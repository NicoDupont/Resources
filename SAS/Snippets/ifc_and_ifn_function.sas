/*------------------------------------*/
/* Creation date : 04/04/2017  (fr)   */
/* Last update :   04/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		      */
/* Not Tested                         */
/*------------------------------------*/

/*IFN() return a num value and IFC() return a string value */
/* IFN and IFC can be used to in a PROC SQL*/


data test;
input id age grp ;
datalines;
1 10 1
2 20 1
3 30 1
4 40 1
5 50 1
1 10 2
2 20 2
3 30 2
4 40 2
5 50 2
;
run;


data test2;
set test;
test_age = ifn(age=10 or age=20,"ok","ko");
run;


