/***************************************************************************************/

Libname users "//Volumes/My Passport for Mac/aisproject"; /*Project Library*/
Libname ais "/Volumes/My Passport for Mac/aisproject/ais"; /*ais dataset Library*/
Libname dat "/Volumes/My Passport for Mac/aisproject/dat"; /*acha dataset Library*/

/***************************************************************************************/

/*2006-2016 AHCA Ambulatory cohort/
/*2006 N= 2953661
/*2007 N= 3101306
/*2008 N= 3133537
/*2009 N= 3071154
/*2010 N= 2982423
/*2011 N= 2930972
/*2012 N= 2895686
/*2013 N= 2899324
/*2014 N= 2938239
/*2015 N= 3029199
/*2016 N= 3063246
/*Total sample for our Ambulatory cohort 32,998,747/ 

/*2006-2016 AHCA Emergency Departement patient cohort/
/*2006 N= 5818875
/*2007 N= 5792226
/*2008 N= 5945370
/*2009 N= 6500554
/*2010 N= 6593010
/*2011 N= 6896896
/*2012 N= 7358100
/*2013 N= 7548503
/*2014 N= 8057141
/*2015 N= 8467139
/*2016 N= 8858561
/*Total sample for our Emergency Departement patient cohort 77,836,375/ 

/*2006-2016 AHCA inpatient cohort/
/*2006 N= 2554999
/*2007 N= 2563643
/*2008 N= 2571688
/*2009 N= 2606167
/*2010 N= 2640286
/*2011 N= 2656257
/*2012 N= 2671113
/*2013 N= 2673465
/*2014 N= 2741984
/*2015 N= 2817621
/*2016 N= 2837863
/*Total sample for our inpatient cohort 37,732,554/ 

/*Step 1*/
/*Renaming gender by sex in dataset from 06 to 09*/

%Macro ret_sex (input, output);
Data &output (keep= sys_recid year maskssn msdrg drg qtr begindate 
	enddate admtype admitdate dischdate gender sex ethnicity race 
	age type_serv dischstat losdays adm_prior admsrc condtn edhr_disch
	edhr_arr adm_time dis_time payer reason_cde zipcode ptcounty 
	fac_region ptstate admitdiag prindiag poa_prin_diag daysproc
	pt_status prinproc tchgs mcare_nbr pro_code atten_phyid 
	atten_phynpi oper_phyid faclnbr hr_arrival serv_loc weekday 
	oper_phynpi othoper_phyid othoper_phynpi mod_code daysproc: 
	poa_ecmorb: ecmorb: poa: evalcode: othproc: othcpt: othdiag:);
	
set &input;
rename gender=sex;
rename admtype=type_serv;
rename reason_cde=admitdiag;
rename msdrg=drg;
rename pt_status=dischstat;
rename admitdate=begindate;
rename dischdate=enddate;
run;
%mend ret_sex;

%ret_sex (dat.amb06, a06);
%ret_sex (dat.amb07, a07);
%ret_sex (dat.amb08, a08);
%ret_sex (dat.amb09, a09);
%ret_sex (dat.amb10, a10);
%ret_sex (dat.amb11, a11);
%ret_sex (dat.amb12, a12);
%ret_sex (dat.amb13, a13);
%ret_sex (dat.amb14, a14);
%ret_sex (dat.amb15, a15);
%ret_sex (dat.amb16, a16);

%ret_sex (dat.edp06, e06);
%ret_sex (dat.edp07, e07);
%ret_sex (dat.edp08, e08);
%ret_sex (dat.edp09, e09);
%ret_sex (dat.edp10, e10);
%ret_sex (dat.edp11, e11);
%ret_sex (dat.edp12, e12);
%ret_sex (dat.edp13, e13);
%ret_sex (dat.edp14, e14);
%ret_sex (dat.edp15, e15);
%ret_sex (dat.edp16, e16);

%ret_sex (dat.inp06, i06);
%ret_sex (dat.inp07, i07);
%ret_sex (dat.inp08, i08);
%ret_sex (dat.inp09, i09);
%ret_sex (dat.inp10, i10);
%ret_sex (dat.inp11, i11);
%ret_sex (dat.inp12, i12);
%ret_sex (dat.inp13, i13);
%ret_sex (dat.inp14, i14);
%ret_sex (dat.inp15, i15);
%ret_sex (dat.inp16, i16);


/* Construction of ais inpatient data for last quarter 2015 and the whole 2016 in ICD 10*/

%Macro ret_ais (input, output, prindiag, othdiag);
Data &output (keep= sys_recid year maskssn msdrg drg qtr begindate 
	enddate admtype admitdate dischdate gender sex ethnicity race 
	age type_serv dischstat losdays adm_prior admsrc condtn edhr_disch
	edhr_arr adm_time dis_time payer reason_cde zipcode ptcounty 
	fac_region ptstate admitdiag prindiag poa_prin_diag daysproc
	pt_status prinproc tchgs mcare_nbr pro_code atten_phyid 
	atten_phynpi oper_phyid faclnbr hr_arrival serv_loc weekday 
	oper_phynpi othoper_phyid othoper_phynpi mod_code daysproc: 
	poa_ecmorb: ecmorb: poa: evalcode: othproc: othcpt: othdiag:);
	
set &input;
if age >= 18 then do;
array dx $ &prindiag &othdiag;
do over dx;
if dx in ('I63.0', 'I63.00', 'I63.01', 'I63.011', 'I63.012', 'I63.013', 
	'I63.019', 'I63.02', 'I63.03', 'I63.031', 'I63.032', 'I63.033', 
	'I63.039', 'I63.09', 'I63.1', 'I63.10', 'I63.11', 'I63.111', 
	'I63.112', 'I63.113', 'I63.119', 'I63.12', 'I63.13', 'I63.131', 
	'I63.132', 'I63.133', 'I63.139', 'I63.19', 'I63.2', 'I63.20', 
	'I63.21', 'I63.211', 'I63.212', 'I63.213', 'I63.219', 'I63.22', 
	'I63.23', 'I63.231', 'I63.232', 'I63.233', 'I63.239', 'I63.29', 
	'I63.3', 'I63.30', 'I63.31', 'I63.311', 'I63.312', 'I63.313', 
	'I63.319', 'I63.32', 'I63.321', 'I63.322', 'I63.323', 'I63.329', 
	'I63.33', 'I63.331', 'I63.332', 'I63.333', 'I63.339', 'I63.34', 
	'I63.341', 'I63.342', 'I63.343', 'I63.349', 'I63.39', 'I63.4', 
	'I63.40', 'I63.41', 'I63.411', 'I63.412', 'I63.413', 'I63.419', 
	'I63.42', 'I63.421', 'I63.422', 'I63.423', 'I63.429', 'I63.43', 
	'I63.431', 'I63.432', 'I63.433', 'I63.439', 'I63.44', 'I63.441', 
	'I63.442', 'I63.443', 'I63.449', 'I63.49', 'I63.5', 'I63.50', 
	'I63.51', 'I63.511', 'I63.512', 'I63.513', 'I63.519', 'I63.52', 
	'I63.521', 'I63.522', 'I63.523', 'I63.529', 'I63.53', 'I63.531', 
	'I63.532', 'I63.533', 'I63.539', 'I63.54', 'I63.541', 'I63.542', 
	'I63.543', 'I63.549', 'I63.59', 'I63.6', 'I63.8', 'I63.81', 'I63.89', 
	'I63.9') then ais=1;
