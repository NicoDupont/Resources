/*------------------------------------
* Created :       03/11/2017
* Last update :   03/11/2017  
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Update :
-------------------------------------*/

ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Correlation/img" image_dpi=200;
ods graphics / reset = all attrpriority=color border = no width =500px height =300px imagename = "connected_scatterplot1" imagefmt = png outputfmt = png antialiasmax = 10000;

/*not good exemple..*/

proc sort data=sashelp.iris out=iris;
	by petallength petalwidth;
run;

proc sgplot data=iris;
	title 'Fisher (1936) Iris Data';
	series x=petallength y=petalwidth;
run;


ods graphics / reset = all attrpriority=color border = no width =500px height =300px imagename = "connected_scatterplot2" imagefmt = png outputfmt = png antialiasmax = 10000;
proc sgplot data=iris;
	title 'Fisher (1936) Iris Data';
	series x=petallength y=petalwidth / group=species DATASKIN=PRESSED;
run;

