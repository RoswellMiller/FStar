﻿#light "off"
module FStar.Syntax.Embeddings

open FStar.All
open FStar.Syntax.Syntax
open FStar.Range

module Print = FStar.Syntax.Print
module S = FStar.Syntax.Syntax
module C = FStar.Const
module PC = FStar.Parser.Const
module SS = FStar.Syntax.Subst
module BU = FStar.Util
module U = FStar.Syntax.Util
module UF = FStar.Syntax.Unionfind
module Ident = FStar.Ident
module Err = FStar.Errors
module Z = FStar.BigInt
open FStar.Char

type embedding<'a> = {
  em : Range.range -> 'a -> term;
  un : bool -> term -> option<'a>;
  typ : typ
}

let mk_emb em un typ = { em = em ; un = un ; typ = typ }

let embed       e = e.em
let unembed     e = e.un true
let try_unembed e = e.un false
let type_of     e = e.typ

type embedder<'a>   = range -> 'a -> term
type unembedder<'a> = term -> option<'a>

let embed_any =
    let em: embedder<term> = fun r t -> t in
    let un: unembedder<term> = fun _ t -> Some t in
    let typ = S.t_term in
    mk_emb em un typ

let embed_unit =
    let em (rng:range) (u:unit) : term = { U.exp_unit with pos = rng } in
    let un (w:bool) (t0:term) : option<unit> =
        let t = U.unascribe t0 in
        match t.n with
        | S.Tm_constant C.Const_unit -> Some ()
        | _ ->
            if w then
            Err.log_issue t0.pos (Err.Warning_NotEmbedded, BU.format1 "Not an embedded unit: %s" (Print.term_to_string t));
            None
    in
    mk_emb em un S.t_unit

let embed_bool =
    let em (rng:range) (b:bool) : term =
        let t = if b then U.exp_true_bool else U.exp_false_bool in
        { t with pos = rng }
    in
    let un (w:bool) (t0:term) : option<bool> =
        let t = U.unmeta_safe t0 in
        match t.n with
        | Tm_constant(FStar.Const.Const_bool b) -> Some b
        | _ ->
            if w then
            Err.log_issue t0.pos (Err.Warning_NotEmbedded, BU.format1 "Not an embedded bool: %s" (Print.term_to_string t0));
            None
    in
    mk_emb em un S.t_bool

let embed_char =
    let em (rng:range) (c:char) : term =
        let t = U.exp_char c in
        { t with pos = rng }
    in
    let un (w:bool) (t0:term) : option<char> =
        let t = U.unmeta_safe t0 in
        match t.n with
        | Tm_constant(FStar.Const.Const_char c) -> Some c
        | _ ->
            if w then
            Err.log_issue t0.pos (Err.Warning_NotEmbedded, BU.format1 "Not an embedded char: %s" (Print.term_to_string t0));
            None
    in
    mk_emb em un S.t_char

let embed_int =
    let em (rng:range) (i:Z.t) : term =
        let t = U.exp_int (Z.string_of_big_int i) in
        { t with pos = rng }
    in
    let un (w:bool) (t0:term) : option<Z.t> =
        let t = U.unmeta_safe t0 in
        match t.n with
        | Tm_constant(FStar.Const.Const_int (s, _)) ->
            Some (Z.big_int_of_string s)
        | _ ->
            if w then
            Err.log_issue t0.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded int: %s" (Print.term_to_string t0)));
            None
    in
    mk_emb em un S.t_int

let embed_string =
    let em (rng:range) (s:string) : term =
        S.mk (Tm_constant(FStar.Const.Const_string(s, rng)))
             None
             rng
    in
    let un (w:bool) (t0:term) : option<string> =
        let t = U.unmeta_safe t0 in
        match t.n with
        | Tm_constant(FStar.Const.Const_string(s, _)) -> Some s
        | _ ->
            if w then
            Err.log_issue t0.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded string: %s" (Print.term_to_string t0)));
            None
    in
    mk_emb em un S.t_string

