(** Anthony Bordg, February-March 2017 *)

Require Import UniMath.Algebra.Rigs_and_Rings.
Require Import UniMath.Algebra.Monoids_and_Groups.
Require Import UniMath.Foundations.Sets.
Require Import UniMath.Foundations.PartA.
Require Import UniMath.Foundations.Preamble.
Require Import UniMath.Algebra.Domains_and_Fields.
Require Import UniMath.Foundations.PartD.


Local Open Scope addmonoid_scope.

(** * The ring of endomorphisms of an abelian group *)

(** Two binary operations on the set of endomorphisms of an abelian group *)

Definition monoidfun_to_isbinopfun {G : abgr} (f : monoidfun G G) : isbinopfun f := pr1 (pr2 f).

Definition rngofendabgr_op1 {G: abgr} : binop (monoidfun G G).
Proof.
  intros f g.
  apply (@monoidfunconstr _ _ (λ x : G, f x + g x)).
  apply tpair.
  - intros x x'.
    rewrite (monoidfun_to_isbinopfun f).
    rewrite (monoidfun_to_isbinopfun g).
    apply (abmonoidrer G).
  - rewrite (monoidfununel f).
    rewrite (monoidfununel g).
    rewrite (lunax G).
    reflexivity.
Defined.

Definition rngofendabgr_op2 {G : abgr} : binop (monoidfun G G).
Proof.
  intros f g.
  apply (monoidfuncomp f g).
Defined.

Notation "f + g" := (rngofendabgr_op1 f g) : abgr_scope.

(** the composition below uses the diagrammatic order following the general convention used in UniMath *)

Notation "f ∘ g" := (rngofendabgr_op2 f g) : abgr_scope.

(** The underlying set of the ring of endomorphisms of an abelian group *)

Definition setofendabgr (G : abgr) : hSet :=
   hSetpair (monoidfun G G) (isasetmonoidfun G G).

(** A few access functions *)

Definition pr1setofendabgr {G : abgr} (f : setofendabgr G) : G -> G := pr1 f.

Definition pr2setofendabgr {G : abgr} (f : setofendabgr G) : ismonoidfun (pr1 f) := pr2 f.

Definition setofendabgr_to_isbinopfun {G : abgr} (f : setofendabgr G) : isbinopfun (pr1setofendabgr f) := pr1 (pr2 f).

Definition setofendabgr_to_unel {G : abgr} (f : setofendabgr G) : pr1setofendabgr f 0 = 0 := pr2 (pr2setofendabgr f).

(** We endow setofendabgr with the two binary operations defined above *)

Definition setwith2binopofendabgr (G : abgr) : setwith2binop :=
   setwith2binoppair (setofendabgr G) (dirprodpair (rngofendabgr_op1) (rngofendabgr_op2)).

(** rngofendabgr_op1 G and rngofendabgr_op2 G are ring operations *)

(** rngofendabgr_op1 is a monoid operation *)

Local Open Scope abgr_scope.

Definition isassoc_rngofendabgr_op1 {G : abgr} : isassoc (@rngofendabgr_op1 G).
Proof.
   intros f g h.
   use total2_paths_f.
   - apply funextfun.
     intro.
     apply (pr2 G).
   - apply isapropismonoidfun.
Defined.

Definition setofendabgr_un0 {G: abgr} : monoidfun G G.
Proof.
   apply (@monoidfunconstr _ _ (λ x : G, 0)).
   apply dirprodpair.
     - intros x x'.
       rewrite (lunax G).
       reflexivity.
     - reflexivity.
Defined.

Definition islunit_setofendabgr_un0 {G : abgr} : islunit (@rngofendabgr_op1 G) setofendabgr_un0.
Proof.
   intro f.
   use total2_paths_f.
   - apply funextfun. intro x.
     apply (lunax G (pr1setofendabgr f x)).
   - apply isapropismonoidfun.
Defined.

Definition isrunit_setofendabgr_un0 {G : abgr} : isrunit (@rngofendabgr_op1 G) setofendabgr_un0.
Proof.
   intros f.
   use total2_paths_f.
   - apply funextfun. intro x.
     apply (runax G (pr1setofendabgr f x)).
   - apply isapropismonoidfun.
Defined.

Definition isunit_setofendabgr_un0 {G : abgr} : isunit (@rngofendabgr_op1 G) setofendabgr_un0 :=
  isunitpair islunit_setofendabgr_un0 isrunit_setofendabgr_un0.

Definition isunital_rngofendabgr_op1 {G : abgr} : isunital (@rngofendabgr_op1 G) :=
  isunitalpair setofendabgr_un0 isunit_setofendabgr_un0.

