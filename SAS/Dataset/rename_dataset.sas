/*------------------------------------*/
/* Creation date : 21/04/2017  (fr)   */
/* Last update :   21/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Unix 9.3             */
/*------------------------------------*/

/* It's more efficient than a data step because we dont't to read line by line */

proc datasets library=SASHELP;
    change CARS = CARSRENAME;
run;
