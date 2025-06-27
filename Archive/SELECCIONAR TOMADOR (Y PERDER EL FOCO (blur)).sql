/*  SELECCIONAR TOMADOR (Y PERDER EL FOCO (blur))
====================================================================================================*/
exec cot_execute_command @cod_command=1416,@patterns='policyId,looterId',@values='51563944|-1',@query=default,@proc=1
    EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
        EXEC @isValid = usp_validar_query @v_val -- revisar porqué se ejecuta 2 veces
    EXEC emi_delete_pagador3 51563944, -1;
exec emi_get_payer_risk @id_pv=51563944,@cod_item=0
    SET @pje_participacion = dbo.fn_GetPjePartCiaPagador(@id_pv)