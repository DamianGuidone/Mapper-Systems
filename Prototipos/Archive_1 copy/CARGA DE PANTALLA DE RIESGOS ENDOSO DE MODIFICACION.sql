/*  CARGA DE PANTALLA DE RIESGOS ENDOSO DE MODIFICACION
====================================================================================================*/
exec emi_usp_existen_riesgos_wkf 51569382
exec sp_rep_obtener_comando @p_cod_comando=2255,@p_patrones=N'pid_pv_wkf',@p_valores=N'51569382'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2260,@p_patrones=N'pid_pv_wkf',@p_valores=N'51569382'
    EXEC @isValid = usp_validar_query @v_val
    EXEC sp_validar_agente_habilitado_cp 51569382
exec sp_rep_obtener_comando @p_cod_comando=20188,@p_patrones=N'pid_pv,pfec_emi,pfec_vig_desde,pfec_vig_hasta,pcod_conducto,pcod_ppago',@p_valores=N'51569382|''2025-05-19''|''2024-03-15''|''2026-03-16''|1|1'
    EXEC @isValid = usp_validar_query @v_val -- 6 VECES
    SELECT convert(varchar(10), fec_1_vto, 103) AS primer_vto, '' FROM dbo.emi_ufn_calcular_primer_vto(51569382, '2025-05-19', '2024-03-15', '2026-03-16', 1, 1)
exec cot_get_num_endo @id_pv_cero=4681164,@date_emi='2025-05-19 00:00:00'
exec emi_save_pv_header @id_pv=51569382,@cod_suc=1,@cod_ramo=500,@nro_pol=24058902,@aaaa_endoso=2025,@nro_endoso=7,@cod_aseg=76401,@fec_emi='2025-05-19 00:00:00',@fec_vig_desde='2024-03-15 12:00:00',@fec_vig_hasta='2026-03-16 12:00:00',@cod_moneda=4,@imp_cambio=39151.580000,@id_pv_modifica=0,@cod_operacion=1,@nro_solicitud=51569382,@nro_cotizacion=-1,@cod_tipo_agente=4,@cod_agente=941,@fec_hora_desde='2024-03-15 12:00:00',@id_pv_cero=4681164,@sn_cob_coas_total=0,@cod_grupo_endo=2,@cod_tipo_endo=607,@cod_sistema=1,@sn_bancaseguros=-1,@sn_fronting=0,@cod_periodo_fact=1,@cod_grupo=0,@nro_flota=0,@txt_partic_acreedor=N'50',@cod_nivel_facturacion=0,@cod_nivel_imp_factura=0,@cod_subramo=0
    SELECT @old_cod_aseg = cod_aseg, @imp_cambio = dbo.emi_fn_get_currency_change(cod_moneda, getdate()) --Req. 77280 LFREIRE
    FROM pv_header_wkf
    WHERE id_pv = @id_pv
exec emi_save_pv_varios @id_pv=51569382,@fec_proceso='2025-05-19 10:12:56.603',@fec_inicio='2025-05-19 10:12:56.603',@fec_fin='2025-05-19 10:12:56.603',@cod_usuario=N'DEMO',@fec_vig_hasta_orig='2026-03-16 12:00:00',@cod_pto_vta=1,@txt_usuario_cotiz=N'DEMO',@cod_tipo_negocio=3,@cod_tipo_poliza=1,@txt_nom_factura=N' SOC. ING. CONSTRUCCION Y MAQUINARIAS SPA ',@cod_grupo_caucion=0,@cod_producto_com=0,@cod_socio=-1
    INSERT INTO @vig_prox_facturacion EXEC emi_usp_get_fec_fact_cober @id_pv = @id_pv, @sn_temporal = -1
exec emi_save_pvc_varios @id_pv=51569382,@nro_propuesta_interna=N'123',@nro_propuesta_externa=default,@sn_renovacion_automatica=0,@subdivision_ramo_fecu=6,@cod_convenio=323,@nro_cotiz=default
exec emi_genera_pv_agente @id_pv_wkf=51569382,@ind_agente=1,@cod_agente=941,@cod_tipo_agente=4,@pje_participacion=100
    exec emi_genera_pv_agente_core @id_pv_wkf,@ind_agente,@cod_agente,@cod_tipo_agente,@pje_participacion
    EXEC emi_save_comispago_agente_cp @id_pv_wkf,@cod_producto_cial,@cod_agente,@cod_conducto,@cod_ppago
exec emi_sp_calcula_comis @id_pv_wkf=51569382,@pje_comis_normal_usuario=-1,@pje_comis_extra_usuario=-1,@ind_agente=1,@criterio_calc_comis=0
    EXEC dbo.revisa_importe_emision_tempdb_core
exec sp_rep_obtener_comando @p_cod_comando=2221,@p_patrones=N'pid_pv_cero, pid_pv_wkf, pproceso_actividad',@p_valores=N'4681164|51569382|0'
    EXEC @isValid = usp_validar_query @v_val -- 3 VECES
    EXEC emi_endoso_primer_vto 4681164,51569382,0;
exec sp_rep_obtener_comando @p_cod_comando=2232,@p_patrones=N'pid_pv_cero, pid_pv_wkf, pcod_aseg, pfecha_vto, pcod_ppago, pcod_conducto, pnro_tarjeta, pcod_dir_envio',@p_valores=N'4681164|51569382|76401|''25/04/2024''|1|1|''0''|1'
    EXEC @isValid = usp_validar_query @v_val -- 8 VECES
    EXEC emi_endoso_renovacion_ppago 4681164,51569382,76401,'25/04/2024',1,1,'0',1
exec sp_rep_obtener_comando @p_cod_comando=927,@p_patrones=N'currency',@p_valores=N'4'
    EXEC @isValid = usp_validar_query @v_val
exec emi_spc_datos_agente 51569382
    EXEC dbo.revisa_importe_emision_tempdb_core
    EXEC emi_set_comis_ult_endo @id_pv_wkf
    EXEC emi_sp_calcula_comis @id_pv_wkf, -1, -1, 0, 1, @cod_criterio_comis
        EXEC dbo.revisa_importe_emision_tempdb_core
exec emi_spc_datos_comision @id_pv=51569382,@ind_agente=1
exec sp_rep_obtener_comando @p_cod_comando=1232,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec save_process_current 75,227,'51569382'








