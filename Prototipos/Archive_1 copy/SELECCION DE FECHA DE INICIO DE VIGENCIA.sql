/*  SELECCIÓN DE FECHA DE INICIO DE VIGENCIA
====================================================================================================*/
exec cot_get_cant_dias_vigen @fec_desde=N'20250515 12:00 PM',@fec_hasta=N'20260513 12:00 PM',@cod_periodo_fact=1
    SET @cant_dias = dbo.fn_dias_vigencia(@fec_desde, @fec_hasta, @cod_periodo_fact)
exec cot_get_cant_dias_vigen @fec_desde=N'20250515 12:00 PM',@fec_hasta=N'20260515 12:00 PM',@cod_periodo_fact=1
    SET @cant_dias = dbo.fn_dias_vigencia(@fec_desde, @fec_hasta, @cod_periodo_fact)