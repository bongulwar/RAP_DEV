@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Doc Att to Spec.'
@Metadata.allowExtensions: true
define root view entity ZC_DOC_ATT
  provider contract transactional_query
  as projection on ZI_DOC_ATT
  //  composition of target_data_source_name as _association_name
  {
    key Id,
        Specification,
        DocType,
        StorageCat,
        DocNo,
        Filename,
        Mimetype,
        Attachment,
        Local_Created_By,
        Local_Created_At,
        Local_Last_Changed_By,
        Local_Last_Changed_At,
        Last_Changed_At
        //        _association_name // Make association public
  }
