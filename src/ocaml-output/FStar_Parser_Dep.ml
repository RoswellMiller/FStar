
open Prims
type map =
Prims.string FStar_Util.smap

let check_and_strip_suffix = (fun f -> (let suffixes = (".fsti")::(".fst")::(".fsi")::(".fs")::[]
in (let matches = (FStar_List.map (fun ext -> (let lext = (FStar_String.length ext)
in (let l = (FStar_String.length f)
in if ((l > lext) && ((FStar_String.substring f (l - lext) lext) = ext)) then begin
(let _115_4 = (FStar_String.substring f 0 (l - lext))
in Some (_115_4))
end else begin
None
end))) suffixes)
in (match ((FStar_List.filter FStar_Util.is_some matches)) with
| Some (m)::_49_17 -> begin
Some (m)
end
| _49_22 -> begin
None
end))))

let is_interface = (fun f -> ((FStar_String.get f ((FStar_String.length f) - 1)) = 'i'))

let print_map = (fun m -> (let _115_13 = (let _115_12 = (FStar_Util.smap_keys m)
in (FStar_List.unique _115_12))
in (FStar_List.iter (fun k -> (let _115_11 = (let _115_10 = (FStar_Util.smap_try_find m k)
in (FStar_Util.must _115_10))
in (FStar_Util.print2 "%s: %s\n" k _115_11))) _115_13)))

let lowercase_module_name = (fun f -> (match ((let _115_16 = (FStar_Util.basename f)
in (check_and_strip_suffix _115_16))) with
| Some (longname) -> begin
(FStar_String.lowercase longname)
end
| None -> begin
(let _115_18 = (let _115_17 = (FStar_Util.format1 "not a valid FStar file: %s\n" f)
in FStar_Absyn_Syntax.Err (_115_17))
in (Prims.raise _115_18))
end))

let build_map = (fun filenames -> (let include_directories = (FStar_Options.get_include_path ())
in (let include_directories = (FStar_List.map FStar_Util.normalize_file_path include_directories)
in (let include_directories = (FStar_List.unique include_directories)
in (let cwd = (let _115_21 = (FStar_Util.getcwd ())
in (FStar_Util.normalize_file_path _115_21))
in (let map = (FStar_Util.smap_create 41)
in (let _49_52 = (FStar_List.iter (fun d -> if (FStar_Util.file_exists d) then begin
(let files = (FStar_Util.readdir d)
in (FStar_List.iter (fun f -> (let f = (FStar_Util.basename f)
in (match ((check_and_strip_suffix f)) with
| Some (longname) -> begin
(let key = (FStar_String.lowercase longname)
in (let full_path = if (d = cwd) then begin
f
end else begin
(FStar_Util.join_paths d f)
end
in (match ((FStar_Util.smap_try_find map key)) with
| Some (existing_file) -> begin
(let _49_46 = if ((FStar_String.lowercase existing_file) = (FStar_String.lowercase f)) then begin
(let _115_25 = (let _115_24 = (FStar_Util.format1 "I\'m case insensitive, and I found the same file twice (%s)\n" f)
in FStar_Absyn_Syntax.Err (_115_24))
in (Prims.raise _115_25))
end else begin
()
end
in (let _49_48 = if ((is_interface existing_file) = (is_interface f)) then begin
(let _115_27 = (let _115_26 = (FStar_Util.format1 "Found both a .fs and a .fst (or both a .fsi and a .fsti) (%s)\n" f)
in FStar_Absyn_Syntax.Err (_115_26))
in (Prims.raise _115_27))
end else begin
()
end
in if (not ((is_interface existing_file))) then begin
(FStar_Util.smap_add map key full_path)
end else begin
()
end))
end
| None -> begin
(FStar_Util.smap_add map key full_path)
end)))
end
| None -> begin
()
end))) files))
end else begin
()
end) include_directories)
in (let _49_55 = (FStar_List.iter (fun f -> (let _115_29 = (lowercase_module_name f)
in (FStar_Util.smap_add map _115_29 f))) filenames)
in map))))))))

