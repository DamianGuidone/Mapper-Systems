/*  AVANZAR A PANTALLA DE COMISIONES (me centro en las comisiones)
====================================================================================================*/
exec sp_rep_obtener_comando @p_cod_comando=1391,@p_patrones=N'policyId,isLifePrefix',@p_valores=N'51572278|0'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
    EXEC emi_validate_coverages 51572278, 0;
exec sp_rep_obtener_comando @p_cod_comando=1368,@p_patrones=N'usuario,prefixId,policyId,riskId',@p_valores=N'DEMO|200|51572278|0'
    EXEC @isValid = usp_validar_query @v_val -- 4 VECES
    EXEC cot_validateInsuredAmountMax 51572278, 0, 200, 'DEMO';
exec sp_rep_obtener_comando @p_cod_comando=2262,@p_patrones=N'id_pv_wkf',@p_valores=N'51572278'
    EXEC @isValid = usp_validar_query @v_val
    EXEC usp_validar_montos_riesgos 51572278
exec emi_save_payer_risk @id_pv=51572278,@cod_item=-1,@cod_aseg=297508,@method_pay=30,@ind_conducto=-1,@means_pay=56,@card_pay=N'',@date_from='2024-09-09 00:00:00',@date_to='2025-09-09 00:00:00',@participation=100,@cod_dir_envio=1,@proc=1,@tipo_facturacion=1,@periodicidad_orden=-1,@nro_orden_compra=N'-1',@firstDueDate='2024-10-25 00:00:00'
    EXEC emi_save_pvc_pagador @id_pv,@tipo_facturacion,@periodicidad_orden,@nro_orden_compra
