@echo off
set batchName=Clear all folders for analysis with GeMA  - Version 1.0.0
Title %batchName%
echo =====================================================================
echo %batchName%
echo Author: Francisco Dias
echo See more: https://github.com/fcdiass/batchs
echo =====================================================================
echo. 

REM Exclusions by extension (separated by a space)
set exRange=.lua .xls .xlsx .bat .py

REM Exclusion by name + extension (separated by a space and MUST be inside double quotes)
set nERange="runFolders.txt" "options.txt" "readme.txt"

setlocal enabledelayedexpansion
cd /d %~dp0
set /a n=0
for /r %%i in (*) do (
    set /a del=1
    call :exclusions "%%~xi" "%%~nxi" "%%~i"
    if !del!==1 set /a n+=1 & set range=!range! "%%i"
)

if !n!==0 (
    echo ======================= NO FILES TO DELETE ==========================
    pause > nul & exit
) else (
    call :warning
    if /i !ans!==Y (
        echo. 
        echo Deleting files...
        echo. 
        for %%i in (!range!) do ( del /q "%%~i" )
        echo ========================== FILES DELETED ============================
        pause > nul & exit
    )
)

:exclusions
    set extension=%~1
    set nameExten=%~2
    set fullPath=%~3
    for %%i in (!exRange!) do ( if "!extension!"=="%%~i" set /a del=0 )
    for %%i in (!nERange!) do ( if "!nameExten!"=="%%~i" set /a del=0 )
    if "!fullPath!"=="%~f0" set /a del=0
goto :eof

:warning
    echo                         # #   WARNING   # #
    echo. 
    echo - This operation clear folders and subfolders with GeMA projects.
    echo - Continue if you know what are you doing.
    echo. 
    echo - These files will be deleted:
    for %%i in (!range!) do ( echo   %%~i & set /a nReal+=1)
    echo. 
    echo !nReal! of !n! possible files will be deleted.
    set /p ans="Do you want continue? (Y) Yes (Press enter to cancel): "
goto :eof
