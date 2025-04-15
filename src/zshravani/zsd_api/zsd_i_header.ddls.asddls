@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Read SO Header'
define root view entity ZSD_I_HEADER
  as select from zsd_header
  {
    key id                    as Id,
        optio_type            as OptioType,
        test_run              as TestRun,
        filename              as Filename,

        @Semantics.largeObject: {
          mimeType: 'Mimetype',
          fileName: 'Filename',
          acceptableMimeTypes: [ 'application/msexcel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ], //['image/png', 'image/jpeg'],
          contentDispositionPreference: #ATTACHMENT
        }
        attachment            as Attachment,

        @Semantics.mimeType: true
        mimetype              as Mimetype,

        @Semantics.user.createdBy: true
        created_by            as CreatedBy,

        @Semantics.systemDateTime.createdAt: true
        created_at            as CreatedAt,


        //local ETag field --> OData ETag
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        local_last_changed_at as LocalLastChangedAt,

        @Semantics.user.localInstanceLastChangedBy: true
        local_last_changed_by as LocalLastChangedBy,

        //total ETag field
        @Semantics.systemDateTime.lastChangedAt: true
        last_changed_at       as LastChangedAt,

        @Semantics.user.lastChangedBy: true
        last_changed_by       as LastChangedbY

  }
