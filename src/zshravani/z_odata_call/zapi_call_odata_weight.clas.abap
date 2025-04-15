CLASS zapi_call_odata_weight DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: t_business_data TYPE TABLE OF z_weight_odata=>tys_read.
    DATA:   lt_business_data TYPE TABLE OF z_weight_odata=>tys_read.
    CLASS-DATA:
      gv_comm_scenario TYPE if_com_management=>ty_cscn_id VALUE 'YY1_CALL_ODATA_CC1',
      gv_service_id    TYPE if_com_management=>ty_cscn_outb_srv_id VALUE 'YY1_CALLHTTPODATA_REST'.

*      gv_comm_scenario TYPE string VALUE 'YY1_CALL_ODATA_CC1',
*      gv_service_id    TYPE string VALUE 'YY1_CALLHTTPODATA_REST'.
    METHODS get_weight
      IMPORTING
        top              TYPE i OPTIONAL
        skip             TYPE i OPTIONAL
      EXPORTING
        et_business_data TYPE t_business_data.

    INTERFACES: if_oo_adt_classrun,
                if_rap_query_provider.
*The signature of the method `IF_RAP_QUERY_PROVIDER~SELECT` contains the import parameter `io_request`.
*This parameter represents the OData query options that are delegated from the UI and used as input for the SELECT method.
*Whenever the OData client requests data, the query implementation class must return the data that matches the request, or throw an exception if the request cannot be fulfilled.
*You will get a warning: “Implementation missing for method IF_RAP_QUERY_PROVIDER~SELECT.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZAPI_CALL_ODATA_WEIGHT IMPLEMENTATION.


  METHOD get_weight.
    " Variables for http_client and client_proxy
    DATA:

      lo_http_client  TYPE REF TO if_web_http_client,
      lo_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request      TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response     TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA:
      lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node,
      lt_range_weight     TYPE RANGE OF z_weight_odata=>tys_read-weight.
* lt_range_ TYPE RANGE OF .


** Link: https://help.sap.com/docs/sap-btp-abap-environment/abap-environment/http-communication-via-communication-arrangements
    DATA: lr_cscn TYPE if_com_scenario_factory=>ty_query-cscn_id_range.

    " find CA by scenario
    lr_cscn = VALUE #( ( sign = 'I' option = 'EQ' low = gv_comm_scenario ) ). " 'YY1_CALL_ODATA_CC1' ) ).

    DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).

    lo_factory->query_ca(
      EXPORTING
        is_query           = VALUE #( cscn_id_range = lr_cscn )
      IMPORTING
        et_com_arrangement = DATA(lt_ca) ).

    IF lt_ca IS INITIAL.
      EXIT.
    ENDIF.

    " take the first one
    READ TABLE lt_ca INTO DATA(lo_ca) INDEX 1.

*" 1. get destination based to Communication Arrangement
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario  = gv_comm_scenario "'YY1_CALL_ODATA_CC1'
            service_id     = gv_service_id   "'YY1_CALLHTTPODATA_REST'
            comm_system_id = lo_ca->get_comm_system_id( ) ).

*        out->write( |Comm_scenario  = 'YY1_CALL_ODATA_CC1' | && cl_abap_char_utilities=>newline && | |).
*        out->write( |Service_id     = 'YY1_CALLHTTPODATA_REST'| ).
*        out->write( 'Communication System : ' ).
*        out->write( lo_ca->get_comm_system_id( ) ).

*"     execute the request
*        DATA(lo_request) = lo_http_client->get_http_request( ).
*        DATA(lo_response) = lo_http_client->execute( if_web_http_client=>get ).

        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

* "2. create client PROXY
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
         EXPORTING
           is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                              proxy_model_id      = 'Z_WEIGHT_ODATA'
                                               proxy_model_version = '0001' )
          io_http_client             = lo_http_client
          iv_relative_service_root   = '/sap/opu/odata/SAP/ZWEIGHT_READ_SRV' ).

**     http://idevapp.iclean.in:8010/sap/opu/odata/SAP/ZWEIGHT_READ_SRV/ReadSet

        ASSERT lo_http_client IS BOUND.


*" 3. Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'READ_SET' )->create_request_for_read( ).
        lo_request->set_top( top )->set_skip( skip ).
        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).

        lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'WEIGHT'
                                                                it_range             = lt_range_weight ).
*        lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = ''
*                                                                it_range             = lt_range_ ).

        lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
        lo_request->set_filter( lo_filter_node_root ).


*" 4. Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
*        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).
        lo_response->get_business_data( IMPORTING et_business_data = et_business_data ).
*        out->write(
*          EXPORTING
*            data   = lt_business_data
*        ).

*->> Handle Exception

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " It contains details about the problems of your HTTP (s) connection

        DATA(lv_http_status_code) = lx_remote->http_status_code.
        DATA(lv_http_status_message) = lx_remote->http_status_message.
        DATA(lv_error_body) = lx_remote->http_error_body.
        DATA(ls_odata_error) = lx_remote->s_odata_error.
*        out->write( lv_http_status_message ).

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        DATA(lv_client_error_text) = lx_gateway->get_text( ).
*        out->write( lv_client_error_text ).
        ...
      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
*        out->write( lx_web_http_client_error->get_text( ) ).
        RAISE SHORTDUMP lx_web_http_client_error.

      CATCH cx_http_dest_provider_error  INTO DATA(lx_error).
*        out->write( lx_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.  "Direct RUN Class - F9
    TRY.
        CALL METHOD get_weight
*      EXPORTING
*        top              =
*        skip             =
          IMPORTING
            et_business_data = lt_business_data.
        out->write( lt_business_data ).
      CATCH cx_root INTO DATA(exception).
        out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.   "Using RAP CDS- Custom Entity
* Read Input TOP & SKIP
    DATA(top)     = io_request->get_paging( )->get_page_size( ).
    DATA(skip)    = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)    = io_request->get_sort_elements( ).

    TRY.
        CALL METHOD get_weight
          EXPORTING
            top              = CONV i( top )
            skip             = CONV i( skip )
          IMPORTING
            et_business_data = lt_business_data.

* Send Data back to UI
        io_response->set_total_number_of_records( lines( lt_business_data ) ).
        io_response->set_data( lt_business_data ).

      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
