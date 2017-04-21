/*------------------------------------*/
/* Creation date : 21/04/2017  (fr)   */
/* Last update :   21/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Unix 9.3             */
/*------------------------------------*/

/* 
If you want to delete quickly all sas files in a library, you can use the following code : 
Attention : files are immediatly deleted
You can specify a memtype to specify what type of sas files you want to delete.
*/

/*
MEMTYPE :
- Dataset => MEMTYPE=DATA,
- View    => MEMTYPE=VIEW
- Catalog => MEMTYPE=CATALOG (format)
*/


proc datasets lib=work kill /*memtype=data*/;
run;
quit;


/*----------------------------------*/
/* Delete all sas files in the WORK library : */

proc datasets kill;
quit;

proc datasets lib=work memtype=all kill;
quit;
