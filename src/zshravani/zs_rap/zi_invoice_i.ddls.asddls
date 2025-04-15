@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Billing Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_invoice_i   as select from zinv_i
  association to parent ZI_Invoice_H as _Invoice_h on  $projection.Id            = _Invoice_h.Id
                                                        and $projection.InvoiceNumber = _Invoice_h.InvoiceNumber
{
      @EndUserText.label: 'ID'
  key id                      as Id,
      @EndUserText.label: 'InvoiceNumber'
  key invoice_number          as InvoiceNumber,
      @EndUserText.label: 'ReferenceDocumentItem'
  key reference_document_item as ReferenceDocumentItem,

      @EndUserText.label: 'Glaccount'
      glaccount               as Glaccount,
      @EndUserText.label: 'AmountInTransaction'
      amount_in_transaction   as AmountInTransaction,
      @EndUserText.label: 'AmountTCurrencyCode'
      amount_t_currency_code  as AmountTCurrencyCode,
      @EndUserText.label: 'DebitCreditCode'
      debit_credit_code       as DebitCreditCode,
      _Invoice_h
}
