/*------------------------------------
* Created :       12/07/2017  (fr)
* Last update :   13/07/2017  (fr)
* Author(s) : Nicolas Dupont
* Contributor(s) :
* Tested on SAS Studio 9.4 onDemand
-------------------------------------*/

/*------------------------------------
 * It can be usefull to see what's the data looks like
 * In the data library you have titanic datasets from kaggle
 * I have imported csv files in sas datasets
 	- titatnic_train
 	- titanic_test
 * Those sas datasets are available here : https://github.com/NicoDupont/Resources/tree/master/SAS/Data
-------------------------------------*/

libname DATA "/home/nicolasdupont0/Data";
%let dataset=data.titanic_train;

/*------------------------------------
	* Tail macro
	* see rows at the end
-------------------------------------*/

%macro tail(data, obs=10, nuubs=no, wmin=no, nlabel=no, title="Last 10 rows");

	/*get the number of line in the dataset*/
	data _NULL_;
		if 0 then set &data nobs=n;
			call symputx('nrows',n);
		stop;
	run;
	%let lobs=&nrows;

	%if &nuubs=no  %then %let nuubs=;  %else %let nuubs=noobs;
	%if &wmin=no   %then %let wmin=;   %else %let wmin=width=min;
	%if &nlabel=no %then %let nlabel=; %else %let nlabel=LABEL;

	proc print data=&data (firstobs=%eval(&lobs-&obs+1) obs=%eval(&obs.+(&lobs-1))) &nuubs. &wmin. &nlabel.;
	Title &title;
	run;

	/*reset title*/
	title;

%mend tail;

%tail(&dataset, obs=10, nuubs=no, wmin=yes, nlabel=no);
%tail(&dataset,title="Last 10 rows in the submited dataset");
