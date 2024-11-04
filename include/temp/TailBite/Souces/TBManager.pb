EnableExplicit

#WID = 0 ; Main Window

;Gadgets
Enumeration
  #Frame3D_cmdlops
  #Frame3D_Folders
  #Frame3D_TailBiteConsole
  #CheckBox_AskDelete
  #CheckBox_DontMakeLib
  #CheckBox_KeepSrcFiles
  #CheckBox_QuietMode
  #CheckBox_WriteBatch
  #CheckBox_ThreadsafeOption
  #CheckBox_UnicodeOption
  #CheckBox_MultiLibOption
  #Text_HotKeys
  #Text_PBFolder
  #Text_TBFolder
  #Text_ASMFolder
  #Text_Subsystem
  #Text_SourceFolder
  #String_PBFolder
  #String_ASMFolder
  #String_SourceFolder
  #Batch_Options
  #Listicon_jobs
  #ComboBox_HotKeys
  #ComboBox_Subsystem
  #ComboBox_Language
  #Button_PBFolderBrowse
  #Button_ASMFolderBrowse
  #Button_Pick_current
  #Button_SourceFolderBrowse
  #Button_Addjob
  #Button_Deletejob
  #Button_Run
  #Button_Process
  #Button_CheckErrors
  #Button_CheckUpdates
  #Button_ExtractSources
  #Button_Help
  #Button_Save
  #Button_Exit
  #Button_Expand
  #Button_Sticky
  #Container1
  #Container2
  #Last
EndEnumeration

;Toolbar
;Enumeration
;  #Toolbar1
;  #Toolbar2
;EndEnumeration

;Toolbar buttons
;Enumeration
  ;#Button_Sticky
;   #Button_Expand
;EndEnumeration

;Images
Enumeration
  #ImageSticky1
  #ImageSticky2
  #ImageExpand1
  #ImageExpand2
EndEnumeration

Global OldWndProc, mDC, WindowWidth, xPos, yPos, BtnWidth, BtnHeight
Global OrBtnWidth, OrBtnHeight, BGColour, FGColour, hToolTip
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Global tp.TOOLINFO
CompilerEndIf
Global NewList Subsystems.s()
Global NewList Languages.s()
Global NewList HotK.s()
Global IconExpandSize.l,TailBiteInProgress.l
Global WWidth.l,WHeight.l

#gap = 4 ; Gap between gadgets
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  #lh = 24 ; Height
  WWidth = 600
CompilerElse
  #lh = 30 ; Height
  WWidth = 650
CompilerEndIf
#cmdlops = 8 ; Commandline options
#folders = 2 ; folders
#fcombo = 1 ; Subsystem
#hbatch = 200

