/*------------------------------------
* Created :       05/07/2017  (fr)
* Last update :   11/07/2017  (fr)
* Author(s) : Nicolas Dupont
* Contributor(s) :
* Tested on SAS Studio 9.4 onDemand
-------------------------------------*/

/*------------------------------------
Sometimes it can be useful to find the physical path of a "libname"
-------------------------------------*/

%let pathwork = %sysfunc(pathname(work)); 
%put Path of the work libref:;
%put &pathwork;
%put -----------;
%put -----------;


libname datagit '/home/nicolasdupont0/Data';
%let pathdatag = %sysfunc(pathname(datagit)); 
%put Path of the datagit libref:;
%put &pathdatag;
%put -----------;
%put -----------;


/*------------------------------------
With SASHELP VIEWS and DICTIONARY Tables
-------------------------------------*/

data _null_;
	set sashelp.vlibnam(keep=libname path where=(libname='DATAGIT'));
 	call symputx('datagitpath',path,'l');
run;

%put Path of the datagit libref:;
%put &datagitpath;
%put -----------;
%put -----------;


proc sql noprint;
	/*describe table dictionary.libnames;*/
	select path into :datagitpath2
	from dictionary.libnames
	where libname='DATAGIT';
quit;
%put Path of the datagit libref:;
%put &datagitpath2;
%put -----------;
%put -----------;