end;
end;
if ais=1;
run;
%mend ret_ais;

%ret_ais (i15, i15t, prindiag, othdiag1-othdiag30); /* 11226 obs */
%ret_ais (i16, i16, prindiag, othdiag1-othdiag30); /* 46935 obs */
%ret_ais (a15, a15t, prindiag, othdiag1-othdiag30); /* 309 obs */
%ret_ais (a16, a16, prindiag, othdiag1-othdiag30); /* 1292 obs */
%ret_ais (e15, e15t, prindiag, othdiag1-othdiag30); /* 1590 obs */
%ret_ais (e16, e16, prindiag, othdiag1-othdiag30); /* 6135 obs */


/*Extracting ais patients from 06 to 16 datasets*/

%Macro ret_ais (input, output, prindiag, othdiag);
Data &output (keep= sys_recid year maskssn msdrg drg qtr begindate 
	enddate admtype admitdate dischdate gender sex ethnicity race 
	age type_serv dischstat losdays adm_prior admsrc condtn edhr_disch
	edhr_arr adm_time dis_time payer reason_cde zipcode ptcounty 
	fac_region ptstate admitdiag prindiag poa_prin_diag daysproc
	pt_status prinproc tchgs mcare_nbr pro_code atten_phyid 
	atten_phynpi oper_phyid faclnbr hr_arrival serv_loc weekday 
	oper_phynpi othoper_phyid othoper_phynpi mod_code daysproc: 
	poa_ecmorb: ecmorb: poa: evalcode: othproc: othcpt: othdiag:);
	
set &input;
if age >= 18 then do;
array dx1 $ &prindiag &othdiag;
do over dx1;
if dx1 in ('433.01', '433.11', '433.21', '433.31', '433.81', 
			'434.01', '434.11', '434.91') then ais=1;
end;
end;
if ais=1;
run;
%mend ret_ais;

%ret_ais (a06, a06, prindiag, othdiag1-othdiag30); 
%ret_ais (a07, a07, prindiag, othdiag1-othdiag30); 
%ret_ais (a08, a08, prindiag, othdiag1-othdiag30); 
%ret_ais (a09, a09, prindiag, othdiag1-othdiag30); 
%ret_ais (a10, a10, prindiag, othdiag1-othdiag30); 
%ret_ais (a11, a11, prindiag, othdiag1-othdiag30); 
%ret_ais (a12, a12, prindiag, othdiag1-othdiag30); 
%ret_ais (a13, a13, prindiag, othdiag1-othdiag30); 
%ret_ais (a14, a14, prindiag, othdiag1-othdiag30); 
%ret_ais (a15, a15, prindiag, othdiag1-othdiag30); 

%ret_ais (e06, e06, prindiag, othdiag1-othdiag30); 
%ret_ais (e07, e07, prindiag, othdiag1-othdiag30); 
%ret_ais (e08, e08, prindiag, othdiag1-othdiag30); 
%ret_ais (e09, e09, prindiag, othdiag1-othdiag30); 
%ret_ais (e10, e10, prindiag, othdiag1-othdiag30); 
%ret_ais (e11, e11, prindiag, othdiag1-othdiag30); 
%ret_ais (e12, e12, prindiag, othdiag1-othdiag30); 
%ret_ais (e13, e13, prindiag, othdiag1-othdiag30); 
%ret_ais (e14, e14, prindiag, othdiag1-othdiag30); 
%ret_ais (e15, e15, prindiag, othdiag1-othdiag30); 

%ret_ais (i06, i06, prindiag, othdiag1-othdiag30); 
%ret_ais (i07, i07, prindiag, othdiag1-othdiag30); 
%ret_ais (i08, i08, prindiag, othdiag1-othdiag30); 
%ret_ais (i09, i09, prindiag, othdiag1-othdiag30); 
%ret_ais (i10, i10, prindiag, othdiag1-othdiag30); 
%ret_ais (i11, i11, prindiag, othdiag1-othdiag30); 
%ret_ais (i12, i12, prindiag, othdiag1-othdiag30); 
%ret_ais (i13, i13, prindiag, othdiag1-othdiag30); 
%ret_ais (i14, i14, prindiag, othdiag1-othdiag30); 
%ret_ais (i15, i15, prindiag, othdiag1-othdiag30); 


/* Consolidated ais all patient data for 2015 */

%Macro ret15 (input1, input2, output);

data &output;
	set &input1 &input2;
run;

%mend ret15;

%ret15 (i15, i15t, i15); /* 45616 obs */
%ret15 (a15, a15t, a15); /* 823 obs */
%ret15 (e15, e15t, e15); /* 5477 obs */


*/ Variable transformation from numeric to Character or from Character to numeric/;

%Macro vartransf (input, output, drg, qtr);
Data &output (keep= sys_recid year maskssn msdrg drg qtr begindate 
	enddate admtype admitdate dischdate gender sex ethnicity race 
	age type_serv dischstat losdays adm_prior admsrc condtn edhr_disch
	edhr_arr adm_time dis_time payer reason_cde zipcode ptcounty 
	fac_region ptstate admitdiag prindiag poa_prin_diag daysproc
	pt_status prinproc tchgs mcare_nbr pro_code atten_phyid 
	atten_phynpi oper_phyid faclnbr hr_arrival serv_loc weekday 
	oper_phynpi othoper_phyid othoper_phynpi mod_code daysproc: 
	poa_ecmorb: ecmorb: poa: evalcode: othproc: othcpt: othdiag:);
Set &input;
	ndrg = put(drg, 9.);
	drop drg;
	rename ndrg=drg;
	
	nqtr = input(qtr, 8.);
	drop qtr;
	rename nqtr=qtr;
run;

%mend vartransf;

%vartransf (a06, a06, drg, qrt); /* 445 obs */
%vartransf (a07, a07, drg, qrt); /* 527 obs */
%vartransf (a08, a08, drg, qrt); /* 403 obs */
%vartransf (a09, a09, drg, qrt); /* 274 obs */
%vartransf (a10, a10, drg, qrt); /* 223 obs */
%vartransf (a11, a11, drg, qrt); /* 308 obs */
%vartransf (a12, a12, drg, qrt); /* 383 obs */
%vartransf (a13, a13, drg, qrt); /* 406 obs */
%vartransf (a14, a14, drg, qrt); /* 519 obs */
%vartransf (a15, a15, drg, qrt); /* 823 obs */
%vartransf (a16, a16, drg, qrt); /* 1292 obs */

