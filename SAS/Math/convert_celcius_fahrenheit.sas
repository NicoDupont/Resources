/*------------------------------------*/
/* Creation date : 03/05/2017  (fr)   */
/* Last update :   03/05/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3 (Unix)           */
/*------------------------------------*/

/*
1 - ToCelcius() --- Convert Fahrenheit to celcius
2 - ToFahr()------- Convert Celcius to Fahrenheit 
*/

/* Example data : */
data test;
	input nb;
	datalines;
10
37
38
39
40
41
42
0
-1
1
-5
5
50
;
run;

options cmplib=work.cat_function;

/*-----------------*/
/* 1 - ToCelcius() */
/*-----------------*/

proc fcmp outlib=work.cat_function.test ;
	function ToCelcius(Fah);
		res = ((Fah - 32) / (1.8));
	    return(res);
	endsub;
run;


/*--------------*/
/* 2 - ToFahr() */
/*--------------*/

proc fcmp outlib=work.cat_function.test ;
	function ToFahr(Cel);
		res = ((Cel * (1.8)) + 32);
	    return(res);
	endsub;
run;


/* Example : */
data test;
	set test;
	CCelcius = ToCelcius(nb);
	CFahrenheit = ToFahr(nb);
run;
