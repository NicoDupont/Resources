/*------------------------------------*/
/* Creation date : 09/04/2017  (fr)   */
/* Last update :   09/04/2017  (fr)   */
/* Author(s) : 						            */
/* Contributor(s) : 		              */
/* Tested on SAS Studio 9.4           */
/*------------------------------------*/

data test_email;
   informat email $32.;
   input email;
   datalines;
      test@test.fr
      Test@test.fr
      test@test..fr
      .test@test.fr
      .test@@test.fr
      test@test
      @test.fr
      1.test@test.fr
      n.test@test.fr
;
run;

/* Check if email is ok or not : */

proc fcmp outlib=work.cat_function.test ;
	function CheckMail(Email $);
		mail=Email;
		res = prxmatch("/^" !!
                       "[a-z0-9#\$%&'*+\/=\]+?^_`\{|\}~-]+" !!
                       "(?:\.[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+)*" !!
                       "@" !!
                       "(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+" !!
                       "[a-z0-9]" !!
                       "(?:[a-z0-9-]*[a-z0-9])?" !!
                       "/"
                       ,
                       lowcase(mail));
	return(res);
	endsub;
run;

/*options cmplib=work.cat_function;*/

data test_email;
   set test_email;
   Cmail=CheckMail(email);
run;
