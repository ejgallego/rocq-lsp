(************************************************************************)
(* Copyright 2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2019-2024 Inria      -- Dual License LGPL 2.1+ / GPL3+     *)
(* Copyright 2024-2025 Emilio J. Gallego Arias -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                    -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & coq-lsp contributors           *)
(************************************************************************)
(* Flèche => Semantic Token Analysis                                    *)
(************************************************************************)

module Color_info : sig

  type t = { range : Loc.t; color: string }

  val make : Loc.t -> string -> t
  val pp : Format.formatter -> t -> unit

end

include Ser_genarg.S with type a := Color_info.t list
