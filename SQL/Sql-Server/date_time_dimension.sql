TRUNCATE TABLE [dbo].[DIM_DATE_HEURE]
DECLARE @StartDate DATETIME = '01/01/2016 00:00:00' DECLARE @EndDate DATETIME = '01/01/2025 00:00:00'

DECLARE @CurrentDate AS DATETIME = @StartDate

DECLARE @CurrentDate_travail AS DATETIME = dateadd(hour, +2, @StartDate)
WHILE @CurrentDate < @EndDate
BEGIN

	
	INSERT INTO [dbo].[DIM_DATE_HEURE]
		SELECT 
			format((@CurrentDate),'yyyyMMddHHmm') as id_date,
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
			DATEPART(YY, @CurrentDate) as ANNEE,
      
      DATENAME(HH, @CurrentDate) as heure,
      DATENAME(n, @CurrentDate) as minute,
      
       CONVERT (char(8),@CurrentDate_travail,112),

			DATENAME(DW, @CurrentDate_travail) as JOUR_NOM_travail,
			DATEPART(DY, @CurrentDate_travail) AS JOUR_ANNEE_travail,
			DATEPART(DD, @CurrentDate_travail) AS JOUR_MOIS_travail,
			DATEPART(DW, @CurrentDate_travail) AS JOUR_SEMAINE_travail,
			DATEPART(WK, @CurrentDate_travail) AS SEMAINE_travail,
			DATEPART(WK, @CurrentDate_travail )-DATEPART(WK,@CurrentDate_travail-DAY(@CurrentDate_travail)+1)+1 as SEMAINE_MOIS_travail,
			DATEPART(MM, @CurrentDate_travail) AS MOIS_travail,
			DATENAME(MM, @CurrentDate_travail) AS MOIS_NOM_travail,
			DATEPART(QQ, @CurrentDate_travail) as TRIMESTRE_travail,
			(DATEPART(QQ, @CurrentDate_travail)+1) / 2 as SEMESTRE_travail,
			DATEPART(YY, @CurrentDate_travail) as ANNEE_travail
      
     

	SET @CurrentDate = DATEADD(n, 1, @CurrentDate)
  SET @CurrentDate_travail = DATEADD(n, 1, @CurrentDate_travail)
END