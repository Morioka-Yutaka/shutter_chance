/* jenner-check bundle: %shutter_chance, missing-value carry-forward walkthrough
   Source: shutter_chance/06_macros/shutter_chance.sas (macro definition, unmodified)
   Caller: the README's own third "Usage example" verbatim (DATALINES walkthrough
   of a RETAIN-based missing-value carry-forward, checkpointed at each of the 6 rows). */

%macro shutter_chance(CheckID =, n = ,if_condition= ,varlist=);
%if %length(&varlist) eq 0 %then %do;
    %put ERROR:varlist is Null;
    %goto eoflabel ;
%end;
%if %length(&n) ne 0 and %length(&if_condition) ne 0 %then %do;
    %put ERROR:Both n and if_condition parameters cannot be used together;
    %goto eoflabel ;
%end;
%if %length(&CheckID) eq 0 %then %let CheckID = &sysindex;
%if %length(&n) eq 0 and %length(&if_condition) eq 0  %then %let n = 1;
%let varlist=%sysfunc(compbl(&varlist));
%let n_var = %eval(%sysfunc(countw(&varlist,%str( ))) );
%if %length(&if_condition.) eq 0 %then %do;  if _N_ in ( &n)  then do;%end;
%if %length(&if_condition.) ne 0 %then %do;if %unquote(&if_condition) then do; %end;
dcl odsout ob&sysindex();
ob&sysindex..layout_gridded(columns: 2,column_gutter: '2mm');
 ob&sysindex..region();
  ob&sysindex..table_start();
   ob&sysindex..row_start();
    ob&sysindex..format_cell(data: "CheckID",  style_attr: "background=white color=black");
    %if %length(&if_condition) ne 0 %then %do;
     ob&sysindex..format_cell(data: "If Cond.",  style_attr: "background=white color=black");
    %end;
    ob&sysindex..format_cell(data: "_N_",  style_attr: "background=white color=black");
   ob&sysindex..row_end();
   ob&sysindex..row_start();
    ob&sysindex..format_cell(data:"&CheckID");
    %if %length(&if_condition) ne 0 %then %do;
     ob&sysindex..format_cell(data: "&if_condition",  style_attr: "background=white color=black");
    %end;
    ob&sysindex..format_cell(data:_N_);
    ob&sysindex..row_end();
  ob&sysindex..table_end();
ob&sysindex..region();
 ob&sysindex..table_start();
  ob&sysindex..row_start();
  %do i = 1 %to &n_var;
   %let target = %scan(&varlist,&i);
    ob&sysindex..format_cell(data: "&target",  style_attr: "background=skyblue color=black");
  %end;
  ob&sysindex..row_end();
  ob&sysindex..row_start();
  %do i = 1 %to &n_var;
   %let target = %scan(&varlist,&i);
    ob&sysindex..format_cell(data: &target);
 %end;
  ob&sysindex..row_end();
 ob&sysindex..table_end();
ob&sysindex..layout_end();
end;
%eoflabel:
%mend;

ods html file="output.html";

data DT1;
length A A2 8.;
retain A2;
input A @@;
if A^=. then A2=A;
%shutter_chance(n= 1:6, varlist=A A2);
cards;
1 . 5 . . 10
;
run;

ods html close;

proc print data=DT1;
run;
