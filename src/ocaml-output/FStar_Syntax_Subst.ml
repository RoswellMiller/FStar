
open Prims
# 51 "FStar.Syntax.Subst.fst"
let rec force_uvar : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_uvar (uv, _35_11) -> begin
(match ((FStar_Unionfind.find uv)) with
| FStar_Syntax_Syntax.Fixed (t') -> begin
(force_uvar t')
end
| _35_17 -> begin
t
end)
end
| _35_19 -> begin
t
end))

# 65 "FStar.Syntax.Subst.fst"
let rec force_delayed_thunk : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (f, m) -> begin
(match ((FStar_ST.read m)) with
| None -> begin
(match (f) with
| FStar_Util.Inr (c) -> begin
(
# 72 "FStar.Syntax.Subst.fst"
let t' = (let _127_8 = (c ())
in (force_delayed_thunk _127_8))
in (
# 72 "FStar.Syntax.Subst.fst"
let _35_29 = (FStar_ST.op_Colon_Equals m (Some (t')))
in t'))
end
| _35_32 -> begin
t
end)
end
| Some (t') -> begin
(
# 75 "FStar.Syntax.Subst.fst"
let t' = (force_delayed_thunk t')
in (
# 75 "FStar.Syntax.Subst.fst"
let _35_36 = (FStar_ST.op_Colon_Equals m (Some (t')))
in t'))
end)
end
| _35_39 -> begin
t
end))

# 76 "FStar.Syntax.Subst.fst"
let rec compress_univ : FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.universe = (fun u -> (match (u) with
| FStar_Syntax_Syntax.U_unif (u') -> begin
(match ((FStar_Unionfind.find u')) with
| Some (u) -> begin
(compress_univ u)
end
| _35_46 -> begin
u
end)
end
| _35_48 -> begin
u
end))

# 84 "FStar.Syntax.Subst.fst"
let subst_to_string = (fun s -> (let _127_15 = (FStar_All.pipe_right s (FStar_List.map (fun _35_53 -> (match (_35_53) with
| (b, _35_52) -> begin
b.FStar_Syntax_Syntax.ppname.FStar_Ident.idText
end))))
in (FStar_All.pipe_right _127_15 (FStar_String.concat ", "))))

# 90 "FStar.Syntax.Subst.fst"
let subst_bv : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.term Prims.option = (fun a s -> (FStar_Util.find_map s (fun _35_1 -> (match (_35_1) with
| FStar_Syntax_Syntax.DB (i, x) when (i = a.FStar_Syntax_Syntax.index) -> begin
(let _127_23 = (let _127_22 = (let _127_21 = (FStar_Syntax_Syntax.range_of_bv a)
in (FStar_Syntax_Syntax.set_range_of_bv x _127_21))
in (FStar_Syntax_Syntax.bv_to_name _127_22))
in Some (_127_23))
end
| _35_62 -> begin
None
end))))

# 96 "FStar.Syntax.Subst.fst"
let subst_nm : FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.term Prims.option = (fun a s -> (FStar_Util.find_map s (fun _35_2 -> (match (_35_2) with
| FStar_Syntax_Syntax.NM (x, i) when (FStar_Syntax_Syntax.bv_eq a x) -> begin
(let _127_29 = (FStar_Syntax_Syntax.bv_to_tm (
# 98 "FStar.Syntax.Subst.fst"
let _35_70 = a
in {FStar_Syntax_Syntax.ppname = _35_70.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = i; FStar_Syntax_Syntax.sort = _35_70.FStar_Syntax_Syntax.sort}))
in Some (_127_29))
end
| FStar_Syntax_Syntax.NT (x, t) when (FStar_Syntax_Syntax.bv_eq a x) -> begin
Some (t)
end
| _35_77 -> begin
None
end))))

# 100 "FStar.Syntax.Subst.fst"
let subst_univ_bv : Prims.int  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.universe Prims.option = (fun x s -> (FStar_Util.find_map s (fun _35_3 -> (match (_35_3) with
| FStar_Syntax_Syntax.UN (y, t) when (x = y) -> begin
Some (t)
end
| _35_86 -> begin
None
end))))

# 103 "FStar.Syntax.Subst.fst"
let subst_univ_nm : FStar_Syntax_Syntax.univ_name  ->  FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.universe Prims.option = (fun x s -> (FStar_Util.find_map s (fun _35_4 -> (match (_35_4) with
| FStar_Syntax_Syntax.UD (y, i) when (x.FStar_Ident.idText = y.FStar_Ident.idText) -> begin
Some (FStar_Syntax_Syntax.U_bvar (i))
end
| _35_95 -> begin
None
end))))

# 106 "FStar.Syntax.Subst.fst"
let rec apply_until_some = (fun f s -> (match (s) with
| [] -> begin
None
end
| (s0)::rest -> begin
(match ((f s0)) with
| None -> begin
(apply_until_some f rest)
end
| Some (st) -> begin
Some (((rest), (st)))
end)
end))

# 116 "FStar.Syntax.Subst.fst"
let map_some_curry = (fun f x _35_5 -> (match (_35_5) with
| None -> begin
x
end
| Some (a, b) -> begin
(f a b)
end))

# 120 "FStar.Syntax.Subst.fst"
let apply_until_some_then_map = (fun f s g t -> (let _127_67 = (apply_until_some f s)
in (FStar_All.pipe_right _127_67 (map_some_curry g t))))

# 124 "FStar.Syntax.Subst.fst"
let rec subst_univ : FStar_Syntax_Syntax.subst_elt Prims.list Prims.list  ->  FStar_Syntax_Syntax.universe  ->  FStar_Syntax_Syntax.universe = (fun s u -> (
# 127 "FStar.Syntax.Subst.fst"
let u = (compress_univ u)
in (match (u) with
| FStar_Syntax_Syntax.U_bvar (x) -> begin
(apply_until_some_then_map (subst_univ_bv x) s subst_univ u)
end
| FStar_Syntax_Syntax.U_name (x) -> begin
(apply_until_some_then_map (subst_univ_nm x) s subst_univ u)
end
| (FStar_Syntax_Syntax.U_zero) | (FStar_Syntax_Syntax.U_unknown) | (FStar_Syntax_Syntax.U_unif (_)) -> begin
u
end
| FStar_Syntax_Syntax.U_succ (u) -> begin
(let _127_72 = (subst_univ s u)
in FStar_Syntax_Syntax.U_succ (_127_72))
end
| FStar_Syntax_Syntax.U_max (us) -> begin
(let _127_73 = (FStar_List.map (subst_univ s) us)
in FStar_Syntax_Syntax.U_max (_127_73))
end)))

# 139 "FStar.Syntax.Subst.fst"
let rec subst' : FStar_Syntax_Syntax.subst_ts  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun s t -> (match (s) with
| ([]) | (([])::[]) -> begin
t
end
| _35_139 -> begin
(
# 146 "FStar.Syntax.Subst.fst"
let t0 = (force_delayed_thunk t)
in (match (t0.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Tm_unknown) | (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) | (FStar_Syntax_Syntax.Tm_uvar (_)) -> begin
t0
end
| FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inl (t', s'), m) -> begin
(FStar_Syntax_Syntax.mk_Tm_delayed (FStar_Util.Inl (((t'), ((FStar_List.append s' s))))) t.FStar_Syntax_Syntax.pos)
end
| FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inr (_35_159), _35_162) -> begin
(FStar_All.failwith "Impossible: force_delayed_thunk removes lazy delayed nodes")
end
| FStar_Syntax_Syntax.Tm_bvar (a) -> begin
(apply_until_some_then_map (subst_bv a) s subst' t0)
end
| FStar_Syntax_Syntax.Tm_name (a) -> begin
(apply_until_some_then_map (subst_nm a) s subst' t0)
end
| FStar_Syntax_Syntax.Tm_type (u) -> begin
(let _127_89 = (let _127_88 = (subst_univ s u)
in FStar_Syntax_Syntax.Tm_type (_127_88))
in (FStar_Syntax_Syntax.mk _127_89 None t0.FStar_Syntax_Syntax.pos))
end
| _35_172 -> begin
(FStar_Syntax_Syntax.mk_Tm_delayed (FStar_Util.Inl (((t0), (s)))) t.FStar_Syntax_Syntax.pos)
end))
end))
and subst_flags' : FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.cflags Prims.list  ->  FStar_Syntax_Syntax.cflags Prims.list = (fun s flags -> (FStar_All.pipe_right flags (FStar_List.map (fun _35_6 -> (match (_35_6) with
| FStar_Syntax_Syntax.DECREASES (a) -> begin
(let _127_94 = (subst' s a)
in FStar_Syntax_Syntax.DECREASES (_127_94))
end
| f -> begin
f
end)))))
and subst_comp_typ' : FStar_Syntax_Syntax.subst_elt Prims.list Prims.list  ->  FStar_Syntax_Syntax.comp_typ  ->  FStar_Syntax_Syntax.comp_typ = (fun s t -> (match (s) with
| ([]) | (([])::[]) -> begin
t
end
| _35_185 -> begin
(
# 183 "FStar.Syntax.Subst.fst"
let _35_186 = t
in (let _127_101 = (subst' s t.FStar_Syntax_Syntax.result_typ)
in (let _127_100 = (FStar_List.map (fun _35_190 -> (match (_35_190) with
| (t, imp) -> begin
(let _127_98 = (subst' s t)
in ((_127_98), (imp)))
end)) t.FStar_Syntax_Syntax.effect_args)
in (let _127_99 = (subst_flags' s t.FStar_Syntax_Syntax.flags)
in {FStar_Syntax_Syntax.effect_name = _35_186.FStar_Syntax_Syntax.effect_name; FStar_Syntax_Syntax.result_typ = _127_101; FStar_Syntax_Syntax.effect_args = _127_100; FStar_Syntax_Syntax.flags = _127_99}))))
end))
and subst_comp' : FStar_Syntax_Syntax.subst_elt Prims.list Prims.list  ->  (FStar_Syntax_Syntax.comp', Prims.unit) FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.comp', Prims.unit) FStar_Syntax_Syntax.syntax = (fun s t -> (match (s) with
| ([]) | (([])::[]) -> begin
t
end
| _35_197 -> begin
(match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (t) -> begin
(let _127_104 = (subst' s t)
in (FStar_Syntax_Syntax.mk_Total _127_104))
end
| FStar_Syntax_Syntax.GTotal (t) -> begin
(let _127_105 = (subst' s t)
in (FStar_Syntax_Syntax.mk_GTotal _127_105))
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
(let _127_106 = (subst_comp_typ' s ct)
in (FStar_Syntax_Syntax.mk_Comp _127_106))
end)
end))
and compose_subst : FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.subst_ts  ->  FStar_Syntax_Syntax.subst_elt Prims.list Prims.list = (fun s1 s2 -> (FStar_List.append s1 s2))

# 196 "FStar.Syntax.Subst.fst"
let shift : Prims.int  ->  FStar_Syntax_Syntax.subst_elt  ->  FStar_Syntax_Syntax.subst_elt = (fun n s -> (match (s) with
| FStar_Syntax_Syntax.DB (i, t) -> begin
FStar_Syntax_Syntax.DB ((((i + n)), (t)))
end
| FStar_Syntax_Syntax.UN (i, t) -> begin
FStar_Syntax_Syntax.UN ((((i + n)), (t)))
end
| FStar_Syntax_Syntax.NM (x, i) -> begin
FStar_Syntax_Syntax.NM (((x), ((i + n))))
end
| FStar_Syntax_Syntax.UD (x, i) -> begin
FStar_Syntax_Syntax.UD (((x), ((i + n))))
end
| FStar_Syntax_Syntax.NT (_35_225) -> begin
s
end))

# 203 "FStar.Syntax.Subst.fst"
let shift_subst : Prims.int  ->  FStar_Syntax_Syntax.subst_t  ->  FStar_Syntax_Syntax.subst_t = (fun n s -> (FStar_List.map (shift n) s))

# 204 "FStar.Syntax.Subst.fst"
let shift_subst' : Prims.int  ->  FStar_Syntax_Syntax.subst_t Prims.list  ->  FStar_Syntax_Syntax.subst_t Prims.list = (fun n s -> (FStar_All.pipe_right s (FStar_List.map (shift_subst n))))

# 205 "FStar.Syntax.Subst.fst"
let subst_binder' = (fun s _35_234 -> (match (_35_234) with
| (x, imp) -> begin
(let _127_124 = (
# 206 "FStar.Syntax.Subst.fst"
let _35_235 = x
in (let _127_123 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_235.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_235.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_123}))
in ((_127_124), (imp)))
end))

# 206 "FStar.Syntax.Subst.fst"
let subst_binders' = (fun s bs -> (FStar_All.pipe_right bs (FStar_List.mapi (fun i b -> if (i = 0) then begin
(subst_binder' s b)
end else begin
(let _127_129 = (shift_subst' i s)
in (subst_binder' _127_129 b))
end))))

# 212 "FStar.Syntax.Subst.fst"
let subst_binders : FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.binders = (fun s bs -> (subst_binders' ((s)::[]) bs))

# 213 "FStar.Syntax.Subst.fst"
let subst_arg' = (fun s _35_246 -> (match (_35_246) with
| (t, imp) -> begin
(let _127_136 = (subst' s t)
in ((_127_136), (imp)))
end))

# 214 "FStar.Syntax.Subst.fst"
let subst_args' = (fun s -> (FStar_List.map (subst_arg' s)))

