Libname users "C:\Users\Vassiki Sanogo\Desktop\aisproject"; /*Project Library*/
Libname data "C:\Users\Vassiki Sanogo\Desktop\aisproject\data"; /*ais dataset Library*/
Libname ais "C:\Users\Vassiki Sanogo\Desktop\aisproject\ais"; /*ais dataset Library*/
Libname dat "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat"; /*acha dataset Library*/
Libname sec "C:\Users\Vassiki Sanogo\Desktop\aisproject\securedata"; /*acha dataset Library*/

*****************************************************************************
*************************** Descriptive Analysis ************************
*****************************************************************************;

proc import datafile = 'C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\datindv.csv'
 out = work.datindv
 dbms = csv
 replace;
run;

data iaist1; set datindv; overall=1;drop necomorb;run;

* Formating *;
proc format;
value yesno_ 1='   Yes'
0='   No'
.='   Missing';      
value sex_ 1='   Male'
2='   Female'
3='   Unknown'
.='   Missing';
value agegrp_ 1='   18-49'
2='   50-64'
3='   65-74'
4='   74<'
.='   Missing';
value race_ 1='   Black'
2='   White'
3='   _Other'
.='   Missing';
value ethnicity_ 1='   Hispanic'
2='   Not_Hispanic'
3='   Unknown'
.='   Missing';
value payer_ 0='   No Insurance'
1='   Government Insurance'
2='   Private Insurance'
3='   Other Insurance'
.='   Missing';
value ptgrp_ 1='   no er and yes ih and yes coc_r'
2='   no er and yes ih and no coc_r'
3='   yes er and yes ih and yes coc_r'
4='   yes er and yes ih and no coc_r'
.='   Missing';
value caislos_ 1='   length of stay 0-2'
2='   length of stay 3-4'
3='   length of stay 5-7'
4='   length of stay >7'
.='   Missing';
value qtr_ 1='   Quarter 1'
2='   Quarter 2'
3='   Quarter 3'
4='   Quarter 4'
.='   Missing';
value fac_region_ 1='   Local Health Council 1'
2='   Local Health Council 2'
3='   Local Health Council 3'
4='   Local Health Council 4'
5='   Local Health Council 5'
6='   Local Health Council 6'
7='   Local Health Council 7'
8='   Local Health Council 8'
9='   Local Health Council 9'
10='   Local Health Council 10'
11='   Local Health Council 11'
.='   Missing';
value ptstat_ 1='   Discharged to home'
2='   Discharged to a short-term general hospital'
3='   Discharged to a skilled nursing facility'
4='   Discharged to an intermediate care facility'
5='   Discharged to home under care of home health care organization'
6='   Discharged to an inpatient Rehabilitation facility'
7='   Discharged to a Medicare Certified Long term care hospital'
8='   Discharged to a Nursing facility Certified under Medicaid only'
9='   Discharged to a psychiatric hospital'
10='   Discharged to a Critical Access hospital'
0='   Unknown'
.='   Missing';
value exinju_ 1='   Not present at the time that the order for inpatient admission occurs'
2='   Present at time that order for inpatient admission occurs'
3='   Documentation is insufficient to determine if condition is present on admission'
4='   Provider is unable to clinically determine whether the condition was present on admission or not'
5='   The condition is exempt from POA reporting'
0='   Missing'
.='   Missing';
value adm_prior_ 1='   Emergency'
2='   Urgent'
3='   Elective'
4='   Newborn'
5='   Trauma'
.='   Missing';
value diag_ 1='   Primary Diagnosis'
0='   Not Primary Diagnosis'
.='   Missing';
value sevr_ 1='   Acute Ischemic Stroke W Use of Thrombolytic Agent W MCC'
2='   Acute Ischemic Stroke W Use of Thrombolytic Agent W CC'
3='   Acute Ischemic Stroke W Use of Thrombolytic Agent W/O CC/MCC'
4='   Others'
.='   Missing';
value edhrarr_ 1='   emergency hour of arrival 00-05'
2='   emergency hour of arrival 06-07'
3='   emergency hour of arrival 08-13'
4='   emergency hour of arrival 14-15'
5='   emergency hour of arrival 16-21'
6='   emergency hour of arrival 22-23'
7='   Unknown'
.='   Missing';
value distime_ 1='   emergency hour of arrival 00-05'
2='   emergency hour of arrival 06-07'
3='   emergency hour of arrival 08-13'
4='   emergency hour of arrival 14-15'
5='   emergency hour of arrival 16-21'
6='   emergency hour of arrival 22-23'
7='   Unknown'
.='   Missing';
value admtime_ 1='   emergency hour of arrival 00-05'
2='   emergency hour of arrival 06-07'
3='   emergency hour of arrival 08-13'
4='   emergency hour of arrival 14-15'
5='   emergency hour of arrival 16-21'
6='   emergency hour of arrival 22-23'
7='   Unknown'
.='   Missing';
value weekday_ 1='   Monday'
2='   Tuesday'
3='   Wednesday'
4='   Thursday'
5='   Friday'
6='   Satursday'
7='   Sunday'
.='   Missing';
value admsrc_ 1='   Non-Health Care Facility Point of Origin' 
2='   Clinic or Physician’s Office'
3='   Transfer from a Hospital'
4='   Transfer from a Skilled Nursing Facility (SNF)'
5='   Transfer from another health care facility'
6='   Court/Law Enforcement'
7='   Information Not Available'
8='   Transfer from one distinct unit of the hospital to another distinct unit of the same hospital resulting in a separate claim'
9='   Transfer from an Ambulatory Surgery Center'
10='   Transfer from a hospice facility & under a hospice plan of care or enrolled in a hospice program Codes Required for Newborn Admissions'
11='   Born inside this hospital'
12='   Born outside this hospital'
.='   Missing';
value condpr_ 0='   Not present at the time that the order for inpatient admission occurs'
1='   Present at time that order for inpatient admission occurs'
2='   Documentation is insufficient to determine if condition is present on admission'
3='   Provider is unable to clinically determine whether the condition was present on admission or not'
4='   The condition is exempt from POA reporting'
.='   Missing';
value condprs_ 0='   Not present at the time that the order for inpatient admission occurs'
1='   Present at time that order for inpatient admission occurs'
2='   Documentation is insufficient to determine if condition is present on admission'
3='   Provider is unable to clinically determine whether the condition was present on admission or not'
4='   The condition is exempt from POA reporting';
value pecmorb_ 1='   Not present at the time that the order for inpatient admission occurs'
2='   Present at time that order for inpatient admission occurs'
3='   Documentation is insufficient to determine if condition is present on admission'
4='   Provider is unable to clinically determine whether the condition was present on admission or not'
5='   The condition is exempt from POA reporting'
0='   Missing'
.='   Missing';
value cond_ 1='   Patient received treatment in this facility’s emergency department'
2='   Not admitted through this facility’s emergency department'
3='   Not reported'
.='   Missing';
value overall 1='   Overall cohort';
value age;
value aistchg; 
value aislos;
value drg;
value phy;
value incAmed;
value ndiag;
value nproc;
picture pctfmt(round)low-high='   009.9)' (prefix='(');
run;


