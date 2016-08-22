
open Prims
# 22 "FStar.Syntax.Const.fst"
let mk : FStar_Syntax_Syntax.term'  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun t -> (FStar_Syntax_Syntax.mk t None FStar_Range.dummyRange))

# 24 "FStar.Syntax.Const.fst"
let p2l : Prims.string Prims.list  ->  FStar_Ident.lident = (fun l -> (FStar_Ident.lid_of_path l FStar_Range.dummyRange))

# 25 "FStar.Syntax.Const.fst"
let pconst : Prims.string  ->  FStar_Ident.lident = (fun s -> (p2l (("Prims")::(s)::[])))

# 26 "FStar.Syntax.Const.fst"
let prims_lid : FStar_Ident.lident = (p2l (("Prims")::[]))

# 27 "FStar.Syntax.Const.fst"
let fstar_ns_lid : FStar_Ident.lident = (p2l (("FStar")::[]))

# 28 "FStar.Syntax.Const.fst"
let bool_lid : FStar_Ident.lident = (pconst "bool")

# 31 "FStar.Syntax.Const.fst"
let unit_lid : FStar_Ident.lident = (pconst "unit")

# 32 "FStar.Syntax.Const.fst"
let squash_lid : FStar_Ident.lident = (pconst "squash")

# 33 "FStar.Syntax.Const.fst"
let string_lid : FStar_Ident.lident = (pconst "string")

# 34 "FStar.Syntax.Const.fst"
let bytes_lid : FStar_Ident.lident = (pconst "bytes")

# 35 "FStar.Syntax.Const.fst"
let int_lid : FStar_Ident.lident = (pconst "int")

# 36 "FStar.Syntax.Const.fst"
let exn_lid : FStar_Ident.lident = (pconst "exn")

# 37 "FStar.Syntax.Const.fst"
let list_lid : FStar_Ident.lident = (pconst "list")

# 38 "FStar.Syntax.Const.fst"
let option_lid : FStar_Ident.lident = (pconst "option")

# 39 "FStar.Syntax.Const.fst"
let either_lid : FStar_Ident.lident = (pconst "either")

# 40 "FStar.Syntax.Const.fst"
let pattern_lid : FStar_Ident.lident = (pconst "pattern")

# 41 "FStar.Syntax.Const.fst"
let precedes_lid : FStar_Ident.lident = (pconst "precedes")

# 42 "FStar.Syntax.Const.fst"
let lex_t_lid : FStar_Ident.lident = (pconst "lex_t")

# 43 "FStar.Syntax.Const.fst"
let lexcons_lid : FStar_Ident.lident = (pconst "LexCons")

# 44 "FStar.Syntax.Const.fst"
let lextop_lid : FStar_Ident.lident = (pconst "LexTop")

# 45 "FStar.Syntax.Const.fst"
let smtpat_lid : FStar_Ident.lident = (pconst "SMTPat")

# 46 "FStar.Syntax.Const.fst"
let smtpatT_lid : FStar_Ident.lident = (pconst "SMTPatT")

# 47 "FStar.Syntax.Const.fst"
let smtpatOr_lid : FStar_Ident.lident = (pconst "SMTPatOr")

# 48 "FStar.Syntax.Const.fst"
let monadic_lid : FStar_Ident.lident = (pconst "M")

# 49 "FStar.Syntax.Const.fst"
let int8_lid : FStar_Ident.lident = (p2l (("FStar")::("Int8")::("t")::[]))

# 51 "FStar.Syntax.Const.fst"
let uint8_lid : FStar_Ident.lident = (p2l (("FStar")::("UInt8")::("t")::[]))

# 52 "FStar.Syntax.Const.fst"
let int16_lid : FStar_Ident.lident = (p2l (("FStar")::("Int16")::("t")::[]))

# 53 "FStar.Syntax.Const.fst"
let uint16_lid : FStar_Ident.lident = (p2l (("FStar")::("UInt16")::("t")::[]))

# 54 "FStar.Syntax.Const.fst"
let int32_lid : FStar_Ident.lident = (p2l (("FStar")::("Int32")::("t")::[]))

# 55 "FStar.Syntax.Const.fst"
let uint32_lid : FStar_Ident.lident = (p2l (("FStar")::("UInt32")::("t")::[]))

# 56 "FStar.Syntax.Const.fst"
let int64_lid : FStar_Ident.lident = (p2l (("FStar")::("Int64")::("t")::[]))

# 57 "FStar.Syntax.Const.fst"
let uint64_lid : FStar_Ident.lident = (p2l (("FStar")::("UInt64")::("t")::[]))

# 58 "FStar.Syntax.Const.fst"
let salloc_lid : FStar_Ident.lident = (p2l (("FStar")::("HST")::("salloc")::[]))

