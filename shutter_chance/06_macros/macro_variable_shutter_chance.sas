/*** HELP START ***//*

Program Name    : %macro_variable_shutter_chance
 Description     : 
     This macro displays the current macro variables grouped by their scope
     (GLOBAL, LOCAL, AUTOMATIC) in a formatted SAS RWI(report Writing Interface) ods layout.
     It is primarily intended for debugging or reporting the macro environment
     during runtime. Output layout varies depending on the presence of automatic
     variables as specified by the parameter.

 Parameters      :
     CheckID        = [optional] Identifier string used to distinguish the ODS output 
                            for each macro call. If not provided, defaults to &SYSINDEX.

     automatic_fl   = [optional] Flag to include AUTOMATIC scope variables. 
                      Accepts 'Y' or 'N'. Default is 'N'.

 Features        :
     - Uses SASHELP.VMACRO to retrieve macro variables by scope
     - Hash objects and iterators used for efficient processing
     - Outputs results using the ODS OUT interface
     - Supports multiple executions with unique output regions

 Usage Example   :
     %let mvar1=A;
     %let mvar2=B;
     %macro_variable_shutter_chance(CheckID=A);

     %macro test;
         %global mvar2;
         %let mvar1=D;
         %let mvar2=E;
         %let mvar4=F;
         %do i = 1 %to 2;
             %put &i;
             %macro_variable_shutter_chance(CheckID=B);
             %if &i=1 %then %do;
                 data _null_;
                     call symputx("mvar3","G","L");
                 run;
             %end;
         %end;
     %mend;
     %test;

 Notes and Caveats:
     - This macro intentionally masks its own local macro variables from being 
       reported in the LOCAL scope output. This prevents internal implementation 
       details from appearing in the diagnostics.
        scope ne "MACRO_VARIABLE_SHUTTER_CHANCE"
        In other words, scope ne "MACRO_VARIABLE_SHUTTER_CHANCE2 is included in the extraction.  

     - Some AUTOMATIC macro variables may reflect values that were populated or 
       modified as a result of this macro�fs own execution (e.g., SYSLAST, SYSERR,  
       SYSINDEX, etc.). Their presence or contents should be interpreted accordingly. 

Author:Morioka Yutaka
License :MIT

*//*** HELP END ***/

%macro macro_variable_shutter_chance(CheckID =, automatic_fl =N);
%if %length(&CheckID) eq 0 %then %let CheckID = &sysindex;

data _null_;
if 0 then do;
  set sashelp.vmacro(where=(scope = "GLOBAL") keep=scope name value rename=(name=name1 value=value1));
  set sashelp.vmacro(where=(scope = "LOCAL") keep=scope name value rename=(name=name2 value=value2));
  set sashelp.vmacro(where=(scope = "AUTOMATIC") keep=scope name value rename=(name=name3 value=value3));
end;

declare hash h1(dataset:'sashelp.vmacro(where=(scope = "GLOBAL") keep=scope name value rename=(name=name1 value=value1))');
h1.definekey("name1");
h1.definedata("name1","value1");
h1.definedone();
declare hiter hi1('h1');

declare hash h2(dataset:'sashelp.vmacro(where=(scope ne "GLOBAL" and scope ne "AUTOMATIC" and scope ne "MACRO_VARIABLE_SHUTTER_CHANCE") keep=scope name value rename=(name=name2 value=value2))');
h2.definekey("name2");
h2.definedata("name2","value2","scope");
h2.definedone();
declare hiter hi2('h2');

declare hash h3(dataset:'sashelp.vmacro(where=(scope = "AUTOMATIC") keep=scope name value rename=(name=name3 value=value3))');
h3.definekey("name3");
h3.definedata("name3","value3");
h3.definedone();
declare hiter hi3('h3');

num1=h1.num_items;
num2=h2.num_items;
num3=h3.num_items;

dcl  odsout ob&sysindex.();
%if %upcase(&automatic_fl) = Y %then %do;
  ob&sysindex..layout_gridded(columns: 3,column_gutter: '2mm');
%end;
%else %do;
  ob&sysindex..layout_gridded(columns: 2,column_gutter: '2mm');
