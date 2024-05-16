Income Quintile Macro
                                       Version 2.00
                                      Shelley Derksen
	                     Manitoba Centre for Health Policy

                                       May 31, 1995
                                    Updated Dec 9,1998

This program is used to attach an income quintile value to a dataset.
Income quintiles are attached by postal code in strictly urban areas
and by municipality code in mixed urban/rural areas and strictly rural
areas.


Call:
   option implmac;
   _quint options;

   The macro is present in the autocall library so there is no need
   to %include any sas code.

Options:
     data=     Input data set name
     output=   Output Data set name (required)
     year=     Quintile Format Year (required)
               Valid years: 84-97
     muncode=  Municipal code variable name (default=muncode)
     postcode= Postal code variable name (default=postal)
     debug=    Toggle debugging feature (=debug/=nodebug(default))


Example Calls:
* Attach income quintiles to 1993 population file;
_quint data=cpe.pop93
       output=rank
       year=93
       muncode=muncode
       postcode=postcode
       debug=nodebug;


Notes:
The macro creates an output data set whose name is specified by the output=
parameter.  The new dataset is a copy of the input dataset with one new
variable added.  The new variable is called _rank_.  This variable can take on
the following values.

                 N1=Out of Province Municipality Code
                 N2=Out of Province Postal Code
                 N3=Postal Code of a Personal Care Home
                 N4=Postal Code of Other Institution
                 N5=Postal Code Missing Income
                 N6=Muncode Missing Income
                 N7=Post Code Not Present on Postal Code Conversion File
                 U1=Urban Quintile 1    <Lowest>
                 U2=Urban Quintile 2
                 U3=Urban Quintile 3
                 U4=Urban Quintile 4
                 U5=Urban Quintile 5    <Highest>
                 R1=Rural Quintile 1    <Lowest>
                 R2=Rural Quintile 2
                 R3=Rural Quintile 3
                 R4=Rural Quintile 4
                 R5=Rural Quintile 5    <Highest>

The value N1-N7 identify unrankable observations.  U1-U5 and R1-R5 are the income
quintile rankings within an urban/rural designation.  The urban/rural designation
is based on a census definition of urban/rural involving a population density rule.

The income quintile ranking is based upon the ranking of the Manitoba population
from 1984 to 1997.  The years are ranked by census estimates of average household
income according to the following table:

Year    Census
84      1986
85      "
86      "
87      "
88      "
89      1991
90      "
91      "
92      "
93      "
94      1996
95      "
96      "
97      "

A complete description of the method used to develop these rankings can be found
in the concept dictionary.

NOTE:  The macro creates three intermediate variables on the SAS dataset specified by the output
parameter.  These variables are _pch, _del and _pctype.  If you have a variable by any
of these names on your input dataset, they will be overwritten and dropped from the
output dataset.

This work follows in the footsteps of many previous brave pioneers including:
Cam Mustard and Ngiap Koh who took the first steps in understanding the 1986 census.
Teresa Mayer and Leonard McWilliam who continued the journey into the
1991 census.
