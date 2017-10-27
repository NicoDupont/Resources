/*-----------------------------------------------------------------------------------------------


SAS Beeswarm macro created by Shane Rosanbalm of Rho, Inc. 2014 


*---------- high level overview of the BEESWARM macro ----------*

-  This macro creates a dataset which can be used to facilitate the production of a beeswarm plot.
   -  The macro does not itself produce a plot. Instead, it adds a variable to a dataset. The 
      programmer then uses this new variable to produce the beeswarm.
-  This macro requires the user to supply a dataset, a response variable, and a grouping variable.
   -  The grouping variable must be numeric with values 1 to "number of groups".
-  The new variable that the macro creates is a modified version of the grouping variable.
   -  The added variable will have the suffix _BEE. E.g., if you specify TRTAN as a grouping 
      variable, then TRTAN_BEE will be added to the dataset.
-  Results will look best when plotted with the SCATTER statement in SGPLOT.
   -  The optimal range for the grouping axis is min=0.5 and max="number of groups"+0.5.
   -  If you are going to produce a plot with non-default dimensions, axis ranges, or marker sizes, 
      use rmarkers, gmarkers, rmin, and rmax to correct (more below).


*---------- required arguments ----------*

data =      input dataset
respvar =   response variable
grpvar =    grouping variable 
            must be numeric with values 1 to "number of groups"

*---------- optional arguments (for resizing) ----------*

rmarkers =  number of markers that fit in the response direction
            specify rmarkers values >60 if your height is taller than 480px
            specify rmarkers values <60 if your height is shorter than 480px
gmarkers =  number of markers that fit in the grouping direction
            specify gmarkers values >80 if your width is wider than 640px
            specify gmarkers values <80 if your width is narrower than 640px
rmin =      response variable axis minimum 
            specify rmin if your axis will extend much beyond the minimum response value
rmax =      response variable axis maximum
            specify rmax if your axis will extend much beyond the maximum response value

*---------- other optional arguments ----------*

out =       output dataset name
            defaults to BEESWARM
debug       positional
            1=some messages, 2=more messages


*---------- sample usage #1 ----------*

%beeswarm(data=adlb
         ,respvar=aval
         ,grpvar=trtan
         );

proc sgplot data=beeswarm;
   scatter x=trtan_bee y=aval;
   xaxis min=0.5 max=3.5 integer;
run;


*---------- sample usage #2 ----------*

%beeswarm(data=adlb
         ,respvar=aval
         ,grpvar=trtan
         ,rmarkers=35
         ,gmarkers=35
         );

ods graphics / height=2.5in width=2.5in;

proc sgplot data=beeswarm;
   scatter x=trtan_bee y=aval;
   xaxis min=0.5 max=3.5 integer;
run;


-----------------------------------------------------------------------------------------------*/

