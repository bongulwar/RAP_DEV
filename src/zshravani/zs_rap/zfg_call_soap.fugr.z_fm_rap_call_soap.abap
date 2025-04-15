FUNCTION z_fm_rap_call_soap.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_DATA) TYPE  ZAPI_INV_H
*"  EXPORTING
*"     VALUE(E_DATA) TYPE  ZAPI_INV_H
*"----------------------------------------------------------------------
  "------ Source Code ------
  DATA(lr_API) = NEW ycl_call_post_api( ).
  DATA: im_data TYPE zapi_inv_h,
        e_msg   TYPE ycl_call_post_api=>e_msg.

  lr_API->post_invoice_save(
    EXPORTING
      i_data = i_data
    IMPORTING
      e_msg  = e_msg
  ).

ENDFUNCTION.
