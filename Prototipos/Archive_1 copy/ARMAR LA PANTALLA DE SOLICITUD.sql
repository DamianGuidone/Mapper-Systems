/*  ARMAR LA PANTALLA DE SOLICITUD
====================================================================================================*/
exec get_param_x_descrip @txt_param_descript=N'COD_RAMO_AP'
exec get_param_x_descrip @txt_param_descript=N'COD_PLAN_TEC_INNOMINADO'
exec get_param_x_descrip @txt_param_descript=N'COD_ASEG_HER_LEG'
exec get_param_x_descrip @txt_param_descript=N'COD_PROD_PROT_FIN'
exec emi_obtiene_ttipo_calle -1
exec sp_rep_obtener_comando @p_cod_comando=776,@p_patrones=N'',@p_valores=N''
exec COMM.GET_PARAMETERS @PARAMETER_ID=12146
exec RE_obtener_permisos_usuario @cod_usuario=N'DEMO'
exec RE_obtener_parametro @id=N'PDIST',@subid=N'VEXT'
exec RE_obtener_parametro @id=N'REONL',@subid=N'GUARDADOOBL'
exec RE_obtener_parametro @id=N'EDITENDO',@subid=N'0'
exec sp_rep_obtener_comando @p_cod_comando=1294,@p_patrones=N'p_id_user',@p_valores=N'DEMO'
exec RE_obtener_parametro @id=N'PDIST',@subid=N'VEXT'
exec RE_obtener_parametro @id=N'REONL',@subid=N'GUARDADOOBL'
exec RE_obtener_parametro @id=N'EDITENDO',@subid=N'0'
exec get_param_x_descrip @txt_param_descript=N'COD_DPTO_SIN_INFO'
exec sp_rep_obtener_comando @p_cod_comando=777,@p_patrones=N'country_id',@p_valores=N'15'
exec get_param_x_descrip @txt_param_descript=N'COD_PAIS_SIN_INFO'
exec sp_rep_obtener_comando @p_cod_comando=1418,@p_patrones=N'id_user',@p_valores=N'DEMO'
exec COMM.GET_PARAMETERS @PARAMETER_ID=80003
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session'
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session_Alert'
exec get_LocalDecimal 
exec RE_param_obtener_sistema_tipos 
exec sp_rep_obtener_comando @p_cod_comando=1367,@p_patrones=N'id_user',@p_valores=N'DEMO'
exec spc_web_catalogo 'ttipo_dir'