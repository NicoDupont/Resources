/*------------------------------------
* Created :       05/07/2017  (fr)
* Last update :   05/07/2017  (fr)
* Author(s) : Nicolas Dupont
* Contributor(s) :
* Tested on SAS Studio 9.4 
-------------------------------------*/

/*------------------------------------
Sometimes it can be useful to find the physical path of a "libname"
-------------------------------------*/

%let pathwork = %sysfunc(pathname(work)); 
%put Path of the work libref:;
%put &pathwork;
%put -----------;
%put -----------;


libname datagit '/folders/myfolders/resource_github/Data';
%let pathdatag = %sysfunc(pathname(datagit)); 
%put Path of the datagit libref:;
%put &pathdatag;
%put -----------;