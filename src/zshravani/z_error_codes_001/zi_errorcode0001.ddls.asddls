@EndUserText.label: 'Error Code 0001'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_ErrorCode0001
    as select from zerror_codes_001
    association to parent ZI_ErrorCode0001_S   as _ErrorCode0001All on $projection.SingletonID = _ErrorCode0001All.SingletonID
    composition [0..*] of ZI_ErrorCode0001Text as _ErrorCode0001Text
    {
        key error_code            as ErrorCode,
            @Semantics.systemDateTime.lastChangedAt: true
            last_changed_at       as LastChangedAt,
            @Semantics.systemDateTime.localInstanceLastChangedAt: true
            local_last_changed_at as LocalLastChangedAt,
            1                     as SingletonID,
            _ErrorCode0001All,
            _ErrorCode0001Text
    }
