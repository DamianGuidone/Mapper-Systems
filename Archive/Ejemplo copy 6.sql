/*  CREAR ENDOSO DE MODIFICACION A PARTIR DE PÓLIZA
====================================================================================================*/
exec get_param_x_descrip @txt_param_descript=N'COD_RAMO_AP'
exec get_param_x_descrip @txt_param_descript=N'COD_PLAN_TEC_INNOMINADO' -- 2 VECES
exec get_param_x_descrip @txt_param_descript=N'COD_ASEG_HER_LEG'
exec get_param_x_descrip @txt_param_descript=N'COD_PROD_PROT_FIN'
exec sp_rep_obtener_comando @p_cod_comando=776,@p_patrones=N'',@p_valores=N''
exec COMM.GET_PARAMETERS @PARAMETER_ID=12146
exec RE_obtener_permisos_usuario @cod_usuario=N'DEMO'
exec RE_obtener_parametro @id=N'PDIST',@subid=N'VEXT'
exec RE_obtener_parametro @id=N'REONL',@subid=N'GUARDADOOBL'
exec RE_obtener_parametro @id=N'EDITENDO',@subid=N'0'
exec get_param_x_descrip @txt_param_descript=N'COD_PAIS_SIN_INFO'
exec RE_obtener_parametro @id=N'PDIST',@subid=N'VEXT'
exec emi_obtiene_ttipo_calle -1
exec RE_obtener_parametro @id=N'REONL',@subid=N'GUARDADOOBL'
exec get_param_x_descrip @txt_param_descript=N'COD_DPTO_SIN_INFO'
exec RE_obtener_parametro @id=N'EDITENDO',@subid=N'0' -- 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=777,@p_patrones=N'country_id',@p_valores=N'15'
	EXEC @isValid = usp_validar_query @v_val
exec COMM.GET_PARAMETERS @PARAMETER_ID=80003
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session'
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session_Alert'
exec get_LocalDecimal 
exec RE_param_obtener_sistema_tipos 
exec sp_rep_obtener_comando @p_cod_comando=1294,@p_patrones=N'p_id_user',@p_valores=N'DEMO'
	EXEC @isValid = usp_validar_query @v_val
exec spc_web_catalogo 'ttipo_dir'
exec sp_rep_obtener_comando @p_cod_comando=2237,@p_patrones=N'pcod_suc',@p_valores=N'3'
	EXEC @isValid = usp_validar_query @v_val
exec sp_seg_sucursales 0
exec sp_rep_obtener_comando @p_cod_comando=758,@p_patrones=N'p_cod_ramo',@p_valores=N'400'
	EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2237,@p_patrones=N'pcod_suc',@p_valores=N'3'
	EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=959,@p_patrones=N'p_nro_pol, p_cod_suc, p_cod_ramo',@p_valores=N'25051528|3|400'
	EXEC @isValid = usp_validar_query @v_val -- 3 VECES
exec sp_rep_obtener_comando @p_cod_comando=1360,@p_patrones=N'prefixId',@p_valores=N'400'
	EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=786,@p_patrones=N'branch_Id',@p_valores=N'400'
	EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1231,@p_patrones=N'prefixId',@p_valores=N'400'
	EXEC @isValid = usp_validar_query @v_val
