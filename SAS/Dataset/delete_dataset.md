Creation date : 01/04/2017  (fr)          
Last update : 02/04/2017    (fr)         
Author(s) : Nicolas DUPONT     
Contributor(s) :   
Tested with SAS Studio 9.4   

---
## Delete SAS dataset    

- PROC DATASET 
- PROC DELETE 
- In a Datastep 
- PROC SQL (drop)

```sas
LIBNAME TEST "/folders/myfolders/resource_github/Dataset/Dataset";
%LET PREFIX = NICO;

%macro create_empty_dataset();
	/*Some creations of tables to test our code :*/
	data TEST.&PREFIX._TEST1;
	set _NULL_;
	run;
	data TEST.&PREFIX._TEST2;
	set _NULL_;
	run;
	data TEST.&PREFIX._TEST3;
	set _NULL_;
	run;
	data TEST.&PREFIX._TEST4;
	set _NULL_;
	run;
	data TEST.&PREFIX._TEST5;
	set _NULL_;
	run;
	
	/* 5 empty datasets are created as follow :
	- TEST.NICO_TEST1
	- TEST.NICO_TEST2
	- TEST.NICO_TEST3
	- TEST.NICO_TEST4
	- TEST.NICO_TEST5
	*/
%mend;
%create_empty_dataset();
```


#### 1 - PROC DATASET

```sas
proc delete data=TEST.&PREFIX._TEST1;
run;

proc delete lib=TEST data=&PREFIX._TEST2;
run;


/* Delete multile datasets with the same name structure : */


proc datasets lib=TEST nolist nowarn memtype=data;
	delete &PREFIX._TEST1 - &PREFIX._TEST5;
run;

proc datasets lib=TEST nolist nowarn memtype=data;
	delete &PREFIX.:;
run;
```

#### 2 -  PROC DELETE 


Be careful, The proc delete procedure don't check if the dataset exist !  
=> If the dataset not exist, a warning will be generated !  


```sas
%create_empty_dataset();

proc delete data=TEST.&PREFIX._TEST1;
run;

proc delete lib=TEST data=&PREFIX._TEST2;
run;


proc delete lib=TEST data=&PREFIX._TEST1-&PREFIX._TEST5;
run;
```



#### 3 -  In a DataStep 

```sas
%create_empty_dataset();

DATA _Null_;
	length dd $8;
	rc = filename(dd,cats(pathname('TEST'),'\&PREFIX._TEST1..sas7bdat'));
	rc = fdelete(dd);
	put _all_;
run;
```


#### 4 -  PROC SQL (drop)

```sas
%create_empty_dataset();

/*------------*/
/* delete a single Datset :*/
PROC SQL; 
	drop table TEST.&PREFIX._TEST1;
quit;


/*------------*/
/* Delete multiple datasets with a proc sql :*/

%create_empty_dataset();
%LET DATASET=TEST.&PREFIX._TEST;
%put &DATASET;

%MACRO DELETE_DATASET(DATA,NBDATASET);
	%DO i=1 %TO &NBDATASET;
		%PUT Dataset : &DATA.&i deleted !;
		PROC SQL; 
			drop table &DATA.&i;
    	quit;
    	
	%END;
%MEND DELETE_DATASET;
%DELETE_DATASET(&DATASET,5);


/*-------------*/
%create_empty_dataset();
%LET DATASET=TEST.&PREFIX._TEST;
%put &DATASET;
/* version with test on the dataset */
%MACRO DELETE_DATASET_2(DATA,NBDATASET);
	%DO i=1 %TO &NBDATASET;
		/* test if the dataset exist or not */
		%IF %sysfunc(exist(&DATA.&i)) = 1
		/* if the dataset exist */
			%THEN %DO;
				PROC SQL; 
					drop table &DATA.&i;
		    	quit;
		    	%PUT Dataset : &DATA.&i deleted !;
			%END;
			%ELSE %DO;
				%PUT Dataset : &DATA.&i do not exist !;
			%END;	
	%END;
%MEND DELETE_DATASET_2;
%DELETE_DATASET_2(&DATASET,6);


/*------------*/
/* Delete multiple datasets with a list : */

%create_empty_dataset();
%LET DATASET=TEST.&PREFIX._TEST1 TEST.&PREFIX._TEST2 TEST.&PREFIX._TEST3 TEST.&PREFIX._TEST6;
%put &DATASET;

%MACRO DELETE_DATASET_3(LISTE_DATASET,SEP);
	%LET NBDATASET = %SYSFUNC(COUNTW(&LISTE_DATASET,&SEP));
	%DO i=1 %TO &NBDATASET;
		%LET DATA=%scan(&LISTE_DATASET,&i,&SEP);
		PROC SQL; 
			drop table &DATA;
    	quit;
    	%PUT Dataset : &DATA deleted !;
	%END;
%MEND DELETE_DATASET_3;
%DELETE_DATASET_3(&DATASET,' ');


/*------------*/

%create_empty_dataset();
%LET DATASET=TEST.&PREFIX._TEST1|TEST.&PREFIX._TEST2|TEST.&PREFIX._TEST3|TEST.&PREFIX._TEST6;
%put &DATASET;
/* version with test on the dataset */
%MACRO DELETE_DATASET_4(LISTE_DATASET,SEP);
	%LET NBDATASET = %SYSFUNC(COUNTW(&LISTE_DATASET,&SEP));
	/* loop for each item on the list */
	%DO i=1 %TO &NBDATASET;
		%LET DATA=%scan(&LISTE_DATASET,&i,&SEP);
		/* test if the dataset exist or not */
		%IF %sysfunc(exist(&DATA)) = 1
		/* if the dataset exist */
			%THEN %DO;
				PROC SQL; 
					drop table &DATA;
		    	quit;
		    	%PUT Dataset : &DATA deleted !;
			%END;
			%ELSE %DO;
				%PUT Dataset : &DATA do not exist !;
			%END;	
	%END;
%MEND DELETE_DATASET_4;
%DELETE_DATASET_4(&DATASET,'|');
```



