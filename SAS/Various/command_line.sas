/*------------------------------------*/
/* Creation date : 05/05/2017  (fr)   */
/* Last update :   05/05/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		              */
/* Tested on SAS Studio 9.4 (OnDemand)*/
/*------------------------------------*/

* Different ways to send command lines to the system ;
* and get results if needed ;

/*
1 - Data _NULL_
2 - Filename and pipe
3 - Macro : %CmdLine(cmd,table=_NULL_)
*/

dm log 'clear';
dm lst 'clear';

/*%let workdir=%sysfunc(pathname(work));*/

/*-----------*/
/* 1 - Data  */
/*-----------*/

/*
data _NULL_;
	call system("command");
run;
*/

/*Example:*/
/*cp train.csv in data to another folder*/

data _NULL_;
	call system("cp /home/nico/sasrep/test.sas /home/nico/sasrep/test1.sas");
run;

/*--------------*/
/* 2 - Filename */
/*--------------*/

/* Write the result of a commande line in a table :*/
filename lsdir pipe "ls /home/nico/sasrep";  /* "ps -e|grep 'sas'"  => sas process */
data cmdresult;
   length file $ 300;
   infile lsdir truncover;
   input file $300.;
run;
proc print data=cmdresult;
run;

/*---------------------------------*/
/* 3 - Macro : %CmdLine(cmd,table) */
/*---------------------------------*/

/*
With that macro-program you can simply execute a command line 
and if needed, you can get the result in a table.
*/

%macro CmdLine(cmd,table=_NULL_);
	
	/*Do not confuse CMD and the macro-variable &CMD*/
	%local CMD ;  
	Filename CMD Pipe 
	%if %qsubstr(&CMD,1,1) ~= %str(%")  
		%then "&CMD";
		%else &CMD;;
	%put $ &CMD;  
	%if  &table ne _NULL_  
		%then %put => &table ;;
	/* If the table parameter is not assigned. a dataset _NULL_ is generated */
	Data &table;
	Length LINERESULT $300;
	infile CMD truncover;
	input LINERESULT $300.;
	%if &table = _NULL_  
		%then Put LINERESULT;;
	Run;
	/*execute the filename :*/
	filename CMD;
		
%mend CmdLine;

%put ----------;
%put Example 1 ;
%put ----------;
%CmdLine(cmd=%bquote(ls /home/nico/sasrep),table=test);
proc print data=work.test;
run;

%put ----------;
%put Example 2 ;
%put ----------;
%CmdLine(cmd="cp /home/nico/sasrep/test.sas /home/nico/sasrep/test1.sas");
%put ----------;
