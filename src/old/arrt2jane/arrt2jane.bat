@echo off
title Arrt2Jane
echo "c:\program files\pl\bin\plcon.exe" -g "load_files([arrt2jane],[silent(true)])"  -- %1 %2 %3 %4 %5 %6 %7 %8 >> arrt2jane.log
"c:\program files\pl\bin\plcon.exe" -g "load_files([arrt2jane],[silent(true)])"  -- %1 %2 %3 %4 %5 %6 %7 %8 
