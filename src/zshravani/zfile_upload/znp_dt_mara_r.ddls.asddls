@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity znp_dt_mara_r
  as select from znp_dt_mara1
  {
    key matnr           as Matnr,
        mtart           as Mtart,
        materialstatus  as Materialstatus,
        lvorm           as Lvorm,
        @Semantics.largeObject : {
                mimeType: 'Mimetype',
                fileName: 'Filename',
                contentDispositionPreference: #INLINE
                }
        attachement     as Attachement,
        filename        as Filename,
        @Semantics.mimeType: true
        mimetype        as Mimetype,
        @Semantics.user.createdBy: true
        created_by      as CreatedBy,
        @Semantics.systemDateTime.createdAt: true
        created_at      as CreatedAt,
        @Semantics.user.localInstanceLastChangedBy: true
        last_changed_by as LastChangedBy,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        last_changed_at as LastChangedAt
  }
