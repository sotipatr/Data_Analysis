/*Import arxeiou Campaign1 */
/*Observations=1700, Variables=18*/

data CAMP.campaign1 ;  
infile "&path/Campaign1.csv" dlm=';' dsd firstobs=2;
input id_ targetD:dollar10.2 GiftCnt36 GiftCntAll GiftCntCard36 GiftCntCardAll GiftAvgLast:dollar10.2 GiftAvg36:dollar10.2 GiftAvgAll:dollar10.2 GiftAvgCard36:dollar10.2 GiftTimeLast GiftTimeFirst  PromCnt12 PromCnt36 PromCntAll PromCntCard12 PromCntCard36 PromCntCardAll;
run;

proc print data=CAMP.campaign1;
run;

proc contents data=CAMP.campaign1;
run;

/*Import arxeiou Campaign2 */
/*Observations=1700, Variables=11*/
data CAMP.campaign2 ;  
infile "&path/Campaign2.csv" dlm=';' dsd firstobs=2;
input id_ StatusCat96NK $ StatusCatStarAll DemCluster DemAge DeMGender $ DemHomeOwner $ DemIncomeGroup DemMedHomeValue:dollar10.2 DemPctVeterans TargetB;
run;

proc print data=CAMP.campaign2;
run;

proc contents data=CAMP.campaign2;
run;

/*Sorting */
proc sort data=CAMP.campaign1
out=CAMP.campaign1_sorted;
by id_;
run;

proc print data=CAMP.campaign1_sorted;
run;

proc sort data=CAMP.campaign2
out=CAMP.campaign2_sorted;
by id_;
run;

proc print data=CAMP.campaign2_sorted;
run; 


/*Merging*/
data CAMP.campaign12 ;
merge CAMP.campaign1_sorted (in=a) CAMP.campaign2_sorted (in=b) ;
by id_;
if a=1 and b=1;
run;

proc print data=CAMP.campaign12;
run;

proc contents data=CAMP.campaign12;
run;

proc freq data=CAMP.campaign12;
tables _NUMERIC_ /missing;
tables _CHAR_ /missing;
run;

/*Cleaning the dataset*/
data CAMP.cleaned(drop= DemPctVeterans DemAge TargetB);
set CAMP.campaign12;

if DeMGender = 'Manan' then DeMGender = 'M';
if DeMGender = 'Man' then DeMGender = 'M';
if DemHomeOwner = 'Home' then  DemHomeOwner = 'H';
if DemHomeOwner = 'NoHome' then  DemHomeOwner = 'NH';
if DeMGender = 'Woman' then DeMGender = 'F';
if DeMGender = 'U' then delete;
if GiftAvgCard36 = '.' then delete;
if DemIncomeGroup = '.' then delete;
if TargetB = '0'  then delete;
if DemMedHomeValue = '0' then delete;
if GiftAvgLast = '0' then delete;
if PromCntCard12 = '0' then delete;
if GiftCnt36 = '0'  then delete;
if GiftCntCard36 = '0' then delete;
if GiftCntCardAll = '0' then delete;
if GiftAvg36 = '0' then delete;

run;

proc print data=CAMP.cleaned;
run;

proc contents data=CAMP.cleaned;
run;

proc freq data=CAMP.cleaned;
/*tables _NUMERIC_ /missing;
tables _CHAR_ /missing;*/
table DemCluster/plots=freqplot;
table DemIncomeGroup/plots=freqplot;
table DemMedHomeValue/plots=freqplot;
table GiftAvg36/plots=freqplot;
table GiftAvgAll/plots=freqplot;
table GiftAvgCard36/plots=freqplot;
table GiftAvgLast/plots=freqplot;
table GiftCnt36/plots=freqplot;
table GiftCntAll/plots=freqplot;
table GiftCntCard36/plots=freqplot;
table GiftCntCardAll/plots=freqplot;
table GiftTimeFirst/plots=freqplot;
table GiftTimeLast/plots=freqplot;
table PromCnt12/plots=freqplot;
table PromCnt36/plots=freqplot;
table PromCntAll/plots=freqplot;
table PromCntCard12/plots=freqplot;
table PromCntCard36/plots=freqplot;
table PromCntCardAll/plots=freqplot;
run;

/*Sorting */
proc sort data=CAMP.cleaned
out=CAMP.cleaned_sorted;
by DemHomeOwner;
run;

