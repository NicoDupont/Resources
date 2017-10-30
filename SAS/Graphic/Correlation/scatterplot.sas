/*------------------------------------
* Created :       30/10/2017  (fr)  
* Last update :   30/10/2017  
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Update :
-------------------------------------*/

ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Correlation/img" image_dpi=200;
ods graphics / reset = all attrpriority=color border = no width = 6in height = 3.5in imagename = "scatterplot1" imagefmt = png outputfmt = png antialiasmax = 10000;

proc sgplot data=sashelp.iris;
	title 'Fisher (1936) Iris Data';
	scatter x=petallength y=petalwidth;
run;


ods graphics / reset = all attrpriority=color border = no width = 6in height = 3.5in imagename = "scatterplot2" imagefmt = png outputfmt = png antialiasmax = 10000;
proc sgplot data=sashelp.iris;
	title 'Fisher (1936) Iris Data';
	scatter x=petallength y=petalwidth / group=species DATASKIN=PRESSED;
run;

