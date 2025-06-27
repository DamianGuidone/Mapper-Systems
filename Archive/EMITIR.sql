/*  Emitir
====================================================================================================*/
exec sp_rep_obtener_comando @p_cod_comando=2222,@p_patrones=N'pid_pv_wkf',@p_valores=N'51576768'
    EXEC @isValid = usp_validar_query @v_val
exec usp_RE_instantanea_emi_wkf @id_pv_wkf=51576768
exec spd_RE_temp_proceso @id_proceso=51576768,@id_pv=51576768
exec emi_usp_load_coinsurance @id_pv_wkf=51576768,@sn_load_own=0
exec sp_consistencia_emi_wkf @id_pv=51576768,@sino_muestra=-1,@sino_ISO=-1    
    exec sp_verif_pv_importe @sp_id_pv = @id_pv, @sp_cod_moneda = @cod_moneda_me, @sp_rango = @dif_aceptada, @sp_imp_prima_header = 0, @sp_aux = @msg_status output, @sp_output = @sp_output output, @sp_imp_prima_importe = @imp_prima_me output, @sp_imp_deremi_importe = @imp_gasto_emision_me output, @sp_imp_recargo_importe = @imp_recargo_me output, @sp_imp_descuento_importe = @imp_descuento_me output, @sp_imp_decreto_importe = @imp_decreto_me output,     @sp_imp_iva_importe = @imp_iva_me output, @sp_imp_premio_importe = @imp_premio_me output
        exec sp_verif_pv_imp_pesificado @sp_id_pv = @sp_id_pv, @sp_cod_moneda = @sp_cod_moneda, @imp_cambio = @imp_cambio, @sp_imp_prima_importe = @sp_imp_prima_importe, @sp_imp_deremi_importe = @sp_imp_deremi_importe, @sp_imp_recargo_importe = @sp_imp_recargo_importe, @sp_imp_descuento_importe = @sp_imp_descuento_importe, @sp_imp_decreto_importe = @sp_imp_decreto_importe, @sp_imp_iva_importe = @sp_imp_iva_importe, @sp_imp_premio_importe = @sp_imp_premio_importe, @sp_aux = @sp_aux output, @sp_output = @sp_output output
    exec sp_verif_pv_importe_concepto @sp_id_pv = @id_pv, @sp_cod_moneda = @cod_moneda_me, @sp_rango = @dif_aceptada, @sp_imp_prima_importe = @imp_prima_me, @sp_imp_deremi_importe = @imp_gasto_emision_me, @sp_imp_recargo_importe = @imp_recargo_me, @sp_imp_descuento_importe = @imp_descuento_me, @sp_imp_decreto_importe = @imp_decreto_me, @sp_imp_iva_importe = @imp_iva_me, @sp_imp_premio_importe = @imp_premio_me, @sp_aux = @msg_status output, @sp_output = @sp_output output
        exec sp_verif_pv_importe_cpto_pesif @sp_id_pv = @sp_id_pv, @sp_cod_moneda =  @sp_cod_moneda, @imp_cambio = @imp_cambio, @sp_imp_prima_pv_imp_cto = @sp_imp_prima_pv_imp_cto, @sp_imp_deremi_pv_imp_cto = @sp_imp_deremi_pv_imp_cto, @sp_imp_recargo_pv_imp_cto = @sp_imp_recargo_pv_imp_cto, @sp_imp_descto_pv_imp_cto = @sp_imp_descto_pv_imp_cto, @sp_imp_decreto_pv_imp_cto = @sp_imp_decreto_pv_imp_cto, @sp_imp_IVA_pv_imp_cto = @sp_imp_IVA_pv_imp_cto, @sp_imp_premio_pv_imp_cto = @sp_imp_premio_pv_imp_cto, @sp_aux = @sp_aux output, @sp_output = @sp_output output
    exec sp_verif_pv_pagador @sp_id_pv = @id_pv, @cod_moneda = @cod_moneda_me, @sp_rango = @dif_aceptada, @sp_imp_prima_importe = @imp_prima_me, @sp_imp_deremi_importe = @imp_gasto_emision_me, @sp_imp_recargo_importe = @imp_recargo_me, @sp_imp_descuento_importe = @imp_descuento_me, @sp_imp_decreto_importe = @imp_decreto_me, @sp_imp_iva_importe = @imp_iva_me, @sp_imp_premio_importe = @imp_premio_me, @sp_aux = @msg_status output, @sp_output = @sp_output output
        EXEC sp_verif_pv_pagador_pesif @sp_id_pv = @sp_id_pv, @sp_cod_moneda = @cod_moneda, @sp_imp_prima_pv_pagador = @sp_imp_prima_pv_pagador, @sp_deremi_pv_pagador = @sp_deremi_pv_pagador, @sp_rec_pv_pagador = @sp_rec_pv_pagador, @sp_descto_pv_pagador = @sp_descto_pv_pagador, @sp_imp_iva_pv_pagador = @sp_imp_iva_pv_pagador, @sp_imp_decreto_pv_pagador = @sp_imp_decreto_pv_pagador, @sp_imp_premio_pv_pagador = @sp_imp_premio_pv_pagador, @sp_aux = @sp_aux output, @sp_output = @sp_output output
    exec sp_verif_pv_pagador_cuota @sp_id_pv = @id_pv, @sp_cod_moneda = @cod_moneda_me, @sp_rango = @dif_aceptada, @sp_aux = @msg_status OUTPUT , @sp_output = @sp_output OUTPUT
        EXEC sp_verif_pv_pagador_cuo_pesif @sp_id_pv = @sp_id_pv, @sp_cod_moneda = @sp_cod_moneda, @imp_cambio = @imp_cambio, @sp_imp_prima_pv_pagador_cuota = @sp_imp_prima_pv_pagador_cuota, @sp_imp_DE_pv_pagador_cuota = @sp_imp_DE_pv_pagador_cuota, @sp_imp_rec_pv_pagador_cuota = @sp_imp_rec_pv_pagador_cuota, @sp_imp_DTO_pv_pagador_cuota = @sp_imp_DTO_pv_pagador_cuota, @sp_imp_DEC_pv_pagador_cuota = @sp_imp_DEC_pv_pagador_cuota, @sp_imp_iva_pv_pagador_cuota = @sp_imp_iva_pv_pagador_cuota, @sp_imp_premio_pv_pagador = @sp_imp_premio_pv_pagador, @sp_imp_PO_pv_pagador_cuota = @sp_imp_PO_pv_pagador_cuota, @sp_rango = @sp_rango, @sp_aux = @sp_aux output, @sp_output = @sp_output output
    exec sp_verif_pv_agente @sp_id_pv = @id_pv, @sp_rango = @dif_aceptada, @sp_aux = @msg_status output, @sp_output = @sp_output output
    exec sp_verif_control_riesgos @id_pv = @id_pv, @sn_coas = @sn_coas, @sp_aux = @msg_status output, @sp_output = @sp_output output
    exec sp_verif_suma_asegurada @sp_id_pv = @id_pv, @cod_moneda = @cod_moneda_me, @sp_rango = @dif_aceptada, @sp_aux = @msg_status output, @sp_output = @sp_output output
    exec sp_verif_componentes_cuotas_dif_signos @id_pv = @id_pv, @sp_aux = @msg_status output, @sp_output = @sp_output output
    exec sp_verif_dev_conceptos @id_pv = @id_pv, @cod_moneda = @cod_moneda_me, @imp_premio_pv = @imp_premio_me, @sp_aux = @msg_status output, @sp_output = @sp_output output
