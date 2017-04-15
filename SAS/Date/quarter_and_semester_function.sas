/*------------------------------------*/
/* Creation date : 09/04/2017  (fr)   */
/* Last update :   15/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Studio 9.4           */
/*------------------------------------*/
/*
Four SAS functions to get the quarter and the semester from a date.
- 1 - Quarter()
- 2 - QuarterYear()
- 3 - Semester()
- 4 - SemesterYear()
*/

/* Example data : */
data test;
	input date;
	informat date date9.;
	format date date9.;
	datalines;
		05JAN2017
		05APR2017
		09JUL2017
		10NOV2017
		;
run;

%macro example_date();
	data test;
		set test (drop=quarter quarter2);
	run;
%mend;
%macro example_date2();
	data test;
		set test (drop=semester);
	run;
%mend;
*%example_date();
*%example_date2();

/*-------------------*/
/*-------------------*/
/*  1 - Quarter()    */
proc fcmp outlib=work.cat_function.test ;
	function Quarter(DateDay,Language $) $ ;
		/* There is no test if DateDay is a real date.. */
		Lg=Language;
		qd=QTR(DateDay);
		length q $ 2;
		if Lg='EN' then do;
			select (qd);
				when (1) q='Q1';
				when (2) q='Q2';
				when (3) q='Q3';
				when (4) q='Q4';
				otherwise put 'Not a date !';
			end;
		end;
		else do;
			select (qd);
				when (1) q='T1';
				when (2) q='T2';
				when (3) q='T3';
				when (4) q='T4';
				otherwise put 'Not a date !';
			end;
		end;
	return(q);
	endsub;
run;

options cmplib=work.cat_function;

data test;
	set test;
	quarter=Quarter(date,'EN');
	quarter2=Quarter(date,'FR');
run;

/*-----------------------*/
/*-----------------------*/
/*  2 - QuarterYear()    */
%example_date();

proc fcmp outlib=work.cat_function.test ;
	function QuarterYear(DateDay,Language $) $ ;
		/* There is no test if DateDay is a real date.. */
		Lg=Language;
		qd=QTR(DateDay);
		ye=put(year(DateDay),4.);
		length q $ 7;
		if Lg='EN' then do;
			select (qd);
				when (1) q=compress('Q1-'||ye);
				when (2) q=compress('Q2-'||ye);
				when (3) q=compress('Q3-'||ye);
				when (4) q=compress('Q4-'||ye);
				otherwise put 'Not a date !';
			end;
		end;
		else do;
			select (qd);
				when (1) q=compress('T1-'||ye);
				when (2) q=compress('T2-'||ye);
				when (3) q=compress('T3-'||ye);
				when (4) q=compress('T4-'||ye);
				otherwise put 'Not a date !';
			end;
		end;
	return(q);
	endsub;
run;

data test;
	set test;
	length quarter $7.;
	format quarter $7.;
	quarter=QuarterYear(date,'FR');
	quarter2=QuarterYear(date,'EN');
run;

/*--------------------*/
/*--------------------*/
/*  3 - Semester()    */
%example_date();

proc fcmp outlib=work.cat_function.test ;
	function Semester(DateDay) $ ;
		/* There is no test if DateDay is a real date.. */
		qd=QTR(DateDay);
		length q $ 2;
		if qd in (1,2) then se=1; else se=2;
		select (se);
			when (1) s='S1';
			when (2) s='S2';
			otherwise put 'Not a date !';
		end;
	return(s);
	endsub;
run;


data test;
	set test;
	semester=Semester(date);
run;

/*------------------------*/
/*------------------------*/
/*  4 - SemesterYear()    */
%example_date2();

proc fcmp outlib=work.cat_function.test ;
	function SemesterYear(DateDay) $ ;
		/* There is no test if DateDay is a real date.. */
		qd=QTR(DateDay);
		ye=put(year(DateDay),4.);
		length q $ 7;
		if qd in (1,2) then se=1; else se=2;
		select (se);
			when (1) s=compress('S1-'||ye);
			when (2) s=compress('S2-'||ye);
			otherwise put 'Not a date !';
		end;
	return(s);
	endsub;
run;


data test;
	set test;
	semester=SemesterYear(date);
run;
