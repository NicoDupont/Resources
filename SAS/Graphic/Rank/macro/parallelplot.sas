/*--------------------------------------------------------------------------------------------------

Source : https://github.com/srosanba/sas-parallel-coordinates-plot/blob/master/src/ParallelPlot.sas

Parallel coordinates plot macro, Shane Rosanbalm, Rho, Inc., 2017

Description:
   This macro generates a parallel coordinates plot. 
      http://www.datavizcatalogue.com/methods/parallel_coordinates.html
   The user specifies the name of a dataset, the names of several numeric 
   variables within that dataset, and an optional grouping variable. The 
   macro performs some data manipulation to scale the variables to fit 
   on a single plot before producing output via SGPLOT. The user writes 
   wrapper code around the macro call to capture the output in their 
   preferrred ODS destination.

Required parameters:
   data     =  Name of input dataset.
               E.g., data=sashelp.cars
   var      =  Space-separated list of numeric variables to plot.
               E.g., var=enginesize horsepower msrp invoice
               BONUS: var=_numeric_ will include all numeric variables.

Optional parmeters:
   group    =  Name of the grouping variable.
               E.g., group=origin
   axistype =  Type of yaxis to display.
               VALID: percentiles|datavalues
               DEFAULT: percentiles
               DETAILS: Using percentiles results in all variables being 
               scaled to [0,1] based on the min/max for that variable. 
               Axes are drawn on the left and right of the plot. Using 
               datavalues results in "nice" axis ranges being calculated
               for each variable. Tick values for each variable are 
               overlayed on top of the lines using the backlight option
               of the text statement.
   sgplotout=  Sends SGPLOT code to specified location.
               E.g., sgplotout=C:/temp/sgplot4parallel.sas
               GOTCHA: The code saving is accomplished via MPRINT and 
               MFILE. Do not attempt to use MPRINT and MFILE elsewhere in 
               the calling program or bad things will happen.
   debug    =  To debug or not to debug...
               VALID: yes|no
               DEFAULT: no

Example 1:
   %parallelplot
      (data=sashelp.iris
      ,var=sepallength sepalwidth petallength petalwidth
      ,group=species
      );
   Result for this call:
      https://github.com/srosanba/sas-parallel-coordinates-plot/raw/master/img/iris_by_percentiles.png

Example 2:
   %parallelplot
      (data=sashelp.iris
      ,var=sepallength sepalwidth petallength petalwidth
      ,group=species
      ,axistype=datavalues
      );
   Result for this call:
      https://github.com/srosanba/sas-parallel-coordinates-plot/raw/master/img/iris_by_datavalues.png

--------------------------------------------------------------------------------------------------*/

