@ECHO OFF
title Un-nix
SET MAKE_MODE=unix
SET CYGROOT=C:\Cygnus\B19
SET CYGFS=C:/Cygnus/B19
SET CYGREL=B19
SET GCC_EXEC_PREFIX=%CYGROOT%\H-i386-cygwin32\lib\gcc-lib\
SET TCL_LIBRARY=%CYGROOT%\share\tcl8.0\
SET GDBTK_LIBRARY=%CYGFS%/share/gdbtcl
SET PATH=%CYGROOT%\H-i386-cygwin32\bin;%PATH%
echo Cygnus Cygwin32 %CYGREL%
bash 
rem -c "cd %1:%2; bash"
