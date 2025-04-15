@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for STUDENT'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
// Step 1 -> Add Root entity for Projection view/Creating Fiori App we need root entity
define root view entity YI_STUDENT
  as select from ystudent
  {
    key ystudent.id                 as ID,
        ystudent.firstname          as FIRSTNAME,
        ystudent.lastname           as LASTNAME,
        ystudent.age                as Age,
        ystudent.course             as Course,
        ystudent.courseduration     as Courseduration,
        ystudent.status             as Status,
        ystudent.gender             as Gender,
        ystudent.dob                as Dob,
        @Semantics.systemDateTime.lastChangedAt: true              //Etag Change
        ystudent.lastchangedat      as lastchangedat,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true //Etag Change
        ystudent.locallastchangedat as locallastchangedat
  }
// Step 2 -> Create Consumption View for this CDS view entiy
//          (YC_STUDENT)
