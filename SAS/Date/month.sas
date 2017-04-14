/*------------------------------------*/
/* Creation date : 14/04/2017  (fr)   */
/* Last update :   14/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3                  */
/*------------------------------------*/
/*
Two SAS functions to get the month from a date in string.
- 1 - MonthText() return the month in string
- 2 - Monthyear() returns the month-year concatenated in string
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

%macro example_date();
	data test;
		set test (drop=M M2);
	run;
%mend;
*%example_date();


/*-------------------*/
/*-------------------*/
/*  1 - MonthText()    */
proc fcmp outlib=work.cat_function.test ;
	function MonthText(DateDay,Language $) $;
		/* There is no test if DateDay is a real date.. */
		Lg=Language;
		mo=month(DateDay);
		length m $ 9;
		if Lg='EN' then do;
			select (mo);
				when (1) m='january';
				when (2) m='february';
				when (3) m='march';
				when (4) m='april';
				when (5) m='may';
				when (6) m='june';
				when (7) m='july';
				when (8) m='august';
				when (9) m='september';
				when (10) m='october';
				when (11) m='november';
				when (12) m='december';
				otherwise put 'Not a date !';
			end;
		end;
		else do;
			select (mo);
				when (1) m='janvier';
				when (2) m='février';
				when (3) m='mars';
				when (4) m='avril';
				when (5) m='mai';
				when (6) m='juin';
				when (7) m='juillet';
				when (8) m='aout';
				when (9) m='septembre';
				when (10) m='octobre';
				when (11) m='novembre';
				when (12) m='décembre';
				otherwise put 'Not a date !';
			end;
		end;
	return(m);
	endsub;
run;

options cmplib=work.cat_function;

data test;
	set test;
	length M M2 $ 9;
	format M M2 $9.;
	M=MonthText(date,'EN');
	M2=MonthText(date,'FR');
run;

/*-----------------------*/
/*-----------------------*/
/*  2 - MonthYear()    */
*%example_date();

proc fcmp outlib=work.cat_function.test;
	function MonthYear(DateDay,Language $) $;
		/* There is no test if DateDay is a real date.. */
		Lg = Language;
		mo = month(DateDay);
		ye = put(year(DateDay),4.);
		length m $ 14;
		if Lg='EN' then do;
			select (mo);
				when (1)  m='january-'||ye;
				when (2)  m='february-'||ye;
				when (3)  m='march-'||ye;
				when (4)  m='april-'||ye;
				when (5)  m='may-'||ye;
				when (6)  m='june-'||ye;
				when (7)  m='july-'||ye;
				when (8)  m='august-'||ye;
				when (9)  m='september-'||ye;
				when (10) m='october-'||ye;
				when (11) m='november-'||ye;
				when (12) m='december-'||ye;
				otherwise put 'Not a date !';
			end;
		end;
		else do;
			select (mo);
				when (1)  m=compress('janvier-'||ye);
				when (2)  m=compress('février-'||ye);
				when (3)  m=compress('mars-'||ye);
				when (4)  m=compress('avril-'||ye);
				when (5)  m=compress('mai-'||ye);
				when (6)  m=compress('juin-'||ye);
				when (7)  m=compress('juillet-'||ye);
				when (8)  m=compress('aout-'||ye);
				when (9)  m=compress('septembre-'||ye);
				when (10) m=compress('octobre-'||ye);
				when (11) m=compress('novembre-'||ye);
				when (12) m=compress('décembre-'||ye);
				otherwise put 'Not a date !';
			end;
		end;
	return(m);
	endsub;
run;

data test;
	set test;
	length My My2 $ 14;
	format My My2 $14.;
	My=MonthYear(date,'FR');
	My2=MonthYear(date,'EN');
run;