%vartransf (e06, e06, drg, qrt); /* 2007 obs */
%vartransf (e07, e07, drg, qrt); /* 2024 obs */
%vartransf (e08, e08, drg, qrt); /* 2422 obs */
%vartransf (e09, e09, drg, qrt); /* 2320 obs */
%vartransf (e10, e10, drg, qrt); /* 2824 obs */
%vartransf (e11, e11, drg, qrt); /* 3075 obs */
%vartransf (e12, e12, drg, qrt); /* 3560 obs */
%vartransf (e13, e13, drg, qrt); /* 3764 obs */
%vartransf (e14, e14, drg, qrt); /* 4135 obs */
%vartransf (e15, e15, drg, qrt); /* 5477 obs */
%vartransf (e16, e16, drg, qrt); /* 6135 obs */

%vartransf (i06, i06, drg, qrt); /* 35757 obs */
%vartransf (i07, i07, drg, qrt); /* 35748 obs */
%vartransf (i08, i08, drg, qrt); /* 36442 obs */
%vartransf (i09, i09, drg, qrt); /* 36711 obs */
%vartransf (i10, i10, drg, qrt); /* 39980 obs */
%vartransf (i11, i11, drg, qrt); /* 40729 obs */
%vartransf (i12, i12, drg, qrt); /* 41939 obs */
%vartransf (i13, i13, drg, qrt); /* 41474 obs */
%vartransf (i14, i14, drg, qrt); /* 43499 obs */
%vartransf (i15, i15, drg, qrt); /* 45616 obs */
%vartransf (i16, i16, drg, qrt); /* 46935 obs */


/* Concatenating ais all patients */

%Macro concat (input1, input2, input3, input4, input5, input6, 
				input7, input8, input9, input10, input11, output);

data &output;
	set &input1 &input2 &input3 &input4 &input5 &input6 
		&input7 &input8 &input9 &input10 &input11;
run;

%mend concat;

%concat (i06, i07, i08, i09, i10, i11, i12, i13, i14, i15, i16, iais); /* inpatients: 444830 obs */ 
%concat (a06, a07, a08, a09, a10, a11, a12, a13, a14, a15, a16, aais); /* ambulantory patients: 5603 obs */
%concat (e06, e07, e08, e09, e10, e11, e12, e13, e14, e15, e16, eais); /* emergency patients: 37743 obs */


/* amb patients, edp patients, inpatients */ 

%Macro format (input, output);

data &output;
   set &input;
   begindate = datepart(begindate);
   format begindate date9.;
   format begindate mmddyy10.;
   enddate = datepart(enddate);
   format enddate date9.;
   format enddate mmddyy10.;
run;

%mend format;

%format (aais, ais.aais);
%format (eais, ais.eais);
%format (iais, ais.iais);

/*Full data (amb + ER + INP)*/

data ais.dataei;set ais.aais ais.eais ais.iais;run; /*obs 488,176*/


/*Step 2*/
/*Creating index date and unique ambpatients, edppatients, inpatients*/

%Macro retindex (input,output1,output2);

data &output1; set &input; run;
proc sort data=&output1;
  by maskssn begindate;
run;

data &output2 (keep=index_dt maskssn);
  set &output1 (rename= (begindate = index_dt));
  by maskssn index_dt;
  if first.maskssn then output;
run;

%mend retindex;

%retindex (ais.iais,iw,ais.indexdt); /*obs 444,830*/


/*Creating datestart and datend*/

%Macro dat (input,output);

data &output (keep =begindate maskssn); set &input; run;

%mend dat;

%dat (dat.amb,amb);
%dat (dat.edp,edp);
%dat (dat.inp,inp);


/* Inpatients */
/***********************/

%Macro datst (input,input1,input2,output,output1,output2);

/***********************/
data &output; set &input; keep maskssn; run;

proc sql;
create table y as select a.*,b.* 
from &output a left join &input1 b
on a. maskssn= b. maskssn;
quit;

proc sort data=y; by maskssn begindate; run;

 data &output1;
   set y;
   BY maskssn;
   retain dtstart;                
   if FIRST.maskssn then do;
      dtstart = begindate;        
   end;
   if LAST.maskssn then do;
      dtend = begindate; 
              format dtstart mmddyy10.;
              format dtend mmddyy10.;
      output;                                        
   end;
run;
/***********************/
proc sql;
create table y as select a.*,b.* 
from &output a left join &input2 b
on a. maskssn= b. maskssn;
quit;

proc sort data=y; by maskssn begindate; run;

 data &output2;
   set y;
   BY maskssn;
   retain dtstart;                 
   if FIRST.maskssn then do;
      dtstart = begindate;       
   end;
   if LAST.maskssn then do;
      dtend = begindate; 
              format dtstart mmddyy10.;
              format dtend mmddyy10.;
      output;                                         
   end;
run;
/***********************/

%mend datst;

%datst (ais.indexdt,inp,amb,x,ais.inp1,ais.amb1);


/***********************/

%Macro conca (input,input1,output);

data &output; set &input &input1; run;

%mend conca;

%conca (ais.inp1,ais.amb1,datindxi);
%conca (ais.inp2,ais.amb2,datindxaei);


%Macro dtstr (input,output,output1);

data &output; set &input; if begindate='.' then delete; run; 
proc sort data= &output; by maskssn dtstart dtend; run;

 data &output;
   set &output;
   BY maskssn;
   retain dt_start;                 
   if FIRST.maskssn then do;
      dt_start = dtstart;        
   end;
   if LAST.maskssn then do;
      dt_end = dtend; 
              format dt_start mmddyy10.;
              format dt_end mmddyy10.;
      output;                                         
   end;
run;

data &output1; * obs 359456 *;
   set &output;
   keep maskssn dt_start dt_end;               
run;

%mend dtstr;

%dtstr (datindxi,datindxi,ais.datindxv)


/* Joining our index date with our original ihd data file: work */;

%Macro jindx (input,input1,output);

proc sql;
create table &output as select a.*,b.* 
from &input1 a left join &input b
on a. maskssn= b. maskssn;
quit;

%mend jindx;

%jindx (ais.indexdt,iw,iw);


/*Joining our datestart/datend with our original ihd data file */

%Macro jdatst (input,input1,output);

proc sql;
create table &output as select a.*,b.* 
from &input1 a left join &input b
on a. maskssn= b. maskssn;
quit;

%mend jdatst;

%jdatst (datindxi,iw,ais.datindxi); /*obs 444830*/


/*Step 3*/
/*Merging primary care physician (tx) to inpatient*/
/*constructing the treatment variable (tx)*/

data aaist; set ais.aais; keep maskssn amb; amb=1; run;
data aaist; set aaist; proc sort; by maskssn; run;
data aaist; set aaist; by maskssn;
    retain pcp;
      if first.maskssn then pcp=amb;
      else pcp=amb+pcp;
      if last.maskssn;
      if pcp>1;
      tx=1;
run;

/*Merging step*/
data aaist1; set aaist; keep maskssn pcp tx;run;
proc sql;
create table iaist as select a.*,b.* 
from ais.datindxi a left join aaist1 b
on a. maskssn= b. maskssn;
quit;

data iaist;set iaist;if tx=. then tx=0;if pcp=. then pcp=0;run;


/*Step 4*/
/*Merging emergency to inpatient*/

