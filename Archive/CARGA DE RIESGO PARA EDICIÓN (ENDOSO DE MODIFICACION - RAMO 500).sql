/*  CARGA DE RIESGO PARA EDICIÓN (ENDOSO DE MODIFICACION - RAMO 500)
====================================================================================================*/
exec emi_usp_get_fecha_item_stro @id_pv_wkf=51569382,@cod_item=1
    INSERT INTO @t_stro EXEC emi_valida_fec_stros @id_pv_wkf, @cod_item, @fec_stro OUTPUT
exec sp_rep_obtener_comando @p_cod_comando=962,@p_patrones=N'policyId,riskId',@p_valores=N'51569382|1'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=2175,@p_patrones=N'p_cod_ramo',@p_valores=N'500'
    EXEC @isValid = usp_validar_query @v_val
exec usp_obtener_vistas_dinamicas 0,0,12
exec usp_validar_vistas_dinamicas_procesos_temp 12,'51569382|1','DEMO'
    EXEC dview_validar_existen_tablas @id_view
            EXEC @validacion = [DVIEW_validar_tabla] @tabla,@ID_VIEW,@mensaje_campo_distinto output   , 0
        EXEC DVIEW_crear_tabla @ID_VIEW, @tabla, @sn_definitiva = -1
            EXEC Dview_actualizar_formato_det @txt_tabla,@cod_formato
        EXEC @validacion = [DVIEW_validar_tabla] @tabla,@ID_VIEW,@mensaje_campo_distinto output   , -1
        EXEC	DVIEW_crear_tabla @ID_VIEW, @tabla, @sn_definitiva = 0
    SELECT @where = dbo.dview_getwhere(@id_view, @id_process, 0)
        select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where = @where + ' = ' + convert(varchar(max),value)  from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' AND ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' , ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
exec usp_validar_vistas_dinamicas_procesos 12,'51569382|1','DEMO'
    EXEC DVIEW_VALIDAR_EXISTEN_TABLAS @id_view
        EXEC @validacion = [DVIEW_validar_tabla] @tabla,@ID_VIEW,@mensaje_campo_distinto output   , 0
        EXEC	DVIEW_crear_tabla @ID_VIEW, @tabla, @sn_definitiva = -1
            EXEC Dview_actualizar_formato_det @txt_tabla, @cod_formato
        EXEC @validacion = [DVIEW_validar_tabla] @tabla,@ID_VIEW,@mensaje_campo_distinto output   , -1
        EXEC	DVIEW_crear_tabla @ID_VIEW, @tabla, @sn_definitiva = 0
    SELECT @WHERE_TABLA_FINAL = DBO.dview_getwhere(@id_view, @CLAVE_FINAL, 0)
        select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' AND ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' , ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
    SELECT @WHERE_TABLA_TEMPORAL = DBO.dview_getwhere(@id_view, @id_process, 0)
        select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' AND ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' , ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
    SELECT @WHERE_TABLA_WKF = DBO.dview_getwhere(@id_view, @id_process, 5)
        select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' AND ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' , ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
    SELECT @JOIN_TABLA = DBO.dview_getwhere(@id_view, @id_process, 4) 
        select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta -- 2 VECES
    SELECT @CAMPOS_SELECT = dbo.[dview_getcapmostabla] (@id_view, 0)
    SELECT @ID_PV = VALUE FROM dbo.fn_Split(@id_process, '|') WHERE idx = 0 AND ISNUMERIC(VALUE) <> 0
exec usp_cargar_temporal_vistas_dinamicas_especiales 12,'51569382|1','DEMO'
    SELECT @ID_PV_WKF = VALUE FROM DBO.fn_Split(@id_process,'|') WHERE IDX = 0
    SELECT @COD_ITEM = VALUE FROM DBO.fn_Split(@id_process,'|') WHERE IDX = 1
    exec usp_validar_vistas_dinamicas_procesos @id_view,@id_process,@User, @CLAVE_BUSQUEDA
        EXEC DVIEW_VALIDAR_EXISTEN_TABLAS @id_view
            EXEC @validacion = [DVIEW_validar_tabla] @tabla,@ID_VIEW,@mensaje_campo_distinto output   , 0
            EXEC	DVIEW_crear_tabla @ID_VIEW, @tabla, @sn_definitiva = -1
                EXEC Dview_actualizar_formato_det @txt_tabla,@cod_formato
            EXEC @validacion = [DVIEW_validar_tabla] @tabla,@ID_VIEW,@mensaje_campo_distinto output   , -1
            EXEC	DVIEW_crear_tabla @ID_VIEW, @tabla, @sn_definitiva = 0
        SELECT @WHERE_TABLA_FINAL = DBO.dview_getwhere(@id_view, @CLAVE_FINAL, 0)
            select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
            select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
            select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
            select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
            select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
            select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' AND ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
            select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' , ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
            select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
        SELECT @WHERE_TABLA_TEMPORAL = DBO.dview_getwhere(@id_view, @id_process, 0)
            select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta















