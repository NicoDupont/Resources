/*------------------------------------
* Created :       11/05/2017  (fr)  
* Last update :   11/05/2017  (fr)   
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* Tested on SAS Studio 9.4 onDemand           
-------------------------------------*/


data temp;

	alphabetw='  a  ';
	/*default*/
	chardate=put(alphabetw,$10.);
	output;
	/*align left*/
	chardate=put(alphabetw,$10. -l);
	output ;
	/*align center*/
	chardate=put(alphabetw,$10. -c);
	output ;
	/*align right*/
	chardate=put(alphabetw,$10. -r);
	output ;
	
	/*align right*/
	chardate=right(alphabetw);
	output ;
	/*align left*/
	chardate=left(alphabetw);
	output ;
	 
run;


proc print;run;