* create a journal style template *;
proc template;
	define style Styles.vasstables;
		parent = Styles.Default;
		STYLE SystemTitle /
			FONT_FACE = "Times New Roman, Helvetica, sans-serif"
			FONT_SIZE = 8
			FONT_WEIGHT = bold
			FONT_STYLE = roman
			FOREGROUND = white
			BACKGROUND = white;
		STYLE SystemFooter /
			FONT_FACE = "Times New Roman, Helvetica, sans-serif"
			FONT_SIZE = 2
			FONT_WEIGHT = bold
			FONT_STYLE = italic
			FOREGROUND = white
			BACKGROUND = white;
		STYLE Header /
			FONT_FACE = "Times New Roman, Helvetica, sans-serif"
			FONT_SIZE = 4
			FONT_WEIGHT = medium
			FONT_STYLE = roman
			FOREGROUND = white
			BACKGROUND = white;
		STYLE Data /
			FONT_FACE = "Times New Roman, Helvetica, sans-serif"
			FONT_SIZE = 2
			FONT_WEIGHT = medium
			FONT_STYLE = roman
			FOREGROUND = black
			BACKGROUND = white;
		STYLE Table /
			FOREGROUND = black
			BACKGROUND = white
			CELLSPACING = 0
			CELLPADDING = 3
			FRAME = HSIDES
			RULES = NONE;
		STYLE Body /
			FONT_FACE = "Times New Roman, Helvetica, sans-serif"
			FONT_SIZE = 3
			FONT_WEIGHT = medium
			FONT_STYLE = roman
			FOREGROUND = black
			BACKGROUND = white;
		STYLE SysTitleAndFooterContainer /
			CELLSPACING=0;
	end;
