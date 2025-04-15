@EndUserText.label: 'Error Code 0001 Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_ErrorCode0001_S
    as select from      I_Language
        left outer join zerror_codes_001 on 0 = 0
    association [0..*] to I_ABAPTransportRequestText as _I_ABAPTransportRequestText on $projection.TransportRequestID = _I_ABAPTransportRequestText.TransportRequestID
    composition [0..*] of ZI_ErrorCode0001           as _ErrorCode0001
    {
        key 1                                       as SingletonID,
            _ErrorCode0001,
            max( zerror_codes_001.last_changed_at ) as LastChangedAtMax,
            cast( '' as sxco_transport)             as TransportRequestID,
            _I_ABAPTransportRequestText
    }
    where
        I_Language.Language = $session.system_language