# 60 "FStar.Syntax.Const.fst"
let swrite_lid : FStar_Ident.lident = (p2l (("FStar")::("HST")::("op_Colon_Equals")::[]))

# 61 "FStar.Syntax.Const.fst"
let sread_lid : FStar_Ident.lident = (p2l (("FStar")::("HST")::("op_Bang")::[]))

# 62 "FStar.Syntax.Const.fst"
let float_lid : FStar_Ident.lident = (p2l (("FStar")::("Float")::("float")::[]))

# 64 "FStar.Syntax.Const.fst"
let char_lid : FStar_Ident.lident = (p2l (("FStar")::("Char")::("char")::[]))

# 66 "FStar.Syntax.Const.fst"
let heap_lid : FStar_Ident.lident = (p2l (("FStar")::("Heap")::("heap")::[]))

# 68 "FStar.Syntax.Const.fst"
let kunary : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.typ  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun k k' -> (let _126_15 = (let _126_14 = (let _126_13 = (let _126_11 = (FStar_Syntax_Syntax.null_binder k)
in (_126_11)::[])
in (let _126_12 = (FStar_Syntax_Syntax.mk_Total k')
in ((_126_13), (_126_12))))
in FStar_Syntax_Syntax.Tm_arrow (_126_14))
in (mk _126_15)))

# 71 "FStar.Syntax.Const.fst"
let kbin : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.typ  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun k1 k2 k' -> (let _126_28 = (let _126_27 = (let _126_26 = (let _126_24 = (FStar_Syntax_Syntax.null_binder k1)
in (let _126_23 = (let _126_22 = (FStar_Syntax_Syntax.null_binder k2)
in (_126_22)::[])
in (_126_24)::_126_23))
in (let _126_25 = (FStar_Syntax_Syntax.mk_Total k')
in ((_126_26), (_126_25))))
in FStar_Syntax_Syntax.Tm_arrow (_126_27))
in (mk _126_28)))

# 72 "FStar.Syntax.Const.fst"
let ktern : FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.typ  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun k1 k2 k3 k' -> (let _126_45 = (let _126_44 = (let _126_43 = (let _126_41 = (FStar_Syntax_Syntax.null_binder k1)
in (let _126_40 = (let _126_39 = (FStar_Syntax_Syntax.null_binder k2)
in (let _126_38 = (let _126_37 = (FStar_Syntax_Syntax.null_binder k3)
in (_126_37)::[])
in (_126_39)::_126_38))
in (_126_41)::_126_40))
in (let _126_42 = (FStar_Syntax_Syntax.mk_Total k')
in ((_126_43), (_126_42))))
in FStar_Syntax_Syntax.Tm_arrow (_126_44))
in (mk _126_45)))

# 75 "FStar.Syntax.Const.fst"
let true_lid : FStar_Ident.lident = (pconst "l_True")

# 76 "FStar.Syntax.Const.fst"
let false_lid : FStar_Ident.lident = (pconst "l_False")

# 77 "FStar.Syntax.Const.fst"
let and_lid : FStar_Ident.lident = (pconst "l_and")

# 78 "FStar.Syntax.Const.fst"
let or_lid : FStar_Ident.lident = (pconst "l_or")

# 79 "FStar.Syntax.Const.fst"
let not_lid : FStar_Ident.lident = (pconst "l_not")

# 80 "FStar.Syntax.Const.fst"
let imp_lid : FStar_Ident.lident = (pconst "l_imp")

# 81 "FStar.Syntax.Const.fst"
let iff_lid : FStar_Ident.lident = (pconst "l_iff")

# 82 "FStar.Syntax.Const.fst"
let ite_lid : FStar_Ident.lident = (pconst "l_ITE")

# 83 "FStar.Syntax.Const.fst"
let exists_lid : FStar_Ident.lident = (pconst "l_Exists")

# 84 "FStar.Syntax.Const.fst"
let forall_lid : FStar_Ident.lident = (pconst "l_Forall")

# 85 "FStar.Syntax.Const.fst"
let haseq_lid : FStar_Ident.lident = (pconst "hasEq")

# 86 "FStar.Syntax.Const.fst"
let b2t_lid : FStar_Ident.lident = (pconst "b2t")

# 87 "FStar.Syntax.Const.fst"
let admit_lid : FStar_Ident.lident = (pconst "admit")

# 88 "FStar.Syntax.Const.fst"
let magic_lid : FStar_Ident.lident = (pconst "magic")

# 89 "FStar.Syntax.Const.fst"
let has_type_lid : FStar_Ident.lident = (pconst "has_type")

# 90 "FStar.Syntax.Const.fst"
let eq2_lid : FStar_Ident.lident = (pconst "eq2")