exec usp_load_combo 'tconvenio','cod_convenio','cod_txt_convenio + '' - '' + txt_desc',''
exec sp_rep_obtener_comando @p_cod_comando=960,@p_patrones=N'branchId,prefixId,policyId',@p_valores=N'3|400|25051528'
	EXEC @isValid = usp_validar_query @v_val
	EXEC cot_get_data_general 25051528, 3, 400; 
		SELECT h.id_pv AS Id ,'Recuperacion' AS [Description] ,aseg = (ltrim(rtrim(ISNULL(p.txt_nombre, ''))) + ' ' + ltrim(rtrim(ISNULL(p.txt_apellido1, ''))) + ' ' + ltrim(rtrim(ISNULL(p.txt_apellido2, '')))) ,h.cod_aseg ,fec_emi = convert(VARCHAR, h.fec_emi, 103) ,fec_vig_desde = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_desde, 103) ELSE convert(VARCHAR,@fec_vig_desde_ult_endoso, 103) END ,time_vig_desde = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_desde, 108) ELSE convert(VARCHAR, @fec_vig_desde_ult_endoso, 108) END  + ' ' + CASE WHEN DATEPART(HOUR, h.fec_vig_desde) >= 12 THEN 'PM' ELSE 'AM' END ,fec_vig_hasta = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_hasta, 103) ELSE convert(VARCHAR, @fec_vig_hasta_ult_endoso, 103) END ,time_vig_hasta = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_hasta, 108) ELSE convert(VARCHAR, @fec_vig_hasta_ult_endoso, 108) END  + ' ' + CASE WHEN DATEPART(HOUR, h.fec_vig_hasta) >= 12 THEN 'PM' ELSE 'AM' END ,h.cod_nivel_facturacion ,h.cod_periodo_fact  , h.cod_moneda ,dbo.emi_fn_get_currency_change(h.cod_moneda, getdate()) imp_cambio ,h.cod_operacion ,h.cod_tipo_agente ,cod_tipo_poliza ,agente = (SELECT (ISNULL(txt_nombre, '') + ' ' + ISNULL(txt_apellido1, '') + ' ' + ISNULL(txt_apellido2, '')) AS agente FROM magente INNER JOIN pv_header ON magente.cod_agente = pv_header.cod_agente AND magente.cod_tipo_agente = pv_header.cod_tipo_agente INNER JOIN mpersona ON mpersona.id_persona = magente.id_persona WHERE pv_header.id_pv = (SELECT max(id_pv) FROM pv_header  WHERE nro_pol = @nro_pol AND cod_suc = @cod_suc AND cod_ramo = @cod_ramo AND cod_grupo_endo NOT IN (14) ) ) ,h.cod_agente ,h.cod_grupo_endo  ,h.cod_tipo_endo ,cod_pto_vta ,cod_tipo_negocio  ,isnull(v.txt_nom_factura, (case when p.cod_tipo_persona = 'F' then ltrim(rtrim(isnull(p.txt_apellido1, ''))) + ' ' +  ltrim(rtrim(isnull(p.txt_apellido2, ''))) + ' ' +  ltrim(rtrim(isnull(p.txt_nombre, ''))) else ltrim(rtrim(p.txt_apellido1)) end ) ) txt_nom_factura ,@resultPayer AS 'looterIsPayer' ,@resultInsured AS 'looterIsInsured' ,@lastEndorsement AS 'lastEndo' ,@lastNumEndo AS 'lastNumEndo' ,v.cod_grupo_caucion ,v.cod_socio ,isnull(v.cod_producto_com, 0) cod_producto_com ,pvc.cod_sub_ramo_fecu subdivision_ramo_fecu ,isnull(pvc.cod_convenio,0) cod_convenio ,'' nro_cotiz, pvc.sn_renovacion_automatica FROM pv_header h INNER JOIN pv_varios v ON h.id_pv = v.id_pv inner join pv_varios_cp pvc on v.id_pv = pvc.id_pv INNER JOIN maseg_header a ON h.cod_aseg = a.cod_aseg INNER JOIN mpersona p ON a.id_persona = p.id_persona INNER JOIN pv_header ph ON ph.id_pv = h.id_pv_cero WHERE h.id_pv = (SELECT max(id_pv) FROM pv_header WHERE nro_pol = @nro_pol AND cod_suc = @cod_suc AND cod_ramo = @cod_ramo ) ORDER BY h.id_pv;
exec sp_rep_obtener_comando @p_cod_comando=949,@p_patrones=N'dateIssuance',@p_valores=N'20250702'
	EXEC @isValid = usp_validar_query @v_val
	EXEC sp_fecha_mov_suc  '20250702', 1, 3, 1, @fecha_real = @fecha OUTPUT
		INSERT INTO @t  EXEC dbo.usp_get_fecha_tope_modulo @cod_modulo
exec get_currency @cod_moneda=4
exec sp_rep_obtener_comando @p_cod_comando=787,@p_patrones=N'grupo_endo_Id,branch_Id',@p_valores=N'2|400'
	EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=1409,@p_patrones=N'prefixId',@p_valores=N'400'
	EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1064,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
exec emi_usp_get_vig_hab @id_pv_cero=5087434,@cod_grupo_endo=2
exec sp_rep_obtener_comando @p_cod_comando=1408,@p_patrones=N'',@p_valores=N''
exec emi_spc_datos_agente -1
	EXEC dbo.revisa_importe_emision_tempdb_core
	EXEC emi_set_comis_ult_endo @id_pv_wkf
	EXEC emi_sp_calcula_comis @id_pv_wkf, -1, -1, 0, 1, @cod_criterio_comis
exec sp_rep_obtener_comando @p_cod_comando=918,@p_patrones=N'branchId',@p_valores=N'3'
	EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=927,@p_patrones=N'currency',@p_valores=N'4'
	EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=790,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=792,@p_patrones=N'sucursal_Id',@p_valores=N'3'
	EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=756,@p_patrones=N'id_user',@p_valores=N'DEMO'
	EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1922,@p_patrones=N'',@p_valores=N''
