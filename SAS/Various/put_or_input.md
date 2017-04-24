Creation date : 24/04/2017  (fr)          
Last update : 24/04/2017    (fr)         
Author(s) : Nicolas DUPONT     
Contributor(s) :   
Tested with SAS 9.3  

---

#### Use Put() or Input() for converting variable types ?

---

The first things to do is to ask you what data you have and what you want in output !  

- You want to transforme a numeric value to character value => use Put()  
- You want to transforme a character value to a numeric value or another character value => use Input()

Put() always create character value. The source can be only numeric.   
Input() can produce both character and numeric value. But the source can be only character.  

Topics on SAS blog :
- [http://blogs.sas.com/content/sgf/2015/05/01/converting-variable-types-do-i-use-put-or-input/](http://blogs.sas.com/content/sgf/2015/05/01/converting-variable-types-do-i-use-put-or-input/)
- [http://blogs.sas.com/content/sastraining/2013/02/26/rhymes-mnemonics-and-tips-in-learning-sas/](http://blogs.sas.com/content/sastraining/2013/02/26/rhymes-mnemonics-and-tips-in-learning-sas/)

##### Examples :  

```sas
data _NULL_;

	/*---------*/
	/* Put() : */
	x = 2.23;
	y = put(x,4.2);
	l = lengthn(y);
	put y=;
	put l=;

	length e $10;
	e = "223";
	f = put(e,$10.);
	g = f||'aa';
	put g=;

	dd = 13122017; /*13DEC2017*/
	ff = input(put(dd,z8.),ddmmyy10.);
	format ff date9.;
	put ff=;

	cc = 01122017; /*01DEC2017*/
	hh = input(put(cc,z8.),ddmmyy10.);
	format hh ddmmyy10.;
	put hh=;

	ccc = 20170815; /*15AUG2017*/
	hhh = input(put(ccc,z8.),yymmdd10.);
	format hhh date9.;
	put hhh=;
	
	/*-----------*/
	/* Input() : */
	a = "22.23";
	b = input(a,comma5.);
	put b=;
	format c numx5.2;
	c = b + 1;
	put c=;

	aa = "22,23";
	bb = input(aa,numx5.);
	put bb=;
	format cc comma5.2;
	cc = bb + 1;
	put cc=;
	pp = cc;
	format pp numx5.2;
	put pp=;

	a = "10";
	b = input(a,4.);
	c = b + 1;
	put c=;
		
	h = "01JAN2017";
	i = input(h,date9.);
	format i ddmmyy10.;
	put i=;

	j = "28/02/2017";
	k = input(j,ddmmyy10.);
	format k date9.;
	put k=;
	
run;

```

##### Results :

	y=2.23
	l=4
	g=223       aa
	ff=13DEC2017
	hh=01/12/2017
	hhh=15AUG2017
	b=22.23
	c=23,23
	bb=22.23
	cc=23.23
	pp=23,23
	c=11,00
	i=01/01/2017
	k=28FEB2017