# 93 "FStar.Syntax.Const.fst"
let eq3_lid : FStar_Ident.lident = (pconst "eq3")

# 94 "FStar.Syntax.Const.fst"
let exp_true_bool : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (mk (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_bool (true))))

# 97 "FStar.Syntax.Const.fst"
let exp_false_bool : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (mk (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_bool (false))))

# 98 "FStar.Syntax.Const.fst"
let exp_unit : (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (mk (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_unit)))

# 99 "FStar.Syntax.Const.fst"
let cons_lid : FStar_Ident.lident = (pconst "Cons")

# 100 "FStar.Syntax.Const.fst"
let nil_lid : FStar_Ident.lident = (pconst "Nil")

# 101 "FStar.Syntax.Const.fst"
let assume_lid : FStar_Ident.lident = (pconst "_assume")

# 102 "FStar.Syntax.Const.fst"
let assert_lid : FStar_Ident.lident = (pconst "_assert")

# 103 "FStar.Syntax.Const.fst"
let list_append_lid : FStar_Ident.lident = (p2l (("FStar")::("List")::("Tot")::("append")::[]))

# 104 "FStar.Syntax.Const.fst"
let strcat_lid : FStar_Ident.lident = (p2l (("Prims")::("strcat")::[]))

# 105 "FStar.Syntax.Const.fst"
let let_in_typ : FStar_Ident.lident = (p2l (("Prims")::("Let")::[]))

# 106 "FStar.Syntax.Const.fst"
let op_Eq : FStar_Ident.lident = (pconst "op_Equality")

# 109 "FStar.Syntax.Const.fst"
let op_notEq : FStar_Ident.lident = (pconst "op_disEquality")

# 110 "FStar.Syntax.Const.fst"
let op_LT : FStar_Ident.lident = (pconst "op_LessThan")

# 111 "FStar.Syntax.Const.fst"
let op_LTE : FStar_Ident.lident = (pconst "op_LessThanOrEqual")

# 112 "FStar.Syntax.Const.fst"
let op_GT : FStar_Ident.lident = (pconst "op_GreaterThan")

# 113 "FStar.Syntax.Const.fst"
let op_GTE : FStar_Ident.lident = (pconst "op_GreaterThanOrEqual")

# 114 "FStar.Syntax.Const.fst"
let op_Subtraction : FStar_Ident.lident = (pconst "op_Subtraction")

# 115 "FStar.Syntax.Const.fst"
let op_Minus : FStar_Ident.lident = (pconst "op_Minus")

# 116 "FStar.Syntax.Const.fst"
let op_Addition : FStar_Ident.lident = (pconst "op_Addition")

# 117 "FStar.Syntax.Const.fst"
let op_Multiply : FStar_Ident.lident = (pconst "op_Multiply")

# 118 "FStar.Syntax.Const.fst"
let op_Division : FStar_Ident.lident = (pconst "op_Division")

# 119 "FStar.Syntax.Const.fst"
let op_Modulus : FStar_Ident.lident = (pconst "op_Modulus")

# 120 "FStar.Syntax.Const.fst"
let op_And : FStar_Ident.lident = (pconst "op_AmpAmp")

# 121 "FStar.Syntax.Const.fst"
let op_Or : FStar_Ident.lident = (pconst "op_BarBar")

# 122 "FStar.Syntax.Const.fst"
let op_Negation : FStar_Ident.lident = (pconst "op_Negation")

# 123 "FStar.Syntax.Const.fst"
let array_lid : FStar_Ident.lident = (p2l (("FStar")::("Array")::("array")::[]))

# 126 "FStar.Syntax.Const.fst"
let array_mk_array_lid : FStar_Ident.lident = (p2l (("FStar")::("Array")::("mk_array")::[]))

# 127 "FStar.Syntax.Const.fst"
let st_lid : FStar_Ident.lident = (p2l (("FStar")::("ST")::[]))

# 130 "FStar.Syntax.Const.fst"
let write_lid : FStar_Ident.lident = (p2l (("FStar")::("ST")::("write")::[]))

# 131 "FStar.Syntax.Const.fst"
let read_lid : FStar_Ident.lident = (p2l (("FStar")::("ST")::("read")::[]))

# 132 "FStar.Syntax.Const.fst"
let alloc_lid : FStar_Ident.lident = (p2l (("FStar")::("ST")::("alloc")::[]))

# 133 "FStar.Syntax.Const.fst"
let op_ColonEq : FStar_Ident.lident = (p2l (("FStar")::("ST")::("op_Colon_Equals")::[]))

# 134 "FStar.Syntax.Const.fst"
let ref_lid : FStar_Ident.lident = (p2l (("FStar")::("Heap")::("ref")::[]))

