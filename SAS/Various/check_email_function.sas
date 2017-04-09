/*------------------------------------*/
/* Creation date : 09/04/2017  (fr)   */
/* Last update :   09/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		      */
/* Tested on SAS 9.3                  */
/*------------------------------------*/

/*
https://sites.google.com/site/lecoindudeveloppeursas/tutoriels-sas/creer-une-fonction-avec-sas
*/

data liste_email;
   informat email $32.;
   input email;
   datalines;
clark.kent@daily-planet.com
B.wayne@batm.fr
greenl@supercom
;

/* Vérification des emails */

data validation_email;
   set liste_email;
   rfc=prxmatch("/^" !!
                       "[a-z0-9#\$%&'*+\/=\]+?^_`\{|\}~-]+" !!
                       "(?:\.[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+)*" !!
                       "@" !!
                       "(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+" !!
                       "[a-z0-9]" !!
                       "(?:[a-z0-9-]*[a-z0-9])?" !!
                       "/"
                       ,
                       email
                       );
run;
