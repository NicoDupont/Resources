/*------------------------------------
* Created :       26/10/2017  (fr)  
* Last update :   27/10/2017  
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* I used the macro : beeswarm.sas  from : https://github.com/RhoInc/sas-beeswarm
* => no modification on the macro
-------------------------------------*/

ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Distribution/img" image_dpi=200;
%include '/home/nicolasdupont0/resources_github/Graph/Distribution/macro/beeswarm.sas';


/* An example with with the cars dataset*/

data cars (keep= horsepower group);
set sashelp.cars (where=(Make in ('Audi','BMW','Chevrolet')));
if Make = 'Audi' then group=1;
else if Make = 'BMW' then group=2; 
else group=3;
run;

%beeswarm(data=cars,grpvar=group,respvar=horsepower);

ods graphics / reset = all border = no width = 8in height = 5.5in imagename = "beeswarm1" imagefmt = png outputfmt = png antialiasmax = 10000; 
proc sgplot data=beeswarm;
   scatter x=group_bee y=horsepower / markerattrs=(symbol=circlefilled);
   xaxis min=0 max=4 integer values=(0 1 2 3 4) valuesdisplay=('' 'Audi' 'BMW' 'Chevrolet' '');
run;


/* Another with the iris dataset*/

data iris (keep= SepalLength group);
set sashelp.iris ;
if Species = 'Virginica' then group=1;
else if Species = 'Versicolor' then group=2; 
else group=3;/*Setosa*/
run;

%beeswarm(data=iris,grpvar=group,respvar=SepalLength);

ods graphics / reset = all border = no width = 8in height = 5.5in imagename = "beeswarm2" imagefmt = png outputfmt = png antialiasmax = 10000; 
proc sgplot data=beeswarm;
   scatter x=group_bee y=SepalLength / markerattrs=(symbol=circlefilled);
   xaxis min=0 max=4 integer values=(0 1 2 3 4) valuesdisplay=('' 'Virginica' 'Versicolor' 'Setosa' '');
run;
