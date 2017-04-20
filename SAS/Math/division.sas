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
0 1
1 0
. 2
. 8
8 .
;
run;


/*------------------*/
/*  1 - Division()  */
/*------------------*/

proc fcmp outlib=work.cat_function.test ;
	function Division(Numerator,Denominator);
		if Numerator in (.,0) or Denominator in (.,0)
			then div = .; /* or 0 ?*/
			else div = Numerator / Denominator;
	    return(div);
	endsub;
run;

options cmplib=work.cat_function;


/* Example : */
data test;
	set test;
	Divres = Division(nb,dv);
run;
