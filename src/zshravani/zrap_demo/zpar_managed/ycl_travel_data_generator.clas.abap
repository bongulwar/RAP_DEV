CLASS ycl_travel_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_TRAVEL_DATA_GENERATOR IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DELETE FROM ytravel_tech_m.
    DELETE FROM ybooking_tech_m.
    DELETE FROM ybooksupp_tech_m.

    out->write(
      EXPORTING
        data   = 'Table Data erased..!'
*    name   =
*  RECEIVING
*    output =
    ).

    INSERT ytravel_tech_m FROM ( SELECT * FROM /dmo/travel_m ).
    INSERT ybooking_tech_m FROM ( SELECT * FROM /dmo/booking_m ).
    INSERT ybooksupp_tech_m FROM ( SELECT * FROM /dmo/booksuppl_m ).
    out->write(
      EXPORTING
        data   = 'Table uploaded ..!'
*    name   =
*  RECEIVING
*    output =
    ).
  ENDMETHOD.
ENDCLASS.
