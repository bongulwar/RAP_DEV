CLASS lhc_ZI_TRAVEL_TECH_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_tech_m RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_travel_tech_m RESULT result.

    METHODS accetpttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_tech_m~accetpttravel RESULT result.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_tech_m~rejecttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_tech_m~copytravel.
    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_tech_m~validatecustomer.

    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_tech_m\_booking.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_tech_m.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_TECH_M IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*           IGNORE_BUFFER     =
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )
*           SUBOBJECT         =
*           TOYEAR            =
          IMPORTING
            number            = DATA(LV_latest_NO)
            returncode        = DATA(lv_code)
            returned_quantity = DATA(lv_Qty)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).

        LOOP AT lt_entities INTO DATA(ls_entity).

          failed-zi_travel_tech_m = VALUE #( ( %cid = ls_entity-%cid
                                               %key = ls_entity-%key
                                             ) ).

          reported-zi_travel_tech_m = VALUE #( ( %cid = ls_entity-%cid
                                                 %key = ls_entity-%key
                                                 %msg =  lo_error
                                               ) ).
        ENDLOOP.
        EXIT.
    ENDTRY.

* Data Declarations
    DATA: lt_travel_tech_m TYPE TABLE FOR MAPPED EARLY zi_travel_tech_m,
          ls_travel_tech_m LIKE LINE OF lt_travel_tech_m.

* Get Current Number in DB
    DATA(lv_curr_no) =   lv_latest_no - lv_qty.

    ASSERT lv_qty    = lines( lt_entities ). "Check
    LOOP AT lt_entities INTO ls_entity.

      lv_curr_no = lv_curr_no + 1.

      ls_travel_tech_m = VALUE #( %cid = ls_entity-%cid
                                  travelid = lv_curr_no
                                 ).
      APPEND ls_travel_tech_m TO mapped-zi_travel_tech_m.
    ENDLOOP.


  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    DATA: lv_max_booking  TYPE /dmo/booking_id.

    READ ENTITIES OF zi_travel_tech_m IN LOCAL MODE
    ENTITY zi_travel_tech_m BY \_Booking
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_link).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>)
                                            GROUP BY <ls_entity>-%tky.

* Checked MAX number from DB records
      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                         FOR ls_link IN lt_link USING KEY entity
                                     WHERE ( source-TravelId =  <ls_entity>-TravelId )
                         NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                THEN ls_link-target-BookingId
                                                                ELSE lv_max ) ).
*Update MAX number at run-time from ENTITY - (Used in Draft scenarios)
      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                              FOR ls_entity IN entities USING KEY entity
                                  WHERE ( TravelId = <ls_entity>-TravelId )
                                 FOR ls_booking IN ls_entity-%target
                                  NEXT lv_max =   COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId
                                                                          THEN ls_booking-BookingId
                                                                          ELSE lv_max ) ).


      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ent>) USING KEY entity WHERE TravelId = <ls_entity>-TravelId.
        LOOP AT <ls_ent>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #( <ls_booking> ) TO mapped-zi_booking_tech_m ASSIGNING FIELD-SYMBOL(<ls_map_booking>).
          IF <ls_booking>-BookingId IS INITIAL.
            lv_max_booking += 10.
            <ls_map_booking>-BookingId = lv_max_booking.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD copyTravel.
    DATA: lt_travel_n      TYPE TABLE FOR CREATE zi_travel_tech_m,
          lt_booking_n     TYPE TABLE FOR CREATE zi_travel_tech_m\_Booking,
          lt_bookingSupp_n TYPE TABLE FOR CREATE zi_booking_tech_m\_BookingSuppl.



    DATA(ls_key_without_cid) = VALUE #( keys[ %cid = ' ' ] OPTIONAL ).
* IF %CID is found empty then Dump, Else Create New copy Travel.
    ASSERT ls_key_without_cid IS INITIAL.

**Step:1 Read Selected Row Data from db.

*  ---------------------------------
    READ ENTITIES OF zi_travel_tech_m IN LOCAL MODE
*1. Travel Data
        ENTITY zi_travel_tech_m ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel_r)
*2. Booking Data
        ENTITY zi_travel_tech_m BY \_Booking ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_bookig_r)

        FAILED DATA(lt_failed).
*  ---------------------------------
*3.Booking->Supplement
    READ ENTITIES OF zi_travel_tech_m IN LOCAL MODE
        ENTITY zi_booking_tech_m BY \_BookingSuppl ALL FIELDS WITH CORRESPONDING #( lt_bookig_r )
        RESULT DATA(lt_BookSppl_r).


*Step:2 - Prepare ITAB for Insert Data to DB.

    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).

*      APPEND INITIAL LINE TO lt_travel_n ASSIGNING FIELD-SYMBOL(<ls_travel_n>).
*      <ls_travel_n>-%cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid.
*      <ls_travel_n>-%data = CORRESPONDING #( <ls_travel_r>-%data EXCEPT TravelId ).

      APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_travel_r>-%data EXCEPT travelId ) )
      TO lt_travel_n ASSIGNING FIELD-SYMBOL(<ls_travel_n>).

*Modify Travel Data
      <ls_travel_n>-BeginDate = cl_abap_context_info=>get_system_date( ).
      <ls_travel_n>-EndDate = cl_abap_context_info=>get_system_date( ).
      <ls_travel_n>-OverallStatus = 'O'.
*Assign Travel to Booking[]
      APPEND VALUE #( %cid_ref  = <ls_travel_n>-%cid ) TO lt_booking_n ASSIGNING FIELD-SYMBOL(<lt_booking_n>).

      LOOP AT lt_bookig_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>) USING KEY entity
                                WHERE TravelId = <ls_travel_r>-TravelId.

        APPEND VALUE #( %cid =  <ls_travel_n>-%cid && <ls_booking_r>-BookingId
                        %data = CORRESPONDING #( <ls_booking_r>-%data EXCEPT travelid )
                      ) TO <lt_booking_n>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).
        <ls_booking_n>-BookingStatus = 'N'.

