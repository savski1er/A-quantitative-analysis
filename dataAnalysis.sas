/***************************************************************************************/

Libname users "//Volumes/My Passport for Mac/aisproject"; /*Project Library*/
Libname ais "/Volumes/My Passport for Mac/aisproject/ais"; /*ais dataset Library*/
Libname dat "/Volumes/My Passport for Mac/aisproject/dat"; /*acha dataset Library*/

/***************************************************************************************/


/*Demographics 

Age, Sex, Payer(Medicare, Medicaid, private insurance, self-pay, 
no charge, other), Patient location (urban/rural classification), 
Household income quartiles 

X1: age;
X2: agegrp;
X3: sex;
X4: ethnicity;
X5: race;
X6: payer;
X7: ptgrp;
X8: ptcounty;
X9: zipcode; 



Admission & discharge information 
Admission on weekend, Disposition of patient, Elective admission, 
Emergency Department (ED) services, Transferring to rehabilitation, 
Length of stay 

X10: year;
X11: pcp;
X12: tx;
X13: qtr;
X14: ptstat;
X15: weekday;
X16: weekend;
X17: caislos;
X18: aislos;
X19: losdays;
X20: loser;
X21: losamb;
X22: los;
X23: er;
X24: ih;
X25: distime;
X26: edhrarr;
X27: admtime;
X28: cond;
X29: admsrc; and
X30: adm_prior.


Clinical information 
Type and number of Diagnoses (ICD-9-CM), External causes of injury 
codes (ICD-9-CM), Procedures (ICD-9-CM), Number of chronic conditions, 
Major operating room procedure indicator 

X31: diag
X32: ndiag
X33: nproc
X34: exinju
X35: condpr
X36: condprs


Severity information 
Risk of mortality of 3M All Patient Refined Diagnosis-Related 
Group (APR-DRG), Severity of illness of APR-DRG, AHRQ comorbidity 
measures, Chronic condition body system indicators, Procedure class 
for all ICD-9-CM procedures 

X37: sevr
X38: necmorb
X39: pecmorb
X40: drg
X41: vpn
X42: tia
X43: pvd
X44: mpn
X45: inf
X46: htn
X47: hld
X48: dm
X49: dep
X50: cvd
X51: copd
X52: chf
X53: cad
X54: bpn
X55: anx
X56: stroke


Hospital information 
Control/ownership of hospital, Size of hospital based on the number 
of beds, Teaching status of hospital, Hospital urban-rural location 

X57: tchgs
X58: aistchg
X59: tchger
X60: tchgamb
X61: faclnbr;
X62: mcare_nbr;
X63: fac_region; and
X64: atten_phynpi.

Previous Admissions information 
Number of days from the most recent previous admission of any kind 
and the same APR-DRG in CY2013, Number of previous admissions of any 
nd and the same APR-DRG in CY2013, Frequency of previous admissions 
of any kkiind and the same APR- DRG in CY2013, Average number of days 
between admissions

X65: death;
X66: death_30;
X67: death_60;
X68: death_90;
X69: death_180;
X70: visit_30; and
X71: readm_30


Traetment Variable

X12: tx;
X23: er;
X24: ih;


Outcome Variables

X17: caislos;
X18: aislos;
X19: losdays;
X20: loser;
X21: losamb;
X22: los;
X57: tchgs
X58: aistchg
X59: tchger
X60: tchgamb
X65: death;
X66: death_30;
X67: death_60;
X68: death_90;
X69: death_180;
X70: visit_30; and
X71: readm_30


Florida regions economic information (limitation in our study!)
Florida regions climate and environmental information (limitation in our study!)
 */ 

Program 9.1 Computing Treatment Selection and Censoring Weights
/* This section of code computes the treatment selection and censoring
weights. This is accomplished in 4 steps:
1) multinomial model to compute numerator of treatment selection weights;
2) multinomial model to compute denominator of treatment selection weights;
3) binomial model to compute numerator of censoring adjustment weights;
4) binomial model to compute denominator of censoring adjustment weights.*/
/* treatment selection weights: numerator calculation
(probability of treatment using only baseline covariates) */
PROC LOGISTIC DATA = INPDS;
CLASS VIS THERAPY PR1TRTA PR1TRTB PR1TRTC GENDER ORIGIN2 BHOSP BEVNT;
MODEL TRT = VIS THERAPY PR1TRTA PR1TRTB PR1TRTC GENDER ORIGIN2 BHOSP
BEVNT AGEYRS BGAF BBPRS
/LINK=GLOGIT;
OUTPUT OUT=PREDTRT0(WHERE=(TRT=_LEVEL_)) PRED=PREDTRT0;
run;
/* treatment selection weights: denominator calculation
(probability of treatment with baseline covariates and time-dependent
covariates) */
PROC LOGISTIC DATA = INPDS;
CLASS VIS THERAPY PR1TRTA PR1TRTB PR1TRTC GENDER ORIGIN2 BHOSP BEVNT
PR1EVNT PR1HOSP;
MODEL TRT = VIS THERAPY PR1TRTA PR1TRTB PR1TRTC GENDER ORIGIN2 BHOSP
/LINK=GLOGIT;
BEVNT AGEYRS BGAF BBPRS PR1EVNT PR1HOSP PR1BPRS PR1GAFC
OUTPUT OUT=PREDTRT1(WHERE=(TRT=_LEVEL_)) PRED=PREDTRT1;
run;
/* censoring adjustment weights: numerator calculation
(probability of censoring using only baseline covariates) */
ODS LISTING EXCLUDE OBSTATS;
PROC GENMOD DATA = INPDS;
CLASS PATSC VIS THERAPY TRTA TRTB TRTC GENDER ORIGIN2 BHOSP BEVNT;
MODEL CFLAG = VIS THERAPY TRTA TRTB TRTC GENDER ORIGIN2 BHOSP BEVNT
AGEYRS BGAF BBPRS
/DIST = BIN LINK = LOGIT TYPE3 OBSTATS;
REPEATED SUBJECT = PATSC / TYPE = EXCH;
ODS OUTPUT OBSTATS = PREDCEN0(RENAME=(PRED=PREDCEN0));
run;
ODS LISTING SELECT ALL;
/* censoring adjustment weights: denominator calculation
(probability of censoring using baseline covariates and time-dependent
covariates) */
ODS LISTING EXCLUDE OBSTATS;
PROC GENMOD DATA = INPDS;
CLASS PATSC VIS THERAPY TRTA TRTB TRTC GENDER ORIGIN2 BHOSP BEVNT
EVNT HOSP;
MODEL CFLAG = VIS THERAPY TRTA TRTB TRTC GENDER ORIGIN2 BHOSP BEVNT
EVNT HOSP AGEYRS BGAF BBPRS BPRS GAFC
/DIST = BIN LINK = LOGIT TYPE3 OBSTATS;
REPEATED SUBJECT = PATSC / TYPE = EXCH;
run;
ODS OUTPUT OBSTATS = PREDCEN1(RENAME=(PRED=PREDCEN1));
ODS LISTING SELECT ALL;
