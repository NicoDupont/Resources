/*------------------------------------
* Last update :   06/11/2017  
* Author(s) : https://blogs.sas.com/content/iml/2014/08/20/heat-map-in-sasiml.html      
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Update :
-------------------------------------*/

ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Correlation/img" image_dpi=200;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "heatmap2_1" imagefmt = jpeg outputfmt = jpeg antialiasmax = 10000;
	
proc sgplot  data=sashelp.heart;
  heatmap x=weight y=cholesterol;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "heatmap2_2" imagefmt = jpeg outputfmt = jpeg antialiasmax = 10000;
	
proc sgpanel data=sashelp.heart;
  panelby sex;
  heatmap x=weight y=cholesterol;
run;

/*
*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "heatmap2_3" imagefmt = jpeg outputfmt = jpeg antialiasmax = 10000;
	
proc sgplot  data=sashelp.heart;
  heatmapparm x=weight y=cholesterol 
     colorresponse=height;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "heatmap2_4" imagefmt = jpeg outputfmt = jpeg antialiasmax = 10000;
	
proc sgpanel data=sashelp.heart;
  panelby sex;
  heatmapparm x=weight y=cholesterol 
     colorresponse=height;
run;
*/