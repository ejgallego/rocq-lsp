(************************************************************************)
(* Copyright 2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2019-2024 Inria      -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2024-2025 Emilio J. Gallego Arias -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                    -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & coq-lsp contributors           *)
(************************************************************************)
(* Flèche => command-line compiler                                      *)
(************************************************************************)

open Fleche

let is_in_dir ~dir ~file = CString.is_prefix dir file

let workspace_of_uri ~io ~uri ~workspaces ~default =
  let file = Lang.LUri.File.to_string_file uri in
  match List.find_opt (fun (dir, _) -> is_in_dir ~dir ~file) workspaces with
  | None ->
    Io.Report.msg ~io ~lvl:Error "file not in workspace: %s" file;
    default
  | Some (_, Error err) ->
    Io.Report.msg ~io ~lvl:Error "invalid workspace for: %s %s" file err;
    default
  | Some (_, Ok workspace) -> workspace

(** Move to a plugin *)
let save_diags_file ~(doc : Fleche.Doc.t) =
  let file = Lang.LUri.File.to_string_file doc.uri in
  let file = Filename.remove_extension file ^ ".diags" in
  let diags = Fleche.Doc.diags doc in
  Coq.Compat.format_to_file ~file ~f:Output.pp_diags diags

(** Return: exit status for file:

    - 1: fatal error in checking (usually due to [max_errors=n]
    - 2: checking stopped
    - 102: file not scheduled
    - 222: Incorrect URI *)
let status_of_doc (doc : Doc.t) =
  match doc.completed with
  | Yes _ -> 0
  | Stopped _ | WorkspaceUpdated _ -> 2
  | Failed _ -> 1

let guess_languageId file =
  match Filename.extension file with
  | ".mv" -> "markdown"
  | ".v" -> "rocq"
  | ".v.tex" -> "latex"
  | _ -> "rocq"

let do_save_vof ~io ~token ~doc =
  match Doc.save_vof ~token ~doc with
  | Coq.Protect.E.{ r = Coq.Protect.R.Completed (Ok ()); feedback } ->
    Io.Log.feedback "vof safe" feedback;
    Io.Report.msg ~io ~lvl:Info "vof file saved"
  | Coq.Protect.E.{ r = Completed (Error (User msg)); feedback }
  | Coq.Protect.E.{ r = Completed (Error (Anomaly msg)); feedback } ->
    Io.Log.feedback "vof safe" feedback;
    Io.Report.msg ~io ~lvl:Error "error saving vof file %a" Coq.Pp_t.pp_with
      msg.msg
  | Coq.Protect.E.{ r = Interrupted; feedback } ->
    Io.Log.feedback "vof safe" feedback;
    Io.Report.msg ~io ~lvl:Error "saving vof file interrupted"

let compile_file ~cc file : int =
  let { Cc.io; root_state; workspaces; default; token; save_vof } = cc in
  Io.Report.msg ~io ~lvl:Info "compiling file %s" file;
  match Lang.LUri.(File.of_uri (of_string file)) with
  | Error _ -> 222
  | Ok uri -> (
    let languageId = guess_languageId file in
    let workspace = workspace_of_uri ~io ~workspaces ~uri ~default in
    let files = Coq.Files.make () in
    let env = Doc.Env.make ~init:root_state ~workspace ~files in
    let raw = Coq.Compat.Ocaml_414.In_channel.(with_open_bin file input_all) in
    let () = Theory.open_ ~io ~token ~env ~uri ~languageId ~raw ~version:1 in
    match Theory.Check.maybe_check ~io ~token with
    | None -> 102
    | Some (_, doc) ->
      save_diags_file ~doc;
      (* Vo file saving is now done by a plugin *)
      Theory.close ~uri;
      if save_vof then do_save_vof ~io ~token ~doc;
      status_of_doc doc)

let compile_file ~cc file : int =
  let args () = [ ("file", `String file) ] in
  NewProfile.profile "compile" ~args (fun () -> compile_file ~cc file) ()

let oprofile = ref None

let init_profile trace_file =
  match trace_file with
  | None -> ()
  | Some file ->
    let oc = Stdlib.open_out file in
    let fmt = Format.formatter_of_out_channel oc in
    oprofile := Some (oc, fmt);
    NewProfile.init { output = fmt }

let finish_profile () =
  match !oprofile with
  | None -> ()
  | Some (oc, fmt) ->
    NewProfile.finish ();
    Format.pp_print_flush fmt ();
    Stdlib.close_out oc

let compile ~cc ~trace_file files =
  init_profile trace_file;
  let finally = finish_profile in
  let compile () =
    List.fold_left
      (fun status file -> if status = 0 then compile_file ~cc file else status)
      0 files
  in
  Fun.protect ~finally compile
