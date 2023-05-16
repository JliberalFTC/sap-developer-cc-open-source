*&---------------------------------------------------------------------*
*& Report ZFIARRHYP_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfiarrhyp_002 MESSAGE-ID zar.
TYPES: ty_sc_acu TYPE zcos015,  "para ALV
       tt_sc_acu TYPE TABLE OF ty_sc_acu.

TYPES: BEGIN OF ty_sc_file.     "archivo salida con path
TYPES: path    TYPE zdirectorio,
       negocio TYPE zperges.
    INCLUDE STRUCTURE zcos016.  "archivo salida
TYPES: END OF ty_sc_file.
TYPES: tt_sc_file TYPE TABLE OF ty_sc_file.


DATA:
  gt_sc_acu  TYPE tt_sc_acu,
  gt_sc_file TYPE tt_sc_file,
  lv_mensaje TYPE string.

DATA: lv_zcot015 TYPE zcot015.
DATA: wl_mensaje2 TYPE char50.

PARAMETERS: p_ledger TYPE rldnr DEFAULT '0L',
            p_bukrs  TYPE bukrs,
            p_gjahr  TYPE gjahr,
            p_poper  TYPE poper.

SELECTION-SCREEN: BEGIN OF BLOCK b7 WITH FRAME TITLE TEXT-500.
PARAMETERS: tpo_inf AS CHECKBOX.
SELECTION-SCREEN: END OF BLOCK b7.

CONSTANTS: c_ks TYPE char02 VALUE 'KS',
           c_or TYPE char02 VALUE 'OR',
           c_pr TYPE char02 VALUE 'PR',
           c_ao TYPE char02 VALUE 'AO',
           c_kl TYPE char02 VALUE 'KL',
           c_vb TYPE char02 VALUE 'VB',
           c_nv TYPE char02 VALUE 'NV',
           c_sd TYPE char02 VALUE 'SD', "ind saldos contables
           c_ic TYPE char02 VALUE 'IC', "ind detalle gastos
           c_af TYPE char02 VALUE 'AF', " AF
           c_oc TYPE char02 VALUE 'OC', "ind detalle ordenes
           c_cl TYPE char02 VALUE 'CL', " chile
           c_ar TYPE char02 VALUE 'AR', " Argentina
           c_co TYPE char02 VALUE 'CO', " Colombia
           c_pe TYPE char02 VALUE 'PE', " Peru
           c_uy TYPE char02 VALUE 'UY', " Uruguay
           c_mx TYPE char02 VALUE 'MX', " Mexico
           c_cn TYPE char02 VALUE 'CN', " China
           c_vg TYPE char02 VALUE 'VG', " Islas Virgenes
           c_br TYPE char02 VALUE 'BR', " Brasil
           c_id TYPE char02 VALUE 'SD'.


START-OF-SELECTION.
  AUTHORITY-CHECK OBJECT 'J_B_BUKRS'
   ID 'BUKRS' FIELD p_bukrs.
  IF sy-subrc <> 0.
    CONCATENATE wl_mensaje2 p_bukrs  INTO wl_mensaje2 SEPARATED BY ','.
  ELSE.
    SELECT FROM zcds_c_hype001(
                                      p_ledger   = @p_ledger,
                                      p_bukrs    = @p_bukrs,
                                      p_gjahr    = @p_gjahr
                                           )
      FIELDS
  rbukrs,
  gjahr,
  racct,
  prctr,
  poper,
  skat_desc,
  rfarea,
  fkbtx,
  aufnr,
  aufk_desc,
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
  obj_costo_estad_des,
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
  negocio
      WHERE  poper    = @p_poper
     INTO CORRESPONDING FIELDS OF  TABLE @gt_sc_acu.

    IF sy-subrc EQ 0.
      PERFORM f_get_obj_costo_sc TABLES gt_sc_acu.
      PERFORM f_prefijos_sc TABLES gt_sc_acu gt_sc_file.

      PERFORM f_add_path_sc TABLES gt_sc_file.
      PERFORM f_download_sc TABLES gt_sc_file.
    ENDIF.
  ENDIF.

