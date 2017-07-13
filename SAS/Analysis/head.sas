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
	* Head macro
	* see rows at the beginning
-------------------------------------*/

%macro head(data, fobs=1, obs=10, nuubs=no, wmin=no, nlabel=no, title="First 10 rows");

	%if &nuubs=no  %then %let nuubs=;  %else %let nuubs=noobs;
	%if &wmin=no   %then %let wmin=;   %else %let wmin=width=min;
	%if &nlabel=no %then %let nlabel=; %else %let nlabel=LABEL;

	proc print data=&data (firstobs=&fobs. obs=%eval(&obs.+(&fobs-1))) &nuubs. &wmin. &nlabel.;
	Title &title;
	run;

	/*reset title*/
	title;

%mend head;

%head(&dataset, fobs=1, obs=10, nuubs=yes, wmin=no, nlabel=no);
%head(&dataset,title="First 10 rows in the submited dataset");
