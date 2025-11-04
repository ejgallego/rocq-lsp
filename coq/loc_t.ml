(************************************************************************)
(* Copyright 2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2019-2024 Inria      -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2024-2025 Emilio J. Gallego Arias -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                    -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & coq-lsp contributors           *)
(************************************************************************)
(* Rocq Language Server Protocol: Rocq Loc API                          *)
(************************************************************************)

type source = Loc.source =
  (* OCaml won't allow using DirPath.t in InFile *)
  | InFile of
      { dirpath : string option
      ; file : string
      }
  | ToplevelInput

let initial = Loc.initial

type t = Loc.t =
  { fname : source  (** Filename or toplevel input. *)
  ; line_nb : int  (** Start line number. *)
  ; bol_pos : int  (** Position of the beginning of start line. *)
  ; line_nb_last : int  (** End line number. *)
  ; bol_pos_last : int  (** Position of the beginning of end line. *)
  ; bp : int  (** Start position. *)
  ; ep : int  (** End position. *)
  }
