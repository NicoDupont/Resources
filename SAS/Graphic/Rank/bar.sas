/*------------------------------------
* Created :       07/11/2017  (fr)  
* Last update :   07/11/2017  
* Author(s) : Nicolas Dupont      
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Update :
-------------------------------------*/

ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Rank/img" image_dpi=200;

*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "bar1" imagefmt = png outputfmt = png antialiasmax = 10000;
	
proc sgplot data=sashelp.cars noborder;
  title 'Number of Observations by Type';
  vbar type / datalabel;
  yaxis label="Count" grid;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "bar2" imagefmt = png outputfmt = png antialiasmax = 10000;
	
proc sgplot data=sashelp.cars;
  title 'Number of Observations by Type';
  hbar type;
  xaxis label="Count" grid;
run;

*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "bar3" imagefmt = png outputfmt = png antialiasmax = 10000;

proc sgplot data=sashelp.cars;
  title 'Mean of mpg_city by Type';
  vbar type / response=mpg_city stat=mean barwidth=0.6 fillattrs=graphdata3 limits=both baselineattrs=(thickness=0);
  xaxis display=(nolabel);
  yaxis label="Mean" grid;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "bar4" imagefmt = png outputfmt = png antialiasmax = 10000;
	

proc sgplot data=sashelp.cars(where=(make in ('Audi','BMW','Chevrolet','Buick','Cadillac'))) noborder;
  title 'Count by Type and make';
  vbar make / group=type seglabel datalabel 
          baselineattrs=(thickness=0) 
          outlineattrs=(color=cx3f3f3f);
  xaxis display=(nolabel noline noticks);
  yaxis display=(noline noticks) grid;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "bar5" imagefmt = png outputfmt = png antialiasmax = 10000;
	

proc sgplot data=sashelp.cars(where=(make in ('Audi','BMW','Chevrolet','Buick','Cadillac'))) noborder;
  title 'Count by Type and make';
  vbar make / group=type seglabel datalabel baselineattrs=(thickness=0) groupdisplay=cluster outlineattrs=(color=cx3f3f3f);
  xaxis display=(nolabel noline noticks);
  yaxis display=(noline noticks) grid;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "bar6" imagefmt = png outputfmt = png antialiasmax = 10000;

title 'Count by Type and make splited by the number of Cylinders';
proc sgpanel data=sashelp.cars(where=(make in ('Audi','BMW','Chevrolet','Buick','Cadillac')));
  panelby Cylinders / onepanel rows=1 noborder layout=columnlattice noheaderborder novarname colheaderpos=bottom;
  vbar make / group=type barwidth=0.8 baselineattrs=(thickness=0) filltype=gradient seglabel datalabel;
  colaxis display=(nolabel noline noticks);
  rowaxis display=(noline nolabel noticks) grid;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "bar7" imagefmt = png outputfmt = png antialiasmax = 10000;
	
proc sgplot data=sashelp.cars noborder;
  title 'Mean mpg_city vs mpg_highway by Type';
  vbar type / response=mpg_highway stat=mean datalabel;
  vbar type / response=mpg_city stat=mean datalabel;
  yaxis display=(nolabel) grid;
run;
