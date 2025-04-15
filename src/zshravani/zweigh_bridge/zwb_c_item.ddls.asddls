@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption WB Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZWB_C_ITEM
 as projection on ZWB_I_ITEM
{
@EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'PO Number'
    key Ebeln,
    @EndUserText.label: 'PO Material Number'
    key Matnr,
    @EndUserText.label: 'PO Item'
    key Posnr,
    @EndUserText.label: 'Quantity'
    @Semantics.quantity.unitOfMeasure: 'Meins'
    Qty,
    Meins,
    /* Associations */
    _header : redirected to parent ZWB_C_HEADER
}
