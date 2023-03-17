libname b '/home/4dsasdemo01/ak/logreg';

data a01;
 set b.bank;
run;

*Is logistic regession assumptionless?

ods graphics on;
proc logistic data=a01 plots=(effect);
 model y(event='yes') = age ;
 output out=a02 p=p;
run;

proc sgplot data=a02;
 scatter x=age y=p;
run;

proc freq data=a02 noprint;
 tables age*p / out=f03;
run;

*Target depends on the age;
data a03;
 set a02;
 y2 = ranbin(age,1,age/100);
run;

proc logistic data=a03;
 model y2(event='1') = age;
 output out=a04 p=p2;
run;
proc sgplot data=a04;
 scatter x=age y=p;
 scatter x=age y=p2;
run;

proc freq data=a04 noprint;
 tables age*p2 / out=f04;
run;

data d01;
 do x=-500 to 1000;
  Px=1/(1+exp(-1*(-2.0316	+0.0401*x)));
  output;
 end;
run;

proc sql;
 create table d02 as select
  a.*
  ,b.p2
 from d01 a 
  left join f04 b on (a.x=b.age);
quit;

proc sgplot data=d02;
    series x=x y=Px / lineattrs=(color=red);
    scatter x=x y=p2 / markerattrs=(symbol=circle color=red);
    refline 18 90 / axis=x;
    refline 0.2 0.82 / axis=y;
run;








data d01;
 do x=-500 to 1000;
  Px=1/(1+exp(-1*(-2.5769	+0.0129*x)));
  output;
 end;
run;

proc sql;
 create table d02 as select
  a.*
  ,b.p
 from d01 a 
  left join f03 b on (a.x=b.age);
quit;

proc sgplot data=d02;
    series x=x y=Px / lineattrs=(color=red);
    scatter x=x y=p / markerattrs=(symbol=circle color=red);
    refline 18 90 / axis=x;
    refline 0.08 0.2 / axis=y;
run;


***;
*1;
data c01;
 set a01;
 if age<30 then agec=1;
 else if 30<=age<35 then agec=3;
 else if 35<=age<40 then agec=4;
 else if 40<=age<45 then agec=5;
 else if 45<=age<50 then agec=6;
 else if 50<=age<55 then agec=7;
 else if 55<=age<60 then agec=8;
 else if age>=60 then agec=9;
run;

proc freq data=c01 noprint;
 tables agec*y / out=f02 (drop=percent);
run;

proc sql;
 create table f02b(where=(y='yes')) as select
  *
  ,sum(count) as sumbin
  ,count/calculated sumbin as pct
 from f02 group by agec;
quit;

proc sgplot data=f02b;
 vbar agec / response=pct datalabel=count;
run;

*2;
data c01;
 set a03;
 if age<30 then agec=1;
 else if 30<=age<35 then agec=3;
 else if 35<=age<40 then agec=4;
 else if 40<=age<45 then agec=5;
 else if 45<=age<50 then agec=6;
 else if 50<=age<55 then agec=7;
 else if 55<=age<60 then agec=8;
 else if age>=60 then agec=9;
run;

proc freq data=c01 noprint;
 tables agec*y2 / out=f02 (drop=percent);
run;

proc sql;
 create table f02b(where=(y2=1)) as select
  *
  ,sum(count) as sumbin
  ,count/calculated sumbin as pct
 from f02 group by agec;
quit;

proc sgplot data=f02b;
 vbar agec / response=pct datalabel=count;
run;

***;

proc freq data=a01 noprint;
 tables age / out=f01;
run;


proc hpbin data=a01 output=b01; 
   input age / numbin=20; 
   id age y;
run;

proc freq data=b01 noprint;
 tables bin_age*age / out=f02;
run;

proc freq data=b01 noprint;
 tables bin_age*y / out=f03 (drop=percent);
run;


proc sql;
 create table f04(where=(y='yes')) as select
  *
  ,sum(count) as sumbin
  ,count/calculated sumbin as pct
 from f03 group by bin_age;
quit;

proc sgplot data=f04;
 vbar bin_age / response=pct datalabel=count;
run;






data d01;
 do t=-500 to 1000 by 0.01;
  Pt=1/(1+exp(-1*(-2.5769	+0.0129*t)));
  output;
 end;
run;

proc sgplot data=d01;
    series x=t y=Pt / lineattrs=(color=red);
    refline 18 90 / axis=x;
run;



