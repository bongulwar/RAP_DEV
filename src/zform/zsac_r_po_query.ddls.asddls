@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Note'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zsac_r_po_query
  as select from I_PurchaseOrderAPI01
  composition [1..1] of zsac_i_po_header as _POheader
{
      @UI.facet: [{
          id: 'Root_Node',
          purpose: #STANDARD,
          label: 'Root Node',
          type: #IDENTIFICATION_REFERENCE,
          position: 10
      },
      {
        id: 'PO_Header',
        label: 'PO List',
        purpose: #STANDARD,
        type: #LINEITEM_REFERENCE,
        targetElement: '_POheader',
        position: 20
      }
      ]

      @UI: { lineItem:       [{ position: 10, label: 'PO NO.' }],
             identification: [{ position: 10, label: 'PO No.' }] }
  key PurchaseOrder,
      _POheader // Make association public
}
