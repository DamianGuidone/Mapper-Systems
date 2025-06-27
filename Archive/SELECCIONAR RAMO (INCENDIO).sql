/*  SELECCIONAR RAMO (INCENDIO)
====================================================================================================*/
exec Get_CodTipoRamo_ByRamo '200'
exec cot_spc_tclasificacion_vida @cod_ramo=200
exec sp_rep_obtener_comando @p_cod_comando=758,@p_patrones=N'p_cod_ramo',@p_valores=N'200'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=917,@p_patrones=N'prefixId',@p_valores=N'200'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1525,@p_patrones=N'prefix',@p_valores=N'200'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1922,@p_patrones=N'',@p_valores=N''
exec spiu_tult_id_pv_wkf_suc @sn_muestra=-1,@cod_suc=1,@ult_nro=0
exec sp_rep_obtener_comando @p_cod_comando=1331,@p_patrones=N'prefixId',@p_valores=N'200'
    EXEC @isValid = usp_validar_query @v_val
exec cot_spc_tclasificacion_vida @cod_ramo=200
exec sp_rep_obtener_comando @p_cod_comando=757,@p_patrones=N'p_cod_ramo,p_cod_suc,userId,prefixId',@p_valores=N'200|1|DEMO|0'
    EXEC @isValid = usp_validar_query @v_val -- 4 VECES
    EXEC cot_spc_consulta_planes '200','1', 'DEMO', '0';
exec sp_rep_obtener_comando @p_cod_comando=1360,@p_patrones=N'prefixId',@p_valores=N'200'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=788,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=789,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=790,@p_patrones=N'',@p_valores=N''
exec usp_load_combo 'tconvenio','cod_convenio','cod_txt_convenio + '' - '' + txt_desc',''
exec sp_rep_obtener_comando @p_cod_comando=792,@p_patrones=N'sucursal_Id',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1409,@p_patrones=N'prefixId',@p_valores=N'200'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1408,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=1231,@p_patrones=N'prefixId',@p_valores=N'200'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=949,@p_patrones=N'dateIssuance',@p_valores=N'20250513'
    EXEC @isValid = usp_validar_query @v_val
    EXEC sp_fecha_mov_suc  '20250513', 1, 3, 1, @fecha_real = @fecha OUTPUT
        INSERT INTO @t EXEC dbo.usp_get_fecha_tope_modulo @cod_modulo
exec sp_rep_obtener_comando @p_cod_comando=786,@p_patrones=N'branch_Id',@p_valores=N'200'
    EXEC @isValid = usp_validar_query @v_val
exec emi_usp_recup_prod_comerciales @cod_ramo=200
exec GetdefaultbyRamo '21','cot_move'
exec sp_rep_obtener_comando @p_cod_comando=787,@p_patrones=N'grupo_endo_Id,branch_Id',@p_valores=N'1|200'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec GetdefaultbyRamo '21','cot_typeMove'
exec GetdefaultbyRamo '21','cot_typeCommerce'
exec GetdefaultbyRamo '21','cot_operationType'
exec GetdefaultbyRamo '21','cot_salePoint'
exec GetdefaultbyRamo '21','cot_currency'
exec GetdefaultbyRamo '21','cot_tipo_poliza'
exec GetdefaultbyRamo '21','cot_looterId'
exec sp_rep_obtener_comando @p_cod_comando=1402,@p_patrones=N'criteria',@p_valores=N'-1'
    EXEC @isValid = usp_validar_query @v_val
exec GetdefaultbyRamo '21','tperiodo_facturacion'
exec GetdefaultbyRamo '21','ttipo_facturacion'
exec sp_rep_obtener_comando @p_cod_comando=918,@p_patrones=N'branchId',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1064,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2261,@p_patrones=N'prefixCd,policyType',@p_valores=N'200|1'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=1402,@p_patrones=N'criteria',@p_valores=N'-1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=917,@p_patrones=N'prefixId',@p_valores=N'200'
    EXEC @isValid = usp_validar_query @v_val
exec get_currency @cod_moneda=4
exec sp_rep_obtener_comando @p_cod_comando=830,@p_patrones=N'cod_currency',@p_valores=N'4'
    EXEC @isValid = usp_validar_query @v_val
    EXEC emi_get_currency_change 4
        exec sp_fecha_mov_suc  @fec_emi, 1, 3, 1, @fecha_real = @fec_emi OUTPUT
            INSERT INTO @t EXEC dbo.usp_get_fecha_tope_modulo @cod_modulo
        select @imp_cambio = dbo.emi_fn_get_currency_change(@cod_currency,@fec_emi)




