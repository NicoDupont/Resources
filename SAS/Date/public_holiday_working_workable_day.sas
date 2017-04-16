/*------------------------------------*/
/* Creation date : 14/04/2017  (fr)   */
/* Last update :   16/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		              */
/* Tested on SAS Studio 9.4           */
/*------------------------------------*/

/*------------------------------------*/
/*
' List of functions :
' - 1 -- PublicHolidayFr()  ------- returns 1 if it's a public holiday (FR actualy). 0 if not.
' - 2 -- WorkingDay() ------------- returns 1 if it's a Working Day (Monday => Friday). 0 if not.
' - 3 -- WorkableDay() ------------ returns 1 if it's a Workable Day (Monday => Saturday). 0 if not.
' - 4 -- NextWorkingDay() --------- returns the date in parameter if it's a working day or the next working day if is not.
' - 5 -- NextWorkableDay() -------- returns the date in parameter if it's a workable  day or the next workable day if is not.
' - 6 -- PrevWorkingDay() --------- returns the previous working day.
' - 7 -- PrevWorkableDay() -------- returns the previous workable day.
' - 8 -- NextPublicHoliday() ------ returns the next public holiday.
' - 9 -- FirstWorkingDayMonth() --- returns the first working day of the month.
' - 10 - FirstWorkableDayMonth() -- returns the first workable day of the month.
' - 11 - LastWorkingDayMonth() ---- returns the last working day of the month.
' - 12 - LastWorkableDayMonth() --- returns the last workable day of the month.
' - 13 - NumberWorkingDayMonth() -- returns the number of working days of the month.
' - 14 - NumberWorkableDayMonth() - returns the number of workable days of the month.
' - 15 - NumberWorkingDay() ------- returns the number of working days between two dates.
' - 16 - NumberWorkableDay() ------ returns the number of workable days between two dates.
*/
/*------------------------------------*/

options cmplib=work.cat_function;

/* Example data : */
data test;
	input date date2;
	informat date date2 date9.;
	format date date2 date9.;
	datalines;
		31DEC2016 05JAN2017
		01JAN2017 05FEB2017
		15FEB2017 05MAR2017
		15FEB2016 05MAR2018
		08JAN2017 06JUL2017
		09JAN2017 19AUG2017
		25DEC2017 23SEP2017
		31DEC2017 13NOV2017
		01JAN2018 15JAN2018
		05JAN2017 15JAN2017
		05APR2017 06JUN2017
		09JUL2017 04DEC2017
		10NOV2017 23NOV2017
		31DEC2017 24FEB2018
		15MAR2017 26APR2017
		27MAR2016 28MAR2016
		16APR2017 17APR2017
		01APR2018 02APR2018
		31MAR2024 01APR2024
		05MAY2016 06MAY2016
		01MAY2017 02MAY2017
		08MAY2017 09MAY2017
		25MAY2017 26MAY2017
		04JUN2017 05JUN2017
		05JUN2017 06JUN2017
		06JUN2017 07JUN2017
		14APR2017 15APR2017
		15APR2017 16APR2017
		16APR2017 17APR2017
		;
run;


/*-------------------------------------*/
/*  1 - PublicHolidayFr()    		   */
/*-------------------------------------*/

proc fcmp outlib=work.cat_function.test;
	function PublicHolidayFr(DateDay);
		ye = year(DateDay);
		/* compute Pâques Day */
    	mod9 = mod(((19 * (mod(ye,19))) + 24),30);
    	mod4 = mod(ye,4);
    	mod7 = mod(ye,7);
		daypa = Mod9 + mod((2 * Mod4) + (4 * Mod7) + (6 * Mod9) + 5 ,7) - 9;
		mopa = 4;
		/*if daypa <=0 or > 30 there is an error.*/
		if daypa<=0 then do; mopa+-1; daypa=day(intnx('month', mdy(mopa,1,ye), 0, 'e')+daypa/*0 = end of previous month*/); end;
		if daypa>30 then do; mopa+-1; daypa=day(intnx('month', mdy(mopa,1,ye), 0, 'b')+(daypa-31)/*0 = first day of next month*/); end;
    	Pa = mdy(mopa,daypa,ye);
		res = 0;
		select;
				when (mdy(1,1,ye) = DateDay)  res = 1;
				when (mdy(5,1,ye) = DateDay)  res = 1;
				when (mdy(5,8,ye) = DateDay)  res = 1;
				when (mdy(7,14,ye) = DateDay)  res = 1;
				when (mdy(8,15,ye) = DateDay)  res = 1;
				when (mdy(11,1,ye) = DateDay)  res = 1;
				when (mdy(11,11,ye) = DateDay)  res = 1;
				when (mdy(12,25,ye) = DateDay)  res = 1;
				when (Pa = DateDay)  res = 1; /* Dimanche Paques */
				when (Pa+1 = DateDay) res = 1; /* Lundi de Paques */
				when (Pa+39 = DateDay) res = 1; /* Ascension */
				when (Pa+49 = DateDay) res = 1; /* Pentecôte */
				when (Pa+50 = DateDay) res = 1; /* Lundi de Pentecôte */
		end;
		return(res);
	endsub;
