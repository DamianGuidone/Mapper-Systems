/*  PRESIONAR BOTÓN AGREGAR DE DIALOGO TOMADOR ES PAGADOR
====================================================================================================*/
exec sp_rep_obtener_comando @p_cod_comando=2203,@p_patrones=N'p_id_pv,p_cod_producto_cial,p_cod_agente,p_cod_conducto,p_cod_ppago',@p_valores=N'51563944|-1|598|1|1'
    EXEC @isValid = usp_validar_query @v_val -- 5 VECES
    EXEC emi_save_comispago_agente 51563944, -1, 598, 1, 1;
exec emi_usp_update_payer_general 51563944,244954,'2025-06-05 00:00:00',1,1,default,2
    SELECT @ind_conducto = mpc.ind_conducto
    FROM maseg_header mh 
    INNER JOIN mpersona_conducto mpc ON mpc.id_persona = mh.id_persona AND mpc.cod_conducto = @cod_conducto AND ltrim(rtrim(isnull([dbo].[Desencriptar](mpc.nro_cta_tarj, 0), ''))) = ltrim(rtrim(ISNULL(@nro_tarjeta, '')))
    WHERE mh.cod_aseg = @cod_aseg
exec emi_usp_update_payer_general_extra 51563944,244954,1,default,3,-1,-1
    SELECT @ind_conducto = mpc.ind_conducto
    FROM maseg_header mh 
    INNER JOIN mpersona_conducto mpc ON mpc.id_persona = mh.id_persona AND mpc.cod_conducto = @cod_conducto AND ltrim(rtrim(isnull([dbo].[Desencriptar](mpc.nro_cta_tarj, 0), ''))) = ltrim(rtrim(ISNULL(@nro_tarjeta, '')))
    WHERE mh.cod_aseg = @cod_aseg
exec cot_execute_command @cod_command=1288,@patterns='policyId,expenses,rateType,updatePayer',@values='51563944|null|null|-1',@query=default,@proc=1
    EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
        EXEC @isValid = usp_validar_query @v_val -- 4 VECES
    EXEC emi_genera_solicitud @id_pv = 51563944, @imp_g_emi_usuario = null, @cod_tipo_tasa = null, @sn_update_pagador = -1;
        EXEC dbo.revisa_importe_emision_tempdb_core
        EXEC spi_RE_sumas_reasegurar @id_pv,-1,@id_pv
            EXEC spu_RE_sumas_reasegurar_param @id_pv_wkf
exec cot_verifica_tipo_operacion @id_pv=51563944
exec emi_cot_summary_risk @id_pv_wkf=51563944,@sn_realRisk=0
    EXEC cot_verifica_tipo_operacion @id_pv = @id_pv_wkf, @return = @tipo_operacion OUTPUT, @sn_muestra = 0
    EXEC usp_emi_summary_risk_general @id_pv_cero, @id_pv_wkf, @SN_RENOVACION, @SN_COTIZACION
        EXEC usp_emi_summary_risk_gral_pol @id_pv_cero,@id_pv,@SN_RENOVACION
            EXEC revisa_importe_emision_tempdb_core
    