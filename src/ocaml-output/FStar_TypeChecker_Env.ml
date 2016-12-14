
open Prims

type binding =
| Binding_var of FStar_Syntax_Syntax.bv
| Binding_lid of (FStar_Ident.lident * FStar_Syntax_Syntax.tscheme)
| Binding_sig of (FStar_Ident.lident Prims.list * FStar_Syntax_Syntax.sigelt)
| Binding_univ of FStar_Syntax_Syntax.univ_name
| Binding_sig_inst of (FStar_Ident.lident Prims.list * FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.universes)


let is_Binding_var = (fun _discr_ -> (match (_discr_) with
| Binding_var (_) -> begin
true
end
| _ -> begin
false
end))


let is_Binding_lid = (fun _discr_ -> (match (_discr_) with
| Binding_lid (_) -> begin
true
end
| _ -> begin
false
end))


let is_Binding_sig = (fun _discr_ -> (match (_discr_) with
| Binding_sig (_) -> begin
true
end
| _ -> begin
false
end))


let is_Binding_univ = (fun _discr_ -> (match (_discr_) with
| Binding_univ (_) -> begin
true
end
| _ -> begin
false
end))


let is_Binding_sig_inst = (fun _discr_ -> (match (_discr_) with
| Binding_sig_inst (_) -> begin
true
end
| _ -> begin
false
end))


let ___Binding_var____0 = (fun projectee -> (match (projectee) with
| Binding_var (_53_15) -> begin
_53_15
end))


let ___Binding_lid____0 = (fun projectee -> (match (projectee) with
| Binding_lid (_53_18) -> begin
_53_18
end))


let ___Binding_sig____0 = (fun projectee -> (match (projectee) with
| Binding_sig (_53_21) -> begin
_53_21
end))


let ___Binding_univ____0 = (fun projectee -> (match (projectee) with
| Binding_univ (_53_24) -> begin
_53_24
end))


let ___Binding_sig_inst____0 = (fun projectee -> (match (projectee) with
| Binding_sig_inst (_53_27) -> begin
_53_27
end))


type delta_level =
| NoDelta
| Inlining
| Eager_unfolding_only
| Unfold of FStar_Syntax_Syntax.delta_depth


let is_NoDelta = (fun _discr_ -> (match (_discr_) with
| NoDelta (_) -> begin
true
end
| _ -> begin
false
end))


let is_Inlining = (fun _discr_ -> (match (_discr_) with
| Inlining (_) -> begin
true
end
| _ -> begin
false
end))


let is_Eager_unfolding_only = (fun _discr_ -> (match (_discr_) with
| Eager_unfolding_only (_) -> begin
true
end
| _ -> begin
false
end))


let is_Unfold = (fun _discr_ -> (match (_discr_) with
| Unfold (_) -> begin
true
end
| _ -> begin
false
end))


let ___Unfold____0 = (fun projectee -> (match (projectee) with
| Unfold (_53_30) -> begin
_53_30
end))


type mlift =
FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.typ


type edge =
{msource : FStar_Ident.lident; mtarget : FStar_Ident.lident; mlift : FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.typ}


let is_Mkedge : edge  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkedge"))))


type effects =
{decls : FStar_Syntax_Syntax.eff_decl Prims.list; order : edge Prims.list; joins : (FStar_Ident.lident * FStar_Ident.lident * FStar_Ident.lident * mlift * mlift) Prims.list}


let is_Mkeffects : effects  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkeffects"))))


type cached_elt =
((FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ), (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.universes Prims.option)) FStar_Util.either


type env =
{solver : solver_t; range : FStar_Range.range; curmodule : FStar_Ident.lident; gamma : binding Prims.list; gamma_cache : cached_elt FStar_Util.smap; modules : FStar_Syntax_Syntax.modul Prims.list; expected_typ : FStar_Syntax_Syntax.typ Prims.option; sigtab : FStar_Syntax_Syntax.sigelt FStar_Util.smap; is_pattern : Prims.bool; instantiate_imp : Prims.bool; effects : effects; generalize : Prims.bool; letrecs : (FStar_Syntax_Syntax.lbname * FStar_Syntax_Syntax.typ) Prims.list; top_level : Prims.bool; check_uvars : Prims.bool; use_eq : Prims.bool; is_iface : Prims.bool; admit : Prims.bool; lax : Prims.bool; lax_universes : Prims.bool; type_of : env  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.typ * guard_t); universe_of : env  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.universe; use_bv_sorts : Prims.bool; qname_and_index : (FStar_Ident.lident * Prims.int) Prims.option} 
 and solver_t =
{init : env  ->  Prims.unit; push : Prims.string  ->  Prims.unit; pop : Prims.string  ->  Prims.unit; mark : Prims.string  ->  Prims.unit; reset_mark : Prims.string  ->  Prims.unit; commit_mark : Prims.string  ->  Prims.unit; encode_modul : env  ->  FStar_Syntax_Syntax.modul  ->  Prims.unit; encode_sig : env  ->  FStar_Syntax_Syntax.sigelt  ->  Prims.unit; solve : (Prims.unit  ->  Prims.string) Prims.option  ->  env  ->  FStar_Syntax_Syntax.typ  ->  Prims.unit; is_trivial : env  ->  FStar_Syntax_Syntax.typ  ->  Prims.bool; finish : Prims.unit  ->  Prims.unit; refresh : Prims.unit  ->  Prims.unit} 
 and guard_t =
{guard_f : FStar_TypeChecker_Common.guard_formula; deferred : FStar_TypeChecker_Common.deferred; univ_ineqs : FStar_TypeChecker_Common.univ_ineq Prims.list; implicits : (Prims.string * env * FStar_Syntax_Syntax.uvar * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.typ * FStar_Range.range) Prims.list}


let is_Mkenv : env  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkenv"))))


let is_Mksolver_t : solver_t  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mksolver_t"))))


let is_Mkguard_t : guard_t  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkguard_t"))))


type env_t =
env


type implicits =
(env * FStar_Syntax_Syntax.uvar * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.typ * FStar_Range.range) Prims.list


type sigtable =
FStar_Syntax_Syntax.sigelt FStar_Util.smap


let should_verify : env  ->  Prims.bool = (fun env -> (((not (env.lax)) && (not (env.admit))) && (FStar_Options.should_verify env.curmodule.FStar_Ident.str)))


let visible_at : delta_level  ->  FStar_Syntax_Syntax.qualifier  ->  Prims.bool = (fun d q -> (match (((d), (q))) with
| ((NoDelta, _)) | ((Eager_unfolding_only, FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen)) | ((Unfold (_), FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen)) | ((Unfold (_), FStar_Syntax_Syntax.Visible_default)) -> begin
true
end
| (Inlining, FStar_Syntax_Syntax.Inline_for_extraction) -> begin
true
end
| _53_107 -> begin
false
end))


let default_table_size : Prims.int = (Prims.parse_int "200")


let new_sigtab = (fun _53_108 -> (match (()) with
| () -> begin
(FStar_Util.smap_create default_table_size)
end))


let new_gamma_cache = (fun _53_109 -> (match (()) with
| () -> begin
(FStar_Util.smap_create (Prims.parse_int "100"))
end))


let initial_env : (env  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.typ * guard_t))  ->  (env  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.universe)  ->  solver_t  ->  FStar_Ident.lident  ->  env = (fun type_of universe_of solver module_lid -> (let _150_422 = (new_gamma_cache ())
in (let _150_421 = (new_sigtab ())
in {solver = solver; range = FStar_Range.dummyRange; curmodule = module_lid; gamma = []; gamma_cache = _150_422; modules = []; expected_typ = None; sigtab = _150_421; is_pattern = false; instantiate_imp = true; effects = {decls = []; order = []; joins = []}; generalize = true; letrecs = []; top_level = false; check_uvars = false; use_eq = false; is_iface = false; admit = false; lax = false; lax_universes = false; type_of = type_of; universe_of = universe_of; use_bv_sorts = false; qname_and_index = None})))


let sigtab : env  ->  FStar_Syntax_Syntax.sigelt FStar_Util.smap = (fun env -> env.sigtab)


let gamma_cache : env  ->  cached_elt FStar_Util.smap = (fun env -> env.gamma_cache)


type env_stack_ops =
{es_push : env  ->  env; es_mark : env  ->  env; es_reset_mark : env  ->  env; es_commit_mark : env  ->  env; es_pop : env  ->  env; es_incr_query_index : env  ->  env}


let is_Mkenv_stack_ops : env_stack_ops  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkenv_stack_ops"))))


