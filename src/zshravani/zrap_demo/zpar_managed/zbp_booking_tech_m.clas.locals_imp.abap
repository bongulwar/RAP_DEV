CLASS lhc_zi_booking_tech_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE zi_booking_tech_m\_Bookingsuppl.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_booking_tech_m RESULT result.

ENDCLASS.

CLASS lhc_zi_booking_tech_m IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.
*importing   entities    type table for create zi_booking_tech_m\_bookingsuppl
*changing    mapped      type response for mapped early zi_travel_tech_m
*            failed      type response for failed early zi_travel_tech_m
*            reported    type response for reported early zi_travel_tech_m

    DATA: lv_max_supp TYPE  /dmo/booking_supplement_id.

    READ ENTITIES OF zi_travel_tech_m IN LOCAL MODE
    ENTITY zi_booking_tech_m BY \_BookingSuppl
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_link).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>)
                                   GROUP BY <ls_entity>-%tky.

      lv_max_supp = REDUCE #( INIT lv_max = CONV /dmo/booking_supplement_id( '0' )
                              FOR ls_link IN lt_link USING KEY entity
                                          WHERE ( source-TravelId = <ls_entity>-TravelId  AND
                                                  source-BookingId = <ls_entity>-BookingId )
                              NEXT lv_max = COND /dmo/booking_supplement_id( WHEN lv_max < ls_link-target-BookingSupplementId
                                                                             THEN ls_link-target-BookingSupplementId
                                                                             ELSE lv_max       )  ).
*Update MAx is used in runtime Data

      lv_max_supp = REDUCE #( INIT lv_max = lv_max_supp
                              FOR ls_entity IN entities USING KEY entity
                                  WHERE ( TravelId = <ls_entity>-TravelId AND
                                          BookingId = <ls_entity>-BookingId )
                                  FOR ls_entity_supp IN ls_entity-%target

                             NEXT lv_max = COND  /dmo/booking_supplement_id( WHEN lv_max < ls_entity_supp-BookingSupplementId
                                                            THEN ls_entity_supp-BookingSupplementId
                                                            ELSE lv_max ) ).

* Set Booking Supplement ID and Return to UI to display on screen
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ent>) USING KEY entity WHERE TravelId = <ls_entity>-TravelId
                                                                           AND BookingId = <ls_entity>-BookingId.
        LOOP AT <ls_ent>-%target ASSIGNING FIELD-SYMBOL(<ls_supplement>).
          APPEND CORRESPONDING #( <ls_supplement> ) TO mapped-zi_booksuppl_teck_m ASSIGNING FIELD-SYMBOL(<ls_mapp_supplement>).
          IF <ls_mapp_supplement>-BookingSupplementId IS INITIAL.
            <ls_mapp_supplement>-BookingSupplementId = lv_max_supp.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_travel_tech_m IN LOCAL MODE
    ENTITY zi_travel_tech_m BY \_Booking
    FIELDS ( TravelId BookingId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_bookig).

    result = VALUE #( FOR ls_booking IN lt_bookig (
                          %tky = ls_booking-%tky
                          %features-%assoc-_bookingsuppl = COND #( WHEN ls_booking-BookingDate = 'X'        "CBA allowed
                                                                  THEN if_abap_behv=>fc-o-disabled
                                                                  ELSE if_abap_behv=>fc-o-disabled )
                                                  ) ).
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
