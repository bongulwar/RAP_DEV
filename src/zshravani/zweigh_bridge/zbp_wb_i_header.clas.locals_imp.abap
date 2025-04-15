CLASS lhc_header_h DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header_h RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE header_h.

    METHODS earlynumbering_cba_item FOR NUMBERING
      IMPORTING entities FOR CREATE header_h\_item.

ENDCLASS.

CLASS lhc_header_h IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
  ENDMETHOD.

  METHOD earlynumbering_cba_item.
  ENDMETHOD.

ENDCLASS.
