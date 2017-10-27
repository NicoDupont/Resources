/*------------------------------------
* Created :       28/10/2017  (fr)  
* Last update :   28/10/2017  
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Update :
-------------------------------------*/

ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Distribution/img" image_dpi=200;
 
ods graphics / reset = all attrpriority=color border = no width = 8in height = 5.5in imagename = "boxplot1" imagefmt = png outputfmt = png antialiasmax = 10000;
proc sgplot data=sashelp.heart;
  title "Cholesterol Distribution by Weight Class";
  hbox cholesterol / category=weight_status lineattrs=(pattern=solid) whiskerattrs=(pattern=solid);
run;

ods graphics / reset = all attrpriority=color border = no width = 8in height = 5.5in imagename = "boxplot2" imagefmt = png outputfmt = png antialiasmax = 10000;
proc sgplot data=sashelp.heart;
  title "Cholesterol Distribution by Weight Class";
  vbox cholesterol / category=weight_status lineattrs=(pattern=solid) whiskerattrs=(pattern=solid);
run;



ods graphics / reset = all attrpriority=color border = no width = 8in height = 5.5in imagename = "boxplot3" imagefmt = png outputfmt = png antialiasmax = 10000;
proc sgplot data=sashelp.cars(where=(type in ('Sedan' 'Sports'))) ;
  title 'Mileage by Type and Origin';
  vbox mpg_city / category=origin group=type groupdisplay=cluster lineattrs=(pattern=solid) whiskerattrs=(pattern=solid); 
  xaxis display=(nolabel);
  yaxis grid;
  keylegend / location=inside position=topright across=1;
run;

ods graphics / reset = all attrpriority=color border = no width = 8in height = 5.5in imagename = "boxplot4" imagefmt = png outputfmt = png antialiasmax = 10000;
proc sgplot data=sashelp.cars(where=(type in ('Sedan' 'Sports'))) ;
  title 'Mileage by Type and Origin';
  hbox mpg_city / category=origin group=type groupdisplay=cluster lineattrs=(pattern=solid) whiskerattrs=(pattern=solid); 
  xaxis display=(nolabel);
  yaxis grid;
  keylegend / location=inside position=topright across=1;
run;