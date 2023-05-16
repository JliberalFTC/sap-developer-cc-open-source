@AbapCatalog.sqlViewName: 'ZCDSV_HYP001'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cuenta balance - Saldos contables'
define view ZCDS_C_HYP001
  with parameters
    @Consumption.defaultValue: '0L'
    p_ledger : rldnr,
    p_bukrs  : bukrs,
    p_gjahr  : gjahr
  as select from    zcot015_1 as a
    left outer join ZCDS_RTR_SALDOS_ACUMULADOS

                    (
                    p_ledger  : $parameters.p_ledger,
                    p_bukrs   : $parameters.p_bukrs,
                    p_gjahr   : $parameters.p_gjahr
                    )         as b on  b.POPER = a.poper
                                   and b.RACCT = a.racct
                                   and b.PRCTR = a.prctr
{
  a.rbukrs,
  a.gjahr,
  a.racct,
  a.prctr,
  a.poper,
  a.skat_desc,
  a.rfarea,
  a.fkbtx,
  a.aufnr,
  a.aufk_desc,
  a.cepct_desc,
  a.rcntr,
  a.cskt_desc,
  a.ps_posid,
  a.prps_post1,
  a.accasty,
  a.co_accasty_n1,
  a.obj_costo_real,
  a.obj_costo_real_des,
  a.obj_costo_estad,
  a.obj_costo_estad_des,
  a.paval,
  a.butxt,
  a.segment,
  a.khinr,
  a.campo1,
  a.campo2,
  a.campo3,
  b.SALDO_acumulado  as Campo4,
  sum(a.imp_debito)  as Imp_Debito,
  sum(a.imp_credito) as Imp_Credito,
  sum(a.saldo)       as Saldo,
  waers              as Waers,
  a.negocio,
  a.xbilk,
  a.glaccount_type,
  a.rrcty
}

group by
  a.rbukrs,
  a.gjahr,
  a.racct,
  a.prctr,
  a.poper,
  a.skat_desc,
  a.rfarea,
  a.fkbtx,
  a.aufnr,
  a.aufk_desc,
  a.cepct_desc,
  a.rcntr,
  a.cskt_desc,
  a.ps_posid,
  a.prps_post1,
  a.accasty,
  a.co_accasty_n1,
  a.obj_costo_real,
  a.obj_costo_real_des,
  a.obj_costo_estad,
  a.obj_costo_estad_des,
  a.paval,
  a.butxt,
  a.segment,
  a.khinr,
  a.campo1,
  a.campo2,
  a.campo3,
  a.waers,
  a.negocio,
  b.SALDO_acumulado,
  a.xbilk,
  a.glaccount_type,
  a.rrcty
