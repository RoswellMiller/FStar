(* to be used with Ex12.MAC.fst and Ex12a.ACLs.fst *)

module Ex12a1.Cap (* capabilities *) 

open FStar.ST
open FStar.All
open FStar.Bytes


module ACLs = Ex12a.ACLs
module MAC = Ex12.MAC
module SHA1 = Ex12.SHA1

// In FStar.Bytes: val utf8_encode: s:string  -> Tot bytes

assume UTF8_inj:
  forall s0 s1.{:pattern (utf8_encode s0); (utf8_encode s1)}
     Bytes.equal (utf8_encode s0) (utf8_encode s1) ==> s0==s1

type string30 = (s:string{ String.length s < pow2 30 })

type capRead (msg:bytes) = (forall (f:string30). msg = utf8_encode f ==> ACLs.canRead f)

let k = MAC.keygen capRead

// BEGIN: CapImplementation
val issue: f:string30{ ACLs.canRead f } -> ML MAC.tag
val redeem: f:string30 -> m:MAC.tag -> ML (u:unit{ ACLs.canRead f })

let issue f = 
  assert(ACLs.canRead f);
  let bs = (utf8_encode f) in
  assert(capRead bs);
  assume (Bytes.length bs < pow2 30);
  MAC.mac k bs

let redeem f t =
  let bs = (utf8_encode f) in
  assume (Bytes.length bs < pow2 30);
  if MAC.verify k bs t then
    (MAC.from_key_prop k bs ;
    assert(ACLs.canRead f))
  else
    failwith "bad capability"
// END: CapImplementation
