CLASS zcl_amdp_i_hyperion DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_cb_sc  FOR TABLE FUNCTION zrtrh_tf_cb_sc_hyperion.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_i_hyperion IMPLEMENTATION.
  METHOD get_cb_sc BY DATABASE FUNCTION FOR HDB
                     LANGUAGE SQLSCRIPT OPTIONS READ-ONLY


                     USING zotct009 skat t001
*                     fglv_faglflexa
*fglv_faglflext
                     cepct cepc cskt t001z  skb1
                     zcdsvfaglflexa zcdsvfaglflext.

    lt_negocio = select * from  zotct009       AS dir   WHERE  dir.id_directorio = 'SD'
                                                        and    dir.bukrs         = :p_bukrs

;
*    lt_saldo_det =  select
*    fl.rclnt,
*    fl.rldnr,
*    fl.rbukrs,
*    fl.ryear,
*    fl.poper,
*    fl.racct,
*    fl.prctr,
*    fl.segment,
*    case when fl.drcrk  = 'S' THEN sum( fl.hsl )
*    else 0
*    end as debe,
*    case when fl.drcrk  = 'H' THEN sum( fl.hsl )
*    else 0
*    end as haber,
*    fl.TIMESTAMP
*    from fglv_faglflexa as fl
*    where  fl.rclnt = :p_clnt
*    and    fl.rldnr = :p_ledger
*    and fl.poper > 00 and fl.poper < 13
*--    and    racct  = '1041110007'
*    and    fl.ryear = :p_gjahr
*    and    fl.rbukrs = :p_bukrs
*    and    fl.poper  = :p_poper
*    group by fl.rclnt,fl.rldnr,fl.rbukrs,fl.ryear,fl.poper,fl.racct,fl.prctr,fl.segment,fl.drcrk,fl.TIMESTAMP
*    order by fl.racct,fl.ryear,fl.poper
*    ;

lt_saldo_ini = SELECT
    rclnt,
    rldnr,
    erdat,
    rbukrs,
    ryear,
    '001' as poper,
    racct,
    prctr,
    segment,
    sum(debe) as debe,
    sum(haber) as haber,
    sum( saldo ) as saldo
    from zcdsvfaglflexa
    where rbukrs = :p_bukrs
*    and erdat = :p_erdat
*    and racct  = '1041110007'
    and rldnr  = :p_ledger
    and ryear = :p_gjahr
    and poper  = '000'
    group by rclnt,rldnr,erdat,rbukrs,ryear,poper,racct,prctr,segment
    order BY racct,ryear,poper
    ;

lt_saldo = SELECT
    rclnt,
    rldnr,
    erdat,
    rbukrs,
    ryear,
    poper,
    racct,
    prctr,
    segment,
    sum(debe) as debe,
    sum(haber) as haber,
    sum( saldo ) as saldo,
    0 as saldo_acum
    from zcdsvfaglflexa
    where rbukrs = :p_bukrs
    and erdat = :p_erdat
    and racct  = '1041110007'
    and rldnr  = :p_ledger
    and ryear = :p_gjahr
    and poper  = :p_poper
    group by rclnt,rldnr,erdat,rbukrs,ryear,poper,racct,prctr,segment
    order BY racct,ryear,poper
    ;


lt_acum = SELECT sld.rclnt,sld.rldnr,sld.poper,sld.erdat,sld.rbukrs,sld.ryear,sld.racct,sld.prctr,sld.segment,sld.debe,sld.haber,sld.saldo,
CASE
* when sld.poper = '000' then sum( fg.hslvt )
 when sld.poper = '001' then sum( n.saldo ) + sum( fg.hsl01 )
 when sld.poper = '002' then  sum( fg.hsl01 ) + sum( fg.hsl02 )
 when sld.poper = '003' then  sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 )
 when sld.poper = '004' then  sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 )
 when sld.poper = '005' then  sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 )
 when sld.poper = '006' then  sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 )
 when sld.poper = '007' then  sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 )
 when sld.poper = '008' then  sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 )
 when sld.poper = '009' then  sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
 when sld.poper = '010' then  sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
 + sum( fg.hsl10 )
 when sld.poper = '011' then  sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
 + sum( fg.hsl10 ) +  sum( fg.hsl11 )
 when sld.poper = '012' then  sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
 + sum( fg.hsl10 ) +  sum( fg.hsl11 ) +  sum( fg.hsl12 )
 else 0
