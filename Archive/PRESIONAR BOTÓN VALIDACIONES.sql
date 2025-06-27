/*  PRESIONAR BOTÓN VALIDACIONES
====================================================================================================*/
exec sp_rep_obtener_comando @p_cod_comando=2252,@p_patrones=N'criteria',@p_valores=N'61656'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2270,@p_patrones=N'id_pv_wkf',@p_valores=N'51606514'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2131,@p_patrones=N'pcod_parametro',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2131,@p_patrones=N'pcod_parametro',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec usp_get_liquidator @id_pv=51606514
exec sp_rep_obtener_comando @p_cod_comando=2131,@p_patrones=N'pcod_parametro',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2131,@p_patrones=N'pcod_parametro',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_save_consistency @id_pv=51606514
    INSERT INTO @err_consistencia EXEC sp_consistencia_emi_wkf @id_pv = @id_pv
        exec sp_verif_pv_importe @sp_id_pv = @id_pv, @sp_cod_moneda = @cod_moneda_me, @sp_rango = @dif_aceptada, @sp_imp_prima_header = 0, @sp_aux = @msg_status output, @sp_output = @sp_output output, @sp_imp_prima_importe = @imp_prima_me output, @sp_imp_deremi_importe = @imp_gasto_emision_me output, @sp_imp_recargo_importe = @imp_recargo_me output, @sp_imp_descuento_importe = @imp_descuento_me output, @sp_imp_decreto_importe = @imp_decreto_me output, @sp_imp_iva_importe = @imp_iva_me output, @sp_imp_premio_importe = @imp_premio_me output
            exec sp_verif_pv_imp_pesificado @sp_id_pv = @sp_id_pv, @sp_cod_moneda = @sp_cod_moneda, @imp_cambio = @imp_cambio, @sp_imp_prima_importe = @sp_imp_prima_importe, @sp_imp_deremi_importe = @sp_imp_deremi_importe, @sp_imp_recargo_importe = @sp_imp_recargo_importe, @sp_imp_descuento_importe = @sp_imp_descuento_importe, @sp_imp_decreto_importe = @sp_imp_decreto_importe, @sp_imp_iva_importe = @sp_imp_iva_importe, @sp_imp_premio_importe = @sp_imp_premio_importe, @sp_aux = @sp_aux output, @sp_output = @sp_output output
                IF EXISTS( SELECT 1 FROM pv_importe_wkf  WHERE (id_pv = @sp_id_pv) AND (cod_moneda = 0) AND ( imp_prima <> dbo.RedondeaImporteEmision(@sp_imp_prima_importe * @imp_cambio,0) OR imp_gasto_emision <> dbo.RedondeaImporteEmision(@sp_imp_deremi_importe * @imp_cambio,0) OR imp_recargo <> dbo.RedondeaImporteEmision(@sp_imp_recargo_importe * @imp_cambio,0) OR imp_descuento <> dbo.RedondeaImporteEmision(@sp_imp_descuento_importe * @imp_cambio,0) OR imp_decreto <> dbo.RedondeaImporteEmision(@sp_imp_decreto_importe * @imp_cambio,0) OR imp_iva <> dbo.RedondeaImporteEmision(@sp_imp_iva_importe * @imp_cambio,0))) -- 12 VECES
        exec sp_verif_pv_importe_concepto @sp_id_pv = @id_pv, @sp_cod_moneda = @cod_moneda_me, @sp_rango = @dif_aceptada, @sp_imp_prima_importe = @imp_prima_me, @sp_imp_deremi_importe = @imp_gasto_emision_me, @sp_imp_recargo_importe = @imp_recargo_me, @sp_imp_descuento_importe = @imp_descuento_me, @sp_imp_decreto_importe = @imp_decreto_me, @sp_imp_iva_importe = @imp_iva_me, @sp_imp_premio_importe = @imp_premio_me, @sp_aux = @msg_status output, @sp_output = @sp_output output
            SELECT @sp_imp_prima_pv_imp_cto = (ISNULL(imp_concepto,0) + ISNULL(imp_concepto2,0)) FROM pv_importe_concepto_wkf WHERE cod_tipo_concepto =  2 AND cod_concepto = dbo.CONST_EMI_PRIMA() AND cod_moneda = @sp_cod_moneda AND id_pv = @sp_id_pv -- 6 VECES
            SELECT @sp_imp_deremi_pv_imp_cto = SUM((ISNULL(imp_concepto,0) + ISNULL(imp_concepto2,0))) FROM pv_importe_concepto_wkf WHERE cod_tipo_concepto = 2 AND cod_concepto = dbo.CONST_EMI_DER_EMI() AND cod_moneda = @sp_cod_moneda AND id_pv = @sp_id_pv -- 6 VECES
            SELECT @sp_imp_recargo_pv_imp_cto = SUM(ISNULL(imp_concepto,0) + ISNULL(imp_concepto2,0)) FROM pv_importe_concepto_wkf WHERE cod_tipo_concepto = 2 AND NOT(cod_concepto = dbo.CONST_EMI_DER_EMI() or cod_concepto = dbo.CONST_EMI_PRIMA() or cod_concepto = dbo.CONST_EMI_DESCUENTO()) AND cod_moneda = @sp_cod_moneda AND id_pv = @sp_id_pv -- 26 VECES
            SELECT @sp_imp_descto_pv_imp_cto = ISNULL(SUM(ISNULL(imp_concepto,0) + ISNULL(imp_concepto2,0)), 0) FROM pv_importe_concepto_wkf WHERE cod_tipo_concepto = 2 AND cod_concepto = dbo.CONST_EMI_DESCUENTO() AND cod_moneda = @sp_cod_moneda AND id_pv = @sp_id_pv -- 6 VECES
            SELECT @sp_imp_IVA_pv_imp_cto = (ISNULL(imp_concepto,0) + ISNULL(imp_concepto2,0)) FROM pv_importe_concepto_wkf WHERE cod_tipo_concepto = 1 AND cod_concepto = dbo.CONST_EMI_IVA() AND cod_moneda = @sp_cod_moneda AND id_pv = @sp_id_pv -- 2 VECES
            SELECT @sp_imp_decreto_pv_imp_cto = SUM(ISNULL(imp_concepto,0) + ISNULL(imp_concepto2,0)) FROM pv_importe_concepto_wkf WHERE cod_tipo_concepto = 1 AND cod_concepto > dbo.CONST_EMI_IVA() AND cod_moneda = @sp_cod_moneda AND id_pv = @sp_id_pv -- 2 VECES
            exec sp_verif_pv_importe_cpto_pesif @sp_id_pv = @sp_id_pv, @sp_cod_moneda =  @sp_cod_moneda, @imp_cambio = @imp_cambio, @sp_imp_prima_pv_imp_cto = @sp_imp_prima_pv_imp_cto, @sp_imp_deremi_pv_imp_cto = @sp_imp_deremi_pv_imp_cto, @sp_imp_recargo_pv_imp_cto = @sp_imp_recargo_pv_imp_cto, @sp_imp_descto_pv_imp_cto = @sp_imp_descto_pv_imp_cto, @sp_imp_decreto_pv_imp_cto = @sp_imp_decreto_pv_imp_cto, @sp_imp_IVA_pv_imp_cto = @sp_imp_IVA_pv_imp_cto, @sp_imp_premio_pv_imp_cto = @sp_imp_premio_pv_imp_cto, @sp_aux = @sp_aux output, @sp_output = @sp_output output
                SELECT @sp_imp_prima_pv_imp_cto = convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_imp_prima_pv_imp_cto * @imp_cambio,0))
                SELECT @sp_imp_deremi_pv_imp_cto = convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_imp_deremi_pv_imp_cto * @imp_cambio,0))
                SELECT @sp_imp_recargo_pv_imp_cto = convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_imp_recargo_pv_imp_cto * @imp_cambio,0))
                SELECT @sp_imp_descto_pv_imp_cto = convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_imp_descto_pv_imp_cto * @imp_cambio,0))
                SELECT @sp_imp_decreto_pv_imp_cto = convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_imp_decreto_pv_imp_cto * @imp_cambio,0))
                SELECT @sp_imp_IVA_pv_imp_cto = convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_imp_IVA_pv_imp_cto * @imp_cambio,0))
                SELECT @sp_dif_prima_pv_imp_cto$ = (@sp_imp_prima_pv_imp_cto - (ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0))) FROM pv_importe_concepto_wkf WHERE (cod_tipo_concepto = 2) AND (cod_concepto = dbo.CONST_EMI_PRIMA()) AND (id_pv = @sp_id_pv) AND (cod_moneda <> @sp_cod_moneda) AND (@sp_imp_prima_pv_imp_cto - (ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0)) <> @sp_imp_prima_pv_imp_cto)
                SELECT @sp_dif_deremi_pv_imp_cto$ = (@sp_imp_deremi_pv_imp_cto - (ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0))) FROM pv_importe_concepto_wkf WHERE (cod_tipo_concepto = 2) AND (cod_concepto = dbo.CONST_EMI_DER_EMI()) AND (id_pv = @sp_id_pv) AND (cod_moneda <> @sp_cod_moneda) AND (@sp_imp_deremi_pv_imp_cto - (ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0)) <> @sp_imp_deremi_pv_imp_cto)
                SELECT @sp_dif_recargo_pv_imp_cto$ = (@sp_imp_recargo_pv_imp_cto - SUM(ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0))) FROM pv_importe_concepto_wkf WHERE (cod_tipo_concepto = 2) AND NOT(cod_concepto = dbo.CONST_EMI_PRIMA() or cod_concepto = dbo.CONST_EMI_DER_EMI() or cod_concepto = dbo.CONST_EMI_DESCUENTO()) AND (id_pv = @sp_id_pv) AND (cod_moneda <> @sp_cod_moneda) HAVING ((@sp_imp_recargo_pv_imp_cto - SUM(ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0)) <> @sp_imp_recargo_pv_imp_cto)) -- 28 VECES
                SELECT @sp_dif_descto_pv_imp_cto$ = (@sp_imp_descto_pv_imp_cto - (ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0))) FROM pv_importe_concepto_wkf WHERE (cod_tipo_concepto = 2) AND (cod_concepto = dbo.CONST_EMI_DESCUENTO()) AND (id_pv = @sp_id_pv) AND (cod_moneda <> @sp_cod_moneda) AND (@sp_imp_descto_pv_imp_cto - (ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0)) <> @sp_imp_descto_pv_imp_cto)
                SELECT @sp_dif_decreto_pv_imp_cto$ = (@sp_imp_decreto_pv_imp_cto - SUM(ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0))) FROM pv_importe_concepto_wkf WHERE (cod_tipo_concepto = 1) AND (cod_concepto <> dbo.CONST_EMI_IVA()) AND (id_pv = @sp_id_pv) AND (cod_moneda <> @sp_cod_moneda) HAVING (@sp_imp_decreto_pv_imp_cto - SUM(ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0)) <> @sp_imp_decreto_pv_imp_cto) -- 4 VECES
                SELECT @sp_dif_IVA_pv_imp_cto$ = (@sp_imp_IVA_pv_imp_cto - (ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0))) FROM pv_importe_concepto_wkf WHERE (cod_tipo_concepto = 1) AND (cod_concepto = dbo.CONST_EMI_IVA()) AND (id_pv = @sp_id_pv) AND (cod_moneda <> @sp_cod_moneda) AND (@sp_imp_IVA_pv_imp_cto - (ISNULL(imp_concepto, 0) + ISNULL(imp_concepto2, 0)) <> @sp_imp_IVA_pv_imp_cto)
        exec sp_verif_pv_pagador @sp_id_pv = @id_pv, @cod_moneda = @cod_moneda_me, @sp_rango = @dif_aceptada, @sp_imp_prima_importe = @imp_prima_me, @sp_imp_deremi_importe = @imp_gasto_emision_me, @sp_imp_recargo_importe = @imp_recargo_me, @sp_imp_descuento_importe = @imp_descuento_me, @sp_imp_decreto_importe = @imp_decreto_me, @sp_imp_iva_importe = @imp_iva_me, @sp_imp_premio_importe = @imp_premio_me, @sp_aux = @msg_status output, @sp_output = @sp_output output
            EXEC sp_verif_pv_pagador_pesif @sp_id_pv = @sp_id_pv, @sp_cod_moneda = @cod_moneda, @sp_imp_prima_pv_pagador = @sp_imp_prima_pv_pagador, @sp_deremi_pv_pagador = @sp_deremi_pv_pagador, @sp_rec_pv_pagador = @sp_rec_pv_pagador, @sp_descto_pv_pagador = @sp_descto_pv_pagador, @sp_imp_iva_pv_pagador = @sp_imp_iva_pv_pagador, @sp_imp_decreto_pv_pagador = @sp_imp_decreto_pv_pagador, @sp_imp_premio_pv_pagador = @sp_imp_premio_pv_pagador, @sp_aux = @sp_aux output, @sp_output = @sp_output output
                IF EXISTS (SELECT 1 FROM pv_pagador_wkf WHERE (id_pv = @sp_id_pv) AND (imp_prima_eq <> convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_imp_prima_pv_pagador * @imp_cambio,0)) OR imp_deremi_eq <> convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_deremi_pv_pagador * @imp_cambio,0)) OR imp_recfin_eq <> convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_rec_pv_pagador * @imp_cambio,0)) OR imp_descto_eq <> convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_descto_pv_pagador * @imp_cambio,0)) OR imp_decreto_eq <> convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_imp_decreto_pv_pagador * @imp_cambio,0)) OR imp_iva_eq <> convert(numeric(14,2),dbo.RedondeaImporteEmision(@sp_imp_iva_pv_pagador * @imp_cambio,0)))) -- 12 VECES
        exec sp_verif_pv_pagador_cuota @sp_id_pv = @id_pv, @sp_cod_moneda = @cod_moneda_me, @sp_rango = @dif_aceptada, @sp_aux = @msg_status OUTPUT, @sp_output = @sp_output OUTPUT
            EXEC sp_verif_pv_pagador_cuo_pesif @sp_id_pv = @sp_id_pv, @sp_cod_moneda = @sp_cod_moneda, @imp_cambio = @imp_cambio, @sp_imp_prima_pv_pagador_cuota = @sp_imp_prima_pv_pagador_cuota, @sp_imp_DE_pv_pagador_cuota = @sp_imp_DE_pv_pagador_cuota, @sp_imp_rec_pv_pagador_cuota = @sp_imp_rec_pv_pagador_cuota, @sp_imp_DTO_pv_pagador_cuota = @sp_imp_DTO_pv_pagador_cuota, @sp_imp_DEC_pv_pagador_cuota = @sp_imp_DEC_pv_pagador_cuota, @sp_imp_iva_pv_pagador_cuota = @sp_imp_iva_pv_pagador_cuota, @sp_imp_premio_pv_pagador = @sp_imp_premio_pv_pagador, @sp_imp_PO_pv_pagador_cuota = @sp_imp_PO_pv_pagador_cuota, @sp_rango = @sp_rango, @sp_aux = @sp_aux output, @sp_output = @sp_output output
                IF ABS(ISNULL(@sp_imp_prima_pv_pagador_cta$,0) - ISNULL(dbo.RedondeaImporteEmision(@sp_imp_prima_pv_pagador_cuota * @imp_cambio,2),0)) > @sp_rango
                IF ABS(ISNULL(@sp_imp_DE_pv_pagador_cta$,0) - ISNULL(dbo.RedondeaImporteEmision(@sp_imp_DE_pv_pagador_cuota * @imp_cambio,2),0))>@sp_rango
                IF ABS(ISNULL(@sp_imp_rec_pv_pagador_cta$,0) - ISNULL(dbo.RedondeaImporteEmision(@sp_imp_rec_pv_pagador_cuota * @imp_cambio,2),0))>@sp_rango
                IF ABS(ISNULL(@sp_imp_DTO_pv_pagador_cta$,0) - ISNULL(dbo.RedondeaImporteEmision(@sp_imp_DTO_pv_pagador_cuota * @imp_cambio,2),0))>@sp_rango
                IF ABS(ISNULL(@sp_imp_DEC_pv_pagador_cta$,0) - ISNULL(dbo.RedondeaImporteEmision(@sp_imp_DEC_pv_pagador_cuota* @imp_cambio, 2),0))>@sp_rango
                IF ABS(ISNULL(@sp_imp_iva_pv_pagador_cta$,0) - ISNULL(dbo.RedondeaImporteEmision(@sp_imp_iva_pv_pagador_cuota* @imp_cambio, 2),0))>@sp_rango
        SELECT @diff = @imp_prima_me - dbo.RedondeaImporteEmision(sum(dp.imp_participa_me), @cod_moneda_me)/*round(sum(dp.imp_participa_me), 2)*/ + @imp_gasto_emision_me - sum(dp.imp_recfin_me) + @imp_recargo_me - sum(dp.imp_deremi_me) + @imp_descuento_me - sum(dp.imp_descto_me) + @imp_decreto_me - sum(dp.imp_decreto_me) + @imp_iva_me - sum(dp.imp_iva_me) + @imp_conceptos_adicionales_me - @imp_concepto_di_pagador_me + @imp_premio_me - sum(dp.imp_premio_me), @diff2 = @imp_prima_eq - dbo.RedondeaImporteEmision(sum(dp.imp_participa_eq), @cod_moneda_eq)/*round(sum(dp.imp_participa_eq), 2)*/ + @imp_gasto_emision_eq - sum(dp.imp_recfin_eq) + @imp_recargo_eq - sum(dp.imp_deremi_eq) + @imp_descuento_eq - sum(dp.imp_descto_eq) + @imp_decreto_eq - sum(dp.imp_decreto_eq) + @imp_iva_eq - sum(dp.imp_iva_eq) + @imp_conceptos_adicionales_eq - @imp_concepto_di_pagador_eq + @imp_premio_eq - sum(dp.imp_premio_eq) FROM dbo.di_pagador_wkf AS dp WHERE dp.id_pv = @id_pv         -- 2 VECES
        exec sp_verif_pv_agente @sp_id_pv = @id_pv, @sp_rango = @dif_aceptada, @sp_aux = @msg_status output, @sp_output = @sp_output output
        exec sp_verif_control_riesgos @id_pv = @id_pv, @sn_coas = @sn_coas, @sp_aux = @msg_status output, @sp_output = @sp_output output
            if exists (select 1 from pv_header_wkf ph inner join tramo tr on tr.cod_ramo = ph.cod_ramo and tr.cod_ttipo_ramo = dbo.CONST_TIPO_RAMO_AUTOS() where ph.id_pv = @id_pv)
        exec sp_verif_suma_asegurada @sp_id_pv = @id_pv, @cod_moneda = @cod_moneda_me, @sp_rango = @dif_aceptada, @sp_aux = @msg_status output, @sp_output = @sp_output output
        exec sp_verif_componentes_cuotas_dif_signos @id_pv = @id_pv, @sp_aux = @msg_status output, @sp_output = @sp_output output
        exec sp_verif_dev_conceptos @id_pv = @id_pv, @cod_moneda = @cod_moneda_me, @imp_premio_pv = @imp_premio_me, @sp_aux = @msg_status output, @sp_output = @sp_output output
exec usp_get_consistency @id_pv=51606514
exec usp_get_validate @id_pv=51606514
exec usp_get_consistency @id_pv=51606514



















