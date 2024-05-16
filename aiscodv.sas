/***************************************************************************************/

Libname users "/Volumes/My Passport for Mac/aisproject"; /*Project Library*/
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
/*Total sample for our inpatient cohort 37732554/ 


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

%retindex (ais.aais,aw,ais.indexdta); /*obs 4709*/
%retindex (ais.eais,ew,ais.indexdte); /*obs 34846*/
%retindex (ais.iais,iw,ais.indexdti); /*obs 359456*/


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

%datst (ais.indexdta,inp,amb,x,ais.inp1,ais.amb1);
%datst (ais.indexdte,inp,amb,x,ais.inp2,ais.amb2);
%datst (ais.indexdti,inp,amb,x,ais.inp3,ais.amb3);

/***********************/

%Macro conca (input,input1,output);

data &output; set &input &input1; run;

%mend conca;

%conca (ais.inp1,ais.amb1,datindxa);
%conca (ais.inp2,ais.amb2,datindxe);
%conca (ais.inp3,ais.amb3,datindxi);


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

%dtstr (datindxa,datindxa,ais.datindxa)
%dtstr (datindxe,datindxe,ais.datindxe)
%dtstr (datindxi,datindxi,ais.datindxi)


/* Joining our index date with our original ihd data file: work */;

%Macro jindx (input,input1,output);

proc sql;
create table &output as select a.*,b.* 
from &input1 a left join &input b
on a. maskssn= b. maskssn;
quit;

%mend jindx;

%jindx (ais.indexdta,aw,aw);
%jindx (ais.indexdte,ew,ew);
%jindx (ais.indexdti,iw,iw);


/*Joining our datestart/datend with our original ihd data file */

%Macro jdatst (input,input1,output);

proc sql;
create table &output as select a.*,b.* 
from &input1 a left join &input b
on a. maskssn= b. maskssn;
quit;

%mend jdatst;

%jdatst (datindxa,aw,ais.datindxa1); /*obs 5603*/
%jdatst (datindxe,ew,ais.datindxe1); /*obs 37743*/
%jdatst (datindxi,iw,ais.datindxi1); /*obs 444830*/


/*Defining the lookback and follow up period "continiuos enrolment" five year lookback & one year lookforward dataset**/

%Macro lback (input,output);

data &output; set &input; 
if (index_dt-1825) > dt_start and (index_dt+365) < dt_end then output; 
run;

%mend lback;

%lback (ais.datindxa1,ais.datindxa2); /* obs 619*/
%lback (ais.datindxe1,ais.datindxe2); /* obs 2680*/
%lback (ais.datindxi1,ais.datindxi2); /* obs 24681*/


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

%dx_comorb (ais.iais, ais.dx_varbli);
%dx_comorb (ais.aais, ais.dx_varbla);
%dx_comorb (ais.eais, ais.dx_varble);


/*keeping the needed variables (comorbidities)*/

%Macro dx_ret (input, output);

data &output; set &input;
keep maskssn hld tia Stroke cvd chf htn dm cad pvd copd dep anx inf vpn bpn mpn;
run;

%mend dx_ret;

%dx_ret (ais.dx_varbla, dx_varbla);
%dx_ret (ais.dx_varble, dx_varble);
%dx_ret (ais.dx_varbli, dx_varbli);


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

%dx_com (dx_varbla,ahld,atia,aStroke,acvd,achf,ahtn,adm,acad,apvd,acopd,adep,aanx,ainf,avpn,abpn,ampn);
%dx_com (dx_varble,ehld,etia,eStroke,ecvd,echf,ehtn,edm,ecad,epvd,ecopd,edep,eanx,einf,evpn,ebpn,empn);
%dx_com (dx_varbli,ihld,itia,iStroke,icvd,ichf,ihtn,idm,icad,ipvd,icopd,idep,ianx,iinf,ivpn,ibpn,impn);


/*Addressing the comorbidity; Step 1*/

%Macro comorb (input, output);

data &output; set &input; keep maskssn; run;
proc sort data=&output nodupkey; by maskssn; run;

%mend comorb;

%comorb (ais.datindxa2, comorba)
%comorb (ais.datindxe2, comorbe)
%comorb (ais.datindxi2, comorbi)


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

%dx_comorb (comorba,ahld,atia,aStroke,acvd,achf,ahtn,adm, 
			acad,apvd,acopd,adep, aanx,ainf,avpn,abpn,ampn, comorba);
%dx_comorb (comorbe,ehld,etia,eStroke,ecvd,echf,ehtn,edm, 
			ecad,epvd,ecopd,edep,eanx,einf,evpn,ebpn,empn,comorbe);
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

%dx_comor (comorba, comorba)
%dx_comor (comorbe, comorbe)
%dx_comor (comorbi, comorbi)


/*Combining comorbidities with the original data files*/

%Macro comstr (input1, input2, output);

proc sql;
create table &output as select a.*, b.* 
from &input1 a left join &input2 b
on a. maskssn= b. maskssn;
quit;

%mend comstr;

%comstr (ais.datindxa2, comorba, ais.datindxa3); /* obs	619 */
%comstr (ais.datindxe2, comorbe, ais.datindxe3); /* obs	2680 */
%comstr (ais.datindxi2, comorbi, ais.datindxi3); /* obs	24681 */


/*****************************************************************/
/*****************************************************************/
/*****************************************************************/

%Macro adm (input, output);

/*creating disharge_dt for each index_dt (dis_index_dt=index_dt+ losdays), and readm (30,60,90)*/
data &output; set &input (rename =(begindate = adm_dt)); 
	keep maskssn index_dt adm_dt index_dt dis_index_dt readm30 
	readm60 readm90 losdays; run;
data &output; set &output; 
  dis_index_dt = index_dt + losdays;
    format dis_index_dt mmddyy10.;

readm30= index_dt+losdays+30;
readm60= index_dt+losdays+60;
readm90= index_dt+losdays+90;
      format readm30 mmddyy10.;
      format readm60 mmddyy10.; 
      format readm90 mmddyy10.;
run;

%mend adm;

%adm (ais.datindxa2,index_dta); /*619*/ 
%adm (ais.datindxe2,index_dte); /*2680*/
%adm (ais.datindxi2,index_dti); /*24681*/

/*****************************************************************/

%Macro comb (input1,input2,output1,output2);

/*Combining index_dt dis_index_dt,readm30,readm60,readm90 with the original data files*/
data &output1; set &input1; keep maskssn adm_dt index_dt dis_index_dt readm30 readm60 readm90; run;
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &input2; drop index_dt readm30 readm60 readm90; run;
proc sql;
create table &output2 as select a.*, b.*
from &output2 a left join &output1 b
on a. maskssn = b. maskssn;
quit; 

%mend comb;

%comb (index_dta,ais.datindxa3,index_dta1,ais.datindxa4);
%comb (index_dte,ais.datindxe3,index_dte1,ais.datindxe4);
%comb (index_dti,ais.datindxi3,index_dti1,ais.datindxi4);

/*****************************************************************/
/*****************************************************************/
/*****************************************************************/

/*creating readmXX variables*/

%Macro readm (input,output);

data &output; set &input; 
if dis_index_dt < adm_dt <= readm30 then readm_30=1; else readm_30=0;
if dis_index_dt < adm_dt <= readm60 then readm_60=1; else readm_60=0;
if dis_index_dt < adm_dt <= readm90 then readm_90=1; else readm_90=0;
run;

%mend readm;

%readm (index_dta,readma);
%readm (index_dte,readme);
%readm (index_dti,readmi);


/* Construction of rate variables*/ 


%Macro readmr (input,input1,output1,output2,output3,output4);

/*Creating the readmission rate*/
/*readm_30*/
data &output1; set &input; proc sort; by maskssn; run;
data &output1; set &output1; by maskssn;
    retain readm_rate_30;
      if first.maskssn then readm_rate_30=readm_30;
      else readm_rate_30= readm_30+ readm_rate_30;
      if last.maskssn;
run;

proc sql;
create table y as select a.*, b.*
from &input1 a left join &output1 b
on a. maskssn = b. maskssn;
quit; 

/*readm_60*/
data &output2; set &input; proc sort; by maskssn; run;
data &output2; set &output2; by maskssn;
    retain readm_rate_60;
      if first.maskssn then readm_rate_60=readm_60;
      else readm_rate_60= readm_60+ readm_rate_60;
      if last.maskssn;
run;

proc sql;
create table y as select a.*, b.*
from y a left join &output2 b
on a. maskssn = b. maskssn;
quit; 

/*readm_90*/
data &output3; set &input; proc sort; by maskssn; run;
data &output3; set &output3; by maskssn;
    retain readm_rate_90;
      if first.maskssn then readm_rate_90=readm_90;
      else readm_rate_90= readm_90+ readm_rate_90;
      if last.maskssn;
run;

proc sql;
create table &output4 as select a.*, b.*
from y a left join &output3 b
on a. maskssn = b. maskssn;
quit; 

%mend readmr;

%readmr (readma,ais.datindxa4,readma_rate30,readma_rate60,readma_rate90,datindxa5); /*obs 619*/;
%readmr (readme,ais.datindxe4,readme_rate30,readme_rate60,readme_rate90,datindxe5); /*obs 2680*/;
%readmr (readmi,ais.datindxi4,readmi_rate30,readmi_rate60,readmi_rate90,datindxi5); /*obs 24681*/;

/* Construction of visit variables for amb and edp*/ 

data datindxa5; set datindxa5;
rename readm30 = vsta30;
rename readm60 = vsta60;
rename readm90 = vsta90;
rename readm_30 = vsta_30;
rename readm_60 = vsta_60;
rename readm_90 = vsta_90;
rename readm_rate_30 = vsta_rate_30;
rename readm_rate_60 = vsta_rate_60;
rename readm_rate_90 = vsta_rate_90;
rename adm_dt = adm_dta;
rename index_dt = index_dta;
rename dis_index_dt = dis_index_dta;
rename losdays = losa;
run;

data datindxe5; set datindxe5;
rename readm30 = vste30;
rename readm60 = vste60;
rename readm90 = vste90;
rename readm_30 = vste_30;
rename readm_60 = vste_60;
rename readm_90 = vste_90;
rename readm_rate_30 = vste_rate_30;
rename readm_rate_60 = vste_rate_60;
rename readm_rate_90 = vste_rate_90;
rename adm_dt = adm_dte;
rename index_dt = index_dte;
rename dis_index_dt = dis_index_dte;
rename losdays = lose;
run;

/*Variable harmonization*/

%Macro harm (input,output);

data &output; set &input; 

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

*categorize gender*;
	if sex ='M' then sex = 1; * Male *;
	else if sex ='F' then sex = 2; * Female *;
	else if sex ='U' then sex = 3; * Unknown *;

*categorize race*;
		do year = 2006 to 2009;
			if race = 4 then race = 5;
			if race = 6 then race = 3;
			if race = 7 then race = 6;
			if race = 8 then race = 7; 
		end;
	
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
run;

%mend harm;

%harm (datindxa5,datindxa5)
%harm (datindxe5,datindxe5)
%harm (datindxi5,datindxi5)

/* death Variable Creation*/

%Macro death (input,output);

data h; set &input; proc sort; by maskssn; run;
data &output; set h; by maskssn;
    retain death;
    if dischstat in (20,50,51) then death=1;
      else death= 0;
run;

%mend death;

%death (datindxa5,datindxa5)
%death (datindxe5,datindxe5)
%death (datindxi5,datindxi5)

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
between admissions*/ 

/*categorize weekend*/;
proc contents data=datindxi5; run;

data datindxa5n; set datindxa5;

admsrca = input(admsrc, 6.);
	drop admsrc;
	
type_serva = input(type_serv, 3.);
	drop type_serv;

rename pro_code=pro_codea;
rename fac_region= fac_regiona;
rename weekday= weekdaya;
rename age= agea;
rename sex= sexa;
rename dischstat= dischstata;
rename hr_arrival= hr_arrivala;
rename prinproc= prinproca;
rename othproc= othproca;
rename tchgs= tchgsa;
rename qtr= qtra;
rename edhr= edhra;
rename atten_phyid= atten_phyida;
rename atten_phynpi= atten_phynpia;
rename oper_phyid= oper_phyida;
rename oper_phynpi= oper_phynpia;
rename othoper_phyid= othoper_phyida;
rename othoper_phynpi= othoper_phynpia;
rename ecmorb= ecomorba;
rename othcpt= othcpta;
rename begindate=begindatea;
rename enddate=enddatea;
rename dtstart= dtstarta;
rename dtend= dtenda;
rename dt_start= dt_starta;
rename othcpt= othcpta;
rename dt_end= dt_enda; 

run;

data datindxa5n; set datindxa5n;

if admsrca='00' then admsrca=0; *indicating ambulatory surgery data*;
if admsrca='01' then admsrca=1; *Non-Health Care Facility Point of Origin*; 
if admsrca='02' then admsrca=2; *Clinic or Physician’s Office*;
if admsrca='04' then admsrca=3; *Transfer from a Hospital *;
if admsrca='05' then admsrca=4; *Transfer from a Skilled Nursing Facility (SNF) or Intermediate Care Facility (ICF)*;
if admsrca='06' then admsrca=5; *Transfer from another health care facility*;
if admsrca='08' then admsrca=6; *Court/Law Enforcement*;
if admsrca='09' then admsrca=7; *Information Not Available*;
if admsrca='D' then admsrca=8; *Transfer from one distinct unit of the hospital to another distinct unit of the same hospital resulting in a separate claim*;
if admsrca='E' then admsrca=9; *Transfer from an Ambulatory Surgery Center*;
if admsrca='F' then admsrca=10; *Transfer from a hospice facility and under a hospice plan of care or enrolled in a hospice program Codes Required for Newborn Admissions*;

run;



data datindxa5n; set datindxa5n;

if type_serva=1 then typsrva=3; *Ambulatory surgery, as described in 59B-9.034 (1)(a), F.A.C.*;
if admitdiag=prindiag then diaga=1;
else diaga=0;
drop admitdiag prindiag admsrca;
run;


/*categorize weekend*/;

data datindxe5n; set datindxe5;

admsrce = input(admsrc, 6.);
	drop admsrc;
	
type_serve = input(type_serv, 3.);
	drop type_serv;

