/*  CARGA DE DATOS GENERALES ENDOSO DE MODIFICACION
====================================================================================================*/
exec get_param_x_descrip @txt_param_descript=N'COD_RAMO_AP'
exec get_param_x_descrip @txt_param_descript=N'COD_PLAN_TEC_INNOMINADO' -- 2 VECES
exec get_param_x_descrip @txt_param_descript=N'COD_ASEG_HER_LEG'
exec get_param_x_descrip @txt_param_descript=N'COD_PROD_PROT_FIN'
exec sp_obtener_mod_sub_x_usuario @id_usuario=0
exec sp_obtener_sub_mod_x_usuario @id_usuario=default
exec COMM.GET_PARAMETERS @PARAMETER_ID=12146
exec RE_obtener_permisos_usuario @cod_usuario=N'DEMO'
exec RE_obtener_parametro @id=N'PDIST',@subid=N'VEXT'
exec RE_obtener_parametro @id=N'REONL',@subid=N'GUARDADOOBL'
exec RE_obtener_parametro @id=N'EDITENDO',@subid=N'0'
exec emi_obtiene_ttipo_calle -1
exec RE_obtener_parametro @id=N'PDIST',@subid=N'VEXT'
exec RE_obtener_parametro @id=N'REONL',@subid=N'GUARDADOOBL'
exec RE_obtener_parametro @id=N'EDITENDO',@subid=N'0' -- 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=776,@p_patrones=N'',@p_valores=N''
exec spc_web_catalogo 'ttipo_dir'
exec get_param_x_descrip @txt_param_descript=N'COD_DPTO_SIN_INFO'
exec get_param_x_descrip @txt_param_descript=N'COD_PAIS_SIN_INFO'
exec COMM.GET_PARAMETERS @PARAMETER_ID=80003
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session'
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session_Alert'
exec usp_obtener_notificaciones 'DEMO'
exec get_LocalDecimal 
exec RE_param_obtener_sistema_tipos 
exec sp_rep_obtener_comando @p_cod_comando=756,@p_patrones=N'id_user',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2237,@p_patrones=N'pcod_suc',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=758,@p_patrones=N'p_cod_ramo',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1294,@p_patrones=N'p_id_user',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec sp_seg_sucursales 0
exec sp_rep_obtener_comando @p_cod_comando=2237,@p_patrones=N'pcod_suc',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=959,@p_patrones=N'p_nro_pol, p_cod_suc, p_cod_ramo',@p_valores=N'24058902|1|500'
    EXEC @isValid = usp_validar_query @v_val -- 3 VECES
