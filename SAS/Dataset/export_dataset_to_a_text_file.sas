/*------------------------------------*/
/* Creation date : 06/04/2017  (fr)   */
/* Last update :   09/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		              */
/* Tested on SAS 9.3                  */
/*------------------------------------*/

/* A simple macro to export a SAS dataset to a text file : */

%macro TextFileExport(Table,Path,NameOutput,Extension,Dlm);
	PROC EXPORT DATA=&Table
	    OUTFILE ="&Path./&NameOutput..&Extension."
	    REPLACE
	    DBMS = DLM REPLACE;
	    DELIMITER = &Dlm;
	    /*putnames=no; => do not write column/variable name */	
	RUN;
%mend;


/* Examples */
%TextFileExport(SASHELP.CARS,$SASGRP/DUPONTNI,CARS_CSV,csv,';')
%TextFileExport(SASHELP.CARS,$SASGRP/DUPONTNI,CARS_CSV2,csv,',')
%TextFileExport(SASHELP.CARS,$SASGRP/DUPONTNI,CARS_TXT,txt,'|')