rename pro_code=pro_codee;
rename fac_region= fac_regione;
rename weekday= weekdaye;
rename age= agee;
rename sex= sexe;
rename dischstat= dischstate;
rename hr_arrival= hr_arrivale;
rename prinproc= prinproce;
rename othproc= othproce;
rename tchgs= tchgse;
rename qtr= qtre;
rename edhr= edhre;
rename atten_phyid= atten_phyide;
rename atten_phynpi= atten_phynpie;
rename oper_phyid= oper_phyide;
rename oper_phynpi= oper_phynpie;
rename othoper_phyid= othoper_phyide;
rename othoper_phynpi= othoper_phynpie;
rename ecmorb= ecomorbe;
rename othcpt= othcpte;
rename begindate=begindatee;
rename enddate=enddatee;
rename dtstart= dtstarte;
rename dtend= dtenda;
rename dt_start= dt_starte;
rename othcpt= othcpte;
rename dt_end= dt_ende;

run;

data datindxe5n; set datindxe5;

if admsrc='00' then admsrce=0; *indicating ambulatory surgery data*;
if admsrc='01' then admsrce=1; *Non-Health Care Facility Point of Origin*; 
if admsrc='02' then admsrce=2; *Clinic or Physician’s Office*;
if admsrc='04' then admsrce=3; *Transfer from a Hospital *;
if admsrc='05' then admsrce=4; *Transfer from a Skilled Nursing Facility (SNF) or Intermediate Care Facility (ICF)*;
if admsrc='06' then admsrce=5; *Transfer from another health care facility*;
if admsrc='08' then admsrce=6; *Court/Law Enforcement*;
if admsrc='09' then admsrce=7; *Information Not Available*;
if admsrc='D' then admsrce=8; *Transfer from one distinct unit of the hospital to another distinct unit of the same hospital resulting in a separate claim*;
if admsrc='E' then admsrce=9; *Transfer from an Ambulatory Surgery Center*;
if admsrc='F' then admsrce=10; *Transfer from a hospice facility and under a hospice plan of care*; 

run;

data datindxe5n; set datindxe5;

if type_serve=2 then typsrve=4; *Emergency department visit, as described in 59B-9.034 (2)(b), F.A.C. *;
if admitdiag=prindiag then diage=1;
else diage=0;
drop admitdiag prindiag admsrc;

run;


proc sort data=datindxa5n;
by maskssn;
run;

proc sort data=datindxe5n;
by maskssn;
run;

options mergenoby=warn;
data datindxae5;
merge datindxa5n datindxe5n;
by maskssn;
*if (in1=1 or in2=1) then output datindxae5;
run;


data datindxi5n; set datindxi5;

nadmsrc = input(admsrc, 6.);
	drop admsrc;
	rename nadmsrc=admsrc;
	
ntype_serv = input(type_serv, 3.);
	drop type_serv;
	rename ntype_serv=type_serv;

if type_serv=1 then typsrvi=1; *Inpatient/Long Term Care/Short and Long Term Psychiatric *;
if type_serv=2 then typsrvi=2; *Comprehensive Rehabilitation*;

if admsrc='01' then admsrci=1; *Non-Health Care Facility Point of Origin*; 
if admsrc='02' then admsrci=2; *Clinic or Physician’s Office*;
if admsrc='04' then admsrci=3; *Transfer from a Hospital *;
if admsrc='05' then admsrci=4; *Transfer from a Skilled Nursing Facility (SNF) or Intermediate Care Facility (ICF)*;
if admsrc='06' then admsrci=5; *Transfer from another health care facility*;
if admsrc='08' then admsrci=6; *Court/Law Enforcement*;
if admsrc='09' then admsrci=7; *Information Not Available*;
if admsrc='D' then admsrci=8; *Transfer from one distinct unit of the hospital to another distinct unit of the same hospital resulting in a separate claim*;
if admsrc='E' then admsrci=9; *Transfer from an Ambulatory Surgery Center*;
if admsrc='F' then admsrci=10; *Transfer from a hospice facility & under a hospice plan of care or enrolled in a hospice program Codes Required for Newborn Admissions*;
if admsrc='10' then admsrci=11; *Born inside this hospital*;
if admsrc='13' then admsrci=12; *Born outside this hospital*;


*if poa ='N' then condprs=0; *Not present at the time that the order for inpatient admission occurs*;
*if poa ='Y' then condprs=1; *Present at time that order for inpatient admission occurs*;
*if poa ='U' then condprs=2; *Documentation is insufficient to determine if condition is present on admission*;
*if poa ='W' then condprs=3; *Provider is unable to clinically determine whether the condition was present on admission or not*;
*if poa ='E' then condprs=4; *The condition is exempt from POA reporting*;

if poa_prin_diag ='N' then condpr=0; *Not present at the time that the order for inpatient admission occurs*;
if poa_prin_diag ='Y' then condpr=1; *Present at time that order for inpatient admission occurs*;
if poa_prin_diag ='U' then condpr=2; *Documentation is insufficient to determine if condition is present on admission*;
if poa_prin_diag ='W' then condpr=3; *Provider is unable to clinically determine whether the condition was present on admission or not*;
if poa_prin_diag ='E' then condpr=4; *The condition is exempt from POA reporting*;

if mod_code='cl01' then class=1; *Class 1 Hospital*;
if mod_code='cl02' then class=2; *Class 2 Hospital*;
if mod_code='cl03' then claas=3; *Class 3 Hospital Psychiatric*;
if mod_code='cl04' then class=4; *Class 4 Hospital Intermediate Residential Treatment Facility (IRTF)*;
if mod_code='cl06' then class=5; *Class 1 Hospital Long Term Care*;
if mod_code='cl07' then claas=6; *Class 1 Hospital Rural *;
if mod_code='cl09' then class=7; *Class 3 Hospital Rehabilitation*;
if mod_code='cl10' then class=8; *Class 3 Hospital Special Medical*;

if admitdiag=prindiag then diagi=1;
else diagi=0;
drop admitdiag prindiag admsrc mod_code;
run;











data datindxi6; set datindxi5;
	if weeday in (6,7) then wkd = 1; * Weekend *;
	else wkd = 0; * Business days *;
	
	if adm_time in (06,07) then admf=1; *1st shift balance *;
	if adm_time in (14,15) then admf=2; *2nd shift balance *;
	if adm_time in (06,07) then admf=3; *3rd shift balance *;

	if dis_time in (06,07) then disf=1; *1st shift balance *;
	if dis_time in (14,15) then disf=2; *2nd shift balance *;
	if dis_time in (06,07) then disf=3; *3rd shift balance *;

	if edhr_arr in (06,07) then edpf=1; *1st shift balance *;
	if edhr_arr in (14,15) then edpf=2; *2nd shift balance *;
	if edhr_arr in (06,07) then edpf=3; *3rd shift balance *;
	
	if hr_arrival in (06,07) then aredpf=1; *1st shift balance *;
	if hr_arrival in (14,15) then aredpf=2; *2nd shift balance *;
	if hr_arrival in (06,07) then aredpf=3; *3rd shift balance *;
	
	
	if dischstat=01 then ptstat=1; *Discharged to home or self-care *;
	if dischstat=02 then ptstat=2; *Discharged or transferred to a short-term general hospital for inpatient care*;
	if dischstat=62 then ptstat=3; *Discharged or transferred to a short-term general hospital for inpatient care*;
	if dischstat=63 then ptstat=4; *Discharged or transferred to a Medicare certified long term care hospital*;
	if dischstat=65 then ptstat=5; *Discharged or transferred to a psychiatric hospital including psychiatric distinct part units of a hospital*;
	if dischstat=66 then ptstat=6; *Discharged or transferred to a Critical Access hospital*;
	
	/*Florida Local Health Council Districts (Facility Regions)*/

	if county in (17,46,57,66) then council=1;
	if county in (3,7,19,20,23,30,32,33,37,39,40,62,65,67) then council=2;
	if county in (1,4,9,12,15,21,24,27,34,35,38,42,54,60,61,63) then council=3;
	if county in (2,10,16,18,45,55,64) then council=4;
	if county in (51,52) then council=5;
	if county in (25,28,29,41,53) then council=6;
	if county in (5,48,49,59) then council=7;
	if county in (8,11,14,22,26,36,58) then council=8;
	if county in (31,43,47,50,56) then council=9;
	if county in (6) then council=10;
	if county in (13,44) then council=11;
	if county in (99) then council=0;

	/*Florida Local Health Council Districts (Facility Regions)*/

	if mod_code=cl01 then class=1; *Class 1 Hospital*;
	if mod_code=cl02 then class=2; *Class 2 Hospital*;
	if mod_code=cl03 then claas=3; *Class 3 Hospital Psychiatric*;
	if mod_code=cl04 then class=4; *Class 4 Hospital Intermediate Residential Treatment Facility (IRTF)*;
	if mod_code=cl06 then class=5; *Class 1 Hospital Long Term Care*;
	if mod_code=cl07 then claas=6; *Class 1 Hospital Rural *;
	if mod_code=cl09 then class=7; *Class 3 Hospital Rehabilitation*;
	if mod_code=cl10 then class=8; *Class 3 Hospital Special Medical*;

 
	if condtn=P7 then ncondtn=1; *Patient received treatment in this facility’s emergency department.*;
	if condtn=00 then ncondtn=2; *Not admitted through this facility’s emergency department.*;
	if condtn=NR then ncondtn=3; *Not reported*;
	
run;
















/* Variable reformating and Creation*/

%Macro comstr (input1, input2, output);

proc sql;
create table &output as select a.*, b.* 
from &input1 a left join &input2 b
on a. maskssn= b. maskssn;
quit;

%mend comstr;

%comstr (ais.datindxa3, readma, ais.datindxa5); /* obs	619 */
%comstr (ais.datindxe3, readme, ais.datindxe5); /* obs	2680 */
%comstr (ais.datindxi3, readmi, ais.datindxi5); /* obs	24681 */


























data vsta1; set readma; keep maskssn vsta_30 vsta_60 vsta_90; run;
data vste1; set readme; keep maskssn vste_30 vste_60 vste_90; run;


proc sql;
create table readmia1 as select a.*, b.*
from readmi a left join vsta1 b
on a. maskssn = b. maskssn;
quit; 

proc sql;
create table readmiae2 as select a.*, b.*
from readmi1 a left join vste1 b
on a. maskssn = b. maskssn;
quit; 


data dtrdvst; set readmiae2;
if vsta_30 =. then vsta_30=0;
if vsta_60=. then vsta_60=0;
if vsta_90=. then vsta_90=0;
if vste_30 =. then vste_30=0;
if vste_60 =. then vste_60=0;
if vste_90 =. then vste_90=0;
run;


/*Creating the Mortality variable*/

data h; set ais.datindxi4; proc sort; by maskssn; run;
data datindxi5; set h; by maskssn;
    retain death;
    if dischstat in (20,50,51) then death=1;
      else death= 0;
run;


/*Inpatient Cohort Consolidation with all variables*/

data dtrdvst1; set dtrdvst; keep maskssn readm_30 readm_60 readm_90 
vsta_30 vsta_60 vsta_90 vste_30 vste_60 vste_90; run;

proc sql;
create table datind as select a.*, b.*
from datindxi5 a left join dtrdvst1 b
on a. maskssn = b. maskssn;
quit; 

/* Construction of rates variables for amb and edp*/ 

/*readm_30*/
data datind1; set datind; proc sort; by maskssn; run;
data datind1; set datind1; by maskssn;
    retain readm_rate_30;
      if first.maskssn then readm_rate_30=readm_30;
      else readm_rate_30= readm_30+ readm_rate_30;
      if last.maskssn;
run;

/*readm_60*/
data datind2; set datind1; proc sort; by maskssn; run;
data datind2; set datind2; by maskssn;
    retain readm_rate_60;
      if first.maskssn then readm_rate_60=readm_60;
      else readm_rate_60= readm_60+ readm_rate_60;
      if last.maskssn;
run;

/*readm_90*/
data datind3; set datind2; proc sort; by maskssn; run;
data datind3; set datind3; by maskssn;
    retain readm_rate_90;
      if first.maskssn then readm_rate_90=readm_90;
      else readm_rate_90= readm_90+ readm_rate_90;
      if last.maskssn;
run;


/*vsta_30*/
data datind1; set datind3; proc sort; by maskssn; run;
data datind1; set datind1; by maskssn;
    retain vsta_rate_30;
      if first.maskssn then vsta_rate_30=vsta_30;
      else vsta_rate_30= vsta_30+ vsta_rate_30;
      if last.maskssn;
run;

/*vsta_60*/
data datind2; set datind1; proc sort; by maskssn; run;
data datind2; set datind2; by maskssn;
    retain vsta_rate_60;
      if first.maskssn then vsta_rate_60=vsta_60;
      else vsta_rate_60= vsta_60+ vsta_rate_60;
      if last.maskssn;
run;

/*vsta_90*/
data datind3; set datind2; proc sort; by maskssn; run;
data datind3; set datind3; by maskssn;
    retain vsta_rate_90;
      if first.maskssn then vsta_rate_90=vsta_90;
      else vsta_rate_90= vsta_90+ vsta_rate_90;
      if last.maskssn;
run;


/*vste_30*/
data datind1; set datind3; proc sort; by maskssn; run;
data datind1; set datind1; by maskssn;
    retain vste_rate_30;
      if first.maskssn then vste_rate_30=vste_30;
      else vste_rate_30= vste_30+ vste_rate_30;
      if last.maskssn;
run;

/*vste_60*/
data datind2; set datind1; proc sort; by maskssn; run;
data datind2; set datind2; by maskssn;
    retain vste_rate_60;
      if first.maskssn then vste_rate_60=vste_60;
      else vste_rate_60= vste_60+ vste_rate_60;
      if last.maskssn;
run;

/*vste_90*/
data datind3; set datind2; proc sort; by maskssn; run;
data datind3; set datind3; by maskssn;
    retain vste_rate_90;
      if first.maskssn then vste_rate_90=vste_90;
      else vste_rate_90= vste_90+ vste_rate_90;
      if last.maskssn;
run;



data ais.datindx6; set datind3; run; 
data datindx6; set ais.datindx6; run ;









