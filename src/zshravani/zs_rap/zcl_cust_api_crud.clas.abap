CLASS zcl_cust_api_crud DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      tt_create_invoice_h TYPE TABLE FOR CREATE zi_cust_invoice_h\\invoice_h,
      tt_mapped_early     TYPE RESPONSE FOR MAPPED EARLY zi_cust_invoice_h,
      tt_failed_early     TYPE RESPONSE FOR FAILED EARLY zi_cust_invoice_h,
      tt_reported_early   TYPE RESPONSE FOR REPORTED EARLY zi_cust_invoice_h,
      tt_reported_late    TYPE RESPONSE FOR REPORTED LATE zi_cust_invoice_h.

    TYPES:
      tt_invoice_keys   TYPE TABLE FOR READ IMPORT zi_cust_invoice_h\\invoice_h,
      tt_invoice_result TYPE TABLE FOR READ RESULT zi_cust_invoice_h\\invoice_h.

    TYPES:
        tt_invoice_update TYPE TABLE FOR UPDATE zi_cust_invoice_h\\invoice_h.

    TYPES:
      tt_cba_inv_item TYPE TABLE FOR CREATE zi_cust_invoice_h\\invoice_h\_invoice_item.

    TYPES: tt_invoice_h_delete TYPE TABLE FOR DELETE zi_cust_invoice_h\\invoice_h.
    TYPES: BEGIN OF e_msg,
             message TYPE string,
             inv_no  TYPE zapi_inv_h-invoicenumber,
           END OF e_msg.
    "Create Constructor
    CLASS-METHODS:
      get_instance RETURNING VALUE(ro_inst) TYPE REF TO zcl_cust_api_crud.

    METHODS:

      get_next_id
        RETURNING VALUE(rv_id) TYPE sysuuid_x16
        RAISING   cx_uuid_error ,

      get_next_invoice_id
        RETURNING VALUE(rv_inv_id) TYPE zinvoice_h-invoice_number,

**----- Early Numbering Method -----

      earlynumbering_create
        IMPORTING entities TYPE tt_create_invoice_h
        CHANGING  mapped   TYPE tt_mapped_early
                  failed   TYPE tt_failed_early
                  reported TYPE tt_reported_early,

      earlynumbering_cba_invoice_ite
        IMPORTING entities TYPE tt_cba_inv_item         "table for create zi_cust_invoice_h\\invoice_h\_invoice_item
        CHANGING  mapped   TYPE tt_mapped_early         "response for mapped early zi_cust_invoice_h
                  failed   TYPE tt_failed_early         "response for failed early zi_cust_invoice_h
                  reported TYPE tt_reported_early,      "response for reported early zi_cust_invoice_h  ,

**----- Crate Method -----

      create_invoice_h
        IMPORTING entities TYPE tt_create_invoice_h "table for CREATE zi_cust_invoice_h\\invoice_h
        CHANGING  mapped   TYPE tt_mapped_early     "response for mapped early zi_cust_invoice_h
                  failed   TYPE tt_failed_early     "response for failed early zi_cust_invoice_h
                  reported TYPE tt_reported_early,  "response for reported early zi_cust_invoice_h.

      cba_invoice_item
        IMPORTING entities_cba TYPE tt_cba_inv_item    "table for create zi_cust_invoice_h\\invoice_h\_invoice_item  [ derived type... ]
        CHANGING  mapped       TYPE tt_mapped_early    "response for mapped early zi_cust_invoice_h  [ derived type... ]
                  failed       TYPE tt_failed_early    "response for failed early zi_cust_invoice_h  [ derived type... ]
                  reported     TYPE tt_reported_early, "response for reported early zi_cust_invoice_h

