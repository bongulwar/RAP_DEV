@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'value Help for Airport'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

//@ObjectModel.resultSet.sizeCategory: #XS  //Dropdown List, but only Key is displaying not Text
@Search.searchable: true

define view entity ZI_AIRTPORT_VH
  as select from /dmo/airport
  {
        @Search.defaultSearchElement: true
        @Search.fuzzinessThreshold: 0.7
        @ObjectModel.text.element: [ 'Name' ]
        @UI.textArrangement: #TEXT_LAST
    key airport_id as AirportId,

        @Search.defaultSearchElement: true
        @Search.fuzzinessThreshold: 0.7

        @Semantics.text: true
        name       as Name,

        @Search.defaultSearchElement: true
        @Search.fuzzinessThreshold: 0.7
        city       as City,

        @Search.defaultSearchElement: true
        @Search.fuzzinessThreshold: 0.7
        country    as Country
  }
