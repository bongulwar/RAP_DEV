@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Accept Travel Requet'
@Metadata.allowExtensions: true
define root view entity YC_TRVEL_ACCEPT_M
  provider contract transactional_query
  as projection on ZI_TRAVEL_TECH_M
  {
    key TravelId,
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
        @Semantics.amount.currencyCode: 'CurrencyCode'
        BookingFee,
        @Semantics.amount.currencyCode: 'CurrencyCode'
        TotalPrice,

        @Semantics.currencyCode: true
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
        _Booking : redirected to composition child YC_BOOKING_TECH_M,
        _currency,
        _Customer,
        _Status
  }