%macro beeswarm(debug
         ,data=
         ,respvar=
         ,grpvar=
         ,rmarkers=60
         ,gmarkers=80
         ,rmin=
         ,rmax=
         ,out=beeswarm
         );



   *---------------------------------------------------------;
   *---------- pre-processing ----------;
   *---------------------------------------------------------;
   
      
   *---------- helper macro ----------;
   
   %macro letput(mvar);
      %let &mvar = &&&mvar;
      %put &mvar = [ &&&mvar ];
   %mend letput;
   
   
   *---------- comment things in/out based on debug setting ----------;
   
   %let ast1 = * ;
   %let ast2 = * ;
   %if &debug = 1 %then %let ast1 = ;
   %if &debug = 2 %then %do;
      %let ast1 = ;
      %let ast2 = ;
   %end;
   
   %letput (ast1);
   %letput (ast2);


   *---------- verify that grpvar is numeric and integer ----------;
   
   %let _badvartype = 0;
   data _null_;
      dsid = open("&data");
      varnum = varnum(dsid,"&grpvar");
      vartype = vartype(dsid,varnum);
      if vartype = 'C' then call symput('_badvartype','1');
   run;
   %if &_badvartype = 1 %then %do;
      %put Beeswarm -> THE INPUT VARIABLE [ &grpvar ] IS NOT NUMERIC.; 
      %put Beeswarm -> THE MACRO WILL STOP EXECUTING.;
      %goto badending;
   %end;
   
   %let _badvarval = 0;
   data _null_;
      set &data;
      if round(&grpvar,1) ne &grpvar then call symput('_badvarval','1');
   run;
   %if &_badvarval = 1 %then %do;
      %put Beeswarm -> THE INPUT VARIABLE [ &grpvar ] DO NOT FIT THE "1 to N" REQUIREMENT.; 
      %put Beeswarm -> THE MACRO WILL STOP EXECUTING.;
      %goto badending;
   %end;

   
   *---------- count number of groups ----------;

   proc sql noprint;
      select max(&grpvar)
         into :ngrps
         from &data
         ;
   quit;

   %letput (ngrps);


   *---------- calculate what constitutes a marker/step in the grouping direction ----------;

   data _null_;
      gstep = &ngrps/&gmarkers;
      call symput('gstep',put(gstep,best12.));
   run;

   %letput (gstep);


   *---------- calculate what constitutes a marker/step in the response direction ----------;

   proc sql noprint;
      select min(&respvar), max(&respvar)
         into :rminact, :rmaxact
         from &data
         ;
   quit;
   
   %letput (rminact);
   %letput (rmaxact);
      
   data _null_;
      %if &rmin eq %then min = &rminact;;
      %if &rmin ne %then min = min(&rminact,&rmin);;
      %if &rmax eq %then max = &rmaxact;;
      %if &rmax ne %then max = max(&rmaxact,&rmax);;
      rstep = (max - min)/&rmarkers;
      call symput('rstep',put(rstep,best12.));
   run;
   
   %letput (rstep);



   *---------------------------------------------------------;
   *---------- data prep work ----------;
   *---------------------------------------------------------;
   
   
   *---------- get variables list for data ----------;
   
   %let _dot = %index(&data,.);
   
   proc sql noprint;
      select name
         into :varlist separated by ' '
         from sashelp.vcolumn
         where 
            %if &_dot > 0 %then %do; 
               libname = upcase(scan("&data",1,'.')) 
               and memname = upcase(scan("&data",2,'.'))
            %end;
            %if &_dot = 0 %then %do; 
               libname = "WORK" 
               and memname = upcase("&data")
            %end;
         order by name
         ;
   quit;
   
   %letput (varlist);
   
   
   *---------- order least to greatest and transpose by group ----------;
   
   data _ds00;
      set &data;
      _index = _N_;
   run;
   
   proc sort data=_ds00 out=_ds05 (keep=&grpvar &respvar _index);
      by &grpvar &respvar;
      where &respvar is not missing;
   run;
   
   proc transpose data=_ds05 out=_ds10 prefix=resp;
      var &respvar;
      by &grpvar;
   run;
   
   proc transpose data=_ds05 out=_ds11 prefix=_index;
      var _index;
      by &grpvar;
   run;
   
   data _ds15;
      merge _ds10 _ds11;
      by &grpvar;
   run;
   

   *---------- array max ----------;

   proc sql noprint;
      create table _grpcnt as
      select &grpvar, count(*) as grpcnt
         from &data
         group by &grpvar
         ;
      select max(grpcnt)
         into :grpmax
         from _grpcnt
         ;
   quit;
   
   %letput (grpmax);
   
   
   
   *---------------------------------------------------------;
   *---------- actually move data off of center line ----------;
   *---------------------------------------------------------;
   
   
   data _ds20;
      set _ds15;
      
      array resp {&grpmax} resp1-resp&grpmax;
      array xval {&grpmax};
      array distleft {&grpmax};
      array distright {&grpmax};
      threshold = 0.8*sqrt(1**2 + 1**2);
      imax = n(of resp1-resp&grpmax);
      
      *--- first data point stays home always ---;
      i = 1;
      xval[i] = &grpvar;
      
      *--- debug ---;
      &ast1 if _N_ = 1 then do;
      &ast1    put'=================================================';
      &ast1    put "gstep=&gstep rstep=&rstep " threshold=;
      &ast1 end;
      &ast1 put'=================================================';
      &ast1 put i= &grpvar= resp[i]=;
      &ast1 put i= xval[i]= resp[i]=;
      
      *--- process subsequent data points one at a time ---;
      do i = 2 to imax;
      
         *--- debug ---;
         &ast1 put'=================================================';
         &ast1 put i= &grpvar= resp[i]=;
      
         *--- start by trying to place the data point on the center line ---;
         offleft = 0;
         offright = 0;
         
         *--- reset distances for all previous ---;
         do j = 1 to &grpmax;
            distleft[j] = .;
            distright[j] = .;
         end;
         
         *--- want to get outside of threshold either on the right or the left ---;
         if not missing(resp[i]) then do until (dleft >= threshold or dright >= threshold);
         
            *--- evaluate all previous points at a given offleft/offright ---;
            do j = 1 to i-1;
            
               *--- look left ---;
               xleft = &grpvar - offleft;
               xdl = (xval[j]-xleft)/&gstep;
               ydl = (resp[j]-resp[i])/&rstep;
               distleft[j]  = sqrt(xdl**2 + ydl**2);
               
               *--- look right ---;
               xright = &grpvar + offright;
               xdr = (xval[j]-xright)/&gstep;
               ydr = (resp[j]-resp[i])/&rstep;
               distright[j] = sqrt(xdr**2 + ydr**2);
               
               *--- debug ---;
               &ast2 put'----------------------------------------------';
               &ast2 put j= xval[j]= xleft= xright=;
               &ast2 put resp[j]= resp[i]=;
               &ast2 put xdl= ydl= distleft[j]=;
               &ast2 put xdr= ydr= distright[j]=;
               
            end;
            
            *--- what is the worst result for any previous data point ---;
            dleft = min(of distleft1-distleft&grpmax);
            dright = min(of distright1-distright&grpmax);
            
            *--- extend offleft/offright if worst result is not good enough ---;
            if dleft < threshold then offleft = offleft + 0.05*&gstep;
            if dright < threshold then offright = offright + 0.05*&gstep;
            
         end;
         
         *--- pick side to put the data point on, choosing randomly if a tie ---;
         posneg = 2*round(ranuni(1),1) - 1;
         if      offleft = offright then xval[i] = &grpvar + posneg*offright;
         else if offleft < offright then xval[i] = &grpvar - offleft;
         else if offright < offleft then xval[i] = &grpvar + offright;
         
         *--- debug ---;
         &ast1 put'----------------------------------------------';
         &ast1 put xval[j]=;
         
      end;
      
   run;


      
   *---------------------------------------------------------;
   *---------- un-transpose for final output ----------;
   *---------------------------------------------------------;
   
   
   data _ds30;
      set _ds20;
      array respout {&grpmax} resp1-resp&grpmax;
      array xvalout {&grpmax} xval1-xval&grpmax;
      array _indexout (&grpmax) _index1-_index&grpmax;
      do i = 1 to &grpmax;
         &grpvar._bee = xvalout[i];
         &respvar = respout[i];
         _index = _indexout[i];
         if not missing(&respvar) then output;
      end;
      keep &grpvar._bee &respvar _index;
   run;               

   proc sort data=_ds30 out=_ds40;
      by _index;
   run;
   
   data &out (drop=_index);
      merge _ds00 _ds40;
      by _index;
   run;

   %if &debug eq %then %do;
      proc datasets library=work nodetails nolist;
         delete _ds: _grpcnt;
      run;quit;
   %end;
      

   *---------------------------------------------------------;
   *---------- this is the goto landing point ----------;
   *---------------------------------------------------------;
   
   
   %badending:
   
   
%mend beeswarm;

