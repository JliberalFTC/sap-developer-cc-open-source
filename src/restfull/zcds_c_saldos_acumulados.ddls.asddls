@AbapCatalog.sqlViewName: 'ZCDSCSLD_CONT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Saldos contables acumulado'
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
@ClientHandling.algorithm: #SESSION_VARIABLE
@AbapCatalog.buffering.status: #NOT_ALLOWED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType.sizeCategory: #XXL
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.dataClass: #MIXED
@OData: {
    publish: true
}
define view ZCDS_C_SALDOS_ACUMULADOS
  with parameters
    @Consumption.defaultValue: '0L'
    p_ledger : rldnr,
    p_bukrs  : bukrs,
    p_gjahr  : gjahr
  as select from ZCDS_RTR_SALDOS_ACUMULADOS(
                                             p_ledger   : $parameters.p_ledger,
                                             p_bukrs       : $parameters.p_bukrs,
                                             p_gjahr       : $parameters.p_gjahr
                                        )

{
  rldnr,
  @EndUserText.label: 'Sociedad'
  @AnalyticsDetails.query.display: #KEY_TEXT
  @AnalyticsDetails.query.axis: #ROWS
  RBUKRS,
  @AnalyticsDetails.query.axis: #ROWS
  @EndUserText.label: 'Cuenta Contable'
  @AnalyticsDetails.query.display: #KEY_TEXT
  RACCT,
  @AnalyticsDetails.query.axis: #ROWS
  @EndUserText.label: 'Centro Costo'
  PRCTR,
  @AnalyticsDetails.query.axis: #ROWS
  @EndUserText.label: 'Segmento'
  SEGMENT,
  @AnalyticsDetails.query.axis: #ROWS
  @EndUserText.label: 'Ejercicio'
  ryear,
  @AnalyticsDetails.query.axis: #ROWS
  @EndUserText.label: 'Período'
  POPER,
  @EndUserText.label: 'Debe'
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'rtcur'
  debe,
  @EndUserText.label: 'Haber'
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'rtcur'
  haber,
  @EndUserText.label: 'Saldo'
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'rtcur'
  SALDO,
  @EndUserText.label: 'Saldo acumulado'
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'rtcur'
  SALDO_acumulado,
  @EndUserText.label: 'Moneda'
  @Semantics.currencyCode: 'true'
  rtcur

}