%macro parallelplot
         (data=
         ,var=
         ,group=
         ,axistype=percentiles
         ,sgplotout=
         ,debug=no
         ) / minoperator;

   %*--- capture current option settings ---;
   proc optsave out=_optsave;
   run;
   
   %*--- version check ---;
   %if &sysver < 9.4 %then %do;
      %put %str(W)ARNING: version issue. You are using &sysver..;
      %put %str(W)ARNING: This macro uses features from 9.4.;
      %put %str(W)ARNING: Expect %str(E)RROR messages below.;
   %end;
   %else %if &sysver = 9.4 %then %do;
      data _null_;
         sysvlong = "&sysvlong";
         m = index(sysvlong,"M");
         maint = input(substr(sysvlong,m+1,1),best.);
         if maint < 2 then do;
            put "W" "ARNING: version issue. You are using " sysvlong +(-1) ".";
            put "W" "ARNING: This macro uses features from 9.4M2.";
            put "W" "ARNING: Expect E" "RROR messages below.";
         end;
      run;
   %end;
      
   %*--- required checks ---;
   %if &data eq %str() %then 
      %put %str(W)ARNING: parameter DATA is required;
      
   %if &var eq %str() %then 
      %put %str(W)ARNING: parameter VAR is required;
      
   %*--- valid value checks ---;
   %let debug = %upcase(&debug);
   %if not (&debug in (YES Y NO N)) %then
      %put %str(W)ARNING: unexpected value of &=debug;
      
   %let axistype = %upcase(&axistype);
   %if not (&axistype in (PERCENTILES DATAVALUES)) %then
      %put %str(W)ARNING: unexpected value of &=axistype;
      
   %*--- bookkeeping ---;
   %local i;
   %if &group = %str() %then
      %let group = _pcp_dummygroup;

   %*--- create var list if _numeric_ specified ---;
   %local _numeric_;
   %let _numeric_ = 0;
   %if %upcase(&var) = _NUMERIC_ %then %do;
      %let _numeric_ = 1;
      data _numeric_;
         set &data;
      run;
      proc sql noprint;
         select   name
         into     :var separated by " "
         from     dictionary.columns
         where    libname = "WORK"
                  and memname = "_NUMERIC_"
                  and type = "num"
         order by varnum
         ;
      quit;
   %end;
   
   %*--- parse var list ---;
   %let i = 1;
   %do %while (%scan(&var,&i,%str( )) ne %str());
      %local var&i;
      %let var&i = %scan(&var,&i,%str( ));
      %let i = %eval(&i + 1);
   %end;
   %local var_n;
   %let var_n = %eval(&i - 1);
   %put &=var_n;
   %do i = 1 %to &var_n;
      %put var&i=&&var&i;
   %end;

   %*--- dataset existence check ---;
   %if not %sysfunc(exist(&data)) %then
      %put %str(W)ARNING: &=data does not exist;
      
   %*--- dataset conflict check ---;
   proc sql noprint;
      select   count(*)
      into     :pcpdatas
      from     dictionary.tables
      where    libname = "WORK"
               and substr(memname,1,4) = "_PCP"
      ;
      %put &=pcpdatas;
   quit;
   %if &pcpdatas > 0 %then %do;
      %put %str(W)ARNING: WORK dataset names beginning with "_PCP" can be problematic;
      %put NOTE: the above %str(W)ARNING is unavoidable if you have debug turned on;
   %end;
      
   %*--- rename dataset for convenience ---;
   data _pcp10;
      set &data;
      _pcp_dummygroup = 1;
      keep &var &group;
   run;

   %*--- variable existence checks ---;
   %do i = 1 %to &var_n;
      %if not %varexist(data=_pcp10,var=&&var&i) %then
         %put %str(W)ARNING: variable &&var&i does not exist;
   %end;
   
   %if &group ne %str() %then %do;
      %if not %varexist(data=_pcp10,var=&group) %then
         %put %str(W)ARNING: variable &group does not exist;
   %end;
   
   %*--- variable name conflict check ---;
   %local pcpvars;
   proc sql noprint;
      select   count(*)
      into     :pcpvars
      from     dictionary.columns
      where    libname = "WORK"
               and memname = "_PCP10"
               and upcase(substr(name,1,5)) = "_PCP_"
               and upcase(name) ne "_PCP_DUMMYGROUP"
      ;
      %put &=pcpvars;
   quit;
   %if &pcpvars > 0 %then %do;
      %put %str(W)ARNING: variable names in &=data beginning with "_PCP_" can be problematic;
      %put NOTE: avoid variable names beginning with "_PCP_" if at all possible;
   %end;
      
   %*--- type checks ---;
   %do i = 1 %to &var_n;
      %local type&i;
      proc sql noprint;
         select   type
         into     :type&i
         from     dictionary.columns
         where    libname = "WORK"
                  and memname = "_PCP10"
                  and upcase(name) = upcase("&&var&i")
         ;
      quit;
      %if &&type&i ne num %then
         %put %str(W)ARNING: variable &&var&i is not numeric;         
   %end;
   
   %*--- get variable labels for x2axis ---;
   %do i = 1 %to &var_n;
      %local label&i;
      proc sql noprint;
         select   label
         into     :label&i
         from     dictionary.columns
         where    libname = "WORK"
                  and memname = "_PCP10"
                  and upcase(name) = upcase("&&var&i")
         ;
      quit;
      %put label&i=&&label&i;
   %end;

   %*--- make dataset vertical ---;
   data _pcp20;
      set _pcp10;
      _pcp_series = _N_;
      %do i = 1 %to &var_n;
         _pcp_var = &i;
         length _pcp_varc $40;
         _pcp_varc = "&&label&i";
         if _pcp_varc = "" then
            _pcp_varc = "&&var&i";
         _pcp_yval = &&var&i;
         output;
      %end;
   run;

   %*--- standardize results based on start/end (dv) and min/max (pct) ---;
   %do i = 1 %to &var_n;

      data _pcp25_&i;
         set _pcp20;
         where _pcp_var = &i;
      run;

      %axisorder
         (data=_pcp25_&i
         ,var=_pcp_yval
         );

      %local AxisList&i AxisStart&i AxisEnd&i AxisMin&i AxisMax&i;
      %let AxisList&i = %sysfunc(translate(&_AxisList,%str(,),%str( )));
      %let AxisStart&i = &_AxisStart;
      %let AxisEnd&i = &_AxisEnd;
      %let AxisMin&i = &_AxisMin;
      %let AxisMax&i = &_AxisMax;
      %letput(AxisList&i);
      %letput(AxisStart&i);
      %letput(AxisEnd&i);
      %letput(AxisMin&i);
      %letput(AxisMax&i);

   %end;

   data _pcp30;
      set _pcp20;
      %do i = 1 %to &var_n;
         if _pcp_var = &i then do;
            _pcp_start = &&AxisStart&i;
            _pcp_end = &&AxisEnd&i;
            _pcp_dvrange = _pcp_end - _pcp_start;
            _pcp_yval_dv = (_pcp_yval - _pcp_start) / _pcp_dvrange;
            _pcp_min = &&AxisMin&i;
            _pcp_max = &&AxisMax&i;
            _pcp_pctrange = _pcp_max - _pcp_min;
            _pcp_yval_pct = (_pcp_yval - _pcp_min) / _pcp_pctrange;
         end;
      %end;
   run;

   %*--- create group format ---;
   proc sql noprint;
      create   table _pcp35 as
      select   distinct
               "varf" as fmtname,
               _pcp_var as start,
               _pcp_varc as label
      from     _pcp30
      ;
   quit;

   proc format cntlin=_pcp35;
   run;

   %*--- add records for datavalues ---;
   data _pcp40;
      %do i = 1 %to &var_n;
         _pcp_xtext = &i;
         do _pcp_yloop = &&AxisList&i;
            _pcp_start = &&AxisStart&i;
            _pcp_end = &&AxisEnd&i;
            _pcp_dvrange = _pcp_end - _pcp_start;
            _pcp_ytext = (_pcp_yloop - _pcp_start) / _pcp_dvrange;
            _pcp_texttext = strip(put(_pcp_yloop,best.));
            output;
         end;
      %end;
   run;

   data _pcp50;
      set _pcp30 _pcp40;
      format _pcp_var _pcp_xtext varf.;
   run;

   %*--- at long last, we plot ---;
   %macro _pcp_sgplot;
   
      proc sgplot data=_pcp50 nocycleattrs noautolegend noborder;
         styleattrs axisextent=data;
         %*--- pick y variable ---;
         %local yvar;
         %if &axistype = PERCENTILES %then 
            %let yvar = _pcp_yval_pct;
         %else %if &axistype = DATAVALUES %then
            %let yvar = _pcp_yval_dv;
         %*--- series plot ---;
         series x=_pcp_var y=&yvar / 
            group=_pcp_series 
            grouplc=&group /* 9.4m2 feature */
            lineattrs=(pattern=solid)
            x2axis
            name="series"
            ;
         %*--- tick values added: 9.4 feature ---;
         %if &axistype = DATAVALUES %then 
            text x=_pcp_xtext y=_pcp_ytext text=_pcp_texttext /
               x2axis
               backlight=1
               ;
            ;
         %*--- top axis control ---;
         x2axis 
            values=(%do i = 1 %to &var_n; &i %end;)
            display=(nolabel noline noticks)
            grid
            fitpolicy=staggerrotate
            ;
         %*--- yaxis control ---;
         yaxis 
            %if &axistype = PERCENTILES %then
               display=(nolabel)
               grid
               refticks=(values)
               ;
            %else %if &axistype = DATAVALUES %then 
               display=none
               ;
            ;
         %*--- legend for grouped plot ---;
         %if &group ne _pcp_dummygroup %then 
            keylegend "series" /
               exclude=(" ")
               noborder
               type=linecolor /* 9.4m2 feature */
               ;
            ;
      run;
      
   %mend _pcp_sgplot;
   
   %*--- macro to delete previous sgplotout code ---;
   %macro _pcp_delete(path=);
      %if %sysfunc(fileexist(&path)) %then %do;
         data _null_;
            fname="tempfile";
            rc=filename(fname,"&path");
            if rc=0 and fexist(fname) then
               rf=fdelete(fname);
            rc=filename(fname);
         run;
      %end;
   %mend _pcp_delete;
   
   %*--- potentially capture sgplot code ---;
   %if %nrbquote(&sgplotout) ne %str() %then %do;
      %_pcp_delete(path=&sgplotout);
      filename mprint "&sgplotout";
      options mprint mfile;
      %_pcp_sgplot;
   %end;
   %else %do;
      %_pcp_sgplot;
   %end;

   %*--- reset options to baseline values ---;
   proc optload data=_optsave;
   run;
      
   %*--- clean up almost everything ---;
   %if &debug in (N NO) %then %do;
      proc datasets library=work nolist;
         delete 
            %if &_numeric_ %then _numeric_ ;
            _pcp10 _pcp20 
            %do i = 1 %to &var_n;
               _pcp25_&i
            %end;
            _pcp30 _pcp35 _pcp40 _pcp45
            _optsave
            ;
      run; quit;
   %end;
   
%mend parallelplot;