open Prims
type local_binding =
  (FStar_Ident.ident,FStar_Syntax_Syntax.bv,Prims.bool)
    FStar_Pervasives_Native.tuple3[@@deriving show]
type rec_binding =
  (FStar_Ident.ident,FStar_Ident.lid,FStar_Syntax_Syntax.delta_depth)
    FStar_Pervasives_Native.tuple3[@@deriving show]
type module_abbrev =
  (FStar_Ident.ident,FStar_Ident.lident) FStar_Pervasives_Native.tuple2
[@@deriving show]
type open_kind =
  | Open_module 
  | Open_namespace [@@deriving show]
let (uu___is_Open_module : open_kind -> Prims.bool) =
  fun projectee  ->
    match projectee with | Open_module  -> true | uu____20 -> false
  
let (uu___is_Open_namespace : open_kind -> Prims.bool) =
  fun projectee  ->
    match projectee with | Open_namespace  -> true | uu____24 -> false
  
type open_module_or_namespace =
  (FStar_Ident.lident,open_kind) FStar_Pervasives_Native.tuple2[@@deriving
                                                                 show]
type record_or_dc =
  {
  typename: FStar_Ident.lident ;
  constrname: FStar_Ident.ident ;
  parms: FStar_Syntax_Syntax.binders ;
  fields:
    (FStar_Ident.ident,FStar_Syntax_Syntax.typ)
      FStar_Pervasives_Native.tuple2 Prims.list
    ;
  is_private_or_abstract: Prims.bool ;
  is_record: Prims.bool }[@@deriving show]
let (__proj__Mkrecord_or_dc__item__typename :
  record_or_dc -> FStar_Ident.lident) =
  fun projectee  ->
    match projectee with
    | { typename = __fname__typename; constrname = __fname__constrname;
        parms = __fname__parms; fields = __fname__fields;
        is_private_or_abstract = __fname__is_private_or_abstract;
        is_record = __fname__is_record;_} -> __fname__typename
  
let (__proj__Mkrecord_or_dc__item__constrname :
  record_or_dc -> FStar_Ident.ident) =
  fun projectee  ->
    match projectee with
    | { typename = __fname__typename; constrname = __fname__constrname;
        parms = __fname__parms; fields = __fname__fields;
        is_private_or_abstract = __fname__is_private_or_abstract;
        is_record = __fname__is_record;_} -> __fname__constrname
  
let (__proj__Mkrecord_or_dc__item__parms :
  record_or_dc -> FStar_Syntax_Syntax.binders) =
  fun projectee  ->
    match projectee with
    | { typename = __fname__typename; constrname = __fname__constrname;
        parms = __fname__parms; fields = __fname__fields;
        is_private_or_abstract = __fname__is_private_or_abstract;
        is_record = __fname__is_record;_} -> __fname__parms
  
let (__proj__Mkrecord_or_dc__item__fields :
  record_or_dc ->
    (FStar_Ident.ident,FStar_Syntax_Syntax.typ)
      FStar_Pervasives_Native.tuple2 Prims.list)
  =
  fun projectee  ->
    match projectee with
    | { typename = __fname__typename; constrname = __fname__constrname;
        parms = __fname__parms; fields = __fname__fields;
        is_private_or_abstract = __fname__is_private_or_abstract;
        is_record = __fname__is_record;_} -> __fname__fields
  
