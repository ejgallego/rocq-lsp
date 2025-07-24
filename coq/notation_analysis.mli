(*************************************************************************)
(* Copyright 2015-2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+ *)
(* Copyright 2019-2024 Inria           -- Dual License LGPL 2.1+ / GPL3+ *)
(* Copyright 2024-2025 Emilio J. Gallego Arias  -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                     -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & coq-lsp contributors            *)
(*************************************************************************)
(* Rocq Language Server Protocol: Rocq parsing API                       *)
(*************************************************************************)

module Info : sig
  type t =
    { (* XXX: Careful with Loc.t, is not in LSP/UTF-16 encoding *)
      locations : Loc.t list
    ; path : string
    ; secpath : string
    ; notation : string
    ; scope : string option
    }
end

val notations_in_statement :
     token:Limits.Token.t
  -> intern:Library.Intern.t
  -> st:State.t
  -> Ast.t
  -> (Info.t list, Loc.t) Protect.E.t
