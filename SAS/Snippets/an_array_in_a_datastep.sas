/*------------------------------------*/
/* Creation date : 05/04/2017  (fr)   */
/* Last update :   05/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3                  */
/*------------------------------------*/

/* How to iterate over an array in a SAS datastep */

/* A little more complicated : */
data test;
input var1 var2 var3 var4 var5 var6;
datalines;
1 10 11 23 15 10
2 20 5 12 23 65
3 30 15 23 89 87
4 40 14 15 17 74
5 50 13 16 65 23
;
run;


data test2;
set test;
	array tabvar {*} var1 - var5;
	res = 0;
	do i= 1 to dim(tabvar);
		res ++ tabvar(i);
	end;
	drop i;
run;


/*-------------------*/
/* Another example : */
data test;

array motif {5} $  _TEMPORARY_  ('ONE' 'TWO' 'THREE' 'FOUR' 'FIVE');

 do i = 1 to 5;
	mtf = motif[i];        
	output;
    drop i;
 end;

run;
