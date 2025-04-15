@EndUserText.label: 'Suppliment Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_BOOKSUPPL_TECK_M
  as projection on ZI_BOOKSUPPL_TECK_M
  {
    key TravelId,
    key BookingId,
    key BookingSupplementId,
        @ObjectModel.text.element: [ 'SupplementDesc' ]
        SupplementId,
        _SupplementTxt.Description as SupplementDesc : localized,
        Price,
        CurrencyCode,
        LastChangedAt,

        /* Associations */
        _Travel  : redirected to ZC_TRAVEL_TECH_M,
        _Booking : redirected to parent ZC_BOOKING_TECH_M,
        _Supplement,
        _SupplementTxt
  }
