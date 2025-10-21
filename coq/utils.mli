(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *   INRIA, CNRS and contributors - Copyright 1999-2018       *)
(* <O___,, *       (see CREDITS file for the list of authors)           *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(************************************************************************)
(* Coq Language Server Protocol                                         *)
(* Copyright 2022-2023 Inria      -- Dual License LGPL 2.1 / GPL3+      *)
(* Written by: Emilio J. Gallego Arias                                  *)
(************************************************************************)

(** Specific to Coq *)
val to_range : lines:string array -> Loc.t -> Lang.Range.t

val to_orange : lines:string array -> Loc.t option -> Lang.Range.t option

(** Separation of parsing and execution made this API hard to use for us *)
val with_control :
     fn:(unit -> unit)
  -> control:Vernacexpr.control_flag list
  -> st:State.t
  -> unit

module IntSet : Set.S with type elt = Int.t
module StringMap : Map.S with type key = String.t
