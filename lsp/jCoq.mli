(*************************************************************************)
(* Copyright 2015-2019 MINES ParisTech -- Dual License LGPL 2.1+ / GPL3+ *)
(* Copyright 2019-2024 Inria           -- Dual License LGPL 2.1+ / GPL3+ *)
(* Copyright 2024-2025 Emilio J. Gallego Arias  -- LGPL 2.1+ / GPL3+     *)
(* Copyright 2025      CNRS                     -- LGPL 2.1+ / GPL3+     *)
(* Written by: Emilio J. Gallego Arias & coq-lsp contributors            *)
(*************************************************************************)

(** This module contains the serialization functions for some Rocq's types *)

module Loc_t : sig
  type t = Coq.Loc_t.t [@@deriving yojson]
end

module Pp_t : sig
  type t = Coq.Pp_t.t [@@deriving yojson]
end

module Goals : sig
  type ('a, 'pp) t = ('a, 'pp) Coq.Goals.t [@@deriving yojson]
  type ('a, 'pp) reified = ('a, 'pp) Coq.Goals.reified [@@deriving yojson]
end

module Ast : sig
  type t = Coq.Ast.t [@@deriving yojson]
end

module State : sig
  module Proof : sig
    module Program : sig
      type t = Coq.State.Proof.Program.t [@@deriving yojson]
    end
  end
end

module Notation_analysis : sig
  module Info : sig
    type t = Coq.Notation_analysis.Info.t [@@deriving yojson]
  end
end
