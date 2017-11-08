/*------------------------------------
* Created :       08/11/2017  (fr)  
* Last update :   08/11/2017  
* Author(s) : Nicolas Dupont      
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Update :
-------------------------------------*/

ods listing;
*---------------------------------------------------;
filename rankimg '/home/nicolasdupont0/resources_github/Graph/Rank/img/radar1.png';
goptions reset=all border device=png gsfname=rankimg gsfmode=replace;
		 

title h=12pt "Capacitor Failures";
proc gradar data=sashelp.failure;
    chart cause / freq=count;
run;
quit;

filename rankimg clear;

*---------------------------------------------------;
filename rankimg '/home/nicolasdupont0/resources_github/Graph/Rank/img/radar2.png';
goptions reset=all border device=png gsfname=rankimg gsfmode=replace;

proc gradar data=sashelp.failure;
    chart cause / freq=count
    overlayvar=process
    cstars=(red, blue)
    wstars=2 2
    lstars=1 1
    starcircles=(0.5 1.0)
    cstarcircles=ltgray;
run;
quit;

filename rankimg clear;

*---------------------------------------------------;
filename rankimg '/home/nicolasdupont0/resources_github/Graph/Rank/img/radar3.png';
goptions reset=all border device=png gsfname=rankimg gsfmode=replace;

title h=12pt "Capacitor Failures by Cleaning Process";
proc gradar data=sashelp.failure;
    chart cause / acrossvar=process
    freq=count
    starlegend=clock
    starlegendlab="Failure Causes";
run;
quit;

filename rankimg clear;
ods listing close;