**---- Read Method ------

      read_invoice
        IMPORTING keys     TYPE tt_invoice_keys     "table for read import zi_cust_invoice_h\\invoice_h
        CHANGING  result   TYPE tt_invoice_result   "table for read result zi_cust_invoice_h\\invoice_h
                  failed   TYPE tt_failed_early     "response for failed early zi_cust_invoice_h
                  reported TYPE tt_reported_early , "response for reported early zi_cust_invoice_h

      update_invoice_h
        IMPORTING entities TYPE tt_invoice_update "type table for update zi_cust_invoice_h\\invoice_h  [ derived type... ]
        CHANGING  mapped   TYPE tt_mapped_early" type response for mapped early zi_cust_invoice_h  [ derived type... ]
                  failed   TYPE tt_failed_early    "response for failed early zi_cust_invoice_h  [ derived type... ]
                  reported TYPE tt_reported_early, "response for reported early zi_cust_invoice_h
**---- Delete Method ----
      delete_invoice_h
        IMPORTING keys     TYPE tt_invoice_h_delete "table for delete zi_cust_invoice_h\\invoice_h
        CHANGING  mapped   TYPE tt_mapped_early "response for mapped early zi_cust_invoice_h
                  failed   TYPE tt_failed_early "response for failed early zi_cust_invoice_h
                  reported TYPE tt_reported_early, "response for reported early zi_cust_invoice_h,

      save_invoice_h
        CHANGING reported TYPE tt_reported_late," response for reported late zi_cust_invoice_h.

      post_invoice
        EXPORTING e_msg TYPE e_msg."string.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: mo_instance   TYPE REF TO zcl_cust_api_crud,
                gt_invoice_h  TYPE STANDARD TABLE OF zinvoice_h,
                gr_inv_delete TYPE RANGE OF zinvoice_h-id,
                gs_mapped     TYPE tt_mapped_early,
                gt_invoice_i  TYPE STANDARD TABLE OF  zinvoice_item,
                gv_timestamp1 TYPE timestampl.
ENDCLASS.



CLASS ZCL_CUST_API_CRUD IMPLEMENTATION.


  METHOD cba_invoice_item.
** Create By Association
*Step 1 - Collect all Information from UI
    DATA(lv_item) = 0010.
    gt_invoice_i = VALUE #(
                            FOR ls_entity_cba IN entities_cba
                                 FOR ls_item_cba IN ls_entity_cba-%target
                                LET ls_rap_items = CORRESPONDING zinvoice_item( ls_item_cba MAPPING FROM ENTITY )
                                    IN (
                                        id = ls_rap_items-id
                                        invoice_number = ls_entity_cba-invoicenumber
                                        amount_in_transaction = ls_rap_items-amount_in_transaction
                                        amount_t_currency_code = ls_rap_items-amount_t_currency_code
                                        debit_credit_code = ls_rap_items-debit_credit_code
                                        glaccount = ls_rap_items-glaccount
                                        reference_document_item = ls_rap_items-reference_document_item
                                        )
                               ).
* To SAVE Data "Call RFC/ FM/ BAPI
*    CALL METHOD post_invoice
*      IMPORTING
*        e_msg = DATA(lv_message).
*    IF lv_message IS NOT INITIAL   .
**        rv_inv_id = lv_message-inv_no.
*    ENDIF.

    LOOP AT gt_invoice_h ASSIGNING FIELD-SYMBOL(<fs_hdr>).
      IF <fs_hdr>-id IS  INITIAL.
        TRY.
            <fs_hdr>-id = get_next_id( ).
            <fs_hdr>-invoice_number = '1234567'. "lv_message-inv_no.
          CATCH cx_uuid_error. "handle exception
        ENDTRY.
      ENDIF.
    ENDLOOP.

** Mapped result Out for UI display
    mapped =  VALUE #(
        invoice_i = VALUE #(
                        FOR i = 1 WHILE i <= lines( entities_cba )
                        LET lt_items = VALUE #( entities_cba[ i ]-%target OPTIONAL )
                            IN
                                FOR j = 1 WHILE j <= lines( lt_items )
                                    LET ls_curee_item = VALUE #( lt_items[ j ] OPTIONAL )
                                        IN
                                        (
                                            %cid = ls_curee_item-%cid
                                            %key = ls_curee_item-%key
*                                            id = ls_curee_item-id
*                                            invoicenumber = entities_cba[ i ]-invoicenumber
                                        )
            ) ).

  ENDMETHOD.


  METHOD create_invoice_h.

