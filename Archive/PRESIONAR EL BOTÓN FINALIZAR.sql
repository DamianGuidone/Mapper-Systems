/*  PRESIONAR EL BOTÓN FINALIZAR
====================================================================================================*/
exec sp_rep_obtener_comando @p_cod_comando=2222,@p_patrones=N'pid_pv_wkf',@p_valores=N'51576763'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1391,@p_patrones=N'policyId,isLifePrefix',@p_valores=N'51576763|0'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
    EXEC emi_validate_coverages 51576763, 0;
exec sp_rep_obtener_comando @p_cod_comando=1368,@p_patrones=N'usuario,prefixId,policyId,riskId',@p_valores=N'DEMO|200|51576763|0'
    EXEC @isValid = usp_validar_query @v_val -- 4 VECES
    EXEC cot_validateInsuredAmountMax 51576763, 0, 200, 'DEMO';
exec sp_rep_obtener_comando @p_cod_comando=2262,@p_patrones=N'id_pv_wkf',@p_valores=N'51576763'
    EXEC @isValid = usp_validar_query @v_val
    EXEC usp_validar_montos_riesgos 51576763
exec cot_get_num_endo @id_pv_cero=0,@date_emi='2025-05-26 00:00:00'
exec emi_save_pv_header @id_pv=51576763,@cod_suc=1,@cod_ramo=200,@nro_pol=0,@aaaa_endoso=2025,@nro_endoso=0,@cod_aseg=286273,@fec_emi='2025-05-26 00:00:00',@fec_vig_desde='2025-05-23 12:00:00',@fec_vig_hasta='2026-05-23 12:00:00',@cod_moneda=4,@imp_cambio=39171.770000,@id_pv_modifica=0,@cod_operacion=1,@nro_solicitud=51576763,@nro_cotizacion=-1,@cod_tipo_agente=4,@cod_agente=1105,@fec_hora_desde='2025-05-23 12:00:00',@id_pv_cero=0,@sn_cob_coas_total=0,@cod_grupo_endo=1,@cod_tipo_endo=1,@cod_sistema=1,@sn_bancaseguros=-1,@sn_fronting=0,@cod_periodo_fact=1,@cod_grupo=0,@nro_flota=0,@txt_partic_acreedor=N'50',@cod_nivel_facturacion=0,@cod_nivel_imp_factura=0,@cod_subramo=0
    SELECT @old_cod_aseg = cod_aseg, @imp_cambio = dbo.emi_fn_get_currency_change(cod_moneda, getdate()) FROM pv_header_wkf WHERE id_pv = @id_pv
exec emi_save_pv_varios @id_pv=51576763,@fec_proceso='2025-05-26 12:16:11.173',@fec_inicio='2025-05-26 12:16:11.173',@fec_fin='2025-05-26 12:16:11.173',@cod_usuario=N'DEMO',@fec_vig_hasta_orig='2026-05-23 12:00:00',@cod_pto_vta=1,@txt_usuario_cotiz=N'DEMO',@cod_tipo_negocio=3,@cod_tipo_poliza=1,@txt_nom_factura=N' ABC ETIQUETAS LIMITADA ',@cod_grupo_caucion=0,@cod_producto_com=0,@cod_socio=-1
    INSERT INTO @vig_prox_facturacion EXEC emi_usp_get_fec_fact_cober @id_pv = @id_pv, @sn_temporal = -1
exec emi_save_pvc_varios @id_pv=51576763,@nro_propuesta_interna=N'212080',@nro_propuesta_externa=default,@sn_renovacion_automatica=0,@subdivision_ramo_fecu=1,@cod_convenio=0,@nro_cotiz=default
exec save_process_current 5,227,'51576763'
exec sp_rep_obtener_comando @p_cod_comando=1391,@p_patrones=N'policyId,isLifePrefix',@p_valores=N'51576763|0'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
    exec emi_validate_coverages 51576763, 0;
exec sp_rep_obtener_comando @p_cod_comando=1368,@p_patrones=N'usuario,prefixId,policyId,riskId',@p_valores=N'DEMO|200|51576763|0'
    EXEC @isValid = usp_validar_query @v_val -- 4 VECES
    exec cot_validateInsuredAmountMax 51576763, 0, 200, 'DEMO';
exec sp_rep_obtener_comando @p_cod_comando=2262,@p_patrones=N'id_pv_wkf',@p_valores=N'51576763'
    EXEC @isValid = usp_validar_query @v_val
    EXEC usp_validar_montos_riesgos 51576763
exec sp_rep_obtener_comando @p_cod_comando=1415,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec emi_get_payer_risk @id_pv=51576763,@cod_item=0
    SET @pje_participacion = dbo.fn_GetPjePartCiaPagador(@id_pv)
exec emi_spc_pv_pagador_cuota @id_pv=51576763,@cod_ind_pagador=1
exec cot_sp_detalle_conceptos 51576763,-1,-1,-1
exec emi_usp_get_concept_byid @id_pv=51576763,@cod_tipo_concepto=2,@cod_concepto=13,@sn_temp=-1
    SELECT te.txt_dec txt_concepto, pic.cod_tipo_concepto, pic.cod_concepto,dbo.RedondeaImporteEmision(pic.imp_concepto, pic.cod_moneda) imp_concepto, pic.pje_tasa FROM pv_importe_concepto_wkf pic INNER JOIN pv_header_wkf ph ON ph.id_pv = pic.id_pv AND ph.cod_moneda = pic.cod_moneda INNER JOIN tconcepto_emi te ON te.cod_tipo_concepto = pic.cod_tipo_concepto AND te.cod_concepto = pic.cod_concepto WHERE pic.id_pv = 51576763 AND pic.cod_tipo_concepto = 2 AND pic.cod_concepto = 13
exec emi_usp_get_concept_byid @id_pv=51576763,@cod_tipo_concepto=2,@cod_concepto=4,@sn_temp=-1
    SELECT te.txt_dec txt_concepto, pic.cod_tipo_concepto, pic.cod_concepto,dbo.RedondeaImporteEmision(pic.imp_concepto, pic.cod_moneda) imp_concepto, pic.pje_tasa FROM pv_importe_concepto_wkf pic INNER JOIN pv_header_wkf ph ON ph.id_pv = pic.id_pv AND ph.cod_moneda = pic.cod_moneda INNER JOIN tconcepto_emi te ON te.cod_tipo_concepto = pic.cod_tipo_concepto AND te.cod_concepto = pic.cod_concepto WHERE pic.id_pv = 51576763 AND pic.cod_tipo_concepto = 2 AND pic.cod_concepto = 4



