run;

/******************* TABLE 1a in TEXT *************************************************/
* Labeling Categorical Variables*;

data tab2;
set iaist1;
label payer='Payer';
label race = 'Race';
label agegrp='Age groups';
label sex='Gender';
label death='Died';
label death_180='Died 180 days after discharged';
label readm_30='In Hospital Readmission 30 days after discharged';
label visit_30='Emergency Room Visit 30 days after discharged';
label Etnicity = 'Ethnicity'; 
label aistchg ='Total gross charges';
label aislos = 'Length of stay';
label age = 'Age';
label overall = 'Overall cohort';

* Creating table 1a*;

options orientation=landscape;

ods csv file= "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\table1a.csv" style=vasstables;

title1 "Baseline 1: Clinical and Socioeconomic Characteristic of AIS Patients by Continuity of Care Policy Groups";

proc tabulate data=tab2 missing order=formatted;
	class ptgrp sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad bpn anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag  
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30 overall;
	classlev sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad bpn anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag  
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30 /style=[cellwidth=3in asis=on];
	table sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad bpn anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30,
		overall=''*(n*f=4.0 colpctn='(%)'*f=pctfmt.)
		ptgrp= 'ptgrp'*(n*f=4.0 colpctn='(%)'*f=pctfmt.)/misstext='0' rts=15;
format ptgrp ptgrp_. race race_. sex sex_. ethnicity ethnicity_. payer payer_. agegrp agegrp_. ptstat ptstat_. diag diag_.
death yesno_. vpn yesno_. tia yesno_. pvd yesno_. mpn yesno_. inf yesno_.  htn yesno_. hld yesno_. dm yesno_. dep yesno_. 
cvd yesno_. copd yesno_. chf yesno_. cad yesno_. bpn yesno_. anx yesno_. stroke yesno_. death_180 yesno_. exinju exinju_.
visit_30 yesno_. readm_30 yesno_. weekday weekday_. weekend yesno_. distime distime_. edhrarr edhrarr_. adm_prior adm_prior_.
admtime admtime_. sevr sevr_. caislos caislos_. cond cond_. admsrc admsrc_. condpr condpr_. condprs condprs_. 
pecmorb pecmorb_. overall overall.;
run;

/******************* TABLE 1b in TEXT *************************************************/
* Labeling Categorical Variables*;

data tab2;
set iaist1;
label payer='Payer';
label race = 'Race';
label agegrp='Age groups';
label sex='Gender';
label death='Died';
label death_180='Died 180 days after discharged';
label readm_30='In Hospital Readmission 30 days after discharged';
label visit_30='Emergency Room Visit 30 days after discharged';
label Etnicity = 'Ethnicity'; 
label aistchg ='Total gross charges';
label aislos = 'Length of stay';
label age = 'Age';
label overall = 'Overall cohort';

