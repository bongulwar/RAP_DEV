CLASS lhc_zi_errorcode0001_s DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      augment_errorcode0001 FOR MODIFY
        IMPORTING
          entities_create FOR CREATE errorcode0001all\_errorcode0001
          entities_update FOR UPDATE errorcode0001.
ENDCLASS.

CLASS lhc_zi_errorcode0001_s IMPLEMENTATION.
  METHOD augment_errorcode0001.
    DATA: text_for_new_entity      TYPE TABLE FOR CREATE zi_errorcode0001\_errorcode0001text,
          text_for_existing_entity TYPE TABLE FOR CREATE zi_errorcode0001\_errorcode0001text,
          text_update              TYPE TABLE FOR UPDATE zi_errorcode0001text.
    DATA: relates_create TYPE abp_behv_relating_tab,
          relates_update TYPE abp_behv_relating_tab,
          relates_cba    TYPE abp_behv_relating_tab.
    DATA: text_tky_link TYPE STRUCTURE FOR READ LINK zi_errorcode0001\_errorcode0001text,
          text_tky      LIKE text_tky_link-target.

    LOOP AT entities_create INTO DATA(entity).
      DATA(tabix) = sy-tabix.
      LOOP AT entity-%target ASSIGNING FIELD-SYMBOL(<target>).
        APPEND tabix TO relates_create.
        INSERT VALUE #( %cid_ref = <target>-%cid
                        %is_draft = <target>-%is_draft
                          %key-errorcode = <target>-%key-errorcode
                        %target = VALUE #( (
                          %cid = |CREATETEXTCID{ tabix }_{ sy-tabix }|
                          %is_draft = <target>-%is_draft
                          langu = sy-langu
                          description = <target>-description
                          %control-langu = if_abap_behv=>mk-on
                          %control-description = <target>-%control-description ) ) )
                     INTO TABLE text_for_new_entity.
      ENDLOOP.
    ENDLOOP.
    MODIFY AUGMENTING ENTITIES OF zi_errorcode0001_s
      ENTITY errorcode0001
        CREATE BY \_errorcode0001text
        FROM text_for_new_entity
        RELATING TO entities_create BY relates_create.

    IF entities_update IS NOT INITIAL.
      READ ENTITIES OF zi_errorcode0001_s
        ENTITY errorcode0001 BY \_errorcode0001text
          FROM CORRESPONDING #( entities_update )
          LINK DATA(link).
      LOOP AT entities_update INTO DATA(update) WHERE %control-description = if_abap_behv=>mk-on.
        tabix = sy-tabix.
        text_tky = CORRESPONDING #( update-%tky MAPPING
                                                        errorcode = errorcode
                                    ).
        text_tky-langu = sy-langu.
        IF line_exists( link[ KEY draft source-%tky  = CORRESPONDING #( update-%tky )
                                        target-%tky  = CORRESPONDING #( text_tky ) ] ).
          APPEND tabix TO relates_update.
          APPEND VALUE #( %tky = CORRESPONDING #( text_tky )
                          %cid_ref = update-%cid_ref
                          description = update-description
                          %control = VALUE #( description = update-%control-description )
          ) TO text_update.
        ELSEIF line_exists(  text_for_new_entity[ KEY cid %is_draft = update-%is_draft
                                                          %cid_ref  = update-%cid_ref ] ).
          APPEND tabix TO relates_update.
          APPEND VALUE #( %tky = CORRESPONDING #( text_tky )
                          %cid_ref = text_for_new_entity[ KEY cid %is_draft = update-%is_draft
                          %cid_ref = update-%cid_ref ]-%target[ 1 ]-%cid
                          description = update-description
                          %control = VALUE #( description = update-%control-description )
          ) TO text_update.
        ELSE.
          APPEND tabix TO relates_cba.
          APPEND VALUE #( %tky = CORRESPONDING #( update-%tky )
                          %cid_ref = update-%cid_ref
                          %target  = VALUE #( (
                            %cid = |UPDATETEXTCID{ tabix }|
                            langu = sy-langu
                            %is_draft = text_tky-%is_draft
                            description = update-description
                            %control-langu = if_abap_behv=>mk-on
                            %control-description = update-%control-description
                          ) )
          ) TO text_for_existing_entity.
        ENDIF.
      ENDLOOP.
      IF text_update IS NOT INITIAL.
        MODIFY AUGMENTING ENTITIES OF zi_errorcode0001_s
          ENTITY errorcode0001text
            UPDATE FROM text_update
            RELATING TO entities_update BY relates_update.
      ENDIF.
      IF text_for_existing_entity IS NOT INITIAL.
        MODIFY AUGMENTING ENTITIES OF zi_errorcode0001_s
          ENTITY errorcode0001
            CREATE BY \_errorcode0001text
            FROM text_for_existing_entity
            RELATING TO entities_update BY relates_cba.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
