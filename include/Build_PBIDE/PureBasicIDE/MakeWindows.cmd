@Echo Off
:: ************************************************************************
:: *             Windows Build Script without preconditions               *
:: ************************************************************************
::
:: This script is an optional replacement to build the IDE/Debugger on
:: Windows without the need to install any Unix tools such as make.
::
:: Run this script as follows:
::
::    MakeWindows.cmd <TargetPureBasicDirectory>
::
:: No previous setup or use of "BuildEnv.cmd" is required in this case.
:: For more information on the <TargetPureBasicDirectory> parameter, see 
:: the description of "BuildEnv.cmd" in the main directory.
::
:: NOTE:
:: The makefile is still the official way to build the IDE and debugger,
:: even on Windows. This script is for convenience only. If you make
:: any changes to this build script, the same changes must be made
:: (and tested) in the makefile as well!
::
:: ************************************************************************

Cd /d %~dp0

:: Check presence of the mandatory argument
If Not [%1]==[] Goto Path_argument_ok

Echo Invalid parameters: Missing argument for target PureBasic directory
:: waits 5s before exiting to have time to read the message (if started with double-click)
Ping -n 4 127.0.0.1 > nul
Exit 1

:Path_argument_ok

:: Set PUREBASIC_HOME and ensure the compiler and IDE are in the path
Set PUREBASIC_HOME=%1
Set PATH=%PUREBASIC_HOME%\Compilers;%PUREBASIC_HOME%;%PATH%

:: Check its a valid PB folder
If Not Exist %PUREBASIC_HOME%\Compilers\pbcompiler.exe (
    Echo Invalid parameters: PBcompiler was not found in target PureBasic directory
    Ping -n 4 127.0.0.1 > nul
    Exit 1
)

:: Check if the Target PureBasic folder is writable
Copy /Y Nul "%PUREBASIC_HOME%/Tmp_FullAccess" >nul 2>&1 && set WRITEOK=1
If Defined WRITEOK ( 
  Del /q /f "%PUREBASIC_HOME%\Tmp_FullAccess"
 ) Else (
  Echo The Target PureBasic folder is not writable.
  Echo Please copy paste it to another location, with Full control Permissions.
  Ping -n 4 127.0.0.1 > nul
  Exit 1
)

Echo.
Echo --------------------------------------------------------------------------------------
Echo Compil PureBasic
Echo --------------------------------------------------------------------------------------

@Echo On

:: ************** Build steps start here *********************************

:: Clean/Reset the Build directory
If Exist Build\ Rd /q /s Build
Md Build

:: Create the "Build/dummy" file for compatibility with using the real makefile
Type Nul > Build\dummy

:: Generate dialog files
@Set DIALOGS=Find;Grep;Goto;CompilerOptions;AddTools;About;Preferences;Templates;StructureViewer;Projects;Build;Diff;FileMonitor;History;HistoryShutdown;CreateApp;Updates
PBCompiler /QUIET /CONSOLE ..\DialogManager\DialogCompiler.pb /EXE Build\DialogCompiler.exe
@FOR %%D IN (%DIALOGS%) DO Build\DialogCompiler.exe dialogs\%%D.xml Build\%%D.pb

:: Generate themes
PBCompiler /QUIET /CONSOLE tools\maketheme.pb /EXE Build\maketheme.exe
Build\maketheme.exe Build\DefaultTheme.zip data\DefaultTheme
Build\maketheme.exe %PUREBASIC_HOME%\Themes\SilkTheme.zip data\SilkTheme

:: Generate build info
PBCompiler /QUIET /CONSOLE tools/makebuildinfo.pb /EXE Build/makebuildinfo.exe
Build\makebuildinfo.exe Build

:: Generate version info resource
PBCompiler /QUIET /CONSOLE tools/makeversion.pb /EXE Build/makeversion.exe
Build\makeversion.exe ide Build/VersionInfo.rc data/PBSourceFile.ico

:: Compile the IDE
PBCompiler /QUIET PureBasic.pb /EXE %PUREBASIC_HOME%\PureBasic.exe /THREAD /UNICODE /XP /USER /ICON data/PBLogoBig.ico /DPIAWARE /RESOURCE Build/VersionInfo.rc

:: ************** Build steps end here *********************************
:: information message about the success or failure of the compilation and waits 5s before exiting

@Echo Off
Echo.
Echo --------------------------------------------------------------------------------------
If Exist "%PUREBASIC_HOME%\PureBasic.exe" (
    Echo PureBasic.exe Successfully Created in %PUREBASIC_HOME%
) else (
    Echo Purebasic.exe Compilation Failure! 
)
Echo --------------------------------------------------------------------------------------
Echo Exiting... & Ping -n 9 127.0.0.1 > nul
::Pause
Exit