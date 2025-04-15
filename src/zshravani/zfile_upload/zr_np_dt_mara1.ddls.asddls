@Metadata.allowExtensions: true

@EndUserText.label: '###GENERATED Core Data Service Entity'

@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZR_NP_DT_MARA1
  provider contract transactional_query
  as projection on znp_dt_mara_r
  {
    key Matnr,
        Mtart,
        Materialstatus,
        Lvorm,
        Attachement,
        Filename,
        Mimetype,
        CreatedBy,
        CreatedAt,
        LastChangedBy,
        LastChangedAt
  }
