/*------------------------------------*/
/* Creation date : 05/05/2017  (fr)   */
/* Last update :   05/05/2017  (fr)   */
/* Author(s) : Nicolas Dupont         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3 (Unix)           */
/*------------------------------------*/

/*
How to sort multiples columns horizontally
*/

/* Example data (num data) : */
data test;
	input nb1 nb2 nb3 nb4 nb5 nb6;
	datalines;
1 3 5 8 9 4
3 8 4 6 9 5
0 1 2 3 4 5
6 5 4 3 2 1
6 4 2 1 8 7
;
run;

data test2;
	set test;
	call sortn(nb1,nb2,nb3,nb4,nb5);
run;

data test3;
	set test;
	call sortn(of nb1-nb5);
run;


data _null_;
   array x(7) (0,6,5,7,1,3,2);
   call sortn(of x(*));
   put +3 x(*);
run;

/*
Log :  0 1 2 3 5 6 7
*/



/* Example data (char data) : */
data test;
	input ch1 $ ch2 $ ch3 $ ch4 $ ch5 $ ch6 $;
	datalines;
AB BC VG ZK AK PL
JH IC VG ZK AK ML
;
run;

/* Sort on 1# letter in string : */
data test2;
	set test;
	call sortc(ch1,ch2,ch3,ch4,ch5);
run;