exec cot_execute_command @cod_command=1288,@patterns='policyId,expenses,rateType,updatePayer',@values='51572278|null|null|0',@query=default,@proc=1
    EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
        EXEC @isValid = usp_validar_query @v_val -- 4 VECES
    EXEC emi_genera_solicitud @id_pv = 51572278, @imp_g_emi_usuario = null, @cod_tipo_tasa = null, @sn_update_pagador = 0;
        EXEC dbo.revisa_importe_emision_tempdb_core
        EXEC spi_RE_sumas_reasegurar @id_pv,-1,@id_pv
            EXEC spi_RE_sumas_reasegurar_param_endo @id_pv_wkf, @id_pv_cero
            EXEC spu_RE_sumas_reasegurar_param @id_pv_wkf
        EXEC emi_usp_ajusta_prima_mov @id_pv
            EXEC dbo.revisa_importe_emision_tempdb_core
            UPDATE di_pagador_wkf SET imp_participa_me = dbo.RedondeaImporteEmision((@prima_cober * @pje_participa / 100), @cod_moneda),imp_participa_eq = dbo.RedondeaImporteEmision((@prima_cober * @pje_participa / 100 * @imp_cambio), @cod_moneda)
                WHERE id_pv = @id_pv AND cod_item = @cod_item AND cod_ind_cob = @cod_ind_cob AND cod_ind_pagador = @cod_ind_pagador AND cod_aseg = @cod_aseg -- 2 VECES
            UPDATE pv_importe_wkf SET imp_prima = dbo.RedondeaImporteEmision((SELECT ISNULL(SUM(di_header_wkf.imp_prima_neto_me),0) FROM di_header_wkf WHERE id_pv = @id_pv), @cod_moneda),imp_suma_asegurada = dbo.RedondeaImporteEmision((SELECT ISNULL(SUM(di_header_wkf.imp_suma_aseg_me),0) FROM di_header_wkf WHERE id_pv = @id_pv), @cod_moneda)
                WHERE id_pv = @id_pv -- 2 VECES
        EXEC emi_consistencia_moneda @id_pv  
            EXEC dbo.revisa_importe_emision_tempdb_core
        EXEC emi_usp_carga_conceptos @id_pv = @id_pv, @cod_moneda = @cod_moneda, @cod_tipo_concepto = 2, @cod_concepto = @cod_concepto, @imp_concepto_me = @imp_gasto_emision
            EXEC dbo.revisa_importe_emision_tempdb_core
        EXEC @sp_error = usp_ArmaPVImporteConcepto_wkf @id_pv = @id_pv, @cod_moneda = @cod_moneda, @cod_ramo = @cod_ramo, @sn_temporario = - 1
            exec usp_ArmaPVImporteConcepto_wkf_core @id_pv = @id_pv, @cod_moneda = @cod_moneda, @cod_ramo = @cod_ramo, @imp_base_calculo = @imp_base_calculo, @pje_recfin = @pje_recfin, @pje_iva = @pje_iva, @pje_deremi = @pje_deremi, @pje_descuento = @pje_descuento, @pje_decreto = @pje_decreto, @sn_temporario = @sn_temporario
                EXEC dbo.revisa_importe_emision_tempdb_core
                INSERT INTO pv_importe_concepto_wkf SELECT 51572278, 0, 2, 1, 1, 200, 0, imp_base_calculo * 39164.2000, 100, 0.00, dbo.RedondeaImporteEmision((imp_concepto * 39164.2000),0), 0, 0, 0, 0, 0, 0, 0 FROM pv_importe_concepto_wkf WHERE id_pv = 51572278AND cod_moneda = 4 AND cod_tipo_concepto = 2 AND cod_concepto = 1
                    IF @cod_concepto = dbo.CONST_EMI_REC_FINC_AF() or @cod_concepto = dbo.CONST_EMI_REC_FINC_EX()
                    IF @cod_concepto = dbo.CONST_EMI_REC_FINC_AF() or @cod_concepto = dbo.CONST_EMI_REC_FINC_EX()
                    IF @cod_concepto = dbo.CONST_EMI_DER_EMI()
                    SET @imp_base = dbo.fn_BaseConcepto(@id_pv_wkf, @cod_moneda,@cod_tipo_concepto,@cod_concepto)
                        IF (@cod_concepto = dbo.CONST_EMI_REC_FINC_AF() or @cod_concepto = dbo.CONST_EMI_REC_FINC_EX()) and dbo.emi_sn_nuevo_calc_recargo(@id_pv_wkf,-1) = -1 -- 2 veces
                        SELECT @imp_descuento = ISNULL(SUM(imp_concepto),0) FROM pv_importe_concepto_wkf WHERE id_pv = @id_pv_wkf AND cod_tipo_concepto = 2 AND cod_concepto = dbo.CONST_EMI_DESCUENTO() AND cod_moneda = @cod_moneda
                        IF @cod_concepto = dbo.CONST_EMI_REC_FINC_AF()
                        IF @cod_concepto <> 1 AND @cod_concepto <> dbo.CONST_EMI_DESCUENTO()
                        SET @imp_base = dbo.RedondeaImporteEmision((@imp_base - @imp_descuento), @cod_moneda)
                    RETURN dbo.RedondeaImporteEmision(@imp_concepto, @cod_moneda)
                INSERT INTO pv_importe_concepto_wkf SELECT 51572278, 0, 2, 2, 2, 200, 0, imp_base_calculo * 39164.2000, 100, 0.00, dbo.RedondeaImporteEmision((imp_concepto * 39164.2000),0), 0, 0, 0, 0, 0, 0, 0 FROM pv_importe_concepto_wkf WHERE id_pv = 51572278AND cod_moneda = 4 AND cod_tipo_concepto = 2 AND cod_concepto = 2
                INSERT INTO pv_importe_concepto_wkf SELECT 51572278, 4, 2, 4, 3, 200, 0, 0, 100, 0.00, ISNULL(SUM(ISNULL(dbo.fn_GetConcep(id_pv, cod_moneda,2,4),0)),0), 0, 0, 0, 0, 0, 0, 0 FROM pv_header_wkf WHERE id_pv = 51572278
                    IF @cod_concepto = dbo.CONST_EMI_REC_FINC_AF() or @cod_concepto = dbo.CONST_EMI_REC_FINC_EX()
                    SELECT @imp_concepto = dbo.fn_BaseConcepto(@id_pv_wkf, @cod_moneda,@cod_tipo_concepto,@cod_concepto) * (tp.pje_rec_fin / 100) FROM pv_header_wkf ph INNER JOIN pv_header ph2 on ph2.id_pv = ph.id_pv_cero INNER JOIN pv_pagador pp on pp.id_pv = ph2.id_pv INNER JOIN tppago tp ON tp.cod_ppago = pp.cod_ppago WHERE pp.id_pv = @id_pv_cero
                        IF (@cod_concepto = dbo.CONST_EMI_REC_FINC_AF() or @cod_concepto = dbo.CONST_EMI_REC_FINC_EX()) and dbo.emi_sn_nuevo_calc_recargo(@id_pv_wkf,-1) = -1
                        IF (@cod_concepto = dbo.CONST_EMI_REC_FINC_AF() or @cod_concepto = dbo.CONST_EMI_REC_FINC_EX()) and dbo.emi_sn_nuevo_calc_recargo(@id_pv_wkf,-1) = -1
                            if @fec_emi < dbo.emi_fec_corte_calc_recargo()
