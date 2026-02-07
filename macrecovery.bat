@echo off
setlocal EnableDelayedExpansion

REM ============================
REM  OpenCore Simplify Python Logic
REM ============================

set "thisDir=%~dp0"
set "script_name=macrecovery.py"
set /a tried=0
set "toask=yes"
set "pause_on_error=yes"
set "py2v="
set "py2path="
set "py3v="
set "py3path="
set "pypath="
set "targetpy=3"
set "use_py3=TRUE"
set "just_installing=FALSE"

call :getsyspath "syspath"

if "%~1"=="--install-python" (
    set "just_installing=TRUE"
    goto installpy
)

goto checkscript

:checkscript
if not exist "%thisDir%%script_name%" (
    echo macrecovery.py not found in:
    echo   %thisDir%
    pause >nul
    exit /b
)
goto checkpy

:checkpy
call :updatepath
for /f "USEBACKQ tokens=*" %%x in (`!syspath!where.exe python 2^>nul`) do ( call :checkpyversion "%%x" "py2v" "py2path" "py3v" "py3path" )
for /f "USEBACKQ tokens=*" %%x in (`!syspath!where.exe python3 2^>nul`) do ( call :checkpyversion "%%x" "py2v" "py2path" "py3v" "py3path" )
for /f "USEBACKQ tokens=*" %%x in (`!syspath!where.exe py 2^>nul`) do ( call :checkpylauncher "%%x" "py2v" "py2path" "py3v" "py3path" )

if /i "!use_py3!"=="FALSE" (
    set "pypath=!py2path!"
) else (
    set "pypath=!py3path!"
    if "!pypath!"=="" set "pypath=!py2path!"
)

if not "!pypath!"=="" goto menu

if !tried! lss 1 (
    goto askinstall
) else (
    echo Python not found.
    pause >nul
    exit /b
)

goto menu

:askinstall
cls
echo Python not found.
set /p ans=Install Python now? [y/n]: 
if /i "%ans%"=="y" goto installpy
set /a tried+=1
goto checkpy

:installpy
set /a tried+=1
cls
echo Installing Python...
powershell -command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;(new-object System.Net.WebClient).DownloadFile('https://www.python.org/downloads/windows/','%TEMP%\pyurl.txt')"
powershell -command "$infile='%TEMP%\pyurl.txt';$outfile='%TEMP%\pyurl.temp';try{$input=New-Object System.IO.FileStream $infile,([IO.FileMode]::Open),([IO.FileAccess]::Read),([IO.FileShare]::Read);$output=New-Object System.IO.FileStream $outfile,([IO.FileMode]::Create),([IO.FileAccess]::Write),([IO.FileShare]::None);$gzipStream=New-Object System.IO.Compression.GzipStream $input,([IO.Compression.CompressionMode]::Decompress);$buffer=New-Object byte[](1024);while($true){$read=$gzipstream.Read($buffer,0,1024);if($read -le 0){break};$output.Write($buffer,0,$read)};$gzipStream.Close();$output.Close();$input.Close();Move-Item -Path $outfile -Destination $infile -Force}catch{}"

pushd "%TEMP%"
for /f "tokens=9 delims=< " %%x in ('findstr /i /c:"Latest Python 3 Release" pyurl.txt') do set "release=%%x"
popd

set "url=https://www.python.org/ftp/python/%release%/python-%release%-amd64.exe"
powershell -command "(new-object System.Net.WebClient).DownloadFile('%url%','%TEMP%\pyinstall.exe')"

"%TEMP%\pyinstall.exe" /quiet PrependPath=1 Include_test=0 Shortcuts=0 Include_launcher=0

call :updatepath
goto checkpy

REM ============================
REM  macOS Recovery Menu
REM ============================

:menu
cls
echo ===============================
echo   macOS Recovery Downloader
echo ===============================
echo 1. Lion
echo 2. Mountain Lion
echo 3. Mavericks
echo 4. Yosemite
echo 5. El Capitan
echo 6. Sierra
echo 7. High Sierra
echo 8. Mojave
echo 9. Catalina
echo 10. Big Sur
echo 11. Monterey
echo 12. Ventura
echo 13. Sonoma
echo 14. Sequoia
echo 15. Tahoe (Latest)
echo 0. Exit
echo ===============================
set /p choice=Select: 

if "%choice%"=="0" exit /b

set "OUTPUT=%thisDir%RecoveryOutput"
if not exist "%OUTPUT%" mkdir "%OUTPUT%"

echo.
echo Saving files to:
echo   %OUTPUT%
echo.

REM ============================
REM  OS COMMANDS (WINDOWS VERSION)
REM ============================

pushd "%OUTPUT%"

if "%choice%"=="1" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-2E6FAB96566FE58C -m 00000000000F25Y00 download
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-C3EC7CD22292981F -m 00000000000F0HM00 download
)

if "%choice%"=="2" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-7DF2A3B5E5D671ED -m 00000000000F65100 download
)

if "%choice%"=="3" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-F60DEB81FF30ACF6 -m 00000000000FNN100 download
)

if "%choice%"=="4" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-E43C1C25D4880AD6 -m 00000000000GDVW00 download
)

if "%choice%"=="5" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-FFE5EF870D7BA81A -m 00000000000GQRX00 download
)

