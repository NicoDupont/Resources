/*------------------------------------
* Created :       11/05/2017  (fr)  
* Last update :   11/05/2017  (fr)   
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* Tested on SAS Studio 9.4 onDemand           
-------------------------------------*/


data temp;

	alphabetw='  a  ';
	chardate=put(alphabetw,$10.);
	output;
	chardate=put(alphabetw,$10. -l);
	output ;
	chardate=put(alphabetw,$10. -c);
	output ;
	chardate=put(alphabetw,$10. -r);
	output ;
	
	chardate=right(alphabetw);
	output ;
	chardate=left(alphabetw);
	output ;
	 
run;


proc print;run;