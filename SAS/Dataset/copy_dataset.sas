/*------------------------------------*/
/* Creation date : 21/04/2017  (fr)   */
/* Last update :   21/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Unix 9.3             */
/*------------------------------------*/

%LET ORIGIN=SASHELP;
%LET TARGET=OTHERLIB;

proc datasets;
	COPY IN=&ORIGIN OUT=&TARGET;
	SELECT CARS;
quit;