Definition ismonoidop_rngofendabgr_op1 {G : abgr} : ismonoidop (@rngofendabgr_op1 G) :=
   mk_ismonoidop isassoc_rngofendabgr_op1 isunital_rngofendabgr_op1.

Local Close Scope abgr_scope.

(** rngofendabgr_op1 is a group operation *)

Definition setofendabgr_inv {G : abgr} : monoidfun G G -> monoidfun G G.
Proof.
   intro f.
   apply (@monoidfunconstr G G (λ x : G, grinv G (pr1setofendabgr f x))).
   apply dirprodpair.
   - intros x x'.
     rewrite (setofendabgr_to_isbinopfun f).
     rewrite (grinvop G).
     apply (commax G).
   - rewrite (setofendabgr_to_unel f).
     apply (grinvunel G).
Defined.

Local Open Scope abgr_scope.

Definition islinv_setofendabgr_inv {G : abgr} : islinv (@rngofendabgr_op1 G) setofendabgr_un0 setofendabgr_inv.
Proof.
   intro f.
   use total2_paths_f.
   - apply funextfun. intro x.
     apply (grlinvax G).
   - apply isapropismonoidfun.
Defined.

Definition isrinv_setofendabgr_inv {G : abgr} : isrinv (@rngofendabgr_op1 G) setofendabgr_un0 setofendabgr_inv.
Proof.
   intro f.
   use total2_paths_f.
   - apply funextfun. intro x.
     apply (grrinvax G).
   - apply isapropismonoidfun.
Defined.

Definition isinv_setofendabgr_inv {G : abgr} : isinv (@rngofendabgr_op1 G) (unel_is (@ismonoidop_rngofendabgr_op1 G)) setofendabgr_inv :=
  mk_isinv islinv_setofendabgr_inv isrinv_setofendabgr_inv.

Definition invstruct_setofendabgr_inv {G : abgr} : invstruct (@rngofendabgr_op1 G) ismonoidop_rngofendabgr_op1 :=
   mk_invstruct (@setofendabgr_inv G) (@isinv_setofendabgr_inv G).

Definition isgrop_rngofendabgr_op1 {G : abgr} : isgrop (@rngofendabgr_op1 G) :=
   isgroppair ismonoidop_rngofendabgr_op1 invstruct_setofendabgr_inv.

Definition iscomm_rngofendabgr_op1 {G : abgr} : iscomm (@rngofendabgr_op1 G).
Proof.
   intros f g.
   use total2_paths_f.
   - apply funextfun. intro x.
     apply (commax G).
   - apply (isapropismonoidfun).
Defined.

Definition isabgrop_rngofendabgr_op1 {G : abgr} : isabgrop (@rngofendabgr_op1 G) :=
  mk_isabgrop isgrop_rngofendabgr_op1 iscomm_rngofendabgr_op1.

(** rngofendabgr_op2 is a monoid operation *)

Definition isassoc_rngofendabgr_op2 {G : abgr} : isassoc (@rngofendabgr_op2 G).
Proof.
  intros f g h.
  use total2_paths_f.
  - apply funcomp_assoc.
  - apply isapropismonoidfun.
Defined.

Definition setofendabgr_un1 {G: abgr} : monoidfun G G.
Proof.
   apply (@monoidfunconstr _ _ (idfun G)).
   apply dirprodpair.
   - intros x x'. reflexivity.
   - reflexivity.
Defined.

Definition islunit_setofendabgr_un1 {G : abgr} : islunit (@rngofendabgr_op2 G) setofendabgr_un1.
Proof.
   intro f.
   use total2_paths_f.
   - apply funextfun. intro x. reflexivity.
   - apply isapropismonoidfun.
Defined.

Definition isrunit_setofendabgr_un1 {G : abgr} : isrunit (@rngofendabgr_op2 G) setofendabgr_un1.
Proof.
   intros f.
   use total2_paths_f.
   - apply funextfun. intro x. reflexivity.
   - apply isapropismonoidfun.
Defined.

Definition isunit_setofendabgr_un1 {G : abgr} : isunit (@rngofendabgr_op2 G) setofendabgr_un1 :=
  isunitpair islunit_setofendabgr_un1 isrunit_setofendabgr_un1.

Definition isunital_rngofendabgr_op2 {G : abgr} : isunital (@rngofendabgr_op2 G) :=
  isunitalpair setofendabgr_un1 isunit_setofendabgr_un1.

Definition ismonoidop_rngofendabgr_op2 {G : abgr} : ismonoidop (@rngofendabgr_op2 G) :=
   mk_ismonoidop isassoc_rngofendabgr_op2 isunital_rngofendabgr_op2.

(** rngofendabgr_op2 is distributive over rngofendabgr_op1 *)

