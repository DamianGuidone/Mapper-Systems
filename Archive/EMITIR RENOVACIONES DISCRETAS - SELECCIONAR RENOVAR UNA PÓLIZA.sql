/*  EMITIR RENOVACIONES DISCRETAS - SELECCIONAR RENOVAR UNA PÓLIZA
====================================================================================================*/
exec get_param_x_descrip @txt_param_descript=N'COD_RAMO_AP'
exec get_param_x_descrip @txt_param_descript=N'COD_PLAN_TEC_INNOMINADO' -- X2
exec get_param_x_descrip @txt_param_descript=N'COD_ASEG_HER_LEG'
exec get_param_x_descrip @txt_param_descript=N'COD_PROD_PROT_FIN'
exec sp_rep_obtener_comando @p_cod_comando=776,@p_patrones=N'',@p_valores=N''
exec COMM.GET_PARAMETERS @PARAMETER_ID=12146
exec RE_obtener_permisos_usuario @cod_usuario=N'DEMO'
exec RE_obtener_parametro @id=N'PDIST',@subid=N'VEXT'
exec RE_obtener_parametro @id=N'REONL',@subid=N'GUARDADOOBL'
exec RE_obtener_parametro @id=N'EDITENDO',@subid=N'0'
exec get_param_x_descrip @txt_param_descript=N'COD_DPTO_SIN_INFO'
exec emi_obtiene_ttipo_calle -1
exec RE_obtener_parametro @id=N'PDIST',@subid=N'VEXT'
exec RE_obtener_parametro @id=N'REONL',@subid=N'GUARDADOOBL'
exec RE_obtener_parametro @id=N'EDITENDO',@subid=N'0' -- X2
exec sp_rep_obtener_comando @p_cod_comando=777,@p_patrones=N'country_id',@p_valores=N'15'
    EXEC @isValid = usp_validar_query @v_val
exec get_param_x_descrip @txt_param_descript=N'COD_PAIS_SIN_INFO'
exec spc_web_catalogo 'ttipo_dir'
exec COMM.GET_PARAMETERS @PARAMETER_ID=80003
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session'
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session_Alert'
exec get_LocalDecimal 
exec RE_param_obtener_sistema_tipos 
exec sp_rep_obtener_comando @p_cod_comando=1294,@p_patrones=N'p_id_user',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec sp_seg_sucursales 0
exec sp_rep_obtener_comando @p_cod_comando=756,@p_patrones=N'id_user',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2237,@p_patrones=N'pcod_suc',@p_valores=N'8'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=758,@p_patrones=N'p_cod_ramo',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2237,@p_patrones=N'pcod_suc',@p_valores=N'8'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=959,@p_patrones=N'p_nro_pol, p_cod_suc, p_cod_ramo',@p_valores=N'24093823|8|500'    
    EXEC @isValid = usp_validar_query @v_val -- X3
exec sp_rep_obtener_comando @p_cod_comando=1360,@p_patrones=N'prefixId',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=789,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=790,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=792,@p_patrones=N'sucursal_Id',@p_valores=N'8'
    EXEC @isValid = usp_validar_query @v_val
