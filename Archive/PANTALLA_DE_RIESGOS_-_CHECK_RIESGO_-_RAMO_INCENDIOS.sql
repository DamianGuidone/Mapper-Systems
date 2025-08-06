/* PANTALLA DE RIESGOS - CHECK RIESGO - RAMO INCENDIOS - EDITANDO ENDOSO DE RENOVACION
====================================================================================================*/
exec emi_usp_get_fecha_item_stro @id_pv_wkf=50614014,@cod_item=1
    INSERT INTO @t_stro EXEC emi_valida_fec_stros @id_pv_wkf, @cod_item, @fec_stro OUTPUT
exec sp_rep_obtener_comando @p_cod_comando=962,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2175,@p_patrones=N'p_cod_ramo',@p_valores=N'200'
    EXEC @isValid = usp_validar_query @v_val
exec cot_verifica_tipo_operacion @id_pv=50614014
exec cot_verifica_tipo_operacion @id_pv=50614014
exec cot_verifica_tipo_operacion @id_pv=50614014
exec emi_spc_data_fire 50614014,1
exec emi_get_payer_risk @id_pv=50614014,@cod_item=1
    SET @pje_participacion = dbo.fn_GetPjePartCiaPagador(@id_pv)
exec emi_get_benef_risk @id_pv=50614014,@cod_item=1
exec spc_web_prov_dtro 15,NULL
exec sp_rep_obtener_comando @p_cod_comando=1363,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec spc_web_prov_dtro 15,13
exec sp_rep_obtener_comando @p_cod_comando=863,@p_patrones=N'p_id_pv,p_cod_item',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec cot_spc_get_cob_item_plan 50614014,1,25
exec cot_verifica_tipo_operacion @id_pv=50614014
exec emi_spc_get_cob_item @id_pv_wkf=50614014,@cod_item=1
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|22|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,22,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|25|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,25,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3804|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3804,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3817|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3817,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3805|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3805,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3806|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3806,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3807|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3807,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3818|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3818,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3808|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3808,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3819|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3819,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3811|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3811,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3820|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3820,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3812|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3812,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3813|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3813,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3821|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3821,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3814|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3814,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3815|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3815,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|4067|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,4067,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|4114|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,4114,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|4115|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,4115,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|68|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,68,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|69|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,69,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|79|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,79,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|81|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,81,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|82|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,82,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|80|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,80,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|4060|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,4060,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|4061|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,4061,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|76|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,76,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3881|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3881,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|3902|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,3902,3;
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'50614014|-1|4003|3'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
            emi_spc_get_sum_cob_item 50614014,-1,4003,3;
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec emi_spc_prima_en_dep_by_risk @id_pv=4076552,@cod_item=1
exec sp_rep_obtener_comando @p_cod_comando=1760,@p_patrones=N'id_pv_cero,riskId',@p_valores=N'4076552|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=1761,@p_patrones=N'policyId,riskId',@p_valores=N'50614014|1'
    EXEC @isValid = usp_validar_query @v_val
    EXEC @isValid = usp_validar_query @v_val