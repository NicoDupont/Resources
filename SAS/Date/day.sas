/*------------------------------------*/
/* Creation date : 14/04/2017  (fr)   */
/* Last update :   14/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3                  */
/*------------------------------------*/
/*
- 1 - DayWeek()    returns the day in string
- 2 - NumDayWeek() returns the number of the day of the week in string
*/

/* Example data : */
data test;
	input date;
	informat date date9.;
	format date date9.;
	datalines;
		31DEC2016
		05JAN2017
		05APR2017
		09JUL2017
		10NOV2017
		31DEC2017
		;
run;

/*-------------------*/
/*-------------------*/
/*  1 - DayWeek()    */

proc fcmp outlib=work.cat_function.test;
	function DayWeek(DateDay,Language $) $;
		/* There is no test if DateDay is a real date.. */
		Lg = Language;
		nd=WEEKDAY(DateDay);  
		IF nd = 1 
			THEN 
				nd = 7; 
			ELSE 
				nd+-1;
		length d $ 9;
		if Lg='EN' then do;
			select (nd);
				when (1)  d='monday';
				when (2)  d='tuesday';
				when (3)  d='wednesday';
				when (4)  d='thursday';
				when (5)  d='friday';
				when (6)  d='saturday';
				when (7)  d='sunday';
				otherwise put 'Not a date !';
			end;
		end;
		else do;
			select (nd);
				when (1)  d='lundi';
				when (2)  d='mardi';
				when (3)  d='mercredi';
				when (4)  d='jeudi';
				when (5)  d='vendredi';
				when (6)  d='samedi';
				when (7)  d='dimanche';
				otherwise put 'Not a date !';
			end;
		end;
	return(d);
	endsub;
run;

data test;
	set test;
	length da da2 $ 9;
	format da da2 $9.;
	da=DayWeek(date,'FR');
	da2=DayWeek(date,'EN');
run;



/*----------------------*/
/*----------------------*/
/*  2 - NumDayWeek()    */

proc fcmp outlib=work.cat_function.test;
	function NumDayWeek(DateDay) $;
		/* There is no test if DateDay is a real date.. */
		nd=WEEKDAY(DateDay);  
		IF nd = 1 
			THEN 
				nd = 7; 
			ELSE 
				nd+-1;
		length d $ 1;
		d=put(nd,1.);
	return(d);
	endsub;
run;


data test;
	set test;
	length Numday $ 1;
	format Numday $1.;
	Numday=NumDayWeek(date);
run;
