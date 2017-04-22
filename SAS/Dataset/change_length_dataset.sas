/*------------------------------------*/
/* Creation date : 22/04/2017  (fr)   */
/* Last update :   22/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Studio 9.4           */
/*------------------------------------*/


/*
Sometimes when you want to append/concatenate 2 datasets or more together you have warning or error like "multiple length".
How to change lenth of a variable in a dataset without create another dataset ?
*/


/* Data example */

data cars;
	set sashelp.cars (keep=Make Model Type Origin Drivetrain);
run;


/* change length of Type 8 => 10*/
/*
data cars;
length Type $10;
	set cars;
run;
*/


/*------------------------------------------*/
/* To keep variables order you can do this :*/


/* Put all variables in a list :*/
proc sql noprint;
	select name into :varlist separated by ' '
	from sashelp.vcolumn
	where upcase(libname) eq 'WORK' and upcase(memname) eq 'CARS';
quit;


/* And : */

/* change length of Type 8 => 10*/
/* Now all variables are at the same place */
data cars;
retain &varlist;
length Type $10;
	set cars;
run;