* Creating table 1b*;

options orientation=landscape;

ods csv file= "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\table1b.csv" style=karamtables;

title1 "Baseline 2: Clinical and Socioeconomic Characteristic of AIS Patients by Local Health Council";

proc tabulate data=tab2 missing order=formatted;
	class fac_region sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad bpn anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30 overall;
	classlev sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad bpn anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30 /style=[cellwidth=3in asis=on];
	table sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad bpn anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30,
		overall=''*(n*f=4.0 colpctn='(%)'*f=pctfmt.)
		fac_region= 'fac_region'*(n*f=4.0 colpctn='(%)'*f=pctfmt.)/misstext='0' rts=15;
format fac_region fac_region_. race race_. sex sex_. ethnicity ethnicity_. payer payer_. agegrp agegrp_. ptstat ptstat_. 
death yesno_. vpn yesno_. tia yesno_. pvd yesno_. mpn yesno_. inf yesno_.  htn yesno_. hld yesno_. dm yesno_. dep yesno_. 
cvd yesno_. copd yesno_. chf yesno_. cad yesno_. bpn yesno_. anx yesno_. stroke yesno_. death_180 yesno_. exinju exinju_.
visit_30 yesno_. readm_30 yesno_. weekday weekday_. weekend yesno_. distime distime_. edhrarr edhrarr_. adm_prior adm_prior_.
admtime admtime_. sevr sevr_. caislos caislos_. cond cond_. admsrc admsrc_. condpr condpr_. condprs condprs_. diag diag_.
pecmorb pecmorb_. overall overall.;
run;

/******************* TABLE 2a in TEXT *************************************************/
* Labeling Categorical Variables*;

data tab2;
set iaist1;
label payer='Payer';
label race = 'Race';
label agegrp='Age groups';
label sex='Gender';
label death='Died';
label death_180='Died 180 days after discharged';
label readm_30='In Hospital Readmission 30 days after discharged';
label visit_30='Emergency Room Visit 30 days after discharged';
label Etnicity = 'Ethnicity'; 
label aistchg ='Total gross charges';
label aislos = 'Length of stay';
label age = 'Age';
label overall = 'Overall cohort';

* Creating table 2a*;

options orientation=landscape;

ods csv file= "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\table2a.csv" style=vasstables;

title1 "Baseline 3: Clinical and Socioeconomic Characteristic of AIS Patients by Viral Pneumonia";

proc tabulate data=tab2 missing order=formatted;
	class vpn sex ethnicity race payer agegrp ptstat death tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad bpn anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag  
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30 overall;
	classlev sex ethnicity race payer agegrp ptstat death tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad bpn anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag  
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30 /style=[cellwidth=3in asis=on];
	table sex ethnicity race payer agegrp ptstat death tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad bpn anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30,
		overall=''*(n*f=4.0 colpctn='(%)'*f=pctfmt.)
		vpn= 'vpn'*(n*f=4.0 colpctn='(%)'*f=pctfmt.)/misstext='0' rts=15;
format ptgrp ptgrp_. race race_. sex sex_. ethnicity ethnicity_. payer payer_. agegrp agegrp_. ptstat ptstat_. diag diag_.
death yesno_. tia yesno_. pvd yesno_. mpn yesno_. inf yesno_.  htn yesno_. hld yesno_. dm yesno_. dep yesno_. 
cvd yesno_. copd yesno_. chf yesno_. cad yesno_. bpn yesno_. anx yesno_. stroke yesno_. death_180 yesno_. exinju exinju_.
visit_30 yesno_. readm_30 yesno_. weekday weekday_. weekend yesno_. distime distime_. edhrarr edhrarr_. adm_prior adm_prior_.
admtime admtime_. sevr sevr_. caislos caislos_. cond cond_. admsrc admsrc_. condpr condpr_. condprs condprs_. 
pecmorb pecmorb_. overall overall.;
run;

