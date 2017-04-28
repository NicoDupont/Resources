/*------------------------------------*/
/* Creation date : 28/04/2017  (fr)   */
/* Last update :   28/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3                  */
/*------------------------------------*/

/*-----------------------------------------------------*/
/*  Examples with putn()/putc() and inputn()/inputc()  */
* Put and input cannot be used in %sysfunc. 			;
* But you can use putn()/putc() or inputn()/inputc()    ;
/* 
putn()/putc() :
formatted-val=PUTC(char-val,format);
formatted-val=PUTN(num-val,format);

inputn()/inputc() :
char-value=INPUTC(char-string,char-informat);
num-value=INPUTN(char-string,num-informat);
*/

%put &sysdate;
/* Get the numeric value from the sysdate macro-variable : */
%let TODAY=%sysfunc(inputn("&sysdate"d,date9.));
%put &TODAY;
/* Put the numeric value in character : */
%let TODAY=%sysfunc(putn(&TODAY,date9.));
%put &TODAY;

/* Get the numeric value from today() : */
%let TODAY=%sysfunc(today());
%put &TODAY;
/* Put the numeric value in character : */
%let TODAY=%sysfunc(putn(&TODAY,date9.));
%put &TODAY;

/* Results :

%put &sysdate;
28APR17
%let TODAY=%sysfunc(inputn("&sysdate"d,date9.));
%put &TODAY;
20937
%let TODAY=%sysfunc(putn(&TODAY,date9.));
%put &TODAY;
28APR2017
%let TODAY=%sysfunc(today());
%put &TODAY;
20937
%let TODAY=%sysfunc(putn(&TODAY,date9.));
%put &TODAY;
28APR2017

*/


/*-------------------------*/
/* with time() or &systime */

%put &systime;
%let TIME=%sysfunc(putn("&systime"t,TIME10.));
%put &TIME;
/* Convert to numeric time : */
%let TIME=%sysfunc(inputn(&TIME,TIME5.));
%put &TIME;
/* Print only HHMM */
%let TIME2=%substr(%sysfunc(putn(&TIME,B8601TM.)),1,4);
%put &TIME2;
/* Add 120 seconds */
%let TIME= %sysevalf(&TIME+120);
%put &TIME;
/* Print only HHMM */
%let TIME=%substr(%sysfunc(putn(&TIME,B8601TM.)),1,4);
%put &TIME;

%let TIME=%sysfunc(time());
%put &TIME;
/* Print only HHMM */
%let TIME=%substr(%sysfunc(putn(&TIME,B8601TM.)),1,4);
%put &TIME;
/* Add 60 seconds */
%let TIME= %sysevalf(%sysfunc(time())+60);
%put &TIME;
/* Print only HHMM */
%let TIME=%substr(%sysfunc(putn(&TIME,B8601TM.)),1,4);
%put &TIME;


%let TIME=%sysfunc(putn("10:50:21"t,TIME5.));
%put &TIME;
%let TIME=%sysfunc(putn("10:50:21"t,TIME10.));
%put &TIME;


/* Results :

%put &systime;
10:04
%let TIME=%sysfunc(putn("&systime"t,TIME10.));
%put &TIME;
10:04:00
%let TIME=%sysfunc(inputn(&TIME,TIME5.));
%put &TIME;
36240
%let TIME2=%substr(%sysfunc(putn(&TIME,B8601TM.)),1,4);
%put &TIME2;
1004
%let TIME= %sysevalf(&TIME+120);
%put &TIME;
36360
%let TIME=%substr(%sysfunc(putn(&TIME,B8601TM.)),1,4);
%put &TIME;
1006
   
 
%let TIME=%sysfunc(time());
%put &TIME;
42138.8577320575
%let TIME=%substr(%sysfunc(putn(&TIME,B8601TM.)),1,4);
%put &TIME;
1142
%let TIME= %sysevalf(%sysfunc(time())+60);
%put &TIME;
42198.8580379486
%let TIME=%substr(%sysfunc(putn(&TIME,B8601TM.)),1,4);
%put &TIME;
1143


%let TIME=%sysfunc(putn("10:50:21"t,TIME5.));
%put &TIME;
10:50
%let TIME=%sysfunc(putn("10:50:21"t,TIME10.));
%put &TIME;
10:50:21

*/

/* Example with a num format : */
proc format ;
	value income
	0 -< 1000 ='small'
	1000 - high ='big';
run;

/* equivalent :
proc format ;
	value income
	low -< 1000 ='small'
	1000 - high ='big';
run;
*/

%let salary = 1234;
%put --------------------; 
%put %sysfunc(putn(&salary,income.));


/* Results :

%let salaire = 1234;
%put --------------------;
--------------------
%put %sysfunc(putn(&salaire,income.));
big

*/
