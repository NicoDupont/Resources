/*
* https://blogs.sas.com/content/sasdummy/2013/06/12/correlations-matrix-heatmap-with-sas/ 
*/

/* Prepare the correlations coeff matrix: Pearson's r method */
%macro prepCorrData(in=,out=);
		/* Run corr matrix for input data, all numeric vars */
		proc corr data=&in. noprint
			pearson
			outp=work._tmpCorr
			vardef=df
		;
		run;
	
		/* prep data for heatmap */
	data &out.;
		keep x y r;
		set work._tmpCorr(where=(_TYPE_="CORR"));
		array v{*} _numeric_;
		x = _NAME_;
		do i = dim(v) to 1 by -1;
			y = vname(v(i));
			r = v(i);
			/* creates a diagonally sparse matrix */
			if (i<_n_) then
				r=.;
			output;
		end;
	run;
	
	proc datasets lib=work nolist nowarn;
		delete _tmpcorr;
	quit;
%mend;