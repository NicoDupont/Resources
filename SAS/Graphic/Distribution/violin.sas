/*------------------------------------
* Created :       26/10/2017  (fr)  
* Last update :   27/10/2017  
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* I used the macro : violinPlot.sas  from : https://github.com/RhoInc/sas-violinPlot
* I made littles modifications on the macro and remove the pdf output.
-------------------------------------*/

/*------------------------------------------------------------------------------------------------\
  Include %violinPlot directly from GitHub.
\------------------------------------------------------------------------------------------------*/

	/*
    %let repo = https://github.com/RhoInc/sas-violinPlot;
    %let file = src/violinPlot.sas;
    %let fileURL = %sysfunc(tranwrd(%nrbquote(&repo), github.com, raw.githubusercontent.com))/master/&file;

    filename fileURL url "&fileURL";
        %include fileURL;
    filename fileURL;
    */


 %include '/home/nicolasdupont0/resources_github/Graph/Distribution/macro/violinPlot.sas';

/*------------------------------------------------------------------------------------------------\
  Output a violin plot of SASHELP.CARS.MPG_CITY.
\------------------------------------------------------------------------------------------------*/

%violinPlot(data = sashelp.cars,outcomeVar = mpg_city,outPath = /home/nicolasdupont0/resources_github/Graph/Distribution/img,outName=violinPlot1);


/*------------------------------------------------------------------------------------------------\
  Output a violin plot of SASHELP.CARS.MPG_CITY group by Make
\------------------------------------------------------------------------------------------------*/

data cars;
set sashelp.cars (where=(Make in ('Audi','BMW','Chevrolet')));
run;
%violinPlot(data = cars,outcomeVar = mpg_city,groupVar= Make,outPath = /home/nicolasdupont0/resources_github/Graph/Distribution/img,outName=violinPlot2);
