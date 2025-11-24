Require Import ssreflect.

Lemma dummy : forall  (P:nat->Prop) (n:nat),
  (P n -> P (n+1)) /\ (P (n+1) -> P(n+2)) -> (P n) -> P(n+2).
Proof.
intros.
assert (P (n+1));
last by (destruct H as [Ha Hb]; apply Hb).
destruct H as [Ha Hb]; apply Ha; assumption.
Qed.

Lemma foo : forall n:nat, True.
Proof.
move => n.
(have: (n=n) by rewrite /=); move => Hn //.
Qed.