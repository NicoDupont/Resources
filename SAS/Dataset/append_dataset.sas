/*------------------------------------*/
/* Creation date : 11/04/2017  (fr)   */
/* Last update :   11/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 				  */
/* Tested with SAS 9.3                */
/*------------------------------------*/

/*
Append 2 datasets with datastep, proc append and proc sql.
1 - Datastep
2 - Proc append
3 - Proc sql ( union / insert )
*/

/*------------------*/
/*  1 -  DATASTEP   */

data master;
	do i = 1 to 5;
		j = 10;
		output;
	end;
run;

data add;
	do i = 1 to 5;
		j = 200;
		cpt=_N_;
		output;
	end;
run;


Data master;
	set 
		master
		add /*(drop=cpt)*/;
run;


/*---------------------*/
/*  2 -  PROC APPEND   */
/* More efficient than a datastep ! */

%MACRO AppendDataset(BASE,DATA,DROP=NO,FORCE=);	
	/* Append DATA to BASE */
	proc append base=&BASE data=&DATA &FORCE;
	run;
	/* Delete DATA if we want */
	%let DROP = %upcase(&DROP);
	%if &DROP = YES
		%then %do;
			proc delete data=&DATA;
			run;
		%end;
%MEND AppendDataset;

/* Examples : */

data master;
	do i = 1 to 5;
		j = 10;
		output;
	end;
run;

data add;
	do i = 1 to 5;
		j = 200;
		output;
	end;
run;


%AppendDataset(BASE=master,DATA=add);
%AppendDataset(BASE=master,DATA=add,DROP=yes);

data add;
	do i = 1 to 5;
		j = 300;
		cpt=_N_;
		output;
	end;
run;

%AppendDataset(BASE=master,DATA=add,FORCE=force,DROP=yes);


/*------------------*/
/*  3 -  PROC SQL   */

data master;
	do i = 1 to 5;
		j = 10;
		output;
	end;
run;

data add;
	do i = 1 to 5;
		j = 200;
		output;
	end;
run;

data add2;
	do i = 1 to 5;
		j = 10;
		output;
	end;
run;


/* Pay attention : proc sql with union remove duplicates values !! */
proc sql;
   create table master2 as
      select * from master
   union
      select * from add
   union
      select * from add2;
quit;


/* Proc sql insert methode : */
proc sql;
  insert into master
     select *
     from add;
  insert into master
     select *
     from add2;
quit;

proc contents data=master; run;
