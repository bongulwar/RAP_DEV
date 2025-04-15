@EndUserText.label: 'Custom entity ZI_JournalEntry_Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@ObjectModel.query.implementedBy:'ABAP:YCL_CALL_POST_API'
define root view entity ZI_CUST_INVOICE_H
  as select from zinvoice_h
  composition [0..*] of ZI_CUST_INVOICE_I as _Invoice_item
  {
    key id                 as Id,
    key invoice_number     as InvoiceNumber,
        company_code       as CompanyCode,
        created_by_user    as CreatedByUser,
        document_date      as DocumentDate,
        posting_date       as PostingDate,
        message            as Message,
        @Semantics.systemDateTime.lastChangedAt: true
        lastchangedat      as Lastchangedat,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true //Etag Change
        locallastchangedat as Locallastchangedat,
        _Invoice_item
  }
