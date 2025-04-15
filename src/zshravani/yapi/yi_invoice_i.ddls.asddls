@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Item for Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity yi_invoice_i
    as select from yinvoice_i
    association to parent YI_INVOICE_H as _Invoice_h on  $projection.Id            = _Invoice_h.Id
                                                     and $projection.InvoiceNumber = _Invoice_h.InvoiceNumber
    {
        key _Invoice_h.Id           as Id,
        key invoice_number          as InvoiceNumber,
        key reference_document_item as ReferenceDocumentItem,
            glaccount               as Glaccount,
            @Semantics.amount.currencyCode: 'AmountTCurrencyCode'
            amount_in_transaction   as AmountInTransaction,
            amount_t_currency_code  as AmountTCurrencyCode,
            debit_credit_code       as DebitCreditCode,
            _Invoice_h
    }
