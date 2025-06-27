/*  CARGA DE DATOS MODAL DE TOMADOR TAMBIÉN ES PAGADOR
====================================================================================================*/
-- CONTADO
exec sp_rep_obtener_comando @p_cod_comando=807,@p_patrones=N'insured_Id,payer_Method_Id',@p_valores=N'244954|1'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec emi_usp_recup_planes_pago @cod_ramo=200,@cod_moneda=4,@cod_conducto=1,@cod_prod_cial=-1

-- AVISO DE VENCIMIENTO
exec sp_rep_obtener_comando @p_cod_comando=807,@p_patrones=N'insured_Id,payer_Method_Id',@p_valores=N'244954|27'
    EXEC @isValid = usp_validar_query @v_val -- 2 VECES
exec emi_usp_recup_planes_pago @cod_ramo=200,@cod_moneda=4,@cod_conducto=27,@cod_prod_cial=-1

/*===================================================================================================*/
-- MÉTODO DE PAGO CONTADO -> AVERIGUAR PORQUÉ SE EJECUTA TODO 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=2219,@p_patrones=N'pid_pv, pfecha_emision, pfecha_vig_ini, pfecha_vig_fin, pcod_conducto, pcod_ppago',@p_valores=N'51563944|''13/05/2025''|''22/05/2025''|''22/05/2026''|1|1'
    EXEC @isValid = usp_validar_query @v_val -- 6 VECES
    EXEC emi_calcula_fecha_primer_vto 51563944,'13/05/2025','22/05/2025','22/05/2026',1,1;
        SELECT convert(varchar(10), fec_1_vto, 103) Id, convert(varchar(10), fec_1_vto, 103) [Description]
        FROM dbo.emi_ufn_calcular_primer_vto(@id_pv, @fec_emi, @fec_vig_desde, @fec_vig_hasta, @cod_conducto, @cod_ppago)

-- MÉTODO DE PAGO 10 CUOTAS IGUALES -> AVERIGUAR PORQUÉ SE EJECUTA TODO 2 VECES
exec sp_rep_obtener_comando @p_cod_comando=2219,@p_patrones=N'pid_pv, pfecha_emision, pfecha_vig_ini, pfecha_vig_fin, pcod_conducto, pcod_ppago',@p_valores=N'51563944|''13/05/2025''|''22/05/2025''|''22/05/2026''|1|30'
    EXEC @isValid = usp_validar_query @v_val -- 6 VECES
    EXEC emi_calcula_fecha_primer_vto 51563944,'13/05/2025','22/05/2025','22/05/2026',1,30;
        SELECT convert(varchar(10), fec_1_vto, 103) Id, convert(varchar(10), fec_1_vto, 103) [Description]
        FROM dbo.emi_ufn_calcular_primer_vto(@id_pv, @fec_emi, @fec_vig_desde, @fec_vig_hasta, @cod_conducto, @cod_ppago)