data eaist; set ais.eais; keep maskssn er; er=1; run;
proc sql;
create table iaist as select a.*,b.* 
from iaist a left join eaist b
on a. maskssn= b. maskssn;
quit;

data iaist; set iaist;if er=. then er=0; ih=1;run;

/*Storing the data for the rest of our analysis*/
data ais.datindx;set iaist;run; *obs 16253955*;


/*Step 5*/
/*Defining the lookback and follow up period "continiuos enrolment" five year lookback & one year lookforward dataset**/

%Macro lback (input,input1,input2,output);

data &output; set &input; 
if (index_dt-&input1) > dt_start and (index_dt+&input2) < dt_end then output; 
run;

%mend lback;

%lback (ais.datindx,1825,365,ais.datindx1); /* obs 24856*/
/*all patients have been hospitalized: 24,856*/
/*Patients visit in Emergency room: 1,734*/
/*Patients who have a Primary Care Physician: 39*/
proc freq data=ais.datindx1; tables ih er tx;run;


/*Step 6*/
/* Create a dataset that includes multiple variables */

%Macro dx_comorb (input, output);

Data &output;
Set &input;
array CONDITIONS (16) hld tia Stroke cvd chf htn dm cad pvd copd dep anx inf vpn bpn mpn;
do i= 1 to 16; 
CONDITIONS (i)=0;
end;
 
array dx3 $ prindiag othdiag1-othdiag30;
do over dx3;

		/* Hyperlipidemia */;
	
         if  dx3 in ('272.0', '272.1', '272.2', '272.4', '272.9', '414.3') then hld = 1;
            LABEL hld='Hyperlipidemia';

         /* Transient Ischemic Attack */
         if  dx3 IN ('435.8', '435.9', 'V12.54', 'G45.9') then tia = 1;
            LABEL  tia ='Transient Ischemic Attack';

         /* Stroke */
         if  dx3 IN ('433', '434', '436') then Stroke = 1;
            LABEL Stroke='Stroke';

         /* Other Cerebrovascular Disease */
         if  dx3 IN ('430', '431', '432', '435.0', '435.1', '435.2', '435.3', '435.4', '435.5', '435.6', '435.7', '437', '438.0', '438.1', 
					      '438.2', '438.3', '438.4', '438.5', '438.6', '438.7', '438.8', '438.9') then cvd = 1;
            LABEL  cvd ='Other Cerebrovascular Disease';

		 /* Heart Failure */
         if  dx3 IN ('398.91', '413.9', '428.0', '428.1', '428.2', '428.3', '428.4', '428.5', '428.6', '428.7', '428.8', '428.9'
					    'I50.2', 'I50.20', 'I50.21', 'I50.22', 'I50.23', 'I50.3', 'I50.30', 'I50.31', 'I50.32', 'I50.33', 'I50.4', 
					    'I50.40', 'I50.41', 'I50.42', 'I50.43') then chf = 1;
            LABEL chf='Heart Failure';

		/* Essential Hypertension */
         if  dx3 IN ('401.1', '401.2', '401.3', '401.4', '401.5', '401.6', '401.7', '401.8', '401.9', 'I11.0') then htn = 1;
            LABEL  htn ='Essential Hypertension';
            
         /* Diabetes Mellitus */
         if  dx3 IN ('250.0', '250.1', '250.2', '250.3', '250.4', '250.5', '250.6', '250.7', '250.8', '250.9') then dm = 1;
            LABEL dm ='Diabetes Mellitus';
            
         /* Other Coronary Artery Disease */
         if  dx3 IN ('411.0', '411.1', '411.81', '411.89', '413.0', '413.1', '413.9', '414.00', '414.01', '414.02', '414.03', '414.04', 
				         '414.05', '414.06', '414.07', '414.2', '414.3', '414.9', 'V45.81', 'V45.82') then cad = 1;
           LABEL cad ='Other Coronary Artery Disease';

         /* Peripheral Vascular Disease */
         if  dx3 IN ('443.9', 'I73.9') then pvd = 1;
           LABEL pvd ='Peripheral Vascular Disease';

         /* Chronic Obstructive Pulmonary Disease */
         if  dx3 IN ('491', '492', '494', '496', '506', 'J40', 'J41.0', 'J41.1', 'J41.8', 'J42', 'J43.0', 'J43.2', 'J43.8', 'J43.9', 'J44.0',
			         'J44.1', 'J44.9', 'J47') then copd = 1;
           LABEL copd='Chronic Obstructive Pulmonary Disease';
           
           /* Depression Disease */
         if  dx3 IN ('296.51', '296.52', '296.53', '296.54', '296.6', '296.21', '296.22', '296.23', '296.24', '296.25', '296.26', '296.20',
				    '296.82', '296.31', '311', '296.32', '296.33', '296.34', '296.35', '296.36', '296.30', '296.99', '296.90', '309.0', 
				    '309.28', '296.82', '298', '3409.1', 'F31.31','F31.32', 'F31.4', 'F31.5', 'F31.6', 'F31.9', 'F32.0', 'F32.1', 
			       'F32.2', 'F32.3', 'F332.4','F32.5', 'F32.8', 'F32.9', 'F33.0', 'F33.1', 'F33.2', 'F33.3', 'F33.41','F33.42', 'F33.8', 
			       'F33.9', 'F34.1', 'F34.8', 'F34.9', 'F38.0', 'F38.1','F38.8', 'F39', 'F41.2', 'F43.2', 'F99') then dep = 1;
           LABEL dep=' Depression';
           
              /* Anxiety Disease */
         if  dx3 IN ('300', '293.84', '300.00', '300.09', '300.02', '309.21', '309.24', '300.2', '300.4',
				    '296.82', '296.31', '311', '296.32', '296.33', 'F41.9', 'F41.8', 'F41.0', 'F41.1', 'F41.3') then anx = 1;
           LABEL anx='Anxiety ';
           
           /*Influenza */
         if  dx3 IN ('J09', 'J09.X', 'J09.X1', 'J09.X2', 'J09.X3', 'J09.X9', 'J10', 'J10.0', 
		'J10.00', 'J10.01', 'J10.08', 'J10.1', 'J10.2', 'J10.8', 'J10.81', 'J10.82', 'J10.83', 
		'J10.89', 'J11', 'J11.0', 'J11.00', 'J11.08', 'J11.1', 'J11.2', 'J11.8', 'J11.81', 
		'J11.82', 'J11.83', 'J11.89', '487', '487.0', '487.1', '487.8', '488', '488.0', 
		'488.01', '488.02', '488.09', '488.1', '488.11', '488.12', '488.19', '488.8', 
		'488.81', '488.82', '488.89') then inf=1;
			LABEL inf= 'Influenza' ;
			
			/*Viral Pneumonia*/
		if  dx3 IN ('J12', 'J12.0', 'J12.1', 'J12.2', 'J12.3', 'J12.8', 'J12.81', 
		'J12.89', 'J12.9','480', '480.0', '480.1', '480.2', '480.3', '480.3', '480.8', 
		'480.8', '480.9', '480.9') then vpn=1;
			LABEL vpn='Viral Pneumonia';
			
			/*Bacterial Pneumonia*/
		if  dx3 IN ('J15', 'J15.0', 'J15.1', 'J15.2', 'J15.20', 'J15.21', 
		'J15.211', 'J15.212', 'J15.29', 'J15.3', 'J15.4', 'J15.5', 'J15.6', 'J15.7', 
		'J15.8', 'J15.9', '482', '482.0', '482.1', '482.2', '482.2', '482.3', '482.30', 
		'482.30', '482.31', '482.32', '482.39', '482.4', '482.40', '482.41', '482.42', 
		'482.49', '482.8', '482.81', '482.82', '482.83', '482.84', '482.89', '482.9') then bpn=1; 
			LABEL bpn= 'Bacterial Pneumonia';
			
			/*mislenuoness Causes Pneumonia*/
		else if prindiag in ('J13', 'J14', 'J16', 'J16.0', 'J16.8', 'J17', 'J18', 
		'J18.0', 'J18.1', 'J18.2', 'J18.8', 'J18.9', '483', '483.0', '483.1', '483.8', 
		'484', '484.1', '484.3', '484.5', '484.6', '484.7', '484.8', '485', '486') then mpn=1; 
			LABEL mpn= 'mislenuoness Causes Pneumonia';
    end;
