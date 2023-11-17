EnableExplicit
; //////////////////////////////////////////////////////
; /        SPECIAL TAILBITE BUILD FOR JAPBE V3         /
; //////////////////////////////////////////////////////
;
; You may need some other source files from the original package
; http://www.purebasicpower.de/?download=TailBite_Installer.exe
; http://www.purebasicpower.de/?download=src.pack
;
; This line is for testing purposes only, it should be commented for normal use



;temp folder = C:\Users\KillerMP\AppData\Local\Temp\TBTemp\
;temp folder = C:\Users\Administrator\AppData\Local\Temp\TBTemp

;#TB_Testmode       = 1

;-ABBKlaus test files
;#TB_TestFile$      = "c:\Backup\Printer_Lib.pb"
;#TB_TestFile$      = "c:\Downloads\Gnozal_Test.pb"
;#TB_TestFile$      = "d:\Backup\PurePDF\PurePDF.pb"

;-MPZ test files
;#TB_TestFile$      = "g:\temp\Tailbite 1.4.11\Testlib\test_lib.pb"
;#TB_TestFile$      = "i:\temp\Tailbite 1.4.11\Testlib\test_lib.pb"

; #TB_TestFile$      = "f:\temp\MP_33\SimpleDX11_rev_50\Demos\003_Lighting\MP3D_DX11.pb"
; #TB_TestFile$      = "G:\temp\MP_33\SimpleDX11_rev_50\Demos\003_Lighting\MP3D_DX11.pb"

;#TB_TestFile$      = "C:\Program Files\PureBasic\Examples\DirectX For PB4\Source\MP3D_Library.pb"
;#TB_TestFile$      = "C:\Program Files\PureBasic\Examples\TestMe.pb"
;#TB_TestFile$      = "C:\Program Files\PureBasic\Examples\MemLib_HeapCreate.pb"
;-lexvictory test files
;#TB_TestFile$ = "C:\Users\lex\Documents\pb\TailBite\tb_tests\mpzInterfaces.pb"
;#TB_TestFile$ = "C:\Users\lex\Documents\pb\droopyslib-svn\droopy.pb"
;#TB_TestFile$ = "\\xander-laptop\Users\lex\Documents\pb\droopyslib-svn\droopy.pb"
;#TB_TestFile$ = "/root/tailbite-svn/Samples/TestLibs/sample_00.pb"
;#TB_TestFile$ = "c:\Downloads\TailBite_Labelbug.pb"
;#TB_TestSubsystem$ = "SubSystems\UserLibUnicode\PureLibraries\UserLibraries\"

;#TB_TestSubsystem$ = "SubSystems\dx9\PureLibraries\"
;#TB_TestSubsystem$ = "SubSystems\DirectX11\PureLibraries\"

;#TB_TestDontSetTBDirToSourceDir = 1
;#TB_TestUCOD       = 1
;#TB_TestTHRD       = 1
;#TB_TestDONT       = 1
;#TB_TestPref       = "C:\users\lex\documents\pb\TailBite\tailbite_svn\TailBite.prefs"

;#TB_TestMULT       = 1
#TB_TestCHM        = "Helpfile.chm"

;CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  #TB_Enable_Progress = 1; enable or disable the progress bar in the TB window, and in the windows 7 taskbar.
;CompilerEndIf

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

Define Output.l,CancelText$,CancelWidth.l,EventID.l , MyIde

