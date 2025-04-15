CLASS ycl_call_post_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider.

    TYPES: BEGIN OF e_msg,
             message TYPE string,
             inv_no  TYPE zapi_inv_h-InvoiceNumber,
           END OF e_msg.

    METHODS: Post_Invoice    "HTTP
      IMPORTING i_data TYPE zapi_inv_h"any
      EXPORTING e_msg  TYPE e_msg,"string.

      Post_Invoice_Check   "Using Comm.Arr.
        IMPORTING i_data TYPE zapi_inv_h"any
        EXPORTING e_msg  TYPE e_msg,"string,

      Post_Invoice_Save    "Using Comm.Arr.
        IMPORTING i_data_h TYPE zapi_inv_h"any
        EXPORTING e_msg    TYPE e_msg."string        .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: gv_message  TYPE e_msg,
                gt_out_data TYPE STANDARD TABLE OF zi_cust_invoice_h..
ENDCLASS.



CLASS YCL_CALL_POST_API IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA ls_inv_h TYPE zapi_inv_h.
*    CALL METHOD post_invoice_check "Call using Communication Arrangement
    CALL METHOD post_invoice      "Call Using HTTP_URL -> PROXY call
      EXPORTING
        i_data = ls_inv_h
      IMPORTING
        e_msg  = gv_message.
    out->write( gv_message-message ).
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA business_data TYPE TABLE OF zi_cust_invoice_h.
    DATA(top)     = io_request->get_paging( )->get_page_size( ).
    DATA(skip)    = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)    = io_request->get_sort_elements( ).

    TRY.
        DATA(filter_condition) = io_request->get_filter( )->get_as_ranges( ).

*       CALL METHOD post_invoice
*         IMPORTING
*           e_msg = gv_message.
        gv_message-message  = 'Hello__Root Cust'.
        IF gv_message IS NOT INITIAL.
          io_response->set_total_number_of_records( 1 ).
          gt_out_data = VALUE #( ( InvoiceNumber = substring_after( val = gv_message-message sub = 'BKPFF 0'  len = 9 )
                                   message = gv_message-message ) ).
          io_response->set_data( gt_out_data ).
        ENDIF.

      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception(
                            exception )->if_message~get_longtext( ).
    ENDTRY.
  ENDMETHOD.


  METHOD post_invoice.
    TRY.                                     "Sample URL
        DATA: lv_URL        TYPE string VALUE 'https://my403888-api.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi',
              lv_out_string TYPE string.

        DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = lv_URL ).
        destination->set_basic_authentication(
                                              i_user     = 'AFI'
                                              i_password = 'Qwertyuiopasdfghjkl1!'
                                             ).

        DATA(proxy) = NEW zco_journal_entry_create_reque( destination = destination ).


        " fill request
        DATA(request) = VALUE zjournal_entry_bulk_create_req(
       journal_entry_bulk_create_requ = VALUE #(
                                message_header = VALUE #(
                                                 creation_date_time = 20240201110011 "'2018-06-05T12:00:00.1234567Z'
                                                 test_data_indicator = 'X' ) "Pass 'X'-Document check - no errors: BKPFF $ 0M4OF7L
      journal_entry_create_request = VALUE #(
                            ( "message_header = VALUE #( creation_date_time = 20240201110011 "'2018-06-05T12:00:00.1234567Z' test_data_indicator = 'X' )
                               journal_entry = VALUE #(
                                                original_reference_document_ty  = 'BKPFF'
                                                business_transaction_type = 'RFBU'
                                                accounting_document_type = 'SA'
                                                company_code =   '1710'
*                                                company_code = i_data-CompanyCode
                                                created_by_user = 'CB9980000010'
*                                                created_by_user = i_data-CreatedByUser "'CB9980000010'
                                                document_date = '20220202'
*                                                document_date = i_data-DocumentDate "20220202'
                                                posting_date = '20220202'
