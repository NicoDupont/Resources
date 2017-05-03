/*------------------------------------*/
/* Creation date : 03/05/2017  (fr)   */
/* Last update :   03/05/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3 (Unix)           */
/*------------------------------------*/

/* Example data : */
data test;
	input nb;
	datalines;
1
2
2
3
4
5
6
7
8
9
10
11
12
13
14
37
38
39
40
41
42
88
89
;
run;


proc fcmp outlib=work.cat_function.test ;
	function IsPrime(Number);
		prime = 1;
		If (Number < 2 Or (Number ne 2 And Mod(Number,2) = 0) Or (Number ne Int(Number))) 
			Then 
				prime = 0;
			else do;
				do i = 3 To sqrt(Number) by 2;
					if Mod(Number,i) = 0 
						Then 
							prime = 0;
				end;
			end;
	    return(prime);
	endsub;
run;


options cmplib=work.cat_function;


/* Example : */
data test;
	set test;
	isprime = IsPrime(nb);
run;