let stack_ops : env_stack_ops = (

let query_indices = (FStar_Util.mk_ref (([])::[]))
in (

let push_query_indices = (fun _53_125 -> (match (()) with
| () -> begin
(match ((FStar_ST.read query_indices)) with
| [] -> begin
(FStar_All.failwith "Empty query indices!")
end
| _53_128 -> begin
(let _150_487 = (let _150_486 = (let _150_484 = (FStar_ST.read query_indices)
in (FStar_List.hd _150_484))
in (let _150_485 = (FStar_ST.read query_indices)
in (_150_486)::_150_485))
in (FStar_ST.op_Colon_Equals query_indices _150_487))
end)
end))
in (

let pop_query_indices = (fun _53_130 -> (match (()) with
| () -> begin
(match ((FStar_ST.read query_indices)) with
| [] -> begin
(FStar_All.failwith "Empty query indices!")
end
| (hd)::tl -> begin
(FStar_ST.op_Colon_Equals query_indices tl)
end)
end))
in (

let add_query_index = (fun _53_138 -> (match (_53_138) with
| (l, n) -> begin
(match ((FStar_ST.read query_indices)) with
| (hd)::tl -> begin
(FStar_ST.op_Colon_Equals query_indices (((((l), (n)))::hd)::tl))
end
| _53_143 -> begin
(FStar_All.failwith "Empty query indices")
end)
end))
in (

let peek_query_indices = (fun _53_145 -> (match (()) with
| () -> begin
(let _150_494 = (FStar_ST.read query_indices)
in (FStar_List.hd _150_494))
end))
in (

let commit_query_index_mark = (fun _53_147 -> (match (()) with
| () -> begin
(match ((FStar_ST.read query_indices)) with
| (hd)::(_53_150)::tl -> begin
(FStar_ST.op_Colon_Equals query_indices ((hd)::tl))
end
| _53_155 -> begin
(FStar_All.failwith "Unmarked query index stack")
end)
end))
in (

let stack = (FStar_Util.mk_ref [])
in (

let push_stack = (fun env -> (

let _53_159 = (let _150_500 = (let _150_499 = (FStar_ST.read stack)
in (env)::_150_499)
in (FStar_ST.op_Colon_Equals stack _150_500))
in (

let _53_161 = env
in (let _150_502 = (FStar_Util.smap_copy (gamma_cache env))
in (let _150_501 = (FStar_Util.smap_copy (sigtab env))
in {solver = _53_161.solver; range = _53_161.range; curmodule = _53_161.curmodule; gamma = _53_161.gamma; gamma_cache = _150_502; modules = _53_161.modules; expected_typ = _53_161.expected_typ; sigtab = _150_501; is_pattern = _53_161.is_pattern; instantiate_imp = _53_161.instantiate_imp; effects = _53_161.effects; generalize = _53_161.generalize; letrecs = _53_161.letrecs; top_level = _53_161.top_level; check_uvars = _53_161.check_uvars; use_eq = _53_161.use_eq; is_iface = _53_161.is_iface; admit = _53_161.admit; lax = _53_161.lax; lax_universes = _53_161.lax_universes; type_of = _53_161.type_of; universe_of = _53_161.universe_of; use_bv_sorts = _53_161.use_bv_sorts; qname_and_index = _53_161.qname_and_index})))))
in (

let pop_stack = (fun env -> (match ((FStar_ST.read stack)) with
| (env)::tl -> begin
(

let _53_168 = (FStar_ST.op_Colon_Equals stack tl)
in env)
end
| _53_171 -> begin
(FStar_All.failwith "Impossible: Too many pops")
end))
in (

let push = (fun env -> (

let _53_174 = (push_query_indices ())
in (push_stack env)))
in (

let pop = (fun env -> (

let _53_178 = (pop_query_indices ())
in (pop_stack env)))
in (

let mark = (fun env -> (

let _53_182 = (push_query_indices ())
in (push_stack env)))
in (

let commit_mark = (fun env -> (

let _53_186 = (commit_query_index_mark ())
in (

let _53_188 = (let _150_513 = (pop_stack env)
in (Prims.ignore _150_513))
in env)))
in (

let reset_mark = (fun env -> (

let _53_192 = (pop_query_indices ())
in (pop_stack env)))
in (

let incr_query_index = (fun env -> (

let qix = (peek_query_indices ())
in (match (env.qname_and_index) with
| None -> begin
env
end
| Some (l, n) -> begin
(match ((FStar_All.pipe_right qix (FStar_List.tryFind (fun _53_205 -> (match (_53_205) with
| (m, _53_204) -> begin
(FStar_Ident.lid_equals l m)
end))))) with
| None -> begin
(

let next = (n + (Prims.parse_int "1"))
in (

let _53_208 = (add_query_index ((l), (next)))
in (

let _53_210 = env
in {solver = _53_210.solver; range = _53_210.range; curmodule = _53_210.curmodule; gamma = _53_210.gamma; gamma_cache = _53_210.gamma_cache; modules = _53_210.modules; expected_typ = _53_210.expected_typ; sigtab = _53_210.sigtab; is_pattern = _53_210.is_pattern; instantiate_imp = _53_210.instantiate_imp; effects = _53_210.effects; generalize = _53_210.generalize; letrecs = _53_210.letrecs; top_level = _53_210.top_level; check_uvars = _53_210.check_uvars; use_eq = _53_210.use_eq; is_iface = _53_210.is_iface; admit = _53_210.admit; lax = _53_210.lax; lax_universes = _53_210.lax_universes; type_of = _53_210.type_of; universe_of = _53_210.universe_of; use_bv_sorts = _53_210.use_bv_sorts; qname_and_index = Some (((l), (next)))})))
end
| Some (_53_213, m) -> begin
(

let next = (m + (Prims.parse_int "1"))
in (

let _53_218 = (add_query_index ((l), (next)))
in (

let _53_220 = env
in {solver = _53_220.solver; range = _53_220.range; curmodule = _53_220.curmodule; gamma = _53_220.gamma; gamma_cache = _53_220.gamma_cache; modules = _53_220.modules; expected_typ = _53_220.expected_typ; sigtab = _53_220.sigtab; is_pattern = _53_220.is_pattern; instantiate_imp = _53_220.instantiate_imp; effects = _53_220.effects; generalize = _53_220.generalize; letrecs = _53_220.letrecs; top_level = _53_220.top_level; check_uvars = _53_220.check_uvars; use_eq = _53_220.use_eq; is_iface = _53_220.is_iface; admit = _53_220.admit; lax = _53_220.lax; lax_universes = _53_220.lax_universes; type_of = _53_220.type_of; universe_of = _53_220.universe_of; use_bv_sorts = _53_220.use_bv_sorts; qname_and_index = Some (((l), (next)))})))
end)
end)))
in {es_push = push; es_mark = push; es_reset_mark = pop; es_commit_mark = commit_mark; es_pop = pop; es_incr_query_index = incr_query_index})))))))))))))))


let push : env  ->  Prims.string  ->  env = (fun env msg -> (

let _53_224 = (env.solver.push msg)
in (stack_ops.es_push env)))


let mark : env  ->  env = (fun env -> (

let _53_227 = (env.solver.mark "USER MARK")
in (stack_ops.es_mark env)))


let commit_mark : env  ->  env = (fun env -> (

let _53_230 = (env.solver.commit_mark "USER MARK")
in (stack_ops.es_commit_mark env)))


let reset_mark : env  ->  env = (fun env -> (

let _53_233 = (env.solver.reset_mark "USER MARK")
in (stack_ops.es_reset_mark env)))


let pop : env  ->  Prims.string  ->  env = (fun env msg -> (

let _53_237 = (env.solver.pop msg)
in (stack_ops.es_pop env)))


let cleanup_interactive : env  ->  Prims.unit = (fun env -> (env.solver.pop ""))


let incr_query_index : env  ->  env = (fun env -> (stack_ops.es_incr_query_index env))


let debug : env  ->  FStar_Options.debug_level_t  ->  Prims.bool = (fun env l -> (FStar_Options.debug_at_level env.curmodule.FStar_Ident.str l))


let set_range : env  ->  FStar_Range.range  ->  env = (fun e r -> if (r = FStar_Range.dummyRange) then begin
e
end else begin
(

let _53_245 = e
in {solver = _53_245.solver; range = r; curmodule = _53_245.curmodule; gamma = _53_245.gamma; gamma_cache = _53_245.gamma_cache; modules = _53_245.modules; expected_typ = _53_245.expected_typ; sigtab = _53_245.sigtab; is_pattern = _53_245.is_pattern; instantiate_imp = _53_245.instantiate_imp; effects = _53_245.effects; generalize = _53_245.generalize; letrecs = _53_245.letrecs; top_level = _53_245.top_level; check_uvars = _53_245.check_uvars; use_eq = _53_245.use_eq; is_iface = _53_245.is_iface; admit = _53_245.admit; lax = _53_245.lax; lax_universes = _53_245.lax_universes; type_of = _53_245.type_of; universe_of = _53_245.universe_of; use_bv_sorts = _53_245.use_bv_sorts; qname_and_index = _53_245.qname_and_index})
end)


let get_range : env  ->  FStar_Range.range = (fun e -> e.range)


let modules : env  ->  FStar_Syntax_Syntax.modul Prims.list = (fun env -> env.modules)


let current_module : env  ->  FStar_Ident.lident = (fun env -> env.curmodule)


let set_current_module : env  ->  FStar_Ident.lident  ->  env = (fun env lid -> (

let _53_252 = env
in {solver = _53_252.solver; range = _53_252.range; curmodule = lid; gamma = _53_252.gamma; gamma_cache = _53_252.gamma_cache; modules = _53_252.modules; expected_typ = _53_252.expected_typ; sigtab = _53_252.sigtab; is_pattern = _53_252.is_pattern; instantiate_imp = _53_252.instantiate_imp; effects = _53_252.effects; generalize = _53_252.generalize; letrecs = _53_252.letrecs; top_level = _53_252.top_level; check_uvars = _53_252.check_uvars; use_eq = _53_252.use_eq; is_iface = _53_252.is_iface; admit = _53_252.admit; lax = _53_252.lax; lax_universes = _53_252.lax_universes; type_of = _53_252.type_of; universe_of = _53_252.universe_of; use_bv_sorts = _53_252.use_bv_sorts; qname_and_index = _53_252.qname_and_index}))


let has_interface : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env l -> (FStar_All.pipe_right env.modules (FStar_Util.for_some (fun m -> (m.FStar_Syntax_Syntax.is_interface && (FStar_Ident.lid_equals m.FStar_Syntax_Syntax.name l))))))


let find_in_sigtab : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.sigelt Prims.option = (fun env lid -> (FStar_Util.smap_try_find (sigtab env) (FStar_Ident.text_of_lid lid)))


let name_not_found : FStar_Ident.lid  ->  Prims.string = (fun l -> (FStar_Util.format1 "Name \"%s\" not found" l.FStar_Ident.str))


