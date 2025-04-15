@EndUserText.label: 'Travel Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_TRAVEL_TECH_M
  provider contract transactional_query
  as projection on ZI_TRAVEL_TECH_M
  {
    key TravelId,
        // @ObjectModel.text.element: [ '_Agency.Name' ] //Won't work - U hv to use 'AgencyName' field
        @ObjectModel.text.element: [ 'AgencyName' ]
        AgencyId,

        @UI.hidden: true
        _Agency.Name       as AgencyName,

        @ObjectModel.text.element: [ 'CustomerName' ]
        CustomerId,

        @UI.hidden: true
        _Customer.LastName as CustomerName,

        BeginDate,
        EndDate,
        BookingFee,
        TotalPrice,
        CurrencyCode,
        Description,

        @ObjectModel.text.element: [ 'OverallStatusText' ]
        OverallStatus,

        _Status._Text.Text as OverallStatusText : localized,
        CreatedBy,
        CreatedAt,
        LastChangedBy,
        LastChangedAt,

        /* Associations */
        _Agency,
        _Booking : redirected to composition child ZC_BOOKING_TECH_M,
        _currency,
        _Customer,
        _Status
  }
