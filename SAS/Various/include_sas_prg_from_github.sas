/*------------------------------------
* Created :       09/11/2017  (fr)  
* Last update :   09/11/2017  
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
-------------------------------------*/

/*-----------------------------------------------------------------------------------------------
  How to import a sas file directly from a repo on github :
------------------------------------------------------------------------------------------------*/

%let repo = https://github.com/NicoDupont/Resources;
%let sasfile = SAS/Analysis/head.sas;
%let sasrawfileURL = %sysfunc(tranwrd(%nrbquote(&repo), github.com, raw.githubusercontent.com))/master/&sasfile;

/*%put &sasrawfileURL;*/

filename fileURL url "&sasrawfileURL";
	%include fileURL;
filename fileURL; 

/*test:*/

%head(sashelp.cars, fobs=1, obs=10, nuubs=yes, wmin=no, nlabel=no);
