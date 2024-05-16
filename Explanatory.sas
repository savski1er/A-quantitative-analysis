Libname users "/Users/macuser/Desktop/aisproject/"; /*Project Library*/
Libname data "/Users/macuser/Desktop/aisproject/data"; /*ais dataset Library*/
Libname ais "/Users/macuser/Desktop/aisproject/ais"; /*ais dataset Library*/
Libname dat "/Users/macuser/Desktop/aisproject/dat"; /*acha dataset Library*/
Libname sec "/Users/macuser/Desktop/aisproject/securedata"; /*acha dataset Library*/

*****************************************************************************
*************************** Pre-Explanatory Analysis ************************
*****************************************************************************;

data iaist1; set dat.datind; overall=1;run;
proc freq data=iaist1; tables coc_r;run;

* Multicollinearity checking *;
proc reg data = tab2;
	model readm_30 = ptgrp fac_region sex ethnicity race payer agegrp ptstat death vpn tia pvd 
	mpn inf htn hld dm dep cvd copd chf cad bpn anx stroke weekday weekend distime edhrarr admtime 
	cond admsrc adm_prior diag exinju condpr condprs sevr pecmorb caislos visit_30 coc_r tx1
	aistchg aislos age incAmed ndiag nproc phy/ vif tol collin;
	ods pdf file= "/Users/macuser/Desktop/aisproject/dat/table7.pdf" style=vasstables;
run;

* Multicollinearity checking *;
proc reg data = tab2;
	model death_180 = ptgrp fac_region sex ethnicity race payer agegrp ptstat death vpn tia pvd 
	mpn inf htn hld dm dep cvd copd chf cad bpn anx stroke weekday weekend distime edhrarr admtime 
	cond admsrc adm_prior diag exinju condpr condprs sevr pecmorb caislos visit_30 readm_30 coc_r
	tx1 aistchg aislos age incAmed ndiag nproc phy/ vif tol collin;
	ods pdf file= "/Users/macuser/Desktop/aisproject/dat/table8.pdf" style=vasstables;
run;

* Multicollinearity checking *;
proc reg data = tab2;
	model aislos = ptgrp fac_region sex ethnicity race payer agegrp ptstat death vpn tia pvd 
	mpn inf htn hld dm dep cvd copd chf cad bpn anx stroke weekday weekend distime edhrarr admtime 
	cond admsrc adm_prior diag exinju condpr condprs sevr pecmorb death_180 readm_30 visit_30 coc_r
	tx1 aistchg age incAmed ndiag nproc phy/ vif tol collin;
	ods pdf file= "/Users/macuser/Desktop/aisproject/dat/table9.pdf" style=vasstables;
run;

* Multicollinearity checking *;
proc reg data = tab2;
	model aistchg = ptgrp fac_region sex ethnicity race payer agegrp ptstat death vpn tia pvd 
	mpn inf htn hld dm dep cvd copd chf cad bpn anx stroke weekday weekend distime edhrarr admtime 
	cond admsrc adm_prior diag exinju condpr condprs sevr pecmorb death_180 readm_30 visit_30 coc_r
	tx1 aislos age incAmed ndiag nproc phy/ vif tol collin;
	ods pdf file= "/Users/macuser/Desktop/aisproject/dat/table10.pdf" style=vasstables;
run;

*****************************************************************************
***************************  Explanatory Analysis    ************************
*****************************************************************************

* Explanatory *;
title 'Stepwise Regression on AIS Readmission Data';
proc logistic data=tab2 outest=betas covout;
class ptgrp(ref=4) ;
   model readm_30(event='1')=ptgrp fac_region sex ethnicity race payer agegrp ptstat vpn tia pvd 
	mpn inf htn hld dm dep cvd copd chf cad bpn anx stroke weekday weekend distime edhrarr admtime 
	cond admsrc adm_prior diag exinju condpr condprs sevr pecmorb caislos visit_30 coc_r tx1 aistchg 
	aislos age incAmed ndiag nproc phy
                / selection=stepwise
                  slentry=0.3
                  slstay=0.35
                  details
                  lackfit;
   output out=pred p=phat lower=lcl upper=ucl
          predprob=(individual crossvalidate);
   ods output Association=Association;
   ods pdf file= "/Users/macuser/Desktop/aisproject/dat/table11.pdf" style=vasstables;
