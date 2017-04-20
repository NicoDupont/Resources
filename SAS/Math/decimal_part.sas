/*------------------------------------*/
/* Creation date : 17/04/2017  (fr)   */
/* Last update :   18/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		      */
/* Tested on SAS 9.3                  */
/*------------------------------------*/


/* Example data : */
data test;
	input nb;
	informat nb 6.2;
	format nb 6.2;
	datalines;
	5.56
   10.20
   12.00
  156.00
   45.69
  124.10
;
run;


/*---------------------*/
/*  1 - DecimalPart()  */
/*---------------------*/

proc fcmp outlib=work.cat_function.test ;
	function DecimalPart(decnum);
	    res=mod(decnum,1);
	    /*res=decnum-int(decnum);*/
	    /*res = int(100*mod(decnum,1))/100;*/
	    /*res = int(100*mod(decnum,1));*/
	    /*res = decnum - (1 * int(decnum / 1))*/
	    return(res);
	endsub;
run;

options cmplib=work.cat_function;


/* Example : */
data test;
	set test;
	format decnb 4.2;
	decnb = DecimalPart(nb);
run;
