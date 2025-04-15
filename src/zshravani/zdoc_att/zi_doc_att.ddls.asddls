@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view - DOC ATT'
//@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_DOC_ATT
  as select from zvc_docatt
  //composition of target_data_source_name as _association_name
  {
    key id                    as Id,

        @EndUserText.label: 'Specification Number'
        specification         as Specification,

        @EndUserText.label: 'Doc Type'
        doc_type              as DocType,
        @EndUserText.label: 'Storage Catagory'
        storage_cat           as StorageCat,

        @EndUserText.label: 'Document Number'
        doc_no                as DocNo,
        @EndUserText.label: 'File Name'
        filename              as Filename,

        @Semantics.mimeType: true
        @EndUserText.label: 'Mime Type'
        mimetype              as Mimetype,

        @EndUserText.label: 'Attachment File Content'
        @Semantics.largeObject:{
                 mimeType: 'Mimetype',
                 fileName: 'Filename',
                 //      acceptableMimeTypes: [ 'xlsx' ],
                 contentDispositionPreference: #INLINE }
        attachment            as Attachment,
        @Semantics.user.createdBy: true
        local_created_by      as Local_Created_By,
        @Semantics.systemDateTime.createdAt: true
        local_created_at      as Local_Created_At,
        @Semantics.user.lastChangedBy: true
        local_last_changed_by as Local_Last_Changed_By,
        //local ETag field --> OData ETag
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        local_last_changed_at as Local_Last_Changed_At,
        //total ETag field
        @Semantics.systemDateTime.lastChangedAt: true
        last_changed_at       as Last_Changed_At
  }