exec usp_load_combo 'tconvenio','cod_convenio','cod_txt_convenio + '' - '' + txt_desc',''
exec sp_rep_obtener_comando @p_cod_comando=1409,@p_patrones=N'prefixId',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1408,@p_patrones=N'',@p_valores=N''
exec emi_usp_recup_prod_comerciales @cod_ramo=500
exec sp_rep_obtener_comando @p_cod_comando=960,@p_patrones=N'branchId,prefixId,policyId',@p_valores=N'8|500|24093823'
    EXEC @isValid = usp_validar_query @v_val -- X3
    EXEC cot_get_data_general 24093823, 8, 500;
        SELECT h.id_pv AS Id ,'Recuperacion' AS [Description] ,aseg = (ltrim(rtrim(ISNULL(p.txt_nombre, ''))) + ' ' + ltrim(rtrim(ISNULL(p.txt_apellido1, ''))) + ' ' + ltrim(rtrim(ISNULL(p.txt_apellido2, '')))) ,h.cod_aseg ,fec_emi = convert(VARCHAR, h.fec_emi, 103) ,fec_vig_desde = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_desde, 103) ELSE convert(VARCHAR,@fec_vig_desde_ult_endoso, 103) END,time_vig_desde = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_desde, 108) ELSE convert(VARCHAR, @fec_vig_desde_ult_endoso, 108) END  + ' ' + CASE WHEN DATEPART(HOUR, h.fec_vig_desde) >= 12 THEN 'PM' ELSE 'AM' END,fec_vig_hasta = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_hasta, 103) ELSE convert(VARCHAR, @fec_vig_hasta_ult_endoso, 103) END,time_vig_hasta = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_hasta, 108) ELSE convert(VARCHAR, @fec_vig_hasta_ult_endoso, 108) END  + ' ' + CASE WHEN DATEPART(HOUR, h.fec_vig_hasta) >= 12 THEN 'PM' ELSE 'AM' END,h.cod_nivel_facturacion ,h.cod_periodo_fact , h.cod_moneda  ,dbo.emi_fn_get_currency_change(h.cod_moneda, getdate()) imp_cambio ,h.cod_operacion ,h.cod_tipo_agente ,cod_tipo_poliza ,agente = (SELECT (ISNULL(txt_nombre, '') + ' ' + ISNULL(txt_apellido1, '') + ' ' + ISNULL(txt_apellido2, '')) AS agente FROM magente INNER JOIN pv_header ON magente.cod_agente = pv_header.cod_agente AND magente.cod_tipo_agente = pv_header.cod_tipo_agente INNER JOIN mpersona ON mpersona.id_persona = magente.id_persona WHERE pv_header.id_pv = (SELECT max(id_pv) FROM pv_header WHERE nro_pol = @nro_pol AND cod_suc = @cod_suc AND cod_ramo = @cod_ramo AND cod_grupo_endo NOT IN (14) ) ) ,h.cod_agente ,h.cod_grupo_endo ,h.cod_tipo_endo ,cod_pto_vta ,cod_tipo_negocio ,isnull(v.txt_nom_factura, (case when p.cod_tipo_persona = 'F' then ltrim(rtrim(isnull(p.txt_apellido1, ''))) + ' ' + ltrim(rtrim(isnull(p.txt_apellido2, ''))) + ' ' + ltrim(rtrim(isnull(p.txt_nombre, ''))) else ltrim(rtrim(p.txt_apellido1)) end ) ) txt_nom_factura ,@resultPayer AS 'looterIsPayer' ,@resultInsured AS 'looterIsInsured' ,@lastEndorsement AS 'lastEndo' ,@lastNumEndo AS 'lastNumEndo'  ,v.cod_grupo_caucion  ,v.cod_socio ,isnull(v.cod_producto_com, 0) cod_producto_com ,pvc.cod_sub_ramo_fecu subdivision_ramo_fecu ,isnull(pvc.cod_convenio,0) cod_convenio ,'' nro_cotiz, pvc.sn_renovacion_automatica
        FROM pv_header h INNER JOIN pv_varios v ON h.id_pv = v.id_pv inner join pv_varios_cp pvc on v.id_pv = pvc.id_pv INNER JOIN maseg_header a ON h.cod_aseg = a.cod_aseg INNER JOIN mpersona p ON a.id_persona = p.id_persona INNER JOIN pv_header ph ON ph.id_pv = h.id_pv_cero --     #63285 malvarado
        WHERE h.id_pv = (SELECT max(id_pv) FROM pv_header WHERE nro_pol = @nro_pol AND cod_suc = @cod_suc AND cod_ramo = @cod_ramo ) ORDER BY h.id_pv
exec sp_rep_obtener_comando @p_cod_comando=927,@p_patrones=N'currency',@p_valores=N'4'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=788,@p_patrones=N'',@p_valores=N''
    exec get_currency @cod_moneda=4
exec sp_rep_obtener_comando @p_cod_comando=786,@p_patrones=N'branch_Id',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=787,@p_patrones=N'grupo_endo_Id,branch_Id',@p_valores=N'5|500'
    EXEC @isValid = usp_validar_query @v_val -- X2
exec sp_rep_obtener_comando @p_cod_comando=1064,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec emi_spc_datos_agente -1
    EXEC dbo.revisa_importe_emision_tempdb_core
    EXEC emi_set_comis_ult_endo @id_pv_wkf
    EXEC emi_sp_calcula_comis @id_pv_wkf, -1, -1, 0, 1, @cod_criterio_comis
