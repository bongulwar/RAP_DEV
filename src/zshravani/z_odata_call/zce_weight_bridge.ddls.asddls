@EndUserText.label: 'Get weight Bridge - custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZAPI_CALL_ODATA_WEIGHT'
@Metadata.allowExtensions: true
define root custom entity ZCE_WEIGHT_BRIDGE
    // with parameters parameter_name : parameter_type
    {
        key WEIGHT : abap.string( 500 );
    }
