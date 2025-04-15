** Below code is copied from SAP Tutorial
** https://developers.sap.com/tutorials/abap-s4hanacloud-procurement-purchasereq-checks.html

CLASS zcl_check_purch_req_001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mm_pur_s4_pr_check .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CHECK_PURCH_REQ_001 IMPLEMENTATION.


  METHOD if_mm_pur_s4_pr_check~check.

    DATA ls_message TYPE mmpur_s_messages.

*    READ TABLE  purchaserequisitionitem_table  INTO DATA(ls_pur_req_itm) INDEX 1    .
*    IF sy-subrc IS INITIAL.
*      IF ls_pur_req_itm-orderedquantity > 10.
*        ls_message-messageid = 'DUMMY'.
*        ls_message-messagetype = 'E'.
*        ls_message-messagenumber = '001'.
*        ls_message-messagevariable1 = ' Quantity limit 10'.         "Place holder
*        ls_message-messagevariable2 = '-> pls check zcl_check_purch_req_001'.
*        APPEND ls_message TO messages.
*
*      ENDIF.
*
*      IF ls_pur_req_itm-deliverydate - ( cl_abap_context_info=>get_system_date( ) ) > 180.
*        ls_message-messageid = 'DUMMY'.
*        ls_message-messagetype = 'E'.
*        ls_message-messagenumber = '001'.
*        ls_message-messagevariable1 = 'Delivery date limit 180 days '.           "Place holder
*        ls_message-messagevariable2 = '-> pls check zcl_check_purch_req_001'.
*        APPEND ls_message TO messages.
*
*      ENDIF.

*    ENDIF.
  ENDMETHOD.
ENDCLASS.
