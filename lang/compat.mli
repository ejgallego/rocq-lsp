module OCaml4_14 : sig
  module Uchar : sig
    type utf_decode

    val utf_decode_is_valid : utf_decode -> bool
    val utf_decode_uchar : utf_decode -> Uchar.t
    val utf_decode_length : utf_decode -> int
    val utf_decode : int -> Uchar.t -> int
    val utf_8_byte_length : Uchar.t -> int
    val utf_16_byte_length : Uchar.t -> int
  end

  module String : sig
    val get_utf_8_uchar : string -> int -> Uchar.utf_decode
  end
end

(* CList from Rocq *)
module List : sig
  type 'a eq = 'a -> 'a -> bool

  (** Introduced in 5.1 *)
  val is_empty : 'a list -> bool

  (** Insert at the (first) position so that if the list is ordered wrt to the
      total order given as argument, the order is preserved *)
  val insert : 'a eq -> 'a -> 'a list -> 'a list

  (** [remove eq a l] Remove all occurrences of [a] in [l] *)
  val remove : 'a eq -> 'a -> 'a list -> 'a list

  (** Count the number of elements satisfying a predicate *)
  val count : ('a -> bool) -> 'a list -> int

  (** [prefix_of eq l1 l2] returns [true] if [l1] is a prefix of [l2], [false]
      otherwise. It uses [eq] to compare elements *)
  val prefix_of : 'a eq -> 'a list eq
end

(* CString from Rocq *)
module String : sig
  module Map : Map.S with type key = String.t
end

module IntSet : Set.S with type elt = int
