CLASS lhc_yi_invoice_h DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    CLASS-DATA:
      gt_invoice_h   TYPE STANDARD TABLE OF yinvoice_h,
      gt_invoice_i   TYPE STANDARD TABLE OF yinvoice_i,
      gt_invoice_log TYPE STANDARD TABLE OF yinvoice_log,
      gv_timestamp1  TYPE timestampl,
      gv_id          TYPE sysuuid_x16,
      gv_invoice     TYPE yinvoice_h-invoice_number,
      gt_errors      TYPE STANDARD TABLE OF char256.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR yi_invoice_h RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE yi_invoice_h.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE yi_invoice_h.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE yi_invoice_h.

    METHODS read FOR READ
      IMPORTING keys FOR READ yi_invoice_h RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK yi_invoice_h.

    METHODS rba_invoice_item FOR READ
      IMPORTING keys_rba FOR READ yi_invoice_h\_invoice_item FULL result_requested RESULT result LINK association_links.

    METHODS cba_invoice_item FOR MODIFY
      IMPORTING entities_cba FOR CREATE yi_invoice_h\_invoice_item.

    METHODS rba_invoice_log FOR READ
      IMPORTING keys_rba FOR READ yi_invoice_h\_invoice_log FULL result_requested RESULT result LINK association_links.

    METHODS cba_invoice_log FOR MODIFY
      IMPORTING entities_cba FOR CREATE yi_invoice_h\_invoice_log.

** Added additional Methods + Types Data
    TYPES: BEGIN OF e_msg,
             message TYPE string,
             inv_no  TYPE zapi_inv_h-invoicenumber,
           END OF e_msg.

    METHODS:
      get_next_id
        RETURNING VALUE(rv_id) TYPE sysuuid_x16
        RAISING   cx_uuid_error ,

      get_next_invoice_id
        RETURNING VALUE(rv_inv_id) TYPE zinvoice_h-invoice_number,

      post_invoice
        EXPORTING e_msg TYPE e_msg."string.

ENDCLASS.

CLASS lhc_yi_invoice_h IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_next_id.
    TRY.
        DATA(lv_new_id) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        rv_id = lv_new_id.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.
  ENDMETHOD.

  METHOD get_next_invoice_id.
    SELECT MAX( invoice_number ) FROM zinvoice_h INTO @DATA(lv_inv_id).
    rv_inv_id = lv_inv_id + 1.
  ENDMETHOD.

  METHOD create.
* Read Entity from UI in table after filling all entries and press CREATE button
    "--Mapping is required for this CORRESPONDING in behavior CDS--DB in BH_Def.
    gt_invoice_h = CORRESPONDING #( entities MAPPING FROM ENTITY ).

    IF gt_invoice_h IS NOT INITIAL.

      TRY.
          gv_id = get_next_id( ).
        CATCH cx_uuid_error.
          "handle exception
      ENDTRY.

      GET TIME STAMP FIELD gv_timestamp1.
      gt_invoice_h[ 1 ]-locallastchangedat = gv_timestamp1.
      gt_invoice_h[ 1 ]-lastchangedat = gv_timestamp1.
      gt_invoice_h[ 1 ]-id = gv_id.

      mapped = VALUE #(
         yi_invoice_h  = VALUE #( FOR ls_entity IN entities
                                  (
                                      %cid = ls_entity-%cid
                                      %key = ls_entity-%key
                                      id = gv_id
                                   ) "For Loop
                                ) "yi_invoice_h
                             ).
    ENDIF.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_invoice_item.
  ENDMETHOD.

  METHOD rba_invoice_log.
  ENDMETHOD.

  METHOD cba_invoice_item.
** Create By Association
*Step 1 - Collect all Information from UI
    DATA(lv_item) = 0010.
    gt_invoice_i = VALUE #(
                            FOR ls_entity_cba IN entities_cba
                                 FOR ls_item_cba IN ls_entity_cba-%target
                                LET ls_rap_items = CORRESPONDING yinvoice_i( ls_item_cba MAPPING FROM ENTITY )
                                    IN (
                                        id = gv_id
                                        amount_in_transaction = ls_rap_items-amount_in_transaction
                                        amount_t_currency_code = ls_rap_items-amount_t_currency_code
                                        debit_credit_code = ls_rap_items-debit_credit_code
                                        glaccount = ls_rap_items-glaccount
                                        reference_document_item = ls_rap_items-reference_document_item
                                        )
                          ).

** To SAVE Data "Call RFC/ FM/ BAPI
*    CALL METHOD post_invoice
*      IMPORTING
*        e_msg = DATA(lv_message).
*
*    IF lv_message IS NOT INITIAL   .
*      gv_invoice   = lv_message-inv_no.
*    ELSE.
*      gv_invoice  = ''.
*    ENDIF.

    IF gv_invoice IS INITIAL.
      gv_invoice  = '0000000'.
    ENDIF.

*    IF lv_message-inv_no IS INITIAL. "Display Errors