exec sp_rep_obtener_comando @p_cod_comando=1360,@p_patrones=N'prefixId',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=960,@p_patrones=N'branchId,prefixId,policyId',@p_valores=N'1|500|24058902'
    EXEC @isValid = usp_validar_query @v_val -- 3 VECES
    EXEC cot_get_data_general 24058902, 1, 500;
        SELECT h.id_pv AS Id      
            ,'Recuperacion' AS [Description]      
            ,aseg = (ltrim(rtrim(ISNULL(p.txt_nombre, ''))) + ' ' + ltrim(rtrim(ISNULL(p.txt_apellido1, ''))) + ' ' + ltrim(rtrim(ISNULL(p.txt_apellido2, ''))))      
            ,h.cod_aseg      
            ,fec_emi = convert(VARCHAR, h.fec_emi, 103)--#63285 malvarado <agrego alias>
            --REQ63307 malvarado <Si esta cancelaca, devuelvo la vigencia de cancelacion>
            ,fec_vig_desde = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_desde, 103) ELSE convert(VARCHAR,@fec_vig_desde_ult_endoso, 103) END
            ,time_vig_desde = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_desde, 108) ELSE convert(VARCHAR, @fec_vig_desde_ult_endoso, 108) END  + ' ' + CASE WHEN DATEPART(HOUR, h.fec_vig_desde) >= 12 THEN 'PM' ELSE 'AM' END
            ,fec_vig_hasta = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_hasta, 103) ELSE convert(VARCHAR, @fec_vig_hasta_ult_endoso, 103) END
            ,time_vig_hasta = CASE WHEN @sn_cancelada = 0 AND @fin_contrato = 0 THEN convert(VARCHAR, ph.fec_vig_hasta, 108) ELSE convert(VARCHAR, @fec_vig_hasta_ult_endoso, 108) END  + ' ' + CASE WHEN DATEPART(HOUR, h.fec_vig_hasta) >= 12 THEN 'PM' ELSE 'AM' END
            /*,fec_vig_desde = convert(VARCHAR, h.fec_vig_desde, 103)
            ,time_vig_desde = convert(VARCHAR, h.fec_vig_desde, 108)
            ,fec_vig_hasta = convert(VARCHAR, h.fec_vig_hasta, 103)
            ,time_vig_hasta = convert(VARCHAR, h.fec_vig_hasta, 108)*/
            --REQ63307 malvarado <Si esta cancelaca, devuelvo la vigencia de cancelacion>    
            ,h.cod_nivel_facturacion      
            ,h.cod_periodo_fact      
            ,--REQ - 17135 Gcombariza      
            h.cod_moneda     --#63285 malvarado <agrego alias>
            --,h.imp_cambio    --#63285 malvarado <agrego alias>
            ,dbo.emi_fn_get_currency_change(h.cod_moneda, getdate()) imp_cambio  --Req. 77280 LFREIRE
            ,h.cod_operacion --#63285 malvarado <agrego alias>     
            ,h.cod_tipo_agente      
            ,cod_tipo_poliza      
            ,agente = (SELECT (ISNULL(txt_nombre, '') + ' ' + ISNULL(txt_apellido1, '') + ' ' + ISNULL(txt_apellido2, '')) AS agente
                        FROM magente
                        INNER JOIN pv_header ON magente.cod_agente = pv_header.cod_agente
                                        AND magente.cod_tipo_agente = pv_header.cod_tipo_agente
                        INNER JOIN mpersona ON mpersona.id_persona = magente.id_persona
                        WHERE pv_header.id_pv = (SELECT max(id_pv)
                                                FROM pv_header
                                                WHERE nro_pol = @nro_pol
                                                AND cod_suc = @cod_suc
                                                AND cod_ramo = @cod_ramo
                                                AND cod_grupo_endo NOT IN (14)
                                                )
                    )
            ,h.cod_agente      
            ,h.cod_grupo_endo --#63285 malvarado <agrego alias>     
            ,h.cod_tipo_endo --#63285 malvarado <agrego alias>     
            ,cod_pto_vta      
            ,cod_tipo_negocio      
            ,isnull(v.txt_nom_factura, (case when p.cod_tipo_persona = 'F' 
                                                then ltrim(rtrim(isnull(p.txt_apellido1, ''))) + ' ' + 
                                                        ltrim(rtrim(isnull(p.txt_apellido2, ''))) + ' ' + 
                                                        ltrim(rtrim(isnull(p.txt_nombre, '')))
                                                else ltrim(rtrim(p.txt_apellido1))
                                            end
                                        )
            ) txt_nom_factura
            --MNahara RQ 52737 - Tomador es pagador    
            ,@resultPayer AS 'looterIsPayer'     
            --Fin MNahara RQ 52737 - Tomador es pagador   
            ,@resultInsured AS 'looterIsInsured'     
            ,@lastEndorsement AS 'lastEndo'   
            ,@lastNumEndo AS 'lastNumEndo'  
            ,v.cod_grupo_caucion 
            ,v.cod_socio
            ,isnull(v.cod_producto_com, 0) cod_producto_com
            ,pvc.cod_sub_ramo_fecu subdivision_ramo_fecu
            ,isnull(pvc.cod_convenio,0) cod_convenio
            ,'' nro_cotiz,
            --naguilar(Req.85034) se aumenta porque cuando se realiza un endoso ese campo lo trae como indefinido
            pvc.sn_renovacion_automatica
        FROM pv_header h      
        INNER JOIN pv_varios v ON h.id_pv = v.id_pv    
        inner join pv_varios_cp pvc on v.id_pv = pvc.id_pv	  
        INNER JOIN maseg_header a ON h.cod_aseg = a.cod_aseg      
        INNER JOIN mpersona p ON a.id_persona = p.id_persona 
        INNER JOIN pv_header ph ON ph.id_pv = h.id_pv_cero --     #63285 malvarado
    WHERE h.id_pv = (SELECT max(id_pv)      
                        FROM pv_header      
                    WHERE nro_pol = @nro_pol      
                        AND cod_suc = @cod_suc      
                        AND cod_ramo = @cod_ramo     
                    )      
    ORDER BY h.id_pv
