
Userlibdir$           = "purelibraries"+#DirSeparator+"userlibraries"+#DirSeparator;lexvictory change to lowercase 06/02/09 - windows will find it either way, linux won't
PBUserLibraryFolder$  = Userlibdir$ ; <- this will change to subsystem folder

CompilerIf Defined(TB_Installer,#PB_Constant)=0
  #TB_Installer=0
CompilerEndIf

  ; -gnozal : some procedures for PB4 version compatibility
  Procedure.s GetPBCompilerVersion(Compiler$) 
    Protected PosV.l,PosP.l,Output.s,Compiler.l
    
    Compiler = RunProgram(Compiler$, #Switch_Version, "", #PB_Program_Open|#PB_Program_Read|#PB_Program_Hide) 
    Output = ""
    If Compiler
      While ProgramRunning(Compiler)
        Output + UCase(ReadProgramString(Compiler))
      Wend
      CloseProgram(Compiler)
    EndIf
    
    ProcedureReturn Output
  EndProcedure
  Procedure CheckPBVersion() ; gnozal
    Protected CompilerPath.s, Len.l
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows
        CompilerPath = PBCompilerFolder$+"pbcompiler.exe"
      CompilerCase #PB_OS_Linux
        CompilerPath = PBCompilerFolder$+"pbcompiler"  
      CompilerCase #PB_OS_MacOS
        CompilerPath = PBCompilerFolder$+"pbcompiler"
    CompilerEndSelect
    Len = FileSize(CompilerPath)
    If Len > 0
      ; gnozal
      PBVersion$ = GetPBCompilerVersion(CompilerPath)
      If FindString(PBVersion$,"X64",1)
        PBVersionX64=1
      Else
        PBVersionX64=0
      EndIf
      ;
      PBVersion$ = RemoveString(PBVersion$, "PUREBASIC")
      PBVersion$ = RemoveString(PBVersion$, "WINDOWS")
      PBVersion$ = RemoveString(PBVersion$, "LINUX")
      PBVersion$ = RemoveString(PBVersion$, "MACOS X")
      PBVersion$ = RemoveString(PBVersion$, "X86")
      PBVersion$ = RemoveString(PBVersion$, "X64")
      PBVersion$ = RemoveString(PBVersion$, "(")
      PBVersion$ = RemoveString(PBVersion$, ")")
      PBVersion$ = RemoveString(PBVersion$, "-")
      PBVersion$ = RemoveString(PBVersion$, "V")
      PBVersion$ = Trim(PBVersion$)
      PBnbVersion=Val(RemoveString(PBVersion$,"."))
      ;
    EndIf
  EndProcedure
; -Main

Procedure.l CreatePath(Path$)
  Protected res.l=1,idx.l,part$,temppath$
  
  If FileSize(Path$)<>-2
    idx=1
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      part$=StringField(Path$,idx,#DirSeparator)
      ;Debug "windows createpath"
    CompilerElse
      Path$ = Right(Path$, Len(Path$)-1)
      part$="/"+StringField(Path$,idx,#DirSeparator)
      ;Debug part$
    CompilerEndIf
    temppath$=""
    While part$
      temppath$+part$+#DirSeparator
      If FileSize(temppath$)=-1
        If CreateDirectory(temppath$)=0
          res=0
          ;MessageRequester("CreatePath", "Could not create "+temppath$)
          Break ; exit on error
        EndIf
      EndIf
      idx+1
      part$=StringField(Path$,idx,#DirSeparator)
    Wend
  EndIf
  
  ProcedureReturn res
EndProcedure

CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0;dont need this if compiling DLL

Procedure.l TBLoadPreferences()
  Protected PrefsFound.l=0,Mode.l,Folder$,Text$,Dir.l
  
  ; Mode = 0 Prefs loaded by PBVersion in #CSIDL_APPDATA / Mode = 1 Prefs loaded in TailBite folder (the old way)
  Mode=0
  ;If FileSize(GetCurrentDirectory()+"TailBite.prefs")>=0
  If FileSize(GetPathPart(ProgramFilename())+"TailBite.prefs")>=0
    Mode=1
  EndIf
  
  Folder$=GetPBFolder()
  If UseUserPrefsFile;parameter specified prefs
    TBPreferencesPath$ = GetPathPart(TBPrefsFile$)
  ElseIf Mode ; Prefs loaded in TailBite folder (the old way)
    TBPreferencesPath$=GetPathPart(ProgramFilename())
    TBPrefsFile$=TBPreferencesPath$+"TailBite.prefs"
  Else ; Prefs loaded by PBVersion in #CSIDL_APPDATA
    ;TBPreferencesPath$=SpecialFolder(#CSIDL_APPDATA) + "\TailBite\"
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      TBPreferencesPath$=GetEnvironmentVariable("APPDATA") + #DirSeparator+"TailBite"+#DirSeparator
    CompilerElse
      TBPreferencesPath$=GetEnvironmentVariable("HOME") + #DirSeparator+".tailbite"+#DirSeparator
    CompilerEndIf
    If Folder$="" ; if the PureBasic registry key was not found default to "TailBite.prefs"
      TBPrefsFile$=TBPreferencesPath$+"TailBite.prefs"
    Else
      PBCompilerFolder$ = Folder$ + "compilers"+#DirSeparator
      CheckPBVersion() ; gnozal : for PB4 version compatibility
      If PBVersionX64
        TBPrefsFile$=TBPreferencesPath$+"TailBite_"+Str(PBnbVersion)+"X64.prefs"
      Else
        TBPrefsFile$=TBPreferencesPath$+"TailBite_"+Str(PBnbVersion)+".prefs"
      EndIf
    EndIf
  EndIf
  
  If OpenPreferences(TBPrefsFile$)
    Debug "Preferences "+TBPrefsFile$+" loaded"
    PrefsFound=1
  EndIf
    If PBCompilerFolder$ And Folder$<>""
      PBFolder$ = Folder$
    Else
      PBFolder$ = ReadPreferenceString("PBFolder", Folder$)
    EndIf
    
    CompilerIf #PB_Compiler_Debugger And (Defined(TB_TestDontSetTBDirToSourceDir, #PB_Constant) = 0)
      TBFolder$ = GetCurrentDirectory()
    CompilerElse
      TBFolder$ = ReadPreferenceString("TBFolder", PBFolder$ + "tailbite"+#DirSeparator)
     CompilerEndIf
     
    If TBFolder$ And Right(TBFolder$, 1)<>#DirSeparator
      TBFolder$+#DirSeparator
    EndIf
    If Mode
      Debug "Prefs loaded in TailBite folder (the old way)"
      LibSourceFolder$ = ReadPreferenceString("LibSourceFolder", TBFolder$+#DirSeparator+"Library Sources"+#DirSeparator)
    Else
      Debug "Prefs loaded by PBVersion in #CSIDL_APPDATA"
      LibSourceFolder$ = ReadPreferenceString("LibSourceFolder", SpecialFolder(#CSIDL_PERSONAL)+#DirSeparator+"TailBite Library Sources"+#DirSeparator)
    EndIf
    If (PBCompilerFolder$ = "") Or (PBnbVersion = 0);pbcompiler not found bug lexvictory 13/05/09
      PBCompilerFolder$=PBFolder$+"compilers"+#DirSeparator
      CheckPBVersion() ; gnozal : for PB4 version compatibility
    EndIf
    
    CreatePath(LibSourceFolder$)
    LastFile$ = ReadPreferenceString("LastFile", "")
    ManagerOnTop = ReadPreferenceLong("ManagerOnTop", 0)
    PBSubsystem$ = ReadPreferenceString("Subsystem", Userlibdir$)
    Language$ = ReadPreferenceString("Language", "English")
    Batch_options = ReadPreferenceLong("Batchoptions",0)
    Batch_threads = ReadPreferenceLong("Batchthreads",0)
    If Language$
      LoadLanguage(TBFolder$+"Catalogs"+#DirSeparator+Language$+".catalog")
    EndIf
  ClosePreferences()
  
  TBTempPath$ = GetTemporaryDirectory()+"TBTemp"+#DirSeparator
  CreatePath(TBTempPath$)
  
  ; For PB >= 4.10
  If PBnbVersion > 402
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      PBPreferencesPath$ = GetEnvironmentVariable("APPDATA") + #DirSeparator+"Purebasic"+#DirSeparator
    CompilerElse
      PBPreferencesPath$ = GetEnvironmentVariable("HOME") + #DirSeparator+".purebasic"+#DirSeparator
    CompilerEndIf
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
        If PBnbVersion >= 510 ;- gnozal PB5.10 fix
          IsPB510 = #True
        EndIf
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
  
  ;Find Librarymaker.exe
  Define  dontdolibmakersearch.l; if set, library maker found in expected location (pb4.30), and no search needs to be done (faster startup) - lexvictory 13/02/09
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    #libmaker = "LibraryMaker"
    If FileSize(PBFolder$+"SDK\"+#libmaker+".exe") > 0
      dontdolibmakersearch = 1
      LibraryMaker$ = PBFolder$+"SDK\"+#libmaker+".exe"
    EndIf
  CompilerElse
    #libmaker = "pblibrarymaker"
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      If FileSize(PBFolder$+"/compilers/"+#libmaker) > 0
        dontdolibmakersearch = 1
        LibraryMaker$ = PBFolder$+"/compilers/"+#libmaker
      EndIf
    CompilerElse
      If FileSize(PBFolder$+"compilers/"+#libmaker) > 0;powerpc unsupported currently
        dontdolibmakersearch = 1
        LibraryMaker$ = PBFolder$+"compilers/"+#libmaker
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
  WriteLog("Mode="+Str(Mode))
  WriteLog("GetPBFolder()="+Folder$)
  WriteLog("TBPreferencesPath$="+TBPreferencesPath$)
  WriteLog("TBPrefsFile$="+TBPrefsFile$)
  WriteLog("PBCompilerFolder$="+PBCompilerFolder$)
  WriteLog("PrefsFound="+Str(PrefsFound))
  WriteLog("PBFolder$="+PBFolder$)
  WriteLog("TBFolder$="+TBFolder$)
  WriteLog("LibSourceFolder$="+LibSourceFolder$)
  WriteLog("LastFile$="+LastFile$)
  WriteLog("ManagerOnTop="+Str(ManagerOnTop))
  WriteLog("PBSubsystem$="+PBSubsystem$)
  WriteLog("Language$="+Language$)
  WriteLog("PBPreferencesPath$="+PBPreferencesPath$)
  WriteLog("TBTempPath$="+TBTempPath$)
  WriteLog("pb_align$="+pb_align$)
  WriteLog("pb_bssalign$="+pb_bssalign$)
  WriteLog("LibraryMakerOptions$="+LibraryMakerOptions$)
  WriteLog("IsPB410="+Str(IsPB410))
  WriteLog("LibraryMaker$="+LibraryMaker$)
  
  If PBnbVersion=0 ; PureBasic Version could not be identyfied
    If #TB_Installer=0 ; Ignore PB-Version only in install-mode
      If FileSize(PBCompilerFolder$+"pbcompiler"+#SystemExeExt)=-1
        
        Debug PBCompilerFolder$+"pbcompiler"+#SystemExeExt
        
        
        Text$=Language("TailBite", "SorryNeedPBCompiler")+Chr(10)+PBCompilerFolder$+"pbcompiler"+#SystemExeExt+Chr(10)
        TBError(Text$, 0, "", #False)
        End
      Else
        Text$=Language("TailBite", "Version")
        Text$=ReplaceString(Text$,"%pbcompiler%",PBCompilerFolder$+"pbcompiler"+#SystemExeExt)
        Text$=ReplaceString(Text$,"%version%",PBVersion$+"/"+Str(PBnbVersion))
        TBError(Text$, 0, "", #False)
        End
      EndIf
    EndIf
  ElseIf PBnbVersion < 400
    Text$=ReplaceString(Language("TailBite", "PB4XXWarning"),"%version%",PBVersion$)
    TBError(Text$, 0, "", #False)
    End 
  EndIf
  
  ProcedureReturn PrefsFound
EndProcedure

CompilerEndIf

Procedure TBSavePreferences()
  ; when TailBite is installed on removable media set the prefspath to that folder
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    If GetDriveType_(TBFolder$)=#DRIVE_REMOVABLE
      TBPreferencesPath$=TBFolder$
      TBPrefsFile$=TBPreferencesPath$+"TailBite.prefs"
    EndIf
  CompilerEndIf
  ;create the preference path if needed
  CreatePath(TBPreferencesPath$)
  
  If CreatePreferences(TBPrefsFile$)
    WritePreferenceString("PBFolder", PBFolder$)
    WritePreferenceString("TBFolder", TBFolder$)
    WritePreferenceString("LibSourceFolder", LibSourceFolder$)
    WritePreferenceString("LastFile", LastFile$)
    WritePreferenceLong("ManagerOnTop", ManagerOnTop)
    WritePreferenceString("Subsystem",PBSubsystem$)
    WritePreferenceString("Language", Language$)
    WritePreferenceLong("Batchoptions",Batch_options)
    WritePreferenceLong("Batchthreads",Batch_threads)
    ClosePreferences()
  EndIf
EndProcedure
Procedure TBSaveToolsPrefs(ArgPref$,ToolsHK$,Inst=0)
  Protected TPFName$,AlreadyPresent.l,ToolCount.l,searching.l,ToolIndex.l,i.l,sValue.l
  
  If PBPreferencesPath$="" ; No PureBasic Preferences found = exit
    ProcedureReturn
  EndIf
  
  TPFName$ = PBPreferencesPath$+"Tools.prefs"
  If inst
    AlreadyPresent=0
    If FileSize(TPFName$)<>-1
      If OpenPreferences(TPFName$)
        If PreferenceGroup("ToolsInfo")
          ToolCount = Val(ReadPreferenceString("ToolCount", ""))
        EndIf
        searching = 0
        While searching<=ToolCount And AlreadyPresent=0
          If PreferenceGroup("Tool_"+Str(searching))
            If ReadPreferenceString("Command", "")=TBFolder$+"TailBite"+#SystemExeExt
              AlreadyPresent = 1
            EndIf
          EndIf
          searching+1
        Wend
        ClosePreferences()
      EndIf
    Else
      If CreatePreferences(TPFName$)
        PreferenceComment("; PureBasic IDE ToolsMenu Configuration")
        PreferenceComment("")
        PreferenceGroup("ToolsInfo")
        WritePreferenceString("ToolCount", "0")
        PreferenceComment("")
        PreferenceComment("")
        ClosePreferences()
      EndIf
    EndIf
    If AlreadyPresent=0
      If OpenPreferences(TPFName$)
        PreferenceGroup("ToolsInfo")
        ToolCount = Val(ReadPreferenceString("ToolCount", ""))
        WritePreferenceString("ToolCount", Str(ToolCount+1))
        PreferenceGroup("Tool_"+Str(ToolCount))
        WritePreferenceString("Command", TBFolder$+"TailBite"+#SystemExeExt)
        WritePreferenceString("Arguments", #DQUOTE$+"%FILE"+#DQUOTE$+" "+#DQUOTE$+"%TEMPFILE"+#DQUOTE$)
        WritePreferenceString("WorkingDir", "")
        WritePreferenceString("MenuItemName", "TailBite")
        WritePreferenceString("ShortCut", "")
        WritePreferenceString("ConfigLine", "")
        WritePreferenceLong("Trigger", 0)
        WritePreferenceLong("Flags", 0)
        WritePreferenceLong("ReloadSource", 0)
        WritePreferenceLong("HideEditor", 0)
        WritePreferenceLong("HideFromMenu", 0)
        WritePreferenceLong("Deactivate", 0)
        PreferenceComment("")
        PreferenceComment("")
        ClosePreferences()
      EndIf
    EndIf
  Else
    If OpenPreferences(TPFName$)
      PreferenceGroup("ToolsInfo")
      ToolCount = Val(ReadPreferenceString("ToolCount", ""))
      ToolIndex=-1
      If ToolCount
        For i=0 To ToolCount-1
          PreferenceGroup("Tool_"+Str(i))
          If LCase(ReadPreferenceString("MenuItemName", ""))="tailbite"
            ToolIndex=i
            Break
          EndIf
        Next i
      EndIf
      If ToolIndex=-1
        PreferenceGroup("ToolsInfo")
        WritePreferenceString("ToolCount", Str(ToolCount+1))
        PreferenceGroup("Tool_"+Str(ToolCount))
      EndIf
      WritePreferenceString("Command", TBFolder$+"TailBite"+#SystemExeExt)
      WritePreferenceString("Arguments", ArgPref$)
      WritePreferenceString("WorkingDir", "")
      WritePreferenceString("MenuItemName", "TailBite")
      If ToolsHK$<>"None"
        ToolsHK$ = LTrim(RTrim(RemoveString(ToolsHK$, "Alt+")))
        If Left(ToolsHK$, 1)="F"
          ToolsHK$ = LTrim(RTrim(RemoveString(ToolsHK$, "F")))
          sValue = Val(ToolsHK$)+111
          WritePreferenceString("ShortCut", Str(#PB_Shortcut_Alt|sValue))
        Else
          sValue = Val(ToolsHK$)+48
          WritePreferenceString("ShortCut", Str(#PB_Shortcut_Alt|sValue))
        EndIf
      Else
        WritePreferenceString("ShortCut", "")
      EndIf
      WritePreferenceString("ConfigLine", "")
      WritePreferenceLong("Trigger", 0)
      WritePreferenceLong("Flags", 0)
      WritePreferenceLong("ReloadSource", 0)
      WritePreferenceLong("HideEditor", 0)
      WritePreferenceLong("HideFromMenu", 0)
      WritePreferenceLong("Deactivate", 0)
      If ToolIndex=-1
        PreferenceComment("")
        PreferenceComment("")
      EndIf
      ClosePreferences()
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 103
; FirstLine = 76
; Folding = --
; CompileSourceDirectory