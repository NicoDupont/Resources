/****** Object: Function [dbo].[jour_ouvrable]   Script Date: 22/03/2018 13:53:18 ******/
USE [BDD];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE FUNCTION [dbo].[jour_ouvrable]
(@date_jour date = '=getdate()')
RETURNS int
WITH EXEC AS CALLER
AS
BEGIN
/* 
Date de type date à passer en paramètre
Retourne 1 si jour est un lundi,mardi,mercredi,jeudi,vendredi,samedi sinon 0
Testé sur SQL-Serveur 2016
22/03/2017 - NicolasD - Création
*/
declare @jour_ouvrable int
declare @num_day_week int

set @num_day_week = datepart(weekday, @date_jour)

if @num_day_week < 7
  set @jour_ouvrable = 1
else
  set @jour_ouvrable = 0
  
return @jour_ouvrable
END
GO