run;

%mend;

%dx_comorb (ais.iais, ais.dx_varbl);


/*keeping the needed variables (comorbidities)*/

%Macro dx_ret (input, output);

data &output; set &input;
keep maskssn hld tia Stroke cvd chf htn dm cad pvd copd dep anx inf vpn bpn mpn;
run;

%mend dx_ret;

%dx_ret (ais.dx_varbl, dx_varbl);


%Macro dx_com (input, output1,output2,output3,output4,output5,
	output6,output7,output8,output9,output10,output11,output12, 
	output13,output14,output15,output16);

data &output1; set &input; keep maskssn hld; where hld=1; run;
proc sort data=&output1 nodupkey; by maskssn; run; 
data &output2; set &input; keep maskssn tia; where tia=1; run;
proc sort data=&output2  nodupkey; by maskssn; run; 
data &output3; set &input; keep maskssn stroke; where Stroke=1; run;
proc sort data=&output3 nodupkey; by maskssn; run; 
data &output4; set &input; keep maskssn cvd; where cvd=1; run;
proc sort data=&output4 nodupkey; by maskssn; run; 
data &output5; set &input; keep maskssn chf; where chf=1; run;
proc sort data=&output5 nodupkey; by maskssn; run; 
data &output6; set &input; keep maskssn htn; where htn=1; run;
proc sort data=&output6 nodupkey; by maskssn; run; 
data &output7; set &input; keep maskssn dm; where dm=1; run;
proc sort data=&output7 nodupkey; by maskssn; run; 
data &output8; set &input; keep maskssn cad; where cad=1; run;
proc sort data=&output8 nodupkey; by maskssn; run; 
data &output9; set &input; keep maskssn pvd; where pvd=1; run;
proc sort data=&output9 nodupkey; by maskssn; run; 
data &output10; set &input; keep maskssn copd; where copd=1; run;
proc sort data=&output10 nodupkey; by maskssn; run;
data &output11; set &input; keep maskssn dep; where dep=1; run;
proc sort data=&output11 nodupkey; by maskssn; run;
data &output12; set &input; keep maskssn anx; where anx=1; run;
proc sort data=&output12 nodupkey; by maskssn; run; 
data &output13; set &input; keep maskssn inf; where inf=1; run;
proc sort data=&output13 nodupkey; by maskssn; run; 
data &output14; set &input; keep maskssn vpn; where vpn=1; run;
proc sort data=&output14 nodupkey; by maskssn; run;
data &output15; set &input; keep maskssn bpn; where bpn=1; run;
proc sort data=&output15 nodupkey; by maskssn; run;
data &output16; set &input; keep maskssn mpn; where mpn=1; run;
proc sort data=&output16 nodupkey; by maskssn; run; 


%mend dx_com;

%dx_com (dx_varbl,ihld,itia,iStroke,icvd,ichf,ihtn,idm,icad,ipvd,icopd,idep,ianx,iinf,ivpn,ibpn,impn);


/*Addressing the comorbidity; Step 1*/

%Macro comorb (input, output);

data &output; set &input; keep maskssn; run;
proc sort data=&output nodupkey; by maskssn; run;

%mend comorb;

%comorb (ais.datindx1, comorbi)


/*Addressing the comorbidity; Step 2*/

%Macro dx_comorb (input, input1,input2,input3,input4,input5,
	input6,input7,input8,input9,input10,input11,input12,
	input13,input14,input15,input16,output);

proc sql;
create table comorbidity as select a.*, b.*
from &input a left join &input1 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input2 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input3 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input4 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input5 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input6 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input7 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input8 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input9 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input10 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input11 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input12 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input13 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input14 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table comorbidity as select a.*, b.*
from comorbidity a left join &input15 b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table &output as select a.*, b.*
from comorbidity a left join &input16 b
on a. maskssn= b. maskssn;
quit;

%mend dx_comorb;

%dx_comorb (comorbi,ihld,itia,iStroke,icvd,ichf,ihtn,idm, 
			icad,ipvd,icopd,idep,ianx,iinf,ivpn,ibpn,impn,comorbi);


%Macro dx_comor (input, output);

data &output; set &input;
if hld =. then hld=0;
if tia=. then tia=0;
if stroke=. then stroke=0;
if cvd =. then cvd=0;
if chf =. then chf=0;
if htn =. then htn=0;
if dm =. then  dm=0;
if cad =. then cad=0;
if pvd =. then pvd=0;
if copd=. then copd=0;
if dep =. then dep=0;
if anx=. then anx=0;
if inf =. then inf=0;
if vpn=. then vpn=0;
if bpn =. then bpn=0;
if mpn=. then mpn=0;
run;

%mend dx_comor;

%dx_comor (comorbi, comorbi)


/*Combining comorbidities with the original data files*/

%Macro comstr (input1, input2, output);

proc sql;
create table &output as select a.*, b.* 
from &input1 a left join &input2 b
on a. maskssn= b. maskssn;
quit;

%mend comstr;

%comstr (ais.datindx1, comorbi, ais.datindx1); /* obs	24856*/

/*Step 7*/
/* death Variable Creation*/

%Macro death (input,output);

data h; set &input; proc sort; by maskssn; run;
data &output; set h; by maskssn;
    retain death;
    if dischstat in (20,50,51) then death=1;
      else death= 0;
run;

%mend death;

%death (ais.datindx1,ais.datindx1)


/*****************************************************************/
/*****************************************************************/
/*****************************************************************/

%Macro adm (input, output);

/*creating disharge_dt for each index_dt (dis_index_dt=index_dt+ losdays), and readm 30*/
data &output; set &input (rename =(begindate = adm_dt)); run;
data &output; set &output; 
  dis_index_dt = index_dt + losdays;
    format dis_index_dt mmddyy10.;

