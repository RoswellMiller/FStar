#light "off"
module FStar.Reflection.Embeddings

open FStar.All
open FStar.Reflection.Data
open FStar.Syntax.Syntax
open FStar.Syntax.Embeddings
open FStar.Order
open FStar.Errors

module S = FStar.Syntax.Syntax // TODO: remove, it's open

module SS = FStar.Syntax.Subst
module BU = FStar.Util
module Range = FStar.Range
module U = FStar.Syntax.Util
module Print = FStar.Syntax.Print
module Env = FStar.TypeChecker.Env
module Err = FStar.Errors
module Z = FStar.BigInt
open FStar.Reflection.Basic //needed for inspect_fv, but that feels wrong

open FStar.Dyn

(*
 * Most of this file is tedious and repetitive.
 * We should really allow for some metaprogramming in F*. Oh wait....
 *)

(* -------------------------------------------------------------------------------------- *)
(* ------------------------------------- EMBEDDINGS ------------------------------------- *)
(* -------------------------------------------------------------------------------------- *)

let embed_bv (rng:Range.range) (bv:bv) : term =
    U.mk_lazy bv fstar_refl_binder Lazy_bv (Some rng)

let embed_binder (rng:Range.range) (b:binder) : term =
    U.mk_lazy b fstar_refl_binder Lazy_binder (Some rng)

let embed_term_aq (aq:antiquotations) (rng:Range.range) (t:term) : term =
    let qi = { qkind = Quote_static; antiquotes = aq } in
    S.mk (Tm_quoted (t, qi)) None rng

let embed_term rng t = embed_term_aq [] rng t

let embed_aqualv (rng:Range.range) (q : aqualv) : term =
    let r =
    match q with
    | Data.Q_Explicit -> ref_Q_Explicit.t
    | Data.Q_Implicit -> ref_Q_Implicit.t
    in { r with pos = rng }

let embed_binders rng l = embed_list embed_binder fstar_refl_binder rng l

let embed_fv (rng:Range.range) (fv:fv) : term =
    U.mk_lazy fv fstar_refl_fv Lazy_fvar (Some rng)

let embed_comp (rng:Range.range) (c:comp) : term =
    U.mk_lazy c fstar_refl_comp Lazy_comp (Some rng)

let embed_env (rng:Range.range) (e:Env.env) : term =
    U.mk_lazy e fstar_refl_env Lazy_env (Some rng)

let embed_const (rng:Range.range) (c:vconst) : term =
    let r =
    match c with
    | C_Unit    -> ref_C_Unit.t
    | C_True    -> ref_C_True.t
    | C_False   -> ref_C_False.t

    | C_Int i ->
        S.mk_Tm_app ref_C_Int.t [S.as_arg (U.exp_int (Z.string_of_big_int i))]
                    None Range.dummyRange
    | C_String s ->
        S.mk_Tm_app ref_C_String.t [S.as_arg (embed_string rng s)]
                    None Range.dummyRange
    in { r with pos = rng }

let rec embed_pattern (rng:Range.range) (p : pattern) : term =
    match p with
    | Pat_Constant c ->
        S.mk_Tm_app ref_Pat_Constant.t [S.as_arg (embed_const rng c)] None rng
    | Pat_Cons (fv, ps) ->
        S.mk_Tm_app ref_Pat_Cons.t [S.as_arg (embed_fv rng fv); S.as_arg (embed_list embed_pattern fstar_refl_pattern rng ps)] None rng
    | Pat_Var bv ->
        S.mk_Tm_app ref_Pat_Var.t [S.as_arg (embed_bv rng bv)] None rng
    | Pat_Wild bv ->
        S.mk_Tm_app ref_Pat_Wild.t [S.as_arg (embed_bv rng bv)] None rng
    | Pat_Dot_Term (bv, t) ->
        S.mk_Tm_app ref_Pat_Dot_Term.t [S.as_arg (embed_bv rng bv);
                                        S.as_arg (embed_term rng t)]
                    None rng


