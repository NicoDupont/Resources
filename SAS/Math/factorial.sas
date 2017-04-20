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
. 2
0 2
;
run;


/*-------------------*/
/*  1 - Factorial()  */
/* 2 methods :       */
/*-------------------*/

proc fcmp outlib=work.cat_function.test ;
	function Factorial1(Number);
		if Number in (.,0,1)
			then fact = 1;
			else do;
				fact = 1;
				do i=2 to Number;
					fact = i * fact;
				end;
			end;
	    return(fact);
	endsub;
run;


proc fcmp outlib=work.cat_function.test ;
	function Factorial(Number);
		if Number in (.,0)
			then fact = 1; 
			else fact = Factorial(Number - 1) * Number;
	    return(fact);
	endsub;
run;

options cmplib=work.cat_function;


/* Example : */
data test;
	set test;
	FactNb1 = Factorial1(nb);
	FactNb = Factorial(nb);
run;