let enter_namespace = (fun original_map working_map prefix -> (let found = (FStar_ST.alloc false)
in (let prefix = (Prims.strcat prefix ".")
in (let _49_67 = (let _115_39 = (let _115_38 = (FStar_Util.smap_keys original_map)
in (FStar_List.unique _115_38))
in (FStar_List.iter (fun k -> if (FStar_Util.starts_with k prefix) then begin
(let suffix = (FStar_String.substring k (FStar_String.length prefix) ((FStar_String.length k) - (FStar_String.length prefix)))
in (let filename = (let _115_37 = (FStar_Util.smap_try_find original_map k)
in (FStar_Util.must _115_37))
in (let _49_65 = (FStar_Util.smap_add working_map suffix filename)
in (FStar_ST.op_Colon_Equals found true))))
end else begin
()
end) _115_39))
in (FStar_ST.read found)))))

let string_of_lid = (fun l last -> (let suffix = if last then begin
(l.FStar_Absyn_Syntax.ident.FStar_Absyn_Syntax.idText)::[]
end else begin
[]
end
in (let names = (let _115_45 = (FStar_List.map (fun x -> x.FStar_Absyn_Syntax.idText) l.FStar_Absyn_Syntax.ns)
in (FStar_List.append _115_45 suffix))
in (FStar_String.concat "." names))))

let lowercase_join_longident = (fun l last -> (let _115_50 = (string_of_lid l last)
in (FStar_String.lowercase _115_50)))

