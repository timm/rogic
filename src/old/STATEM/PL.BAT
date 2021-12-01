: pl.bat (c) 1999 tim@menzies.com
: runs swi prolog code like any other batch file
: requires:  a main.pl file in the current directory
:            a prolog executable
@echo off

::::::::::::::::::: stuff to customise ::::::::::::::::::::::
:location of prolog executable
:can be reset using -2
set PL_EXE="C:\Program Files\pl\BIN\Plcon.exe"  

:main file to load
:can be reset using -1 
set PL_MAIN=main

:::::: stop customising here. rest should be generic ::::::::

set PL_ARGS=
:loop
if "%1"==""   goto endLoop
if "%1"=="-MAIN" goto argMain
if "%1"=="-EXE"  goto argExe
goto argNs

:argMain
set PL_MAIN=%2
shift
shift
goto loop

:argExe
set PL_EXE=%2
shift
shift
goto loop

:argNs
set PL_ARGS=%PL_ARGS% %1
shift
goto loop
:endLoop

if not exist %PL_EXE%    goto missingProlog
if not exist %PL_MAIN%.pl goto missingMain
if "%PL_ARGS%"==""     goto plrun
goto start

:missingProlog
echo pl: prolog executable not installed at %Pl_2%
goto abort

:missingMain
echo pl: missing main load file: %Pl_1%.pl
goto abort

:start
set PL_=%PL_EXE% -t halt -g 
set PL_=%PL_% "load_files([%PL_MAIN%],[silent(true)])"
echo %PL_% -- %PL_ARGS% > plrun.bat

:plrun
if not exist plrun.bat goto abort
plrun

:abort
