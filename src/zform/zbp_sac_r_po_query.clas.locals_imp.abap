CLASS lhc_zsac_r_po_query DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsac_r_po_query RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zsac_r_po_query RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zsac_r_po_query.

    METHODS rba_Poheader FOR READ
      IMPORTING keys_rba FOR READ zsac_r_po_query\_Poheader FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zsac_r_po_query IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Poheader.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zsac_i_po_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ zsac_i_po_header RESULT result.

    METHODS rba_Query FOR READ
      IMPORTING keys_rba FOR READ zsac_i_po_header\_Query FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zsac_i_po_header IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Query.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZSAC_R_PO_QUERY DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZSAC_R_PO_QUERY IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