WHeight = (#gap*23)+(#cmdlops*(#lh+#gap))+(#folders*((#lh*2)+(#gap*2)))+(#lh*4)+(#fcombo*((#lh*2)+(#gap*2)))+(#lh*4)

;#TB_TestDontSetTBDirToSourceDir = 1

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
;XIncludeFile "Inc_Tailbite.pb"  ; WinAPI

UsePNGImageDecoder()
CatchImage(#ImageSticky1,?Sticky1,?Sticky1e-?Sticky1)
CatchImage(#ImageSticky2,?Sticky2,?Sticky2e-?Sticky2)
CatchImage(#ImageExpand1,?Expand1,?Expand1e-?Expand1)
CatchImage(#ImageExpand2,?Expand2,?Expand2e-?Expand2)
IconExpandSize=24

; Procedure.l CreateToolBarEx(ToolBar.l,WindowID.l,Style.l)
;   Protected Res.l,TID.l
;   
;   Res=CreateToolBar(ToolBar,WindowID)
;   If toolbar = #PB_Any
;     If Not IsToolBar(res)
;       ProcedureReturn 0
;     EndIf
;   Else
;     If Not IsToolBar(toolbar)
;       ProcedureReturn 0
;     EndIf
;   EndIf
;   
;   If ToolBar=#PB_Any
;     TID=ToolBarID(ToolBar)
;   Else
;     TID=Res
;   EndIf
;   
;   CompilerIf #PB_Compiler_OS=#PB_OS_Windows
;     SetWindowLong_(TID, #GWL_STYLE, GetWindowLong_(TID, #GWL_STYLE) | Style) ; Get rid of the divider
;   CompilerEndIf
;   
;   ProcedureReturn Res
; EndProcedure

Procedure.l CBFindStringExact(ID.l,Text.s,Part.l=#False)
  Protected count.l,i.l,tlen.l=Len(Text)
  If IsGadget(ID) And GadgetType(ID)=#PB_GadgetType_ComboBox
    count=CountGadgetItems(id)
    If count
      For i=0 To count
        If Part
          If Left(GetGadgetItemText(ID,i),tlen)=Text
            ProcedureReturn i
          EndIf
        Else
          If GetGadgetItemText(ID,i)=Text
            ProcedureReturn i
          EndIf
        EndIf
      Next
    EndIf
  EndIf
  ProcedureReturn -1
EndProcedure

Procedure MaxValue(a, b)
  If a>b
    ProcedureReturn a
  Else
    ProcedureReturn b
  EndIf
EndProcedure

Procedure GetSubsystems()
  Protected folder$,dir.l
  
  ClearList(Subsystems())
  AddElement(Subsystems())
  Subsystems()=Userlibdir$
  folder$=PBFolder$+"subsystems"+#DirSeparator
  dir=ExamineDirectory(#PB_Any,folder$,"*.*")
  If dir
    While NextDirectoryEntry(dir)
      If DirectoryEntryType(dir) = #PB_DirectoryEntry_Directory
        If DirectoryEntryName(dir)<>"." And DirectoryEntryName(dir)<>".."
          AddElement(Subsystems())
          If PBnbVersion<402
            Subsystems()="subsystems"+#DirSeparator+DirectoryEntryName(dir)+#DirSeparator+"purelibraries"+#DirSeparator
          Else
            Subsystems()="subsystems"+#DirSeparator+DirectoryEntryName(dir)+#DirSeparator+"purelibraries"+#DirSeparator+"userlibraries"+#DirSeparator
          EndIf
        EndIf
      EndIf
    Wend
    FinishDirectory(dir)
  EndIf
EndProcedure

Procedure GetLanguages()
  Protected dir.l
  
  ClearList(Languages())
  dir=ExamineDirectory(#PB_Any,TBFolder$+"Catalogs"+#DirSeparator,"*.catalog")
  If dir
    While NextDirectoryEntry(dir)
      If DirectoryEntryType(dir) = #PB_DirectoryEntry_File
        AddElement(Languages())
        Languages()=RemoveString(DirectoryEntryName(dir),".catalog",1)
      EndIf
    Wend
    FinishDirectory(dir)
  EndIf
EndProcedure

Procedure.s GetHotKeys()
  Protected ToolCount.l,i.l,TName$,ThisHotK$,vHotKey.l,CHotK$
  
  If OpenPreferences(PBPreferencesPath$+"tools.prefs")
    PreferenceGroup("ToolsInfo")
    ToolCount = Val(ReadPreferenceString("ToolCount", "0"))
    For i=0 To ToolCount-1
      PreferenceGroup("Tool_"+Str(i))
      TName$ = ReadPreferenceString("MenuItemName", "")
      ThisHotK$ = ReadPreferenceString("ShortCut", "")
      If ThisHotK$
        If TName$<>"TailBite"
          vHotKey = Val(ThisHotK$)
          If vHotKey&#PB_Shortcut_Alt
            vHotKey!#PB_Shortcut_Alt
            If (vHotKey>47 And vHotKey<58) Or (vHotKey>111 And vHotKey<124)
              If vHotKey>47 And vHotKey<58
                ThisHotK$ = "Alt+"+Str(vHotKey-48)
              Else
                ThisHotK$ = "Alt+F"+Str(vHotKey-111)
              EndIf
              ForEach HotK()
                If HotK()=ThisHotK$
                  DeleteElement(HotK())
                  Break
                EndIf
              Next
            EndIf
          EndIf
        Else
          CHotK$ = ThisHotK$
        EndIf
      EndIf
    Next i
    ClosePreferences()
  EndIf
  ProcedureReturn CHotK$
EndProcedure

Define SrcPath$,OrigSrcPath$,i.l

PBSourceFile$ = ProgramParameter()
If UCase(PBSourceFile$) = "/PREF";we reuse the PBSourceFile$ variable here, saves creating more variables
  Debug "user defined pref file"
  PBSourceFile$ = ProgramParameter()
  Debug PBSourceFile$
  If GetPathPart(PBSourceFile$);if its not a valid filename, no point in setting it.
    Debug "user pref valid filename"
    UseUserPrefsFile = 1
    TBPrefsFile$ = PBSourceFile$
  EndIf
  PBSourceFile$ = ProgramParameter()
EndIf
TBLoadPreferences()

; ABBKlaus 2.1.2008 create SubSystem path
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  If PBFolder$
    If PBnbVersion<402
      CreatePath(PBFolder$+"SubSystems\UserLibUnicode\PureLibraries\")
      CreatePath(PBFolder$+"SubSystems\UserLibThreadSafe\PureLibraries\")
      CreatePath(PBFolder$+"SubSystems\UserLibUnicodeThreadSafe\PureLibraries\")
    Else
      CreatePath(PBFolder$+"SubSystems\UserLibUnicode\PureLibraries\UserLibraries\")
      CreatePath(PBFolder$+"SubSystems\UserLibThreadSafe\PureLibraries\UserLibraries\")
      CreatePath(PBFolder$+"SubSystems\UserLibUnicodeThreadSafe\PureLibraries\UserLibraries\")
    EndIf
  EndIf
CompilerElse
  If PBFolder$
    If pBnbVersion<402
      CreatePath(PBFolder$+"subsystems/userlibunicode/purelibraries/")
      CreatePath(PBFolder$+"subsystems/userlibthreadsafe/purelibraries/")
      CreatePath(PBFolder$+"subsystems/userlibunicodethreadsafe/purelibraries/")
    Else
      CreatePath(PBFolder$+"subsystems/userlibunicode/purelibraries/userlibraries/")
      CreatePath(PBFolder$+"subsystems/userlibthreadsafe/purelibraries/userlibraries/")
      CreatePath(PBFolder$+"subsystems/userlibunicodethreadsafe/purelibraries/userlibraries/")
    EndIf
  EndIf
CompilerEndIf

AddElement(Process())
Process() = "TBUpdater"
RunOne("TailBite Manager")

;Get Version of TailBite
Version$=PeekS(?Version1,?Version2-?Version1,#PB_Ascii)
Version$=RemoveString(Trim(StringField(Version$,2,"=")),#CRLF$)

SrcPath$ = TBFolder$+"src\"
OrigSrcPath$ = SrcPath$

Delay(250)

If FileSize(TBTempPath$+"TBCompiler.exe")>=0
  DeleteFile(TBTempPath$+"TBCompiler.exe")
EndIf

If FileSize(TBTempPath$+"TBUpdater.exe")>=0
  DeleteFile(TBTempPath$+"TBUpdater.exe")
EndIf

; HotKeys 0-9 F1-F12
For i=0 To 9
  AddElement(HotK())
  HotK() = Str(i)
Next i
For i=1 To 12
  AddElement(HotK())
  HotK() = "F"+Str(i)
Next i

If PBSourceFile$=""
  PBSourceFile$ = LastFile$
EndIf

Procedure DisableButtons(Status)
  Protected i.l
  
  For i=0 To #Last-1
    If IsGadget(i)
      DisableGadget(i, Status)
    Else
      Debug "Gadget is not initialized "+Str(i)
      CallDebugger
    EndIf
  Next i
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    If Status = 0
      DisableGadget(#ComboBox_Language, 1)
      DisableGadget(#Button_Pick_current, 1)
      DisableGadget(#Button_ExtractSources, 1)
      DisableGadget(#Button_CheckUpdates, 1)
    EndIf
  CompilerEndIf
EndProcedure

Procedure CheckManagerOnTop(bShow.b=#False)
  If Not bShow
    ManagerOnTop!1
  EndIf
  
;   If IsToolBar(#Toolbar1)
;     FreeToolBar(#Toolbar1)
;   EndIf
;   If CreateToolBarEx(#Toolbar1,GadgetID(#Container1),#CCS_NODIVIDER)
;     If ManagerOnTop
;       ToolBarImageButton(#Button_Sticky,ImageID(#ImageSticky2),#PB_ToolBar_Toggle);ImageID(#ImageSticky1)
;     Else
;       Define imgid = ImageID(#ImageSticky1)
;       ToolBarImageButton(#Button_Sticky,imgid,#PB_ToolBar_Toggle);ImageID(#ImageSticky1)
;     EndIf
;     ToolBarToolTip(#Toolbar1,#Button_Sticky,Language("TBManager","Stayontop"))
;   EndIf
;   
;   If ManagerOnTop
;     StickyWindow(#WID,1)
;   Else
;     StickyWindow(#WID,0)
;   EndIf

  If Not IsGadget(#Button_Sticky)
    ButtonImageGadget(#Button_Sticky, 0,0,24,24,0, #PB_Button_Toggle)
    SetGadgetState(#Button_Sticky, ManagerOnTop)
  EndIf
  ;If CreateToolBarEx(#Toolbar1,GadgetID(#Container1),#CCS_NODIVIDER)
    If ManagerOnTop
      SetGadgetAttribute(#Button_Sticky,#PB_Button_Image,ImageID(#ImageSticky2));ImageID(#ImageSticky1)
    Else
      Define imgid = ImageID(#ImageSticky1)
      SetGadgetAttribute(#Button_Sticky,#PB_Button_Image,imgid);ImageID(#ImageSticky1)
    EndIf
    GadgetToolTip(#Button_Sticky,Language("TBManager","Stayontop"))
  ;EndIf
  
  If ManagerOnTop
    StickyWindow(#WID,1)
  Else
    StickyWindow(#WID,0)
  EndIf
  
EndProcedure

Procedure CheckExpand(bShow.b=#False)
  Static state.l
  
;   If IsToolBar(#Toolbar2)
;     If bShow
;       state=Batch_options
;     Else
;       state=1!state
;     EndIf
;   Else
;     state=Batch_options
;   EndIf
;   
;   If IsToolBar(#Toolbar2)
;     FreeToolBar(#Toolbar2)
;   EndIf
;   If CreateToolBarEx(#Toolbar2,GadgetID(#Container2),#CCS_NODIVIDER)
;     If state
;       ; Set image to Arrow_up
;       ToolBarImageButton(#Button_Expand,ImageID(#ImageExpand1),#PB_ToolBar_Normal)
;     Else
;       ; Set image to Arrow_down
;       ToolBarImageButton(#Button_Expand,ImageID(#ImageExpand2),#PB_ToolBar_Normal)
;     EndIf
;   EndIf
;   
;   If state
;     Batch_options=1
;     ResizeWindow(#WID,#PB_Ignore,#PB_Ignore,#PB_Ignore,WHeight+#hbatch)
;   Else
;     Batch_options=0
;     ResizeWindow(#WID,#PB_Ignore,#PB_Ignore,#PB_Ignore,WHeight)
;   EndIf
;   
;   ToolBarToolTip(#Toolbar2,#Button_Expand,Language("TBManager","Batchoptions"))
  
  If IsGadget(#Button_Expand)
    If bShow
      state=Batch_options
    Else
      state=1!state
    EndIf
  Else
    ButtonImageGadget(#Button_Expand, 0, 0,IconExpandSize,#lh,0)
    state=Batch_options
  EndIf
  
  ;If CreateToolBarEx(#Toolbar2,GadgetID(#Container2),#CCS_NODIVIDER)
    If state
      ; Set image to Arrow_up
      SetGadgetAttribute(#Button_Expand,#PB_Button_Image,ImageID(#ImageExpand1))
    Else
      ; Set image to Arrow_down
      SetGadgetAttribute(#Button_Expand,#PB_Button_Image,ImageID(#ImageExpand2))
    EndIf
  ;EndIf
  
  If state
    Batch_options=1
    ResizeWindow(#WID,#PB_Ignore,#PB_Ignore,#PB_Ignore,WHeight+#hbatch)
  Else
    Batch_options=0
    ResizeWindow(#WID,#PB_Ignore,#PB_Ignore,#PB_Ignore,WHeight)
  EndIf
  
  GadgetToolTip(#Button_Expand,Language("TBManager","Batchoptions"))

EndProcedure

Procedure Open_Window_TBManager()
  Protected Focus.l,BrowseStr$,TBCProcess$,TBCCheck$,Update$,Extract$,HelpStr$,SaveStr$,ExitStr$,HKText$,PickText$
  Protected addjobStr$,deletejobStr$,ThreadStr$,RunStr$,JobnameStr$,FontID.l,BrWidth.l,TBCWidth.l,UpdateWidth.l
  Protected ExtractWidth.l,ExitWidth.l,HKTextWidth.l,PickWidth.l,FoldersWidth.l,jobWidth.l,ThreadWidth.l,i.l
  Protected CHotK$,YCSR.l,ToolsPrefsSize.l,*ToolsPrefs,*ToolsPrefsEnd,FileSeeker.l,CMDLOps$,CGIndex.l,vhotk.l
  Protected langw.l,width.l,height.l,*SHAutoComplete
  
  If IsWindow(#WID)
    CloseWindow(#WID)
  EndIf
    If OpenWindow(#WID, 0, 0, WWidth, WHeight, "TailBite Manager", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)=0
      TBError(Language("TBManager","WindowError"),0,"")
      End
    EndIf
    Focus=0
  ;Else
  ;  Focus=GetActiveGadget()
  ;EndIf
  BrowseStr$ = " "+Language("TBManager","Browse")+" "
  TBCProcess$ = Language("TBManager","TailBiteIt")
  TBCCheck$ = Language("TBManager","CheckErrors")
  Update$ = Language("TBManager","CheckUpdates")
  Extract$ = Language("TBManager","ExtractTBSources")
  HelpStr$ = " "+Language("TBManager","Help")+" "
  SaveStr$ = " "+Language("TBManager","Save")+" "
  ExitStr$ = " "+Language("TBManager","Exit")+" "
  HKText$ = Language("TBManager","HotKey")
  PickText$ = Language("TBManager","PickCurrent")
  addjobStr$ = Language("TBManager","Addjob")
  deletejobStr$ = Language("TBManager","Deletejob")
  ThreadStr$ = Language("TBManager","Threads")
  RunStr$ = Language("TBManager","Run")
  JobnameStr$ = Language("TBManager","Jobfilename")
  
  Dim cmdlop.s(#cmdlops-1)
  Dim widthcmdlop.l(#cmdlops-1)
  CmdLOp(0)=Language("TBManager","PromptConfirm")
  CmdLOp(1)=Language("TBManager","DontBuildLib")
  CmdLOp(2)=Language("TBManager","KeepSources")
  CmdLOp(3)=Language("TBManager","HideWindow")
  CmdLOp(4)=Language("TBManager","BatchFile")
  CmdLOp(5)=Language("TBManager","ThreadOption")
  CmdLOp(6)=Language("TBManager","UnicodeOption")
  CmdLOp(7)=Language("TBManager","MultiLibOption")
  Dim Folders.s(#folders-1)
  Folders(0)=Language("TBManager","PBFolder")
  Folders(1)=Language("TBManager","AsmFolder")
  Dim FCombo.s(#fcombo-1)
  fcombo(0)=Language("TBManager","LibrarySubsystem")
  
  CompilerIf #PB_Compiler_OS <> #PB_OS_Linux;-retest this in linux
    FontID=GetGadgetFont(#PB_Default)
  CompilerElse;ima workaround
    TextGadget(#Frame3D_cmdlops,0,0,0,0,"")
    FontID=GetGadgetFont(#Frame3D_cmdlops)
  CompilerEndIf
  
  ;If CreateGadgetList(WindowID(#WID))
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    #GadgetWidthExtraSpace = 8
    #CmdLopExtraSpace = 20
  CompilerElse
    #GadgetWidthExtraSpace = 15
    #CmdLopExtraSpace = 37
  CompilerEndIf
   CompilerIf #PB_Compiler_OS=#PB_OS_MacOS;cant draw on a window in os x
     Define drawimg
     drawimg = CreateImage(#PB_Any, 200,200)
     If StartDrawing(ImageOutput(drawimg))
   CompilerElse
     If StartDrawing(WindowOutput(#WID))
   CompilerEndIf
      DrawingFont(#PB_Default);FontID)
      BrWidth = TextWidth(BrowseStr$)+#GadgetWidthExtraSpace
      TBCWidth = MaxValue(TextWidth(TBCProcess$), TextWidth(TBCCheck$))+#GadgetWidthExtraSpace
      UpdateWidth = TextWidth(Update$)+#GadgetWidthExtraSpace
      ExtractWidth =  TextWidth(Extract$)+#GadgetWidthExtraSpace
      ExitWidth = MaxValue(MaxValue(TextWidth(SaveStr$), TextWidth(ExitStr$)), TextWidth(HelpStr$))+#GadgetWidthExtraSpace
      HKTextWidth = TextWidth(HKText$)+#GadgetWidthExtraSpace
      PickWidth = TextWidth(PickText$)+#GadgetWidthExtraSpace
      FoldersWidth = MaxValue(TextWidth(Folders(0)), TextWidth(Folders(1)))+#GadgetWidthExtraSpace
      
      jobWidth = MaxValue(TextWidth(addjobStr$)+#GadgetWidthExtraSpace,TextWidth(deletejobStr$)+#GadgetWidthExtraSpace)
      jobWidth = MaxValue(jobWidth,TextWidth(RunStr$)+#GadgetWidthExtraSpace)
      
      ThreadWidth = TextWidth(ThreadStr$)+#GadgetWidthExtraSpace
      For i=0 To #cmdlops-1
        widthcmdlop(i)=TextWidth(CmdLOp(i))+#CmdLopExtraSpace
      Next
      CHotK$ = GetHotKeys()
      StopDrawing()
    EndIf
    
    ;Command line options
    FrameGadget(#Frame3D_cmdlops, #gap, #gap, WWidth-(#gap*2), (#cmdlops*(#lh))+(#gap*5), Language("TBManager","Options"))
    YCSR = #gap*5
    CheckBoxGadget(#CheckBox_AskDelete, #gap*3, YCSR, widthcmdlop(0), #lh, CmdLOp(0))
    YCSR+#lh;+#gap
    CheckBoxGadget(#CheckBox_DontMakeLib, #gap*3, YCSR, widthcmdlop(1), #lh, CmdLOp(1))
    YCSR+#lh;+#gap
    CheckBoxGadget(#CheckBox_KeepSrcFiles, #gap*3, YCSR, widthcmdlop(2), #lh, CmdLOp(2))
    YCSR+#lh;+#gap
    CheckBoxGadget(#CheckBox_QuietMode, #gap*3, YCSR, widthcmdlop(3), #lh, CmdLOp(3))
    YCSR+#lh;+#gap
    CheckBoxGadget(#CheckBox_WriteBatch, #gap*3, YCSR, widthcmdlop(4), #lh, CmdLOp(4))
    YCSR+#lh;+#gap
    CheckBoxGadget(#CheckBox_ThreadsafeOption, #gap*3, YCSR, widthcmdlop(5), #lh, CmdLOp(5))
    YCSR+#lh;+#gap
    CheckBoxGadget(#CheckBox_UnicodeOption, #gap*3, YCSR, widthcmdlop(6), #lh, CmdLOp(6))
    YCSR+#lh;+#gap
    CheckBoxGadget(#CheckBox_MultiLibOption, #gap*3, YCSR, widthcmdlop(7), #lh, CmdLOp(7))
    
    ;DisableGadget(#CheckBox_ThreadsafeOption,1)
    ;DisableGadget(#CheckBox_UnicodeOption,1)
    YCSR+#lh+#gap
    If ReadFile(0, PBPreferencesPath$+"Tools.prefs")
      ToolsPrefsSize = Lof(0)
      *ToolsPrefs = AllocateMemory(ToolsPrefsSize)
      ReadData(0, *ToolsPrefs, ToolsPrefsSize)
      CloseFile(0)
      *ToolsPrefsEnd = *ToolsPrefs+ToolsPrefsSize
      FileSeeker = FindNextString("MenuItemName = TailBite", *ToolsPrefs, *ToolsPrefsEnd)
      FileSeeker = FindNextString("Arguments = ", FileSeeker, *ToolsPrefs)+12
      CMDLOps$ = GetNextString(FileSeeker, #CRLF$)
      FreeMemory(*ToolsPrefs)
      If FindString(CMDLOps$, " /ASKDELETE", 1)
        SetGadgetState(#CheckBox_AskDelete, #True)
      EndIf
      If FindString(CMDLOps$, " /DONTMAKELIB", 1)
        SetGadgetState(#CheckBox_DontMakeLib, #True)
      EndIf
      If FindString(CMDLOps$, " /KEEPSRCFILES", 1)
        SetGadgetState(#CheckBox_KeepSrcFiles, #True)
      EndIf
      If FindString(CMDLOps$, " /QUIETMODE", 1)
        SetGadgetState(#CheckBox_QuietMode, #True)
      EndIf
      If FindString(CMDLOps$, " /WRITEBATCH", 1)
        SetGadgetState(#CheckBox_WriteBatch, #True)
      EndIf
      If FindString(CMDLOps$, " /THRD", 1)
        SetGadgetState(#CheckBox_ThreadsafeOption, #True)
      EndIf
      If FindString(CMDLOps$, " /UCOD", 1)
        SetGadgetState(#CheckBox_UnicodeOption, #True)
      EndIf
      If FindString(CMDLOps$, " /MULT", 1)
        SetGadgetState(#CheckBox_MultiLibOption, #True)
      EndIf
    EndIf
    YCSR = (#gap*2)+GadgetHeight(#Frame3D_cmdlops)
    ;Folders
    FrameGadget(#Frame3D_Folders, #gap, YCSR, WWidth-(#gap*2), ((#folders+#fcombo)*((#lh*2)+(#gap*2)))+(#gap*5), Language("TBManager","Folders"))
    YCSR+(#gap*5)
    TextGadget(#Text_PBFolder, #gap*3, YCSR, FoldersWidth, #lh, Folders(0))
    StringGadget(#String_PBFolder, #gap*3, YCSR+#lh, WWidth-(#gap*8)-BrWidth, #lh, "")
    ButtonGadget(#Button_PBFolderBrowse, WWidth-(#gap*4)-BrWidth, YCSR+#lh, BrWidth, #lh, BrowseStr$)
    YCSR+(#lh*2)+(#gap*2)
    TextGadget(#Text_ASMFolder, #gap*3, YCSR, FoldersWidth, #lh, Folders(1))
    StringGadget(#String_ASMFolder, #gap*3, YCSR+#lh, WWidth-(#gap*8)-BrWidth, #lh, "")
    ButtonGadget(#Button_ASMFolderBrowse, WWidth-(#gap*4)-BrWidth, YCSR+#lh, BrWidth, #lh, BrowseStr$)
    YCSR+(#lh*2)+(#gap*2)
    ;Subsystems
    GetSubsystems()
    TextGadget(#Text_Subsystem, #gap*3, YCSR, FoldersWidth, #lh, fcombo(0))
    ;ComboBoxGadget(#ComboBox_Subsystem, #gap*3, YCSR+#lh, WWidth-(#gap*8)-BrWidth, #lh*ListSize(Subsystems()))
    ComboBoxGadget(#ComboBox_Subsystem, #gap*3, YCSR+#lh, WWidth-(#gap*8)-BrWidth, #lh*1)
    ClearGadgetItems(#ComboBox_Subsystem)
    ForEach Subsystems()
      AddGadgetItem(#ComboBox_Subsystem,-1,Subsystems())
    Next
    SetGadgetState(#ComboBox_Subsystem,0)
    If PBSubsystem$
      CGIndex=CBFindStringExact(#ComboBox_Subsystem,PBSubsystem$)
      If CGIndex<>-1
        SetGadgetState(#ComboBox_Subsystem, CGIndex)
      EndIf
    EndIf
    ;Hotkeys
    YCSR+(#lh*2)+(#gap*2)
    YCSR = (#gap*7)+GadgetHeight(#Frame3D_cmdlops)
    ComboBoxGadget(#ComboBox_HotKeys, WWidth-(#gap*4)-BrWidth, YCSR-#gap, BrWidth, #lh)
    ClearGadgetItems(#ComboBox_HotKeys)
    AddGadgetItem(#ComboBox_HotKeys, -1, Language("TBManager","None"))
    TextGadget(#Text_HotKeys, WWidth-(#gap*5)-BrWidth-HKTextWidth, YCSR, HKTextWidth, #lh, HKText$, #PB_Text_Right)
    ForEach HotK()
      AddGadgetItem(#ComboBox_HotKeys, -1, "Alt+"+HotK())
    Next
    SetGadgetState(#ComboBox_HotKeys, 0)
    vhotk=Val(CHotK$)
    If vhotk&#PB_Shortcut_Alt
      CHotK$="Alt+"
      vhotk&(~#PB_Shortcut_Alt)
      CHotK$+Chr(vhotk)
    ElseIf vhotk&#PB_Shortcut_Control
      CHotK$="Ctrl+"
      vhotk&(~#PB_Shortcut_Control)
      CHotK$+Chr(vhotk)
    EndIf
    If CHotK$
      CGIndex=CBFindStringExact(#ComboBox_HotKeys,CHotK$)
      If CGIndex<>-1
        SetGadgetState(#ComboBox_HotKeys, CGIndex)
      EndIf
    EndIf
    ;Console
    YCSR = (#gap*3)+GadgetHeight(#Frame3D_cmdlops)+GadgetHeight(#Frame3D_Folders)
    FrameGadget(#Frame3D_TailBiteConsole, #gap, YCSR, WWidth-(#gap*2), (#lh*4)+(#gap*9),ReplaceString(Language("TBManager","Version"),"%version%",Version$))
    ContainerGadget(#Container1,#gap+WWidth-(#gap*4)-24,YCSR+(#lh*4)+(#gap*7)-24,24,24,#PB_Container_BorderLess)
    CheckManagerOnTop(1)
    CloseGadgetList()
    
    YCSR+(#gap*5)
    TextGadget(#Text_SourceFolder, #gap*3, YCSR, WWidth-(#gap*8)-BrWidth, #lh, Language("TBManager","SelectFile"))
    YCSR+#lh
    If FileSize(PBSourceFile$)=0
      PBSourceFile$ = ""
    EndIf
    StringGadget(#String_SourceFolder, #gap*3, YCSR, WWidth-(#gap*9)-BrWidth-PickWidth, #lh, PBSourceFile$)
    ButtonGadget(#Button_Pick_current, WWidth-(#gap*5)-BrWidth-PickWidth, YCSR, PickWidth, #lh, PickText$)
    CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
      DisableGadget(#Button_Pick_current, 1);not implemented on linux/OSX
    CompilerEndIf
    ButtonGadget(#Button_SourceFolderBrowse, WWidth-(#gap*4)-BrWidth, YCSR, BrWidth, #lh, BrowseStr$)
    YCSR+#gap+#lh
    ButtonGadget(#Button_Process, #gap*3, YCSR, TBCWidth, #lh, TBCProcess$)
    ButtonGadget(#Button_CheckErrors, (#gap*4)+TBCWidth, YCSR, TBCWidth, #lh, TBCCheck$)
    YCSR+#gap*2+#lh
    TextGadget(#Text_TBFolder,#gap*3,YCSR,WWidth-(#gap*12),#lh,Language("TBManager","TBFolder")+" "+TBFolder$)
    YCSR = (#gap*4)+GadgetHeight(#Frame3D_cmdlops)+GadgetHeight(#Frame3D_Folders)+GadgetHeight(#Frame3D_TailBiteConsole)
    ButtonGadget(#Button_CheckUpdates, #gap, YCSR, UpdateWidth, #lh, Update$)
    ButtonGadget(#Button_ExtractSources, (#gap*2)+UpdateWidth, YCSR, ExtractWidth, #lh, Extract$)
    CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
      DisableGadget(#Button_CheckUpdates,1);not implemented
      DisableGadget(#Button_ExtractSources,1)
      GadgetToolTip(#Button_ExtractSources, "Source is already in the TailBite directory")
    CompilerEndIf
    langw=WWidth-((ExitWidth+#gap)*3+UpdateWidth+ExtractWidth+(#gap*4))-IconExpandSize
    If langw < 10;happens with a few languages. EDIT 21/09/09: changed to 10 so box is always visible (becomes almost invisible on OSX sometimes.
      WWidth+100;make extra space for it, so that gtk_widget_set_size_request assertion width >=-1 (linux) does not fail
      ;perhaps not the best solution, but it makes the language box always readable like this - lexvictory 13-02-09
      ProcedureReturn Open_Window_TBManager()
    EndIf
    ;Language ComboBox
    GetLanguages()
    ;ComboBoxGadget(#ComboBox_Language,(#gap*3)+UpdateWidth+ExtractWidth, YCSR, langw, #lh*(ListSize(Languages())+1))
    If Not IsGadget(#ComboBox_Language)
      ComboBoxGadget(#ComboBox_Language,(#gap*3)+UpdateWidth+ExtractWidth, YCSR, langw, #lh)
    Else
      ResizeGadget(#ComboBox_Language,(#gap*3)+UpdateWidth+ExtractWidth, YCSR, langw, #lh)
    EndIf
    ClearGadgetItems(#ComboBox_Language)
    ForEach Languages()
      AddGadgetItem(#ComboBox_Language,-1,Languages())
    Next
    SetGadgetState(#ComboBox_Language,0)
    If Language$
      CGIndex = CBFindStringExact(#ComboBox_Language,Language$)
      If CGIndex<>-1
        SetGadgetState(#ComboBox_Language, CGIndex)
      EndIf
    EndIf
    ButtonGadget(#Button_Help, WWidth-((ExitWidth+#gap)*3)-IconExpandSize, YCSR, ExitWidth, #lh, HelpStr$)
    ButtonGadget(#Button_Save, WWidth-((ExitWidth+#gap)*2)-IconExpandSize, YCSR, ExitWidth, #lh, SaveStr$)
    DisableGadget(#Button_Save, #True)
    ButtonGadget(#Button_Exit, WWidth-ExitWidth-#gap-IconExpandSize, YCSR, ExitWidth, #lh, ExitStr$)
    ContainerGadget(#Container2,WWidth-(#gap/2)-IconExpandSize,YCSR+1,IconExpandSize,#lh,#PB_Container_BorderLess)
      CheckExpand(1)
    CloseGadgetList()
    SetGadgetText(#String_PBFolder, PBFolder$)
    SetGadgetText(#String_ASMFolder, LibSourceFolder$)
    YCSR+#lh+#gap
    WHeight=YCSR
    ResizeWindow(#WID, WindowX(#WID), WindowY(#WID), WWidth, WHeight)
    FrameGadget(#Batch_Options,#gap,YCSR,WWidth-#gap*2,#hbatch-#gap*2,Language("TBManager","Batchoptions"))
    YCSR+(#gap*5)
    ButtonGadget(#Button_Addjob,#gap*3,YCSR,jobWidth,#lh,addjobStr$)
    ButtonGadget(#Button_Deletejob,#gap*4+jobWidth,YCSR,jobWidth,#lh,deletejobStr$)
    ButtonGadget(#Button_Run,#gap*5+jobWidth*2,YCSR,jobWidth,#lh,RunStr$)
    YCSR+#gap+#lh
    width=WWidth-(#gap*6)
    height=#hbatch-(#gap*10)-#lh
    ListIconGadget(#Listicon_jobs,#gap*3,YCSR,width,height,JobnameStr$,width-4,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect)
    YCSR+height+#gap
    
    HideWindow(#WID, #False)
    ;Enable autocomplete for Folders
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        If OpenLibrary(0, "shlwapi.dll")
          *SHAutoComplete = GetFunction(0, "SHAutoComplete")
          If *SHAutoComplete<>#Null
            CallFunctionFast(*SHAutoComplete, GadgetID(#String_PBFolder), #SHACF_AUTOAPPEND_FORCE_ON|#SHACF_AUTOSUGGEST_FORCE_ON|#SHACF_FILESYSTEM)
            CallFunctionFast(*SHAutoComplete, GadgetID(#String_ASMFolder), #SHACF_AUTOAPPEND_FORCE_ON|#SHACF_AUTOSUGGEST_FORCE_ON|#SHACF_FILESYSTEM)
            CallFunctionFast(*SHAutoComplete, GadgetID(#String_SourceFolder), #SHACF_AUTOAPPEND_FORCE_ON|#SHACF_AUTOSUGGEST_FORCE_ON|#SHACF_FILESYSTEM)
          EndIf
          CloseLibrary(0)
        EndIf
    CompilerEndSelect
    
    ;PB4.10 Enable Drag/Drop
    EnableWindowDrop(#WID,#PB_Drop_Files,#PB_Drag_Copy);PB4.30B2 bug Dropping of files not possible !
    If Batch_options
      ResizeWindow(#WID,#PB_Ignore,#PB_Ignore,#PB_Ignore,WHeight+#hbatch)
    EndIf
    If Focus<>-1
      SetActiveGadget(Focus)
    EndIf
  ;EndIf
EndProcedure

Procedure FindSubSystem()
  Protected State.l,tmp$,CGIndex.l
  
  State=GetGadgetState(#CheckBox_ThreadsafeOption)*1
  State+GetGadgetState(#CheckBox_UnicodeOption)*2
  If GetGadgetState(#CheckBox_MultiLibOption)
    State=0
  EndIf
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Select State
      Case 0 ; PureLibraries\UserLibraries
        tmp$= "PureLibraries\UserLibraries"
      Case 1 ; SubSystems\UserLibThreadSafe
        tmp$= "SubSystems\UserLibThreadSafe"
      Case 2 ; SubSystems\UserLibUnicode
        tmp$= "SubSystems\UserLibUnicode"
      Case 3 ; SubSystems\UserLibUnicodeThreadSafe
        tmp$= "SubSystems\UserLibUnicodeThreadSafe"
    EndSelect
  CompilerElse
    Select State
      Case 0 ; PureLibraries\UserLibraries
        tmp$= "purelibraries/userlibraries"
      Case 1 ; SubSystems\UserLibThreadSafe
        tmp$= "subsystems/userlibthreadsafe"
      Case 2 ; SubSystems\UserLibUnicode
        tmp$= "subsystems/userlibunicode"
      Case 3 ; SubSystems\UserLibUnicodeThreadSafe
        tmp$= "subsystems/userlibunicodethreadsafe"
    EndSelect
  CompilerEndIf
  CGIndex = CBFindStringExact(#ComboBox_Subsystem,tmp$,#True)
  If CGIndex<>-1
    SetGadgetState(#ComboBox_Subsystem, CGIndex)
  EndIf
  PBSubsystem$=GetGadgetText(#ComboBox_Subsystem)
EndProcedure

Procedure.s GetCommandlineoptions(Gadget)
  Protected CMDLOps$
  CMDLOps$=""
  
  If UseUserPrefsFile
    CMDLOps$ = "/PREF "+#DQUOTE$+TBPrefsFile$+#DQUOTE$
  EndIf
  
  If GetGadgetState(#CheckBox_AskDelete)
    CMDLOps$+" /ASKDELETE"
  EndIf
  If GetGadgetState(#CheckBox_DontMakeLib)
    CMDLOps$+" /DONTMAKELIB"
  EndIf
  If GetGadgetState(#CheckBox_KeepSrcFiles)
    CMDLOps$+" /KEEPSRCFILES"
  EndIf
  If GetGadgetState(#CheckBox_QuietMode)
    CMDLOps$+" /QUIETMODE"
  EndIf
  If GetGadgetState(#CheckBox_WriteBatch)
    CMDLOps$+" /WRITEBATCH"
  EndIf
  If GetGadgetState(#CheckBox_MultiLibOption)
    CMDLOps$+" /MULT"
  Else
    If GetGadgetState(#CheckBox_ThreadsafeOption)
      CMDLOps$+" /THRD"
    EndIf
    If GetGadgetState(#CheckBox_UnicodeOption)
      CMDLOps$+" /UCOD"
    EndIf
  EndIf
  If PBSubsystem$<>Userlibdir$
    CMDLOps$+" /SUBS:"+PBSubsystem$
  EndIf
  
  If Gadget=#Button_Process
    CMDLOps$+" /HWND:"+Str(WindowID(#WID))
  Else
    ;CMDLOps$+" /MULT"
  EndIf
  
  ProcedureReturn Trim(CMDLOps$)
EndProcedure

Procedure.l RunBatchjob(Options)
  Protected count.l,i.l,job$
  
  count=CountGadgetItems(#Listicon_jobs)
  If count
    For i=0 To count-1
      job$=GetGadgetItemText(#Listicon_jobs,i,0)
      If FileSize(PBSourceFile$)>=0
        If Not RunProgram(TBFolder$+"TailBite"+#SystemExeExt, job$, "",#PB_Program_Wait)
          TBError(Language("TBManager","Error"), 0, "")
          Break
        EndIf
      Else
        MessageRequester("TailBite", Language("TBManager","NoFile"))
        Break
      EndIf
    Next
  EndIf
  DisableButtons(#False)
EndProcedure

;-Start
Define EventID.l,CMDLOps$,text$,alreadyexist.l,count.l,temp$,sel.l,NewPBFolder$,NewLibSourceFolder$,PBProc.FindProcInfo
Define FilePath$,LastType.l,NewPBSourceFile$,*TBUpdater,TBSrc$,SrcPackSize.l,*SrcPack,*SrcPackSeeker,nURLs.l,nFiles.l
Define NewSrcPath$,SelSrcPath$,*Unpacked,FName$,Pos.l,DateCreated.l,DateAccessed.l,DateModified.l,File.l,Dir0.l
Define DName$,Dir1.l,File1.l,BatFileSize.l,*BatFile,*BatFileSeeker,*BatFileEnd,*NewBatFile,*NewBatFileSeeker,File2.l
Define ArgPref$,ToolsHK$
Define Mode.l,Size.l,FileSize.q

Open_Window_TBManager()

Repeat
  EventID = WaitWindowEvent(50)
  Select EventID
    Case 0
      If TailBiteInProgress
        If Not ProgramRunning(TailBiteInProgress)
          CloseProgram(TailBiteInProgress)
          TailBiteInProgress=0
          DisableButtons(#False)
        EndIf
      EndIf
;    Case #PB_Event_Menu
;      Select EventMenu()
;         Case #Button_Sticky
;           CheckManagerOnTop()
;           DisableGadget(#Button_Save, #False)
;         Case #Button_Expand
;           CheckExpand()
;           DisableGadget(#Button_Save, #False)
;      EndSelect
    Case #PB_Event_WindowDrop
      Select EventDropAction()
        Case #PB_Drag_Copy
          PBSourceFile$ = StringField(EventDropFiles(),1,Chr(10))
          SetGadgetText(#String_SourceFolder, PBSourceFile$)
          DisableGadget(#Button_Save, #False)
      EndSelect
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #Button_Run
          DisableButtons(#True)
          CreateThread(@RunBatchjob(),0)
        Case #Button_Sticky
          CheckManagerOnTop()
          DisableGadget(#Button_Save, #False)
        Case #Button_Expand
          CheckExpand()
          DisableGadget(#Button_Save, #False)
        Case #Button_Addjob
          CMDLOps$=GetCommandlineoptions(#Button_Addjob)
          PBSourceFile$ = RemoveString(GetGadgetText(#String_SourceFolder), q)
          
          text$=#DQUOTE$+PBSourceFile$+#DQUOTE$+" "+CMDLOps$
          
          ;check if already in list
          alreadyexist=0
          count=CountGadgetItems(#Listicon_jobs)
          If count
            For i=0 To count-1
              temp$=GetGadgetItemText(#Listicon_jobs,i,0)
              If temp$=text$
                alreadyexist=1
                Break
              EndIf
            Next
          EndIf
          
          If FileSize(PBSourceFile$)>=0 And alreadyexist=0
            AddGadgetItem(#Listicon_jobs,-1,Text$)
          EndIf
        Case #Button_Deletejob
          sel=GetGadgetState(#Listicon_jobs)
          If sel<>-1
            RemoveGadgetItem(#Listicon_jobs,sel)
          Else
            count=CountGadgetItems(#Listicon_jobs)
            If count
              RemoveGadgetItem(#Listicon_jobs,count-1)
            EndIf
          EndIf
        ;Case #ComboBox_Threads
        ;  Batch_threads=Val(GetGadgetText(#ComboBox_Threads))
        ;  DisableGadget(#Button_Save, #False)
        Case #CheckBox_AskDelete
          DisableGadget(#Button_Save, #False)
        Case #CheckBox_DontMakeLib
          DisableGadget(#Button_Save, #False)
        Case #CheckBox_KeepSrcFiles
          DisableGadget(#Button_Save, #False)
        Case #CheckBox_QuietMode
          DisableGadget(#Button_Save, #False)
        Case #CheckBox_WriteBatch
          DisableGadget(#Button_Save, #False)
        Case #CheckBox_ThreadsafeOption
          If GetGadgetState(#CheckBox_ThreadsafeOption)
            SetGadgetState(#CheckBox_MultiLibOption,0)
          EndIf
          DisableGadget(#Button_Save, #False)
          FindSubSystem()
        Case #CheckBox_UnicodeOption
          If GetGadgetState(#CheckBox_UnicodeOption)
            SetGadgetState(#CheckBox_MultiLibOption,0)
          EndIf
          DisableGadget(#Button_Save, #False)
          FindSubSystem()
        Case #CheckBox_MultiLibOption
          If GetGadgetState(#CheckBox_MultiLibOption)
            SetGadgetState(#CheckBox_ThreadsafeOption,0)
            SetGadgetState(#CheckBox_UnicodeOption,0)
          EndIf
          DisableGadget(#Button_Save, #False)
          FindSubSystem()
        Case #ComboBox_HotKeys
          DisableGadget(#Button_Save, #False)
        Case #String_PBFolder
          If EventType()=#PB_EventType_Change
            PBFolder$=GetGadgetText(#String_PBFolder)
            DisableGadget(#Button_Save, #False)
          EndIf
        Case #String_ASMFolder
          If EventType()=#PB_EventType_Change
            LibSourceFolder$=GetGadgetText(#String_ASMFolder)
            DisableGadget(#Button_Save, #False)
          EndIf
        Case #ComboBox_Language
          ;Select EventType()
          If Not Language$=GetGadgetText(#ComboBox_Language);cross platform way of seeing if langauge change is needed - lexvictory 13/02/09
            ;Case #PB_EventType_RightClick <-- I'm presuming that on windows this means the content has changed? - lexvictory
              Language$=GetGadgetText(#ComboBox_Language)
              LoadLanguage(TBFolder$+"Catalogs"+#DirSeparator+Language$+".catalog")
              Open_Window_TBManager()
              DisableGadget(#Button_Save, #False)
          ;EndSelect
          EndIf
        Case #ComboBox_Subsystem
          ;Select EventType()
          If Not PBSubsystem$=GetGadgetText(#ComboBox_Subsystem);see #combobox language
            ;Case #PB_EventType_RightClick
              PBSubsystem$=GetGadgetText(#ComboBox_Subsystem)
              DisableGadget(#Button_Save, #False)
          ;EndSelect
          EndIf
        Case #String_SourceFolder
          If EventType()=#PB_EventType_Change
            If FileSize(GetGadgetText(#String_SourceFolder))>=0
              If LCase(Right(GetGadgetText(#String_SourceFolder), 5))=".desc"
                DisableGadget(#Button_CheckErrors, #True)
              Else
                DisableGadget(#Button_CheckErrors, #False)
              EndIf
              DisableGadget(#Button_Save, #False)
              PBSourceFile$=GetGadgetText(#String_SourceFolder)
            EndIf
          EndIf
        Case #Button_PBFolderBrowse
          NewPBFolder$ = PathRequester(Language("TBManager","SelectPBFolder"), PBFolder$)
          If NewPBFolder$
            PBFolder$ = NewPBFolder$
            If Right(PBFolder$, 1)<>#DirSeparator
              PBFolder$+#DirSeparator
            EndIf
            SetGadgetText(#String_PBFolder, PBFolder$)
            DisableGadget(#Button_Save, #False)
          EndIf
        Case #Button_ASMFolderBrowse
          NewLibSourceFolder$ = PathRequester(Language("TBManager","SelectSourceFolder"), LibSourceFolder$)
          If NewLibSourceFolder$
            LibSourceFolder$ = NewLibSourceFolder$
            If Right(LibSourceFolder$, 1)<>#DirSeparator
              LibSourceFolder$+#DirSeparator
            EndIf
            SetGadgetText(#String_ASMFolder, LibSourceFolder$)
            DisableGadget(#Button_Save, #False)
          EndIf
        Case #Button_Pick_current
          PBProc\ProcessName$ = "PUREBASIC.EXE"
          PBProc\FindText$ = "PureBasic"
          PBProc\NoText$ = "PureBasic - Debug Output"
          GetProcessList(@PBProc)
          If GetProcessListResult$
            PBSourceFile$ = Trim(StringField(GetProcessListResult$,2,"-"))
            SetGadgetText(#String_SourceFolder, PBSourceFile$)
            DisableGadget(#Button_Save, #False)
          EndIf
        Case #Button_SourceFolderBrowse
          FilePath$ = GetGadgetText(#String_SourceFolder)
          If LCase(GetExtensionPart(LastFile$))="desc"
            LastType = 1
          Else
            LastType = 0
          EndIf
          NewPBSourceFile$ = OpenFileRequester(Language("TBManager","SelectFile"), FilePath$, Language("TBManager","Extensions"), LastType)
          If NewPBSourceFile$
            PBSourceFile$ = NewPBSourceFile$
            SetGadgetText(#String_SourceFolder, PBSourceFile$)
            DisableGadget(#Button_Save, #False)
          EndIf
        Case #Button_Process
          DisableButtons(#True)
          CMDLOps$ = GetCommandlineoptions(#Button_Process)
          PBSourceFile$ = RemoveString(GetGadgetText(#String_SourceFolder), q)
          If FileSize(PBSourceFile$)>=0
            CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
              TailBiteInProgress=RunProgram(TBFolder$+"TailBite"+#SystemExeExt, #DQUOTE$+PBSourceFile$+#DQUOTE$+" "+CMDLOps$, "",#PB_Program_Open)
            CompilerElse
              TailBiteInProgress=RunProgram(TBFolder$+"TailBite.app/Contents/MacOS/TailBite", #DQUOTE$+PBSourceFile$+#DQUOTE$+" "+CMDLOps$, "",#PB_Program_Open)
            CompilerEndIf
            If TailBiteInProgress
              LastFile$ = PBSourceFile$
            Else
              TBError(Language("TBManager","Error"), 0, "")
              DisableButtons(#False)
            EndIf
          Else
            MessageRequester("TailBite", Language("TBManager","NoFile")+Chr(13)+PBSourceFile$)
            DisableButtons(#False)
          EndIf
        Case #Button_CheckErrors
          DisableButtons(#True)
          PBSourceFile$ = GetGadgetText(#String_SourceFolder)
          If FileSize(PBSourceFile$)>=0
            If LCase(GetExtensionPart(PBSourceFile$))<>"desc"
              If PBCompile(PBSourceFile$, "", "", 0, "", 0)
                MessageRequester("TailBite", Language("TBManager","NoError"))
              EndIf
            EndIf
          Else
            MessageRequester("TailBite", Language("TBManager","NoFile"))
          EndIf
          DisableButtons(#False)
        Case #Button_CheckUpdates
          DisableButtons(#True)
          CreatePath(TBTempPath$)
          If CreateFile(0, TBTempPath$+"TBUpdater.pack")
            WriteData(0, ?TBUpdater, ?TBUpdaterEnd-?TBUpdater)
            CloseFile(0)
            If OpenPack(TBTempPath$+"TBUpdater.pack")
              *TBUpdater = NextPackFile()
              If *TBUpdater And CreateFile(0, TBTempPath$+"TBUpdater.exe")
                WriteData(0, *TBUpdater, PackFileSize())
                CloseFile(0)
                ClosePack()
                DeleteFile(TBTempPath$+"TBUpdater.pack")
                RunProgram(TBTempPath$+"TBUpdater.exe",Version$,TBFolder$)
                End
              Else
                TBError(Language("TBManager","TBUpdaterError2"), 0, "")
              EndIf
              ClosePack()
              DeleteFile(TBTempPath$+"TBUpdater.pack")
            Else
              TBError(Language("TBManager","TBUpdaterError3"), 0, "")
            EndIf
          Else
            TBError(Language("TBManager","TBUpdaterError"), 0, "")
          EndIf
          DisableButtons(#False)
        Case #Button_ExtractSources
          DisableButtons(#True)
          TBSrc$ = TBFolder$+"src.pack"
          If FileSize(TBSrc$)=-1
            TBSrc$ = OpenFileRequester(Language("TBManager","TBSourcePack"), TBSrc$, Language("TBManager","TBSourcePack")+" (src.pack)|src.pack", 0)
          EndIf
          If GetFilePart(TBSrc$)<>"src.pack"
            MessageRequester("TailBite Manager", Language("TBManager","TBSourcePack2"))
          ElseIf ReadFile(0, TBSrc$)
            SrcPackSize = Lof(0)
            *SrcPack = AllocateMemory(SrcPackSize)
            ReadData(0, *SrcPack, SrcPackSize)
            CloseFile(0)
            *SrcPackSeeker = *SrcPack+Len(PeekS(*SrcPack))+1
            nURLs = Val(PeekS(*SrcPackSeeker))
            For i=0 To nURLs
              *SrcPackSeeker+Len(PeekS(*SrcPackSeeker))+1
            Next
            nFiles = Val(PeekS(*SrcPackSeeker))
            *SrcPackSeeker+Len(Str(nFiles))+1
            TBSrc$ = Left(TBSrc$, Len(TBSrc$)-4)+"flat.pack"
            If CreateFile(0, TBSrc$)
              WriteData(0, *SrcPackSeeker, SrcPackSize-(*SrcPackSeeker-*SrcPack))
              CloseFile(0)
            EndIf
            FreeMemory(*SrcPack)
            NewSrcPath$ = ""
            If FileSize(SrcPath$)<>-2
              CreateDirectory(SrcPath$)
              NewSrcPath$ = SrcPath$
              If NewSrcPath$ And Right(NewSrcPath$, 1)<>#DirSeparator:NewSrcPath$+#DirSeparator:EndIf
            EndIf
            SelSrcPath$ = PathRequester(Language("TBManager","TBSourcePack3"), SrcPath$)
            If SelSrcPath$ And Right(SelSrcPath$, 1)<>#DirSeparator:SelSrcPath$+#DirSeparator:EndIf
            If NewSrcPath$ And LCase(NewSrcPath$)<>LCase(SelSrcPath$)
              DeleteDirectory(NewSrcPath$, "", #PB_FileSystem_Recursive)
            EndIf
            If SelSrcPath$ And FileSize(TBSrc$)<>-1
              SrcPath$ = SelSrcPath$
              If OpenPack(TBSrc$)
                Mode=0
                Repeat
                  *Unpacked = NextPackFile()
                  If *Unpacked
                    If Mode=0
                      If PeekS(*Unpacked,3,#PB_Ascii)="DIR"
                        Mode=#PB_Ascii
                        Size=1
                      Else
                        Mode=#PB_Unicode
                        Size=2
                      EndIf
                    EndIf
                    FName$ = PeekS(*Unpacked,-1,Mode)
                    If FName$="DIR"
                      FName$ = PeekS(*Unpacked+(4*Size),-1,Mode)
                      If FileSize(SrcPath$+FName$)<>-2
                        CreateDirectory(SrcPath$+FName$)
                      EndIf
                    Else
                      CallDebugger
                      Pos=(Len(FName$)+1)*Size
                      DateCreated=PeekL(*Unpacked+Pos):Pos+4
                      DateAccessed=PeekL(*Unpacked+Pos):Pos+4
                      DateModified=PeekL(*Unpacked+Pos):Pos+4
                      FileSize=PeekQ(*Unpacked+Pos):Pos+8
                      If FileSize
                        *Unpacked = NextPackFile()
                        If *Unpacked
                          File=CreateFile(#PB_Any, SrcPath$+FName$)
                          If File
                            WriteData(File, *Unpacked, PackFileSize())
                            CloseFile(File)
                          EndIf
                        EndIf
                      Else
                        File=CreateFile(#PB_Any, SrcPath$+FName$)
                        If File
                          CloseFile(File)
                        EndIf
                      EndIf
                      SetFileDate(SrcPath$+FName$,#PB_Date_Created,DateCreated)
                      SetFileDate(SrcPath$+FName$,#PB_Date_Accessed,DateAccessed)
                      SetFileDate(SrcPath$+FName$,#PB_Date_Modified,DateModified)
                    EndIf
                  EndIf
                Until *Unpacked=0
                ClosePack()
              Else
                MessageRequester("TailBite Manager", Language("TBManager","TBSourcePack4"))
              EndIf
              DeleteFile(TBSrc$)
            EndIf
            If SelSrcPath$ And GetGadgetState(#CheckBox_WriteBatch)
              If SrcPath$<>OrigSrcPath$
                Dir0=ExamineDirectory(#PB_Any, SrcPath$+"Addons"+#DirSeparator, "")
                If Dir0
                  While NextDirectoryEntry(Dir0)
                    If DirectoryEntryName(Dir0)<>"." And DirectoryEntryName(Dir0)<>".."
                      If FileSize(SrcPath$+"Addons"+#DirSeparator+DirectoryEntryName(Dir0))=-2
                        DName$ = SrcPath$+"Addons"+#DirSeparator+DirectoryEntryName(Dir0)+#DirSeparator
                        Dir1=ExamineDirectory(#PB_Any, DName$, "*"+#SystemBatchExt)
                        If Dir1
                          While NextDirectoryEntry(Dir1)
                            If DirectoryEntryType(Dir1)=#PB_DirectoryEntry_File And Right(DirectoryEntryName(Dir1), 8)="Build"+#SystemBatchExt
                              File1=ReadFile(#PB_Any, DName$+DirectoryEntryName(Dir1))
                              If File1
                                BatFileSize = Lof(File1)
                                If BatFileSize
                                  *BatFile = AllocateMemory(BatFileSize)
                                  ReadData(1, *BatFile, BatFileSize)
                                  *BatFileSeeker = *BatFile
                                  *BatFileEnd = *BatFile+BatFileSize
                                  *NewBatFile = AllocateMemory(BatFileSize*2)
                                  *NewBatFileSeeker = *NewBatFile
                                  While *BatFileSeeker<*BatFileEnd
                                    If PeekS(*BatFileSeeker, Len(OrigSrcPath$))=OrigSrcPath$
                                      PokeS(*NewBatFileSeeker, SrcPath$)
                                      *NewBatFileSeeker+Len(SrcPath$)
                                      *BatFileSeeker+Len(OrigSrcPath$)
                                    Else
                                      PokeB(*NewBatFileSeeker, PeekB(*BatFileSeeker))
                                      *NewBatFileSeeker+1
                                      *BatFileSeeker+1
                                    EndIf
                                  Wend
                                  FreeMemory(*BatFile)
                                  File2=CreateFile(#PB_Any, DName$+DirectoryEntryName(Dir1))
                                  If File2
                                    WriteData(File2, *NewBatFile, *NewBatFileSeeker-*NewBatFile)
                                    CloseFile(File2)
                                    FreeMemory(*NewBatFile)
                                  EndIf
                                EndIf
                                CloseFile(File1)
                              EndIf
                            EndIf
                          Wend
                          FinishDirectory(Dir1)
                        EndIf
                      EndIf
                    EndIf
                  Wend
                EndIf
              EndIf
            EndIf
          EndIf
          DisableButtons(#False)
        Case #Button_Help
          If FileSize(PBFolder$+"Help"+#DirSeparator+"TailBite.chm")<>-1
            OpenHelp(PBFolder$+"Help"+#DirSeparator+"TailBite.chm", "Reference/usingtailbitemanager.html")
          Else
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              OpenHelp(PBFolder$+"help"+#DirSeparator+"tailbite"+#DirSeparator+"index.html", "Reference/usingtailbitemanager.html")
            CompilerElse
              RunProgram("/etc/alternatives/x-www-browser", #DQUOTE$+PBFolder$+"help"+#DirSeparator+"tailbite"+#DirSeparator+"Reference/usingtailbitemanager.html", GetCurrentDirectory())
            CompilerEndIf
          EndIf
        Case #Button_Save
          PBSourceFile$=GetGadgetText(#String_SourceFolder)
          PBSubsystem$=GetGadgetText(#ComboBox_Subsystem)
          If FileSize(PBSourceFile$)<>-1
            LastFile$ = PBSourceFile$
          EndIf
          TBSavePreferences()
          ArgPref$ = #DQUOTE$+"%FILE"+#DQUOTE$+" "+#DQUOTE$+"%TEMPFILE"+#DQUOTE$
          If GetGadgetState(#CheckBox_AskDelete):ArgPref$+" /ASKDELETE":EndIf
          If GetGadgetState(#CheckBox_DontMakeLib):ArgPref$+" /DONTMAKELIB":EndIf
          If GetGadgetState(#CheckBox_KeepSrcFiles):ArgPref$+" /KEEPSRCFILES":EndIf
          If GetGadgetState(#CheckBox_QuietMode):ArgPref$+" /QUIETMODE":EndIf
          If GetGadgetState(#CheckBox_WriteBatch):ArgPref$+" /WRITEBATCH":EndIf
          ;Threadsafe / Unicode Option
          If GetGadgetState(#CheckBox_ThreadsafeOption):ArgPref$+" /THRD":EndIf
          If GetGadgetState(#CheckBox_UnicodeOption):ArgPref$+" /UCOD":EndIf
          If GetGadgetState(#CheckBox_MultiLibOption):ArgPref$+" /MULT":EndIf
          ;Subsystem
          If PBSubsystem$<>Userlibdir$:ArgPref$+" /SUBS:"+PBSubsystem$:EndIf
          ToolsHK$ = GetGadgetText(#ComboBox_HotKeys)
          TBSaveToolsPrefs(ArgPref$,ToolsHK$)
          DisableGadget(#Button_Save, #True)
        Case #Button_Exit
          Quit = 1
      EndSelect
    Case #PB_Event_CloseWindow
      Quit = 1
  EndSelect
Until Quit

End

DataSection
  TBUpdater:
  CompilerIf #PB_Compiler_Debugger=0 And #PB_Compiler_OS = #PB_OS_Windows
    IncludeBinary "TBUpdater.pack"
  CompilerEndIf
  TBUpdaterEnd:
  
  Sticky1:
    IncludeBinary "Images"+#DirSeparator+"Sticky1.png"
  Sticky1e:
  Sticky2:
    IncludeBinary "Images"+#DirSeparator+"Sticky2.png"
  Sticky2e:
  Expand1:
    IncludeBinary "Images"+#DirSeparator+"Arrow_up.png"
  Expand1e:
  Expand2:
    IncludeBinary "Images"+#DirSeparator+"Arrow_down.png"
  Expand2e:
EndDataSection
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 748
; FirstLine = 744
; Folding = -------------------------------
; EnableXP
; EnableAdmin
; EnableOnError
; UseIcon = TB_icon_0.2.ico
; Executable = tbmanager
; CompileSourceDirectory
; EnableNT4