/**************************************************/

/**************************************************/

%Macro readmx (input,output1,output2,output3,output4,output5,output6);

data &output1; set &input; where readm_30=1; run;
data &output2; set &output1; keep maskssn; run;
proc sort data=&output2 nodupkey; by maskssn; run;

data &output3; set &input; where readm_60=1; run;
data &output4; set &output3; keep maskssn; run;
proc sort data=&output4 nodupkey; by maskssn; run;

data &output5; set &input; where readm_90=1; run;
data &output6; set &output5; keep maskssn; run;
proc sort data=&output6 nodupkey; by maskssn; run;

%mend readmx;

%readmx (readea,vsta30,testa,vsta60,testa1,vsta90,testa2); 
/*R30:obs 16,unique obs 9*, *R60:obs 27,unique obs 11*, *R90:obs 42,unique obs 16*/

%readmx (readae,vste30,teste,vste60,teste1,vste90,teste2); 
/*R30:obs 21,unique obs 21*, *R60:obs 32,unique obs 31*, *R90:obs 38,unique obs 36*/

%readmx (readmi,readmi30,testi,readmi60,testi1,readmi90,testi2); 
/*R30:obs 579,unique obs 530*, *R60:obs 837,unique obs 754*, *R90:obs 987,unique obs 891*/



/**************************************************/

%Macro readmr (input,input1,output1,output2,output3,output4);

/*Creating the readmission rate*/
/*readm_30*/
data &output1; set &input; proc sort; by maskssn; run;
data &output1; set &output1; by maskssn;
    retain readm_rate_30;
      if first.maskssn then readm_rate_30=readm_30;
      else readm_rate_30= readm_30+ readm_rate_30;
      if last.maskssn;
run;

proc sql;
create table y as select a.*, b.*
from &input1 a left join &output1 b
on a. maskssn = b. maskssn;
quit; 

/*readm_60*/
data &output2; set &input; proc sort; by maskssn; run;
data &output2; set &output2; by maskssn;
    retain readm_rate_60;
      if first.maskssn then readm_rate_60=readm_60;
      else readm_rate_60= readm_60+ readm_rate_60;
      if last.maskssn;
run;

proc sql;
create table y as select a.*, b.*
from y a left join &output2 b
on a. maskssn = b. maskssn;
quit; 

/*readm_90*/
data &output3; set &input; proc sort; by maskssn; run;
data &output3; set &output3; by maskssn;
    retain readm_rate_90;
      if first.maskssn then readm_rate_90=readm_90;
      else readm_rate_90= readm_90+ readm_rate_90;
      if last.maskssn;
run;

proc sql;
create table &output4 as select a.*, b.*
from y a left join &output3 b
on a. maskssn = b. maskssn;
quit; 

%mend readmr

%readmr (readea,ais.datindxa4,vsta_rate30,vsta_rate60,vsta_rate90,datindxa5); /*obs 619*/
%readmr (readae,ais.datindxe4,vste_rate30,vste_rate60,vste_rate90,datindxe5); /*obs 2680*/
%readmr (readmi,ais.datindxi4,readmi_rate30,readmi_rate60,readmi_rate90,datindxi5); /*obs 24681*/


%Macro vist (input,input1,output);

data &input; set &input; by maskssn;
data &input1; set &input1; by maskssn;

proc sql;
create table &output as select a.*, b.*
from &input a left join &input1 b
on a. maskssn = b. maskssn;
quit; 

%mend vist;

%vist (readae,datindxi5,visita)
%vist (readea,datindxi5,visite)















%Macro nodup (input,output);

/*Moving duplicates*/
data &output; set &input; keep maskssn readm_30 readm_60 readm_90 readm_rate_30 readm_rate_60 readm_rate_90; run;
proc sort data=&output nodupkey; by maskssn; run;

%mend nodup;

%nodup (datindxa5,vst_alla) /*obs 362*/
%nodup (datindxe5,vst_alle) /*obs 2495*/
%nodup (datindxi5,readm_alli) /*obs 19215*/


%Macro vass (input1,input2,output);

/*Joining the readmission data file with original data file */
proc sql;
create table &output as select a.*,b.* 
from &input1 a left join &input2 b
on a. maskssn = b. maskssn;
quit; 

%mend vass;

%vass (ais.datindxa4,readm_alla,ais.datindxa6); /*obs 619*/
%vass (ais.datindxe4,readm_alle,ais.datindxe6); /*obs 2680*/
%vass (ais.datindxi4,readm_alli,ais.datindxi6); /*obs 24681*/

/*Reformating Demographic Variables*/

%Macro reform (input, output);

data &output; set &input; 

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

*categorize gender*;
	if sex ='M' then sex = 1; * Male *;
	else if sex ='F' then sex = 2; * Female *;
	else if sex ='U' then sex = 3; * Unknown *;

*categorize race*;
		do year = 2006 to 2009;
			if race = 4 then race = 5;
			if race = 6 then race = 3;
			if race = 7 then race = 6;
			if race = 8 then race = 7; 
		end;
	
	if race = 3 then newrace = 1; * Black *;
	if race = 5 then newrace = 2; * White *;
	if race in (1 2 4 6 7) then newrace = 3; * All Others *;

*categorize payer*;
	if payer in ('L', 'N') then newpayer = 0; * No Insurance *;
	if payer in ('A', 'B', 'C', 'D', 'I', 'J', 'K', 'O', 'H') then newpayer = 1; * Government Insurance *;
	if payer in ('E', 'F', 'G', 'Q') then newpayer = 2; * Private Insurance *;
	if payer in ('M') then newpayer = 3; * Other Insurance *;
	
*categorize states*;
	if ptstate ='FL' then ptstate = 1; * Florida *;
	else ptstate = 2; * Other than Florida *;	
run;

%mend reform;

/* Our final data files for mortality,LOS,and tgch analyses */
%reform (ais.datindxa6,ais.datindxa6); /*619*/
%reform (ais.datindxe6,ais.datindxe6); /*2680*/
%reform (ais.datindxi6,ais.datindxi6); /*24681*/

/**************************************************/
/**************************************************/

/*Applying the exclusion criteria*/

%Macro incl (input,output);

data &output; set &input; 
if losdays=0 then delete;
if losdays=. then delete;
if dischstat in ( 03, 04, 05, 06, 07, 20, 21, 50, 51, 64, 70) then delete;
run; 

%mend incl;

%incl (ais.datindxa6,exa)
%incl (ais.datindxe6,exe)
%incl (ais.datindxi6,exi)

/* Our final data files for readmission analyses */
data ais.datindxa7; set exa; run; /*obs 102*/
data ais.datindxe7; set exe; run; /*obs 963*/
data ais.datindxi7; set exi; run; /*obs 12438*/


/*************************************************************/
/*************************************************************/
/*************************************************************/

/* Readmission Analysis */

/* 30 days */
%Macro read30 (input,output1,output2,output3);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table1.csv";
title1 "30 days Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where readm_30=1; run;
proc freq data=&output2; table readm_30; run;
data &output3; set &output1; where readm_rate_30>0; run;
proc freq data=&output3; table readm_rate_30; run;

%mend read30;
								   /*readm_30*/	    /*readm_rate_30*/
%read30 (exa,ha,ya,ya1) /*ha=72, ya=2(2/72=2.78%), ya1=4(4/72=5.56%)*/
%read30 (exe,he,ye,ye1) /*he=936, ye=8(8/936=0.85%), ye1=9(9/936=0.96%)*/
%read30 (exi,hi,yi,yi1) /*hi=10850, yi=292(292/10850=2.69%), yi1=414(414/10850=3.82%)*/

/* 60 days */
%Macro read60 (input,output1,output2,output3);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table2.csv" style=vasstables;
title1 "60 days Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where readm_60=1; run;
proc freq data=&output2; table readm_60; run;
data &output3; set &output1; where readm_rate_60>0; run;
proc freq data=&output3; table readm_rate_60; run;

%mend read60;

%read60 (exa,ha,ya,ya1); /*ha=72, ya=2 (2/72=2.78%), ya1=4 (4/72=5.56%)*/
%read60 (exe,he,ye,ye1); /*he=936, ye=10 (10/936=1.10%), ye1=13 (13/936=1.39%)*/
%read60 (exi,hi,yi,yi1); /*hi=10850, yi=417 (417/10850=3.84%), yi1=565 (565/10850=5.21%)*/

/* 90 days */
%Macro read90 (input,output1,output2,output3);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table3.csv" style=vasstables;
title1 "90 days Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where readm_90=1; run;
proc freq data=&output2; table readm_90; run;
data &output3; set &output1; where readm_rate_90>0; run;
proc freq data=&output3; table readm_rate_90; run;

%mend read90;

%read90 (exa,ha,ya,ya1); /*ha=72, ya=3 (3/72=4.17%), ya1=5 (5/72=6.94%)*/
%read90 (exe,he,ye,ye1); /*he=936, ye=13 (13/936=1.39%), ye1=16 (16/936=1.71%)*/
%read90 (exi,hi,yi,yi1); /*hi=10850, yi=491 (491/10850=4.53%), yi1=667 (667/10850=6.15%)*/


/* Ethnoracial Readmission Analysis */


/*calculating the readmission rate AND the total readmission rate */

/* ethnicity = 1 (Hispanic or Latino) and  newrace = 1 (Black)*/

/*30 days*/
%Macro reder30 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table4.csv" style=vasstables;
title1 "30 days Ethnoracial (ethn=1-race=1) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=1; run;
data &output3; set &output2; where newrace=1; run;
data &output4; set &output3; where readm_30=1; run;
proc freq data=&output4; table readm_30; run;
data &output5; set &output1; where ethnicity=1; run;
data &output6; set &output5; where newrace=1; run;
data &output7; set &output6; where readm_rate_30>0; run;
proc freq data=&output7; table readm_rate_30; run;

%mend reder30;
												/*readm_30*//*readm_rate_30*/
%reder30 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder30 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=29, ye2=1 (1/29=3.45%), ye5=1 (1/29=3.45%)*/  
%reder30 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=424, yi2=12 (12/424=2.83%), yi5=17 (17/424=4.01%)*/

/*60 days*/
%Macro reder60 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table5.csv" style=vasstables;
title1 "60 days Ethnoracial (ethn=1-race=1) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=1; run;
data &output3; set &output2; where newrace=1; run;
data &output4; set &output3; where readm_60=1; run;
proc freq data=&output4; table readm_60; run;
data &output5; set &output1; where ethnicity=1; run;
data &output6; set &output5; where newrace=1; run;
data &output7; set &output6; where readm_rate_60>0; run;
proc freq data=&output7; table readm_rate_60; run;

%mend reder60;

%reder60 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder60 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=29, ye2=0 (1/29=3.45%), ye5= (1/29=3.45%)*/
%reder60 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=424, yi2=17 (17/424=4.01%), yi5=22 (22/424=5.19%)*/

/*90 days*/
%Macro reder90 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table6.csv" style=vasstables;
title1 "90 days Ethnoracial (ethn=1-race=1) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=1; run;
data &output3; set &output2; where newrace=1; run;
data &output4; set &output3; where readm_90=1; run;
proc freq data=&output2; table readm_90; run;
data &output5; set &output1; where ethnicity=1; run;
data &output6; set &output5; where newrace=1; run;
data &output7; set &output6; where readm_rate_90>0; run;
proc freq data=&output7; table readm_rate_90; run;

%mend reder90;

%reder90 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder90 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=29, ye2=1 (1/29=3.45%), ye5=1 (1/29=3.45%)*/  
%reder90 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=424, yi2=19 (19/424=4.48%), yi5=26 (26/424=6.13%)*/


/* ethnicity = 1 (Hispanic or Latino) and  newrace = 2 (White)*/

/*30 days*/
%Macro reder30 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table7.csv" style=vasstables;
title1 "30 days Ethnoracial (ethn=1-race=2) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=1; run;
data &output3; set &output2; where newrace=2; run;
data &output4; set &output3; where readm_30=1; run;
proc freq data=&output4; table readm_30; run;
data &output5; set &output1; where ethnicity=1; run;
data &output6; set &output5; where newrace=2; run;
data &output7; set &output6; where readm_rate_30>0; run;
proc freq data=&output7; table readm_rate_30; run;

%mend reder30;

%reder30 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=4, ya2=1 (1/4=25.0%), ya5=1 (1/4=25.0%)*/
%reder30 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=108, ye2=0 (0/108=0%), ye5=0 (0/108=0%)*/  
%reder30 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=901, yi2=23 (23/901=2.55%), yi5=40 (40/901=4.44%)*/

/*60 days*/
%Macro reder60 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table8.csv" style=vasstables;
title1 "60 days Ethnoracial (ethn=1-race=2) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=1; run;
data &output3; set &output2; where newrace=2; run;
data &output4; set &output3; where readm_60=1; run;
proc freq data=&output4; table readm_60; run;
data &output5; set &output1; where ethnicity=1; run;
data &output6; set &output5; where newrace=2; run;
data &output7; set &output6; where readm_rate_60>0; run;
proc freq data=&output7; table readm_rate_60; run;

%mend reder60;

%reder60 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=1 (1/4=25%), ya5=1 (1/4=25%)*/
%reder60 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=108, ye2=0 (0/108=0.0%), ye5=0 (0/108=0.0%)*/  
%reder60 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=901, yi2=33 (33/901=3.66%), yi5=52 (52/901=5.77%)*/

/*90 days*/
%Macro reder90 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table9.csv" style=vasstables;
title1 "90 days Ethnoracial (ethn=1-race=2) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=1; run;
data &output3; set &output2; where newrace=2; run;
data &output4; set &output3; where readm_90=1; run;
proc freq data=&output4; table readm_90; run;
data &output5; set &output1; where ethnicity=1; run;
data &output6; set &output5; where newrace=2; run;
data &output7; set &output6; where readm_rate_90>0; run;
proc freq data=&output7; table readm_rate_90; run;

%mend reder90;

%reder90 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=4, ya2= (1/4=25.0%), ya5= (2/4=50.0%)*/
%reder90 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=108, ye2=0 (0/108=0.0%), ye5=0 (0/108=0%)*/  
%reder90 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=901, yi2=38 (38/901=4.22%), yi5=59 (59/901=6.55%)*/

