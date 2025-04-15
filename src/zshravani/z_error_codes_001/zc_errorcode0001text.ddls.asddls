@EndUserText.label: 'Maintain Error Code 0001 Text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_ErrorCode0001Text
  as projection on ZI_ErrorCode0001Text
{
  @ObjectModel.text.element: [ 'LanguageName' ]
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Language', 
      element: 'Language'
    }
  } ]
  key Langu,
  key ErrorCode,
  Description,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _ErrorCode0001 : redirected to parent ZC_ErrorCode0001,
  _ErrorCode0001All : redirected to ZC_ErrorCode0001_S
  
}
