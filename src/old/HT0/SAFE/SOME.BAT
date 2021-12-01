@echo off
set X=
:loop
if "%1"=="" goto done
set X=%X% %1
shift
goto loop
:done
echo %X%