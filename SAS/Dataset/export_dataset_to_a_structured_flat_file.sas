/*------------------------------------*/
/* Creation date : 11/04/2017  (fr)   */
/* Last update :   11/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3	              */
/*------------------------------------*/

/* An example on how to export a dataset to a structured flat file (not delimited) */

data work.test;
	length id 3. name $10. code $2. lib $13. date 8.; 
	format id 3. name $10. code $2. lib $13. date ddmmyy10.;
	informat date DATE9.;
	input id name $ code $ lib $ date;
	datalines;
1      NDupont 91        Essone 02JAN2017
2      GRobert 92 Haut-de-seine 05JAN2017
20    JEdwards 84      Vaucluse 06JAN2017
201 DonaldDuck 62 Pas-de-calais 07JAN2017
;
run;


/* Export : */
data _NULL_;
set work.test;
file "Path/test.txt" /*dlm="something-here"*/;
if _N_ >= 1 then do;
	put @1 id 3. 
		@5 name $10. 
		@16 code $2.
		@19 lib $13.
		@33 date ddmmyy10.;
end;
run;
