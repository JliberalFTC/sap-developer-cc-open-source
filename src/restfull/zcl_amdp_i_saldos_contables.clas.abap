CLASS zcl_amdp_i_saldos_contables DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
      INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_saldos_acum  FOR TABLE FUNCTION ZRTR_TF_SALDOS_FLAGB03.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_i_saldos_contables IMPLEMENTATION.
  METHOD get_saldos_acum BY DATABASE FUNCTION FOR HDB
                     LANGUAGE SQLSCRIPT OPTIONS READ-ONLY
                     USING fglv_faglflexa fglv_faglflext.

     lt_saldo_det =  select
    fl.rclnt,
    fl.rldnr,
    fl.rbukrs,
    fl.ryear,
    fl.poper,
    fl.racct,
    fl.prctr,
    fl.segment,
    case when fl.drcrk  = 'S' THEN sum( fl.hsl )
    else 0
    end as debe,
    case when fl.drcrk  = 'H' THEN sum( fl.hsl )
    else 0
    end as haber

    from fglv_faglflexa as fl
    where  fl.rclnt = :p_clnt
    and    fl.rldnr = :p_ledger
    and fl.poper > 00 and fl.poper < 13
    and    ryear = :p_gjahr
    and    rbukrs = :p_bukrs
    group by fl.rclnt,fl.rldnr,fl.rbukrs,fl.ryear,fl.poper,fl.racct,fl.prctr,fl.segment,fl.drcrk
    order by fl.racct,fl.ryear,fl.poper
    ;

 lt_saldo2 = select
    rclnt,
    rldnr,
    rbukrs,
    ryear,
    poper,
    racct,
    prctr,
    segment,
--    rtcur,
    sum(debe) as debe,
    sum(haber) as haber,
    sum( debe + haber ) as saldo,
    0 as saldo_acum
    from :lt_saldo_det
    where rbukrs = :p_bukrs
    and rldnr  = :p_ledger
    group by rclnt,rldnr,rbukrs,ryear,poper,racct,prctr,segment
    order BY racct,ryear,poper
    ;

lt_acum2 = select sld.rclnt,sld.rldnr,sld.rbukrs,sld.racct,sld.prctr,sld.segment,sld.ryear,sld.poper,sld.debe,sld.haber,sld.saldo,
case
 when sld.poper = '000' then sum(fg.hslvt )
 when sld.poper = '001' then sum(fg.hslvt ) + sum( fg.hsl01 )
 when sld.poper = '002' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 )
 when sld.poper = '003' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 )
 when sld.poper = '004' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 )
 when sld.poper = '005' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 )
 when sld.poper = '006' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 )
 when sld.poper = '007' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 )
 when sld.poper = '008' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 )
 when sld.poper = '009' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
 when sld.poper = '010' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
 + sum( fg.hsl10 )
 when sld.poper = '011' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
 + sum( fg.hsl10 ) +  sum( fg.hsl11 )
 when sld.poper = '012' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
 + sum( fg.hsl10 ) +  sum( fg.hsl11 ) +  sum( fg.hsl12 )
 else 0
end as saldo_acumulado,
fg.rtcur
from :lt_saldo2 as sld
inner join fglv_faglflext fg on fg.rbukrs = :p_bukrs
                             and fg.ryear = :p_gjahr
                             and fg.racct  = sld.racct
                             and fg.rldnr  = :p_ledger
group by sld.rclnt,sld.rldnr,sld.ryear,sld.poper,sld.rbukrs,sld.racct,sld.prctr,sld.segment,sld.debe,sld.haber,sld.saldo,fg.rtcur
;

return select *

from :lt_acum2
;
  ENDMETHOD.
ENDCLASS.