let variable_not_found : FStar_Syntax_Syntax.bv  ->  Prims.string = (fun v -> (let _150_568 = (FStar_Syntax_Print.bv_to_string v)
in (FStar_Util.format1 "Variable \"%s\" not found" _150_568)))


let new_u_univ : Prims.unit  ->  FStar_Syntax_Syntax.universe = (fun _53_261 -> (match (()) with
| () -> begin
(let _150_571 = (FStar_Unionfind.fresh None)
in FStar_Syntax_Syntax.U_unif (_150_571))
end))


let inst_tscheme_with : FStar_Syntax_Syntax.tscheme  ->  FStar_Syntax_Syntax.universes  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.term) = (fun ts us -> (match (((ts), (us))) with
| (([], t), []) -> begin
(([]), (t))
end
| ((formals, t), _53_273) -> begin
(

let _53_275 = ()
in (

let n = ((FStar_List.length formals) - (Prims.parse_int "1"))
in (

let vs = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> FStar_Syntax_Syntax.UN ((((n - i)), (u))))))
in (let _150_578 = (FStar_Syntax_Subst.subst vs t)
in ((us), (_150_578))))))
end))


let inst_tscheme : FStar_Syntax_Syntax.tscheme  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.term) = (fun _53_1 -> (match (_53_1) with
| ([], t) -> begin
(([]), (t))
end
| (us, t) -> begin
(

let us' = (FStar_All.pipe_right us (FStar_List.map (fun _53_288 -> (new_u_univ ()))))
in (inst_tscheme_with ((us), (t)) us'))
end))


let inst_tscheme_with_range : FStar_Range.range  ->  FStar_Syntax_Syntax.tscheme  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.term) = (fun r t -> (

let _53_295 = (inst_tscheme t)
in (match (_53_295) with
| (us, t) -> begin
(let _150_586 = (FStar_Syntax_Subst.set_use_range r t)
in ((us), (_150_586)))
end)))


let inst_effect_fun_with : FStar_Syntax_Syntax.universes  ->  env  ->  FStar_Syntax_Syntax.eff_decl  ->  FStar_Syntax_Syntax.tscheme  ->  FStar_Syntax_Syntax.term = (fun insts env ed _53_301 -> (match (_53_301) with
| (us, t) -> begin
(match (ed.FStar_Syntax_Syntax.binders) with
| [] -> begin
(

let univs = (FStar_List.append ed.FStar_Syntax_Syntax.univs us)
in (

let _53_304 = if ((FStar_List.length insts) <> (FStar_List.length univs)) then begin
(let _150_599 = (let _150_598 = (FStar_All.pipe_left FStar_Util.string_of_int (FStar_List.length univs))
in (let _150_597 = (FStar_All.pipe_left FStar_Util.string_of_int (FStar_List.length insts))
in (let _150_596 = (FStar_Syntax_Print.lid_to_string ed.FStar_Syntax_Syntax.mname)
in (let _150_595 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.format4 "Expected %s instantiations; got %s; failed universe instantiation in effect %s\n\t%s\n" _150_598 _150_597 _150_596 _150_595)))))
in (FStar_All.failwith _150_599))
end else begin
()
end
in (let _150_600 = (inst_tscheme_with (((FStar_List.append ed.FStar_Syntax_Syntax.univs us)), (t)) insts)
in (Prims.snd _150_600))))
end
| _53_307 -> begin
(let _150_602 = (let _150_601 = (FStar_Syntax_Print.lid_to_string ed.FStar_Syntax_Syntax.mname)
in (FStar_Util.format1 "Unexpected use of an uninstantiated effect: %s\n" _150_601))
in (FStar_All.failwith _150_602))
end)
end))


type tri =
| Yes
| No
| Maybe


let is_Yes = (fun _discr_ -> (match (_discr_) with
| Yes (_) -> begin
true
end
| _ -> begin
false
end))


let is_No = (fun _discr_ -> (match (_discr_) with
| No (_) -> begin
true
end
| _ -> begin
false
end))


let is_Maybe = (fun _discr_ -> (match (_discr_) with
| Maybe (_) -> begin
true
end
| _ -> begin
false
end))


let in_cur_mod : env  ->  FStar_Ident.lident  ->  tri = (fun env l -> (

let cur = (current_module env)
in if (l.FStar_Ident.nsstr = cur.FStar_Ident.str) then begin
Yes
end else begin
if (FStar_Util.starts_with l.FStar_Ident.nsstr cur.FStar_Ident.str) then begin
(

let lns = (FStar_List.append l.FStar_Ident.ns ((l.FStar_Ident.ident)::[]))
in (

let cur = (FStar_List.append cur.FStar_Ident.ns ((cur.FStar_Ident.ident)::[]))
in (

let rec aux = (fun c l -> (match (((c), (l))) with
| ([], _53_318) -> begin
Maybe
end
| (_53_321, []) -> begin
No
end
| ((hd)::tl, (hd')::tl') when (hd.FStar_Ident.idText = hd'.FStar_Ident.idText) -> begin
(aux tl tl')
end
| _53_332 -> begin
No
end))
in (aux cur lns))))
end else begin
No
end
end))


let lookup_qname : env  ->  FStar_Ident.lident  ->  ((FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ), (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.universes Prims.option)) FStar_Util.either Prims.option = (fun env lid -> (

let cur_mod = (in_cur_mod env lid)
in (

let cache = (fun t -> (

let _53_338 = (FStar_Util.smap_add (gamma_cache env) lid.FStar_Ident.str t)
in Some (t)))
in (

let found = if (cur_mod <> No) then begin
(match ((FStar_Util.smap_try_find (gamma_cache env) lid.FStar_Ident.str)) with
| None -> begin
(FStar_Util.find_map env.gamma (fun _53_2 -> (match (_53_2) with
| Binding_lid (l, t) -> begin
if (FStar_Ident.lid_equals lid l) then begin
(let _150_622 = (let _150_621 = (inst_tscheme t)
in FStar_Util.Inl (_150_621))
in Some (_150_622))
end else begin
None
end
end
| Binding_sig (_53_347, FStar_Syntax_Syntax.Sig_bundle (ses, _53_350, _53_352, _53_354)) -> begin
(FStar_Util.find_map ses (fun se -> if (let _150_624 = (FStar_Syntax_Util.lids_of_sigelt se)
in (FStar_All.pipe_right _150_624 (FStar_Util.for_some (FStar_Ident.lid_equals lid)))) then begin
(cache (FStar_Util.Inr (((se), (None)))))
end else begin
None
end))
end
| Binding_sig (lids, s) -> begin
(

let maybe_cache = (fun t -> (match (s) with
| FStar_Syntax_Syntax.Sig_declare_typ (_53_367) -> begin
Some (t)
end
| _53_370 -> begin
(cache t)
end))
in if (FStar_All.pipe_right lids (FStar_Util.for_some (FStar_Ident.lid_equals lid))) then begin
(maybe_cache (FStar_Util.Inr (((s), (None)))))
end else begin
None
end)
end
| Binding_sig_inst (lids, s, us) -> begin
if (FStar_All.pipe_right lids (FStar_Util.for_some (FStar_Ident.lid_equals lid))) then begin
Some (FStar_Util.Inr (((s), (Some (us)))))
end else begin
None
end
end
| _53_377 -> begin
None
end)))
end
| se -> begin
se
end)
end else begin
None
end
in if (FStar_Util.is_some found) then begin
found
end else begin
if ((cur_mod <> Yes) || (has_interface env env.curmodule)) then begin
(match ((find_in_sigtab env lid)) with
| Some (se) -> begin
Some (FStar_Util.Inr (((se), (None))))
end
| None -> begin
None
end)
end else begin
None
end
end))))


let rec add_sigelt : env  ->  FStar_Syntax_Syntax.sigelt  ->  Prims.unit = (fun env se -> (match (se) with
| FStar_Syntax_Syntax.Sig_bundle (ses, _53_387, _53_389, _53_391) -> begin
(add_sigelts env ses)
end
| _53_395 -> begin
(

let lids = (FStar_Syntax_Util.lids_of_sigelt se)
in (

let _53_398 = (FStar_List.iter (fun l -> (FStar_Util.smap_add (sigtab env) l.FStar_Ident.str se)) lids)
in (match (se) with
| FStar_Syntax_Syntax.Sig_new_effect (ne, _53_402) -> begin
(FStar_All.pipe_right ne.FStar_Syntax_Syntax.actions (FStar_List.iter (fun a -> (

let se_let = (FStar_Syntax_Util.action_as_lb a)
in (FStar_Util.smap_add (sigtab env) a.FStar_Syntax_Syntax.action_name.FStar_Ident.str se_let)))))
end
| _53_408 -> begin
()
end)))
end))
and add_sigelts : env  ->  FStar_Syntax_Syntax.sigelt Prims.list  ->  Prims.unit = (fun env ses -> (FStar_All.pipe_right ses (FStar_List.iter (add_sigelt env))))


let try_lookup_bv : env  ->  FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.term Prims.option = (fun env bv -> (FStar_Util.find_map env.gamma (fun _53_3 -> (match (_53_3) with
| Binding_var (id) when (FStar_Syntax_Syntax.bv_eq id bv) -> begin
Some (id.FStar_Syntax_Syntax.sort)
end
| _53_417 -> begin
None
end))))


let lookup_type_of_let : FStar_Syntax_Syntax.sigelt  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.term) Prims.option = (fun se lid -> (match (se) with
| FStar_Syntax_Syntax.Sig_let ((_53_421, (lb)::[]), _53_426, _53_428, _53_430) -> begin
(let _150_646 = (inst_tscheme ((lb.FStar_Syntax_Syntax.lbunivs), (lb.FStar_Syntax_Syntax.lbtyp)))
in Some (_150_646))
end
| FStar_Syntax_Syntax.Sig_let ((_53_434, lbs), _53_438, _53_440, _53_442) -> begin
(FStar_Util.find_map lbs (fun lb -> (match (lb.FStar_Syntax_Syntax.lbname) with
| FStar_Util.Inl (_53_447) -> begin
(FStar_All.failwith "impossible")
end
| FStar_Util.Inr (fv) -> begin
if (FStar_Syntax_Syntax.fv_eq_lid fv lid) then begin
(let _150_648 = (inst_tscheme ((lb.FStar_Syntax_Syntax.lbunivs), (lb.FStar_Syntax_Syntax.lbtyp)))
in Some (_150_648))
end else begin
None
end
end)))
end
| _53_452 -> begin
None
end))


let effect_signature : FStar_Syntax_Syntax.sigelt  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.term) Prims.option = (fun se -> (match (se) with
| FStar_Syntax_Syntax.Sig_new_effect (ne, _53_456) -> begin
(let _150_654 = (let _150_653 = (let _150_652 = (let _150_651 = (FStar_Syntax_Syntax.mk_Total ne.FStar_Syntax_Syntax.signature)
in (FStar_Syntax_Util.arrow ne.FStar_Syntax_Syntax.binders _150_651))
in ((ne.FStar_Syntax_Syntax.univs), (_150_652)))
in (inst_tscheme _150_653))
in Some (_150_654))
end
| FStar_Syntax_Syntax.Sig_effect_abbrev (lid, us, binders, _53_463, _53_465, _53_467, _53_469) -> begin
(let _150_658 = (let _150_657 = (let _150_656 = (let _150_655 = (FStar_Syntax_Syntax.mk_Total FStar_Syntax_Syntax.teff)
in (FStar_Syntax_Util.arrow binders _150_655))
in ((us), (_150_656)))
in (inst_tscheme _150_657))
in Some (_150_658))
end
| _53_473 -> begin
None
end))


let try_lookup_lid_aux : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax) Prims.option = (fun env lid -> (

let mapper = (fun _53_4 -> (match (_53_4) with
| FStar_Util.Inl (t) -> begin
Some (t)
end
| FStar_Util.Inr (FStar_Syntax_Syntax.Sig_datacon (_53_480, uvs, t, _53_484, _53_486, _53_488, _53_490, _53_492), None) -> begin
(let _150_665 = (inst_tscheme ((uvs), (t)))
in Some (_150_665))
end
| FStar_Util.Inr (FStar_Syntax_Syntax.Sig_declare_typ (l, uvs, t, qs, _53_503), None) -> begin
if ((in_cur_mod env l) = Yes) then begin
if ((FStar_All.pipe_right qs (FStar_List.contains FStar_Syntax_Syntax.Assumption)) || env.is_iface) then begin
(let _150_666 = (inst_tscheme ((uvs), (t)))
in Some (_150_666))
end else begin
None
end
end else begin
(let _150_667 = (inst_tscheme ((uvs), (t)))
in Some (_150_667))
end
end
| FStar_Util.Inr (FStar_Syntax_Syntax.Sig_inductive_typ (lid, uvs, tps, k, _53_514, _53_516, _53_518, _53_520), None) -> begin
(match (tps) with
| [] -> begin
(let _150_669 = (inst_tscheme ((uvs), (k)))
in (FStar_All.pipe_left (fun _150_668 -> Some (_150_668)) _150_669))
end
| _53_528 -> begin
(let _150_674 = (let _150_673 = (let _150_672 = (let _150_671 = (FStar_Syntax_Syntax.mk_Total k)
in (FStar_Syntax_Util.flat_arrow tps _150_671))
in ((uvs), (_150_672)))
in (inst_tscheme _150_673))
in (FStar_All.pipe_left (fun _150_670 -> Some (_150_670)) _150_674))
end)
end
| FStar_Util.Inr (FStar_Syntax_Syntax.Sig_inductive_typ (lid, uvs, tps, k, _53_534, _53_536, _53_538, _53_540), Some (us)) -> begin
(match (tps) with
| [] -> begin
(let _150_676 = (inst_tscheme_with ((uvs), (k)) us)
in (FStar_All.pipe_left (fun _150_675 -> Some (_150_675)) _150_676))
end
| _53_549 -> begin
(let _150_681 = (let _150_680 = (let _150_679 = (let _150_678 = (FStar_Syntax_Syntax.mk_Total k)
in (FStar_Syntax_Util.flat_arrow tps _150_678))
in ((uvs), (_150_679)))
in (inst_tscheme_with _150_680 us))
in (FStar_All.pipe_left (fun _150_677 -> Some (_150_677)) _150_681))
end)
end
| FStar_Util.Inr (se) -> begin
(match (se) with
| (FStar_Syntax_Syntax.Sig_let (_53_553), None) -> begin
(lookup_type_of_let (Prims.fst se) lid)
end
| _53_558 -> begin
(effect_signature (Prims.fst se))
end)
end))
in (match ((let _150_682 = (lookup_qname env lid)
in (FStar_Util.bind_opt _150_682 mapper))) with
| Some (us, t) -> begin
Some (((us), ((

let _53_564 = t
in {FStar_Syntax_Syntax.n = _53_564.FStar_Syntax_Syntax.n; FStar_Syntax_Syntax.tk = _53_564.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = (FStar_Ident.range_of_lid lid); FStar_Syntax_Syntax.vars = _53_564.FStar_Syntax_Syntax.vars}))))
end
| None -> begin
None
end)))


