/*------------------------------------
* Created :       10/05/2017  (fr)  
* Last update :   14/11/2017  (fr)   
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* Tested on SAS Studio 9.4 onDemand           
-------------------------------------*/

/*
 * Simple way to put the calculation time on the log
*/

%let datetime_start = %sysfunc(TIME()) ;
%put START TIME: %sysfunc(datetime(),datetime14.);

/*Things to do ...*/
data test;
	do i=1 to 400000000;
		a = i;
		b = i**2;
		c = b ** 0.5;
		d = a * b * c;
		e = d ** 3;
		output;
		drop i;
	end;
run;


%put END TIME: %sysfunc(datetime(),datetime14.);
%put PROCESSING TIME:  %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&datetime_start.),mmss.)) (mm:ss) ;


/*------------------------------------
You can see an exemple on how to retrive 
the computation time of your programme.
You can save the result in a table if needed.
-------------------------------------*/

%macro PrgCalcTime(status=start,table=_NULL_);
	%local prgname duration endtime enddate;
	%global starttime;
	%if %upcase(&status) = END 
		%then %do;
    		%if %symexist(starttime) 
    			%then %do; 
    				%let duration = %sysfunc(putn(%sysevalf(%sysfunc(datetime())-&starttime),12.3));
    				%let endtime = %sysfunc(time(),time8.);		
    				%let enddate = %sysfunc(today(),date9.);
    				%put Computation time : &duration. seconds at &endtime. on &enddate.;
  					%if &table ne _NULL_
  						%then %do;
  							%if %sysfunc(EXIST(%sysfunc(compress(&TABLE)))) ne 1
  								%then %do;
  									%let prgname = &_SASPROGRAMFILE;
  									data &table;
  										length id 4 prog $250 duration 8 endtime 8 enddate 8;
  										format enddate date9.;
  										format duration 12.3;
  										format endtime time8.; 
										id=1;
									   	prog="&prgname.";
									   	duration=&duration;
									   	endtime="&endtime."t;
									   	enddate="&enddate."d;
									   	output;
									run;
  								%end;
  								%else %do;
  									%let prgname = &_SASPROGRAMFILE;
				  					data &table;
										set &table end=eof;
										output;
										if eof
											then do;
											   id=_N_+1;
											   prog="&prgname.";
											   duration=&duration;
									   		   endtime="&endtime."t;
											   enddate="&enddate."d;
											   output;
										  	end;
									run;
								%end;
						%end;
		  		%end;
  		%end;
  		%else %do; 
  			%let starttime = %sysfunc(datetime());
  			%put Program Start;
  		%end;
  	/* delete macro-variable : */
  	%if %upcase(&status) = END 
  		%then %symdel starttime;
	
%mend;

/* Examples : */

%PrgCalcTime(status=start);

/*Things to do ...*/
data test;
	do i=1 to 400000000;
		a = i;
		b = i**2;
		c = b ** 0.5;
		d = a * b * c;
		e = d ** 3;
		output;
		drop i;
	end;
run;

%PrgCalcTime(status=end);



%PrgCalcTime(status=start);

/*Things to do ...*/
data test;
	do i=1 to 400000000;
		a = i;
		b = i**2;
		c = b ** 0.5;
		d = a * b * c;
		e = d ** 3;
		output;
		drop i;
	end;
run;

%PrgCalcTime(status=end,table=duration);
