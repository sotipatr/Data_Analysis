title 'Cluster Analysis of Flying Mileages Between 10 American Cities';
ods graphics on;

title1 'Using METHOD=AVERAGE';
proc cluster data=sashelp.mileages(type=distance) method=average pseudo outtree=tree;
   id City;
run;
proc tree data=tree  ;

title2 'Using METHOD=CENTROID';
proc cluster data=sashelp.mileages(type=distance) method=centroid pseudo outtree=tree1;
   id City;
run;
proc tree data=tree1;

title3 'Using METHOD=SINGLE';
proc cluster data=sashelp.mileages(type=distance) method=single outtree=tree2;
   id City;
run;
proc tree data=tree2;

