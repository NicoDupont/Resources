TRUNCATE TABLE [dbo].[DIM_DATE]
DECLARE @StartDate DATETIME = '01/01/2014' DECLARE @EndDate DATETIME = '31/12/2050' 

DECLARE @CurrentDate AS DATETIME = @StartDate


WHILE @CurrentDate < @EndDate
BEGIN

	
	INSERT INTO [dbo].[DIM_DATE]
		SELECT 
			CONVERT (char(8),@CurrentDate,112) as id_date,
			@CurrentDate AS Date,
			DATENAME(DW, @CurrentDate) as JOUR_NOM,
			DATEPART(DY, @CurrentDate) AS JOUR_ANNEE,
			DATEPART(DD, @CurrentDate) AS JOUR_MOIS,
			DATEPART(DW, @CurrentDate) AS JOUR_SEMAINE,
			DATEPART(WK, @CurrentDate) AS SEMAINE,
			DATEPART(WK, @CurrentDate )-DATEPART(WK,@CurrentDate-DAY(@CurrentDate)+1)+1 as SEMAINE_MOIS,
			DATEPART(MM, @CurrentDate) AS MOIS,
			DATENAME(MM, @CurrentDate) AS MOIS_NOM,
			DATEPART(QQ, @CurrentDate) as TRIMESTRE,
			(DATEPART(QQ, @CurrentDate)+1) / 2 as SEMESTRE,
			DATEPART(YY, @CurrentDate) as ANNEE

	SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END