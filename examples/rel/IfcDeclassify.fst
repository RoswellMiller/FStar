module IfcDeclassify

open FStar.DM4F.ST
open Rel

(* Simple example illustrating an IFC property that needs to be stated
   in terms of an instrumented monad. *)

(* We define a variant of the state effect where the state has 3 fields:
   - a secret integer cell
   - a public integer cell
   - a boolean: when this is set the secret integer is declassified
                and allowed to leak to the public cell *)

type state = {secret:int;
              public:int;
              release:bool}

reifiable reflectable new_effect STATE = STATE_h state

effect ST (a:Type) (pre: STATE?.pre) (post: (state -> a -> state -> GTot Type0)) =
  STATE a (fun n0 p -> pre n0 /\
            (forall a n1. pre n0 /\ post n0 a n1 ==> p (a, n1)))

effect St (a:Type) =
  STATE a (fun (_:state) (p:(a * state) -> Type0) -> forall (x:(a * state)). p x)

(* equivalence *)

type low_equiv (s : rel state) = (R?.l s).public == (R?.r s).public

let ni (f:unit -> St unit) = (s:rel state) ->
  Lemma (requires (low_equiv s))
        (ensures (let sl = snd (reify (f ()) (R?.l s)) in
                  let sr = snd (reify (f ()) (R?.r s)) in
                  (sl.release \/ sr.release \/ low_equiv (R sl sr))))

reifiable let p1 () : St unit =
  let s = STATE?.get() in
  STATE?.put s

let ni_p1 : ni p1 = fun s -> () (* nop is noninterferent *)

reifiable let p2 () : St unit =
  let s = STATE?.get() in
  STATE?.put ({s with secret=s.public})

let ni_p2 : ni p2 = fun s -> () (* allowed flow *)

reifiable let p3 () : St unit =
  let s = STATE?.get() in
  STATE?.put ({s with public=s.secret})

(* let ni_p3 : ni p3 = fun s -> () -- this leak fails as it should *)

reifiable let p4 () : St unit=
  let s = STATE?.get() in
  STATE?.put ({s with public=s.secret; release=true})

let ni_p4 : ni p4 = fun s -> () (* this leak is an allowed declassification *)
