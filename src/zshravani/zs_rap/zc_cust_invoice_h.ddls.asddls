@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consume View for Invoice_Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_CUST_INVOICE_H
  provider contract transactional_query
  as projection on ZI_CUST_INVOICE_H as _Invoice_h
  {
    key Id,
    key InvoiceNumber,
        CompanyCode,
        CreatedByUser,
        DocumentDate,
        PostingDate,
        Message,
        Lastchangedat,
        Locallastchangedat,
        /* Associations */
        _Invoice_item : redirected to composition child ZC_CUST_INVOICE_I
  }
