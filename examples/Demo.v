Theorem add_0_r : forall n:nat, n + 0 = n.
Proof.
Timeout 1 intros n.
   intros n.  induction n as [| n' IHn'].
  -  (* n = 0 *)    reflexivity.
  -  (* n = S n' *) simpl.  rewrite -> IHn'. reflexivity.  Qed.