let lid_exists : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env l -> (match ((lookup_qname env l)) with
| None -> begin
false
end
| Some (_53_571) -> begin
true
end))


let lookup_bv : env  ->  FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.typ = (fun env bv -> (match ((try_lookup_bv env bv)) with
| None -> begin
(let _150_694 = (let _150_693 = (let _150_692 = (variable_not_found bv)
in (let _150_691 = (FStar_Syntax_Syntax.range_of_bv bv)
in ((_150_692), (_150_691))))
in FStar_Syntax_Syntax.Error (_150_693))
in (Prims.raise _150_694))
end
| Some (t) -> begin
(let _150_695 = (FStar_Syntax_Syntax.range_of_bv bv)
in (FStar_Syntax_Subst.set_use_range _150_695 t))
end))


let try_lookup_lid : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ) Prims.option = (fun env l -> (match ((try_lookup_lid_aux env l)) with
| None -> begin
None
end
| Some (us, t) -> begin
(let _150_701 = (let _150_700 = (FStar_Syntax_Subst.set_use_range (FStar_Ident.range_of_lid l) t)
in ((us), (_150_700)))
in Some (_150_701))
end))


let lookup_lid : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ) = (fun env l -> (match ((try_lookup_lid env l)) with
| None -> begin
(let _150_708 = (let _150_707 = (let _150_706 = (name_not_found l)
in ((_150_706), ((FStar_Ident.range_of_lid l))))
in FStar_Syntax_Syntax.Error (_150_707))
in (Prims.raise _150_708))
end
| Some (us, t) -> begin
((us), (t))
end))


let lookup_univ : env  ->  FStar_Syntax_Syntax.univ_name  ->  Prims.bool = (fun env x -> (FStar_All.pipe_right (FStar_List.find (fun _53_5 -> (match (_53_5) with
| Binding_univ (y) -> begin
(x.FStar_Ident.idText = y.FStar_Ident.idText)
end
| _53_598 -> begin
false
end)) env.gamma) FStar_Option.isSome))


let try_lookup_val_decl : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.tscheme * FStar_Syntax_Syntax.qualifier Prims.list) Prims.option = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_declare_typ (_53_602, uvs, t, q, _53_607), None)) -> begin
(let _150_723 = (let _150_722 = (let _150_721 = (FStar_Syntax_Subst.set_use_range (FStar_Ident.range_of_lid lid) t)
in ((uvs), (_150_721)))
in ((_150_722), (q)))
in Some (_150_723))
end
| _53_615 -> begin
None
end))


let lookup_val_decl : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ) = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_declare_typ (_53_619, uvs, t, _53_623, _53_625), None)) -> begin
(inst_tscheme_with_range (FStar_Ident.range_of_lid lid) ((uvs), (t)))
end
| _53_633 -> begin
(let _150_730 = (let _150_729 = (let _150_728 = (name_not_found lid)
in ((_150_728), ((FStar_Ident.range_of_lid lid))))
in FStar_Syntax_Syntax.Error (_150_729))
in (Prims.raise _150_730))
end))


let lookup_datacon : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ) = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_datacon (_53_637, uvs, t, _53_641, _53_643, _53_645, _53_647, _53_649), None)) -> begin
(inst_tscheme_with_range (FStar_Ident.range_of_lid lid) ((uvs), (t)))
end
| _53_657 -> begin
(let _150_737 = (let _150_736 = (let _150_735 = (name_not_found lid)
in ((_150_735), ((FStar_Ident.range_of_lid lid))))
in FStar_Syntax_Syntax.Error (_150_736))
in (Prims.raise _150_737))
end))


let datacons_of_typ : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident Prims.list = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_inductive_typ (_53_661, _53_663, _53_665, _53_667, _53_669, dcs, _53_672, _53_674), _53_678)) -> begin
dcs
end
| _53_683 -> begin
[]
end))


let typ_of_datacon : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_datacon (_53_687, _53_689, _53_691, l, _53_694, _53_696, _53_698, _53_700), _53_704)) -> begin
l
end
| _53_709 -> begin
(let _150_747 = (let _150_746 = (FStar_Syntax_Print.lid_to_string lid)
in (FStar_Util.format1 "Not a datacon: %s" _150_746))
in (FStar_All.failwith _150_747))
end))