*                                                posting_date = i_data-PostingDate "'20220202'
                                                item = VALUE #(
                                                                 ( reference_document_item = '1' glaccount-content = '10010000' amount_in_transaction_currency-content = '100.00'
                                                                   amount_in_transaction_currency-currency_code = 'EUR' debit_credit_code = 'H' )
                                                                 ( reference_document_item = '2' glaccount-content = '10010000' amount_in_transaction_currency-content = '-100.00'
                                                                   amount_in_transaction_currency-currency_code = 'EUR' debit_credit_code = 'S' )
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

        DATA: lt_mes TYPE STANDARD TABLE OF char256.

        lt_mes = VALUE #( FOR ls_msg IN response-journal_entry_bulk_create_conf-journal_entry_create_confirmat[ 1 ]-log-item ( ls_msg-note ) ).
        e_msg-message = lt_mes[ 1 ].
        e_msg-inv_no = substring_after( val = e_msg-message sub = 'BKPFF 0'  len = 9 ).

        " handle response
      CATCH cx_soap_destination_error INTO DATA(soap_destination_error).
        DATA(error_message) = soap_destination_error->get_text(  ).
        e_msg-message = error_message.
      CATCH cx_ai_system_fault INTO DATA(ai_system_fault).
        error_message = |code: { ai_system_fault->code  } codetext: { ai_system_fault->errortext }|.
        e_msg-message = error_message.
