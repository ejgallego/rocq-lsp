(* Duplicated with coq_lsp *)
let coq_init ~debug ~record_comments =
  let load_module = Dynlink.loadfile in
  let load_plugin = Coq.Loader.plugin_handler None in
  let vm, warnings = (true, None) in
  Coq.Init.(
    coq_init { debug; record_comments; load_module; load_plugin; vm; warnings })

let replace_test_path exp message =
  let home_re = Str.regexp (exp ^ ".*$") in
  Str.global_replace home_re (exp ^ "[TEST_PATH]") message

let fcc_test = Sys.getenv_opt "FCC_TEST"

let sanitize_paths message =
  match fcc_test with
  | None -> message
  | Some _ ->
    message
    |> replace_test_path "findlib: "
    |> replace_test_path "coqlib is at: "
    |> replace_test_path "coqcorelib is at: "
    |> replace_test_path "findlib config: "
    |> replace_test_path "findlib default location: "

let log_workspace ~io (dir, w) =
  let message, verbose = Coq.Workspace.describe_guess w in
  Fleche.Io.Log.trace "workspace" ~verbose "initialized %s" dir;
  Fleche.Io.Report.msg ~io ~lvl:Info "%s" (sanitize_paths message)

let load_plugin plugin_name = Fl_dynload.load_packages [ plugin_name ]
let plugin_init = List.iter load_plugin

let apply_config ~max_errors =
  Option.iter
    (fun max_errors -> Fleche.Config.v := { !Fleche.Config.v with max_errors })
    max_errors

let go ~int_backend args =
  let { Args.cmdline
      ; roots
      ; display
      ; debug
      ; files
      ; plugins
      ; trace_file
      ; max_errors
      ; coq_diags_level
      ; record_comments
      ; save_vof
      ; load_vof = _
      } =
    args
  in
  (* Initialize event callbacks, in testing don't do perfData *)
  let perfData = Option.is_empty fcc_test in
  let io = Output.init ~display ~perfData ~coq_diags_level in
  (* Initialize Coq *)
  let debug = debug || Fleche.Debug.backtraces || !Fleche.Config.v.debug in
  let root_state = coq_init ~debug ~record_comments in
  let roots = if List.length roots < 1 then [ Sys.getcwd () ] else roots in
  let default = Coq.Workspace.default ~debug ~cmdline in
  let () = Coq.Limits.select_best int_backend in
  let () = Coq.Limits.start () in
  let token = Coq.Limits.Token.create () in
  let make_ws dir = (dir, Coq.Workspace.guess ~token ~cmdline ~debug ~dir ()) in
  let workspaces = List.map make_ws roots in
  List.iter (log_workspace ~io) workspaces;
  let () = apply_config ~max_errors in
  let cc = Cc.{ root_state; workspaces; default; io; token; save_vof } in
  (* Initialize plugins *)
  plugin_init plugins;
  Compile.compile ~cc ~trace_file files

let go ~int_backend args =
  let { Args.cmdline = _
      ; roots = _
      ; display
      ; debug = _
      ; files
      ; plugins
      ; max_errors = _
      ; coq_diags_level
      ; save_vof = _
      ; load_vof
      } =
    args
  in
  if load_vof then
    let open Fleche in

    (* Initialize logging. *)
    let fb_handler = Coq.Init.mk_fb_handler Coq.Protect.fb_queue in
    ignore (Feedback.add_feeder fb_handler);

    plugin_init plugins;

    let perfData = Option.is_empty fcc_test in
    let io = Output.init ~display ~perfData ~coq_diags_level in
    let in_file = List.nth files 0 in
    let in_vof = Filename.(remove_extension in_file) ^ ".vof" in
    let doc = Doc.doc_of_disk ~in_file:in_vof in
    Io.Report.msg ~io ~lvl:Info "vof file loaded";
    Io.Report.msg ~io ~lvl:Info "document has %d nodes" (List.length doc.nodes);
    Io.Report.msg ~io ~lvl:Info "calling plugins";
    (* Little test *)
    let token = Coq.Limits.Token.create () in
    Theory.Register.Completed.fire ~io ~token ~doc;
    let node = (List.rev doc.nodes) |> List.hd in
    let cmds = "About cos_eq_0_2PI_1." in
    (if false then
    begin
      match Doc.run ~token ?loc:None ~st:node.state cmds with
      | Coq.Protect.E.{r = Coq.Protect.R.Completed (Ok _st); feedback} ->
        Io.Log.feedback "run_test" feedback;
        Io.Report.msg ~io ~lvl:Info "Number of feedbacks: %d" (List.length feedback);
        Io.Report.msg ~io ~lvl:Info "About run!"
      | Coq.Protect.E.{r = Completed (Error (User msg)); feedback}
      | Coq.Protect.E.{r = Completed (Error (Anomaly msg)); feedback} ->
        Io.Log.feedback "run test" feedback;
        Io.Report.msg ~io ~lvl:Error "error running about vof file %a" Coq.Pp_t.pp_with msg.msg
      | Coq.Protect.E.{r = Interrupted; feedback} ->
        Io.Log.feedback "run test" feedback;
        Io.Report.msg ~io ~lvl:Error "about vof file interrupted"
    end);
    0
  else
    go ~int_backend args
