CLASS zic_pr_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mm_pur_s4_pr_modify_item .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZIC_PR_ITEM IMPLEMENTATION.


  METHOD if_mm_pur_s4_pr_modify_item~modify_item.

    DATA: ls_message LIKE LINE OF messages.

    " If <very common scenario occurs>, display Warning
    IF purchaserequisition-purchasingdocumenttype EQ 'NB'.
      ls_message-messageid = 'SampleID'.             "Message ID
      ls_message-messagetype = 'W'.                   "Type of Message
      ls_message-messagenumber = '001'.               "Message Number
      ls_message-messagevariable1 = 'PH1'.           "Place holder
      APPEND ls_message TO messages.
    ENDIF.




  ENDMETHOD.
ENDCLASS.