readm30= index_dt+losdays+30;
readm60= index_dt+losdays+60;
readm90= index_dt+losdays+90;
readm180= index_dt+losdays+180;
      format readm30 mmddyy10.;
      format readm60 mmddyy10.;
      format readm90 mmddyy10.;
      format readm180 mmddyy10.;
run;

%mend adm;

%adm (ais.datindx1,ais.datindx1); /*24856*/


/*creating readmXX variables*/

%Macro readm (input,output);

data &output; set &input; 
if dis_index_dt < adm_dt <= readm30 then readm_30=1; else readm_30=0;
if dis_index_dt < adm_dt <= readm30 and er=1 then visit_30=1; else visit_30=0;
if dis_index_dt < adm_dt <= readm30 and death=1 then death_30=1; else death_30=0;
if dis_index_dt < adm_dt <= readm60 and death=1 then death_60=1; else death_60=0;
if dis_index_dt < adm_dt <= readm90 and death=1 then death_90=1; else death_90=0;
if dis_index_dt < adm_dt <= readm180 and death=1 then death_180=1; else death_180=0;
run;

%mend readm;

%readm (ais.datindx1,ais.datindx1);


/*Step 8*/
/*Variable harmonization*/

%Macro harm (input,output);

data &output; set &input; 
drop npoa_prin_diag npoa poa poa_prin_diag poa1-poa30 poa_ecmorb1 
poa_ecmorb2 poa_ecmorb3 hr_arrival condtn readm30 readm60 readm90 
readm180 dis_index_dt index_dt dtstart dtend dt_start dt_end
npoa_ext_injury1 npoa_ext_injury2 npoa_ext_injury3;
 
/*categorize ethnicity*/
	if ethnicity = 'E1' then ethnicity = 1;
	else if ethnicity = 'E2' then ethnicity = 2;
	else if ethnicity = 'E7' then ethnicity = 3;
	
	nethnicity = input(ethnicity, 8.);
	drop ethnicity;
	rename nethnicity=ethnicity;

*categorize age*;
	if 18 <= age <= 49 then agegrp=1;
	else if 50 <= age <65  then agegrp=2;
	else if 65 <= age <=74  then agegrp=3;
	else if 75 <= age then agegrp=4;
	
*categorize los*;
	if losdays in (1,2) then los=1;
	else if losdays in (3,4) then los=2;
	else if losdays in (5,7) then los=3;
	else if losdays > 7 then los=4;

*categorize gender*;
	if sex ='M' then sex = 1; * Male *;
	else if sex ='F' then sex = 2; * Female *;
	else if sex ='U' then sex = 3; * Unknown *;

*categorize race*;
	if race = 3 then newrace = 1; * Black *;
	if race = 5 then newrace = 2; * White *;
	if race in (1 2 4 6 7) then newrace = 3; * All Others *;
	drop race;
	rename newrace =race;
	
*categorize payer*;
	if payer in ('L', 'N') then newpayer = 0; * No Insurance *;
	if payer in ('A', 'B', 'C', 'D', 'I', 'J', 'K', 'O', 'H') then newpayer = 1; * Government Insurance *;
	if payer in ('E', 'F', 'G', 'Q') then newpayer = 2; * Private Insurance *;
	if payer in ('M') then newpayer = 3; * Other Insurance *;
	drop payer;
	rename newpayer=payer;
	
*categorize states*;
	if ptstate ='FL' then ptstate = 1; * Florida *;
	else ptstate = 2; * Other than Florida *;
*exlusion criteria1*;
	if ptstate=1;	

*reformating admsrc*;
nadmsrc = input(admsrc, 6.);
	drop admsrc;
rename nadmsrc=admsrc;
if admsrc='01' then admsrc=1; *Non-Health Care Facility Point of Origin*; 
if admsrc='02' then admsrc=2; *Clinic or Physician’s Office*;
if admsrc='04' then admsrc=3; *Transfer from a Hospital *;
if admsrc='05' then admsrc=4; *Transfer from a Skilled Nursing Facility (SNF) or Intermediate Care Facility (ICF)*;
if admsrc='06' then admsrc=5; *Transfer from another health care facility*;
if admsrc='08' then admsrc=6; *Court/Law Enforcement*;
if admsrc='09' then admsrc=7; *Information Not Available*;
if admsrc='D' then admsrc=8; *Transfer from one distinct unit of the hospital to another distinct unit of the same hospital resulting in a separate claim*;
if admsrc='E' then admsrc=9; *Transfer from an Ambulatory Surgery Center*;
if admsrc='F' then admsrc=10; *Transfer from a hospice facility & under a hospice plan of care or enrolled in a hospice program Codes Required for Newborn Admissions*;
if admsrc='10' then admsrc=11; *Born inside this hospital*;
if admsrc='13' then admsrc=12; *Born outside this hospital*;

npoa_prin_diag = input(poa_prin_diag, 6.);
	drop poa_prin_diag;
if poa_prin_diag ='N' then condpr=0; *Not present at the time that the order for inpatient admission occurs*;
if poa_prin_diag ='Y' then condpr=1; *Present at time that order for inpatient admission occurs*;
if poa_prin_diag ='U' then condpr=2; *Documentation is insufficient to determine if condition is present on admission*;
if poa_prin_diag ='W' then condpr=3; *Provider is unable to clinically determine whether the condition was present on admission or not*;
if poa_prin_diag in ('E','1') then condpr=4; *The condition is exempt from POA reporting*;
drop npoa_prin_diag;

npoa = input(poa, 6.);
array px $ poa_prin_diag poa1-poa30;
do over px;
if px ='N' then condprs=0; *Not present at the time that the order for inpatient admission occurs*;
if px ='Y' then condprs=1; *Present at time that order for inpatient admission occurs*;
if px ='U' then condprs=2; *Documentation is insufficient to determine if condition is present on admission*;
if px ='W' then condprs=3; *Provider is unable to clinically determine whether the condition was present on admission or not*;
if px in ('E','1') then condprs=4; *The condition is exempt from POA reporting*;
end;

npoa_ext_injury1 = input(poa_ext_injury1, 6.);
	drop poa_ext_injury1;
if poa_ext_injury1 ='N' then exinju1=1; *Not present at the time that the order for inpatient admission occurs*;
if poa_ext_injury1 ='Y' then exinju1=2; *Present at time that order for inpatient admission occurs*;
if poa_ext_injury1 ='U' then exinju1=3; *Documentation is insufficient to determine if condition is present on admission*;
if poa_ext_injury1 ='W' then exinju1=4; *Provider is unable to clinically determine whether the condition was present on admission or not*;
if poa_ext_injury1 ='E' then exinju1=5; *The condition is exempt from POA reporting*;
if exinju1=. then exinju1=0;
drop poa_ext_injury1;

npoa_ext_injury2 = input(poa_ext_injury2, 6.);
	drop poa_ext_injury2;
if poa_ext_injury2 ='N' then exinju2=1; *Not present at the time that the order for inpatient admission occurs*;
if poa_ext_injury2 ='Y' then exinju2=2; *Present at time that order for inpatient admission occurs*;
if poa_ext_injury2 ='U' then exinju2=3; *Documentation is insufficient to determine if condition is present on admission*;
if poa_ext_injury2 ='W' then exinju2=4; *Provider is unable to clinically determine whether the condition was present on admission or not*;
if poa_ext_injury2 ='E' then exinju2=5; *The condition is exempt from POA reporting*;
if exinju2=. then exinju2=0;
drop poa_ext_injury2;

