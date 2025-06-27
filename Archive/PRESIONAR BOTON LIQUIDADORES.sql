/*  PRESIONAR BOTÓN LIQUIDADORES
====================================================================================================*/
exec usp_get_liquidator @id_pv=51563944
exec sp_rep_obtener_comando @p_cod_comando=2131,@p_patrones=N'pcod_parametro',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=2131,@p_patrones=N'pcod_parametro',@p_valores=N'1'
    EXEC @isValid = usp_validar_query @v_val
exec sp_create_liquidator @id_pv=51563944,@rut=N'',@name=N''
exec usp_get_liquidator @id_pv=51563944