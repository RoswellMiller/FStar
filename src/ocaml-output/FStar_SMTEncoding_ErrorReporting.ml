
open Prims
# 23 "FStar.SMTEncoding.ErrorReporting.fst"
type label =
FStar_SMTEncoding_Term.error_label

# 25 "FStar.SMTEncoding.ErrorReporting.fst"
type labels =
FStar_SMTEncoding_Term.error_labels

# 26 "FStar.SMTEncoding.ErrorReporting.fst"
let sort_labels : labels  ->  ((Prims.string * FStar_SMTEncoding_Term.sort) * Prims.string * FStar_Range.range) Prims.list = (fun l -> (FStar_List.sortWith (fun _84_7 _84_13 -> (match (((_84_7), (_84_13))) with
| ((_84_3, _84_5, r1), (_84_9, _84_11, r2)) -> begin
(FStar_Range.compare r1 r2)
end)) l))

# 27 "FStar.SMTEncoding.ErrorReporting.fst"
let remove_dups : labels  ->  ((Prims.string * FStar_SMTEncoding_Term.sort) * Prims.string * FStar_Int64.int64) Prims.list = (fun l -> (FStar_Util.remove_dups (fun _84_19 _84_24 -> (match (((_84_19), (_84_24))) with
| ((_84_16, m1, r1), (_84_21, m2, r2)) -> begin
((r1 = r2) && (m1 = m2))
end)) l))

# 28 "FStar.SMTEncoding.ErrorReporting.fst"
type msg =
(Prims.string * FStar_Range.range)

# 29 "FStar.SMTEncoding.ErrorReporting.fst"
type ranges =
(Prims.string Prims.option * FStar_Range.range) Prims.list

# 30 "FStar.SMTEncoding.ErrorReporting.fst"
let fresh_label : ranges  ->  FStar_SMTEncoding_Term.term  ->  labels  ->  (FStar_SMTEncoding_Term.term * labels) = (
# 33 "FStar.SMTEncoding.ErrorReporting.fst"
let ctr = (FStar_ST.alloc 0)
in (fun rs t labs -> (
# 35 "FStar.SMTEncoding.ErrorReporting.fst"
let l = (
# 35 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_29 = (FStar_Util.incr ctr)
in (let _176_16 = (let _176_15 = (FStar_ST.read ctr)
in (FStar_Util.string_of_int _176_15))
in (FStar_Util.format1 "label_%s" _176_16)))
in (
# 36 "FStar.SMTEncoding.ErrorReporting.fst"
let lvar = ((l), (FStar_SMTEncoding_Term.Bool_sort))
in (
# 37 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_49 = (match (rs) with
| [] -> begin
if (FStar_Options.debug_any ()) then begin
((t.FStar_SMTEncoding_Term.hash), (FStar_Range.dummyRange))
end else begin
(("Z3 provided a counterexample, but, unfortunately, F* could not translate it back to something meaningful"), (FStar_Range.dummyRange))
end
end
| ((Some (reason), r))::_84_35 -> begin
((reason), (r))
end
| ((None, r))::_84_42 -> begin
(("failed to prove a pre-condition"), (r))
end)
in (match (_84_49) with
| (message, range) -> begin
(
# 44 "FStar.SMTEncoding.ErrorReporting.fst"
let label = ((lvar), (message), (range))
in (
# 45 "FStar.SMTEncoding.ErrorReporting.fst"
let lterm = (FStar_SMTEncoding_Term.mkFreeV lvar)
in (
# 46 "FStar.SMTEncoding.ErrorReporting.fst"
let lt = (FStar_SMTEncoding_Term.mkOr ((lterm), (t)))
in ((lt), ((label)::labs)))))
end))))))

