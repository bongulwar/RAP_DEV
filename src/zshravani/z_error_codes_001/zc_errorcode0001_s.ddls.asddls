@EndUserText.label: 'Maintain Error Code 0001 Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI: {
  headerInfo: {
    typeName: 'ErrorCode0001All'
  }
}
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_ErrorCode0001_S
  provider contract TRANSACTIONAL_QUERY
  as projection on ZI_ErrorCode0001_S
{
  @UI.facet: [ {
    id: 'ZI_ErrorCode0001', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Error Code 0001', 
    position: 1 , 
    targetElement: '_ErrorCode0001'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key SingletonID,
  @UI.hidden: true
  LastChangedAtMax,
  @ObjectModel.text.element: [ 'TransportRequestDescription' ]
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  TransportRequestID,
  @UI.hidden: true
  _I_ABAPTransportRequestText.TransportRequestDescription : localized,
  _ErrorCode0001 : redirected to composition child ZC_ErrorCode0001
  
}
