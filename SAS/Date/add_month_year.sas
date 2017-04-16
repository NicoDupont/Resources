/*------------------------------------*/
/* Creation date : 15/04/2017  (fr)   */
/* Last update :   16/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Studio 9.4           */
/*------------------------------------*/

options cmplib=work.cat_function;

/*------------------------------------*/
/*
' List of functions :
' - 1 -- AddMonth()  ------- add or substract N Month to the date in parameter at the same day
' - 2 -- AddYear()  -------- add or substract N Year to the date in parameter at the same day
*/
/*------------------------------------*/

/* Example data : */
data test;
	input date date2;
	informat date date2 date9.;
	format date date2 date9.;
	datalines;
		31DEC2016 05JAN2017
		01JAN2017 05FEB2017
		15FEB2017 05MAR2017
		15FEB2016 05MAR2018
		08JAN2017 06JUL2017
		09JAN2017 19AUG2017
		;
run;

/*---------------------------*/
/*  1 - AddMonth()    		   */
/*---------------------------*/

proc fcmp outlib=work.cat_function.test;
	function AddMonth(DateDay,nb);
		res = intnx('month', DateDay, nb, 's');
		return(res);
	endsub;
run;


data test;
	set test;
  format ADDM SUBM date9.;
	ADDM=AddMonth(date,2);
  SUBM=AddMonth(date,-2);
run;


/*-------------------------*/
/*  2 - AddYear()    	   */
/*-------------------------*/

proc fcmp outlib=work.cat_function.test;
	function AddYear(DateDay,nb);
		res = intnx('year', DateDay, nb, 's');
		return(res);
	endsub;
run;


data test;
	set test;
  format ADDY SUBY date9.;
	ADDY=AddYear(date,1);
  SUBY=AddYear(date,-1);
run;
