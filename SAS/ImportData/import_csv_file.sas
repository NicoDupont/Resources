/*------------------------------------
* Created :       21/07/2017  (fr)  
* Last update :   21/07/2017  (fr)   
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* Tested on SAS Studio 9.4 onDemand         
-------------------------------------*/

/* 
  * Easy way :
*/
FILENAME REFFILE '/home/nicolasdupont0/Data/test.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	REPLACE
	OUT=WORK.IMPORT;
	GETNAMES=YES;
	DATAROW=2;
	GUESSINGROWS=500;
RUN;

DATA data.test;
set WORK.IMPORT;
run;
