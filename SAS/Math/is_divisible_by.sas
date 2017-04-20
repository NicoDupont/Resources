/*------------------------------------*/
/* Creation date : 20/04/2017  (fr)   */
/* Last update :   20/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		      */
/* Tested on SAS 9.3                  */
/*------------------------------------*/


/* Example data : */
data test;
	input nb dv;
	datalines;
1  2
2  2
2  3
3  2
4  5
5  5
6  2
7  8
8  2
9  9
10 2
11 10
12 2
13 11
14 2
;
run;


/*-----------------------*/
/*  1 - IsDivisibleBy()  */
/*-----------------------*/

proc fcmp outlib=work.cat_function.test ;
	function IsDivisibleBy(Number,Divider);
		if mod(Number,Divider) = 0
			then divby = 1;
			else divby = 0;
	    return(divby);
	endsub;
run;

options cmplib=work.cat_function;


/* Example : */
data test;
	set test;
	DivBy = IsDivisibleBy(nb,dv);
run;
