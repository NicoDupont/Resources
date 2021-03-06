/*
Creation date : 29/03/2017  (fr)
Last update : 29/03/2017    (fr)
Author(s) : Nicolas DUPONT
Contributor(s) :
*/

/*  LAG -1 */
data test;
input id age grp ;
datalines;
1 10 1
2 20 1
3 30 1
4 40 1
5 50 1
1 10 2
2 20 2
3 30 2
4 40 2
5 50 2
;
run;

data test2;
_n_ ++ 1;
if _n_ le n then do;
set test point=_n_;
agem1=age;
end;
set test nobs=n;
run;

/*  LAG +1 */
data test;
input id age grp ;
datalines;
1 10 1
2 20 1
3 30 1
4 40 1
5 50 1
1 10 2
2 20 2
3 30 2
4 40 2
5 50 2
;
run;

data test2;
_n_ +- 1;
if _n_ le n then do;
set test point=_n_;
agem1=age;
end;
set test nobs=n;
run;