# 137 "FStar.Syntax.Const.fst"
let heap_ref : FStar_Ident.lident = (p2l (("FStar")::("Heap")::("Ref")::[]))

# 138 "FStar.Syntax.Const.fst"
let set_empty : FStar_Ident.lident = (p2l (("FStar")::("Set")::("empty")::[]))

# 139 "FStar.Syntax.Const.fst"
let set_singleton : FStar_Ident.lident = (p2l (("FStar")::("Set")::("singleton")::[]))

# 140 "FStar.Syntax.Const.fst"
let set_union : FStar_Ident.lident = (p2l (("FStar")::("Set")::("union")::[]))

# 141 "FStar.Syntax.Const.fst"
let fstar_hyperheap_lid : FStar_Ident.lident = (p2l (("FStar")::("HyperHeap")::[]))

# 142 "FStar.Syntax.Const.fst"
let rref_lid : FStar_Ident.lident = (p2l (("FStar")::("HyperHeap")::("rref")::[]))

# 143 "FStar.Syntax.Const.fst"
let tset_empty : FStar_Ident.lident = (p2l (("FStar")::("TSet")::("empty")::[]))

# 144 "FStar.Syntax.Const.fst"
let tset_singleton : FStar_Ident.lident = (p2l (("FStar")::("TSet")::("singleton")::[]))

# 145 "FStar.Syntax.Const.fst"
let tset_union : FStar_Ident.lident = (p2l (("FStar")::("TSet")::("union")::[]))

# 146 "FStar.Syntax.Const.fst"
let erased_lid : FStar_Ident.lident = (p2l (("FStar")::("Ghost")::("erased")::[]))

# 149 "FStar.Syntax.Const.fst"
let effect_PURE_lid : FStar_Ident.lident = (pconst "PURE")

# 152 "FStar.Syntax.Const.fst"
let effect_Pure_lid : FStar_Ident.lident = (pconst "Pure")

# 153 "FStar.Syntax.Const.fst"
let effect_Tot_lid : FStar_Ident.lident = (pconst "Tot")

# 154 "FStar.Syntax.Const.fst"
let effect_Lemma_lid : FStar_Ident.lident = (pconst "Lemma")

# 155 "FStar.Syntax.Const.fst"
let effect_GTot_lid : FStar_Ident.lident = (pconst "GTot")

# 156 "FStar.Syntax.Const.fst"
let effect_GHOST_lid : FStar_Ident.lident = (pconst "GHOST")

# 157 "FStar.Syntax.Const.fst"
let effect_Ghost_lid : FStar_Ident.lident = (pconst "Ghost")

# 158 "FStar.Syntax.Const.fst"
let all_lid : FStar_Ident.lident = (p2l (("FStar")::("All")::[]))

# 161 "FStar.Syntax.Const.fst"
let effect_ALL_lid : FStar_Ident.lident = (p2l (("FStar")::("All")::("ALL")::[]))

# 162 "FStar.Syntax.Const.fst"
let effect_ML_lid : FStar_Ident.lident = (p2l (("FStar")::("All")::("ML")::[]))

# 163 "FStar.Syntax.Const.fst"
let failwith_lid : FStar_Ident.lident = (p2l (("FStar")::("All")::("failwith")::[]))

# 164 "FStar.Syntax.Const.fst"
let pipe_right_lid : FStar_Ident.lident = (p2l (("FStar")::("All")::("pipe_right")::[]))

# 165 "FStar.Syntax.Const.fst"
let pipe_left_lid : FStar_Ident.lident = (p2l (("FStar")::("All")::("pipe_left")::[]))

# 166 "FStar.Syntax.Const.fst"
let try_with_lid : FStar_Ident.lident = (p2l (("FStar")::("All")::("try_with")::[]))

# 167 "FStar.Syntax.Const.fst"
let as_requires : FStar_Ident.lident = (pconst "as_requires")

# 169 "FStar.Syntax.Const.fst"
let as_ensures : FStar_Ident.lident = (pconst "as_ensures")

# 170 "FStar.Syntax.Const.fst"
let decreases_lid : FStar_Ident.lident = (pconst "decreases")

# 171 "FStar.Syntax.Const.fst"
let range_lid : FStar_Ident.lident = (pconst "range")

# 173 "FStar.Syntax.Const.fst"
let range_of_lid : FStar_Ident.lident = (pconst "range_of")

# 174 "FStar.Syntax.Const.fst"
let labeled_lid : FStar_Ident.lident = (pconst "labeled")

# 175 "FStar.Syntax.Const.fst"
let range_0 : FStar_Ident.lident = (pconst "range_0")

# 176 "FStar.Syntax.Const.fst"
let guard_free : FStar_Ident.lident = (pconst "guard_free")




