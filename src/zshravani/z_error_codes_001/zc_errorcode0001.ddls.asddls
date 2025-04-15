@EndUserText.label: 'Maintain Error Code 0001'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_ErrorCode0001
  as projection on ZI_ErrorCode0001
{
  key ErrorCode,
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _ErrorCode0001All : redirected to parent ZC_ErrorCode0001_S,
  _ErrorCode0001Text : redirected to composition child ZC_ErrorCode0001Text,
  _ErrorCode0001Text.Description : localized
  
}
