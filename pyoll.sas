                   Potential Years of Life Lost Macro
                               Version 1.00
                           Leonard R. MacWilliam
              Manitoba Centre for Health Policy and Evaluation

                               April 18, 1997


This program is used to compute Potential Years of Life Lost by GENDER
and REGION and CAUSE of DEATH.
(NOTE: the macro's DEFAULTs are BOTH genders and region=RHA and cause of
death= ALL CAUSES)
By default, the program computes PYLL based on the mortality experience
over the most recent 3 years of Manitoba vital statistics. This can be
modified with an optional parameter (NYRS) supplied to the program.
The DEFAULT upper age limit is 75 (i.e. deaths defore age 75 contribute
to the PYLL). The user can use a different upper age limit by providing
a value to the MAXAGE parameter in the mcaro call.

For methodology, please refer to:

** page 112 of "User's Guide to 40 Community Health Indicators"
** Published by: Community Health Division, Health Services & Promotion
** Branch,  Health & Welfare Canada, 1992.
** Minister of Supply & Services Canada 1992
** Cat. No. H39-238/1992E
** ISBN 0-662-19332-6


Macro Call:
   option implmac  nosource;
   %include '/home/lmacwil/healthstatus/concepts/_pyll.mac' ;
   option source ;

 _pyll   ;

Options:
     data= name of dataset from which to extract mortality data
           (OPTIONAL, DEFAULT=cpe.vslk9512)

     out= name of dataset to which the life expectancy data is written
      (OPTIONAL, DEFAULT=pyll9395) NOTE: if you use a two level SAS name, eg.
          dsd.pyll9395, then you must have a libname statement in your
          program before the macro call (eg. Libname dsd '/dsd1/roos5';)

     startyr= four digit value representing the beginning YEAR from
             which to extract mortality records. (OPTIONAL, default=1993)
             Valid years: 1970-1995

     nyrs= number of CALENDAR years of mortality data to extract
           (OPTIONAL, default=3).    This parameter will
           cause the macro to extract  NYRS  calendar years of death
           records starting at Jan. 1 of STARTYR .

     popyr = 2 digit value representing the year of population data
             to be used. DEFAULT = 94 (i.e. cpe.pop94 dataset is used).
             NOTE: reccommend using the mid-year of the range of death
                   data used.

    stdpop = 2 digit value representing the year of population data the
             macro should use as the STANDARD popn. when computing
             standardized rates. DEFAULT is 92.

     region= name af an area variable for which the macro will compute
             potential years of life lost values. (OPTIONAL, DEFAULT=RHA).
             Options are:
               RHA - Regional Health Authorities (see: _rha macro)
               WPGAREA - 9 Winnipeg Areas (see: _wpg_reg macro)
               PARHA - Physician Service Areas (see: _parha macro)
               _RANK_ - Winnipeg Urban Quintiles (see: _quint macro)

     maxage = the upper age limit value to use in computing PYLL

     cause = the name of a variable which indicates a specified cause
             of death. Values of 0 or missing for this variable will
             cause the macro to NOT include that record in the calculations.
             The choices are:
             ALL -  all causes of death (DEFAULT)
             INJURY - accidental injury causes of death
             INFECT - death due to infectious diseases
             CANDTH - death due to all cancers
             CHRONIC - death due to selected major chronic diseases
             BCANCER - death due to Breast Cancer
             CCANCER - death due to Colon Cancer
             PCANCER - death due to Prostate Cancer
        NOTE: for detailed ICD-9 codes for these causes of death please
              refer to formats in /home/lmacwil/fmtlib/PHIS

     debug=  Toggle debugging feature (=debug/=nodebug(default))


Example Calls:

Libname  dsd  'dsd1/lmacwil/rha97' ;
_pyll     startyr=1993    out=dsd.pyll9395
           nyrs=3
           debug=no  ;  * compute P.Y.L.L. for both genders together &
                     * All Causes of death with Upper age = 75 & region
                * = RHA. Use 3 yrs of deaths: 1 Jan. 1993 to 31 Dec. 1995 *;
             * Save the results in a permanent dataset.  ***;

_pyll  ;   ** same as the 1st example except that the results are not
            * saved in a permanent dataset.                        *;

_pyll     out=dsd.pyllwpgQ   sex=males  cause=injury
          region=_rank_  ;
       ** compute P.Y.L.L.  for  MALES  and  cause of death = INJURY
       ** BY  Winnipeg Income Quintile, using the 3 most recent yrs of
       ** mortality. Save the results in a permanent SAS dataset. ****;

Notes:

By default the macro extracts death data from cpe.vslk9512 .

Also, the macro extracts  ALL CAUSE Mortality for both GENDERs.

The macro uses the _RHA macro to compute values for a region var. (RHA).
NOTE that it has collapsed the three Winnipeg areas (H, I, J) into a
single value K.  Also, it uses the _WPG_REG macro to create a second
area variable, named WPGAREA, containing the 9 Winnipeg sub-regions.
And, the _PARHA macro is used to produce a third area variable, named
PARHA, containing the 60 Physician Service areas contained within the
Regional Health Authorities.  A fourth area variable (named _RANK_) is
computed using the _QUINT macro. It contains the Income Quintile values.
PLEASE NOTE: if the region=_rank_ option is specified the _PYLL macro
will compute potantial years of life values for ONLY The Winnipeg URBAN
Quintile Population.

PYLL is an indicator of premature mortality. It gives more importance to
the causes of early death than those that appear in old age.

PYLL vary with certain characteristics: gender, socioeconomic status,
cause of death, geographical area.

The choice of upper age limit may depend on the objectives of the study:
end of adulthood, normal retirement age, etc.

Infant deaths are excluded for 2 reasons: these deaths are due to causes
that often have a different etiology from the deaths at later ages, and
each infant death would contribute approx. 70 years of lost life, double
the weighting of a death between ages 30 & 40.

USES:
 - provides a measure of the major causes of premature death
 - assessing community health research priorities
 - comparisons over time and place
