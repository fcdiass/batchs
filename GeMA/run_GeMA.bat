@echo off
set batchName=Run multiple analysis with GeMA - Version 2.0.0
Title %batchName%
echo ================================================================================
echo %batchName%
echo Author: Francisco Dias
echo See more: https://github.com/fcdiass/batchs
echo ================================================================================
echo.

cd /d "%~dp0"
set mypath=%cd%

REM Set GeMA path file:
set PATH="C:\Program Files\GeMA";%PATH%

:main
	setlocal enableextensions enabledelayedexpansion
	if exist runFolders.txt (
		for /F "delims=" %%g in (runFolders.txt) do (
			if "%%g"=="*" ( call:runAll&call:end&exit/b )
			set folderName=%%g
			cd /d "!mypath!\!folderName!"
			call:run
		)
		call:end
	) else (
		call:runAll&call:end
	)
goto :eof

:runAll
	for /d %%g in (*) do (
		set folderName=%%g
		cd /d "!mypath!\!folderName!"
		call:run
	)
goto:eof

:run
	Title Run multiple analysis with GeMA - Runnig !folderName!...
	echo ================================================================================
	echo Runnig !folderName!
	echo ================================================================================
	set temp1=0
	for %%a in (*) do (
		if %%~xa==.lua ( set temp1=1 )
	)
	if !temp1!==0 (
		echo             ***    There is no input file for this model    ***
	) else (
        if exist options.txt (
            for /F "delims=" %%g in (options.txt) do (
                call:GeMA "%%g"
            )
        ) else (
            call:GeMA
        )
	)
	echo.
	echo.
goto:eof

:GeMA
    set userParams=%1
    
    for %%j in (*.lua) do (
        set fileName=%%j
        set temp2=0
        if !fileName:~-9!==_data.lua      ( set temp2=1 )
        if !fileName:~-10!==_model.lua    ( set temp2=1 )
        if !fileName:~-12!==_intMesh.lua  ( set temp2=1 )
        if !fileName:~-13!==_solution.lua ( set temp2=1 )
        if "!temp2!"=="0" (
            if "%~1"=="" (
                set command="!fileName!"
            ) else (
                set command="!fileName!" -u !userParams!
            )
            REM ================   CHANGE HERE THE PROPERTIES OF ANALYSIS   ================
            gema !command!
        )
    )
goto:eof

:end
	Title Run multiple analysis with GeMA - STEPS FINISHED
	endlocal
	echo ============================== STEPS FINISHED ==================================
	echo. 
    pause