let lookup_definition : delta_level Prims.list  ->  env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.univ_names * FStar_Syntax_Syntax.term) Prims.option = (fun delta_levels env lid -> (

let visible = (fun quals -> (FStar_All.pipe_right delta_levels (FStar_Util.for_some (fun dl -> (FStar_All.pipe_right quals (FStar_Util.for_some (visible_at dl)))))))
in (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (se, None)) -> begin
(match (se) with
| FStar_Syntax_Syntax.Sig_let ((_53_722, lbs), _53_726, _53_728, quals) when (visible quals) -> begin
(FStar_Util.find_map lbs (fun lb -> (

let fv = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname)
in if (FStar_Syntax_Syntax.fv_eq_lid fv lid) then begin
(let _150_760 = (let _150_759 = (let _150_758 = (FStar_Syntax_Util.unascribe lb.FStar_Syntax_Syntax.lbdef)
in (FStar_Syntax_Subst.set_use_range (FStar_Ident.range_of_lid lid) _150_758))
in ((lb.FStar_Syntax_Syntax.lbunivs), (_150_759)))
in Some (_150_760))
end else begin
None
end)))
end
| _53_735 -> begin
None
end)
end
| _53_737 -> begin
None
end)))


let try_lookup_effect_lid : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.term Prims.option = (fun env ftv -> (match ((lookup_qname env ftv)) with
| Some (FStar_Util.Inr (se, None)) -> begin
(match ((effect_signature se)) with
| None -> begin
None
end
| Some (_53_747, t) -> begin
(let _150_765 = (FStar_Syntax_Subst.set_use_range (FStar_Ident.range_of_lid ftv) t)
in Some (_150_765))
end)
end
| _53_752 -> begin
None
end))


let lookup_effect_lid : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.term = (fun env ftv -> (match ((try_lookup_effect_lid env ftv)) with
| None -> begin
(let _150_772 = (let _150_771 = (let _150_770 = (name_not_found ftv)
in ((_150_770), ((FStar_Ident.range_of_lid ftv))))
in FStar_Syntax_Syntax.Error (_150_771))
in (Prims.raise _150_772))
end
| Some (k) -> begin
k
end))


let lookup_effect_abbrev : env  ->  FStar_Syntax_Syntax.universes  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.comp) Prims.option = (fun env univ_insts lid0 -> (match ((lookup_qname env lid0)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_effect_abbrev (lid, univs, binders, c, quals, _53_767, _53_769), None)) -> begin
(

let lid = (let _150_779 = (FStar_Range.set_use_range (FStar_Ident.range_of_lid lid) (FStar_Ident.range_of_lid lid0))
in (FStar_Ident.set_lid_range lid _150_779))
in if (FStar_All.pipe_right quals (FStar_Util.for_some (fun _53_6 -> (match (_53_6) with
| FStar_Syntax_Syntax.Irreducible -> begin
true
end
| _53_780 -> begin
false
end)))) then begin
None
end else begin
(

let insts = if ((FStar_List.length univ_insts) = (FStar_List.length univs)) then begin
univ_insts
end else begin
if ((FStar_Ident.lid_equals lid FStar_Syntax_Const.effect_Lemma_lid) && ((FStar_List.length univ_insts) = (Prims.parse_int "1"))) then begin
(FStar_List.append univ_insts ((FStar_Syntax_Syntax.U_zero)::[]))
end else begin
(let _150_783 = (let _150_782 = (FStar_Syntax_Print.lid_to_string lid)
in (let _150_781 = (FStar_All.pipe_right (FStar_List.length univ_insts) FStar_Util.string_of_int)
in (FStar_Util.format2 "Unexpected instantiation of effect %s with %s universes" _150_782 _150_781)))
in (FStar_All.failwith _150_783))
end
end
in (match (((binders), (univs))) with
| ([], _53_784) -> begin
(FStar_All.failwith "Unexpected effect abbreviation with no arguments")
end
| (_53_787, (_53_794)::(_53_791)::_53_789) when (not ((FStar_Ident.lid_equals lid FStar_Syntax_Const.effect_Lemma_lid))) -> begin
(let _150_786 = (let _150_785 = (FStar_Syntax_Print.lid_to_string lid)
in (let _150_784 = (FStar_All.pipe_left FStar_Util.string_of_int (FStar_List.length univs))
in (FStar_Util.format2 "Unexpected effect abbreviation %s; polymorphic in %s universes" _150_785 _150_784)))
in (FStar_All.failwith _150_786))
end
| _53_798 -> begin
(

let _53_802 = (let _150_788 = (let _150_787 = (FStar_Syntax_Util.arrow binders c)
in ((univs), (_150_787)))
in (inst_tscheme_with _150_788 insts))
in (match (_53_802) with
| (_53_800, t) -> begin
(

let t = (FStar_Syntax_Subst.set_use_range (FStar_Ident.range_of_lid lid) t)
in (match ((let _150_789 = (FStar_Syntax_Subst.compress t)
in _150_789.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (binders, c) -> begin
Some (((binders), (c)))
end
| _53_809 -> begin
(FStar_All.failwith "Impossible")
end))
end))
end))
end)
end
| _53_811 -> begin
None
end))


let norm_eff_name : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident = (

let cache = (FStar_Util.smap_create (Prims.parse_int "20"))
in (fun env l -> (

let rec find = (fun l -> (match ((lookup_effect_abbrev env ((FStar_Syntax_Syntax.U_unknown)::[]) l)) with
| None -> begin
None
end
| Some (_53_819, c) -> begin
(

let l = (FStar_Syntax_Util.comp_effect_name c)
in (match ((find l)) with
| None -> begin
Some (l)
end
| Some (l') -> begin
Some (l')
end))
end))
in (

let res = (match ((FStar_Util.smap_try_find cache l.FStar_Ident.str)) with
| Some (l) -> begin
l
end
| None -> begin
(match ((find l)) with
| None -> begin
l
end
| Some (m) -> begin
(

let _53_833 = (FStar_Util.smap_add cache l.FStar_Ident.str m)
in m)
end)
end)
in (FStar_Ident.set_lid_range res (FStar_Ident.range_of_lid l))))))


let lookup_effect_quals : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.qualifier Prims.list = (fun env l -> (

let l = (norm_eff_name env l)
in (match ((lookup_qname env l)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_new_effect (ne, _53_841), _53_845)) -> begin
ne.FStar_Syntax_Syntax.qualifiers
end
| _53_850 -> begin
[]
end)))


let lookup_projector : env  ->  FStar_Ident.lident  ->  Prims.int  ->  FStar_Ident.lident = (fun env lid i -> (

let fail = (fun _53_855 -> (match (()) with
| () -> begin
(let _150_810 = (let _150_809 = (FStar_Util.string_of_int i)
in (let _150_808 = (FStar_Syntax_Print.lid_to_string lid)
in (FStar_Util.format2 "Impossible: projecting field #%s from constructor %s is undefined" _150_809 _150_808)))
in (FStar_All.failwith _150_810))
end))
in (

let _53_859 = (lookup_datacon env lid)
in (match (_53_859) with
| (_53_857, t) -> begin
(match ((let _150_811 = (FStar_Syntax_Subst.compress t)
in _150_811.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (binders, _53_862) -> begin
if ((i < (Prims.parse_int "0")) || (i >= (FStar_List.length binders))) then begin
(fail ())
end else begin
(

let b = (FStar_List.nth binders i)
in (let _150_812 = (FStar_Syntax_Util.mk_field_projector_name lid (Prims.fst b) i)
in (FStar_All.pipe_right _150_812 Prims.fst)))
end
end
| _53_867 -> begin
(fail ())
end)
end))))


let is_projector : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env l -> (match ((lookup_qname env l)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_declare_typ (_53_871, _53_873, _53_875, quals, _53_878), _53_882)) -> begin
(FStar_Util.for_some (fun _53_7 -> (match (_53_7) with
| FStar_Syntax_Syntax.Projector (_53_888) -> begin
true
end
| _53_891 -> begin
false
end)) quals)
end
| _53_893 -> begin
false
end))


let is_datacon : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_datacon (_53_897, _53_899, _53_901, _53_903, _53_905, _53_907, _53_909, _53_911), _53_915)) -> begin
true
end
| _53_920 -> begin
false
end))


let is_record : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_inductive_typ (_53_924, _53_926, _53_928, _53_930, _53_932, _53_934, tags, _53_937), _53_941)) -> begin
(FStar_Util.for_some (fun _53_8 -> (match (_53_8) with
| (FStar_Syntax_Syntax.RecordType (_)) | (FStar_Syntax_Syntax.RecordConstructor (_)) -> begin
true
end
| _53_953 -> begin
false
end)) tags)
end
| _53_955 -> begin
false
end))


