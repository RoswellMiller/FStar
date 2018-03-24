open Prims
let (guard_of_guard_formula :
  FStar_TypeChecker_Common.guard_formula -> FStar_TypeChecker_Env.guard_t) =
  fun g  ->
    {
      FStar_TypeChecker_Env.guard_f = g;
      FStar_TypeChecker_Env.deferred = [];
      FStar_TypeChecker_Env.univ_ineqs = ([], []);
      FStar_TypeChecker_Env.implicits = []
    }
  
let (guard_form :
  FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Common.guard_formula) =
  fun g  -> g.FStar_TypeChecker_Env.guard_f 
let (is_trivial : FStar_TypeChecker_Env.guard_t -> Prims.bool) =
  fun g  ->
    match g with
    | { FStar_TypeChecker_Env.guard_f = FStar_TypeChecker_Common.Trivial ;
        FStar_TypeChecker_Env.deferred = [];
        FStar_TypeChecker_Env.univ_ineqs = uu____30;
        FStar_TypeChecker_Env.implicits = uu____31;_} -> true
    | uu____58 -> false
  
let (trivial_guard : FStar_TypeChecker_Env.guard_t) =
  {
    FStar_TypeChecker_Env.guard_f = FStar_TypeChecker_Common.Trivial;
    FStar_TypeChecker_Env.deferred = [];
    FStar_TypeChecker_Env.univ_ineqs = ([], []);
    FStar_TypeChecker_Env.implicits = []
  } 
let (abstract_guard_n :
  FStar_Syntax_Syntax.binder Prims.list ->
    FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  =
  fun bs  ->
    fun g  ->
      match g.FStar_TypeChecker_Env.guard_f with
      | FStar_TypeChecker_Common.Trivial  -> g
      | FStar_TypeChecker_Common.NonTrivial f ->
          let f' =
            FStar_Syntax_Util.abs bs f
              (FStar_Pervasives_Native.Some
                 (FStar_Syntax_Util.residual_tot FStar_Syntax_Util.ktype0))
             in
          let uu___118_91 = g  in
          {
            FStar_TypeChecker_Env.guard_f =
              (FStar_TypeChecker_Common.NonTrivial f');
            FStar_TypeChecker_Env.deferred =
              (uu___118_91.FStar_TypeChecker_Env.deferred);
            FStar_TypeChecker_Env.univ_ineqs =
              (uu___118_91.FStar_TypeChecker_Env.univ_ineqs);
            FStar_TypeChecker_Env.implicits =
              (uu___118_91.FStar_TypeChecker_Env.implicits)
          }
  
let (abstract_guard :
  FStar_Syntax_Syntax.binder ->
    FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  = fun b  -> fun g  -> abstract_guard_n [b] g 
let (def_check_vars_in_set :
  FStar_Range.range ->
    Prims.string ->
      FStar_Syntax_Syntax.bv FStar_Util.set ->
        FStar_Syntax_Syntax.term -> Prims.unit)
  =
  fun rng  ->
    fun msg  ->
      fun vset  ->
        fun t  ->
          let uu____114 = FStar_Options.defensive ()  in
          if uu____114
          then
            let s = FStar_Syntax_Free.names t  in
            let uu____118 =
              let uu____119 =
                let uu____120 = FStar_Util.set_difference s vset  in
                FStar_All.pipe_left FStar_Util.set_is_empty uu____120  in
              Prims.op_Negation uu____119  in
            (if uu____118
             then
               let uu____125 =
                 let uu____130 =
                   let uu____131 = FStar_Syntax_Print.term_to_string t  in
                   let uu____132 =
                     let uu____133 = FStar_Util.set_elements s  in
                     FStar_All.pipe_right uu____133
                       (FStar_Syntax_Print.bvs_to_string ",\n\t")
                      in
                   FStar_Util.format3
                     "Internal: term is not closed (%s).\nt = (%s)\nFVs = (%s)\n"
                     msg uu____131 uu____132
                    in
                 (FStar_Errors.Warning_Defensive, uu____130)  in
               FStar_Errors.log_issue rng uu____125
             else ())
          else ()
  
let (def_check_closed :
  FStar_Range.range -> Prims.string -> FStar_Syntax_Syntax.term -> Prims.unit)
  =
  fun rng  ->
    fun msg  ->
      fun t  ->
        let uu____149 =
          let uu____150 = FStar_Options.defensive ()  in
          Prims.op_Negation uu____150  in
        if uu____149
        then ()
        else def_check_vars_in_set rng msg FStar_Syntax_Free.empty t
  
let (def_check_closed_in :
  FStar_Range.range ->
    Prims.string ->
      FStar_Syntax_Syntax.bv Prims.list ->
        FStar_Syntax_Syntax.term -> Prims.unit)
  =
  fun rng  ->
    fun msg  ->
      fun l  ->
        fun t  ->
          let uu____168 =
            let uu____169 = FStar_Options.defensive ()  in
            Prims.op_Negation uu____169  in
          if uu____168
          then ()
          else
            (let uu____171 = FStar_Util.as_set l FStar_Syntax_Syntax.order_bv
                in
             def_check_vars_in_set rng msg uu____171 t)
  
let (def_check_closed_in_env :
  FStar_Range.range ->
    Prims.string ->
      FStar_TypeChecker_Env.env -> FStar_Syntax_Syntax.term -> Prims.unit)
  =
  fun rng  ->
    fun msg  ->
      fun e  ->
        fun t  ->
          let uu____186 =
            let uu____187 = FStar_Options.defensive ()  in
            Prims.op_Negation uu____187  in
          if uu____186
          then ()
          else
            (let uu____189 = FStar_TypeChecker_Env.bound_vars e  in
             def_check_closed_in rng msg uu____189 t)
  
let (apply_guard :
  FStar_TypeChecker_Env.guard_t ->
    FStar_Syntax_Syntax.term -> FStar_TypeChecker_Env.guard_t)
  =
  fun g  ->
    fun e  ->
      match g.FStar_TypeChecker_Env.guard_f with
      | FStar_TypeChecker_Common.Trivial  -> g
      | FStar_TypeChecker_Common.NonTrivial f ->
          let uu___119_199 = g  in
          let uu____200 =
            let uu____201 =
              let uu____202 =
                let uu____205 =
                  let uu____206 =
                    let uu____221 =
                      let uu____224 = FStar_Syntax_Syntax.as_arg e  in
                      [uu____224]  in
                    (f, uu____221)  in
                  FStar_Syntax_Syntax.Tm_app uu____206  in
                FStar_Syntax_Syntax.mk uu____205  in
              uu____202 FStar_Pervasives_Native.None
                f.FStar_Syntax_Syntax.pos
               in
            FStar_All.pipe_left
              (fun _0_40  -> FStar_TypeChecker_Common.NonTrivial _0_40)
              uu____201
             in
          {
            FStar_TypeChecker_Env.guard_f = uu____200;
            FStar_TypeChecker_Env.deferred =
              (uu___119_199.FStar_TypeChecker_Env.deferred);
            FStar_TypeChecker_Env.univ_ineqs =
              (uu___119_199.FStar_TypeChecker_Env.univ_ineqs);
            FStar_TypeChecker_Env.implicits =
              (uu___119_199.FStar_TypeChecker_Env.implicits)
          }
  
let (map_guard :
  FStar_TypeChecker_Env.guard_t ->
    (FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) ->
      FStar_TypeChecker_Env.guard_t)
  =
  fun g  ->
    fun map1  ->
      match g.FStar_TypeChecker_Env.guard_f with
      | FStar_TypeChecker_Common.Trivial  -> g
      | FStar_TypeChecker_Common.NonTrivial f ->
          let uu___120_242 = g  in
          let uu____243 =
            let uu____244 = map1 f  in
            FStar_TypeChecker_Common.NonTrivial uu____244  in
          {
            FStar_TypeChecker_Env.guard_f = uu____243;
            FStar_TypeChecker_Env.deferred =
              (uu___120_242.FStar_TypeChecker_Env.deferred);
            FStar_TypeChecker_Env.univ_ineqs =
              (uu___120_242.FStar_TypeChecker_Env.univ_ineqs);
            FStar_TypeChecker_Env.implicits =
              (uu___120_242.FStar_TypeChecker_Env.implicits)
          }
  
let (trivial : FStar_TypeChecker_Common.guard_formula -> Prims.unit) =
  fun t  ->
    match t with
    | FStar_TypeChecker_Common.Trivial  -> ()
    | FStar_TypeChecker_Common.NonTrivial uu____248 -> failwith "impossible"
  
let (conj_guard_f :
  FStar_TypeChecker_Common.guard_formula ->
    FStar_TypeChecker_Common.guard_formula ->
      FStar_TypeChecker_Common.guard_formula)
  =
  fun g1  ->
    fun g2  ->
      match (g1, g2) with
      | (FStar_TypeChecker_Common.Trivial ,g) -> g
      | (g,FStar_TypeChecker_Common.Trivial ) -> g
      | (FStar_TypeChecker_Common.NonTrivial
         f1,FStar_TypeChecker_Common.NonTrivial f2) ->
          let uu____259 = FStar_Syntax_Util.mk_conj f1 f2  in
          FStar_TypeChecker_Common.NonTrivial uu____259
  
let (check_trivial :
  FStar_Syntax_Syntax.term -> FStar_TypeChecker_Common.guard_formula) =
  fun t  ->
    let uu____263 =
      let uu____264 = FStar_Syntax_Util.unmeta t  in
      uu____264.FStar_Syntax_Syntax.n  in
    match uu____263 with
    | FStar_Syntax_Syntax.Tm_fvar tc when
        FStar_Syntax_Syntax.fv_eq_lid tc FStar_Parser_Const.true_lid ->
        FStar_TypeChecker_Common.Trivial
    | uu____268 -> FStar_TypeChecker_Common.NonTrivial t
  
let (imp_guard_f :
  FStar_TypeChecker_Common.guard_formula ->
    FStar_TypeChecker_Common.guard_formula ->
      FStar_TypeChecker_Common.guard_formula)
  =
  fun g1  ->
    fun g2  ->
      match (g1, g2) with
      | (FStar_TypeChecker_Common.Trivial ,g) -> g
      | (g,FStar_TypeChecker_Common.Trivial ) ->
          FStar_TypeChecker_Common.Trivial
      | (FStar_TypeChecker_Common.NonTrivial
         f1,FStar_TypeChecker_Common.NonTrivial f2) ->
          let imp = FStar_Syntax_Util.mk_imp f1 f2  in check_trivial imp
  
let (binop_guard :
  (FStar_TypeChecker_Common.guard_formula ->
     FStar_TypeChecker_Common.guard_formula ->
       FStar_TypeChecker_Common.guard_formula)
    ->
    FStar_TypeChecker_Env.guard_t ->
      FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  =
  fun f  ->
    fun g1  ->
      fun g2  ->
        let uu____299 =
          f g1.FStar_TypeChecker_Env.guard_f g2.FStar_TypeChecker_Env.guard_f
           in
        {
          FStar_TypeChecker_Env.guard_f = uu____299;
          FStar_TypeChecker_Env.deferred =
            (FStar_List.append g1.FStar_TypeChecker_Env.deferred
               g2.FStar_TypeChecker_Env.deferred);
          FStar_TypeChecker_Env.univ_ineqs =
            ((FStar_List.append
                (FStar_Pervasives_Native.fst
                   g1.FStar_TypeChecker_Env.univ_ineqs)
                (FStar_Pervasives_Native.fst
                   g2.FStar_TypeChecker_Env.univ_ineqs)),
              (FStar_List.append
                 (FStar_Pervasives_Native.snd
                    g1.FStar_TypeChecker_Env.univ_ineqs)
                 (FStar_Pervasives_Native.snd
                    g2.FStar_TypeChecker_Env.univ_ineqs)));
          FStar_TypeChecker_Env.implicits =
            (FStar_List.append g1.FStar_TypeChecker_Env.implicits
               g2.FStar_TypeChecker_Env.implicits)
        }
  
let (conj_guard :
  FStar_TypeChecker_Env.guard_t ->
    FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  = fun g1  -> fun g2  -> binop_guard conj_guard_f g1 g2 
let (imp_guard :
  FStar_TypeChecker_Env.guard_t ->
    FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  = fun g1  -> fun g2  -> binop_guard imp_guard_f g1 g2 
let (close_guard_univs :
  FStar_Syntax_Syntax.universes ->
    FStar_Syntax_Syntax.binders ->
      FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  =
  fun us  ->
    fun bs  ->
      fun g  ->
        match g.FStar_TypeChecker_Env.guard_f with
        | FStar_TypeChecker_Common.Trivial  -> g
        | FStar_TypeChecker_Common.NonTrivial f ->
            let f1 =
              FStar_List.fold_right2
                (fun u  ->
                   fun b  ->
                     fun f1  ->
                       let uu____366 = FStar_Syntax_Syntax.is_null_binder b
                          in
                       if uu____366
                       then f1
                       else
                         FStar_Syntax_Util.mk_forall u
                           (FStar_Pervasives_Native.fst b) f1) us bs f
               in
            let uu___121_368 = g  in
            {
              FStar_TypeChecker_Env.guard_f =
                (FStar_TypeChecker_Common.NonTrivial f1);
              FStar_TypeChecker_Env.deferred =
                (uu___121_368.FStar_TypeChecker_Env.deferred);
              FStar_TypeChecker_Env.univ_ineqs =
                (uu___121_368.FStar_TypeChecker_Env.univ_ineqs);
              FStar_TypeChecker_Env.implicits =
                (uu___121_368.FStar_TypeChecker_Env.implicits)
            }
  
let (close_forall :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.binder Prims.list ->
      FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ)
  =
  fun env  ->
    fun bs  ->
      fun f  ->
        FStar_List.fold_right
          (fun b  ->
             fun f1  ->
               let uu____387 = FStar_Syntax_Syntax.is_null_binder b  in
               if uu____387
               then f1
               else
                 (let u =
                    env.FStar_TypeChecker_Env.universe_of env
                      (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                     in
                  FStar_Syntax_Util.mk_forall u
                    (FStar_Pervasives_Native.fst b) f1)) bs f
  
let (close_guard :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.binders ->
      FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  =
  fun env  ->
    fun binders  ->
      fun g  ->
        match g.FStar_TypeChecker_Env.guard_f with
        | FStar_TypeChecker_Common.Trivial  -> g
        | FStar_TypeChecker_Common.NonTrivial f ->
            let uu___122_400 = g  in
            let uu____401 =
              let uu____402 = close_forall env binders f  in
              FStar_TypeChecker_Common.NonTrivial uu____402  in
            {
              FStar_TypeChecker_Env.guard_f = uu____401;
              FStar_TypeChecker_Env.deferred =
                (uu___122_400.FStar_TypeChecker_Env.deferred);
              FStar_TypeChecker_Env.univ_ineqs =
                (uu___122_400.FStar_TypeChecker_Env.univ_ineqs);
              FStar_TypeChecker_Env.implicits =
                (uu___122_400.FStar_TypeChecker_Env.implicits)
            }
  
let (new_uvar :
  FStar_Range.range ->
    FStar_Syntax_Syntax.binders ->
      FStar_Syntax_Syntax.typ ->
        (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.typ)
          FStar_Pervasives_Native.tuple2)
  =
  fun r  ->
    fun binders  ->
      fun k  ->
        let uv = FStar_Syntax_Unionfind.fresh ()  in
        match binders with
        | [] ->
            let uv1 =
              FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_uvar (uv, k))
                FStar_Pervasives_Native.None r
               in
            (uv1, uv1)
        | uu____432 ->
            let args =
              FStar_All.pipe_right binders
                (FStar_List.map FStar_Syntax_Util.arg_of_non_null_binder)
               in
            let k' =
              let uu____457 = FStar_Syntax_Syntax.mk_Total k  in
              FStar_Syntax_Util.arrow binders uu____457  in
            let uv1 =
              FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_uvar (uv, k'))
                FStar_Pervasives_Native.None r
               in
            let uu____465 =
              FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_app (uv1, args))
                FStar_Pervasives_Native.None r
               in
            (uu____465, uv1)
  
type uvi =
  | TERM of
  ((FStar_Syntax_Syntax.uvar,FStar_Syntax_Syntax.typ)
     FStar_Pervasives_Native.tuple2,FStar_Syntax_Syntax.term)
  FStar_Pervasives_Native.tuple2 
  | UNIV of (FStar_Syntax_Syntax.universe_uvar,FStar_Syntax_Syntax.universe)
  FStar_Pervasives_Native.tuple2 [@@deriving show]
let (uu___is_TERM : uvi -> Prims.bool) =
  fun projectee  ->
    match projectee with | TERM _0 -> true | uu____512 -> false
  
let (__proj__TERM__item___0 :
  uvi ->
    ((FStar_Syntax_Syntax.uvar,FStar_Syntax_Syntax.typ)
       FStar_Pervasives_Native.tuple2,FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | TERM _0 -> _0 
let (uu___is_UNIV : uvi -> Prims.bool) =
  fun projectee  ->
    match projectee with | UNIV _0 -> true | uu____552 -> false
  
let (__proj__UNIV__item___0 :
  uvi ->
    (FStar_Syntax_Syntax.universe_uvar,FStar_Syntax_Syntax.universe)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | UNIV _0 -> _0 
type worklist =
  {
  attempting: FStar_TypeChecker_Common.probs ;
  wl_deferred:
    (Prims.int,Prims.string,FStar_TypeChecker_Common.prob)
      FStar_Pervasives_Native.tuple3 Prims.list
    ;
  ctr: Prims.int ;
  defer_ok: Prims.bool ;
  smt_ok: Prims.bool ;
  tcenv: FStar_TypeChecker_Env.env }[@@deriving show]
let (__proj__Mkworklist__item__attempting :
  worklist -> FStar_TypeChecker_Common.probs) =
  fun projectee  ->
    match projectee with
    | { attempting = __fname__attempting; wl_deferred = __fname__wl_deferred;
        ctr = __fname__ctr; defer_ok = __fname__defer_ok;
        smt_ok = __fname__smt_ok; tcenv = __fname__tcenv;_} ->
        __fname__attempting
  
let (__proj__Mkworklist__item__wl_deferred :
  worklist ->
    (Prims.int,Prims.string,FStar_TypeChecker_Common.prob)
      FStar_Pervasives_Native.tuple3 Prims.list)
  =
  fun projectee  ->
    match projectee with
    | { attempting = __fname__attempting; wl_deferred = __fname__wl_deferred;
        ctr = __fname__ctr; defer_ok = __fname__defer_ok;
        smt_ok = __fname__smt_ok; tcenv = __fname__tcenv;_} ->
        __fname__wl_deferred
  
let (__proj__Mkworklist__item__ctr : worklist -> Prims.int) =
  fun projectee  ->
    match projectee with
    | { attempting = __fname__attempting; wl_deferred = __fname__wl_deferred;
        ctr = __fname__ctr; defer_ok = __fname__defer_ok;
        smt_ok = __fname__smt_ok; tcenv = __fname__tcenv;_} -> __fname__ctr
  
let (__proj__Mkworklist__item__defer_ok : worklist -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | { attempting = __fname__attempting; wl_deferred = __fname__wl_deferred;
        ctr = __fname__ctr; defer_ok = __fname__defer_ok;
        smt_ok = __fname__smt_ok; tcenv = __fname__tcenv;_} ->
        __fname__defer_ok
  
let (__proj__Mkworklist__item__smt_ok : worklist -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | { attempting = __fname__attempting; wl_deferred = __fname__wl_deferred;
        ctr = __fname__ctr; defer_ok = __fname__defer_ok;
        smt_ok = __fname__smt_ok; tcenv = __fname__tcenv;_} ->
        __fname__smt_ok
  
let (__proj__Mkworklist__item__tcenv : worklist -> FStar_TypeChecker_Env.env)
  =
  fun projectee  ->
    match projectee with
    | { attempting = __fname__attempting; wl_deferred = __fname__wl_deferred;
        ctr = __fname__ctr; defer_ok = __fname__defer_ok;
        smt_ok = __fname__smt_ok; tcenv = __fname__tcenv;_} -> __fname__tcenv
  
type solution =
  | Success of FStar_TypeChecker_Common.deferred 
  | Failed of (FStar_TypeChecker_Common.prob,Prims.string)
  FStar_Pervasives_Native.tuple2 [@@deriving show]
let (uu___is_Success : solution -> Prims.bool) =
  fun projectee  ->
    match projectee with | Success _0 -> true | uu____738 -> false
  
let (__proj__Success__item___0 :
  solution -> FStar_TypeChecker_Common.deferred) =
  fun projectee  -> match projectee with | Success _0 -> _0 
let (uu___is_Failed : solution -> Prims.bool) =
  fun projectee  ->
    match projectee with | Failed _0 -> true | uu____754 -> false
  
let (__proj__Failed__item___0 :
  solution ->
    (FStar_TypeChecker_Common.prob,Prims.string)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | Failed _0 -> _0 
type variance =
  | COVARIANT 
  | CONTRAVARIANT 
  | INVARIANT [@@deriving show]
let (uu___is_COVARIANT : variance -> Prims.bool) =
  fun projectee  ->
    match projectee with | COVARIANT  -> true | uu____777 -> false
  
let (uu___is_CONTRAVARIANT : variance -> Prims.bool) =
  fun projectee  ->
    match projectee with | CONTRAVARIANT  -> true | uu____781 -> false
  
let (uu___is_INVARIANT : variance -> Prims.bool) =
  fun projectee  ->
    match projectee with | INVARIANT  -> true | uu____785 -> false
  
type tprob =
  (FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.term)
    FStar_TypeChecker_Common.problem[@@deriving show]
type cprob =
  (FStar_Syntax_Syntax.comp,Prims.unit) FStar_TypeChecker_Common.problem
[@@deriving show]
type ('a,'b) problem_t = ('a,'b) FStar_TypeChecker_Common.problem[@@deriving
                                                                   show]
let (rel_to_string : FStar_TypeChecker_Common.rel -> Prims.string) =
  fun uu___88_808  ->
    match uu___88_808 with
    | FStar_TypeChecker_Common.EQ  -> "="
    | FStar_TypeChecker_Common.SUB  -> "<:"
    | FStar_TypeChecker_Common.SUBINV  -> ":>"
  
let (term_to_string : FStar_Syntax_Syntax.term -> Prims.string) =
  fun t  ->
    let compact = FStar_Syntax_Print.term_to_string t  in
    let detail =
      let uu____814 =
        let uu____815 = FStar_Syntax_Subst.compress t  in
        uu____815.FStar_Syntax_Syntax.n  in
      match uu____814 with
      | FStar_Syntax_Syntax.Tm_uvar (u,t1) ->
          let uu____844 = FStar_Syntax_Print.uvar_to_string u  in
          let uu____845 = FStar_Syntax_Print.term_to_string t1  in
          FStar_Util.format2 "%s : %s" uu____844 uu____845
      | FStar_Syntax_Syntax.Tm_app
          ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar (u,ty);
             FStar_Syntax_Syntax.pos = uu____848;
             FStar_Syntax_Syntax.vars = uu____849;_},args)
          ->
          let uu____895 = FStar_Syntax_Print.uvar_to_string u  in
          let uu____896 = FStar_Syntax_Print.term_to_string ty  in
          let uu____897 = FStar_Syntax_Print.args_to_string args  in
          FStar_Util.format3 "(%s : %s) %s" uu____895 uu____896 uu____897
      | uu____898 -> "--"  in
    let uu____899 = FStar_Syntax_Print.tag_of_term t  in
    FStar_Util.format3 "%s (%s)\t%s" compact uu____899 detail
  
let (prob_to_string :
  FStar_TypeChecker_Env.env -> FStar_TypeChecker_Common.prob -> Prims.string)
  =
  fun env  ->
    fun uu___89_905  ->
      match uu___89_905 with
      | FStar_TypeChecker_Common.TProb p ->
          let uu____911 =
            let uu____914 =
              FStar_Util.string_of_int p.FStar_TypeChecker_Common.pid  in
            let uu____915 =
              let uu____918 = term_to_string p.FStar_TypeChecker_Common.lhs
                 in
              let uu____919 =
                let uu____922 =
                  let uu____925 =
                    term_to_string p.FStar_TypeChecker_Common.rhs  in
                  [uu____925]  in
                (rel_to_string p.FStar_TypeChecker_Common.relation) ::
                  uu____922
                 in
              uu____918 :: uu____919  in
            uu____914 :: uu____915  in
          FStar_Util.format "\n%s:\t%s \n\t\t%s\n\t%s" uu____911
      | FStar_TypeChecker_Common.CProb p ->
          let uu____931 =
            FStar_Util.string_of_int p.FStar_TypeChecker_Common.pid  in
          let uu____932 =
            FStar_TypeChecker_Normalize.comp_to_string env
              p.FStar_TypeChecker_Common.lhs
             in
          let uu____933 =
            FStar_TypeChecker_Normalize.comp_to_string env
              p.FStar_TypeChecker_Common.rhs
             in
          FStar_Util.format4 "\n%s:\t%s \n\t\t%s\n\t%s" uu____931 uu____932
            (rel_to_string p.FStar_TypeChecker_Common.relation) uu____933
  
let (uvi_to_string : FStar_TypeChecker_Env.env -> uvi -> Prims.string) =
  fun env  ->
    fun uu___90_939  ->
      match uu___90_939 with
      | UNIV (u,t) ->
          let x =
            let uu____943 = FStar_Options.hide_uvar_nums ()  in
            if uu____943
            then "?"
            else
              (let uu____945 = FStar_Syntax_Unionfind.univ_uvar_id u  in
               FStar_All.pipe_right uu____945 FStar_Util.string_of_int)
             in
          let uu____946 = FStar_Syntax_Print.univ_to_string t  in
          FStar_Util.format2 "UNIV %s %s" x uu____946
      | TERM ((u,uu____948),t) ->
          let x =
            let uu____955 = FStar_Options.hide_uvar_nums ()  in
            if uu____955
            then "?"
            else
              (let uu____957 = FStar_Syntax_Unionfind.uvar_id u  in
               FStar_All.pipe_right uu____957 FStar_Util.string_of_int)
             in
          let uu____958 = FStar_TypeChecker_Normalize.term_to_string env t
             in
          FStar_Util.format2 "TERM %s %s" x uu____958
  
let (uvis_to_string :
  FStar_TypeChecker_Env.env -> uvi Prims.list -> Prims.string) =
  fun env  ->
    fun uvis  ->
      let uu____969 = FStar_List.map (uvi_to_string env) uvis  in
      FStar_All.pipe_right uu____969 (FStar_String.concat ", ")
  
let (names_to_string : FStar_Syntax_Syntax.bv FStar_Util.set -> Prims.string)
  =
  fun nms  ->
    let uu____981 =
      let uu____984 = FStar_Util.set_elements nms  in
      FStar_All.pipe_right uu____984
        (FStar_List.map FStar_Syntax_Print.bv_to_string)
       in
    FStar_All.pipe_right uu____981 (FStar_String.concat ", ")
  
let args_to_string :
  'Auu____995 .
    (FStar_Syntax_Syntax.term,'Auu____995) FStar_Pervasives_Native.tuple2
      Prims.list -> Prims.string
  =
  fun args  ->
    let uu____1012 =
      FStar_All.pipe_right args
        (FStar_List.map
           (fun uu____1030  ->
              match uu____1030 with
              | (x,uu____1036) -> FStar_Syntax_Print.term_to_string x))
       in
    FStar_All.pipe_right uu____1012 (FStar_String.concat " ")
  
let (empty_worklist : FStar_TypeChecker_Env.env -> worklist) =
  fun env  ->
    let uu____1042 =
      let uu____1043 = FStar_Options.eager_inference ()  in
      Prims.op_Negation uu____1043  in
    {
      attempting = [];
      wl_deferred = [];
      ctr = (Prims.parse_int "0");
      defer_ok = uu____1042;
      smt_ok = true;
      tcenv = env
    }
  
let (singleton' :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Common.prob -> Prims.bool -> worklist)
  =
  fun env  ->
    fun prob  ->
      fun smt_ok  ->
        let uu___123_1059 = empty_worklist env  in
        {
          attempting = [prob];
          wl_deferred = (uu___123_1059.wl_deferred);
          ctr = (uu___123_1059.ctr);
          defer_ok = (uu___123_1059.defer_ok);
          smt_ok;
          tcenv = (uu___123_1059.tcenv)
        }
  
let (singleton :
  FStar_TypeChecker_Env.env -> FStar_TypeChecker_Common.prob -> worklist) =
  fun env  -> fun prob  -> singleton' env prob true 
let wl_of_guard :
  'Auu____1069 .
    FStar_TypeChecker_Env.env ->
      ('Auu____1069,FStar_TypeChecker_Common.prob)
        FStar_Pervasives_Native.tuple2 Prims.list -> worklist
  =
  fun env  ->
    fun g  ->
      let uu___124_1090 = empty_worklist env  in
      let uu____1091 = FStar_List.map FStar_Pervasives_Native.snd g  in
      {
        attempting = uu____1091;
        wl_deferred = (uu___124_1090.wl_deferred);
        ctr = (uu___124_1090.ctr);
        defer_ok = false;
        smt_ok = (uu___124_1090.smt_ok);
        tcenv = (uu___124_1090.tcenv)
      }
  
let (defer :
  Prims.string -> FStar_TypeChecker_Common.prob -> worklist -> worklist) =
  fun reason  ->
    fun prob  ->
      fun wl  ->
        let uu___125_1105 = wl  in
        {
          attempting = (uu___125_1105.attempting);
          wl_deferred = (((wl.ctr), reason, prob) :: (wl.wl_deferred));
          ctr = (uu___125_1105.ctr);
          defer_ok = (uu___125_1105.defer_ok);
          smt_ok = (uu___125_1105.smt_ok);
          tcenv = (uu___125_1105.tcenv)
        }
  
let (attempt :
  FStar_TypeChecker_Common.prob Prims.list -> worklist -> worklist) =
  fun probs  ->
    fun wl  ->
      let uu___126_1122 = wl  in
      {
        attempting = (FStar_List.append probs wl.attempting);
        wl_deferred = (uu___126_1122.wl_deferred);
        ctr = (uu___126_1122.ctr);
        defer_ok = (uu___126_1122.defer_ok);
        smt_ok = (uu___126_1122.smt_ok);
        tcenv = (uu___126_1122.tcenv)
      }
  
let (giveup :
  FStar_TypeChecker_Env.env ->
    Prims.string -> FStar_TypeChecker_Common.prob -> solution)
  =
  fun env  ->
    fun reason  ->
      fun prob  ->
        (let uu____1133 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "Rel")
            in
         if uu____1133
         then
           let uu____1134 = prob_to_string env prob  in
           FStar_Util.print2 "Failed %s:\n%s\n" reason uu____1134
         else ());
        Failed (prob, reason)
  
let (invert_rel :
  FStar_TypeChecker_Common.rel -> FStar_TypeChecker_Common.rel) =
  fun uu___91_1138  ->
    match uu___91_1138 with
    | FStar_TypeChecker_Common.EQ  -> FStar_TypeChecker_Common.EQ
    | FStar_TypeChecker_Common.SUB  -> FStar_TypeChecker_Common.SUBINV
    | FStar_TypeChecker_Common.SUBINV  -> FStar_TypeChecker_Common.SUB
  
let invert :
  'Auu____1142 'Auu____1143 .
    ('Auu____1142,'Auu____1143) FStar_TypeChecker_Common.problem ->
      ('Auu____1142,'Auu____1143) FStar_TypeChecker_Common.problem
  =
  fun p  ->
    let uu___127_1160 = p  in
    {
      FStar_TypeChecker_Common.pid =
        (uu___127_1160.FStar_TypeChecker_Common.pid);
      FStar_TypeChecker_Common.lhs = (p.FStar_TypeChecker_Common.rhs);
      FStar_TypeChecker_Common.relation =
        (invert_rel p.FStar_TypeChecker_Common.relation);
      FStar_TypeChecker_Common.rhs = (p.FStar_TypeChecker_Common.lhs);
      FStar_TypeChecker_Common.element =
        (uu___127_1160.FStar_TypeChecker_Common.element);
      FStar_TypeChecker_Common.logical_guard =
        (uu___127_1160.FStar_TypeChecker_Common.logical_guard);
      FStar_TypeChecker_Common.scope =
        (uu___127_1160.FStar_TypeChecker_Common.scope);
      FStar_TypeChecker_Common.reason =
        (uu___127_1160.FStar_TypeChecker_Common.reason);
      FStar_TypeChecker_Common.loc =
        (uu___127_1160.FStar_TypeChecker_Common.loc);
      FStar_TypeChecker_Common.rank =
        (uu___127_1160.FStar_TypeChecker_Common.rank)
    }
  
let maybe_invert :
  'Auu____1168 'Auu____1169 .
    ('Auu____1168,'Auu____1169) FStar_TypeChecker_Common.problem ->
      ('Auu____1168,'Auu____1169) FStar_TypeChecker_Common.problem
  =
  fun p  ->
    if p.FStar_TypeChecker_Common.relation = FStar_TypeChecker_Common.SUBINV
    then invert p
    else p
  
let (maybe_invert_p :
  FStar_TypeChecker_Common.prob -> FStar_TypeChecker_Common.prob) =
  fun uu___92_1189  ->
    match uu___92_1189 with
    | FStar_TypeChecker_Common.TProb p ->
        FStar_All.pipe_right (maybe_invert p)
          (fun _0_41  -> FStar_TypeChecker_Common.TProb _0_41)
    | FStar_TypeChecker_Common.CProb p ->
        FStar_All.pipe_right (maybe_invert p)
          (fun _0_42  -> FStar_TypeChecker_Common.CProb _0_42)
  
let (vary_rel :
  FStar_TypeChecker_Common.rel -> variance -> FStar_TypeChecker_Common.rel) =
  fun rel  ->
    fun uu___93_1213  ->
      match uu___93_1213 with
      | INVARIANT  -> FStar_TypeChecker_Common.EQ
      | CONTRAVARIANT  -> invert_rel rel
      | COVARIANT  -> rel
  
let (p_pid : FStar_TypeChecker_Common.prob -> Prims.int) =
  fun uu___94_1216  ->
    match uu___94_1216 with
    | FStar_TypeChecker_Common.TProb p -> p.FStar_TypeChecker_Common.pid
    | FStar_TypeChecker_Common.CProb p -> p.FStar_TypeChecker_Common.pid
  
let (p_rel : FStar_TypeChecker_Common.prob -> FStar_TypeChecker_Common.rel) =
  fun uu___95_1229  ->
    match uu___95_1229 with
    | FStar_TypeChecker_Common.TProb p -> p.FStar_TypeChecker_Common.relation
    | FStar_TypeChecker_Common.CProb p -> p.FStar_TypeChecker_Common.relation
  
let (p_reason : FStar_TypeChecker_Common.prob -> Prims.string Prims.list) =
  fun uu___96_1244  ->
    match uu___96_1244 with
    | FStar_TypeChecker_Common.TProb p -> p.FStar_TypeChecker_Common.reason
    | FStar_TypeChecker_Common.CProb p -> p.FStar_TypeChecker_Common.reason
  
let (p_loc : FStar_TypeChecker_Common.prob -> FStar_Range.range) =
  fun uu___97_1259  ->
    match uu___97_1259 with
    | FStar_TypeChecker_Common.TProb p -> p.FStar_TypeChecker_Common.loc
    | FStar_TypeChecker_Common.CProb p -> p.FStar_TypeChecker_Common.loc
  
let (p_guard :
  FStar_TypeChecker_Common.prob ->
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2)
  =
  fun uu___98_1276  ->
    match uu___98_1276 with
    | FStar_TypeChecker_Common.TProb p ->
        p.FStar_TypeChecker_Common.logical_guard
    | FStar_TypeChecker_Common.CProb p ->
        p.FStar_TypeChecker_Common.logical_guard
  
let def_scope_wf :
  'Auu____1295 .
    Prims.string ->
      FStar_Range.range ->
        (FStar_Syntax_Syntax.bv,'Auu____1295) FStar_Pervasives_Native.tuple2
          Prims.list -> Prims.unit
  =
  fun msg  ->
    fun rng  ->
      fun r  ->
        let uu____1320 =
          let uu____1321 = FStar_Options.defensive ()  in
          Prims.op_Negation uu____1321  in
        if uu____1320
        then ()
        else
          (let rec aux prev next =
             match next with
             | [] -> ()
             | (bv,uu____1351)::bs ->
                 (def_check_closed_in rng msg prev
                    bv.FStar_Syntax_Syntax.sort;
                  aux (FStar_List.append prev [bv]) bs)
              in
           aux [] r)
  
let (p_scope : FStar_TypeChecker_Common.prob -> FStar_Syntax_Syntax.binders)
  =
  fun prob  ->
    let r =
      match prob with
      | FStar_TypeChecker_Common.TProb p -> p.FStar_TypeChecker_Common.scope
      | FStar_TypeChecker_Common.CProb p -> p.FStar_TypeChecker_Common.scope
       in
    def_scope_wf "p_scope" (p_loc prob) r; r
  
let (def_check_scoped :
  Prims.string ->
    FStar_TypeChecker_Common.prob -> FStar_Syntax_Syntax.term -> Prims.unit)
  =
  fun msg  ->
    fun prob  ->
      fun phi  ->
        let uu____1388 =
          let uu____1389 = FStar_Options.defensive ()  in
          Prims.op_Negation uu____1389  in
        if uu____1388
        then ()
        else
          (let uu____1391 =
             let uu____1394 = p_scope prob  in
             FStar_All.pipe_left (FStar_List.map FStar_Pervasives_Native.fst)
               uu____1394
              in
           def_check_closed_in (p_loc prob) msg uu____1391 phi)
  
let (def_check_prob :
  Prims.string -> FStar_TypeChecker_Common.prob -> Prims.unit) =
  fun msg  ->
    fun prob  ->
      (let uu____1420 =
         let uu____1421 = FStar_Options.defensive ()  in
         Prims.op_Negation uu____1421  in
       if uu____1420
       then ()
       else
         (let uu____1423 = p_scope prob  in
          def_scope_wf (Prims.strcat msg ".scope") (p_loc prob) uu____1423));
      (let uu____1431 =
         FStar_All.pipe_left FStar_Pervasives_Native.fst (p_guard prob)  in
       def_check_scoped (Prims.strcat msg ".guard") prob uu____1431);
      (let uu____1437 =
         FStar_All.pipe_left FStar_Pervasives_Native.snd (p_guard prob)  in
       def_check_scoped (Prims.strcat msg ".guard_type") prob uu____1437);
      (match prob with
       | FStar_TypeChecker_Common.TProb p ->
           (def_check_scoped (Prims.strcat msg ".lhs") prob
              p.FStar_TypeChecker_Common.lhs;
            def_check_scoped (Prims.strcat msg ".rhs") prob
              p.FStar_TypeChecker_Common.rhs)
       | uu____1448 -> ())
  
let (mk_eq2 :
  FStar_TypeChecker_Common.prob ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun prob  ->
    fun t1  ->
      fun t2  ->
        let uu____1463 = FStar_Syntax_Util.type_u ()  in
        match uu____1463 with
        | (t_type,u) ->
            let uu____1470 =
              let uu____1475 = p_scope prob  in
              new_uvar t1.FStar_Syntax_Syntax.pos uu____1475 t_type  in
            (match uu____1470 with
             | (tt,uu____1477) -> FStar_Syntax_Util.mk_eq2 u tt t1 t2)
  
let (p_invert :
  FStar_TypeChecker_Common.prob -> FStar_TypeChecker_Common.prob) =
  fun uu___99_1480  ->
    match uu___99_1480 with
    | FStar_TypeChecker_Common.TProb p ->
        FStar_All.pipe_left
          (fun _0_43  -> FStar_TypeChecker_Common.TProb _0_43) (invert p)
    | FStar_TypeChecker_Common.CProb p ->
        FStar_All.pipe_left
          (fun _0_44  -> FStar_TypeChecker_Common.CProb _0_44) (invert p)
  
let (is_top_level_prob : FStar_TypeChecker_Common.prob -> Prims.bool) =
  fun p  ->
    let uu____1502 = FStar_All.pipe_right (p_reason p) FStar_List.length  in
    uu____1502 = (Prims.parse_int "1")
  
let (next_pid : Prims.unit -> Prims.int) =
  let ctr = FStar_Util.mk_ref (Prims.parse_int "0")  in
  fun uu____1514  -> FStar_Util.incr ctr; FStar_ST.op_Bang ctr 
let mk_problem :
  'Auu____1599 'Auu____1600 .
    FStar_Syntax_Syntax.binders ->
      FStar_TypeChecker_Common.prob ->
        'Auu____1599 ->
          FStar_TypeChecker_Common.rel ->
            'Auu____1599 ->
              'Auu____1600 FStar_Pervasives_Native.option ->
                Prims.string ->
                  ('Auu____1599,'Auu____1600)
                    FStar_TypeChecker_Common.problem
  =
  fun scope  ->
    fun orig  ->
      fun lhs  ->
        fun rel  ->
          fun rhs  ->
            fun elt  ->
              fun reason  ->
                let uu____1637 = next_pid ()  in
                let uu____1638 =
                  new_uvar FStar_Range.dummyRange scope
                    FStar_Syntax_Util.ktype0
                   in
                {
                  FStar_TypeChecker_Common.pid = uu____1637;
                  FStar_TypeChecker_Common.lhs = lhs;
                  FStar_TypeChecker_Common.relation = rel;
                  FStar_TypeChecker_Common.rhs = rhs;
                  FStar_TypeChecker_Common.element = elt;
                  FStar_TypeChecker_Common.logical_guard = uu____1638;
                  FStar_TypeChecker_Common.scope = scope;
                  FStar_TypeChecker_Common.reason = (reason ::
                    (p_reason orig));
                  FStar_TypeChecker_Common.loc = (p_loc orig);
                  FStar_TypeChecker_Common.rank =
                    FStar_Pervasives_Native.None
                }
  
let new_problem :
  'Auu____1652 'Auu____1653 .
    FStar_TypeChecker_Env.env ->
      'Auu____1652 ->
        FStar_TypeChecker_Common.rel ->
          'Auu____1652 ->
            'Auu____1653 FStar_Pervasives_Native.option ->
              FStar_Range.range ->
                Prims.string ->
                  ('Auu____1652,'Auu____1653)
                    FStar_TypeChecker_Common.problem
  =
  fun env  ->
    fun lhs  ->
      fun rel  ->
        fun rhs  ->
          fun elt  ->
            fun loc  ->
              fun reason  ->
                let scope = FStar_TypeChecker_Env.all_binders env  in
                let uu____1691 = next_pid ()  in
                let uu____1692 =
                  new_uvar FStar_Range.dummyRange scope
                    FStar_Syntax_Util.ktype0
                   in
                {
                  FStar_TypeChecker_Common.pid = uu____1691;
                  FStar_TypeChecker_Common.lhs = lhs;
                  FStar_TypeChecker_Common.relation = rel;
                  FStar_TypeChecker_Common.rhs = rhs;
                  FStar_TypeChecker_Common.element = elt;
                  FStar_TypeChecker_Common.logical_guard = uu____1692;
                  FStar_TypeChecker_Common.scope = scope;
                  FStar_TypeChecker_Common.reason = [reason];
                  FStar_TypeChecker_Common.loc = loc;
                  FStar_TypeChecker_Common.rank =
                    FStar_Pervasives_Native.None
                }
  
let problem_using_guard :
  'Auu____1705 'Auu____1706 .
    FStar_TypeChecker_Common.prob ->
      'Auu____1705 ->
        FStar_TypeChecker_Common.rel ->
          'Auu____1705 ->
            'Auu____1706 FStar_Pervasives_Native.option ->
              Prims.string ->
                ('Auu____1705,'Auu____1706) FStar_TypeChecker_Common.problem
  =
  fun orig  ->
    fun lhs  ->
      fun rel  ->
        fun rhs  ->
          fun elt  ->
            fun reason  ->
              let uu____1739 = next_pid ()  in
              let uu____1740 = p_scope orig  in
              {
                FStar_TypeChecker_Common.pid = uu____1739;
                FStar_TypeChecker_Common.lhs = lhs;
                FStar_TypeChecker_Common.relation = rel;
                FStar_TypeChecker_Common.rhs = rhs;
                FStar_TypeChecker_Common.element = elt;
                FStar_TypeChecker_Common.logical_guard = (p_guard orig);
                FStar_TypeChecker_Common.scope = uu____1740;
                FStar_TypeChecker_Common.reason = (reason :: (p_reason orig));
                FStar_TypeChecker_Common.loc = (p_loc orig);
                FStar_TypeChecker_Common.rank = FStar_Pervasives_Native.None
              }
  
let guard_on_element :
  'Auu____1746 .
    worklist ->
      ('Auu____1746,FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
        FStar_TypeChecker_Common.problem ->
        FStar_Syntax_Syntax.bv ->
          FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ
  =
  fun wl  ->
    fun problem  ->
      fun x  ->
        fun phi  ->
          match problem.FStar_TypeChecker_Common.element with
          | FStar_Pervasives_Native.None  ->
              let u =
                (wl.tcenv).FStar_TypeChecker_Env.universe_of wl.tcenv
                  x.FStar_Syntax_Syntax.sort
                 in
              FStar_Syntax_Util.mk_forall u x phi
          | FStar_Pervasives_Native.Some e ->
              FStar_Syntax_Subst.subst [FStar_Syntax_Syntax.NT (x, e)] phi
  
let (explain :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Common.prob -> Prims.string -> Prims.string)
  =
  fun env  ->
    fun d  ->
      fun s  ->
        let uu____1796 =
          FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
            (FStar_Options.Other "ExplainRel")
           in
        if uu____1796
        then
          let uu____1797 =
            FStar_All.pipe_left FStar_Range.string_of_range (p_loc d)  in
          let uu____1798 = prob_to_string env d  in
          let uu____1799 =
            FStar_All.pipe_right (p_reason d) (FStar_String.concat "\n\t>")
             in
          FStar_Util.format4
            "(%s) Failed to solve the sub-problem\n%s\nWhich arose because:\n\t%s\nFailed because:%s\n"
            uu____1797 uu____1798 uu____1799 s
        else
          (let d1 = maybe_invert_p d  in
           let rel =
             match p_rel d1 with
             | FStar_TypeChecker_Common.EQ  -> "equal to"
             | FStar_TypeChecker_Common.SUB  -> "a subtype of"
             | uu____1805 -> failwith "impossible"  in
           let uu____1806 =
             match d1 with
             | FStar_TypeChecker_Common.TProb tp ->
                 let uu____1820 =
                   FStar_TypeChecker_Normalize.term_to_string env
                     tp.FStar_TypeChecker_Common.lhs
                    in
                 let uu____1821 =
                   FStar_TypeChecker_Normalize.term_to_string env
                     tp.FStar_TypeChecker_Common.rhs
                    in
                 (uu____1820, uu____1821)
             | FStar_TypeChecker_Common.CProb cp ->
                 let uu____1827 =
                   FStar_TypeChecker_Normalize.comp_to_string env
                     cp.FStar_TypeChecker_Common.lhs
                    in
                 let uu____1828 =
                   FStar_TypeChecker_Normalize.comp_to_string env
                     cp.FStar_TypeChecker_Common.rhs
                    in
                 (uu____1827, uu____1828)
              in
           match uu____1806 with
           | (lhs,rhs) ->
               FStar_Util.format3 "%s is not %s the expected type %s" lhs rel
                 rhs)
  
let (commit : uvi Prims.list -> Prims.unit) =
  fun uvis  ->
    FStar_All.pipe_right uvis
      (FStar_List.iter
         (fun uu___100_1844  ->
            match uu___100_1844 with
            | UNIV (u,t) ->
                (match t with
                 | FStar_Syntax_Syntax.U_unif u' ->
                     FStar_Syntax_Unionfind.univ_union u u'
                 | uu____1856 -> FStar_Syntax_Unionfind.univ_change u t)
            | TERM ((u,uu____1858),t) ->
                (def_check_closed t.FStar_Syntax_Syntax.pos "commit" t;
                 FStar_Syntax_Util.set_uvar u t)))
  
let (find_term_uvar :
  FStar_Syntax_Syntax.uvar ->
    uvi Prims.list -> FStar_Syntax_Syntax.term FStar_Pervasives_Native.option)
  =
  fun uv  ->
    fun s  ->
      FStar_Util.find_map s
        (fun uu___101_1879  ->
           match uu___101_1879 with
           | UNIV uu____1882 -> FStar_Pervasives_Native.None
           | TERM ((u,uu____1888),t) ->
               let uu____1894 = FStar_Syntax_Unionfind.equiv uv u  in
               if uu____1894
               then FStar_Pervasives_Native.Some t
               else FStar_Pervasives_Native.None)
  
let (find_univ_uvar :
  FStar_Syntax_Syntax.universe_uvar ->
    uvi Prims.list ->
      FStar_Syntax_Syntax.universe FStar_Pervasives_Native.option)
  =
  fun u  ->
    fun s  ->
      FStar_Util.find_map s
        (fun uu___102_1914  ->
           match uu___102_1914 with
           | UNIV (u',t) ->
               let uu____1919 = FStar_Syntax_Unionfind.univ_equiv u u'  in
               if uu____1919
               then FStar_Pervasives_Native.Some t
               else FStar_Pervasives_Native.None
           | uu____1923 -> FStar_Pervasives_Native.None)
  
let (whnf :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun t  ->
      let uu____1930 =
        let uu____1931 = FStar_Syntax_Util.unmeta t  in
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Normalize.Beta;
          FStar_TypeChecker_Normalize.Weak;
          FStar_TypeChecker_Normalize.HNF] env uu____1931
         in
      FStar_Syntax_Subst.compress uu____1930
  
let (sn :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun t  ->
      let uu____1938 =
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Normalize.Beta] env t
         in
      FStar_Syntax_Subst.compress uu____1938
  
let norm_arg :
  'Auu____1942 .
    FStar_TypeChecker_Env.env ->
      (FStar_Syntax_Syntax.term,'Auu____1942) FStar_Pervasives_Native.tuple2
        ->
        (FStar_Syntax_Syntax.term,'Auu____1942)
          FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun t  ->
      let uu____1963 = sn env (FStar_Pervasives_Native.fst t)  in
      (uu____1963, (FStar_Pervasives_Native.snd t))
  
let (sn_binders :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.binders ->
      (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
        FStar_Pervasives_Native.tuple2 Prims.list)
  =
  fun env  ->
    fun binders  ->
      FStar_All.pipe_right binders
        (FStar_List.map
           (fun uu____1994  ->
              match uu____1994 with
              | (x,imp) ->
                  let uu____2005 =
                    let uu___128_2006 = x  in
                    let uu____2007 = sn env x.FStar_Syntax_Syntax.sort  in
                    {
                      FStar_Syntax_Syntax.ppname =
                        (uu___128_2006.FStar_Syntax_Syntax.ppname);
                      FStar_Syntax_Syntax.index =
                        (uu___128_2006.FStar_Syntax_Syntax.index);
                      FStar_Syntax_Syntax.sort = uu____2007
                    }  in
                  (uu____2005, imp)))
  
let (norm_univ :
  worklist -> FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.universe) =
  fun wl  ->
    fun u  ->
      let rec aux u1 =
        let u2 = FStar_Syntax_Subst.compress_univ u1  in
        match u2 with
        | FStar_Syntax_Syntax.U_succ u3 ->
            let uu____2022 = aux u3  in FStar_Syntax_Syntax.U_succ uu____2022
        | FStar_Syntax_Syntax.U_max us ->
            let uu____2026 = FStar_List.map aux us  in
            FStar_Syntax_Syntax.U_max uu____2026
        | uu____2029 -> u2  in
      let uu____2030 = aux u  in
      FStar_TypeChecker_Normalize.normalize_universe wl.tcenv uu____2030
  
let (base_and_refinement_maybe_delta :
  Prims.bool ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term ->
        (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,(FStar_Syntax_Syntax.bv,
                                                                FStar_Syntax_Syntax.term'
                                                                  FStar_Syntax_Syntax.syntax)
                                                                FStar_Pervasives_Native.tuple2
                                                                FStar_Pervasives_Native.option)
          FStar_Pervasives_Native.tuple2)
  =
  fun should_delta  ->
    fun env  ->
      fun t1  ->
        let norm_refinement env1 t =
          let steps =
            if should_delta
            then
              [FStar_TypeChecker_Normalize.Weak;
              FStar_TypeChecker_Normalize.HNF;
              FStar_TypeChecker_Normalize.UnfoldUntil
                FStar_Syntax_Syntax.Delta_constant]
            else
              [FStar_TypeChecker_Normalize.Weak;
              FStar_TypeChecker_Normalize.HNF]
             in
          FStar_TypeChecker_Normalize.normalize_refinement steps env1 t  in
        let rec aux norm1 t11 =
          let t12 = FStar_Syntax_Util.unmeta t11  in
          match t12.FStar_Syntax_Syntax.n with
          | FStar_Syntax_Syntax.Tm_refine (x,phi) ->
              if norm1
              then
                ((x.FStar_Syntax_Syntax.sort),
                  (FStar_Pervasives_Native.Some (x, phi)))
              else
                (let uu____2142 = norm_refinement env t12  in
                 match uu____2142 with
                 | {
                     FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_refine
                       (x1,phi1);
                     FStar_Syntax_Syntax.pos = uu____2159;
                     FStar_Syntax_Syntax.vars = uu____2160;_} ->
                     ((x1.FStar_Syntax_Syntax.sort),
                       (FStar_Pervasives_Native.Some (x1, phi1)))
                 | tt ->
                     let uu____2186 =
                       let uu____2187 = FStar_Syntax_Print.term_to_string tt
                          in
                       let uu____2188 = FStar_Syntax_Print.tag_of_term tt  in
                       FStar_Util.format2 "impossible: Got %s ... %s\n"
                         uu____2187 uu____2188
                        in
                     failwith uu____2186)
          | FStar_Syntax_Syntax.Tm_lazy i ->
              let uu____2204 = FStar_Syntax_Util.unfold_lazy i  in
              aux norm1 uu____2204
          | FStar_Syntax_Syntax.Tm_uinst uu____2205 ->
              if norm1
              then (t12, FStar_Pervasives_Native.None)
              else
                (let t1' = norm_refinement env t12  in
                 let uu____2242 =
                   let uu____2243 = FStar_Syntax_Subst.compress t1'  in
                   uu____2243.FStar_Syntax_Syntax.n  in
                 match uu____2242 with
                 | FStar_Syntax_Syntax.Tm_refine uu____2260 -> aux true t1'
                 | uu____2267 -> (t12, FStar_Pervasives_Native.None))
          | FStar_Syntax_Syntax.Tm_fvar uu____2282 ->
              if norm1
              then (t12, FStar_Pervasives_Native.None)
              else
                (let t1' = norm_refinement env t12  in
                 let uu____2313 =
                   let uu____2314 = FStar_Syntax_Subst.compress t1'  in
                   uu____2314.FStar_Syntax_Syntax.n  in
                 match uu____2313 with
                 | FStar_Syntax_Syntax.Tm_refine uu____2331 -> aux true t1'
                 | uu____2338 -> (t12, FStar_Pervasives_Native.None))
          | FStar_Syntax_Syntax.Tm_app uu____2353 ->
              if norm1
              then (t12, FStar_Pervasives_Native.None)
              else
                (let t1' = norm_refinement env t12  in
                 let uu____2398 =
                   let uu____2399 = FStar_Syntax_Subst.compress t1'  in
                   uu____2399.FStar_Syntax_Syntax.n  in
                 match uu____2398 with
                 | FStar_Syntax_Syntax.Tm_refine uu____2416 -> aux true t1'
                 | uu____2423 -> (t12, FStar_Pervasives_Native.None))
          | FStar_Syntax_Syntax.Tm_type uu____2438 ->
              (t12, FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Tm_constant uu____2453 ->
              (t12, FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Tm_name uu____2468 ->
              (t12, FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Tm_bvar uu____2483 ->
              (t12, FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Tm_arrow uu____2498 ->
              (t12, FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Tm_abs uu____2525 ->
              (t12, FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Tm_quoted uu____2556 ->
              (t12, FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Tm_uvar uu____2577 ->
              (t12, FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Tm_let uu____2608 ->
              (t12, FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Tm_match uu____2635 ->
              (t12, FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Tm_meta uu____2672 ->
              let uu____2679 =
                let uu____2680 = FStar_Syntax_Print.term_to_string t12  in
                let uu____2681 = FStar_Syntax_Print.tag_of_term t12  in
                FStar_Util.format2 "impossible (outer): Got %s ... %s\n"
                  uu____2680 uu____2681
                 in
              failwith uu____2679
          | FStar_Syntax_Syntax.Tm_ascribed uu____2696 ->
              let uu____2723 =
                let uu____2724 = FStar_Syntax_Print.term_to_string t12  in
                let uu____2725 = FStar_Syntax_Print.tag_of_term t12  in
                FStar_Util.format2 "impossible (outer): Got %s ... %s\n"
                  uu____2724 uu____2725
                 in
              failwith uu____2723
          | FStar_Syntax_Syntax.Tm_delayed uu____2740 ->
              let uu____2765 =
                let uu____2766 = FStar_Syntax_Print.term_to_string t12  in
                let uu____2767 = FStar_Syntax_Print.tag_of_term t12  in
                FStar_Util.format2 "impossible (outer): Got %s ... %s\n"
                  uu____2766 uu____2767
                 in
              failwith uu____2765
          | FStar_Syntax_Syntax.Tm_unknown  ->
              let uu____2782 =
                let uu____2783 = FStar_Syntax_Print.term_to_string t12  in
                let uu____2784 = FStar_Syntax_Print.tag_of_term t12  in
                FStar_Util.format2 "impossible (outer): Got %s ... %s\n"
                  uu____2783 uu____2784
                 in
              failwith uu____2782
           in
        let uu____2799 = whnf env t1  in aux false uu____2799
  
let (base_and_refinement :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      (FStar_Syntax_Syntax.term,(FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.term)
                                  FStar_Pervasives_Native.tuple2
                                  FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple2)
  = fun env  -> fun t  -> base_and_refinement_maybe_delta false env t 
let normalize_refinement :
  'Auu____2821 .
    FStar_TypeChecker_Normalize.steps ->
      FStar_TypeChecker_Env.env ->
        'Auu____2821 -> FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ
  =
  fun steps  ->
    fun env  ->
      fun wl  ->
        fun t0  ->
          FStar_TypeChecker_Normalize.normalize_refinement steps env t0
  
let (unrefine :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ)
  =
  fun env  ->
    fun t  ->
      let uu____2844 = base_and_refinement env t  in
      FStar_All.pipe_right uu____2844 FStar_Pervasives_Native.fst
  
let (trivial_refinement :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2)
  =
  fun t  ->
    let uu____2878 = FStar_Syntax_Syntax.null_bv t  in
    (uu____2878, FStar_Syntax_Util.t_true)
  
let as_refinement :
  'Auu____2884 .
    Prims.bool ->
      FStar_TypeChecker_Env.env ->
        'Auu____2884 ->
          FStar_Syntax_Syntax.term ->
            (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.term)
              FStar_Pervasives_Native.tuple2
  =
  fun delta1  ->
    fun env  ->
      fun wl  ->
        fun t  ->
          let uu____2905 = base_and_refinement_maybe_delta delta1 env t  in
          match uu____2905 with
          | (t_base,refinement) ->
              (match refinement with
               | FStar_Pervasives_Native.None  -> trivial_refinement t_base
               | FStar_Pervasives_Native.Some (x,phi) -> (x, phi))
  
let (force_refinement :
  (FStar_Syntax_Syntax.term,(FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.term)
                              FStar_Pervasives_Native.tuple2
                              FStar_Pervasives_Native.option)
    FStar_Pervasives_Native.tuple2 ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun uu____2984  ->
    match uu____2984 with
    | (t_base,refopt) ->
        let uu____3011 =
          match refopt with
          | FStar_Pervasives_Native.Some (y,phi) -> (y, phi)
          | FStar_Pervasives_Native.None  -> trivial_refinement t_base  in
        (match uu____3011 with
         | (y,phi) ->
             FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_refine (y, phi))
               FStar_Pervasives_Native.None t_base.FStar_Syntax_Syntax.pos)
  
let (wl_prob_to_string :
  worklist -> FStar_TypeChecker_Common.prob -> Prims.string) =
  fun wl  -> fun prob  -> prob_to_string wl.tcenv prob 
let (wl_to_string : worklist -> Prims.string) =
  fun wl  ->
    let uu____3043 =
      let uu____3046 =
        let uu____3049 =
          FStar_All.pipe_right wl.wl_deferred
            (FStar_List.map
               (fun uu____3072  ->
                  match uu____3072 with | (uu____3079,uu____3080,x) -> x))
           in
        FStar_List.append wl.attempting uu____3049  in
      FStar_List.map (wl_prob_to_string wl) uu____3046  in
    FStar_All.pipe_right uu____3043 (FStar_String.concat "\n\t")
  
let (u_abs :
  FStar_Syntax_Syntax.typ ->
    FStar_Syntax_Syntax.binders ->
      FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun k  ->
    fun ys  ->
      fun t  ->
        let uu____3093 =
          let uu____3106 =
            let uu____3107 = FStar_Syntax_Subst.compress k  in
            uu____3107.FStar_Syntax_Syntax.n  in
          match uu____3106 with
          | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
              if (FStar_List.length bs) = (FStar_List.length ys)
              then
                let uu____3160 = FStar_Syntax_Subst.open_comp bs c  in
                ((ys, t), uu____3160)
              else
                (let uu____3174 = FStar_Syntax_Util.abs_formals t  in
                 match uu____3174 with
                 | (ys',t1,uu____3197) ->
                     let uu____3202 = FStar_Syntax_Util.arrow_formals_comp k
                        in
                     (((FStar_List.append ys ys'), t1), uu____3202))
          | uu____3243 ->
              let uu____3244 =
                let uu____3255 = FStar_Syntax_Syntax.mk_Total k  in
                ([], uu____3255)  in
              ((ys, t), uu____3244)
           in
        match uu____3093 with
        | ((ys1,t1),(xs,c)) ->
            if (FStar_List.length xs) <> (FStar_List.length ys1)
            then
              FStar_Syntax_Util.abs ys1 t1
                (FStar_Pervasives_Native.Some
                   (FStar_Syntax_Util.mk_residual_comp
                      FStar_Parser_Const.effect_Tot_lid
                      FStar_Pervasives_Native.None []))
            else
              (let c1 =
                 let uu____3304 = FStar_Syntax_Util.rename_binders xs ys1  in
                 FStar_Syntax_Subst.subst_comp uu____3304 c  in
               FStar_Syntax_Util.abs ys1 t1
                 (FStar_Pervasives_Native.Some
                    (FStar_Syntax_Util.residual_comp_of_comp c1)))
  
let (solve_prob' :
  Prims.bool ->
    FStar_TypeChecker_Common.prob ->
      FStar_Syntax_Syntax.term FStar_Pervasives_Native.option ->
        uvi Prims.list -> worklist -> worklist)
  =
  fun resolve_ok  ->
    fun prob  ->
      fun logical_guard  ->
        fun uvis  ->
          fun wl  ->
            def_check_prob "solve_prob'" prob;
            (let phi =
               match logical_guard with
               | FStar_Pervasives_Native.None  -> FStar_Syntax_Util.t_true
               | FStar_Pervasives_Native.Some phi -> phi  in
             let uu____3333 = p_guard prob  in
             match uu____3333 with
             | (uu____3338,uv) ->
                 ((let uu____3341 =
                     let uu____3342 = FStar_Syntax_Subst.compress uv  in
                     uu____3342.FStar_Syntax_Syntax.n  in
                   match uu____3341 with
                   | FStar_Syntax_Syntax.Tm_uvar (uvar,k) ->
                       let bs = p_scope prob  in
                       let phi1 = u_abs k bs phi  in
                       ((let uu____3374 =
                           FStar_All.pipe_left
                             (FStar_TypeChecker_Env.debug wl.tcenv)
                             (FStar_Options.Other "Rel")
                            in
                         if uu____3374
                         then
                           let uu____3375 =
                             FStar_Util.string_of_int (p_pid prob)  in
                           let uu____3376 =
                             FStar_Syntax_Print.term_to_string uv  in
                           let uu____3377 =
                             FStar_Syntax_Print.term_to_string phi1  in
                           FStar_Util.print3
                             "Solving %s (%s) with formula %s\n" uu____3375
                             uu____3376 uu____3377
                         else ());
                        def_check_closed (p_loc prob) "solve_prob'" phi1;
                        FStar_Syntax_Util.set_uvar uvar phi1)
                   | uu____3380 ->
                       if Prims.op_Negation resolve_ok
                       then
                         failwith
                           "Impossible: this instance has already been assigned a solution"
                       else ());
                  commit uvis;
                  (let uu___129_3383 = wl  in
                   {
                     attempting = (uu___129_3383.attempting);
                     wl_deferred = (uu___129_3383.wl_deferred);
                     ctr = (wl.ctr + (Prims.parse_int "1"));
                     defer_ok = (uu___129_3383.defer_ok);
                     smt_ok = (uu___129_3383.smt_ok);
                     tcenv = (uu___129_3383.tcenv)
                   })))
  
let (extend_solution : Prims.int -> uvi Prims.list -> worklist -> worklist) =
  fun pid  ->
    fun sol  ->
      fun wl  ->
        (let uu____3398 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug wl.tcenv)
             (FStar_Options.Other "RelCheck")
            in
         if uu____3398
         then
           let uu____3399 = FStar_Util.string_of_int pid  in
           let uu____3400 =
             let uu____3401 = FStar_List.map (uvi_to_string wl.tcenv) sol  in
             FStar_All.pipe_right uu____3401 (FStar_String.concat ", ")  in
           FStar_Util.print2 "Solving %s: with %s\n" uu____3399 uu____3400
         else ());
        commit sol;
        (let uu___130_3408 = wl  in
         {
           attempting = (uu___130_3408.attempting);
           wl_deferred = (uu___130_3408.wl_deferred);
           ctr = (wl.ctr + (Prims.parse_int "1"));
           defer_ok = (uu___130_3408.defer_ok);
           smt_ok = (uu___130_3408.smt_ok);
           tcenv = (uu___130_3408.tcenv)
         })
  
let (solve_prob :
  FStar_TypeChecker_Common.prob ->
    FStar_Syntax_Syntax.term FStar_Pervasives_Native.option ->
      uvi Prims.list -> worklist -> worklist)
  =
  fun prob  ->
    fun logical_guard  ->
      fun uvis  ->
        fun wl  ->
          def_check_prob "solve_prob.prob" prob;
          FStar_Util.iter_opt logical_guard
            (def_check_scoped "solve_prob.guard" prob);
          (let conj_guard1 t g =
             match (t, g) with
             | (uu____3448,FStar_TypeChecker_Common.Trivial ) -> t
             | (FStar_Pervasives_Native.None
                ,FStar_TypeChecker_Common.NonTrivial f) ->
                 FStar_Pervasives_Native.Some f
             | (FStar_Pervasives_Native.Some
                t1,FStar_TypeChecker_Common.NonTrivial f) ->
                 let uu____3460 = FStar_Syntax_Util.mk_conj t1 f  in
                 FStar_Pervasives_Native.Some uu____3460
              in
           (let uu____3466 =
              FStar_All.pipe_left (FStar_TypeChecker_Env.debug wl.tcenv)
                (FStar_Options.Other "RelCheck")
               in
            if uu____3466
            then
              let uu____3467 =
                FStar_All.pipe_left FStar_Util.string_of_int (p_pid prob)  in
              let uu____3468 =
                let uu____3469 = FStar_List.map (uvi_to_string wl.tcenv) uvis
                   in
                FStar_All.pipe_right uu____3469 (FStar_String.concat ", ")
                 in
              FStar_Util.print2 "Solving %s: with %s\n" uu____3467 uu____3468
            else ());
           solve_prob' false prob logical_guard uvis wl)
  
let rec occurs :
  'b .
    worklist ->
      (FStar_Syntax_Syntax.uvar,'b) FStar_Pervasives_Native.tuple2 ->
        FStar_Syntax_Syntax.typ -> Prims.bool
  =
  fun wl  ->
    fun uk  ->
      fun t  ->
        let uu____3501 =
          let uu____3508 = FStar_Syntax_Free.uvars t  in
          FStar_All.pipe_right uu____3508 FStar_Util.set_elements  in
        FStar_All.pipe_right uu____3501
          (FStar_Util.for_some
             (fun uu____3544  ->
                match uu____3544 with
                | (uv,uu____3550) ->
                    FStar_Syntax_Unionfind.equiv uv
                      (FStar_Pervasives_Native.fst uk)))
  
let occurs_check :
  'Auu____3557 'Auu____3558 .
    'Auu____3557 ->
      worklist ->
        (FStar_Syntax_Syntax.uvar,'Auu____3558)
          FStar_Pervasives_Native.tuple2 ->
          FStar_Syntax_Syntax.typ ->
            (Prims.bool,Prims.string FStar_Pervasives_Native.option)
              FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun wl  ->
      fun uk  ->
        fun t  ->
          let occurs_ok =
            let uu____3590 = occurs wl uk t  in Prims.op_Negation uu____3590
             in
          let msg =
            if occurs_ok
            then FStar_Pervasives_Native.None
            else
              (let uu____3597 =
                 let uu____3598 =
                   FStar_Syntax_Print.uvar_to_string
                     (FStar_Pervasives_Native.fst uk)
                    in
                 let uu____3599 = FStar_Syntax_Print.term_to_string t  in
                 FStar_Util.format2 "occurs-check failed (%s occurs in %s)"
                   uu____3598 uu____3599
                  in
               FStar_Pervasives_Native.Some uu____3597)
             in
          (occurs_ok, msg)
  
let occurs_and_freevars_check :
  'Auu____3609 'Auu____3610 .
    'Auu____3609 ->
      worklist ->
        (FStar_Syntax_Syntax.uvar,'Auu____3610)
          FStar_Pervasives_Native.tuple2 ->
          FStar_Syntax_Syntax.bv FStar_Util.set ->
            FStar_Syntax_Syntax.term ->
              (Prims.bool,Prims.bool,(Prims.string
                                        FStar_Pervasives_Native.option,
                                       FStar_Syntax_Syntax.bv FStar_Util.set,
                                       FStar_Syntax_Syntax.bv FStar_Util.set)
                                       FStar_Pervasives_Native.tuple3)
                FStar_Pervasives_Native.tuple3
  =
  fun env  ->
    fun wl  ->
      fun uk  ->
        fun fvs  ->
          fun t  ->
            let fvs_t = FStar_Syntax_Free.names t  in
            let uu____3664 = occurs_check env wl uk t  in
            match uu____3664 with
            | (occurs_ok,msg) ->
                let uu____3695 = FStar_Util.set_is_subset_of fvs_t fvs  in
                (occurs_ok, uu____3695, (msg, fvs, fvs_t))
  
let intersect_vars :
  'Auu____3718 'Auu____3719 .
    (FStar_Syntax_Syntax.bv,'Auu____3718) FStar_Pervasives_Native.tuple2
      Prims.list ->
      (FStar_Syntax_Syntax.bv,'Auu____3719) FStar_Pervasives_Native.tuple2
        Prims.list ->
        (FStar_Syntax_Syntax.bv,'Auu____3719) FStar_Pervasives_Native.tuple2
          Prims.list
  =
  fun v1  ->
    fun v2  ->
      let as_set1 v3 =
        FStar_All.pipe_right v3
          (FStar_List.fold_left
             (fun out  ->
                fun x  ->
                  FStar_Util.set_add (FStar_Pervasives_Native.fst x) out)
             FStar_Syntax_Syntax.no_names)
         in
      let v1_set = as_set1 v1  in
      let uu____3803 =
        FStar_All.pipe_right v2
          (FStar_List.fold_left
             (fun uu____3857  ->
                fun uu____3858  ->
                  match (uu____3857, uu____3858) with
                  | ((isect,isect_set),(x,imp)) ->
                      let uu____3939 =
                        let uu____3940 = FStar_Util.set_mem x v1_set  in
                        FStar_All.pipe_left Prims.op_Negation uu____3940  in
                      if uu____3939
                      then (isect, isect_set)
                      else
                        (let fvs =
                           FStar_Syntax_Free.names x.FStar_Syntax_Syntax.sort
                            in
                         let uu____3965 =
                           FStar_Util.set_is_subset_of fvs isect_set  in
                         if uu____3965
                         then
                           let uu____3978 = FStar_Util.set_add x isect_set
                              in
                           (((x, imp) :: isect), uu____3978)
                         else (isect, isect_set)))
             ([], FStar_Syntax_Syntax.no_names))
         in
      match uu____3803 with | (isect,uu____4019) -> FStar_List.rev isect
  
let binders_eq :
  'Auu____4044 'Auu____4045 .
    (FStar_Syntax_Syntax.bv,'Auu____4044) FStar_Pervasives_Native.tuple2
      Prims.list ->
      (FStar_Syntax_Syntax.bv,'Auu____4045) FStar_Pervasives_Native.tuple2
        Prims.list -> Prims.bool
  =
  fun v1  ->
    fun v2  ->
      ((FStar_List.length v1) = (FStar_List.length v2)) &&
        (FStar_List.forall2
           (fun uu____4100  ->
              fun uu____4101  ->
                match (uu____4100, uu____4101) with
                | ((a,uu____4119),(b,uu____4121)) ->
                    FStar_Syntax_Syntax.bv_eq a b) v1 v2)
  
let pat_var_opt :
  'Auu____4135 'Auu____4136 .
    FStar_TypeChecker_Env.env ->
      (FStar_Syntax_Syntax.bv,'Auu____4135) FStar_Pervasives_Native.tuple2
        Prims.list ->
        (FStar_Syntax_Syntax.term,'Auu____4136)
          FStar_Pervasives_Native.tuple2 ->
          (FStar_Syntax_Syntax.bv,'Auu____4136)
            FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option
  =
  fun env  ->
    fun seen  ->
      fun arg  ->
        let hd1 = norm_arg env arg  in
        match (FStar_Pervasives_Native.fst hd1).FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Tm_name a ->
            let uu____4187 =
              FStar_All.pipe_right seen
                (FStar_Util.for_some
                   (fun uu____4201  ->
                      match uu____4201 with
                      | (b,uu____4207) -> FStar_Syntax_Syntax.bv_eq a b))
               in
            if uu____4187
            then FStar_Pervasives_Native.None
            else
              FStar_Pervasives_Native.Some
                (a, (FStar_Pervasives_Native.snd hd1))
        | uu____4223 -> FStar_Pervasives_Native.None
  
let rec (pat_vars :
  FStar_TypeChecker_Env.env ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.aqual)
        FStar_Pervasives_Native.tuple2 Prims.list ->
        FStar_Syntax_Syntax.binders FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun seen  ->
      fun args  ->
        match args with
        | [] -> FStar_Pervasives_Native.Some (FStar_List.rev seen)
        | hd1::rest ->
            let uu____4296 = pat_var_opt env seen hd1  in
            (match uu____4296 with
             | FStar_Pervasives_Native.None  ->
                 ((let uu____4310 =
                     FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                       (FStar_Options.Other "Rel")
                      in
                   if uu____4310
                   then
                     let uu____4311 =
                       FStar_All.pipe_left FStar_Syntax_Print.term_to_string
                         (FStar_Pervasives_Native.fst hd1)
                        in
                     FStar_Util.print1 "Not a pattern: %s\n" uu____4311
                   else ());
                  FStar_Pervasives_Native.None)
             | FStar_Pervasives_Native.Some x ->
                 pat_vars env (x :: seen) rest)
  
let (is_flex : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t  ->
    let uu____4329 =
      let uu____4330 = FStar_Syntax_Subst.compress t  in
      uu____4330.FStar_Syntax_Syntax.n  in
    match uu____4329 with
    | FStar_Syntax_Syntax.Tm_uvar uu____4333 -> true
    | FStar_Syntax_Syntax.Tm_app
        ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar uu____4350;
           FStar_Syntax_Syntax.pos = uu____4351;
           FStar_Syntax_Syntax.vars = uu____4352;_},uu____4353)
        -> true
    | uu____4390 -> false
  
let (destruct_flex_t :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,(FStar_Syntax_Syntax.term'
                                                             FStar_Syntax_Syntax.syntax
                                                             FStar_Pervasives_Native.option
                                                             FStar_Unionfind.p_uvar,
                                                            FStar_Syntax_Syntax.version)
                                                            FStar_Pervasives_Native.tuple2,
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,(FStar_Syntax_Syntax.term'
                                                              FStar_Syntax_Syntax.syntax,
                                                             FStar_Syntax_Syntax.aqual)
                                                             FStar_Pervasives_Native.tuple2
                                                             Prims.list)
      FStar_Pervasives_Native.tuple4)
  =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_uvar (uv,k) -> (t, uv, k, [])
    | FStar_Syntax_Syntax.Tm_app
        ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar (uv,k);
           FStar_Syntax_Syntax.pos = uu____4514;
           FStar_Syntax_Syntax.vars = uu____4515;_},args)
        -> (t, uv, k, args)
    | uu____4583 -> failwith "Not a flex-uvar"
  
let (destruct_flex_pattern :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      ((FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,(FStar_Syntax_Syntax.term'
                                                                FStar_Syntax_Syntax.syntax
                                                                FStar_Pervasives_Native.option
                                                                FStar_Unionfind.p_uvar,
                                                               FStar_Syntax_Syntax.version)
                                                               FStar_Pervasives_Native.tuple2,
         FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,(FStar_Syntax_Syntax.term'
                                                                 FStar_Syntax_Syntax.syntax,
                                                                FStar_Syntax_Syntax.aqual)
                                                                FStar_Pervasives_Native.tuple2
                                                                Prims.list)
         FStar_Pervasives_Native.tuple4,FStar_Syntax_Syntax.binders
                                          FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun t  ->
      let uu____4660 = destruct_flex_t t  in
      match uu____4660 with
      | (t1,uv,k,args) ->
          let uu____4775 = pat_vars env [] args  in
          (match uu____4775 with
           | FStar_Pervasives_Native.Some vars ->
               ((t1, uv, k, args), (FStar_Pervasives_Native.Some vars))
           | uu____4873 -> ((t1, uv, k, args), FStar_Pervasives_Native.None))
  
type match_result =
  | MisMatch of
  (FStar_Syntax_Syntax.delta_depth FStar_Pervasives_Native.option,FStar_Syntax_Syntax.delta_depth
                                                                    FStar_Pervasives_Native.option)
  FStar_Pervasives_Native.tuple2 
  | HeadMatch 
  | FullMatch [@@deriving show]
let (uu___is_MisMatch : match_result -> Prims.bool) =
  fun projectee  ->
    match projectee with | MisMatch _0 -> true | uu____4954 -> false
  
let (__proj__MisMatch__item___0 :
  match_result ->
    (FStar_Syntax_Syntax.delta_depth FStar_Pervasives_Native.option,FStar_Syntax_Syntax.delta_depth
                                                                    FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | MisMatch _0 -> _0 
let (uu___is_HeadMatch : match_result -> Prims.bool) =
  fun projectee  ->
    match projectee with | HeadMatch  -> true | uu____4989 -> false
  
let (uu___is_FullMatch : match_result -> Prims.bool) =
  fun projectee  ->
    match projectee with | FullMatch  -> true | uu____4993 -> false
  
let string_of_option :
  'Auu____4997 .
    ('Auu____4997 -> Prims.string) ->
      'Auu____4997 FStar_Pervasives_Native.option -> Prims.string
  =
  fun f  ->
    fun uu___103_5010  ->
      match uu___103_5010 with
      | FStar_Pervasives_Native.None  -> "None"
      | FStar_Pervasives_Native.Some x ->
          let uu____5016 = f x  in Prims.strcat "Some " uu____5016
  
let (string_of_match_result : match_result -> Prims.string) =
  fun uu___104_5019  ->
    match uu___104_5019 with
    | MisMatch (d1,d2) ->
        let uu____5030 =
          let uu____5031 =
            string_of_option FStar_Syntax_Print.delta_depth_to_string d1  in
          let uu____5032 =
            let uu____5033 =
              let uu____5034 =
                string_of_option FStar_Syntax_Print.delta_depth_to_string d2
                 in
              Prims.strcat uu____5034 ")"  in
            Prims.strcat ") (" uu____5033  in
          Prims.strcat uu____5031 uu____5032  in
        Prims.strcat "MisMatch (" uu____5030
    | HeadMatch  -> "HeadMatch"
    | FullMatch  -> "FullMatch"
  
let (head_match : match_result -> match_result) =
  fun uu___105_5037  ->
    match uu___105_5037 with
    | MisMatch (i,j) -> MisMatch (i, j)
    | uu____5052 -> HeadMatch
  
let (and_match :
  match_result -> (Prims.unit -> match_result) -> match_result) =
  fun m1  ->
    fun m2  ->
      match m1 with
      | MisMatch (i,j) -> MisMatch (i, j)
      | HeadMatch  ->
          let uu____5078 = m2 ()  in
          (match uu____5078 with
           | MisMatch (i,j) -> MisMatch (i, j)
           | uu____5093 -> HeadMatch)
      | FullMatch  -> m2 ()
  
let (fv_delta_depth :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.fv -> FStar_Syntax_Syntax.delta_depth)
  =
  fun env  ->
    fun fv  ->
      match fv.FStar_Syntax_Syntax.fv_delta with
      | FStar_Syntax_Syntax.Delta_abstract d ->
          if
            ((env.FStar_TypeChecker_Env.curmodule).FStar_Ident.str =
               ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.nsstr)
              && (Prims.op_Negation env.FStar_TypeChecker_Env.is_iface)
          then d
          else FStar_Syntax_Syntax.Delta_constant
      | FStar_Syntax_Syntax.Delta_defined_at_level uu____5102 ->
          let uu____5103 =
            FStar_TypeChecker_Env.lookup_definition
              [FStar_TypeChecker_Env.Unfold
                 FStar_Syntax_Syntax.Delta_constant] env
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
             in
          (match uu____5103 with
           | FStar_Pervasives_Native.None  ->
               FStar_Syntax_Syntax.Delta_constant
           | uu____5114 -> fv.FStar_Syntax_Syntax.fv_delta)
      | d -> d
  
let rec (delta_depth_of_term :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.delta_depth FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun t  ->
      let t1 = FStar_Syntax_Util.unmeta t  in
      match t1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_meta uu____5133 -> failwith "Impossible"
      | FStar_Syntax_Syntax.Tm_delayed uu____5142 -> failwith "Impossible"
      | FStar_Syntax_Syntax.Tm_lazy i ->
          let uu____5170 = FStar_Syntax_Util.unfold_lazy i  in
          delta_depth_of_term env uu____5170
      | FStar_Syntax_Syntax.Tm_unknown  -> FStar_Pervasives_Native.None
      | FStar_Syntax_Syntax.Tm_bvar uu____5171 ->
          FStar_Pervasives_Native.None
      | FStar_Syntax_Syntax.Tm_name uu____5172 ->
          FStar_Pervasives_Native.None
      | FStar_Syntax_Syntax.Tm_uvar uu____5173 ->
          FStar_Pervasives_Native.None
      | FStar_Syntax_Syntax.Tm_let uu____5190 -> FStar_Pervasives_Native.None
      | FStar_Syntax_Syntax.Tm_match uu____5203 ->
          FStar_Pervasives_Native.None
      | FStar_Syntax_Syntax.Tm_uinst (t2,uu____5227) ->
          delta_depth_of_term env t2
      | FStar_Syntax_Syntax.Tm_ascribed (t2,uu____5233,uu____5234) ->
          delta_depth_of_term env t2
      | FStar_Syntax_Syntax.Tm_app (t2,uu____5276) ->
          delta_depth_of_term env t2
      | FStar_Syntax_Syntax.Tm_refine
          ({ FStar_Syntax_Syntax.ppname = uu____5297;
             FStar_Syntax_Syntax.index = uu____5298;
             FStar_Syntax_Syntax.sort = t2;_},uu____5300)
          -> delta_depth_of_term env t2
      | FStar_Syntax_Syntax.Tm_constant uu____5307 ->
          FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Delta_constant
      | FStar_Syntax_Syntax.Tm_type uu____5308 ->
          FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Delta_constant
      | FStar_Syntax_Syntax.Tm_arrow uu____5309 ->
          FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Delta_constant
      | FStar_Syntax_Syntax.Tm_quoted uu____5322 ->
          FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Delta_constant
      | FStar_Syntax_Syntax.Tm_abs uu____5329 ->
          FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Delta_constant
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          let uu____5347 = fv_delta_depth env fv  in
          FStar_Pervasives_Native.Some uu____5347
  
let rec (head_matches :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> match_result)
  =
  fun env  ->
    fun t1  ->
      fun t2  ->
        let t11 = FStar_Syntax_Util.unmeta t1  in
        let t21 = FStar_Syntax_Util.unmeta t2  in
        match ((t11.FStar_Syntax_Syntax.n), (t21.FStar_Syntax_Syntax.n)) with
        | (FStar_Syntax_Syntax.Tm_name x,FStar_Syntax_Syntax.Tm_name y) ->
            if FStar_Syntax_Syntax.bv_eq x y
            then FullMatch
            else
              MisMatch
                (FStar_Pervasives_Native.None, FStar_Pervasives_Native.None)
        | (FStar_Syntax_Syntax.Tm_fvar f,FStar_Syntax_Syntax.Tm_fvar g) ->
            let uu____5368 = FStar_Syntax_Syntax.fv_eq f g  in
            if uu____5368
            then FullMatch
            else
              (let uu____5370 =
                 let uu____5379 =
                   let uu____5382 = fv_delta_depth env f  in
                   FStar_Pervasives_Native.Some uu____5382  in
                 let uu____5383 =
                   let uu____5386 = fv_delta_depth env g  in
                   FStar_Pervasives_Native.Some uu____5386  in
                 (uu____5379, uu____5383)  in
               MisMatch uu____5370)
        | (FStar_Syntax_Syntax.Tm_uinst
           (f,uu____5392),FStar_Syntax_Syntax.Tm_uinst (g,uu____5394)) ->
            let uu____5403 = head_matches env f g  in
            FStar_All.pipe_right uu____5403 head_match
        | (FStar_Syntax_Syntax.Tm_constant c,FStar_Syntax_Syntax.Tm_constant
           d) ->
            let uu____5406 = FStar_Const.eq_const c d  in
            if uu____5406
            then FullMatch
            else
              MisMatch
                (FStar_Pervasives_Native.None, FStar_Pervasives_Native.None)
        | (FStar_Syntax_Syntax.Tm_uvar
           (uv,uu____5413),FStar_Syntax_Syntax.Tm_uvar (uv',uu____5415)) ->
            let uu____5464 = FStar_Syntax_Unionfind.equiv uv uv'  in
            if uu____5464
            then FullMatch
            else
              MisMatch
                (FStar_Pervasives_Native.None, FStar_Pervasives_Native.None)
        | (FStar_Syntax_Syntax.Tm_refine
           (x,uu____5471),FStar_Syntax_Syntax.Tm_refine (y,uu____5473)) ->
            let uu____5482 =
              head_matches env x.FStar_Syntax_Syntax.sort
                y.FStar_Syntax_Syntax.sort
               in
            FStar_All.pipe_right uu____5482 head_match
        | (FStar_Syntax_Syntax.Tm_refine (x,uu____5484),uu____5485) ->
            let uu____5490 = head_matches env x.FStar_Syntax_Syntax.sort t21
               in
            FStar_All.pipe_right uu____5490 head_match
        | (uu____5491,FStar_Syntax_Syntax.Tm_refine (x,uu____5493)) ->
            let uu____5498 = head_matches env t11 x.FStar_Syntax_Syntax.sort
               in
            FStar_All.pipe_right uu____5498 head_match
        | (FStar_Syntax_Syntax.Tm_type uu____5499,FStar_Syntax_Syntax.Tm_type
           uu____5500) -> HeadMatch
        | (FStar_Syntax_Syntax.Tm_arrow
           uu____5501,FStar_Syntax_Syntax.Tm_arrow uu____5502) -> HeadMatch
        | (FStar_Syntax_Syntax.Tm_match
           uu____5527,FStar_Syntax_Syntax.Tm_match uu____5528) ->
            ((let uu____5574 =
                FStar_TypeChecker_Env.debug env
                  (FStar_Options.Other "RelDelta")
                 in
              if uu____5574
              then
                FStar_ST.op_Colon_Equals FStar_Syntax_Util.debug_term_eq true
              else ());
             (let uu____5595 = FStar_Syntax_Util.term_eq t11 t21  in
              if uu____5595
              then FullMatch
              else
                MisMatch
                  (FStar_Pervasives_Native.None,
                    FStar_Pervasives_Native.None)))
        | (FStar_Syntax_Syntax.Tm_app
           (head1,uu____5602),FStar_Syntax_Syntax.Tm_app (head',uu____5604))
            ->
            let uu____5645 = head_matches env head1 head'  in
            FStar_All.pipe_right uu____5645 head_match
        | (FStar_Syntax_Syntax.Tm_app (head1,uu____5647),uu____5648) ->
            let uu____5669 = head_matches env head1 t21  in
            FStar_All.pipe_right uu____5669 head_match
        | (uu____5670,FStar_Syntax_Syntax.Tm_app (head1,uu____5672)) ->
            let uu____5693 = head_matches env t11 head1  in
            FStar_All.pipe_right uu____5693 head_match
        | uu____5694 ->
            let uu____5699 =
              let uu____5708 = delta_depth_of_term env t11  in
              let uu____5711 = delta_depth_of_term env t21  in
              (uu____5708, uu____5711)  in
            MisMatch uu____5699
  
let head_matches_delta :
  'Auu____5723 .
    FStar_TypeChecker_Env.env ->
      'Auu____5723 ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.term ->
            (match_result,(FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.typ)
                            FStar_Pervasives_Native.tuple2
                            FStar_Pervasives_Native.option)
              FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun wl  ->
      fun t1  ->
        fun t2  ->
          let maybe_inline t =
            let uu____5756 = FStar_Syntax_Util.head_and_args t  in
            match uu____5756 with
            | (head1,uu____5774) ->
                let uu____5795 =
                  let uu____5796 = FStar_Syntax_Util.un_uinst head1  in
                  uu____5796.FStar_Syntax_Syntax.n  in
                (match uu____5795 with
                 | FStar_Syntax_Syntax.Tm_fvar fv ->
                     let uu____5802 =
                       let uu____5803 =
                         FStar_TypeChecker_Env.lookup_definition
                           [FStar_TypeChecker_Env.Eager_unfolding_only] env
                           (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                          in
                       FStar_All.pipe_right uu____5803 FStar_Option.isSome
                        in
                     if uu____5802
                     then
                       let uu____5822 =
                         FStar_TypeChecker_Normalize.normalize
                           [FStar_TypeChecker_Normalize.Beta;
                           FStar_TypeChecker_Normalize.Eager_unfolding] env t
                          in
                       FStar_All.pipe_right uu____5822
                         (fun _0_45  -> FStar_Pervasives_Native.Some _0_45)
                     else FStar_Pervasives_Native.None
                 | uu____5826 -> FStar_Pervasives_Native.None)
             in
          let success d r t11 t21 =
            (r,
              (if d > (Prims.parse_int "0")
               then FStar_Pervasives_Native.Some (t11, t21)
               else FStar_Pervasives_Native.None))
             in
          let fail1 r = (r, FStar_Pervasives_Native.None)  in
          let rec aux retry n_delta t11 t21 =
            let r = head_matches env t11 t21  in
            match r with
            | MisMatch
                (FStar_Pervasives_Native.Some
                 (FStar_Syntax_Syntax.Delta_equational ),uu____5929)
                ->
                if Prims.op_Negation retry
                then fail1 r
                else
                  (let uu____5947 =
                     let uu____5956 = maybe_inline t11  in
                     let uu____5959 = maybe_inline t21  in
                     (uu____5956, uu____5959)  in
                   match uu____5947 with
                   | (FStar_Pervasives_Native.None
                      ,FStar_Pervasives_Native.None ) -> fail1 r
                   | (FStar_Pervasives_Native.Some
                      t12,FStar_Pervasives_Native.None ) ->
                       aux false (n_delta + (Prims.parse_int "1")) t12 t21
                   | (FStar_Pervasives_Native.None
                      ,FStar_Pervasives_Native.Some t22) ->
                       aux false (n_delta + (Prims.parse_int "1")) t11 t22
                   | (FStar_Pervasives_Native.Some
                      t12,FStar_Pervasives_Native.Some t22) ->
                       aux false (n_delta + (Prims.parse_int "1")) t12 t22)
            | MisMatch
                (uu____5996,FStar_Pervasives_Native.Some
                 (FStar_Syntax_Syntax.Delta_equational ))
                ->
                if Prims.op_Negation retry
                then fail1 r
                else
                  (let uu____6014 =
                     let uu____6023 = maybe_inline t11  in
                     let uu____6026 = maybe_inline t21  in
                     (uu____6023, uu____6026)  in
                   match uu____6014 with
                   | (FStar_Pervasives_Native.None
                      ,FStar_Pervasives_Native.None ) -> fail1 r
                   | (FStar_Pervasives_Native.Some
                      t12,FStar_Pervasives_Native.None ) ->
                       aux false (n_delta + (Prims.parse_int "1")) t12 t21
                   | (FStar_Pervasives_Native.None
                      ,FStar_Pervasives_Native.Some t22) ->
                       aux false (n_delta + (Prims.parse_int "1")) t11 t22
                   | (FStar_Pervasives_Native.Some
                      t12,FStar_Pervasives_Native.Some t22) ->
                       aux false (n_delta + (Prims.parse_int "1")) t12 t22)
            | MisMatch
                (FStar_Pervasives_Native.Some d1,FStar_Pervasives_Native.Some
                 d2)
                when d1 = d2 ->
                let uu____6069 = FStar_TypeChecker_Common.decr_delta_depth d1
                   in
                (match uu____6069 with
                 | FStar_Pervasives_Native.None  -> fail1 r
                 | FStar_Pervasives_Native.Some d ->
                     let t12 =
                       normalize_refinement
                         [FStar_TypeChecker_Normalize.UnfoldUntil d;
                         FStar_TypeChecker_Normalize.Weak;
                         FStar_TypeChecker_Normalize.HNF] env wl t11
                        in
                     let t22 =
                       normalize_refinement
                         [FStar_TypeChecker_Normalize.UnfoldUntil d;
                         FStar_TypeChecker_Normalize.Weak;
                         FStar_TypeChecker_Normalize.HNF] env wl t21
                        in
                     aux retry (n_delta + (Prims.parse_int "1")) t12 t22)
            | MisMatch
                (FStar_Pervasives_Native.Some d1,FStar_Pervasives_Native.Some
                 d2)
                ->
                let d1_greater_than_d2 =
                  FStar_TypeChecker_Common.delta_depth_greater_than d1 d2  in
                let uu____6092 =
                  if d1_greater_than_d2
                  then
                    let t1' =
                      normalize_refinement
                        [FStar_TypeChecker_Normalize.UnfoldUntil d2;
                        FStar_TypeChecker_Normalize.Weak;
                        FStar_TypeChecker_Normalize.HNF] env wl t11
                       in
                    (t1', t21)
                  else
                    (let t2' =
                       normalize_refinement
                         [FStar_TypeChecker_Normalize.UnfoldUntil d1;
                         FStar_TypeChecker_Normalize.Weak;
                         FStar_TypeChecker_Normalize.HNF] env wl t21
                        in
                     (t11, t2'))
                   in
                (match uu____6092 with
                 | (t12,t22) ->
                     aux retry (n_delta + (Prims.parse_int "1")) t12 t22)
            | MisMatch uu____6116 -> fail1 r
            | uu____6125 -> success n_delta r t11 t21  in
          let r = aux true (Prims.parse_int "0") t1 t2  in
          (let uu____6138 =
             FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
               (FStar_Options.Other "RelDelta")
              in
           if uu____6138
           then
             let uu____6139 = FStar_Syntax_Print.term_to_string t1  in
             let uu____6140 = FStar_Syntax_Print.term_to_string t2  in
             let uu____6141 =
               string_of_match_result (FStar_Pervasives_Native.fst r)  in
             FStar_Util.print3 "head_matches (%s, %s) = %s\n" uu____6139
               uu____6140 uu____6141
           else ());
          r
  
type tc =
  | T of
  (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.binders ->
                              FStar_Range.range -> FStar_Syntax_Syntax.term)
  FStar_Pervasives_Native.tuple2 
  | C of FStar_Syntax_Syntax.comp [@@deriving show]
let (uu___is_T : tc -> Prims.bool) =
  fun projectee  -> match projectee with | T _0 -> true | uu____6181 -> false 
let (__proj__T__item___0 :
  tc ->
    (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.binders ->
                                FStar_Range.range -> FStar_Syntax_Syntax.term)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | T _0 -> _0 
let (uu___is_C : tc -> Prims.bool) =
  fun projectee  -> match projectee with | C _0 -> true | uu____6217 -> false 
let (__proj__C__item___0 : tc -> FStar_Syntax_Syntax.comp) =
  fun projectee  -> match projectee with | C _0 -> _0 
type tcs = tc Prims.list[@@deriving show]
let (tc_to_string : tc -> Prims.string) =
  fun uu___106_6229  ->
    match uu___106_6229 with
    | T (t,uu____6231) -> term_to_string t
    | C c -> FStar_Syntax_Print.comp_to_string c
  
let (generic_kind :
  FStar_Syntax_Syntax.binders -> FStar_Range.range -> FStar_Syntax_Syntax.typ)
  =
  fun binders  ->
    fun r  ->
      let uu____6247 = FStar_Syntax_Util.type_u ()  in
      match uu____6247 with
      | (t,uu____6253) ->
          let uu____6254 = new_uvar r binders t  in
          FStar_Pervasives_Native.fst uu____6254
  
let (kind_type :
  FStar_Syntax_Syntax.binders -> FStar_Range.range -> FStar_Syntax_Syntax.typ)
  =
  fun binders  ->
    fun r  ->
      let uu____6265 = FStar_Syntax_Util.type_u ()  in
      FStar_All.pipe_right uu____6265 FStar_Pervasives_Native.fst
  
let rec (decompose :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      (tc Prims.list -> FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term ->
                                                   Prims.bool,(FStar_Syntax_Syntax.binder
                                                                 FStar_Pervasives_Native.option,
                                                                variance,
                                                                tc)
                                                                FStar_Pervasives_Native.tuple3
                                                                Prims.list)
        FStar_Pervasives_Native.tuple3)
  =
  fun env  ->
    fun t  ->
      let t1 = FStar_Syntax_Util.unmeta t  in
      let matches t' =
        let uu____6329 = head_matches env t1 t'  in
        match uu____6329 with
        | MisMatch uu____6330 -> false
        | uu____6339 -> true  in
      match t1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_app (hd1,args) ->
          let rebuild args' =
            let args1 =
              FStar_List.map2
                (fun x  ->
                   fun y  ->
                     match (x, y) with
                     | ((uu____6435,imp),T (t2,uu____6438)) -> (t2, imp)
                     | uu____6457 -> failwith "Bad reconstruction") args
                args'
               in
            FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_app (hd1, args1))
              FStar_Pervasives_Native.None t1.FStar_Syntax_Syntax.pos
             in
          let tcs =
            FStar_All.pipe_right args
              (FStar_List.map
                 (fun uu____6524  ->
                    match uu____6524 with
                    | (t2,uu____6538) ->
                        (FStar_Pervasives_Native.None, INVARIANT,
                          (T (t2, generic_kind)))))
             in
          (rebuild, matches, tcs)
      | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
          let uu____6581 = FStar_Syntax_Subst.open_comp bs c  in
          (match uu____6581 with
           | (bs1,c1) ->
               let rebuild tcs =
                 let rec aux out bs2 tcs1 =
                   match (bs2, tcs1) with
                   | ((x,imp)::bs3,(T (t2,uu____6656))::tcs2) ->
                       aux
                         (((let uu___131_6691 = x  in
                            {
                              FStar_Syntax_Syntax.ppname =
                                (uu___131_6691.FStar_Syntax_Syntax.ppname);
                              FStar_Syntax_Syntax.index =
                                (uu___131_6691.FStar_Syntax_Syntax.index);
                              FStar_Syntax_Syntax.sort = t2
                            }), imp) :: out) bs3 tcs2
                   | ([],(C c2)::[]) ->
                       FStar_Syntax_Util.arrow (FStar_List.rev out) c2
                   | uu____6709 -> failwith "Bad reconstruction"  in
                 aux [] bs1 tcs  in
               let rec decompose1 out uu___107_6762 =
                 match uu___107_6762 with
                 | [] ->
                     FStar_List.rev
                       ((FStar_Pervasives_Native.None, COVARIANT, (C c1)) ::
                       out)
                 | hd1::rest ->
                     decompose1
                       (((FStar_Pervasives_Native.Some hd1), CONTRAVARIANT,
                          (T
                             (((FStar_Pervasives_Native.fst hd1).FStar_Syntax_Syntax.sort),
                               kind_type))) :: out) rest
                  in
               let uu____6879 = decompose1 [] bs1  in
               (rebuild, matches, uu____6879))
      | uu____6928 ->
          let rebuild uu___108_6934 =
            match uu___108_6934 with
            | [] -> t1
            | uu____6937 -> failwith "Bad reconstruction"  in
          (rebuild, ((fun t2  -> FStar_Util.return_all true)), [])
  
let (un_T : tc -> FStar_Syntax_Syntax.term) =
  fun uu___109_6968  ->
    match uu___109_6968 with
    | T (t,uu____6970) -> t
    | uu____6979 -> failwith "Impossible"
  
let (arg_of_tc : tc -> FStar_Syntax_Syntax.arg) =
  fun uu___110_6982  ->
    match uu___110_6982 with
    | T (t,uu____6984) -> FStar_Syntax_Syntax.as_arg t
    | uu____6993 -> failwith "Impossible"
  
let (imitation_sub_probs :
  FStar_TypeChecker_Common.prob ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.binders ->
        FStar_Syntax_Syntax.args ->
          (FStar_Syntax_Syntax.binder FStar_Pervasives_Native.option,
            variance,tc) FStar_Pervasives_Native.tuple3 Prims.list ->
            (FStar_TypeChecker_Common.prob Prims.list,tc Prims.list,FStar_Syntax_Syntax.formula)
              FStar_Pervasives_Native.tuple3)
  =
  fun orig  ->
    fun env  ->
      fun scope  ->
        fun ps  ->
          fun qs  ->
            let r = p_loc orig  in
            let rel = p_rel orig  in
            let sub_prob scope1 args q =
              match q with
              | (uu____7109,variance,T (ti,mk_kind)) ->
                  let k = mk_kind scope1 r  in
                  let uu____7134 = new_uvar r scope1 k  in
                  (match uu____7134 with
                   | (gi_xs,gi) ->
                       let gi_ps =
                         match args with
                         | [] -> gi
                         | uu____7152 ->
                             FStar_Syntax_Syntax.mk
                               (FStar_Syntax_Syntax.Tm_app (gi, args))
                               FStar_Pervasives_Native.None r
                          in
                       let uu____7169 =
                         let uu____7170 =
                           mk_problem scope1 orig gi_ps
                             (vary_rel rel variance) ti
                             FStar_Pervasives_Native.None "type subterm"
                            in
                         FStar_All.pipe_left
                           (fun _0_46  ->
                              FStar_TypeChecker_Common.TProb _0_46)
                           uu____7170
                          in
                       ((T (gi_xs, mk_kind)), uu____7169))
              | (uu____7183,uu____7184,C uu____7185) -> failwith "impos"  in
            let rec aux scope1 args qs1 =
              match qs1 with
              | [] -> ([], [], FStar_Syntax_Util.t_true)
              | q::qs2 ->
                  let uu____7332 =
                    match q with
                    | (bopt,variance,C
                       {
                         FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Total
                           (ti,uopt);
                         FStar_Syntax_Syntax.pos = uu____7349;
                         FStar_Syntax_Syntax.vars = uu____7350;_})
                        ->
                        let uu____7373 =
                          sub_prob scope1 args
                            (bopt, variance, (T (ti, kind_type)))
                           in
                        (match uu____7373 with
                         | (T (gi_xs,uu____7397),prob) ->
                             let uu____7407 =
                               let uu____7408 =
                                 FStar_Syntax_Syntax.mk_Total' gi_xs uopt  in
                               FStar_All.pipe_left (fun _0_47  -> C _0_47)
                                 uu____7408
                                in
                             (uu____7407, [prob])
                         | uu____7411 -> failwith "impossible")
                    | (bopt,variance,C
                       {
                         FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.GTotal
                           (ti,uopt);
                         FStar_Syntax_Syntax.pos = uu____7426;
                         FStar_Syntax_Syntax.vars = uu____7427;_})
                        ->
                        let uu____7450 =
                          sub_prob scope1 args
                            (bopt, variance, (T (ti, kind_type)))
                           in
                        (match uu____7450 with
                         | (T (gi_xs,uu____7474),prob) ->
                             let uu____7484 =
                               let uu____7485 =
                                 FStar_Syntax_Syntax.mk_GTotal' gi_xs uopt
                                  in
                               FStar_All.pipe_left (fun _0_48  -> C _0_48)
                                 uu____7485
                                in
                             (uu____7484, [prob])
                         | uu____7488 -> failwith "impossible")
                    | (uu____7499,uu____7500,C
                       { FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Comp c;
                         FStar_Syntax_Syntax.pos = uu____7502;
                         FStar_Syntax_Syntax.vars = uu____7503;_})
                        ->
                        let components =
                          FStar_All.pipe_right
                            c.FStar_Syntax_Syntax.effect_args
                            (FStar_List.map
                               (fun t  ->
                                  (FStar_Pervasives_Native.None, INVARIANT,
                                    (T
                                       ((FStar_Pervasives_Native.fst t),
                                         generic_kind)))))
                           in
                        let components1 =
                          (FStar_Pervasives_Native.None, COVARIANT,
                            (T
                               ((c.FStar_Syntax_Syntax.result_typ),
                                 kind_type)))
                          :: components  in
                        let uu____7634 =
                          let uu____7643 =
                            FStar_List.map (sub_prob scope1 args) components1
                             in
                          FStar_All.pipe_right uu____7643 FStar_List.unzip
                           in
                        (match uu____7634 with
                         | (tcs,sub_probs) ->
                             let gi_xs =
                               let uu____7697 =
                                 let uu____7698 =
                                   let uu____7701 = FStar_List.hd tcs  in
                                   FStar_All.pipe_right uu____7701 un_T  in
                                 let uu____7702 =
                                   let uu____7711 = FStar_List.tl tcs  in
                                   FStar_All.pipe_right uu____7711
                                     (FStar_List.map arg_of_tc)
                                    in
                                 {
                                   FStar_Syntax_Syntax.comp_univs =
                                     (c.FStar_Syntax_Syntax.comp_univs);
                                   FStar_Syntax_Syntax.effect_name =
                                     (c.FStar_Syntax_Syntax.effect_name);
                                   FStar_Syntax_Syntax.result_typ =
                                     uu____7698;
                                   FStar_Syntax_Syntax.effect_args =
                                     uu____7702;
                                   FStar_Syntax_Syntax.flags =
                                     (c.FStar_Syntax_Syntax.flags)
                                 }  in
                               FStar_All.pipe_left
                                 FStar_Syntax_Syntax.mk_Comp uu____7697
                                in
                             ((C gi_xs), sub_probs))
                    | uu____7720 ->
                        let uu____7733 = sub_prob scope1 args q  in
                        (match uu____7733 with
                         | (ktec,prob) -> (ktec, [prob]))
                     in
                  (match uu____7332 with
                   | (tc,probs) ->
                       let uu____7764 =
                         match (q, tc) with
                         | ((FStar_Pervasives_Native.Some
                             (b,imp),uu____7827,uu____7828),T
                            (t,uu____7830)) ->
                             let b1 =
                               ((let uu___132_7867 = b  in
                                 {
                                   FStar_Syntax_Syntax.ppname =
                                     (uu___132_7867.FStar_Syntax_Syntax.ppname);
                                   FStar_Syntax_Syntax.index =
                                     (uu___132_7867.FStar_Syntax_Syntax.index);
                                   FStar_Syntax_Syntax.sort = t
                                 }), imp)
                                in
                             let uu____7868 =
                               let uu____7875 =
                                 FStar_Syntax_Util.arg_of_non_null_binder b1
                                  in
                               uu____7875 :: args  in
                             ((FStar_Pervasives_Native.Some b1), (b1 ::
                               scope1), uu____7868)
                         | uu____7910 ->
                             (FStar_Pervasives_Native.None, scope1, args)
                          in
                       (match uu____7764 with
                        | (bopt,scope2,args1) ->
                            let uu____7994 = aux scope2 args1 qs2  in
                            (match uu____7994 with
                             | (sub_probs,tcs,f) ->
                                 let f1 =
                                   match bopt with
                                   | FStar_Pervasives_Native.None  ->
                                       let f1 =
                                         let uu____8032 =
                                           let uu____8035 =
                                             FStar_All.pipe_right probs
                                               (FStar_List.map
                                                  (fun prob  ->
                                                     FStar_All.pipe_right
                                                       (p_guard prob)
                                                       FStar_Pervasives_Native.fst))
                                              in
                                           f :: uu____8035  in
                                         FStar_Syntax_Util.mk_conj_l
                                           uu____8032
                                          in
                                       (def_check_closed (p_loc orig)
                                          "imitation_sub_probs (1)" f1;
                                        f1)
                                   | FStar_Pervasives_Native.Some b ->
                                       let u_b =
                                         env.FStar_TypeChecker_Env.universe_of
                                           env
                                           (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                                          in
                                       let f1 =
                                         let uu____8060 =
                                           let uu____8063 =
                                             FStar_Syntax_Util.mk_forall u_b
                                               (FStar_Pervasives_Native.fst b)
                                               f
                                              in
                                           let uu____8064 =
                                             FStar_All.pipe_right probs
                                               (FStar_List.map
                                                  (fun prob  ->
                                                     FStar_All.pipe_right
                                                       (p_guard prob)
                                                       FStar_Pervasives_Native.fst))
                                              in
                                           uu____8063 :: uu____8064  in
                                         FStar_Syntax_Util.mk_conj_l
                                           uu____8060
                                          in
                                       (def_check_closed (p_loc orig)
                                          "imitation_sub_probs (2)" f1;
                                        f1)
                                    in
                                 ((FStar_List.append probs sub_probs), (tc ::
                                   tcs), f1))))
               in
            aux scope ps qs
  
type flex_t =
  (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.uvar,FStar_Syntax_Syntax.typ,
    FStar_Syntax_Syntax.args) FStar_Pervasives_Native.tuple4[@@deriving show]
type im_or_proj_t =
  (((FStar_Syntax_Syntax.uvar,FStar_Syntax_Syntax.typ)
      FStar_Pervasives_Native.tuple2,FStar_Syntax_Syntax.binders,FStar_Syntax_Syntax.comp)
     FStar_Pervasives_Native.tuple3,FStar_Syntax_Syntax.arg Prims.list,
    (tc Prims.list -> FStar_Syntax_Syntax.typ,FStar_Syntax_Syntax.typ ->
                                                Prims.bool,(FStar_Syntax_Syntax.binder
                                                              FStar_Pervasives_Native.option,
                                                             variance,
                                                             tc)
                                                             FStar_Pervasives_Native.tuple3
                                                             Prims.list)
      FStar_Pervasives_Native.tuple3)
    FStar_Pervasives_Native.tuple3[@@deriving show]
let (rigid_rigid : Prims.int) = (Prims.parse_int "0") 
let (flex_rigid_eq : Prims.int) = (Prims.parse_int "1") 
let (flex_refine_inner : Prims.int) = (Prims.parse_int "2") 
let (flex_refine : Prims.int) = (Prims.parse_int "3") 
let (flex_rigid : Prims.int) = (Prims.parse_int "4") 
let (rigid_flex : Prims.int) = (Prims.parse_int "5") 
let (refine_flex : Prims.int) = (Prims.parse_int "6") 
let (flex_flex : Prims.int) = (Prims.parse_int "7") 
let compress_tprob :
  'Auu____8133 .
    worklist ->
      (FStar_Syntax_Syntax.term,'Auu____8133)
        FStar_TypeChecker_Common.problem ->
        (FStar_Syntax_Syntax.term,'Auu____8133)
          FStar_TypeChecker_Common.problem
  =
  fun wl  ->
    fun p  ->
      let uu___133_8154 = p  in
      let uu____8159 = whnf wl.tcenv p.FStar_TypeChecker_Common.lhs  in
      let uu____8160 = whnf wl.tcenv p.FStar_TypeChecker_Common.rhs  in
      {
        FStar_TypeChecker_Common.pid =
          (uu___133_8154.FStar_TypeChecker_Common.pid);
        FStar_TypeChecker_Common.lhs = uu____8159;
        FStar_TypeChecker_Common.relation =
          (uu___133_8154.FStar_TypeChecker_Common.relation);
        FStar_TypeChecker_Common.rhs = uu____8160;
        FStar_TypeChecker_Common.element =
          (uu___133_8154.FStar_TypeChecker_Common.element);
        FStar_TypeChecker_Common.logical_guard =
          (uu___133_8154.FStar_TypeChecker_Common.logical_guard);
        FStar_TypeChecker_Common.scope =
          (uu___133_8154.FStar_TypeChecker_Common.scope);
        FStar_TypeChecker_Common.reason =
          (uu___133_8154.FStar_TypeChecker_Common.reason);
        FStar_TypeChecker_Common.loc =
          (uu___133_8154.FStar_TypeChecker_Common.loc);
        FStar_TypeChecker_Common.rank =
          (uu___133_8154.FStar_TypeChecker_Common.rank)
      }
  
let (compress_prob :
  worklist -> FStar_TypeChecker_Common.prob -> FStar_TypeChecker_Common.prob)
  =
  fun wl  ->
    fun p  ->
      match p with
      | FStar_TypeChecker_Common.TProb p1 ->
          let uu____8172 = compress_tprob wl p1  in
          FStar_All.pipe_right uu____8172
            (fun _0_49  -> FStar_TypeChecker_Common.TProb _0_49)
      | FStar_TypeChecker_Common.CProb uu____8181 -> p
  
let (rank :
  worklist ->
    FStar_TypeChecker_Common.prob ->
      (Prims.int,FStar_TypeChecker_Common.prob)
        FStar_Pervasives_Native.tuple2)
  =
  fun wl  ->
    fun pr  ->
      let prob =
        let uu____8201 = compress_prob wl pr  in
        FStar_All.pipe_right uu____8201 maybe_invert_p  in
      match prob with
      | FStar_TypeChecker_Common.TProb tp ->
          let uu____8211 =
            FStar_Syntax_Util.head_and_args tp.FStar_TypeChecker_Common.lhs
             in
          (match uu____8211 with
           | (lh,uu____8231) ->
               let uu____8252 =
                 FStar_Syntax_Util.head_and_args
                   tp.FStar_TypeChecker_Common.rhs
                  in
               (match uu____8252 with
                | (rh,uu____8272) ->
                    let uu____8293 =
                      match ((lh.FStar_Syntax_Syntax.n),
                              (rh.FStar_Syntax_Syntax.n))
                      with
                      | (FStar_Syntax_Syntax.Tm_uvar
                         uu____8310,FStar_Syntax_Syntax.Tm_uvar uu____8311)
                          -> (flex_flex, tp)
                      | (FStar_Syntax_Syntax.Tm_uvar uu____8348,uu____8349)
                          when
                          (tp.FStar_TypeChecker_Common.relation =
                             FStar_TypeChecker_Common.EQ)
                            || (FStar_Options.eager_inference ())
                          -> (flex_rigid_eq, tp)
                      | (uu____8370,FStar_Syntax_Syntax.Tm_uvar uu____8371)
                          when
                          (tp.FStar_TypeChecker_Common.relation =
                             FStar_TypeChecker_Common.EQ)
                            || (FStar_Options.eager_inference ())
                          -> (flex_rigid_eq, tp)
                      | (FStar_Syntax_Syntax.Tm_uvar uu____8392,uu____8393)
                          ->
                          let uu____8410 =
                            base_and_refinement wl.tcenv
                              tp.FStar_TypeChecker_Common.rhs
                             in
                          (match uu____8410 with
                           | (b,ref_opt) ->
                               (match ref_opt with
                                | FStar_Pervasives_Native.None  ->
                                    (flex_rigid, tp)
                                | uu____8459 ->
                                    let rank =
                                      let uu____8467 = is_top_level_prob prob
                                         in
                                      if uu____8467
                                      then flex_refine
                                      else flex_refine_inner  in
                                    let uu____8469 =
                                      let uu___134_8474 = tp  in
                                      let uu____8479 =
                                        force_refinement (b, ref_opt)  in
                                      {
                                        FStar_TypeChecker_Common.pid =
                                          (uu___134_8474.FStar_TypeChecker_Common.pid);
                                        FStar_TypeChecker_Common.lhs =
                                          (uu___134_8474.FStar_TypeChecker_Common.lhs);
                                        FStar_TypeChecker_Common.relation =
                                          (uu___134_8474.FStar_TypeChecker_Common.relation);
                                        FStar_TypeChecker_Common.rhs =
                                          uu____8479;
                                        FStar_TypeChecker_Common.element =
                                          (uu___134_8474.FStar_TypeChecker_Common.element);
                                        FStar_TypeChecker_Common.logical_guard
                                          =
                                          (uu___134_8474.FStar_TypeChecker_Common.logical_guard);
                                        FStar_TypeChecker_Common.scope =
                                          (uu___134_8474.FStar_TypeChecker_Common.scope);
                                        FStar_TypeChecker_Common.reason =
                                          (uu___134_8474.FStar_TypeChecker_Common.reason);
                                        FStar_TypeChecker_Common.loc =
                                          (uu___134_8474.FStar_TypeChecker_Common.loc);
                                        FStar_TypeChecker_Common.rank =
                                          (uu___134_8474.FStar_TypeChecker_Common.rank)
                                      }  in
                                    (rank, uu____8469)))
                      | (uu____8490,FStar_Syntax_Syntax.Tm_uvar uu____8491)
                          ->
                          let uu____8508 =
                            base_and_refinement wl.tcenv
                              tp.FStar_TypeChecker_Common.lhs
                             in
                          (match uu____8508 with
                           | (b,ref_opt) ->
                               (match ref_opt with
                                | FStar_Pervasives_Native.None  ->
                                    (rigid_flex, tp)
                                | uu____8557 ->
                                    let uu____8564 =
                                      let uu___135_8571 = tp  in
                                      let uu____8576 =
                                        force_refinement (b, ref_opt)  in
                                      {
                                        FStar_TypeChecker_Common.pid =
                                          (uu___135_8571.FStar_TypeChecker_Common.pid);
                                        FStar_TypeChecker_Common.lhs =
                                          uu____8576;
                                        FStar_TypeChecker_Common.relation =
                                          (uu___135_8571.FStar_TypeChecker_Common.relation);
                                        FStar_TypeChecker_Common.rhs =
                                          (uu___135_8571.FStar_TypeChecker_Common.rhs);
                                        FStar_TypeChecker_Common.element =
                                          (uu___135_8571.FStar_TypeChecker_Common.element);
                                        FStar_TypeChecker_Common.logical_guard
                                          =
                                          (uu___135_8571.FStar_TypeChecker_Common.logical_guard);
                                        FStar_TypeChecker_Common.scope =
                                          (uu___135_8571.FStar_TypeChecker_Common.scope);
                                        FStar_TypeChecker_Common.reason =
                                          (uu___135_8571.FStar_TypeChecker_Common.reason);
                                        FStar_TypeChecker_Common.loc =
                                          (uu___135_8571.FStar_TypeChecker_Common.loc);
                                        FStar_TypeChecker_Common.rank =
                                          (uu___135_8571.FStar_TypeChecker_Common.rank)
                                      }  in
                                    (refine_flex, uu____8564)))
                      | (uu____8593,uu____8594) -> (rigid_rigid, tp)  in
                    (match uu____8293 with
                     | (rank,tp1) ->
                         let uu____8613 =
                           FStar_All.pipe_right
                             (let uu___136_8619 = tp1  in
                              {
                                FStar_TypeChecker_Common.pid =
                                  (uu___136_8619.FStar_TypeChecker_Common.pid);
                                FStar_TypeChecker_Common.lhs =
                                  (uu___136_8619.FStar_TypeChecker_Common.lhs);
                                FStar_TypeChecker_Common.relation =
                                  (uu___136_8619.FStar_TypeChecker_Common.relation);
                                FStar_TypeChecker_Common.rhs =
                                  (uu___136_8619.FStar_TypeChecker_Common.rhs);
                                FStar_TypeChecker_Common.element =
                                  (uu___136_8619.FStar_TypeChecker_Common.element);
                                FStar_TypeChecker_Common.logical_guard =
                                  (uu___136_8619.FStar_TypeChecker_Common.logical_guard);
                                FStar_TypeChecker_Common.scope =
                                  (uu___136_8619.FStar_TypeChecker_Common.scope);
                                FStar_TypeChecker_Common.reason =
                                  (uu___136_8619.FStar_TypeChecker_Common.reason);
                                FStar_TypeChecker_Common.loc =
                                  (uu___136_8619.FStar_TypeChecker_Common.loc);
                                FStar_TypeChecker_Common.rank =
                                  (FStar_Pervasives_Native.Some rank)
                              })
                             (fun _0_50  ->
                                FStar_TypeChecker_Common.TProb _0_50)
                            in
                         (rank, uu____8613))))
      | FStar_TypeChecker_Common.CProb cp ->
          let uu____8629 =
            FStar_All.pipe_right
              (let uu___137_8635 = cp  in
               {
                 FStar_TypeChecker_Common.pid =
                   (uu___137_8635.FStar_TypeChecker_Common.pid);
                 FStar_TypeChecker_Common.lhs =
                   (uu___137_8635.FStar_TypeChecker_Common.lhs);
                 FStar_TypeChecker_Common.relation =
                   (uu___137_8635.FStar_TypeChecker_Common.relation);
                 FStar_TypeChecker_Common.rhs =
                   (uu___137_8635.FStar_TypeChecker_Common.rhs);
                 FStar_TypeChecker_Common.element =
                   (uu___137_8635.FStar_TypeChecker_Common.element);
                 FStar_TypeChecker_Common.logical_guard =
                   (uu___137_8635.FStar_TypeChecker_Common.logical_guard);
                 FStar_TypeChecker_Common.scope =
                   (uu___137_8635.FStar_TypeChecker_Common.scope);
                 FStar_TypeChecker_Common.reason =
                   (uu___137_8635.FStar_TypeChecker_Common.reason);
                 FStar_TypeChecker_Common.loc =
                   (uu___137_8635.FStar_TypeChecker_Common.loc);
                 FStar_TypeChecker_Common.rank =
                   (FStar_Pervasives_Native.Some rigid_rigid)
               }) (fun _0_51  -> FStar_TypeChecker_Common.CProb _0_51)
             in
          (rigid_rigid, uu____8629)
  
let (next_prob :
  worklist ->
    (FStar_TypeChecker_Common.prob FStar_Pervasives_Native.option,FStar_TypeChecker_Common.prob
                                                                    Prims.list,
      Prims.int) FStar_Pervasives_Native.tuple3)
  =
  fun wl  ->
    let rec aux uu____8690 probs =
      match uu____8690 with
      | (min_rank,min1,out) ->
          (match probs with
           | [] -> (min1, out, min_rank)
           | hd1::tl1 ->
               let uu____8743 = rank wl hd1  in
               (match uu____8743 with
                | (rank1,hd2) ->
                    if rank1 <= flex_rigid_eq
                    then
                      (match min1 with
                       | FStar_Pervasives_Native.None  ->
                           ((FStar_Pervasives_Native.Some hd2),
                             (FStar_List.append out tl1), rank1)
                       | FStar_Pervasives_Native.Some m ->
                           ((FStar_Pervasives_Native.Some hd2),
                             (FStar_List.append out (m :: tl1)), rank1))
                    else
                      if rank1 < min_rank
                      then
                        (match min1 with
                         | FStar_Pervasives_Native.None  ->
                             aux
                               (rank1, (FStar_Pervasives_Native.Some hd2),
                                 out) tl1
                         | FStar_Pervasives_Native.Some m ->
                             aux
                               (rank1, (FStar_Pervasives_Native.Some hd2), (m
                                 :: out)) tl1)
                      else aux (min_rank, min1, (hd2 :: out)) tl1))
       in
    aux
      ((flex_flex + (Prims.parse_int "1")), FStar_Pervasives_Native.None, [])
      wl.attempting
  
let (is_flex_rigid : Prims.int -> Prims.bool) =
  fun rank1  -> (flex_refine_inner <= rank1) && (rank1 <= flex_rigid) 
let (is_rigid_flex : Prims.int -> Prims.bool) =
  fun rank1  -> (rigid_flex <= rank1) && (rank1 <= refine_flex) 
type univ_eq_sol =
  | UDeferred of worklist 
  | USolved of worklist 
  | UFailed of Prims.string [@@deriving show]
let (uu___is_UDeferred : univ_eq_sol -> Prims.bool) =
  fun projectee  ->
    match projectee with | UDeferred _0 -> true | uu____8850 -> false
  
let (__proj__UDeferred__item___0 : univ_eq_sol -> worklist) =
  fun projectee  -> match projectee with | UDeferred _0 -> _0 
let (uu___is_USolved : univ_eq_sol -> Prims.bool) =
  fun projectee  ->
    match projectee with | USolved _0 -> true | uu____8862 -> false
  
let (__proj__USolved__item___0 : univ_eq_sol -> worklist) =
  fun projectee  -> match projectee with | USolved _0 -> _0 
let (uu___is_UFailed : univ_eq_sol -> Prims.bool) =
  fun projectee  ->
    match projectee with | UFailed _0 -> true | uu____8874 -> false
  
let (__proj__UFailed__item___0 : univ_eq_sol -> Prims.string) =
  fun projectee  -> match projectee with | UFailed _0 -> _0 
let rec (really_solve_universe_eq :
  Prims.int ->
    worklist ->
      FStar_Syntax_Syntax.universe ->
        FStar_Syntax_Syntax.universe -> univ_eq_sol)
  =
  fun pid_orig  ->
    fun wl  ->
      fun u1  ->
        fun u2  ->
          let u11 =
            FStar_TypeChecker_Normalize.normalize_universe wl.tcenv u1  in
          let u21 =
            FStar_TypeChecker_Normalize.normalize_universe wl.tcenv u2  in
          let rec occurs_univ v1 u =
            match u with
            | FStar_Syntax_Syntax.U_max us ->
                FStar_All.pipe_right us
                  (FStar_Util.for_some
                     (fun u3  ->
                        let uu____8914 = FStar_Syntax_Util.univ_kernel u3  in
                        match uu____8914 with
                        | (k,uu____8920) ->
                            (match k with
                             | FStar_Syntax_Syntax.U_unif v2 ->
                                 FStar_Syntax_Unionfind.univ_equiv v1 v2
                             | uu____8930 -> false)))
            | uu____8931 -> occurs_univ v1 (FStar_Syntax_Syntax.U_max [u])
             in
          let rec filter_out_common_univs u12 u22 =
            let common_elts =
              FStar_All.pipe_right u12
                (FStar_List.fold_left
                   (fun uvs  ->
                      fun uv1  ->
                        let uu____8979 =
                          FStar_All.pipe_right u22
                            (FStar_List.existsML
                               (fun uv2  ->
                                  let uu____8985 =
                                    FStar_Syntax_Util.compare_univs uv1 uv2
                                     in
                                  uu____8985 = (Prims.parse_int "0")))
                           in
                        if uu____8979 then uv1 :: uvs else uvs) [])
               in
            let filter1 =
              FStar_List.filter
                (fun u  ->
                   let uu____8999 =
                     FStar_All.pipe_right common_elts
                       (FStar_List.existsML
                          (fun u'  ->
                             let uu____9005 =
                               FStar_Syntax_Util.compare_univs u u'  in
                             uu____9005 = (Prims.parse_int "0")))
                      in
                   Prims.op_Negation uu____8999)
               in
            let uu____9006 = filter1 u12  in
            let uu____9009 = filter1 u22  in (uu____9006, uu____9009)  in
          let try_umax_components u12 u22 msg =
            match (u12, u22) with
            | (FStar_Syntax_Syntax.U_max us1,FStar_Syntax_Syntax.U_max us2)
                ->
                let uu____9032 = filter_out_common_univs us1 us2  in
                (match uu____9032 with
                 | (us11,us21) ->
                     if (FStar_List.length us11) = (FStar_List.length us21)
                     then
                       let rec aux wl1 us12 us22 =
                         match (us12, us22) with
                         | (u13::us13,u23::us23) ->
                             let uu____9085 =
                               really_solve_universe_eq pid_orig wl1 u13 u23
                                in
                             (match uu____9085 with
                              | USolved wl2 -> aux wl2 us13 us23
                              | failed -> failed)
                         | uu____9088 -> USolved wl1  in
                       aux wl us11 us21
                     else
                       (let uu____9098 =
                          let uu____9099 =
                            FStar_Syntax_Print.univ_to_string u12  in
                          let uu____9100 =
                            FStar_Syntax_Print.univ_to_string u22  in
                          FStar_Util.format2
                            "Unable to unify universes: %s and %s" uu____9099
                            uu____9100
                           in
                        UFailed uu____9098))
            | (FStar_Syntax_Syntax.U_max us,u') ->
                let rec aux wl1 us1 =
                  match us1 with
                  | [] -> USolved wl1
                  | u::us2 ->
                      let uu____9120 =
                        really_solve_universe_eq pid_orig wl1 u u'  in
                      (match uu____9120 with
                       | USolved wl2 -> aux wl2 us2
                       | failed -> failed)
                   in
                aux wl us
            | (u',FStar_Syntax_Syntax.U_max us) ->
                let rec aux wl1 us1 =
                  match us1 with
                  | [] -> USolved wl1
                  | u::us2 ->
                      let uu____9142 =
                        really_solve_universe_eq pid_orig wl1 u u'  in
                      (match uu____9142 with
                       | USolved wl2 -> aux wl2 us2
                       | failed -> failed)
                   in
                aux wl us
            | uu____9145 ->
                let uu____9150 =
                  let uu____9151 = FStar_Syntax_Print.univ_to_string u12  in
                  let uu____9152 = FStar_Syntax_Print.univ_to_string u22  in
                  FStar_Util.format3
                    "Unable to unify universes: %s and %s (%s)" uu____9151
                    uu____9152 msg
                   in
                UFailed uu____9150
             in
          match (u11, u21) with
          | (FStar_Syntax_Syntax.U_bvar uu____9153,uu____9154) ->
              let uu____9155 =
                let uu____9156 = FStar_Syntax_Print.univ_to_string u11  in
                let uu____9157 = FStar_Syntax_Print.univ_to_string u21  in
                FStar_Util.format2
                  "Impossible: found an de Bruijn universe variable or unknown universe: %s, %s"
                  uu____9156 uu____9157
                 in
              failwith uu____9155
          | (FStar_Syntax_Syntax.U_unknown ,uu____9158) ->
              let uu____9159 =
                let uu____9160 = FStar_Syntax_Print.univ_to_string u11  in
                let uu____9161 = FStar_Syntax_Print.univ_to_string u21  in
                FStar_Util.format2
                  "Impossible: found an de Bruijn universe variable or unknown universe: %s, %s"
                  uu____9160 uu____9161
                 in
              failwith uu____9159
          | (uu____9162,FStar_Syntax_Syntax.U_bvar uu____9163) ->
              let uu____9164 =
                let uu____9165 = FStar_Syntax_Print.univ_to_string u11  in
                let uu____9166 = FStar_Syntax_Print.univ_to_string u21  in
                FStar_Util.format2
                  "Impossible: found an de Bruijn universe variable or unknown universe: %s, %s"
                  uu____9165 uu____9166
                 in
              failwith uu____9164
          | (uu____9167,FStar_Syntax_Syntax.U_unknown ) ->
              let uu____9168 =
                let uu____9169 = FStar_Syntax_Print.univ_to_string u11  in
                let uu____9170 = FStar_Syntax_Print.univ_to_string u21  in
                FStar_Util.format2
                  "Impossible: found an de Bruijn universe variable or unknown universe: %s, %s"
                  uu____9169 uu____9170
                 in
              failwith uu____9168
          | (FStar_Syntax_Syntax.U_name x,FStar_Syntax_Syntax.U_name y) ->
              if x.FStar_Ident.idText = y.FStar_Ident.idText
              then USolved wl
              else UFailed "Incompatible universes"
          | (FStar_Syntax_Syntax.U_zero ,FStar_Syntax_Syntax.U_zero ) ->
              USolved wl
          | (FStar_Syntax_Syntax.U_succ u12,FStar_Syntax_Syntax.U_succ u22)
              -> really_solve_universe_eq pid_orig wl u12 u22
          | (FStar_Syntax_Syntax.U_unif v1,FStar_Syntax_Syntax.U_unif v2) ->
              let uu____9194 = FStar_Syntax_Unionfind.univ_equiv v1 v2  in
              if uu____9194
              then USolved wl
              else
                (let wl1 = extend_solution pid_orig [UNIV (v1, u21)] wl  in
                 USolved wl1)
          | (FStar_Syntax_Syntax.U_unif v1,u) ->
              let u3 = norm_univ wl u  in
              let uu____9216 = occurs_univ v1 u3  in
              if uu____9216
              then
                let uu____9217 =
                  let uu____9218 =
                    FStar_Syntax_Print.univ_to_string
                      (FStar_Syntax_Syntax.U_unif v1)
                     in
                  let uu____9219 = FStar_Syntax_Print.univ_to_string u3  in
                  FStar_Util.format2 "Failed occurs check: %s occurs in %s"
                    uu____9218 uu____9219
                   in
                try_umax_components u11 u21 uu____9217
              else
                (let uu____9221 = extend_solution pid_orig [UNIV (v1, u3)] wl
                    in
                 USolved uu____9221)
          | (u,FStar_Syntax_Syntax.U_unif v1) ->
              let u3 = norm_univ wl u  in
              let uu____9241 = occurs_univ v1 u3  in
              if uu____9241
              then
                let uu____9242 =
                  let uu____9243 =
                    FStar_Syntax_Print.univ_to_string
                      (FStar_Syntax_Syntax.U_unif v1)
                     in
                  let uu____9244 = FStar_Syntax_Print.univ_to_string u3  in
                  FStar_Util.format2 "Failed occurs check: %s occurs in %s"
                    uu____9243 uu____9244
                   in
                try_umax_components u11 u21 uu____9242
              else
                (let uu____9246 = extend_solution pid_orig [UNIV (v1, u3)] wl
                    in
                 USolved uu____9246)
          | (FStar_Syntax_Syntax.U_max uu____9255,uu____9256) ->
              if wl.defer_ok
              then UDeferred wl
              else
                (let u12 = norm_univ wl u11  in
                 let u22 = norm_univ wl u21  in
                 let uu____9262 = FStar_Syntax_Util.eq_univs u12 u22  in
                 if uu____9262
                 then USolved wl
                 else try_umax_components u12 u22 "")
          | (uu____9264,FStar_Syntax_Syntax.U_max uu____9265) ->
              if wl.defer_ok
              then UDeferred wl
              else
                (let u12 = norm_univ wl u11  in
                 let u22 = norm_univ wl u21  in
                 let uu____9271 = FStar_Syntax_Util.eq_univs u12 u22  in
                 if uu____9271
                 then USolved wl
                 else try_umax_components u12 u22 "")
          | (FStar_Syntax_Syntax.U_succ uu____9273,FStar_Syntax_Syntax.U_zero
             ) -> UFailed "Incompatible universes"
          | (FStar_Syntax_Syntax.U_succ uu____9274,FStar_Syntax_Syntax.U_name
             uu____9275) -> UFailed "Incompatible universes"
          | (FStar_Syntax_Syntax.U_zero ,FStar_Syntax_Syntax.U_succ
             uu____9276) -> UFailed "Incompatible universes"
          | (FStar_Syntax_Syntax.U_zero ,FStar_Syntax_Syntax.U_name
             uu____9277) -> UFailed "Incompatible universes"
          | (FStar_Syntax_Syntax.U_name uu____9278,FStar_Syntax_Syntax.U_succ
             uu____9279) -> UFailed "Incompatible universes"
          | (FStar_Syntax_Syntax.U_name uu____9280,FStar_Syntax_Syntax.U_zero
             ) -> UFailed "Incompatible universes"
  
let (solve_universe_eq :
  Prims.int ->
    worklist ->
      FStar_Syntax_Syntax.universe ->
        FStar_Syntax_Syntax.universe -> univ_eq_sol)
  =
  fun orig  ->
    fun wl  ->
      fun u1  ->
        fun u2  ->
          if (wl.tcenv).FStar_TypeChecker_Env.lax_universes
          then USolved wl
          else really_solve_universe_eq orig wl u1 u2
  
let match_num_binders :
  'a 'b .
    ('a Prims.list,'a Prims.list -> 'b) FStar_Pervasives_Native.tuple2 ->
      ('a Prims.list,'a Prims.list -> 'b) FStar_Pervasives_Native.tuple2 ->
        (('a Prims.list,'b) FStar_Pervasives_Native.tuple2,('a Prims.list,
                                                             'b)
                                                             FStar_Pervasives_Native.tuple2)
          FStar_Pervasives_Native.tuple2
  =
  fun bc1  ->
    fun bc2  ->
      let uu____9366 = bc1  in
      match uu____9366 with
      | (bs1,mk_cod1) ->
          let uu____9407 = bc2  in
          (match uu____9407 with
           | (bs2,mk_cod2) ->
               let rec aux bs11 bs21 =
                 match (bs11, bs21) with
                 | (x::xs,y::ys) ->
                     let uu____9511 = aux xs ys  in
                     (match uu____9511 with
                      | ((xs1,xr),(ys1,yr)) ->
                          (((x :: xs1), xr), ((y :: ys1), yr)))
                 | (xs,ys) ->
                     let uu____9594 =
                       let uu____9601 = mk_cod1 xs  in ([], uu____9601)  in
                     let uu____9604 =
                       let uu____9611 = mk_cod2 ys  in ([], uu____9611)  in
                     (uu____9594, uu____9604)
                  in
               aux bs1 bs2)
  
let rec (solve : FStar_TypeChecker_Env.env -> worklist -> solution) =
  fun env  ->
    fun probs  ->
      (let uu____9722 =
         FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
           (FStar_Options.Other "RelCheck")
          in
       if uu____9722
       then
         let uu____9723 = wl_to_string probs  in
         FStar_Util.print1 "solve:\n\t%s\n" uu____9723
       else ());
      (let uu____9725 = next_prob probs  in
       match uu____9725 with
       | (FStar_Pervasives_Native.Some hd1,tl1,rank1) ->
           let probs1 =
             let uu___138_9746 = probs  in
             {
               attempting = tl1;
               wl_deferred = (uu___138_9746.wl_deferred);
               ctr = (uu___138_9746.ctr);
               defer_ok = (uu___138_9746.defer_ok);
               smt_ok = (uu___138_9746.smt_ok);
               tcenv = (uu___138_9746.tcenv)
             }  in
           (match hd1 with
            | FStar_TypeChecker_Common.CProb cp ->
                solve_c env (maybe_invert cp) probs1
            | FStar_TypeChecker_Common.TProb tp ->
                if
                  ((Prims.op_Negation probs1.defer_ok) &&
                     (flex_refine_inner <= rank1))
                    && (rank1 <= flex_rigid)
                then
                  let uu____9757 = solve_flex_rigid_join env tp probs1  in
                  (match uu____9757 with
                   | FStar_Pervasives_Native.None  ->
                       solve_t' env (maybe_invert tp) probs1
                   | FStar_Pervasives_Native.Some wl -> solve env wl)
                else
                  if
                    ((Prims.op_Negation probs1.defer_ok) &&
                       (rigid_flex <= rank1))
                      && (rank1 <= refine_flex)
                  then
                    (let uu____9762 = solve_rigid_flex_meet env tp probs1  in
                     match uu____9762 with
                     | FStar_Pervasives_Native.None  ->
                         solve_t' env (maybe_invert tp) probs1
                     | FStar_Pervasives_Native.Some wl -> solve env wl)
                  else solve_t' env (maybe_invert tp) probs1)
       | (FStar_Pervasives_Native.None ,uu____9767,uu____9768) ->
           (match probs.wl_deferred with
            | [] -> Success []
            | uu____9785 ->
                let uu____9794 =
                  FStar_All.pipe_right probs.wl_deferred
                    (FStar_List.partition
                       (fun uu____9853  ->
                          match uu____9853 with
                          | (c,uu____9861,uu____9862) -> c < probs.ctr))
                   in
                (match uu____9794 with
                 | (attempt1,rest) ->
                     (match attempt1 with
                      | [] ->
                          let uu____9903 =
                            FStar_List.map
                              (fun uu____9918  ->
                                 match uu____9918 with
                                 | (uu____9929,x,y) -> (x, y))
                              probs.wl_deferred
                             in
                          Success uu____9903
                      | uu____9932 ->
                          let uu____9941 =
                            let uu___139_9942 = probs  in
                            let uu____9943 =
                              FStar_All.pipe_right attempt1
                                (FStar_List.map
                                   (fun uu____9964  ->
                                      match uu____9964 with
                                      | (uu____9971,uu____9972,y) -> y))
                               in
                            {
                              attempting = uu____9943;
                              wl_deferred = rest;
                              ctr = (uu___139_9942.ctr);
                              defer_ok = (uu___139_9942.defer_ok);
                              smt_ok = (uu___139_9942.smt_ok);
                              tcenv = (uu___139_9942.tcenv)
                            }  in
                          solve env uu____9941))))

and (solve_one_universe_eq :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Common.prob ->
      FStar_Syntax_Syntax.universe ->
        FStar_Syntax_Syntax.universe -> worklist -> solution)
  =
  fun env  ->
    fun orig  ->
      fun u1  ->
        fun u2  ->
          fun wl  ->
            let uu____9979 = solve_universe_eq (p_pid orig) wl u1 u2  in
            match uu____9979 with
            | USolved wl1 ->
                let uu____9981 =
                  solve_prob orig FStar_Pervasives_Native.None [] wl1  in
                solve env uu____9981
            | UFailed msg -> giveup env msg orig
            | UDeferred wl1 -> solve env (defer "" orig wl1)

and (solve_maybe_uinsts :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Common.prob ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term -> worklist -> univ_eq_sol)
  =
  fun env  ->
    fun orig  ->
      fun t1  ->
        fun t2  ->
          fun wl  ->
            let rec aux wl1 us1 us2 =
              match (us1, us2) with
              | ([],[]) -> USolved wl1
              | (u1::us11,u2::us21) ->
                  let uu____10027 = solve_universe_eq (p_pid orig) wl1 u1 u2
                     in
                  (match uu____10027 with
                   | USolved wl2 -> aux wl2 us11 us21
                   | failed_or_deferred -> failed_or_deferred)
              | uu____10030 -> UFailed "Unequal number of universes"  in
            let t11 = whnf env t1  in
            let t21 = whnf env t2  in
            match ((t11.FStar_Syntax_Syntax.n), (t21.FStar_Syntax_Syntax.n))
            with
            | (FStar_Syntax_Syntax.Tm_uinst
               ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar f;
                  FStar_Syntax_Syntax.pos = uu____10042;
                  FStar_Syntax_Syntax.vars = uu____10043;_},us1),FStar_Syntax_Syntax.Tm_uinst
               ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar g;
                  FStar_Syntax_Syntax.pos = uu____10046;
                  FStar_Syntax_Syntax.vars = uu____10047;_},us2))
                -> let b = FStar_Syntax_Syntax.fv_eq f g  in aux wl us1 us2
            | (FStar_Syntax_Syntax.Tm_uinst uu____10061,uu____10062) ->
                failwith "Impossible: expect head symbols to match"
            | (uu____10069,FStar_Syntax_Syntax.Tm_uinst uu____10070) ->
                failwith "Impossible: expect head symbols to match"
            | uu____10077 -> USolved wl

and (giveup_or_defer :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Common.prob -> worklist -> Prims.string -> solution)
  =
  fun env  ->
    fun orig  ->
      fun wl  ->
        fun msg  ->
          if wl.defer_ok
          then
            ((let uu____10087 =
                FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                  (FStar_Options.Other "Rel")
                 in
              if uu____10087
              then
                let uu____10088 = prob_to_string env orig  in
                FStar_Util.print2 "\n\t\tDeferring %s\n\t\tBecause %s\n"
                  uu____10088 msg
              else ());
             solve env (defer msg orig wl))
          else giveup env msg orig

and (solve_rigid_flex_meet :
  FStar_TypeChecker_Env.env ->
    tprob -> worklist -> worklist FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun tp  ->
      fun wl  ->
        (let uu____10097 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "RelCheck")
            in
         if uu____10097
         then
           let uu____10098 =
             FStar_Util.string_of_int tp.FStar_TypeChecker_Common.pid  in
           FStar_Util.print1 "Trying to solve by meeting refinements:%s\n"
             uu____10098
         else ());
        (let uu____10100 =
           FStar_Syntax_Util.head_and_args tp.FStar_TypeChecker_Common.rhs
            in
         match uu____10100 with
         | (u,args) ->
             let rec disjoin t1 t2 =
               let uu____10162 = head_matches_delta env () t1 t2  in
               match uu____10162 with
               | (mr,ts) ->
                   (match mr with
                    | MisMatch uu____10203 -> FStar_Pervasives_Native.None
                    | FullMatch  ->
                        (match ts with
                         | FStar_Pervasives_Native.None  ->
                             FStar_Pervasives_Native.Some (t1, [])
                         | FStar_Pervasives_Native.Some (t11,t21) ->
                             FStar_Pervasives_Native.Some (t11, []))
                    | HeadMatch  ->
                        let uu____10252 =
                          match ts with
                          | FStar_Pervasives_Native.Some (t11,t21) ->
                              let uu____10267 =
                                FStar_Syntax_Subst.compress t11  in
                              let uu____10268 =
                                FStar_Syntax_Subst.compress t21  in
                              (uu____10267, uu____10268)
                          | FStar_Pervasives_Native.None  ->
                              let uu____10273 =
                                FStar_Syntax_Subst.compress t1  in
                              let uu____10274 =
                                FStar_Syntax_Subst.compress t2  in
                              (uu____10273, uu____10274)
                           in
                        (match uu____10252 with
                         | (t11,t21) ->
                             let eq_prob t12 t22 =
                               let uu____10300 =
                                 new_problem env t12
                                   FStar_TypeChecker_Common.EQ t22
                                   FStar_Pervasives_Native.None
                                   t12.FStar_Syntax_Syntax.pos
                                   "meeting refinements"
                                  in
                               FStar_All.pipe_left
                                 (fun _0_52  ->
                                    FStar_TypeChecker_Common.TProb _0_52)
                                 uu____10300
                                in
                             (match ((t11.FStar_Syntax_Syntax.n),
                                      (t21.FStar_Syntax_Syntax.n))
                              with
                              | (FStar_Syntax_Syntax.Tm_refine
                                 (x,phi1),FStar_Syntax_Syntax.Tm_refine
                                 (y,phi2)) ->
                                  let uu____10331 =
                                    let uu____10340 =
                                      let uu____10343 =
                                        let uu____10346 =
                                          let uu____10347 =
                                            let uu____10354 =
                                              FStar_Syntax_Util.mk_disj phi1
                                                phi2
                                               in
                                            (x, uu____10354)  in
                                          FStar_Syntax_Syntax.Tm_refine
                                            uu____10347
                                           in
                                        FStar_Syntax_Syntax.mk uu____10346
                                         in
                                      uu____10343
                                        FStar_Pervasives_Native.None
                                        t11.FStar_Syntax_Syntax.pos
                                       in
                                    let uu____10362 =
                                      let uu____10365 =
                                        eq_prob x.FStar_Syntax_Syntax.sort
                                          y.FStar_Syntax_Syntax.sort
                                         in
                                      [uu____10365]  in
                                    (uu____10340, uu____10362)  in
                                  FStar_Pervasives_Native.Some uu____10331
                              | (uu____10378,FStar_Syntax_Syntax.Tm_refine
                                 (x,uu____10380)) ->
                                  let uu____10385 =
                                    let uu____10392 =
                                      let uu____10395 =
                                        eq_prob x.FStar_Syntax_Syntax.sort
                                          t11
                                         in
                                      [uu____10395]  in
                                    (t11, uu____10392)  in
                                  FStar_Pervasives_Native.Some uu____10385
                              | (FStar_Syntax_Syntax.Tm_refine
                                 (x,uu____10405),uu____10406) ->
                                  let uu____10411 =
                                    let uu____10418 =
                                      let uu____10421 =
                                        eq_prob x.FStar_Syntax_Syntax.sort
                                          t21
                                         in
                                      [uu____10421]  in
                                    (t21, uu____10418)  in
                                  FStar_Pervasives_Native.Some uu____10411
                              | uu____10430 ->
                                  let uu____10435 =
                                    FStar_Syntax_Util.head_and_args t11  in
                                  (match uu____10435 with
                                   | (head1,uu____10459) ->
                                       let uu____10480 =
                                         let uu____10481 =
                                           FStar_Syntax_Util.un_uinst head1
                                            in
                                         uu____10481.FStar_Syntax_Syntax.n
                                          in
                                       (match uu____10480 with
                                        | FStar_Syntax_Syntax.Tm_fvar
                                            {
                                              FStar_Syntax_Syntax.fv_name =
                                                uu____10492;
                                              FStar_Syntax_Syntax.fv_delta =
                                                FStar_Syntax_Syntax.Delta_defined_at_level
                                                i;
                                              FStar_Syntax_Syntax.fv_qual =
                                                uu____10494;_}
                                            ->
                                            let prev =
                                              if i > (Prims.parse_int "1")
                                              then
                                                FStar_Syntax_Syntax.Delta_defined_at_level
                                                  (i - (Prims.parse_int "1"))
                                              else
                                                FStar_Syntax_Syntax.Delta_constant
                                               in
                                            let t12 =
                                              FStar_TypeChecker_Normalize.normalize
                                                [FStar_TypeChecker_Normalize.Weak;
                                                FStar_TypeChecker_Normalize.HNF;
                                                FStar_TypeChecker_Normalize.UnfoldUntil
                                                  prev] env t11
                                               in
                                            let t22 =
                                              FStar_TypeChecker_Normalize.normalize
                                                [FStar_TypeChecker_Normalize.Weak;
                                                FStar_TypeChecker_Normalize.HNF;
                                                FStar_TypeChecker_Normalize.UnfoldUntil
                                                  prev] env t21
                                               in
                                            disjoin t12 t22
                                        | uu____10501 ->
                                            FStar_Pervasives_Native.None)))))
                in
             let tt = u  in
             (match tt.FStar_Syntax_Syntax.n with
              | FStar_Syntax_Syntax.Tm_uvar (uv,uu____10514) ->
                  let uu____10539 =
                    FStar_All.pipe_right wl.attempting
                      (FStar_List.partition
                         (fun uu___111_10565  ->
                            match uu___111_10565 with
                            | FStar_TypeChecker_Common.TProb tp1 ->
                                (match tp1.FStar_TypeChecker_Common.rank with
                                 | FStar_Pervasives_Native.Some rank1 when
                                     is_rigid_flex rank1 ->
                                     let uu____10572 =
                                       FStar_Syntax_Util.head_and_args
                                         tp1.FStar_TypeChecker_Common.rhs
                                        in
                                     (match uu____10572 with
                                      | (u',uu____10588) ->
                                          let uu____10609 =
                                            let uu____10610 = whnf env u'  in
                                            uu____10610.FStar_Syntax_Syntax.n
                                             in
                                          (match uu____10609 with
                                           | FStar_Syntax_Syntax.Tm_uvar
                                               (uv',uu____10614) ->
                                               FStar_Syntax_Unionfind.equiv
                                                 uv uv'
                                           | uu____10639 -> false))
                                 | uu____10640 -> false)
                            | uu____10643 -> false))
                     in
                  (match uu____10539 with
                   | (lower_bounds,rest) ->
                       let rec make_lower_bound uu____10677 tps =
                         match uu____10677 with
                         | (bound,sub_probs) ->
                             (match tps with
                              | [] ->
                                  FStar_Pervasives_Native.Some
                                    (bound, sub_probs)
                              | (FStar_TypeChecker_Common.TProb hd1)::tl1 ->
                                  let uu____10725 =
                                    let uu____10734 =
                                      whnf env
                                        hd1.FStar_TypeChecker_Common.lhs
                                       in
                                    disjoin bound uu____10734  in
                                  (match uu____10725 with
                                   | FStar_Pervasives_Native.Some
                                       (bound1,sub1) ->
                                       make_lower_bound
                                         (bound1,
                                           (FStar_List.append sub1 sub_probs))
                                         tl1
                                   | FStar_Pervasives_Native.None  ->
                                       FStar_Pervasives_Native.None)
                              | uu____10769 -> FStar_Pervasives_Native.None)
                          in
                       let uu____10778 =
                         let uu____10787 =
                           let uu____10794 =
                             whnf env tp.FStar_TypeChecker_Common.lhs  in
                           (uu____10794, [])  in
                         make_lower_bound uu____10787 lower_bounds  in
                       (match uu____10778 with
                        | FStar_Pervasives_Native.None  ->
                            ((let uu____10806 =
                                FStar_All.pipe_left
                                  (FStar_TypeChecker_Env.debug env)
                                  (FStar_Options.Other "RelCheck")
                                 in
                              if uu____10806
                              then
                                FStar_Util.print_string "No lower bounds\n"
                              else ());
                             FStar_Pervasives_Native.None)
                        | FStar_Pervasives_Native.Some (lhs_bound,sub_probs)
                            ->
                            let eq_prob =
                              new_problem env lhs_bound
                                FStar_TypeChecker_Common.EQ
                                tp.FStar_TypeChecker_Common.rhs
                                FStar_Pervasives_Native.None
                                tp.FStar_TypeChecker_Common.loc
                                "meeting refinements"
                               in
                            ((let uu____10826 =
                                FStar_All.pipe_left
                                  (FStar_TypeChecker_Env.debug env)
                                  (FStar_Options.Other "RelCheck")
                                 in
                              if uu____10826
                              then
                                let wl' =
                                  let uu___140_10828 = wl  in
                                  {
                                    attempting =
                                      ((FStar_TypeChecker_Common.TProb
                                          eq_prob) :: sub_probs);
                                    wl_deferred =
                                      (uu___140_10828.wl_deferred);
                                    ctr = (uu___140_10828.ctr);
                                    defer_ok = (uu___140_10828.defer_ok);
                                    smt_ok = (uu___140_10828.smt_ok);
                                    tcenv = (uu___140_10828.tcenv)
                                  }  in
                                let uu____10829 = wl_to_string wl'  in
                                FStar_Util.print1
                                  "After meeting refinements: %s\n"
                                  uu____10829
                              else ());
                             (let uu____10831 =
                                solve_t env eq_prob
                                  (let uu___141_10833 = wl  in
                                   {
                                     attempting = sub_probs;
                                     wl_deferred =
                                       (uu___141_10833.wl_deferred);
                                     ctr = (uu___141_10833.ctr);
                                     defer_ok = (uu___141_10833.defer_ok);
                                     smt_ok = (uu___141_10833.smt_ok);
                                     tcenv = (uu___141_10833.tcenv)
                                   })
                                 in
                              match uu____10831 with
                              | Success uu____10836 ->
                                  let wl1 =
                                    let uu___142_10838 = wl  in
                                    {
                                      attempting = rest;
                                      wl_deferred =
                                        (uu___142_10838.wl_deferred);
                                      ctr = (uu___142_10838.ctr);
                                      defer_ok = (uu___142_10838.defer_ok);
                                      smt_ok = (uu___142_10838.smt_ok);
                                      tcenv = (uu___142_10838.tcenv)
                                    }  in
                                  let wl2 =
                                    solve_prob' false
                                      (FStar_TypeChecker_Common.TProb tp)
                                      FStar_Pervasives_Native.None [] wl1
                                     in
                                  let uu____10840 =
                                    FStar_List.fold_left
                                      (fun wl3  ->
                                         fun p  ->
                                           solve_prob' true p
                                             FStar_Pervasives_Native.None []
                                             wl3) wl2 lower_bounds
                                     in
                                  FStar_Pervasives_Native.Some wl2
                              | uu____10845 -> FStar_Pervasives_Native.None))))
              | uu____10846 -> failwith "Impossible: Not a rigid-flex"))

and (solve_flex_rigid_join :
  FStar_TypeChecker_Env.env ->
    tprob -> worklist -> worklist FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun tp  ->
      fun wl  ->
        (let uu____10855 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "RelCheck")
            in
         if uu____10855
         then
           let uu____10856 =
             FStar_Util.string_of_int tp.FStar_TypeChecker_Common.pid  in
           FStar_Util.print1 "Trying to solve by joining refinements:%s\n"
             uu____10856
         else ());
        (let uu____10858 =
           FStar_Syntax_Util.head_and_args tp.FStar_TypeChecker_Common.lhs
            in
         match uu____10858 with
         | (u,args) ->
             let uu____10897 =
               ((Prims.parse_int "0"), (Prims.parse_int "1"),
                 (Prims.parse_int "2"), (Prims.parse_int "3"),
                 (Prims.parse_int "4"))
                in
             (match uu____10897 with
              | (ok,head_match1,partial_match,fallback,failed_match) ->
                  let max1 i j = if i < j then j else i  in
                  let base_types_match t1 t2 =
                    let uu____10938 = FStar_Syntax_Util.head_and_args t1  in
                    match uu____10938 with
                    | (h1,args1) ->
                        let uu____10979 = FStar_Syntax_Util.head_and_args t2
                           in
                        (match uu____10979 with
                         | (h2,uu____10999) ->
                             (match ((h1.FStar_Syntax_Syntax.n),
                                      (h2.FStar_Syntax_Syntax.n))
                              with
                              | (FStar_Syntax_Syntax.Tm_fvar
                                 tc1,FStar_Syntax_Syntax.Tm_fvar tc2) ->
                                  let uu____11026 =
                                    FStar_Syntax_Syntax.fv_eq tc1 tc2  in
                                  if uu____11026
                                  then
                                    (if
                                       (FStar_List.length args1) =
                                         (Prims.parse_int "0")
                                     then FStar_Pervasives_Native.Some []
                                     else
                                       (let uu____11044 =
                                          let uu____11047 =
                                            let uu____11048 =
                                              new_problem env t1
                                                FStar_TypeChecker_Common.EQ
                                                t2
                                                FStar_Pervasives_Native.None
                                                t1.FStar_Syntax_Syntax.pos
                                                "joining refinements"
                                               in
                                            FStar_All.pipe_left
                                              (fun _0_53  ->
                                                 FStar_TypeChecker_Common.TProb
                                                   _0_53) uu____11048
                                             in
                                          [uu____11047]  in
                                        FStar_Pervasives_Native.Some
                                          uu____11044))
                                  else FStar_Pervasives_Native.None
                              | (FStar_Syntax_Syntax.Tm_name
                                 a,FStar_Syntax_Syntax.Tm_name b) ->
                                  if FStar_Syntax_Syntax.bv_eq a b
                                  then
                                    (if
                                       (FStar_List.length args1) =
                                         (Prims.parse_int "0")
                                     then FStar_Pervasives_Native.Some []
                                     else
                                       (let uu____11081 =
                                          let uu____11084 =
                                            let uu____11085 =
                                              new_problem env t1
                                                FStar_TypeChecker_Common.EQ
                                                t2
                                                FStar_Pervasives_Native.None
                                                t1.FStar_Syntax_Syntax.pos
                                                "joining refinements"
                                               in
                                            FStar_All.pipe_left
                                              (fun _0_54  ->
                                                 FStar_TypeChecker_Common.TProb
                                                   _0_54) uu____11085
                                             in
                                          [uu____11084]  in
                                        FStar_Pervasives_Native.Some
                                          uu____11081))
                                  else FStar_Pervasives_Native.None
                              | uu____11099 -> FStar_Pervasives_Native.None))
                     in
                  let conjoin t1 t2 =
                    match ((t1.FStar_Syntax_Syntax.n),
                            (t2.FStar_Syntax_Syntax.n))
                    with
                    | (FStar_Syntax_Syntax.Tm_refine
                       (x,phi1),FStar_Syntax_Syntax.Tm_refine (y,phi2)) ->
                        let m =
                          base_types_match x.FStar_Syntax_Syntax.sort
                            y.FStar_Syntax_Syntax.sort
                           in
                        (match m with
                         | FStar_Pervasives_Native.None  ->
                             FStar_Pervasives_Native.None
                         | FStar_Pervasives_Native.Some m1 ->
                             let x1 = FStar_Syntax_Syntax.freshen_bv x  in
                             let subst1 =
                               [FStar_Syntax_Syntax.DB
                                  ((Prims.parse_int "0"), x1)]
                                in
                             let phi11 = FStar_Syntax_Subst.subst subst1 phi1
                                in
                             let phi21 = FStar_Syntax_Subst.subst subst1 phi2
                                in
                             let uu____11189 =
                               let uu____11198 =
                                 let uu____11201 =
                                   FStar_Syntax_Util.mk_conj phi11 phi21  in
                                 FStar_Syntax_Util.refine x1 uu____11201  in
                               (uu____11198, m1)  in
                             FStar_Pervasives_Native.Some uu____11189)
                    | (uu____11214,FStar_Syntax_Syntax.Tm_refine
                       (y,uu____11216)) ->
                        let m =
                          base_types_match t1 y.FStar_Syntax_Syntax.sort  in
                        (match m with
                         | FStar_Pervasives_Native.None  ->
                             FStar_Pervasives_Native.None
                         | FStar_Pervasives_Native.Some m1 ->
                             FStar_Pervasives_Native.Some (t2, m1))
                    | (FStar_Syntax_Syntax.Tm_refine
                       (x,uu____11264),uu____11265) ->
                        let m =
                          base_types_match x.FStar_Syntax_Syntax.sort t2  in
                        (match m with
                         | FStar_Pervasives_Native.None  ->
                             FStar_Pervasives_Native.None
                         | FStar_Pervasives_Native.Some m1 ->
                             FStar_Pervasives_Native.Some (t1, m1))
                    | uu____11312 ->
                        let m = base_types_match t1 t2  in
                        (match m with
                         | FStar_Pervasives_Native.None  ->
                             FStar_Pervasives_Native.None
                         | FStar_Pervasives_Native.Some m1 ->
                             FStar_Pervasives_Native.Some (t1, m1))
                     in
                  let tt = u  in
                  (match tt.FStar_Syntax_Syntax.n with
                   | FStar_Syntax_Syntax.Tm_uvar (uv,uu____11365) ->
                       let uu____11390 =
                         FStar_All.pipe_right wl.attempting
                           (FStar_List.partition
                              (fun uu___112_11416  ->
                                 match uu___112_11416 with
                                 | FStar_TypeChecker_Common.TProb tp1 ->
                                     (match tp1.FStar_TypeChecker_Common.rank
                                      with
                                      | FStar_Pervasives_Native.Some rank1
                                          when is_flex_rigid rank1 ->
                                          let uu____11423 =
                                            FStar_Syntax_Util.head_and_args
                                              tp1.FStar_TypeChecker_Common.lhs
                                             in
                                          (match uu____11423 with
                                           | (u',uu____11439) ->
                                               let uu____11460 =
                                                 let uu____11461 =
                                                   whnf env u'  in
                                                 uu____11461.FStar_Syntax_Syntax.n
                                                  in
                                               (match uu____11460 with
                                                | FStar_Syntax_Syntax.Tm_uvar
                                                    (uv',uu____11465) ->
                                                    FStar_Syntax_Unionfind.equiv
                                                      uv uv'
                                                | uu____11490 -> false))
                                      | uu____11491 -> false)
                                 | uu____11494 -> false))
                          in
                       (match uu____11390 with
                        | (upper_bounds,rest) ->
                            let rec make_upper_bound uu____11532 tps =
                              match uu____11532 with
                              | (bound,sub_probs) ->
                                  (match tps with
                                   | [] ->
                                       FStar_Pervasives_Native.Some
                                         (bound, sub_probs)
                                   | (FStar_TypeChecker_Common.TProb
                                       hd1)::tl1 ->
                                       let uu____11594 =
                                         let uu____11605 =
                                           whnf env
                                             hd1.FStar_TypeChecker_Common.rhs
                                            in
                                         conjoin bound uu____11605  in
                                       (match uu____11594 with
                                        | FStar_Pervasives_Native.Some
                                            (bound1,sub1) ->
                                            make_upper_bound
                                              (bound1,
                                                (FStar_List.append sub1
                                                   sub_probs)) tl1
                                        | FStar_Pervasives_Native.None  ->
                                            FStar_Pervasives_Native.None)
                                   | uu____11656 ->
                                       FStar_Pervasives_Native.None)
                               in
                            let uu____11667 =
                              let uu____11678 =
                                let uu____11687 =
                                  whnf env tp.FStar_TypeChecker_Common.rhs
                                   in
                                (uu____11687, [])  in
                              make_upper_bound uu____11678 upper_bounds  in
                            (match uu____11667 with
                             | FStar_Pervasives_Native.None  ->
                                 ((let uu____11701 =
                                     FStar_All.pipe_left
                                       (FStar_TypeChecker_Env.debug env)
                                       (FStar_Options.Other "RelCheck")
                                      in
                                   if uu____11701
                                   then
                                     FStar_Util.print_string
                                       "No upper bounds\n"
                                   else ());
                                  FStar_Pervasives_Native.None)
                             | FStar_Pervasives_Native.Some
                                 (rhs_bound,sub_probs) ->
                                 let eq_prob =
                                   new_problem env
                                     tp.FStar_TypeChecker_Common.lhs
                                     FStar_TypeChecker_Common.EQ rhs_bound
                                     FStar_Pervasives_Native.None
                                     tp.FStar_TypeChecker_Common.loc
                                     "joining refinements"
                                    in
                                 ((let uu____11727 =
                                     FStar_All.pipe_left
                                       (FStar_TypeChecker_Env.debug env)
                                       (FStar_Options.Other "RelCheck")
                                      in
                                   if uu____11727
                                   then
                                     let wl' =
                                       let uu___143_11729 = wl  in
                                       {
                                         attempting =
                                           ((FStar_TypeChecker_Common.TProb
                                               eq_prob) :: sub_probs);
                                         wl_deferred =
                                           (uu___143_11729.wl_deferred);
                                         ctr = (uu___143_11729.ctr);
                                         defer_ok = (uu___143_11729.defer_ok);
                                         smt_ok = (uu___143_11729.smt_ok);
                                         tcenv = (uu___143_11729.tcenv)
                                       }  in
                                     let uu____11730 = wl_to_string wl'  in
                                     FStar_Util.print1
                                       "After joining refinements: %s\n"
                                       uu____11730
                                   else ());
                                  (let uu____11732 =
                                     solve_t env eq_prob
                                       (let uu___144_11734 = wl  in
                                        {
                                          attempting = sub_probs;
                                          wl_deferred =
                                            (uu___144_11734.wl_deferred);
                                          ctr = (uu___144_11734.ctr);
                                          defer_ok =
                                            (uu___144_11734.defer_ok);
                                          smt_ok = (uu___144_11734.smt_ok);
                                          tcenv = (uu___144_11734.tcenv)
                                        })
                                      in
                                   match uu____11732 with
                                   | Success uu____11737 ->
                                       let wl1 =
                                         let uu___145_11739 = wl  in
                                         {
                                           attempting = rest;
                                           wl_deferred =
                                             (uu___145_11739.wl_deferred);
                                           ctr = (uu___145_11739.ctr);
                                           defer_ok =
                                             (uu___145_11739.defer_ok);
                                           smt_ok = (uu___145_11739.smt_ok);
                                           tcenv = (uu___145_11739.tcenv)
                                         }  in
                                       let wl2 =
                                         solve_prob' false
                                           (FStar_TypeChecker_Common.TProb tp)
                                           FStar_Pervasives_Native.None []
                                           wl1
                                          in
                                       let uu____11741 =
                                         FStar_List.fold_left
                                           (fun wl3  ->
                                              fun p  ->
                                                solve_prob' true p
                                                  FStar_Pervasives_Native.None
                                                  [] wl3) wl2 upper_bounds
                                          in
                                       FStar_Pervasives_Native.Some wl2
                                   | uu____11746 ->
                                       FStar_Pervasives_Native.None))))
                   | uu____11747 -> failwith "Impossible: Not a flex-rigid")))

and (solve_binders :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.binders ->
      FStar_Syntax_Syntax.binders ->
        FStar_TypeChecker_Common.prob ->
          worklist ->
            (FStar_Syntax_Syntax.binders ->
               FStar_TypeChecker_Env.env ->
                 FStar_Syntax_Syntax.subst_elt Prims.list ->
                   FStar_TypeChecker_Common.prob)
              -> solution)
  =
  fun env  ->
    fun bs1  ->
      fun bs2  ->
        fun orig  ->
          fun wl  ->
            fun rhs  ->
              let rec aux scope env1 subst1 xs ys =
                match (xs, ys) with
                | ([],[]) ->
                    let rhs_prob = rhs scope env1 subst1  in
                    ((let uu____11822 =
                        FStar_All.pipe_left
                          (FStar_TypeChecker_Env.debug env1)
                          (FStar_Options.Other "Rel")
                         in
                      if uu____11822
                      then
                        let uu____11823 = prob_to_string env1 rhs_prob  in
                        FStar_Util.print1 "rhs_prob = %s\n" uu____11823
                      else ());
                     (let formula =
                        FStar_All.pipe_right (p_guard rhs_prob)
                          FStar_Pervasives_Native.fst
                         in
                      FStar_Util.Inl ([rhs_prob], formula)))
                | ((hd1,imp)::xs1,(hd2,imp')::ys1) when imp = imp' ->
                    let hd11 =
                      let uu___146_11877 = hd1  in
                      let uu____11878 =
                        FStar_Syntax_Subst.subst subst1
                          hd1.FStar_Syntax_Syntax.sort
                         in
                      {
                        FStar_Syntax_Syntax.ppname =
                          (uu___146_11877.FStar_Syntax_Syntax.ppname);
                        FStar_Syntax_Syntax.index =
                          (uu___146_11877.FStar_Syntax_Syntax.index);
                        FStar_Syntax_Syntax.sort = uu____11878
                      }  in
                    let hd21 =
                      let uu___147_11882 = hd2  in
                      let uu____11883 =
                        FStar_Syntax_Subst.subst subst1
                          hd2.FStar_Syntax_Syntax.sort
                         in
                      {
                        FStar_Syntax_Syntax.ppname =
                          (uu___147_11882.FStar_Syntax_Syntax.ppname);
                        FStar_Syntax_Syntax.index =
                          (uu___147_11882.FStar_Syntax_Syntax.index);
                        FStar_Syntax_Syntax.sort = uu____11883
                      }  in
                    let prob =
                      let uu____11887 =
                        let uu____11892 =
                          FStar_All.pipe_left invert_rel (p_rel orig)  in
                        mk_problem scope orig hd11.FStar_Syntax_Syntax.sort
                          uu____11892 hd21.FStar_Syntax_Syntax.sort
                          FStar_Pervasives_Native.None "Formal parameter"
                         in
                      FStar_All.pipe_left
                        (fun _0_55  -> FStar_TypeChecker_Common.TProb _0_55)
                        uu____11887
                       in
                    let hd12 = FStar_Syntax_Syntax.freshen_bv hd11  in
                    let subst2 =
                      let uu____11903 =
                        FStar_Syntax_Subst.shift_subst (Prims.parse_int "1")
                          subst1
                         in
                      (FStar_Syntax_Syntax.DB ((Prims.parse_int "0"), hd12))
                        :: uu____11903
                       in
                    let env2 = FStar_TypeChecker_Env.push_bv env1 hd12  in
                    let uu____11907 =
                      aux (FStar_List.append scope [(hd12, imp)]) env2 subst2
                        xs1 ys1
                       in
                    (match uu____11907 with
                     | FStar_Util.Inl (sub_probs,phi) ->
                         let phi1 =
                           let uu____11945 =
                             FStar_All.pipe_right (p_guard prob)
                               FStar_Pervasives_Native.fst
                              in
                           let uu____11950 =
                             close_forall env2 [(hd12, imp)] phi  in
                           FStar_Syntax_Util.mk_conj uu____11945 uu____11950
                            in
                         ((let uu____11960 =
                             FStar_All.pipe_left
                               (FStar_TypeChecker_Env.debug env2)
                               (FStar_Options.Other "Rel")
                              in
                           if uu____11960
                           then
                             let uu____11961 =
                               FStar_Syntax_Print.term_to_string phi1  in
                             let uu____11962 =
                               FStar_Syntax_Print.bv_to_string hd12  in
                             FStar_Util.print2 "Formula is %s\n\thd1=%s\n"
                               uu____11961 uu____11962
                           else ());
                          FStar_Util.Inl ((prob :: sub_probs), phi1))
                     | fail1 -> fail1)
                | uu____11985 ->
                    FStar_Util.Inr "arity or argument-qualifier mismatch"
                 in
              let scope = p_scope orig  in
              let uu____11995 = aux scope env [] bs1 bs2  in
              match uu____11995 with
              | FStar_Util.Inr msg -> giveup env msg orig
              | FStar_Util.Inl (sub_probs,phi) ->
                  let wl1 =
                    solve_prob orig (FStar_Pervasives_Native.Some phi) [] wl
                     in
                  solve env (attempt sub_probs wl1)

and (solve_t : FStar_TypeChecker_Env.env -> tprob -> worklist -> solution) =
  fun env  ->
    fun problem  ->
      fun wl  ->
        def_check_prob "solve_t" (FStar_TypeChecker_Common.TProb problem);
        (let uu____12020 = compress_tprob wl problem  in
         solve_t' env uu____12020 wl)

and (solve_t' : FStar_TypeChecker_Env.env -> tprob -> worklist -> solution) =
  fun env  ->
    fun problem  ->
      fun wl  ->
        def_check_prob "solve_t'.1" (FStar_TypeChecker_Common.TProb problem);
        (let giveup_or_defer1 orig msg = giveup_or_defer env orig wl msg  in
         let rigid_rigid_delta env1 orig wl1 head1 head2 t1 t2 =
           let uu____12054 = head_matches_delta env1 wl1 t1 t2  in
           match uu____12054 with
           | (m,o) ->
               (match (m, o) with
                | (MisMatch uu____12085,uu____12086) ->
                    let rec may_relate head3 =
                      let uu____12111 =
                        let uu____12112 = FStar_Syntax_Subst.compress head3
                           in
                        uu____12112.FStar_Syntax_Syntax.n  in
                      match uu____12111 with
                      | FStar_Syntax_Syntax.Tm_name uu____12115 -> true
                      | FStar_Syntax_Syntax.Tm_match uu____12116 -> true
                      | FStar_Syntax_Syntax.Tm_fvar
                          { FStar_Syntax_Syntax.fv_name = uu____12139;
                            FStar_Syntax_Syntax.fv_delta =
                              FStar_Syntax_Syntax.Delta_equational ;
                            FStar_Syntax_Syntax.fv_qual = uu____12140;_}
                          -> true
                      | FStar_Syntax_Syntax.Tm_fvar
                          { FStar_Syntax_Syntax.fv_name = uu____12143;
                            FStar_Syntax_Syntax.fv_delta =
                              FStar_Syntax_Syntax.Delta_abstract uu____12144;
                            FStar_Syntax_Syntax.fv_qual = uu____12145;_}
                          ->
                          problem.FStar_TypeChecker_Common.relation =
                            FStar_TypeChecker_Common.EQ
                      | FStar_Syntax_Syntax.Tm_ascribed
                          (t,uu____12149,uu____12150) -> may_relate t
                      | FStar_Syntax_Syntax.Tm_uinst (t,uu____12192) ->
                          may_relate t
                      | FStar_Syntax_Syntax.Tm_meta (t,uu____12198) ->
                          may_relate t
                      | uu____12203 -> false  in
                    let uu____12204 =
                      ((may_relate head1) || (may_relate head2)) &&
                        wl1.smt_ok
                       in
                    if uu____12204
                    then
                      let guard =
                        if
                          problem.FStar_TypeChecker_Common.relation =
                            FStar_TypeChecker_Common.EQ
                        then mk_eq2 orig t1 t2
                        else
                          (let has_type_guard t11 t21 =
                             match problem.FStar_TypeChecker_Common.element
                             with
                             | FStar_Pervasives_Native.Some t ->
                                 FStar_Syntax_Util.mk_has_type t11 t t21
                             | FStar_Pervasives_Native.None  ->
                                 let x =
                                   FStar_Syntax_Syntax.new_bv
                                     FStar_Pervasives_Native.None t11
                                    in
                                 let u_x =
                                   env1.FStar_TypeChecker_Env.universe_of
                                     env1 t11
                                    in
                                 let uu____12221 =
                                   let uu____12222 =
                                     FStar_Syntax_Syntax.bv_to_name x  in
                                   FStar_Syntax_Util.mk_has_type t11
                                     uu____12222 t21
                                    in
                                 FStar_Syntax_Util.mk_forall u_x x
                                   uu____12221
                              in
                           if
                             problem.FStar_TypeChecker_Common.relation =
                               FStar_TypeChecker_Common.SUB
                           then has_type_guard t1 t2
                           else has_type_guard t2 t1)
                         in
                      let uu____12224 =
                        solve_prob orig (FStar_Pervasives_Native.Some guard)
                          [] wl1
                         in
                      solve env1 uu____12224
                    else
                      (let uu____12226 =
                         let uu____12227 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____12228 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.format2 "head mismatch (%s vs %s)"
                           uu____12227 uu____12228
                          in
                       giveup env1 uu____12226 orig)
                | (uu____12229,FStar_Pervasives_Native.Some (t11,t21)) ->
                    solve_t env1
                      (let uu___148_12243 = problem  in
                       {
                         FStar_TypeChecker_Common.pid =
                           (uu___148_12243.FStar_TypeChecker_Common.pid);
                         FStar_TypeChecker_Common.lhs = t11;
                         FStar_TypeChecker_Common.relation =
                           (uu___148_12243.FStar_TypeChecker_Common.relation);
                         FStar_TypeChecker_Common.rhs = t21;
                         FStar_TypeChecker_Common.element =
                           (uu___148_12243.FStar_TypeChecker_Common.element);
                         FStar_TypeChecker_Common.logical_guard =
                           (uu___148_12243.FStar_TypeChecker_Common.logical_guard);
                         FStar_TypeChecker_Common.scope =
                           (uu___148_12243.FStar_TypeChecker_Common.scope);
                         FStar_TypeChecker_Common.reason =
                           (uu___148_12243.FStar_TypeChecker_Common.reason);
                         FStar_TypeChecker_Common.loc =
                           (uu___148_12243.FStar_TypeChecker_Common.loc);
                         FStar_TypeChecker_Common.rank =
                           (uu___148_12243.FStar_TypeChecker_Common.rank)
                       }) wl1
                | (uu____12244,FStar_Pervasives_Native.None ) ->
                    ((let uu____12256 =
                        FStar_All.pipe_left
                          (FStar_TypeChecker_Env.debug env1)
                          (FStar_Options.Other "Rel")
                         in
                      if uu____12256
                      then
                        let uu____12257 =
                          FStar_Syntax_Print.term_to_string t1  in
                        let uu____12258 = FStar_Syntax_Print.tag_of_term t1
                           in
                        let uu____12259 =
                          FStar_Syntax_Print.term_to_string t2  in
                        let uu____12260 = FStar_Syntax_Print.tag_of_term t2
                           in
                        FStar_Util.print4
                          "Head matches: %s (%s) and %s (%s)\n" uu____12257
                          uu____12258 uu____12259 uu____12260
                      else ());
                     (let uu____12262 = FStar_Syntax_Util.head_and_args t1
                         in
                      match uu____12262 with
                      | (head11,args1) ->
                          let uu____12299 =
                            FStar_Syntax_Util.head_and_args t2  in
                          (match uu____12299 with
                           | (head21,args2) ->
                               let nargs = FStar_List.length args1  in
                               if nargs <> (FStar_List.length args2)
                               then
                                 let uu____12353 =
                                   let uu____12354 =
                                     FStar_Syntax_Print.term_to_string head11
                                      in
                                   let uu____12355 = args_to_string args1  in
                                   let uu____12356 =
                                     FStar_Syntax_Print.term_to_string head21
                                      in
                                   let uu____12357 = args_to_string args2  in
                                   FStar_Util.format4
                                     "unequal number of arguments: %s[%s] and %s[%s]"
                                     uu____12354 uu____12355 uu____12356
                                     uu____12357
                                    in
                                 giveup env1 uu____12353 orig
                               else
                                 (let uu____12359 =
                                    (nargs = (Prims.parse_int "0")) ||
                                      (let uu____12365 =
                                         FStar_Syntax_Util.eq_args args1
                                           args2
                                          in
                                       uu____12365 = FStar_Syntax_Util.Equal)
                                     in
                                  if uu____12359
                                  then
                                    let uu____12366 =
                                      solve_maybe_uinsts env1 orig head11
                                        head21 wl1
                                       in
                                    match uu____12366 with
                                    | USolved wl2 ->
                                        let uu____12368 =
                                          solve_prob orig
                                            FStar_Pervasives_Native.None []
                                            wl2
                                           in
                                        solve env1 uu____12368
                                    | UFailed msg -> giveup env1 msg orig
                                    | UDeferred wl2 ->
                                        solve env1
                                          (defer "universe constraints" orig
                                             wl2)
                                  else
                                    (let uu____12372 =
                                       base_and_refinement env1 t1  in
                                     match uu____12372 with
                                     | (base1,refinement1) ->
                                         let uu____12397 =
                                           base_and_refinement env1 t2  in
                                         (match uu____12397 with
                                          | (base2,refinement2) ->
                                              (match (refinement1,
                                                       refinement2)
                                               with
                                               | (FStar_Pervasives_Native.None
                                                  ,FStar_Pervasives_Native.None
                                                  ) ->
                                                   let uu____12454 =
                                                     solve_maybe_uinsts env1
                                                       orig head11 head21 wl1
                                                      in
                                                   (match uu____12454 with
                                                    | UFailed msg ->
                                                        giveup env1 msg orig
                                                    | UDeferred wl2 ->
                                                        solve env1
                                                          (defer
                                                             "universe constraints"
                                                             orig wl2)
                                                    | USolved wl2 ->
                                                        let subprobs =
                                                          FStar_List.map2
                                                            (fun uu____12476 
                                                               ->
                                                               fun
                                                                 uu____12477 
                                                                 ->
                                                                 match 
                                                                   (uu____12476,
                                                                    uu____12477)
                                                                 with
                                                                 | ((a,uu____12495),
                                                                    (a',uu____12497))
                                                                    ->
                                                                    let uu____12506
                                                                    =
                                                                    let uu____12511
                                                                    =
                                                                    p_scope
                                                                    orig  in
                                                                    mk_problem
                                                                    uu____12511
                                                                    orig a
                                                                    FStar_TypeChecker_Common.EQ
                                                                    a'
                                                                    FStar_Pervasives_Native.None
                                                                    "index"
                                                                     in
                                                                    FStar_All.pipe_left
                                                                    (fun
                                                                    _0_56  ->
                                                                    FStar_TypeChecker_Common.TProb
                                                                    _0_56)
                                                                    uu____12506)
                                                            args1 args2
                                                           in
                                                        let formula =
                                                          let uu____12517 =
                                                            FStar_List.map
                                                              (fun p  ->
                                                                 FStar_Pervasives_Native.fst
                                                                   (p_guard p))
                                                              subprobs
                                                             in
                                                          FStar_Syntax_Util.mk_conj_l
                                                            uu____12517
                                                           in
                                                        let wl3 =
                                                          solve_prob orig
                                                            (FStar_Pervasives_Native.Some
                                                               formula) []
                                                            wl2
                                                           in
                                                        solve env1
                                                          (attempt subprobs
                                                             wl3))
                                               | uu____12523 ->
                                                   let lhs =
                                                     force_refinement
                                                       (base1, refinement1)
                                                      in
                                                   let rhs =
                                                     force_refinement
                                                       (base2, refinement2)
                                                      in
                                                   solve_t env1
                                                     (let uu___149_12559 =
                                                        problem  in
                                                      {
                                                        FStar_TypeChecker_Common.pid
                                                          =
                                                          (uu___149_12559.FStar_TypeChecker_Common.pid);
                                                        FStar_TypeChecker_Common.lhs
                                                          = lhs;
                                                        FStar_TypeChecker_Common.relation
                                                          =
                                                          (uu___149_12559.FStar_TypeChecker_Common.relation);
                                                        FStar_TypeChecker_Common.rhs
                                                          = rhs;
                                                        FStar_TypeChecker_Common.element
                                                          =
                                                          (uu___149_12559.FStar_TypeChecker_Common.element);
                                                        FStar_TypeChecker_Common.logical_guard
                                                          =
                                                          (uu___149_12559.FStar_TypeChecker_Common.logical_guard);
                                                        FStar_TypeChecker_Common.scope
                                                          =
                                                          (uu___149_12559.FStar_TypeChecker_Common.scope);
                                                        FStar_TypeChecker_Common.reason
                                                          =
                                                          (uu___149_12559.FStar_TypeChecker_Common.reason);
                                                        FStar_TypeChecker_Common.loc
                                                          =
                                                          (uu___149_12559.FStar_TypeChecker_Common.loc);
                                                        FStar_TypeChecker_Common.rank
                                                          =
                                                          (uu___149_12559.FStar_TypeChecker_Common.rank)
                                                      }) wl1))))))))
            in
         let force_quasi_pattern xs_opt uu____12592 =
           match uu____12592 with
           | (t,u,k,args) ->
               let debug1 f =
                 let uu____12634 =
                   FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                     (FStar_Options.Other "Rel")
                    in
                 if uu____12634 then f () else ()  in
               let rec aux pat_args pat_args_set pattern_vars pattern_var_set
                 seen_formals formals res_t args1 =
                 debug1
                   (fun uu____12730  ->
                      let uu____12731 =
                        FStar_Syntax_Print.binders_to_string ", " pat_args
                         in
                      FStar_Util.print1 "pat_args so far: {%s}\n" uu____12731);
                 (match (formals, args1) with
                  | ([],[]) ->
                      let pat_args1 =
                        FStar_All.pipe_right (FStar_List.rev pat_args)
                          (FStar_List.map
                             (fun uu____12799  ->
                                match uu____12799 with
                                | (x,imp) ->
                                    let uu____12810 =
                                      FStar_Syntax_Syntax.bv_to_name x  in
                                    (uu____12810, imp)))
                         in
                      let pattern_vars1 = FStar_List.rev pattern_vars  in
                      let kk =
                        let uu____12823 = FStar_Syntax_Util.type_u ()  in
                        match uu____12823 with
                        | (t1,uu____12829) ->
                            let uu____12830 =
                              new_uvar t1.FStar_Syntax_Syntax.pos
                                pattern_vars1 t1
                               in
                            FStar_Pervasives_Native.fst uu____12830
                         in
                      let uu____12835 =
                        new_uvar t.FStar_Syntax_Syntax.pos pattern_vars1 kk
                         in
                      (match uu____12835 with
                       | (t',tm_u1) ->
                           let uu____12848 = destruct_flex_t t'  in
                           (match uu____12848 with
                            | (uu____12885,u1,k1,uu____12888) ->
                                let all_formals = FStar_List.rev seen_formals
                                   in
                                let k2 =
                                  let uu____12947 =
                                    FStar_Syntax_Syntax.mk_Total res_t  in
                                  FStar_Syntax_Util.arrow all_formals
                                    uu____12947
                                   in
                                let sol =
                                  let uu____12951 =
                                    let uu____12960 = u_abs k2 all_formals t'
                                       in
                                    ((u, k2), uu____12960)  in
                                  TERM uu____12951  in
                                let t_app =
                                  FStar_Syntax_Syntax.mk_Tm_app tm_u1
                                    pat_args1 FStar_Pervasives_Native.None
                                    t.FStar_Syntax_Syntax.pos
                                   in
                                FStar_Pervasives_Native.Some
                                  (sol, (t_app, u1, k1, pat_args1))))
                  | (formal::formals1,hd1::tl1) ->
                      (debug1
                         (fun uu____13095  ->
                            let uu____13096 =
                              FStar_Syntax_Print.binder_to_string formal  in
                            let uu____13097 =
                              FStar_Syntax_Print.args_to_string [hd1]  in
                            FStar_Util.print2
                              "force_quasi_pattern (case 2): formal=%s, hd=%s\n"
                              uu____13096 uu____13097);
                       (let uu____13110 = pat_var_opt env pat_args hd1  in
                        match uu____13110 with
                        | FStar_Pervasives_Native.None  ->
                            (debug1
                               (fun uu____13130  ->
                                  FStar_Util.print_string
                                    "not a pattern var\n");
                             aux pat_args pat_args_set pattern_vars
                               pattern_var_set (formal :: seen_formals)
                               formals1 res_t tl1)
                        | FStar_Pervasives_Native.Some y ->
                            let maybe_pat =
                              match xs_opt with
                              | FStar_Pervasives_Native.None  -> true
                              | FStar_Pervasives_Native.Some xs ->
                                  FStar_All.pipe_right xs
                                    (FStar_Util.for_some
                                       (fun uu____13173  ->
                                          match uu____13173 with
                                          | (x,uu____13179) ->
                                              FStar_Syntax_Syntax.bv_eq x
                                                (FStar_Pervasives_Native.fst
                                                   y)))
                               in
                            if Prims.op_Negation maybe_pat
                            then
                              aux pat_args pat_args_set pattern_vars
                                pattern_var_set (formal :: seen_formals)
                                formals1 res_t tl1
                            else
                              (debug1
                                 (fun uu____13194  ->
                                    let uu____13195 =
                                      FStar_Syntax_Print.args_to_string [hd1]
                                       in
                                    let uu____13208 =
                                      FStar_Syntax_Print.binder_to_string y
                                       in
                                    FStar_Util.print2
                                      "%s (var = %s) maybe pat\n" uu____13195
                                      uu____13208);
                               (let fvs =
                                  FStar_Syntax_Free.names
                                    (FStar_Pervasives_Native.fst y).FStar_Syntax_Syntax.sort
                                   in
                                let uu____13212 =
                                  let uu____13213 =
                                    FStar_Util.set_is_subset_of fvs
                                      pat_args_set
                                     in
                                  Prims.op_Negation uu____13213  in
                                if uu____13212
                                then
                                  (debug1
                                     (fun uu____13225  ->
                                        let uu____13226 =
                                          let uu____13229 =
                                            FStar_Syntax_Print.args_to_string
                                              [hd1]
                                             in
                                          let uu____13242 =
                                            let uu____13245 =
                                              FStar_Syntax_Print.binder_to_string
                                                y
                                               in
                                            let uu____13246 =
                                              let uu____13249 =
                                                FStar_Syntax_Print.term_to_string
                                                  (FStar_Pervasives_Native.fst
                                                     y).FStar_Syntax_Syntax.sort
                                                 in
                                              let uu____13250 =
                                                let uu____13253 =
                                                  names_to_string fvs  in
                                                let uu____13254 =
                                                  let uu____13257 =
                                                    names_to_string
                                                      pattern_var_set
                                                     in
                                                  [uu____13257]  in
                                                uu____13253 :: uu____13254
                                                 in
                                              uu____13249 :: uu____13250  in
                                            uu____13245 :: uu____13246  in
                                          uu____13229 :: uu____13242  in
                                        FStar_Util.print
                                          "BUT! %s (var = %s) is not a pat because its type %s contains {%s} fvs which are not included in the pattern vars so far {%s}\n"
                                          uu____13226);
                                   aux pat_args pat_args_set pattern_vars
                                     pattern_var_set (formal :: seen_formals)
                                     formals1 res_t tl1)
                                else
                                  (let uu____13259 =
                                     FStar_Util.set_add
                                       (FStar_Pervasives_Native.fst y)
                                       pat_args_set
                                      in
                                   let uu____13262 =
                                     FStar_Util.set_add
                                       (FStar_Pervasives_Native.fst formal)
                                       pattern_var_set
                                      in
                                   aux (y :: pat_args) uu____13259 (formal ::
                                     pattern_vars) uu____13262 (formal ::
                                     seen_formals) formals1 res_t tl1)))))
                  | ([],uu____13269::uu____13270) ->
                      let uu____13301 =
                        let uu____13314 =
                          FStar_TypeChecker_Normalize.unfold_whnf env res_t
                           in
                        FStar_Syntax_Util.arrow_formals uu____13314  in
                      (match uu____13301 with
                       | (more_formals,res_t1) ->
                           (match more_formals with
                            | [] -> FStar_Pervasives_Native.None
                            | uu____13353 ->
                                aux pat_args pat_args_set pattern_vars
                                  pattern_var_set seen_formals more_formals
                                  res_t1 args1))
                  | (uu____13360::uu____13361,[]) ->
                      FStar_Pervasives_Native.None)
                  in
               let uu____13384 =
                 let uu____13397 =
                   FStar_TypeChecker_Normalize.unfold_whnf env k  in
                 FStar_Syntax_Util.arrow_formals uu____13397  in
               (match uu____13384 with
                | (all_formals,res_t) ->
                    (debug1
                       (fun uu____13433  ->
                          let uu____13434 =
                            FStar_Syntax_Print.term_to_string t  in
                          let uu____13435 =
                            FStar_Syntax_Print.binders_to_string ", "
                              all_formals
                             in
                          let uu____13436 =
                            FStar_Syntax_Print.term_to_string res_t  in
                          let uu____13437 =
                            FStar_Syntax_Print.args_to_string args  in
                          FStar_Util.print4
                            "force_quasi_pattern of %s with all_formals={%s}, res_t={%s} and args={%s}\n"
                            uu____13434 uu____13435 uu____13436 uu____13437);
                     (let uu____13438 = FStar_Syntax_Syntax.new_bv_set ()  in
                      let uu____13441 = FStar_Syntax_Syntax.new_bv_set ()  in
                      aux [] uu____13438 [] uu____13441 [] all_formals res_t
                        args)))
            in
         let use_pattern_equality orig env1 wl1 lhs pat_vars1 rhs =
           let uu____13475 = lhs  in
           match uu____13475 with
           | (t1,uv,k_uv,args_lhs) ->
               let sol =
                 match pat_vars1 with
                 | [] -> rhs
                 | uu____13485 ->
                     let uu____13486 = sn_binders env1 pat_vars1  in
                     u_abs k_uv uu____13486 rhs
                  in
               let wl2 =
                 solve_prob orig FStar_Pervasives_Native.None
                   [TERM ((uv, k_uv), sol)] wl1
                  in
               solve env1 wl2
            in
         let imitate orig env1 wl1 p =
           let uu____13509 = p  in
           match uu____13509 with
           | (((u,k),xs,c),ps,(h,uu____13520,qs)) ->
               let xs1 = sn_binders env1 xs  in
               let r = FStar_TypeChecker_Env.get_range env1  in
               let uu____13602 = imitation_sub_probs orig env1 xs1 ps qs  in
               (match uu____13602 with
                | (sub_probs,gs_xs,formula) ->
                    let im =
                      let uu____13625 = h gs_xs  in
                      let uu____13626 =
                        FStar_All.pipe_right
                          (FStar_Syntax_Util.residual_comp_of_comp c)
                          (fun _0_57  -> FStar_Pervasives_Native.Some _0_57)
                         in
                      FStar_Syntax_Util.abs xs1 uu____13625 uu____13626  in
                    ((let uu____13632 =
                        FStar_All.pipe_left
                          (FStar_TypeChecker_Env.debug env1)
                          (FStar_Options.Other "Rel")
                         in
                      if uu____13632
                      then
                        let uu____13633 =
                          let uu____13636 =
                            let uu____13637 =
                              FStar_List.map tc_to_string gs_xs  in
                            FStar_All.pipe_right uu____13637
                              (FStar_String.concat "\n\t>")
                             in
                          let uu____13642 =
                            let uu____13645 =
                              FStar_Syntax_Print.binders_to_string ", " xs1
                               in
                            let uu____13646 =
                              let uu____13649 =
                                FStar_Syntax_Print.comp_to_string c  in
                              let uu____13650 =
                                let uu____13653 =
                                  FStar_Syntax_Print.term_to_string im  in
                                let uu____13654 =
                                  let uu____13657 =
                                    FStar_Syntax_Print.tag_of_term im  in
                                  let uu____13658 =
                                    let uu____13661 =
                                      let uu____13662 =
                                        FStar_List.map (prob_to_string env1)
                                          sub_probs
                                         in
                                      FStar_All.pipe_right uu____13662
                                        (FStar_String.concat ", ")
                                       in
                                    let uu____13667 =
                                      let uu____13670 =
                                        FStar_TypeChecker_Normalize.term_to_string
                                          env1 formula
                                         in
                                      [uu____13670]  in
                                    uu____13661 :: uu____13667  in
                                  uu____13657 :: uu____13658  in
                                uu____13653 :: uu____13654  in
                              uu____13649 :: uu____13650  in
                            uu____13645 :: uu____13646  in
                          uu____13636 :: uu____13642  in
                        FStar_Util.print
                          "Imitating gs_xs=\n\t>%s\n\t binders are {%s}, comp=%s\n\t%s (%s)\nsub_probs = %s\nformula=%s\n"
                          uu____13633
                      else ());
                     def_check_closed (p_loc orig) "imitate" im;
                     (let wl2 =
                        solve_prob orig
                          (FStar_Pervasives_Native.Some formula)
                          [TERM ((u, k), im)] wl1
                         in
                      solve env1 (attempt sub_probs wl2))))
            in
         let imitate' orig env1 wl1 uu___113_13692 =
           match uu___113_13692 with
           | FStar_Pervasives_Native.None  ->
               giveup env1 "unable to compute subterms" orig
           | FStar_Pervasives_Native.Some p -> imitate orig env1 wl1 p  in
         let project orig env1 wl1 i p =
           let uu____13724 = p  in
           match uu____13724 with
           | ((u,xs,c),ps,(h,matches,qs)) ->
               let r = FStar_TypeChecker_Env.get_range env1  in
               let uu____13815 = FStar_List.nth ps i  in
               (match uu____13815 with
                | (pi,uu____13819) ->
                    let uu____13824 = FStar_List.nth xs i  in
                    (match uu____13824 with
                     | (xi,uu____13836) ->
                         let rec gs k =
                           let uu____13849 =
                             let uu____13862 =
                               FStar_TypeChecker_Normalize.unfold_whnf env1 k
                                in
                             FStar_Syntax_Util.arrow_formals uu____13862  in
                           match uu____13849 with
                           | (bs,k1) ->
                               let rec aux subst1 bs1 =
                                 match bs1 with
                                 | [] -> ([], [])
                                 | (a,uu____13937)::tl1 ->
                                     let k_a =
                                       FStar_Syntax_Subst.subst subst1
                                         a.FStar_Syntax_Syntax.sort
                                        in
                                     let uu____13950 = new_uvar r xs k_a  in
                                     (match uu____13950 with
                                      | (gi_xs,gi) ->
                                          let gi_xs1 =
                                            FStar_TypeChecker_Normalize.eta_expand
                                              env1 gi_xs
                                             in
                                          let gi_ps =
                                            FStar_Syntax_Syntax.mk_Tm_app gi
                                              ps FStar_Pervasives_Native.None
                                              r
                                             in
                                          let subst2 =
                                            (FStar_Syntax_Syntax.NT
                                               (a, gi_xs1))
                                            :: subst1  in
                                          let uu____13972 = aux subst2 tl1
                                             in
                                          (match uu____13972 with
                                           | (gi_xs',gi_ps') ->
                                               let uu____13999 =
                                                 let uu____14002 =
                                                   FStar_Syntax_Syntax.as_arg
                                                     gi_xs1
                                                    in
                                                 uu____14002 :: gi_xs'  in
                                               let uu____14003 =
                                                 let uu____14006 =
                                                   FStar_Syntax_Syntax.as_arg
                                                     gi_ps
                                                    in
                                                 uu____14006 :: gi_ps'  in
                                               (uu____13999, uu____14003)))
                                  in
                               aux [] bs
                            in
                         let uu____14011 =
                           let uu____14012 = matches pi  in
                           FStar_All.pipe_left Prims.op_Negation uu____14012
                            in
                         if uu____14011
                         then FStar_Pervasives_Native.None
                         else
                           (let uu____14016 = gs xi.FStar_Syntax_Syntax.sort
                               in
                            match uu____14016 with
                            | (g_xs,uu____14028) ->
                                let xi1 = FStar_Syntax_Syntax.bv_to_name xi
                                   in
                                let proj =
                                  let uu____14039 =
                                    FStar_Syntax_Syntax.mk_Tm_app xi1 g_xs
                                      FStar_Pervasives_Native.None r
                                     in
                                  let uu____14040 =
                                    FStar_All.pipe_right
                                      (FStar_Syntax_Util.residual_comp_of_comp
                                         c)
                                      (fun _0_58  ->
                                         FStar_Pervasives_Native.Some _0_58)
                                     in
                                  FStar_Syntax_Util.abs xs uu____14039
                                    uu____14040
                                   in
                                let sub1 =
                                  let uu____14046 =
                                    let uu____14051 = p_scope orig  in
                                    let uu____14052 =
                                      FStar_Syntax_Syntax.mk_Tm_app proj ps
                                        FStar_Pervasives_Native.None r
                                       in
                                    let uu____14055 =
                                      let uu____14058 =
                                        FStar_List.map
                                          (fun uu____14073  ->
                                             match uu____14073 with
                                             | (uu____14082,uu____14083,y) ->
                                                 y) qs
                                         in
                                      FStar_All.pipe_left h uu____14058  in
                                    mk_problem uu____14051 orig uu____14052
                                      (p_rel orig) uu____14055
                                      FStar_Pervasives_Native.None
                                      "projection"
                                     in
                                  FStar_All.pipe_left
                                    (fun _0_59  ->
                                       FStar_TypeChecker_Common.TProb _0_59)
                                    uu____14046
                                   in
                                ((let uu____14098 =
                                    FStar_All.pipe_left
                                      (FStar_TypeChecker_Env.debug env1)
                                      (FStar_Options.Other "Rel")
                                     in
                                  if uu____14098
                                  then
                                    let uu____14099 =
                                      FStar_Syntax_Print.term_to_string proj
                                       in
                                    let uu____14100 =
                                      prob_to_string env1 sub1  in
                                    FStar_Util.print2
                                      "Projecting %s\n\tsubprob=%s\n"
                                      uu____14099 uu____14100
                                  else ());
                                 (let wl2 =
                                    let uu____14103 =
                                      let uu____14106 =
                                        FStar_All.pipe_left
                                          FStar_Pervasives_Native.fst
                                          (p_guard sub1)
                                         in
                                      FStar_Pervasives_Native.Some
                                        uu____14106
                                       in
                                    solve_prob orig uu____14103
                                      [TERM (u, proj)] wl1
                                     in
                                  let uu____14115 =
                                    solve env1 (attempt [sub1] wl2)  in
                                  FStar_All.pipe_left
                                    (fun _0_60  ->
                                       FStar_Pervasives_Native.Some _0_60)
                                    uu____14115)))))
            in
         let solve_t_flex_rigid patterns_only orig lhs t2 wl1 =
           let uu____14146 = lhs  in
           match uu____14146 with
           | ((t1,uv,k_uv,args_lhs),maybe_pat_vars) ->
               let subterms ps =
                 let uu____14182 = FStar_Syntax_Util.arrow_formals_comp k_uv
                    in
                 match uu____14182 with
                 | (xs,c) ->
                     if (FStar_List.length xs) = (FStar_List.length ps)
                     then
                       let uu____14215 =
                         let uu____14262 = decompose env t2  in
                         (((uv, k_uv), xs, c), ps, uu____14262)  in
                       FStar_Pervasives_Native.Some uu____14215
                     else
                       (let rec elim k args =
                          let k1 =
                            FStar_TypeChecker_Normalize.unfold_whnf env k  in
                          let uu____14406 =
                            let uu____14413 =
                              let uu____14414 =
                                FStar_Syntax_Subst.compress k1  in
                              uu____14414.FStar_Syntax_Syntax.n  in
                            (uu____14413, args)  in
                          match uu____14406 with
                          | (uu____14425,[]) ->
                              let uu____14428 =
                                let uu____14439 =
                                  FStar_Syntax_Syntax.mk_Total k1  in
                                ([], uu____14439)  in
                              FStar_Pervasives_Native.Some uu____14428
                          | (FStar_Syntax_Syntax.Tm_uvar
                             uu____14460,uu____14461) ->
                              let uu____14482 =
                                FStar_Syntax_Util.head_and_args k1  in
                              (match uu____14482 with
                               | (uv1,uv_args) ->
                                   let uu____14525 =
                                     let uu____14526 =
                                       FStar_Syntax_Subst.compress uv1  in
                                     uu____14526.FStar_Syntax_Syntax.n  in
                                   (match uu____14525 with
                                    | FStar_Syntax_Syntax.Tm_uvar
                                        (uvar,uu____14536) ->
                                        let uu____14561 =
                                          pat_vars env [] uv_args  in
                                        (match uu____14561 with
                                         | FStar_Pervasives_Native.None  ->
                                             FStar_Pervasives_Native.None
                                         | FStar_Pervasives_Native.Some scope
                                             ->
                                             let xs1 =
                                               FStar_All.pipe_right args
                                                 (FStar_List.map
                                                    (fun uu____14588  ->
                                                       let uu____14589 =
                                                         let uu____14590 =
                                                           let uu____14591 =
                                                             let uu____14596
                                                               =
                                                               let uu____14597
                                                                 =
                                                                 FStar_Syntax_Util.type_u
                                                                   ()
                                                                  in
                                                               FStar_All.pipe_right
                                                                 uu____14597
                                                                 FStar_Pervasives_Native.fst
                                                                in
                                                             new_uvar
                                                               k1.FStar_Syntax_Syntax.pos
                                                               scope
                                                               uu____14596
                                                              in
                                                           FStar_Pervasives_Native.fst
                                                             uu____14591
                                                            in
                                                         FStar_Syntax_Syntax.new_bv
                                                           (FStar_Pervasives_Native.Some
                                                              (k1.FStar_Syntax_Syntax.pos))
                                                           uu____14590
                                                          in
                                                       FStar_All.pipe_left
                                                         FStar_Syntax_Syntax.mk_binder
                                                         uu____14589))
                                                in
                                             let c1 =
                                               let uu____14607 =
                                                 let uu____14608 =
                                                   let uu____14613 =
                                                     let uu____14614 =
                                                       FStar_Syntax_Util.type_u
                                                         ()
                                                        in
                                                     FStar_All.pipe_right
                                                       uu____14614
                                                       FStar_Pervasives_Native.fst
                                                      in
                                                   new_uvar
                                                     k1.FStar_Syntax_Syntax.pos
                                                     scope uu____14613
                                                    in
                                                 FStar_Pervasives_Native.fst
                                                   uu____14608
                                                  in
                                               FStar_Syntax_Syntax.mk_Total
                                                 uu____14607
                                                in
                                             let k' =
                                               FStar_Syntax_Util.arrow xs1 c1
                                                in
                                             let uv_sol =
                                               let uu____14627 =
                                                 let uu____14630 =
                                                   let uu____14631 =
                                                     let uu____14634 =
                                                       FStar_Syntax_Util.type_u
                                                         ()
                                                        in
                                                     FStar_All.pipe_right
                                                       uu____14634
                                                       FStar_Pervasives_Native.fst
                                                      in
                                                   FStar_Syntax_Util.residual_tot
                                                     uu____14631
                                                    in
                                                 FStar_Pervasives_Native.Some
                                                   uu____14630
                                                  in
                                               FStar_Syntax_Util.abs scope k'
                                                 uu____14627
                                                in
                                             (def_check_closed (p_loc orig)
                                                "solve_t_flex_rigid.subterms"
                                                uv_sol;
                                              FStar_Syntax_Util.set_uvar uvar
                                                uv_sol;
                                              FStar_Pervasives_Native.Some
                                                (xs1, c1)))
                                    | uu____14653 ->
                                        FStar_Pervasives_Native.None))
                          | (FStar_Syntax_Syntax.Tm_app
                             uu____14658,uu____14659) ->
                              let uu____14678 =
                                FStar_Syntax_Util.head_and_args k1  in
                              (match uu____14678 with
                               | (uv1,uv_args) ->
                                   let uu____14721 =
                                     let uu____14722 =
                                       FStar_Syntax_Subst.compress uv1  in
                                     uu____14722.FStar_Syntax_Syntax.n  in
                                   (match uu____14721 with
                                    | FStar_Syntax_Syntax.Tm_uvar
                                        (uvar,uu____14732) ->
                                        let uu____14757 =
                                          pat_vars env [] uv_args  in
                                        (match uu____14757 with
                                         | FStar_Pervasives_Native.None  ->
                                             FStar_Pervasives_Native.None
                                         | FStar_Pervasives_Native.Some scope
                                             ->
                                             let xs1 =
                                               FStar_All.pipe_right args
                                                 (FStar_List.map
                                                    (fun uu____14784  ->
                                                       let uu____14785 =
                                                         let uu____14786 =
                                                           let uu____14787 =
                                                             let uu____14792
                                                               =
                                                               let uu____14793
                                                                 =
                                                                 FStar_Syntax_Util.type_u
                                                                   ()
                                                                  in
                                                               FStar_All.pipe_right
                                                                 uu____14793
                                                                 FStar_Pervasives_Native.fst
                                                                in
                                                             new_uvar
                                                               k1.FStar_Syntax_Syntax.pos
                                                               scope
                                                               uu____14792
                                                              in
                                                           FStar_Pervasives_Native.fst
                                                             uu____14787
                                                            in
                                                         FStar_Syntax_Syntax.new_bv
                                                           (FStar_Pervasives_Native.Some
                                                              (k1.FStar_Syntax_Syntax.pos))
                                                           uu____14786
                                                          in
                                                       FStar_All.pipe_left
                                                         FStar_Syntax_Syntax.mk_binder
                                                         uu____14785))
                                                in
                                             let c1 =
                                               let uu____14803 =
                                                 let uu____14804 =
                                                   let uu____14809 =
                                                     let uu____14810 =
                                                       FStar_Syntax_Util.type_u
                                                         ()
                                                        in
                                                     FStar_All.pipe_right
                                                       uu____14810
                                                       FStar_Pervasives_Native.fst
                                                      in
                                                   new_uvar
                                                     k1.FStar_Syntax_Syntax.pos
                                                     scope uu____14809
                                                    in
                                                 FStar_Pervasives_Native.fst
                                                   uu____14804
                                                  in
                                               FStar_Syntax_Syntax.mk_Total
                                                 uu____14803
                                                in
                                             let k' =
                                               FStar_Syntax_Util.arrow xs1 c1
                                                in
                                             let uv_sol =
                                               let uu____14823 =
                                                 let uu____14826 =
                                                   let uu____14827 =
                                                     let uu____14830 =
                                                       FStar_Syntax_Util.type_u
                                                         ()
                                                        in
                                                     FStar_All.pipe_right
                                                       uu____14830
                                                       FStar_Pervasives_Native.fst
                                                      in
                                                   FStar_Syntax_Util.residual_tot
                                                     uu____14827
                                                    in
                                                 FStar_Pervasives_Native.Some
                                                   uu____14826
                                                  in
                                               FStar_Syntax_Util.abs scope k'
                                                 uu____14823
                                                in
                                             (def_check_closed (p_loc orig)
                                                "solve_t_flex_rigid.subterms"
                                                uv_sol;
                                              FStar_Syntax_Util.set_uvar uvar
                                                uv_sol;
                                              FStar_Pervasives_Native.Some
                                                (xs1, c1)))
                                    | uu____14849 ->
                                        FStar_Pervasives_Native.None))
                          | (FStar_Syntax_Syntax.Tm_arrow
                             (xs1,c1),uu____14856) ->
                              let n_args = FStar_List.length args  in
                              let n_xs = FStar_List.length xs1  in
                              if n_xs = n_args
                              then
                                let uu____14897 =
                                  FStar_Syntax_Subst.open_comp xs1 c1  in
                                FStar_All.pipe_right uu____14897
                                  (fun _0_61  ->
                                     FStar_Pervasives_Native.Some _0_61)
                              else
                                if n_xs < n_args
                                then
                                  (let uu____14933 =
                                     FStar_Util.first_N n_xs args  in
                                   match uu____14933 with
                                   | (args1,rest) ->
                                       let uu____14962 =
                                         FStar_Syntax_Subst.open_comp xs1 c1
                                          in
                                       (match uu____14962 with
                                        | (xs2,c2) ->
                                            let uu____14975 =
                                              elim
                                                (FStar_Syntax_Util.comp_result
                                                   c2) rest
                                               in
                                            FStar_Util.bind_opt uu____14975
                                              (fun uu____14999  ->
                                                 match uu____14999 with
                                                 | (xs',c3) ->
                                                     FStar_Pervasives_Native.Some
                                                       ((FStar_List.append
                                                           xs2 xs'), c3))))
                                else
                                  (let uu____15039 =
                                     FStar_Util.first_N n_args xs1  in
                                   match uu____15039 with
                                   | (xs2,rest) ->
                                       let t =
                                         FStar_Syntax_Syntax.mk
                                           (FStar_Syntax_Syntax.Tm_arrow
                                              (rest, c1))
                                           FStar_Pervasives_Native.None
                                           k1.FStar_Syntax_Syntax.pos
                                          in
                                       let uu____15107 =
                                         let uu____15112 =
                                           FStar_Syntax_Syntax.mk_Total t  in
                                         FStar_Syntax_Subst.open_comp xs2
                                           uu____15112
                                          in
                                       FStar_All.pipe_right uu____15107
                                         (fun _0_62  ->
                                            FStar_Pervasives_Native.Some
                                              _0_62))
                          | uu____15127 ->
                              let uu____15134 =
                                let uu____15139 =
                                  let uu____15140 =
                                    FStar_Syntax_Print.uvar_to_string uv  in
                                  let uu____15141 =
                                    FStar_Syntax_Print.term_to_string k1  in
                                  let uu____15142 =
                                    FStar_Syntax_Print.term_to_string k_uv
                                     in
                                  FStar_Util.format3
                                    "Impossible: ill-typed application %s : %s\n\t%s"
                                    uu____15140 uu____15141 uu____15142
                                   in
                                (FStar_Errors.Fatal_IllTyped, uu____15139)
                                 in
                              FStar_Errors.raise_error uu____15134
                                t1.FStar_Syntax_Syntax.pos
                           in
                        let uu____15149 = elim k_uv ps  in
                        FStar_Util.bind_opt uu____15149
                          (fun uu____15204  ->
                             match uu____15204 with
                             | (xs1,c1) ->
                                 let uu____15253 =
                                   let uu____15294 = decompose env t2  in
                                   (((uv, k_uv), xs1, c1), ps, uu____15294)
                                    in
                                 FStar_Pervasives_Native.Some uu____15253))
                  in
               let imitate_or_project n1 lhs1 rhs stopt =
                 let fail1 uu____15415 =
                   giveup env
                     "flex-rigid case failed all backtracking attempts" orig
                    in
                 let rec try_project st i =
                   if i >= n1
                   then fail1 ()
                   else
                     (let tx = FStar_Syntax_Unionfind.new_transaction ()  in
                      let uu____15429 = project orig env wl1 i st  in
                      match uu____15429 with
                      | FStar_Pervasives_Native.None  ->
                          (FStar_Syntax_Unionfind.rollback tx;
                           try_project st (i + (Prims.parse_int "1")))
                      | FStar_Pervasives_Native.Some (Failed uu____15443) ->
                          (FStar_Syntax_Unionfind.rollback tx;
                           try_project st (i + (Prims.parse_int "1")))
                      | FStar_Pervasives_Native.Some sol -> sol)
                    in
                 if FStar_Option.isSome stopt
                 then
                   let st = FStar_Util.must stopt  in
                   let tx = FStar_Syntax_Unionfind.new_transaction ()  in
                   let uu____15458 = imitate orig env wl1 st  in
                   match uu____15458 with
                   | Failed uu____15463 ->
                       (FStar_Syntax_Unionfind.rollback tx;
                        try_project st (Prims.parse_int "0"))
                   | sol -> sol
                 else fail1 ()  in
               let pattern_eq_imitate_or_project n1 lhs1 rhs stopt =
                 let uu____15494 =
                   force_quasi_pattern FStar_Pervasives_Native.None lhs1  in
                 match uu____15494 with
                 | FStar_Pervasives_Native.None  ->
                     imitate_or_project n1 lhs1 rhs stopt
                 | FStar_Pervasives_Native.Some (sol,forced_lhs_pattern) ->
                     let uu____15517 = forced_lhs_pattern  in
                     (match uu____15517 with
                      | (lhs_t,uu____15519,uu____15520,uu____15521) ->
                          ((let uu____15523 =
                              FStar_TypeChecker_Env.debug env
                                (FStar_Options.Other "Rel")
                               in
                            if uu____15523
                            then
                              let uu____15524 = lhs1  in
                              match uu____15524 with
                              | (t0,uu____15526,uu____15527,uu____15528) ->
                                  let uu____15529 = forced_lhs_pattern  in
                                  (match uu____15529 with
                                   | (t11,uu____15531,uu____15532,uu____15533)
                                       ->
                                       let uu____15534 =
                                         FStar_Syntax_Print.term_to_string t0
                                          in
                                       let uu____15535 =
                                         FStar_Syntax_Print.term_to_string
                                           t11
                                          in
                                       FStar_Util.print2
                                         "force_quasi_pattern succeeded, turning %s into %s\n"
                                         uu____15534 uu____15535)
                            else ());
                           (let rhs_vars = FStar_Syntax_Free.names rhs  in
                            let lhs_vars = FStar_Syntax_Free.names lhs_t  in
                            let uu____15543 =
                              FStar_Util.set_is_subset_of rhs_vars lhs_vars
                               in
                            if uu____15543
                            then
                              ((let uu____15545 =
                                  FStar_TypeChecker_Env.debug env
                                    (FStar_Options.Other "Rel")
                                   in
                                if uu____15545
                                then
                                  let uu____15546 =
                                    FStar_Syntax_Print.term_to_string rhs  in
                                  let uu____15547 = names_to_string rhs_vars
                                     in
                                  let uu____15548 = names_to_string lhs_vars
                                     in
                                  FStar_Util.print3
                                    "fvar check succeeded for quasi pattern ...\n\trhs = %s, rhs_vars=%s\nlhs_vars=%s ... proceeding\n"
                                    uu____15546 uu____15547 uu____15548
                                else ());
                               (let tx =
                                  FStar_Syntax_Unionfind.new_transaction ()
                                   in
                                let wl2 =
                                  extend_solution (p_pid orig) [sol] wl1  in
                                let uu____15552 =
                                  let uu____15553 =
                                    FStar_TypeChecker_Common.as_tprob orig
                                     in
                                  solve_t env uu____15553 wl2  in
                                match uu____15552 with
                                | Failed uu____15554 ->
                                    (FStar_Syntax_Unionfind.rollback tx;
                                     imitate_or_project n1 lhs1 rhs stopt)
                                | sol1 -> sol1))
                            else
                              ((let uu____15563 =
                                  FStar_TypeChecker_Env.debug env
                                    (FStar_Options.Other "Rel")
                                   in
                                if uu____15563
                                then
                                  FStar_Util.print_string
                                    "fvar check failed for quasi pattern ... im/proj\n"
                                else ());
                               imitate_or_project n1 lhs1 rhs stopt))))
                  in
               let check_head fvs1 t21 =
                 let uu____15576 = FStar_Syntax_Util.head_and_args t21  in
                 match uu____15576 with
                 | (hd1,uu____15592) ->
                     (match hd1.FStar_Syntax_Syntax.n with
                      | FStar_Syntax_Syntax.Tm_arrow uu____15613 -> true
                      | FStar_Syntax_Syntax.Tm_constant uu____15626 -> true
                      | FStar_Syntax_Syntax.Tm_abs uu____15627 -> true
                      | uu____15644 ->
                          let fvs_hd = FStar_Syntax_Free.names hd1  in
                          let uu____15648 =
                            FStar_Util.set_is_subset_of fvs_hd fvs1  in
                          if uu____15648
                          then true
                          else
                            ((let uu____15651 =
                                FStar_All.pipe_left
                                  (FStar_TypeChecker_Env.debug env)
                                  (FStar_Options.Other "Rel")
                                 in
                              if uu____15651
                              then
                                let uu____15652 = names_to_string fvs_hd  in
                                FStar_Util.print1 "Free variables are %s\n"
                                  uu____15652
                              else ());
                             false))
                  in
               (match maybe_pat_vars with
                | FStar_Pervasives_Native.Some vars ->
                    let t11 = sn env t1  in
                    let t21 = sn env t2  in
                    let lhs1 = (t11, uv, k_uv, args_lhs)  in
                    let fvs1 = FStar_Syntax_Free.names t11  in
                    let fvs2 = FStar_Syntax_Free.names t21  in
                    let uu____15672 = occurs_check env wl1 (uv, k_uv) t21  in
                    (match uu____15672 with
                     | (occurs_ok,msg) ->
                         if Prims.op_Negation occurs_ok
                         then
                           let uu____15685 =
                             let uu____15686 = FStar_Option.get msg  in
                             Prims.strcat "occurs-check failed: " uu____15686
                              in
                           giveup_or_defer1 orig uu____15685
                         else
                           (let uu____15688 =
                              FStar_Util.set_is_subset_of fvs2 fvs1  in
                            if uu____15688
                            then
                              let uu____15689 =
                                ((Prims.op_Negation patterns_only) &&
                                   (FStar_Syntax_Util.is_function_typ t21))
                                  &&
                                  ((p_rel orig) <>
                                     FStar_TypeChecker_Common.EQ)
                                 in
                              (if uu____15689
                               then
                                 let uu____15690 = subterms args_lhs  in
                                 imitate' orig env wl1 uu____15690
                               else
                                 ((let uu____15695 =
                                     FStar_All.pipe_left
                                       (FStar_TypeChecker_Env.debug env)
                                       (FStar_Options.Other "Rel")
                                      in
                                   if uu____15695
                                   then
                                     let uu____15696 =
                                       FStar_Syntax_Print.term_to_string t11
                                        in
                                     let uu____15697 = names_to_string fvs1
                                        in
                                     let uu____15698 = names_to_string fvs2
                                        in
                                     FStar_Util.print3
                                       "Pattern %s with fvars=%s succeeded fvar check: %s\n"
                                       uu____15696 uu____15697 uu____15698
                                   else ());
                                  use_pattern_equality orig env wl1 lhs1 vars
                                    t21))
                            else
                              if
                                ((Prims.op_Negation patterns_only) &&
                                   wl1.defer_ok)
                                  &&
                                  ((p_rel orig) <>
                                     FStar_TypeChecker_Common.EQ)
                              then
                                solve env
                                  (defer
                                     "flex pattern/rigid: occurs or freevar check"
                                     orig wl1)
                              else
                                (let uu____15702 =
                                   (Prims.op_Negation patterns_only) &&
                                     (check_head fvs1 t21)
                                    in
                                 if uu____15702
                                 then
                                   ((let uu____15704 =
                                       FStar_All.pipe_left
                                         (FStar_TypeChecker_Env.debug env)
                                         (FStar_Options.Other "Rel")
                                        in
                                     if uu____15704
                                     then
                                       let uu____15705 =
                                         FStar_Syntax_Print.term_to_string
                                           t11
                                          in
                                       let uu____15706 = names_to_string fvs1
                                          in
                                       let uu____15707 = names_to_string fvs2
                                          in
                                       FStar_Util.print3
                                         "Pattern %s with fvars=%s failed fvar check: %s ... imitate_or_project\n"
                                         uu____15705 uu____15706 uu____15707
                                     else ());
                                    (let uu____15709 = subterms args_lhs  in
                                     imitate_or_project
                                       (FStar_List.length args_lhs) lhs1 t21
                                       uu____15709))
                                 else
                                   giveup env
                                     "free-variable check failed on a non-redex"
                                     orig)))
                | FStar_Pervasives_Native.None  when patterns_only ->
                    giveup env "not a pattern" orig
                | FStar_Pervasives_Native.None  ->
                    if wl1.defer_ok
                    then solve env (defer "not a pattern" orig wl1)
                    else
                      (let uu____15720 =
                         let uu____15721 = FStar_Syntax_Free.names t1  in
                         check_head uu____15721 t2  in
                       if uu____15720
                       then
                         let n_args_lhs = FStar_List.length args_lhs  in
                         ((let uu____15732 =
                             FStar_All.pipe_left
                               (FStar_TypeChecker_Env.debug env)
                               (FStar_Options.Other "Rel")
                              in
                           if uu____15732
                           then
                             let uu____15733 =
                               FStar_Syntax_Print.term_to_string t1  in
                             let uu____15734 =
                               FStar_Util.string_of_int n_args_lhs  in
                             FStar_Util.print2
                               "Not a pattern (%s) ... (lhs has %s args)\n"
                               uu____15733 uu____15734
                           else ());
                          (let uu____15742 = subterms args_lhs  in
                           pattern_eq_imitate_or_project n_args_lhs
                             (FStar_Pervasives_Native.fst lhs) t2 uu____15742))
                       else giveup env "head-symbol is free" orig))
            in
         let flex_flex1 orig lhs rhs =
           if wl.defer_ok && ((p_rel orig) <> FStar_TypeChecker_Common.EQ)
           then solve env (defer "flex-flex deferred" orig wl)
           else
             (let solve_both_pats wl1 uu____15819 uu____15820 r =
                match (uu____15819, uu____15820) with
                | ((u1,k1,xs,args1),(u2,k2,ys,args2)) ->
                    let uu____16018 =
                      (FStar_Syntax_Unionfind.equiv u1 u2) &&
                        (binders_eq xs ys)
                       in
                    if uu____16018
                    then
                      let uu____16019 =
                        solve_prob orig FStar_Pervasives_Native.None [] wl1
                         in
                      solve env uu____16019
                    else
                      (let xs1 = sn_binders env xs  in
                       let ys1 = sn_binders env ys  in
                       let zs = intersect_vars xs1 ys1  in
                       (let uu____16043 =
                          FStar_All.pipe_left
                            (FStar_TypeChecker_Env.debug env)
                            (FStar_Options.Other "Rel")
                           in
                        if uu____16043
                        then
                          let uu____16044 =
                            FStar_Syntax_Print.binders_to_string ", " xs1  in
                          let uu____16045 =
                            FStar_Syntax_Print.binders_to_string ", " ys1  in
                          let uu____16046 =
                            FStar_Syntax_Print.binders_to_string ", " zs  in
                          let uu____16047 =
                            FStar_Syntax_Print.term_to_string k1  in
                          let uu____16048 =
                            FStar_Syntax_Print.term_to_string k2  in
                          FStar_Util.print5
                            "Flex-flex patterns: intersected %s and %s; got %s\n\tk1=%s\n\tk2=%s\n"
                            uu____16044 uu____16045 uu____16046 uu____16047
                            uu____16048
                        else ());
                       (let subst_k k xs2 args =
                          let xs_len = FStar_List.length xs2  in
                          let args_len = FStar_List.length args  in
                          if xs_len = args_len
                          then
                            let uu____16108 =
                              FStar_Syntax_Util.subst_of_list xs2 args  in
                            FStar_Syntax_Subst.subst uu____16108 k
                          else
                            if args_len < xs_len
                            then
                              (let uu____16122 =
                                 FStar_Util.first_N args_len xs2  in
                               match uu____16122 with
                               | (xs3,xs_rest) ->
                                   let k3 =
                                     let uu____16176 =
                                       FStar_Syntax_Syntax.mk_GTotal k  in
                                     FStar_Syntax_Util.arrow xs_rest
                                       uu____16176
                                      in
                                   let uu____16179 =
                                     FStar_Syntax_Util.subst_of_list xs3 args
                                      in
                                   FStar_Syntax_Subst.subst uu____16179 k3)
                            else
                              (let uu____16183 =
                                 let uu____16184 =
                                   FStar_Syntax_Print.term_to_string k  in
                                 let uu____16185 =
                                   FStar_Syntax_Print.binders_to_string ", "
                                     xs2
                                    in
                                 let uu____16186 =
                                   FStar_Syntax_Print.args_to_string args  in
                                 FStar_Util.format3
                                   "k=%s\nxs=%s\nargs=%s\nIll-formed substitutution"
                                   uu____16184 uu____16185 uu____16186
                                  in
                               failwith uu____16183)
                           in
                        let uu____16187 =
                          let uu____16194 =
                            let uu____16207 =
                              FStar_TypeChecker_Normalize.normalize
                                [FStar_TypeChecker_Normalize.Beta] env k1
                               in
                            FStar_Syntax_Util.arrow_formals uu____16207  in
                          match uu____16194 with
                          | (bs,k1') ->
                              let uu____16232 =
                                let uu____16245 =
                                  FStar_TypeChecker_Normalize.normalize
                                    [FStar_TypeChecker_Normalize.Beta] env k2
                                   in
                                FStar_Syntax_Util.arrow_formals uu____16245
                                 in
                              (match uu____16232 with
                               | (cs,k2') ->
                                   let k1'_xs = subst_k k1' bs args1  in
                                   let k2'_ys = subst_k k2' cs args2  in
                                   let sub_prob =
                                     let uu____16273 =
                                       let uu____16278 = p_scope orig  in
                                       mk_problem uu____16278 orig k1'_xs
                                         FStar_TypeChecker_Common.EQ k2'_ys
                                         FStar_Pervasives_Native.None
                                         "flex-flex kinding"
                                        in
                                     FStar_All.pipe_left
                                       (fun _0_63  ->
                                          FStar_TypeChecker_Common.TProb
                                            _0_63) uu____16273
                                      in
                                   let uu____16283 =
                                     let uu____16288 =
                                       let uu____16289 =
                                         FStar_Syntax_Subst.compress k1'  in
                                       uu____16289.FStar_Syntax_Syntax.n  in
                                     let uu____16292 =
                                       let uu____16293 =
                                         FStar_Syntax_Subst.compress k2'  in
                                       uu____16293.FStar_Syntax_Syntax.n  in
                                     (uu____16288, uu____16292)  in
                                   (match uu____16283 with
                                    | (FStar_Syntax_Syntax.Tm_type
                                       uu____16302,uu____16303) ->
                                        (k1'_xs, [sub_prob])
                                    | (uu____16306,FStar_Syntax_Syntax.Tm_type
                                       uu____16307) -> (k2'_ys, [sub_prob])
                                    | uu____16310 ->
                                        let uu____16315 =
                                          FStar_Syntax_Util.type_u ()  in
                                        (match uu____16315 with
                                         | (t,uu____16327) ->
                                             let uu____16328 =
                                               new_uvar r zs t  in
                                             (match uu____16328 with
                                              | (k_zs,uu____16340) ->
                                                  let kprob =
                                                    let uu____16342 =
                                                      let uu____16347 =
                                                        p_scope orig  in
                                                      mk_problem uu____16347
                                                        orig k1'_xs
                                                        FStar_TypeChecker_Common.EQ
                                                        k_zs
                                                        FStar_Pervasives_Native.None
                                                        "flex-flex kinding"
                                                       in
                                                    FStar_All.pipe_left
                                                      (fun _0_64  ->
                                                         FStar_TypeChecker_Common.TProb
                                                           _0_64) uu____16342
                                                     in
                                                  (k_zs, [sub_prob; kprob])))))
                           in
                        match uu____16187 with
                        | (k_u',sub_probs) ->
                            let uu____16360 =
                              let uu____16371 =
                                let uu____16372 = new_uvar r zs k_u'  in
                                FStar_All.pipe_left
                                  FStar_Pervasives_Native.fst uu____16372
                                 in
                              let uu____16381 =
                                let uu____16384 =
                                  FStar_Syntax_Syntax.mk_Total k_u'  in
                                FStar_Syntax_Util.arrow xs1 uu____16384  in
                              let uu____16387 =
                                let uu____16390 =
                                  FStar_Syntax_Syntax.mk_Total k_u'  in
                                FStar_Syntax_Util.arrow ys1 uu____16390  in
                              (uu____16371, uu____16381, uu____16387)  in
                            (match uu____16360 with
                             | (u_zs,knew1,knew2) ->
                                 let sub1 = u_abs knew1 xs1 u_zs  in
                                 let uu____16409 =
                                   occurs_check env wl1 (u1, k1) sub1  in
                                 (match uu____16409 with
                                  | (occurs_ok,msg) ->
                                      if Prims.op_Negation occurs_ok
                                      then
                                        giveup_or_defer1 orig
                                          "flex-flex: failed occcurs check"
                                      else
                                        (let sol1 = TERM ((u1, k1), sub1)  in
                                         let uu____16428 =
                                           FStar_Syntax_Unionfind.equiv u1 u2
                                            in
                                         if uu____16428
                                         then
                                           let wl2 =
                                             solve_prob orig
                                               FStar_Pervasives_Native.None
                                               [sol1] wl1
                                              in
                                           solve env wl2
                                         else
                                           (let sub2 = u_abs knew2 ys1 u_zs
                                               in
                                            let uu____16432 =
                                              occurs_check env wl1 (u2, k2)
                                                sub2
                                               in
                                            match uu____16432 with
                                            | (occurs_ok1,msg1) ->
                                                if
                                                  Prims.op_Negation
                                                    occurs_ok1
                                                then
                                                  giveup_or_defer1 orig
                                                    "flex-flex: failed occurs check"
                                                else
                                                  (let sol2 =
                                                     TERM ((u2, k2), sub2)
                                                      in
                                                   let wl2 =
                                                     solve_prob orig
                                                       FStar_Pervasives_Native.None
                                                       [sol1; sol2] wl1
                                                      in
                                                   solve env
                                                     (attempt sub_probs wl2))))))))
                 in
              let solve_one_pat uu____16485 uu____16486 =
                match (uu____16485, uu____16486) with
                | ((t1,u1,k1,xs),(t2,u2,k2,args2)) ->
                    ((let uu____16604 =
                        FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                          (FStar_Options.Other "Rel")
                         in
                      if uu____16604
                      then
                        let uu____16605 =
                          FStar_Syntax_Print.term_to_string t1  in
                        let uu____16606 =
                          FStar_Syntax_Print.term_to_string t2  in
                        FStar_Util.print2
                          "Trying flex-flex one pattern (%s) with %s\n"
                          uu____16605 uu____16606
                      else ());
                     (let uu____16608 = FStar_Syntax_Unionfind.equiv u1 u2
                         in
                      if uu____16608
                      then
                        let sub_probs =
                          FStar_List.map2
                            (fun uu____16627  ->
                               fun uu____16628  ->
                                 match (uu____16627, uu____16628) with
                                 | ((a,uu____16646),(t21,uu____16648)) ->
                                     let uu____16657 =
                                       let uu____16662 = p_scope orig  in
                                       let uu____16663 =
                                         FStar_Syntax_Syntax.bv_to_name a  in
                                       mk_problem uu____16662 orig
                                         uu____16663
                                         FStar_TypeChecker_Common.EQ t21
                                         FStar_Pervasives_Native.None
                                         "flex-flex index"
                                        in
                                     FStar_All.pipe_right uu____16657
                                       (fun _0_65  ->
                                          FStar_TypeChecker_Common.TProb
                                            _0_65)) xs args2
                           in
                        let guard =
                          let uu____16669 =
                            FStar_List.map
                              (fun p  ->
                                 FStar_All.pipe_right (p_guard p)
                                   FStar_Pervasives_Native.fst) sub_probs
                             in
                          FStar_Syntax_Util.mk_conj_l uu____16669  in
                        let wl1 =
                          solve_prob orig
                            (FStar_Pervasives_Native.Some guard) [] wl
                           in
                        solve env (attempt sub_probs wl1)
                      else
                        (let t21 = sn env t2  in
                         let rhs_vars = FStar_Syntax_Free.names t21  in
                         let uu____16684 = occurs_check env wl (u1, k1) t21
                            in
                         match uu____16684 with
                         | (occurs_ok,uu____16692) ->
                             let lhs_vars =
                               FStar_Syntax_Free.names_of_binders xs  in
                             let uu____16700 =
                               occurs_ok &&
                                 (FStar_Util.set_is_subset_of rhs_vars
                                    lhs_vars)
                                in
                             if uu____16700
                             then
                               let sol =
                                 let uu____16702 =
                                   let uu____16711 = u_abs k1 xs t21  in
                                   ((u1, k1), uu____16711)  in
                                 TERM uu____16702  in
                               let wl1 =
                                 solve_prob orig FStar_Pervasives_Native.None
                                   [sol] wl
                                  in
                               solve env wl1
                             else
                               (let uu____16718 =
                                  occurs_ok &&
                                    (FStar_All.pipe_left Prims.op_Negation
                                       wl.defer_ok)
                                   in
                                if uu____16718
                                then
                                  let uu____16719 =
                                    force_quasi_pattern
                                      (FStar_Pervasives_Native.Some xs)
                                      (t21, u2, k2, args2)
                                     in
                                  match uu____16719 with
                                  | FStar_Pervasives_Native.None  ->
                                      giveup_or_defer1 orig
                                        "flex-flex constraint"
                                  | FStar_Pervasives_Native.Some
                                      (sol,(uu____16743,u21,k21,ys)) ->
                                      let wl1 =
                                        extend_solution (p_pid orig) [sol] wl
                                         in
                                      ((let uu____16769 =
                                          FStar_All.pipe_left
                                            (FStar_TypeChecker_Env.debug env)
                                            (FStar_Options.Other
                                               "QuasiPattern")
                                           in
                                        if uu____16769
                                        then
                                          let uu____16770 =
                                            uvi_to_string env sol  in
                                          FStar_Util.print1
                                            "flex-flex quasi pattern (2): %s\n"
                                            uu____16770
                                        else ());
                                       (match orig with
                                        | FStar_TypeChecker_Common.TProb p ->
                                            solve_t env p wl1
                                        | uu____16777 ->
                                            giveup env "impossible" orig))
                                else
                                  giveup_or_defer1 orig
                                    "flex-flex constraint"))))
                 in
              let uu____16779 = lhs  in
              match uu____16779 with
              | (t1,u1,k1,args1) ->
                  let uu____16784 = rhs  in
                  (match uu____16784 with
                   | (t2,u2,k2,args2) ->
                       let maybe_pat_vars1 = pat_vars env [] args1  in
                       let maybe_pat_vars2 = pat_vars env [] args2  in
                       let r = t2.FStar_Syntax_Syntax.pos  in
                       (match (maybe_pat_vars1, maybe_pat_vars2) with
                        | (FStar_Pervasives_Native.Some
                           xs,FStar_Pervasives_Native.Some ys) ->
                            solve_both_pats wl (u1, k1, xs, args1)
                              (u2, k2, ys, args2) t2.FStar_Syntax_Syntax.pos
                        | (FStar_Pervasives_Native.Some
                           xs,FStar_Pervasives_Native.None ) ->
                            solve_one_pat (t1, u1, k1, xs) rhs
                        | (FStar_Pervasives_Native.None
                           ,FStar_Pervasives_Native.Some ys) ->
                            solve_one_pat (t2, u2, k2, ys) lhs
                        | uu____16824 ->
                            if wl.defer_ok
                            then
                              giveup_or_defer1 orig
                                "flex-flex: neither side is a pattern"
                            else
                              (let uu____16834 =
                                 force_quasi_pattern
                                   FStar_Pervasives_Native.None
                                   (t1, u1, k1, args1)
                                  in
                               match uu____16834 with
                               | FStar_Pervasives_Native.None  ->
                                   giveup env
                                     "flex-flex: neither side is a pattern, nor is coercible to a pattern"
                                     orig
                               | FStar_Pervasives_Native.Some
                                   (sol,uu____16852) ->
                                   let wl1 =
                                     extend_solution (p_pid orig) [sol] wl
                                      in
                                   ((let uu____16859 =
                                       FStar_All.pipe_left
                                         (FStar_TypeChecker_Env.debug env)
                                         (FStar_Options.Other "QuasiPattern")
                                        in
                                     if uu____16859
                                     then
                                       let uu____16860 =
                                         uvi_to_string env sol  in
                                       FStar_Util.print1
                                         "flex-flex quasi pattern (1): %s\n"
                                         uu____16860
                                     else ());
                                    (match orig with
                                     | FStar_TypeChecker_Common.TProb p ->
                                         solve_t env p wl1
                                     | uu____16867 ->
                                         giveup env "impossible" orig))))))
            in
         let orig = FStar_TypeChecker_Common.TProb problem  in
         def_check_prob "solve_t'.2" orig;
         (let uu____16870 =
            FStar_Util.physical_equality problem.FStar_TypeChecker_Common.lhs
              problem.FStar_TypeChecker_Common.rhs
             in
          if uu____16870
          then
            let uu____16871 =
              solve_prob orig FStar_Pervasives_Native.None [] wl  in
            solve env uu____16871
          else
            (let t1 = problem.FStar_TypeChecker_Common.lhs  in
             let t2 = problem.FStar_TypeChecker_Common.rhs  in
             let uu____16875 = FStar_Util.physical_equality t1 t2  in
             if uu____16875
             then
               let uu____16876 =
                 solve_prob orig FStar_Pervasives_Native.None [] wl  in
               solve env uu____16876
             else
               ((let uu____16879 =
                   FStar_TypeChecker_Env.debug env
                     (FStar_Options.Other "RelCheck")
                    in
                 if uu____16879
                 then
                   let uu____16880 =
                     FStar_Util.string_of_int
                       problem.FStar_TypeChecker_Common.pid
                      in
                   let uu____16881 = FStar_Syntax_Print.tag_of_term t1  in
                   let uu____16882 = FStar_Syntax_Print.tag_of_term t2  in
                   FStar_Util.print3 "Attempting %s (%s - %s)\n" uu____16880
                     uu____16881 uu____16882
                 else ());
                (let r = FStar_TypeChecker_Env.get_range env  in
                 match ((t1.FStar_Syntax_Syntax.n),
                         (t2.FStar_Syntax_Syntax.n))
                 with
                 | (FStar_Syntax_Syntax.Tm_delayed uu____16885,uu____16886)
                     -> failwith "Impossible: terms were not compressed"
                 | (uu____16911,FStar_Syntax_Syntax.Tm_delayed uu____16912)
                     -> failwith "Impossible: terms were not compressed"
                 | (FStar_Syntax_Syntax.Tm_ascribed uu____16937,uu____16938)
                     ->
                     let uu____16965 =
                       let uu___150_16966 = problem  in
                       let uu____16967 = FStar_Syntax_Util.unascribe t1  in
                       {
                         FStar_TypeChecker_Common.pid =
                           (uu___150_16966.FStar_TypeChecker_Common.pid);
                         FStar_TypeChecker_Common.lhs = uu____16967;
                         FStar_TypeChecker_Common.relation =
                           (uu___150_16966.FStar_TypeChecker_Common.relation);
                         FStar_TypeChecker_Common.rhs =
                           (uu___150_16966.FStar_TypeChecker_Common.rhs);
                         FStar_TypeChecker_Common.element =
                           (uu___150_16966.FStar_TypeChecker_Common.element);
                         FStar_TypeChecker_Common.logical_guard =
                           (uu___150_16966.FStar_TypeChecker_Common.logical_guard);
                         FStar_TypeChecker_Common.scope =
                           (uu___150_16966.FStar_TypeChecker_Common.scope);
                         FStar_TypeChecker_Common.reason =
                           (uu___150_16966.FStar_TypeChecker_Common.reason);
                         FStar_TypeChecker_Common.loc =
                           (uu___150_16966.FStar_TypeChecker_Common.loc);
                         FStar_TypeChecker_Common.rank =
                           (uu___150_16966.FStar_TypeChecker_Common.rank)
                       }  in
                     solve_t' env uu____16965 wl
                 | (FStar_Syntax_Syntax.Tm_meta uu____16968,uu____16969) ->
                     let uu____16976 =
                       let uu___151_16977 = problem  in
                       let uu____16978 = FStar_Syntax_Util.unmeta t1  in
                       {
                         FStar_TypeChecker_Common.pid =
                           (uu___151_16977.FStar_TypeChecker_Common.pid);
                         FStar_TypeChecker_Common.lhs = uu____16978;
                         FStar_TypeChecker_Common.relation =
                           (uu___151_16977.FStar_TypeChecker_Common.relation);
                         FStar_TypeChecker_Common.rhs =
                           (uu___151_16977.FStar_TypeChecker_Common.rhs);
                         FStar_TypeChecker_Common.element =
                           (uu___151_16977.FStar_TypeChecker_Common.element);
                         FStar_TypeChecker_Common.logical_guard =
                           (uu___151_16977.FStar_TypeChecker_Common.logical_guard);
                         FStar_TypeChecker_Common.scope =
                           (uu___151_16977.FStar_TypeChecker_Common.scope);
                         FStar_TypeChecker_Common.reason =
                           (uu___151_16977.FStar_TypeChecker_Common.reason);
                         FStar_TypeChecker_Common.loc =
                           (uu___151_16977.FStar_TypeChecker_Common.loc);
                         FStar_TypeChecker_Common.rank =
                           (uu___151_16977.FStar_TypeChecker_Common.rank)
                       }  in
                     solve_t' env uu____16976 wl
                 | (uu____16979,FStar_Syntax_Syntax.Tm_ascribed uu____16980)
                     ->
                     let uu____17007 =
                       let uu___152_17008 = problem  in
                       let uu____17009 = FStar_Syntax_Util.unascribe t2  in
                       {
                         FStar_TypeChecker_Common.pid =
                           (uu___152_17008.FStar_TypeChecker_Common.pid);
                         FStar_TypeChecker_Common.lhs =
                           (uu___152_17008.FStar_TypeChecker_Common.lhs);
                         FStar_TypeChecker_Common.relation =
                           (uu___152_17008.FStar_TypeChecker_Common.relation);
                         FStar_TypeChecker_Common.rhs = uu____17009;
                         FStar_TypeChecker_Common.element =
                           (uu___152_17008.FStar_TypeChecker_Common.element);
                         FStar_TypeChecker_Common.logical_guard =
                           (uu___152_17008.FStar_TypeChecker_Common.logical_guard);
                         FStar_TypeChecker_Common.scope =
                           (uu___152_17008.FStar_TypeChecker_Common.scope);
                         FStar_TypeChecker_Common.reason =
                           (uu___152_17008.FStar_TypeChecker_Common.reason);
                         FStar_TypeChecker_Common.loc =
                           (uu___152_17008.FStar_TypeChecker_Common.loc);
                         FStar_TypeChecker_Common.rank =
                           (uu___152_17008.FStar_TypeChecker_Common.rank)
                       }  in
                     solve_t' env uu____17007 wl
                 | (uu____17010,FStar_Syntax_Syntax.Tm_meta uu____17011) ->
                     let uu____17018 =
                       let uu___153_17019 = problem  in
                       let uu____17020 = FStar_Syntax_Util.unmeta t2  in
                       {
                         FStar_TypeChecker_Common.pid =
                           (uu___153_17019.FStar_TypeChecker_Common.pid);
                         FStar_TypeChecker_Common.lhs =
                           (uu___153_17019.FStar_TypeChecker_Common.lhs);
                         FStar_TypeChecker_Common.relation =
                           (uu___153_17019.FStar_TypeChecker_Common.relation);
                         FStar_TypeChecker_Common.rhs = uu____17020;
                         FStar_TypeChecker_Common.element =
                           (uu___153_17019.FStar_TypeChecker_Common.element);
                         FStar_TypeChecker_Common.logical_guard =
                           (uu___153_17019.FStar_TypeChecker_Common.logical_guard);
                         FStar_TypeChecker_Common.scope =
                           (uu___153_17019.FStar_TypeChecker_Common.scope);
                         FStar_TypeChecker_Common.reason =
                           (uu___153_17019.FStar_TypeChecker_Common.reason);
                         FStar_TypeChecker_Common.loc =
                           (uu___153_17019.FStar_TypeChecker_Common.loc);
                         FStar_TypeChecker_Common.rank =
                           (uu___153_17019.FStar_TypeChecker_Common.rank)
                       }  in
                     solve_t' env uu____17018 wl
                 | (FStar_Syntax_Syntax.Tm_quoted
                    (t11,uu____17022),FStar_Syntax_Syntax.Tm_quoted
                    (t21,uu____17024)) ->
                     let uu____17033 =
                       solve_prob orig FStar_Pervasives_Native.None [] wl  in
                     solve env uu____17033
                 | (FStar_Syntax_Syntax.Tm_bvar uu____17034,uu____17035) ->
                     failwith
                       "Only locally nameless! We should never see a de Bruijn variable"
                 | (uu____17036,FStar_Syntax_Syntax.Tm_bvar uu____17037) ->
                     failwith
                       "Only locally nameless! We should never see a de Bruijn variable"
                 | (FStar_Syntax_Syntax.Tm_type
                    u1,FStar_Syntax_Syntax.Tm_type u2) ->
                     solve_one_universe_eq env orig u1 u2 wl
                 | (FStar_Syntax_Syntax.Tm_arrow
                    (bs1,c1),FStar_Syntax_Syntax.Tm_arrow (bs2,c2)) ->
                     let mk_c c uu___114_17092 =
                       match uu___114_17092 with
                       | [] -> c
                       | bs ->
                           let uu____17114 =
                             FStar_Syntax_Syntax.mk
                               (FStar_Syntax_Syntax.Tm_arrow (bs, c))
                               FStar_Pervasives_Native.None
                               c.FStar_Syntax_Syntax.pos
                              in
                           FStar_Syntax_Syntax.mk_Total uu____17114
                        in
                     let uu____17123 =
                       match_num_binders (bs1, (mk_c c1)) (bs2, (mk_c c2))
                        in
                     (match uu____17123 with
                      | ((bs11,c11),(bs21,c21)) ->
                          solve_binders env bs11 bs21 orig wl
                            (fun scope  ->
                               fun env1  ->
                                 fun subst1  ->
                                   let c12 =
                                     FStar_Syntax_Subst.subst_comp subst1 c11
                                      in
                                   let c22 =
                                     FStar_Syntax_Subst.subst_comp subst1 c21
                                      in
                                   let rel =
                                     let uu____17265 =
                                       FStar_Options.use_eq_at_higher_order
                                         ()
                                        in
                                     if uu____17265
                                     then FStar_TypeChecker_Common.EQ
                                     else
                                       problem.FStar_TypeChecker_Common.relation
                                      in
                                   let uu____17267 =
                                     mk_problem scope orig c12 rel c22
                                       FStar_Pervasives_Native.None
                                       "function co-domain"
                                      in
                                   FStar_All.pipe_left
                                     (fun _0_66  ->
                                        FStar_TypeChecker_Common.CProb _0_66)
                                     uu____17267))
                 | (FStar_Syntax_Syntax.Tm_abs
                    (bs1,tbody1,lopt1),FStar_Syntax_Syntax.Tm_abs
                    (bs2,tbody2,lopt2)) ->
                     let mk_t t l uu___115_17343 =
                       match uu___115_17343 with
                       | [] -> t
                       | bs ->
                           FStar_Syntax_Syntax.mk
                             (FStar_Syntax_Syntax.Tm_abs (bs, t, l))
                             FStar_Pervasives_Native.None
                             t.FStar_Syntax_Syntax.pos
                        in
                     let uu____17377 =
                       match_num_binders (bs1, (mk_t tbody1 lopt1))
                         (bs2, (mk_t tbody2 lopt2))
                        in
                     (match uu____17377 with
                      | ((bs11,tbody11),(bs21,tbody21)) ->
                          solve_binders env bs11 bs21 orig wl
                            (fun scope  ->
                               fun env1  ->
                                 fun subst1  ->
                                   let uu____17513 =
                                     let uu____17518 =
                                       FStar_Syntax_Subst.subst subst1
                                         tbody11
                                        in
                                     let uu____17519 =
                                       FStar_Syntax_Subst.subst subst1
                                         tbody21
                                        in
                                     mk_problem scope orig uu____17518
                                       problem.FStar_TypeChecker_Common.relation
                                       uu____17519
                                       FStar_Pervasives_Native.None
                                       "lambda co-domain"
                                      in
                                   FStar_All.pipe_left
                                     (fun _0_67  ->
                                        FStar_TypeChecker_Common.TProb _0_67)
                                     uu____17513))
                 | (FStar_Syntax_Syntax.Tm_abs uu____17524,uu____17525) ->
                     let is_abs t =
                       match t.FStar_Syntax_Syntax.n with
                       | FStar_Syntax_Syntax.Tm_abs uu____17550 -> true
                       | uu____17567 -> false  in
                     let maybe_eta t =
                       if is_abs t
                       then FStar_Util.Inl t
                       else
                         (let t3 =
                            FStar_TypeChecker_Normalize.eta_expand wl.tcenv t
                             in
                          if is_abs t3
                          then FStar_Util.Inl t3
                          else FStar_Util.Inr t3)
                        in
                     let force_eta t =
                       if is_abs t
                       then t
                       else
                         (let uu____17614 =
                            env.FStar_TypeChecker_Env.type_of
                              (let uu___154_17622 = env  in
                               {
                                 FStar_TypeChecker_Env.solver =
                                   (uu___154_17622.FStar_TypeChecker_Env.solver);
                                 FStar_TypeChecker_Env.range =
                                   (uu___154_17622.FStar_TypeChecker_Env.range);
                                 FStar_TypeChecker_Env.curmodule =
                                   (uu___154_17622.FStar_TypeChecker_Env.curmodule);
                                 FStar_TypeChecker_Env.gamma =
                                   (uu___154_17622.FStar_TypeChecker_Env.gamma);
                                 FStar_TypeChecker_Env.gamma_cache =
                                   (uu___154_17622.FStar_TypeChecker_Env.gamma_cache);
                                 FStar_TypeChecker_Env.modules =
                                   (uu___154_17622.FStar_TypeChecker_Env.modules);
                                 FStar_TypeChecker_Env.expected_typ =
                                   FStar_Pervasives_Native.None;
                                 FStar_TypeChecker_Env.sigtab =
                                   (uu___154_17622.FStar_TypeChecker_Env.sigtab);
                                 FStar_TypeChecker_Env.is_pattern =
                                   (uu___154_17622.FStar_TypeChecker_Env.is_pattern);
                                 FStar_TypeChecker_Env.instantiate_imp =
                                   (uu___154_17622.FStar_TypeChecker_Env.instantiate_imp);
                                 FStar_TypeChecker_Env.effects =
                                   (uu___154_17622.FStar_TypeChecker_Env.effects);
                                 FStar_TypeChecker_Env.generalize =
                                   (uu___154_17622.FStar_TypeChecker_Env.generalize);
                                 FStar_TypeChecker_Env.letrecs =
                                   (uu___154_17622.FStar_TypeChecker_Env.letrecs);
                                 FStar_TypeChecker_Env.top_level =
                                   (uu___154_17622.FStar_TypeChecker_Env.top_level);
                                 FStar_TypeChecker_Env.check_uvars =
                                   (uu___154_17622.FStar_TypeChecker_Env.check_uvars);
                                 FStar_TypeChecker_Env.use_eq =
                                   (uu___154_17622.FStar_TypeChecker_Env.use_eq);
                                 FStar_TypeChecker_Env.is_iface =
                                   (uu___154_17622.FStar_TypeChecker_Env.is_iface);
                                 FStar_TypeChecker_Env.admit =
                                   (uu___154_17622.FStar_TypeChecker_Env.admit);
                                 FStar_TypeChecker_Env.lax = true;
                                 FStar_TypeChecker_Env.lax_universes =
                                   (uu___154_17622.FStar_TypeChecker_Env.lax_universes);
                                 FStar_TypeChecker_Env.failhard =
                                   (uu___154_17622.FStar_TypeChecker_Env.failhard);
                                 FStar_TypeChecker_Env.nosynth =
                                   (uu___154_17622.FStar_TypeChecker_Env.nosynth);
                                 FStar_TypeChecker_Env.tc_term =
                                   (uu___154_17622.FStar_TypeChecker_Env.tc_term);
                                 FStar_TypeChecker_Env.type_of =
                                   (uu___154_17622.FStar_TypeChecker_Env.type_of);
                                 FStar_TypeChecker_Env.universe_of =
                                   (uu___154_17622.FStar_TypeChecker_Env.universe_of);
                                 FStar_TypeChecker_Env.check_type_of =
                                   (uu___154_17622.FStar_TypeChecker_Env.check_type_of);
                                 FStar_TypeChecker_Env.use_bv_sorts = true;
                                 FStar_TypeChecker_Env.qtbl_name_and_index =
                                   (uu___154_17622.FStar_TypeChecker_Env.qtbl_name_and_index);
                                 FStar_TypeChecker_Env.proof_ns =
                                   (uu___154_17622.FStar_TypeChecker_Env.proof_ns);
                                 FStar_TypeChecker_Env.synth_hook =
                                   (uu___154_17622.FStar_TypeChecker_Env.synth_hook);
                                 FStar_TypeChecker_Env.splice =
                                   (uu___154_17622.FStar_TypeChecker_Env.splice);
                                 FStar_TypeChecker_Env.is_native_tactic =
                                   (uu___154_17622.FStar_TypeChecker_Env.is_native_tactic);
                                 FStar_TypeChecker_Env.identifier_info =
                                   (uu___154_17622.FStar_TypeChecker_Env.identifier_info);
                                 FStar_TypeChecker_Env.tc_hooks =
                                   (uu___154_17622.FStar_TypeChecker_Env.tc_hooks);
                                 FStar_TypeChecker_Env.dsenv =
                                   (uu___154_17622.FStar_TypeChecker_Env.dsenv);
                                 FStar_TypeChecker_Env.dep_graph =
                                   (uu___154_17622.FStar_TypeChecker_Env.dep_graph)
                               }) t
                             in
                          match uu____17614 with
                          | (uu____17625,ty,uu____17627) ->
                              let uu____17628 =
                                FStar_TypeChecker_Normalize.unfold_whnf env
                                  ty
                                 in
                              FStar_TypeChecker_Normalize.eta_expand_with_type
                                env t uu____17628)
                        in
                     let uu____17629 =
                       let uu____17646 = maybe_eta t1  in
                       let uu____17653 = maybe_eta t2  in
                       (uu____17646, uu____17653)  in
                     (match uu____17629 with
                      | (FStar_Util.Inl t11,FStar_Util.Inl t21) ->
                          solve_t env
                            (let uu___155_17695 = problem  in
                             {
                               FStar_TypeChecker_Common.pid =
                                 (uu___155_17695.FStar_TypeChecker_Common.pid);
                               FStar_TypeChecker_Common.lhs = t11;
                               FStar_TypeChecker_Common.relation =
                                 (uu___155_17695.FStar_TypeChecker_Common.relation);
                               FStar_TypeChecker_Common.rhs = t21;
                               FStar_TypeChecker_Common.element =
                                 (uu___155_17695.FStar_TypeChecker_Common.element);
                               FStar_TypeChecker_Common.logical_guard =
                                 (uu___155_17695.FStar_TypeChecker_Common.logical_guard);
                               FStar_TypeChecker_Common.scope =
                                 (uu___155_17695.FStar_TypeChecker_Common.scope);
                               FStar_TypeChecker_Common.reason =
                                 (uu___155_17695.FStar_TypeChecker_Common.reason);
                               FStar_TypeChecker_Common.loc =
                                 (uu___155_17695.FStar_TypeChecker_Common.loc);
                               FStar_TypeChecker_Common.rank =
                                 (uu___155_17695.FStar_TypeChecker_Common.rank)
                             }) wl
                      | (FStar_Util.Inl t_abs,FStar_Util.Inr not_abs) ->
                          let uu____17718 =
                            (is_flex not_abs) &&
                              ((p_rel orig) = FStar_TypeChecker_Common.EQ)
                             in
                          if uu____17718
                          then
                            let uu____17719 =
                              destruct_flex_pattern env not_abs  in
                            solve_t_flex_rigid true orig uu____17719 t_abs wl
                          else
                            (let t11 = force_eta t1  in
                             let t21 = force_eta t2  in
                             if (is_abs t11) && (is_abs t21)
                             then
                               solve_t env
                                 (let uu___156_17734 = problem  in
                                  {
                                    FStar_TypeChecker_Common.pid =
                                      (uu___156_17734.FStar_TypeChecker_Common.pid);
                                    FStar_TypeChecker_Common.lhs = t11;
                                    FStar_TypeChecker_Common.relation =
                                      (uu___156_17734.FStar_TypeChecker_Common.relation);
                                    FStar_TypeChecker_Common.rhs = t21;
                                    FStar_TypeChecker_Common.element =
                                      (uu___156_17734.FStar_TypeChecker_Common.element);
                                    FStar_TypeChecker_Common.logical_guard =
                                      (uu___156_17734.FStar_TypeChecker_Common.logical_guard);
                                    FStar_TypeChecker_Common.scope =
                                      (uu___156_17734.FStar_TypeChecker_Common.scope);
                                    FStar_TypeChecker_Common.reason =
                                      (uu___156_17734.FStar_TypeChecker_Common.reason);
                                    FStar_TypeChecker_Common.loc =
                                      (uu___156_17734.FStar_TypeChecker_Common.loc);
                                    FStar_TypeChecker_Common.rank =
                                      (uu___156_17734.FStar_TypeChecker_Common.rank)
                                  }) wl
                             else
                               giveup env
                                 "head tag mismatch: RHS is an abstraction"
                                 orig)
                      | (FStar_Util.Inr not_abs,FStar_Util.Inl t_abs) ->
                          let uu____17758 =
                            (is_flex not_abs) &&
                              ((p_rel orig) = FStar_TypeChecker_Common.EQ)
                             in
                          if uu____17758
                          then
                            let uu____17759 =
                              destruct_flex_pattern env not_abs  in
                            solve_t_flex_rigid true orig uu____17759 t_abs wl
                          else
                            (let t11 = force_eta t1  in
                             let t21 = force_eta t2  in
                             if (is_abs t11) && (is_abs t21)
                             then
                               solve_t env
                                 (let uu___156_17774 = problem  in
                                  {
                                    FStar_TypeChecker_Common.pid =
                                      (uu___156_17774.FStar_TypeChecker_Common.pid);
                                    FStar_TypeChecker_Common.lhs = t11;
                                    FStar_TypeChecker_Common.relation =
                                      (uu___156_17774.FStar_TypeChecker_Common.relation);
                                    FStar_TypeChecker_Common.rhs = t21;
                                    FStar_TypeChecker_Common.element =
                                      (uu___156_17774.FStar_TypeChecker_Common.element);
                                    FStar_TypeChecker_Common.logical_guard =
                                      (uu___156_17774.FStar_TypeChecker_Common.logical_guard);
                                    FStar_TypeChecker_Common.scope =
                                      (uu___156_17774.FStar_TypeChecker_Common.scope);
                                    FStar_TypeChecker_Common.reason =
                                      (uu___156_17774.FStar_TypeChecker_Common.reason);
                                    FStar_TypeChecker_Common.loc =
                                      (uu___156_17774.FStar_TypeChecker_Common.loc);
                                    FStar_TypeChecker_Common.rank =
                                      (uu___156_17774.FStar_TypeChecker_Common.rank)
                                  }) wl
                             else
                               giveup env
                                 "head tag mismatch: RHS is an abstraction"
                                 orig)
                      | uu____17778 ->
                          failwith
                            "Impossible: at least one side is an abstraction")
                 | (uu____17795,FStar_Syntax_Syntax.Tm_abs uu____17796) ->
                     let is_abs t =
                       match t.FStar_Syntax_Syntax.n with
                       | FStar_Syntax_Syntax.Tm_abs uu____17821 -> true
                       | uu____17838 -> false  in
                     let maybe_eta t =
                       if is_abs t
                       then FStar_Util.Inl t
                       else
                         (let t3 =
                            FStar_TypeChecker_Normalize.eta_expand wl.tcenv t
                             in
                          if is_abs t3
                          then FStar_Util.Inl t3
                          else FStar_Util.Inr t3)
                        in
                     let force_eta t =
                       if is_abs t
                       then t
                       else
                         (let uu____17885 =
                            env.FStar_TypeChecker_Env.type_of
                              (let uu___154_17893 = env  in
                               {
                                 FStar_TypeChecker_Env.solver =
                                   (uu___154_17893.FStar_TypeChecker_Env.solver);
                                 FStar_TypeChecker_Env.range =
                                   (uu___154_17893.FStar_TypeChecker_Env.range);
                                 FStar_TypeChecker_Env.curmodule =
                                   (uu___154_17893.FStar_TypeChecker_Env.curmodule);
                                 FStar_TypeChecker_Env.gamma =
                                   (uu___154_17893.FStar_TypeChecker_Env.gamma);
                                 FStar_TypeChecker_Env.gamma_cache =
                                   (uu___154_17893.FStar_TypeChecker_Env.gamma_cache);
                                 FStar_TypeChecker_Env.modules =
                                   (uu___154_17893.FStar_TypeChecker_Env.modules);
                                 FStar_TypeChecker_Env.expected_typ =
                                   FStar_Pervasives_Native.None;
                                 FStar_TypeChecker_Env.sigtab =
                                   (uu___154_17893.FStar_TypeChecker_Env.sigtab);
                                 FStar_TypeChecker_Env.is_pattern =
                                   (uu___154_17893.FStar_TypeChecker_Env.is_pattern);
                                 FStar_TypeChecker_Env.instantiate_imp =
                                   (uu___154_17893.FStar_TypeChecker_Env.instantiate_imp);
                                 FStar_TypeChecker_Env.effects =
                                   (uu___154_17893.FStar_TypeChecker_Env.effects);
                                 FStar_TypeChecker_Env.generalize =
                                   (uu___154_17893.FStar_TypeChecker_Env.generalize);
                                 FStar_TypeChecker_Env.letrecs =
                                   (uu___154_17893.FStar_TypeChecker_Env.letrecs);
                                 FStar_TypeChecker_Env.top_level =
                                   (uu___154_17893.FStar_TypeChecker_Env.top_level);
                                 FStar_TypeChecker_Env.check_uvars =
                                   (uu___154_17893.FStar_TypeChecker_Env.check_uvars);
                                 FStar_TypeChecker_Env.use_eq =
                                   (uu___154_17893.FStar_TypeChecker_Env.use_eq);
                                 FStar_TypeChecker_Env.is_iface =
                                   (uu___154_17893.FStar_TypeChecker_Env.is_iface);
                                 FStar_TypeChecker_Env.admit =
                                   (uu___154_17893.FStar_TypeChecker_Env.admit);
                                 FStar_TypeChecker_Env.lax = true;
                                 FStar_TypeChecker_Env.lax_universes =
                                   (uu___154_17893.FStar_TypeChecker_Env.lax_universes);
                                 FStar_TypeChecker_Env.failhard =
                                   (uu___154_17893.FStar_TypeChecker_Env.failhard);
                                 FStar_TypeChecker_Env.nosynth =
                                   (uu___154_17893.FStar_TypeChecker_Env.nosynth);
                                 FStar_TypeChecker_Env.tc_term =
                                   (uu___154_17893.FStar_TypeChecker_Env.tc_term);
                                 FStar_TypeChecker_Env.type_of =
                                   (uu___154_17893.FStar_TypeChecker_Env.type_of);
                                 FStar_TypeChecker_Env.universe_of =
                                   (uu___154_17893.FStar_TypeChecker_Env.universe_of);
                                 FStar_TypeChecker_Env.check_type_of =
                                   (uu___154_17893.FStar_TypeChecker_Env.check_type_of);
                                 FStar_TypeChecker_Env.use_bv_sorts = true;
                                 FStar_TypeChecker_Env.qtbl_name_and_index =
                                   (uu___154_17893.FStar_TypeChecker_Env.qtbl_name_and_index);
                                 FStar_TypeChecker_Env.proof_ns =
                                   (uu___154_17893.FStar_TypeChecker_Env.proof_ns);
                                 FStar_TypeChecker_Env.synth_hook =
                                   (uu___154_17893.FStar_TypeChecker_Env.synth_hook);
                                 FStar_TypeChecker_Env.splice =
                                   (uu___154_17893.FStar_TypeChecker_Env.splice);
                                 FStar_TypeChecker_Env.is_native_tactic =
                                   (uu___154_17893.FStar_TypeChecker_Env.is_native_tactic);
                                 FStar_TypeChecker_Env.identifier_info =
                                   (uu___154_17893.FStar_TypeChecker_Env.identifier_info);
                                 FStar_TypeChecker_Env.tc_hooks =
                                   (uu___154_17893.FStar_TypeChecker_Env.tc_hooks);
                                 FStar_TypeChecker_Env.dsenv =
                                   (uu___154_17893.FStar_TypeChecker_Env.dsenv);
                                 FStar_TypeChecker_Env.dep_graph =
                                   (uu___154_17893.FStar_TypeChecker_Env.dep_graph)
                               }) t
                             in
                          match uu____17885 with
                          | (uu____17896,ty,uu____17898) ->
                              let uu____17899 =
                                FStar_TypeChecker_Normalize.unfold_whnf env
                                  ty
                                 in
                              FStar_TypeChecker_Normalize.eta_expand_with_type
                                env t uu____17899)
                        in
                     let uu____17900 =
                       let uu____17917 = maybe_eta t1  in
                       let uu____17924 = maybe_eta t2  in
                       (uu____17917, uu____17924)  in
                     (match uu____17900 with
                      | (FStar_Util.Inl t11,FStar_Util.Inl t21) ->
                          solve_t env
                            (let uu___155_17966 = problem  in
                             {
                               FStar_TypeChecker_Common.pid =
                                 (uu___155_17966.FStar_TypeChecker_Common.pid);
                               FStar_TypeChecker_Common.lhs = t11;
                               FStar_TypeChecker_Common.relation =
                                 (uu___155_17966.FStar_TypeChecker_Common.relation);
                               FStar_TypeChecker_Common.rhs = t21;
                               FStar_TypeChecker_Common.element =
                                 (uu___155_17966.FStar_TypeChecker_Common.element);
                               FStar_TypeChecker_Common.logical_guard =
                                 (uu___155_17966.FStar_TypeChecker_Common.logical_guard);
                               FStar_TypeChecker_Common.scope =
                                 (uu___155_17966.FStar_TypeChecker_Common.scope);
                               FStar_TypeChecker_Common.reason =
                                 (uu___155_17966.FStar_TypeChecker_Common.reason);
                               FStar_TypeChecker_Common.loc =
                                 (uu___155_17966.FStar_TypeChecker_Common.loc);
                               FStar_TypeChecker_Common.rank =
                                 (uu___155_17966.FStar_TypeChecker_Common.rank)
                             }) wl
                      | (FStar_Util.Inl t_abs,FStar_Util.Inr not_abs) ->
                          let uu____17989 =
                            (is_flex not_abs) &&
                              ((p_rel orig) = FStar_TypeChecker_Common.EQ)
                             in
                          if uu____17989
                          then
                            let uu____17990 =
                              destruct_flex_pattern env not_abs  in
                            solve_t_flex_rigid true orig uu____17990 t_abs wl
                          else
                            (let t11 = force_eta t1  in
                             let t21 = force_eta t2  in
                             if (is_abs t11) && (is_abs t21)
                             then
                               solve_t env
                                 (let uu___156_18005 = problem  in
                                  {
                                    FStar_TypeChecker_Common.pid =
                                      (uu___156_18005.FStar_TypeChecker_Common.pid);
                                    FStar_TypeChecker_Common.lhs = t11;
                                    FStar_TypeChecker_Common.relation =
                                      (uu___156_18005.FStar_TypeChecker_Common.relation);
                                    FStar_TypeChecker_Common.rhs = t21;
                                    FStar_TypeChecker_Common.element =
                                      (uu___156_18005.FStar_TypeChecker_Common.element);
                                    FStar_TypeChecker_Common.logical_guard =
                                      (uu___156_18005.FStar_TypeChecker_Common.logical_guard);
                                    FStar_TypeChecker_Common.scope =
                                      (uu___156_18005.FStar_TypeChecker_Common.scope);
                                    FStar_TypeChecker_Common.reason =
                                      (uu___156_18005.FStar_TypeChecker_Common.reason);
                                    FStar_TypeChecker_Common.loc =
                                      (uu___156_18005.FStar_TypeChecker_Common.loc);
                                    FStar_TypeChecker_Common.rank =
                                      (uu___156_18005.FStar_TypeChecker_Common.rank)
                                  }) wl
                             else
                               giveup env
                                 "head tag mismatch: RHS is an abstraction"
                                 orig)
                      | (FStar_Util.Inr not_abs,FStar_Util.Inl t_abs) ->
                          let uu____18029 =
                            (is_flex not_abs) &&
                              ((p_rel orig) = FStar_TypeChecker_Common.EQ)
                             in
                          if uu____18029
                          then
                            let uu____18030 =
                              destruct_flex_pattern env not_abs  in
                            solve_t_flex_rigid true orig uu____18030 t_abs wl
                          else
                            (let t11 = force_eta t1  in
                             let t21 = force_eta t2  in
                             if (is_abs t11) && (is_abs t21)
                             then
                               solve_t env
                                 (let uu___156_18045 = problem  in
                                  {
                                    FStar_TypeChecker_Common.pid =
                                      (uu___156_18045.FStar_TypeChecker_Common.pid);
                                    FStar_TypeChecker_Common.lhs = t11;
                                    FStar_TypeChecker_Common.relation =
                                      (uu___156_18045.FStar_TypeChecker_Common.relation);
                                    FStar_TypeChecker_Common.rhs = t21;
                                    FStar_TypeChecker_Common.element =
                                      (uu___156_18045.FStar_TypeChecker_Common.element);
                                    FStar_TypeChecker_Common.logical_guard =
                                      (uu___156_18045.FStar_TypeChecker_Common.logical_guard);
                                    FStar_TypeChecker_Common.scope =
                                      (uu___156_18045.FStar_TypeChecker_Common.scope);
                                    FStar_TypeChecker_Common.reason =
                                      (uu___156_18045.FStar_TypeChecker_Common.reason);
                                    FStar_TypeChecker_Common.loc =
                                      (uu___156_18045.FStar_TypeChecker_Common.loc);
                                    FStar_TypeChecker_Common.rank =
                                      (uu___156_18045.FStar_TypeChecker_Common.rank)
                                  }) wl
                             else
                               giveup env
                                 "head tag mismatch: RHS is an abstraction"
                                 orig)
                      | uu____18049 ->
                          failwith
                            "Impossible: at least one side is an abstraction")
                 | (FStar_Syntax_Syntax.Tm_refine
                    (x1,ph1),FStar_Syntax_Syntax.Tm_refine (x2,phi2)) ->
                     let should_delta =
                       ((let uu____18081 = FStar_Syntax_Free.uvars t1  in
                         FStar_Util.set_is_empty uu____18081) &&
                          (let uu____18093 = FStar_Syntax_Free.uvars t2  in
                           FStar_Util.set_is_empty uu____18093))
                         &&
                         (let uu____18108 =
                            head_matches env x1.FStar_Syntax_Syntax.sort
                              x2.FStar_Syntax_Syntax.sort
                             in
                          match uu____18108 with
                          | MisMatch
                              (FStar_Pervasives_Native.Some
                               d1,FStar_Pervasives_Native.Some d2)
                              ->
                              let is_unfoldable uu___116_18118 =
                                match uu___116_18118 with
                                | FStar_Syntax_Syntax.Delta_constant  -> true
                                | FStar_Syntax_Syntax.Delta_defined_at_level
                                    uu____18119 -> true
                                | uu____18120 -> false  in
                              (is_unfoldable d1) && (is_unfoldable d2)
                          | uu____18121 -> false)
                        in
                     let uu____18122 = as_refinement should_delta env wl t1
                        in
                     (match uu____18122 with
                      | (x11,phi1) ->
                          let uu____18129 =
                            as_refinement should_delta env wl t2  in
                          (match uu____18129 with
                           | (x21,phi21) ->
                               let base_prob =
                                 let uu____18137 =
                                   let uu____18142 = p_scope orig  in
                                   mk_problem uu____18142 orig
                                     x11.FStar_Syntax_Syntax.sort
                                     problem.FStar_TypeChecker_Common.relation
                                     x21.FStar_Syntax_Syntax.sort
                                     problem.FStar_TypeChecker_Common.element
                                     "refinement base type"
                                    in
                                 FStar_All.pipe_left
                                   (fun _0_68  ->
                                      FStar_TypeChecker_Common.TProb _0_68)
                                   uu____18137
                                  in
                               let x12 = FStar_Syntax_Syntax.freshen_bv x11
                                  in
                               let subst1 =
                                 [FStar_Syntax_Syntax.DB
                                    ((Prims.parse_int "0"), x12)]
                                  in
                               let phi11 =
                                 FStar_Syntax_Subst.subst subst1 phi1  in
                               let phi22 =
                                 FStar_Syntax_Subst.subst subst1 phi21  in
                               let env1 =
                                 FStar_TypeChecker_Env.push_bv env x12  in
                               let mk_imp1 imp phi12 phi23 =
                                 let uu____18176 = imp phi12 phi23  in
                                 FStar_All.pipe_right uu____18176
                                   (guard_on_element wl problem x12)
                                  in
                               let fallback uu____18180 =
                                 let impl =
                                   if
                                     problem.FStar_TypeChecker_Common.relation
                                       = FStar_TypeChecker_Common.EQ
                                   then
                                     mk_imp1 FStar_Syntax_Util.mk_iff phi11
                                       phi22
                                   else
                                     mk_imp1 FStar_Syntax_Util.mk_imp phi11
                                       phi22
                                    in
                                 let guard =
                                   let uu____18186 =
                                     FStar_All.pipe_right (p_guard base_prob)
                                       FStar_Pervasives_Native.fst
                                      in
                                   FStar_Syntax_Util.mk_conj uu____18186 impl
                                    in
                                 let wl1 =
                                   solve_prob orig
                                     (FStar_Pervasives_Native.Some guard) []
                                     wl
                                    in
                                 solve env1 (attempt [base_prob] wl1)  in
                               if
                                 problem.FStar_TypeChecker_Common.relation =
                                   FStar_TypeChecker_Common.EQ
                               then
                                 let ref_prob =
                                   let uu____18195 =
                                     let uu____18200 =
                                       let uu____18201 = p_scope orig  in
                                       let uu____18208 =
                                         let uu____18215 =
                                           FStar_Syntax_Syntax.mk_binder x12
                                            in
                                         [uu____18215]  in
                                       FStar_List.append uu____18201
                                         uu____18208
                                        in
                                     mk_problem uu____18200 orig phi11
                                       FStar_TypeChecker_Common.EQ phi22
                                       FStar_Pervasives_Native.None
                                       "refinement formula"
                                      in
                                   FStar_All.pipe_left
                                     (fun _0_69  ->
                                        FStar_TypeChecker_Common.TProb _0_69)
                                     uu____18195
                                    in
                                 let uu____18224 =
                                   solve env1
                                     (let uu___157_18226 = wl  in
                                      {
                                        attempting = [ref_prob];
                                        wl_deferred = [];
                                        ctr = (uu___157_18226.ctr);
                                        defer_ok = false;
                                        smt_ok = (uu___157_18226.smt_ok);
                                        tcenv = (uu___157_18226.tcenv)
                                      })
                                    in
                                 (match uu____18224 with
                                  | Failed uu____18233 -> fallback ()
                                  | Success uu____18238 ->
                                      let guard =
                                        let uu____18242 =
                                          FStar_All.pipe_right
                                            (p_guard base_prob)
                                            FStar_Pervasives_Native.fst
                                           in
                                        let uu____18247 =
                                          let uu____18248 =
                                            FStar_All.pipe_right
                                              (p_guard ref_prob)
                                              FStar_Pervasives_Native.fst
                                             in
                                          FStar_All.pipe_right uu____18248
                                            (guard_on_element wl problem x12)
                                           in
                                        FStar_Syntax_Util.mk_conj uu____18242
                                          uu____18247
                                         in
                                      let wl1 =
                                        solve_prob orig
                                          (FStar_Pervasives_Native.Some guard)
                                          [] wl
                                         in
                                      let wl2 =
                                        let uu___158_18257 = wl1  in
                                        {
                                          attempting =
                                            (uu___158_18257.attempting);
                                          wl_deferred =
                                            (uu___158_18257.wl_deferred);
                                          ctr =
                                            (wl1.ctr + (Prims.parse_int "1"));
                                          defer_ok =
                                            (uu___158_18257.defer_ok);
                                          smt_ok = (uu___158_18257.smt_ok);
                                          tcenv = (uu___158_18257.tcenv)
                                        }  in
                                      solve env1 (attempt [base_prob] wl2))
                               else fallback ()))
                 | (FStar_Syntax_Syntax.Tm_uvar
                    uu____18259,FStar_Syntax_Syntax.Tm_uvar uu____18260) ->
                     let uu____18293 = destruct_flex_t t1  in
                     let uu____18294 = destruct_flex_t t2  in
                     flex_flex1 orig uu____18293 uu____18294
                 | (FStar_Syntax_Syntax.Tm_app
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar
                         uu____18295;
                       FStar_Syntax_Syntax.pos = uu____18296;
                       FStar_Syntax_Syntax.vars = uu____18297;_},uu____18298),FStar_Syntax_Syntax.Tm_uvar
                    uu____18299) ->
                     let uu____18352 = destruct_flex_t t1  in
                     let uu____18353 = destruct_flex_t t2  in
                     flex_flex1 orig uu____18352 uu____18353
                 | (FStar_Syntax_Syntax.Tm_uvar
                    uu____18354,FStar_Syntax_Syntax.Tm_app
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar
                         uu____18355;
                       FStar_Syntax_Syntax.pos = uu____18356;
                       FStar_Syntax_Syntax.vars = uu____18357;_},uu____18358))
                     ->
                     let uu____18411 = destruct_flex_t t1  in
                     let uu____18412 = destruct_flex_t t2  in
                     flex_flex1 orig uu____18411 uu____18412
                 | (FStar_Syntax_Syntax.Tm_app
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar
                         uu____18413;
                       FStar_Syntax_Syntax.pos = uu____18414;
                       FStar_Syntax_Syntax.vars = uu____18415;_},uu____18416),FStar_Syntax_Syntax.Tm_app
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar
                         uu____18417;
                       FStar_Syntax_Syntax.pos = uu____18418;
                       FStar_Syntax_Syntax.vars = uu____18419;_},uu____18420))
                     ->
                     let uu____18493 = destruct_flex_t t1  in
                     let uu____18494 = destruct_flex_t t2  in
                     flex_flex1 orig uu____18493 uu____18494
                 | (FStar_Syntax_Syntax.Tm_uvar uu____18495,uu____18496) when
                     problem.FStar_TypeChecker_Common.relation =
                       FStar_TypeChecker_Common.EQ
                     ->
                     let uu____18513 = destruct_flex_pattern env t1  in
                     solve_t_flex_rigid false orig uu____18513 t2 wl
                 | (FStar_Syntax_Syntax.Tm_app
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar
                         uu____18520;
                       FStar_Syntax_Syntax.pos = uu____18521;
                       FStar_Syntax_Syntax.vars = uu____18522;_},uu____18523),uu____18524)
                     when
                     problem.FStar_TypeChecker_Common.relation =
                       FStar_TypeChecker_Common.EQ
                     ->
                     let uu____18561 = destruct_flex_pattern env t1  in
                     solve_t_flex_rigid false orig uu____18561 t2 wl
                 | (uu____18568,FStar_Syntax_Syntax.Tm_uvar uu____18569) when
                     problem.FStar_TypeChecker_Common.relation =
                       FStar_TypeChecker_Common.EQ
                     -> solve_t env (invert problem) wl
                 | (uu____18586,FStar_Syntax_Syntax.Tm_app
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar
                         uu____18587;
                       FStar_Syntax_Syntax.pos = uu____18588;
                       FStar_Syntax_Syntax.vars = uu____18589;_},uu____18590))
                     when
                     problem.FStar_TypeChecker_Common.relation =
                       FStar_TypeChecker_Common.EQ
                     -> solve_t env (invert problem) wl
                 | (FStar_Syntax_Syntax.Tm_uvar
                    uu____18627,FStar_Syntax_Syntax.Tm_type uu____18628) ->
                     solve_t' env
                       (let uu___159_18646 = problem  in
                        {
                          FStar_TypeChecker_Common.pid =
                            (uu___159_18646.FStar_TypeChecker_Common.pid);
                          FStar_TypeChecker_Common.lhs =
                            (uu___159_18646.FStar_TypeChecker_Common.lhs);
                          FStar_TypeChecker_Common.relation =
                            FStar_TypeChecker_Common.EQ;
                          FStar_TypeChecker_Common.rhs =
                            (uu___159_18646.FStar_TypeChecker_Common.rhs);
                          FStar_TypeChecker_Common.element =
                            (uu___159_18646.FStar_TypeChecker_Common.element);
                          FStar_TypeChecker_Common.logical_guard =
                            (uu___159_18646.FStar_TypeChecker_Common.logical_guard);
                          FStar_TypeChecker_Common.scope =
                            (uu___159_18646.FStar_TypeChecker_Common.scope);
                          FStar_TypeChecker_Common.reason =
                            (uu___159_18646.FStar_TypeChecker_Common.reason);
                          FStar_TypeChecker_Common.loc =
                            (uu___159_18646.FStar_TypeChecker_Common.loc);
                          FStar_TypeChecker_Common.rank =
                            (uu___159_18646.FStar_TypeChecker_Common.rank)
                        }) wl
                 | (FStar_Syntax_Syntax.Tm_app
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar
                         uu____18647;
                       FStar_Syntax_Syntax.pos = uu____18648;
                       FStar_Syntax_Syntax.vars = uu____18649;_},uu____18650),FStar_Syntax_Syntax.Tm_type
                    uu____18651) ->
                     solve_t' env
                       (let uu___159_18689 = problem  in
                        {
                          FStar_TypeChecker_Common.pid =
                            (uu___159_18689.FStar_TypeChecker_Common.pid);
                          FStar_TypeChecker_Common.lhs =
                            (uu___159_18689.FStar_TypeChecker_Common.lhs);
                          FStar_TypeChecker_Common.relation =
                            FStar_TypeChecker_Common.EQ;
                          FStar_TypeChecker_Common.rhs =
                            (uu___159_18689.FStar_TypeChecker_Common.rhs);
                          FStar_TypeChecker_Common.element =
                            (uu___159_18689.FStar_TypeChecker_Common.element);
                          FStar_TypeChecker_Common.logical_guard =
                            (uu___159_18689.FStar_TypeChecker_Common.logical_guard);
                          FStar_TypeChecker_Common.scope =
                            (uu___159_18689.FStar_TypeChecker_Common.scope);
                          FStar_TypeChecker_Common.reason =
                            (uu___159_18689.FStar_TypeChecker_Common.reason);
                          FStar_TypeChecker_Common.loc =
                            (uu___159_18689.FStar_TypeChecker_Common.loc);
                          FStar_TypeChecker_Common.rank =
                            (uu___159_18689.FStar_TypeChecker_Common.rank)
                        }) wl
                 | (FStar_Syntax_Syntax.Tm_uvar
                    uu____18690,FStar_Syntax_Syntax.Tm_arrow uu____18691) ->
                     solve_t' env
                       (let uu___159_18721 = problem  in
                        {
                          FStar_TypeChecker_Common.pid =
                            (uu___159_18721.FStar_TypeChecker_Common.pid);
                          FStar_TypeChecker_Common.lhs =
                            (uu___159_18721.FStar_TypeChecker_Common.lhs);
                          FStar_TypeChecker_Common.relation =
                            FStar_TypeChecker_Common.EQ;
                          FStar_TypeChecker_Common.rhs =
                            (uu___159_18721.FStar_TypeChecker_Common.rhs);
                          FStar_TypeChecker_Common.element =
                            (uu___159_18721.FStar_TypeChecker_Common.element);
                          FStar_TypeChecker_Common.logical_guard =
                            (uu___159_18721.FStar_TypeChecker_Common.logical_guard);
                          FStar_TypeChecker_Common.scope =
                            (uu___159_18721.FStar_TypeChecker_Common.scope);
                          FStar_TypeChecker_Common.reason =
                            (uu___159_18721.FStar_TypeChecker_Common.reason);
                          FStar_TypeChecker_Common.loc =
                            (uu___159_18721.FStar_TypeChecker_Common.loc);
                          FStar_TypeChecker_Common.rank =
                            (uu___159_18721.FStar_TypeChecker_Common.rank)
                        }) wl
                 | (FStar_Syntax_Syntax.Tm_app
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar
                         uu____18722;
                       FStar_Syntax_Syntax.pos = uu____18723;
                       FStar_Syntax_Syntax.vars = uu____18724;_},uu____18725),FStar_Syntax_Syntax.Tm_arrow
                    uu____18726) ->
                     solve_t' env
                       (let uu___159_18776 = problem  in
                        {
                          FStar_TypeChecker_Common.pid =
                            (uu___159_18776.FStar_TypeChecker_Common.pid);
                          FStar_TypeChecker_Common.lhs =
                            (uu___159_18776.FStar_TypeChecker_Common.lhs);
                          FStar_TypeChecker_Common.relation =
                            FStar_TypeChecker_Common.EQ;
                          FStar_TypeChecker_Common.rhs =
                            (uu___159_18776.FStar_TypeChecker_Common.rhs);
                          FStar_TypeChecker_Common.element =
                            (uu___159_18776.FStar_TypeChecker_Common.element);
                          FStar_TypeChecker_Common.logical_guard =
                            (uu___159_18776.FStar_TypeChecker_Common.logical_guard);
                          FStar_TypeChecker_Common.scope =
                            (uu___159_18776.FStar_TypeChecker_Common.scope);
                          FStar_TypeChecker_Common.reason =
                            (uu___159_18776.FStar_TypeChecker_Common.reason);
                          FStar_TypeChecker_Common.loc =
                            (uu___159_18776.FStar_TypeChecker_Common.loc);
                          FStar_TypeChecker_Common.rank =
                            (uu___159_18776.FStar_TypeChecker_Common.rank)
                        }) wl
                 | (FStar_Syntax_Syntax.Tm_uvar uu____18777,uu____18778) ->
                     if wl.defer_ok
                     then
                       solve env
                         (defer "flex-rigid subtyping deferred" orig wl)
                     else
                       (let new_rel =
                          problem.FStar_TypeChecker_Common.relation  in
                        let uu____18797 =
                          let uu____18798 = is_top_level_prob orig  in
                          FStar_All.pipe_left Prims.op_Negation uu____18798
                           in
                        if uu____18797
                        then
                          let uu____18799 =
                            FStar_All.pipe_left
                              (fun _0_70  ->
                                 FStar_TypeChecker_Common.TProb _0_70)
                              (let uu___160_18805 = problem  in
                               {
                                 FStar_TypeChecker_Common.pid =
                                   (uu___160_18805.FStar_TypeChecker_Common.pid);
                                 FStar_TypeChecker_Common.lhs =
                                   (uu___160_18805.FStar_TypeChecker_Common.lhs);
                                 FStar_TypeChecker_Common.relation = new_rel;
                                 FStar_TypeChecker_Common.rhs =
                                   (uu___160_18805.FStar_TypeChecker_Common.rhs);
                                 FStar_TypeChecker_Common.element =
                                   (uu___160_18805.FStar_TypeChecker_Common.element);
                                 FStar_TypeChecker_Common.logical_guard =
                                   (uu___160_18805.FStar_TypeChecker_Common.logical_guard);
                                 FStar_TypeChecker_Common.scope =
                                   (uu___160_18805.FStar_TypeChecker_Common.scope);
                                 FStar_TypeChecker_Common.reason =
                                   (uu___160_18805.FStar_TypeChecker_Common.reason);
                                 FStar_TypeChecker_Common.loc =
                                   (uu___160_18805.FStar_TypeChecker_Common.loc);
                                 FStar_TypeChecker_Common.rank =
                                   (uu___160_18805.FStar_TypeChecker_Common.rank)
                               })
                             in
                          let uu____18806 = destruct_flex_pattern env t1  in
                          solve_t_flex_rigid false uu____18799 uu____18806 t2
                            wl
                        else
                          (let uu____18814 = base_and_refinement env t2  in
                           match uu____18814 with
                           | (t_base,ref_opt) ->
                               (match ref_opt with
                                | FStar_Pervasives_Native.None  ->
                                    let uu____18843 =
                                      FStar_All.pipe_left
                                        (fun _0_71  ->
                                           FStar_TypeChecker_Common.TProb
                                             _0_71)
                                        (let uu___161_18849 = problem  in
                                         {
                                           FStar_TypeChecker_Common.pid =
                                             (uu___161_18849.FStar_TypeChecker_Common.pid);
                                           FStar_TypeChecker_Common.lhs =
                                             (uu___161_18849.FStar_TypeChecker_Common.lhs);
                                           FStar_TypeChecker_Common.relation
                                             = new_rel;
                                           FStar_TypeChecker_Common.rhs =
                                             (uu___161_18849.FStar_TypeChecker_Common.rhs);
                                           FStar_TypeChecker_Common.element =
                                             (uu___161_18849.FStar_TypeChecker_Common.element);
                                           FStar_TypeChecker_Common.logical_guard
                                             =
                                             (uu___161_18849.FStar_TypeChecker_Common.logical_guard);
                                           FStar_TypeChecker_Common.scope =
                                             (uu___161_18849.FStar_TypeChecker_Common.scope);
                                           FStar_TypeChecker_Common.reason =
                                             (uu___161_18849.FStar_TypeChecker_Common.reason);
                                           FStar_TypeChecker_Common.loc =
                                             (uu___161_18849.FStar_TypeChecker_Common.loc);
                                           FStar_TypeChecker_Common.rank =
                                             (uu___161_18849.FStar_TypeChecker_Common.rank)
                                         })
                                       in
                                    let uu____18850 =
                                      destruct_flex_pattern env t1  in
                                    solve_t_flex_rigid false uu____18843
                                      uu____18850 t_base wl
                                | FStar_Pervasives_Native.Some (y,phi) ->
                                    let y' =
                                      let uu___162_18864 = y  in
                                      {
                                        FStar_Syntax_Syntax.ppname =
                                          (uu___162_18864.FStar_Syntax_Syntax.ppname);
                                        FStar_Syntax_Syntax.index =
                                          (uu___162_18864.FStar_Syntax_Syntax.index);
                                        FStar_Syntax_Syntax.sort = t1
                                      }  in
                                    let impl =
                                      guard_on_element wl problem y' phi  in
                                    let base_prob =
                                      let uu____18867 =
                                        mk_problem
                                          problem.FStar_TypeChecker_Common.scope
                                          orig t1 new_rel
                                          y.FStar_Syntax_Syntax.sort
                                          problem.FStar_TypeChecker_Common.element
                                          "flex-rigid: base type"
                                         in
                                      FStar_All.pipe_left
                                        (fun _0_72  ->
                                           FStar_TypeChecker_Common.TProb
                                             _0_72) uu____18867
                                       in
                                    let guard =
                                      let uu____18879 =
                                        FStar_All.pipe_right
                                          (p_guard base_prob)
                                          FStar_Pervasives_Native.fst
                                         in
                                      FStar_Syntax_Util.mk_conj uu____18879
                                        impl
                                       in
                                    let wl1 =
                                      solve_prob orig
                                        (FStar_Pervasives_Native.Some guard)
                                        [] wl
                                       in
                                    solve env (attempt [base_prob] wl1))))
                 | (FStar_Syntax_Syntax.Tm_app
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar
                         uu____18887;
                       FStar_Syntax_Syntax.pos = uu____18888;
                       FStar_Syntax_Syntax.vars = uu____18889;_},uu____18890),uu____18891)
                     ->
                     if wl.defer_ok
                     then
                       solve env
                         (defer "flex-rigid subtyping deferred" orig wl)
                     else
                       (let new_rel =
                          problem.FStar_TypeChecker_Common.relation  in
                        let uu____18930 =
                          let uu____18931 = is_top_level_prob orig  in
                          FStar_All.pipe_left Prims.op_Negation uu____18931
                           in
                        if uu____18930
                        then
                          let uu____18932 =
                            FStar_All.pipe_left
                              (fun _0_73  ->
                                 FStar_TypeChecker_Common.TProb _0_73)
                              (let uu___160_18938 = problem  in
                               {
                                 FStar_TypeChecker_Common.pid =
                                   (uu___160_18938.FStar_TypeChecker_Common.pid);
                                 FStar_TypeChecker_Common.lhs =
                                   (uu___160_18938.FStar_TypeChecker_Common.lhs);
                                 FStar_TypeChecker_Common.relation = new_rel;
                                 FStar_TypeChecker_Common.rhs =
                                   (uu___160_18938.FStar_TypeChecker_Common.rhs);
                                 FStar_TypeChecker_Common.element =
                                   (uu___160_18938.FStar_TypeChecker_Common.element);
                                 FStar_TypeChecker_Common.logical_guard =
                                   (uu___160_18938.FStar_TypeChecker_Common.logical_guard);
                                 FStar_TypeChecker_Common.scope =
                                   (uu___160_18938.FStar_TypeChecker_Common.scope);
                                 FStar_TypeChecker_Common.reason =
                                   (uu___160_18938.FStar_TypeChecker_Common.reason);
                                 FStar_TypeChecker_Common.loc =
                                   (uu___160_18938.FStar_TypeChecker_Common.loc);
                                 FStar_TypeChecker_Common.rank =
                                   (uu___160_18938.FStar_TypeChecker_Common.rank)
                               })
                             in
                          let uu____18939 = destruct_flex_pattern env t1  in
                          solve_t_flex_rigid false uu____18932 uu____18939 t2
                            wl
                        else
                          (let uu____18947 = base_and_refinement env t2  in
                           match uu____18947 with
                           | (t_base,ref_opt) ->
                               (match ref_opt with
                                | FStar_Pervasives_Native.None  ->
                                    let uu____18976 =
                                      FStar_All.pipe_left
                                        (fun _0_74  ->
                                           FStar_TypeChecker_Common.TProb
                                             _0_74)
                                        (let uu___161_18982 = problem  in
                                         {
                                           FStar_TypeChecker_Common.pid =
                                             (uu___161_18982.FStar_TypeChecker_Common.pid);
                                           FStar_TypeChecker_Common.lhs =
                                             (uu___161_18982.FStar_TypeChecker_Common.lhs);
                                           FStar_TypeChecker_Common.relation
                                             = new_rel;
                                           FStar_TypeChecker_Common.rhs =
                                             (uu___161_18982.FStar_TypeChecker_Common.rhs);
                                           FStar_TypeChecker_Common.element =
                                             (uu___161_18982.FStar_TypeChecker_Common.element);
                                           FStar_TypeChecker_Common.logical_guard
                                             =
                                             (uu___161_18982.FStar_TypeChecker_Common.logical_guard);
                                           FStar_TypeChecker_Common.scope =
                                             (uu___161_18982.FStar_TypeChecker_Common.scope);
                                           FStar_TypeChecker_Common.reason =
                                             (uu___161_18982.FStar_TypeChecker_Common.reason);
                                           FStar_TypeChecker_Common.loc =
                                             (uu___161_18982.FStar_TypeChecker_Common.loc);
                                           FStar_TypeChecker_Common.rank =
                                             (uu___161_18982.FStar_TypeChecker_Common.rank)
                                         })
                                       in
                                    let uu____18983 =
                                      destruct_flex_pattern env t1  in
                                    solve_t_flex_rigid false uu____18976
                                      uu____18983 t_base wl
                                | FStar_Pervasives_Native.Some (y,phi) ->
                                    let y' =
                                      let uu___162_18997 = y  in
                                      {
                                        FStar_Syntax_Syntax.ppname =
                                          (uu___162_18997.FStar_Syntax_Syntax.ppname);
                                        FStar_Syntax_Syntax.index =
                                          (uu___162_18997.FStar_Syntax_Syntax.index);
                                        FStar_Syntax_Syntax.sort = t1
                                      }  in
                                    let impl =
                                      guard_on_element wl problem y' phi  in
                                    let base_prob =
                                      let uu____19000 =
                                        mk_problem
                                          problem.FStar_TypeChecker_Common.scope
                                          orig t1 new_rel
                                          y.FStar_Syntax_Syntax.sort
                                          problem.FStar_TypeChecker_Common.element
                                          "flex-rigid: base type"
                                         in
                                      FStar_All.pipe_left
                                        (fun _0_75  ->
                                           FStar_TypeChecker_Common.TProb
                                             _0_75) uu____19000
                                       in
                                    let guard =
                                      let uu____19012 =
                                        FStar_All.pipe_right
                                          (p_guard base_prob)
                                          FStar_Pervasives_Native.fst
                                         in
                                      FStar_Syntax_Util.mk_conj uu____19012
                                        impl
                                       in
                                    let wl1 =
                                      solve_prob orig
                                        (FStar_Pervasives_Native.Some guard)
                                        [] wl
                                       in
                                    solve env (attempt [base_prob] wl1))))
                 | (uu____19020,FStar_Syntax_Syntax.Tm_uvar uu____19021) ->
                     if wl.defer_ok
                     then
                       solve env
                         (defer "rigid-flex subtyping deferred" orig wl)
                     else
                       (let uu____19039 = base_and_refinement env t1  in
                        match uu____19039 with
                        | (t_base,uu____19051) ->
                            solve_t env
                              (let uu___163_19065 = problem  in
                               {
                                 FStar_TypeChecker_Common.pid =
                                   (uu___163_19065.FStar_TypeChecker_Common.pid);
                                 FStar_TypeChecker_Common.lhs = t_base;
                                 FStar_TypeChecker_Common.relation =
                                   FStar_TypeChecker_Common.EQ;
                                 FStar_TypeChecker_Common.rhs =
                                   (uu___163_19065.FStar_TypeChecker_Common.rhs);
                                 FStar_TypeChecker_Common.element =
                                   (uu___163_19065.FStar_TypeChecker_Common.element);
                                 FStar_TypeChecker_Common.logical_guard =
                                   (uu___163_19065.FStar_TypeChecker_Common.logical_guard);
                                 FStar_TypeChecker_Common.scope =
                                   (uu___163_19065.FStar_TypeChecker_Common.scope);
                                 FStar_TypeChecker_Common.reason =
                                   (uu___163_19065.FStar_TypeChecker_Common.reason);
                                 FStar_TypeChecker_Common.loc =
                                   (uu___163_19065.FStar_TypeChecker_Common.loc);
                                 FStar_TypeChecker_Common.rank =
                                   (uu___163_19065.FStar_TypeChecker_Common.rank)
                               }) wl)
                 | (uu____19066,FStar_Syntax_Syntax.Tm_app
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_uvar
                         uu____19067;
                       FStar_Syntax_Syntax.pos = uu____19068;
                       FStar_Syntax_Syntax.vars = uu____19069;_},uu____19070))
                     ->
                     if wl.defer_ok
                     then
                       solve env
                         (defer "rigid-flex subtyping deferred" orig wl)
                     else
                       (let uu____19108 = base_and_refinement env t1  in
                        match uu____19108 with
                        | (t_base,uu____19120) ->
                            solve_t env
                              (let uu___163_19134 = problem  in
                               {
                                 FStar_TypeChecker_Common.pid =
                                   (uu___163_19134.FStar_TypeChecker_Common.pid);
                                 FStar_TypeChecker_Common.lhs = t_base;
                                 FStar_TypeChecker_Common.relation =
                                   FStar_TypeChecker_Common.EQ;
                                 FStar_TypeChecker_Common.rhs =
                                   (uu___163_19134.FStar_TypeChecker_Common.rhs);
                                 FStar_TypeChecker_Common.element =
                                   (uu___163_19134.FStar_TypeChecker_Common.element);
                                 FStar_TypeChecker_Common.logical_guard =
                                   (uu___163_19134.FStar_TypeChecker_Common.logical_guard);
                                 FStar_TypeChecker_Common.scope =
                                   (uu___163_19134.FStar_TypeChecker_Common.scope);
                                 FStar_TypeChecker_Common.reason =
                                   (uu___163_19134.FStar_TypeChecker_Common.reason);
                                 FStar_TypeChecker_Common.loc =
                                   (uu___163_19134.FStar_TypeChecker_Common.loc);
                                 FStar_TypeChecker_Common.rank =
                                   (uu___163_19134.FStar_TypeChecker_Common.rank)
                               }) wl)
                 | (FStar_Syntax_Syntax.Tm_refine uu____19135,uu____19136) ->
                     let t21 =
                       let uu____19146 = base_and_refinement env t2  in
                       FStar_All.pipe_left force_refinement uu____19146  in
                     solve_t env
                       (let uu___164_19170 = problem  in
                        {
                          FStar_TypeChecker_Common.pid =
                            (uu___164_19170.FStar_TypeChecker_Common.pid);
                          FStar_TypeChecker_Common.lhs =
                            (uu___164_19170.FStar_TypeChecker_Common.lhs);
                          FStar_TypeChecker_Common.relation =
                            (uu___164_19170.FStar_TypeChecker_Common.relation);
                          FStar_TypeChecker_Common.rhs = t21;
                          FStar_TypeChecker_Common.element =
                            (uu___164_19170.FStar_TypeChecker_Common.element);
                          FStar_TypeChecker_Common.logical_guard =
                            (uu___164_19170.FStar_TypeChecker_Common.logical_guard);
                          FStar_TypeChecker_Common.scope =
                            (uu___164_19170.FStar_TypeChecker_Common.scope);
                          FStar_TypeChecker_Common.reason =
                            (uu___164_19170.FStar_TypeChecker_Common.reason);
                          FStar_TypeChecker_Common.loc =
                            (uu___164_19170.FStar_TypeChecker_Common.loc);
                          FStar_TypeChecker_Common.rank =
                            (uu___164_19170.FStar_TypeChecker_Common.rank)
                        }) wl
                 | (uu____19171,FStar_Syntax_Syntax.Tm_refine uu____19172) ->
                     let t11 =
                       let uu____19182 = base_and_refinement env t1  in
                       FStar_All.pipe_left force_refinement uu____19182  in
                     solve_t env
                       (let uu___165_19206 = problem  in
                        {
                          FStar_TypeChecker_Common.pid =
                            (uu___165_19206.FStar_TypeChecker_Common.pid);
                          FStar_TypeChecker_Common.lhs = t11;
                          FStar_TypeChecker_Common.relation =
                            (uu___165_19206.FStar_TypeChecker_Common.relation);
                          FStar_TypeChecker_Common.rhs =
                            (uu___165_19206.FStar_TypeChecker_Common.rhs);
                          FStar_TypeChecker_Common.element =
                            (uu___165_19206.FStar_TypeChecker_Common.element);
                          FStar_TypeChecker_Common.logical_guard =
                            (uu___165_19206.FStar_TypeChecker_Common.logical_guard);
                          FStar_TypeChecker_Common.scope =
                            (uu___165_19206.FStar_TypeChecker_Common.scope);
                          FStar_TypeChecker_Common.reason =
                            (uu___165_19206.FStar_TypeChecker_Common.reason);
                          FStar_TypeChecker_Common.loc =
                            (uu___165_19206.FStar_TypeChecker_Common.loc);
                          FStar_TypeChecker_Common.rank =
                            (uu___165_19206.FStar_TypeChecker_Common.rank)
                        }) wl
                 | (FStar_Syntax_Syntax.Tm_match uu____19209,uu____19210) ->
                     let head1 =
                       let uu____19236 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____19236
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____19280 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____19280
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____19322 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____19322
                       then
                         let uu____19323 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____19324 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____19325 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____19323 uu____19324 uu____19325
                       else ());
                      (let uu____19327 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____19327
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____19342 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____19342
                          then
                            let guard =
                              let uu____19354 =
                                let uu____19355 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____19355 = FStar_Syntax_Util.Equal  in
                              if uu____19354
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____19359 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_76  ->
                                      FStar_Pervasives_Native.Some _0_76)
                                   uu____19359)
                               in
                            let uu____19362 = solve_prob orig guard [] wl  in
                            solve env uu____19362
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (FStar_Syntax_Syntax.Tm_uinst uu____19365,uu____19366) ->
                     let head1 =
                       let uu____19376 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____19376
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____19420 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____19420
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____19462 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____19462
                       then
                         let uu____19463 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____19464 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____19465 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____19463 uu____19464 uu____19465
                       else ());
                      (let uu____19467 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____19467
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____19482 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____19482
                          then
                            let guard =
                              let uu____19494 =
                                let uu____19495 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____19495 = FStar_Syntax_Util.Equal  in
                              if uu____19494
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____19499 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_77  ->
                                      FStar_Pervasives_Native.Some _0_77)
                                   uu____19499)
                               in
                            let uu____19502 = solve_prob orig guard [] wl  in
                            solve env uu____19502
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (FStar_Syntax_Syntax.Tm_name uu____19505,uu____19506) ->
                     let head1 =
                       let uu____19510 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____19510
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____19554 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____19554
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____19596 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____19596
                       then
                         let uu____19597 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____19598 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____19599 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____19597 uu____19598 uu____19599
                       else ());
                      (let uu____19601 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____19601
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____19616 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____19616
                          then
                            let guard =
                              let uu____19628 =
                                let uu____19629 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____19629 = FStar_Syntax_Util.Equal  in
                              if uu____19628
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____19633 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_78  ->
                                      FStar_Pervasives_Native.Some _0_78)
                                   uu____19633)
                               in
                            let uu____19636 = solve_prob orig guard [] wl  in
                            solve env uu____19636
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (FStar_Syntax_Syntax.Tm_constant uu____19639,uu____19640)
                     ->
                     let head1 =
                       let uu____19644 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____19644
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____19688 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____19688
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____19730 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____19730
                       then
                         let uu____19731 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____19732 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____19733 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____19731 uu____19732 uu____19733
                       else ());
                      (let uu____19735 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____19735
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____19750 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____19750
                          then
                            let guard =
                              let uu____19762 =
                                let uu____19763 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____19763 = FStar_Syntax_Util.Equal  in
                              if uu____19762
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____19767 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_79  ->
                                      FStar_Pervasives_Native.Some _0_79)
                                   uu____19767)
                               in
                            let uu____19770 = solve_prob orig guard [] wl  in
                            solve env uu____19770
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (FStar_Syntax_Syntax.Tm_fvar uu____19773,uu____19774) ->
                     let head1 =
                       let uu____19778 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____19778
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____19822 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____19822
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____19864 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____19864
                       then
                         let uu____19865 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____19866 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____19867 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____19865 uu____19866 uu____19867
                       else ());
                      (let uu____19869 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____19869
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____19884 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____19884
                          then
                            let guard =
                              let uu____19896 =
                                let uu____19897 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____19897 = FStar_Syntax_Util.Equal  in
                              if uu____19896
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____19901 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_80  ->
                                      FStar_Pervasives_Native.Some _0_80)
                                   uu____19901)
                               in
                            let uu____19904 = solve_prob orig guard [] wl  in
                            solve env uu____19904
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (FStar_Syntax_Syntax.Tm_app uu____19907,uu____19908) ->
                     let head1 =
                       let uu____19926 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____19926
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____19970 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____19970
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____20012 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____20012
                       then
                         let uu____20013 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____20014 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____20015 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____20013 uu____20014 uu____20015
                       else ());
                      (let uu____20017 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____20017
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____20032 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____20032
                          then
                            let guard =
                              let uu____20044 =
                                let uu____20045 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____20045 = FStar_Syntax_Util.Equal  in
                              if uu____20044
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____20049 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_81  ->
                                      FStar_Pervasives_Native.Some _0_81)
                                   uu____20049)
                               in
                            let uu____20052 = solve_prob orig guard [] wl  in
                            solve env uu____20052
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (uu____20055,FStar_Syntax_Syntax.Tm_match uu____20056) ->
                     let head1 =
                       let uu____20082 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____20082
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____20126 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____20126
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____20168 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____20168
                       then
                         let uu____20169 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____20170 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____20171 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____20169 uu____20170 uu____20171
                       else ());
                      (let uu____20173 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____20173
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____20188 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____20188
                          then
                            let guard =
                              let uu____20200 =
                                let uu____20201 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____20201 = FStar_Syntax_Util.Equal  in
                              if uu____20200
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____20205 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_82  ->
                                      FStar_Pervasives_Native.Some _0_82)
                                   uu____20205)
                               in
                            let uu____20208 = solve_prob orig guard [] wl  in
                            solve env uu____20208
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (uu____20211,FStar_Syntax_Syntax.Tm_uinst uu____20212) ->
                     let head1 =
                       let uu____20222 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____20222
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____20266 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____20266
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____20308 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____20308
                       then
                         let uu____20309 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____20310 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____20311 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____20309 uu____20310 uu____20311
                       else ());
                      (let uu____20313 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____20313
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____20328 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____20328
                          then
                            let guard =
                              let uu____20340 =
                                let uu____20341 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____20341 = FStar_Syntax_Util.Equal  in
                              if uu____20340
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____20345 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_83  ->
                                      FStar_Pervasives_Native.Some _0_83)
                                   uu____20345)
                               in
                            let uu____20348 = solve_prob orig guard [] wl  in
                            solve env uu____20348
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (uu____20351,FStar_Syntax_Syntax.Tm_name uu____20352) ->
                     let head1 =
                       let uu____20356 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____20356
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____20400 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____20400
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____20442 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____20442
                       then
                         let uu____20443 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____20444 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____20445 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____20443 uu____20444 uu____20445
                       else ());
                      (let uu____20447 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____20447
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____20462 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____20462
                          then
                            let guard =
                              let uu____20474 =
                                let uu____20475 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____20475 = FStar_Syntax_Util.Equal  in
                              if uu____20474
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____20479 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_84  ->
                                      FStar_Pervasives_Native.Some _0_84)
                                   uu____20479)
                               in
                            let uu____20482 = solve_prob orig guard [] wl  in
                            solve env uu____20482
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (uu____20485,FStar_Syntax_Syntax.Tm_constant uu____20486)
                     ->
                     let head1 =
                       let uu____20490 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____20490
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____20534 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____20534
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____20576 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____20576
                       then
                         let uu____20577 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____20578 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____20579 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____20577 uu____20578 uu____20579
                       else ());
                      (let uu____20581 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____20581
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____20596 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____20596
                          then
                            let guard =
                              let uu____20608 =
                                let uu____20609 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____20609 = FStar_Syntax_Util.Equal  in
                              if uu____20608
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____20613 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_85  ->
                                      FStar_Pervasives_Native.Some _0_85)
                                   uu____20613)
                               in
                            let uu____20616 = solve_prob orig guard [] wl  in
                            solve env uu____20616
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (uu____20619,FStar_Syntax_Syntax.Tm_fvar uu____20620) ->
                     let head1 =
                       let uu____20624 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____20624
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____20668 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____20668
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____20710 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____20710
                       then
                         let uu____20711 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____20712 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____20713 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____20711 uu____20712 uu____20713
                       else ());
                      (let uu____20715 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____20715
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____20730 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____20730
                          then
                            let guard =
                              let uu____20742 =
                                let uu____20743 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____20743 = FStar_Syntax_Util.Equal  in
                              if uu____20742
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____20747 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_86  ->
                                      FStar_Pervasives_Native.Some _0_86)
                                   uu____20747)
                               in
                            let uu____20750 = solve_prob orig guard [] wl  in
                            solve env uu____20750
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (uu____20753,FStar_Syntax_Syntax.Tm_app uu____20754) ->
                     let head1 =
                       let uu____20772 = FStar_Syntax_Util.head_and_args t1
                          in
                       FStar_All.pipe_right uu____20772
                         FStar_Pervasives_Native.fst
                        in
                     let head2 =
                       let uu____20816 = FStar_Syntax_Util.head_and_args t2
                          in
                       FStar_All.pipe_right uu____20816
                         FStar_Pervasives_Native.fst
                        in
                     ((let uu____20858 =
                         FStar_TypeChecker_Env.debug env
                           (FStar_Options.Other "RelCheck")
                          in
                       if uu____20858
                       then
                         let uu____20859 =
                           FStar_Util.string_of_int
                             problem.FStar_TypeChecker_Common.pid
                            in
                         let uu____20860 =
                           FStar_Syntax_Print.term_to_string head1  in
                         let uu____20861 =
                           FStar_Syntax_Print.term_to_string head2  in
                         FStar_Util.print3
                           ">> (%s)\n>>> head1 = %s\n>>> head2 = %s\n"
                           uu____20859 uu____20860 uu____20861
                       else ());
                      (let uu____20863 =
                         (((FStar_TypeChecker_Env.is_interpreted env head1)
                             ||
                             (FStar_TypeChecker_Env.is_interpreted env head2))
                            && wl.smt_ok)
                           &&
                           (problem.FStar_TypeChecker_Common.relation =
                              FStar_TypeChecker_Common.EQ)
                          in
                       if uu____20863
                       then
                         let uv1 = FStar_Syntax_Free.uvars t1  in
                         let uv2 = FStar_Syntax_Free.uvars t2  in
                         let uu____20878 =
                           (FStar_Util.set_is_empty uv1) &&
                             (FStar_Util.set_is_empty uv2)
                            in
                         (if uu____20878
                          then
                            let guard =
                              let uu____20890 =
                                let uu____20891 =
                                  FStar_Syntax_Util.eq_tm t1 t2  in
                                uu____20891 = FStar_Syntax_Util.Equal  in
                              if uu____20890
                              then FStar_Pervasives_Native.None
                              else
                                (let uu____20895 = mk_eq2 orig t1 t2  in
                                 FStar_All.pipe_left
                                   (fun _0_87  ->
                                      FStar_Pervasives_Native.Some _0_87)
                                   uu____20895)
                               in
                            let uu____20898 = solve_prob orig guard [] wl  in
                            solve env uu____20898
                          else
                            rigid_rigid_delta env orig wl head1 head2 t1 t2)
                       else rigid_rigid_delta env orig wl head1 head2 t1 t2))
                 | (FStar_Syntax_Syntax.Tm_let
                    uu____20901,FStar_Syntax_Syntax.Tm_let uu____20902) ->
                     let uu____20927 = FStar_Syntax_Util.term_eq t1 t2  in
                     if uu____20927
                     then
                       let uu____20928 =
                         solve_prob orig FStar_Pervasives_Native.None [] wl
                          in
                       solve env uu____20928
                     else giveup env "Tm_let mismatch (%s-%s vs %s-%s)" orig
                 | (FStar_Syntax_Syntax.Tm_let uu____20930,uu____20931) ->
                     let uu____20944 =
                       let uu____20949 =
                         let uu____20950 = FStar_Syntax_Print.tag_of_term t1
                            in
                         let uu____20951 = FStar_Syntax_Print.tag_of_term t2
                            in
                         let uu____20952 =
                           FStar_Syntax_Print.term_to_string t1  in
                         let uu____20953 =
                           FStar_Syntax_Print.term_to_string t2  in
                         FStar_Util.format4
                           "Internal error: unexpected flex-flex of %s and %s\n>>> (%s) -- (%s)"
                           uu____20950 uu____20951 uu____20952 uu____20953
                          in
                       (FStar_Errors.Fatal_UnificationNotWellFormed,
                         uu____20949)
                        in
                     FStar_Errors.raise_error uu____20944
                       t1.FStar_Syntax_Syntax.pos
                 | (uu____20954,FStar_Syntax_Syntax.Tm_let uu____20955) ->
                     let uu____20968 =
                       let uu____20973 =
                         let uu____20974 = FStar_Syntax_Print.tag_of_term t1
                            in
                         let uu____20975 = FStar_Syntax_Print.tag_of_term t2
                            in
                         let uu____20976 =
                           FStar_Syntax_Print.term_to_string t1  in
                         let uu____20977 =
                           FStar_Syntax_Print.term_to_string t2  in
                         FStar_Util.format4
                           "Internal error: unexpected flex-flex of %s and %s\n>>> (%s) -- (%s)"
                           uu____20974 uu____20975 uu____20976 uu____20977
                          in
                       (FStar_Errors.Fatal_UnificationNotWellFormed,
                         uu____20973)
                        in
                     FStar_Errors.raise_error uu____20968
                       t1.FStar_Syntax_Syntax.pos
                 | uu____20978 -> giveup env "head tag mismatch" orig)))))

and (solve_c :
  FStar_TypeChecker_Env.env ->
    (FStar_Syntax_Syntax.comp,Prims.unit) FStar_TypeChecker_Common.problem ->
      worklist -> solution)
  =
  fun env  ->
    fun problem  ->
      fun wl  ->
        let c1 = problem.FStar_TypeChecker_Common.lhs  in
        let c2 = problem.FStar_TypeChecker_Common.rhs  in
        let orig = FStar_TypeChecker_Common.CProb problem  in
        let sub_prob t1 rel t2 reason =
          let uu____21006 = p_scope orig  in
          mk_problem uu____21006 orig t1 rel t2 FStar_Pervasives_Native.None
            reason
           in
        let solve_eq c1_comp c2_comp =
          (let uu____21015 =
             FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
               (FStar_Options.Other "EQ")
              in
           if uu____21015
           then
             FStar_Util.print_string
               "solve_c is using an equality constraint\n"
           else ());
          (let uu____21017 =
             let uu____21018 =
               FStar_Ident.lid_equals c1_comp.FStar_Syntax_Syntax.effect_name
                 c2_comp.FStar_Syntax_Syntax.effect_name
                in
             Prims.op_Negation uu____21018  in
           if uu____21017
           then
             let uu____21019 =
               let uu____21020 =
                 FStar_Syntax_Print.lid_to_string
                   c1_comp.FStar_Syntax_Syntax.effect_name
                  in
               let uu____21021 =
                 FStar_Syntax_Print.lid_to_string
                   c2_comp.FStar_Syntax_Syntax.effect_name
                  in
               FStar_Util.format2 "incompatible effects: %s <> %s"
                 uu____21020 uu____21021
                in
             giveup env uu____21019 orig
           else
             (let sub_probs =
                FStar_List.map2
                  (fun uu____21041  ->
                     fun uu____21042  ->
                       match (uu____21041, uu____21042) with
                       | ((a1,uu____21060),(a2,uu____21062)) ->
                           let uu____21071 =
                             sub_prob a1 FStar_TypeChecker_Common.EQ a2
                               "effect arg"
                              in
                           FStar_All.pipe_left
                             (fun _0_88  ->
                                FStar_TypeChecker_Common.TProb _0_88)
                             uu____21071)
                  c1_comp.FStar_Syntax_Syntax.effect_args
                  c2_comp.FStar_Syntax_Syntax.effect_args
                 in
              let guard =
                let uu____21081 =
                  FStar_List.map
                    (fun p  ->
                       FStar_All.pipe_right (p_guard p)
                         FStar_Pervasives_Native.fst) sub_probs
                   in
                FStar_Syntax_Util.mk_conj_l uu____21081  in
              let wl1 =
                solve_prob orig (FStar_Pervasives_Native.Some guard) [] wl
                 in
              solve env (attempt sub_probs wl1)))
           in
        let solve_sub c11 edge c21 =
          let r = FStar_TypeChecker_Env.get_range env  in
          let lift_c1 uu____21105 =
            let wp =
              match c11.FStar_Syntax_Syntax.effect_args with
              | (wp1,uu____21112)::[] -> wp1
              | uu____21129 ->
                  let uu____21138 =
                    let uu____21139 =
                      let uu____21140 =
                        FStar_Ident.range_of_lid
                          c11.FStar_Syntax_Syntax.effect_name
                         in
                      FStar_Range.string_of_range uu____21140  in
                    FStar_Util.format1
                      "Unexpected number of indices on a normalized effect (%s)"
                      uu____21139
                     in
                  failwith uu____21138
               in
            let univs1 =
              match c11.FStar_Syntax_Syntax.comp_univs with
              | [] ->
                  let uu____21148 =
                    env.FStar_TypeChecker_Env.universe_of env
                      c11.FStar_Syntax_Syntax.result_typ
                     in
                  [uu____21148]
              | x -> x  in
            let uu____21150 =
              let uu____21159 =
                let uu____21160 =
                  let uu____21161 = FStar_List.hd univs1  in
                  (edge.FStar_TypeChecker_Env.mlift).FStar_TypeChecker_Env.mlift_wp
                    uu____21161 c11.FStar_Syntax_Syntax.result_typ wp
                   in
                FStar_Syntax_Syntax.as_arg uu____21160  in
              [uu____21159]  in
            {
              FStar_Syntax_Syntax.comp_univs = univs1;
              FStar_Syntax_Syntax.effect_name =
                (c21.FStar_Syntax_Syntax.effect_name);
              FStar_Syntax_Syntax.result_typ =
                (c11.FStar_Syntax_Syntax.result_typ);
              FStar_Syntax_Syntax.effect_args = uu____21150;
              FStar_Syntax_Syntax.flags = (c11.FStar_Syntax_Syntax.flags)
            }  in
          if
            problem.FStar_TypeChecker_Common.relation =
              FStar_TypeChecker_Common.EQ
          then let uu____21162 = lift_c1 ()  in solve_eq uu____21162 c21
          else
            (let is_null_wp_2 =
               FStar_All.pipe_right c21.FStar_Syntax_Syntax.flags
                 (FStar_Util.for_some
                    (fun uu___117_21168  ->
                       match uu___117_21168 with
                       | FStar_Syntax_Syntax.TOTAL  -> true
                       | FStar_Syntax_Syntax.MLEFFECT  -> true
                       | FStar_Syntax_Syntax.SOMETRIVIAL  -> true
                       | uu____21169 -> false))
                in
             let uu____21170 =
               match ((c11.FStar_Syntax_Syntax.effect_args),
                       (c21.FStar_Syntax_Syntax.effect_args))
               with
               | ((wp1,uu____21204)::uu____21205,(wp2,uu____21207)::uu____21208)
                   -> (wp1, wp2)
               | uu____21265 ->
                   let uu____21286 =
                     let uu____21291 =
                       let uu____21292 =
                         FStar_Syntax_Print.lid_to_string
                           c11.FStar_Syntax_Syntax.effect_name
                          in
                       let uu____21293 =
                         FStar_Syntax_Print.lid_to_string
                           c21.FStar_Syntax_Syntax.effect_name
                          in
                       FStar_Util.format2
                         "Got effects %s and %s, expected normalized effects"
                         uu____21292 uu____21293
                        in
                     (FStar_Errors.Fatal_ExpectNormalizedEffect, uu____21291)
                      in
                   FStar_Errors.raise_error uu____21286
                     env.FStar_TypeChecker_Env.range
                in
             match uu____21170 with
             | (wpc1,wpc2) ->
                 let uu____21312 = FStar_Util.physical_equality wpc1 wpc2  in
                 if uu____21312
                 then
                   let uu____21315 =
                     problem_using_guard orig
                       c11.FStar_Syntax_Syntax.result_typ
                       problem.FStar_TypeChecker_Common.relation
                       c21.FStar_Syntax_Syntax.result_typ
                       FStar_Pervasives_Native.None "result type"
                      in
                   solve_t env uu____21315 wl
                 else
                   (let uu____21319 =
                      let uu____21326 =
                        FStar_TypeChecker_Env.effect_decl_opt env
                          c21.FStar_Syntax_Syntax.effect_name
                         in
                      FStar_Util.must uu____21326  in
                    match uu____21319 with
                    | (c2_decl,qualifiers) ->
                        let uu____21347 =
                          FStar_All.pipe_right qualifiers
                            (FStar_List.contains
                               FStar_Syntax_Syntax.Reifiable)
                           in
                        if uu____21347
                        then
                          let c1_repr =
                            let uu____21351 =
                              let uu____21352 =
                                let uu____21353 = lift_c1 ()  in
                                FStar_Syntax_Syntax.mk_Comp uu____21353  in
                              let uu____21354 =
                                env.FStar_TypeChecker_Env.universe_of env
                                  c11.FStar_Syntax_Syntax.result_typ
                                 in
                              FStar_TypeChecker_Env.reify_comp env
                                uu____21352 uu____21354
                               in
                            FStar_TypeChecker_Normalize.normalize
                              [FStar_TypeChecker_Normalize.UnfoldUntil
                                 FStar_Syntax_Syntax.Delta_constant;
                              FStar_TypeChecker_Normalize.Weak;
                              FStar_TypeChecker_Normalize.HNF] env
                              uu____21351
                             in
                          let c2_repr =
                            let uu____21356 =
                              let uu____21357 =
                                FStar_Syntax_Syntax.mk_Comp c21  in
                              let uu____21358 =
                                env.FStar_TypeChecker_Env.universe_of env
                                  c21.FStar_Syntax_Syntax.result_typ
                                 in
                              FStar_TypeChecker_Env.reify_comp env
                                uu____21357 uu____21358
                               in
                            FStar_TypeChecker_Normalize.normalize
                              [FStar_TypeChecker_Normalize.UnfoldUntil
                                 FStar_Syntax_Syntax.Delta_constant;
                              FStar_TypeChecker_Normalize.Weak;
                              FStar_TypeChecker_Normalize.HNF] env
                              uu____21356
                             in
                          let prob =
                            let uu____21360 =
                              let uu____21365 =
                                let uu____21366 =
                                  FStar_Syntax_Print.term_to_string c1_repr
                                   in
                                let uu____21367 =
                                  FStar_Syntax_Print.term_to_string c2_repr
                                   in
                                FStar_Util.format2
                                  "sub effect repr: %s <: %s" uu____21366
                                  uu____21367
                                 in
                              sub_prob c1_repr
                                problem.FStar_TypeChecker_Common.relation
                                c2_repr uu____21365
                               in
                            FStar_TypeChecker_Common.TProb uu____21360  in
                          let wl1 =
                            let uu____21369 =
                              let uu____21372 =
                                FStar_All.pipe_right (p_guard prob)
                                  FStar_Pervasives_Native.fst
                                 in
                              FStar_Pervasives_Native.Some uu____21372  in
                            solve_prob orig uu____21369 [] wl  in
                          solve env (attempt [prob] wl1)
                        else
                          (let g =
                             if env.FStar_TypeChecker_Env.lax
                             then FStar_Syntax_Util.t_true
                             else
                               if is_null_wp_2
                               then
                                 ((let uu____21381 =
                                     FStar_All.pipe_left
                                       (FStar_TypeChecker_Env.debug env)
                                       (FStar_Options.Other "Rel")
                                      in
                                   if uu____21381
                                   then
                                     FStar_Util.print_string
                                       "Using trivial wp ... \n"
                                   else ());
                                  (let c1_univ =
                                     env.FStar_TypeChecker_Env.universe_of
                                       env c11.FStar_Syntax_Syntax.result_typ
                                      in
                                   let uu____21384 =
                                     let uu____21387 =
                                       let uu____21388 =
                                         let uu____21403 =
                                           FStar_TypeChecker_Env.inst_effect_fun_with
                                             [c1_univ] env c2_decl
                                             c2_decl.FStar_Syntax_Syntax.trivial
                                            in
                                         let uu____21404 =
                                           let uu____21407 =
                                             FStar_Syntax_Syntax.as_arg
                                               c11.FStar_Syntax_Syntax.result_typ
                                              in
                                           let uu____21408 =
                                             let uu____21411 =
                                               let uu____21412 =
                                                 (edge.FStar_TypeChecker_Env.mlift).FStar_TypeChecker_Env.mlift_wp
                                                   c1_univ
                                                   c11.FStar_Syntax_Syntax.result_typ
                                                   wpc1
                                                  in
                                               FStar_All.pipe_left
                                                 FStar_Syntax_Syntax.as_arg
                                                 uu____21412
                                                in
                                             [uu____21411]  in
                                           uu____21407 :: uu____21408  in
                                         (uu____21403, uu____21404)  in
                                       FStar_Syntax_Syntax.Tm_app uu____21388
                                        in
                                     FStar_Syntax_Syntax.mk uu____21387  in
                                   uu____21384 FStar_Pervasives_Native.None r))
                               else
                                 (let c1_univ =
                                    env.FStar_TypeChecker_Env.universe_of env
                                      c11.FStar_Syntax_Syntax.result_typ
                                     in
                                  let c2_univ =
                                    env.FStar_TypeChecker_Env.universe_of env
                                      c21.FStar_Syntax_Syntax.result_typ
                                     in
                                  let uu____21421 =
                                    let uu____21424 =
                                      let uu____21425 =
                                        let uu____21440 =
                                          FStar_TypeChecker_Env.inst_effect_fun_with
                                            [c2_univ] env c2_decl
                                            c2_decl.FStar_Syntax_Syntax.stronger
                                           in
                                        let uu____21441 =
                                          let uu____21444 =
                                            FStar_Syntax_Syntax.as_arg
                                              c21.FStar_Syntax_Syntax.result_typ
                                             in
                                          let uu____21445 =
                                            let uu____21448 =
                                              FStar_Syntax_Syntax.as_arg wpc2
                                               in
                                            let uu____21449 =
                                              let uu____21452 =
                                                let uu____21453 =
                                                  (edge.FStar_TypeChecker_Env.mlift).FStar_TypeChecker_Env.mlift_wp
                                                    c1_univ
                                                    c11.FStar_Syntax_Syntax.result_typ
                                                    wpc1
                                                   in
                                                FStar_All.pipe_left
                                                  FStar_Syntax_Syntax.as_arg
                                                  uu____21453
                                                 in
                                              [uu____21452]  in
                                            uu____21448 :: uu____21449  in
                                          uu____21444 :: uu____21445  in
                                        (uu____21440, uu____21441)  in
                                      FStar_Syntax_Syntax.Tm_app uu____21425
                                       in
                                    FStar_Syntax_Syntax.mk uu____21424  in
                                  uu____21421 FStar_Pervasives_Native.None r)
                              in
                           let base_prob =
                             let uu____21460 =
                               sub_prob c11.FStar_Syntax_Syntax.result_typ
                                 problem.FStar_TypeChecker_Common.relation
                                 c21.FStar_Syntax_Syntax.result_typ
                                 "result type"
                                in
                             FStar_All.pipe_left
                               (fun _0_89  ->
                                  FStar_TypeChecker_Common.TProb _0_89)
                               uu____21460
                              in
                           let wl1 =
                             let uu____21470 =
                               let uu____21473 =
                                 let uu____21476 =
                                   FStar_All.pipe_right (p_guard base_prob)
                                     FStar_Pervasives_Native.fst
                                    in
                                 FStar_Syntax_Util.mk_conj uu____21476 g  in
                               FStar_All.pipe_left
                                 (fun _0_90  ->
                                    FStar_Pervasives_Native.Some _0_90)
                                 uu____21473
                                in
                             solve_prob orig uu____21470 [] wl  in
                           solve env (attempt [base_prob] wl1))))
           in
        let uu____21489 = FStar_Util.physical_equality c1 c2  in
        if uu____21489
        then
          let uu____21490 =
            solve_prob orig FStar_Pervasives_Native.None [] wl  in
          solve env uu____21490
        else
          ((let uu____21493 =
              FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                (FStar_Options.Other "Rel")
               in
            if uu____21493
            then
              let uu____21494 = FStar_Syntax_Print.comp_to_string c1  in
              let uu____21495 = FStar_Syntax_Print.comp_to_string c2  in
              FStar_Util.print3 "solve_c %s %s %s\n" uu____21494
                (rel_to_string problem.FStar_TypeChecker_Common.relation)
                uu____21495
            else ());
           (let uu____21497 =
              let uu____21502 =
                FStar_TypeChecker_Normalize.ghost_to_pure env c1  in
              let uu____21503 =
                FStar_TypeChecker_Normalize.ghost_to_pure env c2  in
              (uu____21502, uu____21503)  in
            match uu____21497 with
            | (c11,c21) ->
                (match ((c11.FStar_Syntax_Syntax.n),
                         (c21.FStar_Syntax_Syntax.n))
                 with
                 | (FStar_Syntax_Syntax.GTotal
                    (t1,uu____21507),FStar_Syntax_Syntax.Total
                    (t2,uu____21509)) when
                     FStar_Syntax_Util.non_informative t2 ->
                     let uu____21526 =
                       problem_using_guard orig t1
                         problem.FStar_TypeChecker_Common.relation t2
                         FStar_Pervasives_Native.None "result type"
                        in
                     solve_t env uu____21526 wl
                 | (FStar_Syntax_Syntax.GTotal
                    uu____21529,FStar_Syntax_Syntax.Total uu____21530) ->
                     giveup env "incompatible monad ordering: GTot </: Tot"
                       orig
                 | (FStar_Syntax_Syntax.Total
                    (t1,uu____21548),FStar_Syntax_Syntax.Total
                    (t2,uu____21550)) ->
                     let uu____21567 =
                       problem_using_guard orig t1
                         problem.FStar_TypeChecker_Common.relation t2
                         FStar_Pervasives_Native.None "result type"
                        in
                     solve_t env uu____21567 wl
                 | (FStar_Syntax_Syntax.GTotal
                    (t1,uu____21571),FStar_Syntax_Syntax.GTotal
                    (t2,uu____21573)) ->
                     let uu____21590 =
                       problem_using_guard orig t1
                         problem.FStar_TypeChecker_Common.relation t2
                         FStar_Pervasives_Native.None "result type"
                        in
                     solve_t env uu____21590 wl
                 | (FStar_Syntax_Syntax.Total
                    (t1,uu____21594),FStar_Syntax_Syntax.GTotal
                    (t2,uu____21596)) ->
                     let uu____21613 =
                       problem_using_guard orig t1
                         problem.FStar_TypeChecker_Common.relation t2
                         FStar_Pervasives_Native.None "result type"
                        in
                     solve_t env uu____21613 wl
                 | (FStar_Syntax_Syntax.GTotal
                    uu____21616,FStar_Syntax_Syntax.Comp uu____21617) ->
                     let uu____21626 =
                       let uu___166_21631 = problem  in
                       let uu____21636 =
                         let uu____21637 =
                           FStar_TypeChecker_Env.comp_to_comp_typ env c11  in
                         FStar_All.pipe_left FStar_Syntax_Syntax.mk_Comp
                           uu____21637
                          in
                       {
                         FStar_TypeChecker_Common.pid =
                           (uu___166_21631.FStar_TypeChecker_Common.pid);
                         FStar_TypeChecker_Common.lhs = uu____21636;
                         FStar_TypeChecker_Common.relation =
                           (uu___166_21631.FStar_TypeChecker_Common.relation);
                         FStar_TypeChecker_Common.rhs =
                           (uu___166_21631.FStar_TypeChecker_Common.rhs);
                         FStar_TypeChecker_Common.element =
                           (uu___166_21631.FStar_TypeChecker_Common.element);
                         FStar_TypeChecker_Common.logical_guard =
                           (uu___166_21631.FStar_TypeChecker_Common.logical_guard);
                         FStar_TypeChecker_Common.scope =
                           (uu___166_21631.FStar_TypeChecker_Common.scope);
                         FStar_TypeChecker_Common.reason =
                           (uu___166_21631.FStar_TypeChecker_Common.reason);
                         FStar_TypeChecker_Common.loc =
                           (uu___166_21631.FStar_TypeChecker_Common.loc);
                         FStar_TypeChecker_Common.rank =
                           (uu___166_21631.FStar_TypeChecker_Common.rank)
                       }  in
                     solve_c env uu____21626 wl
                 | (FStar_Syntax_Syntax.Total
                    uu____21638,FStar_Syntax_Syntax.Comp uu____21639) ->
                     let uu____21648 =
                       let uu___166_21653 = problem  in
                       let uu____21658 =
                         let uu____21659 =
                           FStar_TypeChecker_Env.comp_to_comp_typ env c11  in
                         FStar_All.pipe_left FStar_Syntax_Syntax.mk_Comp
                           uu____21659
                          in
                       {
                         FStar_TypeChecker_Common.pid =
                           (uu___166_21653.FStar_TypeChecker_Common.pid);
                         FStar_TypeChecker_Common.lhs = uu____21658;
                         FStar_TypeChecker_Common.relation =
                           (uu___166_21653.FStar_TypeChecker_Common.relation);
                         FStar_TypeChecker_Common.rhs =
                           (uu___166_21653.FStar_TypeChecker_Common.rhs);
                         FStar_TypeChecker_Common.element =
                           (uu___166_21653.FStar_TypeChecker_Common.element);
                         FStar_TypeChecker_Common.logical_guard =
                           (uu___166_21653.FStar_TypeChecker_Common.logical_guard);
                         FStar_TypeChecker_Common.scope =
                           (uu___166_21653.FStar_TypeChecker_Common.scope);
                         FStar_TypeChecker_Common.reason =
                           (uu___166_21653.FStar_TypeChecker_Common.reason);
                         FStar_TypeChecker_Common.loc =
                           (uu___166_21653.FStar_TypeChecker_Common.loc);
                         FStar_TypeChecker_Common.rank =
                           (uu___166_21653.FStar_TypeChecker_Common.rank)
                       }  in
                     solve_c env uu____21648 wl
                 | (FStar_Syntax_Syntax.Comp
                    uu____21660,FStar_Syntax_Syntax.GTotal uu____21661) ->
                     let uu____21670 =
                       let uu___167_21675 = problem  in
                       let uu____21680 =
                         let uu____21681 =
                           FStar_TypeChecker_Env.comp_to_comp_typ env c21  in
                         FStar_All.pipe_left FStar_Syntax_Syntax.mk_Comp
                           uu____21681
                          in
                       {
                         FStar_TypeChecker_Common.pid =
                           (uu___167_21675.FStar_TypeChecker_Common.pid);
                         FStar_TypeChecker_Common.lhs =
                           (uu___167_21675.FStar_TypeChecker_Common.lhs);
                         FStar_TypeChecker_Common.relation =
                           (uu___167_21675.FStar_TypeChecker_Common.relation);
                         FStar_TypeChecker_Common.rhs = uu____21680;
                         FStar_TypeChecker_Common.element =
                           (uu___167_21675.FStar_TypeChecker_Common.element);
                         FStar_TypeChecker_Common.logical_guard =
                           (uu___167_21675.FStar_TypeChecker_Common.logical_guard);
                         FStar_TypeChecker_Common.scope =
                           (uu___167_21675.FStar_TypeChecker_Common.scope);
                         FStar_TypeChecker_Common.reason =
                           (uu___167_21675.FStar_TypeChecker_Common.reason);
                         FStar_TypeChecker_Common.loc =
                           (uu___167_21675.FStar_TypeChecker_Common.loc);
                         FStar_TypeChecker_Common.rank =
                           (uu___167_21675.FStar_TypeChecker_Common.rank)
                       }  in
                     solve_c env uu____21670 wl
                 | (FStar_Syntax_Syntax.Comp
                    uu____21682,FStar_Syntax_Syntax.Total uu____21683) ->
                     let uu____21692 =
                       let uu___167_21697 = problem  in
                       let uu____21702 =
                         let uu____21703 =
                           FStar_TypeChecker_Env.comp_to_comp_typ env c21  in
                         FStar_All.pipe_left FStar_Syntax_Syntax.mk_Comp
                           uu____21703
                          in
                       {
                         FStar_TypeChecker_Common.pid =
                           (uu___167_21697.FStar_TypeChecker_Common.pid);
                         FStar_TypeChecker_Common.lhs =
                           (uu___167_21697.FStar_TypeChecker_Common.lhs);
                         FStar_TypeChecker_Common.relation =
                           (uu___167_21697.FStar_TypeChecker_Common.relation);
                         FStar_TypeChecker_Common.rhs = uu____21702;
                         FStar_TypeChecker_Common.element =
                           (uu___167_21697.FStar_TypeChecker_Common.element);
                         FStar_TypeChecker_Common.logical_guard =
                           (uu___167_21697.FStar_TypeChecker_Common.logical_guard);
                         FStar_TypeChecker_Common.scope =
                           (uu___167_21697.FStar_TypeChecker_Common.scope);
                         FStar_TypeChecker_Common.reason =
                           (uu___167_21697.FStar_TypeChecker_Common.reason);
                         FStar_TypeChecker_Common.loc =
                           (uu___167_21697.FStar_TypeChecker_Common.loc);
                         FStar_TypeChecker_Common.rank =
                           (uu___167_21697.FStar_TypeChecker_Common.rank)
                       }  in
                     solve_c env uu____21692 wl
                 | (FStar_Syntax_Syntax.Comp
                    uu____21704,FStar_Syntax_Syntax.Comp uu____21705) ->
                     let uu____21706 =
                       (((FStar_Syntax_Util.is_ml_comp c11) &&
                           (FStar_Syntax_Util.is_ml_comp c21))
                          ||
                          ((FStar_Syntax_Util.is_total_comp c11) &&
                             (FStar_Syntax_Util.is_total_comp c21)))
                         ||
                         (((FStar_Syntax_Util.is_total_comp c11) &&
                             (FStar_Syntax_Util.is_ml_comp c21))
                            &&
                            (problem.FStar_TypeChecker_Common.relation =
                               FStar_TypeChecker_Common.SUB))
                        in
                     if uu____21706
                     then
                       let uu____21707 =
                         problem_using_guard orig
                           (FStar_Syntax_Util.comp_result c11)
                           problem.FStar_TypeChecker_Common.relation
                           (FStar_Syntax_Util.comp_result c21)
                           FStar_Pervasives_Native.None "result type"
                          in
                       solve_t env uu____21707 wl
                     else
                       (let c1_comp =
                          FStar_TypeChecker_Env.comp_to_comp_typ env c11  in
                        let c2_comp =
                          FStar_TypeChecker_Env.comp_to_comp_typ env c21  in
                        if
                          problem.FStar_TypeChecker_Common.relation =
                            FStar_TypeChecker_Common.EQ
                        then
                          let uu____21713 =
                            let uu____21718 =
                              FStar_Ident.lid_equals
                                c1_comp.FStar_Syntax_Syntax.effect_name
                                c2_comp.FStar_Syntax_Syntax.effect_name
                               in
                            if uu____21718
                            then (c1_comp, c2_comp)
                            else
                              (let uu____21724 =
                                 FStar_TypeChecker_Env.unfold_effect_abbrev
                                   env c11
                                  in
                               let uu____21725 =
                                 FStar_TypeChecker_Env.unfold_effect_abbrev
                                   env c21
                                  in
                               (uu____21724, uu____21725))
                             in
                          match uu____21713 with
                          | (c1_comp1,c2_comp1) -> solve_eq c1_comp1 c2_comp1
                        else
                          (let c12 =
                             FStar_TypeChecker_Env.unfold_effect_abbrev env
                               c11
                              in
                           let c22 =
                             FStar_TypeChecker_Env.unfold_effect_abbrev env
                               c21
                              in
                           (let uu____21732 =
                              FStar_All.pipe_left
                                (FStar_TypeChecker_Env.debug env)
                                (FStar_Options.Other "Rel")
                               in
                            if uu____21732
                            then
                              FStar_Util.print2 "solve_c for %s and %s\n"
                                (c12.FStar_Syntax_Syntax.effect_name).FStar_Ident.str
                                (c22.FStar_Syntax_Syntax.effect_name).FStar_Ident.str
                            else ());
                           (let uu____21734 =
                              FStar_TypeChecker_Env.monad_leq env
                                c12.FStar_Syntax_Syntax.effect_name
                                c22.FStar_Syntax_Syntax.effect_name
                               in
                            match uu____21734 with
                            | FStar_Pervasives_Native.None  ->
                                let uu____21737 =
                                  let uu____21738 =
                                    FStar_Syntax_Print.lid_to_string
                                      c12.FStar_Syntax_Syntax.effect_name
                                     in
                                  let uu____21739 =
                                    FStar_Syntax_Print.lid_to_string
                                      c22.FStar_Syntax_Syntax.effect_name
                                     in
                                  FStar_Util.format2
                                    "incompatible monad ordering: %s </: %s"
                                    uu____21738 uu____21739
                                   in
                                giveup env uu____21737 orig
                            | FStar_Pervasives_Native.Some edge ->
                                solve_sub c12 edge c22))))))

let (print_pending_implicits : FStar_TypeChecker_Env.guard_t -> Prims.string)
  =
  fun g  ->
    let uu____21744 =
      FStar_All.pipe_right g.FStar_TypeChecker_Env.implicits
        (FStar_List.map
           (fun uu____21782  ->
              match uu____21782 with
              | (uu____21795,uu____21796,u,uu____21798,uu____21799,uu____21800)
                  -> FStar_Syntax_Print.uvar_to_string u))
       in
    FStar_All.pipe_right uu____21744 (FStar_String.concat ", ")
  
let (ineqs_to_string :
  (FStar_Syntax_Syntax.universe Prims.list,(FStar_Syntax_Syntax.universe,
                                             FStar_Syntax_Syntax.universe)
                                             FStar_Pervasives_Native.tuple2
                                             Prims.list)
    FStar_Pervasives_Native.tuple2 -> Prims.string)
  =
  fun ineqs  ->
    let vars =
      let uu____21831 =
        FStar_All.pipe_right (FStar_Pervasives_Native.fst ineqs)
          (FStar_List.map FStar_Syntax_Print.univ_to_string)
         in
      FStar_All.pipe_right uu____21831 (FStar_String.concat ", ")  in
    let ineqs1 =
      let uu____21849 =
        FStar_All.pipe_right (FStar_Pervasives_Native.snd ineqs)
          (FStar_List.map
             (fun uu____21877  ->
                match uu____21877 with
                | (u1,u2) ->
                    let uu____21884 = FStar_Syntax_Print.univ_to_string u1
                       in
                    let uu____21885 = FStar_Syntax_Print.univ_to_string u2
                       in
                    FStar_Util.format2 "%s < %s" uu____21884 uu____21885))
         in
      FStar_All.pipe_right uu____21849 (FStar_String.concat ", ")  in
    FStar_Util.format2 "Solving for {%s}; inequalities are {%s}" vars ineqs1
  
let (guard_to_string :
  FStar_TypeChecker_Env.env -> FStar_TypeChecker_Env.guard_t -> Prims.string)
  =
  fun env  ->
    fun g  ->
      match ((g.FStar_TypeChecker_Env.guard_f),
              (g.FStar_TypeChecker_Env.deferred),
              (g.FStar_TypeChecker_Env.univ_ineqs))
      with
      | (FStar_TypeChecker_Common.Trivial ,[],(uu____21902,[])) -> "{}"
      | uu____21927 ->
          let form =
            match g.FStar_TypeChecker_Env.guard_f with
            | FStar_TypeChecker_Common.Trivial  -> "trivial"
            | FStar_TypeChecker_Common.NonTrivial f ->
                let uu____21944 =
                  ((FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                      (FStar_Options.Other "Rel"))
                     ||
                     (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                        (FStar_Options.Other "Implicits")))
                    ||
                    (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                       FStar_Options.Extreme)
                   in
                if uu____21944
                then FStar_TypeChecker_Normalize.term_to_string env f
                else "non-trivial"
             in
          let carry =
            let uu____21947 =
              FStar_List.map
                (fun uu____21957  ->
                   match uu____21957 with
                   | (uu____21962,x) -> prob_to_string env x)
                g.FStar_TypeChecker_Env.deferred
               in
            FStar_All.pipe_right uu____21947 (FStar_String.concat ",\n")  in
          let imps = print_pending_implicits g  in
          let uu____21967 =
            ineqs_to_string g.FStar_TypeChecker_Env.univ_ineqs  in
          FStar_Util.format4
            "\n\t{guard_f=%s;\n\t deferred={\n%s};\n\t univ_ineqs={%s};\n\t implicits={%s}}\n"
            form carry uu____21967 imps
  
let new_t_problem :
  'Auu____21975 .
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term ->
        FStar_TypeChecker_Common.rel ->
          FStar_Syntax_Syntax.term ->
            'Auu____21975 FStar_Pervasives_Native.option ->
              FStar_Range.range ->
                (FStar_Syntax_Syntax.term,'Auu____21975)
                  FStar_TypeChecker_Common.problem
  =
  fun env  ->
    fun lhs  ->
      fun rel  ->
        fun rhs  ->
          fun elt  ->
            fun loc  ->
              let reason =
                let uu____22009 =
                  FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                    (FStar_Options.Other "ExplainRel")
                   in
                if uu____22009
                then
                  let uu____22010 =
                    FStar_TypeChecker_Normalize.term_to_string env lhs  in
                  let uu____22011 =
                    FStar_TypeChecker_Normalize.term_to_string env rhs  in
                  FStar_Util.format3 "Top-level:\n%s\n\t%s\n%s" uu____22010
                    (rel_to_string rel) uu____22011
                else "TOP"  in
              let p = new_problem env lhs rel rhs elt loc reason  in p
  
let (new_t_prob :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ ->
      FStar_TypeChecker_Common.rel ->
        FStar_Syntax_Syntax.term ->
          (FStar_TypeChecker_Common.prob,FStar_Syntax_Syntax.bv)
            FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun t1  ->
      fun rel  ->
        fun t2  ->
          let x =
            let uu____22035 =
              let uu____22038 = FStar_TypeChecker_Env.get_range env  in
              FStar_All.pipe_left
                (fun _0_91  -> FStar_Pervasives_Native.Some _0_91)
                uu____22038
               in
            FStar_Syntax_Syntax.new_bv uu____22035 t1  in
          let env1 = FStar_TypeChecker_Env.push_bv env x  in
          let p =
            let uu____22047 =
              let uu____22050 = FStar_Syntax_Syntax.bv_to_name x  in
              FStar_All.pipe_left
                (fun _0_92  -> FStar_Pervasives_Native.Some _0_92)
                uu____22050
               in
            let uu____22053 = FStar_TypeChecker_Env.get_range env1  in
            new_t_problem env1 t1 rel t2 uu____22047 uu____22053  in
          ((FStar_TypeChecker_Common.TProb p), x)
  
let (solve_and_commit :
  FStar_TypeChecker_Env.env ->
    worklist ->
      ((FStar_TypeChecker_Common.prob,Prims.string)
         FStar_Pervasives_Native.tuple2 ->
         FStar_TypeChecker_Common.deferred FStar_Pervasives_Native.option)
        -> FStar_TypeChecker_Common.deferred FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun probs  ->
      fun err  ->
        let probs1 =
          let uu____22083 = FStar_Options.eager_inference ()  in
          if uu____22083
          then
            let uu___168_22084 = probs  in
            {
              attempting = (uu___168_22084.attempting);
              wl_deferred = (uu___168_22084.wl_deferred);
              ctr = (uu___168_22084.ctr);
              defer_ok = false;
              smt_ok = (uu___168_22084.smt_ok);
              tcenv = (uu___168_22084.tcenv)
            }
          else probs  in
        let tx = FStar_Syntax_Unionfind.new_transaction ()  in
        let sol = solve env probs1  in
        match sol with
        | Success deferred ->
            (FStar_Syntax_Unionfind.commit tx;
             FStar_Pervasives_Native.Some deferred)
        | Failed (d,s) ->
            ((let uu____22095 =
                FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                  (FStar_Options.Other "ExplainRel")
                 in
              if uu____22095
              then
                let uu____22096 = explain env d s  in
                FStar_All.pipe_left FStar_Util.print_string uu____22096
              else ());
             (let result = err (d, s)  in
              FStar_Syntax_Unionfind.rollback tx; result))
  
let (simplify_guard :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  =
  fun env  ->
    fun g  ->
      match g.FStar_TypeChecker_Env.guard_f with
      | FStar_TypeChecker_Common.Trivial  -> g
      | FStar_TypeChecker_Common.NonTrivial f ->
          ((let uu____22110 =
              FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                (FStar_Options.Other "Simplification")
               in
            if uu____22110
            then
              let uu____22111 = FStar_Syntax_Print.term_to_string f  in
              FStar_Util.print1 "Simplifying guard %s\n" uu____22111
            else ());
           (let f1 =
              FStar_TypeChecker_Normalize.normalize
                [FStar_TypeChecker_Normalize.Beta;
                FStar_TypeChecker_Normalize.Eager_unfolding;
                FStar_TypeChecker_Normalize.Simplify;
                FStar_TypeChecker_Normalize.Primops;
                FStar_TypeChecker_Normalize.NoFullNorm] env f
               in
            (let uu____22115 =
               FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                 (FStar_Options.Other "Simplification")
                in
             if uu____22115
             then
               let uu____22116 = FStar_Syntax_Print.term_to_string f1  in
               FStar_Util.print1 "Simplified guard to %s\n" uu____22116
             else ());
            (let f2 =
               let uu____22119 =
                 let uu____22120 = FStar_Syntax_Util.unmeta f1  in
                 uu____22120.FStar_Syntax_Syntax.n  in
               match uu____22119 with
               | FStar_Syntax_Syntax.Tm_fvar fv when
                   FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.true_lid
                   -> FStar_TypeChecker_Common.Trivial
               | uu____22124 -> FStar_TypeChecker_Common.NonTrivial f1  in
             let uu___169_22125 = g  in
             {
               FStar_TypeChecker_Env.guard_f = f2;
               FStar_TypeChecker_Env.deferred =
                 (uu___169_22125.FStar_TypeChecker_Env.deferred);
               FStar_TypeChecker_Env.univ_ineqs =
                 (uu___169_22125.FStar_TypeChecker_Env.univ_ineqs);
               FStar_TypeChecker_Env.implicits =
                 (uu___169_22125.FStar_TypeChecker_Env.implicits)
             })))
  
let (with_guard :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Common.prob ->
      FStar_TypeChecker_Common.deferred FStar_Pervasives_Native.option ->
        FStar_TypeChecker_Env.guard_t FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun prob  ->
      fun dopt  ->
        match dopt with
        | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
        | FStar_Pervasives_Native.Some d ->
            let uu____22144 =
              let uu____22145 =
                let uu____22146 =
                  let uu____22147 =
                    FStar_All.pipe_right (p_guard prob)
                      FStar_Pervasives_Native.fst
                     in
                  FStar_All.pipe_right uu____22147
                    (fun _0_93  -> FStar_TypeChecker_Common.NonTrivial _0_93)
                   in
                {
                  FStar_TypeChecker_Env.guard_f = uu____22146;
                  FStar_TypeChecker_Env.deferred = d;
                  FStar_TypeChecker_Env.univ_ineqs = ([], []);
                  FStar_TypeChecker_Env.implicits = []
                }  in
              simplify_guard env uu____22145  in
            FStar_All.pipe_left
              (fun _0_94  -> FStar_Pervasives_Native.Some _0_94) uu____22144
  
let with_guard_no_simp :
  'Auu____22174 .
    'Auu____22174 ->
      FStar_TypeChecker_Common.prob ->
        FStar_TypeChecker_Common.deferred FStar_Pervasives_Native.option ->
          FStar_TypeChecker_Env.guard_t FStar_Pervasives_Native.option
  =
  fun env  ->
    fun prob  ->
      fun dopt  ->
        match dopt with
        | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
        | FStar_Pervasives_Native.Some d ->
            let uu____22194 =
              let uu____22195 =
                let uu____22196 =
                  FStar_All.pipe_right (p_guard prob)
                    FStar_Pervasives_Native.fst
                   in
                FStar_All.pipe_right uu____22196
                  (fun _0_95  -> FStar_TypeChecker_Common.NonTrivial _0_95)
                 in
              {
                FStar_TypeChecker_Env.guard_f = uu____22195;
                FStar_TypeChecker_Env.deferred = d;
                FStar_TypeChecker_Env.univ_ineqs = ([], []);
                FStar_TypeChecker_Env.implicits = []
              }  in
            FStar_Pervasives_Native.Some uu____22194
  
let (try_teq :
  Prims.bool ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.typ ->
        FStar_Syntax_Syntax.typ ->
          FStar_TypeChecker_Env.guard_t FStar_Pervasives_Native.option)
  =
  fun smt_ok  ->
    fun env  ->
      fun t1  ->
        fun t2  ->
          (let uu____22234 =
             FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
               (FStar_Options.Other "Rel")
              in
           if uu____22234
           then
             let uu____22235 = FStar_Syntax_Print.term_to_string t1  in
             let uu____22236 = FStar_Syntax_Print.term_to_string t2  in
             FStar_Util.print2 "try_teq of %s and %s\n" uu____22235
               uu____22236
           else ());
          (let prob =
             let uu____22239 =
               let uu____22244 = FStar_TypeChecker_Env.get_range env  in
               new_t_problem env t1 FStar_TypeChecker_Common.EQ t2
                 FStar_Pervasives_Native.None uu____22244
                in
             FStar_All.pipe_left
               (fun _0_96  -> FStar_TypeChecker_Common.TProb _0_96)
               uu____22239
              in
           let g =
             let uu____22252 =
               let uu____22255 = singleton' env prob smt_ok  in
               solve_and_commit env uu____22255
                 (fun uu____22257  -> FStar_Pervasives_Native.None)
                in
             FStar_All.pipe_left (with_guard env prob) uu____22252  in
           g)
  
let (teq :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.typ -> FStar_TypeChecker_Env.guard_t)
  =
  fun env  ->
    fun t1  ->
      fun t2  ->
        let uu____22275 = try_teq true env t1 t2  in
        match uu____22275 with
        | FStar_Pervasives_Native.None  ->
            ((let uu____22279 = FStar_TypeChecker_Env.get_range env  in
              let uu____22280 =
                FStar_TypeChecker_Err.basic_type_error env
                  FStar_Pervasives_Native.None t2 t1
                 in
              FStar_Errors.log_issue uu____22279 uu____22280);
             trivial_guard)
        | FStar_Pervasives_Native.Some g ->
            ((let uu____22287 =
                FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                  (FStar_Options.Other "Rel")
                 in
              if uu____22287
              then
                let uu____22288 = FStar_Syntax_Print.term_to_string t1  in
                let uu____22289 = FStar_Syntax_Print.term_to_string t2  in
                let uu____22290 = guard_to_string env g  in
                FStar_Util.print3
                  "teq of %s and %s succeeded with guard %s\n" uu____22288
                  uu____22289 uu____22290
              else ());
             g)
  
let (subtype_fail :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ -> Prims.unit)
  =
  fun env  ->
    fun e  ->
      fun t1  ->
        fun t2  ->
          let uu____22304 = FStar_TypeChecker_Env.get_range env  in
          let uu____22305 =
            FStar_TypeChecker_Err.basic_type_error env
              (FStar_Pervasives_Native.Some e) t2 t1
             in
          FStar_Errors.log_issue uu____22304 uu____22305
  
let (sub_comp :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.comp ->
      FStar_Syntax_Syntax.comp ->
        FStar_TypeChecker_Env.guard_t FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun c1  ->
      fun c2  ->
        (let uu____22322 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "Rel")
            in
         if uu____22322
         then
           let uu____22323 = FStar_Syntax_Print.comp_to_string c1  in
           let uu____22324 = FStar_Syntax_Print.comp_to_string c2  in
           FStar_Util.print2 "sub_comp of %s and %s\n" uu____22323
             uu____22324
         else ());
        (let rel =
           if env.FStar_TypeChecker_Env.use_eq
           then FStar_TypeChecker_Common.EQ
           else FStar_TypeChecker_Common.SUB  in
         let prob =
           let uu____22329 =
             let uu____22334 = FStar_TypeChecker_Env.get_range env  in
             new_problem env c1 rel c2 FStar_Pervasives_Native.None
               uu____22334 "sub_comp"
              in
           FStar_All.pipe_left
             (fun _0_97  -> FStar_TypeChecker_Common.CProb _0_97) uu____22329
            in
         let uu____22339 =
           let uu____22342 = singleton env prob  in
           solve_and_commit env uu____22342
             (fun uu____22344  -> FStar_Pervasives_Native.None)
            in
         FStar_All.pipe_left (with_guard env prob) uu____22339)
  
let (solve_universe_inequalities' :
  FStar_Syntax_Unionfind.tx ->
    FStar_TypeChecker_Env.env ->
      (FStar_Syntax_Syntax.universe Prims.list,(FStar_Syntax_Syntax.universe,
                                                 FStar_Syntax_Syntax.universe)
                                                 FStar_Pervasives_Native.tuple2
                                                 Prims.list)
        FStar_Pervasives_Native.tuple2 -> Prims.unit)
  =
  fun tx  ->
    fun env  ->
      fun uu____22373  ->
        match uu____22373 with
        | (variables,ineqs) ->
            let fail1 u1 u2 =
              FStar_Syntax_Unionfind.rollback tx;
              (let uu____22412 =
                 let uu____22417 =
                   let uu____22418 = FStar_Syntax_Print.univ_to_string u1  in
                   let uu____22419 = FStar_Syntax_Print.univ_to_string u2  in
                   FStar_Util.format2 "Universe %s and %s are incompatible"
                     uu____22418 uu____22419
                    in
                 (FStar_Errors.Fatal_IncompatibleUniverse, uu____22417)  in
               let uu____22420 = FStar_TypeChecker_Env.get_range env  in
               FStar_Errors.raise_error uu____22412 uu____22420)
               in
            let equiv1 v1 v' =
              let uu____22428 =
                let uu____22433 = FStar_Syntax_Subst.compress_univ v1  in
                let uu____22434 = FStar_Syntax_Subst.compress_univ v'  in
                (uu____22433, uu____22434)  in
              match uu____22428 with
              | (FStar_Syntax_Syntax.U_unif v0,FStar_Syntax_Syntax.U_unif
                 v0') -> FStar_Syntax_Unionfind.univ_equiv v0 v0'
              | uu____22453 -> false  in
            let sols =
              FStar_All.pipe_right variables
                (FStar_List.collect
                   (fun v1  ->
                      let uu____22483 = FStar_Syntax_Subst.compress_univ v1
                         in
                      match uu____22483 with
                      | FStar_Syntax_Syntax.U_unif uu____22490 ->
                          let lower_bounds_of_v =
                            FStar_All.pipe_right ineqs
                              (FStar_List.collect
                                 (fun uu____22519  ->
                                    match uu____22519 with
                                    | (u,v') ->
                                        let uu____22528 = equiv1 v1 v'  in
                                        if uu____22528
                                        then
                                          let uu____22531 =
                                            FStar_All.pipe_right variables
                                              (FStar_Util.for_some (equiv1 u))
                                             in
                                          (if uu____22531 then [] else [u])
                                        else []))
                             in
                          let lb =
                            FStar_TypeChecker_Normalize.normalize_universe
                              env
                              (FStar_Syntax_Syntax.U_max lower_bounds_of_v)
                             in
                          [(lb, v1)]
                      | uu____22547 -> []))
               in
            let uu____22552 =
              let wl =
                let uu___170_22556 = empty_worklist env  in
                {
                  attempting = (uu___170_22556.attempting);
                  wl_deferred = (uu___170_22556.wl_deferred);
                  ctr = (uu___170_22556.ctr);
                  defer_ok = false;
                  smt_ok = (uu___170_22556.smt_ok);
                  tcenv = (uu___170_22556.tcenv)
                }  in
              FStar_All.pipe_right sols
                (FStar_List.map
                   (fun uu____22574  ->
                      match uu____22574 with
                      | (lb,v1) ->
                          let uu____22581 =
                            solve_universe_eq (~- (Prims.parse_int "1")) wl
                              lb v1
                             in
                          (match uu____22581 with
                           | USolved wl1 -> ()
                           | uu____22583 -> fail1 lb v1)))
               in
            let rec check_ineq uu____22591 =
              match uu____22591 with
              | (u,v1) ->
                  let u1 =
                    FStar_TypeChecker_Normalize.normalize_universe env u  in
                  let v2 =
                    FStar_TypeChecker_Normalize.normalize_universe env v1  in
                  (match (u1, v2) with
                   | (FStar_Syntax_Syntax.U_zero ,uu____22600) -> true
                   | (FStar_Syntax_Syntax.U_succ
                      u0,FStar_Syntax_Syntax.U_succ v0) ->
                       check_ineq (u0, v0)
                   | (FStar_Syntax_Syntax.U_name
                      u0,FStar_Syntax_Syntax.U_name v0) ->
                       FStar_Ident.ident_equals u0 v0
                   | (FStar_Syntax_Syntax.U_unif
                      u0,FStar_Syntax_Syntax.U_unif v0) ->
                       FStar_Syntax_Unionfind.univ_equiv u0 v0
                   | (FStar_Syntax_Syntax.U_name
                      uu____22623,FStar_Syntax_Syntax.U_succ v0) ->
                       check_ineq (u1, v0)
                   | (FStar_Syntax_Syntax.U_unif
                      uu____22625,FStar_Syntax_Syntax.U_succ v0) ->
                       check_ineq (u1, v0)
                   | (FStar_Syntax_Syntax.U_max us,uu____22636) ->
                       FStar_All.pipe_right us
                         (FStar_Util.for_all (fun u2  -> check_ineq (u2, v2)))
                   | (uu____22643,FStar_Syntax_Syntax.U_max vs) ->
                       FStar_All.pipe_right vs
                         (FStar_Util.for_some
                            (fun v3  -> check_ineq (u1, v3)))
                   | uu____22651 -> false)
               in
            let uu____22656 =
              FStar_All.pipe_right ineqs
                (FStar_Util.for_all
                   (fun uu____22671  ->
                      match uu____22671 with
                      | (u,v1) ->
                          let uu____22678 = check_ineq (u, v1)  in
                          if uu____22678
                          then true
                          else
                            ((let uu____22681 =
                                FStar_All.pipe_left
                                  (FStar_TypeChecker_Env.debug env)
                                  (FStar_Options.Other "GenUniverses")
                                 in
                              if uu____22681
                              then
                                let uu____22682 =
                                  FStar_Syntax_Print.univ_to_string u  in
                                let uu____22683 =
                                  FStar_Syntax_Print.univ_to_string v1  in
                                FStar_Util.print2 "%s </= %s" uu____22682
                                  uu____22683
                              else ());
                             false)))
               in
            if uu____22656
            then ()
            else
              ((let uu____22687 =
                  FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                    (FStar_Options.Other "GenUniverses")
                   in
                if uu____22687
                then
                  ((let uu____22689 = ineqs_to_string (variables, ineqs)  in
                    FStar_Util.print1
                      "Partially solved inequality constraints are: %s\n"
                      uu____22689);
                   FStar_Syntax_Unionfind.rollback tx;
                   (let uu____22699 = ineqs_to_string (variables, ineqs)  in
                    FStar_Util.print1
                      "Original solved inequality constraints are: %s\n"
                      uu____22699))
                else ());
               (let uu____22709 = FStar_TypeChecker_Env.get_range env  in
                FStar_Errors.raise_error
                  (FStar_Errors.Fatal_FailToSolveUniverseInEquality,
                    "Failed to solve universe inequalities for inductives")
                  uu____22709))
  
let (solve_universe_inequalities :
  FStar_TypeChecker_Env.env ->
    (FStar_Syntax_Syntax.universe Prims.list,(FStar_Syntax_Syntax.universe,
                                               FStar_Syntax_Syntax.universe)
                                               FStar_Pervasives_Native.tuple2
                                               Prims.list)
      FStar_Pervasives_Native.tuple2 -> Prims.unit)
  =
  fun env  ->
    fun ineqs  ->
      let tx = FStar_Syntax_Unionfind.new_transaction ()  in
      solve_universe_inequalities' tx env ineqs;
      FStar_Syntax_Unionfind.commit tx
  
let rec (solve_deferred_constraints :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  =
  fun env  ->
    fun g  ->
      let fail1 uu____22757 =
        match uu____22757 with
        | (d,s) ->
            let msg = explain env d s  in
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_ErrorInSolveDeferredConstraints, msg)
              (p_loc d)
         in
      let wl = wl_of_guard env g.FStar_TypeChecker_Env.deferred  in
      (let uu____22771 =
         FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
           (FStar_Options.Other "RelCheck")
          in
       if uu____22771
       then
         let uu____22772 = wl_to_string wl  in
         let uu____22773 =
           FStar_Util.string_of_int
             (FStar_List.length g.FStar_TypeChecker_Env.implicits)
            in
         FStar_Util.print2
           "Trying to solve carried problems: begin\n\t%s\nend\n and %s implicits\n"
           uu____22772 uu____22773
       else ());
      (let g1 =
         let uu____22788 = solve_and_commit env wl fail1  in
         match uu____22788 with
         | FStar_Pervasives_Native.Some [] ->
             let uu___171_22801 = g  in
             {
               FStar_TypeChecker_Env.guard_f =
                 (uu___171_22801.FStar_TypeChecker_Env.guard_f);
               FStar_TypeChecker_Env.deferred = [];
               FStar_TypeChecker_Env.univ_ineqs =
                 (uu___171_22801.FStar_TypeChecker_Env.univ_ineqs);
               FStar_TypeChecker_Env.implicits =
                 (uu___171_22801.FStar_TypeChecker_Env.implicits)
             }
         | uu____22806 ->
             failwith "impossible: Unexpected deferred constraints remain"
          in
       solve_universe_inequalities env g1.FStar_TypeChecker_Env.univ_ineqs;
       (let uu___172_22810 = g1  in
        {
          FStar_TypeChecker_Env.guard_f =
            (uu___172_22810.FStar_TypeChecker_Env.guard_f);
          FStar_TypeChecker_Env.deferred =
            (uu___172_22810.FStar_TypeChecker_Env.deferred);
          FStar_TypeChecker_Env.univ_ineqs = ([], []);
          FStar_TypeChecker_Env.implicits =
            (uu___172_22810.FStar_TypeChecker_Env.implicits)
        }))
  
let (last_proof_ns :
  FStar_TypeChecker_Env.proof_namespace FStar_Pervasives_Native.option
    FStar_ST.ref)
  = FStar_Util.mk_ref FStar_Pervasives_Native.None 
let (maybe_update_proof_ns : FStar_TypeChecker_Env.env -> Prims.unit) =
  fun env  ->
    let pns = env.FStar_TypeChecker_Env.proof_ns  in
    let uu____22836 = FStar_ST.op_Bang last_proof_ns  in
    match uu____22836 with
    | FStar_Pervasives_Native.None  ->
        FStar_ST.op_Colon_Equals last_proof_ns
          (FStar_Pervasives_Native.Some pns)
    | FStar_Pervasives_Native.Some old ->
        if old = pns
        then ()
        else
          ((env.FStar_TypeChecker_Env.solver).FStar_TypeChecker_Env.refresh
             ();
           FStar_ST.op_Colon_Equals last_proof_ns
             (FStar_Pervasives_Native.Some pns))
  
let (discharge_guard' :
  (Prims.unit -> Prims.string) FStar_Pervasives_Native.option ->
    FStar_TypeChecker_Env.env ->
      FStar_TypeChecker_Env.guard_t ->
        Prims.bool ->
          FStar_TypeChecker_Env.guard_t FStar_Pervasives_Native.option)
  =
  fun use_env_range_msg  ->
    fun env  ->
      fun g  ->
        fun use_smt  ->
          let debug1 =
            ((FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                (FStar_Options.Other "Rel"))
               ||
               (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                  (FStar_Options.Other "SMTQuery")))
              ||
              (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                 (FStar_Options.Other "Tac"))
             in
          let g1 = solve_deferred_constraints env g  in
          let ret_g =
            let uu___173_22939 = g1  in
            {
              FStar_TypeChecker_Env.guard_f =
                FStar_TypeChecker_Common.Trivial;
              FStar_TypeChecker_Env.deferred =
                (uu___173_22939.FStar_TypeChecker_Env.deferred);
              FStar_TypeChecker_Env.univ_ineqs =
                (uu___173_22939.FStar_TypeChecker_Env.univ_ineqs);
              FStar_TypeChecker_Env.implicits =
                (uu___173_22939.FStar_TypeChecker_Env.implicits)
            }  in
          let uu____22940 =
            let uu____22941 = FStar_TypeChecker_Env.should_verify env  in
            Prims.op_Negation uu____22941  in
          if uu____22940
          then FStar_Pervasives_Native.Some ret_g
          else
            (match g1.FStar_TypeChecker_Env.guard_f with
             | FStar_TypeChecker_Common.Trivial  ->
                 FStar_Pervasives_Native.Some ret_g
             | FStar_TypeChecker_Common.NonTrivial vc ->
                 (if debug1
                  then
                    (let uu____22949 = FStar_TypeChecker_Env.get_range env
                        in
                     let uu____22950 =
                       let uu____22951 = FStar_Syntax_Print.term_to_string vc
                          in
                       FStar_Util.format1 "Before normalization VC=\n%s\n"
                         uu____22951
                        in
                     FStar_Errors.diag uu____22949 uu____22950)
                  else ();
                  (let vc1 =
                     FStar_TypeChecker_Normalize.normalize
                       [FStar_TypeChecker_Normalize.Eager_unfolding;
                       FStar_TypeChecker_Normalize.Simplify;
                       FStar_TypeChecker_Normalize.Primops] env vc
                      in
                   if debug1
                   then
                     (let uu____22955 = FStar_TypeChecker_Env.get_range env
                         in
                      let uu____22956 =
                        let uu____22957 =
                          FStar_Syntax_Print.term_to_string vc1  in
                        FStar_Util.format1 "After normalization VC=\n%s\n"
                          uu____22957
                         in
                      FStar_Errors.diag uu____22955 uu____22956)
                   else ();
                   (let uu____22960 = FStar_TypeChecker_Env.get_range env  in
                    def_check_closed_in_env uu____22960 "discharge_guard'"
                      env vc1);
                   (let uu____22961 = check_trivial vc1  in
                    match uu____22961 with
                    | FStar_TypeChecker_Common.Trivial  ->
                        FStar_Pervasives_Native.Some ret_g
                    | FStar_TypeChecker_Common.NonTrivial vc2 ->
                        if Prims.op_Negation use_smt
                        then
                          (if debug1
                           then
                             (let uu____22968 =
                                FStar_TypeChecker_Env.get_range env  in
                              let uu____22969 =
                                let uu____22970 =
                                  FStar_Syntax_Print.term_to_string vc2  in
                                FStar_Util.format1
                                  "Cannot solve without SMT : %s\n"
                                  uu____22970
                                 in
                              FStar_Errors.diag uu____22968 uu____22969)
                           else ();
                           FStar_Pervasives_Native.None)
                        else
                          (if debug1
                           then
                             (let uu____22975 =
                                FStar_TypeChecker_Env.get_range env  in
                              let uu____22976 =
                                let uu____22977 =
                                  FStar_Syntax_Print.term_to_string vc2  in
                                FStar_Util.format1 "Checking VC=\n%s\n"
                                  uu____22977
                                 in
                              FStar_Errors.diag uu____22975 uu____22976)
                           else ();
                           (let vcs =
                              let uu____22988 = FStar_Options.use_tactics ()
                                 in
                              if uu____22988
                              then
                                FStar_Options.with_saved_options
                                  (fun uu____23007  ->
                                     (let uu____23009 =
                                        FStar_Options.set_options
                                          FStar_Options.Set "--no_tactics"
                                         in
                                      FStar_All.pipe_left
                                        FStar_Pervasives.ignore uu____23009);
                                     (env.FStar_TypeChecker_Env.solver).FStar_TypeChecker_Env.preprocess
                                       env vc2)
                              else
                                (let uu____23011 =
                                   let uu____23018 = FStar_Options.peek ()
                                      in
                                   (env, vc2, uu____23018)  in
                                 [uu____23011])
                               in
                            FStar_All.pipe_right vcs
                              (FStar_List.iter
                                 (fun uu____23052  ->
                                    match uu____23052 with
                                    | (env1,goal,opts) ->
                                        let goal1 =
                                          FStar_TypeChecker_Normalize.normalize
                                            [FStar_TypeChecker_Normalize.Simplify;
                                            FStar_TypeChecker_Normalize.Primops]
                                            env1 goal
                                           in
                                        let uu____23063 = check_trivial goal1
                                           in
                                        (match uu____23063 with
                                         | FStar_TypeChecker_Common.Trivial 
                                             ->
                                             if debug1
                                             then
                                               FStar_Util.print_string
                                                 "Goal completely solved by tactic\n"
                                             else ()
                                         | FStar_TypeChecker_Common.NonTrivial
                                             goal2 ->
                                             (FStar_Options.push ();
                                              FStar_Options.set opts;
                                              maybe_update_proof_ns env1;
                                              if debug1
                                              then
                                                (let uu____23071 =
                                                   FStar_TypeChecker_Env.get_range
                                                     env1
                                                    in
                                                 let uu____23072 =
                                                   let uu____23073 =
                                                     FStar_Syntax_Print.term_to_string
                                                       goal2
                                                      in
                                                   let uu____23074 =
                                                     FStar_TypeChecker_Env.string_of_proof_ns
                                                       env1
                                                      in
                                                   FStar_Util.format2
                                                     "Trying to solve:\n> %s\nWith proof_ns:\n %s\n"
                                                     uu____23073 uu____23074
                                                    in
                                                 FStar_Errors.diag
                                                   uu____23071 uu____23072)
                                              else ();
                                              if debug1
                                              then
                                                (let uu____23077 =
                                                   FStar_TypeChecker_Env.get_range
                                                     env1
                                                    in
                                                 let uu____23078 =
                                                   let uu____23079 =
                                                     FStar_Syntax_Print.term_to_string
                                                       goal2
                                                      in
                                                   FStar_Util.format1
                                                     "Before calling solver VC=\n%s\n"
                                                     uu____23079
                                                    in
                                                 FStar_Errors.diag
                                                   uu____23077 uu____23078)
                                              else ();
                                              (env1.FStar_TypeChecker_Env.solver).FStar_TypeChecker_Env.solve
                                                use_env_range_msg env1 goal2;
                                              FStar_Options.pop ())))));
                           FStar_Pervasives_Native.Some ret_g)))))
  
let (discharge_guard_no_smt :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  =
  fun env  ->
    fun g  ->
      let uu____23089 =
        discharge_guard' FStar_Pervasives_Native.None env g false  in
      match uu____23089 with
      | FStar_Pervasives_Native.Some g1 -> g1
      | FStar_Pervasives_Native.None  ->
          let uu____23095 = FStar_TypeChecker_Env.get_range env  in
          FStar_Errors.raise_error
            (FStar_Errors.Fatal_ExpectTrivialPreCondition,
              "Expected a trivial pre-condition") uu____23095
  
let (discharge_guard :
  FStar_TypeChecker_Env.env ->
    FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  =
  fun env  ->
    fun g  ->
      let uu____23102 =
        discharge_guard' FStar_Pervasives_Native.None env g true  in
      match uu____23102 with
      | FStar_Pervasives_Native.Some g1 -> g1
      | FStar_Pervasives_Native.None  ->
          failwith
            "Impossible, with use_smt = true, discharge_guard' should never have returned None"
  
let (resolve_implicits' :
  Prims.bool ->
    Prims.bool ->
      FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t)
  =
  fun must_total  ->
    fun forcelax  ->
      fun g  ->
        let unresolved u =
          let uu____23121 = FStar_Syntax_Unionfind.find u  in
          match uu____23121 with
          | FStar_Pervasives_Native.None  -> true
          | uu____23124 -> false  in
        let rec until_fixpoint acc implicits =
          let uu____23142 = acc  in
          match uu____23142 with
          | (out,changed) ->
              (match implicits with
               | [] ->
                   if Prims.op_Negation changed
                   then out
                   else until_fixpoint ([], false) out
               | hd1::tl1 ->
                   let uu____23228 = hd1  in
                   (match uu____23228 with
                    | (uu____23241,env,u,tm,k,r) ->
                        let uu____23247 = unresolved u  in
                        if uu____23247
                        then until_fixpoint ((hd1 :: out), changed) tl1
                        else
                          (let tm1 =
                             FStar_TypeChecker_Normalize.normalize
                               [FStar_TypeChecker_Normalize.Beta] env tm
                              in
                           let env1 =
                             if forcelax
                             then
                               let uu___174_23277 = env  in
                               {
                                 FStar_TypeChecker_Env.solver =
                                   (uu___174_23277.FStar_TypeChecker_Env.solver);
                                 FStar_TypeChecker_Env.range =
                                   (uu___174_23277.FStar_TypeChecker_Env.range);
                                 FStar_TypeChecker_Env.curmodule =
                                   (uu___174_23277.FStar_TypeChecker_Env.curmodule);
                                 FStar_TypeChecker_Env.gamma =
                                   (uu___174_23277.FStar_TypeChecker_Env.gamma);
                                 FStar_TypeChecker_Env.gamma_cache =
                                   (uu___174_23277.FStar_TypeChecker_Env.gamma_cache);
                                 FStar_TypeChecker_Env.modules =
                                   (uu___174_23277.FStar_TypeChecker_Env.modules);
                                 FStar_TypeChecker_Env.expected_typ =
                                   (uu___174_23277.FStar_TypeChecker_Env.expected_typ);
                                 FStar_TypeChecker_Env.sigtab =
                                   (uu___174_23277.FStar_TypeChecker_Env.sigtab);
                                 FStar_TypeChecker_Env.is_pattern =
                                   (uu___174_23277.FStar_TypeChecker_Env.is_pattern);
                                 FStar_TypeChecker_Env.instantiate_imp =
                                   (uu___174_23277.FStar_TypeChecker_Env.instantiate_imp);
                                 FStar_TypeChecker_Env.effects =
                                   (uu___174_23277.FStar_TypeChecker_Env.effects);
                                 FStar_TypeChecker_Env.generalize =
                                   (uu___174_23277.FStar_TypeChecker_Env.generalize);
                                 FStar_TypeChecker_Env.letrecs =
                                   (uu___174_23277.FStar_TypeChecker_Env.letrecs);
                                 FStar_TypeChecker_Env.top_level =
                                   (uu___174_23277.FStar_TypeChecker_Env.top_level);
                                 FStar_TypeChecker_Env.check_uvars =
                                   (uu___174_23277.FStar_TypeChecker_Env.check_uvars);
                                 FStar_TypeChecker_Env.use_eq =
                                   (uu___174_23277.FStar_TypeChecker_Env.use_eq);
                                 FStar_TypeChecker_Env.is_iface =
                                   (uu___174_23277.FStar_TypeChecker_Env.is_iface);
                                 FStar_TypeChecker_Env.admit =
                                   (uu___174_23277.FStar_TypeChecker_Env.admit);
                                 FStar_TypeChecker_Env.lax = true;
                                 FStar_TypeChecker_Env.lax_universes =
                                   (uu___174_23277.FStar_TypeChecker_Env.lax_universes);
                                 FStar_TypeChecker_Env.failhard =
                                   (uu___174_23277.FStar_TypeChecker_Env.failhard);
                                 FStar_TypeChecker_Env.nosynth =
                                   (uu___174_23277.FStar_TypeChecker_Env.nosynth);
                                 FStar_TypeChecker_Env.tc_term =
                                   (uu___174_23277.FStar_TypeChecker_Env.tc_term);
                                 FStar_TypeChecker_Env.type_of =
                                   (uu___174_23277.FStar_TypeChecker_Env.type_of);
                                 FStar_TypeChecker_Env.universe_of =
                                   (uu___174_23277.FStar_TypeChecker_Env.universe_of);
                                 FStar_TypeChecker_Env.check_type_of =
                                   (uu___174_23277.FStar_TypeChecker_Env.check_type_of);
                                 FStar_TypeChecker_Env.use_bv_sorts =
                                   (uu___174_23277.FStar_TypeChecker_Env.use_bv_sorts);
                                 FStar_TypeChecker_Env.qtbl_name_and_index =
                                   (uu___174_23277.FStar_TypeChecker_Env.qtbl_name_and_index);
                                 FStar_TypeChecker_Env.proof_ns =
                                   (uu___174_23277.FStar_TypeChecker_Env.proof_ns);
                                 FStar_TypeChecker_Env.synth_hook =
                                   (uu___174_23277.FStar_TypeChecker_Env.synth_hook);
                                 FStar_TypeChecker_Env.splice =
                                   (uu___174_23277.FStar_TypeChecker_Env.splice);
                                 FStar_TypeChecker_Env.is_native_tactic =
                                   (uu___174_23277.FStar_TypeChecker_Env.is_native_tactic);
                                 FStar_TypeChecker_Env.identifier_info =
                                   (uu___174_23277.FStar_TypeChecker_Env.identifier_info);
                                 FStar_TypeChecker_Env.tc_hooks =
                                   (uu___174_23277.FStar_TypeChecker_Env.tc_hooks);
                                 FStar_TypeChecker_Env.dsenv =
                                   (uu___174_23277.FStar_TypeChecker_Env.dsenv);
                                 FStar_TypeChecker_Env.dep_graph =
                                   (uu___174_23277.FStar_TypeChecker_Env.dep_graph)
                               }
                             else env  in
                           (let uu____23280 =
                              FStar_All.pipe_left
                                (FStar_TypeChecker_Env.debug env1)
                                (FStar_Options.Other "RelCheck")
                               in
                            if uu____23280
                            then
                              let uu____23281 =
                                FStar_Syntax_Print.uvar_to_string u  in
                              let uu____23282 =
                                FStar_Syntax_Print.term_to_string tm1  in
                              let uu____23283 =
                                FStar_Syntax_Print.term_to_string k  in
                              FStar_Util.print3
                                "Checking uvar %s resolved to %s at type %s\n"
                                uu____23281 uu____23282 uu____23283
                            else ());
                           (let g1 =
                              try
                                env1.FStar_TypeChecker_Env.check_type_of
                                  must_total env1 tm1 k
                              with
                              | e ->
                                  ((let uu____23294 =
                                      let uu____23303 =
                                        let uu____23310 =
                                          let uu____23311 =
                                            FStar_Syntax_Print.uvar_to_string
                                              u
                                             in
                                          let uu____23312 =
                                            FStar_TypeChecker_Normalize.term_to_string
                                              env1 tm1
                                             in
                                          FStar_Util.format2
                                            "Failed while checking implicit %s set to %s"
                                            uu____23311 uu____23312
                                           in
                                        (FStar_Errors.Error_BadImplicit,
                                          uu____23310, r)
                                         in
                                      [uu____23303]  in
                                    FStar_Errors.add_errors uu____23294);
                                   FStar_Exn.raise e)
                               in
                            let g2 =
                              if env1.FStar_TypeChecker_Env.is_pattern
                              then
                                let uu___177_23326 = g1  in
                                {
                                  FStar_TypeChecker_Env.guard_f =
                                    FStar_TypeChecker_Common.Trivial;
                                  FStar_TypeChecker_Env.deferred =
                                    (uu___177_23326.FStar_TypeChecker_Env.deferred);
                                  FStar_TypeChecker_Env.univ_ineqs =
                                    (uu___177_23326.FStar_TypeChecker_Env.univ_ineqs);
                                  FStar_TypeChecker_Env.implicits =
                                    (uu___177_23326.FStar_TypeChecker_Env.implicits)
                                }
                              else g1  in
                            let g' =
                              let uu____23329 =
                                discharge_guard'
                                  (FStar_Pervasives_Native.Some
                                     (fun uu____23335  ->
                                        FStar_Syntax_Print.term_to_string tm1))
                                  env1 g2 true
                                 in
                              match uu____23329 with
                              | FStar_Pervasives_Native.Some g3 -> g3
                              | FStar_Pervasives_Native.None  ->
                                  failwith
                                    "Impossible, with use_smt = true, discharge_guard' should never have returned None"
                               in
                            until_fixpoint
                              ((FStar_List.append
                                  g'.FStar_TypeChecker_Env.implicits out),
                                true) tl1))))
           in
        let uu___178_23363 = g  in
        let uu____23364 =
          until_fixpoint ([], false) g.FStar_TypeChecker_Env.implicits  in
        {
          FStar_TypeChecker_Env.guard_f =
            (uu___178_23363.FStar_TypeChecker_Env.guard_f);
          FStar_TypeChecker_Env.deferred =
            (uu___178_23363.FStar_TypeChecker_Env.deferred);
          FStar_TypeChecker_Env.univ_ineqs =
            (uu___178_23363.FStar_TypeChecker_Env.univ_ineqs);
          FStar_TypeChecker_Env.implicits = uu____23364
        }
  
let (resolve_implicits :
  FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t) =
  fun g  -> resolve_implicits' true false g 
let (resolve_implicits_tac :
  FStar_TypeChecker_Env.guard_t -> FStar_TypeChecker_Env.guard_t) =
  fun g  -> resolve_implicits' false true g 
let (force_trivial_guard :
  FStar_TypeChecker_Env.env -> FStar_TypeChecker_Env.guard_t -> Prims.unit) =
  fun env  ->
    fun g  ->
      let g1 =
        let uu____23418 = solve_deferred_constraints env g  in
        FStar_All.pipe_right uu____23418 resolve_implicits  in
      match g1.FStar_TypeChecker_Env.implicits with
      | [] ->
          let uu____23431 = discharge_guard env g1  in
          FStar_All.pipe_left FStar_Pervasives.ignore uu____23431
      | (reason,uu____23433,uu____23434,e,t,r)::uu____23438 ->
          let uu____23465 =
            let uu____23470 =
              let uu____23471 = FStar_Syntax_Print.term_to_string t  in
              let uu____23472 = FStar_Syntax_Print.term_to_string e  in
              FStar_Util.format2
                "Failed to resolve implicit argument of type '%s' introduced in %s"
                uu____23471 uu____23472
               in
            (FStar_Errors.Fatal_FailToResolveImplicitArgument, uu____23470)
             in
          FStar_Errors.raise_error uu____23465 r
  
let (universe_inequality :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.universe -> FStar_TypeChecker_Env.guard_t)
  =
  fun u1  ->
    fun u2  ->
      let uu___179_23479 = trivial_guard  in
      {
        FStar_TypeChecker_Env.guard_f =
          (uu___179_23479.FStar_TypeChecker_Env.guard_f);
        FStar_TypeChecker_Env.deferred =
          (uu___179_23479.FStar_TypeChecker_Env.deferred);
        FStar_TypeChecker_Env.univ_ineqs = ([], [(u1, u2)]);
        FStar_TypeChecker_Env.implicits =
          (uu___179_23479.FStar_TypeChecker_Env.implicits)
      }
  
let (discharge_guard_nosmt :
  FStar_TypeChecker_Env.env -> FStar_TypeChecker_Env.guard_t -> Prims.bool) =
  fun env  ->
    fun g  ->
      let uu____23502 =
        discharge_guard' FStar_Pervasives_Native.None env g false  in
      match uu____23502 with
      | FStar_Pervasives_Native.Some uu____23507 -> true
      | FStar_Pervasives_Native.None  -> false
  
let (teq_nosmt :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ -> Prims.bool)
  =
  fun env  ->
    fun t1  ->
      fun t2  ->
        let uu____23517 = try_teq false env t1 t2  in
        match uu____23517 with
        | FStar_Pervasives_Native.None  -> false
        | FStar_Pervasives_Native.Some g -> discharge_guard_nosmt env g
  
let (check_subtyping :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        (FStar_Syntax_Syntax.bv,FStar_TypeChecker_Env.guard_t)
          FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun t1  ->
      fun t2  ->
        (let uu____23537 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "Rel")
            in
         if uu____23537
         then
           let uu____23538 =
             FStar_TypeChecker_Normalize.term_to_string env t1  in
           let uu____23539 =
             FStar_TypeChecker_Normalize.term_to_string env t2  in
           FStar_Util.print2 "check_subtyping of %s and %s\n" uu____23538
             uu____23539
         else ());
        (let uu____23541 = new_t_prob env t1 FStar_TypeChecker_Common.SUB t2
            in
         match uu____23541 with
         | (prob,x) ->
             let g =
               let uu____23557 =
                 let uu____23560 = singleton' env prob true  in
                 solve_and_commit env uu____23560
                   (fun uu____23562  -> FStar_Pervasives_Native.None)
                  in
               FStar_All.pipe_left (with_guard env prob) uu____23557  in
             ((let uu____23572 =
                 (FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                    (FStar_Options.Other "Rel"))
                   && (FStar_Util.is_some g)
                  in
               if uu____23572
               then
                 let uu____23573 =
                   FStar_TypeChecker_Normalize.term_to_string env t1  in
                 let uu____23574 =
                   FStar_TypeChecker_Normalize.term_to_string env t2  in
                 let uu____23575 =
                   let uu____23576 = FStar_Util.must g  in
                   guard_to_string env uu____23576  in
                 FStar_Util.print3
                   "check_subtyping succeeded: %s <: %s\n\tguard is %s\n"
                   uu____23573 uu____23574 uu____23575
               else ());
              (match g with
               | FStar_Pervasives_Native.None  ->
                   FStar_Pervasives_Native.None
               | FStar_Pervasives_Native.Some g1 ->
                   FStar_Pervasives_Native.Some (x, g1))))
  
let (get_subtyping_predicate :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.typ ->
        FStar_TypeChecker_Env.guard_t FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun t1  ->
      fun t2  ->
        let uu____23604 = check_subtyping env t1 t2  in
        match uu____23604 with
        | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
        | FStar_Pervasives_Native.Some (x,g) ->
            let uu____23623 =
              let uu____23624 = FStar_Syntax_Syntax.mk_binder x  in
              abstract_guard uu____23624 g  in
            FStar_Pervasives_Native.Some uu____23623
  
let (get_subtyping_prop :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.typ ->
        FStar_TypeChecker_Env.guard_t FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun t1  ->
      fun t2  ->
        let uu____23636 = check_subtyping env t1 t2  in
        match uu____23636 with
        | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
        | FStar_Pervasives_Native.Some (x,g) ->
            let uu____23655 =
              let uu____23656 =
                let uu____23657 = FStar_Syntax_Syntax.mk_binder x  in
                [uu____23657]  in
              close_guard env uu____23656 g  in
            FStar_Pervasives_Native.Some uu____23655
  
let (subtype_nosmt :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ -> Prims.bool)
  =
  fun env  ->
    fun t1  ->
      fun t2  ->
        (let uu____23668 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "Rel")
            in
         if uu____23668
         then
           let uu____23669 =
             FStar_TypeChecker_Normalize.term_to_string env t1  in
           let uu____23670 =
             FStar_TypeChecker_Normalize.term_to_string env t2  in
           FStar_Util.print2 "try_subtype_no_smt of %s and %s\n" uu____23669
             uu____23670
         else ());
        (let uu____23672 = new_t_prob env t1 FStar_TypeChecker_Common.SUB t2
            in
         match uu____23672 with
         | (prob,x) ->
             let g =
               let uu____23682 =
                 let uu____23685 = singleton' env prob false  in
                 solve_and_commit env uu____23685
                   (fun uu____23687  -> FStar_Pervasives_Native.None)
                  in
               FStar_All.pipe_left (with_guard env prob) uu____23682  in
             (match g with
              | FStar_Pervasives_Native.None  -> false
              | FStar_Pervasives_Native.Some g1 ->
                  let g2 =
                    let uu____23698 =
                      let uu____23699 = FStar_Syntax_Syntax.mk_binder x  in
                      [uu____23699]  in
                    close_guard env uu____23698 g1  in
                  discharge_guard_nosmt env g2))
  