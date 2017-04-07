/*------------------------------------*/
/* Creation date : 06/04/2017  (fr)   */
/* Last update :   07/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		        */
/* Tested  on SAS 9.3                 */
/*------------------------------------*/


/* The code above list all the file in a directory and put results in a SAS dataset :*/

%LET PATH=;

filename REP "&PATH.";

data TABLE(keep = files);
     length fichier $50;
     retain did ;
     did = dopen("REP");
     if did > 0 then do;
          do i = 1 to dnum(did) ;
                files = dread(did,i);
                output;
          end;
          did = dclose(did);
     end;
run;
