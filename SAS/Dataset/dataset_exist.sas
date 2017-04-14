/*------------------------------------*/
/* Creation date : 14/04/2017  (fr)   */
/* Last update :   14/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Unix 9.3.0.0         */
/*------------------------------------*/


%GLOBAL datasetexist;

%macro DatasetExist(LIB=,TABLE=);

    %if %sysfunc(EXIST(%sysfunc(compress(&LIB..&TABLE.)))) ne 1 
		%then %LET DatasetExist=0;
		%else %LET DatasetExist=1;
 	%put DatasetExist : &DatasetExist;
    %if %eval(&datasetexist)>0 
	%then %do;
		%put --------------------------;
		%put The dataset : &LIB..&TABLE exist;
		%put --------------------------;
	%end;
    %else %do;
		%put --------------------------;
		%put The dataset : &LIB..&TABLE don%str(%')t exist;
		%put --------------------------;
	%end;
%mend;

data CARS;
set SASHELP.CARS;
run;

/*ok*/
%DatasetExist(LIB=WORK,TABLE=CARS);

/*ko*/
%DatasetExist(LIB=WORK,TABLE=CARSS);