let embed_branch_aq aqs rng br = embed_tuple2 embed_pattern fstar_refl_pattern (embed_term_aq aqs) S.t_term rng br
let embed_argv_aq   aqs rng aq = embed_tuple2 (embed_term_aq aqs) S.t_term embed_aqualv fstar_refl_aqualv rng aq

let embed_branch rng br = embed_branch_aq [] rng br
let embed_argv   rng aq = embed_argv_aq [] rng aq

let embed_term_view_aq (aq:antiquotations) (rng:Range.range) (t:term_view) : term =
    match t with
    | Tv_FVar fv ->
        S.mk_Tm_app ref_Tv_FVar.t [S.as_arg (embed_fv rng fv)]
                    None rng

    | Tv_BVar fv ->
        S.mk_Tm_app ref_Tv_BVar.t [S.as_arg (embed_bv rng fv)]
                    None rng

    | Tv_Var bv ->
        S.mk_Tm_app ref_Tv_Var.t [S.as_arg (embed_bv rng bv)]
                    None rng

    | Tv_App (hd, a) ->
        S.mk_Tm_app ref_Tv_App.t [S.as_arg (embed_term_aq aq rng hd); S.as_arg (embed_argv_aq aq rng a)]
                    None rng

    | Tv_Abs (b, t) ->
        S.mk_Tm_app ref_Tv_Abs.t [S.as_arg (embed_binder rng b); S.as_arg (embed_term_aq aq rng t)]
                    None rng

    | Tv_Arrow (b, c) ->
        S.mk_Tm_app ref_Tv_Arrow.t [S.as_arg (embed_binder rng b); S.as_arg (embed_comp rng c)]
                    None rng

    | Tv_Type u ->
        S.mk_Tm_app ref_Tv_Type.t [S.as_arg (embed_unit rng ())]
                    None rng

    | Tv_Refine (bv, t) ->
        S.mk_Tm_app ref_Tv_Refine.t [S.as_arg (embed_bv rng bv); S.as_arg (embed_term_aq aq rng t)]
                    None rng

    | Tv_Const c ->
        S.mk_Tm_app ref_Tv_Const.t [S.as_arg (embed_const rng c)]
                    None rng

    | Tv_Uvar (u, t) ->
        S.mk_Tm_app ref_Tv_Uvar.t [S.as_arg (embed_int rng u); S.as_arg (embed_term_aq aq rng t)]
                    None rng

    | Tv_Let (r, b, t1, t2) ->
        S.mk_Tm_app ref_Tv_Let.t [S.as_arg (embed_bool rng r);
                                  S.as_arg (embed_bv rng b);
                                  S.as_arg (embed_term_aq aq rng t1);
                                  S.as_arg (embed_term_aq aq rng t2)]
                    None rng

    | Tv_Match (t, brs) ->
        S.mk_Tm_app ref_Tv_Match.t [S.as_arg (embed_term_aq aq rng t);
                                    S.as_arg (embed_list (embed_branch_aq aq) fstar_refl_branch rng brs)]
                    None rng

    | Tv_AscribedT (e, t, tacopt) ->
        S.mk_Tm_app ref_Tv_AscT.t
                    [S.as_arg (embed_term_aq aq rng e);
                     S.as_arg (embed_term_aq aq rng t);
                     S.as_arg (embed_option (embed_term_aq aq) fstar_refl_term rng tacopt)]
                    None rng

    | Tv_AscribedC (e, c, tacopt) ->
        S.mk_Tm_app ref_Tv_AscC.t
                    [S.as_arg (embed_term_aq aq rng e);
                     S.as_arg (embed_comp rng c);
                     S.as_arg (embed_option (embed_term_aq aq) fstar_refl_term rng tacopt)]
                    None rng

    | Tv_Unknown ->
        { ref_Tv_Unknown.t with pos = rng }

let embed_term_view rng t = embed_term_view_aq [] rng t

let embed_bv_view (rng:Range.range) (bvv:bv_view) : term =
    S.mk_Tm_app ref_Mk_bv.t [S.as_arg (embed_string rng bvv.bv_ppname);
                             S.as_arg (embed_int    rng bvv.bv_index);
                             S.as_arg (embed_term   rng bvv.bv_sort)]
                None rng

