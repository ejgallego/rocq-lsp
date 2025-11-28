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

open Sexplib

type t = PConstraints.t [@@deriving sexp,yojson,hash,compare]

val t_of_sexp : Sexp.t -> t
val sexp_of_t : t -> Sexp.t

module ContextSet : SerType.SJHC with type t = PConstraints.ContextSet.t

type 'a in_poly_context_set = 'a PConstraints.in_poly_context_set
val in_poly_context_set_of_sexp : (Sexp.t -> 'a) -> Sexp.t -> 'a in_poly_context_set
val sexp_of_in_poly_context_set : ('a -> Sexp.t) -> 'a in_poly_context_set -> Sexp.t
