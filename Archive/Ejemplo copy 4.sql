/*  EMITIR RENOVACIONES DISCRETAS - GUARDAR RENOVACIÓN ANTES DE EMITIR
====================================================================================================*/
exec cot_execute_command @cod_command=1285,@patterns='policyId,tempCero, billingId, moveId,typeMove, nroPropInt, nroPropExt,nroCot',@values='51633985|4719086|1|5|1|123456|''''|''''',@query=default,@proc=1
    EXEC cot_separator_command @patterns, @values, @SQL OUTPUT
        EXEC @isValid = usp_validar_query @v_val -- X8
    EXEC emi_usp_renovacion_poliza 51633985, 4719086,1,5, 1, 0, 0,123456,'', '';
        EXEC sp_fecha_mov_suc @fec_emi, 1, 3, 1, @fecha_real = @fec_emi OUTPUT
            INSERT INTO @t  EXEC dbo.usp_get_fecha_tope_modulo @cod_modulo
        SELECT @imp_cambio = dbo.emi_fn_get_currency_change(cod_moneda, getdate())  FROM pv_header WHERE id_pv = @id_pv_ult_endo
        EXEC emi_usp_renovacion_riesgos @id_pv ,@id_pv_cero ,@sn_aplica_depreciacion
            EXEC emi_recuperar_datos_riesgo_dview @id_pv_wkf = @id_pv, @id_pv_endo = @id_pv_cero
                set @where = ' where ' + DBO.dview_getwhere(@id_view,@id_pv_wkf,0)
                    select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
                    select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
                    select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
                    select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
                    select  @valorCampo=count(*) from dbo.fn_Split(@parametros,'|')  where IDX = @vuelta
                    select @where_TABLA_TEMPORAL = @where_TABLA_TEMPORAL + ' AND ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
                    select @select_TABLA_TEMPORAL2 = @select_TABLA_TEMPORAL2 + ' , ' + ' {TABLA_TEMPORAL}.' + @cur_columna + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
                    select @where = @where + ' = ' + convert(varchar(max),value) from dbo.fn_Split(@parametros,'|') where IDX = @vuelta
                exec CargarVistasDinamicasEmision @id_pv_endo, @cod_ramo, @cod_usuario, @id_pv_wkf
                    execute usp_validar_vistas_dinamicas_procesos @iddynamicview, @ID_PV_DESTINO, @COD_USUARIO, @ID_PV
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



































































