let embed_comp_view (rng:Range.range) (cv : comp_view) : term =
    match cv with
    | C_Total (t, md) ->
        S.mk_Tm_app ref_C_Total.t [S.as_arg (embed_term rng t);
                                   S.as_arg (embed_option embed_term S.t_term rng md)]
                    None rng

    | C_Lemma (pre, post) ->
        let post = U.unthunk_lemma_post post in
        S.mk_Tm_app ref_C_Lemma.t [S.as_arg (embed_term rng pre); S.as_arg (embed_term rng post)]
                    None rng

    | C_Unknown ->
        { ref_C_Unknown.t with pos = rng }

let embed_order (rng:Range.range) (o:order) : term =
    let r =
    match o with
    | Lt -> ord_Lt
    | Eq -> ord_Eq
    | Gt -> ord_Gt
    in { r with pos = rng }

let embed_sigelt (rng:Range.range) (se:sigelt) : term =
    U.mk_lazy se fstar_refl_sigelt Lazy_sigelt (Some rng)

let embed_sigelt_view (rng:Range.range) (sev:sigelt_view) : term =
    match sev with
    | Sg_Let (r, fv, ty, t) ->
        S.mk_Tm_app ref_Sg_Let.t
                    [S.as_arg (embed_bool rng r);
                        S.as_arg (embed_fv rng fv);
                        S.as_arg (embed_term rng ty);
                        S.as_arg (embed_term rng t)]
                    None rng

    | Sg_Constructor (nm, ty) ->
        S.mk_Tm_app ref_Sg_Constructor.t
                    [S.as_arg (embed_string_list rng nm);
                        S.as_arg (embed_term rng ty)]
                    None rng

    | Sg_Inductive (nm, bs, t, dcs) ->
        S.mk_Tm_app ref_Sg_Inductive.t
                    [S.as_arg (embed_string_list rng nm);
                        S.as_arg (embed_binders rng bs);
                        S.as_arg (embed_term rng t);
                        S.as_arg (embed_list embed_string_list (S.t_list_of S.t_string) rng dcs)]
                    None rng

    | Unk ->
        { ref_Unk.t with pos = rng }

let rec embed_exp (rng:Range.range) (e:exp) : term =
    let r =
    match e with
    | Unit    -> ref_E_Unit.t
    | Var i ->
        S.mk_Tm_app ref_E_Var.t [S.as_arg (U.exp_int (Z.string_of_big_int i))]
                    None Range.dummyRange
    | Mult (e1, e2) ->
        S.mk_Tm_app ref_E_Mult.t [S.as_arg (embed_exp rng e1); S.as_arg (embed_exp rng e2)]
                    None Range.dummyRange
    in { r with pos = rng }


(* -------------------------------------------------------------------------------------- *)
(* ------------------------------------ UNEMBEDDINGS ------------------------------------ *)
(* -------------------------------------------------------------------------------------- *)

let unembed_bv (t:term) : option<bv> =
    match (SS.compress t).n with
    | Tm_lazy i when i.lkind = Lazy_bv ->
        Some (undyn i.blob)
    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded bv: %s" (Print.term_to_string t)));
        None

let unembed_binder (t:term) : option<binder> =
    match (SS.compress t).n with
    | Tm_lazy i when i.lkind = Lazy_binder ->
        Some (undyn i.blob)
    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded binder: %s" (Print.term_to_string t)));
        None