/******************* TABLE 2b in TEXT *************************************************/
* Labeling Categorical Variables*;

data tab2;
set iaist1;
label payer='Payer';
label race = 'Race';
label agegrp='Age groups';
label sex='Gender';
label death='Died';
label death_180='Died 180 days after discharged';
label readm_30='In Hospital Readmission 30 days after discharged';
label visit_30='Emergency Room Visit 30 days after discharged';
label Etnicity = 'Ethnicity'; 
label aistchg ='Total gross charges';
label aislos = 'Length of stay';
label age = 'Age';
label overall = 'Overall cohort';

* Creating table 2b*;

options orientation=landscape;

ods csv file= "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\table2b.csv" style=karamtables;

title1 "Baseline 4: Clinical and Socioeconomic Characteristic of AIS Patients by Bacterial Pneumonia";

proc tabulate data=tab2 missing order=formatted;
	class bpn sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30 overall;
	classlev sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30 /style=[cellwidth=3in asis=on];
	table sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30,
		overall=''*(n*f=4.0 colpctn='(%)'*f=pctfmt.)
		bpn= 'bpn'*(n*f=4.0 colpctn='(%)'*f=pctfmt.)/misstext='0' rts=15;
format fac_region fac_region_. race race_. sex sex_. ethnicity ethnicity_. payer payer_. agegrp agegrp_. ptstat ptstat_. 
death yesno_. vpn yesno_. tia yesno_. pvd yesno_. mpn yesno_. inf yesno_.  htn yesno_. hld yesno_. dm yesno_. dep yesno_. 
cvd yesno_. copd yesno_. chf yesno_. cad yesno_. anx yesno_. stroke yesno_. death_180 yesno_. exinju exinju_.
visit_30 yesno_. readm_30 yesno_. weekday weekday_. weekend yesno_. distime distime_. edhrarr edhrarr_. adm_prior adm_prior_.
admtime admtime_. sevr sevr_. caislos caislos_. cond cond_. admsrc admsrc_. condpr condpr_. condprs condprs_. diag diag_.
pecmorb pecmorb_. overall overall.;
run;

/******************* TABLE 3a in TEXT *************************************************/
* Labeling Categorical Variables*;

data tab2;
set iaist1;
label age='Age at patient admission';
label aistchg = 'AIS Total Charges';
label aislos='AIS Total Length of Stay';
label drg='Diagnosis-related group';
label incAmed= 'Median Incom in the Facility Region';
label phy='Number of visit by physician';
label nproc='Number of Procedures';
label ndiag='Number of Diagnosis';
label overall = 'Overall cohort';

* Creating table 3a*;
options orientation=landscape;

ods csv file= "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\table3a.csv" style=vasstables;

title1 "Continuity of Care Policy Groups, Regional, vpn, and bpn Differences in Hospital Resource Utilization of AIS Patients";

proc tabulate data=tab2 missing order=formatted;
	class ptgrp fac_region vpn bpn;
	var aistchg aislos age incAmed ndiag nproc ndiag phy;
	table aistchg aislos age incAmed ndiag nproc ndiag phy,
		ptgrp='ptgrp'*(mean*f=6.1 stddev*f=6.1)
		fac_region='fac_region'*(mean*f=6.1 stddev*f=6.1)
		vpn='vpn'*(mean*f=6.1 stddev*f=6.1)
		bpn='bpn'*(mean*f=6.1 stddev*f=6.1);
	format ptgrp ptgrp_. fac_region fac_region_. vpn yesno_. bpn yesno_. overall overall. aistchg aistchg. aislos aislos. 
	age age. incAmed incAmed. ndiag ndiag. nproc nproc. ndiag ndiag. phy phy.;
run;


/******************* TABLE 4a in TEXT***********************************************/
* Labeling Categorical Variables*; 

