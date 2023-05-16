@EndUserText.label: 'Saldos contables'
define table function ZRTR_TF_SALDOS_FLAGB03
  with parameters
    @Environment.systemField: #CLIENT
    p_clnt   : abap.clnt,
    p_ledger : rldnr,
    p_bukrs  : bukrs,
    p_gjahr  : gjahr
returns
{
  rclnt           : abap.clnt;
  rldnr           : fins_ledger;
  RBUKRS          : bukrs;
  RACCT           : racct;
  PRCTR           : prctr;
  SEGMENT         : fb_segment;
  ryear           : gjahr;
  POPER           : poper;
  debe            : hslvt12;
  haber           : hslvt12;
  SALDO           : hslvt12;
  SALDO_acumulado : hslvt12;
  rtcur           : waers;
}
implemented by method
  zcl_amdp_i_saldos_contables=>get_saldos_acum;
