/*  PASAR A RIESGOS EN MODIFICACION DE UN ENDOSO DE RENOVACIÓN
====================================================================================================*/
exec emi_usp_existen_riesgos_wkf 50613934
exec sp_rep_obtener_comando @p_cod_comando=931,@p_patrones=N'branchId,prefixId,policyId',@p_valores=N'10|100|50613934'
    EXEC @isValid = usp_validar_query @v_val -- 3 VECES
    EXEC cot_get_data_general_wkf '50613934', '10', '100';    
exec sp_rep_obtener_comando @p_cod_comando=2255,@p_patrones=N'pid_pv_wkf',@p_valores=N'50613934'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2260,@p_patrones=N'pid_pv_wkf',@p_valores=N'50613934'   
    EXEC @isValid = usp_validar_query @v_val
    EXEC sp_validar_agente_habilitado_cp 50613934
exec sp_rep_obtener_comando @p_cod_comando=20188,@p_patrones=N'pid_pv,pfec_emi,pfec_vig_desde,pfec_vig_hasta,pcod_conducto,pcod_ppago',@p_valores=N'50613934|''2021-04-30''|''2022-03-27''|''2023-03-27''|undefined|-1'
    EXEC @isValid = usp_validar_query @v_val -- 6 VECES
exec get_insured_default_address 61958
exec emi_genera_pv_agente @id_pv_wkf=50613934,@ind_agente=1,@cod_agente=664,@cod_tipo_agente=4,@pje_participacion=100
    exec emi_genera_pv_agente_core @id_pv_wkf, @ind_agente, @cod_agente, @cod_tipo_agente, @pje_participacion
    EXEC emi_save_comispago_agente_cp @id_pv_wkf, @cod_producto_cial, @cod_agente, @cod_conducto, @cod_ppago
exec emi_sp_calcula_comis @id_pv_wkf=50613934,@pje_comis_normal_usuario=14,@pje_comis_extra_usuario=0,@ind_agente=1,@ind_comision=1,@criterio_calc_comis=0 -- UNO POR CADA ind_comis
    EXEC dbo.revisa_importe_emision_tempdb_core
    SET @importe_partic = dbo.RedondeaImporteEmision((@prima_neta * (@pje_participacion/100)), @cod_moneda)
    SET @importe_comis_normal = dbo.RedondeaImporteEmision((@importe_partic * (@pje_comis_normal/100)), @cod_moneda)
    SET @importe_comis_extra = dbo.RedondeaImporteEmision((@importe_partic * (@pje_comis_extra/100)), @cod_moneda)
    SET @importe_partic_eq = dbo.RedondeaImporteEmision(((@prima_neta * (@pje_participacion/100)) * @imp_cambio), 0)
    SET @importe_comis_normal_eq = dbo.RedondeaImporteEmision(((@importe_partic * (@pje_comis_normal/100)) * @imp_cambio), 0)
    SET @importe_comis_extra_eq = dbo.RedondeaImporteEmision(((@importe_partic * (@pje_comis_extra/100)) * @imp_cambio), 0)
exec sp_rep_obtener_comando @p_cod_comando=2221,@p_patrones=N'pid_pv_cero, pid_pv_wkf, pproceso_actividad',@p_valores=N'4099932|50613934|0'
    EXEC @isValid = usp_validar_query @v_val -- 3 VECES
    EXEC emi_endoso_primer_vto 4099932,50613934,0;