let rec mapM_opt (f : ('a -> option<'b>)) (l : list<'a>) : option<list<'b>> =
    match l with
    | [] -> Some []
    | x::xs ->
        BU.bind_opt (f x) (fun x ->
        BU.bind_opt (mapM_opt f xs) (fun xs ->
        Some (x :: xs)))

let rec unembed_term (t:term) : option<term> =
    let t = U.unmeta_safe t in
    match t.n with
    | Tm_quoted (tm, qi) ->
        let aqs = mapM_opt (fun (bv, b, e) ->
                                if b
                                then Some (NT (bv, e))
                                else BU.bind_opt (unembed_term e) (fun e -> Some (NT (bv, e))))
                           qi.antiquotes in
        BU.bind_opt aqs (fun s ->
        Some (SS.subst s tm))
    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded term: %s" (Print.term_to_string t)));
        None

let unembed_aqualv (t : term) : option<aqualv> =
    let t = U.unascribe t in
    let hd, args = U.head_and_args t in
    match (U.un_uinst hd).n, args with
    | Tm_fvar fv, [] when S.fv_eq_lid fv ref_Q_Explicit.lid -> Some Data.Q_Explicit
    | Tm_fvar fv, [] when S.fv_eq_lid fv ref_Q_Implicit.lid -> Some Data.Q_Implicit
    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded aqualv: %s" (Print.term_to_string t)));
        None

let unembed_binders t = unembed_list unembed_binder t

let unembed_fv (t:term) : option<fv> =
    match (SS.compress t).n with
    | Tm_lazy i when i.lkind = Lazy_fvar ->
        Some (undyn i.blob)
    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded fvar: %s" (Print.term_to_string t)));
        None

let unembed_comp (t:term) : option<comp> =
    match (SS.compress t).n with
    | Tm_lazy i when i.lkind = Lazy_comp ->
        Some (undyn i.blob)
    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded comp: %s" (Print.term_to_string t)));
        None

let unembed_env (t:term) : option<Env.env> =
    match (SS.compress t).n with
    | Tm_lazy i when i.lkind = Lazy_env ->
        Some (undyn i.blob)
    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded env: %s" (Print.term_to_string t)));
        None

let unembed_const (t:term) : option<vconst> =
    let t = U.unascribe t in
    let hd, args = U.head_and_args t in
    match (U.un_uinst hd).n, args with
    | Tm_fvar fv, [] when S.fv_eq_lid fv ref_C_Unit.lid ->
        Some C_Unit

    | Tm_fvar fv, [] when S.fv_eq_lid fv ref_C_True.lid ->
        Some C_True

    | Tm_fvar fv, [] when S.fv_eq_lid fv ref_C_False.lid ->
        Some C_False

    | Tm_fvar fv, [(i, _)] when S.fv_eq_lid fv ref_C_Int.lid ->
        BU.bind_opt (unembed_int i) (fun i ->
        Some <| C_Int i)

    | Tm_fvar fv, [(s, _)] when S.fv_eq_lid fv ref_C_String.lid ->
        BU.bind_opt (unembed_string s) (fun s ->
        Some <| C_String s)

    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded vconst: %s" (Print.term_to_string t)));
        None

let rec unembed_pattern (t : term) : option<pattern> =
    let t = U.unascribe t in
    let hd, args = U.head_and_args t in
    match (U.un_uinst hd).n, args with
    | Tm_fvar fv, [(c, _)] when S.fv_eq_lid fv ref_Pat_Constant.lid ->
        BU.bind_opt (unembed_const c) (fun c ->
        Some <| Pat_Constant c)

    | Tm_fvar fv, [(f, _); (ps, _)] when S.fv_eq_lid fv ref_Pat_Cons.lid ->
        BU.bind_opt (unembed_fv f) (fun f ->
        BU.bind_opt (unembed_list unembed_pattern ps) (fun ps ->
        Some <| Pat_Cons (f, ps)))

    | Tm_fvar fv, [(bv, _)] when S.fv_eq_lid fv ref_Pat_Var.lid ->
        BU.bind_opt (unembed_bv bv) (fun bv ->
        Some <| Pat_Var bv)

    | Tm_fvar fv, [(bv, _)] when S.fv_eq_lid fv ref_Pat_Wild.lid ->
        BU.bind_opt (unembed_bv bv) (fun bv ->
        Some <| Pat_Wild bv)

    | Tm_fvar fv, [(bv, _); (t, _)] when S.fv_eq_lid fv ref_Pat_Dot_Term.lid ->
        BU.bind_opt (unembed_bv bv) (fun bv ->
        BU.bind_opt (unembed_term t) (fun t ->
        Some <| Pat_Dot_Term (bv, t)))

    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded pattern: %s" (Print.term_to_string t)));
        None

let unembed_branch = unembed_tuple2 unembed_pattern unembed_term
let unembed_argv = unembed_tuple2 unembed_term unembed_aqualv

let unembed_term_view (t:term) : option<term_view> =
    let hd, args = U.head_and_args t in
    match (U.un_uinst hd).n, args with
    | Tm_fvar fv, [(b, _)] when S.fv_eq_lid fv ref_Tv_Var.lid ->
        BU.bind_opt (unembed_bv b) (fun b ->
        Some <| Tv_Var b)

    | Tm_fvar fv, [(b, _)] when S.fv_eq_lid fv ref_Tv_BVar.lid ->
        BU.bind_opt (unembed_bv b) (fun b ->
        Some <| Tv_BVar b)

    | Tm_fvar fv, [(f, _)] when S.fv_eq_lid fv ref_Tv_FVar.lid ->
        BU.bind_opt (unembed_fv f) (fun f ->
        Some <| Tv_FVar f)

    | Tm_fvar fv, [(l, _); (r, _)] when S.fv_eq_lid fv ref_Tv_App.lid ->
        BU.bind_opt (unembed_term l) (fun l ->
        BU.bind_opt (unembed_argv r) (fun r ->
        Some <| Tv_App (l, r)))

    | Tm_fvar fv, [(b, _); (t, _)] when S.fv_eq_lid fv ref_Tv_Abs.lid ->
        BU.bind_opt (unembed_binder b) (fun b ->
        BU.bind_opt (unembed_term t) (fun t ->
        Some <| Tv_Abs (b, t)))

    | Tm_fvar fv, [(b, _); (t, _)] when S.fv_eq_lid fv ref_Tv_Arrow.lid ->
        BU.bind_opt (unembed_binder b) (fun b ->
        BU.bind_opt (unembed_comp t) (fun c ->
        Some <| Tv_Arrow (b, c)))

    | Tm_fvar fv, [(u, _)] when S.fv_eq_lid fv ref_Tv_Type.lid ->
        BU.bind_opt (unembed_unit u) (fun u ->
        Some <| Tv_Type u)

    | Tm_fvar fv, [(b, _); (t, _)] when S.fv_eq_lid fv ref_Tv_Refine.lid ->
        BU.bind_opt (unembed_bv b) (fun b ->
        BU.bind_opt (unembed_term t) (fun t ->
        Some <| Tv_Refine (b, t)))

    | Tm_fvar fv, [(c, _)] when S.fv_eq_lid fv ref_Tv_Const.lid ->
        BU.bind_opt (unembed_const c) (fun c ->
        Some <| Tv_Const c)

    | Tm_fvar fv, [(u, _); (t, _)] when S.fv_eq_lid fv ref_Tv_Uvar.lid ->
        BU.bind_opt (unembed_int u) (fun u ->
        BU.bind_opt (unembed_term t) (fun t ->
        Some <| Tv_Uvar (u, t)))

    | Tm_fvar fv, [(r, _); (b, _); (t1, _); (t2, _)] when S.fv_eq_lid fv ref_Tv_Let.lid ->
        BU.bind_opt (unembed_bool r) (fun r ->
        BU.bind_opt (unembed_bv b) (fun b ->
        BU.bind_opt (unembed_term t1) (fun t1 ->
        BU.bind_opt (unembed_term t2) (fun t2 ->
        Some <| Tv_Let (r, b, t1, t2)))))

    | Tm_fvar fv, [(t, _); (brs, _)] when S.fv_eq_lid fv ref_Tv_Match.lid ->
        BU.bind_opt (unembed_term t) (fun t ->
        BU.bind_opt (unembed_list unembed_branch brs) (fun brs ->
        Some <| Tv_Match (t, brs)))

    | Tm_fvar fv, [(e, _); (t, _); (tacopt, _)] when S.fv_eq_lid fv ref_Tv_AscT.lid ->
        BU.bind_opt (unembed_term e) (fun e ->
        BU.bind_opt (unembed_term t) (fun t ->
        BU.bind_opt (unembed_option unembed_term tacopt) (fun tacopt ->
        Some <| Tv_AscribedT (e, t, tacopt))))

    | Tm_fvar fv, [(e, _); (c, _); (tacopt, _)] when S.fv_eq_lid fv ref_Tv_AscC.lid ->
        BU.bind_opt (unembed_term e) (fun e ->
        BU.bind_opt (unembed_comp c) (fun c ->
        BU.bind_opt (unembed_option unembed_term tacopt) (fun tacopt ->
        Some <| Tv_AscribedC (e, c, tacopt))))

    | Tm_fvar fv, [] when S.fv_eq_lid fv ref_Tv_Unknown.lid ->
        Some <| Tv_Unknown

    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded term_view: %s" (Print.term_to_string t)));
        None

let unembed_bv_view (t : term) : option<bv_view> =
    let t = U.unascribe t in
    let hd, args = U.head_and_args t in
    match (U.un_uinst hd).n, args with
    | Tm_fvar fv, [(nm, _); (idx, _); (s, _)] when S.fv_eq_lid fv ref_Mk_bv.lid ->
        BU.bind_opt (unembed_string nm) (fun nm ->
        BU.bind_opt (unembed_int idx) (fun idx ->
        BU.bind_opt (unembed_term s) (fun s ->
        Some <| { bv_ppname = nm ; bv_index = idx ; bv_sort = s })))

    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded bv_view: %s" (Print.term_to_string t)));
        None

let rec unembed_exp (t: term) : option<exp> =
    let t = U.unascribe t in
    let hd, args = U.head_and_args t in
    match (U.un_uinst hd).n, args with
    | Tm_fvar fv, [] when S.fv_eq_lid fv ref_E_Unit.lid ->
        Some Unit

    | Tm_fvar fv, [(i, _)] when S.fv_eq_lid fv ref_E_Var.lid ->
        BU.bind_opt (unembed_int i) (fun i ->
        Some <| Var i)

    | Tm_fvar fv, [(e1, _); (e2, _)] when S.fv_eq_lid fv ref_E_Mult.lid ->
        BU.bind_opt (unembed_exp e1) (fun e1 ->
        BU.bind_opt (unembed_exp e2) (fun e2 ->
        Some <| Mult (e1, e2)))
    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded exp: %s" (Print.term_to_string t)));
        None


let unembed_comp_view (t : term) : option<comp_view> =
    let t = U.unascribe t in
    let hd, args = U.head_and_args t in
    match (U.un_uinst hd).n, args with
    | Tm_fvar fv, [(t, _); (md, _)] when S.fv_eq_lid fv ref_C_Total.lid ->
        BU.bind_opt (unembed_term t) (fun t ->
        BU.bind_opt (unembed_option unembed_term md) (fun md ->
        Some <| C_Total (t, md)))

    | Tm_fvar fv, [(pre, _); (post, _)] when S.fv_eq_lid fv ref_C_Lemma.lid ->
        BU.bind_opt (unembed_term pre) (fun pre ->
        BU.bind_opt (unembed_term post) (fun post ->
        Some <| C_Lemma (pre, post)))

    | Tm_fvar fv, [] when S.fv_eq_lid fv ref_C_Unknown.lid ->
        Some <| C_Unknown

    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded comp_view: %s" (Print.term_to_string t)));
        None

let unembed_order (t:term) : option<order> =
    let t = U.unascribe t in
    let hd, args = U.head_and_args t in
    match (U.un_uinst hd).n, args with
    | Tm_fvar fv, [] when S.fv_eq_lid fv ord_Lt_lid -> Some Lt
    | Tm_fvar fv, [] when S.fv_eq_lid fv ord_Eq_lid -> Some Eq
    | Tm_fvar fv, [] when S.fv_eq_lid fv ord_Gt_lid -> Some Gt
    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded order: %s" (Print.term_to_string t)));
        None

let unembed_sigelt (t:term) : option<sigelt> =
    match (SS.compress t).n with
    | Tm_lazy i when i.lkind = Lazy_sigelt ->
        Some (undyn i.blob)
    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded sigelt: %s" (Print.term_to_string t)));
        None

let unembed_sigelt_view (t:term) : option<sigelt_view> =
    let t = U.unascribe t in
    let hd, args = U.head_and_args t in
    match (U.un_uinst hd).n, args with
    | Tm_fvar fv, [(nm, _); (bs, _); (t, _); (dcs, _)] when S.fv_eq_lid fv ref_Sg_Inductive.lid ->
        BU.bind_opt (unembed_string_list nm) (fun nm ->
        BU.bind_opt (unembed_binders bs) (fun bs ->
        BU.bind_opt (unembed_term t) (fun t ->
        BU.bind_opt (unembed_list (unembed_list unembed_string) dcs) (fun dcs ->
        Some <| Sg_Inductive (nm, bs, t, dcs)))))

    | Tm_fvar fv, [(r, _); (fvar, _); (ty, _); (t, _)] when S.fv_eq_lid fv ref_Sg_Let.lid ->
        BU.bind_opt (unembed_bool r) (fun r ->
        BU.bind_opt (unembed_fv fvar) (fun fvar ->
        BU.bind_opt (unembed_term ty) (fun ty ->
        BU.bind_opt (unembed_term t) (fun t ->
        Some <| Sg_Let (r, fvar, ty, t)))))

    | Tm_fvar fv, [] when S.fv_eq_lid fv ref_Unk.lid ->
        Some Unk

    | _ ->
        Err.log_issue t.pos (Err.Warning_NotEmbedded, (BU.format1 "Not an embedded sigelt_view: %s" (Print.term_to_string t)));
        None

(* -------------------------------------------------------------------------------------- *)
(* ------------------------------------- UNFOLDINGS ------------------------------------- *)
(* -------------------------------------------------------------------------------------- *)

let embed_binder_view   = embed_tuple2 embed_bv fstar_refl_bv_view embed_aqualv fstar_refl_aqualv
let unembed_binder_view = unembed_tuple2 unembed_bv unembed_aqualv


(* Note that most of these are never needed during normalization, since
 * the types are abstract.
 *)

let unfold_lazy_bv  (i : lazyinfo) : term =
    let bv : bv = undyn i.blob in
    S.mk_Tm_app fstar_refl_pack_bv.t [S.as_arg (embed_bv_view i.rng (inspect_bv bv))]
                None i.rng

(* TODO: non-uniform *)
let unfold_lazy_binder (i : lazyinfo) : term =
    let binder : binder = undyn i.blob in
    let bv, aq = inspect_binder binder in
    S.mk_Tm_app fstar_refl_pack_binder.t [S.as_arg (embed_bv i.rng bv);
                                        S.as_arg (embed_aqualv i.rng aq)]
                None i.rng

let unfold_lazy_fvar (i : lazyinfo) : term =
    let fv : fv = undyn i.blob in
    S.mk_Tm_app fstar_refl_pack_fv.t [S.as_arg (embed_list embed_string t_string i.rng (inspect_fv fv))]
                None i.rng

let unfold_lazy_comp (i : lazyinfo) : term =
    let comp : comp = undyn i.blob in
    S.mk_Tm_app fstar_refl_pack_comp.t [S.as_arg (embed_comp_view i.rng (inspect_comp comp))]
                None i.rng

let unfold_lazy_env (i : lazyinfo) : term =
    (* Not needed, metaprograms never see concrete environments. *)
    U.exp_unit

let unfold_lazy_sigelt (i : lazyinfo) : term =
    let sigelt : sigelt = undyn i.blob in
    S.mk_Tm_app fstar_refl_pack_sigelt.t [S.as_arg (embed_sigelt_view i.rng (inspect_sigelt sigelt))]
                None i.rng