data tab2;
set iaist1;
label payer='Payer';
label race = 'Race';
label agegrp='Age groups';
label sex='Gender';
label death='Died';
label death_180='Died 180 days after discharged';
label readm_30='In Hospital Readmission 30 days after discharged';
label visit_30='Emergency Room Visit 30 days after discharged';
label Etnicity = 'Ethnicity'; 
label aistchg ='Total gross charges';
label aislos = 'Length of stay';
label age = 'Age';
label overall = 'Overall cohort';

* Creating table 4a;
options orientation=portrait;

ods csv file= "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\table4a.csv" style=vasstables;

title1 "Chisquare Test for Clinical and Socioeconomic Characteristic of AIS Patients by COC Policy Groups";

proc freq data=tab2 order=formatted;
	tables (ptgrp)*(sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30)/ chisq;;
	format ptgrp ptgrp_. race race_. sex sex_. ethnicity ethnicity_. payer payer_. agegrp agegrp_. ptstat ptstat_. 
	death yesno_. vpn yesno_. tia yesno_. pvd yesno_. mpn yesno_. inf yesno_.  htn yesno_. hld yesno_. dm yesno_. dep yesno_. 
	cvd yesno_. copd yesno_. chf yesno_. cad yesno_. anx yesno_. stroke yesno_. death_180 yesno_. exinju exinju_.
	visit_30 yesno_. readm_30 yesno_. weekday weekday_. weekend yesno_. distime distime_. edhrarr edhrarr_. adm_prior adm_prior_.
	admtime admtime_. sevr sevr_. caislos caislos_. cond cond_. admsrc admsrc_. condpr condpr_. condprs condprs_. diag diag_.
	pecmorb pecmorb_.;
run;

/******************* TABLE 4b in TEXT***********************************************/
* Labeling Categorical Variables*; 

data tab2;
set iaist1;
label payer='Payer';
label race = 'Race';
label agegrp='Age groups';
label sex='Gender';
label death='Died';
label death_180='Died 180 days after discharged';
label readm_30='In Hospital Readmission 30 days after discharged';
label visit_30='Emergency Room Visit 30 days after discharged';
label Etnicity = 'Ethnicity'; 
label aistchg ='Total gross charges';
label aislos = 'Length of stay';
label age = 'Age';
label overall = 'Overall cohort';

* Creating table 4b;
options orientation=portrait;

ods csv file= "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\table4b.csv" style=vasstables;

title1 "Chisquare Test for Clinical and Socioeconomic Characteristic of AIS Patients by Region";

proc freq data=tab2 order=formatted;
	tables (fac_region)*(sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30)/ chisq;;
	format fac_region fac_region_. race race_. sex sex_. ethnicity ethnicity_. payer payer_. agegrp agegrp_. ptstat ptstat_. 
	death yesno_. vpn yesno_. tia yesno_. pvd yesno_. mpn yesno_. inf yesno_.  htn yesno_. hld yesno_. dm yesno_. dep yesno_. 
	cvd yesno_. copd yesno_. chf yesno_. cad yesno_. anx yesno_. stroke yesno_. death_180 yesno_. exinju exinju_.
	visit_30 yesno_. readm_30 yesno_. weekday weekday_. weekend yesno_. distime distime_. edhrarr edhrarr_. adm_prior adm_prior_.
	admtime admtime_. sevr sevr_. caislos caislos_. cond cond_. admsrc admsrc_. condpr condpr_. condprs condprs_. diag diag_.
	pecmorb pecmorb_.;
run;

/******************* TABLE 5a in TEXT***********************************************/
* Labeling Categorical Variables*; 

data tab2;
set iaist1;
label payer='Payer';
label race = 'Race';
label agegrp='Age groups';
label sex='Gender';
label death='Died';
label death_180='Died 180 days after discharged';
label readm_30='In Hospital Readmission 30 days after discharged';
label visit_30='Emergency Room Visit 30 days after discharged';
label Etnicity = 'Ethnicity'; 
label aistchg ='Total gross charges';
label aislos = 'Length of stay';
label age = 'Age';
label overall = 'Overall cohort';

