@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Interface view Managed'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOOKING_TECH_M
  as select from ybooking_tech_m
  //Link to Parent
  association        to parent ZI_TRAVEL_TECH_M  as _Travel         on  _Travel.TravelId = $projection.TravelId
  //Link to Child
  composition [0..*] of ZI_BOOKSUPPL_TECK_M      as _BookingSuppl

  association [1..1] to /DMO/I_Carrier           as _Carrier        on  $projection.CarrierId = _Carrier.AirlineID
  association [1..1] to /DMO/I_Customer          as _Customer       on  $projection.CustomerId = _Customer.CustomerID
  association [1..1] to /DMO/I_Connection        as _Connection     on  $projection.ConnectionId = _Connection.ConnectionID
                                                                    and $projection.CarrierId    = _Connection.AirlineID
  association [1..1] to /DMO/I_Booking_Status_VH as _Booking_Status on  $projection.BookingStatus = _Booking_Status.BookingStatus
  {
    key travel_id       as TravelId,
    key booking_id      as BookingId,
        booking_date    as BookingDate,
        customer_id     as CustomerId,
        carrier_id      as CarrierId,
        connection_id   as ConnectionId,
        flight_date     as FlightDate,

        @Semantics.amount.currencyCode: 'CurrencyCode'
        flight_price    as FlightPrice,
        currency_code   as CurrencyCode,
        booking_status  as BookingStatus,

        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        last_changed_at as LastChangedAt,

        /*Association*/
        _Carrier,
        _Customer,
        _Connection,
        _Booking_Status,

        _Travel,      //association to Parent
        _BookingSuppl //Composition to Item

  }
