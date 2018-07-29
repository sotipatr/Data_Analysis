proc print data= statdata.bodyfat2;
run;
proc fastclus data=statdata.bodyfat2  radius=2  out=clust;
   var age;	;
   
run;
proc sort data=clust;
by cluster;
proc print;
by cluster;
