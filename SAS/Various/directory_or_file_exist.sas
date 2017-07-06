/*------------------------------------
* Created :       06/07/2017  (fr)  
* Last update :   06/07/2017  (fr)   
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* Tested on SAS Studio 9.4 onDemand           
-------------------------------------*/


/*Directory or file exist :*/

/*#1*/
%macro DirExist(dir) ; 
	%if %sysfunc(fileexist(&dir))  
		%then %let return=1;    
		%else %let return=0;
	&return;
%mend DirExist;

/*return 1*/
%put %DirExist(/home/nicolasdupont0/resources_github);
%put -------------------;
/*return 0*/
%put %DirExist(/home/nicolasdupont0/resources_github2);
%put -------------------;

/*return 1*/
%put %DirExist(/home/nicolasdupont0/resources_github/directory_or_file_exist.sas);
%put -------------------;
/*return 0*/
%put %DirExist(/home/nicolasdupont0/resources_github/directory_or_file_exist2.sas);
%put -------------------;

/*#2*/
%macro DirExist2(dir); 
   %LOCAL rc fileref res; 
   %let rc = %sysfunc(filename(fileref,&dir)) ; 
   %if %sysfunc(fexist(&fileref))  
   	%then 
   		%let res=1;    
   	%else 
   		%let res=0;
   &res
%mend DirExist2;

/*return 1*/
%put %DirExist2(/home/nicolasdupont0/resources_github);
%put -------------------;
/*return 0*/
%put %DirExist2(/home/nicolasdupont0/resources_github2);
%put -------------------;

/*return 1*/
%put %DirExist2(/home/nicolasdupont0/resources_github/directory_or_file_exist.sas);
%put -------------------;
/*return 0*/
%put %DirExist2(/home/nicolasdupont0/resources_github/directory_or_file_exist2.sas);
%put -------------------;


/*Create directory if directory not exist :*/

/* 
# The LIBNAME statement option :
With the option dlcreatedir, he is possible to automaticaly create a folder with the LIBNAME statement 
*/
options dlcreatedir;
libname t1 "/home/nicolasdupont0/resources_github/test1";
libname t2 "/home/nicolasdupont0/resources_github/test2";
/* we don't need those libnames */
libname t1 clear;
libname t2 clear;

/*-------------------------------------------
Log results :

 126        options dlcreatedir;
 127        libname t1 "/home/nicolasdupont0/resources_github/test1";
 NOTE: La bibliothèque T1 a été créée.
 NOTE: Libref T1 was successfully assigned as follows: 
       Engine:        V9 
       Physical Name: /home/nicolasdupont0/resources_github/test1
 128        libname t2 "/home/nicolasdupont0/resources_github/test2";
 NOTE: La bibliothèque T2 a été créée.
 NOTE: Libref T2 was successfully assigned as follows: 
       Engine:        V9 
       Physical Name: /home/nicolasdupont0/resources_github/test2
 130        libname t1 clear;
 NOTE: Libref T1 has been deassigned.
 131        libname t2 clear;
 NOTE: Libref T2 has been deassigned.
--------------------------------------------*/


/* # Commande line option : */
%macro CreateDir(path); 
	data _NULL_;
		call system("mkdir &path."); /*something like that..*/
	run;
%mend CreateDir; 

/* I actually can't test because I cannot execute command line on sas studio*/
*%CreateDir(/home/nicolasdupont0/resources_github/test3) ;


