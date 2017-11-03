/*------------------------------------
* Created :       03/11/2017  (fr)  
* Last update :   03/11/2017  
* Author(s) : Nicolas Dupont
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Update :
-------------------------------------*/


ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Correlation/img" image_dpi=200;

*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "bubble1" imagefmt = png outputfmt = png antialiasmax = 10000;

title 'Age by Height and Weight';
proc sgplot data=sashelp.class(where=(sex='F')) noautolegend;
  bubble x=height y=weight size=age / group=name datalabel=name 
    transparency=0.4 datalabelattrs=(size=9 weight=bold);
  inset "Bubble size represents Age" / position=bottomright textattrs=(size=11);
  yaxis grid;
  xaxis grid;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "bubble2" imagefmt = png outputfmt = png antialiasmax = 10000;


proc sgplot data=sashelp.cars;
  title 'Comparing Horsepower and MSRP for European Made Cars';
  where origin='Europe'; 
  bubble x=make y=horsepower size=msrp / group=make  ;
  xaxis display=none;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "bubble3" imagefmt = png outputfmt = png antialiasmax = 10000;
	

proc sgplot data=sashelp.class;
  title 'Student Age by Height and Weight';
  bubble x=height y=weight size=age / group=sex fillattrs=(transparency=0.4)
    datalabel=age datalabelpos=center /*dataskin=sheen*/;
  inset 'Bubble size is proportional to age' / position=bottomright;
  xaxis grid;  yaxis grid;
  keylegend / location=inside position=topleft;
 run;