npoa_ext_injury3 = input(poa_ext_injury3, 6.);
	drop poa_ext_injury3;
if poa_ext_injury3 ='N' then exinju3=1; *Not present at the time that the order for inpatient admission occurs*;
if poa_ext_injury3 ='Y' then exinju3=2; *Present at time that order for inpatient admission occurs*;
if poa_ext_injury3 ='U' then exinju3=3; *Documentation is insufficient to determine if condition is present on admission*;
if poa_ext_injury3 ='W' then exinju3=4; *Provider is unable to clinically determine whether the condition was present on admission or not*;
if poa_ext_injury3 ='E' then exinju3=5; *The condition is exempt from POA reporting*;
if exinju3=. then exinju3=0;
drop poa_ext_injury3;

if weekday in (6,7) then weekend=1; *whether admitted on weekend*;
else weekend=0;

if prindiag=admitdiag then diag=1; *whether prindiag and admitdiag are same*;
else diag=0;

ncondtn = put(condtn, 6.);
drop condtn;
rename ncondtn=condtn;
if condtn='P7' then cond=1; *Patient received treatment in this facility’s emergency department.*;
if condtn='00' then cond=2; *Not admitted through this facility’s emergency department.*;
if condtn='NR' then cond=3; *Not reported*;

/* formarting poa_ecmorb1*/
npoa_ecmorb1 = input(poa_ecmorb1, 6.);
drop poa_ecmorb1;
rename npoa_ecmorb1=poa_ecmorb1;
if poa_ecmorb1 ='Y' then pecmorb1=1;
if poa_ecmorb1 ='N' then pecmorb1=2;
if poa_ecmorb1 ='U' then pecmorb1=3;
if poa_ecmorb1 ='W' then pecmorb1=4;
if poa_ecmorb1 in ('E','1') then pecmorb1=5;
if pecmorb1=. then pecmorb1=0;
/* formarting poa_ecmorb2*/
npoa_ecmorb2 = input(poa_ecmorb2, 6.);
drop poa_ecmorb2;
rename npoa_ecmorb2=poa_ecmorb2;
if poa_ecmorb2 ='Y' then pecmorb2=1;
if poa_ecmorb2 ='N' then pecmorb2=2;
if poa_ecmorb2 ='U' then pecmorb2=3;
if poa_ecmorb2 ='W' then pecmorb2=4;
if poa_ecmorb2 in ('E','1') then pecmorb2=5;
if pecmorb2=. then pecmorb2=0;
/* formarting poa_ecmorb3*/
npoa_ecmorb3 = input(poa_ecmorb3, 6.);
drop poa_ecmorb3;
rename npoa_ecmorb3=poa_ecmorb3;
if poa_ecmorb3 ='Y' then pecmorb3=1;
if poa_ecmorb3 ='N' then pecmorb3=2;
if poa_ecmorb3 ='U' then pecmorb3=3;
if poa_ecmorb3 ='W' then pecmorb3=4;
if poa_ecmorb3 in ('E','1') then pecmorb3=5;
if pecmorb3=. then pecmorb3=0;

/*adm time and employees shift time*/
if adm_time in (00,01,02,03,04,05) then admtime=1;
if adm_time in (06,07) then admtime=2; /*switch 1*/
if adm_time in (08,09.10,11,12,13) then admtime=3;
if adm_time in (14,15) then admtime=4; /*switch 2*/
if adm_time in (16,17,18,19,20,21) then admtime=5;
if adm_time in (22,23) then admtime=6; /*switch 3*/
else admtime=7; /*Unknown*/
drop adm_time;

/*dis time and employees shift time*/
if dis_time in (00,01,02,03,04,5) then distime=1;
if dis_time in (6,7) then distime=2; /*switch 1*/
if dis_time in (08,09,10,11,12,13) then distime=3;
if dis_time in (14,15) then distime=4; /*switch 2*/
if dis_time in (16,17,18,19,20,21) then distime=5;
if dis_time in (22,23) then distime=6; /*switch 3*/
else distime=7; /*Unknown*/
drop dis_time;

/*edhr_arr and employees shift time*/
if edhr_arr in (00,01,02,03,04,5) then edhrarr=1;
if edhr_arr in (6,7) then edhrarr=2; /*switch 1*/
if edhr_arr in (08,09,10,11,12,13) then edhrarr=3;
if edhr_arr in (14,15) then edhrarr=4; /*switch 2*/
if edhr_arr in (16,17,18,19,20,21) then edhrarr=5;
if edhr_arr in (22,23) then edhrarr=6; /*switch 3*/
else edhrarr=7; /*Unknown*/
drop edhr_arr;

/*Type of sverity*/
if drg=061 then sevr=1; /*ACUTE ISCHEMIC STROKE W USE OF THROMBOLYTIC AGENT W MCC*/
if drg=062 then sevr=2; /*ACUTE ISCHEMIC STROKE W USE OF THROMBOLYTIC AGENT W CC*/
if drg=063 then sevr=3; /*ACUTE ISCHEMIC STROKE W USE OF THROMBOLYTIC AGENT W/O CC/MCC*/
else sevr=4;

array vars{*} prindiag othdiag1-othdiag30;
ndiag = 0;
do i = 1 to dim(vars);
  if not missing(vars{i}) then ndiag + 1;
end;
drop i admitdiag prindiag othdiag:;

array vars1{*} prinproc othproc1-othproc30;
nproc=0;
do j = 1 to dim(vars1);
  if not missing(vars1{j}) then nproc+1;
end;
drop j prinproc othproc:;

array vars2{*} ecmorb1-ecmorb3;
necmorb=0;
do k = 1 to dim(vars2);
  if not missing(vars2{k}) then necmorb+1;
end;
drop k mod_code atten_phyid oper_phyid othoper_phyid oper_phynpi othoper_phynpi ecmorb:;

run;

%mend harm;

%harm (ais.datindx1,ais.datindx2); *obs 24646*;

/*Apply Selection Criteria*/
data ais.datindx3;set ais.datindx2;
ndischstat = input(dischstat, 6.);
drop dischstat;
rename ndischstat=dischstat;
if dischstat='01' then ptstat=1;
if dischstat='02' then ptstat=2;
if dischstat='03' then ptstat=3;
if dischstat='04' then ptstat=4;
if dischstat='06' then ptstat=5;
if dischstat='62' then ptstat=6;
if dischstat='63' then ptstat=7;
if dischstat='64' then ptstat=8;
if dischstat='65' then ptstat=9;
if dischstat='66' then ptstat=10;

if (pecmorb1=0 and pecmorb2=0 and pecmorb3=0)or
(pecmorb1=0 and pecmorb2=0 and pecmorb3 ne 0)or
(pecmorb1=0 and pecmorb2 ne 0 and pecmorb3=0)or
(pecmorb1 ne 0 and pecmorb2=0 and pecmorb3=0) then pecmorb=0;

