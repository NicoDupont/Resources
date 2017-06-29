/*------------------------------------
* Created :       29/06/2017  (fr)  
* Last update :   29/06/2017  (fr)   
* Author(s) : Nicolas Dupont         
* Contributor(s) : 		          
* Tested on SAS Studio 9.4 onDemand           
-------------------------------------*/


/*------------------------------------
 Sample data to test :
-------------------------------------*/

data test;
   input n1 n2 c1 $ c2 $ n3 c3 $;
datalines;
1 . A B 9999 C
. 2 Z Z 9998 A
1 2 A B 12 D
1 8 E F 23 G
;
run;


/*------------------------------------
 It can be interesting to perform one operation or more on all numeric or all character columns in a SAS data set.
 We can use the two key word : << _numeric_ >> and << _character_ >> to do that.
-------------------------------------*/

data test2 (drop=i);
   set test;
   
  /*2 arrays with names of all numeric columns or all character columns :*/
   array ColNum[*] _numeric_;    /*keyword _numeric_*/
   array ColChar[*] _character_; /*keyword _character_*/
  
  /*First loop on numeric variables*/
   do i = 1 to dim(ColNum);
      if ColNum[i] = 9999 then ColNum[i] = .;
      	else if ColNum[i] = . then ColNum[i] = 9999;
   end;
  /*Second loop on character variables*/
   do i = 1 to dim(ColChar);
      if ColChar[i] = "A" then ColChar[i] = "Z";
      	else if ColChar[i] = "Z" then ColChar[i] = "A";
   end;
   
   /*we don't need column "i"*/
   /*drop i;*/
run;
