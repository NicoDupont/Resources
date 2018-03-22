/****** Object: Function [dbo].[jour_ouvre]   Script Date: 22/03/2018 13:56:50 ******/
USE [BDD];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE FUNCTION [dbo].[jour_ouvre]
(@date_jour date = '=getdate()')
RETURNS int
WITH EXEC AS CALLER
AS
BEGIN
/* 
Date de type date à passer en paramètre
Retourne 1 si jour est un lundi,mardi,mercredi,jeudi,vendredi sinon 0
Testé sur SQL-Serveur 2016
22/03/2017 - NicolasD - Création
*/
declare @jour_ouvre int
declare @num_day_week int

set @num_day_week = datepart(weekday, @date_jour)

if @num_day_week < 6
  set @jour_ouvre = 1
else
  set @jour_ouvre = 0
  
return @jour_ouvre
END
GO
