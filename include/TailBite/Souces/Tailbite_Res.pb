;{ Structures
  ;=====Main
  Structure SK
    StructureUnion
      b.b
      w.w
      l.l
      i.i
    EndStructureUnion
  EndStructure
  Structure LibFunction
    ID.l
    Name$
    ProcedureFullLine$
    PlainName$
    Args$
    nArgs.l
    maxArgs.l
    HelpLine$
    RetValue$
    DLLFunction.l
    Main.l
    DebugFunction.l
    nModifiers.l
    Modifiers$
    FIndex.l
    VarArgs$
    VarArgStr$
    VarHelpStr$
    floatreturnfound.l

  EndStructure
  Structure ImportFunction
    Name$
    NewName$
    LibPath$
    RetValue$
    HelpLine$
    Args$
    Type$
  EndStructure
  Structure ExternLib
    Name$
    FullPath$
    Type$
    nFunctions.l
    nocompile.l
  EndStructure
  Structure LabelStructure
    LabelName.s
    FunctionName.s
  EndStructure
  ;=====Inc_Language
  Structure LanguageGroup
    Name$ 
    GroupStart.l 
    GroupEnd.l 
    IndexTable.l[256] 
  EndStructure 

;}

;{ Linked Lists
  Global NewList ImportLib.ExternLib()
  Global NewList ImportFunction.ImportFunction()
  Global NewList Arg.s()
  Global NewList function.LibFunction()
  Global NewList function2.LibFunction()
  Global NewList PBLib.s()
  Global NewList ApiFunction.s()
  Global NewList DLLList.s()
  Global NewList External.s()
  Global NewList Label.LabelStructure()
  Global NewList Parameter.s()
  Global NewList Labels_Define.LabelStructure()
  ;=====Inc_Misc
  ; FileList
  Global NewList DirList.s()
  Global NewList FileList.s()
;}

;{ Globals
  ;=====Main
  ; String
  Global TBDestFolder$, LibName$, OrigLibName$, HelpName$, Libexe$, LibexeBaseName$, ChmName$, TBOutputpath$, TBLibname$,GadgetExtension$,TBDebugger$
  ; Long
  Global SetChmName, AskDelete, DontMakeLib, KeepSrcFiles, WriteBatch, QuietMode, OldButtonProc, ReLaunchFile, hParent, ResidentFile
  Global EndInclude, ThID, Quit, AddTB_GadgetExtension, AddTB_Debugger, AddTB_ImagePlugin
  Global UseThreadOption, UseUnicodeOption, MultiLib, UseUserPrefsFile
  
  ;=====Inc_Language
  Global NbLanguageGroups, NbLanguageStrings 
  
  ;=====Inc_Prefs
  Global PBFolder$, TBFolder$, TBPreferencesPath$, TBPrefsFile$, LibSourceFolder$, PBSourceFile$, PBSubsystem$, Userlibdir$
  Global PBUserLibraryFolder$, Userlibdir$, PBSubsystem$, Language$, LastFile$, Version$
  Global PBCompilerFolder$, PBVersion$, PBPreferencesPath$, TBTempPath$, PBVersionX64
  Global IsPB410, IsPB420, IsPB510, pb_align$, pb_bssalign$, LibraryMaker$, LibraryMakerOptions$
  Global Batch_options, UseSubsystem, Batch_threads, PBnbVersion, ManagerOnTop
  ;=====Inc_Misc 
  ; Log
  Global WriteLogfile
  Global TailBiteLogFile.s
  ;=====Inc_Parameter
  Global SourceExists.l
  ;=====Inc_PBCompiler
  Global PureOk$, PureResOk$
  PureOk$     = "- Feel the ..PuRe.. Power -"
  PureResOk$  = " created."
;}