proc print data=CAMP.cleaned_sorted;
run;


/*sampling*/
title1 'Marketing campaign sampling (70% of population)';
title2 'Proportional Allocation';
proc surveyselect data=CAMP.cleaned_sorted
      n=559 out=CAMP.sample;
   strata  DemHomeOwner / alloc=prop;
run;

proc print data=CAMP.sample;
run;

proc corr data=CAMP.sample;
var DemCluster DemIncomeGroup DemMedHomeValue GiftAvg36 GiftAvgAll GiftAvgCard36 GiftAvgLast
 	GiftCnt36 	GiftCntAll 	GiftCntCard36 	GiftCntCardAll 	GiftTimeFirst 	GiftTimeLast
 	PromCnt12 	PromCnt36 	PromCntAll 	PromCntCard12 	PromCntCard36 	PromCntCardAll;
	with targetD;
run;

proc reg data=CAMP.sample
outest=CAMP.estimates;

model targetD=GiftAvg36 GiftAvgAll GiftAvgCard36 GiftAvgLast
 GiftCnt36 	GiftCntAll GiftCntCard36/clm cli;
	
title "Regression of % targetD on sample";
run;

proc contents data=CAMP.estimates;
run;

/*clustering*/
proc fastclus data=CAMP.cleaned out=CAMP.Clust
              maxclusters=7 maxiter=100;
   var GiftAvg36 GiftAvgAll GiftAvgCard36 GiftAvgLast GiftCnt36 GiftCntAll 
		GiftCntCard36;
run;

proc sort data=CAMP.Clust;
by cluster;
run;
proc print;
by cluster;
run;

proc corr data=CAMP.Clust; 
by cluster;
var DemCluster DemIncomeGroup DemMedHomeValue GiftAvg36 GiftAvgAll GiftAvgCard36 GiftAvgLast
 GiftCnt36 	GiftCntAll 	GiftCntCard36 	GiftCntCardAll 	GiftTimeFirst 	GiftTimeLast
 	PromCnt12 	PromCnt36 	PromCntAll 	PromCntCard12 	PromCntCard36 	PromCntCardAll;
	with targetD;
run;

proc reg data=CAMP.Clust
outest=CAMP.estimates2;
by cluster;
model targetD=GiftAvg36 GiftAvgAll GiftAvgCard36 GiftAvgLast /clm cli;
	title "Regression of % targetD in clusters";
run;

proc contents data=CAMP.estimates2;
run;
/*anagwgh tou parapanw montelou sto .sample*/

proc reg data=CAMP.sample
outest=CAMP.estimates3;
model targetD=GiftAvg36 GiftAvgAll GiftAvgCard36 GiftAvgLast /clm cli;
	title "Regression of % targetD on sample by model of cluster 7";
run;

/*Import arxeiou New_Campaign */
/*Observations=50, Variables=18*/

data CAMP.New_Campaign ;  
infile "&path/New_Campaign.csv" dlm=';' dsd firstobs=2;
input targetB id_ targetD:dollar10.2 GiftCnt36 GiftCntAll GiftCntCard36
 	GiftCntCardAll GiftAvgLast:dollar10.2 GiftAvg36:dollar10.2 
	GiftAvgAll:dollar10.2 GiftAvgCard36:dollar10.2 GiftTimeLast 
	GiftTimeFirst PromCnt12 PromCnt36 PromCntAll PromCntCard12 
	PromCntCard36 PromCntCardAll StatusCat96NK $ StatusCatStarAll
 	DemCluster DemAge DeMGender $ DemHomeOwner $ DemIncomeGroup 
	DemMedHomeValue:dollar10.2 DemPctVeterans;
	title "Import dataset New_Campaign";
run;

proc print data=CAMP.New_Campaign;
run;

proc contents data=CAMP.New_Campaign;
run;

/*telikh problepsh posou*/

proc score data=CAMP.New_Campaign score=CAMP.estimates out=CAMP.scored 
	type=parms;
	var GiftAvg36 GiftAvgAll GiftAvgCard36 GiftAvgLast
 		GiftCnt36 	GiftCntAll GiftCntCard36;
	title "Problepsh telikou posou";
run;

proc print data=CAMP.estimates;
run;

data CAMP.scored1;
set CAMP.scored;
if MODEL1 = '.' then delete;
run;

proc print data=CAMP.scored1;
var id_ MODEL1;
sum MODEL1; 
run;
