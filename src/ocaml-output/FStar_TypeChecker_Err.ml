open Prims
let (info_at_pos :
  FStar_TypeChecker_Env.env ->
    Prims.string ->
      Prims.int ->
        Prims.int ->
          ((Prims.string,FStar_Ident.lid) FStar_Util.either,FStar_Syntax_Syntax.typ,
            FStar_Range.range) FStar_Pervasives_Native.tuple3
            FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun file  ->
      fun row  ->
        fun col  ->
          let uu____25 =
            let uu____28 =
              FStar_ST.op_Bang env.FStar_TypeChecker_Env.identifier_info  in
            FStar_TypeChecker_Common.id_info_at_pos uu____28 file row col  in
          match uu____25 with
          | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
          | FStar_Pervasives_Native.Some info ->
              (match info.FStar_TypeChecker_Common.identifier with
               | FStar_Util.Inl bv ->
                   let uu____84 =
                     let uu____95 =
                       let uu____100 = FStar_Syntax_Print.nm_to_string bv  in
                       FStar_Util.Inl uu____100  in
                     let uu____101 = FStar_Syntax_Syntax.range_of_bv bv  in
                     (uu____95,
                       (info.FStar_TypeChecker_Common.identifier_ty),
                       uu____101)
                      in
                   FStar_Pervasives_Native.Some uu____84
               | FStar_Util.Inr fv ->
                   let uu____117 =
                     let uu____128 =
                       let uu____133 = FStar_Syntax_Syntax.lid_of_fv fv  in
                       FStar_Util.Inr uu____133  in
                     let uu____134 = FStar_Syntax_Syntax.range_of_fv fv  in
                     (uu____128,
                       (info.FStar_TypeChecker_Common.identifier_ty),
                       uu____134)
                      in
                   FStar_Pervasives_Native.Some uu____117)
  
let (add_errors :
  FStar_TypeChecker_Env.env ->
    (FStar_Errors.raw_error,Prims.string,FStar_Range.range)
      FStar_Pervasives_Native.tuple3 Prims.list -> Prims.unit)
  =
  fun env  ->
    fun errs  ->
      let errs1 =
        FStar_All.pipe_right errs
          (FStar_List.map
             (fun uu____213  ->
                match uu____213 with
                | (e,msg,r) ->
                    if r = FStar_Range.dummyRange
                    then
                      let uu____235 = FStar_TypeChecker_Env.get_range env  in
                      (e, msg, uu____235)
                    else
                      (let r' =
                         let uu____238 = FStar_Range.use_range r  in
                         FStar_Range.set_def_range r uu____238  in
                       let uu____239 =
                         let uu____240 = FStar_Range.file_of_range r'  in
                         let uu____241 =
                           let uu____242 =
                             FStar_TypeChecker_Env.get_range env  in
                           FStar_Range.file_of_range uu____242  in
                         uu____240 <> uu____241  in
                       if uu____239
                       then
                         let uu____249 =
                           let uu____250 =
                             let uu____251 =
                               let uu____252 =
                                 FStar_Range.string_of_use_range r  in
                               Prims.strcat uu____252 ")"  in
                             Prims.strcat "(Also see: " uu____251  in
                           Prims.strcat msg uu____250  in
                         let uu____253 = FStar_TypeChecker_Env.get_range env
                            in
                         (e, uu____249, uu____253)
                       else (e, msg, r))))
         in
      FStar_Errors.add_errors errs1
  
let (err_msg_type_strings :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        (Prims.string,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun t1  ->
      fun t2  ->
        let s1 = FStar_TypeChecker_Normalize.term_to_string env t1  in
        let s2 = FStar_TypeChecker_Normalize.term_to_string env t2  in
        if s1 = s2
        then
          FStar_Options.with_saved_options
            (fun uu____286  ->
               (let uu____288 =
                  FStar_Options.set_options FStar_Options.Set
                    "--print_full_names --print_universes"
                   in
                ());
               (let uu____289 =
                  FStar_TypeChecker_Normalize.term_to_string env t1  in
                let uu____290 =
                  FStar_TypeChecker_Normalize.term_to_string env t2  in
                (uu____289, uu____290)))
        else (s1, s2)
  
let (exhaustiveness_check : Prims.string) = "Patterns are incomplete" 
let (subtyping_failed :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.typ -> Prims.unit -> Prims.string)
  =
  fun env  ->
    fun t1  ->
      fun t2  ->
        fun x  ->
          let uu____304 = err_msg_type_strings env t1 t2  in
          match uu____304 with
          | (s1,s2) ->
              FStar_Util.format2
                "Subtyping check failed; expected type %s; got type %s" s2 s1
  
let (ill_kinded_type : Prims.string) = "Ill-kinded type" 
let (totality_check : Prims.string) = "This term may not terminate" 
let (unexpected_signature_for_monad :
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.term ->
        (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun m  ->
      fun k  ->
        let uu____324 =
          let uu____325 = FStar_TypeChecker_Normalize.term_to_string env k
             in
          FStar_Util.format2
            "Unexpected signature for monad \"%s\". Expected a signature of the form (a:Type => WP a => Effect); got %s"
            m.FStar_Ident.str uu____325
           in
        (FStar_Errors.Fatal_UnexpectedSignatureForMonad, uu____324)
  
let (expected_a_term_of_type_t_got_a_function :
  FStar_TypeChecker_Env.env ->
    Prims.string ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term ->
          (FStar_Errors.raw_error,Prims.string)
            FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun msg  ->
      fun t  ->
        fun e  ->
          let uu____342 =
            let uu____343 = FStar_TypeChecker_Normalize.term_to_string env t
               in
            let uu____344 = FStar_Syntax_Print.term_to_string e  in
            FStar_Util.format3
              "Expected a term of type \"%s\"; got a function \"%s\" (%s)"
              uu____343 uu____344 msg
             in
          (FStar_Errors.Fatal_ExpectTermGotFunction, uu____342)
  
let (unexpected_implicit_argument :
  (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2) =
  (FStar_Errors.Fatal_UnexpectedImplicitArgument,
    "Unexpected instantiation of an implicit argument to a function that only expects explicit arguments")
  
let (expected_expression_of_type :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term ->
          (FStar_Errors.raw_error,Prims.string)
            FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun t1  ->
      fun e  ->
        fun t2  ->
          let uu____365 = err_msg_type_strings env t1 t2  in
          match uu____365 with
          | (s1,s2) ->
              let uu____376 =
                let uu____377 = FStar_Syntax_Print.term_to_string e  in
                FStar_Util.format3
                  "Expected expression of type \"%s\"; got expression \"%s\" of type \"%s\""
                  s1 uu____377 s2
                 in
              (FStar_Errors.Fatal_UnexpectedExpressionType, uu____376)
  
let (expected_function_with_parameter_of_type :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term -> Prims.string -> Prims.string)
  =
  fun env  ->
    fun t1  ->
      fun t2  ->
        let uu____389 = err_msg_type_strings env t1 t2  in
        match uu____389 with
        | (s1,s2) ->
            FStar_Util.format3
              "Expected a function with a parameter of type \"%s\"; this function has a parameter of type \"%s\""
              s1 s2
  
let (expected_pattern_of_type :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term ->
          (FStar_Errors.raw_error,Prims.string)
            FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun t1  ->
      fun e  ->
        fun t2  ->
          let uu____414 = err_msg_type_strings env t1 t2  in
          match uu____414 with
          | (s1,s2) ->
              let uu____425 =
                let uu____426 = FStar_Syntax_Print.term_to_string e  in
                FStar_Util.format3
                  "Expected pattern of type \"%s\"; got pattern \"%s\" of type \"%s\""
                  s1 uu____426 s2
                 in
              (FStar_Errors.Fatal_UnexpectedPattern, uu____425)
  
let (basic_type_error :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term ->
          (FStar_Errors.raw_error,Prims.string)
            FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun eopt  ->
      fun t1  ->
        fun t2  ->
          let uu____447 = err_msg_type_strings env t1 t2  in
          match uu____447 with
          | (s1,s2) ->
              let msg =
                match eopt with
                | FStar_Pervasives_Native.None  ->
                    FStar_Util.format2
                      "Expected type \"%s\"; got type \"%s\"" s1 s2
                | FStar_Pervasives_Native.Some e ->
                    let uu____460 =
                      FStar_TypeChecker_Normalize.term_to_string env e  in
                    FStar_Util.format3
                      "Expected type \"%s\"; but \"%s\" has type \"%s\"" s1
                      uu____460 s2
                 in
              (FStar_Errors.Error_TypeError, msg)
  
let (occurs_check :
  (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2) =
  (FStar_Errors.Fatal_PossibleInfiniteTyp,
    "Possibly infinite typ (occurs check failed)")
  
let (incompatible_kinds :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun k1  ->
      fun k2  ->
        let uu____478 =
          let uu____479 = FStar_TypeChecker_Normalize.term_to_string env k1
             in
          let uu____480 = FStar_TypeChecker_Normalize.term_to_string env k2
             in
          FStar_Util.format2 "Kinds \"%s\" and \"%s\" are incompatible"
            uu____479 uu____480
           in
        (FStar_Errors.Fatal_IncompatibleKinds, uu____478)
  
let (constructor_builds_the_wrong_type :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term ->
          (FStar_Errors.raw_error,Prims.string)
            FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      fun t  ->
        fun t'  ->
          let uu____497 =
            let uu____498 = FStar_Syntax_Print.term_to_string d  in
            let uu____499 = FStar_TypeChecker_Normalize.term_to_string env t
               in
            let uu____500 = FStar_TypeChecker_Normalize.term_to_string env t'
               in
            FStar_Util.format3
              "Constructor \"%s\" builds a value of type \"%s\"; expected \"%s\""
              uu____498 uu____499 uu____500
             in
          (FStar_Errors.Fatal_ConstsructorBuildWrongType, uu____497)
  
let constructor_fails_the_positivity_check :
  'Auu____505 .
    'Auu____505 ->
      FStar_Syntax_Syntax.term ->
        FStar_Ident.lid ->
          (FStar_Errors.raw_error,Prims.string)
            FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun d  ->
      fun l  ->
        let uu____522 =
          let uu____523 = FStar_Syntax_Print.term_to_string d  in
          let uu____524 = FStar_Syntax_Print.lid_to_string l  in
          FStar_Util.format2
            "Constructor \"%s\" fails the strict positivity check; the constructed type \"%s\" occurs to the left of a pure function type"
            uu____523 uu____524
           in
        (FStar_Errors.Fatal_ConstructorFailedCheck, uu____522)
  
let (inline_type_annotation_and_val_decl :
  FStar_Ident.lid ->
    (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun l  ->
    let uu____532 =
      let uu____533 = FStar_Syntax_Print.lid_to_string l  in
      FStar_Util.format1
        "\"%s\" has a val declaration as well as an inlined type annotation; remove one"
        uu____533
       in
    (FStar_Errors.Fatal_DuplicateTypeAnnotationAndValDecl, uu____532)
  
let (inferred_type_causes_variable_to_escape :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.bv ->
        (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun t  ->
      fun x  ->
        let uu____547 =
          let uu____548 = FStar_TypeChecker_Normalize.term_to_string env t
             in
          let uu____549 = FStar_Syntax_Print.bv_to_string x  in
          FStar_Util.format2
            "Inferred type \"%s\" causes variable \"%s\" to escape its scope"
            uu____548 uu____549
           in
        (FStar_Errors.Fatal_InferredTypeCauseVarEscape, uu____547)
  
let (expected_function_typ :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun t  ->
      let uu____560 =
        let uu____561 = FStar_TypeChecker_Normalize.term_to_string env t  in
        FStar_Util.format1
          "Expected a function; got an expression of type \"%s\"" uu____561
         in
      (FStar_Errors.Fatal_FunctionTypeExpected, uu____560)
  
let (expected_poly_typ :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term ->
          (FStar_Errors.raw_error,Prims.string)
            FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun f  ->
      fun t  ->
        fun targ  ->
          let uu____578 =
            let uu____579 = FStar_Syntax_Print.term_to_string f  in
            let uu____580 = FStar_TypeChecker_Normalize.term_to_string env t
               in
            let uu____581 =
              FStar_TypeChecker_Normalize.term_to_string env targ  in
            FStar_Util.format3
              "Expected a polymorphic function; got an expression \"%s\" of type \"%s\" applied to a type \"%s\""
              uu____579 uu____580 uu____581
             in
          (FStar_Errors.Fatal_PolyTypeExpected, uu____578)
  
let (nonlinear_pattern_variable :
  FStar_Syntax_Syntax.bv ->
    (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun x  ->
    let m = FStar_Syntax_Print.bv_to_string x  in
    let uu____590 =
      FStar_Util.format1
        "The pattern variable \"%s\" was used more than once" m
       in
    (FStar_Errors.Fatal_NonLinearPatternVars, uu____590)
  
let (disjunctive_pattern_vars :
  FStar_Syntax_Syntax.bv Prims.list ->
    FStar_Syntax_Syntax.bv Prims.list ->
      (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun v1  ->
    fun v2  ->
      let vars v3 =
        let uu____617 =
          FStar_All.pipe_right v3
            (FStar_List.map FStar_Syntax_Print.bv_to_string)
           in
        FStar_All.pipe_right uu____617 (FStar_String.concat ", ")  in
      let uu____626 =
        let uu____627 = vars v1  in
        let uu____628 = vars v2  in
        FStar_Util.format2
          "Every alternative of an 'or' pattern must bind the same variables; here one branch binds (\"%s\") and another (\"%s\")"
          uu____627 uu____628
         in
      (FStar_Errors.Fatal_DisjuctivePatternVarsMismatch, uu____626)
  
let (name_and_result :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    (Prims.string,FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
      FStar_Pervasives_Native.tuple2)
  =
  fun c  ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total (t,uu____649) -> ("Tot", t)
    | FStar_Syntax_Syntax.GTotal (t,uu____661) -> ("GTot", t)
    | FStar_Syntax_Syntax.Comp ct ->
        let uu____673 =
          FStar_Syntax_Print.lid_to_string ct.FStar_Syntax_Syntax.effect_name
           in
        (uu____673, (ct.FStar_Syntax_Syntax.result_typ))
  
let computed_computation_type_does_not_match_annotation :
  'Auu____681 .
    FStar_TypeChecker_Env.env ->
      'Auu____681 ->
        FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
          FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
            (FStar_Errors.raw_error,Prims.string)
              FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun e  ->
      fun c  ->
        fun c'  ->
          let uu____710 = name_and_result c  in
          match uu____710 with
          | (f1,r1) ->
              let uu____727 = name_and_result c'  in
              (match uu____727 with
               | (f2,r2) ->
                   let uu____744 = err_msg_type_strings env r1 r2  in
                   (match uu____744 with
                    | (s1,s2) ->
                        let uu____755 =
                          FStar_Util.format4
                            "Computed type \"%s\" and effect \"%s\" is not compatible with the annotated type \"%s\" effect \"%s\""
                            s1 f1 s2 f2
                           in
                        (FStar_Errors.Fatal_ComputedTypeNotMatchAnnotation,
                          uu____755)))
  
let (unexpected_non_trivial_precondition_on_term :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term ->
      (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun f  ->
      let uu____766 =
        let uu____767 = FStar_TypeChecker_Normalize.term_to_string env f  in
        FStar_Util.format1
          "Term has an unexpected non-trivial pre-condition: %s" uu____767
         in
      (FStar_Errors.Fatal_UnExpectedPreCondition, uu____766)
  
let (expected_pure_expression :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun e  ->
    fun c  ->
      let uu____782 =
        let uu____783 = FStar_Syntax_Print.term_to_string e  in
        let uu____784 =
          let uu____785 = name_and_result c  in
          FStar_All.pipe_left FStar_Pervasives_Native.fst uu____785  in
        FStar_Util.format2
          "Expected a pure expression; got an expression \"%s\" with effect \"%s\""
          uu____783 uu____784
         in
      (FStar_Errors.Fatal_ExpectedPureExpression, uu____782)
  
let (expected_ghost_expression :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun e  ->
    fun c  ->
      let uu____814 =
        let uu____815 = FStar_Syntax_Print.term_to_string e  in
        let uu____816 =
          let uu____817 = name_and_result c  in
          FStar_All.pipe_left FStar_Pervasives_Native.fst uu____817  in
        FStar_Util.format2
          "Expected a ghost expression; got an expression \"%s\" with effect \"%s\""
          uu____815 uu____816
         in
      (FStar_Errors.Fatal_ExpectedGhostExpression, uu____814)
  
let (expected_effect_1_got_effect_2 :
  FStar_Ident.lident ->
    FStar_Ident.lident ->
      (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun c1  ->
    fun c2  ->
      let uu____842 =
        let uu____843 = FStar_Syntax_Print.lid_to_string c1  in
        let uu____844 = FStar_Syntax_Print.lid_to_string c2  in
        FStar_Util.format2
          "Expected a computation with effect %s; but it has effect %s"
          uu____843 uu____844
         in
      (FStar_Errors.Fatal_UnexpectedEffect, uu____842)
  
let (failed_to_prove_specification_of :
  FStar_Syntax_Syntax.lbname ->
    Prims.string Prims.list ->
      (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun l  ->
    fun lbls  ->
      let uu____859 =
        let uu____860 = FStar_Syntax_Print.lbname_to_string l  in
        let uu____861 = FStar_All.pipe_right lbls (FStar_String.concat ", ")
           in
        FStar_Util.format2
          "Failed to prove specification of %s; assertions at [%s] may fail"
          uu____860 uu____861
         in
      (FStar_Errors.Error_TypeCheckerFailToProve, uu____859)
  
let (failed_to_prove_specification :
  Prims.string Prims.list ->
    (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun lbls  ->
    let msg =
      match lbls with
      | [] ->
          "An unknown assertion in the term at this location was not provable"
      | uu____876 ->
          let uu____879 =
            FStar_All.pipe_right lbls (FStar_String.concat "\n\t")  in
          FStar_Util.format1 "The following problems were found:\n\t%s"
            uu____879
       in
    (FStar_Errors.Error_TypeCheckerFailToProve, msg)
  
let (top_level_effect :
  (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2) =
  (FStar_Errors.Warning_TopLevelEffect,
    "Top-level let-bindings must be total; this term may have effects")
  
let (cardinality_constraint_violated :
  FStar_Ident.lid ->
    FStar_Syntax_Syntax.bv FStar_Syntax_Syntax.withinfo_t ->
      (FStar_Errors.raw_error,Prims.string) FStar_Pervasives_Native.tuple2)
  =
  fun l  ->
    fun a  ->
      let uu____900 =
        let uu____901 = FStar_Syntax_Print.lid_to_string l  in
        let uu____902 =
          FStar_Syntax_Print.bv_to_string a.FStar_Syntax_Syntax.v  in
        FStar_Util.format2
          "Constructor %s violates the cardinality of Type at parameter '%s'; type arguments are not allowed"
          uu____901 uu____902
         in
      (FStar_Errors.Fatal_CardinalityConstraintViolated, uu____900)
  