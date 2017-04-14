/*------------------------------------*/
/* Creation date : 14/04/2017  (fr)   */
/* Last update :   14/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Unix 9.3.0.0         */
/*------------------------------------*/

/*------------------------------------*/
/*
' List of functions :
' 1 - DateToNum() -- returns the sas date as a numerique value => AAAAMMJJ 
' 2 - NumToDate() -- returns a sas date for an input numeric value representing a date.
*/
/*------------------------------------*/

/* Example data : */
data test;
	input date date2;
	informat date date9.;
	format date date9.;
	datalines;
		31DEC2016 20161231
		01JAN2017 20170101
		;
run;

/*-------------------*/
/*  1 - DateToNum()  */
/*-------------------*/

proc fcmp outlib=work.cat_function.test;
	function DateToNum(DateDay);
		da = day(DateDay);
		mo = month(DateDay);
		ye = year(DateDay);
		res = (ye * 10000) + (mo * 100) + da;
		return(res);
	endsub;
run;

/*-------------------*/
/*  2 - NumToDate()  */
/*-------------------*/

proc fcmp outlib=work.cat_function.test;
	function NumToDate(DateNum);
		ye = int(DateNum/10000);
		mo = int(DateNum/100)-(ye*100);
		da = DateNum - (int(DateNum/100) * 100);
		res = mdy(mo,da,ye);
		return(res);
	endsub;
run;

/*-------------------*/
/* Example :         */
/*-------------------*/
data test;
	set test;
	format num2date date9.;
	Date2Num = DateToNum(date);
	num2date = NumToDate(date2);
run;
