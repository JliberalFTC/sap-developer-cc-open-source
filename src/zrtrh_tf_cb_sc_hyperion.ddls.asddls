@EndUserText.label: 'Cuenta Balance - Saldos Contables'
define table function ZRTRH_TF_CB_SC_HYPERION
  with parameters
    @Environment.systemField: #CLIENT
    p_clnt   : abap.clnt,
    p_ledger : rldnr,
    p_bukrs  : bukrs,
    p_gjahr  : gjahr,
    p_poper  : poper,
    p_erdat  : erdat,
    @Environment.systemField:#SYSTEM_LANGUAGE
    p_langu  : spras
returns

{
  rclnt               : abap.clnt;
  rldnr               : fins_ledger;
  erdat               : erdat;
  RACCT               : racct;
  SKAT_DESC           : txt50_skat;
  RFAREA              : fkber;
  FKBTX               : fkbtx;
  AUFNR               : aufnr;
  AUFK_DESC           : auftext;
  POPER               : poper;
  GJAHR               : gjahr;
  PRCTR               : prctr;
  CEPCT_DESC          : ltext;
  RCNTR               : kostl;
  CSKT_DESC           : ltext;
  PS_POSID            : ps_posid;
  PRPS_POST1          : ps_post1;
  ACCASTY             : j_obart;
  CO_ACCASTY_N1       : fins_accasty_n1;
  OBJ_COSTO_REAL      : abap.char( 60 );
  OBJ_COSTO_REAL_DES  : abap.char( 60 );
  OBJ_COSTO_ESTAD     : abap.char( 60 );
  OBJ_COSTO_ESTAD_DES : abap.char( 60 );
  RBUKRS              : bukrs;
  PAVAL               : paval;
  BUTXT               : butxt;
  SEGMENT             : fb_segment;
  KHINR               : phinr;
  CAMPO1              : abap.char(12);
  CAMPO2              : abap.char(1);
  CAMPO3              : abap.char(1);
  CAMPO4              : hslvt12;
  IMP_DEBITO          : hslvt12;
  IMP_CREDITO         : hslvt12;
  SALDO               : hslvt12;
  WAERS               : waers;
  NEGOCIO             : zperges;
  LSTAR               : lstar;
}
implemented by method
  zcl_amdp_i_hyperion=>get_cb_sc;
