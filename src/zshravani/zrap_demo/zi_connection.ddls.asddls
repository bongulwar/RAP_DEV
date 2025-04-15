@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Connection'
@Metadata.ignorePropagatedAnnotations: true

@UI.headerInfo:{
                    typeName: 'Connection',
                    typeNamePlural: 'Connections'
               }
@Search.searchable: true

define view entity ZI_CONNECTION
  as select from /dmo/connection as Connection
  association [1..*] to ZI_FLIGHT_R  as _Flight
    on  $projection.CarrierId    = _Flight.CarrierId
    and $projection.ConnectionId = _Flight.ConnectionId

  association [1]    to ZI_CARRIER_R as _Airline
    on $projection.CarrierId = _Airline.CarrierId
  {
        @UI.facet: [{ id: 'Connection',
                      purpose:#STANDARD,
                      type: #IDENTIFICATION_REFERENCE,
                      position: 10,
                      label: 'Conenction Details'
                   },
                   {  id: 'Flight',
                      purpose:#STANDARD,
                      type: #LINEITEM_REFERENCE,
                      position: 20,
                      label: 'Flights',
                      targetElement: '_Flight'
        //Also Expose this Flight CDS in Service else It won't display in Object Page as Table.
                   }]

        @UI.lineItem: [{ position: 10, label: 'Airline ID2' }]
        @UI.identification: [{ position: 10 }]
        @UI.textArrangement: #TEXT_FIRST //#TEXT_SEPARATE #TEXT_ONLY, #TEXT_LAST, #TEXT_FIRST

        //@ObjectModel.text.element: [ '_Airline.Name' ] "Not working
        //->Solution:Description field must be in this CDS field List and expose ZI_CARRIER_R as below "Carrier_Text";
        //  @ObjectModel.text.element: [ 'Carrier_Text' ] - Working

        @ObjectModel.text.association: '_Airline' //With Direct _Text association with @Semantics.text: true
        //it will only work With Associatiated CDS with @Semantics.text: true

        @Search.defaultSearchElement: true
    key carrier_id      as CarrierId,

        @UI.lineItem: [{ position: 20 }]
        @UI.identification: [{ position: 20 }]
    key connection_id   as ConnectionId,

        //        @UI.hidden: true
        //        _Airline.Name   as Carrier_Text,;
        @UI.lineItem: [{ position: 30 }]
        @UI.identification: [{ position: 30 }]
        @UI.selectionField: [{ position: 10 }]

        // Search
        @Search.defaultSearchElement: true

        //F4 Help
        @Consumption.valueHelpDefinition: [{ entity: {
                                                        name: 'ZI_AIRTPORT_VH',
                                                        element: 'AirportId'  //ZI_AIRTPORT_VH.AirportId
                                                      }
                                           }]
        @EndUserText.label: 'EndUserText.label=Departure Airport_11'
        airport_from_id as AirportFromId,

        @UI.lineItem: [{ position: 40 }]
        @UI.identification: [{ position: 40 }]
        @UI.selectionField: [{ position: 20 }]

        // Range Option in UI Selection field
        //        @Consumption.filter: {
        //        //            mandatory: true,
        //        //            defaultValue: 'TT',
        //        //            defaultValueHigh: 'HI',
        //        selectionType: #INTERVAL
        //        }
        @Consumption.valueHelpDefinition: [{ entity: {
            name: 'ZI_AIRTPORT_VH',
            element: 'AirportId'
        } }]
        airport_to_id   as AirportToId,

        @UI.lineItem: [{ position: 50 }]
        @UI.identification: [{ position: 50 }]
        @UI.selectionField: [{ position: 30 }]
        @EndUserText.label: 'Departure Time _11'
        departure_time  as DepartureTime,

        @UI.lineItem: [{ position: 60 }]
        @UI.identification: [{ position: 60 }]
        arrival_time    as ArrivalTime,

        @UI.lineItem: [{ position: 70 }]
        @UI.identification: [{ position: 70 }]
        @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
        distance        as Distance,

        //        @UI.lineItem: [{ position: 80 }]
        //        @UI.identification: [{ position: 80 }]
        //        @UI.hidden: true //Don't display in whole App - only with Distance Field ( 100 KM )
        //        @UI.lineItem: [{hidden: true}]
        //        @UI.identification: [{hidden: true}]
        @UI.lineItem: [{exclude: true}]
        distance_unit   as DistanceUnit,

        /* Expose Associations*/
        @Search.defaultSearchElement: true
        _Flight,
        // Search
        @Search.defaultSearchElement: true
        _Airline
  }