end as acum
from :lt_saldo as sld
inner join zcdsvfaglflext fg on fg.erdat    = :p_erdat
                             and fg.rbukrs  = :p_bukrs
                             and fg.ryear   = :p_gjahr
                             and fg.racct   = sld.racct
                             and fg.prctr   = sld.prctr
                             and fg.segment = sld.segment
                             and fg.rldnr   = :p_ledger
left outer join :lt_saldo_ini n on n.rbukrs  = :p_bukrs
                             and n.ryear   = :p_gjahr
                             and n.poper   = sld.poper
                             and n.racct   = sld.racct
                             and n.prctr   = sld.prctr
                             and n.segment = sld.segment
                             and n.rldnr   = :p_ledger

group by sld.rclnt,sld.rldnr,sld.ryear,sld.poper,sld.rbukrs,sld.erdat,sld.racct,sld.prctr,sld.segment,sld.saldo,sld.debe,sld.haber
;


*lt_saldo = select
*    rclnt,
*    rldnr,
*--    negocio,
*    rbukrs,
*    ryear,
*    poper,
*    racct,
*    prctr,
*    segment,
*--    rtcur,
*    sum(debe) as debe,
*    sum(haber) as haber,
*    sum( debe + haber ) as saldo,
*    0 as saldo_acum,
*    TIMESTAMP
*    from :lt_saldo_det
*    where rbukrs = :p_bukrs
*    and rldnr  = :p_ledger
*    group by rclnt,rldnr,rbukrs,ryear,poper,racct,prctr,segment,TIMESTAMP
*    order BY racct,ryear,poper
*    ;

*lt_acum = SELECT sld.rclnt,sld.rldnr,sld.ryear,sld.poper,sld.rbukrs,sld.racct,sld.prctr,sld.segment,sld.debe,sld.haber,sld.saldo,
*CASE
* when sld.poper = '000' then sum(fg.hslvt )
* when sld.poper = '001' then sum(fg.hslvt ) + sum( fg.hsl01 )
* when sld.poper = '002' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 )
* when sld.poper = '003' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 )
* when sld.poper = '004' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 )
* when sld.poper = '005' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 )
* when sld.poper = '006' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 )
* when sld.poper = '007' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 )
* when sld.poper = '008' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 )
* when sld.poper = '009' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
* when sld.poper = '010' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
* + sum( fg.hsl10 )
* when sld.poper = '011' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
* + sum( fg.hsl10 ) +  sum( fg.hsl11 )
* when sld.poper = '012' then sum(fg.hslvt ) + sum( fg.hsl01 ) + sum( fg.hsl02 ) +  sum( fg.hsl03 ) + sum( fg.hsl04 ) + sum( fg.hsl05 ) + sum( fg.hsl06 ) + sum( fg.hsl07 ) + sum( fg.hsl08 ) + sum( fg.hsl09 )
* + sum( fg.hsl10 ) +  sum( fg.hsl11 ) +  sum( fg.hsl12 )
* else 0
*end as acum
*from :lt_saldo as sld
*inner join fglv_faglflext fg on fg.rbukrs = :p_bukrs
*                             and fg.ryear = :p_gjahr
*                             and fg.racct  = sld.racct
*                             and fg.prctr  = sld.prctr
*                             and fg.segment = sld.segment
*                             and fg.rldnr  = :p_ledger
*group by sld.rclnt,sld.rldnr,sld.ryear,sld.poper,sld.rbukrs,sld.racct,sld.prctr,sld.segment,sld.saldo,sld.debe,sld.haber
*;


lt_skb1 = select sk.mandt,sk.bukrs,sk.saknr,sk.erdat,sk.waers,skat.txt50,skat.ktopl
from skb1 as sk
    inner join      skat     on  skat.ktopl   = 'PCOF'
                             and skat.spras = :p_langu
                             and skat.saknr = sk.saknr
                             and skat.mandt = sk.mandt
