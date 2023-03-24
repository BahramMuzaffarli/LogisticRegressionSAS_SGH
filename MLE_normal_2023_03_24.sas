data a01;
input y;
cards;
-2.5
-2
-1
;
run;

proc univariate data=a01;
 var y;
 histogram y / normal;
run;