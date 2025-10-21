(************************************************************************)
(* Flèche => document manager: Language Support                         *)
(* Copyright 2019-2024 Inria      -- Dual License LGPL 2.1 / GPL3+      *)
(* Written by: Emilio J. Gallego Arias                                  *)
(************************************************************************)

module QualId = struct
  type t = string list
end

module FailedRequire = struct
  type t =
    { prefix : QualId.t option
    ; refs : QualId.t list
    }
end

module Data = struct
  type t =
    { sentenceRange : Range.t option [@default None]
    ; failedRequire : FailedRequire.t list option [@default None]
    ; quickFix : Range.t Qf.t list option [@default None]
    }
end

module Severity = struct
  type t = int

  let error = 1
  let warning = 2
  let information = 3
  let hint = 4
end

type 'a t =
  { range : Range.t
  ; severity : Severity.t
  ; message : 'a
  ; data : Data.t option [@default None]
  }

let is_error { severity; _ } = severity = 1