exec usp_load_combo 'tconvenio','cod_convenio','cod_txt_convenio + '' - '' + txt_desc',''
exec emi_usp_recup_prod_comerciales @cod_ramo=400
exec sp_rep_obtener_comando @p_cod_comando=789,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=917,@p_patrones=N'prefixId',@p_valores=N'400'
	EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=963,@p_patrones=N'policyId',@p_valores=N'5087434'
	EXEC @isValid = usp_validar_query @v_val
	EXEC cot_validate_payer 5087434; -- REVISAR ESTA PARTE!!!!!!!!🤞👀
exec sp_rep_obtener_comando @p_cod_comando=1558,@p_patrones=N'policyId',@p_valores=N'5087434'
	EXEC @isValid = usp_validar_query @v_val
	EXEC cot_validate_benef '5087434';
exec spiu_tult_id_pv_wkf_suc @sn_muestra=-1,@cod_suc=3,@ult_nro=0
exec sp_rep_obtener_comando @p_cod_comando=758,@p_patrones=N'p_cod_ramo',@p_valores=N'400'
	EXEC @isValid = usp_validar_query @v_val
exec cot_execute_command @cod_command=1740,@patterns='policyNumber,policyId',@values='25051528|51621584',@query=default,@proc=1
	EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
		EXEC @isValid = usp_validar_query @v_val -- 2 VECES
		EXEC emi_transfer_real_category '25051528', '51621584';
