@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity yc_invoice_log
  as projection on yi_invoice_log
{
  key Id,
  key InvoiceNumber,
  key ReferenceDocumentItem,
      Note,
      /* Associations */
      _Invoice_h : redirected to parent yc_invoice_h
}
