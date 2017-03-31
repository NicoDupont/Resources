Creation date : 29/03/2017  (fr)          
Last update : 29/03/2017    (fr)         
Author(s) : Nicolas DUPONT     
Contributor(s) :   
Tested with SAS 9.3  

---

###### How to create a sas format from a table/dataset:  
###### You can adapt with a flat file in entry or make a macro.  

 - 1 - Example with string data
 - 2 - Example with num data
 - 3 - Extract data from a format 

---

### 1 - Example with string data : */

```sas
data work.dept;
input code $2. lib $25.;
cards;
91 Essone
92 Haut-de-seine
84 Vaucluse
62 Pas-de-calais
;
run;

/* The table in entry need to be transform to be used by the PROC FORMAT at the next step */
data work.tmp_fmt (keep=fmtname label end start type);
set work.dept;
	length fmtname $8 start $2 end $2 label $25 type $1;
	FMTNAME = "FDEPTFR";
	START = code;
	END = code;
	LABEL = lib;
	TYPE = "C"; /*C or N*/
run;

/* The sas format is generated here : */
/* Change the LIB option if you want your new format stay persistent(WORK is not or just during the session.. !)*/
Proc format LIB=WORK CNTLIN=WORK.TMP_FMT;
run;

/* Example : */
%put %sysfunc(putc(84,$FDEPTFR.));
```

Result :

	52         /* Example : */
	53         %put %sysfunc(putc(84,$FDEPTFR.));
	Vaucluse



### 2 - Example with num data : */

```sas
data work.num;
input start $5. end $5. lib $25.;
cards;
LOW  1000 Small
1001 1500 Medium
1501 HIGH Large
;
run;

/* The table in entry need to be transform to be used by the PROC FORMAT at the next step */
data work.tmp_fmt (keep=fmtname label end start type);
set work.num;
	length fmtname $8;
	FMTNAME = "INCOME";
	START = start;
	END = end;
	LABEL = lib;
	TYPE = "N"; /*C or N*/
run;

/* The sas format is generated here : */
/* Change the LIB option if you want your new format stay persistent(WORK is not or just during the session.. !)*/
Proc format LIB=WORK CNTLIN=WORK.TMP_FMT;
run;

/* Examples : */
%put %sysfunc(putn(-1,INCOME.));
%put %sysfunc(putn(800,INCOME.));
%put %sysfunc(putn(1000,INCOME.));
%put %sysfunc(putn(1001,INCOME.));
%put %sysfunc(putn(1502,INCOME.));
%put %sysfunc(putn(2001,INCOME.));
```

LOG results :  

	49         %put %sysfunc(putn(-1,INCOME.));
	Small
	50         %put %sysfunc(putn(800,INCOME.));
	Small
	51         %put %sysfunc(putn(1000,INCOME.));
	Small
	52         %put %sysfunc(putn(1001,INCOME.));
	Medium
	53         %put %sysfunc(putn(1502,INCOME.));
	Large
	54         %put %sysfunc(putn(2001,INCOME.));
	Large


### 3 - Extract data from a format :

```sas
/* We extract from the library WORK all formats and we add a where clause to filter only what we want */
proc format cntlout=WORK.FDEPTFR 
				(keep=FMTNAME START END LABEL TYPE 
				where=(FMTNAME="FDEPTFR")) 
			lib=work; 
run;
```

![](https://github.com/NicoDupont/Resources/blob/master/SAS/Various/img/cntloutformatresult.png?raw=true) 
   
