/*------------------------------------*/
/* Creation date : 16/04/2017  (fr)   */
/* Last update :   16/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Studio 9.4           */
/*------------------------------------*/

/*
Compute the age.
- 1 - AgeToday() ---- returns the age compared to today.
- 2 - AgeDate() ----- returns the age compared to a date.
*/


/* Example data : */
data test;
	input birthday date2;
	informat birthday date2 date9.;
	format birthday date2 date9.;
	datalines;
		16APR1986 16APR2017
		15APR1986 16APR2017
		17APR1986 16APR2017
		29FEB2016 28FEB2017
		29FEB2016 27FEB2017
		29FEB2016 01MAR2017
		;
run;

/*------------------*/
/*  1 - AgeToday()  */
/*------------------*/

proc fcmp outlib=work.cat_function.test ;
	function AgeToday(DateDay);
		to = TODAY();
		bd = DateDay;
		age = int((intck('month',bd,to)-(day(bd)>day(to)))/12);
		/*if month(bd) = month(to) and day(bd) = day(to)
   			then age = year(to)-year(bd);
			else age = int(yrdif(bd,to,'ACTUAL'));*/
	return(age);
	endsub;
run;

/*------------------*/
/*  2 - AgeDate()   */
/*------------------*/

proc fcmp outlib=work.cat_function.test ;
	function AgeDate(Birthdate,Date);
		to = Date;
		bd = Birthdate;
		age = int((intck('month',bd,to)-(day(bd)>day(to)))/12);
	return(age);
	endsub;
run;

options cmplib=work.cat_function;


/* Example : */
data test;
	set test;
	AgeT = AgeToday(birthday);
	AgeD = AgeDate(birthday,date2);
run;
