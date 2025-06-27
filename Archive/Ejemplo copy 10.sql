/*  GUARDAR ENDOSO DE RENOVACIÓN DE PÓLIZA
====================================================================================================*/
exec cot_execute_command @cod_command=1285,@patterns='policyId,tempCero, billingId, moveId,typeMove, nroPropInt, nroPropExt,nroCot',@values='50613934|4099932|1|5|1|123456|''''|''''',@query=default,@proc=1
    EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
        EXEC @isValid = usp_validar_query @v_val -- 8 VECES
    EXEC emi_usp_renovacion_poliza 50613934, 4099932,1,5, 1, 0, 0,123456,'', '';    
        EXEC sp_fecha_mov_suc @fec_emi, 1, 3, 1, @fecha_real = @fec_emi OUTPUT
            INSERT INTO @t EXEC dbo.usp_get_fecha_tope_modulo @cod_modulo
        SELECT @imp_cambio = dbo.emi_fn_get_currency_change(cod_moneda, getdate()) FROM pv_header WHERE id_pv = @id_pv_ult_endo
        EXEC emi_usp_renovacion_riesgos @id_pv, @id_pv_cero, @sn_aplica_depreciacion
























