/*** HELP START ***//*

MACRO NAME   : shutter_chance
 Description  : This macro generates a visual checkpoint output for selected records 
                (based on _N_　or conditional expression) using ODS layout and table constructs. It is useful for 
                data review or debugging by presenting variable values in a clear format.
 Parameters      :
   CheckID  = Optional identifier for the output block. If not specified, &sysindex is used.
   n        = Record numbers (_N_) to trigger output generation (e.g., 1:3 or 2 4 6). Default is 1.
   if_condition  = Logical expression evaluated per observation (e.g., SEX='F' and AGE=15). 
                   Cannot be used together with n.
   varlist  = List of variable names to be displayed (space-delimited). This is required.

 OUTPUT        :
   When either _N_ matches the values in `n` **or** the `if_condition` evaluates to true,
   the macro produces an ODS layout showing the CheckID, current _N_, and values of the 
   specified variables. Requires ODS output environment (e.g., HTML or RTF) to be active.


 USAGE EXAMPLE:
   data wk1;
     set sashelp.class;
     %shutter_chance(CheckID=A, n=1:3, varlist=Name Weight Height BMI);
     BMI = Weight / HEIGHT**2 * 703;
     %shutter_chance(CheckID=B, n=1:3, varlist=Name Weight Height BMI);
     %shutter_chance(CheckID=C, if_condition=%nrbquote(SEX = "F" and AGE=15), varlist=Name Weight Height BMI);
   run;

 NOTES        : 
   - This macro internally creates an ODSOUT instance. Ensure ODS output is enabled.
   - Variable names must be valid and exist in the dataset at the time of macro invocation.
   - Avoid instance name conflicts if other ODS macros/templates are used.

 Author          : Yutaka Morioka
License : MIT

*//*** HELP END ***/

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