# 215 "FStar.Syntax.Subst.fst"
let subst_pat' : FStar_Syntax_Syntax.subst_t Prims.list  ->  (FStar_Syntax_Syntax.pat', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.withinfo_t  ->  (FStar_Syntax_Syntax.pat * Prims.int) = (fun s p -> (
# 217 "FStar.Syntax.Subst.fst"
let rec aux = (fun n p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible: empty disjunction")
end
| FStar_Syntax_Syntax.Pat_constant (_35_256) -> begin
((p), (n))
end
| FStar_Syntax_Syntax.Pat_disj ((p)::ps) -> begin
(
# 223 "FStar.Syntax.Subst.fst"
let _35_264 = (aux n p)
in (match (_35_264) with
| (p, m) -> begin
(
# 224 "FStar.Syntax.Subst.fst"
let ps = (FStar_List.map (fun p -> (let _127_149 = (aux n p)
in (Prims.fst _127_149))) ps)
in (((
# 225 "FStar.Syntax.Subst.fst"
let _35_267 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_disj ((p)::ps); FStar_Syntax_Syntax.ty = _35_267.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_267.FStar_Syntax_Syntax.p})), (m)))
end))
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 228 "FStar.Syntax.Subst.fst"
let _35_284 = (FStar_All.pipe_right pats (FStar_List.fold_left (fun _35_275 _35_278 -> (match (((_35_275), (_35_278))) with
| ((pats, n), (p, imp)) -> begin
(
# 229 "FStar.Syntax.Subst.fst"
let _35_281 = (aux n p)
in (match (_35_281) with
| (p, m) -> begin
(((((p), (imp)))::pats), (m))
end))
end)) (([]), (n))))
in (match (_35_284) with
| (pats, n) -> begin
(((
# 231 "FStar.Syntax.Subst.fst"
let _35_285 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_cons (((fv), ((FStar_List.rev pats)))); FStar_Syntax_Syntax.ty = _35_285.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_285.FStar_Syntax_Syntax.p})), (n))
end))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 234 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 235 "FStar.Syntax.Subst.fst"
let x = (
# 235 "FStar.Syntax.Subst.fst"
let _35_290 = x
in (let _127_152 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_290.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_290.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_152}))
in (((
# 236 "FStar.Syntax.Subst.fst"
let _35_293 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (x); FStar_Syntax_Syntax.ty = _35_293.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_293.FStar_Syntax_Syntax.p})), ((n + 1)))))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 239 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 240 "FStar.Syntax.Subst.fst"
let x = (
# 240 "FStar.Syntax.Subst.fst"
let _35_298 = x
in (let _127_153 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_298.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_298.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_153}))
in (((
# 241 "FStar.Syntax.Subst.fst"
let _35_301 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x); FStar_Syntax_Syntax.ty = _35_301.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_301.FStar_Syntax_Syntax.p})), ((n + 1)))))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 244 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 245 "FStar.Syntax.Subst.fst"
let x = (
# 245 "FStar.Syntax.Subst.fst"
let _35_308 = x
in (let _127_154 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_308.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_308.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_154}))
in (
# 246 "FStar.Syntax.Subst.fst"
let t0 = (subst' s t0)
in (((
# 247 "FStar.Syntax.Subst.fst"
let _35_312 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term (((x), (t0))); FStar_Syntax_Syntax.ty = _35_312.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_312.FStar_Syntax_Syntax.p})), (n)))))
end))
in (aux 0 p)))

