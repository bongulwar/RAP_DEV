CLASS lhc_zsd_i_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    CONSTANTS state_area_validate_attachment TYPE string VALUE 'VALIDATE_ATTACHMENT' ##NO_TEXT.
    CONSTANTS state_area_validate_name       TYPE string VALUE 'VALIDATE_NAME'       ##NO_TEXT.
    CONSTANTS state_area_validate_email      TYPE string VALUE 'VALIDATE_EMAIL'      ##NO_TEXT.
    CONSTANTS state_area_validate_country    TYPE string VALUE 'VALIDATE_COUNTRY'    ##NO_TEXT.
    CONSTANTS state_area_validate_lob        TYPE string VALUE 'VALIDATE_LOB'     ##NO_TEXT.

    TYPES: BEGIN OF t_mimetypes,
             file_extension TYPE string,
             mimetype       TYPE string,
           END OF t_mimetypes.

    CLASS-DATA allowed_mimetypes TYPE STANDARD TABLE OF t_mimetypes WITH KEY mimetype.

    CLASS-METHODS class_constructor.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR SO_Header RESULT result.

*    METHODS validatelargeobject FOR VALIDATE ON SAVE
*      IMPORTING keys FOR zsd_i_header~validatelargeobject.

ENDCLASS.

CLASS lhc_zsd_i_header IMPLEMENTATION.

  METHOD class_constructor.
    allowed_mimetypes = VALUE #(
*                                 ( file_extension = '.txt' mimetype = 'text/plain' )
*                                 ( file_extension = '.jpg' mimetype = 'image/jpeg' )
*                                 ( file_extension = '.png' mimetype = 'image/png' )
*                                 ( file_extension = '.bmp' mimetype = 'image/bmp' )
*                                 ( file_extension = '.bmp' mimetype = 'image/bmp' )
                                 ( file_extension = '.xlsx' mimetype = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' )
                               ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD validatelargeobject.
*
*    READ ENTITIES OF zsd_i_header IN LOCAL MODE
*         ENTITY so_header
*         FIELDS ( attachment mimetype filename )
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(agencies).
*
*    LOOP AT agencies INTO DATA(agency).
*
*      APPEND VALUE #( %tky        = agency-%tky
*                      %state_area = state_area_validate_lob ) TO reported-so_header.
*
*      " No mimetype for attachment
*      IF agency-attachment IS NOT INITIAL AND agency-mimetype IS INITIAL.
*        APPEND VALUE #( %tky = agency-%tky ) TO failed-so_header.
*        APPEND VALUE #( %tky              = agency-%tky
*                        %state_area       = state_area_validate_lob
*                        %msg              = NEW /dmo/cx_agency( textid     = /dmo/cx_agency=>mimetype_missing
*                                                                attachment = agency-attachment )
*                        %element-mimetype = if_abap_behv=>mk-on )
*               TO reported-so_header.
*
*      ENDIF.
*
*      IF agency-mimetype IS NOT INITIAL.
*
*        " No (empty) attachment for mimetype
*        IF agency-attachment IS INITIAL.
*          APPEND VALUE #( %tky = agency-%tky ) TO failed-so_header.
*          APPEND VALUE #(
*              %tky                = agency-%tky
*              %state_area         = state_area_validate_lob
*              %msg                = NEW /dmo/cx_agency( textid     = /dmo/cx_agency=>attachment_empty_missing
*                                                        attachment = agency-attachment )
*              %element-attachment = if_abap_behv=>mk-on )
*                 TO reported-so_header.
*        ENDIF.
*
*        " Mimetype is not supported
*        IF NOT line_exists( allowed_mimetypes[ mimetype = agency-mimetype ] ).
*          APPEND VALUE #( %tky = agency-%tky ) TO failed-so_header.
*          APPEND VALUE #( %tky              = agency-%tky
*                          %state_area       = state_area_validate_lob
*                          %msg              = NEW /dmo/cx_agency( textid   = /dmo/cx_agency=>mimetype_not_supported
*                                                                  mimetype = agency-mimetype )
*                          %element-mimetype = if_abap_behv=>mk-on )
*                 TO reported-so_header.
*        ELSE.
*
*          IF agency-filename IS NOT INITIAL.
*            DATA(file_extension) = substring_from( val = agency-filename pcre = '(.[^.]*)$' ).
*
*            " File extension does not match mimetype
*            IF file_extension <> allowed_mimetypes[ mimetype = agency-mimetype ]-file_extension.
*              APPEND VALUE #( %tky = agency-%tky ) TO failed-so_header.
*              APPEND VALUE #(
*                  %tky              = agency-%tky
*                  %state_area       = state_area_validate_lob
*                  %msg              = NEW /dmo/cx_agency( textid   = /dmo/cx_agency=>extension_mimetype_mismatch
*                                                          mimetype = agency-mimetype )
*                  %element-mimetype = if_abap_behv=>mk-on
*                  %element-filename = if_abap_behv=>mk-on )
*                     TO reported-so_header.
*            ENDIF.
*
*          ENDIF.
*
*        ENDIF.
*
*      ELSEIF agency-attachment IS INITIAL AND agency-filename IS NOT INITIAL.
*        APPEND VALUE #( %tky = agency-%tky ) TO failed-so_header.
*        APPEND VALUE #( %tky                = agency-%tky
*                        %state_area         = state_area_validate_lob
*                        %msg                = NEW /dmo/cx_agency( textid   = /dmo/cx_agency=>only_filename
*                                                                  filename = agency-filename )
*                        %element-attachment = if_abap_behv=>mk-on
*                        %element-mimetype   = if_abap_behv=>mk-on )
*               TO reported-so_header.
*
*      ENDIF.
*
*    ENDLOOP.
*
*  ENDMETHOD.

ENDCLASS.
