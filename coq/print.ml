(*************************************************************************)
(* Copyright 2015-2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+ *)
(* Copyright 2019-2024 Inria           -- Dual License LGPL 2.1+ / GPL3+ *)
(* Copyright 2024-2025 Emilio J. Gallego Arias  -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                     -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & coq-lsp contributors            *)
(*************************************************************************)
(* Rocq Language Server Protocol: Rocq Print API                         *)
(*************************************************************************)

let pr_letype_env ~goal_concl_style env sigma x =
  Printer.pr_letype_env ~goal_concl_style env sigma x

let pr_letype_env ~token ~goal_concl_style env sigma x =
  let f = pr_letype_env ~goal_concl_style env sigma in
  Protect.eval ~token ~f x