# 248 "FStar.Syntax.Subst.fst"
let push_subst_lcomp = (fun s lopt -> (match (lopt) with
| (None) | (Some (FStar_Util.Inr (_))) -> begin
lopt
end
| Some (FStar_Util.Inl (l)) -> begin
(let _127_161 = (let _127_160 = (
# 254 "FStar.Syntax.Subst.fst"
let _35_324 = l
in (let _127_159 = (subst' s l.FStar_Syntax_Syntax.res_typ)
in {FStar_Syntax_Syntax.eff_name = _35_324.FStar_Syntax_Syntax.eff_name; FStar_Syntax_Syntax.res_typ = _127_159; FStar_Syntax_Syntax.cflags = _35_324.FStar_Syntax_Syntax.cflags; FStar_Syntax_Syntax.comp = (fun _35_326 -> (match (()) with
| () -> begin
(let _127_158 = (l.FStar_Syntax_Syntax.comp ())
in (subst_comp' s _127_158))
end))}))
in FStar_Util.Inl (_127_160))
in Some (_127_161))
end))

# 255 "FStar.Syntax.Subst.fst"
let push_subst : FStar_Syntax_Syntax.subst_ts  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun s t -> (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (_35_330) -> begin
(FStar_All.failwith "Impossible")
end
| (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) | (FStar_Syntax_Syntax.Tm_unknown) | (FStar_Syntax_Syntax.Tm_uvar (_)) -> begin
t
end
| (FStar_Syntax_Syntax.Tm_type (_)) | (FStar_Syntax_Syntax.Tm_bvar (_)) | (FStar_Syntax_Syntax.Tm_name (_)) -> begin
(subst' s t)
end
| FStar_Syntax_Syntax.Tm_uinst (t', us) -> begin
(
# 273 "FStar.Syntax.Subst.fst"
let us = (FStar_List.map (subst_univ s) us)
in (FStar_Syntax_Syntax.mk_Tm_uinst t' us))
end
| FStar_Syntax_Syntax.Tm_app (t0, args) -> begin
(let _127_172 = (let _127_171 = (let _127_170 = (subst' s t0)
in (let _127_169 = (subst_args' s args)
in ((_127_170), (_127_169))))
in FStar_Syntax_Syntax.Tm_app (_127_171))
in (FStar_Syntax_Syntax.mk _127_172 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_ascribed (t0, FStar_Util.Inl (t1), lopt) -> begin
(let _127_177 = (let _127_176 = (let _127_175 = (subst' s t0)
in (let _127_174 = (let _127_173 = (subst' s t1)
in FStar_Util.Inl (_127_173))
in ((_127_175), (_127_174), (lopt))))
in FStar_Syntax_Syntax.Tm_ascribed (_127_176))
in (FStar_Syntax_Syntax.mk _127_177 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_ascribed (t0, FStar_Util.Inr (c), lopt) -> begin
(let _127_182 = (let _127_181 = (let _127_180 = (subst' s t0)
in (let _127_179 = (let _127_178 = (subst_comp' s c)
in FStar_Util.Inr (_127_178))
in ((_127_180), (_127_179), (lopt))))
in FStar_Syntax_Syntax.Tm_ascribed (_127_181))
in (FStar_Syntax_Syntax.mk _127_182 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_abs (bs, body, lopt) -> begin
(
# 282 "FStar.Syntax.Subst.fst"
let n = (FStar_List.length bs)
in (
# 283 "FStar.Syntax.Subst.fst"
let s' = (shift_subst' n s)
in (let _127_187 = (let _127_186 = (let _127_185 = (subst_binders' s bs)
in (let _127_184 = (subst' s' body)
in (let _127_183 = (push_subst_lcomp s' lopt)
in ((_127_185), (_127_184), (_127_183)))))
in FStar_Syntax_Syntax.Tm_abs (_127_186))
in (FStar_Syntax_Syntax.mk _127_187 None t.FStar_Syntax_Syntax.pos))))
end
| FStar_Syntax_Syntax.Tm_arrow (bs, comp) -> begin
(
# 287 "FStar.Syntax.Subst.fst"
let n = (FStar_List.length bs)
in (let _127_192 = (let _127_191 = (let _127_190 = (subst_binders' s bs)
in (let _127_189 = (let _127_188 = (shift_subst' n s)
in (subst_comp' _127_188 comp))
in ((_127_190), (_127_189))))
in FStar_Syntax_Syntax.Tm_arrow (_127_191))
in (FStar_Syntax_Syntax.mk _127_192 None t.FStar_Syntax_Syntax.pos)))
end
| FStar_Syntax_Syntax.Tm_refine (x, phi) -> begin
(
# 291 "FStar.Syntax.Subst.fst"
let x = (
# 291 "FStar.Syntax.Subst.fst"
let _35_388 = x
in (let _127_193 = (subst' s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_388.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_388.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_193}))
in (
# 292 "FStar.Syntax.Subst.fst"
let phi = (let _127_194 = (shift_subst' 1 s)
in (subst' _127_194 phi))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_refine (((x), (phi)))) None t.FStar_Syntax_Syntax.pos)))
end
| FStar_Syntax_Syntax.Tm_match (t0, pats) -> begin
(
# 296 "FStar.Syntax.Subst.fst"
let t0 = (subst' s t0)
in (
# 297 "FStar.Syntax.Subst.fst"
let pats = (FStar_All.pipe_right pats (FStar_List.map (fun _35_400 -> (match (_35_400) with
| (pat, wopt, branch) -> begin
(
# 298 "FStar.Syntax.Subst.fst"
let _35_403 = (subst_pat' s pat)
in (match (_35_403) with
| (pat, n) -> begin
(
# 299 "FStar.Syntax.Subst.fst"
let s = (shift_subst' n s)
in (
# 300 "FStar.Syntax.Subst.fst"
let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _127_196 = (subst' s w)
in Some (_127_196))
end)
in (
# 303 "FStar.Syntax.Subst.fst"
let branch = (subst' s branch)
in ((pat), (wopt), (branch)))))
end))
end))))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_match (((t0), (pats)))) None t.FStar_Syntax_Syntax.pos)))
end
| FStar_Syntax_Syntax.Tm_let ((is_rec, lbs), body) -> begin
(
# 308 "FStar.Syntax.Subst.fst"
let n = (FStar_List.length lbs)
in (
# 309 "FStar.Syntax.Subst.fst"
let sn = (shift_subst' n s)
in (
# 310 "FStar.Syntax.Subst.fst"
let body = (subst' sn body)
in (
# 311 "FStar.Syntax.Subst.fst"
let lbs = (FStar_All.pipe_right lbs (FStar_List.map (fun lb -> (
# 312 "FStar.Syntax.Subst.fst"
let lbt = (subst' s lb.FStar_Syntax_Syntax.lbtyp)
in (
# 313 "FStar.Syntax.Subst.fst"
let lbd = if (is_rec && (FStar_Util.is_left lb.FStar_Syntax_Syntax.lbname)) then begin
(subst' sn lb.FStar_Syntax_Syntax.lbdef)
end else begin
(subst' s lb.FStar_Syntax_Syntax.lbdef)
end
in (
# 316 "FStar.Syntax.Subst.fst"
let lbname = (match (lb.FStar_Syntax_Syntax.lbname) with
| FStar_Util.Inl (x) -> begin
FStar_Util.Inl ((
# 317 "FStar.Syntax.Subst.fst"
let _35_425 = x
in {FStar_Syntax_Syntax.ppname = _35_425.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_425.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = lbt}))
end
| FStar_Util.Inr (fv) -> begin
FStar_Util.Inr ((
# 318 "FStar.Syntax.Subst.fst"
let _35_429 = fv
in {FStar_Syntax_Syntax.fv_name = (
# 318 "FStar.Syntax.Subst.fst"
let _35_431 = fv.FStar_Syntax_Syntax.fv_name
in {FStar_Syntax_Syntax.v = _35_431.FStar_Syntax_Syntax.v; FStar_Syntax_Syntax.ty = lbt; FStar_Syntax_Syntax.p = _35_431.FStar_Syntax_Syntax.p}); FStar_Syntax_Syntax.fv_delta = _35_429.FStar_Syntax_Syntax.fv_delta; FStar_Syntax_Syntax.fv_qual = _35_429.FStar_Syntax_Syntax.fv_qual}))
end)
in (
# 319 "FStar.Syntax.Subst.fst"
let _35_434 = lb
in {FStar_Syntax_Syntax.lbname = lbname; FStar_Syntax_Syntax.lbunivs = _35_434.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = lbt; FStar_Syntax_Syntax.lbeff = _35_434.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = lbd})))))))
in (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_let (((((is_rec), (lbs))), (body)))) None t.FStar_Syntax_Syntax.pos)))))
end
| FStar_Syntax_Syntax.Tm_meta (t0, FStar_Syntax_Syntax.Meta_pattern (ps)) -> begin
(let _127_202 = (let _127_201 = (let _127_200 = (subst' s t0)
in (let _127_199 = (let _127_198 = (FStar_All.pipe_right ps (FStar_List.map (subst_args' s)))
in FStar_Syntax_Syntax.Meta_pattern (_127_198))
in ((_127_200), (_127_199))))
in FStar_Syntax_Syntax.Tm_meta (_127_201))
in (FStar_Syntax_Syntax.mk _127_202 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_meta (t0, FStar_Syntax_Syntax.Meta_monadic (m, t)) -> begin
(let _127_208 = (let _127_207 = (let _127_206 = (subst' s t0)
in (let _127_205 = (let _127_204 = (let _127_203 = (subst' s t)
in ((m), (_127_203)))
in FStar_Syntax_Syntax.Meta_monadic (_127_204))
in ((_127_206), (_127_205))))
in FStar_Syntax_Syntax.Tm_meta (_127_207))
in (FStar_Syntax_Syntax.mk _127_208 None t.FStar_Syntax_Syntax.pos))
end
| FStar_Syntax_Syntax.Tm_meta (t, m) -> begin
(let _127_211 = (let _127_210 = (let _127_209 = (subst' s t)
in ((_127_209), (m)))
in FStar_Syntax_Syntax.Tm_meta (_127_210))
in (FStar_Syntax_Syntax.mk _127_211 None t.FStar_Syntax_Syntax.pos))
end))

# 329 "FStar.Syntax.Subst.fst"
let rec compress : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun t -> (
# 332 "FStar.Syntax.Subst.fst"
let t = (force_delayed_thunk t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (FStar_Util.Inl (t, s), memo) -> begin
(
# 335 "FStar.Syntax.Subst.fst"
let t' = (let _127_214 = (push_subst s t)
in (compress _127_214))
in (
# 336 "FStar.Syntax.Subst.fst"
let _35_463 = (FStar_Unionfind.update_in_tx memo (Some (t')))
in t'))
end
| _35_466 -> begin
(force_uvar t)
end)))

# 339 "FStar.Syntax.Subst.fst"
let subst : FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun s t -> (subst' ((s)::[]) t))

# 342 "FStar.Syntax.Subst.fst"
let subst_comp : FStar_Syntax_Syntax.subst_elt Prims.list  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun s t -> (subst_comp' ((s)::[]) t))

# 343 "FStar.Syntax.Subst.fst"
let closing_subst = (fun bs -> (let _127_226 = (FStar_List.fold_right (fun _35_475 _35_478 -> (match (((_35_475), (_35_478))) with
| ((x, _35_474), (subst, n)) -> begin
(((FStar_Syntax_Syntax.NM (((x), (n))))::subst), ((n + 1)))
end)) bs (([]), (0)))
in (FStar_All.pipe_right _127_226 Prims.fst)))

# 345 "FStar.Syntax.Subst.fst"
let open_binders' = (fun bs -> (
# 347 "FStar.Syntax.Subst.fst"
let rec aux = (fun bs o -> (match (bs) with
| [] -> begin
(([]), (o))
end
| ((x, imp))::bs' -> begin
(
# 350 "FStar.Syntax.Subst.fst"
let x' = (
# 350 "FStar.Syntax.Subst.fst"
let _35_489 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _127_232 = (subst o x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_489.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_489.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_232}))
in (
# 351 "FStar.Syntax.Subst.fst"
let o = (let _127_233 = (shift_subst 1 o)
in (FStar_Syntax_Syntax.DB (((0), (x'))))::_127_233)
in (
# 352 "FStar.Syntax.Subst.fst"
let _35_495 = (aux bs' o)
in (match (_35_495) with
| (bs', o) -> begin
(((((x'), (imp)))::bs'), (o))
end))))
end))
in (aux bs [])))

# 354 "FStar.Syntax.Subst.fst"
let open_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.binders = (fun bs -> (let _127_236 = (open_binders' bs)
in (Prims.fst _127_236)))

# 355 "FStar.Syntax.Subst.fst"
let open_term' : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.subst_t) = (fun bs t -> (
# 357 "FStar.Syntax.Subst.fst"
let _35_501 = (open_binders' bs)
in (match (_35_501) with
| (bs', opening) -> begin
(let _127_241 = (subst opening t)
in ((bs'), (_127_241), (opening)))
end)))

# 358 "FStar.Syntax.Subst.fst"
let open_term : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.term) = (fun bs t -> (
# 360 "FStar.Syntax.Subst.fst"
let _35_508 = (open_term' bs t)
in (match (_35_508) with
| (b, t, _35_507) -> begin
((b), (t))
end)))

# 361 "FStar.Syntax.Subst.fst"
let open_comp : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.comp  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.comp) = (fun bs t -> (
# 363 "FStar.Syntax.Subst.fst"
let _35_513 = (open_binders' bs)
in (match (_35_513) with
| (bs', opening) -> begin
(let _127_250 = (subst_comp opening t)
in ((bs'), (_127_250)))
end)))

# 364 "FStar.Syntax.Subst.fst"
let open_pat : FStar_Syntax_Syntax.pat  ->  (FStar_Syntax_Syntax.pat * FStar_Syntax_Syntax.subst_t) = (fun p -> (
# 368 "FStar.Syntax.Subst.fst"
let rec aux_disj = (fun sub renaming p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj (_35_520) -> begin
(FStar_All.failwith "impossible")
end
| FStar_Syntax_Syntax.Pat_constant (_35_523) -> begin
p
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 375 "FStar.Syntax.Subst.fst"
let _35_529 = p
in (let _127_263 = (let _127_262 = (let _127_261 = (FStar_All.pipe_right pats (FStar_List.map (fun _35_533 -> (match (_35_533) with
| (p, b) -> begin
(let _127_260 = (aux_disj sub renaming p)
in ((_127_260), (b)))
end))))
in ((fv), (_127_261)))
in FStar_Syntax_Syntax.Pat_cons (_127_262))
in {FStar_Syntax_Syntax.v = _127_263; FStar_Syntax_Syntax.ty = _35_529.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_529.FStar_Syntax_Syntax.p}))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 379 "FStar.Syntax.Subst.fst"
let yopt = (FStar_Util.find_map renaming (fun _35_7 -> (match (_35_7) with
| (x', y) when (x.FStar_Syntax_Syntax.ppname.FStar_Ident.idText = x'.FStar_Syntax_Syntax.ppname.FStar_Ident.idText) -> begin
Some (y)
end
| _35_541 -> begin
None
end)))
in (
# 382 "FStar.Syntax.Subst.fst"
let y = (match (yopt) with
| None -> begin
(
# 383 "FStar.Syntax.Subst.fst"
let _35_544 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _127_265 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_544.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_544.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_265}))
end
| Some (y) -> begin
y
end)
in (
# 385 "FStar.Syntax.Subst.fst"
let _35_549 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (y); FStar_Syntax_Syntax.ty = _35_549.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_549.FStar_Syntax_Syntax.p})))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 388 "FStar.Syntax.Subst.fst"
let x' = (
# 388 "FStar.Syntax.Subst.fst"
let _35_553 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _127_266 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_553.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_553.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_266}))
in (
# 389 "FStar.Syntax.Subst.fst"
let _35_556 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x'); FStar_Syntax_Syntax.ty = _35_556.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_556.FStar_Syntax_Syntax.p}))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 392 "FStar.Syntax.Subst.fst"
let x = (
# 392 "FStar.Syntax.Subst.fst"
let _35_562 = x
in (let _127_267 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_562.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_562.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_267}))
in (
# 393 "FStar.Syntax.Subst.fst"
let t0 = (subst sub t0)
in (
# 394 "FStar.Syntax.Subst.fst"
let _35_566 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term (((x), (t0))); FStar_Syntax_Syntax.ty = _35_566.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_566.FStar_Syntax_Syntax.p})))
end))
in (
# 396 "FStar.Syntax.Subst.fst"
let rec aux = (fun sub renaming p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible: empty disjunction")
end
| FStar_Syntax_Syntax.Pat_constant (_35_575) -> begin
((p), (sub), (renaming))
end
| FStar_Syntax_Syntax.Pat_disj ((p)::ps) -> begin
(
# 402 "FStar.Syntax.Subst.fst"
let _35_584 = (aux sub renaming p)
in (match (_35_584) with
| (p, sub, renaming) -> begin
(
# 403 "FStar.Syntax.Subst.fst"
let ps = (FStar_List.map (aux_disj sub renaming) ps)
in (((
# 404 "FStar.Syntax.Subst.fst"
let _35_586 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_disj ((p)::ps); FStar_Syntax_Syntax.ty = _35_586.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_586.FStar_Syntax_Syntax.p})), (sub), (renaming)))
end))
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 407 "FStar.Syntax.Subst.fst"
let _35_606 = (FStar_All.pipe_right pats (FStar_List.fold_left (fun _35_595 _35_598 -> (match (((_35_595), (_35_598))) with
| ((pats, sub, renaming), (p, imp)) -> begin
(
# 408 "FStar.Syntax.Subst.fst"
let _35_602 = (aux sub renaming p)
in (match (_35_602) with
| (p, sub, renaming) -> begin
(((((p), (imp)))::pats), (sub), (renaming))
end))
end)) (([]), (sub), (renaming))))
in (match (_35_606) with
| (pats, sub, renaming) -> begin
(((
# 410 "FStar.Syntax.Subst.fst"
let _35_607 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_cons (((fv), ((FStar_List.rev pats)))); FStar_Syntax_Syntax.ty = _35_607.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_607.FStar_Syntax_Syntax.p})), (sub), (renaming))
end))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 413 "FStar.Syntax.Subst.fst"
let x' = (
# 413 "FStar.Syntax.Subst.fst"
let _35_611 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _127_276 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_611.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_611.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_276}))
in (
# 414 "FStar.Syntax.Subst.fst"
let sub = (let _127_277 = (shift_subst 1 sub)
in (FStar_Syntax_Syntax.DB (((0), (x'))))::_127_277)
in (((
# 415 "FStar.Syntax.Subst.fst"
let _35_615 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (x'); FStar_Syntax_Syntax.ty = _35_615.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_615.FStar_Syntax_Syntax.p})), (sub), ((((x), (x')))::renaming))))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 418 "FStar.Syntax.Subst.fst"
let x' = (
# 418 "FStar.Syntax.Subst.fst"
let _35_619 = (FStar_Syntax_Syntax.freshen_bv x)
in (let _127_278 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_619.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_619.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_278}))
in (
# 419 "FStar.Syntax.Subst.fst"
let sub = (let _127_279 = (shift_subst 1 sub)
in (FStar_Syntax_Syntax.DB (((0), (x'))))::_127_279)
in (((
# 420 "FStar.Syntax.Subst.fst"
let _35_623 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x'); FStar_Syntax_Syntax.ty = _35_623.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_623.FStar_Syntax_Syntax.p})), (sub), ((((x), (x')))::renaming))))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 423 "FStar.Syntax.Subst.fst"
let x = (
# 423 "FStar.Syntax.Subst.fst"
let _35_629 = x
in (let _127_280 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_629.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_629.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_280}))
in (
# 424 "FStar.Syntax.Subst.fst"
let t0 = (subst sub t0)
in (((
# 425 "FStar.Syntax.Subst.fst"
let _35_633 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term (((x), (t0))); FStar_Syntax_Syntax.ty = _35_633.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_633.FStar_Syntax_Syntax.p})), (sub), (renaming))))
end))
in (
# 427 "FStar.Syntax.Subst.fst"
let _35_639 = (aux [] [] p)
in (match (_35_639) with
| (p, sub, _35_638) -> begin
((p), (sub))
end)))))

# 428 "FStar.Syntax.Subst.fst"
let open_branch : FStar_Syntax_Syntax.branch  ->  FStar_Syntax_Syntax.branch = (fun _35_643 -> (match (_35_643) with
| (p, wopt, e) -> begin
(
# 431 "FStar.Syntax.Subst.fst"
let _35_646 = (open_pat p)
in (match (_35_646) with
| (p, opening) -> begin
(
# 432 "FStar.Syntax.Subst.fst"
let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _127_283 = (subst opening w)
in Some (_127_283))
end)
in (
# 435 "FStar.Syntax.Subst.fst"
let e = (subst opening e)
in ((p), (wopt), (e))))
end))
end))

# 436 "FStar.Syntax.Subst.fst"
let close : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun bs t -> (let _127_288 = (closing_subst bs)
in (subst _127_288 t)))

# 438 "FStar.Syntax.Subst.fst"
let close_comp : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun bs c -> (let _127_293 = (closing_subst bs)
in (subst_comp _127_293 c)))

# 439 "FStar.Syntax.Subst.fst"
let close_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.binders = (fun bs -> (
# 441 "FStar.Syntax.Subst.fst"
let rec aux = (fun s bs -> (match (bs) with
| [] -> begin
[]
end
| ((x, imp))::tl -> begin
(
# 444 "FStar.Syntax.Subst.fst"
let x = (
# 444 "FStar.Syntax.Subst.fst"
let _35_666 = x
in (let _127_300 = (subst s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_666.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_666.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_300}))
in (
# 445 "FStar.Syntax.Subst.fst"
let s' = (let _127_301 = (shift_subst 1 s)
in (FStar_Syntax_Syntax.NM (((x), (0))))::_127_301)
in (let _127_302 = (aux s' tl)
in (((x), (imp)))::_127_302)))
end))
in (aux [] bs)))

# 447 "FStar.Syntax.Subst.fst"
let close_lcomp : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.lcomp  ->  FStar_Syntax_Syntax.lcomp = (fun bs lc -> (
# 450 "FStar.Syntax.Subst.fst"
let s = (closing_subst bs)
in (
# 451 "FStar.Syntax.Subst.fst"
let _35_673 = lc
in (let _127_309 = (subst s lc.FStar_Syntax_Syntax.res_typ)
in {FStar_Syntax_Syntax.eff_name = _35_673.FStar_Syntax_Syntax.eff_name; FStar_Syntax_Syntax.res_typ = _127_309; FStar_Syntax_Syntax.cflags = _35_673.FStar_Syntax_Syntax.cflags; FStar_Syntax_Syntax.comp = (fun _35_675 -> (match (()) with
| () -> begin
(let _127_308 = (lc.FStar_Syntax_Syntax.comp ())
in (subst_comp s _127_308))
end))}))))

# 452 "FStar.Syntax.Subst.fst"
let close_pat : (FStar_Syntax_Syntax.pat', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.withinfo_t  ->  ((FStar_Syntax_Syntax.pat', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.withinfo_t * FStar_Syntax_Syntax.subst_elt Prims.list) = (fun p -> (
# 455 "FStar.Syntax.Subst.fst"
let rec aux = (fun sub p -> (match (p.FStar_Syntax_Syntax.v) with
| FStar_Syntax_Syntax.Pat_disj ([]) -> begin
(FStar_All.failwith "Impossible: empty disjunction")
end
| FStar_Syntax_Syntax.Pat_constant (_35_683) -> begin
((p), (sub))
end
| FStar_Syntax_Syntax.Pat_disj ((p)::ps) -> begin
(
# 461 "FStar.Syntax.Subst.fst"
let _35_691 = (aux sub p)
in (match (_35_691) with
| (p, sub) -> begin
(
# 462 "FStar.Syntax.Subst.fst"
let ps = (FStar_List.map (fun p -> (let _127_317 = (aux sub p)
in (Prims.fst _127_317))) ps)
in (((
# 463 "FStar.Syntax.Subst.fst"
let _35_694 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_disj ((p)::ps); FStar_Syntax_Syntax.ty = _35_694.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_694.FStar_Syntax_Syntax.p})), (sub)))
end))
end
| FStar_Syntax_Syntax.Pat_cons (fv, pats) -> begin
(
# 466 "FStar.Syntax.Subst.fst"
let _35_711 = (FStar_All.pipe_right pats (FStar_List.fold_left (fun _35_702 _35_705 -> (match (((_35_702), (_35_705))) with
| ((pats, sub), (p, imp)) -> begin
(
# 467 "FStar.Syntax.Subst.fst"
let _35_708 = (aux sub p)
in (match (_35_708) with
| (p, sub) -> begin
(((((p), (imp)))::pats), (sub))
end))
end)) (([]), (sub))))
in (match (_35_711) with
| (pats, sub) -> begin
(((
# 469 "FStar.Syntax.Subst.fst"
let _35_712 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_cons (((fv), ((FStar_List.rev pats)))); FStar_Syntax_Syntax.ty = _35_712.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_712.FStar_Syntax_Syntax.p})), (sub))
end))
end
| FStar_Syntax_Syntax.Pat_var (x) -> begin
(
# 472 "FStar.Syntax.Subst.fst"
let x = (
# 472 "FStar.Syntax.Subst.fst"
let _35_716 = x
in (let _127_320 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_716.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_716.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_320}))
in (
# 473 "FStar.Syntax.Subst.fst"
let sub = (let _127_321 = (shift_subst 1 sub)
in (FStar_Syntax_Syntax.NM (((x), (0))))::_127_321)
in (((
# 474 "FStar.Syntax.Subst.fst"
let _35_720 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var (x); FStar_Syntax_Syntax.ty = _35_720.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_720.FStar_Syntax_Syntax.p})), (sub))))
end
| FStar_Syntax_Syntax.Pat_wild (x) -> begin
(
# 477 "FStar.Syntax.Subst.fst"
let x = (
# 477 "FStar.Syntax.Subst.fst"
let _35_724 = x
in (let _127_322 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_724.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_724.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_322}))
in (
# 478 "FStar.Syntax.Subst.fst"
let sub = (let _127_323 = (shift_subst 1 sub)
in (FStar_Syntax_Syntax.NM (((x), (0))))::_127_323)
in (((
# 479 "FStar.Syntax.Subst.fst"
let _35_728 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild (x); FStar_Syntax_Syntax.ty = _35_728.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_728.FStar_Syntax_Syntax.p})), (sub))))
end
| FStar_Syntax_Syntax.Pat_dot_term (x, t0) -> begin
(
# 482 "FStar.Syntax.Subst.fst"
let x = (
# 482 "FStar.Syntax.Subst.fst"
let _35_734 = x
in (let _127_324 = (subst sub x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _35_734.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _35_734.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _127_324}))
in (
# 483 "FStar.Syntax.Subst.fst"
let t0 = (subst sub t0)
in (((
# 484 "FStar.Syntax.Subst.fst"
let _35_738 = p
in {FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_dot_term (((x), (t0))); FStar_Syntax_Syntax.ty = _35_738.FStar_Syntax_Syntax.ty; FStar_Syntax_Syntax.p = _35_738.FStar_Syntax_Syntax.p})), (sub))))
end))
in (aux [] p)))

# 485 "FStar.Syntax.Subst.fst"
let close_branch : FStar_Syntax_Syntax.branch  ->  FStar_Syntax_Syntax.branch = (fun _35_743 -> (match (_35_743) with
| (p, wopt, e) -> begin
(
# 488 "FStar.Syntax.Subst.fst"
let _35_746 = (close_pat p)
in (match (_35_746) with
| (p, closing) -> begin
(
# 489 "FStar.Syntax.Subst.fst"
let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _127_327 = (subst closing w)
in Some (_127_327))
end)
in (
# 492 "FStar.Syntax.Subst.fst"
let e = (subst closing e)
in ((p), (wopt), (e))))
end))
end))

# 493 "FStar.Syntax.Subst.fst"
let univ_var_opening : FStar_Syntax_Syntax.univ_names  ->  (FStar_Syntax_Syntax.subst_elt Prims.list * FStar_Syntax_Syntax.univ_name Prims.list) = (fun us -> (
# 496 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 497 "FStar.Syntax.Subst.fst"
let _35_759 = (let _127_332 = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> (
# 498 "FStar.Syntax.Subst.fst"
let u' = (FStar_Syntax_Syntax.new_univ_name (Some (u.FStar_Ident.idRange)))
in ((FStar_Syntax_Syntax.UN ((((n - i)), (FStar_Syntax_Syntax.U_name (u'))))), (u'))))))
in (FStar_All.pipe_right _127_332 FStar_List.unzip))
in (match (_35_759) with
| (s, us') -> begin
((s), (us'))
end))))

# 500 "FStar.Syntax.Subst.fst"
let open_univ_vars : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.univ_names * FStar_Syntax_Syntax.term) = (fun us t -> (
# 503 "FStar.Syntax.Subst.fst"
let _35_764 = (univ_var_opening us)
in (match (_35_764) with
| (s, us') -> begin
(
# 504 "FStar.Syntax.Subst.fst"
let t = (subst s t)
in ((us'), (t)))
end)))

# 505 "FStar.Syntax.Subst.fst"
let open_univ_vars_comp : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.comp  ->  (FStar_Syntax_Syntax.univ_names * FStar_Syntax_Syntax.comp) = (fun us c -> (
# 508 "FStar.Syntax.Subst.fst"
let _35_770 = (univ_var_opening us)
in (match (_35_770) with
| (s, us') -> begin
(let _127_341 = (subst_comp s c)
in ((us'), (_127_341)))
end)))

# 509 "FStar.Syntax.Subst.fst"
let close_univ_vars : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun us t -> (
# 512 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 513 "FStar.Syntax.Subst.fst"
let s = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> FStar_Syntax_Syntax.UD (((u), ((n - i)))))))
in (subst s t))))

# 514 "FStar.Syntax.Subst.fst"
let close_univ_vars_comp : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun us c -> (
# 517 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 518 "FStar.Syntax.Subst.fst"
let s = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> FStar_Syntax_Syntax.UD (((u), ((n - i)))))))
in (subst_comp s c))))

# 519 "FStar.Syntax.Subst.fst"
let open_let_rec : FStar_Syntax_Syntax.letbinding Prims.list  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.letbinding Prims.list * FStar_Syntax_Syntax.term) = (fun lbs t -> if (FStar_Syntax_Syntax.is_top_level lbs) then begin
((lbs), (t))
end else begin
(
# 538 "FStar.Syntax.Subst.fst"
let _35_796 = (FStar_List.fold_right (fun lb _35_789 -> (match (_35_789) with
| (i, lbs, out) -> begin
(
# 540 "FStar.Syntax.Subst.fst"
let x = (let _127_360 = (FStar_Util.left lb.FStar_Syntax_Syntax.lbname)
in (FStar_Syntax_Syntax.freshen_bv _127_360))
in (((i + 1)), (((
# 541 "FStar.Syntax.Subst.fst"
let _35_791 = lb
in {FStar_Syntax_Syntax.lbname = FStar_Util.Inl (x); FStar_Syntax_Syntax.lbunivs = _35_791.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = _35_791.FStar_Syntax_Syntax.lbtyp; FStar_Syntax_Syntax.lbeff = _35_791.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = _35_791.FStar_Syntax_Syntax.lbdef}))::lbs), ((FStar_Syntax_Syntax.DB (((i), (x))))::out)))
end)) lbs ((0), ([]), ([])))
in (match (_35_796) with
| (n_let_recs, lbs, let_rec_opening) -> begin
(
# 543 "FStar.Syntax.Subst.fst"
let lbs = (FStar_All.pipe_right lbs (FStar_List.map (fun lb -> (
# 544 "FStar.Syntax.Subst.fst"
let _35_808 = (FStar_List.fold_right (fun u _35_802 -> (match (_35_802) with
| (i, us, out) -> begin
(
# 546 "FStar.Syntax.Subst.fst"
let u = (FStar_Syntax_Syntax.new_univ_name None)
in (((i + 1)), ((u)::us), ((FStar_Syntax_Syntax.UN (((i), (FStar_Syntax_Syntax.U_name (u)))))::out)))
end)) lb.FStar_Syntax_Syntax.lbunivs ((n_let_recs), ([]), (let_rec_opening)))
in (match (_35_808) with
| (_35_805, us, u_let_rec_opening) -> begin
(
# 549 "FStar.Syntax.Subst.fst"
let _35_809 = lb
in (let _127_364 = (subst u_let_rec_opening lb.FStar_Syntax_Syntax.lbdef)
in {FStar_Syntax_Syntax.lbname = _35_809.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = us; FStar_Syntax_Syntax.lbtyp = _35_809.FStar_Syntax_Syntax.lbtyp; FStar_Syntax_Syntax.lbeff = _35_809.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = _127_364}))
end)))))
in (
# 551 "FStar.Syntax.Subst.fst"
let t = (subst let_rec_opening t)
in ((lbs), (t))))
end))
end)

# 552 "FStar.Syntax.Subst.fst"
let close_let_rec : FStar_Syntax_Syntax.letbinding Prims.list  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.letbinding Prims.list * FStar_Syntax_Syntax.term) = (fun lbs t -> if (FStar_Syntax_Syntax.is_top_level lbs) then begin
((lbs), (t))
end else begin
(
# 556 "FStar.Syntax.Subst.fst"
let _35_821 = (FStar_List.fold_right (fun lb _35_818 -> (match (_35_818) with
| (i, out) -> begin
(let _127_374 = (let _127_373 = (let _127_372 = (let _127_371 = (FStar_Util.left lb.FStar_Syntax_Syntax.lbname)
in ((_127_371), (i)))
in FStar_Syntax_Syntax.NM (_127_372))
in (_127_373)::out)
in (((i + 1)), (_127_374)))
end)) lbs ((0), ([])))
in (match (_35_821) with
| (n_let_recs, let_rec_closing) -> begin
(
# 558 "FStar.Syntax.Subst.fst"
let lbs = (FStar_All.pipe_right lbs (FStar_List.map (fun lb -> (
# 559 "FStar.Syntax.Subst.fst"
let _35_830 = (FStar_List.fold_right (fun u _35_826 -> (match (_35_826) with
| (i, out) -> begin
(((i + 1)), ((FStar_Syntax_Syntax.UD (((u), (i))))::out))
end)) lb.FStar_Syntax_Syntax.lbunivs ((n_let_recs), (let_rec_closing)))
in (match (_35_830) with
| (_35_828, u_let_rec_closing) -> begin
(
# 560 "FStar.Syntax.Subst.fst"
let _35_831 = lb
in (let _127_378 = (subst u_let_rec_closing lb.FStar_Syntax_Syntax.lbdef)
in {FStar_Syntax_Syntax.lbname = _35_831.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _35_831.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = _35_831.FStar_Syntax_Syntax.lbtyp; FStar_Syntax_Syntax.lbeff = _35_831.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = _127_378}))
end)))))
in (
# 561 "FStar.Syntax.Subst.fst"
let t = (subst let_rec_closing t)
in ((lbs), (t))))
end))
end)

# 562 "FStar.Syntax.Subst.fst"
let close_tscheme : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.tscheme  ->  FStar_Syntax_Syntax.tscheme = (fun binders _35_838 -> (match (_35_838) with
| (us, t) -> begin
(
# 565 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length binders) - 1)
in (
# 566 "FStar.Syntax.Subst.fst"
let k = (FStar_List.length us)
in (
# 567 "FStar.Syntax.Subst.fst"
let s = (FStar_List.mapi (fun i _35_845 -> (match (_35_845) with
| (x, _35_844) -> begin
FStar_Syntax_Syntax.NM (((x), ((k + (n - i)))))
end)) binders)
in (
# 568 "FStar.Syntax.Subst.fst"
let t = (subst s t)
in ((us), (t))))))
end))

# 569 "FStar.Syntax.Subst.fst"
let close_univ_vars_tscheme : FStar_Syntax_Syntax.univ_names  ->  FStar_Syntax_Syntax.tscheme  ->  FStar_Syntax_Syntax.tscheme = (fun us _35_851 -> (match (_35_851) with
| (us', t) -> begin
(
# 572 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length us) - 1)
in (
# 573 "FStar.Syntax.Subst.fst"
let k = (FStar_List.length us')
in (
# 574 "FStar.Syntax.Subst.fst"
let s = (FStar_List.mapi (fun i x -> FStar_Syntax_Syntax.UD (((x), ((k + (n - i)))))) us)
in (let _127_391 = (subst s t)
in ((us'), (_127_391))))))
end))

# 575 "FStar.Syntax.Subst.fst"
let opening_of_binders : FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.subst_t = (fun bs -> (
# 578 "FStar.Syntax.Subst.fst"
let n = ((FStar_List.length bs) - 1)
in (FStar_All.pipe_right bs (FStar_List.mapi (fun i _35_863 -> (match (_35_863) with
| (x, _35_862) -> begin
FStar_Syntax_Syntax.DB ((((n - i)), (x)))
end))))))




