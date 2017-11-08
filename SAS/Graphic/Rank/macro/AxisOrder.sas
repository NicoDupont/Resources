/*----------------------------------------------------------------------------------*

   *******************************************************
   ***  Copyright Rho, Inc. 2015, all rights reserved  ***
   *******************************************************

   MACRO:      AxisOrder.sas

   PURPOSE:    Generate components of the ORDER option in an AXIS statement for linear-scale axes.

   ARGUMENTS:  Data     => REQUIRED.   Input dataset.
               Var      => REQUIRED.   Space-separated list of variables on which to base axis range.
               Val      => OPTIONAL.   Space-separated list of additional values to include within axis range.
               By       => OPTIONAL.   By value override.
               Prefix   => OPTIONAL.   Prefix to add to output macro variable names.
               MajTarg  => OPTIONAL.   Desired number of major tick marks. 
                                       Default value is 6.
                                       This parameter has no effect if a value of By is specified.
               MajDev   => OPTIONAL.   Acceptable deviation from MajTarg. 
                                       Once the algorithm gets within MajDev of MajTarg, white space reduction
                                          drives the axis selection process.
                                       Default value is 1.
               Threshold=> OPTIONAL.   Thresholdmin/max value to use in deriving _&Prefix.AxisListUnb.
                                       Set to 0.7 to most closely approximate SGPLOT behavior.
                                       Default values is 0.
               RoundBys => OPTIONAL.   Roundness of by value candidates.
                                       Y=yes limits the tick interval search to 10, 20, 25, or 50. 
                                       N=no expands the tick interval search to 10, 12.5, 15, 20, 25, 30, 40, 
                                          50, 60, 75, or 80.
                                       Default value is Y.
               MinDens  => OPTIONAL.   Density of minor tick marks. 
                                       L=low, M=medium, H=high.
                                       Default value is M.

   OUTPUTS:    Macro variables
                  _&Prefix.AxisStart   Axis start value.
                  _&Prefix.AxisEnd     Axis end value.
                  _&Prefix.AxisBy      Axis increment/by value.
                  _&Prefix.AxisList    Space-separated list of major tick mark values.
                  _&Prefix.AxisMin     Minimum observed value in VAR or VAL.
                  _&Prefix.AxisMax     Maximum observed value in VAR or VAL.
                  _&Prefix.AxisListUnb Alternate version of AxisList that allows for unbounded data
                                       values by removing the first/last values if they are smaller/
                                       larger than the observed minimum/maximum.
                  _&Prefix.AxisMinor   Recommended number of minor tick marks.
                                       Returns zero when By is specified.

   EXAMPLE 1:  %AxisOrder(Data=work.adlb
                         ,Var=aval anrlo anrhi
                         ,Prefix=y
                         ,MajTarg=3
                         );

               axis1 order=(&_yAxisStart to &_yAxisEnd by &_yAxisBy) minor=(n=&_yAxisMinor);
               
   EXAMPLE 2:  %AxisOrder(Data=lb_alt
                         ,Var=lbstresn
                         ,Val=0
                         ,By=10
                         );

               axis1 order=(&_AxisStart to &_AxisEnd by &_AxisBy);
                               
   PROGRAM HISTORY:

   DATE        PROGRAMMER        DESCRIPTION
   ----------  ---------------   ----------------------------------------------------
   2014-03-13  Shane Rosanbalm   Original program.
   2015-06-16  Shane Rosanbalm   Add _AxisMin, _AxisMax, and _AxisListUnb.
   2015-07-13  Shane Rosanbalm   Add Threshold.
   2016-05-06  Shane Rosanbalm   Fails when &val contains negative numbers.
                                 Added %nrbquote to %if and %str( ) as modifier to countw.
   2016-07-25  Shane Rosanbalm   Fix two-level dataset name bug.

*-----------------------------------------------------------------------------------*/

