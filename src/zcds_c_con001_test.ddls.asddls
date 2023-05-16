@AbapCatalog.sqlViewName: 'ZCDSCCONTEST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@Metadata.allowExtensions: true
@OData.publish: true
@EndUserText.label: 'CON001: Asientos manuales'
--@Analytics.query: true
@AccessControl.authorizationCheck: #CHECK
@VDM.viewType: #CONSUMPTION
//@ClientHandling.algorithm: #SESSION_VARIABLE
//@AbapCatalog.buffering.status: #NOT_ALLOWED
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType.sizeCategory: #XXL
//@ObjectModel.usageType.serviceQuality: #D
//@ObjectModel.usageType.dataClass: #MIXED


define view ZCDS_C_CON001_TEST 
  with parameters
    @Consumption.defaultValue: '0L'
    p_ledger : rldnr,
--    p_bukrs  : bukrs,
    p_gjahr  : gjahr,
    p_poper_l : poper,
    p_poper_h : poper

as select from ZCDS_I_CONS_REPORT_DET( p_ledger   : $parameters.p_ledger,
 --                                    p_bukrs    : $parameters.p_bukrs,
                                     p_gjahr    : $parameters.p_gjahr,
                                     p_poper_l    : $parameters.p_poper_l,   
                                     p_poper_h    : $parameters.p_poper_h                                                                         
                                     )



  association [1..1] to P_BKPF_COM                   as _DocHeader                  on  $projection.rbukrs = _DocHeader.bukrs
                                                                                    and $projection.gjahr  = _DocHeader.gjahr
                                                                                    and $projection.belnr  = _DocHeader.belnr
                                                                                                                                                                 
  association [1..1] to I_AccountingDocumentType     as _AccountingDocumentType     on  $projection.blart = _AccountingDocumentType.AccountingDocumentType
  association [1..1] to I_Ledger                     as _Ledger                     on  $projection.rldnr = _Ledger.Ledger
  association [1..1] to I_CompanyCode                as _CompanyCode                on  $projection.rbukrs = _CompanyCode.CompanyCode

  //SKA1
  association [1..1] to I_GLAccountInChartOfAccounts as _GLAccountInChartOfAccounts on  $projection.ktopl = _GLAccountInChartOfAccounts.ChartOfAccounts
                                                                                    and $projection.racct = _GLAccountInChartOfAccounts.GLAccount
  //SKB1                                                                                  
  association [0..1] to I_GLAccountInCompanyCode     as  _GLAccountInCompanyCode    on  $projection.rbukrs = _GLAccountInCompanyCode.CompanyCode
                                                                                    and $projection.racct = _GLAccountInCompanyCode.GLAccount
  
  association [0..*] to I_CostCenter                 as _CostCenter                 on  $projection.ControllingArea = _CostCenter.ControllingArea
                                                                                    and $projection.CostCenter = _CostCenter.CostCenter

  association [0..*] to I_ProfitCenter               as _ProfitCenter               on  $projection.ControllingArea = _ProfitCenter.ControllingArea
                                                                                    and $projection.ProfitCenter = _ProfitCenter.ProfitCenter

  association [0..1] to I_Supplier                   as _Supplier                   on  $projection.Proveedor = _Supplier.Supplier
  association [0..1] to I_Customer                   as _Customer                   on  $projection.Cliente = _Customer.Customer
