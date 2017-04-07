/*------------------------------------*/
/* Creation date : 04/04/2017  (fr)   */
/* Last update :   05/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3                  */
/*------------------------------------*/

/* IFN() return a num value and IFC() return a string value */
/* IFN and IFC can be used to in a PROC SQL */


data test;
input id age;
datalines;
1 10
2 20
3 30
4 40
5 50
1 10
2 20
3 30
4 40
5 50
;
run;

/* IFC() */
data test2;
set test;
test_age = IFC(age=10 or age=20,"ok","ko");
run;

/* IFN() */
data test3;
set test;
test_age = IFN(age>30,1,0);
run;

