General tests for rocq-checkdecls

Simple test with one file, succeed

  $ echo Coq.Init.Nat.add > clist
  $ echo Coq.Init.Peano.plus_n_O >> clist
  $ rocq-checkdecls clist

Simple test with one file, fail

  $ echo Coq.Init.Peano.not_a_constant >> clist
  $ echo Coq.Init.Nat.not_a_theorem >> clist
  $ rocq-checkdecls clist
  Coq.Init.Peano.not_a_constant is missing.
  Coq.Init.Nat.not_a_theorem is missing.
  [1]
