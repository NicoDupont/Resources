/*------------------------------------
* Created :       21/07/2017  (fr)  
* Last update :   21/07/2017  (fr)   
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* Tested on SAS Studio 9.4 onDemand        
-------------------------------------*/


%macro ecdf(data,var);

	title "Descriptive statistics on &var.";
	proc univariate data=&data;
	   var &var;
	run;
	
	title "Distribution of &var.";
	proc univariate data=&data noprint;
   		histogram &var / odstitle = title;
   		inset n = 'Number of observations' / position=ne;
	run;
	
	title "Cumulative Distribution of &var.";
	proc univariate data=&data noprint;
   		cdf &var / normal;
   		/*inset normal(mu sigma);*/
	run;
	
	title;

%mend ecdf;

%ecdf(sashelp.cars,Horsepower);