exec sp_rep_obtener_comando @p_cod_comando=1745,@p_patrones=N'policyId',@p_valores=N'51621584'
	EXEC @isValid = usp_validar_query @v_val
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=2261,@p_patrones=N'prefixCd,policyType',@p_valores=N'400|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=2261,@p_patrones=N'prefixCd,policyType',@p_valores=N'400|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=2167,@p_patrones=N'criteria',@p_valores=N' PIETRO DEPETRIS E HIJOS Y CIA. LTDA. '
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=2167,@p_patrones=N'criteria',@p_valores=N' PIETRO DEPETRIS E HIJOS Y CIA. LTDA. '
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=788,@p_patrones=N'',@p_valores=N''
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=788,@p_patrones=N'',@p_valores=N''
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=787,@p_patrones=N'grupo_endo_Id,branch_Id',@p_valores=N'2|400'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=787,@p_patrones=N'grupo_endo_Id,branch_Id',@p_valores=N'2|400'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=1064,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=1064,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'5087434|-1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'5087434|-1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'5087434|-1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'5087434|-1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=1785,@p_patrones=N'prefixId',@p_valores=N'400'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=1785,@p_patrones=N'prefixId',@p_valores=N'400'
SP:Starting	exec sp_getproducts_filtered @cod_ramo=400,@cod_suc=3
SP:Completed	exec sp_getproducts_filtered @cod_ramo=400,@cod_suc=3
SP:Starting	exec sp_getproducts_filtered @cod_ramo=400,@cod_suc=3
SP:Completed	exec sp_getproducts_filtered @cod_ramo=400,@cod_suc=3
SP:Starting	exec cot_verifica_tipo_operacion @id_pv=51621584
SP:Completed	exec cot_verifica_tipo_operacion @id_pv=51621584
SP:Starting	exec cot_verifica_tipo_operacion @id_pv=51621584
SP:Completed	exec cot_verifica_tipo_operacion @id_pv=51621584
SP:Starting	exec cot_recalculated_quote @id_pv=51621584
SP:Starting	EXEC [dbo].[cot_migrated_recalculated] @id_pv
SP:Completed	EXEC [dbo].[cot_migrated_recalculated] @id_pv
SP:Completed	exec cot_recalculated_quote @id_pv=51621584
SP:Starting	exec cot_verifica_tipo_operacion @id_pv=51621584
SP:Completed	exec cot_verifica_tipo_operacion @id_pv=51621584
SP:Starting	exec emi_cot_summary_risk @id_pv_wkf=51621584,@sn_realRisk=-1
SP:Starting	EXEC usp_emi_summary_risk_general @id_pv_cero, @id_pv_wkf, @SN_RENOVACION, @SN_COTIZACION
SP:Starting	EXEC usp_emi_summary_risk_gral_pol @id_pv_cero,@id_pv,@SN_RENOVACION
SP:Starting	EXEC revisa_importe_emision_tempdb_core
SP:Completed	EXEC revisa_importe_emision_tempdb_core
SP:Completed	EXEC usp_emi_summary_risk_gral_pol @id_pv_cero,@id_pv,@SN_RENOVACION
SP:Completed	EXEC usp_emi_summary_risk_general @id_pv_cero, @id_pv_wkf, @SN_RENOVACION, @SN_COTIZACION
SP:Completed	exec emi_cot_summary_risk @id_pv_wkf=51621584,@sn_realRisk=-1
SP:Starting	exec cot_get_cant_dias_vigen @fec_desde=N'20250531 12:00 PM',@fec_hasta=N'20270531 12:00 PM',@cod_periodo_fact=1
SP:Starting	SET @cant_dias = dbo.fn_dias_vigencia(@fec_desde, @fec_hasta, @cod_periodo_fact)
SP:Completed	SET @cant_dias = dbo.fn_dias_vigencia(@fec_desde, @fec_hasta, @cod_periodo_fact)
SP:Completed	exec cot_get_cant_dias_vigen @fec_desde=N'20250531 12:00 PM',@fec_hasta=N'20270531 12:00 PM',@cod_periodo_fact=1
SP:Starting	exec spc_web_catalogo 'ttipo_dir'
SP:Completed	exec spc_web_catalogo 'ttipo_dir'
SP:Starting	exec cot_get_num_endo @id_pv_cero=5087434,@date_emi='2025-07-02 00:00:00'
SP:Completed	exec cot_get_num_endo @id_pv_cero=5087434,@date_emi='2025-07-02 00:00:00'
SP:Starting	exec emi_save_pv_header @id_pv=51621584,@cod_suc=3,@cod_ramo=400,@nro_pol=25051528,@aaaa_endoso=2025,@nro_endoso=1,@cod_aseg=78225,@fec_emi='2025-07-02 00:00:00',@fec_vig_desde='2025-05-31 12:00:00',@fec_vig_hasta='2027-05-31 12:00:00',@cod_moneda=4,@imp_cambio=39259.230000,@id_pv_modifica=0,@cod_operacion=1,@nro_solicitud=51621584,@nro_cotizacion=1,@cod_tipo_agente=4,@cod_agente=40,@fec_hora_desde='2025-05-31 12:00:00',@id_pv_cero=5087434,@sn_cob_coas_total=0,@cod_grupo_endo=2,@cod_tipo_endo=0,@cod_sistema=1,@sn_bancaseguros=-1,@sn_fronting=0,@cod_periodo_fact=1,@cod_grupo=0,@nro_flota=0,@txt_partic_acreedor=N'50',@cod_nivel_facturacion=0,@cod_nivel_imp_factura=0,@cod_subramo=0
SP:Completed	exec emi_save_pv_header @id_pv=51621584,@cod_suc=3,@cod_ramo=400,@nro_pol=25051528,@aaaa_endoso=2025,@nro_endoso=1,@cod_aseg=78225,@fec_emi='2025-07-02 00:00:00',@fec_vig_desde='2025-05-31 12:00:00',@fec_vig_hasta='2027-05-31 12:00:00',@cod_moneda=4,@imp_cambio=39259.230000,@id_pv_modifica=0,@cod_operacion=1,@nro_solicitud=51621584,@nro_cotizacion=1,@cod_tipo_agente=4,@cod_agente=40,@fec_hora_desde='2025-05-31 12:00:00',@id_pv_cero=5087434,@sn_cob_coas_total=0,@cod_grupo_endo=2,@cod_tipo_endo=0,@cod_sistema=1,@sn_bancaseguros=-1,@sn_fronting=0,@cod_periodo_fact=1,@cod_grupo=0,@nro_flota=0,@txt_partic_acreedor=N'50',@cod_nivel_facturacion=0,@cod_nivel_imp_factura=0,@cod_subramo=0
SP:Starting	exec emi_save_pv_varios @id_pv=51621584,@fec_proceso='2025-07-02 18:28:53.703',@fec_inicio='2025-07-02 18:28:53.703',@fec_fin='2025-07-02 18:28:53.703',@cod_usuario=N'DEMO',@fec_vig_hasta_orig='2027-05-31 12:00:00',@cod_pto_vta=0,@txt_usuario_cotiz=N'DEMO',@cod_tipo_negocio=3,@cod_tipo_poliza=1,@txt_nom_factura=N' PIETRO DEPETRIS E HIJOS Y CIA. LTDA. ',@cod_grupo_caucion=0,@cod_producto_com=0,@cod_socio=-1
SP:Starting	INSERT INTO @vig_prox_facturacion
	  EXEC emi_usp_get_fec_fact_cober @id_pv = @id_pv,
	                                  @sn_temporal = -1
SP:Completed	INSERT INTO @vig_prox_facturacion
	  EXEC emi_usp_get_fec_fact_cober @id_pv = @id_pv,
	                                  @sn_temporal = -1
