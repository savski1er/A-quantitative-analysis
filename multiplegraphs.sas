/** The following is a maco that will print multiple graphics on the
    same page using the proc greplay command.

    After generating the graphics that you want use the macro
    to produce a page of graphics in N rows by X cols.

    The SAS option IMPLMAC must be set for this to work.

    usage:
       goptions nodisplay device=hp4si ;
       * Generate SAS graphics proc gchart, gmap, gplot etc... ;
       goptions reset=all targetdevice=hp4si ;
       _multg rows=N cols=X ;  ** This is the macro call ;
       * wher N and X are positive intergers indicating the 
         potential number of graphics on a page ;

    Original macro from Sung-Il Cho, Occupational Health Prograrm,
             Dept. Env. Health and & Dept. Epidemiology,
             Harvard School of Public Health

**/
%macro _multg(rows=1, cols=1) /stmt;  %* default row=1, column=1;
   %put Multiple graphics per page macro ;
   %put Sung-Il Cho - Harvard School of Public Health ;
   %put Modifications by Charles Burchill ;
   %put March 20, 1995 ;
proc greplay igout=gseg tc=tempcat nofs;
tdef template des="&rows by &cols graphs in one page"

 %do i=1 %to %eval(&rows); %do j=1 %to %eval(&cols);
%eval(&j+(&i-1)*(&cols))/
ulx=%eval(100*(&j-1)/(&cols))   uly=%eval(100*(&rows+1-&i)/(&rows))
urx=%eval(100*(&j)  /(&cols))   ury=%eval(100*(&rows+1-&i)/(&rows))
llx=%eval(100*(&j-1)/(&cols))   lly=%eval(100*(&rows-&i)  /(&rows))
lrx=%eval(100*(&j)  /(&cols))   lry=%eval(100*(&rows-&i)  /(&rows))
 %end; %end;
;

template template;
 treplay  %do i=1 %to %eval(&rows); %do j=1 %to %eval(&cols);
          %eval(&j+(&i-1)*&cols) : %eval(&j+(&i-1)*&cols)
          %end; %end;
 ;
run;
%mend _multg;

/*** Example run of this program ;
goptions nodisplay device=hp4 ;  *suppress terminal output;
 ** Use proc catalog to limit the graphics to the ones you want ;
 ** remove specific items from the gseg work catalog ;
 *proc catalog cat=gseg ;
 *    delete gchart gchart1 /entrytype=grseg ;
 *    run;
 *    quit ;
 ** remove the contents of the gseg work catalog ;
 proc catalog cat=gseg kill ;
     run; quit ;

options implmac ;

*** Set a library and test dataset ;
libname test '/PHIS/Hospital/1993_94/summdata' ;
data test;
   set test.a_hsp ;
   run;

** Generate a couple of graphics ;
proc gchart data=test;
   vbar region /sumvar = d_perso
                discrete sum ;
   run;
proc gchart data=test;
   vbar region /sumvar = d_perso
                discrete sum ;
   run; quit ;

** Redefine your goptions ;
goptions reset=all targetdevice=hp4 ;

** Generate a page of graphics;
_multg rows=2 cols=1 ;  *print graphs in 2 rows by 3 columns;

**/