* Read Entity from UI in table after filling all entries and press CREATE button
    "--Mapping is required for this CORRESPONDING in behavior CDS--DB in BH_Def.
    gt_invoice_h = CORRESPONDING #( entities MAPPING FROM ENTITY ).

    IF gt_invoice_h IS NOT INITIAL.

      GET TIME STAMP FIELD gv_timestamp1.
      gt_invoice_h[ 1 ]-locallastchangedat = gv_timestamp1.
      gt_invoice_h[ 1 ]-lastchangedat = gv_timestamp1.

      gt_invoice_h[ 1 ]-invoice_number = get_next_invoice_id( ).

      mapped = VALUE #(
         invoice_h  = VALUE #( FOR ls_entity IN entities
              (
                  %cid = ls_entity-%cid
*                  %is_draft = ls_entity-%is_draft "Commented Because, not required for WEB API
                  %key = ls_entity-%key
*                  id = ls_entity-id
*                  invoicenumber =  gt_invoice_h[ 1 ]-invoice_number
               ) )
           ).
    ENDIF.
  ENDMETHOD.


  METHOD delete_invoice_h.
    DATA: lt_invoice TYPE STANDARD TABLE OF zinvoice_h.
    lt_invoice = CORRESPONDING #( keys MAPPING FROM ENTITY  ).
    gr_inv_delete = VALUE #(
                       FOR ls_inv IN lt_invoice
                           ( sign = 'I'
                             option = 'EQ'
                             low = ls_inv-id
                           )
                         ).
  ENDMETHOD.


  METHOD earlynumbering_cba_invoice_ite.

    TRY.
        DATA(lv_new_item_id) = get_next_id(  ).
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.
    mapped-invoice_i = VALUE #(
                           FOR ls_entity IN entities
                              FOR ls_create_itm IN ls_entity-%target
                                (
                                        %cid = ls_create_itm-%cid
                                        %key = ls_create_itm-%key
                                       " %is_draft = ls_create_itm-%is_draft  "Not required for WEB API
                                        "No need to Assign ID as it was already there
                                )
                            ).
  ENDMETHOD.


  METHOD earlynumbering_create.
    DATA(ls_mapped) = gs_mapped.

    TRY.
        DATA(lv_new_id) = get_next_id( ).
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    "When Draft Table then we will get data in GT_Invoice_h.
    "Buffer Table Update
    "But not CREATE operation

    READ TABLE gt_invoice_h ASSIGNING FIELD-SYMBOL(<fs_invoice_h>) INDEX 1.
    IF <fs_invoice_h> IS ASSIGNED.
      <fs_invoice_h>-id = lv_new_id.
      UNASSIGN <fs_invoice_h>.
    ENDIF.

    "Send data from Back-end to Front-End while Create New entry with filled ID value
    mapped = VALUE #(
          invoice_h = VALUE #(
                        FOR ls_entity IN entities "WHERE ( Id IS INITIAL )
                          (
                            %cid = ls_entity-%cid
*                            %is_draft = ls_entity-%is_draft "Commented Because, not required for WEB API
                            id = lv_new_id
                           )
                         )
                    ).
  ENDMETHOD.


  METHOD get_instance.
    mo_instance = ro_inst = COND #( WHEN mo_instance IS BOUND
                                    THEN mo_instance
                                    ELSE NEW #(  ) ).
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
*                                                company_code =   '1710'
                                                company_code = ls_header-company_code
*                                                created_by_user = 'CB9980000010'
                                                created_by_user = ls_header-created_by_user "'CB9980000010'
*                                                document_date = '20220202'
                                                document_date = ls_header-document_date "20220202'
*                                                posting_date = '20220202'
                                                posting_date = ls_header-posting_date "'20220202'
                                                item = VALUE #(
*                                                                 ( reference_document_item = '1' glaccount-content = '10010000' amount_in_transaction_currency-content = '100.00'
*                                                                   amount_in_transaction_currency-currency_code = 'EUR' debit_credit_code = 'H' )
*                                                                 ( reference_document_item = '2' glaccount-content = '10010000' amount_in_transaction_currency-content = '-100.00'
*                                                                   amount_in_transaction_currency-currency_code = 'EUR' debit_credit_code = 'S' )
                                                              FOR ls_item IN gt_invoice_i
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


  METHOD read_invoice.
