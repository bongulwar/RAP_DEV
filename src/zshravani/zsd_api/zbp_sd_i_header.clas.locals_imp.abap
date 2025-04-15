CLASS lhc_zsd_i_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsd_i_header RESULT result.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE zsd_i_header.

*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE zsd_i_header.

*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE zsd_i_header.

**"ZSD_I_HEADER" has the implementation type "managed", hence the implementation type "READ" is superfluous.
*    METHODS read FOR READ
*      IMPORTING keys FOR READ zsd_i_header RESULT result.

*    METHODS lock FOR LOCK
*      IMPORTING keys FOR LOCK zsd_i_header.

ENDCLASS.

CLASS lhc_zsd_i_header IMPLEMENTATION.

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

*CLASS lsc_zsd_i_header DEFINITION INHERITING FROM cl_abap_behavior_saver.
*  PROTECTED SECTION.

*    METHODS finalize REDEFINITION.

*    METHODS check_before_save REDEFINITION.
*
*    METHODS save REDEFINITION.
*
*    METHODS cleanup REDEFINITION.
*
*    METHODS cleanup_finalize REDEFINITION.

*ENDCLASS.
*
*CLASS lsc_zsd_i_header IMPLEMENTATION.

*  METHOD finalize.
*  ENDMETHOD.
*
*  METHOD check_before_save.
*  ENDMETHOD.
*
*  METHOD save.
*  ENDMETHOD.
*
*  METHOD cleanup.
*  ENDMETHOD.
*
*  METHOD cleanup_finalize.
*  ENDMETHOD.

*ENDCLASS.
