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
	reset = all attrpriority=color border = no width=800px height=800px 
	imagename = "matrix1" imagefmt = png outputfmt = png antialiasmax = 10000;


proc sgscatter data=sashelp.cars(where=(type in ('Sedan' 'Sports')));
  title 'Scatterplot Matrix for Vehicle Type';
  label mpg_city='City';
  label mpg_highway='Highway';
  matrix mpg_city mpg_highway horsepower weight / transparency=0.5 markerattrs=(symbol=CircleFilled); 
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=800px height=800px 
	imagename = "matrix2" imagefmt = png outputfmt = png antialiasmax = 10000;


proc sgscatter data=sashelp.iris;
  title "Scatterplot Matrix for Iris Data";
  matrix SepalLength SepalWidth PetalLength PetalWidth  / group=Species transparency=0.5 markerattrs=(symbol=CircleFilled); 
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=800px height=800px 
	imagename = "matrix3" imagefmt = png outputfmt = png antialiasmax = 10000;
	
proc sgscatter data=sashelp.iris;
  title "Scatterplot Matrix for Iris Data";
  compare x=(SepalLength SepalWidth)
          y=(PetalLength PetalWidth)
          / group=species markerattrs=(symbol=CircleFilled);
run;