*Assign Booking CID into Supplement %cid_ref
        APPEND VALUE #( %cid_ref =  <ls_booking_n>-%cid ) TO lt_bookingsupp_n ASSIGNING FIELD-SYMBOL(<lt_bookingSupp_n>).

*Prepare Supplement[]
        LOOP AT lt_booksppl_r ASSIGNING FIELD-SYMBOL(<ls_bookSupp_r>) USING KEY entity
                    WHERE TravelId = <ls_travel_r>-TravelId
                      AND BookingId = <ls_booking_r>-BookingId.

          APPEND VALUE #(  %cid = <ls_travel_n>-%cid && <ls_booking_r>-BookingId && <ls_bookSupp_r>-BookingSupplementId
                           %data = CORRESPONDING #( <ls_bookSupp_r>-%data EXCEPT travelid ) "BookingId )
                        ) TO  <lt_bookingSupp_n>-%target.
        ENDLOOP.
*    APPEND VALUE #(  ) to

      ENDLOOP. "Booking []

    ENDLOOP. "Travel []

*// Insert/Update records in DB

    MODIFY ENTITIES OF zi_travel_tech_m IN LOCAL MODE
    ENTITY zi_travel_tech_m
    CREATE FIELDS (
                    CustomerId
                    AgencyId
                    BeginDate
                    EndDate
                    BookingFee
                    TotalPrice
                    CurrencyCode
                    Description
                    OverallStatus  )
    WITH lt_travel_n

    ENTITY zi_travel_tech_m
    CREATE BY \_Booking
    FIELDS (    BookingId
                BookingDate
                CustomerId
                CarrierId
                ConnectionId
                FlightDate
                FlightPrice
                CurrencyCode
                BookingStatus )
    WITH lt_booking_n

    ENTITY zi_booking_tech_m
    CREATE BY \_BookingSuppl
    FIELDS (
            BookingId
            BookingSupplementId
            SupplementId
            Price
            CurrencyCode      )
    WITH lt_bookingsupp_n

    FAILED DATA(lt_failed_n)
    MAPPED DATA(lt_mapped_n)
    REPORTED DATA(lt_reported_n).

* Return Data to UI to display on screen
    mapped-zi_travel_tech_m = lt_mapped_n-zi_travel_tech_m.
  ENDMETHOD.

  METHOD accetptTravel.

*Update Status = 'A'
    MODIFY ENTITIES OF zi_travel_tech_m IN LOCAL MODE
    ENTITY zi_travel_tech_m
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_key IN keys ( %tky = ls_key-%tky            "Use %tky bcz it will cover Draft/All keys from DB table
                                       OverallStatus = 'A' ) ).

*Read All fields and send to UI for display

    READ ENTITIES OF zi_travel_tech_m IN LOCAL MODE
    ENTITY zi_travel_tech_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result  =  VALUE #( FOR ls_result IN lt_result ( %key = ls_result-%key
                                                     %param = ls_result    ) ).
  ENDMETHOD.

  METHOD rejectTravel.
* Update Status = 'X'
    MODIFY ENTITIES OF zi_travel_tech_m IN LOCAL MODE
    ENTITY zi_travel_tech_m
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_key IN keys ( %tky = ls_key-%tky            "Use %tky bcz it will cover Draft/All keys from DB table
                                       %data-OverallStatus = 'X' ) ).

*Read All fields and send to UI for display

    READ ENTITIES OF zi_travel_tech_m IN LOCAL MODE
    ENTITY zi_travel_tech_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).


    result  =  VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                                     %param = ls_result    ) ).

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_travel_tech_m IN LOCAL MODE
    ENTITY zi_travel_tech_m
    FIELDS ( TravelId OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    result = VALUE #( FOR ls_result IN   lt_result
                        ( %tky = ls_result-%tky

                         %features-%action-accetpttravel = COND #( WHEN ls_result-OverallStatus = 'A'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )
                         %features-%action-rejectTravel  = COND #( WHEN ls_result-OverallStatus = 'X'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )

                         %features-%assoc-_Booking = COND #( WHEN ls_result-OverallStatus = 'X'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )
                         ) ).

  ENDMETHOD.

  METHOD validateCustomer." On SAVE event

    DATA: lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    READ ENTITIES OF zi_travel_tech_m IN LOCAL MODE
     ENTITY zi_travel_tech_m
     FIELDS ( CustomerId  )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_travel).


    lt_cust = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).
    DELETE lt_cust WHERE customer_id IS INITIAL.
    IF lt_cust IS NOT INITIAL.
      SELECT FROM /dmo/customer
      FIELDS customer_id
      FOR ALL ENTRIES IN @lt_cust
      WHERE customer_id = @lt_cust-customer_id
      INTO TABLE @DATA(lt_cust_db).
    ENDIF.

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_trvel>).
*If Customer Id is empty/ Not present in DB... then error
      IF <ls_trvel>-CustomerId IS INITIAL
          OR NOT line_exists( lt_cust_db[ customer_id = <ls_trvel>-CustomerId ] ).

*        failed-zi_travel_tech_m = VALUE #( (  %tky = <ls_trvel>-%tky ) ).
        failed-zi_travel_tech_m = VALUE #( (  %tky = <ls_trvel>-%tky ) ).
        reported-zi_travel_tech_m = VALUE #( ( %tky = <ls_trvel>-%tky
                                               %msg =
                                           ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
