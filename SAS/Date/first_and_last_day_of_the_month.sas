/*------------------------------------*/
/* Creation date : 14/04/2017  (fr)   */
/* Last update :   14/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3.0.0              */
/*------------------------------------*/
/*
- 1 - BeginMonth()  returns the first day of the month for the date in parameter.  
- 2 - EndMonth()    returns the last day of the month for the date in parameter.  
*/

/* Example data : */
data test;
	input date;
	informat date date9.;
	format date date9.;
	datalines;
		31DEC2016
		01JAN2017
		15FEB2017
		15FEB2016
		08JAN2017
		09JAN2017
		25DEC2017
		31DEC2017
		01JAN2018
		05JAN2017
		05APR2017
		09JUL2017
		10NOV2017
		31DEC2017
		15MAR2017
		;
run;

/*----------------------*/
/*----------------------*/
/*  1 - BeginMonth()    */

proc fcmp outlib=work.cat_function.test;
	function BeginMonth(DateDay);
		res=intnx('month', DateDay, 0, 'b'); 
		return(res);
	endsub;
run;

/*--------------------*/
/*--------------------*/
/*  2 - EndMonth()    */

proc fcmp outlib=work.cat_function.test;
	function EndMonth(DateDay);
		res=intnx('month', DateDay, 0, 'e'); 
		return(res);
	endsub;
run;


data test;
	set test;
	format FirstDay lastDay DATE9.;
	FirstDay=BeginMonth(date);
	LastDay=EndMonth(date);
run;
