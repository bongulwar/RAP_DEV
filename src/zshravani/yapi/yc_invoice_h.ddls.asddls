@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Header for consumption View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity yc_invoice_h
  provider contract transactional_query
  as projection on yi_invoice_h
  {
    key Id,
    key InvoiceNumber,
        CompanyCode,
        CreatedByUser,
        DocumentDate,
        PostingDate,
        Message,
        @Semantics.systemDateTime.lastChangedAt: true
        Lastchangedat,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        Locallastchangedat,
        /* Associations */
        _Invoice_item : redirected to composition child yc_invoice_i,
        _Invoice_log  : redirected to composition child yc_invoice_log
  }
