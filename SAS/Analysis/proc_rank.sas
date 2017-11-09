/*------------------------------------
* Created :       11/07/2017  (fr)
* Last update :   11/07/2017  (fr)
* Author(s) : Nicolas Dupont
* Contributor(s) :
* Tested on SAS Studio 9.4 onDemand
-------------------------------------*/

/*------------------------------------
The proc rank can be very usefull to select the first n better observations 
or the last n less good observations depending on the sort you proceed.
-------------------------------------*/

proc sort data=sashelp.class
	out=class;
	by sex;
run;
 
proc rank data=class
          out=rank1(where=(rankwt le 5))
          descending;
   by sex;
   ranks rankwt;
   var weight;
run;

proc rank data=class
          out=rank2(where=(rankwt le 5));
   by sex;
   ranks rankwt;
   var weight;
run;

%macro rankbyvar(dataset,output,by,var,n=5,order=D);
	
	%if &order=D %then %let order=descending; %else %let order=;

	proc sort data=&dataset out=dataset; by &by; run;
	 
	proc rank data=dataset
	          out=&output(where=(rank le &n))
	          &order.;
	   by &by;
	   ranks rank;
	   var &var;
	run;
	
	proc sort data=&output; by &by. rank; run;
	
	proc delete data=dataset; run;

%mend rankbyvar;

%rankbyvar(sashelp.class,work.rank3,sex,weight,n=7);
%rankbyvar(sashelp.class,work.rank4,sex,weight,order=C);