exec emi_spc_datos_agente 50613934
    EXEC dbo.revisa_importe_emision_tempdb_core
    EXEC emi_sp_calcula_comis @id_pv_wkf, @pje_comis_normal, @pje_comis_extra, @ind_agente, @ind_comis_nuevo, @cod_criterio_comis -- UNO POR CADA ind_comis
        EXEC dbo.revisa_importe_emision_tempdb_core
        SET @importe_partic = dbo.RedondeaImporteEmision((@prima_neta * (@pje_participacion/100)), @cod_moneda)
        SET @importe_comis_normal = dbo.RedondeaImporteEmision((@importe_partic * (@pje_comis_normal/100)), @cod_moneda)
        SET @importe_comis_extra = dbo.RedondeaImporteEmision((@importe_partic * (@pje_comis_extra/100)), @cod_moneda)  
        SET @importe_partic_eq = dbo.RedondeaImporteEmision(((@prima_neta * (@pje_participacion/100)) * @imp_cambio), 0)
        SET @importe_comis_normal_eq = dbo.RedondeaImporteEmision(((@importe_partic * (@pje_comis_normal/100)) * @imp_cambio), 0)
        SET @importe_comis_extra_eq = dbo.RedondeaImporteEmision(((@importe_partic * (@pje_comis_extra/100)) * @imp_cambio), 0)
exec emi_spc_datos_comision @id_pv=50613934,@ind_agente=1
exec sp_rep_obtener_comando @p_cod_comando=1232,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec cot_get_num_endo @id_pv_cero=4099932,@date_emi='2021-04-30 00:00:00'
exec emi_save_pv_header @id_pv=50613934,@cod_suc=10,@cod_ramo=100,@nro_pol=21500668,@aaaa_endoso=2025,@nro_endoso=1,@cod_aseg=61958,@fec_emi='2021-04-30 00:00:00',@fec_vig_desde='2022-03-27 12:00:00',@fec_vig_hasta='2023-03-27 12:00:00',@cod_moneda=4,@imp_cambio=29544.690000,@id_pv_modifica=0,@cod_operacion=1,@nro_solicitud=50613934,@nro_cotizacion=-1,@cod_tipo_agente=4,@cod_agente=664,@fec_hora_desde='2022-03-27 12:00:00',@id_pv_cero=4099932,@sn_cob_coas_total=0,@cod_grupo_endo=5,@cod_tipo_endo=1,@cod_sistema=1,@sn_bancaseguros=-1,@sn_fronting=0,@cod_periodo_fact=1,@cod_grupo=0,@nro_flota=0,@txt_partic_acreedor=N'50',@cod_nivel_facturacion=0,@cod_nivel_imp_factura=0,@cod_subramo=0
    SELECT @old_cod_aseg = cod_aseg, @imp_cambio = dbo.emi_fn_get_currency_change(cod_moneda, getdate())  FROM pv_header_wkf WHERE id_pv = @id_pv
exec emi_save_pv_varios @id_pv=50613934,@fec_proceso='2025-06-25 14:24:53.760',@fec_inicio='2025-06-25 14:24:53.760',@fec_fin='2025-06-25 14:24:53.760',@cod_usuario=N'DEMO',@fec_vig_hasta_orig='2023-03-27 12:00:00',@cod_pto_vta=0,@txt_usuario_cotiz=N'DEMO',@cod_tipo_negocio=3,@cod_tipo_poliza=1,@txt_nom_factura=N'ARRIENDO DE VEHICULOS Y ASESORIA EN INGENIERIA ANDRES RICARDO PINOCHET WILLEMSEN',@cod_grupo_caucion=0,@cod_producto_com=28,@cod_socio=0    
    INSERT INTO @vig_prox_facturacion EXEC emi_usp_get_fec_fact_cober @id_pv = @id_pv, @sn_temporal = -1
exec emi_save_pv_varios_cp @id_pv=50613934,@nro_propuesta_interna=N'123456',@nro_propuesta_externa=default,@id_tipo_licitacion=0,@nro_licitacion=default,@sn_renovacion_automatica=-1,@subdivision_ramo_fecu=1,@cod_convenio=0,@nro_cotiz=default
exec sp_rep_obtener_comando @p_cod_comando=927,@p_patrones=N'currency',@p_valores=N'4'
    EXEC @isValid = usp_validar_query @v_val
exec save_process_current 75,227,'50613934'

