/*----------------------- Copyright 2016, Rho, Inc.  All rights reserved. ------------------------\

  Program:    violinPlot.sas

    Purpose:  Generate violin plots in SAS

    Output:   violinPlot.(pdf png sas)

    /---------------------------------------------------------------------------------------------\
      Macro parameters
    \---------------------------------------------------------------------------------------------/

            Parameter               Purpose
            --------------------    --------------------------------------------------------------
            data                    [REQUIRED]  input dataset
            outcomeVar              [REQUIRED]  continuous outcome variable

            groupVar                [optional]  categorical grouping variable
            panelVar                [optional]  categorical paneling variable
            byVar                   [optional]  categorical BY variable
            outPath                 [optional]  output directory
            outName                 [optional]  output name
            widthMultiplier         [optional]  kernel density width coefficient
            jitterYN                [optional]  display jittered data points?
            quartileYN              [optional]  display color-coded quartiles?
            quartileSymbolsYN       [optional]  display quartiles as symbols?
            meanYN                  [optional]  display means?
            trendLineYN             [optional]  display a trend line?
            trendStatistic          [optional]  trend line statistic

/-------------------------------------------------------------------------------------------------\
  Program history:
\-------------------------------------------------------------------------------------------------/

    Date        Programmer          Description
    ----------  ------------------  --------------------------------------------------------------
    2016-02-02  Spencer Childress   Create

\------------------------------------------------------------------------------------------------*/