**      failed = VALUE #(
**                yi_invoice_h = VALUE #(
**                                   FOR ls_failed IN entities_cba
**                                      (
**                                        %cid = ls_failed-%cid_ref
**                                      ) )
**                yi_invoice_i = VALUE #(
**                                    FOR ls_failed IN entities_cba
**                                        FOR ls_failed_i IN ls_failed-%target
**                                          (
**                                            %cid = ls_failed_i-%cid
**                                            %key = ls_failed_i-%key
**                                      ) )
**                                    ).

**      IF lines( gt_errors ) > 1 OR gv_invoice IS INITIAL.
**        READ TABLE entities_cba INTO DATA(ls_entity) INDEX 1.
**        DATA: lv_index TYPE i VALUE 1.
**
**        LOOP AT gt_errors INTO DATA(ls_message).
**          APPEND VALUE #(
**                           %cid = VALUE #( ls_entity-%target[ lv_index ]-%cid OPTIONAL )
**                           %key = VALUE #( ls_entity-%target[ lv_index ]-%key  OPTIONAL )
**                           %msg = new_message_with_text(
**                                     severity = if_abap_behv_message=>severity-error
**                                     text     =  ls_message
**                                  )
**                           ) TO reported-yi_invoice_i.
**          lv_index = lv_index + 1.
**        ENDLOOP.
**        CLEAR: lv_index.
**      ENDIF.

**    ELSE.

** Update New Invoice Number in Global Table Invoice-Header
    LOOP AT gt_invoice_h ASSIGNING FIELD-SYMBOL(<fs_hdr>).
      IF <fs_hdr>-id IS NOT INITIAL.
        <fs_hdr>-invoice_number = gv_invoice.
      ENDIF.
    ENDLOOP.

** Update New Invoice Number in Global Table Invoice-Item
    LOOP AT gt_invoice_i ASSIGNING FIELD-SYMBOL(<fs_item>).
      IF <fs_item>-id IS NOT INITIAL.
        <fs_item>-invoice_number = gv_invoice.
      ENDIF.
    ENDLOOP.

** Update New Invoice Number in Global Table Invoice-lOG
    gt_invoice_log = VALUE #(  FOR l = 1 WHILE l <= lines( gt_errors )
                                      LET ls_log = VALUE #( gt_errors[ l ] OPTIONAL )
                                      IN  (
                                            id = gv_id
                                            invoice_number = gv_invoice
                                            reference_document_item = l
                                            note  = ls_log
                                          ) ).
** Mapped result Out for UI display
    mapped =  VALUE #(
             yi_invoice_h  = VALUE #(
                                FOR ls_entity_h IN entities_cba
                                  (
                                      %cid = ls_entity_h-%cid_ref
                                      %key = ls_entity_h-%key
                                      id = gv_id
                                      invoicenumber = gv_invoice
                                  ) "For Loop
                                ) "yi_invoice_h
             yi_invoice_i = VALUE #(
                            FOR i = 1 WHILE i <= lines( entities_cba )
                            LET lt_items = VALUE #( entities_cba[ i ]-%target OPTIONAL )
                            IN
                                FOR j = 1 WHILE j <= lines( lt_items )
                                        LET ls_curee_item = VALUE #( lt_items[ j ] OPTIONAL )
                                        IN  (
                                                %cid = ls_curee_item-%cid
                                                %key = ls_curee_item-%key
                                                id = ls_curee_item-id
                                                invoicenumber = gv_invoice
                                            ) "LET-IN
                                     )"yi_invoice_i
                 )."mapped
**    ENDIF.
  ENDMETHOD.

  METHOD cba_invoice_log.

