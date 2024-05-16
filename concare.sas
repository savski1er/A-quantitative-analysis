	Continuity of Care Macro(/home/dfriesn/maclib/_concare.sas)
				Version 1.02
				David Friesen
			Manitoba Centre for Health Policy & Evaluation

				June 16, 1999

This macro is used to calculate measures of continuity of care on
physician visit data or other sources.  

This macro requires the SAS IMPLMAC option.

Usage:

_concare <options>;

Options:
	data = 	Input dataset name 

	output =Output dataset name [required]

	year = Year of Analysis [required] 91-97 Needed to identify unique
physicians using Bogdans format /home/bogdan/fmtlib/mdfmt&year which
converts fake mdno to unique physician number, for physicians who bill
under more than one md number. 

	provider = Definition of provider: refgrp[default],grp,ref,mdonly
refgrp - physicians, referring physicians, or practices [default]
grp    - physicians or practices
ref    - physicians or referring physicians 
mdnonly - physicians only

	md = name of md number variable(faked), default is md 

	id = patient id number, default is phindata 

	refmd = name of referring md number variable(faked), default is
refmd [required for provider=ref, refgrp]

	grp = name of group practice variable, default is bpgroup
[required for provider=refgrp, grp]

	nserv = number of services variable, default is nservnet 

	dateserv = date of service/visit variable, default is ndtserv

	debug = turn on mprint and notes: debug, nodebug[default]


Output:

A SAS dataset with the name specified in the 'output' option, one
observation for every patient (id) with the following variables: 


<id> - Patient ID number

VISITS - Total Ambulatory visits made by patient

CLAIMS - Total Ambulatory Claims for the patient

PROVIDU - Usual Provider, most frequently seen provider unique physician
number.  Physician practices start with 'GR' and end with two digit
practice number. 

PROVIDN	- Number of Providers seen

UPC_R - Usual Provider Continuity, is the proportion of visits made to the
most frequently seen provider. 

SCC_R - usual provider continuity standardized to a mean of 0 and variance 1.

COC_R - is sensitive to changes in the total number of visits and in their
distribution across different providers.  It ranges from 0 to 1, where 0
occurs when each visit is to a different provider and 1 occurs when all
visits are to one provider.  Needs at least two visits to calculate. 

SECON_R - measure SEquential nature of provider CONtinuity, is the
fraction of sequential visit pairs at which the same provider is seen. 
Like COC_R it also ranges from 0 to 1, but in contrast is dependent on the
sequential order of visits.  A patient who alternates between two
providers will have a score of 0.  Needs at least two visits to calculate. 

Examples:

%inc '/home/dfriesn/maclib/_concare.sas';

options implmac;

data test;  
set phis.phy9596(obs=100000 keep=phindata ndtserv md bpgroup
refmd nservnet ambvis);  
if (ov='1' or pv='1') and phy_spec='1';
*AMBULATORY NON-CONSULT VISITS TO GPS;  
run; 

_concare data=test year=95 output=contcare provider=mdonly debug=debug;
