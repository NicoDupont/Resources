/*------------------------------------
* Created :       21/08/2017  (fr)  
* Last update :   26/08/2017  (fr)   
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* Tested on SAS Studio 9.4 onDemand        
-------------------------------------*/

/*Données à insérer :*/
data sasdata;
   input col1 $ col2 $;
datalines;
AAA 10
BBB 11
CCC 10
DDD 29
EEE 44
FFF 86
;
run;

/*table vide*/
proc sql noprint;
create table table2
(
var1 char 3,
var2 char 2
);
quit;


%macro inserttab(var1,var2);
   proc sql;
      insert into table2 (var1,var2) values ("&var1.","&var2.");
   run;
%mend inserttab;

data _null_;
   set sasdata;
   call execute('%inserttab('||col1||','||col2||')');
run;
