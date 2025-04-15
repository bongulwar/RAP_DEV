CLASS zcl_eml_modify_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_eml_modify_practice IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*** Create New record using EML-Modify statement
**    MODIFY ENTITY zi_travel_tech_m
**
*** 1. Travel
**    CREATE FROM VALUE #(  ( %cid = 'CID_TRV_1'
**                          %data-Begindate = '20241225'
**                          %control-BeginDate = if_abap_behv=>mk-on ) )
**
*** 2. _Booking
**    CREATE BY \_Booking
**    FROM VALUE #( ( %cid_ref = 'CID_TRV_1'
**                    %target = VALUE #( (  %cid = 'BOOKING_1'
**                                          %data-BookingDate = '20241225'
**                                          %control-BookingDate = if_abap_behv=>mk-on )
**                                     )
**                  ) )

*
*    FAILED FINAL(lt_failed)
*    MAPPED FINAL(lt_mapped)
*    REPORTED FINAL(lt_reported).


** Delete Travel will also deleted associated Entities like _Booking + _BookingSupp

*    MODIFY ENTITIES OF zi_travel_tech_m
*    ENTITY zi_travel_tech_m
*    DELETE FROM VALUE #( ( %key-TravelId = '00004146' ) )
*    FAILED FINAL(lt_failed)
*    MAPPED FINAL(lt_mapped)
*    REPORTED FINAL(lt_reported).

* Deleted only Booking , But not Travel then

    MODIFY ENTITY zi_booking_tech_m
    DELETE FROM VALUE #( ( %key-TravelId = '00004136' %key-BookingId = '0001' ) )
        FAILED FINAL(lt_failed)
        MAPPED FINAL(lt_mapped)
        REPORTED FINAL(lt_reported).


* Display Result- Output
    IF lt_failed IS NOT INITIAL.
      out->write( 'Create Failed...!' ).
      out->write( lt_failed ).
      IF lt_reported IS NOT INITIAL.
        out->write( 'Reported ...!' ).
        out->write( lt_reported ).
      ENDIF.

    ELSE.
      COMMIT ENTITIES.
      IF lt_mapped IS NOT INITIAL.
        out->write( 'Mapped...!' ).
        out->write( lt_mapped ).
      ENDIF.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
