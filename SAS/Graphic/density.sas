/*------------------------------------
* Created :       26/10/2017  (fr)  
* Last update :   26/10/2017  
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

title '1# Distribution of the numerical variable horsepower in the cars dataset';
proc sgplot data=sashelp.cars;
  title "1# horsepower Density";
  density horsepower / type=normal scale=percent legendlabel="Normal";
  density horsepower  / type=kernel scale=percent legendlabel="kernel";
  xaxis min=0;
  yaxis min=0;
run;


title '2# Distribution of two numerical variables MSRP and Invoice from the cars dataset';
proc sgplot data=sashelp.cars;
  title "2# MSRP and Invoice Density";
  density MSRP / scale=percent name="MSRP" legendlabel="MSRP";
  density Invoice / scale=percent name="Invoice" legendlabel="Invoice";
  xaxis label="Distribution" min=0;
  yaxis label="%" min=0;
  keylegend "MSRP" "Invoice" / across=1 position=Topleft location=Inside;
run;
