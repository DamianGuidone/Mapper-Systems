/*  SELECCIONAR SUCURSAL
====================================================================================================*/
exec sp_rep_obtener_comando @p_cod_comando=918,@p_patrones=N'branchId',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val

/*==================================================================================================*/

