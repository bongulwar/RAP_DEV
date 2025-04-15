CLASS lhc_zi_doc_att DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_doc_att RESULT result.

    "ZI_DOC_ATT" has the implementation type "managed", hence the implementation type "UPDATE" is superfluous.
*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE zi_doc_att.

*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE zi_doc_att.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE zi_doc_att.
*
*    METHODS read FOR READ
*      IMPORTING keys FOR READ zi_doc_att RESULT result.
*
*    METHODS lock FOR LOCK
*      IMPORTING keys FOR LOCK zi_doc_att.

ENDCLASS.

CLASS lhc_zi_doc_att IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD create.
*  ENDMETHOD.
*
*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.
*
*  METHOD read.
*  ENDMETHOD.
*
*  METHOD lock.
*  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_doc_att DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

*    METHODS finalize REDEFINITION.
*
*    METHODS check_before_save REDEFINITION.
*
*    METHODS cleanup REDEFINITION.
*
*    METHODS cleanup_finalize REDEFINITION.
*
*    METHODS save REDEFINITION.

ENDCLASS.

CLASS lsc_zi_doc_att IMPLEMENTATION.

*  METHOD finalize.
*  ENDMETHOD.
*
*  METHOD check_before_save.
*  ENDMETHOD.
*
*  METHOD cleanup.
*  ENDMETHOD.
*
*  METHOD cleanup_finalize.
*  ENDMETHOD.
*
*  METHOD save.
*  ENDMETHOD.

ENDCLASS.
