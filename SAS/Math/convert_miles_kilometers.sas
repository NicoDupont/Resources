/*------------------------------------*/
/* Creation date : 03/05/2017  (fr)   */
/* Last update :   03/05/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3 (Unix)           */
/*------------------------------------*/

/*
1 - ToKm() --- Convert miles to kilometers
2 - ToMile()-- Convert kilometers to miles 
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
88
89
100
200
150
20
;
run;

options cmplib=work.cat_function;

/*------------*/
/* 1 - ToKm() */
/*------------*/

proc fcmp outlib=work.cat_function.test ;
	function ToKm(Number);
		res = Number * 1.609344;
	    return(res);
	endsub;
run;


/*--------------*/
/* 2 - ToMile() */
/*--------------*/

proc fcmp outlib=work.cat_function.test ;
	function ToMile(Number);
		res = Number * 0.621371192237334;
	    return(res);
	endsub;
run;


/* Example : */
data test;
	set test;
	Ckms = ToKm(nb);
	CMiles = ToMile(nb);
run;