END-OF-SELECTION.
FORM f_get_obj_costo_sc TABLES pte_sc_acu TYPE tt_sc_acu.

  LOOP AT pte_sc_acu ASSIGNING FIELD-SYMBOL(<fs_acu>).
*   Objeto costo real
    CASE <fs_acu>-accasty.
      WHEN c_ks.
        <fs_acu>-obj_costo_real = <fs_acu>-rcntr.
        <fs_acu>-obj_costo_real_des = <fs_acu>-cskt_desc.
      WHEN c_or.
        <fs_acu>-obj_costo_real = <fs_acu>-aufnr.
        <fs_acu>-obj_costo_real_des = <fs_acu>-aufk_desc.
      WHEN c_pr.
        <fs_acu>-obj_costo_real = <fs_acu>-ps_posid.
        <fs_acu>-obj_costo_real_des = <fs_acu>-prps_post1.
      WHEN c_ao.
        <fs_acu>-obj_costo_real = <fs_acu>-prctr.
        <fs_acu>-obj_costo_real_des = <fs_acu>-cepct_desc.
      WHEN c_kl.
        <fs_acu>-obj_costo_real = <fs_acu>-lstar.
        <fs_acu>-obj_costo_real_des = <fs_acu>-cepct_desc.
      WHEN c_vb.
        <fs_acu>-obj_costo_real = <fs_acu>-prctr.
        <fs_acu>-obj_costo_real_des = <fs_acu>-cepct_desc.
    ENDCASE.

*   Objeto costo estadistico
    CASE <fs_acu>-co_accasty_n1.
      WHEN c_ks.
        <fs_acu>-obj_costo_estad = <fs_acu>-rcntr.
        <fs_acu>-obj_costo_estad_des = <fs_acu>-cskt_desc.
      WHEN c_or.
        <fs_acu>-obj_costo_estad = <fs_acu>-aufnr.
        <fs_acu>-obj_costo_estad_des = <fs_acu>-aufk_desc.
      WHEN c_pr.
        <fs_acu>-obj_costo_estad = <fs_acu>-ps_posid.
        <fs_acu>-obj_costo_estad_des = <fs_acu>-prps_post1.
    ENDCASE.
  ENDLOOP.

ENDFORM. "F_GET_OBJ_COSTO_SC
FORM f_prefijos_sc TABLES pti TYPE tt_sc_acu
                          pte_file TYPE tt_sc_file.
  DATA: lv_pref TYPE char3.

  LOOP AT pti ASSIGNING FIELD-SYMBOL(<in>).
    APPEND INITIAL LINE TO pte_file ASSIGNING FIELD-SYMBOL(<out>).
    MOVE-CORRESPONDING <in> TO <out>.

    PERFORM f_prefijo USING abap_false 'CodCta.' CHANGING <out>-racct.
    PERFORM f_prefijo USING abap_false 'NmbCta.' CHANGING <out>-skat_desc.
    PERFORM f_prefijo USING abap_false 'CodAFnc.' CHANGING <out>-rfarea.
    PERFORM f_prefijo USING abap_false 'NmbAFnc.' CHANGING <out>-fkbtx.
    PERFORM f_prefijo USING abap_true 'O.' CHANGING <out>-aufnr.
    PERFORM f_prefijo USING abap_true 'O.' CHANGING <out>-aufk_desc.
    CONCATENATE 'Mes.' <out>-poper+1 INTO <out>-poper.  "Mes.mm
    CONCATENATE 'FY' <out>-gjahr+2 INTO <out>-gjahr.    "FYyy
    PERFORM f_prefijo USING abap_true 'B.' CHANGING <out>-prctr.
    PERFORM f_prefijo USING abap_true 'B.' CHANGING <out>-cepct_desc.
    PERFORM f_prefijo USING abap_true 'C.' CHANGING <out>-rcntr.
    PERFORM f_prefijo USING abap_true 'C.' CHANGING <out>-cskt_desc.
    IF <out>-rcntr EQ 'C.NA'.
      <out>-cskt_desc = 'C.NA'.
    ENDIF.
    PERFORM f_prefijo USING abap_true 'P.' CHANGING <out>-ps_posid.
    PERFORM f_prefijo USING abap_true 'P.' CHANGING <out>-prps_post1.
    PERFORM f_prefijo USING abap_false 'ClsObj.' CHANGING <out>-accasty.
    PERFORM f_prefijo USING abap_false 'ImpEst.' CHANGING <out>-co_accasty_n1.

    IF <in>-accasty = c_ao OR <in>-accasty = c_vb.
      CLEAR: <in>-obj_costo_real, <in>-obj_costo_estad.
    ENDIF.

