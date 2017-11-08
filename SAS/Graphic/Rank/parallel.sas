/*------------------------------------ 
* Last update :   08/11/2017  
* Author(s) : https://github.com/srosanba/sas-parallel-coordinates-plot     
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Comment :  You need sas 9.4M2 (see the wiki on the github repository for more information) and the 4 macros in the macro folder
-------------------------------------*/

%include '/home/nicolasdupont0/resources_github/Graph/Rank/macro/AxisOrder.sas';
%include '/home/nicolasdupont0/resources_github/Graph/Rank/macro/LetPut.sas';
%include '/home/nicolasdupont0/resources_github/Graph/Rank/macro/VarExist.sas';
%include '/home/nicolasdupont0/resources_github/Graph/Rank/macro/parallelplot.sas';

ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Rank/img" image_dpi=200;

*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "parallel1" imagefmt = png outputfmt = png antialiasmax = 10000;


/*plotting based on data values*/	
%parallelplot
   (data=sashelp.iris
   ,var=sepallength sepalwidth petallength petalwidth
   ,group=species
   ,axistype=datavalues
   );
   

*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=600px height=400px 
	imagename = "parallel2" imagefmt = png outputfmt = png antialiasmax = 10000;

/*plotting based on percentiles*/	

%parallelplot
   (data=sashelp.iris
   ,var=sepallength sepalwidth petallength petalwidth
   ,group=species
   );