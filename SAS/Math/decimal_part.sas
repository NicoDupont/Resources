/*------------------------------------*/
/* Creation date : 17/04/2017  (fr)   */
/* Last update :   17/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		              */
/* need to be tested                  */
/*------------------------------------*/


/* Example data : */
data test;
	input nb;
	informat nb ;
	datalines;
		16APR1986
		15APR1986
		17APR1986
		29FEB2016
		29FEB2016
		29FEB2016
		;
run;


/*---------------------*/
/*  1 - DecimalPart()  */
/*---------------------*/

proc fcmp outlib=work.cat_function.test ;
	function DecimalPart(decnum);
    /*obtenir la partie non entière*/
    /*Y=mod(decnum,1);
    Z=X-int(decnum);*/
    res = int(10*mod(decnum,1))/10;
	 return(res);
	endsub;
run;

options cmplib=work.cat_function;


/* Example : */
data test;
	set test;
	decnb = DecimalPart(nb);
run;
