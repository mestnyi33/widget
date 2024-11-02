EnableExplicit

;Windows
Enumeration
  #TBW        = 0
EndEnumeration
;Gadgets
Enumeration
  #Text1
  #Button1
  #extra_status
  #progress
EndEnumeration
#lh         = 24
#gap        = 4
#WWidth     = 350
#WHeight    = 140

#TB_Building_DLL = 1
#TB_Enable_Progress = 1

Procedure.s w(var)
  If var 
    ProcedureReturn PeekS(var, -1, #PB_Unicode)
  Else
    ProcedureReturn ""
  EndIf 
EndProcedure

Global tb_result.i

XIncludeFile "Tailbite_Res.pb"
XIncludeFile "Inc_Language.pb"  ; No WinAPI
CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    XIncludeFile "Inc_OS_Win.pb" ; WinAPI
  CompilerCase #PB_OS_Linux
    XIncludeFile "Inc_OS_Linux.pb"
  CompilerCase #PB_OS_MacOS
    XIncludeFile "Inc_OS_MacOsX.pb"
CompilerEndSelect
XIncludeFile "Inc_Parameter.pb" ; No WinAPI
XIncludeFile "Inc_Misc.pb"      ; No WinAPI
XIncludeFile "Inc_Prefs.pb"     ; No WinAPI
XIncludeFile "Inc_Compiler.pb"  ; No WinAPI
XIncludeFile "Inc_Tailbite.pb"  ; WinAPI

;ProcedureDLL AttachProcess(Instance)
  ;
;EndProcedure

ProcedureDLL TailBite_Init(FolderPB.s, FolderTB.s, FolderLibSource.s, LanguageName.s, LogF.i);Initialise things that would normally be loaded from the prefs file
  Protected Text$
  OnErrorCall(@ErrorHook())
  If LogF : WriteLogfile = 1 : EndIf

  If Right(FolderPB, 1) <> #DirSeparator
    PBFolder$ = FolderPB+#DirSeparator
  Else
    PBFolder$ = FolderPB
  EndIf
  PBCompilerFolder$=PBFolder$+"compilers"+#DirSeparator
  CheckPBVersion()
  If Right(FolderTB, 1)<>#DirSeparator
    TBFolder$ = FolderTB+#DirSeparator
  Else
    TBFolder$ = FolderTB
  EndIf
  If Right(FolderLibSource, 1)<> #DirSeparator
    LibSourceFolder$ = FolderLibSource+#DirSeparator
  Else
    LibSourceFolder$ = FolderLibSource
  EndIf
  CreatePath(LibSourceFolder$)
  If LanguageName <> "" 
    Language$ = LanguageName
    LoadLanguage(TBFolder$+"Catalogs"+#DirSeparator+Language$+".catalog")
  EndIf
  
  TBTempPath$ = GetTemporaryDirectory()+"TBTemp"+#DirSeparator
  CreatePath(TBTempPath$)
  
  If PBnbVersion > 402
    pb_align$ = "pb_align"
    pb_bssalign$ = "pb_bssalign"
    If PBVersionX64
      LibraryMakerOptions$ = " /NOUNICODEWARNING" ; /COMPRESSED not working in X64 !
    Else
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        LibraryMakerOptions$ = " /COMPRESSED /NOUNICODEWARNING"
      CompilerElse
        LibraryMakerOptions$ = " /NOUNICODEWARNING";compressed not supported on linux
      CompilerEndIf
    EndIf
    IsPB410 = #True
    If PBnbVersion >= 420 ;- gnozal PB4.20 fix
      IsPB420 = #True
      If PBnbVersion >= 430
        
      Else
        pb_align$ = "align"
        pb_bssalign$ = "align"
      EndIf
    EndIf
  Else
    PBPreferencesPath$ = PBFolder$
    pb_align$ = "align"
    pb_bssalign$ = "bssalign"
    LibraryMakerOptions$ = " /COMPRESSED"
    IsPB410 = #False
    IsPB420 = #False
  EndIf
  
  Define  dontdolibmakersearch.l; if set, library maker found in expected location (pb4.30), and no search needs to be done (faster startup) - lexvictory 13/02/09
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    #libmaker = "LibraryMaker"
    If FileSize(PBFolder$+"\SDK\"+#libmaker+".exe") > 0
      dontdolibmakersearch = 1
      LibraryMaker$ = PBFolder$+"\SDK\"+#libmaker+".exe"
    EndIf
  CompilerElse
    #libmaker = "pblibrarymaker"
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      If FileSize(PBFolder$+"/compilers/"+#libmaker) > 0
        dontdolibmakersearch = 1
        LibraryMaker$ = PBFolder$+"/compilers/"+#libmaker
      EndIf
    CompilerElse
      If FileSize(PBFolder$+"compilers/x86/"+#libmaker) > 0;powerpc unsupported currently
        dontdolibmakersearch = 1
        LibraryMaker$ = PBFolder$+"compilers/x86/"+#libmaker
      EndIf
    CompilerEndIf
  CompilerEndIf
  If dontdolibmakersearch = 0
    LibraryMaker$=SearchDirectory(PBFolder$,#libmaker+#SystemExeExt,#PB_String_NoCase)
  EndIf 
  
  WriteLog("OSVersion()="+Str(OSVersion()))
  WriteLog(ProgramFilename())
  If PBVersionX64
    WriteLog("PureBasic Version found : "+PBVersion$+" / "+Str(PBnbVersion)+" /X64")
  Else
    WriteLog("PureBasic Version found : "+PBVersion$+" / "+Str(PBnbVersion)+" /X86")
  EndIf
  WriteLog("PBCompilerFolder$="+PBCompilerFolder$)
  WriteLog("PBFolder$="+PBFolder$)
  WriteLog("TBFolder$="+TBFolder$)
  WriteLog("LibSourceFolder$="+LibSourceFolder$)
  WriteLog("Language$="+Language$)
  WriteLog("TBTempPath$="+TBTempPath$)
  WriteLog("pb_align$="+pb_align$)
  WriteLog("pb_bssalign$="+pb_bssalign$)
  WriteLog("LibraryMakerOptions$="+LibraryMakerOptions$)
  WriteLog("IsPB410="+Str(IsPB410))
  WriteLog("LibraryMaker$="+LibraryMaker$)
  
  If PBnbVersion=0 ; PureBasic Version could not be identyfied
    If #TB_Installer=0 ; Ignore PB-Version only in install-mode
      If FileSize(PBCompilerFolder$+"pbcompiler"+#SystemExeExt)=-1
        Text$=Language("TailBite", "SorryNeedPBCompiler")+Chr(10)+PBCompilerFolder$+"pbcompiler"+#SystemExeExt+Chr(10)
        TBError(Text$, 0, "", #False)
        OnErrorDefault()
        ProcedureReturn 0
      Else
        Text$=Language("TailBite", "Version")
        Text$=ReplaceString(Text$,"%pbcompiler%",PBCompilerFolder$+"pbcompiler"+#SystemExeExt)
        Text$=ReplaceString(Text$,"%version%",PBVersion$+"/"+Str(PBnbVersion))
        TBError(Text$, 0, "", #False)
        OnErrorDefault()
        ProcedureReturn 0
      EndIf
    EndIf
  ElseIf PBnbVersion < 400
    Text$=ReplaceString(Language("TailBite", "PB4XXWarning"),"%version%",PBVersion$)
    TBError(Text$, 0, "", #False)
    ProcedureReturn 0
  EndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Libexe$ = PBCompilerFolder$+"polib.exe"
    LibexeBaseName$ = "polib"
    WriteLog("Libexe$="+Libexe$)
    WriteLog("LibexeBaseName$="+LibexeBaseName$)
    If DontMakeLib = 0
      If FileSize(Libexe$)=-1
        TBError(Language("TailBite","SorryNeedPolib"),0,"",#False)
        ProcedureReturn 0
      EndIf
    EndIf
  CompilerElse
    Libexe$ = "ar"
    LibexeBaseName$ = "ar"
    WriteLog("Libexe$="+Libexe$)
    WriteLog("LibexeBaseName$="+LibexeBaseName$)
  CompilerEndIf
  
  OnErrorDefault()
  ProcedureReturn 1;we must be successful at this stage
EndProcedure

ProcedureDLL TailBite_InitW(FolderPB.i, FolderTB.i, FolderLibSource.i, LanguageName.i, LogF.i);created due to bugs with p-ascii
  ProcedureReturn TailBite_Init(w(FolderPB), w(FolderTB), w(FolderLibSource), w(LanguageName), LogF)
EndProcedure

ProcedureDLL TailBite_It(Keep.i, Askd.i,  Dont.i, Writ.i, Thrd.i, Ucod.i, Mult.i, parentwindow, Outp.s, Libn.s, Subsys.s, filename.s);parameters are like the command line options
  Protected Output.l,CancelText$,CancelWidth.l,EventID.l;for event loop stuff
  OnErrorCall(@ErrorHook())
  ;reset variables from previous runs!
  tb_result = 0
  quit = 0
  KeepSrcFiles = 0
  WriteLogfile = 0
  AskDelete = 0
  DontMakeLib = 0
  WriteBatch = 0
  UseThreadOption = 0
  UseUnicodeOption = 0
  MultiLib = 0
  TBLibname$ = ""
  UseSubsystem = 0
  PBSubsystem$ = ""
  PBUserLibraryFolder$  = Userlibdir$
  If keep : KeepSrcFiles = 1 : WriteLogfile = 1 : EndIf
  If Askd : AskDelete = 1 : EndIf
  If Dont : DontMakeLib = 1 : EndIf
  If Writ : WriteBatch = 1 : EndIf
  If Thrd : UseThreadOption = 1 : EndIf
  If Ucod : UseUnicodeOption = 1 : EndIf
  If Mult
    MultiLib = 1
    UseUnicodeOption = 0;safeguard
    UseThreadOption = 0
  EndIf
  If Libn <> ""
    TBLibname$ = Libn
  EndIf
  If Len(Trim(subsys)) >0
    ;MessageRequester("subs", #DQUOTE$+subsys+#DQUOTE$)
    PBUserLibraryFolder$=Subsys
    If UCase(PBUserLibraryFolder$)=UCase(Userlibdir$)
      UseSubsystem    = 0
    Else
      UseSubsystem    = 1
      PBSubsystem$    = StringField(PBUserLibraryFolder$,2,#DirSeparator)
      If PBSubsystem$<>""
        If FileSize(PBFolder$+PBUserLibraryFolder$)<>-2 ; if folder don´t exist create it
          If CreatePath(PBFolder$+PBUserLibraryFolder$)=0
            TBError(PBFolder$+PBUserLibraryFolder$,0,"")
            ProcedureReturn 0
          EndIf
        EndIf
      Else
        TBError(ReplaceString(Language("TailBite","SubSystemWrong"),"%subsystem%",Parameter()),0,"")
        ProcedureReturn 0
      EndIf
    EndIf
  EndIf
  
  PBSourceFile$ = filename;filename MUST be validated in calling program
  
;-start main execution  
CancelText$ = Language("TailBite","Cancel")
If QuietMode=0
  If OpenWindow(#TBW, 0, 0, #WWidth, #WHeight, "TailBite "+Version$, #PB_Window_ScreenCentered|#PB_Window_TitleBar, parentwindow)=0
    TBError(Language("TailBite","WindowError"), 0, "")
    QuietMode = 1
  EndIf 
  If QuietMode=0
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      CancelWidth = 50
    CompilerElse
      If StartDrawing(WindowOutput(#TBW))
        CancelWidth = TextWidth(CancelText$)+10
        StopDrawing()
      EndIf
    CompilerEndIf
    If QuietMode=0
      TextGadget(#Text1, #gap, #gap*3, #WWidth-(#gap*2)-CancelWidth, #WHeight-(#gap*31), Language("TailBite","Starting"))
      TextGadget(#extra_status, #gap, #gap*3+#WHeight-(#gap*31), #WWidth-(#gap*2)-CancelWidth, #WHeight-(#gap*8), "")
      SetExtrastatustext()
      ButtonGadget(#Button1, #WWidth-#gap-CancelWidth, #WHeight/2-25, CancelWidth, 50, CancelText$)
      CompilerIf Defined(TB_Enable_Progress, #PB_Constant)
      CompilerIf #TB_Enable_Progress = 1
        ResizeWindow(#TBW, #PB_Ignore, #PB_Ignore, #PB_Ignore, #WHeight+20+#gap)
        ProgressBarGadgetExtended(#progress, #gap, #WHeight, #WWidth-#gap*2, 20,parentwindow)
        ProgressBarSetIndeterminate(#progress, 1)
      CompilerEndIf
      CompilerEndIf
    EndIf
  EndIf
EndIf

;{ Create Working Temporary Path
    TBTempPath$ = GetTemporaryDirectory()+"TBTemp"+#DirSeparator
    TBTempPath$+Hex(Random(#MAXLONG)+(Random(#MAXLONG)<<32),#PB_Quad)+#DirSeparator
    CreatePath(TBTempPath$)
  ;}

ThID = CreateThread(@MainProc(), @PBSourceFile$)

If QuietMode=0
  Repeat
    EventID = WaitWindowEvent(50)
    If EventID=0
      If Not IsThread(ThID)
        Quit=1
      EndIf
    ElseIf EventID=#PB_Event_Gadget And EventGadget()=#Button1
      PauseThread(ThID)
      SetGadgetText(0, Language("TailBite","Canceling"))
      If ResidentFile
        If FileSize(PBFolder$+"Residents"+#DirSeparator+OrigLibName$)=-1
          If FileSize(TBDestFolder$+OrigLibName$)<>-1
            If TBOutputpath$<>""
              CopyFile(TBDestFolder$+OrigLibName$, TBOutputpath$+OrigLibName$)
            Else
              CopyFile(TBDestFolder$+OrigLibName$, PBFolder$+PBUserLibraryFolder$+OrigLibName$)
            EndIf
            DeleteFile(TBDestFolder$+OrigLibName$)
          EndIf
        EndIf
      Else
        If FileSize(PBFolder$+PBUserLibraryFolder$+OrigLibName$)=-1
          If FileSize(TBDestFolder$+OrigLibName$)<>-1
            If TBOutputpath$<>""
              CopyFile(TBDestFolder$+OrigLibName$, TBOutputpath$+OrigLibName$)
            Else
              CopyFile(TBDestFolder$+OrigLibName$, PBFolder$+PBUserLibraryFolder$+OrigLibName$)
            EndIf
            DeleteFile(TBDestFolder$+OrigLibName$)
          EndIf
        EndIf
      EndIf
      Quit = 1
    EndIf
  Until Quit=1
  CompilerIf Defined(TB_Enable_Progress, #PB_Constant)
  CompilerIf #TB_Enable_Progress = 1
    ProgressBarSetState(#progress, -1);take away progress bar on taskbar button
  CompilerEndIf
  CompilerEndIf
  ;MessageRequester("", "Quitting")
  If IsThread(ThID)
    KillThread(ThID)
  EndIf 
Else
  WaitThread(ThID)
EndIf

If recover ; on failure copy back saved lib
  CopyFile(tmplibfile$,oldlibfile$)
  DeleteFile(tmplibfile$)
  recover=0
EndIf

DeleteDirectory(TBTempPath$,"",#PB_FileSystem_Recursive|#PB_FileSystem_Force)
;MessageRequester("", TBTempPath$)
CloseWindow(#TBW)
OnErrorDefault()
ProcedureReturn tb_result
EndProcedure

ProcedureDLL TailBite_ItW(Keep.i, Askd.i,  Dont.i, Writ.i, Thrd.i, Ucod.i, Mult.i, parentwindow, Outp.i, Libn.i, Subsys.i, filename.i);created due to bugs with p-ascii
  ProcedureReturn TailBite_It(Keep, Askd, Dont, Writ, Thrd, Ucod, Mult, parentwindow, w(Outp), w(Libn), w(Subsys), w(filename))
EndProcedure

  ;Debug TailBite_Init(#PB_Compiler_Home, "C:\Documents and Settings\lex.XANDER\My Documents\pb\TailBite\tailbite-svn\", "C:\Documents and Settings\lex.XANDER\My Documents\TailBite Library Sources", "Italiano", 1)
  ;TailBite_It(1,0,0,0,0,0,1,"", "", "", "C:\Documents and Settings\lex.XANDER\My Documents\pb\TailBite\tb_tests\floatAndDouble.pb", 0)

; IDE Options = PureBasic 5.40 LTS Beta 1 (Windows - x64)
; ExecutableFormat = Shared Dll
; CursorPosition = 86
; FirstLine = 68
; Folding = ---
; EnableThread
; EnableXP
; EnableOnError
; Executable = ..\..\duplicapbe\TailBite.dll
; IncludeVersionInfo
; VersionField0 = 1,4,0,0
; VersionField1 = 1,4,0,0
; VersionField2 = Lexvictory
; VersionField3 = TailBite DLL Compile
; VersionField4 = 1.4.0
; VersionField5 = 1.4.0
; VersionField6 = DLL to allow direct TailBite integration
; VersionField7 = TailBite.dll
; VersionField8 = %EXECUTABLE