# 47 "FStar.SMTEncoding.ErrorReporting.fst"
let label_goals : (Prims.unit  ->  Prims.string) Prims.option  ->  FStar_Int64.int64  ->  FStar_SMTEncoding_Term.term  ->  (FStar_SMTEncoding_Term.term * labels * ranges) = (fun use_env_msg r q -> (
# 62 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_61 = (match (use_env_msg) with
| None -> begin
((false), (""))
end
| Some (f) -> begin
(let _176_32 = (f ())
in ((true), (_176_32)))
end)
in (match (_84_61) with
| (flag, msg_prefix) -> begin
(
# 65 "FStar.SMTEncoding.ErrorReporting.fst"
let fresh_label = (fun rs t labs -> (
# 66 "FStar.SMTEncoding.ErrorReporting.fst"
let rs' = if (not (flag)) then begin
rs
end else begin
(match (rs) with
| ((Some (reason), _84_71))::_84_67 -> begin
(((Some ((Prims.strcat "Failed to verify implicit argument: " reason))), (r)))::[]
end
| _84_75 -> begin
(((Some ("Failed to verify implicit argument")), (r)))::[]
end)
end
in (
# 71 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_79 = (fresh_label rs' t labs)
in (match (_84_79) with
| (lt, labs) -> begin
((lt), (labs), (rs))
end))))
in (
# 73 "FStar.SMTEncoding.ErrorReporting.fst"
let rec aux = (fun rs q labs -> (match (q.FStar_SMTEncoding_Term.tm) with
| (FStar_SMTEncoding_Term.BoundV (_)) | (FStar_SMTEncoding_Term.Integer (_)) -> begin
((q), (labs), (rs))
end
| FStar_SMTEncoding_Term.Labeled (_84_91, "push", r) -> begin
((FStar_SMTEncoding_Term.mkTrue), (labs), ((((None), (r)))::rs))
end
| FStar_SMTEncoding_Term.Labeled (_84_97, "pop", r) -> begin
(let _176_45 = (FStar_List.tl rs)
in ((FStar_SMTEncoding_Term.mkTrue), (labs), (_176_45)))
end
| FStar_SMTEncoding_Term.Labeled (arg, reason, r) -> begin
(
# 85 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_110 = (aux ((((Some (reason)), (r)))::rs) arg labs)
in (match (_84_110) with
| (tm, labs, rs) -> begin
(let _176_46 = (FStar_List.tl rs)
in ((tm), (labs), (_176_46)))
end))
end
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Imp, (lhs)::(rhs)::[]) -> begin
(
# 89 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_120 = (aux rs rhs labs)
in (match (_84_120) with
| (rhs, labs, rs) -> begin
(
# 90 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_178 = (match (lhs.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.And, conjuncts) -> begin
(
# 92 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_169 = (FStar_Util.fold_map (fun _84_127 tm -> (match (_84_127) with
| (labs, rs) -> begin
(match (tm.FStar_SMTEncoding_Term.tm) with
| FStar_SMTEncoding_Term.Quant (FStar_SMTEncoding_Term.Forall, (({FStar_SMTEncoding_Term.tm = FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Var ("Prims.guard_free"), (p)::[]); FStar_SMTEncoding_Term.hash = _84_133; FStar_SMTEncoding_Term.freevars = _84_131})::[])::[], iopt, sorts, {FStar_SMTEncoding_Term.tm = FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Iff, (l)::(r)::[]); FStar_SMTEncoding_Term.hash = _84_148; FStar_SMTEncoding_Term.freevars = _84_146}) -> begin
(
# 95 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_161 = (aux rs r labs)
in (match (_84_161) with
| (r, labs, rs) -> begin
(
# 96 "FStar.SMTEncoding.ErrorReporting.fst"
let q = (let _176_51 = (let _176_50 = (let _176_49 = (FStar_SMTEncoding_Term.mk (FStar_SMTEncoding_Term.App (((FStar_SMTEncoding_Term.Iff), ((l)::(r)::[])))))
in ((FStar_SMTEncoding_Term.Forall), (((p)::[])::[]), (Some (0)), (sorts), (_176_49)))
in FStar_SMTEncoding_Term.Quant (_176_50))
in (FStar_All.pipe_left FStar_SMTEncoding_Term.mk _176_51))
in ((((labs), (rs))), (q)))
end))
end
| _84_164 -> begin
((((labs), (rs))), (tm))
end)
end)) ((labs), (rs)) conjuncts)
in (match (_84_169) with
| ((labs, rs), conjuncts) -> begin
(
# 99 "FStar.SMTEncoding.ErrorReporting.fst"
let tm = (FStar_List.fold_right (fun conjunct out -> (FStar_SMTEncoding_Term.mkAnd ((out), (conjunct)))) conjuncts FStar_SMTEncoding_Term.mkTrue)
in ((tm), (labs), (rs)))
end))
end
| _84_174 -> begin
((lhs), (labs), (rs))
end)
in (match (_84_178) with
| (lhs, labs, rs) -> begin
(let _176_54 = (FStar_SMTEncoding_Term.mkImp ((lhs), (rhs)))
in ((_176_54), (labs), (rs)))
end))
end))
end
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.And, conjuncts) -> begin
(
# 105 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_195 = (FStar_List.fold_left (fun _84_186 c -> (match (_84_186) with
| (rs, cs, labs) -> begin
(
# 106 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_191 = (aux rs c labs)
in (match (_84_191) with
| (c, labs, rs) -> begin
((rs), ((c)::cs), (labs))
end))
end)) ((rs), ([]), (labs)) conjuncts)
in (match (_84_195) with
| (rs, conjuncts, labs) -> begin
(
# 110 "FStar.SMTEncoding.ErrorReporting.fst"
let tm = (FStar_List.fold_left (fun out conjunct -> (FStar_SMTEncoding_Term.mkAnd ((out), (conjunct)))) FStar_SMTEncoding_Term.mkTrue conjuncts)
in ((tm), (labs), (rs)))
end))
end
| FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.ITE, (hd)::(q1)::(q2)::[]) -> begin
(
# 114 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_210 = (aux rs q1 labs)
in (match (_84_210) with
| (q1, labs, _84_209) -> begin
(
# 115 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_215 = (aux rs q2 labs)
in (match (_84_215) with
| (q2, labs, _84_214) -> begin
(let _176_59 = (FStar_SMTEncoding_Term.mk (FStar_SMTEncoding_Term.App (((FStar_SMTEncoding_Term.ITE), ((hd)::(q1)::(q2)::[])))))
in ((_176_59), (labs), (rs)))
end))
end))
end
| (FStar_SMTEncoding_Term.Quant (FStar_SMTEncoding_Term.Exists, _, _, _, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Iff, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Or, _)) -> begin
(fresh_label rs q labs)
end
| (FStar_SMTEncoding_Term.FreeV (_)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.True, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.False, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Not, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Eq, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.LT, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.LTE, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.GT, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.GTE, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Var (_), _)) -> begin
(fresh_label rs q labs)
end
| (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Add, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Sub, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Div, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Mul, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Minus, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Mod, _)) -> begin
(FStar_All.failwith "Impossible: non-propositional term")
end
| (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.ITE, _)) | (FStar_SMTEncoding_Term.App (FStar_SMTEncoding_Term.Imp, _)) -> begin
(FStar_All.failwith "Impossible: arity mismatch")
end
| FStar_SMTEncoding_Term.Quant (FStar_SMTEncoding_Term.Forall, pats, iopt, sorts, body) -> begin
(
# 148 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_337 = (aux rs body labs)
in (match (_84_337) with
| (body, labs, rs) -> begin
(let _176_60 = (FStar_SMTEncoding_Term.mk (FStar_SMTEncoding_Term.Quant (((FStar_SMTEncoding_Term.Forall), (pats), (iopt), (sorts), (body)))))
in ((_176_60), (labs), (rs)))
end))
end))
in (aux [] q [])))
end)))

