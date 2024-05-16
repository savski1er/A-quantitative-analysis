                           Life Expectancy Macro
                               Version 1.1
                           Leonard R. MacWilliam
              Manitoba Centre for Health Policy and Evaluation

                               April 8, 1997


This program is used to compute LIFE EXPECTANCY by GENDER and REGION .
By default the program computes life expectancy based on the mortality
experience over the most recent 5 years of Manitoba vital statistics.
This can be modified with an optional parameter (NYRS) supplied to the
program. The DEFAULT region is Regional Health Authority (RHA).

For methodology, please refer to:

** page 47 of "User's Guide to 40 Community Health Indicators"
** Published by: Community Health Division, Health Services & Promotion
** Branch,  Health & Welfare Canada, 1992.
** Minister of Supply & Services Canada 1992
** Cat. No. H39-238/1992E
** ISBN 0-662-19332-6

11 Feb. 1999 : Added new options to the macro which allow
               user to supply her/his own mortality data and
               population data (both must be SAS datasets) AND
               both must have variables named  AGE  and  SEX.

11 Sep 2000 : Added a comparison region definition and comparison
              value options (similar to pop_rate macro) to the _life
              macro call options so that a user can pass comparison
              area definitions to the pop_rate macro.


Macro Call:
   option implmac  nosource;
   %include '/home/lmacwil/healthstatus/concepts/_life.mac' ;
   option source ;

 _life   ;

Options:
    userdata= no / yes (OPTIONAL, DEFAULT=no). If the user sets this
             parameter to  yes  on the macro call it indicates to the
             program that the user has supplied the names of BOTH a
             SAS dataset containing mortality (see data= parameter)
             AND a SAS dataset containing population (see popdata=
             parameter below). Both of these
             datasets must contain the same REGION variable (see
             region= parameter below) and AGE and SEX.

     data= name of SAS dataset from which to extract mortality data
           (OPTIONAL, DEFAULT=cpe.vslk9512) or in which the mortality
           data is contained with the appropriate region, age & sex
           variables.

     popdata=  name of a SAS dataset containing population data.
             (OPTIONAL, no DEFAULT).

     out= name of dataset to which the life expectancy data is written
      (OPTIONAL, DEFAULT=life) NOTE: if you use a two level SAS name, eg.
          dsd.life, then you must have a libname statement in your
          program before the macro call (eg. Libname dsd '/dsd1/roos5';)

     startyr= four digit value representing the beginning YEAR from
             which to extract mortality records. (OPTIONAL, default=1991)
             Valid years: 1970-1995

     nyrs= number of CALENDAR years of mortality data to extract
           (OPTIONAL, default=5).    This parameter will
           cause the macro to extract  NYRS  calendar years of death
           records starting at Jan. 1 of STARTYR .

     region= name of an area variable for which the macro will compute
             life expectancy values. (OPTIONAL, DEFAULT=RHA).
             Options are:
               RHA - Regional Health Authorities (see: _rha macro)
               WPGAREA - 9 Winnipeg Areas (see: _wpg_reg macro)
               PARHA - Physician Service Areas (see: _parha macro)
               PARHA60 - Physician Service Areas including 9 Wpg areas
               _RANK_ - Winnipeg Urban Quintiles (see: _quint macro)

     compdef=  Definition comparison area which is used by the pop_rate
               macro to compute rates for. EG. compdef="region ne 'K'"
               would define a Non-Wpg area as a comparison area. See
               /cpe/maclib/pop_rate.docs for more details.
               NOTE: this parameter must be enclosed by double quotes.
               DEFAULT is no comparison area.

     compval= a value which is assigned to the comparison area which
              is defined by the previous macro parameter.
               DEFAULT is no comparison value.

     debug=  Toggle debugging feature (=debug/=nodebug(default))


Example Calls:

Libname  dsd  'dsd1/lmacwil/rha97' ;
_life     startyr=1993    out=dsd.life9395
           nyrs=3
           debug=no  ;  * compute life expectancy per Gender & RHA using
                     * 3 yrs of deaths: 1 Jan. 1993 to 31 Dec. 1995 *;

_life  ;   ** compute life expectancy using the 5 most recent yrs of  *;
            * deaths:  1 Jan. 1991 to 31 Dec. 1995  BY  RHA         *;

_life     out=dsd.lifewpgQ
          region=_rank_  ;
       ** compute life expectancy per Gender & Winnipeg Income
       ** Quintile, using the 5 most recent yrs of mortality. Save
       ** the results in a permanent SAS dataset

Notes:
BY default, this macro creates a temporary SAS dataset, named LIFE
containing the Life Expectancy values (LIFEEXP) plus other life table
calculations, using the most recent 5 yrs of death data. Results are by
Gender and (by default) Regional Health Authority (RHA).

By default the macro extracts death data from cpe.vslk9512 .

Also, the macro extracts  ALL CAUSE Mortality for both GENDERs.

After age=0, 5 year age group values are used in the computations.

The macro uses the _RHA macro to compute values for a region var. (RHA).
NOTE that it has collapsed the three Winnipeg areas (H, I, J) into a
single value K.  Also, it uses the _WPG_REG macro to create a second
area variable, named WPGAREA, containing the 9 Winnipeg sub-regions.
And, the _PARHA macro is used to produce a third area variable, named
PARHA, containing the 60 Physician Service areas contained within the
Regional Health Authorities.  A fourth area variable (named _RANK_) is
computed using the _QUINT macro. It contains the Income Quintile values.
PLEASE NOTE: if the region=_rank_ option is specified the _LIFE macro
will compute life expectancy values for ONLY The Winnipeg URBAN
Quintile Population.

From H&W's Users Guide to 40 Community Health Indicators:
- higher life expectancy is associated with better socioeconomic and
  health conditions. Life expectancy varies with marital status, gender,
  income, and geographical location.

- it is NOT affected by the age structure of the population

- time series enable us to see a decrease in premature mortality

- along with infant mortality, it is one of the most commonly used
  indicators of health status

- MORTALITY only gives info. on fatal illnesses; it does not supply info.
  on the number of sick individuals nor the importance of diseases that
  do not result in death.

LIMITATIONS:
- life expectancies calculated for a given period do not reflect only the
  mortality for that period. They may be influenced by past conditions or
  by the consequences of previous events (wars, epidemics), and this may
  cause a temporary increase in mortality in the upper age groups.

- the calculation is based on the hypothesis that the age-specific
  mortality observed is stable during a given period. When mortality
  decreases over time, the life expectancy obtained underestimates the
  true longevity.

USES:
- useful in planning and assessing the effectiveness of health care services
- comparisons over time and place.
