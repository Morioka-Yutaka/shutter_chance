# shutter_chance
SHUTTER_CHANCE: Visual Checkpoints for SAS Data Step Review

![shutter_chance](./shutter_chance_small.png)  

# %shutter_chance
This macro generates a visual checkpoint output for selected records (based on _N_) using ODS html layout and table constructs. .<br>
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

