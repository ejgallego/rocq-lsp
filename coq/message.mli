(** Messages from Coq *)

(** Coq provides payload to our layer via two different mechanisms:
    - feedback messages
    - error exceptions

    In both cases, the payload is the same, and it comes via different ways due
    to historical reasons. We abstract the payload as to better handle the
    common paths. *)
module Payload : sig
  type 'l t =
    { range : 'l option
    ; quickFix : 'l Lang.Qf.t list option
    ; msg : Pp_t.t
    }

  val make : ?range:'l -> ?quickFix:'l Lang.Qf.t list -> Pp_t.t -> 'l t
  val map : f:('l -> 'm) -> 'l t -> 'm t
end

type 'l t = Lang.Diagnostic.Severity.t * 'l Payload.t

val map : f:('l -> 'm) -> 'l t -> 'm t