%macro violinPlot
    (data              = 
    ,outcomeVar        = 
    ,groupVar          = 
    ,panelVar          = 
    ,byVar             = 
    ,outPath           = .
    ,outName           = violinPlot
    ,widthMultiplier   = 1
    ,jitterYN          = Yes
    ,quartileYN        = Yes
    ,quartileSymbolsYN = No
    ,meanYN            = Yes
    ,trendLineYN       = Yes
    ,trendStatistic    = Median
    ) / minoperator;

    %if &data            = %then %goto exit;
    %if &outcomeVar      = %then %goto exit;
    %if &widthMultiplier = %then %let  widthMuliplier = 1;

    /*--------------------------------------------------------------------------------------------\
      Data manipulation
    \--------------------------------------------------------------------------------------------*/

        data _inputData_;
            set &data (
                keep  = &byVar &panelVar &groupVar &outcomeVar
                where = (&outcomeVar gt .z));

            if "&groupVar" = '' then do;
                dummyVariable = 1;
                call symputx('groupVar', 'dummyVariable');
            end;
        run;

        proc sort
            data = _inputData_;
            by &groupVar &outcomeVar;
        data inputData (drop = groupVarValues);
            retain &byVar &panelVar &groupVar &outcomeVar;
            set _inputData_
                end = eof;
            by &groupVar;

            outcomeVar = &outcomeVar*&widthMultiplier;

            length groupVarValues $9999;
            retain groupVarValues;

            if first.&groupVar then do;
                groupVar   + 1;
                groupVarValues = catx('|', groupVarValues, ifc(vtype(&groupVar) = 'C', quote(&groupVar), &groupvar));
            end;

            if eof then do;
                    call symputx('outcomeVarLabel', coalescec(vlabel(&outcomeVar), vname(&outcomeVar)));
                    call symputx('nGroupVarValues', strip(put(groupVar, 8.)));
                    call symputx('groupVarValues', groupVarValues);
                    call symputx('groupVarLabel', coalescec(vlabel(  &groupVar), vname(  &groupVar)));
                %if &panelVar ne %then
                    call symputx('panelVarLabel', coalescec(vlabel(&panelVar), vname(&panelVar)));;
                %if &byVar ne %then
                    call symputx('byVarLabel', coalescec(vlabel(&byVar), vname(&byVar)));;
            end;
        run;

            %put %str(NOTE- Outcome:          &outcomeVarLabel);

        %if &groupVar ne dummyVariable %then %do;
            %put %str(NOTE- Group by:         &groupVarLabel);
            %put %str(NOTE- Number of groups: &nGroupVarValues);
            %put %str(NOTE- Group values:     &groupVarValues);
        %end;

        %if &panelVar ne %then
            %put %str(NOTE- Panel by:         &panelVarLabel);
        %if &byVar ne %then
            %put %str(NOTE- Process by:       &byVarLabel);

    /*--------------------------------------------------------------------------------------------\
      Formats
    \--------------------------------------------------------------------------------------------*/

        proc format;
            value groupVar
                %do i = 1 %to %scan(&nGroupVarValues, -1);
                    %sysevalf(&i/2 - .25) -< %sysevalf(&i/2 + .25) = %scan(&groupVarValues, &i, |)
                %end;
                other        = ' '
            ;
        run;

    /*--------------------------------------------------------------------------------------------\
      Statistics
    \--------------------------------------------------------------------------------------------*/

        /*----------------------------------------------------------------------------------------\
          Kernel density estimation (KDE)
        \----------------------------------------------------------------------------------------*/

            ods graphics off;
                proc sort
                    data = inputData;
                    by &byVar &panelVar &groupVar &outcomeVar;
                proc kde
                    data = inputData;
                    by &byVar &panelVar &groupVar groupVar;
                    univar outcomeVar / noprint
                        out = KDE;
                run;
            ods graphics;


        /*----------------------------------------------------------------------------------------\
          Descriptive statistics (stats)
        \----------------------------------------------------------------------------------------*/

            proc means noprint nway
                data = inputData;
                class  &byVar &panelVar &groupVar groupVar;
                var    &outcomeVar;
                output
                    out    = statistics
                    mean   = mean
                    p25    = quartile1
                    median = median
                    p75    = quartile3;
            run;

        /*----------------------------------------------------------------------------------------\
          Merge KDE and stats to assign quartiles
        \----------------------------------------------------------------------------------------*/

            proc sql;
                create table KDEstatistics as
                    select a.*,

                          density  + b.groupVar/2 as upperBand,
                        (-density) + b.groupVar/2 as lowerBand,
                        value/&widthMultiplier    as     yBand,
                        case when              calculated yBand le quartile1 then  25 + 100*b.groupVar
                             when quartile1 lt calculated yBand le median    then  50 + 100*b.groupVar
                             when median    lt calculated yBand le quartile3 then  75 + 100*b.groupVar
                                                                             else 100 + 100*b.groupVar
                         end as quartile

                         from    KDE a
                             inner join
                                 statistics b
                             on %if &byVar    ne %then a.&byVar    = b.&byVar and;
                                %if &panelVar ne %then a.&panelVar = b.&panelVar and;
                                a.&groupVar = b.&groupVar
                order by %if &byVar    ne %then &byVar,;
                         %if &panelVar ne %then &panelVar,;
                                                &groupVar,
                                                 yBand;

        /*----------------------------------------------------------------------------------------\
          Merge input date and stats to assign quartiles and jitter outcome
        \----------------------------------------------------------------------------------------*/

                create table inputDataStatistics as
                    select a.*,
                        case when              &outcomeVar le quartile1 then  25 + 100*b.groupVar
                             when quartile1 lt &outcomeVar le median    then  50 + 100*b.groupVar
                             when median    lt &outcomeVar le quartile3 then  75 + 100*b.groupVar
                                                                        else 100 + 100*b.groupVar
                         end as quartile,
                        case when              &outcomeVar le quartile1 then b.groupVar/2 + ifn(mod(monotonic(), 2), 1, -1)*ranuni(2357)/30
                             when quartile1 lt &outcomeVar le median    then b.groupVar/2 + ifn(mod(monotonic(), 2), 1, -1)*ranuni(2357)/15
                             when median    lt &outcomeVar le quartile3 then b.groupVar/2 + ifn(mod(monotonic(), 2), 1, -1)*ranuni(2357)/15
                                                                        else b.groupVar/2 + ifn(mod(monotonic(), 2), 1, -1)*ranuni(2357)/30
                         end as jitter

                         from    inputData a
                             inner join
                                 statistics b
                             on %if &byVar    ne %then a.&byVar    = b.&byVar and;
                                %if &panelVar ne %then a.&panelVar = b.&panelVar and;
                                a.&groupVar = b.&groupVar
                order by %if &byVar    ne %then &byVar,;
                         %if &panelVar ne %then &panelVar,;
                                                &groupVar,
                                                 &outcomeVar;
            quit;

        /*----------------------------------------------------------------------------------------\
          Stack KDE, stats, and input data
        \----------------------------------------------------------------------------------------*/

            data fin;
                set KDEstatistics (
                        in = KDE)
                    statistics (
                        in = stats)
                    inputDataStatistics (
                        in = data);

                groupVar_div_2 = groupVar/2;
                if quartile gt .z and "&quartileYN" ne 'Yes' then quartile = ceil(quartile/100)*100;

                label
                    quartile1 = 'First Quartile'
                    median = 'Median'
                    quartile3 = 'Third Quartile'
                    mean = 'Mean'
                ;
            run;

            proc sql;
                %if &panelVar ne %then %do;
                    select count(distinct &panelVar)
                      into :nPanelVarValues trimmed
                        from inputData;

                    %if &nPanelVarValues le 4 %then %do;
                        %let rows = 1;
                        %let columns = &nPanelVarValues;
                    %end;
                    %else %if &nPanelVarValues le 8 %then %do;
                        %let rows = 2;
                        %let columns = 4;
                    %end;
                    %else %do;
                        %let rows = 1;
                        %let cols = 4;
                    %end;
                %end;
            quit;

    /*--------------------------------------------------------------------------------------------\
      Figure generation
    \--------------------------------------------------------------------------------------------*/

        proc sql;
            create table quartileColors as
                select distinct %if &panelVar ne %then &panelVar,; groupVar, quartile, (quartile - 100*groupVar)/25 as colorIndex
                    from inputDataStatistics;
        quit;

        %let colors = cxdeebf7 cx9ecae1 cx4292c6 cx08519c;

        data _null_;
            length styleStatement $1000;
            set quartileColors
                end = eof;
            by &panelVar groupVar;

            styleStatement = 'style graphData'
                || strip(put(_n_, 8.))
                || ' / color = '
                || scan("&colors", colorIndex)
                || ';';

            if _n_ = 1 then do;
                call execute('proc template;');
                    call execute('define style styles.violin;');
                        call execute('parent = styles.printer;');
            end;

                            call execute(styleStatement);

            if eof then do;
                    call execute('end;');
                call execute('run;');
            end;
        run;

        title;
        footnote;

        options nodate
            orientation = landscape;

        ods results off;

            ods listing
                gpath = "%sysfunc(pathname(temp))"
                style = styles.violin;
            ods graphics /
                reset = all
                border = no
                width = 10in
                height = 7.5in
                imagename = 'violinPlotImage'
                imagefmt = pdf
                outputfmt = pdf;

            ods pdf
                file  = "&outPath\&outName..pdf"
                style = styles.violin;
                title1 j = c "&outcomeVarLabel";
                %if &panelVar ne %then title2 j = c "Paneled by &panelVarLabel";;

                %macro violin;
                    %if &panelVar ne %then %do;
                        proc sgpanel nocycleattrs noautolegend
                            data = fin;
                            format
                                lowerBand upperBand groupVar_div_2 jitter groupVar.;
                            panelby
                                &panelVar / novarname
                                    rows = &rows
                                    columns = &columns;
                            band
                                y = yBand
                                lower = lowerBand
                                upper = upperBand / fill outline
                                    group = quartile
                                    lineattrs = (
                                        pattern = solid
                                        color = black);

                            %if &jitterYN = Yes %then %do;
                                scatter
                                    x = jitter
                                    y = &outcomeVar /
                                        markerattrs = (
                                            symbol = circle
                                            size = 6px
                                            color = black);
                            %end;

                            %if &quartileSymbolsYN = Yes %then %do;
                                scatter
                                    x = groupVar_div_2
                                    y = quartile1 /
                                        name = 'quartile1'
                                        markerattrs = (
                                            symbol = diamondFilled
                                            size = 6px
                                            color = black);
                                scatter
                                    x = groupVar_div_2
                                    y = median /
                                        name = 'median'
                                        markerattrs = (
                                            symbol = diamondFilled
                                            size = 9px
                                            color = black);
                                scatter
                                    x = groupVar_div_2
                                    y = quartile3 /
                                        name = 'quartile3'
                                        markerattrs = (
                                            symbol = diamondFilled
                                            size = 6px
                                            color = black);
                            %end;

                            %if &meanYN = Yes %then %do;
                                scatter
                                    x = groupVar_div_2
                                    y = mean /
                                        name = 'mean'
                                        markerattrs = (
                                            symbol = diamondFilled
                                            size = 9px
                                            color = yellow);
                            %end;

                            %if &trendLineYN = Yes %then %do;
                                series
                                    x = groupVar_div_2
                                    y = &trendStatistic /
                                        lineattrs = (
                                            color = red
                                            thickness = 2px);
                                scatter
                                    x = groupVar_div_2
                                    y = &trendStatistic /
                                        name = 'trend'
                                        markerattrs = (
                                            symbol = circleFilled
                                            size = 9px
                                            color = red);
                            %end;

                            rowaxis grid
                                label  = "&outcomeVarLabel"
                                /*values = (&min to &max)*/;
                            colaxis grid
                                label   = "&groupVarLabel"
                                display = (noticks)
                                fitpolicy = rotate
                                values  = (0 to %sysevalf(%scan(&nGroupVarValues, -1)/2 + .5) by .5);
                            *keylegend 'mean' 'trend' /
                                position = right;
                        run;
                    %end;
                    %else %do;
                        proc sgplot nocycleattrs noautolegend
                            data = fin;
                            format
                                lowerBand upperBand groupVar_div_2 jitter groupVar.;
                            band
                                y = yBand
                                lower = lowerBand
                                upper = upperBand / fill outline
                                    group = quartile
                                    lineattrs = (
                                        pattern = solid
                                        color = black);

                            %if &jitterYN = Yes %then %do;
                                scatter
                                    x = jitter
                                    y = &outcomeVar /
                                        markerattrs = (
                                            symbol = circle
                                            size = 6px
                                            color = black);
                            %end;

                            %if &quartileSymbolsYN = Yes %then %do;
                                scatter
                                    x = groupVar_div_2
                                    y = quartile1 /
                                        name = 'quartile1'
                                        markerattrs = (
                                            symbol = diamondFilled
                                            size = 6px
                                            color = black);
                                scatter
                                    x = groupVar_div_2
                                    y = median /
                                        name = 'median'
                                        markerattrs = (
                                            symbol = diamondFilled
                                            size = 9px
                                            color = black);
                                scatter
                                    x = groupVar_div_2
                                    y = quartile3 /
                                        name = 'quartile3'
                                        markerattrs = (
                                            symbol = diamondFilled
                                            size = 6px
                                            color = black);
                            %end;

                            %if &meanYN = Yes %then %do;
                                scatter
                                    x = groupVar_div_2
                                    y = mean /
                                        name = 'mean'
                                        markerattrs = (
                                            symbol = diamondFilled
                                            size = 9px
                                            color = yellow);
                            %end;

                            %if &trendLineYN = Yes %then %do;
                                series
                                    x = groupVar_div_2
                                    y = &trendStatistic /
                                        lineattrs = (
                                            color = red
                                            thickness = 2px);
                                scatter
                                    x = groupVar_div_2
                                    y = &trendStatistic /
                                        name = 'trend'
                                        markerattrs = (
                                            symbol = circleFilled
                                            size = 9px
                                            color = red);
                            %end;

                            yaxis grid
                                label  = "&outcomeVarLabel"
                                /*values = (&min to &max)*/;
                            xaxis grid
                                %if &groupVar ne dummyVariable %then %do;
                                    label   = "&groupVarLabel"
                                    display = (noticks)
                                %end;
                                %else %do;
                                    label   = ""
                                    display = none
                                %end;
                                values  = (0 to %sysevalf(%scan(&nGroupVarValues, -1)/2 + .5) by .5);
                            *keylegend 'mean' 'trend' /
                                position = right;
                        run;
                    %end;
                %mend  violin;
                %violin
            ods pdf close;

            ods graphics /
                reset = all
                border = no
                width = 10.5in
                height = 8in
                imagename = "&outName"
                imagefmt = png
                outputfmt = png
                antialiasmax = 10000;
                ods listing
                    gpath = "&outPath"
                    style = styles.violin;
                    %violin

        ods results;

    %exit:

%mend  violinPlot;
