                 Episodes of Care and Transfers
                        Version 2.01

This macro will create several new variables on a hospital
dataset to mark individual episodes of care.  An Episode of care
is defined as a continuous stay in the hospital system
irrespective of transfers.  The algorithm used in this macro is
based on the Hospital Transfer Memo (Oct. 15, 1991) and was
originally written by Leonard MacWilliam.

Macro Call
   _EPISODE <options-list> ;

Options
  indkey - Individual identifier such as PHIN (must be a single
     variable). [required]
    indkey=PHIN91
  hspin  - Input hospital dataset.  [required]
     hspin=SAS_dataset_name
  hspout - Output dataset with new episode variables. This
     dataset has been sorted by indkey dateadm datesep.
     Defaults to variable passed in hspin option.
    hspout=SAS_dataset_name
  syear  - Start of year of interest.  Must be in the format
     yymmdd.  This will allow the macro to mark episodes that may
     have started before the current study period. [required]
    syear=910401
  dis_epi - distinguish the start of an episode from a single
     hospital separation (yes or no).  The default value is no.
    dis_epi=no <yes>
  dateadm - Date of admission variable.  Default dateadm=dateadm
  datesep - Date of separation variable. Default datesep=datesep
  hosp - hospital variable. Default hosp=hosp 
  los - length of stay variable. Default los=los
  trfrom - Transfer from variable. Default trfrom=trfrom
  trto - Transfer to variable. Default trto=trto
  debug  - turn on debug options. The default value is nodebug.
    debug=debug

Output
  A sas dataset with the name defined by hspout. The dataset is
  sorted by indkey dateadm datesep.  Five variables have been
  added to the dataset:
  1. Episode     1 = Start of episode, or single
                          separation.
                 0 = continuation of an episode.
                 2 = Start of episode if dis_epi = yes.  This
                     will seperate single seperation (1) from the
                     start of an episode (2).
  2. E_los       Length of stay over the whole episode
  3. fst_hsp     First hospital in episode.
  4. lst_hsp     Last hospital in episode.
  5. alg_trf     Algorithm transfer from
  6. _tranexp    Explanation of transfer use $EXPLAN
  format.
     VALUE $EXPLAN
     '00' = '00 Verified NON-Transfer'          /* Episode = 1 */
     '10' = '10 Algorithm ONLY: diff hosp'      /* Episode = 0 */
     '11' = '11 Verified: trto/trfrom match'    /* Episode = 0 */
     '12' = '12 Same Hospital'                  /* Episode = 0 */
     '13' = '13 Overlap Transfer'               /* Episode = 0 */
     '14' = '14 Algorithm ONLY: same hosp'      /* Episode = 0 */
     '15' = '15 Verified: trfrom only'          /* Episode = 0 */
     '01' = '01 NON-Verified: Diff >1'          /* Episode = 1 */
     '02' = '02 NON-Verified: Prev Yr'          /* Episode = 1 */
     '03' = '03 NON-Verified: Unexplained'      /* Episode = 1 */
     '04' = '04 NON-Verified: Nursing Home'     /* Episode = 1 */
     '05' = '05 NON-Verified: Out-of-Prov'      /* Episode = 1 */
     OTHER = '  NON-Verified: Other' ;         /* Episode = 1 */
     /* Non-Verified indicates that the TRFROM variables indicate
     a transfer but the transfer algorithm does not */

Example calls
     
     _episode indkey=phin91 hspin=hsp9192 hspout=hspepi
     syear=910401 ;
Additional Notes
  This macro uses the sort order of dateadm datesep because the
order closely matches the order that the trto/trfrom variables
use.  The standard dateadm descending datesep is used at the
center for several reasons: 1.  It is more efficient to test for
day surg. (& OPD), in hospital concurrent stays, and OPD/day
surg. on same day of admission to a stay; 2. Sorting by dateadm
and datesep may confuse the relationship between concurrent stays
if the transfer takes place on dateadm.
  
  Currently this macro is not very efficient so use it
judiciously.  I may improve the macro at some later date.
  
  In all transfer, and episode studies you should be aware of
episodes that started before the start of the study, and any
episodes that start during the study but may continue after the
end of the study. Remember that the presence of a second (or
third) claim in an episode is less likely to exist the closer you
get to the fiscal year end.


Example Program

libname hosp '/hosp/hosp9192' ;

data test;
   set hosp.hsputil(keep=INDID admdate sepdate hosp
                         los transto transfr obs=1000) ;
run;

%inc '_episode.mac' ;

_episode indkey=indid
         hspin=test
         hspout=hspepi
         syear=910401
         dis_epi=yes
         s_order=no
         debug=nodebug ;
run;

proc print data=hspepi;
     var indid hosp los episode e_los ;
run;
