/*------------------------------------*/
/* Creation date : 06/04/2017  (fr)   */
/* Last update :   11/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		      */
/* Tested on SAS 9.3                  */
/*------------------------------------*/

/* A simple macro to export a SAS dataset to a delimited text file : */

%macro DelimTextFileExport(Table,Path,NameOutput,Extension,Dlm);
	PROC EXPORT DATA=&Table
	    OUTFILE ="&Path./&NameOutput..&Extension."
	    REPLACE
	    DBMS = DLM REPLACE
	    /*LABEL*/; /* use LABEL if you want the header row to contain variable labels instead of variable names */
	    DELIMITER = &Dlm;
	    /*putnames=no; => do not write column/variable name */	
	RUN;
%mend;


/* Examples */
%DelimTextFileExport(SASHELP.CARS,$SASGRP/DUPONTNI,CARS_CSV,csv,';')
%DelimTextFileExport(SASHELP.CARS,$SASGRP/DUPONTNI,CARS_CSV2,csv,',')
%DelimTextFileExport(SASHELP.CARS,$SASGRP/DUPONTNI,CARS_TXT,txt,'|')
