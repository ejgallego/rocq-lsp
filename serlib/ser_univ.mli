(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(************************************************************************)
(* SerAPI: Coq interaction protocol with bidirectional serialization    *)
(************************************************************************)
(* Copyright 2016-2019 MINES ParisTech -- License LGPL 2.1+             *)
(* Copyright 2019-2023 Inria           -- License LGPL 2.1+             *)
(* Written by: Emilio J. Gallego Arias and others                       *)
(************************************************************************)

module Level : sig
  include SerType.SJHC with type t = Univ.Level.t
  module Set : SerType.SJHC with type t = Univ.Level.Set.t
end
module Universe : SerType.SJHC with type t = Univ.Universe.t

module UnivConstraint : sig
  type kind = Univ.UnivConstraint.kind [@@deriving sexp,yojson,hash,compare]

  include SerType.SJHC with type t = Univ.UnivConstraint.t
end

module UnivConstraints : SerType.SJHC with type t = Univ.UnivConstraints.t
