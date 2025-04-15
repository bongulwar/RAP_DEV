@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Parent Node'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity zsac_i_po_header
  as select from I_PurchaseOrderAPI01
//  composition [0..*] of zsac_i_po_item  as _POitem
  association to parent zsac_r_po_query as _query on $projection.PurchaseOrder = _query.PurchaseOrder
{
      @UI.facet: [{ id: 'PO_Header',
                    type: #IDENTIFICATION_REFERENCE,
                    label: 'PO Header',
                    purpose: #STANDARD,
                    position: 10
                  }
//                 ,{ id: 'PO_Item',
//                    type: #LINEITEM_REFERENCE,
//                    label: 'PO Item Label',
//                    purpose: #STANDARD,
//                    position: 20,
//                    targetElement: '_POitem'
//                  }
                  ]
      @UI: { lineItem:       [{ position: 10, label: 'PurchaseOrder' }],
             identification: [{ position: 10, label: 'PurchaseOrder' }] }
  key PurchaseOrder,
      @UI: { lineItem:       [{ position: 20, label: 'PurchaseOrderType' }],
             identification: [{ position: 20, label: 'PurchaseOrderType' }] }

      PurchaseOrderType,
      @UI: { lineItem:       [{ position: 30, label: 'CreationDate' }],
             identification: [{ position: 30, label: 'CreationDate' }] }
      CreationDate,
      @UI: { lineItem:       [{ position: 40, label: 'PurchaseOrderDate' }],
             identification: [{ position: 50, label: 'PurchaseOrderDate' }] }
      PurchaseOrderDate,
      @UI: { lineItem:       [{ position: 60, label: 'PurchaseOrderDate' }],
             identification: [{ position: 60, label: 'PurchaseOrderDate' }] }
      PaymentTerms,
      _query
//      _POitem
}
