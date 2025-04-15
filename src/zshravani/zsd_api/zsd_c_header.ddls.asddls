@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection: SD Header'
@Metadata.allowExtensions: true
define root view entity ZSD_C_HEADER
  provider contract transactional_query
  as projection on ZSD_I_HEADER
  {
        @UI.facet: [{   id: 'SO_H',
                        type: #IDENTIFICATION_REFERENCE,
                        label: 'SO Header',
                        position: 10
                   }]
    key Id,
        @UI: { lineItem:      [{ position: 10 }],
               identification: [{position: 10 }]
             }
        @Consumption.valueHelpDefinition: [{ entity: {
                                                        name: 'ZI_OPT_TYPE_F4',
                                                        element: 'Value'
                                                      },
                                                      distinctValues: true }]
        OptioType,

        @UI: { lineItem:       [{ position: 20 }],
               identification: [{position: 20 }]
             }
        @EndUserText.label: 'Test Run'
        TestRun,

        @UI.hidden: true
        Filename,

        @UI.hidden: true
        Mimetype,

        @UI: { lineItem:       [{ position: 30 }],
              identification: [{position: 30 }]
            }
        @EndUserText.label: 'Browser'
        Attachment,

        @UI: { lineItem:       [{ position: 40 }],
               identification: [{position: 40 }]
             }
        CreatedBy,
        @UI: { lineItem:       [{ position:50 }],
               identification: [{position: 50 }]
             }
        CreatedAt,
        @UI: { lineItem:       [{ position: 60 }],
               identification: [{position: 60 }]
             }
        LastChangedbY,
        @UI: { lineItem:       [{ position: 70 }],
               identification: [{position: 70 }]
             }
        LastChangedAt,

        @UI: { lineItem:       [{ position: 80 }],
               identification: [{position: 80 }]
             }
        LocalLastChangedBy,

        @UI: { lineItem:       [{ position: 90 }],
               identification: [{position: 90 }]
             }
        LocalLastChangedAt
  }
