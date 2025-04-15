CLASS lhc_rap_tdat_cts DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      get
        RETURNING
          VALUE(result) TYPE REF TO if_mbc_cp_rap_tdat_cts.

ENDCLASS.

CLASS lhc_rap_tdat_cts IMPLEMENTATION.
  METHOD get.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZERRORCODE0001'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'ErrorCode0001' table = 'ZERROR_CODES_001' )
                                         ( entity = 'ErrorCode0001Text' table = 'ZERRCODET_0001' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_errorcode0001_s DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING
                  keys   REQUEST requested_features FOR errorcode0001all
        RESULT    result,
      selectcustomizingtransptreq FOR MODIFY
        IMPORTING
                  keys   FOR ACTION errorcode0001all~selectcustomizingtransptreq
        RESULT    result,
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR errorcode0001all
        RESULT result,
      edit FOR MODIFY
        IMPORTING
          keys FOR ACTION errorcode0001all~edit.
ENDCLASS.

CLASS lhc_zi_errorcode0001_s IMPLEMENTATION.
  METHOD get_instance_features.
    DATA: edit_flag            TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled
         ,transport_feature    TYPE abp_behv_field_ctrl VALUE if_abap_behv=>fc-f-mandatory
         ,selecttransport_flag TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ) = abap_false.
      transport_feature = if_abap_behv=>fc-f-unrestricted.
    ENDIF.
    IF keys[ 1 ]-%is_draft = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %tky = keys[ 1 ]-%tky
               %action-edit = edit_flag
               %assoc-_errorcode0001 = edit_flag
               %field-transportrequestid = transport_feature
               %action-selectcustomizingtransptreq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD selectcustomizingtransptreq.
    MODIFY ENTITIES OF zi_errorcode0001_s IN LOCAL MODE
      ENTITY errorcode0001all
        UPDATE FIELDS ( transportrequestid )
        WITH VALUE #( FOR key IN keys
                        ( %tky               = key-%tky
                          transportrequestid = key-%param-transportrequestid
                         ) ).

    READ ENTITIES OF zi_errorcode0001_s IN LOCAL MODE
      ENTITY errorcode0001all
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %tky   = entity-%tky
                          %param = entity ) ).
  ENDMETHOD.
  METHOD get_global_authorizations.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ERRORCODE0001' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%update      = is_authorized.
    result-%action-edit = is_authorized.
    result-%action-selectcustomizingtransptreq = is_authorized.
  ENDMETHOD.
  METHOD edit.
    CHECK lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ).
    DATA(transport_request) = lhc_rap_tdat_cts=>get( )->get_transport_request( ).
    IF transport_request IS NOT INITIAL.
      MODIFY ENTITY IN LOCAL MODE zi_errorcode0001_s
        EXECUTE selectcustomizingtransptreq FROM VALUE #( ( %is_draft = if_abap_behv=>mk-on
                                                            singletonid = 1
                                                            %param-transportrequestid = transport_request ) ).
      reported-errorcode0001all = VALUE #( ( %is_draft = if_abap_behv=>mk-on
                                     singletonid = 1
                                     %msg = mbc_cp_api=>message( )->get_transport_selected( transport_request ) ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS lsc_zi_errorcode0001_s DEFINITION FINAL INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS:
      save_modified REDEFINITION,
      cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_zi_errorcode0001_s IMPLEMENTATION.
  METHOD save_modified.
    READ TABLE update-errorcode0001all INDEX 1 INTO DATA(all).
    IF all-transportrequestid IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-transportrequestid
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD cleanup_finalize ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_errorcode0001text DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_features FOR GLOBAL FEATURES
        IMPORTING
        REQUEST requested_features FOR errorcode0001text
        RESULT result.
ENDCLASS.

CLASS lhc_zi_errorcode0001text IMPLEMENTATION.
  METHOD get_global_features.
    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%update = edit_flag.
    result-%delete = edit_flag.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_errorcode0001 DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_features FOR GLOBAL FEATURES
        IMPORTING
        REQUEST requested_features FOR errorcode0001
        RESULT result,
      validatetransportrequest FOR VALIDATE ON SAVE
        IMPORTING
          keys_errorcode0001     FOR errorcode0001~validatetransportrequest
          keys_errorcode0001text FOR errorcode0001text~validatetransportrequest.
ENDCLASS.

CLASS lhc_zi_errorcode0001 IMPLEMENTATION.
  METHOD get_global_features.
    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%update = edit_flag.
    result-%delete = edit_flag.
    result-%assoc-_errorcode0001text = edit_flag.
  ENDMETHOD.
  METHOD validatetransportrequest.
    DATA change TYPE REQUEST FOR CHANGE zi_errorcode0001_s.
    IF keys_errorcode0001 IS NOT INITIAL.
      DATA(is_draft) = keys_errorcode0001[ 1 ]-%is_draft.
    ELSEIF keys_errorcode0001text IS NOT INITIAL.
      is_draft = keys_errorcode0001text[ 1 ]-%is_draft.
    ELSE.
      RETURN.
    ENDIF.
    READ ENTITY IN LOCAL MODE zi_errorcode0001_s
    FROM VALUE #( ( %is_draft = is_draft
                    singletonid = 1
                    %control-transportrequestid = if_abap_behv=>mk-on ) )
    RESULT FINAL(transport_from_singleton).
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = VALUE #( transport_from_singleton[ 1 ]-transportrequestid OPTIONAL )
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZERROR_CODES_001' keys = REF #( keys_errorcode0001 ) )
                                                          ( table = 'ZERRCODET_0001' keys = REF #( keys_errorcode0001text ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
