EnableExplicit

;Windows
Enumeration
  #TBI
EndEnumeration
;Gadgets
Enumeration
  #Gadget0
  #Gadget1
  #Gadget2
  #Gadget3
  #Gadget4
  #Gadget5
  #Gadget6
  #Gadget7
EndEnumeration

#PB_String_MultiLine = 4
#TB_Installer=1

Global NewList Chm.S()
Global NewList InstallList.S()

XIncludeFile "Tailbite_Res.pb"
XIncludeFile "Inc_Language.pb"  ; No WinAPI
CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    XIncludeFile "Inc_OS_Win.pb" ; WinAPI
  CompilerCase #PB_OS_Linux
    XIncludeFile "Inc_OS_Linux.pb"
CompilerEndSelect
XIncludeFile "Inc_Parameter.pb" ; No WinAPI
XIncludeFile "Inc_Misc.pb"      ; No WinAPI
XIncludeFile "Inc_Prefs.pb"     ; No WinAPI
XIncludeFile "Inc_Compiler.pb"  ; No WinAPI

Define PrefsFound.l,Option$,AutoInstall.l,ViewReadme.l,LaunchTailBiteManager.l,TBProc.FindProcInfo,WindowWidth.l
Define WindowHeight.l,Text$,InstallStr$,CancelStr$,BrowseStr$,NextStr$,BWidth.l,GCr.l,*SHAutoComplete,Event.l,i.l
Define TempFolder$,FSeeker.i,nURLs.l,nFiles.l,PackedFileName$,*Unpacked,FName$,Agreement$,WordWrapEdit.l,FInstall$
Define TailBitePack.l,Pos.l,DateCreated.l,DateAccessed.l,DateModified.l,File.i,HLibDir$,LangStr$,TxtWdth.l,EventID.l
Define Language.l

PrefsFound=TBLoadPreferences()

Option$ = ProgramParameter()
While Option$
  Select Left(Option$, 10)
    Case "/PBFOLDER:"
      PBFolder$ = StringField(Option$,2,":") ;Mid(Option$, 11, Len(Option$)-10)
    Case "/TBFOLDER:"
      TBFolder$ = StringField(Option$,2,":") ;Mid(Option$, 11, Len(Option$)-10)
    Case "/AUTOINSTA"
      AutoInstall = 1
    Case "/VIEWREADM"
      ViewReadme = 1
    Case "/LAUNCHTBM"
      LaunchTailBiteManager = 1
    Case "/LANGUAGE:"
      AddElement(Chm())
      Chm() = StringField(Option$,2,":") ;Right(Option$, Len(Option$)-10)
  EndSelect
  Option$ = ProgramParameter()
Wend

TBProc\Terminate = #True
TBProc\ProcessName$ = "TBManager.exe"
GetProcessList(TBProc)

AddElement(Process())
Process() = "TailBite"
AddElement(Process())
Process() = "TBUpdater"
AddElement(Process())
Process() = "TailBite Manager"
RunOne("TailBite Installer")

Procedure MaxValue(a, b)
  If a>b
    ProcedureReturn a
  Else
    ProcedureReturn b
  EndIf
EndProcedure

WindowWidth = 480
WindowHeight = 164
#gap = 4
#lh = 24
If AutoInstall
  If PBFolder$ And TBFolder$
    Goto InstallTB
  EndIf
