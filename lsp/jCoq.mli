(*************************************************************************)
(* Copyright 2015-2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+ *)
(* Copyright 2019-2024 Inria           -- Dual License LGPL 2.1+ / GPL3+ *)
(* Copyright 2024-2025 Emilio J. Gallego Arias  -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                     -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & coq-lsp contributors            *)
(*************************************************************************)

(** This module contains the serialization functions for some Rocq's types *)

module Pp_t : sig
  type t = Pure.Pp_t.t [@@deriving yojson]
end

module Goals : sig
  type ('a, 'pp) t = ('a, 'pp) Pure.Goals.t [@@deriving yojson]
  type ('a, 'pp) reified = ('a, 'pp) Pure.Goals.reified [@@deriving yojson]
end

module Ast : sig
  type t = Pure.Ast.t [@@deriving yojson]
end

module State : sig
  module Proof : sig
    module Program : sig
      type t = Pure.State.Proof.Program.t [@@deriving yojson]
    end
  end
end
