CLASS lhc_Invoice_h DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Invoice_h RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Invoice_h.

*    METHODS earlynumbering_create FOR NUMBERING
*      IMPORTING entities FOR CREATE Invoice_h.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Invoice_h.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Invoice_h.

    METHODS read FOR READ
      IMPORTING keys FOR READ Invoice_h RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Invoice_h.

    METHODS rba_Invoice_item FOR READ "Read By Association
      IMPORTING keys_rba FOR READ Invoice_h\_Invoice_item FULL result_requested RESULT result LINK association_links.

    METHODS cba_Invoice_item FOR MODIFY "Create By Association
      IMPORTING entities_cba FOR CREATE Invoice_h\_Invoice_item.

*    METHODS earlynumbering_cba_Invoice_ite FOR NUMBERING
*      IMPORTING entities FOR CREATE Invoice_h\_Invoice_item.

ENDCLASS.

CLASS lhc_Invoice_h IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    zcl_cust_api_crud=>get_instance(  )->create_invoice_h(
      EXPORTING
        entities = entities
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported
    ).
  ENDMETHOD.

*  METHOD earlynumbering_create.
*    zcl_cust_api_crud=>get_instance(  )->earlynumbering_create(
*    EXPORTING
*      entities = entities
*    CHANGING
*      mapped   =  mapped
*      failed   =  failed
*      reported = reported
*  ).
*  ENDMETHOD.

  METHOD update.
    zcl_cust_api_crud=>get_instance(  )->update_invoice_h(
      EXPORTING
        entities = entities
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported
    ).
  ENDMETHOD.

  METHOD delete.
    zcl_cust_api_crud=>get_instance(  )->delete_invoice_h(
      EXPORTING
        keys     = keys
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported
    ).
  ENDMETHOD.

  METHOD read.
    zcl_cust_api_crud=>get_instance(  )->read_invoice(
      EXPORTING
        keys     = keys
      CHANGING
        result   = result
        failed   = failed
        reported = reported
    ).
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Invoice_item.
  ENDMETHOD.

  METHOD cba_Invoice_item.
    zcl_cust_api_crud=>get_instance(  )->cba_invoice_item(
      EXPORTING
        entities_cba = entities_cba
      CHANGING
        mapped       = mapped
        failed       = failed
        reported     = reported
    ).
  ENDMETHOD.

*  METHOD earlynumbering_cba_Invoice_ite.
*    zcl_cust_api_crud=>get_instance(  )->earlynumbering_cba_invoice_ite(
*      EXPORTING
*        entities = entities
*      CHANGING
*        mapped   = mapped
*        failed   = failed
*        reported = reported
*    ).
*
*  ENDMETHOD.

ENDCLASS.

CLASS lhc_Invoice_I DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Invoice_I.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Invoice_I.

    METHODS read FOR READ
      IMPORTING keys FOR READ Invoice_I RESULT result.

    METHODS rba_Invoice_h FOR READ
      IMPORTING keys_rba FOR READ Invoice_I\_Invoice_h FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_Invoice_I IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Invoice_h.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_CUST_INVOICE_H DEFINITION INHERITING FROM cl_abap_behavior_saver_failed.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

*    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_CUST_INVOICE_H IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    zcl_cust_api_crud=>get_instance(  )->save_invoice_h(
      CHANGING
        reported = reported
    ).
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

*  METHOD adjust_numbers.
*
*  ENDMETHOD.

ENDCLASS.