/* ethnicity = 1 (Hispanic or Latino) and  newrace = 3 (All Others)*/

/*30 days*/
%Macro reder30 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table10.csv" style=vasstables;
title1 "30 days Ethnoracial (ethn=1-race=3) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=1; run;
data &output3; set &output2; where newrace=3; run;
data &output4; set &output3; where readm_30=1; run;
proc freq data=&output4; table readm_30; run;
data &output5; set &output1; where ethnicity=1; run;
data &output6; set &output5; where newrace=3; run;
data &output7; set &output6; where readm_rate_30>0; run;
proc freq data=&output7; table readm_rate_30; run;

%mend reder30;

%reder30 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder30 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=1, ye2=0 (0/1=0.0%), ya5=0 (0/1=0%)*/  
%reder30 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=8, yi2=0 (0/8=0%), yi5=0 (0/8=0%)*/

/*60 days*/
%Macro reder60 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table11.csv" style=vasstables;
title1 "60 days Ethnoracial (ethn=1-race=3) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=1; run;
data &output3; set &output2; where newrace=3; run;
data &output4; set &output3; where readm_60=1; run;
proc freq data=&output4; table readm_60; run;
data &output5; set &output1; where ethnicity=1; run;
data &output6; set &output5; where newrace=3; run;
data &output7; set &output6; where readm_rate_60>0; run;
proc freq data=&output7; table readm_rate_60; run;

%mend reder60;

%reder60 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder60 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=1, ye2=0 (0/1=0%), ye5=0 (0/1=0%)*/  
%reder60 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=8, yi2=1 (1/8=12.5%), yi5=2 (2/8=25%)*/

/*90 days*/
%Macro reder90 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table12.csv" style=vasstables;
title1 "90 days Ethnoracial (ethn=1-race=3) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=1; run;
data &output3; set &output2; where newrace=3; run;
data &output4; set &output3; where readm_90=1; run;
proc freq data=&output4; table readm_90; run;
data &output5; set &output1; where ethnicity=1; run;
data &output6; set &output5; where newrace=3; run;
data &output7; set &output6; where readm_rate_90>0; run;
proc freq data=&output7; table readm_rate_90; run;

%mend reder90;

%reder90 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=4, ya2=1 (1/4=25.0%), ya5=2 (2/4=50.0%)*/
%reder90 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=0, ye2=0, ye5=0*/  
%reder90 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=8, yi2=1 (1/8=12.5%), yi5=2 (2/8=25.0%)*/


/* ethnicity = 2 (Non-Hispanic or Latino) and  newrace = 1 (Black)*/

/*30 days*/
%Macro reder30 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table13.csv" style=vasstables;
title1 "30 days Ethnoracial (ethn=2-race=1) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=2; run;
data &output3; set &output2; where newrace=1; run;
data &output4; set &output3; where readm_30=1; run;
proc freq data=&output4; table readm_30; run;
data &output5; set &output1; where ethnicity=2; run;
data &output6; set &output5; where newrace=1; run;
data &output7; set &output6; where readm_rate_30>0; run;
proc freq data=&output7; table readm_rate_30; run;

%mend reder30;

%reder30 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=15, ya2=0 (0/15=0%), ya5=1 (1/15=6.67%)*/
%reder30 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=165, ye2=4 (4/165=2.42%), ye5=5 (5/165=3.03%)*/  
%reder30 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=1994, yi2=58 (58/1994=2.91%), yi5=83 (83/1994=4.16%)*/

/*60 days*/
%Macro reder60 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table14.csv" style=vasstables;
title1 "60 days Ethnoracial (ethn=2-race=1) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=2; run;
data &output3; set &output2; where newrace=1; run;
data &output4; set &output3; where readm_60=1; run;
proc freq data=&output4; table readm_60; run;
data &output5; set &output1; where ethnicity=2; run;
data &output6; set &output5; where newrace=1; run;
data &output7; set &output6; where readm_rate_60>0; run;
proc freq data=&output7; table readm_rate_60; run;

%mend reder60;

%reder60 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=15, ya2=0 (0/15=0%), ya5=1 (1/15=6.67%)*/
%reder60 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=165, ye2=5 (5/165=3.03%), ye5=6 (6/165=3.64%)*/  
%reder60 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=1994, yi2=84 (84/1994=4.21%), yi5=112 (112/1994=5.62%)*/

/*90 days*/
%Macro reder90 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table15.csv" style=vasstables;
title1 "90 days Ethnoracial (ethn=2-race=1) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=2; run;
data &output3; set &output2; where newrace=1; run;
data &output4; set &output3; where readm_90=1; run;
proc freq data=&output4; table readm_90; run;
data &output5; set &output1; where ethnicity=2; run;
data &output6; set &output5; where newrace=1; run;
data &output7; set &output6; where readm_rate_90>0; run;
proc freq data=&output7; table readm_rate_90; run;

%mend reder90;

%reder90 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=15, ya2=0 (0/15=0%), ya5=1 (1/15=6.67%)*/
%reder90 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=165, ye2=7 (7/165=4.24%), ye5=8 (8/165=4.85%)*/  
%reder90 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=1994, yi2=108 (108/1994=5.42%), yi5=145 (145/1994=7.27%)*/


/* ethnicity = 2 (Non-Hispanic or Latino) and  newrace = 2 (White)*/

/*30 days*/
%Macro reder30 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table16.csv" style=vasstables;
title1 "30 days Ethnoracial (ethn=2-race=2) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=2; run;
data &output3; set &output2; where newrace=2; run;
data &output4; set &output3; where readm_30=1; run;
proc freq data=&output4; table readm_30; run;
data &output5; set &output1; where ethnicity=2; run;
data &output6; set &output5; where newrace=2; run;
data &output7; set &output6; where readm_rate_30>0; run;
proc freq data=&output7; table readm_rate_30; run;

%mend reder30;

%reder30 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=49, ya2=1 (1/49=2.04%), ya5=2 (2/49=4.08%)*/
%reder30 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=608, ye2=2 (2/608=0.33%), ye5=2 (2/608=0.33%)*/  
%reder30 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=7259, yi2=190 (190/7259=2.62%), yi5=262 (262/7259=3.61%)*/

/*60 days*/
%Macro reder60 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table17.csv" style=vasstables;
title1 "60 days Ethnoracial (ethn=2-race=2) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=2; run;
data &output3; set &output2; where newrace=2; run;
data &output4; set &output3; where readm_60=1; run;
proc freq data=&output4; table readm_60; run;
data &output5; set &output1; where ethnicity=2; run;
data &output6; set &output5; where newrace=2; run;
data &output7; set &output6; where readm_rate_60>0; run;
proc freq data=&output7; table readm_rate_60; run;

%mend reder60;

%reder60 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=49, ya2=1 (1/49=2.04%), ya5=2 (2/49=4.08%)*/
%reder60 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=608, ye2=3 (3/608=0.49%), ye5=5 (5/608=0.82%)*/  
%reder60 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=7259, yi2=273 (273/7259=3.76%), yi5=363 (363/7259=5.0%)*/

/*90 days*/
%Macro reder90 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table18.csv" style=vasstables;
title1 "90 days Ethnoracial (ethn=2-race=2) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=2; run;
data &output3; set &output2; where newrace=2; run;
data &output4; set &output3; where readm_90=1; run;
proc freq data=&output4; table readm_90; run;
data &output5; set &output1; where ethnicity=2; run;
data &output6; set &output5; where newrace=2; run;
data &output7; set &output6; where readm_rate_90>0; run;
proc freq data=&output7; table readm_rate_90; run;

%mend reder90;

%reder90 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=49, ya2=2 (2/49=4.08%), ya5=2 (2/49=4.08%)*/
%reder90 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=608, ye2=4 (4/608=0.66%), ye5=6 (6/608=0.99%)*/  
%reder90 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=7259, yi2=315 (315/7259=4.34%), yi5=420 (420/7259=5.8%)*/

/* ethnicity = 2 (Non-Hispanic or Latino) and  newrace = 3 (All Others)*/

/*30 days*/
%Macro reder30 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table19.csv" style=vasstables;
title1 "30 days Ethnoracial (ethn=2-race=3) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=2; run;
data &output3; set &output2; where newrace=3; run;
data &output4; set &output3; where readm_30=1; run;
proc freq data=&output4; table readm_30; run;
data &output5; set &output1; where ethnicity=2; run;
data &output6; set &output5; where newrace=3; run;
data &output7; set &output6; where readm_rate_30>0; run;
proc freq data=&output7; table readm_rate_30; run;

%mend reder30;

%reder30 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=1, ya2=0 (0/1=0%), ya5=0 (0/1=0%)*/
%reder30 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=6, ye2=0 (0/6=0%), ye5=0 (0/6=0%)*/  
%reder30 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=63, yi2=3 (3/63=4.76%), yi5=3 (3/63=4.76%)*/

/*60 days*/
%Macro reder60 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table20.csv" style=vasstables;
title1 "60 days Ethnoracial (ethn=2-race=3) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=2; run;
data &output3; set &output2; where newrace=3; run;
data &output4; set &output3; where readm_60=1; run;
proc freq data=&output4; table readm_60; run;
data &output5; set &output1; where ethnicity=2; run;
data &output6; set &output5; where newrace=3; run;
data &output7; set &output6; where readm_rate_60>0; run;
proc freq data=&output7; table readm_rate_60; run;

%mend reder60;

%reder60 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=1, ya2=0 (0/1=0%), ya5=0 (0/1=0%)*/
%reder60 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=6, ye2=0 (0/6=0%), ye5=0 (0/6=0%)*/  
%reder60 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=63, yi2=3 (3/63=4.76%), yi5=3 (3/63=4.76%)*/

/*90 days*/
%Macro reder90 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table21.csv" style=vasstables;
title1 "90 days Ethnoracial (ethn=2-race=3) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=2; run;
data &output3; set &output2; where newrace=3; run;
data &output4; set &output3; where readm_90=1; run;
proc freq data=&output4; table readm_90; run;
data &output5; set &output1; where ethnicity=2; run;
data &output6; set &output5; where newrace=3; run;
data &output7; set &output6; where readm_rate_90>0; run;
proc freq data=&output7; table readm_rate_90; run;

%mend reder90;

%reder90 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=1, ya2=0 (0/1=0%), ya5=0 (0/1=0%)*/
%reder90 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=6, ye2=0 (0/6=0%), ye5=0 (0/6=0%)*/  
%reder90 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=63, yi2=4 (4/63=6.35%), yi5=4 (4/63=6.35%)*/


/* ethnicity = 3 (Unknown) and  newrace = 1 (Black)*/

/*30 days*/
%Macro reder30 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table22.csv" style=vasstables;
title1 "30 days Ethnoracial (ethn=3-race=1) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=3; run;
data &output3; set &output2; where newrace=1; run;
data &output4; set &output3; where readm_30=1; run;
proc freq data=&output4; table readm_30; run;
data &output5; set &output1; where ethnicity=3; run;
data &output6; set &output5; where newrace=1; run;
data &output7; set &output6; where readm_rate_30>0; run;
proc freq data=&output7; table readm_rate_30; run;

%mend reder30;

%reder30 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=2, ya2=0 (0/2=0%), ya5=0 (0/2=0%)*/
%reder30 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=7, ye2=1 (1/7=14.29%), ye5=1 (1/7=14.29%)*/  
%reder30 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=99, yi2=1 (1/99=1.01%), yi5=2 (2/99=2.02%)*/

/*60 days*/
%Macro reder60 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table23.csv" style=vasstables;
title1 "60 days Ethnoracial (ethn=3-race=1) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=3; run;
data &output3; set &output2; where newrace=1; run;
data &output4; set &output3; where readm_60=1; run;
proc freq data=&output4; table readm_60; run;
data &output5; set &output1; where ethnicity=3; run;
data &output6; set &output5; where newrace=1; run;
data &output7; set &output6; where readm_rate_60>0; run;
proc freq data=&output7; table readm_rate_60; run;

%mend reder60;

%reder60 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=2, ya2=0 (0/2=0%), ya5=0 (0/2=0%)*/
%reder60 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=7, ye2=1 (1/7=14.29%), ye5=1 (1/7=14.29%)*/  
%reder60 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=99, yi2=1 (1/99=1.01%), yi5=3 (3/99=3.03%)*/

/*90 days*/
%Macro reder90 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table24.csv" style=vasstables;
title1 "90 days Ethnoracial (ethn=3-race=1) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=3; run;
data &output3; set &output2; where newrace=1; run;
data &output4; set &output3; where readm_90=1; run;
proc freq data=&output4; table readm_90; run;
data &output5; set &output1; where ethnicity=3; run;
data &output6; set &output5; where newrace=1; run;
data &output7; set &output6; where readm_rate_90>0; run;
proc freq data=&output7; table readm_rate_90; run;

%mend reder90;

%reder90 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=2, ya2=0 (0/2=0%), ya5=0 (0/2=0%)*/
%reder90 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=7, ye2=1 (1/7=14.29%), ye5=1 (1/7=14.29%)*/  
%reder90 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=99, yi2=1 (1/99=1.01%), yi5=3 (3/99=3.03%)*/


/* ethnicity = 3 (Unknown) and  newrace = 2 (White)*/

/*30 days*/
%Macro reder30 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table25.csv" style=vasstables;
title1 "30 days Ethnoracial (ethn=3-race=2) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=3; run;
data &output3; set &output2; where newrace=2; run;
data &output4; set &output3; where readm_30=1; run;
proc freq data=&output4; table readm_30; run;
data &output5; set &output1; where ethnicity=3; run;
data &output6; set &output5; where newrace=2; run;
data &output7; set &output6; where readm_rate_30>0; run;
proc freq data=&output7; table readm_rate_30; run;

%mend reder30;

%reder30 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder30 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=12, ye2=0 (0/12=0%), ye5=0 (0/12=0%)*/  
%reder30 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=97, yi2=5 (5/97=5.15%), yi5=7 (7/97=7.21%)*/

/*60 days*/
%Macro reder60 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table26.csv" style=vasstables;
title1 "60 days Ethnoracial (ethn=3-race=2) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=3; run;
data &output3; set &output2; where newrace=2; run;
data &output4; set &output3; where readm_60=1; run;
proc freq data=&output4; table readm_60; run;
data &output5; set &output1; where ethnicity=3; run;
data &output6; set &output5; where newrace=2; run;
data &output7; set &output6; where readm_rate_60>0; run;
proc freq data=&output7; table readm_rate_60; run;