*   Prefijo Objeto de Costo Real
    IF <in>-obj_costo_real IS INITIAL.
      <out>-obj_costo_real = 'OCR_NA'.
      <out>-obj_costo_real_des = 'ObjRl.NA'.
    ELSE.
      CLEAR lv_pref.
      IF <in>-accasty = c_ks.
        lv_pref = 'C.'.
      ELSEIF <in>-accasty = c_or.
        lv_pref = 'O.'.
      ELSEIF <in>-accasty = c_pr.
        lv_pref = 'P.'.
      ELSEIF <in>-accasty = c_ao.
        lv_pref = 'B.'.
      ELSEIF <in>-accasty = c_vb.
        lv_pref = 'B.'.
      ELSEIF <in>-accasty = c_kl.
        lv_pref = 'K.'.
      ELSEIF <in>-accasty = c_nv.
        lv_pref = 'G.'.
      ENDIF.
      PERFORM f_prefijo USING abap_true lv_pref CHANGING <out>-obj_costo_real.
      PERFORM f_prefijo USING abap_true lv_pref CHANGING <out>-obj_costo_real_des.
    ENDIF.

*   Prefijo Objeto de Costo Estadistico
    IF <in>-obj_costo_estad IS INITIAL.
      <out>-obj_costo_estad = 'OCE_NA'.
      <out>-obj_costo_estad_des = 'ObjEs.NA'.
    ELSE.
      CLEAR lv_pref.
      IF <in>-co_accasty_n1 = c_ks.
        lv_pref = 'CE.'.
      ELSEIF <in>-co_accasty_n1 = c_or.
        lv_pref = 'OE.'.
      ELSEIF <in>-co_accasty_n1 = c_pr.
        lv_pref = 'PE.'.
      ENDIF.
      PERFORM f_prefijo USING abap_true lv_pref CHANGING <out>-obj_costo_estad.
      PERFORM f_prefijo USING abap_true lv_pref CHANGING <out>-obj_costo_estad_des.
    ENDIF.

    PERFORM f_prefijo USING abap_false 'SocFI.'   CHANGING <out>-rbukrs.
    PERFORM f_prefijo USING abap_false 'RUTFI.'   CHANGING <out>-paval.
    PERFORM f_prefijo USING abap_false 'NmbFI.'   CHANGING <out>-butxt.
    PERFORM f_prefijo USING abap_false 'Sgmnt.'   CHANGING <out>-segment.
    PERFORM f_prefijo USING abap_false 'GrJE.'    CHANGING <out>-khinr.

*   Convertir importe segun moneda
    PERFORM f_cnv_moneda USING <in>-waers <in>-imp_debito CHANGING <out>-imp_debito.
    PERFORM f_cnv_moneda USING <in>-waers <in>-imp_credito CHANGING <out>-imp_credito.
    PERFORM f_cnv_moneda USING <in>-waers <in>-saldo CHANGING <out>-saldo.
    PERFORM f_cnv_campo4 USING <in>-waers <in>-campo4 CHANGING <out>-campo4.
  ENDLOOP.

