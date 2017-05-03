/*------------------------------------*/
/* Creation date : 03/05/2017  (fr)   */
/* Last update :   03/05/2017  (fr)   */
/* Author(s) : Nicolas DUPONT         */
/* Contributor(s) : 		          */
/* Tested on SAS 9.3 (Unix)           */
/*------------------------------------*/

/*
1 - SquarePerimeter() --- returns the perimeter of a cube or a rectangle
2 - SquareArea() -------- returns the area of a cube or a rectangle
3 - VolumeCube() -------- returns the volume of a cube or a rectangle
4 - CirclePerimeter() --- returns the perimeter of a cube or a rectangle
5 - CircleArea() -------- returns the area of a cube or a rectangle
6 - VolumeSphere() ------ returns the volume of a sphere
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

/* Example : */
data test;
	set test;
	SqPeri = SquarePerimeter(nb,nb1);
	SqArea = SquareArea(nb,nb1);
	VolCube = VolumeCube(nb,nb1,nb2);
	CirPeri = CirclePerimeter(nb);
	CirArea = CircleArea(nb);
	VolSphere = VolumeSphere(nb);
run;