-- voy a seguir desde las comisiones
-- además continúo al final del comando 1288
exec emi_spc_datos_agente 51575684
    EXEC dbo.revisa_importe_emision_tempdb_core
    EXEC emi_sp_calcula_comis @id_pv_wkf, @pje_comis_normal, @pje_comis_extra, @ind_agente, @ind_comis_nuevo, @cod_criterio_comis
        EXEC dbo.revisa_importe_emision_tempdb_core
        SET @importe_partic = dbo.RedondeaImporteEmision((@prima_neta * (@pje_participacion/100)), @cod_moneda)
        SET @importe_comis_normal = dbo.RedondeaImporteEmision((@importe_partic * (@pje_comis_normal/100)), @cod_moneda)
        SET @importe_comis_extra = dbo.RedondeaImporteEmision((@importe_partic * (@pje_comis_extra/100)), @cod_moneda)
        SET @importe_partic_eq = dbo.RedondeaImporteEmision(((@prima_neta * (@pje_participacion/100)) * @imp_cambio), 0)
        SET @importe_comis_normal_eq = dbo.RedondeaImporteEmision(((@importe_partic * (@pje_comis_normal/100)) * @imp_cambio), 0)
        SET @importe_comis_extra_eq = dbo.RedondeaImporteEmision(((@importe_partic * (@pje_comis_extra/100)) * @imp_cambio), 0)
exec emi_spc_datos_comision @id_pv=51572278,@ind_agente=1
exec sp_rep_obtener_comando @p_cod_comando=1232,@p_patrones=N'p_cod_usuario',@p_valores=N'DEMO'
    EXEC @isValid = usp_validar_query @v_val

exec sp_rep_obtener_comando @p_cod_comando=2232,@p_patrones=N'pid_pv_cero, pid_pv_wkf, pcod_aseg, pfecha_vto, pcod_ppago, pcod_conducto, pnro_tarjeta, pcod_dir_envio',@p_valores=N'4846199|51572278|297508|''25/10/2024''|30|56|''0''|1'
    EXEC @isValid = usp_validar_query @v_val -- 8 VECES
    EXEC emi_endoso_renovacion_ppago 4846199,51572278,297508,'25/10/2024',30,56,'0',1



exec cot_verifica_tipo_operacion @id_pv=51572278
exec emi_cot_summary_risk @id_pv_wkf=51572278,@sn_realRisk=-1
    EXEC usp_emi_summary_risk_general @id_pv_cero, @id_pv_wkf, @SN_RENOVACION, @SN_COTIZACION
        EXEC usp_emi_summary_risk_gral_pol @id_pv_cero,@id_pv,@SN_RENOVACION
            EXEC revisa_importe_emision_tempdb_core
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51572278|-1|1|1'













