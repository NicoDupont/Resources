/****** Object: Function [dbo].[jour_ferie]   Script Date: 22/03/2018 13:55:07 ******/
USE [BDD];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE FUNCTION [dbo].[jour_ferie]
(@date_jour date = '=getdate()')
RETURNS int
WITH EXEC AS CALLER
AS
BEGIN

/* 
Date de type date à passer en paramètre
Retourne 1 si le jour est férié
Si aucune date passée en parametre alors la fonction utilise la date du jour par defaut
Testé sur SQL-Serveur 2016
22/03/2017 - NicolasD - Création
*/

/*declaration variable retour*/
declare @jour_ferie int

/*récupération de l'année*/
declare @year_int int
declare @year varchar(4)
set @year_int = datepart(year, @date_jour)
set @year  = convert(varchar(4),@year_int)

/*calcul jour paques*/
declare @mod9 int
declare @mod4 int
declare @mod7 int
declare @day_pa int
declare @day_pa_char varchar(2)
declare @date_pa date

set @mod9 = ((19 * (@year_int % 19)) + 24) % 30
set @mod4 = @year_int % 4
set @mod7 = @year_int % 7

set @day_pa = (@mod9 + (2 * @mod4 + 4 * @mod7 + 6 * @mod9 + 5) % 7) - 9

if @day_pa >= 1 and @day_pa <= 9
  set @day_pa_char = concat('0',convert(varchar(1),@day_pa))
else IF @day_pa >= 10 and @day_pa <=30
  set @day_pa_char = convert(varchar(2),@day_pa)
else if @day_pa >= 31
  set @day_pa_char = convert(varchar(2),@day_pa-30)
else /*<=0*/
  set @day_pa_char = convert(varchar(2),31+@day_pa)

if @day_pa <= 0 
  set @date_pa = convert(date,CONCAT (@day_pa_char,'/03/',@year),103)
else if @day_pa > 30
  set @date_pa = convert(date,CONCAT (@day_pa_char,'/05/',@year),103)
else
  set @date_pa = convert(date,CONCAT (@day_pa_char,'/04/',@year),103)

/*calcul 1 ou 0 si jour ferie ou non*/
set @jour_ferie =
  CASE   
    WHEN convert(date,CONCAT ('01/01/',@year),103) = @date_jour THEN 1 /*Nouvel an*/
    WHEN convert(date,CONCAT ('01/05/',@year),103) = @date_jour THEN 1 /*1er Mai*/
    WHEN convert(date,CONCAT ('08/05/',@year),103) = @date_jour THEN 1 /*8 Mai*/
    WHEN convert(date,CONCAT ('14/07/',@year),103) = @date_jour THEN 1 /*14 Juillet*/ 
    WHEN convert(date,CONCAT ('15/08/',@year),103) = @date_jour THEN 1 /*15 Aout*/ 
    WHEN convert(date,CONCAT ('01/11/',@year),103) = @date_jour THEN 1 /*1er Novembre*/    
    WHEN convert(date,CONCAT ('11/11/',@year),103) = @date_jour THEN 1 /*11 Novembre*/  
    WHEN convert(date,CONCAT ('25/12/',@year),103) = @date_jour THEN 1 /*25 Décembre*/
    WHEN @date_pa = @date_jour THEN 1                                  /*Paques*/ 
    WHEN DATEADD (day, 1, @date_pa) = @date_jour THEN 1                /*Lundi de Paques*/
    WHEN DATEADD (day, 39, @date_pa) = @date_jour THEN 1               /*Ascension*/
    WHEN DATEADD (day, 49, @date_pa) = @date_jour THEN 1               /*Pentecôte*/
    WHEN DATEADD (day, 50, @date_pa) = @date_jour THEN 1               /*Lundi de Pentecôte*/
  END   
  
if @jour_ferie is null
  set @jour_ferie = 0
  
/*retour*/
return @jour_ferie
END
GO

/*
Date de Pâques 2018 : Pâques tombera le  1er avril 2018, et ce n'est pas une farce !
Date de Pâques 2019 : Dimanche de Pâques = 21 avril 2019
Date de Pâques 2020 : Dimanche 12 avril 2020
Date de Pâques 2021 : Pâques sera le 4 avril 2021
Date de Pâques 2022 : Dimanche de Pâques 17 avril 2022
Date de Pâques 2023 : 9 avril 2023
Date de Pâques 2024 : dimanche 31 mars 2024
Date de Pâques 2025 : 20 avril 2025
Date de Pâques 2026 : Pâques sera le 5 avril 2026
Date de Pâques 2027 : Pâques tombe le 28 mars 2027
Date de Pâques 2028 : le 16 avril 2028 sera le jour de Pâques pour 20128
Date de Pâques 2029 : 1er avril 2029
Date de Pâques 2030 : 21 avril 2030
Date de Pâques 2031 : La date de Pâques sera le 13 avril 2031
Date de Pâques 2032 : 28 mars 2032
Date de Pâques 2033 : 17 avril 2033
Date de Pâques 2034 : 9 avril 2034
Date de Pâques 2035 : 25 mars 2035
*/