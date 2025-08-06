/*  REHABILITACIÓN MASIVA
====================================================================================================*/
declare @p3 int set @p3=NULL exec spiu_tvarias_ult_nro default,'importacion_id_proceso',@p3 output select @p3
exec usp_timportacion_actualizar_proceso_estado 87,8773,'DEMO','Cargando archivo'
exec usp_obtener_path_importacion 'IMPORTACION MASIVA'
exec usp_obtener_importacion_formato 87
exec usp_obtener_tipo_archivo_import_form 2
exec usp_obtener_importacion_formato_det 87
exec usp_obtener_importacion_tipo_dato_det 11 -- 4 VECES
exec usp_obtener_importacion_formato 87
exec usp_obtener_tipo_archivo_import_form 2
exec usp_obtener_importacion_formato_det 87
exec usp_obtener_importacion_tipo_dato_det 11 -- 4 VECES
exec usp_importacion_obtener_parametros_sp 87
	SELECT *, case when isnull(padres, '') != '' then -1 else 0 end sn_dependent from (SELECT cod_formato,id_parametro,txt_nombre_param,txt_tipo_dato,txt_sql,nro_orden,sn_requerido,dbo.fn_bulkimport_get_related(1,timportacion_parametro_sp.cod_formato, timportacion_parametro_sp.id_parametro, 1) 'hijos', dbo.fn_bulkimport_get_related(1,timportacion_parametro_sp.cod_formato, timportacion_parametro_sp.id_parametro, 2) 'padres' FROM timportacion_parametro_sp WHERE cod_formato = @cod_formato) A -- 4 VECES
exec usp_importacion_reportes 87
exec usp_validar_tabla_temporal 87
exec usp_load_combo 'ttipo_control_proceso','cod_tipo_proceso','txt_desc',''
exec usp_importacion_tabla_temporal '\\ARBUSQL01\BulkImport\pruebo_rehab_masiva_638871612712169437.txt',87,'DEMO',8773
	SELECT * INTO #tmp_nombre_archivo FROM dbo.SplitNew(@txt_path_servidor, '\')
	EXEC usp_importacion_crear_tabla  @cod_formato, @txt_tabla_temporal_proceso, @sn_definitiva = 0
	EXEC @validacion = usp_importacion_validar_tabla @txt_tabla_temporal,@cod_formato,@mensaje_campo_distinto output
	EXEC USP_IMPORTACION_HEADER_FOOTER @cod_formato,@id_proceso,  @txt_tabla_temporal_proceso
	EXEC @validacion_tabla_temporal = usp_importacion_validar_inserts_temporal @txt_tabla_temporal_proceso, @txt_tabla_temporal, @cod_formato, @id_proceso
	SELECT @campos_select = dbo.FN_TIMPORTACION_FORAMTO_CAMPOS_SELECT (@cod_formato, 0)
	SELECT @where_campos_null = dbo.FN_TIMPORTACION_FORAMTO_CAMPOS_SELECT (@cod_formato, 1)
	SELECT * INTO #tmp_nombre_reg  FROM dbo.SplitNew( @txt_path_servidor, '\')
	EXEC usp_importacion_formato_validaciones_masivas @cod_formato,  @id_proceso, 0
exec sp_obtener_parametros 'masivo_emi_rehabilitar_polizas'
	exec COMM.GET_PARAMETERS @PARAMETER_ID=12146
	exec COMM.GET_PARAMETERS @PARAMETER_ID=80003
	exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session'
	exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session_Alert'
	exec usp_get_list_tcontrol_procesos -1,'DEMO','','1899-12-31 23:59:59','2025-07-04 00:00:00',-1
exec usp_cargar_timportacion_proceso_parametros 8773,87,1,'8773','Proceso'
exec usp_cargar_timportacion_proceso_parametros 8773,87,2,'DEMO','Usuario'
exec masivo_emi_rehabilitar_polizas 8773,'DEMO'
	EXEC @sp_error = masivo_emi_valid_rehabilitacion @nro_pol = @nro_pol, @cod_grupo_endo = @cod_grupo_endo, @cod_tipo_endo = @cod_tipo_endo, @nro_prop_interna = @nro_propuesta_interna,  @txt_error = @txt_error output -- 3 VECES
exec usp_crea_notif_proceso_masivo 87,8773,'DEMO',2,'REHABILITACIÓN MASIVA DE PÓLIZAS (8773)','Importación Finalizada Correctamente id_proceso: 8773','*bulkimport/bulkimport/ProcessBulkImportLoad?processId=8773&codFormat=87',0,0
	exec usp_crea_notif_masivo @id_formato, @cod_usuario, 2, @titulo, @mensaje, @url
	exec get_LocalDecimal 


/*  REHABILITACIÓN MASIVA MUESTRA NOTIFICACIONES
====================================================================================================*/
exec usp_actualiza_estado_notificaciones 0,'DEMO'
	exec usp_actualiza_estado_notificaciones_cp @idMensaje, @usuario
exec usp_load_combo 'ttipo_notif','id_notificacion','tipo_notificacion',''
exec COMM.GET_PARAMETERS @PARAMETER_ID=12146
exec COMM.GET_PARAMETERS @PARAMETER_ID=80003
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session'
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session_Alert'
exec sp_notificaciones @PageSize=1000,@PageNumber=1,@PageCount=0,@usuario=N'DEMO',@idMessage=0,@tittle=N'',@status=99,@type=-1,@dtFrom='2025-04-21 17:04:00',@dtTo='2025-04-21 17:04:00'
exec get_LocalDecimal 


/*  REHABILITACIÓN MASIVA ENTRO A RESULTADOS DE PROCESO
====================================================================================================*/
exec usp_obtener_path_importacion 'IMPORTACION MASIVA'
exec usp_get_timportacion_proceso_parametros 8773
exec usp_leer_abm_importacion_formato 87
exec usp_importacion_reportes 87
exec COMM.GET_PARAMETERS @PARAMETER_ID=12146
exec COMM.GET_PARAMETERS @PARAMETER_ID=80003
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session'
exec get_param_x_descrip @txt_param_descript=N'TimeOut_Session_Alert'
exec get_LocalDecimal 
exec usp_importacion_obt_registros_fallidos 8773



