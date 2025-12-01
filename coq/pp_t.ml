(************************************************************************)
(* Copyright 2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2019-2024 Inria      -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2024-2025 Emilio J. Gallego Arias -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                    -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & coq-lsp contributors           *)
(************************************************************************)
(* Rocq Language Server Protocol: Rocq PP API                           *)
(************************************************************************)

type t = Pp.t
type pp_tag = Pp.pp_tag

type block_type = Pp.block_type =
  | Pp_hbox
  | Pp_vbox of int
  | Pp_hvbox of int
  | Pp_hovbox of int
      (** [Pp_hovbox] produces boxes according to [Format.open_box] not
          [Format.open_hovbox] *)

type doc_view = Pp.doc_view =
  | Ppcmd_empty
  | Ppcmd_string of string
  | Ppcmd_glue of t list
  | Ppcmd_box of block_type * t
  | Ppcmd_tag of pp_tag * t
  (* Are those redundant? *)
  | Ppcmd_print_break of int * int
  | Ppcmd_force_newline
  | Ppcmd_comment of string list

let pp = Pp.pp_with
let pp_with = Pp.pp_with
let mt = Pp.mt
let spc = Pp.spc
let brk = Pp.brk
let str = Pp.str
let int = Pp.int
let ( ++ ) = Pp.( ++ )
let to_string = Pp.string_of_ppcmds
let repr = Pp.repr
let unrepr = Pp.unrepr
