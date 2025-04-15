@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplement View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOOKSUPPL_TECK_M
  as select from ybooksupp_tech_m
  // Parent
  association        to parent ZI_BOOKING_TECH_M as _Booking       on  _Booking.BookingId = $projection.BookingId
                                                                   and _Booking.TravelId  = $projection.TravelId
  association [1..1] to /DMO/I_Supplement        as _Supplement    on  _Supplement.SupplementID = $projection.SupplementId
  association [1..*] to /DMO/I_SupplementText    as _SupplementTxt on  _SupplementTxt.SupplementID = $projection.SupplementId
  association [1..1] to ZI_TRAVEL_TECH_M         as _Travel        on  $projection.TravelId = _Travel.TravelId
  {
    key travel_id             as TravelId,
    key booking_id            as BookingId,
    key booking_supplement_id as BookingSupplementId,
        supplement_id         as SupplementId,

        @Semantics.amount.currencyCode: 'CurrencyCode'
        price                 as Price,
        currency_code         as CurrencyCode,

        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        last_changed_at       as LastChangedAt,

        /*Association*/
        _Supplement,
        _SupplementTxt,
        _Travel,

        _Booking //association to Parent
  }
