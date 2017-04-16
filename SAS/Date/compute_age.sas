/*------------------------------------*/
/* Creation date : 16/04/2017  (fr)   */
/* Last update :   16/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		              */
/* in progress ..         */
/*------------------------------------*/

/*
Compute the age.
- 1 -  ----
*/


/* Example data : */
data test;
	input birthday;
	informat birthday date9.;
	format birthday date9.;
	datalines;
		31DEC2016
		05JAN2017
		05APR2017
		09JUL2017
		10NOV2017
		31DEC2017
		;
run;