exec sp_rep_obtener_comando @p_cod_comando=918,@p_patrones=N'branchId',@p_valores=N'8'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1231,@p_patrones=N'prefixId',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1922,@p_patrones=N'',@p_valores=N''
exec usp_load_combo 'tconvenio','cod_convenio','cod_txt_convenio + '' - '' + txt_desc',''
exec sp_rep_obtener_comando @p_cod_comando=949,@p_patrones=N'dateIssuance',@p_valores=N'20250721'
    EXEC @isValid = usp_validar_query @v_val
    EXEC sp_fecha_mov_suc  '20250721', 1, 3, 1, @fecha_real = @fecha OUTPUT
        INSERT INTO @t  EXEC dbo.usp_get_fecha_tope_modulo @cod_modulo
exec sp_rep_obtener_comando @p_cod_comando=917,@p_patrones=N'prefixId',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=963,@p_patrones=N'policyId',@p_valores=N'4719086'
    EXEC @isValid = usp_validar_query @v_val
    EXEC cot_validate_payer 4719086;
exec sp_rep_obtener_comando @p_cod_comando=1558,@p_patrones=N'policyId',@p_valores=N'4719086'
    EXEC @isValid = usp_validar_query @v_val
    EXEC cot_validate_benef '4719086';
exec spiu_tult_id_pv_wkf_suc @sn_muestra=-1,@cod_suc=8,@ult_nro=0
exec sp_rep_obtener_comando @p_cod_comando=787,@p_patrones=N'grupo_endo_Id,branch_Id',@p_valores=N'5|500'
    EXEC @isValid = usp_validar_query @v_val -- X2
exec sp_rep_obtener_comando @p_cod_comando=1080,@p_patrones=N'',@p_valores=N''
exec cot_execute_command @cod_command=1740,@patterns='policyNumber,policyId',@values='24093823|51633984',@query=default,@proc=1
    EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
        EXEC @isValid = usp_validar_query @v_val -- X2
    EXEC emi_transfer_real_category '24093823', '51633984';
exec sp_rep_obtener_comando @p_cod_comando=1745,@p_patrones=N'policyId',@p_valores=N'51633984'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=758,@p_patrones=N'p_cod_ramo',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2261,@p_patrones=N'prefixCd,policyType',@p_valores=N'500|1'
    EXEC @isValid = usp_validar_query @v_val -- X2
exec sp_rep_obtener_comando @p_cod_comando=2167,@p_patrones=N'criteria',@p_valores=N' ASESORÍAS Y SERVICIOS MECO AUSTRAL LTDA. '   
    EXEC @isValid = usp_validar_query @v_val 
exec cot_get_cant_dias_vigen @fec_desde=N'20240526 12:00 PM',@fec_hasta=N'20250526 12:00 PM',@cod_periodo_fact=1
    SET @cant_dias = dbo.fn_dias_vigencia(@fec_desde, @fec_hasta, @cod_periodo_fact)
exec sp_rep_obtener_comando @p_cod_comando=1064,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4719086|-1' -- X2
    EXEC @isValid = usp_validar_query @v_val -- X2
exec sp_rep_obtener_comando @p_cod_comando=1785,@p_patrones=N'prefixId',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_getproducts_filtered @cod_ramo=500,@cod_suc=8 -- X2
exec cot_verifica_tipo_operacion @id_pv=51633984 -- X2
exec cot_recalculated_quote @id_pv=51633984
    EXEC [dbo].[cot_migrated_recalculated] @id_pv
exec cot_verifica_tipo_operacion @id_pv=51633984
exec emi_cot_summary_risk @id_pv_wkf=51633984,@sn_realRisk=-1
    EXEC usp_emi_summary_risk_general @id_pv_cero, @id_pv_wkf, @SN_RENOVACION, @SN_COTIZACION
        EXEC usp_emi_summary_risk_gral_pol @id_pv_cero,@id_pv,@SN_RENOVACION
            EXEC revisa_importe_emision_tempdb_core
exec emi_save_payer_risk @id_pv=51633984,@cod_item=-1,@cod_aseg=156735,@method_pay=52,@ind_conducto=-1,@means_pay=30,@card_pay=N'5218******7466364',@date_from='2024-05-26 00:00:00',@date_to='2025-05-26 00:00:00',@participation=100,@cod_dir_envio=1,@proc=1,@tipo_facturacion=1,@periodicidad_orden=-1,@nro_orden_compra=N'-1',@firstDueDate='2024-06-15 00:00:00'
    EXEC emi_save_pvc_pagador @id_pv ,@tipo_facturacion ,@periodicidad_orden ,@nro_orden_compra
exec spc_web_catalogo 'ttipo_dir'