if "%choice%"=="6" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-77F17D7DA9285301 -m 00000000000J0DX00 download
)

if "%choice%"=="7" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-7BA5B2D9E42DDD94 -m 00000000000J80300 download
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-BE088AF8C5EB4FA2 -m 00000000000J80300 download
)

if "%choice%"=="8" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-7BA5B2DFE22DDD8C -m 00000000000KXPG00 download
)

if "%choice%"=="9" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-CFF7D910A743CAAF -m 00000000000PHCD00 download
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-00BE6ED71E35EB86 -m 00000000000000000 download
)

if "%choice%"=="10" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-2BD1B31983FE1663 -m 00000000000000000 download
)

if "%choice%"=="11" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-E43C1C25D4880AD6 -m 00000000000000000 download
)

if "%choice%"=="12" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-B4831CEBD52A0C4C -m 00000000000000000 download
)

if "%choice%"=="13" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-827FAC58A8FDFA22 -m 00000000000000000 download
)

if "%choice%"=="14" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-7BA5B2D9E42DDD94 -m 00000000000000000 download
)

if "%choice%"=="15" (
    "%pypath%" "%thisDir%macrecovery.py" -b Mac-CFF7D910A743CAAF -m 00000000000000000 -os latest download
)

popd

echo.
echo Done.
start "" "%OUTPUT%"
pause >nul
goto menu

REM ============================
REM  (Python helper functions)
REM ============================

:checkpylauncher
for /f "USEBACKQ tokens=*" %%x in (`%~1 -2 -c "import sys; print(sys.executable)" 2^>nul`) do ( call :checkpyversion "%%x" "%~2" "%~3" "%~4" "%~5" )
for /f "USEBACKQ tokens=*" %%x in (`%~1 -3 -c "import sys; print(sys.executable)" 2^>nul`) do ( call :checkpyversion "%%x" "%~2" "%~3" "%~4" "%~5" )
goto :EOF

:checkpyversion
set "version="&for /f "tokens=2* USEBACKQ delims= " %%a in (`"%~1" -V 2^>^&1`) do (
    call :isnumber "%%a"
    if not "!errorlevel!"=="0" goto :EOF
    set "version=%%a"
)
if not defined version goto :EOF
if "!version:~0,1!"=="2" (
    call :comparepyversion "!version!" "!%~2!"
    if "!errorlevel!"=="1" (
        set "%~2=!version!"
        set "%~3=%~1"
    )
) else (
    call :comparepyversion "!version!" "!%~4!"
    if "!errorlevel!"=="1" (
        set "%~4=!version!"
        set "%~5=%~1"
    )
)
goto :EOF

:isnumber
set "var="&for /f "delims=0123456789." %%i in ("%~1") do set var=%%i
if defined var exit /b 1
exit /b 0

:comparepyversion
for /f "tokens=1,2,3 delims=." %%a in ("%~1") do ( set a1=%%a & set a2=%%b & set a3=%%c )
for /f "tokens=1,2,3 delims=." %%a in ("%~2") do ( set b1=%%a & set b2=%%b & set b3=%%c )
if not defined a1 set a1=0
if not defined a2 set a2=0
if not defined a3 set a3=0
if not defined b1 set b1=0
if not defined b2 set b2=0
if not defined b3 set b3=0
if %a1% gtr %b1% exit /b 1
if %a1% lss %b1% exit /b 2
if %a2% gtr %b2% exit /b 1
if %a2% lss %b2% exit /b 2
if %a3% gtr %b3% exit /b 1
if %a3% lss %b3% exit /b 2
exit /b 0

:updatepath
set "spath="
set "upath="
for /f "USEBACKQ tokens=2* delims= " %%i in (`!syspath!reg.exe query "HKCU\Environment" /v "Path" 2^>nul`) do ( if not "%%j"=="" set "upath=%%j" )
for /f "USEBACKQ tokens=2* delims= " %%i in (`!syspath!reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "Path" 2^>nul`) do ( if not "%%j"=="" set "spath=%%j" )
if not "%spath%"=="" (
    set "PATH=%spath%"
    if not "%upath%"=="" set "PATH=%PATH%;%upath%"
) else if not "%upath%"=="" (
    set "PATH=%upath%"
)
goto :EOF

:getsyspath
call :undouble "temppath" "%ComSpec%" ";"
(set LF=^
%=empty=%
)
set "testpath=%temppath:;=!LF!%"
set /a found=0
for /f "tokens=* delims=" %%i in ("!testpath!") do (
    if not "%%i"=="" (
        if !found! lss 1 (
            set "checkpath=%%i"
            if /i "!checkpath:~-7!"=="cmd.exe" set "checkpath=!checkpath:~0,-7!"
            if not "!checkpath:~-1!"=="\" set "checkpath=!checkpath!\"
            if exist "!checkpath!cmd.exe" if exist "!checkpath!reg.exe" if exist "!checkpath!where.exe" (
                set /a found=1
                set "ComSpec=!checkpath!cmd.exe"
                set "%~1=!checkpath!"
            )
        )
    )
)
goto :EOF

:undouble
set "string_value=%~2"
:undouble_continue
set "check=!string_value:%~3%~3=%~3!"
if not "!check!"=="!string_value!" (
    set "string_value=!check!"
    goto :undouble_continue
)
set "%~1=!check!"
goto :EOF
