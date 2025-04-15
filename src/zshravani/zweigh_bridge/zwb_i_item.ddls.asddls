@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Weigh Bridge Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZWB_I_ITEM
  as select from zwb_item
  association to parent ZWB_I_HEADER as _header  on  $projection.Id      = _header.Id
{
  key id    as Id,
  key ebeln as Ebeln,
  key matnr as Matnr,
  key posnr as Posnr,
      @Semantics.quantity.unitOfMeasure: 'meins'
      qty   as Qty,
      meins as Meins,
      _header
}
