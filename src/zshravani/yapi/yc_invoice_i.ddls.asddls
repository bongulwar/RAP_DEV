@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Item for consumption View'
@Metadata.ignorePropagatedAnnotations: true
define view entity yc_invoice_i
  as projection on yi_invoice_i
  {
    key Id,
    key InvoiceNumber,
    key ReferenceDocumentItem,
        Glaccount,
        @Semantics.amount.currencyCode: 'AmountTCurrencyCode'
        AmountInTransaction,
        AmountTCurrencyCode,
        DebitCreditCode,

        /* Associations */
        _Invoice_h : redirected to parent yc_invoice_h
  }
