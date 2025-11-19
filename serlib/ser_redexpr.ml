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
module EConstr   = Ser_eConstr
module Pattern   = Ser_pattern
module Genarg    = Ser_genarg
module Genredexpr = Ser_genredexpr

module BO =
struct
  let name = "Redexpr.user_red_expr"
  type 'a t = 'a Redexpr.user_red_expr
end
module B = SerType.Opaque1(BO)

type 'a user_red_expr = 'a B.t
 [@@deriving sexp,yojson,hash,compare]

type raw_red_expr =
  [%import: Redexpr.raw_red_expr]
[@@deriving sexp,yojson,hash,compare]

type glob_red_expr =
  [%import: Redexpr.glob_red_expr]
[@@deriving sexp,yojson,hash,compare]

module A = struct

  type raw =
    [%import: Redexpr.raw_red_expr]
  [@@deriving sexp,yojson,hash,compare]

  type glb =
    [%import: Redexpr.glob_red_expr]
  [@@deriving sexp,yojson,hash,compare]

  type top =
    [%import: Redexpr.red_expr]
  [@@deriving sexp,yojson,hash,compare]
end

let ser_wit_red_expr = let module M = Ser_genarg.GS(A) in M.genser

let register () =
    Ser_genarg.register_genser Redexpr.wit_red_expr ser_wit_red_expr;
    ()

let _ =
  register ()
