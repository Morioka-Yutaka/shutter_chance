# shutter_chance
SHUTTER_CHANCE: Visual Checkpoints for SAS Data Step Review

![shutter_chance](./shutter_chance_small.png)  

# %shutter_chance
This macro generates a visual checkpoint output for selected records (based on _N_) using ODS html layout and table constructs..<br>
It is useful for  data review or debugging by presenting variable values in a clear format.

 Parameters      : <br>
 ~~~text  
   CheckID  = Optional identifier for the output block. If not specified, &sysindex is used.
   n        = Record numbers (_N_) to trigger output generation (e.g., 1:3 or 2 4 6). Default is 1.
   varlist  = List of variable names to be displayed (space-delimited). This is required.
~~~

~~~sas 
 Usage example: <br>
   data wk1;
     set sashelp.class;
     %shutter_chance(CheckID=A, n=1:3, varlist=Name Weight Height BMI);
     BMI = Weight / HEIGHT**2 * 703;
     %shutter_chance(CheckID=B, n=1:3, varlist=Name Weight Height BMI);
   run;
~~~


<img width="264" height="321" alt="Image" src="https://github.com/user-attachments/assets/323df33d-f595-40f5-9688-b1de1f210de8" />

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


# version history<br>
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


