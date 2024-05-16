                 Socio-Economic Risk Indicator Macro
                            Version 1.00
                       Leonard R. MacWilliam
                  Manitoba Centre for Health Policy 

                           June  8, 1997


This program is used to compute Socio-Economic Risk Indicator socres
by  Region. By DEFAULT, SERI scores for the RHAs, treating Winnipeg as
a single RHA, are computed.  TWO variables (i.e SERI scores) are computed.
The first, SERI86 uses the 6 "normalized" (see below) census variable values
for 1986 in a SERI formula involving 6 coefficients from a multiple
regression analyses. The other, SERI8691, uses the 6 "normalized" census
variable values from the 1896 Census as well as the 6 "normalized" census
variable values from the 1991 Census in a formula involving 12 regression 
coefficients.

SERI scores using both the 1986 & 1991 data are most commonly used by
M.C.H.P. researchers.

The method for computing SERI scores involved :

1) computing 6 Census Variables (unemployment rate among ages 15-24;
unemployment rate among ages 45-54; the average value of a single detached
dwelling; the % of the population aged 25-34 with grade 12 education; the % of
women aged 15+ in the labour force; and % of families with only a female parent)
at the MCHP generated (as of December 1996) 60 Physician Service Areas (PARHAs)
which include the old (as of Jan. 2001) 9 Wpg Areas. Next, "normalize" (i.e.
PARHA level value MINUS the provincial mean DIVIDED BY the standard deviation of
the variable) these variables using the 60 data points (i.e. PARHAs).
 NOTE: this will give you slightly different values than if, for example,
 you "normalized" using 20 data points (i.e. regions) even if
 some of the regions were the same (eg. 9 Wpg Areas) on both datasets.

2) pluging these "normalized" values into the SERI formula (i.e. regression
   equations developed by Norm Frohlich & David Friesen) to get SERI scores.

   This will give you SERI scores for the 60 PARHAs.

3) If you need SERI scores for some other (higher) level of geography,
   RHAs for example, then .....
   NOTE: you can only compute SERI value for areas into which the 60 PARHAs (or
   a subset of them) can be combined.
 a) take the 60 PARHA level "normalized" census values and multiply
    each by the corresponding PARHA population to get "population weighted"
    values of the normalized census variables
 b) combine (i.e. sum) these 6 "population weighted" census values and the
    populations into the higher level of geography (eg. RHAs)
 c) compute new (eg. RHA) "normalized" census values by dividing the
    combined "population weighted" census values by the new (eg. RHA) population
    values.
 d) use these new "normalized" census values in the (same as step 2)
   SERI formula.

 This "final" method of computing SERI will give you the same SERI
scores for, say, the 9 Wpg Areas whether you compute SERI for these 9
Areas alone  or  as part of the 11 rural RHAs plus 9 Wpg Areas  or
as part of 51 rural PARHAs plus 9 Wpg Areas.  


For detailed SERI methodology, please contact:

    Norm Frohlich
    U. of Manitoba,  Department of Management
    666 Drake Centre, Fort Garry Campus
    Winnipeg, Manitoba
    phone: (204) 474-6385
    fax:   (204) 275-0181
    email: frohlic@ccu.umanitoba.ca


Macro Call:
   option implmac  nosource;
   %include '/home/lmacwil/healthstatus/concepts/_seri.mac' ;
   option source ;

 _seri   ;

Options:
     data86 = name of dataset from which to extract 1986 "normalized"
              census vars at the 60 PARHA level used in computing SERI.
              (OPTIONAL, DEFAULT=/home/lmacwil/SERI/census86/parha60.ssd01)

     data91 = name of dataset from which to extract 1991 "normalized"
              census vars at the 60 PARHA level used in computing SERI.
              (OPTIONAL, DEFAULT=/home/lmacwil/SERI/census91/parha60.ssd01)

     out= name of dataset to which the SERI scores are written.
      (OPTIONAL, DEFAULT=seri8691) NOTE: if you use a two level SAS name, eg.
          dsd.seri, then you must have a libname statement in your
          program before the macro call (eg. Libname dsd '/dsd1/roos5';)

     region= name af an area variable for which the macro will compute
             life expectancy values. (OPTIONAL, DEFAULT=RHA).
             Options are:
               RHA - Regional Health Authorities (see: _rha macro)
               WPGAREA - 9 Winnipeg Areas (see: _wpg_reg macro)
               PARHA - Physician Service Areas (see: _parha macro)

     debug=  Toggle debugging feature (=debug/=nodebug(default))


Example Calls:

Libname  dsd  'dsd1/lmacwil/rha97' ;
_seri      out=dsd.seri_rha
           debug=no  ;  * compute SERI per  RHA . Save in a permanent
                     * dataset. *;

_seri  ;   ** compute SERI per RHA. resulting dataset is not saved. *;

_seri     out=dsd.seri_par
          region=parha   ;
       ** compute SERI  per Phsycian Service Area. Save the output
       ** dataset as a permanent SAS dataset. ***;

Notes:
BY default, this macro creates a temporary SAS dataset, named SERI8691
containing the SERI scores (seri86 & ser8691).
Results are (by default) per Regional Health Authority (RHA).

By default the macro uses data from two datasets:
   /home/lmacwil/SERI/census86/parha60.ssd01
             &
   /home/lmacwil/SERI/census91/parha60.ssd01

These two datasets were developed through work with the various 1986
and 1991 census files, from which 6 variables were created at the 60
Physician Service Areas. See : /home/lmacwil/SERI/compute.seri.doc
AND   /home/lmacwil/SERI/seri_vars_parha60.sas     for details.

You may note that the datasets were originally placed in directories in
/dsd1/...    Since these directories tend to be "archived" preiodically,
I have copied them to the directories indicated above. NOTE: they may
move to another more "central" and permanent location.

