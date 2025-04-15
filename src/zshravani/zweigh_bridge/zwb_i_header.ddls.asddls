@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Weigh Bridge Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZWB_I_HEADER
  as select from zwb_header
  composition [1..*] of ZWB_I_ITEM as _item
{
  key id                 as Id,
      werks              as Werks,
      ebeln              as Ebeln,
      vehicle            as Vehicle,
      vehicle_type       as VehicleType,
      name               as Name,
      createdate         as Createdate,
      @Semantics.quantity.unitOfMeasure: 'meins'
      gross_wt           as GrossWt,
       @Semantics.quantity.unitOfMeasure: 'meins'
      tare_wt            as TareWt,
       @Semantics.quantity.unitOfMeasure: 'meins'
      net_wt             as NetWt,
      meins              as Meins,
      chk_in_date        as ChkInDate,
      chk_in_time        as ChkInTime,
      chk_out_date       as ChkOutDate,
      chk_out_time       as ChkOutTime,
      lastchangedat      as Lastchangedat,
      locallastchangedat as Locallastchangedat,
      _item
}
