CLASS zcl_eml_read_entity DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_eml_read_entity IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*    READ ENTITY zi_travel_tech_m
*        FROM VALUE #(  ( %key-travelid  = '000000012'
*                         %control-agencyid = if_abap_behv=>mk-on
*                         ) )

*2. Specify Field Names
*    READ ENTITY zi_travel_tech_m
*    FIELDS ( AgencyId  BeginDate )
**    ALL FIELDS
*    WITH VALUE #( ( %key-travelid = '0000000111' )
*                  ( %key-travelid = '0000000014' )
*                )

*3. Read Association All fields
*    READ ENTITY zi_travel_tech_m
*    BY \_Booking
*    ALL FIELDS
*    WITH VALUE #( ( %key-travelid = '0000000111' )
*                  ( %key-travelid = '0000000014' )
*                )


*4. Read Multiple Entities at a time

* ->Travel
    READ ENTITIES OF zi_travel_tech_m
    ENTITY zi_travel_tech_m
    ALL FIELDS
    WITH VALUE #( ( %key-travelid = '0000000111' )
                  ( %key-travelid = '0000000014' )
                )
    RESULT DATA(lt_result_Trv)

* ->Booking
 ENTITY zi_booking_tech_m
    ALL FIELDS
    WITH VALUE #( ( %key-travelid = '0000000111' bookingid = '0001' )
                  ( %key-travelid = '0000000014' bookingid = '0001' )
                )
    RESULT DATA(lt_result_book)

*-> Booking Supplement
* ENTITY zi_booking_tech_m BY \_BookingSuppl
 ENTITY zi_booksuppl_teck_m
    ALL FIELDS
    WITH VALUE #( ( %key-travelid = '0000000111' bookingid = '0001' bookingsupplementid = '01' )
                  ( %key-travelid = '0000000014' bookingid = '0001' bookingsupplementid = '01' )
                )
    RESULT DATA(lt_result_boookSup)

    FAILED DATA(lt_failed).

    IF lt_failed IS NOT INITIAL.
      out->write(
        EXPORTING
          data = 'Read Failed'
      ).

    ELSE.
      out->write( lt_result_trv ).
      out->write( lt_result_book ).
      out->write( lt_result_boooksup ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
