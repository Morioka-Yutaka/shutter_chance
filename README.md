# shutter_chance (v0.2.0, 04August2025)
SHUTTER_CHANCE: Visual Checkpoints for SAS Data Step Review.  
MACRO_VARIABLE_SHUTTER_CHANCE: Visually check the global and local status and values of SAS macro variables at any point.  
![shutter_chance](./shutter_chance_small.png)  

# %shutter_chance
This macro generates a visual checkpoint output for selected records (based on _N_ or conditional expression) using ODS html layout and table constructs..<br>
It is useful for  data review or debugging by presenting variable values in a clear format.

 Parameters      : <br>
 ~~~text  
   CheckID  = Optional identifier for the output block. If not specified, &sysindex is used.
   n        = Record numbers (_N_) to trigger output generation (e.g., 1:3 or 2 4 6). Default is 1.
   if_condition  = Logical expression evaluated per observation (e.g., %nrbquote(SEX='F' and AGE=15)).
                   Macro-masking of conditional expressions is required.   
                   Cannot be used together with n.   
   varlist  = List of variable names to be displayed (space-delimited). This is required.
~~~

Usage example: <br>
~~~sas 
   data wk1;
     set sashelp.class;
     %shutter_chance(CheckID=A, n=1:3, varlist=Name Weight Height BMI);
     BMI = Weight / HEIGHT**2 * 703;
     %shutter_chance(CheckID=B, n=1:3, varlist=Name Weight Height BMI);
   run;
~~~


<img width="264" height="321" alt="Image" src="https://github.com/user-attachments/assets/323df33d-f595-40f5-9688-b1de1f210de8" />




~~~sas 
   data wk2;
     set sashelp.class;
     %shutter_chance(CheckID=C, if_condition=%nrbquote(SEX='F' and AGE=15), varlist=Name Sex Age);
   run;
~~~


<img width="300" height="109" alt="Image" src="https://github.com/user-attachments/assets/014f0d03-94ce-4fa5-888d-cd9e9f9f7e21" />


~~~sas 
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
~~~

<img width="122" height="319" alt="Image" src="https://github.com/user-attachments/assets/d9ffe92c-b226-4f8b-9ff9-754656978b77" />


# %macro_variable_shutter_chance
 Description     :   
     This macro displays the current macro variables grouped by their scope  
     (GLOBAL, LOCAL, AUTOMATIC) in a formatted SAS RWI(report Writing Interface) ods layout.  
     It is primarily intended for debugging or reporting the macro environment  
     during runtime. Output layout varies depending on the presence of automatic  
     variables as specified by the parameter.

 Parameters      :  
~~~text
     CheckID        = [optional] Identifier string used to distinguish the ODS output 
                            for each macro call. If not provided, defaults to &SYSINDEX.

     automatic_fl   = [optional] Flag to include AUTOMATIC scope variables. 
                      Accepts 'Y' or 'N'. Default is 'N'.
~~~

 Usage Example   :  
 ~~~sas
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
~~~

<img width="388" height="222" alt="Image" src="https://github.com/user-attachments/assets/b6395af3-a401-425d-b9e3-2ea87ecb156a" />  

<img width="380" height="366" alt="Image" src="https://github.com/user-attachments/assets/53866fad-08e5-4f3e-8de9-062895ba8bf2" />  


 Notes and Caveats:  
     - This macro intentionally masks its own local macro variables from being   
       reported in the LOCAL scope output. This prevents internal implementation   
       details from appearing in the diagnostics.
        scope ne "MACRO_VARIABLE_SHUTTER_CHANCE"
        In other words, scope ne "MACRO_VARIABLE_SHUTTER_CHANCE2 is included in the extraction.    

     - Some AUTOMATIC macro variables may reflect values that were populated or   
       modified as a result of this macro・ｽfs own execution (e.g., SYSLAST, SYSERR,    
       SYSINDEX, etc.). Their presence or contents should be interpreted accordingly.  


# version history<br>
0.2.0(04August2025): Add %macro_variable_shutter_chance<br>
0.1.1(20July2025): Add if_condition Parameter in %shutter_chance.<br>
0.1.0(17July2025): Initial version<br>

## What is SAS Packages?  
The package is built on top of **SAS Packages framework(SPF)** developed by Bartosz Jablonski.<br>
For more information about SAS Packages framework, see [SAS_PACKAGES](https://github.com/yabwon/SAS_PACKAGES).  
You can also find more SAS Packages(SASPACs) in [SASPAC](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)
### 1. Set-up SPF(SAS Packages Framework)
Firstly, create directory for your packages and assign a fileref to it.
~~~sas      
filename packages "\path\to\your\packages";
~~~
Secondly, enable the SAS Packages Framework.  
(If you don't have SAS Packages Framework installed, follow the instruction in [SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) to install SAS Packages Framework.)  
~~~sas      
%include packages(SPFinit.sas)
~~~  
### 2. Install SAS package  
Install SAS package you want to use using %installPackage() in SPFinit.sas.
~~~sas      
%installPackage(packagename, sourcePath=\github\path\for\packagename)
~~~
(e.g. %installPackage(ABC, sourcePath=https://github.com/XXXXX/ABC/raw/main/))  
### 3. Load SAS package  
Load SAS package you want to use using %loadPackage() in SPFinit.sas.
~~~sas      
%loadPackage(packagename)
~~~
### Enjoy😁


