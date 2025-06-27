/*  PRESIONAR BOTÓN AGREGAR RIESGO (CASO cod_ramo = 200 "INCENDIO")
====================================================================================================*/
exec sp_rep_obtener_comando @p_cod_comando=2175,@p_patrones=N'p_cod_ramo',@p_valores=N'200'
exec sp_rep_obtener_comando @p_cod_comando=758,@p_patrones=N'p_cod_ramo',@p_valores=N'200'
exec sp_rep_obtener_comando @p_cod_comando=885,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=769,@p_patrones=N'branch_Id',@p_valores=N'200'
exec sp_rep_obtener_comando @p_cod_comando=2235,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=767,@p_patrones=N'',@p_valores=N''
exec sp_rep_obtener_comando @p_cod_comando=768,@p_patrones=N'branch_Id',@p_valores=N'200'
    -- exec sp_rep_obtener_comando @p_cod_comando=766,@p_patrones=N'',@p_valores=N''
exec sp_getproducts_filtered @cod_ramo=200,@cod_suc=1
exec sp_rep_obtener_comando @p_cod_comando=1785,@p_patrones=N'prefixId',@p_valores=N'200'
exec spc_web_catalogo 'ttipo_dir'