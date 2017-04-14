/*------------------------------------*/
/* Creation date : 14/04/2017  (fr)   */
/* Last update :   14/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3.0.0              */
/*------------------------------------*/
/*
Two SAS functions to get the week number of the year :
- 1 - NumWeekYearEuro()    
- 2 - NumWeekYearDefault() 

/* Example data : */
data test;
	input date;
	informat date date9.;
	format date date9.;
	datalines;
		31DEC2016
		01JAN2017
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
		;
run;

/*---------------------------*/
/*---------------------------*/
/*  1 - NumWeekYearEuro()    */

proc fcmp outlib=work.cat_function.test;
	function NumWeekYearEuro(DateDay);
		res=WEEK(DateDay,'W');  /* option 'V' can be used too ('U' by default)*/
		if res in (0,53) then res=52;
		return(res);
	endsub;
run;

/*------------------------------*/
/*------------------------------*/
/*  2 - NumWeekYearDefault()    */

proc fcmp outlib=work.cat_function.test;
	function NumWeekYearDefault(DateDay);
		res=WEEK(DateDay,'U');
		if res in (0,53) then res=52; 
		return(res);
	endsub;
run;


data test;
	set test;
	NumWeekDefault=NumWeekYearDefault(date);
	NumWeekEuro=NumWeekYearEuro(date);
run;