exec sp_rep_obtener_comando @p_cod_comando=789,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=790,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=792,@p_patrones=N'sucursal_Id',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1409,@p_patrones=N'prefixId',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=787,@p_patrones=N'grupo_endo_Id,branch_Id',@p_valores=N'2|500'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=927,@p_patrones=N'currency',@p_valores=N'4'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=788,@p_patrones=N'',@p_valores=N''
exec get_currency @cod_moneda=4
exec sp_rep_obtener_comando @p_cod_comando=1064,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec emi_usp_get_vig_hab @id_pv_cero=4681164,@cod_grupo_endo=2
exec emi_spc_datos_agente -1
    EXEC dbo.revisa_importe_emision_tempdb_core
    EXEC emi_set_comis_ult_endo @id_pv_wkf
    EXEC emi_sp_calcula_comis @id_pv_wkf, -1, -1, 0, 1, @cod_criterio_comis
exec sp_rep_obtener_comando @p_cod_comando=918,@p_patrones=N'branchId',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=786,@p_patrones=N'branch_Id',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1408,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=1922,@p_patrones=N'',@p_valores=N''
exec usp_load_combo 'tconvenio','cod_convenio','cod_txt_convenio + '' - '' + txt_desc',''
exec emi_usp_recup_prod_comerciales @cod_ramo=500
exec sp_rep_obtener_comando @p_cod_comando=917,@p_patrones=N'prefixId',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=963,@p_patrones=N'policyId',@p_valores=N'4681164'
    EXEC @isValid = usp_validar_query @v_val
    EXEC cot_validate_payer 4681164;
exec sp_rep_obtener_comando @p_cod_comando=1558,@p_patrones=N'policyId',@p_valores=N'4681164'
    EXEC @isValid = usp_validar_query @v_val
    EXEC cot_validate_benef '4681164';
exec spiu_tult_id_pv_wkf_suc @sn_muestra=-1,@cod_suc=1,@ult_nro=0
exec sp_rep_obtener_comando @p_cod_comando=758,@p_patrones=N'p_cod_ramo',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec usp_load_combo 'tconvenio','cod_convenio','cod_txt_convenio + '' - '' + txt_desc',''
exec sp_rep_obtener_comando @p_cod_comando=787,@p_patrones=N'grupo_endo_Id,branch_Id',@p_valores=N'2|500'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=1231,@p_patrones=N'prefixId',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec cot_execute_command @cod_command=1740,@patterns='policyNumber,policyId',@values='24058902|51569381',@query=default,@proc=1
    EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
        EXEC @isValid = usp_validar_query @v_val -- 2 VECES
    EXEC emi_transfer_real_category '24058902', '51569381';
exec sp_rep_obtener_comando @p_cod_comando=1745,@p_patrones=N'policyId',@p_valores=N'51569381'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2261,@p_patrones=N'prefixCd,policyType',@p_valores=N'500|1'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec cot_get_cant_dias_vigen @fec_desde=N'20240315 12:00 PM',@fec_hasta=N'20260316 12:00 PM',@cod_periodo_fact=1
    SET @cant_dias = dbo.fn_dias_vigencia(@fec_desde, @fec_hasta, @cod_periodo_fact)
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4681164|-1' -- 3 VECES
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=1785,@p_patrones=N'prefixId',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec sp_getproducts_filtered @cod_ramo=500,@cod_suc=1
exec sp_rep_obtener_comando @p_cod_comando=2167,@p_patrones=N'criteria',@p_valores=N' SOC. ING. CONSTRUCCION Y MAQUINARIAS SPA '
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=949,@p_patrones=N'dateIssuance',@p_valores=N'20250519'
    EXEC @isValid = usp_validar_query @v_val
    EXEC sp_fecha_mov_suc  '20250519', 1, 3, 1, @fecha_real = @fecha OUTPUT
        INSERT INTO @t  EXEC dbo.usp_get_fecha_tope_modulo @cod_modulo
exec cot_verifica_tipo_operacion @id_pv=51569381 -- 2 VECES
exec cot_recalculated_quote @id_pv=51569381
    EXEC [dbo].[cot_migrated_recalculated] @id_pv
exec cot_verifica_tipo_operacion @id_pv=51569381
exec emi_cot_summary_risk @id_pv_wkf=51569381,@sn_realRisk=-1
    EXEC usp_emi_summary_risk_general @id_pv_cero, @id_pv_wkf, @SN_RENOVACION, @SN_COTIZACION
        EXEC usp_emi_summary_risk_gral_pol @id_pv_cero,@id_pv,@SN_RENOVACION
            EXEC revisa_importe_emision_tempdb_core
