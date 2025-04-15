@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption WB Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZWB_C_HEADER
  provider contract transactional_query
  as projection on ZWB_I_HEADER
{
      @EndUserText.label: 'Gate Pass Number'
  key Id,
      @EndUserText.label: 'Plant'
      Werks,
      @EndUserText.label: 'PO Number'
      Ebeln,
      @EndUserText.label: 'Vehicle Number'
      Vehicle,
      @EndUserText.label: 'Vehicle Type'
      VehicleType,
      @EndUserText.label: 'Supplier'
      Name,
      @EndUserText.label: 'Create Date'
      Createdate,
      @EndUserText.label: 'Gross Weighr'
      @Semantics.quantity.unitOfMeasure: 'Meins'
      GrossWt,
      @EndUserText.label: 'Tare Weighr'
      @Semantics.quantity.unitOfMeasure: 'Meins'
      TareWt,
      @EndUserText.label: 'Net Weighr'
      @Semantics.quantity.unitOfMeasure: 'Meins'
      NetWt,
      Meins,
      @EndUserText.label: 'Check In Date'
      ChkInDate,
      @EndUserText.label: 'Check In Time'
      ChkInTime,
      @EndUserText.label: 'Check Out Date'
      ChkOutDate,
      @EndUserText.label: 'Check Out Time'
      ChkOutTime,
      Lastchangedat,
      Locallastchangedat,
      /* Associations */
      _item : redirected to composition child ZWB_C_ITEM
}