let is_interpreted : env  ->  FStar_Syntax_Syntax.term  ->  Prims.bool = (

let interpreted_symbols = (FStar_Syntax_Const.op_Eq)::(FStar_Syntax_Const.op_notEq)::(FStar_Syntax_Const.op_LT)::(FStar_Syntax_Const.op_LTE)::(FStar_Syntax_Const.op_GT)::(FStar_Syntax_Const.op_GTE)::(FStar_Syntax_Const.op_Subtraction)::(FStar_Syntax_Const.op_Minus)::(FStar_Syntax_Const.op_Addition)::(FStar_Syntax_Const.op_Multiply)::(FStar_Syntax_Const.op_Division)::(FStar_Syntax_Const.op_Modulus)::(FStar_Syntax_Const.op_And)::(FStar_Syntax_Const.op_Or)::(FStar_Syntax_Const.op_Negation)::[]
in (fun env head -> (match ((let _150_831 = (FStar_Syntax_Util.un_uinst head)
in _150_831.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_fvar (fv) -> begin
(fv.FStar_Syntax_Syntax.fv_delta = FStar_Syntax_Syntax.Delta_equational)
end
| _53_962 -> begin
false
end)))


let is_type_constructor : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env lid -> (

let mapper = (fun _53_9 -> (match (_53_9) with
| FStar_Util.Inl (_53_967) -> begin
Some (false)
end
| FStar_Util.Inr (se, _53_971) -> begin
(match (se) with
| FStar_Syntax_Syntax.Sig_declare_typ (_53_975, _53_977, _53_979, qs, _53_982) -> begin
Some ((FStar_List.contains FStar_Syntax_Syntax.New qs))
end
| FStar_Syntax_Syntax.Sig_inductive_typ (_53_986) -> begin
Some (true)
end
| _53_989 -> begin
Some (false)
end)
end))
in (match ((let _150_838 = (lookup_qname env lid)
in (FStar_Util.bind_opt _150_838 mapper))) with
| Some (b) -> begin
b
end
| None -> begin
false
end)))


let effect_decl_opt : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.eff_decl Prims.option = (fun env l -> (FStar_All.pipe_right env.effects.decls (FStar_Util.find_opt (fun d -> (FStar_Ident.lid_equals d.FStar_Syntax_Syntax.mname l)))))


let get_effect_decl : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.eff_decl = (fun env l -> (match ((effect_decl_opt env l)) with
| None -> begin
(let _150_850 = (let _150_849 = (let _150_848 = (name_not_found l)
in ((_150_848), ((FStar_Ident.range_of_lid l))))
in FStar_Syntax_Syntax.Error (_150_849))
in (Prims.raise _150_850))
end
| Some (md) -> begin
md
end))


let join : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident  ->  (FStar_Ident.lident * mlift * mlift) = (fun env l1 l2 -> if (FStar_Ident.lid_equals l1 l2) then begin
((l1), ((fun t wp -> wp)), ((fun t wp -> wp)))
end else begin
if (((FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_GTot_lid) && (FStar_Ident.lid_equals l2 FStar_Syntax_Const.effect_Tot_lid)) || ((FStar_Ident.lid_equals l2 FStar_Syntax_Const.effect_GTot_lid) && (FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_Tot_lid))) then begin
((FStar_Syntax_Const.effect_GTot_lid), ((fun t wp -> wp)), ((fun t wp -> wp)))
end else begin
(match ((FStar_All.pipe_right env.effects.joins (FStar_Util.find_opt (fun _53_1021 -> (match (_53_1021) with
| (m1, m2, _53_1016, _53_1018, _53_1020) -> begin
((FStar_Ident.lid_equals l1 m1) && (FStar_Ident.lid_equals l2 m2))
end))))) with
| None -> begin
(let _150_926 = (let _150_925 = (let _150_924 = (let _150_923 = (FStar_Syntax_Print.lid_to_string l1)
in (let _150_922 = (FStar_Syntax_Print.lid_to_string l2)
in (FStar_Util.format2 "Effects %s and %s cannot be composed" _150_923 _150_922)))
in ((_150_924), (env.range)))
in FStar_Syntax_Syntax.Error (_150_925))
in (Prims.raise _150_926))
end
| Some (_53_1024, _53_1026, m3, j1, j2) -> begin
((m3), (j1), (j2))
end)
end
end)


let monad_leq : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident  ->  edge Prims.option = (fun env l1 l2 -> if ((FStar_Ident.lid_equals l1 l2) || ((FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_Tot_lid) && (FStar_Ident.lid_equals l2 FStar_Syntax_Const.effect_GTot_lid))) then begin
Some ({msource = l1; mtarget = l2; mlift = (fun t wp -> wp)})
end else begin
(FStar_All.pipe_right env.effects.order (FStar_Util.find_opt (fun e -> ((FStar_Ident.lid_equals l1 e.msource) && (FStar_Ident.lid_equals l2 e.mtarget)))))
end)


let wp_sig_aux : FStar_Syntax_Syntax.eff_decl Prims.list  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.term) = (fun decls m -> (match ((FStar_All.pipe_right decls (FStar_Util.find_opt (fun d -> (FStar_Ident.lid_equals d.FStar_Syntax_Syntax.mname m))))) with
| None -> begin
(let _150_941 = (FStar_Util.format1 "Impossible: declaration for monad %s not found" m.FStar_Ident.str)
in (FStar_All.failwith _150_941))
end
| Some (md) -> begin
(

let _53_1047 = (inst_tscheme ((md.FStar_Syntax_Syntax.univs), (md.FStar_Syntax_Syntax.signature)))
in (match (_53_1047) with
| (_53_1045, s) -> begin
(

let s = (FStar_Syntax_Subst.compress s)
in (match (((md.FStar_Syntax_Syntax.binders), (s.FStar_Syntax_Syntax.n))) with
| ([], FStar_Syntax_Syntax.Tm_arrow (((a, _53_1056))::((wp, _53_1052))::[], c)) when (FStar_Syntax_Syntax.is_teff (FStar_Syntax_Util.comp_result c)) -> begin
((a), (wp.FStar_Syntax_Syntax.sort))
end
| _53_1064 -> begin
(FStar_All.failwith "Impossible")
end))
end))
end))


let wp_signature : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.term) = (fun env m -> (wp_sig_aux env.effects.decls m))


let build_lattice : env  ->  FStar_Syntax_Syntax.sigelt  ->  env = (fun env se -> (match (se) with
| FStar_Syntax_Syntax.Sig_new_effect (ne, _53_1071) -> begin
(

let effects = (

let _53_1074 = env.effects
in {decls = (ne)::env.effects.decls; order = _53_1074.order; joins = _53_1074.joins})
in (

let _53_1077 = env
in {solver = _53_1077.solver; range = _53_1077.range; curmodule = _53_1077.curmodule; gamma = _53_1077.gamma; gamma_cache = _53_1077.gamma_cache; modules = _53_1077.modules; expected_typ = _53_1077.expected_typ; sigtab = _53_1077.sigtab; is_pattern = _53_1077.is_pattern; instantiate_imp = _53_1077.instantiate_imp; effects = effects; generalize = _53_1077.generalize; letrecs = _53_1077.letrecs; top_level = _53_1077.top_level; check_uvars = _53_1077.check_uvars; use_eq = _53_1077.use_eq; is_iface = _53_1077.is_iface; admit = _53_1077.admit; lax = _53_1077.lax; lax_universes = _53_1077.lax_universes; type_of = _53_1077.type_of; universe_of = _53_1077.universe_of; use_bv_sorts = _53_1077.use_bv_sorts; qname_and_index = _53_1077.qname_and_index}))
end
| FStar_Syntax_Syntax.Sig_sub_effect (sub, _53_1081) -> begin
(

let compose_edges = (fun e1 e2 -> {msource = e1.msource; mtarget = e2.mtarget; mlift = (fun r wp1 -> (let _150_956 = (e1.mlift r wp1)
in (e2.mlift r _150_956)))})
in (

let mk_lift = (fun lift_t r wp1 -> (

let _53_1096 = (inst_tscheme lift_t)
in (match (_53_1096) with
| (_53_1094, lift_t) -> begin
(let _150_968 = (let _150_967 = (let _150_966 = (let _150_965 = (FStar_Syntax_Syntax.as_arg r)
in (let _150_964 = (let _150_963 = (FStar_Syntax_Syntax.as_arg wp1)
in (_150_963)::[])
in (_150_965)::_150_964))
in ((lift_t), (_150_966)))
in FStar_Syntax_Syntax.Tm_app (_150_967))
in (FStar_Syntax_Syntax.mk _150_968 None wp1.FStar_Syntax_Syntax.pos))
end)))
in (

let sub_lift_wp = (match (sub.FStar_Syntax_Syntax.lift_wp) with
| Some (sub_lift_wp) -> begin
sub_lift_wp
end
| None -> begin
(FStar_All.failwith "sub effect should\'ve been elaborated at this stage")
end)
in (

let edge = {msource = sub.FStar_Syntax_Syntax.source; mtarget = sub.FStar_Syntax_Syntax.target; mlift = (mk_lift sub_lift_wp)}
in (

let id_edge = (fun l -> {msource = sub.FStar_Syntax_Syntax.source; mtarget = sub.FStar_Syntax_Syntax.target; mlift = (fun t wp -> wp)})
in (

let print_mlift = (fun l -> (

let arg = (let _150_985 = (FStar_Ident.lid_of_path (("ARG")::[]) FStar_Range.dummyRange)
in (FStar_Syntax_Syntax.lid_as_fv _150_985 FStar_Syntax_Syntax.Delta_constant None))
in (

let wp = (let _150_986 = (FStar_Ident.lid_of_path (("WP")::[]) FStar_Range.dummyRange)
in (FStar_Syntax_Syntax.lid_as_fv _150_986 FStar_Syntax_Syntax.Delta_constant None))
in (let _150_987 = (l arg wp)
in (FStar_Syntax_Print.term_to_string _150_987)))))
in (

let order = (edge)::env.effects.order
in (

let ms = (FStar_All.pipe_right env.effects.decls (FStar_List.map (fun e -> e.FStar_Syntax_Syntax.mname)))
in (

let find_edge = (fun order _53_1117 -> (match (_53_1117) with
| (i, j) -> begin
if (FStar_Ident.lid_equals i j) then begin
(FStar_All.pipe_right (id_edge i) (fun _150_993 -> Some (_150_993)))
end else begin
(FStar_All.pipe_right order (FStar_Util.find_opt (fun e -> ((FStar_Ident.lid_equals e.msource i) && (FStar_Ident.lid_equals e.mtarget j)))))
end
end))
in (

let order = (FStar_All.pipe_right ms (FStar_List.fold_left (fun order k -> (let _150_1001 = (FStar_All.pipe_right ms (FStar_List.collect (fun i -> if (FStar_Ident.lid_equals i k) then begin
[]
end else begin
(FStar_All.pipe_right ms (FStar_List.collect (fun j -> if (FStar_Ident.lid_equals j k) then begin
[]
end else begin
(match ((let _150_1000 = (find_edge order ((i), (k)))
in (let _150_999 = (find_edge order ((k), (j)))
in ((_150_1000), (_150_999))))) with
| (Some (e1), Some (e2)) -> begin
((compose_edges e1 e2))::[]
end
| _53_1129 -> begin
[]
end)
end)))
end)))
in (FStar_List.append order _150_1001))) order))
in (

let order = (FStar_Util.remove_dups (fun e1 e2 -> ((FStar_Ident.lid_equals e1.msource e2.msource) && (FStar_Ident.lid_equals e1.mtarget e2.mtarget))) order)
in (

let _53_1135 = (FStar_All.pipe_right order (FStar_List.iter (fun edge -> if ((FStar_Ident.lid_equals edge.msource FStar_Syntax_Const.effect_DIV_lid) && (let _150_1005 = (lookup_effect_quals env edge.mtarget)
in (FStar_All.pipe_right _150_1005 (FStar_List.contains FStar_Syntax_Syntax.TotalEffect)))) then begin
(let _150_1009 = (let _150_1008 = (let _150_1007 = (FStar_Util.format1 "Divergent computations cannot be included in an effect %s marked \'total\'" edge.mtarget.FStar_Ident.str)
in (let _150_1006 = (get_range env)
in ((_150_1007), (_150_1006))))
in FStar_Syntax_Syntax.Error (_150_1008))
in (Prims.raise _150_1009))
end else begin
()
end)))
in (

let joins = (FStar_All.pipe_right ms (FStar_List.collect (fun i -> (FStar_All.pipe_right ms (FStar_List.collect (fun j -> (

let join_opt = (FStar_All.pipe_right ms (FStar_List.fold_left (fun bopt k -> (match ((let _150_1099 = (find_edge order ((i), (k)))
in (let _150_1098 = (find_edge order ((j), (k)))
in ((_150_1099), (_150_1098))))) with
| (Some (ik), Some (jk)) -> begin
(match (bopt) with
| None -> begin
Some (((k), (ik), (jk)))
end
| Some (ub, _53_1149, _53_1151) -> begin
if ((let _150_1100 = (find_edge order ((k), (ub)))
in (FStar_Util.is_some _150_1100)) && (not ((let _150_1101 = (find_edge order ((ub), (k)))
in (FStar_Util.is_some _150_1101))))) then begin
Some (((k), (ik), (jk)))
end else begin
bopt
end
end)
end
| _53_1155 -> begin
bopt
end)) None))
in (match (join_opt) with
| None -> begin
[]
end
| Some (k, e1, e2) -> begin
(((i), (j), (k), (e1.mlift), (e2.mlift)))::[]
end))))))))
in (

let effects = (

let _53_1164 = env.effects
in {decls = _53_1164.decls; order = order; joins = joins})
in (

let _53_1167 = env
in {solver = _53_1167.solver; range = _53_1167.range; curmodule = _53_1167.curmodule; gamma = _53_1167.gamma; gamma_cache = _53_1167.gamma_cache; modules = _53_1167.modules; expected_typ = _53_1167.expected_typ; sigtab = _53_1167.sigtab; is_pattern = _53_1167.is_pattern; instantiate_imp = _53_1167.instantiate_imp; effects = effects; generalize = _53_1167.generalize; letrecs = _53_1167.letrecs; top_level = _53_1167.top_level; check_uvars = _53_1167.check_uvars; use_eq = _53_1167.use_eq; is_iface = _53_1167.is_iface; admit = _53_1167.admit; lax = _53_1167.lax; lax_universes = _53_1167.lax_universes; type_of = _53_1167.type_of; universe_of = _53_1167.universe_of; use_bv_sorts = _53_1167.use_bv_sorts; qname_and_index = _53_1167.qname_and_index})))))))))))))))
end
| _53_1170 -> begin
env
end))


