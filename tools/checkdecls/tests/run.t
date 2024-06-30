General tests for rocq-checkdecls

Error when not input:

  $ rocq-checkdecls
  rocq-checkdecls: required argument FILES is missing
  Usage: rocq-checkdecls [OPTION]… FILES…
  Try 'rocq-checkdecls --help' for more information.
  [124]

Error when file doesn't exists:

  $ rocq-checkdecls where_i_am.txt
  rocq-checkdecls: FILES… arguments: no 'where_i_am.txt' file
  Usage: rocq-checkdecls [OPTION]… FILES…
  Try 'rocq-checkdecls --help' for more information.
  [124]

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
