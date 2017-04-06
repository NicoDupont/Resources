Creation date : 06/04/2017  (fr)          
Last update : 06/04/2017    (fr)         
Author(s) : Nicolas DUPONT     
Contributor(s) :   
Tested on SAS 9.3   

---
### Test if a variable/column exist or not  in a SAS dataset

A macro to test if a column:variable exist or not on a SAS dataset.  
The macro return "0" if not and a "number" > 0  if the column:variable exist.  
We use the macro-variable : "varexist" to use the result from the macro in the main program.  

```sas
GLOBAL varexist;

%macro VarExist(LIB=,TABLE=,VAR=);

    Proc sql noprint;
        select count(*)
        into :varexist
        from DICTIONARY.COLUMNS 
        where libname="%UPCASE(&LIB.)" AND memname="%UPCASE(&table.)"
                   AND name="&var.";
    Quit;
 	
    %if &varexist>0 
	%then %do;
		%put --------------------------;
		%put &VAR column exist on the dataset : &LIB..&TABLE;
		%put --------------------------;
	%end;
    %else %do;
		%put --------------------------;
		%put &VAR column don%str(%')t exist on the dataset : &LIB..&TABLE;
		%put --------------------------;
	%end;

%mend;
```

### ok :

```sas
%VarExist(LIB=WORK,TABLE=CARS,VAR=Make);
```

	Log result :
	--------------------------
	Make column exist on the dataset : WORK.CARS
	--------------------------



### ko : 

```sas
%VarExist(LIB=WORK,TABLE=CARS,VAR=var1);
```


	Log result :
	--------------------------
	var1 column don't exist on the dataset : WORK.CARS
	--------------------------