*      CATCH zco_cx_fault_msg_typ INTO DATA(soap_exception).
*        error_message = soap_exception->error_text.
    ENDTRY.
  ENDMETHOD.


  METHOD Post_Invoice_Check.  "Pass 'X'-Document check - no errors: BKPFF $ 0M4OF7L
    TRY.
        DATA(destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
                                     comm_scenario  = 'Z_OUTBOUND_ODATA_CSCEN_001'
                                     service_id     = 'Z_OUTBOUND_ODATA_001_SPRX'  "'Z_OUTBOUND_SOAP_REST'
                                     comm_system_id = 'Z001_TO_PRV_CSYS'
                            ).

        DATA(proxy) = NEW zco_journal_entry_create_reque( destination = destination ).
        " fill request
        DATA(request) = VALUE zjournal_entry_bulk_create_req(
        journal_entry_bulk_create_requ = VALUE #(
                message_header = VALUE #(
                             creation_date_time = 20240201110011 "'2018-06-05T12:00:00.1234567Z'
                             test_data_indicator = 'X' )
                journal_entry_create_request = VALUE #(
                           ( "message_header = VALUE #( creation_date_time = '2018-06-05T12:00:00.1234567Z' test_data_indicator = '1' )
                              journal_entry = VALUE #(
                                                original_reference_document_ty  = 'BKPFF'
                                                business_transaction_type = 'RFBU'
                                                accounting_document_type = 'SA'
                                                company_code =   '1710'
*                                                company_code = i_data-CompanyCode
                                                created_by_user = 'CB9980000010'
*                                                created_by_user = i_data-CreatedByUser "'CB9980000010'
                                                document_date = '20220202'
*                                                document_date = i_data-DocumentDate "20220202'
                                                posting_date = '20220202'
*                                                posting_date = i_data-PostingDate "'20220202'
                                                item = VALUE #(
                                                                 ( reference_document_item = '1' glaccount-content = '10010000' amount_in_transaction_currency-content = '100.00'
                                                                   amount_in_transaction_currency-currency_code = 'EUR' debit_credit_code = 'H' )
                                                                 ( reference_document_item = '2' glaccount-content = '10010000' amount_in_transaction_currency-content = '-100.00'
                                                                   amount_in_transaction_currency-currency_code = 'EUR' debit_credit_code = 'S' )
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

        DATA: lt_mes TYPE STANDARD TABLE OF char256.

        lt_mes = VALUE #( FOR ls_msg IN response-journal_entry_bulk_create_conf-journal_entry_create_confirmat[ 1 ]-log-item ( ls_msg-note ) ).
        e_msg-message = lt_mes[ 1 ].
*        e_msg-inv_no = substring_after( val = e_msg-message sub = 'BKPFF 0'  len = 9 ).
        e_msg-inv_no = response-journal_entry_bulk_create_conf-journal_entry_create_confirmat[ 1 ]-journal_entry_create_confirmat-accounting_document.

        " handle response
      CATCH cx_soap_destination_error INTO DATA(soap_destination_error).
        DATA(error_message) = soap_destination_error->get_text(  ).
        e_msg-message = error_message.
      CATCH cx_ai_system_fault INTO DATA(ai_system_fault).
        error_message = | code: { ai_system_fault->code  } codetext: { ai_system_fault->errortext  }  |.
        e_msg-message = error_message.
*      CATCH zco_cx_fault_msg_typ INTO DATA(soap_exception).
*        error_message = soap_exception->error_text.
    ENDTRY.
  ENDMETHOD.


  METHOD Post_Invoice_Save.
    TRY.

        DATA(destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
                                     comm_scenario  = 'Z_OUTBOUND_ODATA_CSCEN_001'
                                     service_id     = 'Z_OUTBOUND_ODATA_001_SPRX'  "'Z_OUTBOUND_SOAP_REST'
                                     comm_system_id = 'Z001_TO_PRV_CSYS'
                            ).

        DATA(proxy) = NEW zco_journal_entry_create_reque( destination = destination ).
        " fill request
        DATA(request) = VALUE zjournal_entry_bulk_create_req(
       journal_entry_bulk_create_requ = VALUE #( " message_header = VALUE #(  creation_date_time = 20240201110011 test_data_indicator = ''  )
       journal_entry_create_request = VALUE #(
                            ( "message_header = VALUE #( creation_date_time = '20240201T110011' test_data_indicator = '' )
                              journal_entry = VALUE #(
                                                original_reference_document_ty  = 'BKPFF'
                                                business_transaction_type = 'RFBU'
                                                accounting_document_type = 'SA'
                                                company_code =   '1710'
*                                                company_code = i_data-CompanyCode
                                                created_by_user = 'CB9980000010'
*                                                created_by_user = i_data-CreatedByUser "'CB9980000010'
                                                document_date = '20220202'
*                                                document_date = i_data-DocumentDate "20220202'
                                                posting_date = '20220202'
*                                                posting_date = i_data-PostingDate "'20220202'
                                                item = VALUE #(
                                                                 ( reference_document_item = '1' glaccount-content = '10010000' amount_in_transaction_currency-content = '100.00'
                                                                   amount_in_transaction_currency-currency_code = 'EUR' debit_credit_code = 'H' )
                                                                 ( reference_document_item = '2' glaccount-content = '10010000' amount_in_transaction_currency-content = '-100.00'
                                                                   amount_in_transaction_currency-currency_code = 'EUR' debit_credit_code = 'S' )
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

        DATA: lt_mes TYPE STANDARD TABLE OF char256.

        lt_mes = VALUE #( FOR ls_msg IN response-journal_entry_bulk_create_conf-journal_entry_create_confirmat[ 1 ]-log-item ( ls_msg-note ) ).
        e_msg-message = lt_mes[ 1 ].
        e_msg-inv_no = response-journal_entry_bulk_create_conf-journal_entry_create_confirmat[ 1 ]-journal_entry_create_confirmat-accounting_document.

        " handle response
      CATCH cx_soap_destination_error INTO DATA(soap_destination_error).
        DATA(error_message) = soap_destination_error->get_text(  ).
        e_msg-message = error_message.
      CATCH cx_ai_system_fault INTO DATA(ai_system_fault).
        error_message = | code: { ai_system_fault->code  } codetext: { ai_system_fault->errortext  }  |.
        e_msg-message = error_message.
*      CATCH zco_cx_fault_msg_typ INTO DATA(soap_exception).
*        error_message = soap_exception->error_text.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
