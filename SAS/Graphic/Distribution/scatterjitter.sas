/*------------------------------------
* Created :       27/10/2017  (fr)  
* Last update :   27/10/2017  
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Not work actualy because I'm not in 9.4M5 ..
-------------------------------------*/

ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Distribution/img" image_dpi=200;
ods graphics / reset = all attrpriority=color border = no width = 8in height = 5.5in imagename = "scatterjitter" imagefmt = png outputfmt = png antialiasmax = 10000; 

proc sgplot data=sashelp.cars(where=(Make in ('Audi','BMW','Chevrolet'))) noautolegend noborder;
  title 'Distribution of mpg_city for Audi, Bmw and Chevrolet';
  scatter x=Make y=mpg_city / jitter=uniform jitterwidth=1 markerattrs=(symbol=circlefilled size=5 color=blue);
  xaxis display=(nolabel noticks);
  yaxis display=(nolabel noline noticks) grid;
run;