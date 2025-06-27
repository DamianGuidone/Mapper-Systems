/*  CHECK EL TOMADOR ES TAMBIÉN PAGADOR
====================================================================================================*/
exec sp_rep_obtener_comando @p_cod_comando=811,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=812,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=785,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=784,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=783,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=776,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=784,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=783,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=812,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=810,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=1970,@p_patrones=N'',@p_valores=N''
exec emi_obtiene_ttipo_calle -1 -- REVISAR SE EJECUTA 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=951,@p_patrones=N'insured_Id',@p_valores=N'244954'
    EXEC @isValid = usp_validar_query @v_val
exec sp_rep_obtener_comando @p_cod_comando=777,@p_patrones=N'country_id',@p_valores=N'15'
    EXEC @isValid = usp_validar_query @v_val
exec emi_usp_recup_conducto_aseg @cod_aseg=244954,@cod_ramo=200,@cod_prod_cial=-1