proc import file="/home/5dsasdemo03/BahramMuzaffarli/ESS10.csv" out=df dbms=csv;
run;

data e02;
    set df;
    
    * Response: DR - democracy rate;
    if not missing(stfdem) and stfdem < 11 then do;
        if 0 <= stfdem <= 5 then DR = 1;
        else if 6 <= stfdem <= 7 then DR = 2;
        else if 8 <= stfdem <= 10 then DR = 3;
    end;
    else DR = .;

    * Response: fairelc - FE Fair of election;
    if not missing(fairelc) and fairelc < 11 then do;
        if 0 <= fairelc <= 5 then FE = 1;
        else if 6 <= fairelc <= 7 then FE = 2;
        else if 8 <= fairelc <= 10 then FE = 3;
    end;
    else FE = .;

    * Response: medcrgv - FreeMedia FM;
    if not missing(medcrgv) and medcrgv < 5 then do;
        if 0 <= medcrgv <= 1 then freemedia = 1;
        else if 2 <= medcrgv <= 3 then freemedia = 2;
        else if medcrgv = 4 then freemedia = 3;
    end;
    else freemedia = .;

    * Response: dfprtal - Democracy participation;
    if not missing(dfprtal) and dfprtal < 5 then do;
        if 0 <= dfprtal <= 1 then participation = 1;
        else if 2 <= dfprtal <= 3 then participation = 2;
        else if dfprtal = 4 then participation = 3;
    end;
    else participation = .;

    * Response: votedir - Citizen say final words in election;
    if not missing(votedir) and votedir < 11 then do;
        if 0 <= votedir <= 4 then votedir = 1;
        else if 5 <= votedir <= 8 then votedir = 2;
        else if 7 <= votedir <= 10 then votedir = 3;
    end;
    else votedir = .;

    * Response: gptpelc - Government Punished Parties;
    if not missing(gptpelc) and gptpelc < 11 then do;
        if 0 <= gptpelc <= 4 then punish = 1;
        else if 5 <= gptpelc <= 8 then punish = 2;
        else if 7 <= gptpelc <= 10 then punish = 3;
    end;
    else punish = .;

    * Response: wpestop - People with extreme opinions should have a say;
    if not missing(wpestop) and wpestop < 5 then do;
        if 0 <= wpestop <= 1 then extreme_opinions = 1;
        else if 2 <= wpestop <= 3 then extreme_opinions = 2;
        else if wpestop = 4 then extreme_opinions = 3;
    end;
    else extreme_opinions = .;

    * Response: viepol - Value of political rights;
    if not missing(viepol) and viepol < 11 then do;
        if 0 <= viepol <= 4 then political_rights = 1;
        else if 5 <= viepol <= 8 then political_rights = 2;
        else if 7 <= viepol <= 10 then political_rights = 3;
    end;
    else political_rights = .;

    * Response: gndr - Gender;
    if not missing(gndr) and gndr < 9 then do;
        if gndr = 1 then gender = 'Male';
        else if gndr = 2 then gender = 'Female';
        else gender = '';
    end;
    else gender = '';

    * Response: contplt - Contributed to political activities;
    if not missing(contplt) and contplt < 9 then do;
        if contplt = 1 then contributed = 'Yes';
        else if contplt = 2 then contributed = 'No';
        else contributed = '';
    end;
    else contributed = '';

run;

* Final filtering for country;
data e03;
    set e02;
    where cntry='CZ';
run;

*Check the distribution of the response variable;
proc freq data=df;
 tables stfdem / out=f01;
run;
proc sgplot data=df;
 vbar stfdem;
run;

*After Change target variable's distribution;
proc freq data=e03;
 tables DR / out=f01;
run;
proc sgplot data=e03;
 vbar DR;
run;

%Macro discperf(Var=,whr=);
proc freq data=e03;
	tables DR*&Var.;
	ods output CrossTabFreqs=pct01;
	weight anweight;
	where cntry='CZ'
	%if %length(&whr.)>0 %then %do;
	 and &whr.
	%end;
	;
run;
proc sgplot data=pct01(where=(^missing(RowPercent)));
	vbar DR / group=&Var. groupdisplay=cluster response=RowPercent datalabel;
	format DR DRFMT.;
run;
%Mend DiscPerf;
%DiscPerf(Var=FE);
%DiscPerf(Var=contributed);
%DiscPerf(Var=Gender);
%DiscPerf(Var=punish);

*Response variable distribution and check on proportions;
proc freq data=e03;
	tables DR;
	tables DR*FE / nopercent norow;
run;

*Odds ratios for Fair Election;
proc freq data=e03;
	tables DR;
	tables DR*FE / nopercent norow relrisk;
	where DR^=1;
run;
proc freq data=e03;
	tables DR;
	tables DR*FE / nopercent norow relrisk;
	where DR^=3;
run;

proc logistic data=e03 outest=cov plots(only)=(oddsratio effect(x=punish))/*(3)*/;
		class FE / param=glm;
	model DR (ref='3') = FE punish  / expb link=glogit expb /*Diagnostics*/lackfit;
	output out=o01 p=p predprobs=i;
	lsmeans FE / ilink cl e diff;
	lsmestimate FE '1 vs 2 overall' 1 -1 / category=joint;
	*lsmestimate FE '1 vs 2 overall' 1 -1 / category=joint;
run;