Definition isldistr_setofendabgr_op {G : abgr} : isldistr (@rngofendabgr_op1 G) (@rngofendabgr_op2 G).
Proof.
   intros f g h.
   use total2_paths_f.
   - apply funextfun. intro x. reflexivity.
   - apply isapropismonoidfun.
Defined.

Definition isrdistr_setofendabgr_op {G : abgr} : isrdistr (@rngofendabgr_op1 G) (@rngofendabgr_op2 G).
Proof.
   intros f g h.
   use total2_paths_f.
   - apply funextfun. intro x.
     apply (setofendabgr_to_isbinopfun h).
   - apply isapropismonoidfun.
Defined.

Definition isdistr_setofendabgr_op {G : abgr} : isdistr (@rngofendabgr_op1 G) (@rngofendabgr_op2 G) :=
   dirprodpair isldistr_setofendabgr_op isrdistr_setofendabgr_op.

Definition isrngops_setofendabgr_op {G : abgr} : isrngops (@rngofendabgr_op1 G) (@rngofendabgr_op2 G) :=
   mk_isrngops isabgrop_rngofendabgr_op1 ismonoidop_rngofendabgr_op2 isdistr_setofendabgr_op.

(** The set of endomorphisms of an abelian group is a ring *)

Definition rngofendabgr (G : abgr) : rng :=
   @rngpair (setwith2binopofendabgr G) (@isrngops_setofendabgr_op G).


(** ** The definition of the small type of (left) R-modules over a ring R *)

Definition module_struct (R : rng) (G : abgr) : UU := rngfun R (rngofendabgr G).

Definition module (R : rng) : UU := ∑ G, module_struct R G.

Definition pr1module {R : rng} (M : module R) : abgr := pr1 M.

Coercion pr1module : module >-> abgr.

Definition pr2module {R : rng} (M : module R) : module_struct R (pr1module M) := pr2 M.

Identity Coercion id_module_struct : module_struct >-> rngfun.

(** The multiplication defined from a module *)

Definition module_mult {R : rng} {M : module R} : R -> M -> M := λ r : R, λ x : M, (pr1setofendabgr (pr2module M r) x).

Notation "r * x" := (module_mult r x) : module_scope.

Delimit Scope module_scope with module.

Local Open Scope rig_scope.

Definition rigfun_to_unel_rigaddmonoid {X Y : rig} (f : rigfun X Y) : f 0 = 0 := pr2 (pr1 (pr2 f)).

Local Close Scope rig_scope.

Local Open Scope module.

Definition module_mult_0_to_0 {R : rng} {M : @module R} (x : M) : rngunel1 * x = @unel M.
Proof.
   unfold module_mult. cbn.
   assert (pr2module M rngunel1 = @rngunel1 (rngofendabgr M)).
   - exact (rigfun_to_unel_rigaddmonoid (pr2module M)).
   - rewrite X.
     reflexivity.
Defined.


(** (left) R-module homomorphism *)

Definition islinear {R : rng} {M N : module R} (f : M -> N) :=
  ∏ r : R, ∏ x : M, f (r * x) = r * (f x).

Definition ismodulefun {R : rng} {M N : module R} (f : M -> N) : UU :=
   (isbinopfun f) × (islinear f).

Lemma isapropismodulefun {R : rng} {M N : module R} (f : M -> N) : isaprop (@ismodulefun R M N f).
Proof.
   refine (@isofhleveldirprod 1 (isbinopfun f) (islinear f) _ _).
   exact (isapropisbinopfun f).
   apply (impred 1 _). intro r.
   apply (impred 1 _). intro x.
   apply (setproperty N).
Defined.


Definition modulefun {R : rng} (M N : module R) := total2 (λ f : M -> N, @ismodulefun R M N f).

Definition modulefunpair {R : rng} {M N : module R} (f : M -> N) (is : @ismodulefun R M N f) :=
   tpair _ f is.

Definition pr1modulefun {R : rng} {M N : module R} (f : @modulefun R M N) : M -> N := pr1 f.

Coercion pr1modulefun : modulefun >-> Funclass.

Definition modulefun_to_islinear {R : rng} {M N : module R} (f : modulefun M N): islinear f := pr2 (pr2 f).

Definition modulefun_unel {R : rng} {M N : module R} (f : @modulefun R M N) : f (@unel M) = @unel N.
Proof.
   rewrite <- (module_mult_0_to_0 (@unel M)).
   rewrite ((modulefun_to_islinear f) rngunel1 (@unel M)).
   rewrite (module_mult_0_to_0 _).
   reflexivity.
Defined.

Definition modulefun_to_isbinopfun {R : rng} {M N : module R} (f : modulefun M N) : isbinopfun f := pr1 (pr2 f).
