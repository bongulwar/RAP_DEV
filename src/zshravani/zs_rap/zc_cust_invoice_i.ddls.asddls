@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composition view for Invoice_Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_CUST_INVOICE_I
  as projection on ZI_CUST_INVOICE_I as _Invoice_item
  {
    key Id,
    key InvoiceNumber,
    key ReferenceDocumentItem,
        Glaccount,
        AmountInTransaction,
        AmountTCurrencyCode,
        DebitCreditCode,
        /* Associations */
        _Invoice_h : redirected to parent ZC_CUST_INVOICE_H
  }
