/*------------------------------------
* Created :       26/10/2017  (fr)  
* Last update :   04/11/2017  
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Update :
-------------------------------------*/

/*------------------------------------
* The density graph is also a good solution to represent the distribution of a numerical variable.
-------------------------------------*/

/*------------------------------------
* Density graph with the proc sgplot
-------------------------------------*/
ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Distribution/img" image_dpi=200;


*---------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width = 600px height = 400px 
	imagename = "density1" imagefmt = png outputfmt = png antialiasmax = 10000;

title '1# Distribution of the numerical variable horsepower in the cars dataset';
proc sgplot data=sashelp.cars;
  title "1# horsepower Density";
  density horsepower / type=normal scale=percent legendlabel="Normal";
  density horsepower  / type=kernel scale=percent legendlabel="kernel";
  xaxis min=0;
  yaxis min=0;
run;

*---------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width = 600px height = 400px 
	imagename = "density2" imagefmt = png outputfmt = png antialiasmax = 10000;

title '2# Distribution of two numerical variables MSRP and Invoice from the cars dataset';
proc sgplot data=sashelp.cars;
  title "2# MSRP and Invoice Density";
  density MSRP / scale=percent name="MSRP" legendlabel="MSRP";
  density Invoice / scale=percent name="Invoice" legendlabel="Invoice";
  xaxis label="Distribution" min=0;
  yaxis label="%" min=0;
  keylegend "MSRP" "Invoice" / across=1 position=Topleft location=Inside;
run;