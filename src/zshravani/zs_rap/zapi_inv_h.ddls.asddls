@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Invoice Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZAPI_INV_H
  as select from zinvoice_h
  association [0..*] to ZAPI_INV_I as _Items on zinvoice_h.id             = _Items.Id and
                                                zinvoice_h.invoice_number = _Items.InvoiceNumber
  {
    key id                 as Id,
    key invoice_number     as InvoiceNumber,
        company_code       as CompanyCode,
        created_by_user    as CreatedByUser,
        document_date      as DocumentDate,
        posting_date       as PostingDate,
        message            as Message,
        @Semantics.systemDateTime.lastChangedAt: true
        lastchangedat      as Lastchangedat,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true //Etag Change
        locallastchangedat as Locallastchangedat,
        _Items
  }
