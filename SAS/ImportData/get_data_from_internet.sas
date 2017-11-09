/*---------------------------------------
* Creation date : 28/04/2017  (fr)     
* Last update :   09/11/2017  (fr)    
* Author(s) : Nicolas DUPONT           
* Contributor(s) : 		            
* Tested on SAS Studio 9.4 ondemand   
* Comment : 
---------------------------------------*/

/*
How to get data from internet and use them in a sas program.
*/

FILENAME download TEMP TERMSTR=LF /*(TERMSTR=CRLF / for windows file)*/;
 
/* Download the file from the Internet. Here on my Github repo. */

proc http
 method='GET'
 url="https://raw.githubusercontent.com/NicoDupont/Resources/master/SAS/Data/train.csv"
 out=download;
run;

PROC IMPORT DATAFILE=download
	DBMS=csv
	OUT=work.titanic_train replace;	
RUN;


filename download clear;