exec emi_save_payer_risk @id_pv=51569381,@cod_item=-1,@cod_aseg=76401,@method_pay=1,@ind_conducto=-1,@means_pay=1,@card_pay=N'',@date_from='2024-03-15 00:00:00',@date_to='2026-03-16 00:00:00',@participation=100,@cod_dir_envio=1,@proc=1,@tipo_facturacion=1,@periodicidad_orden=-1,@nro_orden_compra=N'-1',@firstDueDate='2024-04-25 00:00:00'
    EXEC emi_save_pvc_pagador @id_pv, @tipo_facturacion, @periodicidad_orden, @nro_orden_compra
exec sp_rep_obtener_comando @p_cod_comando=1064,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec COMM.GET_PARAMETERS @PARAMETER_ID=214 
exec sp_rep_obtener_comando @p_cod_comando=777,@p_patrones=N'country_id',@p_valores=N'23' -- 2 VECES
    EXEC @isValid = usp_validar_query @v_val
exec spc_web_catalogo 'ttipo_dir'
exec emi_obtiene_ttipo_calle -1
exec cot_get_num_endo @id_pv_cero=4681164,@date_emi='2025-05-19 00:00:00'
exec emi_save_pv_header @id_pv=51569381,@cod_suc=1,@cod_ramo=500,@nro_pol=24058902,@aaaa_endoso=2025,@nro_endoso=7,@cod_aseg=76401,@fec_emi='2025-05-19 00:00:00',@fec_vig_desde='2024-03-15 12:00:00',@fec_vig_hasta='2026-03-16 12:00:00',@cod_moneda=4,@imp_cambio=39151.580000,@id_pv_modifica=0,@cod_operacion=1,@nro_solicitud=51569381,@nro_cotizacion=1,@cod_tipo_agente=4,@cod_agente=941,@fec_hora_desde='2024-03-15 12:00:00',@id_pv_cero=4681164,@sn_cob_coas_total=0,@cod_grupo_endo=2,@cod_tipo_endo=0,@cod_sistema=1,@sn_bancaseguros=-1,@sn_fronting=0,@cod_periodo_fact=1,@cod_grupo=0,@nro_flota=0,@txt_partic_acreedor=N'50',@cod_nivel_facturacion=0,@cod_nivel_imp_factura=0,@cod_subramo=0
exec emi_save_pv_varios @id_pv=51569381,@fec_proceso='2025-05-19 08:48:59.713',@fec_inicio='2025-05-19 08:48:59.713',@fec_fin='2025-05-19 08:48:59.713',@cod_usuario=N'DEMO',@fec_vig_hasta_orig='2026-03-16 12:00:00',@cod_pto_vta=1,@txt_usuario_cotiz=N'DEMO',@cod_tipo_negocio=3,@cod_tipo_poliza=1,@txt_nom_factura=N' SOC. ING. CONSTRUCCION Y MAQUINARIAS SPA ',@cod_grupo_caucion=-1,@cod_producto_com=0,@cod_socio=-1
    INSERT INTO @vig_prox_facturacion EXEC emi_usp_get_fec_fact_cober @id_pv = @id_pv, @sn_temporal = -1
exec emi_usp_traladar_pv_coas_linea @id_pv_wkf=51569381,@id_pv_cero=4681164
exec cot_execute_command @cod_command=1287,@patterns='policyId',@values='51569381',@query=default,@proc=1
    EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
        EXEC @isValid = usp_validar_query @v_val
exec cot_execute_command @cod_command=1286,@patterns='quoIdPvCero,policyId',@values='4681164|51569381',@query=default,@proc=1
    EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
        EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec cot_verifica_tipo_operacion @id_pv=51569381
exec emi_cot_summary_risk @id_pv_wkf=51569381,@sn_realRisk=-1
    EXEC usp_emi_summary_risk_general @id_pv_cero, @id_pv_wkf, @SN_RENOVACION, @SN_COTIZACION
        EXEC usp_emi_summary_risk_gral_pol @id_pv_cero,@id_pv,@SN_RENOVACION
            EXEC revisa_importe_emision_tempdb_core
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51569381|-1|1|1' -- 2 VECES
    EXEC @isValid = usp_validar_query @v_val -- 4 VECES
    EXEC emi_spc_get_sum_cob_item 51569381,-1,1,1;