%mend reder60;

%reder60 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder60 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=12, ye2=0 (0/12=0%), ye5=0 (0/12=0%)*/  
%reder60 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=97, yi2=5 (5/97=5.15%), yi5=8 (8/97=8.25%)*/

/*90 days*/
%Macro reder90 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table27.csv" style=vasstables;
title1 "90 days Ethnoracial (ethn=3-race=2) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=3; run;
data &output3; set &output2; where newrace=2; run;
data &output4; set &output3; where readm_90=1; run;
proc freq data=&output4; table readm_90; run;
data &output5; set &output1; where ethnicity=3; run;
data &output6; set &output5; where newrace=2; run;
data &output7; set &output6; where readm_rate_90>0; run;
proc freq data=&output7; table readm_rate_90; run;

%mend reder90;

%reder90 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder90 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=12, ye2=0 (0/12=0%), ye5=0 (0/12=0%)*/  
%reder90 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=97, yi2=5 (5/97=5.15%), yi5=8 (8/97=8.25%)*/


/* ethnicity = 3 (Unknown) and  newrace = 3 (All Others)*/

/*30 days*/
%Macro reder30 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table28.csv" style=vasstables;
title1 "30 days Ethnoracial (ethn=3-race=3) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=3; run;
data &output3; set &output2; where newrace=3; run;
data &output4; set &output3; where readm_30=1; run;
proc freq data=&output4; table readm_30; run;
data &output5; set &output1; where ethnicity=3; run;
data &output6; set &output5; where newrace=3; run;
data &output7; set &output6; where readm_rate_30>0; run;
proc freq data=&output7; table readm_rate_30; run;

%mend reder30;

%reder30 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder30 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=0, ye2=0, ye5=0*/  
%reder30 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=5, yi2=0 (0/5=0%), yi5=0 (0/5=0%)*/

/*60 days*/
%Macro reder60 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table29.csv" style=vasstables;
title1 "60 days Ethnoracial (ethn=3-race=3) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=3; run;
data &output3; set &output2; where newrace=3; run;
data &output4; set &output3; where readm_60=1; run;
proc freq data=&output4; table readm_60; run;
data &output5; set &output1; where ethnicity=3; run;
data &output6; set &output5; where newrace=3; run;
data &output7; set &output6; where readm_rate_60>0; run;
proc freq data=&output7; table readm_rate_60; run;

%mend reder60;

%reder60 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder60 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=0, ye2=0, ye5=0*/  
%reder60 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=5, yi2=0 (0/5=0%), yi5=0 (0/5=0%)*/

/*90 days*/
%Macro reder90 (input,output1,output2,output3,output4,output5,output6,output7);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table30.csv" style=vasstables;
title1 "90 days Ethnoracial (ethn=3-race=3) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where ethnicity=3; run;
data &output3; set &output2; where newrace=3; run;
data &output4; set &output3; where readm_90=1; run;
proc freq data=&output4; table readm_90; run;
data &output5; set &output1; where ethnicity=3; run;
data &output6; set &output5; where newrace=3; run;
data &output7; set &output6; where readm_rate_90>0; run;
proc freq data=&output7; table readm_rate_90; run;

%mend reder90;

%reder90 (exa,ha,ya,ya1,ya2,ya3,ya4,ya5); /*ya1=0, ya2=0, ya5=0*/
%reder90 (exe,he,ye,ye1,ye2,ye3,ye4,ye5); /*ye1=0, ye2=0, ye5=0*/  
%reder90 (exi,hi,yi,yi1,yi2,yi3,yi4,yi5); /*yi1=5, yi2=0 (0/5=0%), yi5=0 (0/5=0%)*/


/* Age adjested Readmission Analysis */

/* Age adjested agegrp =1 (18-49) */
/* 30 days */
%Macro read30 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table31.csv" style=vasstables;
title1 "30 days Age adjested (18-49) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=1; run;
data &output3; set &output2; where readm_30=1; run;
proc freq data=&output3; table readm_30; run;
data &output4; set &output1; where agegrp=1; run;
data &output5; set &output4; where readm_rate_30>0; run;
proc freq data=&output5; table readm_rate_30; run;

%mend read30;
										  /*readm_30*/	   /*readm_rate_30*/										
%read30 (exa,ha,ya,ya1,ya3,ya4); /*ya=7, ya1=0 (0/7=0%), ya4=1 (1/7=14.29%)*/
%read30 (exe,he,ye,ye1,ye3,ye4); /*ye=70, ye1=1 (1/70=1.43%), ye4=1 (1/70=1.43%)*/
%read30 (exi,hi,yi,yi1,yi3,yi4); /*yi=838, yi1=22 (22/838=2.63%), yi4=32 (32/838=3.82%)*/

/* 60 days */
%Macro read60 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table32.csv" style=vasstables;
title1 "60 days Age adjested (18-49) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=1; run;
data &output3; set &output2; where readm_60=1; run;
proc freq data=&output3; table readm_60; run;
data &output4; set &output1; where agegrp=1; run;
data &output5; set &output4; where readm_rate_60>0; run;
proc freq data=&output5; table readm_rate_60; run;

%mend read60;

%read60 (exa,ha,ya,ya1,ya3,ya4); /*ya=7, ya1=0 (0/7=0%), ya4=1 (1/7=14.29%)*/
%read60 (exe,he,ye,ye1,ye3,ye4); /*ye=70, ye1=2 (2/70=2.86%), ye4=3 (3/70=4.29%)*/
%read60 (exi,hi,yi,yi1,yi3,yi4); /*yi=838, yi1=30 (30/838=3.58%), yi4=42 (42/838=5.01%)*/

/* 90 days */
%Macro read90 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table33.csv" style=vasstables;
title1 "90 days Age adjested (18-49) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=1; run;
data &output3; set &output2; where readm_90=1; run;
proc freq data=&output3; table readm_90; run;
data &output4; set &output1; where agegrp=1; run;
data &output5; set &output4; where readm_rate_90>0; run;
proc freq data=&output5; table readm_rate_90; run;

%mend read90;

%read90 (exa,ha,ya,ya1,ya3,ya4); /*ya=7, ya1=0 (0/7=0%), ya4=1 (1/7=14.29%)*/
%read90 (exe,he,ye,ye1,ye3,ye4); /*ye=70, ye1=2 (2/70=2.86%), ye4=3 (3/70=4.29%)*/
%read90 (exi,hi,yi,yi1,yi3,yi4); /*yi=838, yi1=37 (37/838=4.42%), yi4=54 (54/838=6.44%)*/


/* Age adjested agegrp =2 (50-64) */
/* 30 days */
%Macro read30 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table31.csv" style=vasstables;
title1 "30 days Age adjested (50-64) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=2; run;
data &output3; set &output2; where readm_30=1; run;
proc freq data=&output3; table readm_30; run;
data &output4; set &output1; where agegrp=2; run;
data &output5; set &output4; where readm_rate_30>0; run;
proc freq data=&output5; table readm_rate_30; run;

%mend read30;

%read30 (exa,ha,ya,ya1,ya3,ya4); /*ya=18, ya1=2 (2/18=11.11%), ya4=3 (3/18=16.67%)*/
%read30 (exe,he,ye,ye1,ye3,ye4); /*ye=236, ye1=6 (6/236=2.54%), ye4=6 (6/236=2.54%)*/
%read30 (exi,hi,yi,yi1,yi3,yi4); /*yi=2825, yi1=83 (83/2825=2.94%), yi4=54 (126/2825=4.46%)*/

/* 60 days */
%Macro read60 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table32.csv" style=vasstables;
title1 "60 days Age adjested (50-64) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=2; run;
data &output3; set &output2; where readm_60=1; run;
proc freq data=&output3; table readm_60; run;
data &output4; set &output1; where agegrp=2; run;
data &output5; set &output4; where readm_rate_60>0; run;
proc freq data=&output5; table readm_rate_60; run;

%mend read60;

%read60 (exa,ha,ya,ya1,ya3,ya4); /*ya=18, ya1=2 (2/18=11.11%), ya4=3 (3/18=16.67%)*/
%read60 (exe,he,ye,ye1,ye3,ye4); /*ye=236, ye1=7 (7/236=2.97%), ye4=8 (8/236=3.39%)*/
%read60 (exi,hi,yi,yi1,yi3,yi4); /*yi=2825, yi1=121 (121/2825=4.28%), yi4=169 (169/2825=5.98%)*/

/* 90 days */
%Macro read90 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table33.csv" style=vasstables;
title1 "90 days Age adjested (50-64) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=2; run;
data &output3; set &output2; where readm_90=1; run;
proc freq data=&output3; table readm_90; run;
data &output4; set &output1; where agegrp=2; run;
data &output5; set &output4; where readm_rate_90>0; run;
proc freq data=&output5; table readm_rate_90; run;

%mend read90;

%read90 (exa,ha,ya,ya1,ya3,ya4); /*ya=18, ya1=3 (3/18=16.67%), ya4=3 (3/18=16.67%)*/
%read90 (exe,he,ye,ye1,ye3,ye4); /*ye=236, ye1=9 (9/236=3.817%), ye4=10 (10/236=4.24%)*/
%read90 (exi,hi,yi,yi1,yi3,yi4); /*yi=2825, yi1=139 (139/2825=4.92%), yi4=193 (193/2825=6.83%)*/


/* Age adjested agegrp =3 (65-74) */
/* 30 days */
%Macro read30 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table34.csv" style=vasstables;
title1 "30 days Age adjested (65-74) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=3; run;
data &output3; set &output2; where readm_30=1; run;
proc freq data=&output3; table readm_30; run;
data &output4; set &output1; where agegrp=3; run;
data &output5; set &output4; where readm_rate_30>0; run;
proc freq data=&output5; table readm_rate_30; run;

%mend read30;

%read30 (exa,ha,ya,ya1,ya3,ya4); /*ya=19, ya1=0 (0/19=0%), ya4=0 (0/19=0%)*/
%read30 (exe,he,ye,ye1,ye3,ye4); /*ye=223, ye1=1 (1/223=0.457%), ye4=2 (2/223=0.90%)*/
%read30 (exi,hi,yi,yi1,yi3,yi4); /*yi=2784, yi1=87 (87/2784=3.13%), yi4=113 (113/2784=4.06%)*/

/* 60 days */
%Macro read60 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table35.csv" style=vasstables;
title1 "60 days Age adjested (65-74) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=3; run;
data &output3; set &output2; where readm_60=1; run;
proc freq data=&output3; table readm_60; run;
data &output4; set &output1; where agegrp=3; run;
data &output5; set &output4; where readm_rate_60>0; run;
proc freq data=&output5; table readm_rate_60; run;

%mend read60;

%read60 (exa,ha,ya,ya1,ya3,ya4); /*ya=19, ya1=0 (0/19=0%), ya4=0 (0/19=0%)*/
%read60 (exe,he,ye,ye1,ye3,ye4); /*ye=223, ye1=1 (1/223=0.45%), ye4=2 (2/223=0.90%)*/
%read60 (exi,hi,yi,yi1,yi3,yi4); /*yi=2784, yi1=125 (125/2784=4.49%), yi4=163 (163/2784=5.85%)*/

/* 90 days */
%Macro read90 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table36.csv" style=vasstables;
title1 "90 days Age adjested (65-74) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=3; run;
data &output3; set &output2; where readm_90=1; run;
proc freq data=&output3; table readm_90; run;
data &output4; set &output1; where agegrp=3; run;
data &output5; set &output4; where readm_rate_90>0; run;
proc freq data=&output5; table readm_rate_90; run;

%mend read90;

%read90 (exa,ha,ya,ya1,ya3,ya4); /*ya=19, ya1=0 (0/19=0%), ya4=0 (0/19=0%)*/
%read90 (exe,he,ye,ye1,ye3,ye4); /*ye=223, ye1=2 (2/223=0.90%), ye4=3 (3/223=1.35%)*/
%read90 (exi,hi,yi,yi1,yi3,yi4); /*yi=2784, yi1=139 (139/2784=4.99%), yi4=183 (183/2784=6.57%)*/


/* Age adjested agegrp =4 (75-More) */
/* 30 days */
%Macro read30 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table37.csv" style=vasstables;
title1 "30 days Age adjested (75 and more) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=4; run;
data &output3; set &output2; where readm_30=1; run;
proc freq data=&output3; table readm_30; run;
data &output4; set &output1; where agegrp=4; run;
data &output5; set &output4; where readm_rate_30>0; run;
proc freq data=&output5; table readm_rate_30; run;

%mend read30;

%read30 (exa,ha,ya,ya1,ya3,ya4); /*ya=28, ya1=0 (0/28=0%), ya4=0 (0/28=0%)*/
%read30 (exe,he,ye,ye1,ye3,ye4); /*ye=407, ye1=0 (0/407=0%), ye4=0 (0/407=0%)*/
%read30 (exi,hi,yi,yi1,yi3,yi4); /*yi=4403, yi1=100 (100/4403=2.27%), yi4=143 (143/4403=3.25%)*/

/* 60 days */
%Macro read60 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table38.csv" style=vasstables;
title1 "60 days Age adjested (75 and more) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=4; run;
data &output3; set &output2; where readm_60=1; run;
proc freq data=&output3; table readm_60; run;
data &output4; set &output1; where agegrp=4; run;
data &output5; set &output4; where readm_rate_60>0; run;
proc freq data=&output5; table readm_rate_60; run;

%mend read60;

%read60 (exa,ha,ya,ya1,ya3,ya4); /*ya=28, ya1=0 (0/28=0%), ya4=0 (0/28=0%)*/
%read60 (exe,he,ye,ye1,ye3,ye4); /*ye=407, ye1=0 (0/407=0%), ye4=0 (0/407=0%)*/
%read60 (exi,hi,yi,yi1,yi3,yi4); /*yi=4403, yi1=141 (141/4403=3.20%), yi4=191 (191/4403=4.34%)*/