run;


data test;
	set test;
	PHolidayD1=PublicHolidayFr(date);
	PHolidayD2=PublicHolidayFr(date2);
run;



/*-------------------------------------*/
/*  2 - WorkingDay()    		       */
/*-------------------------------------*/

proc fcmp outlib=work.cat_function.test;
	function WorkingDay(DateDay);
		nd = WEEKDAY(DateDay);
		ph = PublicHolidayFr(DateDay);
				res = 1;
		if nd = 1
			then
				nd = 7;
			else
				nd +- 1;
		if nd = 7 or nd = 6 or ph = 1
			then
				res = 0;;
		return(res);
	endsub;
run;

/*-------------------------------------*/
/*  3 - WorkableDay()    		       */
/*-------------------------------------*/

proc fcmp outlib=work.cat_function.test;
	function WorkableDay(DateDay);
		nd = WEEKDAY(DateDay);
		ph = PublicHolidayFr(DateDay);
		res = 1;
		if nd = 1
			then
				nd = 7;
			else
				nd +- 1;
		if nd = 7 or ph = 1
			then
				res = 0;
		return(res);
	endsub;
run;


data test;
	set test;
	WkingDay=WorkingDay(date);
	WkableDay=WorkableDay(date);
run;


/*-------------------------------------*/
/*  4 - NextWorkingDay()    		   */
/*-------------------------------------*/

proc fcmp outlib=work.cat_function.test;
	function NextWorkingDay(DateDay);
		if WorkingDay(DateDay) = 1
			then res = DateDay;
			else if  WorkingDay(DateDay+1) = 1
				then res = DateDay+1;
				else if  WorkingDay(DateDay+2) = 1
					then res = DateDay+2;
					else if  WorkingDay(DateDay+3) = 1
						then res = DateDay+3;
						else res = DateDay+4;
		return(res);
	endsub;
run;

/*-------------------------------------*/
/*  5 - NextWorkableDay()    		   */
/*-------------------------------------*/

proc fcmp outlib=work.cat_function.test;
	function NextWorkableDay(DateDay);
		if WorkableDay(DateDay) = 1
			then res = DateDay;
			else if  WorkableDay(DateDay+1) = 1
				then res = DateDay+1;
				else if  WorkableDay(DateDay+2) = 1
					then res = DateDay+2;
					else res = DateDay+3;
		return(res);
	endsub;
run;


data test;
	set test;
	format NextWkingDay NextWkableDay DATE9.;
	NextWkingDay=NextWorkingDay(date);
	NextWkableDay=NextWorkableDay(date);
run;


/*-------------------------------------*/
/*  6 - PrevWorkingDay()    		   */
/*-------------------------------------*/

proc fcmp outlib=work.cat_function.test;
	function PrevWorkingDay(DateDay);
		if WorkingDay(DateDay-1) = 1
			then res = DateDay-1;
			else if  WorkingDay(DateDay-2) = 1
				then res = DateDay-2;
				else if  WorkingDay(DateDay-3) = 1
					then res = DateDay-3;
					else if  WorkingDay(DateDay-4) = 1
						then res = DateDay-4;
						else res = DateDay-5;
		return(res);
	endsub;
run;

/*-------------------------------------*/
/*  7 - PrevWorkableDay()    		   */
/*-------------------------------------*/

proc fcmp outlib=work.cat_function.test;
	function PrevWorkableDay(DateDay);
		if WorkableDay(DateDay-1) = 1
			then res = DateDay-1;
			else if  WorkableDay(DateDay-2) = 1
				then res = DateDay-2;
				else if  WorkableDay(DateDay-3) = 1
					then res = DateDay-3;
					else res = DateDay-4;
		return(res);
	endsub;
run;


data test;
	set test;
	format PrevWkingDay PrevWkableDay DATE9.;
	PrevWkingDay=PrevWorkingDay(date);
	PrevWkableDay=PrevWorkableDay(date);
run;


/*-------------------------------------*/
/*  8 - NextPublicHoliday()    		   */
/*-------------------------------------*/

proc fcmp outlib=work.cat_function.test;
	function NextPublicHoliday(DateDay);
		do i = 1 to 365;
			/*put i=;*/
			if PublicHolidayFr(DateDay + i) = 1
				then do;
					res = DateDay + i;
					goto exitloop;
				end;
		end;
		exitloop:
		return(res);
	endsub;