let check_module_declaration_against_filename = (fun lid filename -> (let k' = (lowercase_join_longident lid true)
in if ((let _115_57 = (let _115_56 = (let _115_55 = (FStar_Util.basename filename)
in (check_and_strip_suffix _115_55))
in (FStar_Util.must _115_56))
in (FStar_String.lowercase _115_57)) <> k') then begin
(let _115_59 = (let _115_58 = (string_of_lid lid true)
in (_115_58)::(filename)::[])
in (FStar_Util.fprint FStar_Util.stderr "Warning: the module declaration \"module %s\" found in file %s does not match its filename. Dependencies will be incorrect.\n" _115_59))
end else begin
()
end))

exception Exit

let is_Exit = (fun _discr_ -> (match (_discr_) with
| Exit -> begin
true
end
| _ -> begin
false
end))

let collect_one = (fun original_map filename -> (let deps = (FStar_ST.alloc [])
in (let add_dep = (fun d -> if (not ((let _115_68 = (FStar_ST.read deps)
in (FStar_List.existsb (fun d' -> (d' = d)) _115_68)))) then begin
(let _115_70 = (let _115_69 = (FStar_ST.read deps)
in (d)::_115_69)
in (FStar_ST.op_Colon_Equals deps _115_70))
end else begin
()
end)
in (let working_map = (FStar_Util.smap_copy original_map)
in (let record_open = (fun lid -> (let key = (lowercase_join_longident lid true)
in (match ((FStar_Util.smap_try_find original_map key)) with
| Some (filename) -> begin
(let _115_73 = (lowercase_module_name filename)
in (add_dep _115_73))
end
| None -> begin
(let r = (enter_namespace original_map working_map key)
in if (not (r)) then begin
(let _115_75 = (let _115_74 = (string_of_lid lid true)
in (_115_74)::[])
in (FStar_Util.fprint FStar_Util.stderr "Warning: no modules in namespace %s and no file with that name either\n" _115_75))
end else begin
()
end)
end)))
in (let auto_open = (let index_of = (fun s l -> (let found = (FStar_ST.alloc (- (1)))
in (FStar_All.try_with (fun _49_98 -> (match (()) with
| () -> begin
(let _49_107 = (FStar_List.iteri (fun i x -> if (s = x) then begin
(let _49_105 = (FStar_ST.op_Colon_Equals found i)
in (Prims.raise Exit))
end else begin
()
end) l)
in (- (1)))
end)) (fun _49_97 -> (match (_49_97) with
| Exit -> begin
(FStar_ST.read found)
end)))))
in (let ordered = ("fstar")::("prims")::("fstar.set")::("fstar.heap")::("fstar.st")::("fstar.all")::[]
in (let desired_opens = (FStar_Absyn_Const.fstar_ns_lid)::(FStar_Absyn_Const.prims_lid)::(FStar_Absyn_Const.st_lid)::(FStar_Absyn_Const.all_lid)::[]
in (let me = (let _115_86 = (let _115_85 = (let _115_84 = (FStar_Util.basename filename)
in (check_and_strip_suffix _115_84))
in (FStar_Util.must _115_85))
in (FStar_String.lowercase _115_86))
in (let index_or_length = (fun s l -> (let i = (index_of s l)
in if (i < 0) then begin
(FStar_List.length l)
end else begin
i
end))
in (let my_index = (index_or_length me ordered)
in (FStar_List.filter (fun lid -> ((let _115_92 = (lowercase_join_longident lid true)
in (index_or_length _115_92 ordered)) < my_index)) desired_opens)))))))
in (let _49_119 = (FStar_List.iter record_open auto_open)
in (let rec collect_fragment = (fun _49_1 -> (match (_49_1) with
| FStar_Util.Inl (file) -> begin
(collect_file file)
end
| FStar_Util.Inr (decls) -> begin
(collect_decls decls)
end))
and collect_file = (fun _49_2 -> (match (_49_2) with
| modul::[] -> begin
(collect_module modul)
end
| _49_146 -> begin
(let _115_112 = (let _115_111 = (FStar_Util.format1 "File %s does not respect the one module per file convention" filename)
in FStar_Absyn_Syntax.Err (_115_111))
in (Prims.raise _115_112))
end))
and collect_module = (fun _49_3 -> (match (_49_3) with
| (FStar_Parser_AST.Module (lid, decls)) | (FStar_Parser_AST.Interface (lid, decls, _)) -> begin
(let _49_156 = (check_module_declaration_against_filename lid filename)
in (collect_decls decls))
end))
and collect_decls = (fun decls -> (FStar_List.iter (fun x -> (collect_decl x.FStar_Parser_AST.d)) decls))
and collect_decl = (fun _49_4 -> (match (_49_4) with
| FStar_Parser_AST.Open (lid) -> begin
(record_open lid)
end
| FStar_Parser_AST.ToplevelLet (_49_164, patterms) -> begin
(FStar_List.iter (fun _49_171 -> (match (_49_171) with
| (_49_169, t) -> begin
(collect_term t)
end)) patterms)
end
| FStar_Parser_AST.KindAbbrev (_49_173, binders, t) -> begin
(let _49_178 = (collect_term t)
in (collect_binders binders))
end
| (FStar_Parser_AST.Main (t)) | (FStar_Parser_AST.Assume (_, _, t)) | (FStar_Parser_AST.SubEffect ({FStar_Parser_AST.msource = _; FStar_Parser_AST.mdest = _; FStar_Parser_AST.lift_op = t})) | (FStar_Parser_AST.Val (_, _, t)) -> begin
(collect_term t)
end
| FStar_Parser_AST.Tycon (_49_201, ts) -> begin
(FStar_List.iter collect_tycon ts)
end
| FStar_Parser_AST.Exception (_49_206, t) -> begin
(FStar_Util.iter_opt t collect_term)
end
| FStar_Parser_AST.NewEffect (_49_211, ed) -> begin
(collect_effect_decl ed)
end
| FStar_Parser_AST.Pragma (_49_216) -> begin
()
end))
and collect_tycon = (fun _49_5 -> (match (_49_5) with
| FStar_Parser_AST.TyconAbstract (_49_220, binders, k) -> begin
(let _49_225 = (collect_binders binders)
in (FStar_Util.iter_opt k collect_term))
end
| FStar_Parser_AST.TyconAbbrev (_49_228, binders, k, t) -> begin
(let _49_234 = (collect_binders binders)
in (let _49_236 = (FStar_Util.iter_opt k collect_term)
in (collect_term t)))
end
| FStar_Parser_AST.TyconRecord (_49_239, binders, k, identterms) -> begin
(let _49_245 = (collect_binders binders)
in (let _49_247 = (FStar_Util.iter_opt k collect_term)
in (FStar_List.iter (fun _49_252 -> (match (_49_252) with
| (_49_250, t) -> begin
(collect_term t)
end)) identterms)))
end
| FStar_Parser_AST.TyconVariant (_49_254, binders, k, identterms) -> begin
(let _49_260 = (collect_binders binders)
in (let _49_262 = (FStar_Util.iter_opt k collect_term)
in (FStar_List.iter (fun _49_269 -> (match (_49_269) with
| (_49_265, t, _49_268) -> begin
(FStar_Util.iter_opt t collect_term)
end)) identterms)))
end))
and collect_effect_decl = (fun _49_6 -> (match (_49_6) with
| FStar_Parser_AST.DefineEffect (_49_272, binders, t, decls) -> begin
(let _49_278 = (collect_binders binders)
in (let _49_280 = (collect_term t)
in (collect_decls decls)))
end
| FStar_Parser_AST.RedefineEffect (_49_283, binders, t) -> begin
(let _49_288 = (collect_binders binders)
in (collect_term t))
end))
and collect_binders = (fun binders -> (FStar_List.iter collect_binder binders))
and collect_binder = (fun _49_7 -> (match (_49_7) with
| ({FStar_Parser_AST.b = FStar_Parser_AST.Annotated (_, t); FStar_Parser_AST.brange = _; FStar_Parser_AST.blevel = _; FStar_Parser_AST.aqual = _}) | ({FStar_Parser_AST.b = FStar_Parser_AST.TAnnotated (_, t); FStar_Parser_AST.brange = _; FStar_Parser_AST.blevel = _; FStar_Parser_AST.aqual = _}) -> begin
(collect_term t)
end
| _49_316 -> begin
()
end))
and collect_term = (fun t -> (collect_term' t.FStar_Parser_AST.tm))
and collect_term' = (fun _49_8 -> (match (_49_8) with
| FStar_Parser_AST.Wild -> begin
()
end
| FStar_Parser_AST.Const (_49_321) -> begin
()
end
| FStar_Parser_AST.Op (_49_324, ts) -> begin
(FStar_List.iter collect_term ts)
end
| FStar_Parser_AST.Tvar (_49_329) -> begin
()
end
| (FStar_Parser_AST.Var (lid)) | (FStar_Parser_AST.Name (lid)) -> begin
(let key = (lowercase_join_longident lid false)
in (match ((FStar_Util.smap_try_find working_map key)) with
| Some (filename) -> begin
(let _115_126 = (lowercase_module_name filename)
in (add_dep _115_126))
end
| None -> begin
if (((FStar_List.length lid.FStar_Absyn_Syntax.ns) > 0) && ((FStar_ST.read FStar_Options.debug) <> [])) then begin
(let _115_128 = (let _115_127 = (string_of_lid lid false)
in (_115_127)::[])
in (FStar_Util.fprint FStar_Util.stderr "Warning: unbound module reference %s\n" _115_128))
end else begin
()
end
end))
end
| FStar_Parser_AST.Construct (_49_339, termimps) -> begin
(FStar_List.iter (fun _49_346 -> (match (_49_346) with
| (t, _49_345) -> begin
(collect_term t)
end)) termimps)
end
| FStar_Parser_AST.Abs (pats, t) -> begin
(let _49_351 = (collect_patterns pats)
in (collect_term t))
end
| FStar_Parser_AST.App (t1, t2, _49_356) -> begin
(let _49_359 = (collect_term t1)
in (collect_term t2))
end
| FStar_Parser_AST.Let (_49_362, patterms, t) -> begin
(let _49_371 = (FStar_List.iter (fun _49_370 -> (match (_49_370) with
| (_49_368, t) -> begin
(collect_term t)
end)) patterms)
in (collect_term t))
end
| FStar_Parser_AST.Seq (t1, t2) -> begin
(let _49_377 = (collect_term t1)
in (collect_term t2))
end
| FStar_Parser_AST.If (t1, t2, t3) -> begin
(let _49_384 = (collect_term t1)
in (let _49_386 = (collect_term t2)
in (collect_term t3)))
end
| (FStar_Parser_AST.Match (t, bs)) | (FStar_Parser_AST.TryWith (t, bs)) -> begin
(let _49_394 = (collect_term t)
in (collect_branches bs))
end
| FStar_Parser_AST.Ascribed (t1, t2) -> begin
(let _49_400 = (collect_term t1)
in (collect_term t2))
end
| FStar_Parser_AST.Record (t, idterms) -> begin
(FStar_Util.iter_opt t collect_term)
end
| FStar_Parser_AST.Project (t, _49_408) -> begin
(collect_term t)
end
| (FStar_Parser_AST.Product (binders, t)) | (FStar_Parser_AST.Sum (binders, t)) -> begin
(let _49_417 = (collect_binders binders)
in (collect_term t))
end
| (FStar_Parser_AST.QForall (binders, ts, t)) | (FStar_Parser_AST.QExists (binders, ts, t)) -> begin
(let _49_426 = (collect_binders binders)
in (let _49_428 = (FStar_List.iter (FStar_List.iter collect_term) ts)
in (collect_term t)))
end
| FStar_Parser_AST.Refine (binder, t) -> begin
(let _49_434 = (collect_binder binder)
in (collect_term t))
end
| FStar_Parser_AST.NamedTyp (_49_437, t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Paren (t) -> begin
(collect_term t)
end
| (FStar_Parser_AST.Requires (t, _)) | (FStar_Parser_AST.Ensures (t, _)) | (FStar_Parser_AST.Labeled (t, _, _)) -> begin
(collect_term t)
end))
and collect_patterns = (fun ps -> (FStar_List.iter collect_pattern ps))
and collect_pattern = (fun p -> (collect_pattern' p.FStar_Parser_AST.pat))
and collect_pattern' = (fun _49_9 -> (match (_49_9) with
| FStar_Parser_AST.PatWild -> begin
()
end
| FStar_Parser_AST.PatConst (_49_463) -> begin
()
end
| FStar_Parser_AST.PatApp (p, ps) -> begin
(let _49_469 = (collect_pattern p)
in (collect_patterns ps))
end
| (FStar_Parser_AST.PatVar (_)) | (FStar_Parser_AST.PatName (_)) | (FStar_Parser_AST.PatTvar (_)) -> begin
()
end
| (FStar_Parser_AST.PatList (ps)) | (FStar_Parser_AST.PatOr (ps)) | (FStar_Parser_AST.PatTuple (ps, _)) -> begin
(collect_patterns ps)
end
| FStar_Parser_AST.PatRecord (lidpats) -> begin
(FStar_List.iter (fun _49_492 -> (match (_49_492) with
| (_49_490, p) -> begin
(collect_pattern p)
end)) lidpats)
end
| FStar_Parser_AST.PatAscribed (p, t) -> begin
(let _49_497 = (collect_pattern p)
in (collect_term t))
end))
and collect_branches = (fun bs -> (FStar_List.iter collect_branch bs))
and collect_branch = (fun _49_503 -> (match (_49_503) with
| (pat, t1, t2) -> begin
(let _49_504 = (collect_pattern pat)
in (let _49_506 = (FStar_Util.iter_opt t1 collect_term)
in (collect_term t2)))
end))
in (let ast = (FStar_Parser_Driver.parse_file_raw filename)
in (let _49_509 = (collect_file ast)
in (FStar_ST.read deps)))))))))))

type color =
| White
| Gray
| Black

let is_White = (fun _discr_ -> (match (_discr_) with
| White -> begin
true
end
| _ -> begin
false
end))

let is_Gray = (fun _discr_ -> (match (_discr_) with
| Gray -> begin
true
end
| _ -> begin
false
end))

let is_Black = (fun _discr_ -> (match (_discr_) with
| Black -> begin
true
end
| _ -> begin
false
end))

let collect = (fun filenames -> (let graph = (FStar_Util.smap_create 41)
in (let m = (build_map filenames)
in (let rec discover_one = (fun key -> if ((FStar_Util.smap_try_find graph key) = None) then begin
(let filename = (let _115_144 = (FStar_Util.smap_try_find m key)
in (FStar_Util.must _115_144))
in (let deps = (collect_one m filename)
in (let _49_518 = (FStar_Util.smap_add graph key (deps, White))
in (FStar_List.iter discover_one deps))))
end else begin
()
end)
in (let _49_520 = (let _115_145 = (FStar_List.map lowercase_module_name filenames)
in (FStar_List.iter discover_one _115_145))
in (let print_graph = (fun _49_523 -> (match (()) with
| () -> begin
(let _115_154 = (let _115_153 = (FStar_Util.smap_keys graph)
in (FStar_List.unique _115_153))
in (FStar_List.iter (fun k -> (let _115_152 = (let _115_151 = (let _115_150 = (let _115_149 = (FStar_Util.smap_try_find graph k)
in (FStar_Util.must _115_149))
in (Prims.fst _115_150))
in (FStar_String.concat " " _115_151))
in (FStar_Util.print2 "%s: %s\n" k _115_152))) _115_154))
end))
in (let topologically_sorted = (FStar_ST.alloc [])
in (let rec discover = (fun key -> (let _49_530 = (let _115_157 = (FStar_Util.smap_try_find graph key)
in (FStar_Util.must _115_157))
in (match (_49_530) with
| (direct_deps, color) -> begin
(match (color) with
| Gray -> begin
(let _49_532 = (FStar_Util.print1 "Recursive dependency on module %s\n" key)
in (let _49_534 = (FStar_Util.print_string "Here\'s the (non-transitive) dependency graph:\n")
in (let _49_536 = (print_graph ())
in (let _49_538 = (FStar_Util.print_string "\n")
in (FStar_All.exit 1)))))
end
| Black -> begin
direct_deps
end
| White -> begin
(let _49_542 = (FStar_Util.smap_add graph key (direct_deps, Gray))
in (let all_deps = (let _115_161 = (let _115_160 = (FStar_List.map (fun dep -> (let _115_159 = (discover dep)
in (dep)::_115_159)) direct_deps)
in (FStar_List.flatten _115_160))
in (FStar_List.unique _115_161))
in (let _49_546 = (FStar_Util.smap_add graph key (all_deps, Black))
in (let _49_548 = (let _115_163 = (let _115_162 = (FStar_ST.read topologically_sorted)
in (key)::_115_162)
in (FStar_ST.op_Colon_Equals topologically_sorted _115_163))
in all_deps))))
end)
end)))
in (let must_find = (fun k -> (let _115_166 = (FStar_Util.smap_try_find m k)
in (FStar_Util.must _115_166)))
in (let by_target = (let _115_171 = (FStar_Util.smap_keys graph)
in (FStar_List.map (fun k -> (let deps = (let _115_168 = (discover k)
in (FStar_List.rev _115_168))
in (let _115_170 = (must_find k)
in (let _115_169 = (FStar_List.map must_find deps)
in (_115_170, _115_169))))) _115_171))
in (let topologically_sorted = (let _115_172 = (FStar_ST.read topologically_sorted)
in (FStar_List.map must_find _115_172))
in (by_target, topologically_sorted))))))))))))

let print_make = (fun deps -> (FStar_List.iter (fun _49_559 -> (match (_49_559) with
| (f, deps) -> begin
(let deps = (FStar_List.map (fun s -> (FStar_Util.replace_string s " " "\\ ")) deps)
in (FStar_Util.print2 "%s: %s\n" f (FStar_String.concat " " deps)))
end)) deps))

let print_nubuild = (fun l -> (FStar_List.iter FStar_Util.print_endline (FStar_List.rev l)))

let print = (fun deps -> (match ((FStar_ST.read FStar_Options.dep)) with
| Some ("nubuild") -> begin
(print_nubuild (Prims.snd deps))
end
| Some ("make") -> begin
(print_make (Prims.fst deps))
end
| Some (_49_569) -> begin
(FStar_All.failwith "Unknown tool for --dep")
end
| None -> begin
()
end))




