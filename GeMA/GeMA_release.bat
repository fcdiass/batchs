@echo off
set batchName=GeMA release - Version 2.0.0
Title %batchName%

REM Set origin, destination and backup folders
set origF=D:\GeMA\GeMA_1\trunk\gema
set destF=D:\GeMA_release
set qtF=C:\Qt\5.12.4\msvc2017_64\bin

echo ================================================================================
echo %batchName%
echo Author: Francisco Dias
echo See more: https://github.com/fcdiass/batchs
echo ================================================================================
echo.
echo - This operation will copy the release version of GeMA.
echo. 
echo - You need to build GeMA in release mode before this operation.
echo. 
echo - For correct result, you must ensure the following paths are corrects:
echo   Origin folder     : %origF%
echo   Destination folder: %destF%
echo   Qt folder         : %qtF%
echo.  

setlocal enabledelayedexpansion

set /p ans="Do you want to copy now? (Y) Yes, sure! (N) No, thanks. "

:main
	REM Upgrade GeMA
	if /i !ans!==Y (
		if not exist "!destF!" ( mkdir "!destF!"  & call :copyRelease & exit )
		if exist     "!destF!" ( call :delRelease & call :copyRelease & exit )
	)

goto :eof

:delRelease
	Title GeMA release -Deleting content in destination folder
	REM Clean all folders and files inside of destF
	cd /d "!destF!"
	for %%i in (*) do (
		del %%i /q
	)
	for /d %%i in (*) do (
		rd %%i /s /q
	)
goto :eof

:copyRelease
	Title GeMA release - Copying files from origin folder
	REM Copy release files from origF to destF
	cd /d "!origF!"
	for /d %%i in (*) do (
		REM 0 - Do not copy
		set /a count=0
		
		REM 1 - Copy
		if %%i==config     ( set /a count=1 )
		REM if %%i==examples   ( set /a count=1 )
		if %%i==scriptsLib ( set /a count=1 )

		REM 2 - Copy to parent folder
		if %%i==release    ( set /a count=2 )
		
		REM 3 - Copy removing from release folder
		if %%i==plugins    ( set /a count=3 )
		
		
		if !count!==1 xcopy "!origF!\%%i"       "!destF!\%%i" /D /Y /C /K /I /S
		if !count!==2 xcopy "!origF!\%%i\*.exe" "!destF!"     /D /Y /C /K /I
		if !count!==2 xcopy "!origF!\%%i\*.dll" "!destF!"     /D /Y /C /K /I
		if !count!==3 (
			for /d %%j in (!origF!\%%i\*) do (
				xcopy "%%j\release" "!destF!\%%i\%%~nxj"      /D /Y /C /K /I
			)
		)		
	)
	xcopy "!qtF!\Qt5Core.dll" "!destF!"                 /D /Y /C /K /I
	xcopy "!qtF!\Qt5Network.dll" "!destF!"              /D /Y /C /K /I
	xcopy "C:\Windows\System32\vcomp140.dll" "!destF!"  /D /Y /C /K /I
goto :eof

endlocal
