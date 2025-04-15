@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Node'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zsac_i_po_item
  as select from I_PurchaseOrderItemAPI01
  association to parent zsac_i_po_header as _POheader on $projection.PurchaseOrder = _POheader.PurchaseOrder
{
      @UI.facet:[{
                  id: 'PO_Item',
                  type: #IDENTIFICATION_REFERENCE,
                  label: 'PO Item',
                  purpose: #STANDARD,
                  position: 10
                 }]

      @UI: { lineItem:       [{ position: 10, label: 'PO NO.' }],
             identification: [{ position: 10, label: 'PO No.' }] }
  key PurchaseOrder,
      @UI: { lineItem:       [{ position: 20, label: 'PO NO.' }],
             identification: [{ position: 20, label: 'PO No.' }] }
  key PurchaseOrderItem,
      @UI: { lineItem:       [{ position: 30, label: 'PO NO.' }],
             identification: [{ position: 30, label: 'PO No.' }] }
      Material,
      @UI: { lineItem:       [{ position: 40, label: 'PO NO.' }],
             identification: [{ position: 40, label: 'PO No.' }] }
      MaterialGroup,

      _POheader
}
