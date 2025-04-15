@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumtion View for STUDENT'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
// Step 3 -> Add ROOT and 'as projection'
// Step 4 -> Add 'provider contract transactional_query'
// Step 5 -> Add Annotation @EndUserText.label: ''
define root view entity YC_STUDENT
  provider contract transactional_query
  as projection on YI_STUDENT as Student
  {
        @EndUserText.label: 'Student Id'
    key ID,
        @EndUserText.label: 'First Name'
        FIRSTNAME,
        @EndUserText.label: 'Last Name'
        LASTNAME,
        @EndUserText.label: 'Age'
        Age,
        @EndUserText.label: 'Course'
        Course,
        @EndUserText.label: 'Course Duration'
        Courseduration,
        @EndUserText.label: 'Status'
        Status,
        @EndUserText.label: 'Gender'
        Gender,
        @EndUserText.label: 'Date of Birth'
        Dob,
        lastchangedat, //ETag Changes
        locallastchangedat //ETag Changes
  }
// Step 6 -> Create Metadat Extension for Projection view (YC_STUDENT)
//        ->  @Metadata.allowExtensions: true