** Sending Data back to UI
    mapped = VALUE #(
            yi_invoice_h  = VALUE #(
                                FOR ls_entity_h IN entities_cba
                                  (
                                      %cid = ls_entity_h-%cid_ref
                                      %key = ls_entity_h-%key
                                      id = gv_id
                                      invoicenumber = gv_invoice
                                  ) "For Loop
                                ) "yi_invoice_h
            yi_invoice_log = VALUE #(
                                 FOR ls_head IN entities_cba
                                   FOR ls_log IN gt_invoice_log "gt_errors
                                            (
                                                %cid = | {  ls_head-%cid_ref }| && |{ ls_log-reference_document_item }|
                                                id = gv_id
                                                invoicenumber = gv_invoice
                                                referencedocumentitem = ls_log-reference_document_item
                                             )
                                    )
                      ).

    CLEAR :gv_invoice, gv_id, gv_timestamp1.
  ENDMETHOD.
  METHOD post_invoice.
    TRY.                                     "Sample URL
        DATA: lv_url        TYPE string VALUE 'https://my403888-api.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi',
              lv_out_string TYPE string.

        DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = lv_url ).
        destination->set_basic_authentication(
                                              i_user     = 'AFI'
                                              i_password = 'Qwertyuiopasdfghjkl1!'
                                             ).

        DATA(proxy) = NEW zco_journal_entry_create_reque( destination = destination ).

        IF gt_invoice_h IS NOT INITIAL.
          DATA(ls_header) = VALUE #( gt_invoice_h[ 1 ] OPTIONAL ).
        ENDIF.
        " fill request
        DATA(request) = VALUE zjournal_entry_bulk_create_req(
       journal_entry_bulk_create_requ = VALUE #( message_header = VALUE #( creation_date_time  = gv_timestamp1 "20240201110011 "'2018-06-05T12:00:00.1234567Z'
                                                                           test_data_indicator = '' ) "Pass 'X'-Document check - no errors: BKPFF $ 0M4OF7L
                  journal_entry_create_request = VALUE #(
                            ( "message_header = VALUE #( creation_date_time = 20240201110011 "'2018-06-05T12:00:00.1234567Z' test_data_indicator = 'X' )
                               journal_entry = VALUE #(
                                                original_reference_document_ty  = 'BKPFF'
                                                business_transaction_type = 'RFBU'
                                                accounting_document_type = 'SA'
                                                company_code = ls_header-company_code
                                                created_by_user = ls_header-created_by_user "'CB9980000010'
                                                document_date = ls_header-document_date "20220202'
                                                posting_date = ls_header-posting_date "'20220202'
                                                item = VALUE #( FOR ls_item IN gt_invoice_i
                                                                (
                                                                   reference_document_item = ls_item-reference_document_item "'1'
                                                                   glaccount-content = ls_item-glaccount " '10010000'
                                                                   amount_in_transaction_currency-content = ls_item-amount_in_transaction " '100.00'
                                                                   amount_in_transaction_currency-currency_code = ls_item-amount_t_currency_code "'EUR'
                                                                   debit_credit_code = ls_item-debit_credit_code " 'H' )
                                                               )
                                                              ) "item[]
                                                      )"journal_entry
                                                  )"[ 1 ]
                                             )"3-journal_entry_create_request[]
                                   )"2-journal_entry_bulk_create_requ
                            )."1-zjournal_entry_bulk_create_req

        proxy->journal_entry_create_request_c(
          EXPORTING
            input = request
          IMPORTING
            output = DATA(response)
        ).

        gt_errors = VALUE #( FOR lt_res IN response-journal_entry_bulk_create_conf-journal_entry_create_confirmat
                            FOR ls_msg IN lt_res-log-item
                            (
                                ls_msg-note
                            ) ).
        e_msg-message = gt_errors[ 1 ].
        e_msg-inv_no = substring_after( val = e_msg-message sub = 'BKPFF 0'  len = 9 ).

        " handle response
      CATCH cx_soap_destination_error INTO DATA(soap_destination_error).
        DATA(error_message) = soap_destination_error->get_text(  ).
        e_msg-message = error_message.
      CATCH cx_ai_system_fault INTO DATA(ai_system_fault).
        error_message = |code: { ai_system_fault->code  } codetext: { ai_system_fault->errortext }|.
        e_msg-message = error_message.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_yi_invoice_i DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE yi_invoice_i.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE yi_invoice_i.

    METHODS read FOR READ
      IMPORTING keys FOR READ yi_invoice_i RESULT result.

    METHODS rba_invoice_h FOR READ
      IMPORTING keys_rba FOR READ yi_invoice_i\_invoice_h FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_yi_invoice_i IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_invoice_h.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_yi_invoice_log DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE yi_invoice_log.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE yi_invoice_log.

    METHODS read FOR READ
      IMPORTING keys FOR READ yi_invoice_log RESULT result.

    METHODS rba_invoice_h FOR READ
      IMPORTING keys_rba FOR READ yi_invoice_log\_invoice_h FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_yi_invoice_log IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_invoice_h.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_yi_invoice_h DEFINITION INHERITING FROM cl_abap_behavior_saver_failed.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_yi_invoice_h IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
* To SAVE Data "Call RFC/ FM/ BAPI

** 1. Without Saving data in DB Response is not getting

* DELETE old un-successful invoices from database.
    DELETE FROM yinvoice_h WHERE invoice_number = '0000000'.
    DELETE FROM yinvoice_i WHERE invoice_number = '0000000'.
*    DELETE FROM yinvoice_log WHERE invoice_number = '0000000'.

** Save Invoice Header Data
    IF NOT lhc_yi_invoice_h=>gt_invoice_h IS INITIAL.
      MODIFY yinvoice_h FROM TABLE @lhc_yi_invoice_h=>gt_invoice_h.
    ENDIF.

** Save Invoice Item Data
    IF lhc_yi_invoice_h=>gt_invoice_i IS NOT INITIAL.
      MODIFY yinvoice_i FROM TABLE @lhc_yi_invoice_h=>gt_invoice_i.
    ENDIF.

** Save Invoice Log Data
    IF lhc_yi_invoice_h=>gt_invoice_log IS NOT INITIAL.
      MODIFY yinvoice_log FROM TABLE @lhc_yi_invoice_h=>gt_invoice_log.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
