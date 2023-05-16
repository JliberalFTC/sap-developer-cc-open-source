@AbapCatalog.sqlViewName: 'ZCDSVFAGLFLEXT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Busca data por fecha creacion registro'
define view ZCDS_FGLV_FAGLFLEXT
  as select from fglv_faglflext as fg
{
  fg.rclnt,
  fg.rldnr                                        as Rldnr,
  fg.rbukrs                                       as Rbukrs,
  fg.ryear                                        as Ryear,
  fg.racct,
  cast( substring( cast( fg.timestamp
        as abap.char(17) ), 1, 8 ) as abap.dats ) as erdat,
  fg.prctr                                        as Prctr,
  fg.segment                                      as Segment,
  fg.hslvt,
  fg.hsl01,
  fg.hsl02,
  fg.hsl03,
  fg.hsl04,
  fg.hsl05,
  fg.hsl06,
  fg.hsl07,
  fg.hsl08,
  fg.hsl09,
  fg.hsl10,
  fg.hsl11,
  fg.hsl12
}
