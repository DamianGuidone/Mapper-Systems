/*  AVANZAR A PANTALLA DE RIESGOS
====================================================================================================*/
exec emi_usp_existen_riesgos_wkf 51560090
exec sp_rep_obtener_comando @p_cod_comando=2255,@p_patrones=N'pid_pv_wkf',@p_valores=N'51560090'
exec sp_rep_obtener_comando @p_cod_comando=2260,@p_patrones=N'pid_pv_wkf',@p_valores=N'51560090'
    -- exec sp_validar_agente_habilitado_cp 51560090
exec sp_rep_obtener_comando @p_cod_comando=20188,@p_patrones=N'pid_pv,pfec_emi,pfec_vig_desde,pfec_vig_hasta,pcod_conducto,pcod_ppago',@p_valores=N'51560090|''2025-05-08''|''2025-05-24''|''2026-05-24''|1|1'
    -- SELECT convert(varchar(10), fec_1_vto, 103) AS primer_vto, '' FROM dbo.emi_ufn_calcular_primer_vto(51560090, '2025-05-08', '2025-05-24', '2026-05-24', 1, 1)
exec cot_get_num_endo @id_pv_cero=0,@date_emi='2025-05-08 00:00:00'
exec emi_save_pv_header @id_pv=51560090,@cod_suc=1,@cod_ramo=200,@nro_pol=0,@aaaa_endoso=2025,@nro_endoso=0,@cod_aseg=203188,@fec_emi='2025-05-08 00:00:00',@fec_vig_desde='2025-05-24 12:00:00',@fec_vig_hasta='2026-05-24 12:00:00',@cod_moneda=4,@imp_cambio=39107.9,@id_pv_modifica=0,@cod_operacion=1,@nro_solicitud=51560090,@nro_cotizacion=-1,@cod_tipo_agente=4,@cod_agente=3031,@fec_hora_desde='2025-05-24 12:00:00',@id_pv_cero=0,@sn_cob_coas_total=0,@cod_grupo_endo=1,@cod_tipo_endo=1,@cod_sistema=1,@sn_bancaseguros=-1,@sn_fronting=0,@cod_periodo_fact=1,@cod_grupo=0,@nro_flota=0,@txt_partic_acreedor=N'50',@cod_nivel_facturacion=0,@cod_nivel_imp_factura=0,@cod_subramo=0
    -- SELECT @old_cod_aseg = cod_aseg, @imp_cambio = dbo.emi_fn_get_currency_change(cod_moneda, getdate()) FROM pv_header_wkf WHERE id_pv = @id_pv
exec emi_save_pv_varios @id_pv=51560090,@fec_proceso='2025-05-08 16:04:40.113',@fec_inicio='2025-05-08 16:04:40.113',@fec_fin='2025-05-08 16:04:40.113',@cod_usuario=N'DEMO',@fec_vig_hasta_orig='2026-05-24 12:00:00',@cod_pto_vta=1,@txt_usuario_cotiz=N'DEMO',@cod_tipo_negocio=3,@cod_tipo_poliza=1,@txt_nom_factura=N' ACUICOLA E INVERSIONES NALCAHUE LTDA ',@cod_grupo_caucion=0,@cod_producto_com=0,@cod_socio=-1
    -- INSERT INTO @vig_prox_facturacion EXEC emi_usp_get_fec_fact_cober @id_pv = @id_pv, @sn_temporal = -1
exec emi_save_pvc_varios @id_pv=51560090,@nro_propuesta_interna=N'123',@nro_propuesta_externa=default,@sn_renovacion_automatica=0,@subdivision_ramo_fecu=1,@cod_convenio=0,@nro_cotiz=default
exec sp_rep_obtener_comando @p_cod_comando=2203,@p_patrones=N'p_id_pv,p_cod_producto_cial,p_cod_agente,p_cod_conducto,p_cod_ppago',@p_valores=N'51560090|-1|3031|1|1'
    -- emi_save_comispago_agente 51560090, -1, 3031, 1, 1;
exec sp_rep_obtener_comando @p_cod_comando=927,@p_patrones=N'currency',@p_valores=N'4'
exec emi_genera_pv_agente @id_pv_wkf=51560090,@ind_agente=1,@cod_agente=3031,@cod_tipo_agente=4,@pje_participacion=100
    -- exec emi_genera_pv_agente_core @id_pv_wkf, @ind_agente, @cod_agente, @cod_tipo_agente, @pje_participacion
    -- EXEC emi_save_comispago_agente_cp @id_pv_wkf, @cod_producto_cial, @cod_agente, @cod_conducto, @cod_ppago
exec emi_sp_calcula_comis @id_pv_wkf=51560090,@pje_comis_normal_usuario=-1,@pje_comis_extra_usuario=-1,@ind_agente=1,@criterio_calc_comis=0
    -- EXEC dbo.revisa_importe_emision_tempdb_core
exec save_process_current 5,227,'51560090'
exec emi_spc_datos_agente 51560090
    -- EXEC dbo.revisa_importe_emision_tempdb_core
    -- EXEC emi_sp_calcula_comis @id_pv_wkf, -1, -1, 0, 1, @cod_criterio_comis
        -- EXEC dbo.revisa_importe_emision_tempdb_core