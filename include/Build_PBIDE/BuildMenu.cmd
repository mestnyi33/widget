@Echo OFF
Title Building PureBasic IDE on Windows
:: ************************************************************************
:: *                     Build the IDE on Windows                         *
:: ************************************************************************
::
:: Precondition: A PureBasic installation
:: To compile and test the tools in this repository you need a PureBasic installation. This installation is used both for compilation as well as for testing which is why the compiled IDE and debugger are directly copied into that PureBasic installation for direct testing (this will overwrite the original IDE).
:: 
:: It is therefore recommended to set aside a dedicated PureBasic directory for development with this repository. You can just copy your regular installation to a new directory for this. There is no need to install anything.
:: 
:: The following conditions should be met for this:
:: . You need write permissions to the PureBasic directory (do not use "Program Files" or similar)
:: . You should avoid spaces or special characters in the Path to that directory to avoid any trouble with the build scripts
::
:: Choose an option to build PureBasic IDE on Windows
::   with official method or with a quick and easy method, without make Unix tool 
::
:: ************************************************************************

Cd /d %~dp0

Set PUREBASIC_HOME=%~1
If [%PUREBASIC_HOME%]==[] Goto :Prompt

:: Check that pbcompiler is in the Target PureBasic Directory
If Not Exist "%PUREBASIC_HOME%\Compilers\pbcompiler.exe" Goto :prompt

:: Check if the Target PureBasic folder is writable
Copy /Y Nul "%PUREBASIC_HOME%/Tmp_FullAccess" >nul 2>&1 && set WRITEOK=1
If Defined WRITEOK ( 
  Del /q /f "%PUREBASIC_HOME%\Tmp_FullAccess"
 ) Else (
   Goto :prompt
)
Goto :MainMenu

:Prompt
Cls
Set PUREBASIC_HOME=
Echo.
Echo ======================================================================================
Echo Building PureBasic IDE on Windows
Echo.
Echo Enter, Paste or Drag and Drop the complete path to the Target PureBasic directory
Echo   ^(it must be without spaces and quotes marks ""^)
Echo ======================================================================================
Echo.
Set /p PUREBASIC_HOME= ^> Enter the Target PB directory and press "Enter": 
If [%PUREBASIC_HOME%]==[] Goto :Prompt

:: Check that pbcompiler is in the Target PureBasic Directory
If Not Exist "%PUREBASIC_HOME%\Compilers\pbcompiler.exe" Echo. & Echo PBcompiler was not found in the Target PB directory ! & Ping -n 4 127.0.0.1 > nul & Goto :prompt

:: Check if the Target PureBasic folder is writable
Copy /Y Nul "%PUREBASIC_HOME%/Tmp_FullAccess" >nul 2>&1 && set WRITEOK=1
If Defined WRITEOK ( 
    Del /q /f "%PUREBASIC_HOME%\Tmp_FullAccess"
) Else (
    Echo. & Echo The Target PureBasic folder is not writable ! & Echo Please copy paste it to another location, with Full control Permissions. & Ping -n 4 127.0.0.1 > nul & Goto :prompt
)
:: If needed, check that we are running As Admin/Elevated
:: Fsutil dirty query %systemdrive% 1>nul 2>nul
:: If %errorLevel% Neq 0 Call :GetAdmin %IsoFile% & Exit /B
Goto :MainMenu

:MainMenu
@Cls
Set Userinp=
Echo.
Echo ======================================================================================
Echo Building PureBasic IDE on Windows
Echo.
Echo Target PureBasic directory: %PUREBASIC_HOME%
Echo.
Echo.  Building  on Windows (official method):
Echo     1 - Setting environment and Build the IDE
Echo     2 - Setting environment and Build the IDE debug version
Echo     3 - Setting environment for PureBasic
Echo.
Echo   Building on Windows (quick and easy method, without make Unix tool):
Echo     4 - Compil PureBasic
Echo     5 - Compil PBdebugger
Echo.
Echo     9 - Exit
Echo ======================================================================================
Echo.
Set /p Userinp= ^> Enter your option and press "Enter": 
set Userinp=%Userinp:~0,1%
If %Userinp% Equ 9 Exit
If %Userinp% Equ 1 (Start /B /Wait BuildEnv.cmd %PUREBASIC_HOME% Make & Exit)
If %Userinp% Equ 2 (Start /B /Wait BuildEnv.cmd %PUREBASIC_HOME% MakeDebug & Exit)
If %Userinp% Equ 3 (Start /B /Wait BuildEnv.cmd %PUREBASIC_HOME%)
If %Userinp% Equ 4 (Cd PureBasicIDE & Start /B /Wait MakeWindows.cmd %PUREBASIC_HOME% & Exit) 
If %Userinp% Equ 5 (Cd PureBasicDebugger & Start /B /Wait MakeWindows.cmd %PUREBASIC_HOME% & Exit)
Goto :MainMenu

:GetAdmin
Set "Params=%*"
Set GetAdminvbs="%TEMP%\_tmp_GetAdmin.vbs"
Echo Set UAC = CreateObject^("Shell.Application"^) > %GetAdminvbs%
Echo UAC.ShellExecute "cmd.exe", "/k cd /d ""%~sdp0"" && %~s0 %Params%", "", "runas", 1 >> %GetAdminvbs%
%GetAdminvbs%
Del /Q /F %GetAdminvbs%
Exit /B
%Windir%\system32\reg.exe Query "HKU\S-1-5-19" 1>nul 2>nul || (
    Echo ============================================================
    Echo ERROR: Run the script as administrator.
    Echo ============================================================
    Echo.
    Echo.
Echo Press any key to Exit now & Pause >nul & Exit
)