let (__proj__Mkrecord_or_dc__item__is_private_or_abstract :
  record_or_dc -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | { typename = __fname__typename; constrname = __fname__constrname;
        parms = __fname__parms; fields = __fname__fields;
        is_private_or_abstract = __fname__is_private_or_abstract;
        is_record = __fname__is_record;_} -> __fname__is_private_or_abstract
  
let (__proj__Mkrecord_or_dc__item__is_record : record_or_dc -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | { typename = __fname__typename; constrname = __fname__constrname;
        parms = __fname__parms; fields = __fname__fields;
        is_private_or_abstract = __fname__is_private_or_abstract;
        is_record = __fname__is_record;_} -> __fname__is_record
  
type scope_mod =
  | Local_binding of local_binding 
  | Rec_binding of rec_binding 
  | Module_abbrev of module_abbrev 
  | Open_module_or_namespace of open_module_or_namespace 
  | Top_level_def of FStar_Ident.ident 
  | Record_or_dc of record_or_dc [@@deriving show]
let (uu___is_Local_binding : scope_mod -> Prims.bool) =
  fun projectee  ->
    match projectee with | Local_binding _0 -> true | uu____189 -> false
  
let (__proj__Local_binding__item___0 : scope_mod -> local_binding) =
  fun projectee  -> match projectee with | Local_binding _0 -> _0 
let (uu___is_Rec_binding : scope_mod -> Prims.bool) =
  fun projectee  ->
    match projectee with | Rec_binding _0 -> true | uu____201 -> false
  
let (__proj__Rec_binding__item___0 : scope_mod -> rec_binding) =
  fun projectee  -> match projectee with | Rec_binding _0 -> _0 
let (uu___is_Module_abbrev : scope_mod -> Prims.bool) =
  fun projectee  ->
    match projectee with | Module_abbrev _0 -> true | uu____213 -> false
  
let (__proj__Module_abbrev__item___0 : scope_mod -> module_abbrev) =
  fun projectee  -> match projectee with | Module_abbrev _0 -> _0 
let (uu___is_Open_module_or_namespace : scope_mod -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | Open_module_or_namespace _0 -> true
    | uu____225 -> false
  
let (__proj__Open_module_or_namespace__item___0 :
  scope_mod -> open_module_or_namespace) =
  fun projectee  -> match projectee with | Open_module_or_namespace _0 -> _0 
let (uu___is_Top_level_def : scope_mod -> Prims.bool) =
  fun projectee  ->
    match projectee with | Top_level_def _0 -> true | uu____237 -> false
  
let (__proj__Top_level_def__item___0 : scope_mod -> FStar_Ident.ident) =
  fun projectee  -> match projectee with | Top_level_def _0 -> _0 
let (uu___is_Record_or_dc : scope_mod -> Prims.bool) =
  fun projectee  ->
    match projectee with | Record_or_dc _0 -> true | uu____249 -> false
  
let (__proj__Record_or_dc__item___0 : scope_mod -> record_or_dc) =
  fun projectee  -> match projectee with | Record_or_dc _0 -> _0 
type string_set = Prims.string FStar_Util.set[@@deriving show]
type exported_id_kind =
  | Exported_id_term_type 
  | Exported_id_field [@@deriving show]
let (uu___is_Exported_id_term_type : exported_id_kind -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | Exported_id_term_type  -> true
    | uu____262 -> false
  
let (uu___is_Exported_id_field : exported_id_kind -> Prims.bool) =
  fun projectee  ->
    match projectee with | Exported_id_field  -> true | uu____266 -> false
  
type exported_id_set = exported_id_kind -> string_set FStar_ST.ref[@@deriving
                                                                    show]
type env =
  {
  curmodule: FStar_Ident.lident FStar_Pervasives_Native.option ;
  curmonad: FStar_Ident.ident FStar_Pervasives_Native.option ;
  modules:
    (FStar_Ident.lident,FStar_Syntax_Syntax.modul)
      FStar_Pervasives_Native.tuple2 Prims.list
    ;
  scope_mods: scope_mod Prims.list ;
  exported_ids: exported_id_set FStar_Util.smap ;
  trans_exported_ids: exported_id_set FStar_Util.smap ;
  includes: FStar_Ident.lident Prims.list FStar_ST.ref FStar_Util.smap ;
  sigaccum: FStar_Syntax_Syntax.sigelts ;
  sigmap:
    (FStar_Syntax_Syntax.sigelt,Prims.bool) FStar_Pervasives_Native.tuple2
      FStar_Util.smap
    ;
  iface: Prims.bool ;
  admitted_iface: Prims.bool ;
  expect_typ: Prims.bool ;
  docs: FStar_Parser_AST.fsdoc FStar_Util.smap ;
  remaining_iface_decls:
    (FStar_Ident.lident,FStar_Parser_AST.decl Prims.list)
      FStar_Pervasives_Native.tuple2 Prims.list
    ;
  syntax_only: Prims.bool ;
  ds_hooks: dsenv_hooks }[@@deriving show]
and dsenv_hooks =
  {
  ds_push_open_hook: env -> open_module_or_namespace -> Prims.unit ;
  ds_push_include_hook: env -> FStar_Ident.lident -> Prims.unit ;
  ds_push_module_abbrev_hook:
    env -> FStar_Ident.ident -> FStar_Ident.lident -> Prims.unit }[@@deriving
                                                                    show]
let (__proj__Mkenv__item__curmodule :
  env -> FStar_Ident.lident FStar_Pervasives_Native.option) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__curmodule
  
let (__proj__Mkenv__item__curmonad :
  env -> FStar_Ident.ident FStar_Pervasives_Native.option) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__curmonad
  
let (__proj__Mkenv__item__modules :
  env ->
    (FStar_Ident.lident,FStar_Syntax_Syntax.modul)
      FStar_Pervasives_Native.tuple2 Prims.list)
  =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__modules
  
let (__proj__Mkenv__item__scope_mods : env -> scope_mod Prims.list) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__scope_mods
  
let (__proj__Mkenv__item__exported_ids :
  env -> exported_id_set FStar_Util.smap) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__exported_ids
  
let (__proj__Mkenv__item__trans_exported_ids :
  env -> exported_id_set FStar_Util.smap) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__trans_exported_ids
  
let (__proj__Mkenv__item__includes :
  env -> FStar_Ident.lident Prims.list FStar_ST.ref FStar_Util.smap) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__includes
  
let (__proj__Mkenv__item__sigaccum : env -> FStar_Syntax_Syntax.sigelts) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__sigaccum
  
let (__proj__Mkenv__item__sigmap :
  env ->
    (FStar_Syntax_Syntax.sigelt,Prims.bool) FStar_Pervasives_Native.tuple2
      FStar_Util.smap)
  =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__sigmap
  
let (__proj__Mkenv__item__iface : env -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__iface
  
let (__proj__Mkenv__item__admitted_iface : env -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__admitted_iface
  
let (__proj__Mkenv__item__expect_typ : env -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__expect_typ
  
let (__proj__Mkenv__item__docs :
  env -> FStar_Parser_AST.fsdoc FStar_Util.smap) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__docs
  
let (__proj__Mkenv__item__remaining_iface_decls :
  env ->
    (FStar_Ident.lident,FStar_Parser_AST.decl Prims.list)
      FStar_Pervasives_Native.tuple2 Prims.list)
  =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__remaining_iface_decls
  
let (__proj__Mkenv__item__syntax_only : env -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__syntax_only
  
let (__proj__Mkenv__item__ds_hooks : env -> dsenv_hooks) =
  fun projectee  ->
    match projectee with
    | { curmodule = __fname__curmodule; curmonad = __fname__curmonad;
        modules = __fname__modules; scope_mods = __fname__scope_mods;
        exported_ids = __fname__exported_ids;
        trans_exported_ids = __fname__trans_exported_ids;
        includes = __fname__includes; sigaccum = __fname__sigaccum;
        sigmap = __fname__sigmap; iface = __fname__iface;
        admitted_iface = __fname__admitted_iface;
        expect_typ = __fname__expect_typ; docs = __fname__docs;
        remaining_iface_decls = __fname__remaining_iface_decls;
        syntax_only = __fname__syntax_only; ds_hooks = __fname__ds_hooks;_}
        -> __fname__ds_hooks
  
let (__proj__Mkdsenv_hooks__item__ds_push_open_hook :
  dsenv_hooks -> env -> open_module_or_namespace -> Prims.unit) =
  fun projectee  ->
    match projectee with
    | { ds_push_open_hook = __fname__ds_push_open_hook;
        ds_push_include_hook = __fname__ds_push_include_hook;
        ds_push_module_abbrev_hook = __fname__ds_push_module_abbrev_hook;_}
        -> __fname__ds_push_open_hook
  
let (__proj__Mkdsenv_hooks__item__ds_push_include_hook :
  dsenv_hooks -> env -> FStar_Ident.lident -> Prims.unit) =
  fun projectee  ->
    match projectee with
    | { ds_push_open_hook = __fname__ds_push_open_hook;
        ds_push_include_hook = __fname__ds_push_include_hook;
        ds_push_module_abbrev_hook = __fname__ds_push_module_abbrev_hook;_}
        -> __fname__ds_push_include_hook
  
let (__proj__Mkdsenv_hooks__item__ds_push_module_abbrev_hook :
  dsenv_hooks -> env -> FStar_Ident.ident -> FStar_Ident.lident -> Prims.unit)
  =
  fun projectee  ->
    match projectee with
    | { ds_push_open_hook = __fname__ds_push_open_hook;
        ds_push_include_hook = __fname__ds_push_include_hook;
        ds_push_module_abbrev_hook = __fname__ds_push_module_abbrev_hook;_}
        -> __fname__ds_push_module_abbrev_hook
  
type 'a withenv = env -> ('a,env) FStar_Pervasives_Native.tuple2[@@deriving
                                                                  show]
let (default_ds_hooks : dsenv_hooks) =
  {
    ds_push_open_hook = (fun uu____1535  -> fun uu____1536  -> ());
    ds_push_include_hook = (fun uu____1539  -> fun uu____1540  -> ());
    ds_push_module_abbrev_hook =
      (fun uu____1544  -> fun uu____1545  -> fun uu____1546  -> ())
  } 
type foundname =
  | Term_name of
  (FStar_Syntax_Syntax.typ,Prims.bool,FStar_Syntax_Syntax.attribute
                                        Prims.list)
  FStar_Pervasives_Native.tuple3 
  | Eff_name of (FStar_Syntax_Syntax.sigelt,FStar_Ident.lident)
  FStar_Pervasives_Native.tuple2 [@@deriving show]
let (uu___is_Term_name : foundname -> Prims.bool) =
  fun projectee  ->
    match projectee with | Term_name _0 -> true | uu____1579 -> false
  
let (__proj__Term_name__item___0 :
  foundname ->
    (FStar_Syntax_Syntax.typ,Prims.bool,FStar_Syntax_Syntax.attribute
                                          Prims.list)
      FStar_Pervasives_Native.tuple3)
  = fun projectee  -> match projectee with | Term_name _0 -> _0 
let (uu___is_Eff_name : foundname -> Prims.bool) =
  fun projectee  ->
    match projectee with | Eff_name _0 -> true | uu____1619 -> false
  
let (__proj__Eff_name__item___0 :
  foundname ->
    (FStar_Syntax_Syntax.sigelt,FStar_Ident.lident)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | Eff_name _0 -> _0 
let (set_iface : env -> Prims.bool -> env) =
  fun env  ->
    fun b  ->
      let uu___134_1645 = env  in
      {
        curmodule = (uu___134_1645.curmodule);
        curmonad = (uu___134_1645.curmonad);
        modules = (uu___134_1645.modules);
        scope_mods = (uu___134_1645.scope_mods);
        exported_ids = (uu___134_1645.exported_ids);
        trans_exported_ids = (uu___134_1645.trans_exported_ids);
        includes = (uu___134_1645.includes);
        sigaccum = (uu___134_1645.sigaccum);
        sigmap = (uu___134_1645.sigmap);
        iface = b;
        admitted_iface = (uu___134_1645.admitted_iface);
        expect_typ = (uu___134_1645.expect_typ);
        docs = (uu___134_1645.docs);
        remaining_iface_decls = (uu___134_1645.remaining_iface_decls);
        syntax_only = (uu___134_1645.syntax_only);
        ds_hooks = (uu___134_1645.ds_hooks)
      }
  
let (iface : env -> Prims.bool) = fun e  -> e.iface 
let (set_admitted_iface : env -> Prims.bool -> env) =
  fun e  ->
    fun b  ->
      let uu___135_1655 = e  in
      {
        curmodule = (uu___135_1655.curmodule);
        curmonad = (uu___135_1655.curmonad);
        modules = (uu___135_1655.modules);
        scope_mods = (uu___135_1655.scope_mods);
        exported_ids = (uu___135_1655.exported_ids);
        trans_exported_ids = (uu___135_1655.trans_exported_ids);
        includes = (uu___135_1655.includes);
        sigaccum = (uu___135_1655.sigaccum);
        sigmap = (uu___135_1655.sigmap);
        iface = (uu___135_1655.iface);
        admitted_iface = b;
        expect_typ = (uu___135_1655.expect_typ);
        docs = (uu___135_1655.docs);
        remaining_iface_decls = (uu___135_1655.remaining_iface_decls);
        syntax_only = (uu___135_1655.syntax_only);
        ds_hooks = (uu___135_1655.ds_hooks)
      }
  
let (admitted_iface : env -> Prims.bool) = fun e  -> e.admitted_iface 
let (set_expect_typ : env -> Prims.bool -> env) =
  fun e  ->
    fun b  ->
      let uu___136_1665 = e  in
      {
        curmodule = (uu___136_1665.curmodule);
        curmonad = (uu___136_1665.curmonad);
        modules = (uu___136_1665.modules);
        scope_mods = (uu___136_1665.scope_mods);
        exported_ids = (uu___136_1665.exported_ids);
        trans_exported_ids = (uu___136_1665.trans_exported_ids);
        includes = (uu___136_1665.includes);
        sigaccum = (uu___136_1665.sigaccum);
        sigmap = (uu___136_1665.sigmap);
        iface = (uu___136_1665.iface);
        admitted_iface = (uu___136_1665.admitted_iface);
        expect_typ = b;
        docs = (uu___136_1665.docs);
        remaining_iface_decls = (uu___136_1665.remaining_iface_decls);
        syntax_only = (uu___136_1665.syntax_only);
        ds_hooks = (uu___136_1665.ds_hooks)
      }
  
let (expect_typ : env -> Prims.bool) = fun e  -> e.expect_typ 
let (all_exported_id_kinds : exported_id_kind Prims.list) =
  [Exported_id_field; Exported_id_term_type] 
let (transitive_exported_ids :
  env -> FStar_Ident.lident -> Prims.string Prims.list) =
  fun env  ->
    fun lid  ->
      let module_name = FStar_Ident.string_of_lid lid  in
      let uu____1680 =
        FStar_Util.smap_try_find env.trans_exported_ids module_name  in
      match uu____1680 with
      | FStar_Pervasives_Native.None  -> []
      | FStar_Pervasives_Native.Some exported_id_set ->
          let uu____1686 =
            let uu____1687 = exported_id_set Exported_id_term_type  in
            FStar_ST.op_Bang uu____1687  in
          FStar_All.pipe_right uu____1686 FStar_Util.set_elements
  
let (open_modules :
  env ->
    (FStar_Ident.lident,FStar_Syntax_Syntax.modul)
      FStar_Pervasives_Native.tuple2 Prims.list)
  = fun e  -> e.modules 
let (open_modules_and_namespaces : env -> FStar_Ident.lident Prims.list) =
  fun env  ->
    FStar_List.filter_map
      (fun uu___102_1817  ->
         match uu___102_1817 with
         | Open_module_or_namespace (lid,_info) ->
             FStar_Pervasives_Native.Some lid
         | uu____1822 -> FStar_Pervasives_Native.None) env.scope_mods
  
let (set_current_module : env -> FStar_Ident.lident -> env) =
  fun e  ->
    fun l  ->
      let uu___137_1829 = e  in
      {
        curmodule = (FStar_Pervasives_Native.Some l);
        curmonad = (uu___137_1829.curmonad);
        modules = (uu___137_1829.modules);
        scope_mods = (uu___137_1829.scope_mods);
        exported_ids = (uu___137_1829.exported_ids);
        trans_exported_ids = (uu___137_1829.trans_exported_ids);
        includes = (uu___137_1829.includes);
        sigaccum = (uu___137_1829.sigaccum);
        sigmap = (uu___137_1829.sigmap);
        iface = (uu___137_1829.iface);
        admitted_iface = (uu___137_1829.admitted_iface);
        expect_typ = (uu___137_1829.expect_typ);
        docs = (uu___137_1829.docs);
        remaining_iface_decls = (uu___137_1829.remaining_iface_decls);
        syntax_only = (uu___137_1829.syntax_only);
        ds_hooks = (uu___137_1829.ds_hooks)
      }
  
let (current_module : env -> FStar_Ident.lident) =
  fun env  ->
    match env.curmodule with
    | FStar_Pervasives_Native.None  -> failwith "Unset current module"
    | FStar_Pervasives_Native.Some m -> m
  
let (iface_decls :
  env ->
    FStar_Ident.lident ->
      FStar_Parser_AST.decl Prims.list FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun l  ->
      let uu____1844 =
        FStar_All.pipe_right env.remaining_iface_decls
          (FStar_List.tryFind
             (fun uu____1878  ->
                match uu____1878 with
                | (m,uu____1886) -> FStar_Ident.lid_equals l m))
         in
      match uu____1844 with
      | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
      | FStar_Pervasives_Native.Some (uu____1903,decls) ->
          FStar_Pervasives_Native.Some decls
  
let (set_iface_decls :
  env -> FStar_Ident.lident -> FStar_Parser_AST.decl Prims.list -> env) =
  fun env  ->
    fun l  ->
      fun ds  ->
        let uu____1930 =
          FStar_List.partition
            (fun uu____1960  ->
               match uu____1960 with
               | (m,uu____1968) -> FStar_Ident.lid_equals l m)
            env.remaining_iface_decls
           in
        match uu____1930 with
        | (uu____1973,rest) ->
            let uu___138_2007 = env  in
            {
              curmodule = (uu___138_2007.curmodule);
              curmonad = (uu___138_2007.curmonad);
              modules = (uu___138_2007.modules);
              scope_mods = (uu___138_2007.scope_mods);
              exported_ids = (uu___138_2007.exported_ids);
              trans_exported_ids = (uu___138_2007.trans_exported_ids);
              includes = (uu___138_2007.includes);
              sigaccum = (uu___138_2007.sigaccum);
              sigmap = (uu___138_2007.sigmap);
              iface = (uu___138_2007.iface);
              admitted_iface = (uu___138_2007.admitted_iface);
              expect_typ = (uu___138_2007.expect_typ);
              docs = (uu___138_2007.docs);
              remaining_iface_decls = ((l, ds) :: rest);
              syntax_only = (uu___138_2007.syntax_only);
              ds_hooks = (uu___138_2007.ds_hooks)
            }
  
let (qual : FStar_Ident.lident -> FStar_Ident.ident -> FStar_Ident.lident) =
  FStar_Syntax_Util.qual_id 
let (qualify : env -> FStar_Ident.ident -> FStar_Ident.lident) =
  fun env  ->
    fun id1  ->
      match env.curmonad with
      | FStar_Pervasives_Native.None  ->
          let uu____2026 = current_module env  in qual uu____2026 id1
      | FStar_Pervasives_Native.Some monad ->
          let uu____2028 =
            let uu____2029 = current_module env  in qual uu____2029 monad  in
          FStar_Syntax_Util.mk_field_projector_name_from_ident uu____2028 id1
  
let (syntax_only : env -> Prims.bool) = fun env  -> env.syntax_only 
let (set_syntax_only : env -> Prims.bool -> env) =
  fun env  ->
    fun b  ->
      let uu___139_2039 = env  in
      {
        curmodule = (uu___139_2039.curmodule);
        curmonad = (uu___139_2039.curmonad);
        modules = (uu___139_2039.modules);
        scope_mods = (uu___139_2039.scope_mods);
        exported_ids = (uu___139_2039.exported_ids);
        trans_exported_ids = (uu___139_2039.trans_exported_ids);
        includes = (uu___139_2039.includes);
        sigaccum = (uu___139_2039.sigaccum);
        sigmap = (uu___139_2039.sigmap);
        iface = (uu___139_2039.iface);
        admitted_iface = (uu___139_2039.admitted_iface);
        expect_typ = (uu___139_2039.expect_typ);
        docs = (uu___139_2039.docs);
        remaining_iface_decls = (uu___139_2039.remaining_iface_decls);
        syntax_only = b;
        ds_hooks = (uu___139_2039.ds_hooks)
      }
  
let (ds_hooks : env -> dsenv_hooks) = fun env  -> env.ds_hooks 
let (set_ds_hooks : env -> dsenv_hooks -> env) =
  fun env  ->
    fun hooks  ->
      let uu___140_2049 = env  in
      {
        curmodule = (uu___140_2049.curmodule);
        curmonad = (uu___140_2049.curmonad);
        modules = (uu___140_2049.modules);
        scope_mods = (uu___140_2049.scope_mods);
        exported_ids = (uu___140_2049.exported_ids);
        trans_exported_ids = (uu___140_2049.trans_exported_ids);
        includes = (uu___140_2049.includes);
        sigaccum = (uu___140_2049.sigaccum);
        sigmap = (uu___140_2049.sigmap);
        iface = (uu___140_2049.iface);
        admitted_iface = (uu___140_2049.admitted_iface);
        expect_typ = (uu___140_2049.expect_typ);
        docs = (uu___140_2049.docs);
        remaining_iface_decls = (uu___140_2049.remaining_iface_decls);
        syntax_only = (uu___140_2049.syntax_only);
        ds_hooks = hooks
      }
  
let new_sigmap : 'Auu____2052 . Prims.unit -> 'Auu____2052 FStar_Util.smap =
  fun uu____2058  -> FStar_Util.smap_create (Prims.parse_int "100") 
let (empty_env : Prims.unit -> env) =
  fun uu____2061  ->
    let uu____2062 = new_sigmap ()  in
    let uu____2065 = new_sigmap ()  in
    let uu____2068 = new_sigmap ()  in
    let uu____2079 = new_sigmap ()  in
    let uu____2090 = new_sigmap ()  in
    {
      curmodule = FStar_Pervasives_Native.None;
      curmonad = FStar_Pervasives_Native.None;
      modules = [];
      scope_mods = [];
      exported_ids = uu____2062;
      trans_exported_ids = uu____2065;
      includes = uu____2068;
      sigaccum = [];
      sigmap = uu____2079;
      iface = false;
      admitted_iface = false;
      expect_typ = false;
      docs = uu____2090;
      remaining_iface_decls = [];
      syntax_only = false;
      ds_hooks = default_ds_hooks
    }
  
let (sigmap :
  env ->
    (FStar_Syntax_Syntax.sigelt,Prims.bool) FStar_Pervasives_Native.tuple2
      FStar_Util.smap)
  = fun env  -> env.sigmap 
let (has_all_in_scope : env -> Prims.bool) =
  fun env  ->
    FStar_List.existsb
      (fun uu____2122  ->
         match uu____2122 with
         | (m,uu____2128) ->
             FStar_Ident.lid_equals m FStar_Parser_Const.all_lid) env.modules
  
let (set_bv_range :
  FStar_Syntax_Syntax.bv -> FStar_Range.range -> FStar_Syntax_Syntax.bv) =
  fun bv  ->
    fun r  ->
      let id1 =
        let uu___141_2136 = bv.FStar_Syntax_Syntax.ppname  in
        {
          FStar_Ident.idText = (uu___141_2136.FStar_Ident.idText);
          FStar_Ident.idRange = r
        }  in
      let uu___142_2137 = bv  in
      {
        FStar_Syntax_Syntax.ppname = id1;
        FStar_Syntax_Syntax.index = (uu___142_2137.FStar_Syntax_Syntax.index);
        FStar_Syntax_Syntax.sort = (uu___142_2137.FStar_Syntax_Syntax.sort)
      }
  
let (bv_to_name :
  FStar_Syntax_Syntax.bv -> FStar_Range.range -> FStar_Syntax_Syntax.term) =
  fun bv  -> fun r  -> FStar_Syntax_Syntax.bv_to_name (set_bv_range bv r) 
let (unmangleMap :
  (Prims.string,Prims.string,FStar_Syntax_Syntax.delta_depth,FStar_Syntax_Syntax.fv_qual
                                                               FStar_Pervasives_Native.option)
    FStar_Pervasives_Native.tuple4 Prims.list)
  =
  [("op_ColonColon", "Cons", FStar_Syntax_Syntax.Delta_constant,
     (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor));
  ("not", "op_Negation", FStar_Syntax_Syntax.Delta_equational,
    FStar_Pervasives_Native.None)]
  
let (unmangleOpName :
  FStar_Ident.ident ->
    (FStar_Syntax_Syntax.term,Prims.bool) FStar_Pervasives_Native.tuple2
      FStar_Pervasives_Native.option)
  =
  fun id1  ->
    let t =
      FStar_Util.find_map unmangleMap
        (fun uu____2224  ->
           match uu____2224 with
           | (x,y,dd,dq) ->
               if id1.FStar_Ident.idText = x
               then
                 let uu____2247 =
                   let uu____2248 =
                     FStar_Ident.lid_of_path ["Prims"; y]
                       id1.FStar_Ident.idRange
                      in
                   FStar_Syntax_Syntax.fvar uu____2248 dd dq  in
                 FStar_Pervasives_Native.Some uu____2247
               else FStar_Pervasives_Native.None)
       in
    match t with
    | FStar_Pervasives_Native.Some v1 ->
        FStar_Pervasives_Native.Some (v1, false)
    | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
  
type 'a cont_t =
  | Cont_ok of 'a 
  | Cont_fail 
  | Cont_ignore [@@deriving show]
let uu___is_Cont_ok : 'a . 'a cont_t -> Prims.bool =
  fun projectee  ->
    match projectee with | Cont_ok _0 -> true | uu____2291 -> false
  
let __proj__Cont_ok__item___0 : 'a . 'a cont_t -> 'a =
  fun projectee  -> match projectee with | Cont_ok _0 -> _0 
let uu___is_Cont_fail : 'a . 'a cont_t -> Prims.bool =
  fun projectee  ->
    match projectee with | Cont_fail  -> true | uu____2320 -> false
  
let uu___is_Cont_ignore : 'a . 'a cont_t -> Prims.bool =
  fun projectee  ->
    match projectee with | Cont_ignore  -> true | uu____2334 -> false
  
let option_of_cont :
  'a .
    (Prims.unit -> 'a FStar_Pervasives_Native.option) ->
      'a cont_t -> 'a FStar_Pervasives_Native.option
  =
  fun k_ignore  ->
    fun uu___103_2357  ->
      match uu___103_2357 with
      | Cont_ok a -> FStar_Pervasives_Native.Some a
      | Cont_fail  -> FStar_Pervasives_Native.None
      | Cont_ignore  -> k_ignore ()
  
let find_in_record :
  'Auu____2370 .
    FStar_Ident.ident Prims.list ->
      FStar_Ident.ident ->
        record_or_dc ->
          (record_or_dc -> 'Auu____2370 cont_t) -> 'Auu____2370 cont_t
  =
  fun ns  ->
    fun id1  ->
      fun record  ->
        fun cont  ->
          let typename' =
            FStar_Ident.lid_of_ids
              (FStar_List.append ns [(record.typename).FStar_Ident.ident])
             in
          if FStar_Ident.lid_equals typename' record.typename
          then
            let fname =
              FStar_Ident.lid_of_ids
                (FStar_List.append (record.typename).FStar_Ident.ns [id1])
               in
            let find1 =
              FStar_Util.find_map record.fields
                (fun uu____2416  ->
                   match uu____2416 with
                   | (f,uu____2424) ->
                       if id1.FStar_Ident.idText = f.FStar_Ident.idText
                       then FStar_Pervasives_Native.Some record
                       else FStar_Pervasives_Native.None)
               in
            match find1 with
            | FStar_Pervasives_Native.Some r -> cont r
            | FStar_Pervasives_Native.None  -> Cont_ignore
          else Cont_ignore
  
let (get_exported_id_set :
  env ->
    Prims.string ->
      (exported_id_kind -> string_set FStar_ST.ref)
        FStar_Pervasives_Native.option)
  = fun e  -> fun mname  -> FStar_Util.smap_try_find e.exported_ids mname 
let (get_trans_exported_id_set :
  env ->
    Prims.string ->
      (exported_id_kind -> string_set FStar_ST.ref)
        FStar_Pervasives_Native.option)
  =
  fun e  -> fun mname  -> FStar_Util.smap_try_find e.trans_exported_ids mname 
let (string_of_exported_id_kind : exported_id_kind -> Prims.string) =
  fun uu___104_2470  ->
    match uu___104_2470 with
    | Exported_id_field  -> "field"
    | Exported_id_term_type  -> "term/type"
  
let find_in_module_with_includes :
  'a .
    exported_id_kind ->
      (FStar_Ident.lident -> 'a cont_t) ->
        'a cont_t ->
          env -> FStar_Ident.lident -> FStar_Ident.ident -> 'a cont_t
  =
  fun eikind  ->
    fun find_in_module  ->
      fun find_in_module_default  ->
        fun env  ->
          fun ns  ->
            fun id1  ->
              let idstr = id1.FStar_Ident.idText  in
              let rec aux uu___105_2526 =
                match uu___105_2526 with
                | [] -> find_in_module_default
                | modul::q ->
                    let mname = modul.FStar_Ident.str  in
                    let not_shadowed =
                      let uu____2537 = get_exported_id_set env mname  in
                      match uu____2537 with
                      | FStar_Pervasives_Native.None  -> true
                      | FStar_Pervasives_Native.Some mex ->
                          let mexports =
                            let uu____2558 = mex eikind  in
                            FStar_ST.op_Bang uu____2558  in
                          FStar_Util.set_mem idstr mexports
                       in
                    let mincludes =
                      let uu____2672 =
                        FStar_Util.smap_try_find env.includes mname  in
                      match uu____2672 with
                      | FStar_Pervasives_Native.None  -> []
                      | FStar_Pervasives_Native.Some minc ->
                          FStar_ST.op_Bang minc
                       in
                    let look_into =
                      if not_shadowed
                      then
                        let uu____2748 = qual modul id1  in
                        find_in_module uu____2748
                      else Cont_ignore  in
                    (match look_into with
                     | Cont_ignore  -> aux (FStar_List.append mincludes q)
                     | uu____2752 -> look_into)
                 in
              aux [ns]
  
let (is_exported_id_field : exported_id_kind -> Prims.bool) =
  fun uu___106_2757  ->
    match uu___106_2757 with
    | Exported_id_field  -> true
    | uu____2758 -> false
  
let try_lookup_id'' :
  'a .
    env ->
      FStar_Ident.ident ->
        exported_id_kind ->
          (local_binding -> 'a cont_t) ->
            (rec_binding -> 'a cont_t) ->
              (record_or_dc -> 'a cont_t) ->
                (FStar_Ident.lident -> 'a cont_t) ->
                  ('a cont_t -> FStar_Ident.ident -> 'a cont_t) ->
                    'a FStar_Pervasives_Native.option
  =
  fun env  ->
    fun id1  ->
      fun eikind  ->
        fun k_local_binding  ->
          fun k_rec_binding  ->
            fun k_record  ->
              fun find_in_module  ->
                fun lookup_default_id  ->
                  let check_local_binding_id uu___107_2860 =
                    match uu___107_2860 with
                    | (id',uu____2862,uu____2863) ->
                        id'.FStar_Ident.idText = id1.FStar_Ident.idText
                     in
                  let check_rec_binding_id uu___108_2867 =
                    match uu___108_2867 with
                    | (id',uu____2869,uu____2870) ->
                        id'.FStar_Ident.idText = id1.FStar_Ident.idText
                     in
                  let curmod_ns =
                    let uu____2874 = current_module env  in
                    FStar_Ident.ids_of_lid uu____2874  in
                  let proc uu___109_2880 =
                    match uu___109_2880 with
                    | Local_binding l when check_local_binding_id l ->
                        k_local_binding l
                    | Rec_binding r when check_rec_binding_id r ->
                        k_rec_binding r
                    | Open_module_or_namespace (ns,Open_module ) ->
                        find_in_module_with_includes eikind find_in_module
                          Cont_ignore env ns id1
                    | Top_level_def id' when
                        id'.FStar_Ident.idText = id1.FStar_Ident.idText ->
                        lookup_default_id Cont_ignore id1
                    | Record_or_dc r when is_exported_id_field eikind ->
                        let uu____2888 = FStar_Ident.lid_of_ids curmod_ns  in
                        find_in_module_with_includes Exported_id_field
                          (fun lid  ->
                             let id2 = lid.FStar_Ident.ident  in
                             find_in_record lid.FStar_Ident.ns id2 r k_record)
                          Cont_ignore env uu____2888 id1
                    | uu____2893 -> Cont_ignore  in
                  let rec aux uu___110_2901 =
                    match uu___110_2901 with
                    | a::q ->
                        let uu____2910 = proc a  in
                        option_of_cont (fun uu____2914  -> aux q) uu____2910
                    | [] ->
                        let uu____2915 = lookup_default_id Cont_fail id1  in
                        option_of_cont
                          (fun uu____2919  -> FStar_Pervasives_Native.None)
                          uu____2915
                     in
                  aux env.scope_mods
  
let found_local_binding :
  'Auu____2924 'Auu____2925 .
    FStar_Range.range ->
      ('Auu____2924,FStar_Syntax_Syntax.bv,'Auu____2925)
        FStar_Pervasives_Native.tuple3 ->
        (FStar_Syntax_Syntax.term,'Auu____2925)
          FStar_Pervasives_Native.tuple2
  =
  fun r  ->
    fun uu____2943  ->
      match uu____2943 with
      | (id',x,mut) -> let uu____2953 = bv_to_name x r  in (uu____2953, mut)
  
let find_in_module :
  'Auu____2959 .
    env ->
      FStar_Ident.lident ->
        (FStar_Ident.lident ->
           (FStar_Syntax_Syntax.sigelt,Prims.bool)
             FStar_Pervasives_Native.tuple2 -> 'Auu____2959)
          -> 'Auu____2959 -> 'Auu____2959
  =
  fun env  ->
    fun lid  ->
      fun k_global_def  ->
        fun k_not_found  ->
          let uu____2994 =
            FStar_Util.smap_try_find (sigmap env) lid.FStar_Ident.str  in
          match uu____2994 with
          | FStar_Pervasives_Native.Some sb -> k_global_def lid sb
          | FStar_Pervasives_Native.None  -> k_not_found
  
let (try_lookup_id :
  env ->
    FStar_Ident.ident ->
      (FStar_Syntax_Syntax.term,Prims.bool) FStar_Pervasives_Native.tuple2
        FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun id1  ->
      let uu____3030 = unmangleOpName id1  in
      match uu____3030 with
      | FStar_Pervasives_Native.Some f -> FStar_Pervasives_Native.Some f
      | uu____3056 ->
          try_lookup_id'' env id1 Exported_id_term_type
            (fun r  ->
               let uu____3070 = found_local_binding id1.FStar_Ident.idRange r
                  in
               Cont_ok uu____3070) (fun uu____3080  -> Cont_fail)
            (fun uu____3086  -> Cont_ignore)
            (fun i  ->
               find_in_module env i
                 (fun uu____3101  -> fun uu____3102  -> Cont_fail)
                 Cont_ignore)
            (fun uu____3117  -> fun uu____3118  -> Cont_fail)
  
let lookup_default_id :
  'a .
    env ->
      FStar_Ident.ident ->
        (FStar_Ident.lident ->
           (FStar_Syntax_Syntax.sigelt,Prims.bool)
             FStar_Pervasives_Native.tuple2 -> 'a cont_t)
          -> 'a cont_t -> 'a cont_t
  =
  fun env  ->
    fun id1  ->
      fun k_global_def  ->
        fun k_not_found  ->
          let find_in_monad =
            match env.curmonad with
            | FStar_Pervasives_Native.Some uu____3188 ->
                let lid = qualify env id1  in
                let uu____3190 =
                  FStar_Util.smap_try_find (sigmap env) lid.FStar_Ident.str
                   in
                (match uu____3190 with
                 | FStar_Pervasives_Native.Some r ->
                     let uu____3214 = k_global_def lid r  in
                     FStar_Pervasives_Native.Some uu____3214
                 | FStar_Pervasives_Native.None  ->
                     FStar_Pervasives_Native.None)
            | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
             in
          match find_in_monad with
          | FStar_Pervasives_Native.Some v1 -> v1
          | FStar_Pervasives_Native.None  ->
              let lid =
                let uu____3237 = current_module env  in qual uu____3237 id1
                 in
              find_in_module env lid k_global_def k_not_found
  
let (lid_is_curmod : env -> FStar_Ident.lident -> Prims.bool) =
  fun env  ->
    fun lid  ->
      match env.curmodule with
      | FStar_Pervasives_Native.None  -> false
      | FStar_Pervasives_Native.Some m -> FStar_Ident.lid_equals lid m
  
let (module_is_defined : env -> FStar_Ident.lident -> Prims.bool) =
  fun env  ->
    fun lid  ->
      (lid_is_curmod env lid) ||
        (FStar_List.existsb
           (fun x  ->
              FStar_Ident.lid_equals lid (FStar_Pervasives_Native.fst x))
           env.modules)
  
let (resolve_module_name :
  env ->
    FStar_Ident.lident ->
      Prims.bool -> FStar_Ident.lident FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun lid  ->
      fun honor_ns  ->
        let nslen = FStar_List.length lid.FStar_Ident.ns  in
        let rec aux uu___111_3284 =
          match uu___111_3284 with
          | [] ->
              if module_is_defined env lid
              then FStar_Pervasives_Native.Some lid
              else FStar_Pervasives_Native.None
          | (Open_module_or_namespace (ns,Open_namespace ))::q when honor_ns
              ->
              let new_lid =
                let uu____3297 =
                  let uu____3300 = FStar_Ident.path_of_lid ns  in
                  let uu____3303 = FStar_Ident.path_of_lid lid  in
                  FStar_List.append uu____3300 uu____3303  in
                FStar_Ident.lid_of_path uu____3297
                  (FStar_Ident.range_of_lid lid)
                 in
              if module_is_defined env new_lid
              then FStar_Pervasives_Native.Some new_lid
              else aux q
          | (Module_abbrev (name,modul))::uu____3311 when
              (nslen = (Prims.parse_int "0")) &&
                (name.FStar_Ident.idText =
                   (lid.FStar_Ident.ident).FStar_Ident.idText)
              -> FStar_Pervasives_Native.Some modul
          | uu____3318::q -> aux q  in
        aux env.scope_mods
  
let (fail_if_curmodule :
  env -> FStar_Ident.lident -> FStar_Ident.lident -> Prims.unit) =
  fun env  ->
    fun ns_original  ->
      fun ns_resolved  ->
        let uu____3331 =
          let uu____3332 = current_module env  in
          FStar_Ident.lid_equals ns_resolved uu____3332  in
        if uu____3331
        then
          (if FStar_Ident.lid_equals ns_resolved FStar_Parser_Const.prims_lid
           then ()
           else
             (let uu____3334 =
                let uu____3339 =
                  FStar_Util.format1
                    "Reference %s to current module is forbidden (see GitHub issue #451)"
                    ns_original.FStar_Ident.str
                   in
                (FStar_Errors.Fatal_ForbiddenReferenceToCurrentModule,
                  uu____3339)
                 in
              FStar_Errors.raise_error uu____3334
                (FStar_Ident.range_of_lid ns_original)))
        else ()
  
let (fail_if_qualified_by_curmodule :
  env -> FStar_Ident.lident -> Prims.unit) =
  fun env  ->
    fun lid  ->
      match lid.FStar_Ident.ns with
      | [] -> ()
      | uu____3347 ->
          let modul_orig = FStar_Ident.lid_of_ids lid.FStar_Ident.ns  in
          let uu____3351 = resolve_module_name env modul_orig true  in
          (match uu____3351 with
           | FStar_Pervasives_Native.Some modul_res ->
               fail_if_curmodule env modul_orig modul_res
           | uu____3355 -> ())
  
let (is_open : env -> FStar_Ident.lident -> open_kind -> Prims.bool) =
  fun env  ->
    fun lid  ->
      fun open_kind  ->
        FStar_List.existsb
          (fun uu___112_3370  ->
             match uu___112_3370 with
             | Open_module_or_namespace (ns,k) ->
                 (k = open_kind) && (FStar_Ident.lid_equals lid ns)
             | uu____3373 -> false) env.scope_mods
  
let (namespace_is_open : env -> FStar_Ident.lident -> Prims.bool) =
  fun env  -> fun lid  -> is_open env lid Open_namespace 
let (module_is_open : env -> FStar_Ident.lident -> Prims.bool) =
  fun env  ->
    fun lid  -> (lid_is_curmod env lid) || (is_open env lid Open_module)
  
let (shorten_module_path :
  env ->
    FStar_Ident.ident Prims.list ->
      Prims.bool ->
        (FStar_Ident.ident Prims.list,FStar_Ident.ident Prims.list)
          FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun ids  ->
      fun is_full_path  ->
        let rec aux revns id1 =
          let lid = FStar_Ident.lid_of_ns_and_id (FStar_List.rev revns) id1
             in
          if namespace_is_open env lid
          then
            FStar_Pervasives_Native.Some
              ((FStar_List.rev (id1 :: revns)), [])
          else
            (match revns with
             | [] -> FStar_Pervasives_Native.None
             | ns_last_id::rev_ns_prefix ->
                 let uu____3474 = aux rev_ns_prefix ns_last_id  in
                 FStar_All.pipe_right uu____3474
                   (FStar_Util.map_option
                      (fun uu____3524  ->
                         match uu____3524 with
                         | (stripped_ids,rev_kept_ids) ->
                             (stripped_ids, (id1 :: rev_kept_ids)))))
           in
        let do_shorten env1 ids1 =
          match FStar_List.rev ids1 with
          | [] -> ([], [])
          | ns_last_id::ns_rev_prefix ->
              let uu____3590 = aux ns_rev_prefix ns_last_id  in
              (match uu____3590 with
               | FStar_Pervasives_Native.None  -> ([], ids1)
               | FStar_Pervasives_Native.Some (stripped_ids,rev_kept_ids) ->
                   (stripped_ids, (FStar_List.rev rev_kept_ids)))
           in
        if is_full_path
        then
          let uu____3651 =
            let uu____3654 = FStar_Ident.lid_of_ids ids  in
            resolve_module_name env uu____3654 true  in
          match uu____3651 with
          | FStar_Pervasives_Native.Some m when module_is_open env m ->
              (ids, [])
          | uu____3668 -> do_shorten env ids
        else do_shorten env ids
  
let resolve_in_open_namespaces'' :
  'a .
    env ->
      FStar_Ident.lident ->
        exported_id_kind ->
          (local_binding -> 'a cont_t) ->
            (rec_binding -> 'a cont_t) ->
              (record_or_dc -> 'a cont_t) ->
                (FStar_Ident.lident -> 'a cont_t) ->
                  ('a cont_t -> FStar_Ident.ident -> 'a cont_t) ->
                    'a FStar_Pervasives_Native.option
  =
  fun env  ->
    fun lid  ->
      fun eikind  ->
        fun k_local_binding  ->
          fun k_rec_binding  ->
            fun k_record  ->
              fun f_module  ->
                fun l_default  ->
                  match lid.FStar_Ident.ns with
                  | uu____3770::uu____3771 ->
                      let uu____3774 =
                        let uu____3777 =
                          let uu____3778 =
                            FStar_Ident.lid_of_ids lid.FStar_Ident.ns  in
                          FStar_Ident.set_lid_range uu____3778
                            (FStar_Ident.range_of_lid lid)
                           in
                        resolve_module_name env uu____3777 true  in
                      (match uu____3774 with
                       | FStar_Pervasives_Native.None  ->
                           FStar_Pervasives_Native.None
                       | FStar_Pervasives_Native.Some modul ->
                           let uu____3782 =
                             find_in_module_with_includes eikind f_module
                               Cont_fail env modul lid.FStar_Ident.ident
                              in
                           option_of_cont
                             (fun uu____3786  -> FStar_Pervasives_Native.None)
                             uu____3782)
                  | [] ->
                      try_lookup_id'' env lid.FStar_Ident.ident eikind
                        k_local_binding k_rec_binding k_record f_module
                        l_default
  
let cont_of_option :
  'a . 'a cont_t -> 'a FStar_Pervasives_Native.option -> 'a cont_t =
  fun k_none  ->
    fun uu___113_3804  ->
      match uu___113_3804 with
      | FStar_Pervasives_Native.Some v1 -> Cont_ok v1
      | FStar_Pervasives_Native.None  -> k_none
  
let resolve_in_open_namespaces' :
  'a .
    env ->
      FStar_Ident.lident ->
        (local_binding -> 'a FStar_Pervasives_Native.option) ->
          (rec_binding -> 'a FStar_Pervasives_Native.option) ->
            (FStar_Ident.lident ->
               (FStar_Syntax_Syntax.sigelt,Prims.bool)
                 FStar_Pervasives_Native.tuple2 ->
                 'a FStar_Pervasives_Native.option)
              -> 'a FStar_Pervasives_Native.option
  =
  fun env  ->
    fun lid  ->
      fun k_local_binding  ->
        fun k_rec_binding  ->
          fun k_global_def  ->
            let k_global_def' k lid1 def =
              let uu____3903 = k_global_def lid1 def  in
              cont_of_option k uu____3903  in
            let f_module lid' =
              let k = Cont_ignore  in
              find_in_module env lid' (k_global_def' k) k  in
            let l_default k i = lookup_default_id env i (k_global_def' k) k
               in
            resolve_in_open_namespaces'' env lid Exported_id_term_type
              (fun l  ->
                 let uu____3933 = k_local_binding l  in
                 cont_of_option Cont_fail uu____3933)
              (fun r  ->
                 let uu____3939 = k_rec_binding r  in
                 cont_of_option Cont_fail uu____3939)
              (fun uu____3943  -> Cont_ignore) f_module l_default
  
let (fv_qual_of_se :
  FStar_Syntax_Syntax.sigelt ->
    FStar_Syntax_Syntax.fv_qual FStar_Pervasives_Native.option)
  =
  fun se  ->
    match se.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_datacon
        (uu____3951,uu____3952,uu____3953,l,uu____3955,uu____3956) ->
        let qopt =
          FStar_Util.find_map se.FStar_Syntax_Syntax.sigquals
            (fun uu___114_3967  ->
               match uu___114_3967 with
               | FStar_Syntax_Syntax.RecordConstructor (uu____3970,fs) ->
                   FStar_Pervasives_Native.Some
                     (FStar_Syntax_Syntax.Record_ctor (l, fs))
               | uu____3982 -> FStar_Pervasives_Native.None)
           in
        (match qopt with
         | FStar_Pervasives_Native.None  ->
             FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor
         | x -> x)
    | FStar_Syntax_Syntax.Sig_declare_typ (uu____3988,uu____3989,uu____3990)
        -> FStar_Pervasives_Native.None
    | uu____3991 -> FStar_Pervasives_Native.None
  
let (lb_fv :
  FStar_Syntax_Syntax.letbinding Prims.list ->
    FStar_Ident.lident -> FStar_Syntax_Syntax.fv)
  =
  fun lbs  ->
    fun lid  ->
      let uu____4002 =
        FStar_Util.find_map lbs
          (fun lb  ->
             let fv = FStar_Util.right lb.FStar_Syntax_Syntax.lbname  in
             let uu____4010 = FStar_Syntax_Syntax.fv_eq_lid fv lid  in
             if uu____4010
             then FStar_Pervasives_Native.Some fv
             else FStar_Pervasives_Native.None)
         in
      FStar_All.pipe_right uu____4002 FStar_Util.must
  
let (ns_of_lid_equals :
  FStar_Ident.lident -> FStar_Ident.lident -> Prims.bool) =
  fun lid  ->
    fun ns  ->
      ((FStar_List.length lid.FStar_Ident.ns) =
         (FStar_List.length (FStar_Ident.ids_of_lid ns)))
        &&
        (let uu____4023 = FStar_Ident.lid_of_ids lid.FStar_Ident.ns  in
         FStar_Ident.lid_equals uu____4023 ns)
  
let (try_lookup_name :
  Prims.bool ->
    Prims.bool ->
      env -> FStar_Ident.lident -> foundname FStar_Pervasives_Native.option)
  =
  fun any_val  ->
    fun exclude_interf  ->
      fun env  ->
        fun lid  ->
          let occurrence_range = FStar_Ident.range_of_lid lid  in
          let k_global_def source_lid uu___119_4053 =
            match uu___119_4053 with
            | (uu____4060,true ) when exclude_interf ->
                FStar_Pervasives_Native.None
            | (se,uu____4062) ->
                (match se.FStar_Syntax_Syntax.sigel with
                 | FStar_Syntax_Syntax.Sig_inductive_typ uu____4065 ->
                     let uu____4082 =
                       let uu____4083 =
                         let uu____4092 =
                           FStar_Syntax_Syntax.fvar source_lid
                             FStar_Syntax_Syntax.Delta_constant
                             FStar_Pervasives_Native.None
                            in
                         (uu____4092, false,
                           (se.FStar_Syntax_Syntax.sigattrs))
                          in
                       Term_name uu____4083  in
                     FStar_Pervasives_Native.Some uu____4082
                 | FStar_Syntax_Syntax.Sig_datacon uu____4095 ->
                     let uu____4110 =
                       let uu____4111 =
                         let uu____4120 =
                           let uu____4121 = fv_qual_of_se se  in
                           FStar_Syntax_Syntax.fvar source_lid
                             FStar_Syntax_Syntax.Delta_constant uu____4121
                            in
                         (uu____4120, false,
                           (se.FStar_Syntax_Syntax.sigattrs))
                          in
                       Term_name uu____4111  in
                     FStar_Pervasives_Native.Some uu____4110
                 | FStar_Syntax_Syntax.Sig_let ((uu____4126,lbs),uu____4128)
                     ->
                     let fv = lb_fv lbs source_lid  in
                     let uu____4144 =
                       let uu____4145 =
                         let uu____4154 =
                           FStar_Syntax_Syntax.fvar source_lid
                             fv.FStar_Syntax_Syntax.fv_delta
                             fv.FStar_Syntax_Syntax.fv_qual
                            in
                         (uu____4154, false,
                           (se.FStar_Syntax_Syntax.sigattrs))
                          in
                       Term_name uu____4145  in
                     FStar_Pervasives_Native.Some uu____4144
                 | FStar_Syntax_Syntax.Sig_declare_typ
                     (lid1,uu____4158,uu____4159) ->
                     let quals = se.FStar_Syntax_Syntax.sigquals  in
                     let uu____4163 =
                       any_val ||
                         (FStar_All.pipe_right quals
                            (FStar_Util.for_some
                               (fun uu___115_4167  ->
                                  match uu___115_4167 with
                                  | FStar_Syntax_Syntax.Assumption  -> true
                                  | uu____4168 -> false)))
                        in
                     if uu____4163
                     then
                       let lid2 =
                         FStar_Ident.set_lid_range lid1
                           (FStar_Ident.range_of_lid source_lid)
                          in
                       let dd =
                         let uu____4173 =
                           (FStar_Syntax_Util.is_primop_lid lid2) ||
                             (FStar_All.pipe_right quals
                                (FStar_Util.for_some
                                   (fun uu___116_4178  ->
                                      match uu___116_4178 with
                                      | FStar_Syntax_Syntax.Projector
                                          uu____4179 -> true
                                      | FStar_Syntax_Syntax.Discriminator
                                          uu____4184 -> true
                                      | uu____4185 -> false)))
                            in
                         if uu____4173
                         then FStar_Syntax_Syntax.Delta_equational
                         else FStar_Syntax_Syntax.Delta_constant  in
                       let dd1 =
                         let uu____4188 =
                           FStar_All.pipe_right quals
                             (FStar_Util.for_some
                                (fun uu___117_4192  ->
                                   match uu___117_4192 with
                                   | FStar_Syntax_Syntax.Abstract  -> true
                                   | uu____4193 -> false))
                            in
                         if uu____4188
                         then FStar_Syntax_Syntax.Delta_abstract dd
                         else dd  in
                       let uu____4195 =
                         FStar_Util.find_map quals
                           (fun uu___118_4200  ->
                              match uu___118_4200 with
                              | FStar_Syntax_Syntax.Reflectable refl_monad ->
                                  FStar_Pervasives_Native.Some refl_monad
                              | uu____4204 -> FStar_Pervasives_Native.None)
                          in
                       (match uu____4195 with
                        | FStar_Pervasives_Native.Some refl_monad ->
                            let refl_const =
                              FStar_Syntax_Syntax.mk
                                (FStar_Syntax_Syntax.Tm_constant
                                   (FStar_Const.Const_reflect refl_monad))
                                FStar_Pervasives_Native.None occurrence_range
                               in
                            FStar_Pervasives_Native.Some
                              (Term_name
                                 (refl_const, false,
                                   (se.FStar_Syntax_Syntax.sigattrs)))
                        | uu____4215 ->
                            let uu____4218 =
                              let uu____4219 =
                                let uu____4228 =
                                  let uu____4229 = fv_qual_of_se se  in
                                  FStar_Syntax_Syntax.fvar lid2 dd1
                                    uu____4229
                                   in
                                (uu____4228, false,
                                  (se.FStar_Syntax_Syntax.sigattrs))
                                 in
                              Term_name uu____4219  in
                            FStar_Pervasives_Native.Some uu____4218)
                     else FStar_Pervasives_Native.None
                 | FStar_Syntax_Syntax.Sig_new_effect_for_free ne ->
                     FStar_Pervasives_Native.Some
                       (Eff_name
                          (se,
                            (FStar_Ident.set_lid_range
                               ne.FStar_Syntax_Syntax.mname
                               (FStar_Ident.range_of_lid source_lid))))
                 | FStar_Syntax_Syntax.Sig_new_effect ne ->
                     FStar_Pervasives_Native.Some
                       (Eff_name
                          (se,
                            (FStar_Ident.set_lid_range
                               ne.FStar_Syntax_Syntax.mname
                               (FStar_Ident.range_of_lid source_lid))))
                 | FStar_Syntax_Syntax.Sig_effect_abbrev uu____4237 ->
                     FStar_Pervasives_Native.Some (Eff_name (se, source_lid))
                 | uu____4250 -> FStar_Pervasives_Native.None)
             in
          let k_local_binding r =
            let uu____4269 =
              found_local_binding (FStar_Ident.range_of_lid lid) r  in
            match uu____4269 with
            | (t,mut) ->
                FStar_Pervasives_Native.Some (Term_name (t, mut, []))
             in
          let k_rec_binding uu____4291 =
            match uu____4291 with
            | (id1,l,dd) ->
                let uu____4303 =
                  let uu____4304 =
                    let uu____4313 =
                      FStar_Syntax_Syntax.fvar
                        (FStar_Ident.set_lid_range l
                           (FStar_Ident.range_of_lid lid)) dd
                        FStar_Pervasives_Native.None
                       in
                    (uu____4313, false, [])  in
                  Term_name uu____4304  in
                FStar_Pervasives_Native.Some uu____4303
             in
          let found_unmangled =
            match lid.FStar_Ident.ns with
            | [] ->
                let uu____4321 = unmangleOpName lid.FStar_Ident.ident  in
                (match uu____4321 with
                 | FStar_Pervasives_Native.Some (t,mut) ->
                     FStar_Pervasives_Native.Some (Term_name (t, mut, []))
                 | uu____4338 -> FStar_Pervasives_Native.None)
            | uu____4345 -> FStar_Pervasives_Native.None  in
          match found_unmangled with
          | FStar_Pervasives_Native.None  ->
              resolve_in_open_namespaces' env lid k_local_binding
                k_rec_binding k_global_def
          | x -> x
  
let (try_lookup_effect_name' :
  Prims.bool ->
    env ->
      FStar_Ident.lident ->
        (FStar_Syntax_Syntax.sigelt,FStar_Ident.lident)
          FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option)
  =
  fun exclude_interf  ->
    fun env  ->
      fun lid  ->
        let uu____4374 = try_lookup_name true exclude_interf env lid  in
        match uu____4374 with
        | FStar_Pervasives_Native.Some (Eff_name (o,l)) ->
            FStar_Pervasives_Native.Some (o, l)
        | uu____4389 -> FStar_Pervasives_Native.None
  
let (try_lookup_effect_name :
  env ->
    FStar_Ident.lident -> FStar_Ident.lident FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun l  ->
      let uu____4404 =
        try_lookup_effect_name' (Prims.op_Negation env.iface) env l  in
      match uu____4404 with
      | FStar_Pervasives_Native.Some (o,l1) ->
          FStar_Pervasives_Native.Some l1
      | uu____4419 -> FStar_Pervasives_Native.None
  
let (try_lookup_effect_name_and_attributes :
  env ->
    FStar_Ident.lident ->
      (FStar_Ident.lident,FStar_Syntax_Syntax.cflags Prims.list)
        FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun l  ->
      let uu____4440 =
        try_lookup_effect_name' (Prims.op_Negation env.iface) env l  in
      match uu____4440 with
      | FStar_Pervasives_Native.Some
          ({
             FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_new_effect
               ne;
             FStar_Syntax_Syntax.sigrng = uu____4456;
             FStar_Syntax_Syntax.sigquals = uu____4457;
             FStar_Syntax_Syntax.sigmeta = uu____4458;
             FStar_Syntax_Syntax.sigattrs = uu____4459;_},l1)
          ->
          FStar_Pervasives_Native.Some
            (l1, (ne.FStar_Syntax_Syntax.cattributes))
      | FStar_Pervasives_Native.Some
          ({
             FStar_Syntax_Syntax.sigel =
               FStar_Syntax_Syntax.Sig_new_effect_for_free ne;
             FStar_Syntax_Syntax.sigrng = uu____4478;
             FStar_Syntax_Syntax.sigquals = uu____4479;
             FStar_Syntax_Syntax.sigmeta = uu____4480;
             FStar_Syntax_Syntax.sigattrs = uu____4481;_},l1)
          ->
          FStar_Pervasives_Native.Some
            (l1, (ne.FStar_Syntax_Syntax.cattributes))
      | FStar_Pervasives_Native.Some
          ({
             FStar_Syntax_Syntax.sigel =
               FStar_Syntax_Syntax.Sig_effect_abbrev
               (uu____4499,uu____4500,uu____4501,uu____4502,cattributes);
             FStar_Syntax_Syntax.sigrng = uu____4504;
             FStar_Syntax_Syntax.sigquals = uu____4505;
             FStar_Syntax_Syntax.sigmeta = uu____4506;
             FStar_Syntax_Syntax.sigattrs = uu____4507;_},l1)
          -> FStar_Pervasives_Native.Some (l1, cattributes)
      | uu____4529 -> FStar_Pervasives_Native.None
  
let (try_lookup_effect_defn :
  env ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.eff_decl FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun l  ->
      let uu____4550 =
        try_lookup_effect_name' (Prims.op_Negation env.iface) env l  in
      match uu____4550 with
      | FStar_Pervasives_Native.Some
          ({
             FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_new_effect
               ne;
             FStar_Syntax_Syntax.sigrng = uu____4560;
             FStar_Syntax_Syntax.sigquals = uu____4561;
             FStar_Syntax_Syntax.sigmeta = uu____4562;
             FStar_Syntax_Syntax.sigattrs = uu____4563;_},uu____4564)
          -> FStar_Pervasives_Native.Some ne
      | FStar_Pervasives_Native.Some
          ({
             FStar_Syntax_Syntax.sigel =
               FStar_Syntax_Syntax.Sig_new_effect_for_free ne;
             FStar_Syntax_Syntax.sigrng = uu____4574;
             FStar_Syntax_Syntax.sigquals = uu____4575;
             FStar_Syntax_Syntax.sigmeta = uu____4576;
             FStar_Syntax_Syntax.sigattrs = uu____4577;_},uu____4578)
          -> FStar_Pervasives_Native.Some ne
      | uu____4587 -> FStar_Pervasives_Native.None
  
let (is_effect_name : env -> FStar_Ident.lident -> Prims.bool) =
  fun env  ->
    fun lid  ->
      let uu____4600 = try_lookup_effect_name env lid  in
      match uu____4600 with
      | FStar_Pervasives_Native.None  -> false
      | FStar_Pervasives_Native.Some uu____4603 -> true
  
let (try_lookup_root_effect_name :
  env ->
    FStar_Ident.lident -> FStar_Ident.lident FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun l  ->
      let uu____4612 =
        try_lookup_effect_name' (Prims.op_Negation env.iface) env l  in
      match uu____4612 with
      | FStar_Pervasives_Native.Some
          ({
             FStar_Syntax_Syntax.sigel =
               FStar_Syntax_Syntax.Sig_effect_abbrev
               (l',uu____4622,uu____4623,uu____4624,uu____4625);
             FStar_Syntax_Syntax.sigrng = uu____4626;
             FStar_Syntax_Syntax.sigquals = uu____4627;
             FStar_Syntax_Syntax.sigmeta = uu____4628;
             FStar_Syntax_Syntax.sigattrs = uu____4629;_},uu____4630)
          ->
          let rec aux new_name =
            let uu____4649 =
              FStar_Util.smap_try_find (sigmap env) new_name.FStar_Ident.str
               in
            match uu____4649 with
            | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
            | FStar_Pervasives_Native.Some (s,uu____4667) ->
                (match s.FStar_Syntax_Syntax.sigel with
                 | FStar_Syntax_Syntax.Sig_new_effect_for_free ne ->
                     FStar_Pervasives_Native.Some
                       (FStar_Ident.set_lid_range
                          ne.FStar_Syntax_Syntax.mname
                          (FStar_Ident.range_of_lid l))
                 | FStar_Syntax_Syntax.Sig_new_effect ne ->
                     FStar_Pervasives_Native.Some
                       (FStar_Ident.set_lid_range
                          ne.FStar_Syntax_Syntax.mname
                          (FStar_Ident.range_of_lid l))
                 | FStar_Syntax_Syntax.Sig_effect_abbrev
                     (uu____4676,uu____4677,uu____4678,cmp,uu____4680) ->
                     let l'' = FStar_Syntax_Util.comp_effect_name cmp  in
                     aux l''
                 | uu____4686 -> FStar_Pervasives_Native.None)
             in
          aux l'
      | FStar_Pervasives_Native.Some (uu____4687,l') ->
          FStar_Pervasives_Native.Some l'
      | uu____4693 -> FStar_Pervasives_Native.None
  
let (lookup_letbinding_quals :
  env -> FStar_Ident.lident -> FStar_Syntax_Syntax.qualifier Prims.list) =
  fun env  ->
    fun lid  ->
      let k_global_def lid1 uu___120_4722 =
        match uu___120_4722 with
        | ({
             FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_declare_typ
               (uu____4731,uu____4732,uu____4733);
             FStar_Syntax_Syntax.sigrng = uu____4734;
             FStar_Syntax_Syntax.sigquals = quals;
             FStar_Syntax_Syntax.sigmeta = uu____4736;
             FStar_Syntax_Syntax.sigattrs = uu____4737;_},uu____4738)
            -> FStar_Pervasives_Native.Some quals
        | uu____4745 -> FStar_Pervasives_Native.None  in
      let uu____4752 =
        resolve_in_open_namespaces' env lid
          (fun uu____4760  -> FStar_Pervasives_Native.None)
          (fun uu____4764  -> FStar_Pervasives_Native.None) k_global_def
         in
      match uu____4752 with
      | FStar_Pervasives_Native.Some quals -> quals
      | uu____4774 -> []
  
let (try_lookup_module :
  env ->
    Prims.string Prims.list ->
      FStar_Syntax_Syntax.modul FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun path  ->
      let uu____4791 =
        FStar_List.tryFind
          (fun uu____4806  ->
             match uu____4806 with
             | (mlid,modul) ->
                 let uu____4813 = FStar_Ident.path_of_lid mlid  in
                 uu____4813 = path) env.modules
         in
      match uu____4791 with
      | FStar_Pervasives_Native.Some (uu____4820,modul) ->
          FStar_Pervasives_Native.Some modul
      | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
  
let (try_lookup_let :
  env ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.term FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun lid  ->
      let k_global_def lid1 uu___121_4850 =
        match uu___121_4850 with
        | ({
             FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_let
               ((uu____4857,lbs),uu____4859);
             FStar_Syntax_Syntax.sigrng = uu____4860;
             FStar_Syntax_Syntax.sigquals = uu____4861;
             FStar_Syntax_Syntax.sigmeta = uu____4862;
             FStar_Syntax_Syntax.sigattrs = uu____4863;_},uu____4864)
            ->
            let fv = lb_fv lbs lid1  in
            let uu____4884 =
              FStar_Syntax_Syntax.fvar lid1 fv.FStar_Syntax_Syntax.fv_delta
                fv.FStar_Syntax_Syntax.fv_qual
               in
            FStar_Pervasives_Native.Some uu____4884
        | uu____4885 -> FStar_Pervasives_Native.None  in
      resolve_in_open_namespaces' env lid
        (fun uu____4891  -> FStar_Pervasives_Native.None)
        (fun uu____4893  -> FStar_Pervasives_Native.None) k_global_def
  
let (try_lookup_definition :
  env ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.term FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun lid  ->
      let k_global_def lid1 uu___122_4916 =
        match uu___122_4916 with
        | ({
             FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_let
               (lbs,uu____4926);
             FStar_Syntax_Syntax.sigrng = uu____4927;
             FStar_Syntax_Syntax.sigquals = uu____4928;
             FStar_Syntax_Syntax.sigmeta = uu____4929;
             FStar_Syntax_Syntax.sigattrs = uu____4930;_},uu____4931)
            ->
            FStar_Util.find_map (FStar_Pervasives_Native.snd lbs)
              (fun lb  ->
                 match lb.FStar_Syntax_Syntax.lbname with
                 | FStar_Util.Inr fv when
                     FStar_Syntax_Syntax.fv_eq_lid fv lid1 ->
                     FStar_Pervasives_Native.Some
                       (lb.FStar_Syntax_Syntax.lbdef)
                 | uu____4954 -> FStar_Pervasives_Native.None)
        | uu____4961 -> FStar_Pervasives_Native.None  in
      resolve_in_open_namespaces' env lid
        (fun uu____4971  -> FStar_Pervasives_Native.None)
        (fun uu____4975  -> FStar_Pervasives_Native.None) k_global_def
  
let (empty_include_smap :
  FStar_Ident.lident Prims.list FStar_ST.ref FStar_Util.smap) = new_sigmap () 
let (empty_exported_id_smap : exported_id_set FStar_Util.smap) =
  new_sigmap () 
let (try_lookup_lid' :
  Prims.bool ->
    Prims.bool ->
      env ->
        FStar_Ident.lident ->
          (FStar_Syntax_Syntax.term,Prims.bool,FStar_Syntax_Syntax.attribute
                                                 Prims.list)
            FStar_Pervasives_Native.tuple3 FStar_Pervasives_Native.option)
  =
  fun any_val  ->
    fun exclude_interface  ->
      fun env  ->
        fun lid  ->
          let uu____5022 = try_lookup_name any_val exclude_interface env lid
             in
          match uu____5022 with
          | FStar_Pervasives_Native.Some (Term_name (e,mut,attrs)) ->
              FStar_Pervasives_Native.Some (e, mut, attrs)
          | uu____5052 -> FStar_Pervasives_Native.None
  
let (drop_attributes :
  (FStar_Syntax_Syntax.term,Prims.bool,FStar_Syntax_Syntax.attribute
                                         Prims.list)
    FStar_Pervasives_Native.tuple3 FStar_Pervasives_Native.option ->
    (FStar_Syntax_Syntax.term,Prims.bool) FStar_Pervasives_Native.tuple2
      FStar_Pervasives_Native.option)
  =
  fun x  ->
    match x with
    | FStar_Pervasives_Native.Some (t,mut,uu____5106) ->
        FStar_Pervasives_Native.Some (t, mut)
    | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
  
let (try_lookup_lid_with_attributes :
  env ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.term,Prims.bool,FStar_Syntax_Syntax.attribute
                                             Prims.list)
        FStar_Pervasives_Native.tuple3 FStar_Pervasives_Native.option)
  = fun env  -> fun l  -> try_lookup_lid' env.iface false env l 
let (try_lookup_lid :
  env ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.term,Prims.bool) FStar_Pervasives_Native.tuple2
        FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun l  ->
      let uu____5173 = try_lookup_lid_with_attributes env l  in
      FStar_All.pipe_right uu____5173 drop_attributes
  
let (resolve_to_fully_qualified_name :
  env ->
    FStar_Ident.lident -> FStar_Ident.lident FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun l  ->
      let uu____5208 = try_lookup_lid env l  in
      match uu____5208 with
      | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
      | FStar_Pervasives_Native.Some (e,uu____5222) ->
          let uu____5227 =
            let uu____5228 = FStar_Syntax_Subst.compress e  in
            uu____5228.FStar_Syntax_Syntax.n  in
          (match uu____5227 with
           | FStar_Syntax_Syntax.Tm_fvar fv ->
               FStar_Pervasives_Native.Some
                 ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
           | uu____5234 -> FStar_Pervasives_Native.None)
  
let (shorten_lid' : env -> FStar_Ident.lident -> FStar_Ident.lident) =
  fun env  ->
    fun lid  ->
      let uu____5241 = shorten_module_path env lid.FStar_Ident.ns true  in
      match uu____5241 with
      | (uu____5250,short) ->
          FStar_Ident.lid_of_ns_and_id short lid.FStar_Ident.ident
  
let (shorten_lid : env -> FStar_Ident.lid -> FStar_Ident.lid) =
  fun env  ->
    fun lid  ->
      match env.curmodule with
      | FStar_Pervasives_Native.None  -> shorten_lid' env lid
      | uu____5266 ->
          let lid_without_ns =
            FStar_Ident.lid_of_ns_and_id [] lid.FStar_Ident.ident  in
          let uu____5270 = resolve_to_fully_qualified_name env lid_without_ns
             in
          (match uu____5270 with
           | FStar_Pervasives_Native.Some lid' when
               lid'.FStar_Ident.str = lid.FStar_Ident.str -> lid_without_ns
           | uu____5274 -> shorten_lid' env lid)
  
let (try_lookup_lid_with_attributes_no_resolve :
  env ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.term,Prims.bool,FStar_Syntax_Syntax.attribute
                                             Prims.list)
        FStar_Pervasives_Native.tuple3 FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun l  ->
      let env' =
        let uu___143_5304 = env  in
        {
          curmodule = (uu___143_5304.curmodule);
          curmonad = (uu___143_5304.curmonad);
          modules = (uu___143_5304.modules);
          scope_mods = [];
          exported_ids = empty_exported_id_smap;
          trans_exported_ids = (uu___143_5304.trans_exported_ids);
          includes = empty_include_smap;
          sigaccum = (uu___143_5304.sigaccum);
          sigmap = (uu___143_5304.sigmap);
          iface = (uu___143_5304.iface);
          admitted_iface = (uu___143_5304.admitted_iface);
          expect_typ = (uu___143_5304.expect_typ);
          docs = (uu___143_5304.docs);
          remaining_iface_decls = (uu___143_5304.remaining_iface_decls);
          syntax_only = (uu___143_5304.syntax_only);
          ds_hooks = (uu___143_5304.ds_hooks)
        }  in
      try_lookup_lid_with_attributes env' l
  
let (try_lookup_lid_no_resolve :
  env ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.term,Prims.bool) FStar_Pervasives_Native.tuple2
        FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun l  ->
      let uu____5323 = try_lookup_lid_with_attributes_no_resolve env l  in
      FStar_All.pipe_right uu____5323 drop_attributes
  
let (try_lookup_doc :
  env ->
    FStar_Ident.lid -> FStar_Parser_AST.fsdoc FStar_Pervasives_Native.option)
  = fun env  -> fun l  -> FStar_Util.smap_try_find env.docs l.FStar_Ident.str 
let (try_lookup_datacon :
  env ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.fv FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun lid  ->
      let k_global_def lid1 uu___124_5378 =
        match uu___124_5378 with
        | ({
             FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_declare_typ
               (uu____5385,uu____5386,uu____5387);
             FStar_Syntax_Syntax.sigrng = uu____5388;
             FStar_Syntax_Syntax.sigquals = quals;
             FStar_Syntax_Syntax.sigmeta = uu____5390;
             FStar_Syntax_Syntax.sigattrs = uu____5391;_},uu____5392)
            ->
            let uu____5397 =
              FStar_All.pipe_right quals
                (FStar_Util.for_some
                   (fun uu___123_5401  ->
                      match uu___123_5401 with
                      | FStar_Syntax_Syntax.Assumption  -> true
                      | uu____5402 -> false))
               in
            if uu____5397
            then
              let uu____5405 =
                FStar_Syntax_Syntax.lid_as_fv lid1
                  FStar_Syntax_Syntax.Delta_constant
                  FStar_Pervasives_Native.None
                 in
              FStar_Pervasives_Native.Some uu____5405
            else FStar_Pervasives_Native.None
        | ({
             FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_datacon
               uu____5407;
             FStar_Syntax_Syntax.sigrng = uu____5408;
             FStar_Syntax_Syntax.sigquals = uu____5409;
             FStar_Syntax_Syntax.sigmeta = uu____5410;
             FStar_Syntax_Syntax.sigattrs = uu____5411;_},uu____5412)
            ->
            let uu____5431 =
              FStar_Syntax_Syntax.lid_as_fv lid1
                FStar_Syntax_Syntax.Delta_constant
                (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor)
               in
            FStar_Pervasives_Native.Some uu____5431
        | uu____5432 -> FStar_Pervasives_Native.None  in
      resolve_in_open_namespaces' env lid
        (fun uu____5438  -> FStar_Pervasives_Native.None)
        (fun uu____5440  -> FStar_Pervasives_Native.None) k_global_def
  
let (find_all_datacons :
  env ->
    FStar_Ident.lident ->
      FStar_Ident.lident Prims.list FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun lid  ->
      let k_global_def lid1 uu___125_5465 =
        match uu___125_5465 with
        | ({
             FStar_Syntax_Syntax.sigel =
               FStar_Syntax_Syntax.Sig_inductive_typ
               (uu____5474,uu____5475,uu____5476,uu____5477,datas,uu____5479);
             FStar_Syntax_Syntax.sigrng = uu____5480;
             FStar_Syntax_Syntax.sigquals = uu____5481;
             FStar_Syntax_Syntax.sigmeta = uu____5482;
             FStar_Syntax_Syntax.sigattrs = uu____5483;_},uu____5484)
            -> FStar_Pervasives_Native.Some datas
        | uu____5499 -> FStar_Pervasives_Native.None  in
      resolve_in_open_namespaces' env lid
        (fun uu____5509  -> FStar_Pervasives_Native.None)
        (fun uu____5513  -> FStar_Pervasives_Native.None) k_global_def
  
let (record_cache_aux_with_filter :
  ((Prims.unit -> Prims.unit,Prims.unit -> Prims.unit,Prims.unit ->
                                                        record_or_dc
                                                          Prims.list,
     record_or_dc -> Prims.unit) FStar_Pervasives_Native.tuple4,Prims.unit ->
                                                                  Prims.unit)
    FStar_Pervasives_Native.tuple2)
  =
  let record_cache = FStar_Util.mk_ref [[]]  in
  let push1 uu____5558 =
    let uu____5559 =
      let uu____5564 =
        let uu____5567 = FStar_ST.op_Bang record_cache  in
        FStar_List.hd uu____5567  in
      let uu____5623 = FStar_ST.op_Bang record_cache  in uu____5564 ::
        uu____5623
       in
    FStar_ST.op_Colon_Equals record_cache uu____5559  in
  let pop1 uu____5731 =
    let uu____5732 =
      let uu____5737 = FStar_ST.op_Bang record_cache  in
      FStar_List.tl uu____5737  in
    FStar_ST.op_Colon_Equals record_cache uu____5732  in
  let peek1 uu____5847 =
    let uu____5848 = FStar_ST.op_Bang record_cache  in
    FStar_List.hd uu____5848  in
  let insert r =
    let uu____5908 =
      let uu____5913 = let uu____5916 = peek1 ()  in r :: uu____5916  in
      let uu____5919 =
        let uu____5924 = FStar_ST.op_Bang record_cache  in
        FStar_List.tl uu____5924  in
      uu____5913 :: uu____5919  in
    FStar_ST.op_Colon_Equals record_cache uu____5908  in
  let filter1 uu____6034 =
    let rc = peek1 ()  in
    let filtered =
      FStar_List.filter
        (fun r  -> Prims.op_Negation r.is_private_or_abstract) rc
       in
    let uu____6043 =
      let uu____6048 =
        let uu____6053 = FStar_ST.op_Bang record_cache  in
        FStar_List.tl uu____6053  in
      filtered :: uu____6048  in
    FStar_ST.op_Colon_Equals record_cache uu____6043  in
  let aux = (push1, pop1, peek1, insert)  in (aux, filter1) 
let (record_cache_aux :
  (Prims.unit -> Prims.unit,Prims.unit -> Prims.unit,Prims.unit ->
                                                       record_or_dc
                                                         Prims.list,record_or_dc
                                                                    ->
                                                                    Prims.unit)
    FStar_Pervasives_Native.tuple4)
  =
  let uu____6227 = record_cache_aux_with_filter  in
  match uu____6227 with | (aux,uu____6271) -> aux 
let (filter_record_cache : Prims.unit -> Prims.unit) =
  let uu____6314 = record_cache_aux_with_filter  in
  match uu____6314 with | (uu____6341,filter1) -> filter1 
let (push_record_cache : Prims.unit -> Prims.unit) =
  let uu____6385 = record_cache_aux  in
  match uu____6385 with | (push1,uu____6407,uu____6408,uu____6409) -> push1 
let (pop_record_cache : Prims.unit -> Prims.unit) =
  let uu____6432 = record_cache_aux  in
  match uu____6432 with | (uu____6453,pop1,uu____6455,uu____6456) -> pop1 
let (peek_record_cache : Prims.unit -> record_or_dc Prims.list) =
  let uu____6481 = record_cache_aux  in
  match uu____6481 with | (uu____6504,uu____6505,peek1,uu____6507) -> peek1 
let (insert_record_cache : record_or_dc -> Prims.unit) =
  let uu____6530 = record_cache_aux  in
  match uu____6530 with | (uu____6551,uu____6552,uu____6553,insert) -> insert 
let (extract_record :
  env ->
    scope_mod Prims.list FStar_ST.ref ->
      FStar_Syntax_Syntax.sigelt -> Prims.unit)
  =
  fun e  ->
    fun new_globs  ->
      fun se  ->
        match se.FStar_Syntax_Syntax.sigel with
        | FStar_Syntax_Syntax.Sig_bundle (sigs,uu____6615) ->
            let is_record =
              FStar_Util.for_some
                (fun uu___126_6631  ->
                   match uu___126_6631 with
                   | FStar_Syntax_Syntax.RecordType uu____6632 -> true
                   | FStar_Syntax_Syntax.RecordConstructor uu____6641 -> true
                   | uu____6650 -> false)
               in
            let find_dc dc =
              FStar_All.pipe_right sigs
                (FStar_Util.find_opt
                   (fun uu___127_6672  ->
                      match uu___127_6672 with
                      | {
                          FStar_Syntax_Syntax.sigel =
                            FStar_Syntax_Syntax.Sig_datacon
                            (lid,uu____6674,uu____6675,uu____6676,uu____6677,uu____6678);
                          FStar_Syntax_Syntax.sigrng = uu____6679;
                          FStar_Syntax_Syntax.sigquals = uu____6680;
                          FStar_Syntax_Syntax.sigmeta = uu____6681;
                          FStar_Syntax_Syntax.sigattrs = uu____6682;_} ->
                          FStar_Ident.lid_equals dc lid
                      | uu____6691 -> false))
               in
            FStar_All.pipe_right sigs
              (FStar_List.iter
                 (fun uu___128_6726  ->
                    match uu___128_6726 with
                    | {
                        FStar_Syntax_Syntax.sigel =
                          FStar_Syntax_Syntax.Sig_inductive_typ
                          (typename,univs1,parms,uu____6730,uu____6731,dc::[]);
                        FStar_Syntax_Syntax.sigrng = uu____6733;
                        FStar_Syntax_Syntax.sigquals = typename_quals;
                        FStar_Syntax_Syntax.sigmeta = uu____6735;
                        FStar_Syntax_Syntax.sigattrs = uu____6736;_} ->
                        let uu____6747 =
                          let uu____6748 = find_dc dc  in
                          FStar_All.pipe_left FStar_Util.must uu____6748  in
                        (match uu____6747 with
                         | {
                             FStar_Syntax_Syntax.sigel =
                               FStar_Syntax_Syntax.Sig_datacon
                               (constrname,uu____6754,t,uu____6756,uu____6757,uu____6758);
                             FStar_Syntax_Syntax.sigrng = uu____6759;
                             FStar_Syntax_Syntax.sigquals = uu____6760;
                             FStar_Syntax_Syntax.sigmeta = uu____6761;
                             FStar_Syntax_Syntax.sigattrs = uu____6762;_} ->
                             let uu____6771 =
                               FStar_Syntax_Util.arrow_formals t  in
                             (match uu____6771 with
                              | (formals,uu____6785) ->
                                  let is_rec = is_record typename_quals  in
                                  let formals' =
                                    FStar_All.pipe_right formals
                                      (FStar_List.collect
                                         (fun uu____6834  ->
                                            match uu____6834 with
                                            | (x,q) ->
                                                let uu____6847 =
                                                  (FStar_Syntax_Syntax.is_null_bv
                                                     x)
                                                    ||
                                                    (is_rec &&
                                                       (FStar_Syntax_Syntax.is_implicit
                                                          q))
                                                   in
                                                if uu____6847
                                                then []
                                                else [(x, q)]))
                                     in
                                  let fields' =
                                    FStar_All.pipe_right formals'
                                      (FStar_List.map
                                         (fun uu____6904  ->
                                            match uu____6904 with
                                            | (x,q) ->
                                                let uu____6917 =
                                                  if is_rec
                                                  then
                                                    FStar_Syntax_Util.unmangle_field_name
                                                      x.FStar_Syntax_Syntax.ppname
                                                  else
                                                    x.FStar_Syntax_Syntax.ppname
                                                   in
                                                (uu____6917,
                                                  (x.FStar_Syntax_Syntax.sort))))
                                     in
                                  let fields = fields'  in
                                  let record =
                                    {
                                      typename;
                                      constrname =
                                        (constrname.FStar_Ident.ident);
                                      parms;
                                      fields;
                                      is_private_or_abstract =
                                        ((FStar_List.contains
                                            FStar_Syntax_Syntax.Private
                                            typename_quals)
                                           ||
                                           (FStar_List.contains
                                              FStar_Syntax_Syntax.Abstract
                                              typename_quals));
                                      is_record = is_rec
                                    }  in
                                  ((let uu____6932 =
                                      let uu____6935 =
                                        FStar_ST.op_Bang new_globs  in
                                      (Record_or_dc record) :: uu____6935  in
                                    FStar_ST.op_Colon_Equals new_globs
                                      uu____6932);
                                   (match () with
                                    | () ->
                                        ((let add_field uu____7038 =
                                            match uu____7038 with
                                            | (id1,uu____7046) ->
                                                let modul =
                                                  let uu____7052 =
                                                    FStar_Ident.lid_of_ids
                                                      constrname.FStar_Ident.ns
                                                     in
                                                  uu____7052.FStar_Ident.str
                                                   in
                                                let uu____7053 =
                                                  get_exported_id_set e modul
                                                   in
                                                (match uu____7053 with
                                                 | FStar_Pervasives_Native.Some
                                                     my_ex ->
                                                     let my_exported_ids =
                                                       my_ex
                                                         Exported_id_field
                                                        in
                                                     ((let uu____7084 =
                                                         let uu____7085 =
                                                           FStar_ST.op_Bang
                                                             my_exported_ids
                                                            in
                                                         FStar_Util.set_add
                                                           id1.FStar_Ident.idText
                                                           uu____7085
                                                          in
                                                       FStar_ST.op_Colon_Equals
                                                         my_exported_ids
                                                         uu____7084);
                                                      (match () with
                                                       | () ->
                                                           let projname =
                                                             let uu____7171 =
                                                               let uu____7172
                                                                 =
                                                                 FStar_Syntax_Util.mk_field_projector_name_from_ident
                                                                   constrname
                                                                   id1
                                                                  in
                                                               uu____7172.FStar_Ident.ident
                                                                in
                                                             uu____7171.FStar_Ident.idText
                                                              in
                                                           let uu____7174 =
                                                             let uu____7175 =
                                                               FStar_ST.op_Bang
                                                                 my_exported_ids
                                                                in
                                                             FStar_Util.set_add
                                                               projname
                                                               uu____7175
                                                              in
                                                           FStar_ST.op_Colon_Equals
                                                             my_exported_ids
                                                             uu____7174))
                                                 | FStar_Pervasives_Native.None
                                                      -> ())
                                             in
                                          FStar_List.iter add_field fields');
                                         (match () with
                                          | () -> insert_record_cache record)))))
                         | uu____7270 -> ())
                    | uu____7271 -> ()))
        | uu____7272 -> ()
  
let (try_lookup_record_or_dc_by_field_name :
  env -> FStar_Ident.lident -> record_or_dc FStar_Pervasives_Native.option) =
  fun env  ->
    fun fieldname  ->
      let find_in_cache fieldname1 =
        let uu____7287 =
          ((fieldname1.FStar_Ident.ns), (fieldname1.FStar_Ident.ident))  in
        match uu____7287 with
        | (ns,id1) ->
            let uu____7304 = peek_record_cache ()  in
            FStar_Util.find_map uu____7304
              (fun record  ->
                 let uu____7310 =
                   find_in_record ns id1 record (fun r  -> Cont_ok r)  in
                 option_of_cont
                   (fun uu____7316  -> FStar_Pervasives_Native.None)
                   uu____7310)
         in
      resolve_in_open_namespaces'' env fieldname Exported_id_field
        (fun uu____7318  -> Cont_ignore) (fun uu____7320  -> Cont_ignore)
        (fun r  -> Cont_ok r)
        (fun fn  ->
           let uu____7326 = find_in_cache fn  in
           cont_of_option Cont_ignore uu____7326)
        (fun k  -> fun uu____7332  -> k)
  
let (try_lookup_record_by_field_name :
  env -> FStar_Ident.lident -> record_or_dc FStar_Pervasives_Native.option) =
  fun env  ->
    fun fieldname  ->
      let uu____7343 = try_lookup_record_or_dc_by_field_name env fieldname
         in
      match uu____7343 with
      | FStar_Pervasives_Native.Some r when r.is_record ->
          FStar_Pervasives_Native.Some r
      | uu____7349 -> FStar_Pervasives_Native.None
  
let (belongs_to_record :
  env -> FStar_Ident.lident -> record_or_dc -> Prims.bool) =
  fun env  ->
    fun lid  ->
      fun record  ->
        let uu____7361 = try_lookup_record_by_field_name env lid  in
        match uu____7361 with
        | FStar_Pervasives_Native.Some record' when
            let uu____7365 =
              let uu____7366 =
                FStar_Ident.path_of_ns (record.typename).FStar_Ident.ns  in
              FStar_Ident.text_of_path uu____7366  in
            let uu____7369 =
              let uu____7370 =
                FStar_Ident.path_of_ns (record'.typename).FStar_Ident.ns  in
              FStar_Ident.text_of_path uu____7370  in
            uu____7365 = uu____7369 ->
            let uu____7373 =
              find_in_record (record.typename).FStar_Ident.ns
                lid.FStar_Ident.ident record (fun uu____7377  -> Cont_ok ())
               in
            (match uu____7373 with
             | Cont_ok uu____7378 -> true
             | uu____7379 -> false)
        | uu____7382 -> false
  
let (try_lookup_dc_by_field_name :
  env ->
    FStar_Ident.lident ->
      (FStar_Ident.lident,Prims.bool) FStar_Pervasives_Native.tuple2
        FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun fieldname  ->
      let uu____7397 = try_lookup_record_or_dc_by_field_name env fieldname
         in
      match uu____7397 with
      | FStar_Pervasives_Native.Some r ->
          let uu____7407 =
            let uu____7412 =
              let uu____7413 =
                FStar_Ident.lid_of_ids
                  (FStar_List.append (r.typename).FStar_Ident.ns
                     [r.constrname])
                 in
              FStar_Ident.set_lid_range uu____7413
                (FStar_Ident.range_of_lid fieldname)
               in
            (uu____7412, (r.is_record))  in
          FStar_Pervasives_Native.Some uu____7407
      | uu____7418 -> FStar_Pervasives_Native.None
  
let (string_set_ref_new :
  Prims.unit -> Prims.string FStar_Util.set FStar_ST.ref) =
  fun uu____7442  ->
    let uu____7443 = FStar_Util.new_set FStar_Util.compare  in
    FStar_Util.mk_ref uu____7443
  
let (exported_id_set_new :
  Prims.unit -> exported_id_kind -> Prims.string FStar_Util.set FStar_ST.ref)
  =
  fun uu____7467  ->
    let term_type_set = string_set_ref_new ()  in
    let field_set = string_set_ref_new ()  in
    fun uu___129_7478  ->
      match uu___129_7478 with
      | Exported_id_term_type  -> term_type_set
      | Exported_id_field  -> field_set
  
let (unique :
  Prims.bool -> Prims.bool -> env -> FStar_Ident.lident -> Prims.bool) =
  fun any_val  ->
    fun exclude_interface  ->
      fun env  ->
        fun lid  ->
          let filter_scope_mods uu___130_7520 =
            match uu___130_7520 with
            | Rec_binding uu____7521 -> true
            | uu____7522 -> false  in
          let this_env =
            let uu___144_7524 = env  in
            let uu____7525 =
              FStar_List.filter filter_scope_mods env.scope_mods  in
            {
              curmodule = (uu___144_7524.curmodule);
              curmonad = (uu___144_7524.curmonad);
              modules = (uu___144_7524.modules);
              scope_mods = uu____7525;
              exported_ids = empty_exported_id_smap;
              trans_exported_ids = (uu___144_7524.trans_exported_ids);
              includes = empty_include_smap;
              sigaccum = (uu___144_7524.sigaccum);
              sigmap = (uu___144_7524.sigmap);
              iface = (uu___144_7524.iface);
              admitted_iface = (uu___144_7524.admitted_iface);
              expect_typ = (uu___144_7524.expect_typ);
              docs = (uu___144_7524.docs);
              remaining_iface_decls = (uu___144_7524.remaining_iface_decls);
              syntax_only = (uu___144_7524.syntax_only);
              ds_hooks = (uu___144_7524.ds_hooks)
            }  in
          let uu____7528 =
            try_lookup_lid' any_val exclude_interface this_env lid  in
          match uu____7528 with
          | FStar_Pervasives_Native.None  -> true
          | FStar_Pervasives_Native.Some uu____7547 -> false
  
let (push_scope_mod : env -> scope_mod -> env) =
  fun env  ->
    fun scope_mod  ->
      let uu___145_7570 = env  in
      {
        curmodule = (uu___145_7570.curmodule);
        curmonad = (uu___145_7570.curmonad);
        modules = (uu___145_7570.modules);
        scope_mods = (scope_mod :: (env.scope_mods));
        exported_ids = (uu___145_7570.exported_ids);
        trans_exported_ids = (uu___145_7570.trans_exported_ids);
        includes = (uu___145_7570.includes);
        sigaccum = (uu___145_7570.sigaccum);
        sigmap = (uu___145_7570.sigmap);
        iface = (uu___145_7570.iface);
        admitted_iface = (uu___145_7570.admitted_iface);
        expect_typ = (uu___145_7570.expect_typ);
        docs = (uu___145_7570.docs);
        remaining_iface_decls = (uu___145_7570.remaining_iface_decls);
        syntax_only = (uu___145_7570.syntax_only);
        ds_hooks = (uu___145_7570.ds_hooks)
      }
  
let (push_bv' :
  env ->
    FStar_Ident.ident ->
      Prims.bool ->
        (env,FStar_Syntax_Syntax.bv) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun x  ->
      fun is_mutable  ->
        let bv =
          FStar_Syntax_Syntax.gen_bv x.FStar_Ident.idText
            (FStar_Pervasives_Native.Some (x.FStar_Ident.idRange))
            FStar_Syntax_Syntax.tun
           in
        ((push_scope_mod env (Local_binding (x, bv, is_mutable))), bv)
  
let (push_bv_mutable :
  env ->
    FStar_Ident.ident ->
      (env,FStar_Syntax_Syntax.bv) FStar_Pervasives_Native.tuple2)
  = fun env  -> fun x  -> push_bv' env x true 
let (push_bv :
  env ->
    FStar_Ident.ident ->
      (env,FStar_Syntax_Syntax.bv) FStar_Pervasives_Native.tuple2)
  = fun env  -> fun x  -> push_bv' env x false 
let (push_top_level_rec_binding :
  env -> FStar_Ident.ident -> FStar_Syntax_Syntax.delta_depth -> env) =
  fun env  ->
    fun x  ->
      fun dd  ->
        let l = qualify env x  in
        let uu____7615 =
          (unique false true env l) || (FStar_Options.interactive ())  in
        if uu____7615
        then push_scope_mod env (Rec_binding (x, l, dd))
        else
          FStar_Errors.raise_error
            (FStar_Errors.Fatal_DuplicateTopLevelNames,
              (Prims.strcat "Duplicate top-level names " l.FStar_Ident.str))
            (FStar_Ident.range_of_lid l)
  
let (push_sigelt : env -> FStar_Syntax_Syntax.sigelt -> env) =
  fun env  ->
    fun s  ->
      let err l =
        let sopt = FStar_Util.smap_try_find (sigmap env) l.FStar_Ident.str
           in
        let r =
          match sopt with
          | FStar_Pervasives_Native.Some (se,uu____7640) ->
              let uu____7645 =
                FStar_Util.find_opt (FStar_Ident.lid_equals l)
                  (FStar_Syntax_Util.lids_of_sigelt se)
                 in
              (match uu____7645 with
               | FStar_Pervasives_Native.Some l1 ->
                   FStar_All.pipe_left FStar_Range.string_of_range
                     (FStar_Ident.range_of_lid l1)
               | FStar_Pervasives_Native.None  -> "<unknown>")
          | FStar_Pervasives_Native.None  -> "<unknown>"  in
        let uu____7653 =
          let uu____7658 =
            FStar_Util.format2
              "Duplicate top-level names [%s]; previously declared at %s"
              (FStar_Ident.text_of_lid l) r
             in
          (FStar_Errors.Fatal_DuplicateTopLevelNames, uu____7658)  in
        FStar_Errors.raise_error uu____7653 (FStar_Ident.range_of_lid l)  in
      let globals = FStar_Util.mk_ref env.scope_mods  in
      let env1 =
        let uu____7667 =
          match s.FStar_Syntax_Syntax.sigel with
          | FStar_Syntax_Syntax.Sig_let uu____7676 -> (false, true)
          | FStar_Syntax_Syntax.Sig_bundle uu____7683 -> (false, true)
          | uu____7692 -> (false, false)  in
        match uu____7667 with
        | (any_val,exclude_interface) ->
            let lids = FStar_Syntax_Util.lids_of_sigelt s  in
            let uu____7698 =
              FStar_Util.find_map lids
                (fun l  ->
                   let uu____7704 =
                     let uu____7705 = unique any_val exclude_interface env l
                        in
                     Prims.op_Negation uu____7705  in
                   if uu____7704
                   then FStar_Pervasives_Native.Some l
                   else FStar_Pervasives_Native.None)
               in
            (match uu____7698 with
             | FStar_Pervasives_Native.Some l -> err l
             | uu____7710 ->
                 (extract_record env globals s;
                  (let uu___146_7736 = env  in
                   {
                     curmodule = (uu___146_7736.curmodule);
                     curmonad = (uu___146_7736.curmonad);
                     modules = (uu___146_7736.modules);
                     scope_mods = (uu___146_7736.scope_mods);
                     exported_ids = (uu___146_7736.exported_ids);
                     trans_exported_ids = (uu___146_7736.trans_exported_ids);
                     includes = (uu___146_7736.includes);
                     sigaccum = (s :: (env.sigaccum));
                     sigmap = (uu___146_7736.sigmap);
                     iface = (uu___146_7736.iface);
                     admitted_iface = (uu___146_7736.admitted_iface);
                     expect_typ = (uu___146_7736.expect_typ);
                     docs = (uu___146_7736.docs);
                     remaining_iface_decls =
                       (uu___146_7736.remaining_iface_decls);
                     syntax_only = (uu___146_7736.syntax_only);
                     ds_hooks = (uu___146_7736.ds_hooks)
                   })))
         in
      let env2 =
        let uu___147_7738 = env1  in
        let uu____7739 = FStar_ST.op_Bang globals  in
        {
          curmodule = (uu___147_7738.curmodule);
          curmonad = (uu___147_7738.curmonad);
          modules = (uu___147_7738.modules);
          scope_mods = uu____7739;
          exported_ids = (uu___147_7738.exported_ids);
          trans_exported_ids = (uu___147_7738.trans_exported_ids);
          includes = (uu___147_7738.includes);
          sigaccum = (uu___147_7738.sigaccum);
          sigmap = (uu___147_7738.sigmap);
          iface = (uu___147_7738.iface);
          admitted_iface = (uu___147_7738.admitted_iface);
          expect_typ = (uu___147_7738.expect_typ);
          docs = (uu___147_7738.docs);
          remaining_iface_decls = (uu___147_7738.remaining_iface_decls);
          syntax_only = (uu___147_7738.syntax_only);
          ds_hooks = (uu___147_7738.ds_hooks)
        }  in
      let uu____7787 =
        match s.FStar_Syntax_Syntax.sigel with
        | FStar_Syntax_Syntax.Sig_bundle (ses,uu____7813) ->
            let uu____7822 =
              FStar_List.map
                (fun se  -> ((FStar_Syntax_Util.lids_of_sigelt se), se)) ses
               in
            (env2, uu____7822)
        | uu____7849 -> (env2, [((FStar_Syntax_Util.lids_of_sigelt s), s)])
         in
      match uu____7787 with
      | (env3,lss) ->
          (FStar_All.pipe_right lss
             (FStar_List.iter
                (fun uu____7908  ->
                   match uu____7908 with
                   | (lids,se) ->
                       FStar_All.pipe_right lids
                         (FStar_List.iter
                            (fun lid  ->
                               (let uu____7930 =
                                  let uu____7933 = FStar_ST.op_Bang globals
                                     in
                                  (Top_level_def (lid.FStar_Ident.ident)) ::
                                    uu____7933
                                   in
                                FStar_ST.op_Colon_Equals globals uu____7930);
                               (match () with
                                | () ->
                                    let modul =
                                      let uu____8027 =
                                        FStar_Ident.lid_of_ids
                                          lid.FStar_Ident.ns
                                         in
                                      uu____8027.FStar_Ident.str  in
                                    ((let uu____8029 =
                                        get_exported_id_set env3 modul  in
                                      match uu____8029 with
                                      | FStar_Pervasives_Native.Some f ->
                                          let my_exported_ids =
                                            f Exported_id_term_type  in
                                          let uu____8059 =
                                            let uu____8060 =
                                              FStar_ST.op_Bang
                                                my_exported_ids
                                               in
                                            FStar_Util.set_add
                                              (lid.FStar_Ident.ident).FStar_Ident.idText
                                              uu____8060
                                             in
                                          FStar_ST.op_Colon_Equals
                                            my_exported_ids uu____8059
                                      | FStar_Pervasives_Native.None  -> ());
                                     (match () with
                                      | () ->
                                          let is_iface =
                                            env3.iface &&
                                              (Prims.op_Negation
                                                 env3.admitted_iface)
                                             in
                                          FStar_Util.smap_add (sigmap env3)
                                            lid.FStar_Ident.str
                                            (se,
                                              (env3.iface &&
                                                 (Prims.op_Negation
                                                    env3.admitted_iface))))))))));
           (let env4 =
              let uu___148_8155 = env3  in
              let uu____8156 = FStar_ST.op_Bang globals  in
              {
                curmodule = (uu___148_8155.curmodule);
                curmonad = (uu___148_8155.curmonad);
                modules = (uu___148_8155.modules);
                scope_mods = uu____8156;
                exported_ids = (uu___148_8155.exported_ids);
                trans_exported_ids = (uu___148_8155.trans_exported_ids);
                includes = (uu___148_8155.includes);
                sigaccum = (uu___148_8155.sigaccum);
                sigmap = (uu___148_8155.sigmap);
                iface = (uu___148_8155.iface);
                admitted_iface = (uu___148_8155.admitted_iface);
                expect_typ = (uu___148_8155.expect_typ);
                docs = (uu___148_8155.docs);
                remaining_iface_decls = (uu___148_8155.remaining_iface_decls);
                syntax_only = (uu___148_8155.syntax_only);
                ds_hooks = (uu___148_8155.ds_hooks)
              }  in
            env4))
  
let (push_namespace : env -> FStar_Ident.lident -> env) =
  fun env  ->
    fun ns  ->
      let uu____8210 =
        let uu____8215 = resolve_module_name env ns false  in
        match uu____8215 with
        | FStar_Pervasives_Native.None  ->
            let modules = env.modules  in
            let uu____8229 =
              FStar_All.pipe_right modules
                (FStar_Util.for_some
                   (fun uu____8243  ->
                      match uu____8243 with
                      | (m,uu____8249) ->
                          FStar_Util.starts_with
                            (Prims.strcat (FStar_Ident.text_of_lid m) ".")
                            (Prims.strcat (FStar_Ident.text_of_lid ns) ".")))
               in
            if uu____8229
            then (ns, Open_namespace)
            else
              (let uu____8255 =
                 let uu____8260 =
                   FStar_Util.format1 "Namespace %s cannot be found"
                     (FStar_Ident.text_of_lid ns)
                    in
                 (FStar_Errors.Fatal_NameSpaceNotFound, uu____8260)  in
               FStar_Errors.raise_error uu____8255
                 (FStar_Ident.range_of_lid ns))
        | FStar_Pervasives_Native.Some ns' ->
            (fail_if_curmodule env ns ns'; (ns', Open_module))
         in
      match uu____8210 with
      | (ns',kd) ->
          ((env.ds_hooks).ds_push_open_hook env (ns', kd);
           push_scope_mod env (Open_module_or_namespace (ns', kd)))
  
let (push_include : env -> FStar_Ident.lident -> env) =
  fun env  ->
    fun ns  ->
      let ns0 = ns  in
      let uu____8277 = resolve_module_name env ns false  in
      match uu____8277 with
      | FStar_Pervasives_Native.Some ns1 ->
          ((env.ds_hooks).ds_push_include_hook env ns1;
           fail_if_curmodule env ns0 ns1;
           (let env1 =
              push_scope_mod env
                (Open_module_or_namespace (ns1, Open_module))
               in
            let curmod =
              let uu____8285 = current_module env1  in
              uu____8285.FStar_Ident.str  in
            (let uu____8287 = FStar_Util.smap_try_find env1.includes curmod
                in
             match uu____8287 with
             | FStar_Pervasives_Native.None  -> ()
             | FStar_Pervasives_Native.Some incl ->
                 let uu____8311 =
                   let uu____8314 = FStar_ST.op_Bang incl  in ns1 ::
                     uu____8314
                    in
                 FStar_ST.op_Colon_Equals incl uu____8311);
            (match () with
             | () ->
                 let uu____8407 =
                   get_trans_exported_id_set env1 ns1.FStar_Ident.str  in
                 (match uu____8407 with
                  | FStar_Pervasives_Native.Some ns_trans_exports ->
                      ((let uu____8424 =
                          let uu____8441 = get_exported_id_set env1 curmod
                             in
                          let uu____8448 =
                            get_trans_exported_id_set env1 curmod  in
                          (uu____8441, uu____8448)  in
                        match uu____8424 with
                        | (FStar_Pervasives_Native.Some
                           cur_exports,FStar_Pervasives_Native.Some
                           cur_trans_exports) ->
                            let update_exports k =
                              let ns_ex =
                                let uu____8502 = ns_trans_exports k  in
                                FStar_ST.op_Bang uu____8502  in
                              let ex = cur_exports k  in
                              (let uu____8628 =
                                 let uu____8629 = FStar_ST.op_Bang ex  in
                                 FStar_Util.set_difference uu____8629 ns_ex
                                  in
                               FStar_ST.op_Colon_Equals ex uu____8628);
                              (match () with
                               | () ->
                                   let trans_ex = cur_trans_exports k  in
                                   let uu____8729 =
                                     let uu____8730 =
                                       FStar_ST.op_Bang trans_ex  in
                                     FStar_Util.set_union uu____8730 ns_ex
                                      in
                                   FStar_ST.op_Colon_Equals trans_ex
                                     uu____8729)
                               in
                            FStar_List.iter update_exports
                              all_exported_id_kinds
                        | uu____8815 -> ());
                       (match () with | () -> env1))
                  | FStar_Pervasives_Native.None  ->
                      let uu____8836 =
                        let uu____8841 =
                          FStar_Util.format1
                            "include: Module %s was not prepared"
                            ns1.FStar_Ident.str
                           in
                        (FStar_Errors.Fatal_IncludeModuleNotPrepared,
                          uu____8841)
                         in
                      FStar_Errors.raise_error uu____8836
                        (FStar_Ident.range_of_lid ns1)))))
      | uu____8842 ->
          let uu____8845 =
            let uu____8850 =
              FStar_Util.format1 "include: Module %s cannot be found"
                ns.FStar_Ident.str
               in
            (FStar_Errors.Fatal_ModuleNotFound, uu____8850)  in
          FStar_Errors.raise_error uu____8845 (FStar_Ident.range_of_lid ns)
  
let (push_module_abbrev :
  env -> FStar_Ident.ident -> FStar_Ident.lident -> env) =
  fun env  ->
    fun x  ->
      fun l  ->
        if module_is_defined env l
        then
          (fail_if_curmodule env l l;
           (env.ds_hooks).ds_push_module_abbrev_hook env x l;
           push_scope_mod env (Module_abbrev (x, l)))
        else
          (let uu____8863 =
             let uu____8868 =
               FStar_Util.format1 "Module %s cannot be found"
                 (FStar_Ident.text_of_lid l)
                in
             (FStar_Errors.Fatal_ModuleNotFound, uu____8868)  in
           FStar_Errors.raise_error uu____8863 (FStar_Ident.range_of_lid l))
  
let (push_doc :
  env ->
    FStar_Ident.lident ->
      FStar_Parser_AST.fsdoc FStar_Pervasives_Native.option -> env)
  =
  fun env  ->
    fun l  ->
      fun doc_opt  ->
        match doc_opt with
        | FStar_Pervasives_Native.None  -> env
        | FStar_Pervasives_Native.Some doc1 ->
            ((let uu____8884 =
                FStar_Util.smap_try_find env.docs l.FStar_Ident.str  in
              match uu____8884 with
              | FStar_Pervasives_Native.None  -> ()
              | FStar_Pervasives_Native.Some old_doc ->
                  let uu____8888 =
                    let uu____8893 =
                      let uu____8894 = FStar_Ident.string_of_lid l  in
                      let uu____8895 =
                        FStar_Parser_AST.string_of_fsdoc old_doc  in
                      let uu____8896 = FStar_Parser_AST.string_of_fsdoc doc1
                         in
                      FStar_Util.format3
                        "Overwriting doc of %s; old doc was [%s]; new doc are [%s]"
                        uu____8894 uu____8895 uu____8896
                       in
                    (FStar_Errors.Warning_DocOverwrite, uu____8893)  in
                  FStar_Errors.log_issue (FStar_Ident.range_of_lid l)
                    uu____8888);
             FStar_Util.smap_add env.docs l.FStar_Ident.str doc1;
             env)
  
let (check_admits :
  env -> FStar_Syntax_Syntax.modul -> FStar_Syntax_Syntax.modul) =
  fun env  ->
    fun m  ->
      let admitted_sig_lids =
        FStar_All.pipe_right env.sigaccum
          (FStar_List.fold_left
             (fun lids  ->
                fun se  ->
                  match se.FStar_Syntax_Syntax.sigel with
                  | FStar_Syntax_Syntax.Sig_declare_typ (l,u,t) when
                      let uu____8932 =
                        FStar_All.pipe_right se.FStar_Syntax_Syntax.sigquals
                          (FStar_List.contains FStar_Syntax_Syntax.Assumption)
                         in
                      Prims.op_Negation uu____8932 ->
                      let uu____8935 =
                        FStar_Util.smap_try_find (sigmap env)
                          l.FStar_Ident.str
                         in
                      (match uu____8935 with
                       | FStar_Pervasives_Native.Some
                           ({
                              FStar_Syntax_Syntax.sigel =
                                FStar_Syntax_Syntax.Sig_let uu____8948;
                              FStar_Syntax_Syntax.sigrng = uu____8949;
                              FStar_Syntax_Syntax.sigquals = uu____8950;
                              FStar_Syntax_Syntax.sigmeta = uu____8951;
                              FStar_Syntax_Syntax.sigattrs = uu____8952;_},uu____8953)
                           -> lids
                       | FStar_Pervasives_Native.Some
                           ({
                              FStar_Syntax_Syntax.sigel =
                                FStar_Syntax_Syntax.Sig_inductive_typ
                                uu____8968;
                              FStar_Syntax_Syntax.sigrng = uu____8969;
                              FStar_Syntax_Syntax.sigquals = uu____8970;
                              FStar_Syntax_Syntax.sigmeta = uu____8971;
                              FStar_Syntax_Syntax.sigattrs = uu____8972;_},uu____8973)
                           -> lids
                       | uu____8998 ->
                           ((let uu____9006 =
                               let uu____9007 = FStar_Options.interactive ()
                                  in
                               Prims.op_Negation uu____9007  in
                             if uu____9006
                             then
                               let uu____9008 =
                                 let uu____9013 =
                                   let uu____9014 =
                                     FStar_Ident.string_of_lid l  in
                                   FStar_Util.format1
                                     "Admitting %s without a definition"
                                     uu____9014
                                    in
                                 (FStar_Errors.Warning_AdmitWithoutDefinition,
                                   uu____9013)
                                  in
                               FStar_Errors.log_issue
                                 (FStar_Ident.range_of_lid l) uu____9008
                             else ());
                            (let quals = FStar_Syntax_Syntax.Assumption ::
                               (se.FStar_Syntax_Syntax.sigquals)  in
                             FStar_Util.smap_add (sigmap env)
                               l.FStar_Ident.str
                               ((let uu___149_9025 = se  in
                                 {
                                   FStar_Syntax_Syntax.sigel =
                                     (uu___149_9025.FStar_Syntax_Syntax.sigel);
                                   FStar_Syntax_Syntax.sigrng =
                                     (uu___149_9025.FStar_Syntax_Syntax.sigrng);
                                   FStar_Syntax_Syntax.sigquals = quals;
                                   FStar_Syntax_Syntax.sigmeta =
                                     (uu___149_9025.FStar_Syntax_Syntax.sigmeta);
                                   FStar_Syntax_Syntax.sigattrs =
                                     (uu___149_9025.FStar_Syntax_Syntax.sigattrs)
                                 }), false);
                             l
                             ::
                             lids)))
                  | uu____9026 -> lids) [])
         in
      let uu___150_9027 = m  in
      let uu____9028 =
        FStar_All.pipe_right m.FStar_Syntax_Syntax.declarations
          (FStar_List.map
             (fun s  ->
                match s.FStar_Syntax_Syntax.sigel with
                | FStar_Syntax_Syntax.Sig_declare_typ
                    (lid,uu____9038,uu____9039) when
                    FStar_List.existsb
                      (fun l  -> FStar_Ident.lid_equals l lid)
                      admitted_sig_lids
                    ->
                    let uu___151_9042 = s  in
                    {
                      FStar_Syntax_Syntax.sigel =
                        (uu___151_9042.FStar_Syntax_Syntax.sigel);
                      FStar_Syntax_Syntax.sigrng =
                        (uu___151_9042.FStar_Syntax_Syntax.sigrng);
                      FStar_Syntax_Syntax.sigquals =
                        (FStar_Syntax_Syntax.Assumption ::
                        (s.FStar_Syntax_Syntax.sigquals));
                      FStar_Syntax_Syntax.sigmeta =
                        (uu___151_9042.FStar_Syntax_Syntax.sigmeta);
                      FStar_Syntax_Syntax.sigattrs =
                        (uu___151_9042.FStar_Syntax_Syntax.sigattrs)
                    }
                | uu____9043 -> s))
         in
      {
        FStar_Syntax_Syntax.name = (uu___150_9027.FStar_Syntax_Syntax.name);
        FStar_Syntax_Syntax.declarations = uu____9028;
        FStar_Syntax_Syntax.exports =
          (uu___150_9027.FStar_Syntax_Syntax.exports);
        FStar_Syntax_Syntax.is_interface =
          (uu___150_9027.FStar_Syntax_Syntax.is_interface)
      }
  
let (finish : env -> FStar_Syntax_Syntax.modul -> env) =
  fun env  ->
    fun modul  ->
      FStar_All.pipe_right modul.FStar_Syntax_Syntax.declarations
        (FStar_List.iter
           (fun se  ->
              let quals = se.FStar_Syntax_Syntax.sigquals  in
              match se.FStar_Syntax_Syntax.sigel with
              | FStar_Syntax_Syntax.Sig_bundle (ses,uu____9060) ->
                  if
                    (FStar_List.contains FStar_Syntax_Syntax.Private quals)
                      ||
                      (FStar_List.contains FStar_Syntax_Syntax.Abstract quals)
                  then
                    FStar_All.pipe_right ses
                      (FStar_List.iter
                         (fun se1  ->
                            match se1.FStar_Syntax_Syntax.sigel with
                            | FStar_Syntax_Syntax.Sig_datacon
                                (lid,uu____9080,uu____9081,uu____9082,uu____9083,uu____9084)
                                ->
                                FStar_Util.smap_remove (sigmap env)
                                  lid.FStar_Ident.str
                            | FStar_Syntax_Syntax.Sig_inductive_typ
                                (lid,univ_names,binders,typ,uu____9097,uu____9098)
                                ->
                                (FStar_Util.smap_remove (sigmap env)
                                   lid.FStar_Ident.str;
                                 if
                                   Prims.op_Negation
                                     (FStar_List.contains
                                        FStar_Syntax_Syntax.Private quals)
                                 then
                                   (let sigel =
                                      let uu____9113 =
                                        let uu____9120 =
                                          let uu____9123 =
                                            let uu____9126 =
                                              let uu____9127 =
                                                let uu____9140 =
                                                  FStar_Syntax_Syntax.mk_Total
                                                    typ
                                                   in
                                                (binders, uu____9140)  in
                                              FStar_Syntax_Syntax.Tm_arrow
                                                uu____9127
                                               in
                                            FStar_Syntax_Syntax.mk uu____9126
                                             in
                                          uu____9123
                                            FStar_Pervasives_Native.None
                                            (FStar_Ident.range_of_lid lid)
                                           in
                                        (lid, univ_names, uu____9120)  in
                                      FStar_Syntax_Syntax.Sig_declare_typ
                                        uu____9113
                                       in
                                    let se2 =
                                      let uu___152_9147 = se1  in
                                      {
                                        FStar_Syntax_Syntax.sigel = sigel;
                                        FStar_Syntax_Syntax.sigrng =
                                          (uu___152_9147.FStar_Syntax_Syntax.sigrng);
                                        FStar_Syntax_Syntax.sigquals =
                                          (FStar_Syntax_Syntax.Assumption ::
                                          quals);
                                        FStar_Syntax_Syntax.sigmeta =
                                          (uu___152_9147.FStar_Syntax_Syntax.sigmeta);
                                        FStar_Syntax_Syntax.sigattrs =
                                          (uu___152_9147.FStar_Syntax_Syntax.sigattrs)
                                      }  in
                                    FStar_Util.smap_add (sigmap env)
                                      lid.FStar_Ident.str (se2, false))
                                 else ())
                            | uu____9153 -> ()))
                  else ()
              | FStar_Syntax_Syntax.Sig_declare_typ
                  (lid,uu____9156,uu____9157) ->
                  if FStar_List.contains FStar_Syntax_Syntax.Private quals
                  then
                    FStar_Util.smap_remove (sigmap env) lid.FStar_Ident.str
                  else ()
              | FStar_Syntax_Syntax.Sig_let ((uu____9163,lbs),uu____9165) ->
                  (if
                     (FStar_List.contains FStar_Syntax_Syntax.Private quals)
                       ||
                       (FStar_List.contains FStar_Syntax_Syntax.Abstract
                          quals)
                   then
                     FStar_All.pipe_right lbs
                       (FStar_List.iter
                          (fun lb  ->
                             let uu____9186 =
                               let uu____9187 =
                                 let uu____9188 =
                                   let uu____9191 =
                                     FStar_Util.right
                                       lb.FStar_Syntax_Syntax.lbname
                                      in
                                   uu____9191.FStar_Syntax_Syntax.fv_name  in
                                 uu____9188.FStar_Syntax_Syntax.v  in
                               uu____9187.FStar_Ident.str  in
                             FStar_Util.smap_remove (sigmap env) uu____9186))
                   else ();
                   if
                     (FStar_List.contains FStar_Syntax_Syntax.Abstract quals)
                       &&
                       (Prims.op_Negation
                          (FStar_List.contains FStar_Syntax_Syntax.Private
                             quals))
                   then
                     FStar_All.pipe_right lbs
                       (FStar_List.iter
                          (fun lb  ->
                             let lid =
                               let uu____9205 =
                                 let uu____9208 =
                                   FStar_Util.right
                                     lb.FStar_Syntax_Syntax.lbname
                                    in
                                 uu____9208.FStar_Syntax_Syntax.fv_name  in
                               uu____9205.FStar_Syntax_Syntax.v  in
                             let quals1 = FStar_Syntax_Syntax.Assumption ::
                               quals  in
                             let decl =
                               let uu___153_9213 = se  in
                               {
                                 FStar_Syntax_Syntax.sigel =
                                   (FStar_Syntax_Syntax.Sig_declare_typ
                                      (lid, (lb.FStar_Syntax_Syntax.lbunivs),
                                        (lb.FStar_Syntax_Syntax.lbtyp)));
                                 FStar_Syntax_Syntax.sigrng =
                                   (uu___153_9213.FStar_Syntax_Syntax.sigrng);
                                 FStar_Syntax_Syntax.sigquals = quals1;
                                 FStar_Syntax_Syntax.sigmeta =
                                   (uu___153_9213.FStar_Syntax_Syntax.sigmeta);
                                 FStar_Syntax_Syntax.sigattrs =
                                   (uu___153_9213.FStar_Syntax_Syntax.sigattrs)
                               }  in
                             FStar_Util.smap_add (sigmap env)
                               lid.FStar_Ident.str (decl, false)))
                   else ())
              | uu____9223 -> ()));
      (let curmod =
         let uu____9225 = current_module env  in uu____9225.FStar_Ident.str
          in
       (let uu____9227 =
          let uu____9244 = get_exported_id_set env curmod  in
          let uu____9251 = get_trans_exported_id_set env curmod  in
          (uu____9244, uu____9251)  in
        match uu____9227 with
        | (FStar_Pervasives_Native.Some cur_ex,FStar_Pervasives_Native.Some
           cur_trans_ex) ->
            let update_exports eikind =
              let cur_ex_set =
                let uu____9305 = cur_ex eikind  in
                FStar_ST.op_Bang uu____9305  in
              let cur_trans_ex_set_ref = cur_trans_ex eikind  in
              let uu____9430 =
                let uu____9431 = FStar_ST.op_Bang cur_trans_ex_set_ref  in
                FStar_Util.set_union cur_ex_set uu____9431  in
              FStar_ST.op_Colon_Equals cur_trans_ex_set_ref uu____9430  in
            FStar_List.iter update_exports all_exported_id_kinds
        | uu____9516 -> ());
       (match () with
        | () ->
            (filter_record_cache ();
             (match () with
              | () ->
                  let uu___154_9534 = env  in
                  {
                    curmodule = FStar_Pervasives_Native.None;
                    curmonad = (uu___154_9534.curmonad);
                    modules = (((modul.FStar_Syntax_Syntax.name), modul) ::
                      (env.modules));
                    scope_mods = [];
                    exported_ids = (uu___154_9534.exported_ids);
                    trans_exported_ids = (uu___154_9534.trans_exported_ids);
                    includes = (uu___154_9534.includes);
                    sigaccum = [];
                    sigmap = (uu___154_9534.sigmap);
                    iface = (uu___154_9534.iface);
                    admitted_iface = (uu___154_9534.admitted_iface);
                    expect_typ = (uu___154_9534.expect_typ);
                    docs = (uu___154_9534.docs);
                    remaining_iface_decls =
                      (uu___154_9534.remaining_iface_decls);
                    syntax_only = (uu___154_9534.syntax_only);
                    ds_hooks = (uu___154_9534.ds_hooks)
                  }))))
  
let (stack : env Prims.list FStar_ST.ref) = FStar_Util.mk_ref [] 
let (push : env -> env) =
  fun env  ->
    push_record_cache ();
    (let uu____9561 =
       let uu____9564 = FStar_ST.op_Bang stack  in env :: uu____9564  in
     FStar_ST.op_Colon_Equals stack uu____9561);
    (let uu___155_9613 = env  in
     let uu____9614 = FStar_Util.smap_copy (sigmap env)  in
     let uu____9625 = FStar_Util.smap_copy env.docs  in
     {
       curmodule = (uu___155_9613.curmodule);
       curmonad = (uu___155_9613.curmonad);
       modules = (uu___155_9613.modules);
       scope_mods = (uu___155_9613.scope_mods);
       exported_ids = (uu___155_9613.exported_ids);
       trans_exported_ids = (uu___155_9613.trans_exported_ids);
       includes = (uu___155_9613.includes);
       sigaccum = (uu___155_9613.sigaccum);
       sigmap = uu____9614;
       iface = (uu___155_9613.iface);
       admitted_iface = (uu___155_9613.admitted_iface);
       expect_typ = (uu___155_9613.expect_typ);
       docs = uu____9625;
       remaining_iface_decls = (uu___155_9613.remaining_iface_decls);
       syntax_only = (uu___155_9613.syntax_only);
       ds_hooks = (uu___155_9613.ds_hooks)
     })
  
let (pop : Prims.unit -> env) =
  fun uu____9630  ->
    let uu____9631 = FStar_ST.op_Bang stack  in
    match uu____9631 with
    | env::tl1 ->
        (pop_record_cache (); FStar_ST.op_Colon_Equals stack tl1; env)
    | uu____9686 -> failwith "Impossible: Too many pops"
  
let (export_interface : FStar_Ident.lident -> env -> env) =
  fun m  ->
    fun env  ->
      let sigelt_in_m se =
        match FStar_Syntax_Util.lids_of_sigelt se with
        | l::uu____9700 -> l.FStar_Ident.nsstr = m.FStar_Ident.str
        | uu____9703 -> false  in
      let sm = sigmap env  in
      let env1 = pop ()  in
      let keys = FStar_Util.smap_keys sm  in
      let sm' = sigmap env1  in
      FStar_All.pipe_right keys
        (FStar_List.iter
           (fun k  ->
              let uu____9737 = FStar_Util.smap_try_find sm' k  in
              match uu____9737 with
              | FStar_Pervasives_Native.Some (se,true ) when sigelt_in_m se
                  ->
                  (FStar_Util.smap_remove sm' k;
                   (let se1 =
                      match se.FStar_Syntax_Syntax.sigel with
                      | FStar_Syntax_Syntax.Sig_declare_typ (l,u,t) ->
                          let uu___156_9762 = se  in
                          {
                            FStar_Syntax_Syntax.sigel =
                              (uu___156_9762.FStar_Syntax_Syntax.sigel);
                            FStar_Syntax_Syntax.sigrng =
                              (uu___156_9762.FStar_Syntax_Syntax.sigrng);
                            FStar_Syntax_Syntax.sigquals =
                              (FStar_Syntax_Syntax.Assumption ::
                              (se.FStar_Syntax_Syntax.sigquals));
                            FStar_Syntax_Syntax.sigmeta =
                              (uu___156_9762.FStar_Syntax_Syntax.sigmeta);
                            FStar_Syntax_Syntax.sigattrs =
                              (uu___156_9762.FStar_Syntax_Syntax.sigattrs)
                          }
                      | uu____9763 -> se  in
                    FStar_Util.smap_add sm' k (se1, false)))
              | uu____9768 -> ()));
      env1
  
let (finish_module_or_interface :
  env ->
    FStar_Syntax_Syntax.modul ->
      (env,FStar_Syntax_Syntax.modul) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun modul  ->
      let modul1 =
        if Prims.op_Negation modul.FStar_Syntax_Syntax.is_interface
        then check_admits env modul
        else modul  in
      let uu____9787 = finish env modul1  in (uu____9787, modul1)
  
type exported_ids =
  {
  exported_id_terms: Prims.string Prims.list ;
  exported_id_fields: Prims.string Prims.list }[@@deriving show]
let (__proj__Mkexported_ids__item__exported_id_terms :
  exported_ids -> Prims.string Prims.list) =
  fun projectee  ->
    match projectee with
    | { exported_id_terms = __fname__exported_id_terms;
        exported_id_fields = __fname__exported_id_fields;_} ->
        __fname__exported_id_terms
  
let (__proj__Mkexported_ids__item__exported_id_fields :
  exported_ids -> Prims.string Prims.list) =
  fun projectee  ->
    match projectee with
    | { exported_id_terms = __fname__exported_id_terms;
        exported_id_fields = __fname__exported_id_fields;_} ->
        __fname__exported_id_fields
  
let (as_exported_ids : exported_id_set -> exported_ids) =
  fun e  ->
    let terms =
      let uu____9865 =
        let uu____9868 = e Exported_id_term_type  in
        FStar_ST.op_Bang uu____9868  in
      FStar_Util.set_elements uu____9865  in
    let fields =
      let uu____9982 =
        let uu____9985 = e Exported_id_field  in FStar_ST.op_Bang uu____9985
         in
      FStar_Util.set_elements uu____9982  in
    { exported_id_terms = terms; exported_id_fields = fields }
  
let (as_exported_id_set :
  exported_ids FStar_Pervasives_Native.option ->
    exported_id_kind -> Prims.string FStar_Util.set FStar_ST.ref)
  =
  fun e  ->
    match e with
    | FStar_Pervasives_Native.None  -> exported_id_set_new ()
    | FStar_Pervasives_Native.Some e1 ->
        let terms =
          let uu____10132 =
            FStar_Util.as_set e1.exported_id_terms FStar_Util.compare  in
          FStar_Util.mk_ref uu____10132  in
        let fields =
          let uu____10142 =
            FStar_Util.as_set e1.exported_id_fields FStar_Util.compare  in
          FStar_Util.mk_ref uu____10142  in
        (fun uu___131_10147  ->
           match uu___131_10147 with
           | Exported_id_term_type  -> terms
           | Exported_id_field  -> fields)
  
type module_inclusion_info =
  {
  mii_exported_ids: exported_ids FStar_Pervasives_Native.option ;
  mii_trans_exported_ids: exported_ids FStar_Pervasives_Native.option ;
  mii_includes: FStar_Ident.lident Prims.list FStar_Pervasives_Native.option }
[@@deriving show]
let (__proj__Mkmodule_inclusion_info__item__mii_exported_ids :
  module_inclusion_info -> exported_ids FStar_Pervasives_Native.option) =
  fun projectee  ->
    match projectee with
    | { mii_exported_ids = __fname__mii_exported_ids;
        mii_trans_exported_ids = __fname__mii_trans_exported_ids;
        mii_includes = __fname__mii_includes;_} -> __fname__mii_exported_ids
  
let (__proj__Mkmodule_inclusion_info__item__mii_trans_exported_ids :
  module_inclusion_info -> exported_ids FStar_Pervasives_Native.option) =
  fun projectee  ->
    match projectee with
    | { mii_exported_ids = __fname__mii_exported_ids;
        mii_trans_exported_ids = __fname__mii_trans_exported_ids;
        mii_includes = __fname__mii_includes;_} ->
        __fname__mii_trans_exported_ids
  
let (__proj__Mkmodule_inclusion_info__item__mii_includes :
  module_inclusion_info ->
    FStar_Ident.lident Prims.list FStar_Pervasives_Native.option)
  =
  fun projectee  ->
    match projectee with
    | { mii_exported_ids = __fname__mii_exported_ids;
        mii_trans_exported_ids = __fname__mii_trans_exported_ids;
        mii_includes = __fname__mii_includes;_} -> __fname__mii_includes
  
let (default_mii : module_inclusion_info) =
  {
    mii_exported_ids = FStar_Pervasives_Native.None;
    mii_trans_exported_ids = FStar_Pervasives_Native.None;
    mii_includes = FStar_Pervasives_Native.None
  } 
let as_includes :
  'Auu____10267 .
    'Auu____10267 Prims.list FStar_Pervasives_Native.option ->
      'Auu____10267 Prims.list FStar_ST.ref
  =
  fun uu___132_10279  ->
    match uu___132_10279 with
    | FStar_Pervasives_Native.None  -> FStar_Util.mk_ref []
    | FStar_Pervasives_Native.Some l -> FStar_Util.mk_ref l
  
let (inclusion_info : env -> FStar_Ident.lident -> module_inclusion_info) =
  fun env  ->
    fun l  ->
      let mname = FStar_Ident.string_of_lid l  in
      let as_ids_opt m =
        let uu____10312 = FStar_Util.smap_try_find m mname  in
        FStar_Util.map_opt uu____10312 as_exported_ids  in
      let uu____10315 = as_ids_opt env.exported_ids  in
      let uu____10318 = as_ids_opt env.trans_exported_ids  in
      let uu____10321 =
        let uu____10326 = FStar_Util.smap_try_find env.includes mname  in
        FStar_Util.map_opt uu____10326 (fun r  -> FStar_ST.op_Bang r)  in
      {
        mii_exported_ids = uu____10315;
        mii_trans_exported_ids = uu____10318;
        mii_includes = uu____10321
      }
  
let (prepare_module_or_interface :
  Prims.bool ->
    Prims.bool ->
      env ->
        FStar_Ident.lident ->
          module_inclusion_info ->
            (env,Prims.bool) FStar_Pervasives_Native.tuple2)
  =
  fun intf  ->
    fun admitted  ->
      fun env  ->
        fun mname  ->
          fun mii  ->
            let prep env1 =
              let filename =
                FStar_Util.strcat (FStar_Ident.text_of_lid mname) ".fst"  in
              let auto_open =
                FStar_Parser_Dep.hard_coded_dependencies filename  in
              let auto_open1 =
                let convert_kind uu___133_10446 =
                  match uu___133_10446 with
                  | FStar_Parser_Dep.Open_namespace  -> Open_namespace
                  | FStar_Parser_Dep.Open_module  -> Open_module  in
                FStar_List.map
                  (fun uu____10458  ->
                     match uu____10458 with
                     | (lid,kind) -> (lid, (convert_kind kind))) auto_open
                 in
              let namespace_of_module =
                if
                  (FStar_List.length mname.FStar_Ident.ns) >
                    (Prims.parse_int "0")
                then
                  let uu____10482 =
                    let uu____10487 =
                      FStar_Ident.lid_of_ids mname.FStar_Ident.ns  in
                    (uu____10487, Open_namespace)  in
                  [uu____10482]
                else []  in
              let auto_open2 =
                FStar_List.append namespace_of_module
                  (FStar_List.rev auto_open1)
                 in
              (let uu____10517 = as_exported_id_set mii.mii_exported_ids  in
               FStar_Util.smap_add env1.exported_ids mname.FStar_Ident.str
                 uu____10517);
              (match () with
               | () ->
                   ((let uu____10541 =
                       as_exported_id_set mii.mii_trans_exported_ids  in
                     FStar_Util.smap_add env1.trans_exported_ids
                       mname.FStar_Ident.str uu____10541);
                    (match () with
                     | () ->
                         ((let uu____10565 = as_includes mii.mii_includes  in
                           FStar_Util.smap_add env1.includes
                             mname.FStar_Ident.str uu____10565);
                          (match () with
                           | () ->
                               let env' =
                                 let uu___157_10597 = env1  in
                                 let uu____10598 =
                                   FStar_List.map
                                     (fun x  -> Open_module_or_namespace x)
                                     auto_open2
                                    in
                                 {
                                   curmodule =
                                     (FStar_Pervasives_Native.Some mname);
                                   curmonad = (uu___157_10597.curmonad);
                                   modules = (uu___157_10597.modules);
                                   scope_mods = uu____10598;
                                   exported_ids =
                                     (uu___157_10597.exported_ids);
                                   trans_exported_ids =
                                     (uu___157_10597.trans_exported_ids);
                                   includes = (uu___157_10597.includes);
                                   sigaccum = (uu___157_10597.sigaccum);
                                   sigmap = (env1.sigmap);
                                   iface = intf;
                                   admitted_iface = admitted;
                                   expect_typ = (uu___157_10597.expect_typ);
                                   docs = (uu___157_10597.docs);
                                   remaining_iface_decls =
                                     (uu___157_10597.remaining_iface_decls);
                                   syntax_only = (uu___157_10597.syntax_only);
                                   ds_hooks = (uu___157_10597.ds_hooks)
                                 }  in
                               (FStar_List.iter
                                  (fun op  ->
                                     (env1.ds_hooks).ds_push_open_hook env'
                                       op) (FStar_List.rev auto_open2);
                                env'))))))
               in
            let uu____10610 =
              FStar_All.pipe_right env.modules
                (FStar_Util.find_opt
                   (fun uu____10636  ->
                      match uu____10636 with
                      | (l,uu____10642) -> FStar_Ident.lid_equals l mname))
               in
            match uu____10610 with
            | FStar_Pervasives_Native.None  ->
                let uu____10651 = prep env  in (uu____10651, false)
            | FStar_Pervasives_Native.Some (uu____10652,m) ->
                ((let uu____10659 =
                    (let uu____10662 = FStar_Options.interactive ()  in
                     Prims.op_Negation uu____10662) &&
                      ((Prims.op_Negation m.FStar_Syntax_Syntax.is_interface)
                         || intf)
                     in
                  if uu____10659
                  then
                    let uu____10663 =
                      let uu____10668 =
                        FStar_Util.format1
                          "Duplicate module or interface name: %s"
                          mname.FStar_Ident.str
                         in
                      (FStar_Errors.Fatal_DuplicateModuleOrInterface,
                        uu____10668)
                       in
                    FStar_Errors.raise_error uu____10663
                      (FStar_Ident.range_of_lid mname)
                  else ());
                 (let uu____10670 =
                    let uu____10671 = push env  in prep uu____10671  in
                  (uu____10670, true)))
  
let (enter_monad_scope : env -> FStar_Ident.ident -> env) =
  fun env  ->
    fun mname  ->
      match env.curmonad with
      | FStar_Pervasives_Native.Some mname' ->
          FStar_Errors.raise_error
            (FStar_Errors.Fatal_MonadAlreadyDefined,
              (Prims.strcat "Trying to define monad "
                 (Prims.strcat mname.FStar_Ident.idText
                    (Prims.strcat ", but already in monad scope "
                       mname'.FStar_Ident.idText))))
            mname.FStar_Ident.idRange
      | FStar_Pervasives_Native.None  ->
          let uu___158_10679 = env  in
          {
            curmodule = (uu___158_10679.curmodule);
            curmonad = (FStar_Pervasives_Native.Some mname);
            modules = (uu___158_10679.modules);
            scope_mods = (uu___158_10679.scope_mods);
            exported_ids = (uu___158_10679.exported_ids);
            trans_exported_ids = (uu___158_10679.trans_exported_ids);
            includes = (uu___158_10679.includes);
            sigaccum = (uu___158_10679.sigaccum);
            sigmap = (uu___158_10679.sigmap);
            iface = (uu___158_10679.iface);
            admitted_iface = (uu___158_10679.admitted_iface);
            expect_typ = (uu___158_10679.expect_typ);
            docs = (uu___158_10679.docs);
            remaining_iface_decls = (uu___158_10679.remaining_iface_decls);
            syntax_only = (uu___158_10679.syntax_only);
            ds_hooks = (uu___158_10679.ds_hooks)
          }
  
let fail_or :
  'a .
    env ->
      (FStar_Ident.lident -> 'a FStar_Pervasives_Native.option) ->
        FStar_Ident.lident -> 'a
  =
  fun env  ->
    fun lookup1  ->
      fun lid  ->
        let uu____10706 = lookup1 lid  in
        match uu____10706 with
        | FStar_Pervasives_Native.None  ->
            let opened_modules =
              FStar_List.map
                (fun uu____10719  ->
                   match uu____10719 with
                   | (lid1,uu____10725) -> FStar_Ident.text_of_lid lid1)
                env.modules
               in
            let msg =
              FStar_Util.format1 "Identifier not found: [%s]"
                (FStar_Ident.text_of_lid lid)
               in
            let msg1 =
              if
                (FStar_List.length lid.FStar_Ident.ns) =
                  (Prims.parse_int "0")
              then msg
              else
                (let modul =
                   let uu____10730 =
                     FStar_Ident.lid_of_ids lid.FStar_Ident.ns  in
                   FStar_Ident.set_lid_range uu____10730
                     (FStar_Ident.range_of_lid lid)
                    in
                 let uu____10731 = resolve_module_name env modul true  in
                 match uu____10731 with
                 | FStar_Pervasives_Native.None  ->
                     let opened_modules1 =
                       FStar_String.concat ", " opened_modules  in
                     FStar_Util.format3
                       "%s\nModule %s does not belong to the list of modules in scope, namely %s"
                       msg modul.FStar_Ident.str opened_modules1
                 | FStar_Pervasives_Native.Some modul' when
                     Prims.op_Negation
                       (FStar_List.existsb
                          (fun m  -> m = modul'.FStar_Ident.str)
                          opened_modules)
                     ->
                     let opened_modules1 =
                       FStar_String.concat ", " opened_modules  in
                     FStar_Util.format4
                       "%s\nModule %s resolved into %s, which does not belong to the list of modules in scope, namely %s"
                       msg modul.FStar_Ident.str modul'.FStar_Ident.str
                       opened_modules1
                 | FStar_Pervasives_Native.Some modul' ->
                     FStar_Util.format4
                       "%s\nModule %s resolved into %s, definition %s not found"
                       msg modul.FStar_Ident.str modul'.FStar_Ident.str
                       (lid.FStar_Ident.ident).FStar_Ident.idText)
               in
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_IdentifierNotFound, msg1)
              (FStar_Ident.range_of_lid lid)
        | FStar_Pervasives_Native.Some r -> r
  
let fail_or2 :
  'a .
    (FStar_Ident.ident -> 'a FStar_Pervasives_Native.option) ->
      FStar_Ident.ident -> 'a
  =
  fun lookup1  ->
    fun id1  ->
      let uu____10762 = lookup1 id1  in
      match uu____10762 with
      | FStar_Pervasives_Native.None  ->
          FStar_Errors.raise_error
            (FStar_Errors.Fatal_IdentifierNotFound,
              (Prims.strcat "Identifier not found ["
                 (Prims.strcat id1.FStar_Ident.idText "]")))
            id1.FStar_Ident.idRange
      | FStar_Pervasives_Native.Some r -> r
  
let (mk_copy : env -> env) =
  fun en  ->
    let uu___159_10769 = en  in
    let uu____10770 = FStar_Util.smap_copy en.exported_ids  in
    let uu____10773 = FStar_Util.smap_copy en.trans_exported_ids  in
    let uu____10776 = FStar_Util.smap_copy en.sigmap  in
    let uu____10787 = FStar_Util.smap_copy en.docs  in
    {
      curmodule = (uu___159_10769.curmodule);
      curmonad = (uu___159_10769.curmonad);
      modules = (uu___159_10769.modules);
      scope_mods = (uu___159_10769.scope_mods);
      exported_ids = uu____10770;
      trans_exported_ids = uu____10773;
      includes = (uu___159_10769.includes);
      sigaccum = (uu___159_10769.sigaccum);
      sigmap = uu____10776;
      iface = (uu___159_10769.iface);
      admitted_iface = (uu___159_10769.admitted_iface);
      expect_typ = (uu___159_10769.expect_typ);
      docs = uu____10787;
      remaining_iface_decls = (uu___159_10769.remaining_iface_decls);
      syntax_only = (uu___159_10769.syntax_only);
      ds_hooks = (uu___159_10769.ds_hooks)
    }
  