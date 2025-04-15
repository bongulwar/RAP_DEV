@EndUserText.label: 'Error Code 0001 Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity ZI_ErrorCode0001Text
  as select from ZERRCODET_0001
  association [1..1] to ZI_ErrorCode0001_S as _ErrorCode0001All on $projection.SingletonID = _ErrorCode0001All.SingletonID
  association to parent ZI_ErrorCode0001 as _ErrorCode0001 on $projection.ErrorCode = _ErrorCode0001.ErrorCode
  association [0..*] to I_LanguageText as _LanguageText on $projection.Langu = _LanguageText.LanguageCode
{
  @Semantics.language: true
  key LANGU as Langu,
  key ERROR_CODE as ErrorCode,
  @Semantics.text: true
  DESCRIPTION as Description,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _ErrorCode0001All,
  _ErrorCode0001,
  _LanguageText
  
}
