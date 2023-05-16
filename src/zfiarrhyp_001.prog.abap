*&---------------------------------------------------------------------*
*& Report ZFIARRHYP_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfiarrhyp_001.

DATA: lv_zcot015 TYPE zcot015.
DATA: wl_mensaje2 TYPE char50.

PARAMETERS: p_ledger TYPE rldnr DEFAULT '0L',
            p_erdat  TYPE erdat,
            p_bukrs  TYPE bukrs,
            p_gjahr  TYPE gjahr,
            p_poper  TYPE poper.


START-OF-SELECTION.
  AUTHORITY-CHECK OBJECT 'J_B_BUKRS'
   ID 'BUKRS' FIELD p_bukrs.
  IF sy-subrc <> 0.
    CONCATENATE wl_mensaje2 p_bukrs  INTO wl_mensaje2 SEPARATED BY ','.
  ELSE.
    SELECT FROM zrtrh_tf_cb_sc_hyperion01(
                                      p_ledger   = @p_ledger,
                                      p_bukrs    = @p_bukrs,
                                      p_gjahr    = @p_gjahr,
                                      p_poper    = @p_poper,
                                      p_erdat    = @p_erdat,
                                      p_langu   = @sy-langu
                                           )
      FIELDS
  erdat,
  rbukrs,
  gjahr,
  racct,
  prctr,
  poper,
  skat_desc,
  rfarea,
  fkbtx,
  aufnr,
  aufk_desc,
  cepct_desc,
  cskt_desc,
  ps_posid,
  prps_post1,
  accasty,
  co_accasty_n1,
  obj_costo_real,
  obj_costo_real_des,
  obj_costo_estad,
  obj_costo_estad_des,
  paval,
  butxt,
  segment,
  khinr,
  campo1,
  campo2,
  campo3,
  campo4,
  imp_debito,
  imp_credito,
  saldo,
  waers,
  negocio,
  lstar
     INTO  TABLE @DATA(lt_data)  .
    IF sy-subrc EQ 0.
      LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
        MOVE-CORRESPONDING <fs_data> TO lv_zcot015.
        lv_zcot015-mandt = sy-mandt.
        MODIFY zcot015  FROM lv_zcot015.
      ENDLOOP.
    ENDIF.
  ENDIF.

END-OF-SELECTION.