;{ DataSections
  DataSection
    Language:
      Data$ "_GROUP_",            "TailBite";{
      Data$ "BuildAPIList",       "Building API-List..."
      Data$ "Cancel",             "Cancel"
      Data$ "Canceling",          "Cancelling..."
      Data$ "CannotfindPBAsm",    "Can't find PureBasic.asm in"
      Data$ "ChooseHelp",         "Library help file (*.chm) Or directory (*.html;*.htm)"
      Data$ "CompilingAsm",       "Compiling asm code..."
      Data$ "CompilingLib",       "Compiling lib file..."
      Data$ "CopySourceFiles",    "Copying source files..."
      Data$ "CreateFuncList",     "Creating function list..."
      Data$ "CreateRes",          "Creating resident file..."
      Data$ "Error",              "ERROR"
      Data$ "FileEndErr1",        "File end reached, ' ' not found"
      Data$ "FileEndErr2",        "File end reached, '(' not found"
      Data$ "FileEndErr3",        "File end reached, ')' not found"
      Data$ "FileEndErr4",        "Procedure end not found. One-line procedure?"
      Data$ "FileFormatError",    "TailBite only supports the following sourcefile formats :%newline%ASCII / UTF8 / Unicode"
      Data$ "GadgetError",        "Can't create gadgets."
      Data$ "LibExist",           "User library already exists.%newline%Overwrite : '%libname%' ?"
      Data$ "LibExist2",          "User library already exists in subsystem folder.%newline%%newline%'%libname%'%newline%%newline%Yes deletes the file / No exit TailBite ?"
      Data$ "LibraryMaker",       "Library Maker:"
      Data$ "MakingLib",          "Making PB library..."
      Data$ "NewName",            "New library name:"
      Data$ "NoAsmFile",          "TailBite can only make libraries from ASM files."
      Data$ "NotFound",           "Not found."
      Data$ "OpeningPB",          "Opening PB %version% asm source..."
      Data$ "PB4XXWarning",       "This Tailbite build is for PB4.xx only !%newline%PBCompiler reports V%version%"
      Data$ "ResExist",           "resident file already exists. Overwrite?"
      Data$ "RestartCompiler",    "Restarting compiler..."
      Data$ "SubSystemWrong",     "Specified Subsystem is wrong :%subsystem%%newline%%newline%Example : /SUBS:SubSystems\UserLibThreadSafe\PureLibraries\UserLibraries\"
      Data$ "SorryNeedPB",        "Sorry, you need PureBasic to use TailBite."
      Data$ "SorryNeedPolib",     "Sorry, you need polib.exe to make PureLibraries with TailBite."
      Data$ "SorryNeedPBCompiler","Sorry, you need PBCompiler.exe to make PureLibraries with TailBite."
      Data$ "Splitting",          "Splitting functions..."
      Data$ "Starting",           "Starting TailBite..."
      Data$ "TryInvisibleMode",   "Trying invisible mode."
      Data$ "UnknownFunction",    "Unknown Windows API function:"
      Data$ "Usage",              "Usage:%newline%TailBite.exe <sourcefile.pb> </options>%newline%Launch TailBite Manager?"
      Data$ "Version",            "The version of your PureBasic installation could not be identyfied :%newline%%pbcompiler% reported version %version%"
      Data$ "Warning",            "TailBite Warning"
      Data$ "Warning2",           "Warning: unable To create file"
      Data$ "WindowError",        "Can't create window. Trying invisible mode."
      Data$ "Wrapping",           "Wrapping static lib to PB lib..."
      Data$ "CompileThrd",        "Compiling Threadsafe Lib"
      Data$ "CompileUcod",        "Compiling Unicode Lib"
      Data$ "CompileThrdUcod",    "Compiling Threadsafe+Unicode Lib"
      Data$ "PBVersion",      "PB Version:"
      Data$ "SourceFile",      "Source file:";}
      Data$ "_GROUP_",            "TBManager";{
      Data$ "AsmFolder",          "Asm source files folder:"
      Data$ "Addjob",             "+ Add job"
      Data$ "BatchFile",          "Generate build batch file."
      Data$ "Batchoptions",       "Batch options"
      Data$ "Browse",             "Browse"
      Data$ "CheckErrors",        "Check For errors"
      Data$ "CheckUpdates",       "Check For updates"
      Data$ "Deletejob",          "- Delete job"
      Data$ "DontBuildLib",       "Don't build library, only source files."
      Data$ "Error",              "Can't run TailBite.exe."
      Data$ "Exit",               "Exit"
      Data$ "Extensions",         "PB File (*.pb,*.pbi)|*.pb;*.pbi|Desc File (*.Desc)|*.Desc|All files (*.*)|*.*"
      Data$ "ExtractTBSources",   "Extract TailBite sources"
      Data$ "Folders",            "Folders"
      Data$ "Help",               "Help"
      Data$ "HideWindow",         "Hide TailBite window."
      Data$ "HotKey",             "PureBasic menu hot key:"
      Data$ "Jobfilename",        "JOB-Filename"
      Data$ "KeepSources",        "Keep source files after making the library."
      Data$ "LibrarySubsystem",   "Library subsystem"
      Data$ "NoError",            "PBCompiler reported no errors."
      Data$ "NoFile",             "No file selected for PBCompiler"
      Data$ "None",               "None"
      Data$ "Options",            "Command line options"
      Data$ "PBFolder",           "PureBasic folder:"
      Data$ "PickCurrent",        "Pick current"
      Data$ "PromptConfirm",      "Prompt confirm on deletion of previous library with the same name."
      Data$ "Run",                "Run"
      Data$ "Save",               "Save"
      Data$ "SelectFile",         "Select source file:"
      Data$ "SelectPBFolder",     "Select PureBasic folder"
      Data$ "SelectSourceFolder", "Select library sources folder"
      Data$ "Stayontop",          "Stay on top"
      Data$ "TailBiteIt",         "TailBite it!"
      Data$ "TBFolder",           "TailBite folder:"
      Data$ "TBSourcePack",       "TailBite source pack"
      Data$ "TBSourcePack2",      "TailBite source pack file name must be 'src.pack'."
      Data$ "TBSourcePack3",      "Select a folder to unpack the TailBite source files"
      Data$ "TBSourcePack4",      "Invalid TailBite source pack file."
      Data$ "TBUpdaterError",     "Can't create TBUpdater pack."
      Data$ "TBUpdaterError2",    "Can't create TBUpdater."
      Data$ "TBUpdaterError3",    "Can't open TBUpdater pack."
      Data$ "Threads",            "Threads:"
      Data$ "ThreadOption",       "Threadsafe Option"
      Data$ "UnicodeOption",      "Unicode Option"
      Data$ "MultiLibOption",     "MultiLib Option"
      Data$ "Version",            "TailBite %version% console"
      Data$ "WindowError",        "Can't create window.";}
      Data$ "_GROUP_",            "TBError";{
      Data$ "Error",              "TailBite Error";}
      Data$ "_GROUP_",            "TBUpdater";{
      Data$ "Buffer",             "Allocating buffer..."
      Data$ "Cancel",             "Cancel"
      Data$ "Cancel2",            "Cancelling..."
      Data$ "CheckPack",          "Checking TailBite Update Pack version"
      Data$ "Checking",           "Checking For updates in"
      Data$ "Connect",            "Connecting To Internet..."
      Data$ "Downloading",        "Downloading TailBite V %version% Update Pack%newline%%bytes% of %size%"
      Data$ "DownloadingFrom",    "Downloading from"
      Data$ "Error",              "TBUpdater Error"
      Data$ "Failed",             "failed."
      Data$ "GadgetError",        "Can't create gadgets."
      Data$ "HttpOpen",           "Http open request to"
      Data$ "HttpQueryError",     "Http query failed."
      Data$ "HttpSend",           "Http send request to"
      Data$ "InstAbort",          "Installation aborted."
      Data$ "InvalidPack",        "Invalid update pack."
      Data$ "NoConnection",       "Internet connection Not available."
      Data$ "NoUpdates",          "No updates available in these links:"
      Data$ "Ok",                 "Ok"
      Data$ "PBError",            "Sorry, you need PureBasic To update TailBite."
      Data$ "Proceed",            "Current installation will be lost. Proceed anyway?"
      Data$ "SelectPBFolder",     "Please select the PureBasic folder"
      Data$ "Starting",           "Starting TBUpdater..."
      Data$ "StatusError",        "Status code query failed.%newline%Error %error% !"
      Data$ "Success",            "Installation successful: unpacked %maxfiles% files."
      Data$ "TempError",          "Unable To create temporary file."
      Data$ "UnableError",        "Unable to connect to"
      Data$ "UnpackFiles",        "Unpacking files:"
      Data$ "UnpackFiles2",       "Unpacking files: %filename%%newline%%filenr% of %maxfiles%"
      Data$ "UpdateError",        "Update download failed."
      Data$ "Warning",            "Warning"
      Data$ "SameVersion",        "The version (%version2%) of TailBite you're about to install is the same as the current (%version1%).%newline%Current installation will be lost. Proceed anyway?"
      Data$ "OlderVersion",       "The version (%version2%) of TailBite you're about to install is older than the current (%version1%).%newline%Current installation will be lost. Proceed anyway?"
      Data$ "NewVersion",         "The version (%version2%) of TailBite you're about to install is newer than the current (%version1%).%newline%Current installation will be lost. Proceed anyway?"
      Data$ "WindowError",        "Can't create window.";}
      Data$ "_GROUP_",            "TBInstaller";{
      Data$ "Agree",              "I agree"
      Data$ "Browse",             "Browse"
      Data$ "Cancel",             "Cancel"
      Data$ "Created",            "The above files And folders will be created."
      Data$ "Error1",             "PureBasic directory does Not exist. Installation failed."
      Data$ "Error2",             "Unable to create temporary file. Installation failed."
      Data$ "Error3",             "Unable To open temporary installation file. Installation failed."
      Data$ "Error4",             "Invalid installation pack file. Installation failed."
      Data$ "Finish",             "Finish"
      Data$ "Install",            "Install"
      Data$ "Installing",         "Installing TailBite..."
      Data$ "Language",           "Language:"
      Data$ "Launch",             "Launch TailBite Manager."
      Data$ "Next",               "Next >"
      Data$ "PBFolder",           "PureBasic folder:"
      Data$ "Readme",             "View the README file."
      Data$ "ReadmeErr",          "Can't open the README file."
      Data$ "SelectPBFolder",     "Select PureBasic folder"
      Data$ "SelectTBFolder",     "Select TailBite installation folder"
      Data$ "Success",            "TailBite has been successfully installed."
      Data$ "TBFolder",           "TailBite installation folder:"
      Data$ "Version",            "TailBite Installer V %version%";}
      Data$ "_GROUP_",            "TBInstallerBuild";{
      Data$ "TempError",          "Error creating temporary directory !"
      Data$ "TempCopySrc",        "Error copying sourcefiles to temporary directory !"
      Data$ "CopySourcesToTemp",  "Copying sources into temporary directory..."
      Data$ "CompilingSources",   "Compiling sources..."
      Data$ "CompilingHelpLibs",  "Compiling helper libraries..."
      Data$ "CompilingHelp",      "Compiling help file..."
      Data$ "BuildVersion",       "Build Version:"
      Data$ "BuildExe",           "Build TailBite_Installer.exe"
      Data$ "BuildPack",          "Build TailBite.pack"
      Data$ "BuildSources",       "Build PB sources"
      Data$ "BuildHelpLibs",      "Build helper libraries"
      Data$ "BuildHelp",          "Build help file"
      Data$ "Build",              "Build"
      Data$ "BuildDir",           "Build directory"
      Data$ "BuildPath",          "Select build path"
      Data$ "PathError",          "Please, Select a build path"
      Data$ "Install",            "Install TailBite?"
      Data$ "CreatingPack",       "Creating TailBite.pack..."
      Data$ "CreatingSrcPack",    "Creating src.pack..."
      Data$ "Restoring",          "Restoring original html files..."
      Data$ "Checking",           "Checking TailBite.pack integrity..."
      Data$ "CheckingReport",     "TailBite %version% (%nfiles1% files)%newline%%newline%Folders:%newline%%dirs%%newline%Files:%newline%%files%%newline%Number of files checked: %nfiles2%"
      Data$ "ErrorPack",          "Can't open packed file."
      Data$ "CompilingInstaller", "Compiling TailBite_Installer..."
      Data$ "InternetOpenError",  "Unable to open internet connection !"
      Data$ "Connecting",         "Connecting to %server%"
      Data$ "ServerError",        "Unable connect to %server%"
      Data$ "ServerCHDir",        "Changing To %folder% folder..."
      Data$ "ServerCHDirErr",     "Unable To set remote directory in %server%"
      Data$ "Uploading",          "Uploading %uploadlist% to %server%"
      Data$ "UploadErr",          "Unable to upload %uploadlist% to %server%";}
      Data$ "_GROUP_",            "TBCommon";{
      Data$ "Error",              "Error"
      Data$ "LineNr",             "Line:%linenr%%newline%Exit program?";}
      Data$ "_GROUP_",            "TBCompiler";{
      Data$ "NoCompiler",         "Sorry, you need polib.exe Or lcclib.exe To make PureLibraries."
      Data$ "UnableToCompile",    "Unable to compile %helperlibname% helper library.%newline%%newline%%program% %filestring%%newline%%newline%%errmsg%"
      Data$ "_END_",              "";}
  VarAlias:;{
    Data.l 14
    Data.s "p_", "v_", "e_", "t_", "a_", "_S", "l_", "s_", "m_", "ap_"
    Data.s "D" ; <-D will detect Div64/DWORD/DX As Lib-Function And renames it To "FunctionName_Div64" 30.11.2006 01:23
    Data.s "F"
    Data.s "so_" ; added for static variables in PB5.20 ABBKlaus 15.07.2013 19:32
    Data.s "ll_" ; added for datas in PB5.31 MPZ 17.1.2013
    ;}
  GadgetExtension:;{
    ;IncludeBinary "TB_Gadget.asm"
  GadgetExtensionEnd:
  GadgetExtensionx64:
    ;IncludeBinary "TB_Gadgetx64.asm"
  GadgetExtensionx64End:;}
  TB_Debugger:
  TB_DebuggerEnd:
  TB_Debuggerx64:
  ;IncludeBinary "TB_Debuggerx64.asm"
  TB_Debuggerx64End:
  Version1:;{
    IncludeBinary "TailBite Installer Build.prefs"
  Version2:;}
  Modifiers:;{
  Data.l 7
  Data.s "thread"
  Data.s "unicode"
  Data.s "debug"
  Data.s "mmx"
  Data.s "3dnow"
  Data.s "sse"
  Data.s "sse2"
  ;}
  EndDataSection;}
; IDE Options = PureBasic 5.24 LTS (Windows - x86)
; CursorPosition = 317
; FirstLine = 191
; Folding = -A-