run;


data test;
	set test;
	format NextPubHol DATE9.;
	NextPubHol=NextPublicHoliday(date);
run;

/*-------------------------------------*/
/*  9 - FirstWorkingDayMonth()    	   */
/*-------------------------------------*/

/* Need to be verified.. */

proc fcmp outlib=work.cat_function.test;
	function FirstWorkingDayMonth(DateDay);
		fd = BeginMonth(DateDay);
		res = NextWorkingDay(fd);
		return(res);
	endsub;
run;


data test;
	set test;
	format FirstWkingDayMonth DATE9.;
	FirstWkingDayMonth=FirstWorkingDayMonth(date);
run;

/*-------------------------------------*/
/*  10 - FirstWorkableDayMonth()       */
/*-------------------------------------*/

/* Need to be verified.. */

proc fcmp outlib=work.cat_function.test;
	function FirstWorkableDayMonth(DateDay);
		fd = BeginMonth(DateDay);
		res = NextWorkableDay(fd);
		return(res);
	endsub;
run;


data test;
	set test;
	format FirstWkableDayMonth DATE9.;
	FirstWkableDayMonth=FirstWorkableDayMonth(date);
run;

/*-------------------------------------*/
/*  11 - LastWorkingDayMonth()    	   */
/*-------------------------------------*/

/* Need to be verified.. */

proc fcmp outlib=work.cat_function.test;
	function LastWorkingDayMonth(DateDay);
		ld = EndMonth(DateDay);
		ldwd = WorkingDay(ld);
		if ldwd = 1
			then
				res = ld;
			else
				res = PrevWorkingDay(ld);
		return(res);
	endsub;
run;


data test;
	set test;
	format LastWkingDayMonth DATE9.;
	LastWkingDayMonth=LastWorkingDayMonth(date);
run;

/*-------------------------------------*/
/*  12 - LastWorkableDayMonth()        */
/*-------------------------------------*/

/* Need to be verified.. */

proc fcmp outlib=work.cat_function.test;
	function LastWorkableDayMonth(DateDay);
		ld = EndMonth(DateDay);
		ldwd = WorkableDay(ld);
		if ldwd = 1
			then
				res = ld;
			else
				res = PrevWorkableDay(ld);
		return(res);
	endsub;
run;


data test;
	set test;
	format LastWkableDayMonth DATE9.;
	LastWkableDayMonth=LastWorkableDayMonth(date);
run;

/*-------------------------------------*/
/*  13 - NumberWorkingDayMonth()       */
/*-------------------------------------*/

/* Need to be verified.. */

proc fcmp outlib=work.cat_function.test;
	function NumberWorkingDayMonth(DateDay);
		fd = BeginMonth(DateDay);
		ld = EndMonth(DateDay);
		res = 0;
		do i=fd to ld;
			if WorkingDay(i) = 1
				then res ++ 1;
		end;
		return(res);
	endsub;
run;


data test;
	set test;
	NbWkingDayMonth=NumberWorkingDayMonth(date);
run;


/*-------------------------------------*/
/*  14 - NumberWorkableDayMonth()      */
/*-------------------------------------*/

/* Need to be verified.. */

proc fcmp outlib=work.cat_function.test;
	function NumberWorkableDayMonth(DateDay);
		fd = BeginMonth(DateDay);
		ld = EndMonth(DateDay);
		res = 0;
		do i=fd to ld;
			if WorkableDay(i) = 1
				then res ++ 1;
		end;
		return(res);
	endsub;
run;


data test;
	set test;
	NbWkableDayMonth=NumberWorkableDayMonth(date);
run;

/*-------------------------------------*/
/*  15 - NumberWorkingDay()      	   */
/*-------------------------------------*/

/* Need to be verified.. */

proc fcmp outlib=work.cat_function.test;
	function NumberWorkingDay(DateFirst,DateLast);
		res = 0;
		do i=DateFirst to DateLast;
			if WorkingDay(i) = 1
				then res ++ 1;
		end;
		return(res);
	endsub;
run;


data test;
	set test;
	NbWkingDay=NumberWorkingDay(date,date2);
run;

/*-------------------------------------*/
/*  16 - NumberWorkableDay()           */
/*-------------------------------------*/

/* Need to be verified.. */

proc fcmp outlib=work.cat_function.test;
	function NumberWorkableDay(DateFirst,DateLast);
		res = 0;
		do i=DateFirst to DateLast;
			if WorkableDay(i) = 1
				then res ++ 1;
		end;
		return(res);
	endsub;
run;


data test;
	set test;
	NbWkableDay=NumberWorkableDay(date,date2);
run;
