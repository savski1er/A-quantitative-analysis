libname user '/Users/macuser/Desktop/aisproject/';
libname data '/Users/macuser/Desktop/aisproject/data';
libname dat '/Users/macuser/Desktop/aisproject/dat';


proc import datafile = '/Users/macuser/Desktop/aisproject/dat/datindx4.csv'
 out = work.datindx4
 dbms = CSV;
run;



data dat; da