@AbapCatalog.sqlViewName: 'ZCDSV_SLD_ACUM'
@EndUserText.label: 'Saldos contables Acumulados'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@Analytics: { dataCategory: #CUBE, dataExtraction.enabled: true }
@VDM.viewType: #COMPOSITE
@ObjectModel.representativeKey: ['RBKURS','GJAHR', 'RACCT' ]
define view ZCDS_RTR_SALDOS_ACUMULADOS
  with parameters
    @Consumption.defaultValue: '0L'
    p_ledger : rldnr,
    p_bukrs  : bukrs,
    p_gjahr  : gjahr


  as select from ZRTR_TF_SALDOS_FLAGB03( p_clnt : $session.client,
                                         p_ledger   : $parameters.p_ledger,
                                        p_bukrs       : $parameters.p_bukrs,
                                        p_gjahr       : $parameters.p_gjahr
                                      )
  association [1..1] to I_CompanyCode            as _CompanyCode            on  $projection.RBUKRS = _CompanyCode.CompanyCode

  //SKB1
  association [0..1] to I_GLAccountInCompanyCode as _GLAccountInCompanyCode on  $projection.RBUKRS = _GLAccountInCompanyCode.CompanyCode
                                                                            and $projection.RACCT  = _GLAccountInCompanyCode.GLAccount

{
  key rldnr,
      @EndUserText.label: 'Sociedad'
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key RBUKRS,
      @EndUserText.label: 'Cuenta Mayor'
      @ObjectModel.foreignKey.association: '_GLAccountInCompanyCode'
  key RACCT,
      @EndUserText.label:'Centro Costo'
      PRCTR,
      @EndUserText.label: 'Segmento'
      SEGMENT,
      @EndUserText.label: 'Año'
      ryear,
      @EndUserText.label: 'Mes'
      POPER,
      @EndUserText.label: 'Saldo Debe'
      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'rtcur'
      debe,
      @EndUserText.label: 'Saldo Haber'
      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'rtcur'
      haber,
      @EndUserText.label: 'Saldo'
      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'rtcur'
      SALDO,
      @EndUserText.label: 'Saldo Acumulado'
      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'rtcur'
      SALDO_acumulado,
      @Semantics.currencyCode: 'true'
      rtcur,
      // Relaciones
      _CompanyCode,
      _GLAccountInCompanyCode

}
