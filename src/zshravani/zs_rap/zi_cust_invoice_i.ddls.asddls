@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@EndUserText.label: 'Root CDS - Invoice Item'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUST_INVOICE_I
  as select from zinvoice_item
  association to parent ZI_CUST_INVOICE_H as _Invoice_h on  $projection.Id            = _Invoice_h.Id
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
