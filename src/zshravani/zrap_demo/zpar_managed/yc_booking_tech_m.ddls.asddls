@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Accept Booking Requet'
@Metadata.ignorePropagatedAnnotations: true
define view entity YC_BOOKING_TECH_M
  as projection on ZI_BOOKING_TECH_M
  {
    key TravelId,
    key BookingId,
        BookingDate,
        CustomerId,
        CarrierId,
        ConnectionId,
        FlightDate,
        @Semantics.amount.currencyCode: 'CurrencyCode'
        FlightPrice, //YC_BOOKING_TECH_M-FLIGHTPRICE reference information missing or data type wrong, see long text
       
        @Semantics.currencyCode: true
         CurrencyCode,
        BookingStatus,
        LastChangedAt,
        /* Associations */
        _BookingSuppl,
        _Booking_Status,
        _Carrier,
        _Connection,
        _Customer,
        _Travel : redirected to parent YC_TRVEL_ACCEPT_M
  }
