/*------------------------------------*/
/* Creation date : 03/05/2017  (fr)   */
/* Last update :   04/05/2017  (fr)   */
/* Author(s) : Nicolas Dupont         */
/* Contributor(s) : 		      */
/* Tested on SAS Studio 9.4           */
/*------------------------------------*/

/*
1  - SquarePerimeter() -------- returns the perimeter of a cube or a rectangle
2  - SquareArea() ------------- returns the area of a cube or a rectangle
3  - VolumeCube() ------------- returns the volume of a cube or a rectangle
4  - CirclePerimeter() -------- returns the perimeter of a cube or a rectangle
5  - CircleArea() ------------- returns the area of a cube or a rectangle
6  - VolumeSphere() ----------- returns the volume of a sphere
7  - IsRightTriangle() -------- returns 1 if the triangle is right
8  - IsIsoscelesTriangle() ---- returns 1 if the triangle is isosceles
9  - IsEquilateralTriangle() -- returns 1 if the triangle is equilateral
10 - TriangleArea() ----------- returns the area of a triangle
*/


dm log 'clear';
dm lst 'clear';
/*dm log 'preview';*/

/*
proc datasets library=work mt=data kill nolist;
quit;
*/

/* Example data : */
data test;
	input nb nb1 nb2;
	datalines;
10 12 10
37 13 5
38 15 9
39 5 16
40 8 4
41 9 8
42 12 7
2 13 9
1 14 4
5 6 5
50 8 12
1 2 1
1 2 3
2 3 4
3 4 5
5 4 3
1 2 5
1 1 2
6 8 10
2 2 2
;
run;

options cmplib=work.cat_function;

/*-----------------------*/
/* 1 - SquarePerimeter() */
/*-----------------------*/

proc fcmp outlib=work.cat_function.test ;
	function SquarePerimeter(La,Lo);
		res = (La + Lo) * 2;
	    return(res);
	endsub;
run;

/*------------------*/
/* 2 - SquareArea() */
/*------------------*/

proc fcmp outlib=work.cat_function.test ;
	function SquareArea(La,Lo);
		res = (La * Lo);
	    return(res);
	endsub;
run;

/*------------------*/
/* 3 - VolumeCube() */
/*------------------*/

proc fcmp outlib=work.cat_function.test ;
	function VolumeCube(La,Lo,H);
		res = (La * Lo * H);
	    return(res);
	endsub;
run;

/*------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------*/

/*-----------------------*/
/* 4 - CirclePerimeter() */
/*-----------------------*/

proc fcmp outlib=work.cat_function.test ;
	function CirclePerimeter(R);
		pi=constant("pi");
		res = 2 * pi * R;
	    return(res);
	endsub;
run;

/*------------------*/
/* 5 - CircleArea() */
/*------------------*/

proc fcmp outlib=work.cat_function.test ;
	function CircleArea(R);
		pi=constant("pi");
		res = pi * ( R ** 2 );
	    return(res);
	endsub;
run;

/*--------------------*/
/* 6 - VolumeSphere() */
/*--------------------*/

proc fcmp outlib=work.cat_function.test ;
	function VolumeSphere(R);
		pi=constant("pi");
		res = (4 * pi * (R ** 3)) / 3;
	    return(res);
	endsub;
run;

/*------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------*/

/*-----------------------*/
/* 7 - IsRightTriangle() */
/*-----------------------*/

proc fcmp outlib=work.cat_function.test ;
	function IsRightTriangle(A,B,C);
		A = A ** 2;
		B = B ** 2;
		C = C ** 2;
		smax = max(A,B,C);
		if smax = C 
			then res = A + B - C;
			else if smax = B 
					then res = A + C - B;
					else res = B + C - A;
		if res=0
			then res=1;
			else res=0;
	return(res);
	endsub;
run;

/*---------------------------*/
/* 8 - IsIsoscelesTriangle() */
/* 
We start from the assumption 
that we know that the 3 lengths 
can form a triangle
*/
/*---------------------------*/

proc fcmp outlib=work.cat_function.test ;
	function IsIsoscelesTriangle(A,B,C);
		if (A = B or B = C or C = A)
			then res=1;
			else res=0;
	return(res);
	endsub;
run;

/*-----------------------------*/
/* 9 - IsEquilateralTriangle() */
/*-----------------------------*/

proc fcmp outlib=work.cat_function.test;
	function IsEquilateralTriangle(A,B,C);
		if (A = B and B = C)
			then res=1;
			else res=0;
	return(res);
	endsub;
run;

/*---------------------*/
/* 10 - TriangleArea() */
/*---------------------*/

proc fcmp outlib=work.cat_function.test;
	function TriangleArea(C1,C2,C3);
		/* Heron's formula */
		/*
		s = (A + B + C) / 2;
		put s=;
		res = s * (s - A) * (s - B) * (s - C);
		put res=;
		if res<=0
			then res=.;
			else res = sqrt(res); 
		put res=;
		*/
		/*sort sides of the triangle :*/
		/*
		if A > B 
			then do; 
				if C > A
					then do; 
						c1=B; c2=A; c3=C; 
					end;
					else do;
						if C > B 
							then do; c1=B; c2=C; c3=A; end;
							else do; c1=C; c2=B; c3=A; end;
					end;
			end;
			else do;
				if C > B
					then do;
						c1=A; c2=B; c3=C;
					end;
					else do;
						if C > A 
							then do;c1=A; c2=C; c3=B; end;
							else do;c1=C; c2=A; c3=B; end;
					end;
			end;
		*/
		/*sort sides of the triangle : (easy way)*/ 
		call sortn(C1,C2,C3);
		/* compute area :*/
		t1 = (c1+(c2+c3)) * (c3-(c1-c2)) * (c3+(c1-c2)) * (c1+(c2-c3));
		put t1=;
		if t1<=0
			then res=.;
			else do;
				res = (t1 ** 0.5) * 0.25;
			end;
	return(res);
	endsub;
run;


/* Examples : */
data test;
	set test;
	SqPeri = SquarePerimeter(nb,nb1);
	SqArea = SquareArea(nb,nb1);
	VolCube = VolumeCube(nb,nb1,nb2);
	CirPeri = CirclePerimeter(nb);
	CirArea = CircleArea(nb);
	VolSphere = VolumeSphere(nb);
	Rtriangle = IsRightTriangle(nb,nb1,nb2);
	Itriangle = IsIsoscelesTriangle(nb,nb1,nb2);
	Etriangle = IsEquilateralTriangle(nb,nb1,nb2);
	Tarea = TriangleArea(nb,nb1,nb2);
run;