ENDFORM. "F_PREFIJOS_SC
FORM f_prefijo USING pvi_siempre pvi_prefijo
               CHANGING pve_field.

  IF pvi_prefijo NE 'AA.' AND pvi_prefijo NE  'CodProy.' AND pvi_prefijo NE  'P.' AND pvi_prefijo NE  'G.' AND pvi_prefijo NE 'TG.'.

    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>horizontal_tab IN pve_field WITH '@'.
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>vertical_tab IN pve_field WITH '@'.
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>newline IN pve_field WITH '@'.
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN pve_field WITH  '@'.
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>form_feed IN pve_field WITH  '@'.

    TRANSLATE pve_field USING '@ \ { } , - = < ( ) + " '' | # '. "JQ - INI - 5000000137: 9000000179, Error en extracción Hyperion.
  ENDIF.
  IF pvi_siempre = abap_true.
    IF pve_field IS INITIAL.
      CONCATENATE pvi_prefijo 'NA' INTO pve_field.
    ELSE.
      CONCATENATE pvi_prefijo pve_field INTO pve_field.
    ENDIF.
  ELSE.
    IF pve_field IS INITIAL.
      CONCATENATE pvi_prefijo 'NA' INTO pve_field.
    ENDIF.
  ENDIF.
  CONDENSE pve_field.

ENDFORM. "F_PREFIJO
FORM f_cnv_moneda USING pvi_cur pvi_val
                  CHANGING pvo_val.
  DATA: lv_val TYPE bapicurr_d.

  CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
    EXPORTING
      currency        = pvi_cur
      amount_internal = pvi_val
    IMPORTING
      amount_external = lv_val.

  pvo_val = lv_val.

  pvo_val = |{ pvo_val(17) }{ pvo_val+19 }|. "dejar 2 decimales en vez de 4

  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
    CHANGING
      value = pvo_val.

ENDFORM. "F_CNV_MONEDA

*&---------------------------------------------------------------------*
*& Form F_CNV_CAMPO4
*&---------------------------------------------------------------------*
FORM f_cnv_campo4 USING pvi_cur pvi_val
                  CHANGING pvo_val.
  CONSTANTS: lc_moneda TYPE char3 VALUE 'CLP'.
  DATA: lv_val       TYPE bapicurr_d,
        lc_monto_tot TYPE char25,
        lv_aux_monto TYPE string,
        lv_m         TYPE wertv12.


  CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
    EXPORTING
      currency        = pvi_cur
      amount_internal = pvi_val
    IMPORTING
      amount_external = lv_val.
  IF pvi_cur EQ lc_moneda.

    lc_monto_tot = lv_val.
    lv_m = lc_monto_tot.
    pvo_val = lv_m.

  ELSE.
*    WRITE pvi_val TO lc_monto_tot CURRENCY pvi_cur
*                                     LEFT-JUSTIFIED NO-GROUPING.

    pvo_val = lv_val.

    pvo_val = |{ pvo_val(17) }{ pvo_val+19 }|. "dejar 2 decimales en vez de 4
  ENDIF.

*     WRITE pvi_val TO lc_monto_tot CURRENCY pvi_cur  LEFT-JUSTIFIED NO-GROUPING.

  CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
    CHANGING
      value = pvo_val.

ENDFORM. "F_CNV_MONEDA
FORM f_add_path_sc TABLES pte_sc TYPE tt_sc_file.
  DATA: lt_path     TYPE TABLE OF zotct009,
        lv_filename TYPE char20.
  IF tpo_inf EQ abap_true.
    SELECT id_directorio, pergestion, bukrs, directorio, filename "#EC CI_SUBRC
      INTO CORRESPONDING FIELDS OF TABLE @lt_path
      FROM zotct009
      WHERE id_directorio = @c_sd
      AND informe_ti = @tpo_inf
    AND bukrs       EQ @p_bukrs.
  ELSE.
    SELECT id_directorio, pergestion, bukrs, directorio, filename "#EC CI_SUBRC
      INTO CORRESPONDING FIELDS OF TABLE @lt_path
      FROM zotct009
      WHERE id_directorio = @c_sd
    AND bukrs       EQ @p_bukrs.
  ENDIF.
  LOOP AT pte_sc ASSIGNING FIELD-SYMBOL(<fs>).
    READ TABLE lt_path ASSIGNING FIELD-SYMBOL(<fs_path>)
        WITH KEY pergestion = <fs>-negocio.
    IF sy-subrc = 0.
      <fs>-path = |{ <fs_path>-directorio }{ <fs_path>-filename }|.
