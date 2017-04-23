/*------------------------------------*/
/* Creation date : 23/04/2017  (fr)   */
/* Last update :   23/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		              */
/* Tested on SAS Studio 9.4           */
/*------------------------------------*/


/* Example data : */
data test;
	input x1 x2 x3 x4;
	datalines;
1 2 2 5
2 2 4 9
2 3 4 9
3 2 4 7
;
run;


DATA test;
  SET test (RENAME = (x1 - x4 = y1 - y4)) ;
RUN;


proc print data=test;
run;
