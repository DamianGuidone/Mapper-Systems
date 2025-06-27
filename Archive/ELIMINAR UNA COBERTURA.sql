/*  ELIMINAR UNA COBERTURA
====================================================================================================*/
exec sp_rep_obtener_comando @p_cod_comando=1804,@p_patrones=N'policyId,riskId,coverageId',@p_valores=N'51579544|1|19'
exec cot_verifica_tipo_operacion @id_pv=51579544
exec emi_delete_coverage @id_pv=51579544,@cod_item=1,@cod_ind_cob=19
    exec [dbo].[emi_delete_ISO_respuesta_cpto] @id_pv, @cod_item, @cod_ind_cob
    exec [dbo].[emi_delete_ISO_respuesta] @id_pv, @cod_item, @cod_ind_cob
    exec [dbo].[emi_delete_cober_tarif] @id_pv, @cod_item, @cod_ind_cob
    exec [dbo].[emi_delete_cober_recdesc] @id_pv, @cod_item, @cod_ind_cob
    exec [dbo].[emi_delete_cober_deduc] @id_pv, @cod_item, @cod_ind_cob 
    exec [dbo].[emi_delete_cober_anexo] @id_pv, @cod_item, @cod_ind_cob
    exec [dbo].[emi_delete_cober_texto] @id_pv, @cod_item, @cod_ind_cob
    exec [dbo].[emi_delete_cober_imp] @id_pv, @cod_item, @cod_ind_cob
    exec [dbo].[emi_delete_cober] @id_pv, @cod_item, @cod_ind_cob
    exec [dbo].[emi_reindexar_cob] @id_pv, 100
    exec [dbo].[emi_reindexar_pagadores] @id_pv, @cod_item
    exec [dbo].[emi_recalculated_quote] @id_pv
        EXEC [dbo].[emi_joined_recalculated] @id_pv, @cod_item
            EXEC dbo.revisa_importe_emision_tempdb_core
        EXEC [dbo].[emi_migrated_recalculated] @id_pv
exec cot_verifica_tipo_operacion @id_pv=51579544
exec emi_spc_get_cob_item @id_pv_wkf=51579544,@cod_item=1
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51579544|-1|19|3' -- ESTO SE REPITE PARA TODAS LAS COBERTURAS
    EXEC emi_spc_get_sum_cob_item 51579544,-1,19,3;
exec cot_verifica_tipo_operacion @id_pv=51579544
exec emi_recalculated_quote @id_pv=51579544
    EXEC [dbo].[emi_joined_recalculated] @id_pv, @cod_item
        EXEC dbo.revisa_importe_emision_tempdb_core
    EXEC [dbo].[emi_migrated_recalculated] @id_pv
exec cot_verifica_tipo_operacion @id_pv=51579544
exec emi_cot_summary_risk @id_pv_wkf=51579544,@sn_realRisk=0
    EXEC cot_verifica_tipo_operacion @id_pv = @id_pv_wkf, @return = @tipo_operacion OUTPUT, @sn_muestra = 0
    EXEC usp_emi_summary_risk_general @id_pv_cero, @id_pv_wkf, @SN_RENOVACION, @SN_COTIZACION
        EXEC usp_emi_summary_risk_gral_pol @id_pv_cero,@id_pv,@SN_RENOVACION
            EXEC revisa_importe_emision_tempdb_core
exec sp_rep_obtener_comando @p_cod_comando=925,@p_patrones=N'id_pv_wkf, id_pv, cod_item, tipo',@p_valores=N'51579544|-1|1|1'
exec sp_rep_obtener_comando @p_cod_comando=1806,@p_patrones=N'policyId,riskId,productId,prefixId',@p_valores=N'51579544|1|13|7'