--  association [0..1] to ZCDS_DIAS_HABILES            as _DiasHabiles                on  $projection.gjahr = _DiasHabiles.yearactual
--                                                                                   and  $projection.poper = _DiasHabiles.monthactual
--                                                                                   and  $projection.land1 = _DiasHabiles.land
                                                                                  
                                                                                                                                                             
{

      //
--      @EndUserText.label: 'Ledger'
      @ObjectModel.foreignKey.association: '_Ledger'
  key rldnr,
 --     @EndUserText.label: 'Sociedad'
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key rbukrs,
 --     @EndUserText.label: 'Ejercicio'
      @Semantics.fiscal.year: true
  key gjahr,
 --     @EndUserText.label: 'Período'
      @Semantics.fiscal.period: true
      poper,
 --     @EndUserText.label: 'Nro. Documento'
      belnr,
      docln,
--      @EndUserText.label: 'Operación de referencia'
      _DocHeader.awtyp                         as ReferenceProcedure,
--      @EndUserText.label: 'Clave de referencia'
      _DocHeader.awkey                         as ObjectKey,
      _DocHeader.tcode                         as CodigoTransaccion,
--      @EndUserText.label: 'Texto cabecera'
      _DocHeader.bktxt,
--      @EndUserText.label: 'Longitud Texto cabecera'
      length(_DocHeader.bktxt)                 as LengthHeaderText,
--      @EndUserText.label: 'Clase Documento'
      @ObjectModel.foreignKey.association: '_AccountingDocumentType'
      _DocHeader.blart,
--      @EndUserText.label: 'Fecha Creación'
      _DocHeader.bldat,
--      @EndUserText.label: 'Fecha Contabilización'
      _DocHeader.budat,
--      @EndUserText.label: 'Fecha Registro'
      cpudt,
--      @EndUserText.label: 'Hora Registro'
       cputm,
--      @EndUserText.label: 'Usuario registra'
      _DocHeader.usnam,
--      @EndUserText.label: 'Usuario aprueba'
      _DocHeader.ppnam,
--      @EndUserText.label: 'Longitud Texto posición'
      length(sgtxt)                            as LengthItemText,
--      @EndUserText.label: 'Texto de posición'
      sgtxt,
--      @EndUserText.label: 'Plan de Cuentas'
      @ObjectModel.foreignKey.association: '_GLAccountInChartOfAccounts'
      ktopl,
--      @EndUserText.label: 'Cuenta Contable'
--      @ObjectModel.foreignKey.association: '_GLAccountInChartOfAccounts'
      @ObjectModel.foreignKey.association: '_GLAccountInCompanyCode'
      racct,
      _GLAccountInCompanyCode.CreationDate as AccountCreationDate,
      dats_days_between(_GLAccountInCompanyCode.CreationDate, PresentDay) as DaysOfGLAccount, 

      TipoDeCuenta,
      @EndUserText.label: 'Nombre cl. de cuenta'
      case TipoDeCuenta
         when 'A' then 'Activos fijos'
         when 'D' then 'Deudores'
         when 'K' then 'Acreedores'
         when 'M' then 'Material'
         when 'S' then 'Cuentas de mayor'
         else ''
       end                                     as TextoTipoDeCuenta,

--      @EndUserText.label: 'Sociedad CO'
            @ObjectModel.foreignKey.association: '_CostCenter'
      kokrs                                    as ControllingArea,
--      @EndUserText.label: 'Centro Costo'
      @ObjectModel.foreignKey.association: '_CostCenter'
      rcntr                                    as CostCenter,
--      @EndUserText.label: 'Centro Beneficio'
      @ObjectModel.foreignKey.association: '_ProfitCenter'
      prctr                                    as ProfitCenter,

--      @EndUserText.label: 'Moneda'
      @Semantics.currencyCode: 'true'
      rtcur,
      //Medidas
      --  @EndUserText.label: 'Total Transacciones!'
      --  @DefaultAggregation: #SUM
      --  numberoftransactions,

--      @EndUserText.label: 'Total Debe'
--      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'rtcur'
      montotransacsaldodebe,

--      @EndUserText.label: 'Total Haber'
--      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'rtcur'
      montotransacsaldohaber,

--      @EndUserText.label: 'Moneda Sociedad'
      @Semantics.currencyCode: 'true'
      MonedaSociedad,

      //Medidas
      --  @EndUserText.label: 'Total Transacciones!'
      --  @DefaultAggregation: #SUM
      --  numberoftransactions,

--      @EndUserText.label: 'Saldo Debe'
--      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'MonedaSociedad'
      SaldoSociedadDebe,

--      @EndUserText.label: 'Saldo Haber'
--      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'MonedaSociedad'
      SaldoSociedadHaber,

--      @EndUserText.label: 'Saldo Acumulado'
--      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'MonedaSociedad'
      SaldoAcumuladoSociedad,

      OrdenDeCompra,

      @ObjectModel.foreignKey.association: '_Supplier'
      Proveedor,
      @ObjectModel.foreignKey.association: '_Customer'
      Cliente,
--      @EndUserText.label: 'Fecha compensación'      
      FechaCompensacion,
--      @EndUserText.label: 'Org. de anulación'
      OrganizacionAnulacion,
--      @EndUserText.label: 'Ref. de anulación'
      ReferenciaAnulacion,
--      @EndUserText.label: 'Ind. de anulación'
      IndicadorAnulacion,

--      _Calendar.calendardate as CalendarDate,
--      _Calendar.flag as CalendarDateFlag,
      
//      case when _DocHeader.usnam = _DocHeader.ppnam then '1' 
//       else '0'
//       end as SameUser,
//
//       case when cpudt > _DocHeader.budat then '1' 
//       else '0'
//      end as cpudt_gt_budat,
 
       land1,
--       case when cpudt > _DiasHabiles( p_dia:'05').calendardate then '1' 
--       else '0'
--       end as cpudt_gt_5todiahabil,        

      //Relaciones
      _Ledger,
      _DocHeader,
      _AccountingDocumentType,
      _CompanyCode,
      _GLAccountInChartOfAccounts,
      _GLAccountInCompanyCode,
      _CostCenter,
      _ProfitCenter,
      //_Calendar,
      _Supplier,
      _Customer
--      _DiasHabiles
}
