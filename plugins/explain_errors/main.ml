(************************************************************************)
(* Copyright 2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2019-2024 Inria      -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2024-2025 Emilio J. Gallego Arias -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                    -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & rocq-lsp contributors          *)
(************************************************************************)
(* Flèche => RL agent: petanque                                         *)
(************************************************************************)

(* Example plugin to print errors with goals *)
(* c.f. https://github.com/coq/coq/issues/19601 *)
open Fleche

let msg_info ~io = Io.(Report.msg ~io ~lvl:Info)

let pp_goals ~token ~st =
  match Coq.State.lemmas ~st with
  | None -> Coq.Pp_t.str "no goals"
  | Some proof -> (
    match Coq.Print.pr_goals ~token ~proof with
    | { Coq.Protect.E.r = Completed (Ok goals); _ } -> goals
    | { Coq.Protect.E.r =
          Completed (Error (User { msg; _ } | Anomaly { msg; _ }))
      ; _
      } -> Coq.Pp_t.(str "error when printing goals: " ++ msg)
    | { Coq.Protect.E.r = Interrupted; _ } ->
      Coq.Pp_t.str "goal printing was interrupted")

module Error_info = struct
  type t =
    { error : Coq.Pp_t.t
    ; command : string
    ; goals : Coq.Pp_t.t
    }

  let print ~io { error; command; goals } =
    msg_info ~io
      "[explain errors plugin]@\n\
       Error:@\n\
      \ @[%a@]@\n\
       @\n\
       when trying to apply@\n\
       @\n\
      \ @[%s@]@\n\
       for goals:@\n\
      \ @[%a@]" Coq.Pp_t.pp_with error command Coq.Pp_t.pp_with goals
end

let extract_errors ~token ~root ~contents (node : Doc.Node.t) =
  let errors = List.filter Lang.Diagnostic.is_error node.diags in
  let st = Stdlib.Option.fold ~some:Doc.Node.state ~none:root node.prev in
  let command = Contents.extract_raw ~contents ~range:node.range in
  let goals = pp_goals ~token ~st in
  List.map
    (fun { Lang.Diagnostic.message; _ } ->
      { Error_info.error = message; command; goals })
    errors

let explain_error ~io ~token ~(doc : Doc.t) =
  let root = doc.root in
  let contents = doc.contents in
  let errors =
    List.(map (extract_errors ~token ~root ~contents) doc.nodes |> concat)
  in
  msg_info ~io "[explain errors plugin] we got %d errors" (List.length errors);
  List.iter (Error_info.print ~io) errors

let main () = Theory.Register.Completed.add explain_error
let () = main ()