exec sp_rep_obtener_comando @p_cod_comando=1415,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec cot_sp_detalle_conceptos 51576768,-1,-1,-1
exec emi_usp_get_concept_byid @id_pv=51576768,@cod_tipo_concepto=2,@cod_concepto=13,@sn_temp=-1
exec emi_usp_get_concept_byid @id_pv=51576768,@cod_tipo_concepto=2,@cod_concepto=4,@sn_temp=-1
exec emi_usp_get_concept_byid @id_pv=51576768,@cod_tipo_concepto=2,@cod_concepto=5,@sn_temp=-1
exec emi_usp_obtiene_conceptos @id_pv=51576768
exec emi_get_payer_risk @id_pv=51576768,@cod_item=0
exec emi_spc_pv_pagador_cuota @id_pv=51576768,@cod_ind_pagador=1
exec emi_usp_get_concept_byid @id_pv=51576768,@cod_tipo_concepto=2,@cod_concepto=13,@sn_temp=-1
exec emi_usp_get_concept_byid @id_pv=51576768,@cod_tipo_concepto=2,@cod_concepto=4,@sn_temp=-1
exec emi_usp_get_concept_byid @id_pv=51576768,@cod_tipo_concepto=2,@cod_concepto=5,@sn_temp=-1
exec cot_spg_genera_emi 51576768,'DEMO'
        EXEC spiu_tult_id_pv_suc 0, @cod_suc ,@id_pv_real OUTPUT
    EXEC spiu_tramo_suc_ult_nro 0, @cod_ramo ,@cod_suc ,@nro_pol OUTPUT
        exec spiu_tult_nro_pol_cp @sn_muestra,@ult_nro output
            exec sp_fecha_mov_suc  @fec_emi, 1, 3, 1, @fecha_real = @fec_emi OUTPUT
    EXEC sp_asignar_seguimiento_PD @id_pv_wkf = @id_pv_wkf, @id_pv_sise = @id_pv_real
    EXEC emi_genera_nro_folio @anio = @anio_vig_hasta, @cod_suc = @cod_suc, @cod_ramo = @cod_ramo, @cod_socio = @cod_socio, @nro_folio = @nro_folio OUTPUT
    EXEC @sp_error = usp_Trasladar_Temporario_linea @id_pv_wkf ,@id_pv_real ,@msj_error OUTPUT
        EXECUTE @mi_error = dbo.usp_ReindexarItems @wid_pv, @id_pv_cero, @pjepartic
            EXEC usp_reindexaritems_core @id_pv,@id_pv_cero,@partic
        EXECUTE @mi_error = dbo.usp_Trasladarpv_header @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_trasladar_pv_liquidador @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladarpv_varios @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladar_categorias @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_trasladar_pv_prima_informada @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_TrasladarPvAcreedor @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladarpv_porcentaje @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_TrasladarDi_DatosAg @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_trasladar_di_datos_varios @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladarpv_importe_concep @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladarpv_importe @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladarpv_texto @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladarpv_obs @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladarpv_anexo @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladarpv_anexo_texto @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladarpv_pagador @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.emi_isp_trasladaPVPagConcepto @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladarpv_pagador_cuota @id_pv, @wid_pv
            EXECUTE dbo.usp_numerar_recibos @id_pv
                EXECUTE dbo.spiu_ult_aviso_cobro 0 ,@cod_suc ,@cod_ramo ,@ult_nro = @ult_nro OUTPUT -- 6 VECES
        EXEC @mi_error = dbo.emi_isp_TrasPagCuotaConcepto @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladarpv_agente @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_TrasladarPV_recdesc @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_trasladar_pv_MARS @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_TrasladarPVBenef @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladarpv_agente_comis @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_GrabarCGarantias @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladarpv_cia_excess @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladardi_header @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_TrasladarTextoBatch @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_trasladar_di_datos_caucion @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladardi_au_puntaje @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladardi_cober @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_TrasDiCoberMARS @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladardi_cober_imp @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladar_DI_tarif @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_trasl_di_cober_det @wid_pv, @id_pv
        EXECUTE @mi_error = dbo.usp_Trasladardi_cober_texto @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladardi_cober_anexo @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladardi_cober_anexo_tx @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladar_di_cober_min_CAS @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladar_di_ISO_resp_cpto @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladar_di_ISO_respuesta @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_tras_dicoberdobleint @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladardi_reas @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_trasladar_reas_deduc @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladardi_datos_au @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladardi_cober_au_anexo @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladardi_au_conductores @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_Trasladardi_cober_au_eqesp @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_trasladar_deduc_eq_esp @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladardi_pagador @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladardi_recdesc @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladardi_benef @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladardi_cober_deduc @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasdi_cober_deducs_cau @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.sp_Trasladardi_cober_recdesc @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_trasladardi_liquidador @id_pv, @wid_pv
        EXECUTE @mi_error = dbo.usp_ActualizaPvAct @id_pv, @sn_general
        EXECUTE @mi_error = dbo.sp_LimpiarIDDI_wkf @wid_pv
        EXECUTE @mi_error = dbo.sp_LimpiarIDPV_wkf @wid_pv
        EXECUTE @mi_error = dbo.usp_GrabarRSR_generales @id_pv, @cod_operacion
        EXEC save_process_current @process, @user, @key
        execute @mi_error = usp_dview_paso_reales_emision @cod_ramo,@wid_pv, @id_pv, @usuario
        exec spi_insert_prepago @id_pv
    EXEC spi_RE_sumas_reasegurar @id_pv_wkf, 0, @id_pv_real
    EXEC emi_update_pv_agente_comis @id_pv = @id_pv_real
    EXEC usp_RE_estado_param_REONL_core @id_pv_real, null, null, null, @activo output
    EXEC emi_update_fecha_cober @id_pv = @id_pv_real, @sn_real = -1
declare @p2 varchar(1000) set @p2=NULL
declare @p3 varchar(8000) set @p3=NULL
exec iusp_get_pol_cp 5069388,@p2 output,@p3 output select @p2, @p3
exec cot_execute_command @cod_command=1679,@patterns='subscriptionId,prefixId,user,policyId',@values='51576768|200|DEMO|25047148',@query=default,@proc=1
    EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
    exec emi_tracing_quote 51576768, 200, 'DEMO', 25047148;
exec save_process_current 6,227,'51576768'
exec emi_usp_get_concept_byid @id_pv=5069388,@cod_tipo_concepto=2,@cod_concepto=13,@sn_temp=0
exec emi_usp_get_concept_byid @id_pv=5069388,@cod_tipo_concepto=2,@cod_concepto=4,@sn_temp=0
exec emi_usp_get_concept_byid @id_pv=5069388,@cod_tipo_concepto=2,@cod_concepto=5,@sn_temp=0