* Creating table 5a;
options orientation=portrait;

ods csv file= "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\table5a.csv" style=vasstables;

title1 "Chisquare Test for Clinical and Socioeconomic Characteristic of AIS Patients by VPN";

proc freq data=tab2 order=formatted;
	tables (vpn)*(sex ethnicity race payer agegrp ptstat death tia pvd bpn mpn inf htn hld dm dep cvd copd 
	chf cad anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30)/ chisq;;
	format race race_. sex sex_. ethnicity ethnicity_. payer payer_. agegrp agegrp_. ptstat ptstat_. 
	death yesno_. vpn yesno_. bpn yesno_. tia yesno_. pvd yesno_. mpn yesno_. inf yesno_.  htn yesno_. hld yesno_. dm yesno_. dep yesno_. 
	cvd yesno_. copd yesno_. chf yesno_. cad yesno_. anx yesno_. stroke yesno_. death_180 yesno_. exinju exinju_.
	visit_30 yesno_. readm_30 yesno_. weekday weekday_. weekend yesno_. distime distime_. edhrarr edhrarr_. adm_prior adm_prior_.
	admtime admtime_. sevr sevr_. caislos caislos_. cond cond_. admsrc admsrc_. condpr condpr_. condprs condprs_. diag diag_.
	pecmorb pecmorb_.;
run;

/******************* TABLE 5b in TEXT***********************************************/
* Labeling Categorical Variables*; 

data tab2;
set iaist1;
label payer='Payer';
label race = 'Race';
label agegrp='Age groups';
label sex='Gender';
label death='Died';
label death_180='Died 180 days after discharged';
label readm_30='In Hospital Readmission 30 days after discharged';
label visit_30='Emergency Room Visit 30 days after discharged';
label Etnicity = 'Ethnicity'; 
label aistchg ='Total gross charges';
label aislos = 'Length of stay';
label age = 'Age';
label overall = 'Overall cohort';

* Creating table 5b;
options orientation=portrait;

ods csv file= "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\table5b.csv" style=vasstables;

title1 "Chisquare Test for Clinical and Socioeconomic Characteristic of AIS Patients by BPN";

proc freq data=tab2 order=formatted;
	tables (bpn)*(sex ethnicity race payer agegrp ptstat death vpn tia pvd mpn inf htn hld dm dep cvd copd 
	chf cad anx stroke weekday weekend distime edhrarr admtime cond admsrc adm_prior diag 
	exinju condpr condprs sevr pecmorb caislos death_180 visit_30 readm_30)/ chisq;;
	format bpn yesno_. race race_. sex sex_. ethnicity ethnicity_. payer payer_. agegrp agegrp_. ptstat ptstat_. 
	death yesno_. vpn yesno_. tia yesno_. pvd yesno_. mpn yesno_. inf yesno_.  htn yesno_. hld yesno_. dm yesno_. dep yesno_. 
	cvd yesno_. copd yesno_. chf yesno_. cad yesno_. anx yesno_. stroke yesno_. death_180 yesno_. exinju exinju_.
	visit_30 yesno_. readm_30 yesno_. weekday weekday_. weekend yesno_. distime distime_. edhrarr edhrarr_. adm_prior adm_prior_.
	admtime admtime_. sevr sevr_. caislos caislos_. cond cond_. admsrc admsrc_. condpr condpr_. condprs condprs_. diag diag_.
	pecmorb pecmorb_.;
run;


/******************* TABLE 6a in TEXT *************************************************/

options orientation=portrait;

ods csv file= "C:\Users\Vassiki Sanogo\Desktop\aisproject\dat\table6a.csv" style=vasstables;