let push_in_gamma : env  ->  binding  ->  env = (fun env s -> (

let rec push = (fun x rest -> (match (rest) with
| ((Binding_sig (_))::_) | ((Binding_sig_inst (_))::_) -> begin
(x)::rest
end
| [] -> begin
(x)::[]
end
| (local)::rest -> begin
(let _150_1150 = (push x rest)
in (local)::_150_1150)
end))
in (

let _53_1192 = env
in (let _150_1151 = (push s env.gamma)
in {solver = _53_1192.solver; range = _53_1192.range; curmodule = _53_1192.curmodule; gamma = _150_1151; gamma_cache = _53_1192.gamma_cache; modules = _53_1192.modules; expected_typ = _53_1192.expected_typ; sigtab = _53_1192.sigtab; is_pattern = _53_1192.is_pattern; instantiate_imp = _53_1192.instantiate_imp; effects = _53_1192.effects; generalize = _53_1192.generalize; letrecs = _53_1192.letrecs; top_level = _53_1192.top_level; check_uvars = _53_1192.check_uvars; use_eq = _53_1192.use_eq; is_iface = _53_1192.is_iface; admit = _53_1192.admit; lax = _53_1192.lax; lax_universes = _53_1192.lax_universes; type_of = _53_1192.type_of; universe_of = _53_1192.universe_of; use_bv_sorts = _53_1192.use_bv_sorts; qname_and_index = _53_1192.qname_and_index}))))


let push_sigelt : env  ->  FStar_Syntax_Syntax.sigelt  ->  env = (fun env s -> (

let env = (let _150_1158 = (let _150_1157 = (let _150_1156 = (FStar_Syntax_Util.lids_of_sigelt s)
in ((_150_1156), (s)))
in Binding_sig (_150_1157))
in (push_in_gamma env _150_1158))
in (build_lattice env s)))


let push_sigelt_inst : env  ->  FStar_Syntax_Syntax.sigelt  ->  FStar_Syntax_Syntax.universes  ->  env = (fun env s us -> (

let env = (let _150_1167 = (let _150_1166 = (let _150_1165 = (FStar_Syntax_Util.lids_of_sigelt s)
in ((_150_1165), (s), (us)))
in Binding_sig_inst (_150_1166))
in (push_in_gamma env _150_1167))
in (build_lattice env s)))


let push_local_binding : env  ->  binding  ->  env = (fun env b -> (

let _53_1203 = env
in {solver = _53_1203.solver; range = _53_1203.range; curmodule = _53_1203.curmodule; gamma = (b)::env.gamma; gamma_cache = _53_1203.gamma_cache; modules = _53_1203.modules; expected_typ = _53_1203.expected_typ; sigtab = _53_1203.sigtab; is_pattern = _53_1203.is_pattern; instantiate_imp = _53_1203.instantiate_imp; effects = _53_1203.effects; generalize = _53_1203.generalize; letrecs = _53_1203.letrecs; top_level = _53_1203.top_level; check_uvars = _53_1203.check_uvars; use_eq = _53_1203.use_eq; is_iface = _53_1203.is_iface; admit = _53_1203.admit; lax = _53_1203.lax; lax_universes = _53_1203.lax_universes; type_of = _53_1203.type_of; universe_of = _53_1203.universe_of; use_bv_sorts = _53_1203.use_bv_sorts; qname_and_index = _53_1203.qname_and_index}))


let push_bv : env  ->  FStar_Syntax_Syntax.bv  ->  env = (fun env x -> (push_local_binding env (Binding_var (x))))


let push_binders : env  ->  FStar_Syntax_Syntax.binders  ->  env = (fun env bs -> (FStar_List.fold_left (fun env _53_1213 -> (match (_53_1213) with
| (x, _53_1212) -> begin
(push_bv env x)
end)) env bs))


let binding_of_lb : FStar_Syntax_Syntax.lbname  ->  (FStar_Ident.ident Prims.list * FStar_Syntax_Syntax.term)  ->  binding = (fun x t -> (match (x) with
| FStar_Util.Inl (x) -> begin
(

let _53_1218 = ()
in (

let x = (

let _53_1220 = x
in {FStar_Syntax_Syntax.ppname = _53_1220.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _53_1220.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = (Prims.snd t)})
in Binding_var (x)))
end
| FStar_Util.Inr (fv) -> begin
Binding_lid (((fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v), (t)))
end))


let push_let_binding : env  ->  FStar_Syntax_Syntax.lbname  ->  FStar_Syntax_Syntax.tscheme  ->  env = (fun env lb ts -> (push_local_binding env (binding_of_lb lb ts)))


let push_module : env  ->  FStar_Syntax_Syntax.modul  ->  env = (fun env m -> (

let _53_1230 = (add_sigelts env m.FStar_Syntax_Syntax.exports)
in (

let _53_1232 = env
in {solver = _53_1232.solver; range = _53_1232.range; curmodule = _53_1232.curmodule; gamma = []; gamma_cache = _53_1232.gamma_cache; modules = (m)::env.modules; expected_typ = None; sigtab = _53_1232.sigtab; is_pattern = _53_1232.is_pattern; instantiate_imp = _53_1232.instantiate_imp; effects = _53_1232.effects; generalize = _53_1232.generalize; letrecs = _53_1232.letrecs; top_level = _53_1232.top_level; check_uvars = _53_1232.check_uvars; use_eq = _53_1232.use_eq; is_iface = _53_1232.is_iface; admit = _53_1232.admit; lax = _53_1232.lax; lax_universes = _53_1232.lax_universes; type_of = _53_1232.type_of; universe_of = _53_1232.universe_of; use_bv_sorts = _53_1232.use_bv_sorts; qname_and_index = _53_1232.qname_and_index})))


let push_univ_vars : env  ->  FStar_Syntax_Syntax.univ_names  ->  env = (fun env xs -> (FStar_List.fold_left (fun env x -> (push_local_binding env (Binding_univ (x)))) env xs))


