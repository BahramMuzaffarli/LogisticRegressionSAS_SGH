libname b "\\Vboxsvr\u\zajecia\LogisticRegression\summer_2020\data";

*Copy to work library;
data b01;
 set b.bank;
run;

*Data processing;
data b02;
 set b01;
 if ^missing(y) then do;
	 if y='yes' then NewDeposit=1;
	 else if y='no' then NewDeposit=0;
 end;
run;

*Cross table check;
proc freq data=b02 noprint;
 tables NewDeposit*y / out=f01;
 tables Poutcome / out=f02;
run;

*Model estimation;
ods graphics on;
proc logistic data=b02 alpha=0.05 plots(only)=(effect oddsratio);
	class Poutcome (param=ref ref='failure');
	model NewDeposit(event='1')= Age Poutcome / clodds=pl;
	units age=5; *OR for change by given unit;
	output out=p predicted=p; *Predictions;
run;
