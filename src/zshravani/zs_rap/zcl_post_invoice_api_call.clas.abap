CLASS zcl_post_invoice_api_call DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_POST_INVOICE_API_CALL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    TRY.                                                "Sample URL
        DATA: lv_URL        TYPE string VALUE 'https://my406xxx-api.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi',
              lv_out_string TYPE string.

        DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = lv_URL ).
        destination->set_basic_authentication(
                                              i_user     = 'AFI'
                                              i_password = 'Qwertyuiopasdfghjkl1!'
                                             ).

        DATA(proxy) = NEW zco_journal_entry_create_reque( destination = destination ).

       " fill request
        DATA(request) = VALUE zjournal_entry_bulk_create_req(
       journal_entry_bulk_create_requ = VALUE #( " message_header = VALUE #( creation_date_time =  '2018-06-05T12:00:00.1234567Z' )
       journal_entry_create_request = VALUE #(
                            ( "message_header = VALUE #( creation_date_time = '2018-06-05T12:00:00.1234567Z' )
                              journal_entry = VALUE #(
                                                original_reference_document_ty  = 'BKPFF'
                                                business_transaction_type = 'RFBU'
                                                accounting_document_type = 'SA'
                                                company_code = '1710'
                                                created_by_user = 'CB9980000010'
                                                document_date = '20220202'
                                                posting_date = '20220202'
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
        out->write( lt_mes ).
        " handle response
      CATCH cx_soap_destination_error INTO DATA(soap_destination_error).
        DATA(error_message) = soap_destination_error->get_text(  ).
        out->write( error_message ).
      CATCH cx_ai_system_fault INTO DATA(ai_system_fault).
        error_message = | code: { ai_system_fault->code  } codetext: { ai_system_fault->codecontext  }  |.
        out->write( error_message ).
*      CATCH zco_cx_fault_msg_typ INTO DATA(soap_exception).
*        error_message = soap_exception->error_text.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