/* 90 days */
%Macro read90 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table39.csv" style=vasstables;
title1 "90 days Age adjested (75 and more) Readmission of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=4; run;
data &output3; set &output2; where readm_90=1; run;
proc freq data=&output3; table readm_90; run;
data &output4; set &output1; where agegrp=4; run;
data &output5; set &output4; where readm_rate_90>0; run;
proc freq data=&output5; table readm_rate_90; run;

%mend read90;

%read90 (exa,ha,ya,ya1,ya3,ya4); /*ya=28, ya1=0 (0/28=0%), ya4=1 (1/28=3.57%)*/
%read90 (exe,he,ye,ye1,ye3,ye4); /*ye=407, ye1=0 (0/407=0%), ye4=0 (0/407=0%)*/
%read90 (exi,hi,yi,yi1,yi3,yi4); /*yi=4403, yi1=176 (176/4403=4.0%), yi4=237 (237/4403=5.38%)*/


/*************************************************************/

/*                 Mortality Rate Analyses					*/

/*************************************************************/

data datindxa6; set ais.datindxa6; run;
data datindxe6; set ais.datindxe6; run;
data datindxi6; set ais.datindxi6; run;

/* Creating the Mortality variable*/

%Macro died (input,output);

data h; set &input; proc sort; by maskssn; run;
data &output; set h; by maskssn;
    retain death;
    if dischstat = 20 then death=1;
      else death= 0;
run;

%mend died;

%died (datindxi6,deathi)


%Macro mort (input,output);

data &output; set &input ;
mort30= index_dt+30;
mort60= index_dt+60;
mort90= index_dt+90;
mort365= index_dt+365;
      format mort30 mmddyy10.;
      format mort60 mmddyy10.; 
      format mort90 mmddyy10.;
      format mort365 mmddyy10.;
run;

%mend mort;

%mort (deathi,mort); /*obs 24681*/ 

data mort1; set mort; 
if dis_index_dt <= mort30 and death=1 then mort_30=1; else mort_30=0;
if dis_index_dt <= mort60 and death=1 then mort_60=1; else mort_60=0;
if dis_index_dt <= mort90 and death=1 then mort_90=1; else mort_90=0;
if dis_index_dt <= mort365 and death=1 then mort_365=1; else mort_365=0;
run;

%Macro mortx (input,output1,output2,output3,output4,output5,output6);

data &output1; set &input; where mort_30=1; run;
data &output2; set &output1; keep maskssn; run;
proc sort data=&output2 nodupkey; by maskssn; run;

data &output3; set &input; where mort_60=1; run;
data &output4; set &output3; keep maskssn; run;
proc sort data=&output4 nodupkey; by maskssn; run;

data &output5; set &input; where mort_90=1; run;
data &output6; set &output5; keep maskssn; run;
proc sort data=&output6 nodupkey; by maskssn; run;

%mend mortx;

%mortx (mort1,morti30,testi,morti60,testi1,morti90,testi2); 
/*R30:obs 146,unique obs 146*, *R60:obs 149,unique obs 149*, *R90:obs 150,unique obs 150*/



/**************************************************/

%Macro mortr (input,input1,output1,output2,output3,output4);

/*Creating the mortality rate*/
/*mort_30*/
data &output1; set &input; proc sort; by maskssn; run;
data &output1; set &output1; by maskssn;
    retain mort_rate_30;
      if first.maskssn then mort_rate_30=mort_30;
      else mort_rate_30= mort_30+ mort_rate_30;
      if last.maskssn;
run;

proc sql;
create table y as select a.*, b.*
from &input1 a left join &output1 b
on a. maskssn = b. maskssn;
quit; 

/*mort_60*/
data &output2; set &input; proc sort; by maskssn; run;
data &output2; set &output2; by maskssn;
    retain mort_rate_60;
      if first.maskssn then mort_rate_60=mort_60;
      else mort_rate_60= readm_60+ mort_rate_60;
      if last.maskssn;
run;

proc sql;
create table y as select a.*, b.*
from y a left join &output2 b
on a. maskssn = b. maskssn;
quit; 

/*mort_90*/
data &output3; set &input; proc sort; by maskssn; run;
data &output3; set &output3; by maskssn;
    retain mort_rate_90;
      if first.maskssn then mort_rate_90=mort_90;
      else mort_rate_90= mort_90+ mort_rate_90;
      if last.maskssn;
run;

proc sql;
create table &output4 as select a.*, b.*
from y a left join &output3 b
on a. maskssn = b. maskssn;
quit; 

%mend mortr;

%mortr (mort1,datindxi6,morti_rate30,morti_rate60, morti_rate90,datindxi6); /*obs 619*/


%Macro reform (input, output);

data &output; set &input; 

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

*categorize gender*;
	if sex ='M' then sex = 1; * Male *;
	else if sex ='F' then sex = 2; * Female *;
	else if sex ='U' then sex = 3; * Unknown *;

*categorize race*;
		do year = 2006 to 2009;
			if race = 4 then race = 5;
			if race = 6 then race = 3;
			if race = 7 then race = 6;
			if race = 8 then race = 7; 
		end;
	
	if race = 3 then newrace = 1; * Black *;
	if race = 5 then newrace = 2; * White *;
	if race in (1 2 4 6 7) then newrace = 3; * All Others *;

*categorize payer*;
	if payer in ('L', 'N') then newpayer = 0; * No Insurance *;
	if payer in ('A', 'B', 'C', 'D', 'I', 'J', 'K', 'O', 'H') then newpayer = 1; * Government Insurance *;
	if payer in ('E', 'F', 'G', 'Q') then newpayer = 2; * Private Insurance *;
	if payer in ('M') then newpayer = 3; * Other Insurance *;
	
*categorize states*;
	if ptstate ='FL' then ptstate = 1; * Florida *;
	else ptstate = 2; * Other than Florida *;	
run;

%mend reform;

/* Our final data files for mortality,LOS,and tgch analyses */
%reform (datindxi6,ais.datindxi6); /*obs 24681*/


/* Mortality and mortality rate Analysis */

/* 30 days */
%Macro mort30 (input,output1,output2,output3);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table1.csv";
title1 "30 days Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where mort_30=1; run;
proc freq data=&output2; table mort_30; run;
data &output3; set &output1; where mort_rate_30>0; run;
proc freq data=&output3; table mort_rate_30; run;

%mend mort30;
								                 /*mort_30*/	    /*mort_rate_30*/
%mort30 (datindxi6,hi,yi,yi1) /*ha=72, ya=145 (145/24681=0.59%), ya1=146 (146/24681=0.60%)*/


/* 60 days */
%Macro mort60 (input,output1,output2,output3);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table2.csv";
title1 "60 days Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where mort_60=1; run;
proc freq data=&output2; table mort_60; run;
data &output3; set &output1; where mort_rate_60>0; run;
proc freq data=&output3; table mort_rate_60; run;

%mend mort60;
								                 /*mort_60*/	    /*mort_rate_60*/
%mort60 (datindxi6,hi,yi,yi1) /*ha=72, ya=148 (148/24681=0.60%), ya1=584 (584/24681=2.37%)*/


/* 90 days */
%Macro mort90 (input,output1,output2,output3);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table3.csv";
title1 "90 days Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where mort_90=1; run;
proc freq data=&output2; table mort_90; run;
data &output3; set &output1; where mort_rate_90>0; run;
proc freq data=&output3; table mort_rate_90; run;

%mend mort90;
								                 /*mort_90*/	    /*mort_rate_90*/
%mort90 (datindxi6,hi,yi,yi1) /*ha=72, ya=149 (149/24681=0.60%), ya1=584 (150/24681=0.61%)*/


/* Age adjested Mortality Analysis */

/* Age adjested agegrp =1 (18-49) */
/* 30 days */
%Macro mort30 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table4.csv" style=vasstables;
title1 "30 days Age adjested (18-49) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=1; run;
data &output3; set &output2; where mort_30=1; run;
proc freq data=&output3; table mort_30; run;
data &output4; set &output1; where agegrp=1; run;
data &output5; set &output4; where mort_rate_30>0; run;
proc freq data=&output5; table mort_rate_30; run;

%mend mort30;
										  /*mort_30*/	   /*mort_rate_30*/										
%mort30 (datindxi6,ha,y,y1,y3,y4); /*y=1124, ya1=8 (8/1124=0.71%), ya4=8 (8/1124=0.71%)*/

/* Age adjested agegrp =1 (18-49) */
/* 60 days */
%Macro mort60 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table5.csv" style=vasstables;
title1 "60 days Age adjested (18-49) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=1; run;
data &output3; set &output2; where mort_60=1; run;
proc freq data=&output3; table mort_60; run;
data &output4; set &output1; where agegrp=1; run;
data &output5; set &output4; where mort_rate_60>0; run;
proc freq data=&output5; table mort_rate_60; run;

%mend mort60;
										  /*mort_60*/	   /*mort_rate_60*/										
%mort60 (datindxi6,ha,y,y1,y3,y4); /*y=1124, y1=11 (11/1124=0.98%), y4=35 (35/1124=3.11%)*/


/* Age adjested agegrp =1 (18-49) */
/* 90 days */
%Macro mort90 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table5.csv" style=vasstables;
title1 "90 days Age adjested (18-49) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=1; run;
data &output3; set &output2; where mort_90=1; run;
proc freq data=&output3; table mort_90; run;
data &output4; set &output1; where agegrp=1; run;
data &output5; set &output4; where mort_rate_90>0; run;
proc freq data=&output5; table mort_rate_90; run;

%mend mort90;
										  /*mort_90*/	   /*mort_rate_90*/										
%mort90 (datindxi6,ha,y,y1,y3,y4); /*y=1124, y1=11 (11/1124=0.98%), y4=11 (11/1124=0.98%)*/


/* Age adjested agegrp =2 (50-64) */
/* 30 days */
%Macro mort30 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table6.csv" style=vasstables;
title1 "30 days Age adjested (50-64) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=2; run;
data &output3; set &output2; where mort_30=1; run;
proc freq data=&output3; table mort_30; run;
data &output4; set &output1; where agegrp=2; run;
data &output5; set &output4; where mort_rate_30>0; run;
proc freq data=&output5; table mort_rate_30; run;

%mend mort30;

%mort30 (datindxi6,ha,y,y1,y3,y4); /*y=4052, y1=30 (30/4052=0.74%), y4=30 (30/4052=0.74%)*/


/* Age adjested agegrp =2 (50-64) */
/* 60 days */
%Macro mort60 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table7.csv" style=vasstables;
title1 "60 days Age adjested (50-64) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=2; run;
data &output3; set &output2; where mort_60=1; run;
proc freq data=&output3; table mort_60; run;
data &output4; set &output1; where agegrp=2; run;
data &output5; set &output4; where mort_rate_60>0; run;
proc freq data=&output5; table mort_rate_60; run;

%mend mort60;

%mort60 (datindxi6,ha,y,y1,y3,y4); /*y=4052, y1=30 (30/4052=0.74%), y4=150 (150/4052=3.70%)*/


/* Age adjested agegrp =2 (50-64) */
/* 90 days */
%Macro mort90 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table8.csv" style=vasstables;
title1 "90 days Age adjested (50-64) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=2; run;
data &output3; set &output2; where mort_90=1; run;
proc freq data=&output3; table mort_90; run;
data &output4; set &output1; where agegrp=2; run;
data &output5; set &output4; where mort_rate_90>0; run;
proc freq data=&output5; table mort_rate_90; run;

%mend mort90;

%mort90 (datindxi6,ha,y,y1,y3,y4); /*y=4052, y1=30 (30/4052=0.74%), y4=30 (30/4052=0.74%)*/


/* Age adjested agegrp =3 (65-74) */
/* 30 days */
%Macro mort30 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table10.csv" style=vasstables;
title1 "30 days Age adjested (50-64) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=3; run;
data &output3; set &output2; where mort_30=1; run;
proc freq data=&output3; table mort_30; run;
data &output4; set &output1; where agegrp=3; run;
data &output5; set &output4; where mort_rate_30>0; run;
proc freq data=&output5; table mort_rate_30; run;

%mend mort30;

%mort30 (datindxi6,ha,y,y1,y3,y4); /*y=4734, y1=36 (36/4734=0.76%), y4=36 (36/4734=0.76%)*/


/* Age adjested agegrp =3 (65-74) */
/* 60 days */
%Macro mort60 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table11.csv" style=vasstables;
title1 "60 days Age adjested (50-64) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=3; run;
data &output3; set &output2; where mort_60=1; run;
proc freq data=&output3; table mort_60; run;
data &output4; set &output1; where agegrp=3; run;
data &output5; set &output4; where mort_rate_60>0; run;
proc freq data=&output5; table mort_rate_60; run;

%mend mort60;

%mort60 (datindxi6,ha,y,y1,y3,y4); /*y=4734, y1=36 (36/4734=0.76%), y4=169 (169/4734=3.57%)*/


/* Age adjested agegrp =3 (65-74) */
/* 90 days */
%Macro mort90 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table12.csv" style=vasstables;
title1 "90 days Age adjested (50-64) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=3; run;
data &output3; set &output2; where mort_90=1; run;
proc freq data=&output3; table mort_90; run;
data &output4; set &output1; where agegrp=3; run;
data &output5; set &output4; where mort_rate_90>0; run;
proc freq data=&output5; table mort_rate_90; run;

%mend mort90;

%mort90 (datindxi6,ha,y,y1,y3,y4); /*y=4734, y1=37 (37/4734=0.78%), y4=37 (37/4734=0.78%)*/


/* Age adjested agegrp =4 (74 and more)  */
/* 30 days */
%Macro mort30 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table13.csv" style=vasstables;
title1 "30 days Age adjested (74 and more) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=4; run;
data &output3; set &output2; where mort_30=1; run;
proc freq data=&output3; table mort_30; run;
data &output4; set &output1; where agegrp=4; run;
data &output5; set &output4; where mort_rate_30>0; run;
proc freq data=&output5; table mort_rate_30; run;

%mend mort30;

%mort30 (datindxi6,ha,y,y1,y3,y4); /*y=9305, y1=71 (71/9305=0.76%), y4=72 (72/9305=0.77%)*/


