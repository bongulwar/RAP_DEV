@EndUserText.label: 'Invoice Header for Interface View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity yi_invoice_h
  as select from yinvoice_h
  composition [0..*] of yi_invoice_i   as _Invoice_item
  composition [0..*] of yi_invoice_log as _Invoice_log
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
      /* Associations */
      _Invoice_item,
      _Invoice_log
}