* When user Press "Edit" button -> to display record in UI in Change Mode
    SELECT * FROM zinvoice_h FOR ALL ENTRIES IN @keys
        WHERE id = @keys-id
        INTO TABLE @DATA(lt_invoices).

* Export records to UI in Change Mode
    result = CORRESPONDING #( lt_invoices MAPPING TO ENTITY ).

  ENDMETHOD.


  METHOD save_invoice_h.
* Save called from CREATE/UPDAT button Click from UI

* To SAVE Data "Call RFC/ FM/ BAPI

    IF NOT gt_invoice_h IS INITIAL.
      MODIFY zinvoice_h FROM TABLE @gt_invoice_h.
    ENDIF.
    IF gt_invoice_i IS NOT INITIAL.
      MODIFY zinvoice_item FROM TABLE @gt_invoice_i.
    ENDIF.

    IF gr_inv_delete IS NOT INITIAL.
      DELETE FROM zinvoice_h WHERE id IN @gr_inv_delete.
    ENDIF.
  ENDMETHOD.


  METHOD update_invoice_h.

    DATA: lt_invoice_h_upd   TYPE STANDARD TABLE OF zinvoice_h,
          lt_invoice_h_upd_x TYPE STANDARD TABLE OF zcs_invoice_h.

** Read data from UI and fill Local-table
    lt_invoice_h_upd   = CORRESPONDING #( entities MAPPING FROM ENTITY ).
    lt_invoice_h_upd_x = CORRESPONDING #( entities MAPPING FROM ENTITY USING CONTROL ).

* Read Record to show in UI
    IF NOT lt_invoice_h_upd    IS INITIAL.
      SELECT * FROM zinvoice_h
          FOR ALL ENTRIES IN @lt_invoice_h_upd
          WHERE id = @lt_invoice_h_upd-id
          INTO TABLE @DATA(lt_invoice_h_upd_old).
    ENDIF.

    gt_invoice_h = VALUE #(
                            FOR i = 1 WHILE i <= lines( lt_invoice_h_upd )

                            LET
                                ls_control_flag  = VALUE #( lt_invoice_h_upd_x[ i ] OPTIONAL )
                                ls_invoice_h_new = VALUE #( lt_invoice_h_upd[ i ] OPTIONAL )
                                ls_invoice_h_old = VALUE #( lt_invoice_h_upd_old[ id = ls_invoice_h_new-id ] OPTIONAL )
                           IN
                               (
                                  CORRESPONDING #( ls_invoice_h_new )
*                               id = ls_invoice_h_new-id
*                               invoice_number = COND #( WHEN ls_control_flag-invoice_number IS NOT INITIAL
*                                                             THEN ls_invoice_h_new-invoice_number
*                                                             ELSE ls_invoice_h_old-invoice_number
*                                                                 )
*                               company_code  = COND #( WHEN ls_control_flag-company_code IS NOT INITIAL
*                                                             THEN ls_invoice_h_new-company_code
*                                                             ELSE ls_invoice_h_old-company_code
*                                                                 )
*
*                               created_by_user = COND #( WHEN ls_control_flag-created_by_user IS NOT INITIAL
*                                                             THEN ls_invoice_h_new-created_by_user
*                                                             ELSE ls_invoice_h_old-created_by_user
*                                                                 )
*                               document_date = COND #( WHEN ls_control_flag-document_date IS NOT INITIAL
*                                                             THEN ls_invoice_h_new-document_date
*                                                             ELSE ls_invoice_h_old-document_date
*                                                                 )
*                               posting_date = COND #( WHEN ls_control_flag-posting_date IS NOT INITIAL
*                                                             THEN ls_invoice_h_new-posting_date
*                                                             ELSE ls_invoice_h_old-posting_date
*                                                                 )
                               )
                          ).

  ENDMETHOD.
ENDCLASS.