%end;
ob&sysindex..region(width:'5cm');
ob&sysindex..table_start();
ob&sysindex..head_start();
 ob&sysindex..row_start();
      ob&sysindex..format_cell( column_span: 2 ,data: "Global Scope",  style_attr: "background=Aqua color=black");
 ob&sysindex..row_end();
 ob&sysindex..row_start();
      ob&sysindex..format_cell( column_span: 2 ,data: "CheckID:&CheckID",  style_attr: "background=Aqua color=black");
 ob&sysindex..row_end();
 ob&sysindex..head_end();
ob&sysindex..head_start();
 ob&sysindex..row_start();
      ob&sysindex..format_cell(data: "Macro variable",  style_attr: "background=Aqua color=black");
      ob&sysindex..format_cell(data: "Value",  style_attr: "background=Aqua color=black");
 ob&sysindex..row_end();
 ob&sysindex..head_end();
if 0 < num1 then do;
  rc=hi1.first();
  do until(num1=0);
    ob&sysindex..row_start();
    ob&sysindex..format_cell(data: name1,  style_attr: "background=white color=black");
    ob&sysindex..format_cell(data: value1,  style_attr: "background=white color=black");
    ob&sysindex..row_end();
    if 0 <num1 then rc=hi1.next();
    num1 =num1 -1;
  end;
end;
ob&sysindex..table_end();

ob&sysindex..region(width:'5cm');
ob&sysindex..table_start();
ob&sysindex..head_start();
 ob&sysindex..row_start();
      ob&sysindex..format_cell( column_span: 3 ,data: "Local Scope",  style_attr: "background=PaleGreen color=black");
 ob&sysindex..row_end();
 ob&sysindex..row_start();
      ob&sysindex..format_cell( column_span: 3 ,data: "CheckID:&CheckID",  style_attr: "background=PaleGreen color=black");
 ob&sysindex..row_end();
 ob&sysindex..head_end();
ob&sysindex..head_start();
 ob&sysindex..row_start();
      ob&sysindex..format_cell(data: "Macro",  style_attr: "background=PaleGreen color=black");
      ob&sysindex..format_cell(data: "Macro variable",  style_attr: "background=PaleGreen color=black");
      ob&sysindex..format_cell(data: "Value",  style_attr: "background=PaleGreen color=black");
 ob&sysindex..row_end();
 ob&sysindex..head_end();
if 0 < num2 then do;
  rc=hi2.first();
  do until(num2=0);
    ob&sysindex..row_start();
    ob&sysindex..format_cell(data: scope,  style_attr: "background=white color=black");
    ob&sysindex..format_cell(data: name2,  style_attr: "background=white color=black");
    ob&sysindex..format_cell(data: value2,  style_attr: "background=white color=black");
    ob&sysindex..row_end();
    if 0 <num2 then rc=hi2.next();
    num2 =num2 -1;
  end;
end;
ob&sysindex..table_end();

%if %upcase(&automatic_fl) = Y %then %do;
ob&sysindex..region(width:'5cm');
ob&sysindex..table_start();
ob&sysindex..head_start();
 ob&sysindex..row_start();
      ob&sysindex..format_cell( column_span: 2 ,data: "Automatic Global",  style_attr: "background=LightYellow color=black");
 ob&sysindex..row_end();
 ob&sysindex..row_start();
      ob&sysindex..format_cell( column_span: 2 ,data: "CheckID:&CheckID",  style_attr: "background=LightYellow color=black");
 ob&sysindex..row_end();

 ob&sysindex..head_end();
ob&sysindex..head_start();
 ob&sysindex..row_start();
      ob&sysindex..format_cell(data: "Macro variable",  style_attr: "background=LightYellow color=black");
      ob&sysindex..format_cell(data: "Value",  style_attr: "background=LightYellow color=black");
 ob&sysindex..row_end();
 ob&sysindex..head_end();if 0 < num3 then do;
  rc=hi3.first();
  do until(num3=0);
    ob&sysindex..row_start();
    ob&sysindex..format_cell(data: name3,  style_attr: "background=white color=black");
    ob&sysindex..format_cell(data: value3,  style_attr: "background=white color=black");
    ob&sysindex..row_end();
    if 0 <num3 then rc=hi3.next();
    num3 =num3 -1;
  end;
end;
ob&sysindex..table_end();
%end;

ob&sysindex..layout_end();


stop;
run;

%mend;