run;


* Explanatory death_180*;
title 'Stepwise Regression on AIS Death Data';
proc logistic data=tab2 outest=betas covout;
class ptgrp(ref=4) ;
   model death_180(event='1')=ptgrp fac_region sex ethnicity race payer agegrp ptstat vpn tia pvd 
	mpn inf htn hld dm dep cvd copd chf cad bpn anx stroke weekday weekend distime edhrarr admtime 
	cond admsrc adm_prior diag exinju condpr condprs sevr pecmorb caislos visit_30 readm_30 coc_r tx1
	aistchg aislos age incAmed ndiag nproc phy
                / selection=stepwise
                  slentry=0.3
                  slstay=0.35
                  details
                  lackfit;
   output out=pred p=phat lower=lcl upper=ucl
          predprob=(individual crossvalidate);
   ods output Association=Association;
   ods pdf file= "/Users/macuser/Desktop/aisproject/dat/table12.pdf" style=vasstables;
run;

* Explanatory caislos*;
title 'Stepwise Regression on AIS Length of Stay Categorical Data';
proc logistic data=tab2 outest=betas covout;
class caislos(ref=1) ptgrp(ref=4) ;
   model caislos=ptgrp fac_region sex ethnicity race payer agegrp ptstat death vpn tia pvd 
	mpn inf htn hld dm dep cvd copd chf cad bpn anx stroke weekday weekend distime edhrarr admtime 
	cond admsrc adm_prior diag exinju condpr condprs sevr pecmorb death_180 readm_30 visit_30 coc_r tx1
	aistchg age incAmed ndiag nproc phy
                / selection=stepwise
                  slentry=0.3
                  slstay=0.35
                  details
                  lackfit;
   output out=pred p=phat lower=lcl upper=ucl
          predprob=(individual crossvalidate);
   ods output Association=Association;
   ods pdf file= "/Users/macuser/Desktop/aisproject/dat/table13.pdf" style=vasstables;
run;

* losdays explanatory variables*;
title 'Stepwise Regression on AIS Length of Stay Data';
proc genmod data=tab2;
	class ptgrp/param=ref ;
	model aislos=ptgrp fac_region sex ethnicity race payer agegrp ptstat death vpn tia pvd 
	mpn inf htn hld dm dep cvd copd chf cad bpn anx stroke weekday weekend distime edhrarr admtime 
	cond admsrc adm_prior diag exinju condpr condprs sevr pecmorb death_180 readm_30 visit_30 coc_r tx1
	aistchg age incAmed ndiag nproc phy
	/ dist = tweedie link=log;
   output out=pred p=phat lower=lcl upper=ucl;
   ods output ParameterEstimates=dat.gmparms1;     
   ods pdf file= "/Users/macuser/Desktop/aisproject/dat/table14.pdf" style=vasstables;
run;

 * tchgs explanatory variables*;
title 'Stepwise Regression on AIS Total Charges Data';
proc genmod data=tab2;
	class ptgrp/param=ref ;
	model aistchg=ptgrp fac_region sex ethnicity race payer agegrp ptstat death vpn tia pvd 
	mpn inf htn hld dm dep cvd copd chf cad bpn anx stroke weekday weekend distime edhrarr admtime 
	cond admsrc adm_prior diag exinju condpr condprs sevr pecmorb death_180 readm_30 visit_30 coc_r tx1
	aislos age incAmed ndiag nproc phy
	/ dist = tweedie link=log;
   output out=pred p=phat lower=lcl upper=ucl;
   ods output ParameterEstimates=dat.gmparms;     
   ods pdf file= "/Users/macuser/Desktop/aisproject/dat/table15.pdf" style=vasstables;
run;
