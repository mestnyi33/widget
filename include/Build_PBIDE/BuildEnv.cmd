@Echo Off
:: ************************************************************************
:: *         Setup the build Environment for builds on Windows            *
:: ************************************************************************
::
:: Run this script to setup a command shell with the proper environment
:: variables required for building the IDE and other programs in this 
:: repository.
::
:: The commandline for execution of this script is the following:
::
::    BuildEnv.cmd <TargetPureBasicDirectory>
::
:: The <TargetPureBasicDirectory> parameter is mandatory. It specifies 
:: the compiler to use and building the IDE will actually override 
:: the IDE and other resources within that target directory. It is 
:: therefore recommended to setup a dedicated PB installation for
:: IDE development and testing.
::
:: If the target directory is a SpiderBasic installation, the SB IDE 
:: will be built instead. Note that for this case you will need a 
:: regular PB installation available in the PATH as well.
::
:: By default this script will launch a command shell with the build
:: environment. You can suppress this by setting the PB_BATCH=1 env
:: variable before running this script.
::
:: ************************************************************************

Cd /d %~dp0

If Not [%1] == [] Goto Path_argument_ok

Call :ErrorMsg "Invalid parameters: Missing argument for target PureBasic directory"

:Path_argument_ok
:: Set PUREBASIC_HOME and ensure the compiler and IDE are in the path
Set PUREBASIC_HOME=%1
Set OPTION=%2
Set PATH=%PUREBASIC_HOME%\Compilers;%PUREBASIC_HOME%;%PATH%

:: Check if the Target PureBasic folder is writable
Copy /Y Nul "%PUREBASIC_HOME%/Tmp_FullAccess" >nul 2>&1 && set WRITEOK=1
If Defined WRITEOK ( 
  Del /q /f "%PUREBASIC_HOME%\Tmp_FullAccess"
 ) Else (
  Call :ErrorMsg "The Target PureBasic folder is not writable.& Echo Please copy paste it to another location, with Full control Permissions."
)

:: If UnixTools-4-Win is in %PATH% Else, Download and UnZip it in UnixTools-4-Win subfolder and Add it to %PATH%
Echo %PATH%|Findstr /I /C:"UnixTools-4-Win" >nul 2>&1
Set AddUnixTools=%ErrorLevel%

:: Check if this is PB or SB
If Exist %PUREBASIC_HOME%\Compilers\pbcompiler.exe (
    If [%AddUnixTools%] == [1] Call :AddUnixTools
    Goto Configure_purebasic
) Else (
    If Exist %PUREBASIC_HOME%\Compilers\sbcompiler.exe (
        If [%AddUnixTools%] == [1] Call :AddUnixTools
        Goto Configure_spiderbasic
    )
)

Call :ErrorMsg "Failed to detect PB or SB compiler in %PUREBASIC_HOME%"


:AddUnixTools
If Not Exist "%~dp0UnixTools-4-Win\make.exe" (
    If Not Exist "%~dp0UnixTools-4-Win.zip" (
        Echo.
        Echo --------------------------------------------------------------------------------------
        Echo Download UnixTools-4-Win
        Echo --------------------------------------------------------------------------------------
        Start /B /Wait Bitsadmin.exe /Transfer "Download UnixTools-4-Win" /Download https://github.com/fantaisie-software/purebasic/wiki/UnixTools-4-Win.zip "%~dp0UnixTools-4-Win.zip"
        Cls
    )
    Call :UnZipFile "%~dp0" "%~dp0UnixTools-4-Win.zip"
)


If Exist "%~dp0UnixTools-4-Win\make.exe" (
    Set PATH=%~dp0UnixTools-4-Win;%PATH%
) Else (
    Call :ErrorMsg "make.exe was not found in UnixTools-4-Win sub-folder"
)
Goto :Eof

:UnZipFile <ExtractTo> <Zipfile>
Set vbs="%temp%\_UnZipFile.vbs"
If Exist %vbs% Del /f /q %vbs%
>%vbs%  Echo Set Fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% Echo If Not Fso.FolderExists(%1) Then
>>%vbs% Echo Fso.CreateFolder(%1)
>>%vbs% Echo End If
>>%vbs% Echo Set ObjShell = CreateObject("Shell.Application")
>>%vbs% Echo Set FilesInZip=ObjShell.NameSpace(%2).Items
>>%vbs% Echo ObjShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% Echo Set Fso = Nothing
>>%vbs% Echo Set ObjShell = Nothing
Cscript //Nologo %vbs%
If Exist %vbs% Del /f /q %vbs%
Goto :Eof

:ErrorMsg
:: Displays an error message and waits 5s before exiting to have time to read the message
Echo %~1
Ping -n 4 127.0.0.1 > nul
Exit 1
    
:Configure_purebasic
Set PB_JAVASCRIPT=

:: Detect processor architecture used by the compiler
%PUREBASIC_HOME%\Compilers\pbcompiler.exe /version | Findstr /C:"(Windows - x64)" 1>nul

If %ErrorLevel% Equ 0 (
    Set PB_PROCESSOR=X64
) Else (
    Set PB_PROCESSOR=X86
)
Echo.
Echo --------------------------------------------------------------------------------------
Echo Setting environment for PureBasic %PB_PROCESSOR% in %PUREBASIC_HOME%
Echo --------------------------------------------------------------------------------------
Echo.

Goto Configure_common

:Configure_spiderbasic
Set PB_JAVASCRIPT=1
Echo.
Echo --------------------------------------------------------------------------------------
Echo Setting environment for SpiderBasic in %PUREBASIC_HOME%
Echo --------------------------------------------------------------------------------------
Echo.

Goto Configure_common

:Configure_common
:: There should be no need to modify these:
Set PB_WINDOWS=1
Set PB_SUBSYSTEM=purelibraries/

:: Open command shell unless we are in batch mode:
If Defined PB_BATCH Goto End
Cd %~dp0PureBasicIDE

If [%OPTION%] Equ [] Echo Type "Make" to build the IDE or type "Make Debug" to create a debug version & Echo. 

If [%OPTION%] Equ [Make] (
    Make
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
)

If [%OPTION%] Equ [MakeDebug] (
    Make Debug
    Echo.
    Echo --------------------------------------------------------------------------------------
    If Exist "%PUREBASIC_HOME%\PureBasic.exe" (
        Echo PureBasic.exe Debug version Successfully Created in %PUREBASIC_HOME%
    ) else (
        Echo Purebasic.exe Debug version Compilation Failure! 
    )
    Echo --------------------------------------------------------------------------------------
    Echo Exiting... & Ping -n 9 127.0.0.1 > nul
    ::Pause
    Exit
)
::Cmd

:End
