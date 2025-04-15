@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Invoice Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPI_INV_I
    as select from zinvoice_item
    {
        key id                      as Id,
        key invoice_number          as InvoiceNumber,
        key reference_document_item as ReferenceDocumentItem,
            glaccount               as Glaccount,
            amount_in_transaction   as AmountInTransaction,
            amount_t_currency_code  as AmountTCurrencyCode,
            debit_credit_code       as DebitCreditCode
    }
