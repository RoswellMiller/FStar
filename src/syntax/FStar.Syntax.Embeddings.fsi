#light "off"
module FStar.Syntax.Embeddings

open FStar.All
open FStar.Syntax.Syntax
open FStar.Char

module Range = FStar.Range
module Z = FStar.BigInt

(* TODO: Find a better home for there? *)
type norm_step =
    | Simpl
    | Weak
    | HNF
    | Primops
    | Delta
    | Zeta
    | Iota
    | UnfoldOnly of list<string>
    | UnfoldAttr of attribute

val steps_Simpl      : term
val steps_Weak       : term
val steps_HNF        : term
val steps_Primops    : term
val steps_Delta      : term
val steps_Zeta       : term
val steps_Iota       : term
val steps_UnfoldOnly : term

(*
 * Unmbedding functions return an option because they might fail
 * to interpret the given term as valid data. The `try_` version will
 * simply return None in that case, but the unsafe one will also raise a
 * warning, and should be used only where we really expect to always be
 * able to unembed.
 *)

type embedding<'a>

// embed: turning a value into a term (compiler internals -> userland)
// unembed: interpreting a term as a value, which might fail (userland -> compiler internals)
val embed       : embedding<'a> -> Range.range -> 'a -> term
val unembed     : embedding<'a> -> 'a -> option<term>
val try_unembed : embedding<'a> -> 'a -> option<term>

val embed_any         : embedding<term>
val embed_unit        : embedding<unit>
val embed_bool        : embedding<bool>
val embed_char        : embedding<char>
val embed_int         : embedding<Z.t>
val embed_string      : embedding<string>
val embed_norm_step   : embedding<norm_step>
val embed_range       : embedding<Range.range>

val embed_option      : embedding<'a> -> embedding<option<'a>>
val embed_list        : embedding<'a> -> embedding<list<'a>>
val embed_tuple2      : embedding<'a> -> embedding<'b> -> embedding<('a * 'b)>
val embed_string_list : embedding<list<string>>

val embed_arrow_1     : unembedder<'a> -> embedder<'b> ->
                        ('a -> 'b) -> args -> option<term>

val embed_arrow_2     : unembedder<'a> -> unembedder<'b> -> embedder<'c> ->
                        ('a -> 'b -> 'c) -> args -> option<term>

val embed_arrow_3     : unembedder<'a> -> unembedder<'b> -> unembedder<'c> -> embedder<'d> ->
                        ('a -> 'b -> 'c -> 'd) -> args -> option<term>
