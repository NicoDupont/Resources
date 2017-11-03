/*------------------------------------
* Created :       30/10/2017  (fr)  
* Last update :   03/11/2017  
* Author(s) : Nicolas Dupont   // https://blogs.sas.com/content/sasdummy/2013/06/12/correlations-matrix-heatmap-with-sas/      
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Update :
-------------------------------------*/

ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Correlation/img" image_dpi=200;


/* Put all numerical variables in a macro variable :*/
proc sql noprint;
	select name into :varlistnum separated by ' '
	from sashelp.vcolumn
	where upcase(libname) eq "SASHELP" 
		and upcase(memname) eq "CARS" 
		and type='num';
quit;

PROC CORR DATA=sashelp.cars PLOTS=MATRIX(NVAR=all);
    VAR MSRP Invoice;
RUN;

PROC CORR DATA=sashelp.cars NOPROB RANK;
    VAR &varlistnum.;
RUN;

PROC CORR data=sashelp.cars(keep=&varlistnum.) noprob;
	ods select PearsonCorr;
RUN;



 %include '/home/nicolasdupont0/resources_github/Graph/Correlation/macro/prepcorrdata.sas';

proc template;
	define statgraph corrHeatmap;
   dynamic _Title;
		begingraph;
         entrytitle _Title;
			rangeattrmap name='map';
			/* select a series of colors that represent a "diverging"  */
			/* range of values: stronger on the ends, weaker in middle */
			/* Get ideas from http://colorbrewer.org                   */
			range -1 - 1 / rangecolormodel=(cxedf8b1 cx7fcdbb cx2c7fb8);
			endrangeattrmap;
			rangeattrvar var=r attrvar=r attrmap='map';
			layout overlay / 
				xaxisopts=(display=(line ticks tickvalues)) 
				yaxisopts=(display=(line ticks tickvalues));
				heatmapparm x = x y = y colorresponse = r / xbinaxis=false ybinaxis=false
					colormodel=THREECOLORRAMP name = "heatmap" display=all;
				continuouslegend "heatmap" / 
					orient = vertical location = outside title="Pearson Correlation";
			endlayout;
		endgraph;
	end;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "heatmap1" imagefmt = png outputfmt = png antialiasmax = 10000;
	
%prepCorrData(in=sashelp.cars,out=cars_r);
proc sgrender data=cars_r template=corrHeatmap;
   dynamic _title="Corr matrix for SASHELP.cars";
run;

*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "heatmap2" imagefmt = png outputfmt = png antialiasmax = 10000;
	
%prepCorrData(in=sashelp.iris,out=iris_r);
proc sgrender data=iris_r template=corrHeatmap;
   dynamic _title= "Corr matrix for SASHELP.iris";
run;

*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "heatmap3" imagefmt = png outputfmt = png antialiasmax = 10000;
	
/* example of dropping categorical numerics */
%prepCorrData(
  in=sashelp.pricedata(drop=region date product line),
  out=pricedata_r);
proc sgrender data=pricedata_r template=corrHeatmap;
  dynamic _title="Corr matrix for SASHELP.pricedata";
run;


	
	
