/*------------------------------------*/
/* Creation date : 18/04/2017  (fr)   */
/* Last update :   18/04/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3                  */
/*------------------------------------*/


%macro SearchString(string);
	string ="&string.";
	test=index(compress(upcase(_infile_)), compress(upcase("&string.")));
	if test = 1 
		then do; 
			message=_infile_;
			type="&string.";
			output;
		end;
%mend;

%macro ScanLog(LogFile);
	%if %sysfunc(fileexist("&LogFile."))
	%then %do;
		data result_scan (drop=test fw string);
			Format type $10.;
			Length message $ 200;
			Format message $200.;
			retain line 0;

			infile "&LogFile." truncover;
			input;  
			
			line ++ 1;
			fw=scan(_infile_,1,'20'x);
			if substr(fw, length(fw))=':' then; else goto endstep;

			/* Looking for ERROR or WARNING in a log file */
			*%SearchString(string=NOTE:);
			%SearchString(string=ERROR:);
			%SearchString(string=WARNING:);
			
			endstep:;
		run;
	%end;
	%else %do;
		put " Log File do not exist ! ";
	%end;
%mend ScanLog;


%ScanLog(PathToYourLog);