title1 "aistchg, aislos, age, incAmed, ndiag, nproc, phy - P value - Continuous variable";

/*aistchg*/
proc glm data=tab2 order=formatted;
	class ptgrp;
	model aistchg =  ptgrp;
	means ptgrp/bon; 
run;

proc glm data=tab2 order=formatted;
	class fac_region;
	model aistchg =  fac_region;
	means fac_region/bon; 
run;

proc glm data=tab2 order=formatted;
	class vpn;
	model aistchg =  vpn;
	means vpn/bon; 
run;

proc glm data=tab2 order=formatted;
	class bpn;
	model aistchg =  bpn;
	means bpn/bon; 
run;

/*aislos*/
proc glm data=tab2 order=formatted;
	class ptgrp;
	model aislos =  ptgrp;
	means ptgrp/bon; 
run;

proc glm data=tab2 order=formatted;
	class fac_region;
	model aislos =  fac_region;
	means fac_region/bon; 
run;

proc glm data=tab2 order=formatted;
	class vpn;
	model aislos =  vpn;
	means vpn/bon; 
run;

proc glm data=tab2 order=formatted;
	class bpn;
	model aislos =  bpn;
	means bpn/bon; 
run;

/*age*/
proc glm data=tab2 order=formatted;
	class ptgrp;
	model age =  ptgrp;
	means ptgrp/bon; 
run;

proc glm data=tab2 order=formatted;
	class fac_region;
	model age =  fac_region;
	means fac_region/bon; 
run;

proc glm data=tab2 order=formatted;
	class vpn;
	model age =  vpn;
	means vpn/bon; 
run;

proc glm data=tab2 order=formatted;
	class bpn;
	model age =  bpn;
	means bpn/bon; 
run;

/*incAmed*/
proc glm data=tab2 order=formatted;
	class ptgrp;
	model incAmed =  ptgrp;
	means ptgrp/bon; 
run;

proc glm data=tab2 order=formatted;
	class fac_region;
	model incAmed =  fac_region;
	means fac_region/bon; 
run;

proc glm data=tab2 order=formatted;
	class vpn;
	model incAmed =  vpn;
	means vpn/bon; 
run;

proc glm data=tab2 order=formatted;
	class bpn;
	model incAmed =  bpn;
	means bpn/bon; 
run;

/*ndiag*/
proc glm data=tab2 order=formatted;
	class ptgrp;
	model ndiag =  ptgrp;
	means ptgrp/bon; 
run;

proc glm data=tab2 order=formatted;
	class fac_region;
	model ndiag =  fac_region;
	means fac_region/bon; 
run;

proc glm data=tab2 order=formatted;
	class vpn;
	model ndiag =  vpn;
	means vpn/bon; 
run;

proc glm data=tab2 order=formatted;
	class bpn;
	model ndiag =  bpn;
	means bpn/bon; 
run;

/*nproc*/
proc glm data=tab2 order=formatted;
	class ptgrp;
	model nproc =  ptgrp;
	means ptgrp/bon; 
run;

proc glm data=tab2 order=formatted;
	class fac_region;
	model nproc =  fac_region;
	means fac_region/bon; 
run;

proc glm data=tab2 order=formatted;
	class vpn;
	model nproc =  vpn;
	means vpn/bon; 
run;

proc glm data=tab2 order=formatted;
	class bpn;
	model nproc =  bpn;
	means bpn/bon; 
run;

/*phy*/
proc glm data=tab2 order=formatted;
	class ptgrp;
	model phy =  ptgrp;
	means ptgrp/bon; 
run;

proc glm data=tab2 order=formatted;
	class fac_region;
	model phy =  fac_region;
	means fac_region/bon; 
run;

proc glm data=tab2 order=formatted;
	class vpn;
	model phy =  vpn;
	means vpn/bon; 
run;

proc glm data=tab2 order=formatted;
	class bpn;
	model phy =  bpn;
	means bpn/bon; 
run;
