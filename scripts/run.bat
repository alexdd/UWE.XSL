@ECHO OFF
REM UWE.XSL - DITA Publishing Stylesheets
REM Copyright (C) 2012-2026 Alex Duesel <tekturcms@gmail.com>
REM SPDX-License-Identifier: LGPL-3.0-only
REM See license.txt for the full license text.
REM
REM Run pipeline with Calabash 3 (FOP via p:os-exec)
SETLOCAL EnableDelayedExpansion
cd /d "%~dp0\.."
SET PROJECT_DIR=%CD%
set "PROJECT_URI=!PROJECT_DIR:\=/!"

REM --- User configuration (no auto-detection/guessing) ---
REM Java executable:
REM - Windows: set JAVA_BIN=C:\Program Files\Eclipse Adoptium\jdk-17\bin\java.exe
REM - Docker: keep default JAVA_BIN=java (if image has java in PATH)
if not defined JAVA_BIN set "JAVA_BIN=java"

REM Optional pipeline base URIs (must be valid file: URIs and end with '/').
if defined UWE_INPUT_BASE call :validate_base_uri UWE_INPUT_BASE "!UWE_INPUT_BASE!" || exit /b 1
if defined UWE_OUTPUT_BASE call :validate_base_uri UWE_OUTPUT_BASE "!UWE_OUTPUT_BASE!" || exit /b 1
if defined UWE_LOG_BASE call :validate_base_uri UWE_LOG_BASE "!UWE_LOG_BASE!" || exit /b 1
if defined UWE_TMP_BASE call :validate_base_uri UWE_TMP_BASE "!UWE_TMP_BASE!" || exit /b 1
if defined UWE_VALIDATE_OUTPUT_BASE call :validate_base_uri UWE_VALIDATE_OUTPUT_BASE "!UWE_VALIDATE_OUTPUT_BASE!" || exit /b 1

call :resolve_java_bin "!JAVA_BIN!" || exit /b 1
set "JAVA_BIN=!RESOLVED_JAVA_BIN!"

SET CATALOG=%PROJECT_DIR%\src\catalog.xml
SET CALABASH_HOME=%PROJECT_DIR%\lib\calabash-dist
SET CALABASH_JAR=%CALABASH_HOME%\xmlcalabash-app-3.0.41.jar

if not exist "%CALABASH_JAR%" (
  echo XML Calabash 3 not found. Run: bash scripts/install.sh
  exit /b 1
)

REM Args:
REM   scripts\run.bat [pipeline.xpl] [extra args...]
REM Optional flag:
REM   --no-validate   (skip validate.xpl when running main.xpl)
set "NO_VALIDATE=0"
set "FAIL_ON_VALIDATE=0"
set "PIPELINE_ARG="
set "TAIL_ARGS="
for %%A in (%*) do (
  if /I "%%~A"=="--no-validate" (
    set "NO_VALIDATE=1"
  ) else if /I "%%~A"=="--fail-on-validate" (
    set "FAIL_ON_VALIDATE=1"
  ) else (
    if not defined PIPELINE_ARG (
      set "PIPELINE_ARG=%%~A"
    ) else (
      set "TAIL_ARGS=!TAIL_ARGS! %%~A"
    )
  )
)
if not defined PIPELINE_ARG set "PIPELINE_ARG=main.xpl"
set "PIPELINE_PATH=%PIPELINE_ARG%"
echo %PIPELINE_PATH% | findstr /R "\\" >nul 2>&1 || (
  if exist "%PROJECT_DIR%\src\xpl\%PIPELINE_ARG%" (
    set "PIPELINE_PATH=src\xpl\%PIPELINE_ARG%"
  ) else (
    set "PIPELINE_PATH=src\xpl\pipelines\%PIPELINE_ARG%"
  )
)
set "PIPELINE=%PROJECT_DIR%\%PIPELINE_PATH%"

