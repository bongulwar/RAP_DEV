@EndUserText.label: 'Custom Entiy- returen PDF for PO'
@ObjectModel.query.implementedBy: 'ABAP:ZSAC_CL_PO_PDF'
define custom entity ZSAC_I_PO_PDF
  with parameters
    P_PURCHASEORDER : ebeln
{
  key PDF : abap.string(0);

}
