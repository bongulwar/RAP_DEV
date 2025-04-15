@EndUserText.label: 'Booking Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_BOOKING_TECH_M
  as projection on ZI_BOOKING_TECH_M
  {
    key TravelId,
    key BookingId,
        BookingDate,

        @ObjectModel.text.element: [ 'CustomerName' ]
        CustomerId,

        _Customer.LastName         as CustomerName,

        @ObjectModel.text.element: [ 'CarrireName' ]
        CarrierId,

        _Carrier.Name              as CarrireName,
        ConnectionId,
        FlightDate,
        FlightPrice,
        CurrencyCode,
        @ObjectModel.text.element: [ 'BookingStatusName' ]
        BookingStatus,
        _Booking_Status._Text.Text as BookingStatusName : localized,

        LastChangedAt,

        /* Associations */
        _Travel       : redirected to parent ZC_TRAVEL_TECH_M,
        _BookingSuppl : redirected to composition child ZC_BOOKSUPPL_TECK_M,
        _Booking_Status,
        _Carrier,
        _Connection,
        _Customer
  }