# 150 "FStar.SMTEncoding.ErrorReporting.fst"
let detail_errors : labels  ->  labels  ->  (FStar_SMTEncoding_Term.decls_t  ->  ((FStar_SMTEncoding_Z3.unsat_core, FStar_SMTEncoding_Term.error_labels) FStar_Util.either * Prims.int))  ->  ((Prims.string * FStar_SMTEncoding_Term.sort) * Prims.string * FStar_Range.range) Prims.list = (fun all_labels potential_errors askZ3 -> (
# 163 "FStar.SMTEncoding.ErrorReporting.fst"
let ctr = (FStar_Util.mk_ref 0)
in (
# 164 "FStar.SMTEncoding.ErrorReporting.fst"
let elim = (fun labs -> (
# 165 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_344 = (FStar_Util.incr ctr)
in (let _176_83 = (let _176_76 = (let _176_75 = (let _176_74 = (FStar_ST.read ctr)
in (FStar_Util.string_of_int _176_74))
in (Prims.strcat "DETAILING ERRORS" _176_75))
in FStar_SMTEncoding_Term.Echo (_176_76))
in (let _176_82 = (FStar_All.pipe_right labs (FStar_List.map (fun _84_351 -> (match (_84_351) with
| (l, _84_348, _84_350) -> begin
(let _176_81 = (let _176_80 = (let _176_79 = (let _176_78 = (FStar_SMTEncoding_Term.mkFreeV l)
in ((_176_78), (FStar_SMTEncoding_Term.mkTrue)))
in (FStar_SMTEncoding_Term.mkEq _176_79))
in ((_176_80), (Some ("Disabling label")), (Some ((Prims.strcat "disable_label_" (Prims.fst l))))))
in FStar_SMTEncoding_Term.Assume (_176_81))
end))))
in (_176_83)::_176_82))))
in (
# 168 "FStar.SMTEncoding.ErrorReporting.fst"
let print_labs = (fun tag l -> (FStar_All.pipe_right l (FStar_List.iter (fun _84_360 -> (match (_84_360) with
| (l, _84_357, _84_359) -> begin
(FStar_Util.print2 "%s : %s; " tag (Prims.fst l))
end)))))
in (
# 170 "FStar.SMTEncoding.ErrorReporting.fst"
let minus = (fun l1 l2 -> (FStar_All.pipe_right l1 (FStar_List.filter (fun _84_372 -> (match (_84_372) with
| ((x, _84_366), _84_369, _84_371) -> begin
(not ((FStar_All.pipe_right l2 (FStar_Util.for_some (fun _84_381 -> (match (_84_381) with
| ((y, _84_375), _84_378, _84_380) -> begin
(x = y)
end))))))
end)))))
in (
# 175 "FStar.SMTEncoding.ErrorReporting.fst"
let rec linear_check = (fun eliminated errors active -> (match (active) with
| [] -> begin
(
# 177 "FStar.SMTEncoding.ErrorReporting.fst"
let labs = (FStar_All.pipe_right errors sort_labels)
in labs)
end
| (hd)::tl -> begin
(
# 181 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_394 = (let _176_101 = (FStar_All.pipe_left elim (FStar_List.append eliminated (FStar_List.append errors tl)))
in (askZ3 _176_101))
in (match (_84_394) with
| (result, _84_393) -> begin
if (FStar_Util.is_left result) then begin
(linear_check ((hd)::eliminated) errors tl)
end else begin
(linear_check eliminated ((hd)::errors) tl)
end
end))
end))
in (
# 187 "FStar.SMTEncoding.ErrorReporting.fst"
let rec bisect = (fun eliminated potential_errors active -> (match (active) with
| [] -> begin
((eliminated), (potential_errors))
end
| _84_401 -> begin
(
# 191 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_409 = (match (active) with
| (_84_403)::[] -> begin
((active), ([]))
end
| _84_406 -> begin
(FStar_Util.first_N ((FStar_List.length active) / 2) active)
end)
in (match (_84_409) with
| (pfx, sfx) -> begin
(
# 194 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_413 = (let _176_108 = (elim (FStar_List.append eliminated (FStar_List.append potential_errors sfx)))
in (askZ3 _176_108))
in (match (_84_413) with
| (result, _84_412) -> begin
(match (result) with
| FStar_Util.Inl (_84_415) -> begin
(bisect (FStar_List.append eliminated pfx) potential_errors sfx)
end
| FStar_Util.Inr ([]) -> begin
(bisect eliminated (FStar_List.append potential_errors pfx) sfx)
end
| FStar_Util.Inr (pfx_subset) -> begin
(
# 204 "FStar.SMTEncoding.ErrorReporting.fst"
let potential_errors = (FStar_List.append potential_errors pfx_subset)
in (
# 205 "FStar.SMTEncoding.ErrorReporting.fst"
let pfx_active = (minus pfx pfx_subset)
in (bisect eliminated potential_errors (FStar_List.append pfx_active sfx))))
end)
end))
end))
end))
in (
# 211 "FStar.SMTEncoding.ErrorReporting.fst"
let rec until_fixpoint = (fun eliminated potential_errors active -> (
# 212 "FStar.SMTEncoding.ErrorReporting.fst"
let _84_429 = (bisect eliminated potential_errors active)
in (match (_84_429) with
| (eliminated', potential_errors) -> begin
if (FStar_Util.physical_equality eliminated eliminated') then begin
(linear_check eliminated [] potential_errors)
end else begin
(until_fixpoint eliminated' [] potential_errors)
end
end)))
in (
# 217 "FStar.SMTEncoding.ErrorReporting.fst"
let active = (minus all_labels potential_errors)
in (until_fixpoint [] potential_errors active))))))))))




