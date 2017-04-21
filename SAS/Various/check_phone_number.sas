/*------------------------------------*/
/* Creation date : 21/04/2017  (fr)   */
/* Last update :   21/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS Unix 9.3.0.0         */
/*------------------------------------*/

/*
A sas macro to compute if a FR phone number is valid or not.
It can be improved with better regex and better data in entry.
*/

/* Data for testing : */
data test;
   infile cards;
   input phone $17.;
cards;
0675896354
075896354
06-75-89-63-54
06-75-8963-54
06/75/89/63/54
06/75/8/63/54
06 75 89 63 54
06 75 89 63 5
+33675896354
675896354
(+33)675896354
[+33]675896354
[33]675896354
(+33675896354
0675896354
0775896354
0375896354
0475896354
1111111111
0000000000
2222222222
3333333333
33333333333
33333333332
4444444444
5555555555
6666666666
66666666662
7777777777
8888888888
9999999999
0123456789
01:23456789
01A23456789
01A2345678b
01é23456780
O123456789
0123456789
07'5896354
077589635!
077589635?
0_23456789
33675896354
00775896354
03775896354
;
run;


/*  Valid or not with the pattern function : */
/*
data validate;
   set test;
   pattern = translate(phone, '0000000000', '0123456789','+00000000000');
   if pattern in ('00-00-00-00-00', '0000000000','00 00 00 00 00', 
                  '00/00/00/00/00', '+00000000000', '(+00)000000000') then 
      valid = '1';
   else
      valid = '0';
 
   put (_all_) (=);
 
run;
*/

%macro ValidPhoneNumberFr(dataset,phone);

	data &DATASET. (drop=test2 test3 test4);
		set &DATASET.;
		
		length PhoneRemodeled $16;
		format PhoneRemodeled $16.;
		PhoneRemodeled = compress(&PHONE);

		/* 1# - Find and replace special characters or punctuation */
		if prxmatch("/[\{\}\[\]\(\)\^\$\.\|\*\+\?]/",PhoneRemodeled) > 0 
		or prxmatch("/[+;:,'`&!%-]/",PhoneRemodeled) > 0
		or prxmatch("/\\|\/|\_|\€|\&/",PhoneRemodeled) > 0
		or prxmatch("/[']/",PhoneRemodeled) > 0 
			then do;
				PhoneRemodeled = translate(PhoneRemodeled,'','-_/\()[]+|?!&"#`^°*$:;,$€%');
				PhoneRemodeled = compress(tranwrd(PhoneRemodeled, "'", ""));
			end;
		/* Replace ponctuation */
		if prxmatch("/[éàèçüôòûùêä]/",PhoneRemodeled) > 0
			then do;
				PhoneRemodeled = tranwrd(PhoneRemodeled, "é", "e");
				PhoneRemodeled = tranwrd(PhoneRemodeled, "à", "a");
				PhoneRemodeled = tranwrd(PhoneRemodeled, "ä", "a");
				PhoneRemodeled = tranwrd(PhoneRemodeled, "è", "e");
				PhoneRemodeled = tranwrd(PhoneRemodeled, "ç", "c");
				PhoneRemodeled = tranwrd(PhoneRemodeled, "ü", "u");
				PhoneRemodeled = tranwrd(PhoneRemodeled, "û", "u");
				PhoneRemodeled = tranwrd(PhoneRemodeled, "ù", "u");
				PhoneRemodeled = tranwrd(PhoneRemodeled, "ê", "e");
				PhoneRemodeled = tranwrd(PhoneRemodeled, "ô", "o");
				PhoneRemodeled = tranwrd(PhoneRemodeled, "ò", "o");
				PhoneRemodeled = compress(PhoneRemodeled);
			end;

		/* 2# - Top phone number like "0000000000","1111111111" */
    	if prxmatch('/^([0-9])(\1{9})$/',strip(PhoneRemodeled)) > 0 
			then test2 = 1; 
			else test2 = 0;
		if prxmatch('/^([0-9])(\1{10})$/',strip(PhoneRemodeled)) > 0 
			then test2 = 1; 

		/* 3# - Top phone number with letters */
    	if prxmatch('/[a-zA-Z]/',strip(PhoneRemodeled)) > 0 
			then test3 = 1; 
			else test3 = 0;

		/* 4# - Top phone number < 10 or > 11 */
    	if lengthn(PhoneRemodeled) < 10 or lengthn(PhoneRemodeled) > 11 
			then test4 = 1; 
			else test4 = 0;

		/* 5# - Concatenate with 3 in front of the phone number il length = 10 and the first character is equal to '3' */
		if lengthn(PhoneRemodeled) = 10 and substr(PhoneRemodeled,1,1) = '3' 
			then PhoneRemodeled='3'||PhoneRemodeled;

		/* 6# - Replace the first character if he is equal to '0' */
		if lengthn(PhoneRemodeled) = 10 and substr(PhoneRemodeled,1,1) = '0' 
			then PhoneRemodeled='33'||substr(PhoneRemodeled,2,lengthn(PhoneRemodeled)-1);

		/* 7# - Replace the first two characters if they are equal to '00' or '03' or '30' */
		if lengthn(PhoneRemodeled) = 11 and (substr(PhoneRemodeled,1,2) = '00' or substr(PhoneRemodeled,1,2) = '03' or substr(PhoneRemodeled,1,2) = '30') 
			then PhoneRemodeled='33'||substr(PhoneRemodeled,3,lengthn(PhoneRemodeled)-2);
		
		/* Compute a variable to keep the final result */
		if  sum(of test2-test4) > 0
			then valid = "KO";
			else valid = "OK";
	run;

%mend ValidPhoneNumberFR;


/* Example with the dataset "test" */
%ValidPhoneNumberFr(test,phone);
