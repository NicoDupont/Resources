/*------------------------------------*/
/* Creation date : 20/04/2017  (fr)   */
/* Last update :   20/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		      */
/* Tested on SAS 9.3                  */
/*------------------------------------*/


/* Example data : */
data test;
	input nb;
	datalines;
1
2
3
4
5
6
7
8
9
10
11
12
13
14
;
run;


/*---------------------*/
/*  1 - IsEven()       */
/*---------------------*/

proc fcmp outlib=work.cat_function.test ;
	function IsEven(Number);
		if mod(Number,2) = 0
			then even = 1;
			else even = 0;
	    return(even);
	endsub;
run;

options cmplib=work.cat_function;


/* Example : */
data test;
	set test;
	Even = IsEven(nb);
	if Even = 0 
		then Odd=1; 
		else Odd=0;
run;