if (pecmorb1=1 and pecmorb2=1 and pecmorb3=1)or
(pecmorb1=1 and pecmorb2=1 and pecmorb3 ne 1)or
(pecmorb1=1 and pecmorb2 ne 1 and pecmorb3=1)or
(pecmorb1 ne 1 and pecmorb2=1 and pecmorb3=1) then pecmorb=1;

if (pecmorb1=2 and pecmorb2=2 and pecmorb3=2)or
(pecmorb1=2 and pecmorb2=2 and pecmorb3 ne 2)or
(pecmorb1=2 and pecmorb2 ne 2 and pecmorb3=2)or
(pecmorb1 ne 2 and pecmorb2=2 and pecmorb3=2) then pecmorb=2;

if (pecmorb1=3 and pecmorb2=3 and pecmorb3=3)or
(pecmorb1=3 and pecmorb2=3 and pecmorb3 ne 3)or
(pecmorb1=3 and pecmorb2 ne 3 and pecmorb3=3)or
(pecmorb1 ne 3 and pecmorb2=3 and pecmorb3=3) then pecmorb=3;

if (pecmorb1=4 and pecmorb2=4 and pecmorb3=4)or
(pecmorb1=4 and pecmorb2=4 and pecmorb3 ne 4)or
(pecmorb1=4 and pecmorb2 ne 4 and pecmorb3=4)or
(pecmorb1 ne 4 and pecmorb2=4 and pecmorb3=4) then pecmorb=4;

if (pecmorb1=5 and pecmorb2=5 and pecmorb3=5)or
(pecmorb1=5 and pecmorb2=5 and pecmorb3 ne 5)or
(pecmorb1=5 and pecmorb2 ne 5 and pecmorb3=5)or
(pecmorb1 ne 5 and pecmorb2=5 and pecmorb3=5) then pecmorb=5;

if (exinju1=0 and exinju2=0 and exinju3=0)or
(exinju1=0 and exinju2=0 and exinju3 ne 0)or
(exinju1=0 and exinju2 ne 0 and exinju3=0)or
(exinju1 ne 0 and exinju2=0 and exinju3=0) then exinju=0;

if (exinju1=1 and exinju2=1 and exinju3=1)or
(exinju1=1 and exinju2=1 and exinju3 ne 1)or
(exinju1=1 and exinju2 ne 1 and exinju3=1)or
(exinju1 ne 1 and exinju2=1 and exinju3=1) then exinju=1;

if (exinju1=2 and exinju2=2 and exinju3=2)or
(exinju1=2 and exinju2=2 and exinju3 ne 2)or
(exinju1=2 and exinju2 ne 2 and exinju3=2)or
(exinju1 ne 2 and exinju2=2 and exinju3=2) then exinju=2;

if (exinju1=3 and exinju2=3 and exinju3=3)or
(exinju1=3 and exinju2=3 and exinju3 ne 3)or
(exinju1=3 and exinju2 ne 3 and exinju3=3)or
(exinju1 ne 3 and exinju2=3 and exinju3=3) then exinju=3;

if (exinju1=4 and exinju2=4 and exinju3=4)or
(exinju1=4 and exinju2=4 and exinju3 ne 4)or
(exinju1=4 and exinju2 ne 4 and exinju3=4)or
(exinju1 ne 4 and exinju2=4 and exinju3=4) then exinju=4;

if (exinju1=5 and exinju2=5 and exinju3=5)or
(exinju1=5 and exinju2=5 and exinju3 ne 5)or
(exinju1=5 and exinju2 ne 5 and exinju3=5)or
(exinju1 ne 5 and exinju2=5 and exinju3=5) then exinju=5;

where dischstat in (01,02,03,04,06,20,50,51,62,63,64,65,66); 

run;

data ais.datindx3;set ais.datindx3;
if ptstat=. then ptstat=0;
drop daysproc;
drop poa_ecmorb1;
drop poa_ecmorb2;
drop poa_ecmorb3;
drop condtn;
drop dischstat;
drop exinju1;
drop exinju2;
drop exinju3;
drop pecmorb1;
drop pecmorb2;
drop pecmorb3;
run;

data aaisc;set ais.aais;keep maskssn losdays tchgs;
rename losdays=losamb;rename tchgs=tchgamb;run;

data eaisc;set ais.eais;keep maskssn losdays tchgs;
rename losdays=loser;rename tchgs=tchger;run;

proc sql;
create table v as select a.*, b.* 
from ais.datindx3 a left join aaisc b
on a. maskssn= b. maskssn;
quit;

proc sql;
create table v as select a.*, b.* 
from v a left join eaisc b
on a. maskssn= b. maskssn;
quit;

data ais.datindx4;set v;if losamb=. then losamb=0;if tchgamb=. then tchgamb=0;
if loser=. then loser=0;if tchger=. then tchger=0;aistchg=tchgs+tchgamb+tchger;
aislos=losdays+losamb+loser;
*categorize aislos*;
	if aislos in (1,2) then caislos=1;
	else if aislos in (3,4) then caislos=2;
	else if aislos in (5,7) then caislos=3;
	else if aislos > 7 then caislos=4;
	
	if ih=1 and er=0 and tx=1 then ptgrp=1; /*no er and yes ih and yes tx*/
	if ih=1 and er=0 and tx=0 then ptgrp=2; /*no er and yes ih and no tx*/
	if ih=1 and er=1 and tx=1 then ptgrp=3; /*yes er and yes ih and yes tx*/
	if ih=1 and er=1 and tx=0 then ptgrp=4; /*yes er and yes ih and no tx*/
drop pro_code adm_dt enddate type_serv ptstate; 
run;

proc freq data=ais.datindx4; tables ptgrp tx er ih death readm_30 
visit_30 death_30 death_60 death_90 death_180;run;



/*Demographics 

Age, Sex, Payer(Medicare, Medicaid, private insurance, self-pay, 
no charge, other), Patient location (urban/rural classification), 
Household income quartiles 

Admission & discharge information 
Admission on weekend, Disposition of patient, Elective admission, 
Emergency Department (ED) services, Transferring to rehabilitation, 
Length of stay 

Clinical information 
Type and number of Diagnoses (ICD-9-CM), External causes of injury 
codes (ICD-9-CM), Procedures (ICD-9-CM), Number of chronic conditions, 
Major operating room procedure indicator 

Severity information 
Risk of mortality of 3M All Patient Refined Diagnosis-Related 
Group (APR-DRG), Severity of illness of APR-DRG, AHRQ comorbidity 
measures, Chronic condition body system indicators, Procedure class 
for all ICD-9-CM procedures 

Hospital information 
Control/ownership of hospital, Size of hospital based on the number 
of beds, Teaching status of hospital, Hospital urban-rural location 

Previous Admissions information 
Number of days from the most recent previous admission of any kind 
and the same APR-DRG in CY2013, Number of previous admissions of any 
nd and the same APR-DRG in CY2013, Frequency of previous admissions 
of any kkiind and the same APR- DRG in CY2013, Average number of days 
between admissions

Florida regions economic information
 */ 