let embed_option ea =
    let em (rng:range) (o:option<'a>) : term =
        match o with
        | None ->
          S.mk_Tm_app (S.mk_Tm_uinst (S.tdataconstr PC.none_lid) [U_zero])
                      [S.iarg (type_of ea)]
                      None rng
        | Some a ->
          S.mk_Tm_app (S.mk_Tm_uinst (S.tdataconstr PC.some_lid) [U_zero])
                      [S.iarg (type_of ea); S.as_arg (embed ea rng a)]
                      None rng
    in
    let __un (w:bool) (t0:term) : option<option<'a>> =
        let t = U.unmeta_safe t0 in
        let hd, args = U.head_and_args t in
        match (U.un_uinst hd).n, args with
        | Tm_fvar fv, _ when S.fv_eq_lid fv PC.none_lid -> Some None
        | Tm_fvar fv, [_; (a, _)] when S.fv_eq_lid fv PC.some_lid ->
             BU.bind_opt (unembed ea a) (fun a -> Some (Some a))
        | _ ->
             if w then
             Err.log_issue t0.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded option: %s" (Print.term_to_string t0)));
             None
    in
    mk_emb em un (S.t_option_of (type_of ea))

let embed_tuple2 ea eb =
    let em (rng:range) (x:('a * 'b)) : term =
        S.mk_Tm_app (S.mk_Tm_uinst (S.tdataconstr PC.lid_Mktuple2) [U_zero;U_zero])
                    [S.iarg (type_of ea);
                     S.iarg (type_of eb);
                     S.as_arg (embed ea rng (fst x));
                     S.as_arg (embed eb rng (snd x))]
                    None
                    rng
    in
    let un (w:bool) (t0:term) : option<('a * 'b)> =
        let t = U.unmeta_safe t0 in
        let hd, args = U.head_and_args t in
        match (U.un_uinst hd).n, args with
        | Tm_fvar fv, [_; _; (a, _); (b, _)] when S.fv_eq_lid fv PC.lid_Mktuple2 ->
            BU.bind_opt (unembed ea a) (fun a ->
            BU.bind_opt (unembed eb b) (fun b ->
            Some (a, b)))
        | _ ->
            if w then
            Err.log_issue t0.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded pair: %s" (Print.term_to_string t0)));
            None
    in
    mk_emb em un (S.t_tuple2_of (type_of ea) (type_of eb))

let embed_list ea =
    let em (rng:range) (l:list<'a>) : term =
        let t = S.iarg (type_of ea) in
        let nil =
            S.mk_Tm_app (S.mk_Tm_uinst (S.tdataconstr PC.nil_lid) [U_zero])
                                [t]
                                None
                                rng
        in
        let cons =
            S.mk_Tm_uinst (S.tdataconstr PC.cons_lid) [U_zero]
        in
        FStar.List.fold_right (fun hd tail ->
                S.mk_Tm_app cons
                            [t;
                             S.as_arg (embed ea rng hd);
                             S.as_arg tail]
                            None
                            rng)
             l nil
    in
    let rec un (w:bool) (t0:term) : option<list<'a>> =
        let t = U.unmeta_safe t0 in
        let hd, args = U.head_and_args t in
        match (U.un_uinst hd).n, args with
        | Tm_fvar fv, _
            when S.fv_eq_lid fv PC.nil_lid -> Some []

        | Tm_fvar fv, [_t; (hd, _); (tl, _)]
            when S.fv_eq_lid fv PC.cons_lid ->
            BU.bind_opt (unembed ea hd) (fun hd ->
            BU.bind_opt (__unembed_list w tl) (fun tl ->
            Some (hd :: tl)))
        | _ ->
            if w then
            Err.log_issue t0.pos (Err.Warning_NotEmbedded, BU.format1 "Not an embedded list: %s" (Print.term_to_string t0));
            None
    in
    mk_emb em un (S.t_list_of (type_of ea))

let embed_string_list = embed_list embed_string

let embed_arrow_1 (ua:unembedder<'a>) (eb:embedder<'b>) (f:'a -> 'b) (args:args) : option<term> =
    match args with
    | [(x, _)] ->
      BU.bind_opt (ua x) (fun a ->
      Some (eb FStar.Range.dummyRange (f (BU.must (ua x)))))
    | _ ->
      None

let embed_arrow_2 (ua:unembedder<'a>) (ub:unembedder<'b>) (ed:embedder<'d>)
                  (f:'a -> 'b -> 'd)
                  (args:args) =
    match args with
    | [(x, _); (y, _)] ->
      BU.bind_opt (ua x) (fun a ->
      BU.bind_opt (ub y) (fun b ->
      Some (ed FStar.Range.dummyRange (f a b))))
    | _ ->
      None

let embed_arrow_3 (ua:unembedder<'a>) (ub:unembedder<'b>) (uc:unembedder<'c>) (ed:embedder<'d>)
                  (f:'a -> 'b -> 'c -> 'd)
                  (args:args) =
    match args with
    | [(x, _); (y, _); (z, _)] ->
      BU.bind_opt (ua x) (fun a ->
      BU.bind_opt (ub y) (fun b ->
      BU.bind_opt (uc z) (fun c ->
      Some (ed FStar.Range.dummyRange (f a b c)))))
    | _ ->
      None

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

(* the steps as terms *)
let steps_Simpl      = tdataconstr PC.steps_simpl
let steps_Weak       = tdataconstr PC.steps_weak
let steps_HNF        = tdataconstr PC.steps_hnf
let steps_Primops    = tdataconstr PC.steps_primops
let steps_Delta      = tdataconstr PC.steps_delta
let steps_Zeta       = tdataconstr PC.steps_zeta
let steps_Iota       = tdataconstr PC.steps_iota
let steps_UnfoldOnly = tdataconstr PC.steps_unfoldonly
let steps_UnfoldAttr = tdataconstr PC.steps_unfoldattr

let embed_norm_step =
    let em (rng:range) (n:norm_step) : term =
        match n with
        | Simpl ->
            steps_Simpl
        | Weak ->
            steps_Weak
        | HNF ->
            steps_HNF
        | Primops ->
            steps_Primops
        | Delta ->
            steps_Delta
        | Zeta ->
            steps_Zeta
        | Iota ->
            steps_Iota
        | UnfoldOnly l ->
            S.mk_Tm_app steps_UnfoldOnly [S.as_arg (embed_list embed_string S.t_string rng l)]
                        None rng
        | UnfoldAttr a ->
            S.mk_Tm_app steps_UnfoldAttr [S.as_arg a] None rng
    in
    let un (w:bool) (t0:term) : option<norm_step> =
        let t = U.unmeta_safe t0 in
        let hd, args = U.head_and_args t in
        match (U.un_uinst hd).n, args with
        | Tm_fvar fv, [] when S.fv_eq_lid fv PC.steps_simpl ->
            Some Simpl
        | Tm_fvar fv, [] when S.fv_eq_lid fv PC.steps_weak ->
            Some Weak
        | Tm_fvar fv, [] when S.fv_eq_lid fv PC.steps_hnf ->
            Some HNF
        | Tm_fvar fv, [] when S.fv_eq_lid fv PC.steps_primops ->
            Some Primops
        | Tm_fvar fv, [] when S.fv_eq_lid fv PC.steps_delta ->
            Some Delta
        | Tm_fvar fv, [] when S.fv_eq_lid fv PC.steps_zeta ->
            Some Zeta
        | Tm_fvar fv, [] when S.fv_eq_lid fv PC.steps_iota ->
            Some Iota
        | Tm_fvar fv, [(l, _)] when S.fv_eq_lid fv PC.steps_unfoldonly ->
            BU.bind_opt (unembed_list unembed_string l) (fun ss ->
            Some <| UnfoldOnly ss)
        | Tm_fvar fv, [_;(a, _)] when S.fv_eq_lid fv PC.steps_unfoldattr ->
            Some (UnfoldAttr a)
        | _ ->
            if w then
            Err.log_issue t0.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded norm_step: %s" (Print.term_to_string t0)));
            None
    in
    mk_emb em un S.t_norm_step


let embed_range =
    let em (rng:range) (r:range) : term =
        S.mk (Tm_constant (C.Const_range r)) None rng
    in
    let un (w:bool) (t0:term) : option<range> =
        let t = U.unmeta_safe t0 in
        match t.n with
        | Tm_constant (C.Const_range r) -> Some r
        | _ ->
            if w then
            Err.log_issue t0.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded range: %s" (Print.term_to_string t0)));
            None
    in
    mk_emb em un S.t_range
