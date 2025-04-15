@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity yi_invoice_log
  as select from yinvoice_log
  association to parent yi_invoice_h as _Invoice_h on  $projection.id            = _Invoice_h.Id
                                                   and $projection.InvoiceNumber = _Invoice_h.InvoiceNumber
{
  key _Invoice_h.Id,
  key invoice_number          as InvoiceNumber,
  key reference_document_item as ReferenceDocumentItem,
      note                    as Note,
      /* Associations */
      _Invoice_h
}