set "PIPELINE_PATH_URI=!PIPELINE_PATH:\=/!"
set "PIPELINE_URI=file:///!PROJECT_URI!/!PIPELINE_PATH_URI!"
set "FOP_DIR=%PROJECT_DIR%\lib\fop"
if exist "%FOP_DIR%\fop" set "FOP_DIR=%FOP_DIR%\fop"
set "CP=%CALABASH_JAR%;%CALABASH_HOME%\lib\*;%FOP_DIR%\build\*;%FOP_DIR%\lib\*"
set "TMP_DIR=%PROJECT_DIR%\test\tmp"
if defined UWE_TMP_BASE (
  call :uri_to_win_path "!UWE_TMP_BASE!" TMP_DIR || exit /b 1
  if "!TMP_DIR:~-1!"=="\" set "TMP_DIR=!TMP_DIR:~0,-1!"
)
set "OUTPUT_FALLBACK=%PROJECT_DIR%\test\output\XmlHandsOn"
if defined UWE_OUTPUT_BASE (
  call :uri_to_win_path "!UWE_OUTPUT_BASE!" OUTPUT_FALLBACK || exit /b 1
  if "!OUTPUT_FALLBACK:~-1!"=="\" set "OUTPUT_FALLBACK=!OUTPUT_FALLBACK:~0,-1!"
)

REM Generate FOP config: replace __FONT_DIR__ with absolute path to font directory.
if exist "%PROJECT_DIR%\conf\fop\fop-template.xconf" (
  set "FONT_DIR=!PROJECT_DIR:\=/!/lib/fonts/noto"
  "!JAVA_BIN!" -cp "!CP!" net.sf.saxon.Transform -s:"%PROJECT_DIR%\conf\fop\fop-template.xconf" -xsl:"%PROJECT_DIR%\src\xpl\tools\fop-config-resolve.xsl" "font-dir=!FONT_DIR!" -o:"%PROJECT_DIR%\conf\fop\fop-generated.xconf" 2>nul
)

if exist "%TMP_DIR%" rmdir /s /q "%TMP_DIR%"
mkdir "%TMP_DIR%" >nul 2>&1

REM Main pipeline only: FOP options and --step:main. Validation (validate.xpl) needs no extra options.
set "EXTRA_OPTS="
set "MAIN_PIPELINE="
echo %PIPELINE_ARG% | findstr /I "main.xpl" >nul 2>&1 && (
  set "MAIN_PIPELINE=1"
  set "FOP_CMD=%PROJECT_DIR%\lib\fop\fop\fop.bat"
  if exist "%PROJECT_DIR%\lib\fop\fop\fop.bat" set "FOP_CMD=%PROJECT_DIR%\lib\fop\fop\fop.bat"
  set "EXTRA_OPTS=--step:main --output:result=!TMP_DIR!\pipeline-result.xml use-cmd-wrapper=true fop-command=!FOP_CMD!"
  if defined UWE_INPUT_BASE set "EXTRA_OPTS=!EXTRA_OPTS! input-base=!UWE_INPUT_BASE!"
  if defined UWE_OUTPUT_BASE set "EXTRA_OPTS=!EXTRA_OPTS! output-base=!UWE_OUTPUT_BASE!"
  if defined UWE_LOG_BASE set "EXTRA_OPTS=!EXTRA_OPTS! log-base=!UWE_LOG_BASE!"
  if defined UWE_TMP_BASE set "EXTRA_OPTS=!EXTRA_OPTS! tmp-base=!UWE_TMP_BASE!"
)

