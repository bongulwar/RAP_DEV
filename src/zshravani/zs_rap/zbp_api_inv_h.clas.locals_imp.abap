CLASS lhc_Invoice_H DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Invoice_H RESULT result.

ENDCLASS.

CLASS lhc_Invoice_H IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZAPI_INV_H DEFINITION INHERITING FROM cl_abap_behavior_saver_failed.
  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZAPI_INV_H IMPLEMENTATION.

  METHOD adjust_numbers.
    "get all records from buffer
    READ ENTITY IN LOCAL MODE zapi_inv_h\\Invoice_H
    ALL FIELDS WITH VALUE #( FOR ls_header IN mapped-invoice_h ( %pid = ls_header-%pid ) )
    RESULT DATA(lt_header).

    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<ls_data>).
      "ls_data-CompanyCode.
      DATA ls_inv_h TYPE zapi_inv_h.
      ls_inv_h = CORRESPONDING #( <ls_data> ).

      DATA(lr_post) = NEW ycl_call_post_api( ).
      lr_post->post_invoice_check(
        EXPORTING
          i_data = ls_inv_h
        IMPORTING
         e_msg  = DATA(lv_message)
      ).

      IF lv_message IS NOT INITIAL   .
        <ls_data>-InvoiceNumber = lv_message-inv_no.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD save_modified.
    DATA: ls_inv_h TYPE zapi_inv_h,
          e_data   TYPE zapi_inv_h.
*Getting Dump -
    "DESTINATION 'NONE'  -  Short Text  The use of this RFC destination is not permitted.
*                    -  Runtime Error  RFC_ILLEGAL_CALL_ON_SAPCP
*    CALL FUNCTION 'Z_FM_RAP_CALL_SOAP' DESTINATION 'NONE'
*      EXPORTING
*        i_data = ls_inv_h
*      IMPORTING
*        e_data = e_data.

    "Short Text  Statement "SRFC" is not allowed with this status.
*Runtime Error  BEHAVIOR_ILLEGAL_STATEMENT
*Solution -> Don't not call External API in SAVE method, instead call from  Create by Association "cba_Invoice_item. (Reference: zbp_i_invoice_h->cba_Invoice_item)
    DATA(lr_post) = NEW ycl_call_post_api( ).
    lr_post->post_invoice(
      EXPORTING
        i_data = ls_inv_h
      IMPORTING
       e_msg  = DATA(lv_message)
    ).

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

"IN UPDATE TASK-
"DESTINATION 'NONE'  - Getting Dump -  Short Text  The use of this RFC destination is not permitted.
*                                          Runtime Error  RFC_ILLEGAL_CALL_ON_SAPCP
