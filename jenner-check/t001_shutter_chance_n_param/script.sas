/* jenner-check bundle: %shutter_chance, n= parameter
   Source: shutter_chance/06_macros/shutter_chance.sas (macro definition, unmodified)
   Caller: adapted from the README's own "Usage example" for the n= parameter
   (data wk1; set sashelp.class; %shutter_chance(...n=1:3...); BMI=...; %shutter_chance(...));
   sashelp.class stands in for the caller's own dataset per the README example. */

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

data wk1;
  set sashelp.class;
  %shutter_chance(CheckID=A, n=1:3, varlist=Name Weight Height BMI);
  BMI = Weight / HEIGHT**2 * 703;
  %shutter_chance(CheckID=B, n=1:3, varlist=Name Weight Height BMI);
run;

ods html close;

proc print data=wk1;
run;
