/*------------------------------------
* Created :       11/07/2017  (fr)
* Last update :   11/07/2017  (fr)
* Author(s) : Nicolas Dupont
* Contributor(s) :
* Tested on SAS Studio 9.4 onDemand
-------------------------------------*/

/*
Link : http://support.sas.com/kb/24/301.html
How to extract the name and the path of the executing program :
*/

%put &_SASPROGRAMFILE;
/* for sas server on windows os %put %sysget(SAS_EXECFILENAME)  */
%put -----------;
%put -----------;

/* Without .sas extension*/
/* for sas server on windows os %qsubstr(%sysget(SAS_EXECFILENAME),1,%length(%sysget(SAS_EXECFILENAME))-4) */
%put %qsubstr(&_SASPROGRAMFILE,1,%length(&_SASPROGRAMFILE)-4);
%put -----------;
%put -----------;

/* Only the path : */
/* for sas server on windows os %put %qsubstr(%sysget(SAS_EXECFILEPATH),1,%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))); */
*%put %scan(&_SASPROGRAMFILE.,-1,'/');
%put %qsubstr(&_SASPROGRAMFILE,1,%length(&_SASPROGRAMFILE)-%length(%scan(&_SASPROGRAMFILE.,-1,'/'))-1);
%put -----------;
%put -----------;
