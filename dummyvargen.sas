                  Dummy Variable Generation Macro
                    Version 2.0 - Jan. 22, 1996
                 Charles Burchill, Julie Horrocks
          Manitoba Centre for Health Policy and Evaluation

This macro may be used to generate a series of dummy variables (value
1/0) on a data set based on the values of a variable(s).

     Usage:
         _dumvar <options> ;
         Options:
            data=   SAS data set name. [required]
            out=    SAS output data set name.
                    If missing will default to the input data set name.
            dvar=   Variables to use when generating dummy
                    variables. Multiple variables may be passed
                    in a quoted string. There must be a matching
                    prefix for each. These variables must not contain
                    any missing values.
                    The global macro variable &dvars contains a list
                    of all the dummy variables generated.
                     [required]
            prefix= Prefix to use on dummy variable names.
                    First character must be A-Z and it must be at least
                    1 character long. You must pass a separate
                    prefix for each variable in the dvar= list. If multiple
                    variables are used this string must be quoted
                    [required]
            inter=  Generate interaction terms between the dvar
                    variables. Use the format VAR1*VAR2.
                    Currently you can only generate
                    pairwise interactions (e.g. age*hsp).
                    The program will generate an interaction variable
                    based on the value in each interaction.  If this
                    option is used the combined total length of the
                    prefix and value for each interaction must be
                    less than 8 characters.  You may pass multiple 
                    pairwise interactions in quotes 
                    (e.g. inter='age*hsp rvw*sex').
                    The global macro variable &inters contains a list
                    of all the interaction terms, minus the dropped 
                    combinations.
            drop=   Drop one or more of the dummy variables.
                    The dummy variables have the given prefix followed
                    by the value you want to drop (e.g. hsp81, where
                    hsp is the prefix, 81 is the value).  If you
                    want to drop  multiple variables the list must be
                    in a quoted string. Note: You can not drop 
                    interaction dummy variables.

    Output:
         A new variable for each value of the input variables (dvar=) will
         be generated along with all of the specified interactions.
         These variables will contain a 1 where value of the input
         variable and the dummy variable name match, and 0 where they do not.

         Two global macro variables are generated (&dvars, &inters).
         These macro variables contain the list of dummy and interaction
         data set variables that the macro generated.
         They may be used in a model statement of a subsequent
         procedure without having to enter the list of dummy variables.

     NOTES: 
      - The total length of the prefix, and the value
        of the variable can not exceed 8 characters. 
      - The values in DVAR must not have imbeded or leading spaces.
      - If DVAR is a numeric variable there should be no missing values.
      - If you are using character variables there should be no "."
        values.
      - Interaction dummy variables can not be dropped.  Any
        interaction variables based on a dropped variable will not be
        created.
      - This macro has the potential to generate a huge number of
        variables.  The macro is limited to a maximum of 500 dummy
        variables.

The independent variables in a regression problem can be divided into
two major groups: class variables (aka factored, qualitative, or
categorical variables) and continuous variables (aka quantitative
variables)

Continuous variables are the result of some measurement, like length
or weight, and their values are real numbers (or at least
approximations thereof).

Class variables on the other hand merely identify the class or
category that an observation belongs to, and their values are merely
_codes_ for the category.  An example is the variable AREA taking
values North, South, East and West.

Some SAS procedures can deal with class variables automatically,
namely PROC GLM.  You specify which variables are class variables
using the class statement.  

Most other procedures don't have class statements, so the user is
responsible for coding the class variables him/herself.  There are
several options for coding. Around here, we are usually asked to
create "dummy variables".  Dummy variables, sometimes called indicator
variables, take values 0 and 1 only.  There will be one dummy variable
for each level (value) of the class variable.  As an example, if we
have the variable REGION as above, we could construct 4 dummy
variables, named RegN, RegS, RegE, and RegW.  The variable RegN would
take the value 1 for all observations which had REGION=NORTH, and 0
for all other observations.  The variable RegS would take the value 1
for all observations that had REGION=SOUTH and 0 for all other
observations, etc.  This creates an overparametrized model, an X
matrix that is singular.  A common solution is just to omit one of the
dummy variables.  For instance, we could omit RegW from the model.

Dummy Variables get used more often than you might think.
Some examples of their usage at the Center are:

1) When there is no obvious order to the levels of a variable - for
instance if the variable is region, with levels "Norman","Thompson",
etc..

2) Even if there is an obvious ordering of the levels,
but you don't want to assign numeric values to them,
for instance income quintiles.  We might label the quintiles 
1,2,3,4,5 but not be willing to say that the effect
quintile 2 was twice as much as the effect of quintile 1.
In that case we would use dummies.
 
3) Even if a variable has an obvious numeric ordering, we may still
want to use dummies.  For instance, if we make a plot of visits
against age we might find:

            |
   # of     |   \
   physican |    \     _ 
    visits  |     \ _ / \
            |            \ _  
            |               \
            |__________________


                 age

(ie the relationship between visits and age is not a straight line
over the range of age considered).  In this case we might want to fit
dummy variables for different age groups For instance if we divided
age into 3 levels, and constructed 2 dummies, that is equivalent to
fitting a model which looks like
 
            |
   # of     |   
   physican |  ---     
    visits  |      -----
            |            ----
            |
            |__________________
                 age

Example of use:

** This example provided by Julie Horrocks **;
data acute(drop=mis sex);
  set dsd.acute(drop=phin91 ptid urbquint);

   mis=adacut+sex+agegrp+wpg+hosp+hospgrp;
   if mis=. then delete;
   if revw="." then delete;

   if sex=1 then female=0;
   if sex=2 then female=1;

   run;

_dumvar data=acute 
      dvar="female agegrp hospgrp revw"
      inter="female*agegrp"
      prefix="f age hspgrp rev" 
      drop="f0 age1 hspgrp1 revDB";

 ** Note the usage of the global vars here ;
proc logistic DESCENDING data=acute;
   model adacut=
        wpg
        &dvars
        &inters
        /lackfit ;
   title "GLM model - hspgrp";
   title2 "Baseline - male, non-wpg, agegrp1, hspgrp1, revwDB";
   output out=mod1 pred=pred;
   run;