;------Init
;{
  Init_Parameter()

  ;{ Load Preferences
  If TBLoadPreferences()=#False
    TBSavePreferences()
  EndIf
  ;}
  
  AddElement(Process())
  Process() = "TBUpdater"
  CompilerIf #PB_Compiler_Debugger = 0;lexvictory 20-1-11: killing with debugger seems to be able to make this proc end the program!
    RunOne("TailBite")
  CompilerEndIf
  
  ;{ Get Version of TailBite
  Version$  = PeekS(?Version1,?Version2-?Version1,#PB_Ascii)
  Version$  = RemoveString(Trim(StringField(Version$,2,"=")),#CRLF$)
  WriteLog("TailBite Version found : "+Version$)
  ;}

  ; Need a SourceFile
  If SourceExists
    PBSourceFile$ = Parameter()
    DeleteElement(Parameter())
  EndIf
  ; Need PBFolder
  If PBFolder$=""
    PBFolder$ = PathRequester(Language("TailBite","SelectPBFolder"), TBFolder$)
    If FileSize(PBFolder$)<>-2
      TBError(Language("TailBite","SorryNeedPB"),0,"",#False)
      End
    EndIf
    If Right(PBFolder$, 1)<>#DirSeparator
      PBFolder$+#DirSeparator
    EndIf
    TBSavePreferences()
  EndIf
  
  TBOutputpath$ = ""
  TBLibname$    = ""
  
  ;{ Enable/Disables/Launchs Content according to parameter
  ForEach Parameter()
    Select UCase(Left(Parameter(), 5))
      Case "/VERS"
        If OpenConsole()
          PrintN(Version$)
        EndIf
        End
      Case "/ASKD"
        AskDelete         = 1
      Case "/DONT"
        DontMakeLib       = 1
      Case "/KEEP"
        KeepSrcFiles      = 1
      Case "/QUIE"
        QuietMode         = 1
      Case "/WRIT"
        WriteBatch        = 1
      Case "/HELP"
        RunProgram(PBFolder$+"Help\TailBite.chm")
        End
      Case "/HWND"
        hParent           = Val(Right(Parameter(), Len(Parameter())-6))
      Case "/CHM:"
        SetChmName        = 1
        ChmName$ = Right(Parameter(), Len(Parameter())-5)
        If Len(#SystemHelpExt) And Right(ChmName$,Len(#SystemHelpExt)) = #SystemHelpExt
          ChmName$ = Left(ChmName$,Len(ChmName$)-Len(#SystemHelpExt))
        EndIf
      Case "/THRD" ; Gnozal
        UseThreadOption   = 1
      Case "/UCOD" ; Gnozal
        UseUnicodeOption  = 1
      Case "/OUTP" ; ABBKlaus 16.8.2007 16:33
        Output            = 1
      Case "/LIBN" ; ABBKlaus 16.8.2007 16:35
        TBLibname$        = StringField(Parameter(),2,":")
      Case "/SUBS" ; ABBKlaus 2.6.2007 02:36
        PBUserLibraryFolder$=StringField(Parameter(),2,":")
        If UCase(PBUserLibraryFolder$)=UCase(Userlibdir$)
          UseSubsystem    = 0
        Else
          UseSubsystem    = 1
          PBSubsystem$    = StringField(PBUserLibraryFolder$,2,#DirSeparator)
          If PBSubsystem$<>""
            If FileSize(PBFolder$+PBUserLibraryFolder$)<>-2 ; if folder don�t exist create it
              If CreatePath(PBFolder$+PBUserLibraryFolder$)=0
                TBError(PBFolder$+PBUserLibraryFolder$,0,"")
                End
              EndIf
            EndIf
          Else
            TBError(ReplaceString(Language("TailBite","SubSystemWrong"),"%subsystem%",Parameter()),0,"")
            End
          EndIf
        EndIf
      Case "/MULT" ; Generate library in all modes (NORMAL/UNICODE/THREADSAFE/UNICODETHREADSAFE)
        MultiLib = 1
      Default
        If Output=1
          TBOutputpath$=Parameter()
          WriteLog("/OUTP="+TBOutputpath$)
        EndIf
        Output=0
    EndSelect
  Next
  ; check for misuse of parameters when Multilib is enabled
  If MultiLib
    UseThreadOption=0
    UseUnicodeOption=0
  EndIf
  ;}
  ;{ If Source File doesn't find, ask for launching TBManager
  If SourceExists=0
    If MessageRequester("TailBite", Language("TailBite", "Usage"), #PB_MessageRequester_YesNo)=#PB_MessageRequester_Yes
      RunProgram("TBManager.exe")
    EndIf
    End
  EndIf
  ;}

  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Libexe$ = PBCompilerFolder$+"polib.exe"
    LibexeBaseName$ = "polib"
    WriteLog("Libexe$="+Libexe$)
    WriteLog("LibexeBaseName$="+LibexeBaseName$)
    If DontMakeLib = 0
      If FileSize(Libexe$)=-1
        TBError(Language("TailBite","SorryNeedPolib"),0,"",#False)
        End
      EndIf
    EndIf
  CompilerElse
    Libexe$ = "ar"
    LibexeBaseName$ = "ar"
    WriteLog("Libexe$="+Libexe$)
    WriteLog("LibexeBaseName$="+LibexeBaseName$)
  CompilerEndIf
  
;}

CancelText$ = Language("TailBite","Cancel")
If QuietMode=0
  If OpenWindow(#TBW, 0, 0, #WWidth, #WHeight, "TailBite "+Version$, #PB_Window_ScreenCentered|#PB_Window_TitleBar)=0
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
    ;If CreateGadgetList(WindowID(#TBW))=0
    ;  TBError(Language("TailBite","GadgetError")+NL$+NL$+Language("TailBite","TryInvisibleMode"), 0, "")
    ;  CloseWindow(#TBW)
    ;  QuietMode = 1
    ;EndIf
    If QuietMode=0
      TextGadget(#Text1, #gap, #gap*3, #WWidth-(#gap*2)-CancelWidth, #WHeight-(#gap*31), Language("TailBite","Starting"))
      TextGadget(#extra_status, #gap, #gap*3+#WHeight-(#gap*31), #WWidth-(#gap*3)-CancelWidth, #WHeight-(#gap*8), "")
      SetExtrastatustext()
      ButtonGadget(#Button1, #WWidth-#gap-CancelWidth, #WHeight/2-25, CancelWidth, 50, CancelText$)
      CompilerIf Defined(TB_Enable_Progress, #PB_Constant)
      CompilerIf #TB_Enable_Progress = 1
        ResizeWindow(#TBW, #PB_Ignore, #PB_Ignore, #PB_Ignore, #WHeight+20+#gap)
        ProgressBarGadgetExtended(#progress, #gap, #WHeight, #WWidth-#gap*2, 20,WindowID(#TBW))
        ProgressBarSetIndeterminate(#progress, 1)
      CompilerEndIf
      CompilerEndIf
    EndIf
  EndIf
EndIf
;Repeat : WaitWindowEvent() : ForEver ; for testing changes to window design
  ;{ Create Working Temporary Path
    TBTempPath$+Hex(Random(#MAXLONG)+(Random(#MAXLONG)<<32),#PB_Quad)+#DirSeparator
    CreatePath(TBTempPath$)
  ;}

;-Test
CompilerIf Defined(TB_Testmode,#PB_Constant)
  MainProc(@PBSourceFile$)
  End
CompilerElse
  ThID = CreateThread(@MainProc(), @PBSourceFile$)
CompilerEndIf

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
Else
  WaitThread(ThID)
EndIf

If recover ; on failure copy back saved lib
  CopyFile(tmplibfile$,oldlibfile$)
  DeleteFile(tmplibfile$)
  recover=0
EndIf

DeleteDirectory(TBTempPath$,"",#PB_FileSystem_Recursive|#PB_FileSystem_Force)

CompilerIf #PB_Compiler_OS = #PB_OS_Windows ; Version = 1.4.15
  
  ProcedureDLL.l Makelong_(lowWord.w,highWord.w) ; Create long from low and high words
     ProcedureReturn (highWord<<16)|lowWor  d
  EndProcedure
  
  DisableExplicit
  Procedure FindPartWin(part$)
    r=GetWindow_(GetDesktopWindow_(),#GW_CHILD)
    Repeat
      t$=Space(999) : GetWindowText_(r,@t$,999)
      If FindString(t$,part$,1)<>0 And IsWindowVisible_(r)=#True
        w=r
      Else
        r=GetWindow_(r,#GW_HWNDNEXT)
      EndIf
    Until r=0 Or w<>0
    ProcedureReturn w
  EndProcedure
  
  EnableExplicit
  
  PostMessage_(FindPartWin("PureBasic"),#WM_COMMAND,Makelong_(53,0),0)
  
CompilerEndIf


  
;MyIde=Val(GetEnvironmentVariable("PB_TOOL_MainWindow"))
  
;  MessageRequester("Information", "PostMessage_ = "+Str(MyIde), #PB_MessageRequester_Ok)

End
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 335
; FirstLine = 278
; Folding = --
; EnableXP
; EnableAdmin
; EnableOnError
; UseIcon = TB_icon_0.2.ico
; Executable = Tailbite.exe
; DisableDebugger
; CompileSourceDirectory
; 뿫ꮺ껪ꪻꫮ뮪ꯪ몪껫ꪯ뫮ꪪ믪ꪪꫪ꺫