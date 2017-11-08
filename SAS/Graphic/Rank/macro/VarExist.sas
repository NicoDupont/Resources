/*--------------------------------------------------------------------------------------------------
Purpose: 
   determine if a variable exists
Required arguments: 
   data (dataset name)
   var (variable name)
Output: 
   writes 0 if the variable does not exist
   writes the vector position if the variable does exist
Example use: 
   %if %VarExist(data=bubbles,var=x) %then ...
--------------------------------------------------------------------------------------------------*/

%macro VarExist(data=,var=);

   %local dsid varnum rc;
   
   %let dsid = %sysfunc(open(&data)); 
   
   %if &dsid %then %do; 
      %let varnum = %sysfunc(varnum(&dsid,&var));
      %if &varnum %then 
         &varnum; 
      %else 
         0;
      %let rc = %sysfunc(close(&dsid));
   %end;
   
   %else 
      0;
   
%mend VarExist;