%MACRO AxisOrder
         (Data=
         ,Var=
         ,Val=
         ,By=
         ,Prefix=
         ,MajTarg=6
         ,MajDev=1
         ,Threshold=0
         ,RoundBys=Y
         ,MinDens=M
         );


   %*------------------------------------------------------------------------------;
   %*-------------------- before we begin --------------------;
   %*------------------------------------------------------------------------------;


   %*---------- output macro variables to be created ----------;
   %GLOBAL _&Prefix.AxisStart _&Prefix.AxisEnd _&Prefix.AxisBy _&Prefix.AxisList _&Prefix.AxisMinor
           _&Prefix.AxisMin _&Prefix.AxisMax _&Prefix.AxisListUnb;
      
      
   %*---------- capture option settings at macro invocation ----------;
   %let _mprint = %sysfunc(getoption(mprint));
   %let _notes  = %sysfunc(getoption(notes));
   %let _source = %sysfunc(getoption(source));
      
      
   %*---------- reset some options ----------;
   options nomprint nonotes nosource;
   
   
   %*------------------------------------------------------------------------------;
   %*-------------------- lots of pre-processing of parameters --------------------;
   %*------------------------------------------------------------------------------;
   
   
   %*---------- were required parameters provided ----------;
   %if %nrbquote(&Data) eq %then %do;
      %put AxisOrder -> NO INPUT DATASET WAS SPECIFIED.; 
      %put THE MACRO WILL STOP EXECUTING.;
      %goto badending;
   %end;
   %if %nrbquote(&Var) eq %then %do;
      %put AxisOrder -> NO INPUT VARIABLES WERE SPECIFIED.; 
      %put THE MACRO WILL STOP EXECUTING.;
      %goto badending;
   %end;

   
   %*---------- does Data exist ----------;
   %if %sysfunc(exist(&Data)) eq 0 %then %do;
      %put AxisOrder -> THE INPUT DATASET [ &Data ] DOES NOT EXIST.; 
      %put THE MACRO WILL STOP EXECUTING.;
      %goto badending;
   %end;
   
   %*---------- is Data two-level ----------;
   %let libmem = %sysfunc(compress(&Data,.));
   
   
   %*---------- do Var items exist ----------;
   %let _badvar = 0;
   %do _vari = 1 %to %sysfunc(countw(&Var));;
      %let _varname = %scan(&Var,&_vari,%str( ));
      data _null_;
         dsid = open("&Data");
         check = varnum(dsid,"&_varname");
         if check = 0 then call symput('_badvar','1');
      run;
      %if &_badvar = 1 %then %do;
         %put AxisOrder -> THE INPUT VARIABLE [ &_varname ] DOES NOT EXIST.; 
         %put THE MACRO WILL STOP EXECUTING.;
         %goto badending;
      %end;
   %end;
   
   
   %*---------- are Val items numbers ----------;
   %if %length(%sysfunc(compress(%nrbquote(&val.),0123456789.-))) > 0 %then %do;
      %put AxisOrder -> THE INPUT VALUE [ &Val ] CONTAINS NON-NUMERIC CHARACTERS.; 
      %put THE MACRO WILL STOP EXECUTING.;
      %goto badending;
   %end;
   %if %nrbquote(&Val) ne %then %do;
      %let _badval = 0;
      %do _vali = 1 %to %sysfunc(countw(&Val,%str( )));;
         %let _valvalue = %scan(&Val,&_vali,%str( ));
         data _null_;
            check = input("&_valvalue",??best.);
            if missing(check) then call symput('_badval','1');
         run;
         %if &_badval = 1 %then %do;
            %put AxisOrder -> THE Val ELEMENT [ &_valvalue ] IS NOT A VALID NUMBER.; 
            %put THE MACRO WILL STOP EXECUTING.;
            %goto badending;
         %end;
      %end;
   %end;
   
   
   %*---------- is By a positive number ----------;
   %if %nrbquote(&By) ne %then %do;
      %let _badby = 0;
      data _null_;
         check = input("&By",??best.);
         if check < 1e-5 then call symput('_badby','1');
      run;
      %if &_badby = 1 %then %do;
         %put AxisOrder -> THE INPUT BY VALUE [ &By ] IS NOT COMPATIBLE WITH THIS MACRO.; 
         %put THE MACRO WILL STOP EXECUTING.;
         %goto badending;
      %end;
   %end;
   
   
   %*---------- is MajTarg a positive integer ----------;
   %if %nrbquote(&MajTarg) ne %then %do;
      %let _badmajtarg = 0;
      data _null_;
         check = input("&MajTarg",??8.);
         if check < 1 then call symput('_badmajtarg','1');
      run;
      %if &_badmajtarg = 1 %then %do;
         %put AxisOrder -> THE INPUT VALUE [ &MajTarg ] IS NOT A POSITIVE INTEGER.; 
         %put THE MACRO WILL STOP EXECUTING.;
         %goto badending;
      %end;
   %end;
   
   
   %*---------- is MajDev a non-negative integer ----------;
   %if %nrbquote(&MajDev) ne %then %do;
      %let _badmajdev = 0;
      data _null_;
         check = input("&MajDev",??8.);
         if check < 0 then call symput('_badmajdev','1');
      run;
      %if &_badmajdev = 1 %then %do;
         %put AxisOrder -> THE INPUT VALUE [ &MajDev ] IS NOT A NON-NEGATIVE INTEGER.; 
         %put THE MACRO WILL STOP EXECUTING.;
         %goto badending;
      %end;
   %end;
   
   
   %*---------- is RoundBys valid ----------;
   %if %nrbquote(&RoundBys) ne %then %do;
      %let RoundBys = %upcase(&RoundBys);
      %let _badroundbys = 0;
      data _null_;
         if "&RoundBys" not in ('Y' 'N') then call symput('_badroundbys','1');
      run;
      %if &_badroundbys = 1 %then %do;
         %put AxisOrder -> THE INPUT VALUE [ &RoundBys ] IS NOT A VALID ROUNDNESS.; 
         %put THE MACRO WILL STOP EXECUTING.;
         %goto badending;
      %end;
   %end;
   
   
   %*---------- is MinDens valid ----------;
   %if %nrbquote(&MinDens) ne %then %do;
      %let MinDens = %upcase(&MinDens);
      %let _badmindens = 0;
      data _null_;
         if "&MinDens" not in ('L' 'M' 'H') then call symput('_badmindens','1');
      run;
      %if &_badmindens = 1 %then %do;
         %put AxisOrder -> THE INPUT VALUE [ &MinDens ] IS NOT A VALID MINOR DENSITY.; 
         %put THE MACRO WILL STOP EXECUTING.;
         %goto badending;
      %end;
   %end;
   
   
   %*------------------------------------------------------------------------------;
   %*-------------------- prepare the data for axis selection --------------------;
   %*------------------------------------------------------------------------------;
   
   
   %*---------- stack Val and Var information into vertical structure ----------;
   data _vert&libmem;
      set &Data (keep=&Var) end=eof;
      %if &Var ne %str() %then %do;
         %do _vari = 1 %to %sysfunc(countw(&Var));
            vert = %scan(&Var,&_vari,%str( ));
            output;
         %end;
      %end;
      if eof then do;
         %if %nrbquote(&Val) ne %str() %then %do;
            %do _vali = 1 %to %sysfunc(countw(&Val,%str( )));
               vert = %scan(&Val,&_vali,%str( ));
               output;
            %end;
         %end;
      end;
   run;
      
      
   %*---------- calculate min, max, range based on variables and values of interest ----------;
   proc means data=_vert&libmem noprint;
      var vert;
      output out=_minmaxrange min=varmin max=varmax range=varrange;
   run;
   
   
   %*------------------------------------------------------------------------------;
   %*-------------------- the actual axis selection steps --------------------;
   %*------------------------------------------------------------------------------;
   
   
   data _axisorder;
      set _minmaxrange;
      if varrange = 0 then varrange = 1;

      %*---------- centralize constants associated with each by level ----------;
      %if &RoundBys eq Y %then %do;      
      
         %let _byn = 3;
         root1 = 1;     mult1 = 2/1;   low1 = 1;   med1 = 4;   high1 = 9;
         root2 = 2;     mult2 = 2/1;   low2 = 1;   med2 = 3;   high2 = 7;
         root3 = 2.5;   mult3 = 5/4;   low3 = 1;   med3 = 4;   high3 = 9;
         root0 = 5;     mult0 = 2/1;   low0 = 1;   med0 = 4;   high0 = 9;
         
      %end;
      
      %if &RoundBys eq N %then %do;
      
         %let _byn = 10;
         root1 = 1;     mult1 = 5/4;   low1 = 1;   med1 = 4;   high1 = 9;
         root2 = 1.25;  mult2 = 5/4;   low2 = 1;   med2 = 4;   high2 = 9;
         root3 = 1.5;   mult3 = 6/5;   low3 = 1;   med3 = 2;   high3 = 5;
         root4 = 2;     mult4 = 4/3;   low4 = 1;   med4 = 3;   high4 = 7;
         root5 = 2.5;   mult5 = 5/4;   low5 = 1;   med5 = 4;   high5 = 9;
         root6 = 3;     mult6 = 6/5;   low6 = 1;   med6 = 2;   high6 = 8;
         root7 = 4;     mult7 = 4/3;   low7 = 1;   med7 = 3;   high7 = 7;
         root8 = 5;     mult8 = 5/4;   low8 = 1;   med8 = 4;   high8 = 9;
         root9 = 6;     mult9 = 6/5;   low9 = 1;   med9 = 2;   high9 = 5;
         root10= 7.5;   mult10= 5/4;   low10= 1;   med10= 2;   high10= 5;
         root0 = 8;     mult0 = 16/15; low0 = 1;   med0 = 3;   high0 = 7;
      
      %end;
      
      %let _mod = %eval(&_byn+1);
      %let _min = 0.00001;
      %let _max = 1000000000;
      %let _precision = 0.0000001;
      %let _ratio = %sysfunc(log10(&_max/&_min));
      %let _arraymax = %eval(&_ratio*&_mod+1);
      
      array root[0:&_byn] root0-root&_byn;
      array mult[0:&_byn] mult0-mult&_byn;
      array low[0:&_byn] low0-low&_byn;
      array med[0:&_byn] med0-med&_byn;
      array high[0:&_byn] high0-high&_byn;
         
      %*---------- more work if By not prespecified ----------;
      %if &By eq %then %do;
      
         %*---------- create list of candidate levels ----------;
         array level {&_arraymax};
         do i = 1 to &_arraymax;
            if i = 1 then level[i] = &_min;
            else if i > 1 then do;
               level[i] = level[i-1] * mult[mod(i,&_mod)];
               level[i] = round(level[i],&_precision);
            end;
         end;
            
         array tempdiff {&_arraymax};
         array tempwaste {&_arraymax};
         ibest = 1;
         do i = 1 to &_arraymax;
         
            %*---------- calculate target deviation of candidate levels ----------;
            tempmin = level[i]*floor(varmin/level[i]);
            tempmax = level[i]*ceil(varmax/level[i]);
            tempmaj = round((tempmax-tempmin)/level[i] + 1, 1);
            tempdiff[i] = abs(tempmaj-&MajTarg);
            
            %*---------- calculate waste of candidate levels ----------;
            temprange = tempmax-tempmin;
            if temprange > 0 then do;
               topwaste = abs(tempmax-varmax)/temprange;
               botwaste = abs(tempmin-varmin)/temprange;
            end;
            else do;
               topwaste = 1;
               botwaste = 1;
            end;
            tempwaste[i] = max(topwaste,botwaste);
            
            %*---------- first get within MajDev of MajTarg, and then let white space drive ----------;
            if tempdiff[ibest] > &MajDev then do;
               if tempdiff[i] < tempdiff[ibest] then ibest = i;
               else if tempdiff[i] = tempdiff[ibest] and tempwaste[i] < tempwaste[ibest] then ibest = i;
            end;
            else if tempdiff[ibest] <= &MajDev then do;
               if tempdiff[i] <= &MajDev and tempwaste[i] < tempwaste[ibest] then ibest = i;
            end;
               
         end;
         AxisBy = level[ibest];
            
      %end;
   
      %*---------- less work if By is prespecified ----------;
      %if &By ne %then %do;
      
         AxisBy = &By;
         
      %end;
      
      %*---------- establish start and end ----------;
      AxisStart = round(AxisBy*floor(varmin/AxisBy),&_precision);
      AxisEnd = round(AxisBy*ceil(varmax/AxisBy),&_precision);
      
      %*---------- create axis list ----------;
      length AxisList $200;
      do value = AxisStart to AxisEnd by AxisBy;
         AxisList = catx(' ',AxisList,put(value,best.));
      end;
      
      %*---------- establish min and max ----------;
      AxisMin = round(varmin,&_precision);
      AxisMax = round(varmax,&_precision);
      
      %*---------- trim first/last value from list if inside threshold ----------;
      unbstart = AxisStart;
      secondTick = round(AxisStart+AxisBy,&_precision);
      unbstartcut = secondTick - (1-&Threshold)*AxisBy;
      if unbstartcut < AxisMin then unbstart = round(AxisStart+AxisBy,&_precision);
      else AxisMin = unbstart;
      
      unbend = AxisEnd;
      penultTick = round(AxisEnd-AxisBy,&_precision);
      unbendcut = penultTick + (1-&Threshold)*AxisBy;
      if AxisMax < unbendcut then unbend = round(AxisEnd-AxisBy,&_precision);
      else AxisMax = unbend;
      
      length AxisListUnb $200;
      do value = unbstart to unbend by AxisBy;
         AxisListUnb = catx(' ',AxisListUnb,put(value,best.));
      end;
      
      %*---------- choose minor value ----------;
      %if &By eq %then %do;
      
         modibest = mod(ibest,&_mod);
         if      "&MinDens" = "L" then AxisMinor = low[modibest];
         else if "&MinDens" = "M" then AxisMinor = med[modibest];
         else if "&MinDens" = "H" then AxisMinor = high[modibest];
         
      %end;
      
      %if &By ne %then %do;
      
         AxisMinor = 0;
         
      %end;
      
      %*---------- send results to macro variables ----------;
      call symputx("_&Prefix.AxisStart"  ,put(AxisStart,best.));
      call symputx("_&Prefix.AxisEnd"    ,put(AxisEnd,best.));
      call symputx("_&Prefix.AxisBy"     ,put(AxisBy,best.));
      call symputx("_&Prefix.AxisList"   ,AxisList);
      call symputx("_&Prefix.AxisMin"    ,put(AxisMin,best.));
      call symputx("_&Prefix.AxisMax"    ,put(AxisMax,best.));
      call symputx("_&Prefix.AxisListUnb",AxisListUnb);
      call symputx("_&Prefix.AxisMinor"  ,put(AxisMinor,best.));
      
   run;
   
   
   %*---------- remove temporary datasets ----------;
   proc sql noprint;
      drop table _vert&libmem, _minmaxrange, _axisorder;
   quit;

   
   %*---------- this is the goto landing point ----------;
   %badending:
   
   
   %*---------- reset options  ----------;
   options &_mprint. &_notes. &_source. ;


   %*---------- inform user of macro variable values ----------;
   %put _&Prefix.AxisStart   = [ &&_&Prefix.AxisStart ];
   %put _&Prefix.AxisEnd     = [ &&_&Prefix.AxisEnd ];
   %put _&Prefix.AxisBy      = [ &&_&Prefix.AxisBy ];
   %put _&Prefix.AxisList    = [ &&_&Prefix.AxisList ];
   %put _&Prefix.AxisMin     = [ &&_&Prefix.AxisMin ];
   %put _&Prefix.AxisMax     = [ &&_&Prefix.AxisMax ];
   %put _&Prefix.AxisListUnb = [ &&_&Prefix.AxisListUnb ];
   %put _&Prefix.AxisMinor   = [ &&_&Prefix.AxisMinor ];
   
   
%MEND AxisOrder;