REM Default: validate first (unless --no-validate), then run main.
if defined MAIN_PIPELINE if "%NO_VALIDATE%"=="0" (
  set "VALIDATE_PATH=src\xpl\pipelines\validate.xpl"
  set "VALIDATE_PATH_URI=!VALIDATE_PATH:\=/!"
  set "VALIDATE_URI=file:///!PROJECT_URI!/!VALIDATE_PATH_URI!"
  set "VALIDATE_OPTS="
  if defined UWE_INPUT_BASE set "VALIDATE_OPTS=!VALIDATE_OPTS! input-base=!UWE_INPUT_BASE!"
  if defined UWE_VALIDATE_OUTPUT_BASE set "VALIDATE_OPTS=!VALIDATE_OPTS! output-base=!UWE_VALIDATE_OUTPUT_BASE!"
  "!JAVA_BIN!" -Dxml.catalog.files="%CATALOG%" -cp "%CP%" com.xmlcalabash.app.Main "!VALIDATE_URI!" !VALIDATE_OPTS!
  if errorlevel 1 (
    echo Validation reported errors. Continuing with main pipeline. 1>&2
    if "%FAIL_ON_VALIDATE%"=="1" (
      ENDLOCAL & exit /b 1
    )
  )
)

"!JAVA_BIN!" -Dxml.catalog.files="%CATALOG%" -cp "%CP%" com.xmlcalabash.app.Main "%PIPELINE_URI%" %EXTRA_OPTS% %TAIL_ARGS%
set "RUN_RC=%ERRORLEVEL%"
if "%RUN_RC%"=="0" if defined MAIN_PIPELINE (
  for /D %%D in ("%TMP_DIR%\*") do (
    set "LANG=%%~nxD"
    if exist "%%~fD\at2.xml" (
      if not exist "!OUTPUT_FALLBACK!\!LANG!\pdf" mkdir "!OUTPUT_FALLBACK!\!LANG!\pdf" >nul 2>&1
      if exist "!OUTPUT_FALLBACK!\!LANG!\pdf\!LANG!.pdf" del /f /q "!OUTPUT_FALLBACK!\!LANG!\pdf\!LANG!.pdf" >nul 2>&1
      call "!FOP_CMD!" -c "%PROJECT_DIR%\conf\fop\fop-generated.xconf" -atin "%%~fD\at2.xml" -pdf "!OUTPUT_FALLBACK!\!LANG!\pdf\!LANG!.pdf"
      if errorlevel 1 set "RUN_RC=1"
    )
  )
)
ENDLOCAL & exit /b %RUN_RC%

:validate_base_uri
set "V_NAME=%~1"
set "V_VALUE=%~2"
if /I not "!V_VALUE:~0,8!"=="file:///" (
  echo Invalid !V_NAME!: '!V_VALUE!'. Expected file:///.../ 1>&2
  exit /b 1
)
if not "!V_VALUE:~-1!"=="/" (
  echo Invalid !V_NAME!: '!V_VALUE!'. Expected trailing slash. 1>&2
  exit /b 1
)
exit /b 0

:resolve_java_bin
set "J_IN=%~1"
set "J_PATH="
echo %J_IN% | findstr /R "[\\/]" >nul 2>&1
if not errorlevel 1 (
  if exist "%J_IN%" (
    set "J_PATH=%J_IN%"
  ) else (
    echo Java executable not found: %J_IN% 1>&2
    exit /b 1
  )
) else (
  for /f "delims=" %%I in ('where %J_IN% 2^>nul') do (
    if not defined J_PATH set "J_PATH=%%I"
  )
  if not defined J_PATH (
    echo Java executable '%J_IN%' not found in PATH. 1>&2
    exit /b 1
  )
)
"%J_PATH%" -version >nul 2>&1 || (
  echo Java executable failed: %J_PATH% 1>&2
  exit /b 1
)
set "RESOLVED_JAVA_BIN=%J_PATH%"
exit /b 0

:uri_to_win_path
set "U_VALUE=%~1"
set "U_OUTVAR=%~2"
if /I not "!U_VALUE:~0,8!"=="file:///" (
  echo Invalid file URI: !U_VALUE! 1>&2
  exit /b 1
)
set "U_TMP=!U_VALUE:~8!"
set "U_TMP=!U_TMP:/=\!"
set "%U_OUTVAR%=!U_TMP!"
exit /b 0
