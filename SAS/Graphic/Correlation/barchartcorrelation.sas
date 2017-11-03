/*------------------------------------
* Last update :   03/11/2017  
* Author(s) : https://blogs.sas.com/content/iml/2017/08/16/pairwise-correlations-bar-chart.html
* Contributor(s) : 		          
* On SAS Studio 9.4M4 onDemand 
* Update :
-------------------------------------*/


ods listing gpath="/home/nicolasdupont0/resources_github/Graph/Correlation/img" image_dpi=200;




proc corr data=sashelp.Heart;      /* pairwise correlation */
   var _NUMERIC_;
   ods output PearsonCorr = Corr;  /* write correlations, p-values, and sample sizes to data set */
run;

proc iml;

use Corr;
   read all var "Variable" into ColNames;  /* get names of variables */
   read all var (ColNames) into mCorr;     /* matrix of correlations */
   ProbNames = "P"+ColNames;               /* variables for p-values are named PX, PY, PZ, etc */
   read all var (ProbNames) into mProb;    /* matrix of p-values */
close Corr;

numCols = ncol(mCorr);                /* number of variables */
numPairs = numCols*(numCols-1) / 2;
length = 2*nleng(ColNames) + 5;       /* max length of new ID variable */
PairNames = j(NumPairs, 1, BlankStr(length));
i = 1;
do row= 2 to numCols;                 /* construct the pairwise names */
   do col = 1 to row-1;
      PairNames[i] = strip(ColNames[col]) + " vs. " + strip(ColNames[row]);
      i = i + 1;
   end;
end;
 
lowerIdx = loc(row(mCorr) > col(mCorr));  /* indices of lower-triangular elements */
Corr = mCorr[ lowerIdx ];
Prob = mProb[ lowerIdx ];
Significant = choose(Prob > 0.05, "No ", "Yes");  /* use alpha=0.05 signif level */
 
create CorrPairs var {"PairNames" "Corr" "Prob" "Significant"};
append;
close;
QUIT;


proc sort data=CorrPairs;  by Corr;  run;
 
*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=800px height=800px 
	imagename = "barchartcorrelation1" imagefmt = png outputfmt = png antialiasmax = 10000;

proc sgplot data=CorrPairs;
	title "Pairwise Correlations";
	hbar PairNames / response=Corr group=Significant;
	refline 0 / axis=x;
	yaxis discreteorder=data display=(nolabel) 
	      labelattrs=(size=6pt) fitpolicy=none 
	      offsetmin=0.012 offsetmax=0.012  /* half of 1/k, where k=number of catgories */
	      colorbands=even colorbandsattrs=(color=gray transparency=0.5);
	xaxis grid display=(nolabel);
	keylegend / position=topright location=inside across=1;
run;


*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=800px height=800px 
	imagename = "barchartcorrelation3" imagefmt = png outputfmt = png antialiasmax = 10000;

proc sgplot data=CorrPairs;
	title "Pairwise Correlations";
	hbar PairNames / response=Corr group=Significant;
	refline 0 / axis=x;
	yaxis discreteorder=data display=(nolabel) 
	      labelattrs=(size=6pt) fitpolicy=none 
	      offsetmin=0.012 offsetmax=0.012  /* half of 1/k, where k=number of catgories */
	      colorbands=even colorbandsattrs=(color=gray transparency=0.5);
	xaxis grid display=(nolabel) min=-1 max=1;
	keylegend / position=topright location=inside across=1;
run;

*-----------------------------------------------------------------;
ods graphics / 
	reset = all attrpriority=color border = no width=1000px height=600px 
	imagename = "barchartcorrelation3" imagefmt = png outputfmt = png antialiasmax = 10000;

proc sgplot data=CorrPairs;
	title "Pairwise Correlations";
	vbar PairNames / response=Corr group=Significant;
	refline 0 / axis=x;
	yaxis discreteorder=data display=(nolabel) 
	      labelattrs=(size=6pt) fitpolicy=none 
	      offsetmin=0.012 offsetmax=0.012 /* half of 1/k, where k=number of catgories */
	      colorbands=even colorbandsattrs=(color=gray transparency=0.5) /*min=-1 max=1*/;
	xaxis grid display=(nolabel) ;
	keylegend / position=topright location=inside across=1;
run;