/* Age adjested agegrp =4 (74 and more)  */
/* 60 days */
%Macro mort60 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table14.csv" style=vasstables;
title1 "60 days Age adjested (74 and more) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=4; run;
data &output3; set &output2; where mort_60=1; run;
proc freq data=&output3; table mort_60; run;
data &output4; set &output1; where agegrp=4; run;
data &output5; set &output4; where mort_rate_60>0; run;
proc freq data=&output5; table mort_rate_60; run;

%mend mort60;

%mort60 (datindxi6,ha,y,y1,y3,y4); /*y=9305, y1=71 (71/9305=0.76%), y4=230 (230/9305=2.47%)*/


/* Age adjested agegrp =4 (74 and more)  */
/* 90 days */
%Macro mort90 (input,output1,output2,output3,output4,output5);

ods csv file= "/Volumes/My Passport for Mac/aisproject/table15.csv" style=vasstables;
title1 "90 days Age adjested (74 and more) Mortality of AIS Patients";

data &output1; set &input; run; 
proc sort data=&output1 nodupkey; by maskssn; run;

data &output2; set &output1; where agegrp=4; run;
data &output3; set &output2; where mort_90=1; run;
proc freq data=&output3; table mort_90; run;
data &output4; set &output1; where agegrp=4; run;
data &output5; set &output4; where mort_rate_90>0; run;
proc freq data=&output5; table mort_rate_90; run;

%mend mort90;

%mort90 (datindxi6,ha,y,y1,y3,y4); /*y=9305, y1=71 (37/9305=0.76%), y4=72 (72/9305=0.77%)*/

data ais.datindxi6; set datindxi6; run;


/*Analyses only on the inpatients*/


/* xx observations */

%Macro elix (input,input1,output,output1);

data &output; set &input; keep maskssn readmit_score; run;
proc sort data=&output nodupkey; by maskssn; run;

proc sql;
create table &output1 as select a.*,b.*
from &input1 a left join &output b
on a. maskssn = b. maskssn;
quit; 

%mend elix;

%elix (ais.elixscread,ais.datindxi7,elixscread,ais.datindxi7); /*obs 12438*/
%elix (ais.elixscrmor,ais.datindxi6,elixscrmor,ais.datindxi6); /*obs 24681*/




/**************************************************/
/*Creating dataset for descriptive analysis AND (Total charge + LOS + Mortality)*/
* identification and removal of outliers*;

data ax; set ais.datindxi6; 

proc univariate data = ax robustscale plot;
var losdays tchgs;
run;

data desci; set ax; 
if losdays>180 then losdays=180;
if tchgs<600 then tchgs=600;
if tchgs>2178841 then tchgs=2178841;
run; 

/* 154783 observations for descriptive analysis AND (Total charge + LOS + Mortality)*/

proc univariate data = desci robustscale plot;
var losdays tchgs;
run;

/* Process of TCHGS */

data tchgs; set desci; proc sort; by maskssn; run;
data tchgs; set tchgs; by maskssn;
    retain pt_tchgs;
      if first.maskssn then pt_tchgs=tchgs;
      else pt_tchgs= tchgs+ pt_tchgs;
      if last.maskssn;
run;
data tchgs; set tchgs; keep maskssn pt_tchgs; run; 

proc sql;
create table desc1 as select a.*,b.*
from desci a left join tchgs b
on a. maskssn = b. maskssn;
quit; 

/* Save our work in the permenant library */
data ais.desc; set desc1; run;

/* Process of LOS */

data losdy; set desc1; proc sort; by maskssn; run;
data losdy; set losdy; by maskssn;
    retain pt_losdy;
      if first.maskssn then pt_losdy=losdays;
      else pt_losdy= losdays+ pt_losdy;
      if last.maskssn;
run;
data losdy; set losdy; keep maskssn pt_losdy; run; 
data desc; set ihd.desc; run;

proc sql;
create table desc2 as select a.*,b.*
from desci a left join losdy b
on a. maskssn = b. maskssn;
quit; 

/* Save our work in the permenant library */
data ais.desca; set desc2; run; * database with tchg and losdays *;

/* Process of Mortality */

data died; set desc2; proc sort; by maskssn; run;
data died; set died; by maskssn;
    retain pt_died;
    if dischstat = 20 then pt_died=1;
      else pt_died= 0;
run;
data died; set died; keep maskssn pt_died; run; 
proc sort data=died nodupkey; by maskssn; run;

proc sql;
create table desc3 as select a.*,b.*
from desc2 a left join died b
on a. maskssn = b. maskssn;
quit; 


* Creating newyear *;
data descr; set desc3; newyear = dischdate;format newyear year4.;run;

options nofmterr;


*creating variable to use in proc tabulate to represent all subjects;
data descr; set descr; overall=1; 
nsex = input(sex, 3.);
drop sex;
rename nsex=sex;
nwpayer=input(newpayer, 8.);
drop newpayer;
rename nwpayer=newpayer;
nwrace = input(newrace, 8.);
drop newrace;
rename nwrace=newrace;
agegr=input(agegrp, 3.);
drop agegrp;
rename agegr=agegrp;
ptstat=input(ptstate, 6.);
drop ptstate;
rename ptstat=ptstate;
Ethnicit = input(Ethnicity, 8.); 
drop Ethnicity;
rename Ethnicit=Ethnicity;
run;


* Formating *;
proc format;
value yesno_ 1='   Yes'
0='   No';           
value ptstate_ 1='   Florida'
2='   Outside Florida';
value sex_ 1='   Male'
2='   Female'
3='   Unknown';
value agegrp_ 1='   18-49'
2='   50-64'
3='   65-74'
4='   74<'
.='   Missing';
value newrace_ 1='   Black'
2='   White'
3='   _Other';
value stratum_ 1='   Angina Pectoris'
2='   AMI'
3='   Post AMI Complication'
4='   Other IHD Cases'
5='   Co-occurring IHD cases';
value ethnicity_ 1='   Hispanic'
2='   Not_Hispanic'
3='   Unknown'
.='   Missing';
value newpayer_ 0='   No Insurance'
1='   Government Insurance'
2='   Private Insurance'
3='   Other Insurance';
value overall 1='   Total cohort';
value age;
value pt_tchgs; 
value pt_losdy;
picture pctfmt(round)low-high='   009.9)' (prefix='(');
run;

* create a �journal style� template *;
proc template;
	define style Styles.karamtables;
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

data descr; set ihd.descr; run;

proc sort data=descr nodupkey; by maskssn; run; * obs 56245*;
/*data ihdfinal; set ht; if nmiss(of _numeric_) + cmiss(of _character_) >0 then delete; run;*/;
/* Save our work in the permenant library */
data elixscrmor; set ihd.elixscrmor;keep maskssn mortal_score; run;
proc sort data=elixscrmor nodupkey; by maskssn; run;

proc sql;
create table descr as
select*
from descr left join elixscrmor
on descr. maskssn = elixscrmor. maskssn;
quit; 

data ihd.datindx8; set descr;run;

/******************* TABLE 1 in TEXT *************************************************/
* Labeling Categorical Variables*;

data tab1;
set descr;
label newpayer='Payer';
label newrace = 'Race';
label agegrp='Age groups';
label ptstate='States';
label sex='Gender';
label pt_died='Died';
label Etnicity = 'Ethnicity'; 
label pt_tchgs ='Total gross charges';
label pt_losdy = 'Length of stay';
label age = 'Age';
label overall = 'Total cohort';

* Creating table 1*;

options orientation=landscape;

ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table1.pdf" style=karamtables;

title1 "Clinical and Socioeconomic Characteristic of IHD Patients";

proc tabulate data=tab1 missing order=formatted;
	class stratum newrace sex ethnicity newpayer agegrp ptstate pt_died hld tia Stroke cvd chf htn dm cad pvd copd dep anx overall;
	classlev newrace sex ethnicity newpayer agegrp ptstate pt_died hld tia Stroke cvd chf htn dm cad pvd copd dep anx /style=[cellwidth=3in asis=on];
	table newrace sex ethnicity newpayer agegrp ptstate pt_died hld tia Stroke cvd chf htn dm cad pvd copd dep anx,
		overall=''*(n*f=4.0 colpctn='(%)'*f=pctfmt.)
		stratum= 'stratum'*(n*f=4.0 colpctn='(%)'*f=pctfmt.)/misstext='0' rts=15;
format stratum stratum_. newrace newrace_. sex sex_. ethnicity ethnicity_. newpayer newpayer_. agegrp agegrp_. ptstate ptstate_. 
pt_died yesno_. hld yesno_. tia yesno_. Stroke yesno_. cvd yesno_. chf yesno_. htn yesno_. dm yesno_. cad yesno_. pvd yesno_. 
copd yesno_. dep yesno_. anx yesno_. overall overall.;
run;

*Sub-analyses for mortality*;
data tab1;
set descr;
label newpayer='Payer';
label newrace = 'Race';
label agegrp='Age groups';
label ptstate='States';
label sex='Gender';
label pt_died='Died';
label Etnicity = 'Ethnicity'; 
label pt_tchgs ='Total gross charges';
label pt_losdy = 'Length of stay';
label age = 'Age';
label overall = 'Total cohort';

*Three-way table 1*;
proc freq data=tab1;
table stratum*newrace*pt_died / norow nopercent;
format stratum stratum_. newrace newrace_. pt_died yesno_.;
run;

*Three-way table 2*;
proc freq data=tab1;
table stratum*agegrp*pt_died / norow nopercent;
format stratum stratum_. newrace newrace_. pt_died yesno_. agegrp agegrp_.;
run;


/******************* TABLE 2 in TEXT *************************************************/

data tab2;
set descr;
label newpayer='Payer';
label newrace = 'Race';
label agegrp='Age groups';
label ptstate='States';
label sex='Gender';
label pt_died='Died';
label Etnicity = 'Ethnicity'; 
label pt_tchgs ='Total gross charges';
label pt_losdy = 'Length of stay';
label age = 'Age';
label overall = 'Total cohort';

* Creating table 2*;
options orientation=landscape;

ods csv file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table2.csv" style=karamtables;

title1 "Ethnoracial Differences in Hospital Resource Utilization of IHD Patients";

proc tabulate data=tab2 missing order=formatted;
	class newrace stratum ;
	var pt_tchgs pt_losdy age ;
	table pt_tchgs pt_losdy age,
		newrace='Race'*(mean*f=6.1 stddev*f=6.1)
		stratum='Stratum'*(mean*f=6.1 stddev*f=6.1);
	format stratum stratum_. newrace newrace_. overall overall. pt_tchgs pt_tchgs. pt_losdy pt_losdy. age age. ;
run;

/******************* TABLE 5 in TEXT***********************************************/
* Labeling Categorical Variables*; 

data tab5;
set descr;
label newpayer='Payer';
label newrace = 'Race';
label agegrp='Age Groups';
label ptstate='States';
label sex='Gender';
label pt_died='Died';
label Etnicity = 'Etnicity'; 
label pt_tchgs ='Total gross charges';
label pt_losdy = 'Length of stay';
label overall = 'Total cohort';

* Creating table 5;
options orientation=portrait;

ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table5.pdf" style=karamtables;

title1 "Chisquare Test for Clinical and Socioeconomic Characteristic of IHD Patients";

proc freq data=tab5 order=formatted;
	tables (newrace)*(sex ethnicity newpayer agegrp ptstate pt_died hld tia Stroke cvd chf htn dm cad pvd copd dep anx)/ chisq;
	format newrace newrace_. sex sex_. ethnicity ethnicity_. newpayer newpayer_. agegrp agegrp_. ptstate ptstate_. 
pt_died yesno_. hld yesno_. tia yesno_. Stroke yesno_. cvd yesno_. chf yesno_. htn yesno_. dm yesno_. cad yesno_. pvd yesno_. 
copd yesno_. dep yesno_. anx yesno_.;
run;

/******************* TABLE 6 in TEXT *************************************************/
* Labeling Categorical Variables*; 
data tab6;
set descr;
label newpayer='Payer';
label newrace = 'Race';
label agegrp='Age Groups';
label ptstate='States';
label sex='Gender';
label pt_died='Mortality';
label Etnicity = 'Etnicity'; 
label pt_tchgs ='Total Gross Charges';
label pt_losdy = 'Length of Stay';
label overall = 'overall data set';

* Creating table 6;
options orientation=portrait;

ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table6.pdf" style=karamtables;

title1 "Chisquare Test for Clinical and Socioeconomic Characteristic of IHD Patients - Strata";

proc freq data=tab6 order=formatted; 
	tables (newrace sex ethnicity newpayer agegrp ptstate pt_died hld tia Stroke cvd chf htn dm cad pvd copd dep anx) * (stratum)/ chisq;
	format stratum stratum_. newrace newrace_. sex sex_. ethnicity ethnicity_. newpayer newpayer_. agegrp agegrp_. ptstate ptstate_. 
pt_died yesno_. hld yesno_. tia yesno_. Stroke yesno_. cvd yesno_. chf yesno_. htn yesno_. dm yesno_. cad yesno_. pvd yesno_. 
copd yesno_. dep yesno_. anx yesno_.;
run;

/******************* TABLE 7 in TEXT *************************************************/

options orientation=portrait;

ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table7.pdf" style=karamtables;

title1 "LOS and pt-tchgs - P value - Continuous variable";

proc glm data=descr order=formatted;
	class stratum;
	model pt_tchgs =  stratum;
	means stratum/bon; 
run;

proc glm data=descr order=formatted;
	class newrace;
	model pt_tchgs =  newrace;
	means newrace/bon; 
run;

proc glm data=descr order=formatted;
	class newrace;
	model pt_losdy = newrace;
	means newrace/bon; 
run;

proc glm data=descr order=formatted;
	class stratum;
	model pt_losdy = stratum;
	means stratum/bon; 
run;

proc glm data=descr order=formatted;
	class stratum;
	model age = stratum;
	means stratum/bon; 
run;

proc glm data=descr order=formatted;
	class newrace;
	model age = newrace;
	means newrace/bon; 
run;

/******************* TABLE 8 in TEXT *************************************************/

options orientation=portrait;

ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table8.pdf" style=karamtables;

title1 "LOS and pt-tchgs - P value - Continuous variable Strata";

proc glm data=descr order=formatted;
	class stratum;
	model pt_tchgs = stratum;
	means stratum/bon; 
run;

