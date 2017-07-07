
options minoperator;
%macro putme(name=) / mindelimiter=',';
	%if %lowcase(&name) in alice,alfred,barbara %then %put &name is in the list;
	   %else %put name is NOT in the list;
%mend;
 
%putme(name=Alice)
%putme(name=Buddy)
