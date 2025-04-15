"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>ZWEIGHT_READ_SRV</em>
CLASS z_weight_odata DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">Read</p>
      BEGIN OF tys_read,
        "! <em>Key property</em> Weight
        weight TYPE string,
      END OF tys_read,
      "! <p class="shorttext synchronized">List of Read</p>
      tyt_read TYPE STANDARD TABLE OF tys_read WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! ReadSet
        "! <br/> Collection of type 'Read'
        read_set TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'READ_SET',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for Read</p>
        "! See also structure type {@link ..tys_read}
        BEGIN OF read,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF read,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define Read</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_read RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS Z_WEIGHT_ODATA IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'ZWEIGHT_READ_SRV' ) ##NO_TEXT.

    def_read( ).

  ENDMETHOD.


  METHOD def_read.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'READ'
                                    is_structure              = VALUE tys_read( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'Read' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'READ_SET' ).
    lo_entity_set->set_edm_name( 'ReadSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'WEIGHT' ).
    lo_primitive_property->set_edm_name( 'Weight' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

  ENDMETHOD.
ENDCLASS.
