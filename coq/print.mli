(*************************************************************************)
(* Copyright 2015-2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+ *)
(* Copyright 2019-2024 Inria           -- Dual License LGPL 2.1+ / GPL3+ *)
(* Copyright 2024-2025 Emilio J. Gallego Arias  -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                     -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & coq-lsp contributors            *)
(*************************************************************************)
(* Rocq Language Server Protocol: Rocq Print API                         *)
(*************************************************************************)

val pr_letype_env :
     token:Limits.Token.t
  -> goal_concl_style:bool
  -> Environ.env
  -> Evd.evar_map
  -> EConstr.t
  -> (Pp.t, Loc.t) Protect.E.t

val pr_goals :
  token:Limits.Token.t -> proof:State.Proof.t -> (Pp.t, Loc.t) Protect.E.t

val pr_vernac :
  token:Limits.Token.t -> st:State.t -> Ast.t -> (Pp.t, Loc.t) Protect.E.t
