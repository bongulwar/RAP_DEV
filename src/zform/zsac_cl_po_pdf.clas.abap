CLASS zsac_cl_po_pdf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZSAC_CL_PO_PDF IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA: lt_tab     TYPE TABLE OF zsac_i_po_pdf,
          lv_content TYPE  xstring.

* ----------  Below Code will only work in S4Hana Private Cloud / on-premise Server -------------------------**
** Blog Link:  https://community.sap.com/t5/technology-blogs-by-members/adobe-form-with-rap-based-odata-service/ba-p/13700430

**  DATA: lo_cl_somu_form_services TYPE REF TO cl_somu_form_services,
**
**          lt_keys                  TYPE cl_somu_form_services=>ty_gt_key.
**    TRY.
**        IF io_request->is_data_requested(  ).
**          DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
**          DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
**          DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited
**                                        THEN 0 ELSE lv_page_size )  .
**
**          TRY.
**              DATA(lt_parameters) = io_request->get_parameters( ).
**
**              DATA(lv_po) =   VALUE #( lt_parameters[ parameter_name =  'P_PURCHASEORDER' ]-value OPTIONAL ).
**
**              lt_keys =  VALUE #( ( name = 'PurchaseOrder'     value = lv_po ) ).    "Root Node CDS- ZSAC_R_PO_QUERY field
**              lo_cl_somu_form_services = cl_somu_form_services=>get_instance( ).
**
**              TRY.
**                  lo_cl_somu_form_services->get_document( EXPORTING iv_form_name = 'ZZ1_PO_FORM'
**                                                                    it_key       = lt_keys
**                                                          IMPORTING ev_content   = lv_content
**                                                           ).
**
**                CATCH cx_somu_error INTO DATA(lv_formerror).
**              ENDTRY.
**
    lv_content = 'PO PDF converted String from cl_somu_form_services->get_document'.
    lt_tab = VALUE #( ( pdf = lv_content   ) ).                                  "Send PDF data back to UI-App
    io_response->set_total_number_of_records( 1 ).
    io_response->set_data( lt_tab ).
**            CATCH cx_rap_query_filter_no_range INTO DATA(lv_range).
**              DATA(lv_msg) = lv_range->get_text( ).
**          ENDTRY.
**        ENDIF.
**
**      CATCH cx_rap_query_provider.
**
**    ENDTRY.
  ENDMETHOD.
ENDCLASS.