SP:Completed	exec emi_save_pv_varios @id_pv=51621584,@fec_proceso='2025-07-02 18:28:53.703',@fec_inicio='2025-07-02 18:28:53.703',@fec_fin='2025-07-02 18:28:53.703',@cod_usuario=N'DEMO',@fec_vig_hasta_orig='2027-05-31 12:00:00',@cod_pto_vta=0,@txt_usuario_cotiz=N'DEMO',@cod_tipo_negocio=3,@cod_tipo_poliza=1,@txt_nom_factura=N' PIETRO DEPETRIS E HIJOS Y CIA. LTDA. ',@cod_grupo_caucion=0,@cod_producto_com=0,@cod_socio=-1
SP:Starting	exec emi_usp_traladar_pv_coas_linea @id_pv_wkf=51621584,@id_pv_cero=5087434
SP:Completed	exec emi_usp_traladar_pv_coas_linea @id_pv_wkf=51621584,@id_pv_cero=5087434
SP:Starting	exec cot_execute_command @cod_command=1287,@patterns='policyId',@values='51621584',@query=default,@proc=1
SP:Starting	EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
SP:Completed	exec cot_execute_command @cod_command=1287,@patterns='policyId',@values='51621584',@query=default,@proc=1
SP:Starting	exec cot_execute_command @cod_command=1286,@patterns='quoIdPvCero,policyId',@values='5087434|51621584',@query=default,@proc=1
SP:Starting	EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
SP:Completed	exec cot_execute_command @cod_command=1286,@patterns='quoIdPvCero,policyId',@values='5087434|51621584',@query=default,@proc=1
SP:Starting	exec cot_verifica_tipo_operacion @id_pv=51621584
SP:Completed	exec cot_verifica_tipo_operacion @id_pv=51621584
SP:Starting	exec emi_cot_summary_risk @id_pv_wkf=51621584,@sn_realRisk=-1
SP:Starting	EXEC usp_emi_summary_risk_general @id_pv_cero, @id_pv_wkf, @SN_RENOVACION, @SN_COTIZACION
SP:Starting	EXEC usp_emi_summary_risk_gral_pol @id_pv_cero,@id_pv,@SN_RENOVACION
SP:Starting	EXEC revisa_importe_emision_tempdb_core
SP:Completed	EXEC revisa_importe_emision_tempdb_core
SP:Completed	EXEC usp_emi_summary_risk_gral_pol @id_pv_cero,@id_pv,@SN_RENOVACION
SP:Completed	EXEC usp_emi_summary_risk_general @id_pv_cero, @id_pv_wkf, @SN_RENOVACION, @SN_COTIZACION
SP:Completed	exec emi_cot_summary_risk @id_pv_wkf=51621584,@sn_realRisk=-1
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|1|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,1,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,1,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|1|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|1|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,1,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,1,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|1|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|2|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,2,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,2,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|2|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|2|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,2,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,2,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|2|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|3|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,3,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,3,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|3|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|3|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,3,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,3,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|3|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|4|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,4,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,4,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|4|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|4|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,4,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,4,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|4|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|5|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,5,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,5,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|5|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|5|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,5,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,5,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|5|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|6|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,6,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,6,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|6|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|6|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,6,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,6,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|6|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|7|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,7,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,7,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|7|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|7|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,7,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,7,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|7|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|8|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,8,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,8,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|8|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|8|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,8,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,8,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|8|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|9|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,9,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,9,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|9|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|9|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,9,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,9,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|9|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|10|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,10,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,10,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|10|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|10|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,10,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,10,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|10|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|11|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,11,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,11,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|11|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|11|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,11,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,11,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|11|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|12|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,12,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,12,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|12|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|12|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,12,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,12,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|12|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|13|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,13,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,13,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|13|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|13|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,13,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,13,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|13|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|14|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,14,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,14,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|14|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|14|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,14,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,14,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|14|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|15|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,15,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,15,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|15|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|15|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,15,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,15,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|15|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|16|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,16,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,16,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|16|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|16|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,16,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,16,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|16|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|17|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,17,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,17,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|17|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|17|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,17,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,17,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|17|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|18|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,18,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,18,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|18|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|18|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,18,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,18,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|18|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|19|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,19,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,19,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|19|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|19|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,19,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,19,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|19|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|20|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,20,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,20,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|20|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|20|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,20,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,20,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|20|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|21|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,21,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,21,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|21|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|21|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,21,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,21,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|21|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|22|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,22,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,22,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|22|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|22|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,22,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,22,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|22|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|23|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,23,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,23,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|23|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|23|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,23,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,23,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|23|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|24|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,24,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,24,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|24|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|24|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,24,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,24,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|24|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|25|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,25,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,25,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|25|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|25|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,25,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,25,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|25|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|26|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,26,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,26,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|26|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|26|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,26,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,26,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|26|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|27|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,27,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,27,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|27|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|27|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,27,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,27,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|27|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|28|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,28,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,28,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|28|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|28|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,28,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,28,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|28|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|29|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,29,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,29,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|29|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|29|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,29,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,29,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|29|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|30|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,30,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,30,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|30|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|30|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,30,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,30,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|30|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|31|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,31,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,31,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|31|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|31|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,31,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,31,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|31|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|32|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,32,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,32,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|32|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|32|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,32,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,32,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|32|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|33|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,33,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,33,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|33|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|33|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,33,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,33,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|33|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|34|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,34,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,34,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|34|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|34|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,34,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,34,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|34|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|35|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,35,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,35,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|35|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|35|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,35,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,35,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|35|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|36|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,36,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,36,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|36|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|36|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,36,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,36,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|36|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|37|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,37,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,37,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|37|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|37|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,37,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,37,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|37|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|38|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,38,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,38,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|38|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|38|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,38,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,38,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|38|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|39|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,39,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,39,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|39|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|39|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,39,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,39,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|39|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|40|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,40,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,40,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|40|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|40|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,40,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,40,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|40|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|41|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,41,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,41,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|41|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|41|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,41,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,41,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|41|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|42|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,42,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,42,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|42|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|42|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,42,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,42,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|42|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|43|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,43,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,43,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|43|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|43|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,43,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,43,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|43|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|44|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,44,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,44,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|44|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|44|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,44,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,44,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|44|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|45|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,45,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,45,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|45|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|45|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,45,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,45,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|45|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|46|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,46,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,46,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|46|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|46|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,46,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,46,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|46|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|47|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,47,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,47,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|47|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|47|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,47,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,47,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|47|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|48|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,48,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,48,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|48|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|48|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,48,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,48,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|48|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|49|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,49,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,49,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|49|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|49|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,49,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,49,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|49|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|50|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,50,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,50,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|50|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|50|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,50,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,50,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|50|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|51|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,51,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,51,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|51|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|51|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,51,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,51,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|51|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|52|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,52,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,52,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|52|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|52|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,52,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,52,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|52|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|53|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,53,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,53,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|53|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|53|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,53,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,53,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|53|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|54|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,54,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,54,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|54|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|54|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,54,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,54,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|54|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|55|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,55,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,55,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|55|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|55|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,55,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,55,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|55|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|56|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,56,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,56,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|56|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|56|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,56,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,56,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|56|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|57|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,57,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,57,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|57|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|57|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,57,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,57,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|57|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|58|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,58,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,58,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|58|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|58|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,58,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,58,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|58|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|59|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,59,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,59,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|59|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|59|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,59,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,59,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|59|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|60|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,60,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,60,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|60|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|60|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,60,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,60,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|60|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|61|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,61,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,61,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|61|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|61|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,61,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,61,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|61|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|62|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,62,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,62,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|62|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|62|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,62,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,62,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|62|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|63|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,63,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,63,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|63|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|63|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,63,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,63,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|63|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|64|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,64,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,64,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|64|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|64|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,64,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,64,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|64|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|65|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,65,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,65,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|65|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|65|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,65,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,65,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|65|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|66|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,66,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,66,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|66|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|66|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,66,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,66,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|66|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|67|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,67,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,67,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|67|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|67|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,67,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,67,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|67|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|68|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,68,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,68,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|68|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|68|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,68,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,68,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|68|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|69|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,69,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,69,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|69|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|69|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,69,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,69,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|69|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|70|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,70,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,70,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|70|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|70|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,70,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,70,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|70|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|71|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,71,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,71,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|71|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|71|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,71,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,71,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|71|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|72|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,72,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,72,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|72|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|72|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,72,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,72,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|72|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|73|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,73,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,73,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|73|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|73|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,73,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,73,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|73|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|74|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,74,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,74,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|74|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|74|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,74,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,74,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|74|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|75|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,75,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,75,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|75|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|75|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,75,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,75,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|75|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|76|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,76,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,76,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|76|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|76|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,76,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,76,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|76|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|77|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,77,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,77,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|77|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|77|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,77,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,77,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|77|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|78|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,78,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,78,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|78|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|78|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,78,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,78,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|78|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|79|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,79,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,79,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|79|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|79|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,79,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,79,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|79|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|80|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,80,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,80,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|80|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|80|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,80,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,80,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|80|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|81|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,81,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,81,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|81|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|81|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,81,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,81,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|81|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|82|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,82,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,82,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|82|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|82|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,82,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,82,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|82|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|83|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,83,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,83,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|83|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|83|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,83,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,83,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|83|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|84|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,84,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,84,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|84|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|84|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,84,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,84,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|84|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|85|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,85,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,85,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|85|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|85|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,85,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,85,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|85|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|86|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,86,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,86,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|86|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|86|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,86,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,86,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|86|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|87|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,87,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,87,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|87|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|87|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,87,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,87,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|87|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|88|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,88,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,88,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|88|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|88|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,88,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,88,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|88|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|89|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,89,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,89,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|89|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|89|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,89,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,89,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|89|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|90|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,90,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,90,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|90|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|90|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,90,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,90,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|90|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|91|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,91,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,91,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|91|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|91|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,91,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,91,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|91|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|92|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,92,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,92,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|92|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|92|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,92,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,92,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|92|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|93|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,93,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,93,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|93|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|93|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,93,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,93,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|93|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|94|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,94,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,94,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|94|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|94|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,94,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,94,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|94|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|95|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,95,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,95,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|95|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|95|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,95,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,95,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|95|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|96|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,96,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,96,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|96|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|96|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,96,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,96,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|96|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|97|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,97,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,97,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|97|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|97|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,97,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,97,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|97|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|98|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,98,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,98,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|98|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|98|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,98,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,98,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|98|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|99|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,99,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,99,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|99|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|99|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,99,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,99,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|99|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|100|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,100,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,100,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|100|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|100|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,100,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,100,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|100|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|101|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,101,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,101,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|101|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|101|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,101,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,101,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|101|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|102|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,102,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,102,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|102|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|102|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,102,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,102,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|102|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|103|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,103,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,103,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|103|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|103|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,103,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,103,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|103|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|104|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,104,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,104,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|104|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|104|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,104,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,104,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|104|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|105|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,105,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,105,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|105|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|105|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,105,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,105,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|105|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|106|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,106,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,106,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|106|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|106|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,106,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,106,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|106|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|107|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,107,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,107,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|107|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|107|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,107,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,107,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|107|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|108|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,108,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,108,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|108|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|108|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,108,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,108,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|108|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|109|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,109,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,109,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|109|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|109|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,109,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,109,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|109|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|110|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,110,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,110,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|110|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|110|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,110,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,110,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|110|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|111|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,111,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,111,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|111|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|111|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,111,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,111,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|111|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|112|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,112,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,112,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|112|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|112|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,112,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,112,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|112|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|113|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,113,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,113,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|113|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|113|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,113,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,113,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|113|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|114|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,114,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,114,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|114|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|114|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,114,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,114,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|114|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|115|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,115,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,115,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|115|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|115|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,115,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,115,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|115|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|116|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,116,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,116,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|116|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|116|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,116,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,116,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|116|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|117|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,117,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,117,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|117|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|117|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,117,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,117,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|117|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|118|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,118,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,118,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|118|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|118|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,118,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,118,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|118|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|119|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,119,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,119,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|119|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|119|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,119,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,119,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|119|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|120|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,120,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,120,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|120|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|120|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,120,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,120,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|120|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|121|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,121,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,121,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|121|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|121|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,121,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,121,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|121|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|122|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,122,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,122,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|122|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|122|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,122,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,122,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|122|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|123|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,123,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,123,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|123|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|123|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,123,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,123,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|123|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|124|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,124,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,124,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|124|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|124|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,124,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,124,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|124|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|125|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,125,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,125,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|125|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|125|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,125,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,125,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|125|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|126|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,126,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,126,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|126|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|126|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,126,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,126,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|126|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|127|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,127,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,127,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|127|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|127|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,127,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,127,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|127|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|128|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,128,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,128,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|128|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|128|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,128,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,128,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|128|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|129|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,129,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,129,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|129|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|129|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,129,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,129,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|129|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|130|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,130,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,130,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|130|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|130|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,130,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,130,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|130|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|131|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,131,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,131,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|131|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|131|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,131,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,131,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|131|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|132|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,132,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,132,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|132|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|132|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,132,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,132,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|132|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|133|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,133,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,133,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|133|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|133|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,133,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,133,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|133|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|134|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,134,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,134,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|134|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|134|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,134,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,134,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|134|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|135|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,135,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,135,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|135|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|135|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,135,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,135,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|135|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|136|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,136,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,136,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|136|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|136|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,136,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,136,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|136|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|137|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,137,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,137,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|137|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|137|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,137,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,137,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|137|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|138|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,138,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,138,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|138|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|138|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,138,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,138,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|138|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|139|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,139,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,139,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|139|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|139|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,139,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,139,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|139|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|140|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,140,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,140,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|140|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|140|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,140,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,140,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|140|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|141|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,141,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,141,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|141|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|141|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,141,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,141,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|141|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|142|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,142,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,142,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|142|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|142|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,142,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,142,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|142|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|143|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,143,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,143,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|143|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|143|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,143,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,143,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|143|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|144|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,144,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,144,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|144|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|144|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,144,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,144,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|144|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|145|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,145,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,145,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|145|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|145|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,145,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,145,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|145|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|146|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,146,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,146,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|146|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|146|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,146,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,146,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|146|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|147|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,147,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,147,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|147|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|147|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,147,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,147,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|147|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|148|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,148,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,148,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|148|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|148|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,148,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,148,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|148|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|149|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,149,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,149,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|149|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|149|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,149,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,149,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|149|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|150|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,150,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,150,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|150|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|150|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,150,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,150,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|150|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|151|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,151,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,151,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|151|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|151|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,151,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,151,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|151|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|152|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,152,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,152,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|152|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|152|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,152,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,152,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|152|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|153|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,153,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,153,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|153|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|153|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,153,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,153,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|153|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|154|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,154,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,154,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|154|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|154|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,154,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,154,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|154|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|155|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,155,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,155,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|155|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|155|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,155,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,155,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|155|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|156|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,156,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,156,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|156|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|156|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,156,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,156,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|156|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|157|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,157,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,157,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|157|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|157|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,157,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,157,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|157|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|158|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,158,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,158,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|158|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|158|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,158,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,158,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|158|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|159|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,159,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,159,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|159|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|159|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,159,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,159,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|159|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|160|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,160,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,160,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|160|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|160|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,160,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,160,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|160|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|161|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,161,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,161,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|161|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|161|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,161,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,161,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|161|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|162|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,162,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,162,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|162|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|162|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,162,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,162,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|162|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|163|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,163,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,163,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|163|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|163|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,163,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,163,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|163|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|164|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,164,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,164,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|164|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|164|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,164,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,164,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|164|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|165|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,165,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,165,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|165|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|165|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,165,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,165,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|165|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|166|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,166,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,166,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|166|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|166|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,166,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,166,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|166|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|167|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,167,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,167,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|167|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|167|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,167,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,167,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|167|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|168|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,168,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,168,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|168|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|168|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,168,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,168,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|168|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|169|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,169,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,169,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|169|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|169|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,169,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,169,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|169|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|170|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,170,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,170,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|170|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|170|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,170,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,170,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|170|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|171|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,171,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,171,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|171|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|171|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,171,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,171,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|171|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|172|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,172,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,172,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|172|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|172|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,172,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,172,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|172|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|173|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,173,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,173,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|173|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|173|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,173,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,173,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|173|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|174|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,174,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,174,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|174|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|174|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,174,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,174,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|174|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|175|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,175,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,175,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|175|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|175|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,175,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,175,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|175|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|176|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,176,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,176,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|176|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|176|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,176,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,176,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|176|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|177|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,177,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,177,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|177|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|177|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,177,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,177,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|177|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|178|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,178,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,178,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|178|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|178|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,178,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,178,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|178|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|179|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,179,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,179,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|179|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|179|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,179,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,179,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|179|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|180|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,180,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,180,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|180|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|180|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,180,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,180,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|180|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|181|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,181,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,181,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|181|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|181|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,181,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,181,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|181|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|182|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,182,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,182,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|182|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|182|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,182,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,182,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|182|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|183|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,183,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,183,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|183|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|183|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,183,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,183,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|183|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|184|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,184,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,184,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|184|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|184|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,184,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,184,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|184|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|185|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,185,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,185,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|185|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|185|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,185,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,185,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|185|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|186|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,186,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,186,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|186|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|186|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,186,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,186,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|186|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|187|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,187,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,187,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|187|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|187|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,187,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,187,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|187|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|188|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,188,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,188,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|188|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|188|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,188,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,188,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|188|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|189|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,189,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,189,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|189|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|189|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,189,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,189,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|189|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|190|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,190,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,190,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|190|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|190|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,190,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,190,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|190|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|191|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,191,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,191,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|191|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|191|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,191,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,191,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|191|2'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|192|1'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,192,1;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,192,1;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|192|1'
SP:Starting	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|192|2'
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	EXEC @isValid = usp_validar_query @v_val
SP:Completed	EXEC @isValid = usp_validar_query @v_val
SP:Starting	emi_spc_get_sum_cob_item 51621584,-1,192,2;
SP:Completed	emi_spc_get_sum_cob_item 51621584,-1,192,2;
SP:Completed	exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51621584|-1|192|2'