where sk.bukrs = p_bukrs
*and  sk.saknr = '1041110007'
;
 lt_cepct = SELECT DISTINCT acum.prctr,cep.spras,cep.datbi,cep.kokrs,cep.ltext
 from cepct as cep
 inner join :lt_acum as acum on acum.prctr = cep.prctr
                                          and cep.spras = :p_langu
                                         and cep.datbi >= current_date
                                         and cep.kokrs  = 'SACI'
                                         and cep.mandt = acum.rclnt
 ;
 lt_cskt = select distinct cep.kostl,cep.ltext
 from cskt as cep
 inner join :lt_acum as acum on acum.prctr = cep.kostl
                                          and cep.spras = :p_langu
                                         and cep.datbi >= current_date
                                         and cep.kokrs         = 'SACI'
                                         and cep.mandt = acum.rclnt
;

 lt_cepc = select distinct  cep.prctr,cep.khinr
 from cepc as cep
 inner join :lt_acum as acum on acum.prctr = cep.prctr
                                          and cep.spras = :p_langu
                                         and cep.datbi >= current_date
                                         and cep.kokrs  = 'SACI'
                                         and cep.mandt = acum.rclnt
;

lt_det = select
      sb.mandt as rclnt,
      :p_ledger as rldnr,
      :p_erdat as erdat,
      sb.saknr as racct,
      sb.txt50     as skat_desc,
      m.prctr,
--      CASE
--      when m.prctr is null then 'B.NA'
--      else m.prctr
--      end as prctr,
--      CASE
--      when cep.ltext is null then 'B.NA'
--      else cep.ltext
--      end  as cepct_desc,
      cep.ltext  as cepct_desc,
      '' as rcntr,
      csk.ltext    as cskt_desc,
      '' as ps_posid ,
      '' as prps_post1 ,
      '' as accasty,
      '' as co_accasty_n1,
      '' as obj_costo_real,
      '' as obj_costo_real_des,
      '' as obj_costo_estad,
      '' as obj_costo_estad_des,
--      ska1.xbilk,
--      fa.rrcty,
      CASE
      when m.ryear is null then :p_gjahr
      else  m.ryear
       end     as gjahr,
       CASE
       when m.poper is null then :p_poper
       else m.poper
      end as poper,

      sb.bukrs as rbukrs,
      z.paval,
      t001.butxt,
      m.segment,
      cepc.khinr,
      '' as campo1,
      '' as campo2,
      '' as campo3,
      m.acum as campo4,
      m.debe as imp_debito,
      m.haber as imp_credito,
      m.saldo,
      t001.waers,
      dir.pergestion as negocio,
      '' as  lstar
--      t001.land1,
from :lt_skb1  as sb

    inner join      :lt_negocio       as dir      ON  dir.bukrs  = sb.bukrs

    inner join t001z as z on z.bukrs = :p_bukrs

    left outer join  :lt_acum   as m ON m.rbukrs = sb.bukrs
                                     and m.racct = sb.saknr

    inner join      t001                 on  t001.bukrs = :p_bukrs
                                         and t001.ktopl = sb.ktopl
left outer join :lt_cepct as cep on cep.prctr = m.prctr

left outer join :lt_cskt  as csk   on  csk.kostl = m.prctr

left outer join :lt_cepc  as cepc   on  cepc.prctr = m.prctr

  where sb.bukrs = :p_bukrs
  and   sb.mandt = :p_clnt
;

RETURN SELECT DISTINCT
      rclnt,
      rldnr,
      erdat,
      racct,
      skat_desc,
      '' AS rfarea,
      '' as fkbtx,
      '' as aufnr,
      '' as aufk_desc,
      poper,
      gjahr,
      prctr,
      cepct_desc,
      rcntr,
      cskt_desc,
      ps_posid,
      prps_post1,
      accasty,
      co_accasty_n1,
      obj_costo_real,
      obj_costo_real_des,
      obj_costo_estad,
      obj_costo_estad_des    ,
      rbukrs,
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
 FROM :lt_det
                     ;
  ENDMETHOD.
ENDCLASS.
