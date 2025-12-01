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

open Ppx_hash_lib.Std.Hash.Builtin
open Ppx_compare_lib.Builtin
open Sexplib.Std

module Loc   = Ser_loc
module Names = Ser_names
module Util  = Ser_util
module Locus = Ser_locus
module Libnames = Ser_libnames
module Constrexpr = Ser_constrexpr
module Genintern = Ser_genintern
module Evaluable = Ser_evaluable

type 'a red_atom =
  [%import: 'a Genredexpr.red_atom]
  [@@deriving sexp,yojson,hash,compare]

type strength =
  [%import: Genredexpr.strength]
  [@@deriving sexp,yojson,hash,compare]

type 'a glob_red_flag =
  [%import: 'a Genredexpr.glob_red_flag]
  [@@deriving sexp,yojson,hash,compare]

type ('a,'b,'c) red_context =
  [%import: ('a,'b,'c) Genredexpr.red_context]
  [@@deriving sexp,yojson,hash,compare]

type ('a,'b,'c,'d,'e,'f) red_expr_gen0 =
  [%import: ('a,'b,'c,'d,'e,'f) Genredexpr.red_expr_gen0]
  [@@deriving sexp,yojson,hash,compare]

type ('a,'b,'c,'d,'e) red_expr_gen =
  [%import: ('a,'b,'c,'d,'e) Genredexpr.red_expr_gen]
  [@@deriving sexp,yojson,hash,compare]

(* Helpers for raw_red_expr *)
type r_trm =
  [%import: Genredexpr.r_trm]
  [@@deriving sexp,yojson,hash,compare]

type r_cst =
  [%import: Genredexpr.r_cst]
  [@@deriving sexp,yojson,hash,compare]

type r_pat =
  [%import: Genredexpr.r_pat]
  [@@deriving sexp,yojson,hash,compare]

type 'a raw_red_expr =
  [%import: 'a Genredexpr.raw_red_expr]
  [@@deriving sexp,yojson,hash,compare]

(* glob_red_expr *)

type 'a and_short_name =
  [%import: 'a Genredexpr.and_short_name]
  [@@deriving sexp,yojson,hash,compare]

type g_trm =
  [%import: Genredexpr.g_trm]
  [@@deriving sexp,yojson,hash,compare]

type g_cst =
  [%import: Genredexpr.g_cst]
  [@@deriving sexp,yojson,hash,compare]

type g_pat =
  [%import: Genredexpr.g_pat]
  [@@deriving sexp,yojson,hash,compare]

type 'a glob_red_expr =
  [%import: 'a Genredexpr.glob_red_expr]
  [@@deriving sexp,yojson,hash,compare]
