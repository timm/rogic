@echo off
SETLOCAL
set HERE='C:/tim/src/pl/rogic4'
set MAIN=rogic
set PLCON="c:\program files\pl\bin\plcon.exe"
set PLBIN="c:\program files\pl\bin" 
set LOAD=load_files([%MAIN%],[silent(true)]),+[%2]

IF "%1"=="-runs" GOTO RUNS 
IF "%1"=="-run1" GOTO RUN1 
IF "%1"=="-win"  GOTO WIN
GOTO HELP

:RUNS
%PLCON% -g %LOAD%,welcome
GOTO END

:RUN1
%PLCON%  -g %LOAD%,go,halt
GOTO END

:WIN
start /D  %PLBIN% plwin.exe -g cd(%HERE%),%LOAD%,welcome
GOTO END

:HELP
type usage.txt
:END