let set_expected_typ : env  ->  FStar_Syntax_Syntax.typ  ->  env = (fun env t -> (

let _53_1240 = env
in {solver = _53_1240.solver; range = _53_1240.range; curmodule = _53_1240.curmodule; gamma = _53_1240.gamma; gamma_cache = _53_1240.gamma_cache; modules = _53_1240.modules; expected_typ = Some (t); sigtab = _53_1240.sigtab; is_pattern = _53_1240.is_pattern; instantiate_imp = _53_1240.instantiate_imp; effects = _53_1240.effects; generalize = _53_1240.generalize; letrecs = _53_1240.letrecs; top_level = _53_1240.top_level; check_uvars = _53_1240.check_uvars; use_eq = false; is_iface = _53_1240.is_iface; admit = _53_1240.admit; lax = _53_1240.lax; lax_universes = _53_1240.lax_universes; type_of = _53_1240.type_of; universe_of = _53_1240.universe_of; use_bv_sorts = _53_1240.use_bv_sorts; qname_and_index = _53_1240.qname_and_index}))


let expected_typ : env  ->  FStar_Syntax_Syntax.typ Prims.option = (fun env -> (match (env.expected_typ) with
| None -> begin
None
end
| Some (t) -> begin
Some (t)
end))


let clear_expected_typ : env  ->  (env * FStar_Syntax_Syntax.typ Prims.option) = (fun env -> (let _150_1210 = (expected_typ env)
in (((

let _53_1247 = env
in {solver = _53_1247.solver; range = _53_1247.range; curmodule = _53_1247.curmodule; gamma = _53_1247.gamma; gamma_cache = _53_1247.gamma_cache; modules = _53_1247.modules; expected_typ = None; sigtab = _53_1247.sigtab; is_pattern = _53_1247.is_pattern; instantiate_imp = _53_1247.instantiate_imp; effects = _53_1247.effects; generalize = _53_1247.generalize; letrecs = _53_1247.letrecs; top_level = _53_1247.top_level; check_uvars = _53_1247.check_uvars; use_eq = false; is_iface = _53_1247.is_iface; admit = _53_1247.admit; lax = _53_1247.lax; lax_universes = _53_1247.lax_universes; type_of = _53_1247.type_of; universe_of = _53_1247.universe_of; use_bv_sorts = _53_1247.use_bv_sorts; qname_and_index = _53_1247.qname_and_index})), (_150_1210))))


let finish_module : env  ->  FStar_Syntax_Syntax.modul  ->  env = (

let empty_lid = (FStar_Ident.lid_of_ids (((FStar_Ident.id_of_text ""))::[]))
in (fun env m -> (

let sigs = if (FStar_Ident.lid_equals m.FStar_Syntax_Syntax.name FStar_Syntax_Const.prims_lid) then begin
(let _150_1216 = (FStar_All.pipe_right env.gamma (FStar_List.collect (fun _53_10 -> (match (_53_10) with
| Binding_sig (_53_1254, se) -> begin
(se)::[]
end
| _53_1259 -> begin
[]
end))))
in (FStar_All.pipe_right _150_1216 FStar_List.rev))
end else begin
m.FStar_Syntax_Syntax.exports
end
in (

let _53_1261 = (add_sigelts env sigs)
in (

let _53_1263 = env
in {solver = _53_1263.solver; range = _53_1263.range; curmodule = empty_lid; gamma = []; gamma_cache = _53_1263.gamma_cache; modules = (m)::env.modules; expected_typ = _53_1263.expected_typ; sigtab = _53_1263.sigtab; is_pattern = _53_1263.is_pattern; instantiate_imp = _53_1263.instantiate_imp; effects = _53_1263.effects; generalize = _53_1263.generalize; letrecs = _53_1263.letrecs; top_level = _53_1263.top_level; check_uvars = _53_1263.check_uvars; use_eq = _53_1263.use_eq; is_iface = _53_1263.is_iface; admit = _53_1263.admit; lax = _53_1263.lax; lax_universes = _53_1263.lax_universes; type_of = _53_1263.type_of; universe_of = _53_1263.universe_of; use_bv_sorts = _53_1263.use_bv_sorts; qname_and_index = _53_1263.qname_and_index})))))


let uvars_in_env : env  ->  FStar_Syntax_Syntax.uvars = (fun env -> (

let no_uvs = (FStar_Syntax_Syntax.new_uv_set ())
in (

let ext = (fun out uvs -> (FStar_Util.set_union out uvs))
in (

let rec aux = (fun out g -> (match (g) with
| [] -> begin
out
end
| (Binding_univ (_53_1276))::tl -> begin
(aux out tl)
end
| ((Binding_lid (_, (_, t)))::tl) | ((Binding_var ({FStar_Syntax_Syntax.ppname = _; FStar_Syntax_Syntax.index = _; FStar_Syntax_Syntax.sort = t}))::tl) -> begin
(let _150_1228 = (let _150_1227 = (FStar_Syntax_Free.uvars t)
in (ext out _150_1227))
in (aux _150_1228 tl))
end
| ((Binding_sig (_))::_) | ((Binding_sig_inst (_))::_) -> begin
out
end))
in (aux no_uvs env.gamma)))))


let univ_vars : env  ->  FStar_Syntax_Syntax.universe_uvar FStar_Util.set = (fun env -> (

let no_univs = FStar_Syntax_Syntax.no_universe_uvars
in (

let ext = (fun out uvs -> (FStar_Util.set_union out uvs))
in (

let rec aux = (fun out g -> (match (g) with
| [] -> begin
out
end
| ((Binding_sig_inst (_))::tl) | ((Binding_univ (_))::tl) -> begin
(aux out tl)
end
| ((Binding_lid (_, (_, t)))::tl) | ((Binding_var ({FStar_Syntax_Syntax.ppname = _; FStar_Syntax_Syntax.index = _; FStar_Syntax_Syntax.sort = t}))::tl) -> begin
(let _150_1240 = (let _150_1239 = (FStar_Syntax_Free.univs t)
in (ext out _150_1239))
in (aux _150_1240 tl))
end
| (Binding_sig (_53_1346))::_53_1344 -> begin
out
end))
in (aux no_univs env.gamma)))))


let univnames : env  ->  FStar_Syntax_Syntax.univ_name FStar_Util.set = (fun env -> (

let no_univ_names = FStar_Syntax_Syntax.no_universe_names
in (

let ext = (fun out uvs -> (FStar_Util.set_union out uvs))
in (

let rec aux = (fun out g -> (match (g) with
| [] -> begin
out
end
| (Binding_sig_inst (_53_1360))::tl -> begin
(aux out tl)
end
| (Binding_univ (uname))::tl -> begin
(let _150_1251 = (FStar_Util.set_add uname out)
in (aux _150_1251 tl))
end
| ((Binding_lid (_, (_, t)))::tl) | ((Binding_var ({FStar_Syntax_Syntax.ppname = _; FStar_Syntax_Syntax.index = _; FStar_Syntax_Syntax.sort = t}))::tl) -> begin
(let _150_1253 = (let _150_1252 = (FStar_Syntax_Free.univnames t)
in (ext out _150_1252))
in (aux _150_1253 tl))
end
| (Binding_sig (_53_1387))::_53_1385 -> begin
out
end))
in (aux no_univ_names env.gamma)))))


let bound_vars_of_bindings : binding Prims.list  ->  FStar_Syntax_Syntax.bv Prims.list = (fun bs -> (FStar_All.pipe_right bs (FStar_List.collect (fun _53_11 -> (match (_53_11) with
| Binding_var (x) -> begin
(x)::[]
end
| (Binding_lid (_)) | (Binding_sig (_)) | (Binding_univ (_)) | (Binding_sig_inst (_)) -> begin
[]
end)))))


let binders_of_bindings : binding Prims.list  ->  FStar_Syntax_Syntax.binders = (fun bs -> (let _150_1260 = (let _150_1259 = (bound_vars_of_bindings bs)
in (FStar_All.pipe_right _150_1259 (FStar_List.map FStar_Syntax_Syntax.mk_binder)))
in (FStar_All.pipe_right _150_1260 FStar_List.rev)))


let bound_vars : env  ->  FStar_Syntax_Syntax.bv Prims.list = (fun env -> (bound_vars_of_bindings env.gamma))


let all_binders : env  ->  FStar_Syntax_Syntax.binders = (fun env -> (binders_of_bindings env.gamma))


let fold_env = (fun env f a -> (FStar_List.fold_right (fun e a -> (f a e)) env.gamma a))


let lidents : env  ->  FStar_Ident.lident Prims.list = (fun env -> (

let keys = (FStar_List.fold_left (fun keys _53_12 -> (match (_53_12) with
| Binding_sig (lids, _53_1419) -> begin
(FStar_List.append lids keys)
end
| _53_1423 -> begin
keys
end)) [] env.gamma)
in (FStar_Util.smap_fold (sigtab env) (fun _53_1425 v keys -> (let _150_1283 = (FStar_Syntax_Util.lids_of_sigelt v)
in (FStar_List.append _150_1283 keys))) keys)))


let dummy_solver : solver_t = {init = (fun _53_1429 -> ()); push = (fun _53_1431 -> ()); pop = (fun _53_1433 -> ()); mark = (fun _53_1435 -> ()); reset_mark = (fun _53_1437 -> ()); commit_mark = (fun _53_1439 -> ()); encode_modul = (fun _53_1441 _53_1443 -> ()); encode_sig = (fun _53_1445 _53_1447 -> ()); solve = (fun _53_1449 _53_1451 _53_1453 -> ()); is_trivial = (fun _53_1455 _53_1457 -> false); finish = (fun _53_1459 -> ()); refresh = (fun _53_1460 -> ())}




