: ht0.bat (c) 1999 tim@menzies.com
: runs swi prolog code like any other batch file
: e.g. ht0  -n1 1 -n2 1 -l 28 -i

@echo off

::::::::::::::::::: stuff to customise ::::::::::::::::::::::
:main file to load
set PL_MAIN=main

:predicate to call first, after loading %PL_LOAD%
set PL_1=switches

:predicate to call second, after running %PL_1%.
:if set to "halt", then prolog exits after running %PL_2%. 
:if set to "prolog" then once %PL_2% terminates, you are
:dropped into the interactive prolog environment
:set PL_2=prolog
set PL_2=halt

:location of prolog executable
set PL_="C:\Program Files\pl\BIN\Plcon.exe"  

:::::: stop customising here. rest should be generic ::::::::
set PL_=%PL_% -L0 -G0 -T0 -t %PL_2% -g 
set PL_=%PL_% "load_files([%PL_MAIN%],[silent(true)]),%PL_1%"
set PL_ARGS=

:loop
if "%1"=="" goto end
set PL_ARGS=%PL_ARGS% %1
shift
goto loop
:end

echo ht0 %PL_ARGS% >> ht0run.txt
%PL_%  -- %PL_ARGS% 




