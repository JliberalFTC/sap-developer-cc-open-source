@AbapCatalog.sqlViewName: 'ZCDSVFAGLFLEXA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Busca data por fecha creacion registro'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE

define view ZCDS_FGLV_FAGLFLEXA
  as select from fglv_faglflexa
{
  key rclnt,
  key rldnr                                       as Rldnr,
  key rbukrs                                      as Rbukrs,
  key ryear                                       as Ryear,
  key poper                                       as Poper,
  key racct,
  key cast( substring( cast( timestamp
        as abap.char(17) ), 1, 8 ) as abap.dats ) as erdat,
      prctr                                       as Prctr,
      segment                                     as Segment,
      case when drcrk  = 'S' then sum( hsl )
      else 0
      end                                         as debe,
      case when drcrk  = 'H' then sum( hsl )
      else 0
      end                                         as haber,
      sum( hsl )                                  as saldo
}
--where
--  rclnt = $session.client
group by
  rldnr,
  rbukrs,
  ryear,
  poper,
  racct,
  prctr,
  segment,
  drcrk,
  timestamp