EndIf
Version$ = PeekS(?TailBitePack)
Text$=Language("TBInstaller","Version")
Text$=ReplaceString(Text$,"%version%",Version$)
InstallStr$=Language("TBInstaller","Install")
CancelStr$=Language("TBInstaller","Cancel")
BrowseStr$=Language("TBInstaller","Browse")
NextStr$=Language("TBInstaller","Next")
If OpenWindow(#TBI, 0, 0, WindowWidth, WindowHeight, Text$, #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
  ;If CreateGadgetList(WindowID(#TBI))
    If StartDrawing(WindowOutput(#TBI))
      BWidth = MaxValue(MaxValue(TextWidth(InstallStr$), TextWidth(CancelStr$)), TextWidth(BrowseStr$))+#gap
      StopDrawing()
    EndIf
    GCr = #gap
    TextGadget(#Gadget0, #gap, GCr, WindowWidth-(#gap*2), #lh, Language("TBInstaller","PBFolder"))
    GCr+#lh
    StringGadget(#Gadget1, #gap, GCr, WindowWidth-(#gap*3)-BWidth, #lh, PBFolder$)
    ButtonGadget(#Gadget2, WindowWidth-#gap-BWidth, GCr, BWidth, #lh, BrowseStr$)
    GCr+(2*#gap)+#lh
    TextGadget(#Gadget3, #gap, GCr, WindowWidth-(#gap*2), #lh, Language("TBInstaller","TBFolder"))
    GCr+#lh
    StringGadget(#Gadget4, #gap, GCr, WindowWidth-(#gap*3)-BWidth, #lh, TBFolder$)
    ButtonGadget(#Gadget5, WindowWidth-#gap-BWidth, GCr, BWidth, #lh, BrowseStr$)
    If OpenLibrary(0, "shlwapi.dll")
      *SHAutoComplete = GetFunction(0, "SHAutoComplete")
      If *SHAutoComplete<>#Null
        CallFunctionFast(*SHAutoComplete, GadgetID(#Gadget1), #SHACF_AUTOAPPEND_FORCE_ON|#SHACF_AUTOSUGGEST_FORCE_ON|#SHACF_FILESYSTEM)
        CallFunctionFast(*SHAutoComplete, GadgetID(#Gadget4), #SHACF_AUTOAPPEND_FORCE_ON|#SHACF_AUTOSUGGEST_FORCE_ON|#SHACF_FILESYSTEM)
      EndIf
      CloseLibrary(0)
    EndIf
    GCr+#lh+#gap
MainWindowEventLoop:
    ButtonGadget(#Gadget6, WindowWidth-(BWidth*2)-(#gap*2), GCr, BWidth, #lh+(#gap*2), Language("TBInstaller","Next"))
    ButtonGadget(#Gadget7, WindowWidth-BWidth-#gap, GCr, BWidth, #lh+(#gap*2), CancelStr$)
    Repeat
      Event = WaitWindowEvent()
      Select Event
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #Gadget2
              PBFolder$ = PathRequester(Language("TBInstaller","SelectPBFolder"), PBFolder$)
              If PBFolder$
                If Right(PBFolder$, 1)<>"\":PBFolder$+"\":EndIf
                SetGadgetText(#Gadget1, PBFolder$)
                TBFolder$ = PBFolder$+"TailBite\"
                SetGadgetText(#Gadget4, TBFolder$)
              Else
                PBFolder$ = GetGadgetText(#Gadget1)
              EndIf
            Case #Gadget5
              TBFolder$ = PathRequester(Language("TBInstaller","SelectTBFolder"), TBFolder$)
              If TBFolder$
                If Right(TBFolder$, 1)<>"\":TBFolder$+"\":EndIf
                If Right(TBFolder$, 10)<>"\TailBite\"
                  TBFolder$+"TailBite\"
                EndIf
                SetGadgetText(#Gadget4, TBFolder$)
              Else
                TBFolder$ = GetGadgetText(#Gadget4)
              EndIf
            Case #Gadget6
              Goto InstallTB
            Case #Gadget7
              Quit = 1
          EndSelect
        Case #PB_Event_CloseWindow
          Quit = 1
      EndSelect
    Until Quit
  ;EndIf
EndIf
End

;
InstallTB:
;

PBFolder$ = GetGadgetText(#Gadget1)
TBFolder$ = GetGadgetText(#Gadget4)

For i=#Gadget0 To #Gadget5
  FreeGadget(i)
Next i
DisableGadget(#Gadget6, #True)
TempFolder$=GetTemporaryDirectory()
If Right(TempFolder$, 1)<>"\"
  TempFolder$+"\"
EndIf
Version$ = PeekS(?TailBitePack)
FSeeker = ?TailBitePack+Len(Version$)+1
nURLs = Val(PeekS(FSeeker))
FSeeker+Len(PeekS(FSeeker))+1
For i=1 To nURLs
  FSeeker+Len(PeekS(FSeeker))+1
Next
nFiles = Val(PeekS(FSeeker))
FSeeker+Len(PeekS(FSeeker))+1
PackedFileName$ = TempFolder$+"TailBite.pack"
If CreateFile(0, PackedFileName$)
  WriteData(0, FSeeker, ?EndTailBitePack-FSeeker)
  CloseFile(0)
  If FileSize(PBFolder$)<>-2
    TBError(Language("TBInstaller","Error1"), 0, "")
  EndIf
  If FileSize(TBFolder$)<>-2
    CreateDirectory(TBFolder$)
  EndIf
Else
  TBError(Language("TBInstaller","Error2"), 0, "")
EndIf

If OpenPack(PackedFileName$)
  Repeat
    *Unpacked = NextPackFile()
    If *Unpacked
      FName$ = PeekS(*Unpacked)
      If FName$<>"DIR"
        *Unpacked = NextPackFile()
        If *Unpacked
          AddElement(InstallList())
          InstallList() = FName$
          If UCase(Right(FName$, Len("LICENSE.TXT")))=UCase("LICENSE.TXT")
            Agreement$ = PeekS(*Unpacked, PackFileSize())
          EndIf
        EndIf
      Else
        AddElement(InstallList())
        InstallList() = PeekS(*Unpacked+4)
        If Right(InstallList(), 1)<>"\":InstallList()+"\":EndIf
      EndIf
    EndIf
  Until *Unpacked=0
  ClosePack()
Else
  DeleteFile(PackedFileName$)
  TBError(Language("TBInstaller","Error3"), 0, "")
EndIf

If AutoInstall=0
  Agreement$ = RTrim(ReplaceString(Agreement$, NL$, #CRLF$))
  WordWrapEdit = CreateWindowEx_(#WS_EX_CLIENTEDGE, "EDIT", Agreement$, #PB_String_ReadOnly|#PB_String_MultiLine|#WS_CHILDWINDOW|#WS_VISIBLE|#ES_AUTOVSCROLL|#WS_VSCROLL, #gap, #gap, WindowWidth-(#gap*2), GCr-#lh-#gap, WindowID(#TBI), 0, GetModuleHandle_(0), 0)
  If WordWrapEdit
    SendMessage_(WordWrapEdit, #WM_SETFONT, GetStockObject_(#DEFAULT_GUI_FONT), 1)
    UpdateWindow_(WordWrapEdit)
    ShowWindow_(WordWrapEdit, #SW_SHOWNORMAL)
  EndIf
  CheckBoxGadget(#Gadget1, #gap, GCr, WindowWidth-(BWidth*2)-(#gap*4), #lh, Language("TBInstaller","Agree"))
  Quit = 0
  Repeat
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gadget1
            If GetGadgetState(#Gadget1)
              DisableGadget(#Gadget6, #False)
            Else
              DisableGadget(#Gadget6, #True)
            EndIf
          Case #Gadget6
            Goto GoInstall
          Case #Gadget7
            Quit = 1
        EndSelect
      Case #PB_Event_CloseWindow
        Quit = 1
    EndSelect
  Until Quit
  DestroyWindow_(WordWrapEdit)
  DeleteFile(PackedFileName$)
  End
EndIf

;
GoInstall:
;

If AutoInstall=0
  DestroyWindow_(WordWrapEdit)
  FreeGadget(#Gadget1)
  ListViewGadget(#Gadget0,  #gap, #gap, WindowWidth-(#gap*2), GCr-#lh-#gap)
  ForEach InstallList()
    If Right(InstallList(), 1)<>"\"
      If GetExtensionPart(InstallList())=""
        FInstall$ = TBFolder$+InstallList()
        AddGadgetItem(0, -1, FInstall$)
        FInstall$ = ""
        If PBVersionX64 
          If FindString(InstallList(),"X64",1)
            FInstall$ = PBFolder$+"PureLibraries\UserLibraries\"+GetFilePart(InstallList())
          EndIf
        Else
          If Not FindString(InstallList(),"X64",1)
            FInstall$ = PBFolder$+"PureLibraries\UserLibraries\"+GetFilePart(InstallList())
          EndIf
        EndIf
      ElseIf GetExtensionPart(InstallList())="chm"
        FInstall$ = PBFolder$+"Help\"+GetFilePart(InstallList())
      ElseIf GetExtensionPart(InstallList())="res"
        FInstall$ = PBFolder$+"Residents\"+GetFilePart(InstallList())
      Else
        FInstall$ = TBFolder$+InstallList()
      EndIf
    Else
      FInstall$ = TBFolder$+InstallList()
    EndIf
    If FInstall$
      AddGadgetItem(0, -1, FInstall$)
    EndIf
  Next
  TextGadget(#Gadget1, #gap, GCr, WindowWidth-(BWidth*2)-(#gap*4), #lh, Language("TBInstaller","Created"))
  Quit = 0
  Repeat
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gadget6
            Goto InstallIt
          Case #Gadget7
            Quit = 1
        EndSelect
      Case #PB_Event_CloseWindow
        Quit = 1
    EndSelect
  Until Quit
  DeleteFile(PackedFileName$)
  End
EndIf

;
InstallIt:
;
If AutoInstall=0
  FreeGadget(#Gadget0)
  FreeGadget(#Gadget1)
  FreeGadget(#Gadget6)
  FreeGadget(#Gadget7)
  TextGadget(#Gadget6, 4, 114, 388, 32, "")
EndIf

;
PackInstall:
;
If AutoInstall=0
  SetGadgetText(#Gadget6, Language("TBInstaller","Installing"))
EndIf
nFiles = 0
If FileSize(TBFolder$+"TailBite Manager.exe")<>-1
  DeleteFile(TBFolder$+"TailBite Manager.exe")
EndIf
If OpenPack(PackedFileName$)
  TailBitePack = 0
  Repeat
    *Unpacked = NextPackFile()
    If *Unpacked
      FName$ = PeekS(*Unpacked)
      If FName$="DIR"
        FName$ = PeekS(*Unpacked+4)
        If FileSize(TBFolder$+FName$)<>-2
          CreateDirectory(TBFolder$+FName$)
        EndIf
      Else
        Pos=Len(FName$)+1
        DateCreated=PeekL(*Unpacked+Pos):Pos+4
        DateAccessed=PeekL(*Unpacked+Pos):Pos+4
        DateModified=PeekL(*Unpacked+Pos):Pos+4
        *Unpacked = NextPackFile()
        If *Unpacked
          If GetExtensionPart(FName$)="chm"
            AddElement(Chm())
            Chm() = FName$
          EndIf
          File=CreateFile(#PB_Any, TBFolder$+FName$)
          If File
            WriteData(File, *Unpacked, PackFileSize())
            CloseFile(File)
            nFiles+1
            If FName$="TailBite.exe"
              TailBitePack = 1
            EndIf
            SetFileDate(TBFolder$+FName$,#PB_Date_Created,DateCreated)
            SetFileDate(TBFolder$+FName$,#PB_Date_Accessed,DateAccessed)
            SetFileDate(TBFolder$+FName$,#PB_Date_Modified,DateModified)
          EndIf
        EndIf
      EndIf
    EndIf
  Until *Unpacked=0
  ClosePack()
  DeleteFile(PackedFileName$)
  If PBVersionX64
    HLibDir$ = TBFolder$+"Helper Libraries X64\"
  Else
    HLibDir$ = TBFolder$+"Helper Libraries\"
  EndIf
  If 0 And ExamineDirectory(0, HLibDir$, "");Not the way the helper libs are intended to be used!
    While NextDirectoryEntry(0)
      LibName$ = DirectoryEntryName(0)
      If LibName$
        If LibName$<>"." And LibName$<>".."
          If GetExtensionPart(LibName$)<>"res"
            If FileSize(PBFolder$+"PureLibraries\UserLibraries\"+LibName$)<>-1
              DeleteFile(PBFolder$+"PureLibraries\UserLibraries\"+LibName$)
            EndIf
            CopyFile(HLibDir$+LibName$, PBFolder$+"PureLibraries\UserLibraries\"+LibName$)
          Else
            If FileSize(PBFolder$+"Residents\"+LibName$)<>-1
              DeleteFile(PBFolder$+"Residents\"+LibName$)
            EndIf
            CopyFile(HLibDir$+LibName$, PBFolder$+"Residents\"+LibName$)
          EndIf
          ;DeleteFile(HLibDir$+LibName$)
        EndIf
      EndIf
    Wend
    FinishDirectory(0)
    ;DeleteDirectory(HLibDir$, "", #PB_FileSystem_Recursive)
  EndIf
  If TailBitePack
    If PrefsFound=0 Or GetDriveType_(@TBFolder$)=#DRIVE_REMOVABLE
      TBSavePreferences()
    EndIf
    TBSaveToolsPrefs("","",1)
  EndIf
  ;BuildApiList()
Else
  DeleteFile(PackedFileName$)
  CoUninitialize_()
  TBError(Language("TBInstaller","Error4"), 0, "")
EndIf
If AutoInstall=0
  FreeGadget(#Gadget6)
EndIf
If TailBitePack=0
  DeleteFile(PackedFileName$)
  TBError(Language("TBInstaller","Error4"), 0, "")
EndIf
For i=#Gadget0 To #Gadget6
  FreeGadget(i)
Next i
If AutoInstall=0
  TextGadget(#Gadget0, #gap, #gap+#lh, WindowWidth-(#gap*2), #lh, Language("TBInstaller","Success"))
  CheckBoxGadget(#Gadget1, #gap, (#gap+#lh)*2, WindowWidth-BWidth-(#gap*2), #lh, Language("TBInstaller","Readme"))
  SetGadgetState(#Gadget1, ViewReadme)
  CheckBoxGadget(#Gadget2, #gap, (#gap+#lh)*3, WindowWidth-BWidth-(#gap*2), #lh, Language("TBInstaller","Launch"))
  SetGadgetState(#Gadget2, LaunchTailBiteManager)
  ButtonGadget(#Gadget3, WindowWidth-BWidth-#gap, GCr, BWidth, #lh+(#gap*2), Language("TBInstaller","Finish"))
  LangStr$=Language("TBInstaller","Language")
  If StartDrawing(WindowOutput(0))
    TxtWdth = TextWidth(LangStr$)
    StopDrawing()
  EndIf
  TextGadget(#Gadget4, #gap, (#gap+#lh)*4, TxtWdth, #lh, LangStr$)
  ;ComboBoxGadget(#Gadget5, TxtWdth+(#gap*2), (#gap+#lh)*4, (WindowWidth-BWidth-(#gap*3))/2, #lh*(ListSize(Chm())+1))
  ComboBoxGadget(#Gadget5, TxtWdth+(#gap*2), (#gap+#lh)*4, (WindowWidth-BWidth-(#gap*3))/2, #lh)
  ForEach Chm()
    AddGadgetItem(#Gadget5, ListIndex(Chm()), RemoveString(RemoveString(Chm(), "TailBite "), ".chm"))
  Next
  SetGadgetState(#Gadget5, 0)
  Quit = 0
  Repeat
    EventID = WaitWindowEvent()
    Select EventID
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gadget3
            Quit = 1
        EndSelect
      Case #PB_Event_CloseWindow
        Quit = 1
    EndSelect
  Until Quit
  ViewReadme = GetGadgetState(#Gadget1)
  LaunchTailBiteManager = GetGadgetState(#Gadget2)
  Language = GetGadgetState(#Gadget5)
EndIf
If ListSize(Chm())
  If FileSize(PBFolder$+"Help\TailBite.chm")<>-1
    DeleteFile(PBFolder$+"Help\TailBite.chm")
  EndIf
  SelectElement(Chm(), Language)
  RenameFile(TBFolder$+Chm(), PBFolder$+"Help\TailBite.chm")
EndIf
If ViewReadme
  If RunProgram(#DQUOTE$+TBFolder$+"Readme.txt"+#DQUOTE$)=0
    TBError(Language("TBInstaller","ReadmeErr"), 0, "")
  EndIf
EndIf
If LaunchTailBiteManager
  RunProgram(TBFolder$+"TBManager.exe","",TBFolder$)
EndIf
End

DataSection
TailBitePack:
CompilerIf #PB_Compiler_Debugger=0
  IncludeBinary "TailBite.pack"
CompilerEndIf
EndTailBitePack:
EndDataSection

; IDE Options = PureBasic 4.30 (Windows - x64)
; CursorPosition = 391
; FirstLine = 372
; Folding = -
; EnableOnError
; UseIcon = TB_icon_0.2.ico
; Executable = ..\..\..\Sistema\Programacion\PureBasic\Programas\TailBite\Release\TailBite Installer.exe
; Debugger = IDE