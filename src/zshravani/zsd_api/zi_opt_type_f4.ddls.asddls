@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Read Domain Values: ZD_OPT_TYPE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS --DropDown List
define view entity ZI_OPT_TYPE_F4
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_OPT_TYPE' )
  {
    key domain_name,
    key value_position,
        @Semantics.language: true
    key language,
        @UI.textArrangement: #TEXT_LAST
        value_low as Value,
        @Semantics.text: true
        text      as Text
  }