proc glm data=descr order=formatted;
	class stratum;
	model pt_losdy = stratum;
	means stratum/bon; 
run;

/******************* Predictive Analysis *************************************************/
* Create log pt_tchgs and pt_losdy *;

data ex; set descr; l_ptchgs = log(pt_tchgs); l_plosdy = log(pt_losdy); newyear = dischdate;format newyear year4.;run;

data ihd.ex; set ex; run;





















*Oaxaca Blinder Decomposition*;

%macro BO_decomp 
( 
dsname = ex, /* input data set */ 
depvar = l_ptchgs, /* dependent variable */ 
groupvarref= (newrace=2), /* reference definition for the dependent variable */ 
numvar= age, /* list of continuous predictor variables (leave blank if none) */ 
charvar = sex ethnicity newpayer agegrp ptstate pt_died hld tia Stroke cvd chf htn dm cad pvd copd dep anx, /* list of character variables (leave blank if none) */ 
charvarref= sex /* list reference group definitions(s) (leave blank if none) 
for example: supervs (ref='Y') */ 
); 
ods listing close; 
%let nocharvar=%str( ); 
%if charvar eq %then &nocharvar=*; 
* create a dichotomous A/B grouping variable where B denotes reference group; 
data &dsname._bo; 
length groupvar $1; 
set &dsname; 
if &groupvarref then groupvar='A'; 
else groupvar='B'; 
run; 
* create macro variables housing associated counts of &groupvar levels; 
proc sql noprint; 
select count(*) into :groupvarA_count from &dsname._bo where groupvar="A"; 
select count(*) into :groupvarB_count from &dsname._bo where groupvar="B"; 
quit; 
* fit regression models separately for each group; 
proc sort data=&dsname._bo; by groupvar; run; 
ods output ParameterEstimates=betas; 
proc glm data=&dsname._bo; 
by groupvar; 
&nocharvar class &charvarref &charvar; 
model l_ptchgs = &numvar /* numeric variables */ 
&charvar /* character variables (w/o the (ref=' ') */ 
/ solution; 
quit; 
* re-orient group-specific parameter estimates; 
proc sort data=betas; by Parameter; run; 
data betas; 
length Parameter $200; 
merge betas (where=(groupvar="A") rename=(Estimate=Estimate_A)) 
betas (where=(groupvar="B") rename=(Estimate=Estimate_B)); 
by Parameter; 
keep Dependent Parameter Estimat:; 
Parameter=trim(scan(Parameter,1))||'_'||trim(scan(Parameter,2)); 
Parameter=compress(Parameter); 
if scan(Parameter,2,"_")=' ' then Parameter=scan(Parameter,1,"_"); 
run; 
* merge in means of the predictor variables; 
ods output statistics=means0 
domain=means;
proc surveymeans data=&dsname._bo mean;
var &numvar 
&charvar; 
domain groupvar; 
run; 
data means;

length Parameter $200; 
merge means0 
means (where=(groupvar="A") rename=(Mean=Mean_A)) 
means (where=(groupvar="B") rename=(Mean=Mean_B)); 
Parameter=trim(VarName)||'_'||trim(VarLevel); 
Parameter=compress(Parameter); 
if scan(Parameter,2,"_") in(' ' '.') then Parameter=scan(Parameter,1,"_"); 
keep Parameter Mea:; 
run; 
proc sort data=means; by Parameter; run; 
* create a summary table; 
data all; 
merge betas 
means; 
by Parameter; 
if Mean =. then Mean=1; 
if Mean_A=. then Mean_A=1; 
if Mean_B=. then Mean_B=1; 
explained =Estimate_A*(Mean_A - Mean_B); 
unexplained=Mean_B*(Estimate_B - Estimate_A); 
run; 
* sum components for multi-factor effects; 
data sums; 
set all; 
Parameter=scan(Parameter,1,"_"); 
run; 
proc means data=sums noprint nway; 
class Parameter; 
var explained unexplained; 
output out=sums (keep=Parameter explained unexplained) sum=; 
run; 
proc means data=sums noprint nway; 
var explained unexplained; 
output out=sums0 (keep=explained unexplained) sum=; 
run; 
proc sql noprint; 
select explained into :sum_e from sums0; 
select unexplained into :sum_u from sums0; 
quit; 
data all; 
length Parameter $200; 
set all 
sums 
sums0; 
pct_explained =explained /(&sum_e+&sum_u); 
pct_unexplained=unexplained/(&sum_e+&sum_u); 
run; 
proc sort data=all; by Parameter Estimate_A; run; 
data all; 
set all; 
Gap=explained+unexplained; 
if Parameter=' ' then Parameter='Overall'; 
if Parameter='Overall' then do; 
pct_explained=explained/(explained+unexplained); 
pct_unexplained=unexplained/(explained+unexplained); 
end; 
merge_counter=_N_; 
run; 
ods listing; 
* overall summary report; 
title '1) Overall Summary'; 
proc sql;

select Parameter as Level format=$15., 
Gap format=6.3, 
explained label='Exp.' format=6.3, 
unexplained label='Unexp.' format=6.3, 
pct_explained label='% Exp.' format=percent8.2 
from all 
where (Parameter='Overall' or Dependent=' '); 
quit; 
title '2) Variable-Specific Summary'; 
* regression parameter level summary report; 
proc sql; 
select Parameter format=$15., 
Estimate_A label='Coef A' format=6.3,Mean_A label='Mean A' format=6.3, 
Estimate_B label='Coef B' format=6.3,Mean_B label='Mean B' format=6.3, 
Gap format=6.3,explained label='Exp.' format=6.3,unexplained label='Unexp.' format=6.3, 
pct_explained label='% Exp.' format=percent8.2 
from all 
where Dependent ne ' '; 
quit; 
title; 
%mend;

%BO_decomp ( 
dsname = ex, /* input data set */ 
depvar = l_ptchgs, /* dependent variable */ 
groupvarref= (newrace=2), /* reference definition for the dependent variable */ 
numvar= age, /* list of continuous predictor variables (leave blank if none) */ 
charvar = sex ethnicity newpayer agegrp ptstate pt_died hld tia Stroke cvd chf htn dm mi cad pvd copd dep anx, /* list of character variables (leave blank if none) */ 
charvarref= sex/* list reference group definitions(s) (leave blank if none) 
for example: supervs (ref='Y') */ 
); 


*****************************************************************************
*****************************************************************************
*****************************************************************************


* Readmission Part Two *;

data readmission; set ihd.datindx7; 
newyear = dischdate;format newyear year4.;
proc univariate data = readmission robustscale plot;
var losdays tchgs;
run;


* To address outliers*;

data readmission_1; set readmission; Keep MASKSSN READM_30 AGE AGEGRP SEX NEWRACE ETHNICITY LOSDAYS NEWPAYER STRATUM READMIT_SCORE PTSTATE ADMSRC ADM_PRIOR DISCHSTAT TYPE_SERV;
if losdays=. then delete;
if losdays=0 then delete;
if losdays>=180 then delete;
*if tchgs<=800 then delete;
*if tchgs>=2178841 then delete;

/*data ihd.readmission_1; set readmission_1; run; 


/*categorize ethnicity*/
	if ethnicity = 'E1' then ethnicity = 1;
	else if ethnicity = 'E2' then ethnicity = 2;
	else if ethnicity = 'E7' then ethnicity = 3;

*categorize age*;
	if 40 <= age <= 49 then agegrp=1;
	else if 50 <= age <65  then agegrp=2;
	else if 65 <= age <=74  then agegrp=3;
	else if 75 <= age then agegrp=4;

*categorize gender*;
	if sex ='M' then sex = 1; * Male *;
	else if sex ='F' then sex = 2; * Female *;
	else if sex ='U' then sex = 3; * Unknown *;

*categorize race*;
		do year = 2006 to 2009;
			if race = 4 then race = 5;
			if race = 6 then race = 3;
			if race = 7 then race = 6;
			if race = 8 then race = 7; 
		end;
	
	if race = 3 then newrace = 1; * Black *;
	if race = 5 then newrace = 2; * White *;
	if race in (1 2 4 6 7) then newrace = 3; * All Others *;

*categorize payer*;
	if payer in ('L', 'N') then newpayer = 0; * No Insurance *;
	if payer in ('A', 'B', 'C', 'D', 'I', 'J', 'K', 'O', 'H') then newpayer = 1; * Government Insurance *;
	if payer in ('E', 'F', 'G', 'Q') then newpayer = 2; * Private Insurance *;
	if payer in ('M') then newpayer = 3; * Other Insurance *;
	
*categorize states*;
	if ptstate ='FL' then ptstate = 1; * Florida *;
	else ptstate = 2; * Other than Florida *;
	
nsex = input(sex, 3.);
drop sex;
rename nsex=sex;
nwpayer=input(newpayer, 8.);
drop newpayer;
rename nwpayer=newpayer;
nwrace = input(newrace, 8.);
drop newrace;
rename nwrace=newrace;
agegr=input(agegrp, 3.);
drop agegrp;
rename agegr=agegrp;
ptstat=input(ptstate, 6.);
drop ptstate;
rename ptstat=ptstate;
Ethnicit = input(Ethnicity, 8.); 
drop Ethnicity;
rename Ethnicit=Ethnicity;
run;


data rd1;
set rd;

options orientation=portrait;

ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table5.pdf" style=karamtables;

title1 "Ethnoracial Differences in Hospital Resource Utilization of IHD Patients";

/******************* TABLE 5A in TEXT *************************************************/

proc tabulate data=rd1 missing order=formatted;
	class newrace;
	var losdays;
	table losdays,
		newrace='Race'*(mean*f=6.1 stddev*f=6.1 min*f=6.1 max*f=6.1);
run; 

data rd2; set rd1;
if 1<=losdays<=44 then los=1;
if 45<=losdays<=89 then los=2;
if 90<=losdays<=134 then los=3;
if 135<=losdays<=178 then los=4;
run;



* Multicollinearity checking *;
proc reg data = rd2;
	model readm_30 = newrace sex ethnicity newpayer agegrp ptstate los hld tia Stroke cvd chf htn dm mi cad pvd copd/ vif tol collin;
	ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table6.pdf" style=karamtables;
run;


* Explanatory *;
title 'Stepwise Regression on IHD Readmission Data';
proc logistic data=rd2 outest=betas covout;
class newrace(ref=3) ;
   model readm_30(event='1')=newrace sex ethnicity newpayer age ptstate losdays hld tia Stroke cvd chf htn dm mi cad pvd copd
                / selection=stepwise
                  slentry=0.3
                  slstay=0.35
                  details
                  lackfit;
   output out=pred p=phat lower=lcl upper=ucl
          predprob=(individual crossvalidate);
   ods output Association=Association;
   ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table7.pdf" style=karamtables;
run;


* Explanatory died*;
data dd; set descc; 
nsex = input(sex, 3.);
drop sex;
rename nsex=sex;
nwpayer=input(newpayer, 8.);
drop newpayer;
rename nwpayer=newpayer;
nwrace = input(newrace, 8.);
drop newrace;
rename nwrace=newrace;
agegr=input(agegrp, 3.);
drop agegrp;
rename agegr=agegrp;
ptstat=input(ptstate, 6.);
drop ptstate;
rename ptstat=ptstate;
Ethnicit = input(Ethnicity, 8.); 
drop Ethnicity;
rename Ethnicit=Ethnicity;
run;

proc sort data=dd nodupkey; by maskssn; run;
title 'Stepwise Regression on IHD Readmission Data';
proc logistic data=dd outest=betas covout;
class newrace(ref=3) ;
   model pt_died(event='1')=newrace sex ethnicity newpayer age ptstate losdays hld tia Stroke cvd chf htn dm mi cad pvd copd
                / selection=stepwise
                  slentry=0.3
                  slstay=0.35
                  details
                  lackfit;
   output out=pred p=phat lower=lcl upper=ucl
          predprob=(individual crossvalidate);
   ods output Association=Association;
   ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table8.pdf" style=karamtables;
run;


 * tchgs explanatory variables*;
title 'Stepwise Regression on IHD Readmission Data';
proc genmod data=dd;
	class newrace/param=ref ;
	model tchgs=newrace sex ethnicity newpayer age ptstate losdays hld tia Stroke cvd chf htn dm mi cad pvd copd
                / dist = tweedie link=log;
   output out=pred p=phat lower=lcl upper=ucl;
   ods output ParameterEstimates=ihd.gmparms;     
   ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table9.pdf" style=karamtables;
run;


* losdays explanatory variables*;
title 'Stepwise Regression on IHD Readmission Data';
proc genmod data=dd;
	class newrace/param=ref ;
	model losdays=newrace sex ethnicity newpayer age ptstate hld tia Stroke cvd chf htn dm mi cad pvd copd
                / dist = tweedie link=log;
   output out=pred p=phat lower=lcl upper=ucl;
   ods output ParameterEstimates=ihd.gmparms1;     
   ods pdf file= "C:\Users\v.diaby\Desktop\ihdproject\ihd\table10.pdf" style=karamtables;
run;


**************************************
/*Data LOS, MORT, TCHGS*/

* To address outliers - Mort*;

data mort; set ihd.datindx8; Keep MASKSSN AGE AGEGRP SEX NEWRACE ETHNICITY PT_DIED PT_TCHGS PT_LOSDY NEWPAYER STRATUM MORTAL_SCORE PTSTATE ADMSRC ADM_PRIOR DISCHSTAT TYPE_SERV;
if losdays=. then delete;
if losdays=0 then delete;
if losdays>=180 then delete;
*if tchgs<=800 then delete;
*if tchgs>=2178841 then delete;
run;
data ihd.mort; set mort; run; 

* To address outliers - LOS and TCHGS*;
data loschgs; set ihd.datindx8; Keep MASKSSN AGE SEX NEWRACE ETHNICITY PT_TCHGS PT_LOSDY NEWPAYER STRATUM PTSTATE ADMSRC ADM_PRIOR TYPE_SERV PT_DIED hld tia Stroke cvd chf htn dm cad pvd copd dep anx;
if losdays=. then delete;
if losdays=0 then delete;
if losdays>=180 then delete;
*if tchgs<=800 then delete;
*if tchgs>=2178841 then delete;
run;
data ihd.loschgs; set loschgs; run; 


/***********************************************************************************/
