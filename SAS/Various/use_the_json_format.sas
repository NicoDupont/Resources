/*------------------------------------*/
/* Creation date : 06/04/2017  (fr)   */
/* Last update :   06/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Studio 9.4           */
/*------------------------------------*/

/*
How to use and create a JSON file :
	1 - Import data in a SAS dataset from a .JSON File
	2 - Export data from a SAS dataset to a .JSON File

Doc SAS 9.4 : http://support.sas.com/documentation/cdl/en/proc/70377/HTML/default/viewer.htm#p0ie4bw6967jg6n1iu629d40f0by.htm

*/

/*----------------------------------*/
/*----------------------------------*/
/* 1 - Import data from a JSON File */

/* 
Here for the example we get data from the ISS API. [link](http://open-notify.org/Open-Notify-API/ISS-Pass-Times/)
The api returns the number of times, when and how long the spacial station will be above the coordinates passed in parameters.
We just need to put the latitude and the longitude from any location on earth.
For my case, I use Lille in France : 
	- LAT = 50.6329700°
	- LONG = 3.0585800°
*/

filename issdata temp;

/* Get data from the ISS API : */

proc http
 url= 'http://api.open-notify.org/iss-pass.json?lat=50.6329700&lon=3.0585800'
 method="GET"
 out=issdata;
run;


/* Simple test with the ISS position */
/*
proc http
 url= "http://api.open-notify.org/iss-now.json"
 method="GET"
 out=topics;
run;
*/

libname posts JSON fileref=issdata;
proc datasets lib=posts; quit;

/* Here I create a table with ROOT,RESPONSE and REQUEST on the library posts */

proc sql;
	create table ISS_POSITION as
	select 
		b.message as success,
		c.altitude,
		c.longitude,
		c.latitude,
		c.passes as NumberOfPassages,
		c.datetime,
		a.*
	from POSTS.RESPONSE as a
	left outer join POSTS.ROOT as b
	on a.ordinal_root=b.ordinal_root
	left outer join POSTS.REQUEST as c
	on a.ordinal_root=c.ordinal_root
	;
Quit;

/* Final Result :*/
data ISS_POSITION;
set ISS_POSITION;
format ResponseDate PassageDate ddmmyy10.;
ResponseDate = datepart(dhms('01jan1970'd, 0, 0, datetime));
PassageDate = datepart(dhms('01jan1970'd, 0, 0, risetime));
run;

	
/*--------------------------------*/
/*--------------------------------*/
/* 2 - Export data to a JSON File */

LIBNAME JSONTEST "/folders/myfolders/resource_github/Dataset/Data";

/* Example with SASHELP.CARS => available in the Dataset folder */
data CARS;
set JSONTEST.CARS (keep=Make Model Type Origin Horsepower EngineSize);
run;

/* Export to .json */
proc json out="/folders/myfolders/worktemp/cars.json";
   export CARS / /*nokeys*/ nosastags;
run;









