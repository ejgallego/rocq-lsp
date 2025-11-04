(************************************************************************)
(* Flèche => document manager: Language Support                         *)
(* Copyright 2019-2024 Inria      -- Dual License LGPL 2.1 / GPL3+      *)
(* Written by: Emilio J. Gallego Arias                                  *)
(************************************************************************)

module QualId : sig
  type t = string list
end

module FailedRequire : sig
  type t =
    { prefix : QualId.t option
    ; refs : QualId.t list
    }
end

module Data : sig
  type t =
    { sentenceRange : Range.t option [@default None]
    ; failedRequire : FailedRequire.t list option [@default None]
    ; quickFix : Range.t Qf.t list option [@default None]
    }
end

module Severity : sig
  type t = int

  val error : t (* 1 *)
  val warning : t (* 2 *)
  val information : t (* 3 *)
  val hint : t (* 4 *)
end

type 'a t =
  { range : Range.t
  ; severity : Severity.t
  ; message : 'a
  ; data : Data.t option [@default None]
  }

val is_error : 'a t -> bool
