// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents
Data.createRecords(10);
Data.deleteRecords();
string tempvar = 'https://github.com/itay98/balink';
System.debug('Hello World!');
System.debug('My repo is ' + tempvar);