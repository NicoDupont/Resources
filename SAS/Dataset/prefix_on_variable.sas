/*------------------------------------*/
/* Creation date : 09/04/2017  (fr)   */
/* Last update :   09/04/2017  (fr)   */
/* Author(s) : 	[Céline G](https://github.com/CelineGuilbert/SAS)	*/
/* Contributor(s) : 		              */
/* Not tested                         */
/*------------------------------------*/


data class ;
  set sashelp.class ;
run ;

proc contents data=class noprint out=_contents ;
run ;


data _null_ ;
  set _contents end=LAST;
    if _n_=1 then call execute ('proc datasets lib=WORK ;   modify CLASS ; rename ') ;
    call execute ( compress (name) !! '=' !! compress ('TXT_' !! name) );
    if last then call execute (';quit;');
run ;
