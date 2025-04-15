CLASS lhc_Student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Student RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR student RESULT result.

    METHODS setadmitted FOR MODIFY
      IMPORTING keys FOR ACTION student~setadmitted RESULT result.

ENDCLASS.

CLASS lhc_Student IMPLEMENTATION.

  METHOD get_instance_authorizations.  "Default method which got generated
  ENDMETHOD.

  METHOD get_instance_features.        "set Active/ In-activate -> SetAdmitted Button on UI

*1. Read Selected Rows in UI  - using KEYS[]

    READ ENTITIES OF yi_student IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_read_stud)
    FAILED failed.


*2. Check STATUS field in DB and Set Active/In-Active action Button on UI

    result = VALUE #( FOR ls_stud IN lt_read_stud
                    LET status_val =  COND #( WHEN ls_stud-Status = abap_true
                                                    THEN if_abap_behv=>fc-o-disabled
                                              ELSE if_abap_behv=>fc-o-enabled  )
*
*                         status_val_1 =  COND #( WHEN ls_stud-Status = abap_true
*                                                        THEN if_abap_behv=>fc-o-disabled
*                                                  ELSE if_abap_behv=>fc-o-enabled  )
*                         status_val_2 =  COND #( WHEN ls_stud-Status = abap_true
*                                                        THEN if_abap_behv=>fc-o-disabled
*                                                  ELSE if_abap_behv=>fc-o-enabled  )

                    IN (
                        %tky = ls_stud-%tky
                        %action-setAdmitted = status_val            "Set Action Button Enable/Disable
*                        %action-setAdmitted = status_val_1            "Set Action Button Enable/Disable
*                        %action-setAdmitted = status_val_2            "Set Action Button Enable/Disable
                       )
                   ).

  ENDMETHOD.

  METHOD setAdmitted.

*1. Update Status of selected record.. here
    MODIFY ENTITIES OF yi_student "Interface View
    IN LOCAL MODE                 "will Not check Authorization
    ENTITY Student                "Alias Name for Interface view in Behavior Class
    UPDATE                        "CRUD type
    FIELDS ( Status )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = abap_true ) )
    FAILED failed
    REPORTED reported.

*2. After click Action button Status will update in DB but
*    Issue is updated result not showing - automatically navigating to details page with ID = 000000-00-00000-000

    READ ENTITIES OF yi_student IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_student).

*3. Return Updated value from Database Table to UI

    result = VALUE #( FOR ls_stud IN lt_student
                            ( %tky  = ls_stud-%tky
                              %param = ls_stud           "All fields
                            ) ).

  ENDMETHOD.

ENDCLASS.