*      IF s_poper-low = s_poper-high.
      lv_filename = |{ p_poper+1 }_{ p_gjahr }{ '.txt' }|.
*      ELSE.
*        lv_filename = |{ s_poper-low+1 }_{ s_poper-high+1 }_{ p_ryear }{ '.txt' }|.
*      ENDIF.
      CONCATENATE <fs>-path lv_filename INTO <fs>-path.
    ENDIF.
  ENDLOOP.

ENDFORM. "F_ADD_PATH_SC
FORM f_download_sc TABLES pti_sc TYPE tt_sc_file.
  DATA: lst_salida      TYPE zcos016,
        lv_line         TYPE string,
        lv_cabecera     TYPE string,
        lv_mensaje      TYPE string,
        lt_salida_texto TYPE TABLE OF string.

  FIELD-SYMBOLS <fs_comp>.

  PERFORM f_get_header USING 10 41 CHANGING lv_cabecera.

  SORT pti_sc BY path gjahr poper racct prctr.

  LOOP AT pti_sc ASSIGNING FIELD-SYMBOL(<fs>).
    AT NEW path.
      IF <fs>-path IS INITIAL.
        MESSAGE i028 WITH <fs>-negocio INTO lv_mensaje.
        WRITE:/ lv_mensaje.
        CONTINUE.
      ENDIF.

      REFRESH lt_salida_texto.
      APPEND lv_cabecera TO lt_salida_texto.
    ENDAT.

    CHECK NOT <fs>-path IS INITIAL.

    CLEAR: lst_salida, lv_line.
    "omitir path y negocio
    MOVE <fs>+154 TO lst_salida.

*   Concatenar registro datos
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE lst_salida TO <fs_comp>.
      IF sy-subrc = 0.
        CONCATENATE lv_line <fs_comp> INTO lv_line SEPARATED BY '|'.
      ELSE.
        lv_line = lv_line+1.
        EXIT.
      ENDIF.
    ENDDO.

    APPEND lv_line TO lt_salida_texto.

    AT END OF path.

      OPEN DATASET <fs>-path FOR OUTPUT IN TEXT MODE ENCODING UTF-8 WITH BYTE-ORDER MARK .
      IF sy-subrc <> 0.
        MESSAGE i029 WITH <fs>-path INTO lv_mensaje.
        WRITE:/ lv_mensaje.
        CONTINUE.
      ENDIF.

      LOOP AT lt_salida_texto ASSIGNING FIELD-SYMBOL(<fs_data>).
        lv_line = <fs_data>.
        TRANSFER lv_line   TO <fs>-path.
      ENDLOOP.

      CLOSE DATASET <fs>-path.
      WRITE:/ <fs>-path.

    ENDAT.

  ENDLOOP.
ENDFORM. "F_DOWNLOAD_SC
FORM f_get_header USING pvi_ini pvi_fin CHANGING pve_cab.
  DATA: lv_ini  TYPE numc3,
        lv_fin  TYPE numc3,
        lv_text TYPE char8.

  FIELD-SYMBOLS <fs_text>.

  lv_ini = pvi_ini.
  lv_fin = pvi_fin.

  DO.
    CONCATENATE 'TEXT-' lv_ini INTO lv_text.
    ASSIGN (lv_text) TO <fs_text>.                        "#EC CI_SUBRC
    CONCATENATE pve_cab <fs_text> INTO pve_cab SEPARATED BY '|'.
    IF lv_ini = lv_fin.
      pve_cab = pve_cab+1.
      EXIT.
    ENDIF.
    ADD 1 TO lv_ini.
  ENDDO.

ENDFORM. "F_GET_HEADER
