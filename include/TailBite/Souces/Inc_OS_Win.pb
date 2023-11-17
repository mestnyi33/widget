Declare   WriteLog(Text.s,Close.l=#False)
Declare.s ExecuteProgram(Exe$, Par$, DelFolder$,Dir$="")
Declare TBError(message.s, fatal.l, DelFolder.s, ShowLastError.l=#True)

#DirSeparator = "\"
#SystemExeExt = ".exe"
#SystemEOL = #CRLF$
#SystemHelpExt = ".chm"
#SystemBatchExt = ".bat"

#SystemLinkerError = "POLINK: error: Unresolved external symbol"

#Switch_Commented = "/COMMENTED"
#Switch_Unicode = "/UNICODE"
#Switch_ThreadSafe = "/THREAD"
#Switch_InlineASM = "/INLINEASM"
#Switch_Executable = "/EXE"
#Switch_StandBy = "/STANDBY"
#Switch_SubSystem = "/SUBSYSTEM"
#Switch_Version = "/VERSION"
#Switch_Resident = "/RESIDENT"
#Switch_Debugger = "/DEBUGGER"

#Asm_Format = "MS COFF"
#Asm_Formatx64 = "MS64 COFF"
#Asm_TextSection = "section '.text' code readable executable"
#Asm_MOV_EAX_EXTERNAL = "MOV    eax,"


;{ Windows > OnError
  ; Internet constants
  #INTERNET_FLAG_RELOAD                                 = $80000000
  #INTERNET_DEFAULT_HTTP_PORT                           = 80
  #INTERNET_SERVICE_FTP                                 = 1
  #INTERNET_SERVICE_HTTP                                = 3
  #FTP_PORT                                             = 21
  #FTP_TRANSFER_BINARY                                  = 2
  #HTTP_QUERY_CONTENT_LENGTH                            = 5
  #HTTP_QUERY_STATUS_CODE                               = 19
  #HTTP_STATUS_OK                                       = 200
  #INTERNET_OPEN_TYPE_PRECONFIG                         = 0
  #INTERNET_OPEN_TYPE_DIRECT                            = 1
  #INTERNET_OPEN_TYPE_PROXY                             = 3
  #INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY       = 4
  #INTERNET_ERROR_BASE                                  = 12000
  #ERROR_INTERNET_EXTENDED_ERROR = #INTERNET_ERROR_BASE + 3
  
  ; SHAutoComplete code adapted from the snippet posted by hm at the German forum
  ; Autocomplete constants
  #SHACF_AUTOSUGGEST_FORCE_ON                           = $10000000
  #SHACF_AUTOAPPEND_FORCE_ON                            = $40000000
  #SHACF_FILESYSTEM                                     = $00000001
  
  Global NL$                                           = Chr(10)
  Global WNL$                                          = Chr(13)+Chr(10)
  Global q.s                                           = Chr(34)
  Global FasmOk$                                       = " bytes."
  
  Procedure ErrorHook()
    Protected ErrorMsg$
    ErrorMsg$=Str(ErrorLine())
    ErrorMsg$+Chr(13)+ErrorFile()
    ErrorMsg$+Chr(13)+ErrorMessage()
    If MessageRequester(Language("TBCommon","Error"), ReplaceString(Language("TBCommon","LineNr"),"%linenr%",ErrorMsg$), #PB_MessageRequester_YesNo)=#PB_MessageRequester_Yes
      CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0
        End
      CompilerEndIf
    EndIf
    ProcedureReturn 0
  EndProcedure
  
  CompilerIf #PB_Compiler_Debugger=0 And Defined(TB_Building_DLL, #PB_Constant) = 0
    OnErrorCall(@ErrorHook())
  CompilerEndIf
;} 

;{
CompilerIf Defined(TB_Enable_Progress, #PB_Constant) 
CompilerIf #TB_Enable_Progress = 1

Macro DefineGUID(Name, long, word1, word2, byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8)
  DataSection
    Name:
    Data.l long
    Data.w word1, word2
    Data.b byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8
  EndDataSection
EndMacro
#CLSCTX_INPROC_SERVER  = $01

Structure THUMBBUTTON
    dwMask.l
    iId.l
    iBitmap.l
    pad.l ; used for 64-Bit structure alignment
    hIcon.i
    szTip.w[260] ; widechar is used
    dwFlags.l
EndStructure

Interface ITaskbarList3 Extends ITaskbarList2
  SetProgressValue(hWnd, ullCompleted.q, ullTotal.q)
  SetProgressState(hWnd, tbpFlags.l)
  RegisterTab(hWndTab, hWndMDI)
  UnregisterTab(hWndTab)
  SetTabOrder(hWndTab, hWndInsertBefore)
  SetTabActive(hWndTab, hWndMDI, dwreserved.l)
  ThumbBarAddButtons(hWnd, cButtons.l, *pButton.THUMBBUTTON )
  ThumbBarUpdateButtons(hwnd,cButtons.l, *pButton.THUMBBUTTON)
  ThumbBarSetImageList(hWnd, himl)
  SetOverlayIcon(hWnd, hIcon, pszDescription.p-bstr)
  SetThumbnailTooltip(hWnd, pszTip.p-bstr)
  SetThumbnailClip(hWnd, *prcClip.RECT)
EndInterface
DEFINEGUID(CLSID_TaskbarList, $56fdf344, $fd6d, $11d0, $95, $8a, $00, $60, $97, $c9, $a0, $90)
DEFINEGUID(IID_ITASKBARLIST3, $ea1afb91,$9e28,$4b86,$90,$e9,$9e,$9f,$8a,$5e,$ef,$af)

#TBPF_NoProgress = 0
;/// The progress is indeterminate (marquee).
#TBPF_Indeterminate = $1
;/// Normal progress is displayed.
#TBPF_Normal = $2
;/// An error occurred (red).
#TBPF_Error = $4
;/// The operation is paused (yellow).
#TBPF_Paused = $8

Global g_pTaskbarList.ITaskBarList3

Procedure ProgressBarGadgetExtended(Gadget, x, y, Width, Height, WindowID, Flags=0);creates a ProgressBarGadget that shows on the Windows 7 taskbar also. WindowID needed so can have progressbar in container/panel/etc
  CoCreateInstance_(?CLSID_TaskbarList, #Null, #CLSCTX_INPROC_SERVER, ?IID_ITaskBarList3, @g_pTaskbarList.ITaskBarList3)
  ;if g_pTaskbarList
  ;endif 
  ProgressBarGadget(Gadget, x, y, Width, Height, 0, 100, flags)
  SetProp_(GadgetID(gadget), "windowid", windowid)
EndProcedure

#PBS_MARQUEE = 8
#PBM_SETMARQUEE = #WM_USER + 10 

Procedure ProgressBarSetIndeterminate(gadget, state)
  If g_pTaskbarList
    If state
      g_pTaskbarList\SetProgressState(GetProp_(GadgetID(gadget), "windowid"), #TBPF_Indeterminate)
    Else
      g_pTaskbarList\SetProgressState(GetProp_(GadgetID(gadget), "windowid"), #TBPF_Normal)
    EndIf 
  EndIf 
  If Not IsGadget(gadget) : ProcedureReturn : EndIf 
  If state 
    SetWindowLongPtr_(GadgetID(gadget), #GWL_STYLE, GetWindowLongPtr_(GadgetID(gadget), #GWL_STYLE) | #PBS_MARQUEE)
    SendMessage_(GadgetID(gadget), #PBM_SETMARQUEE, 1, 30)
  Else
    SetWindowLongPtr_(GadgetID(gadget), #GWL_STYLE, GetWindowLongPtr_(GadgetID(gadget), #GWL_STYLE) & ~#PBS_MARQUEE)
    SendMessage_(GadgetID(gadget), #PBM_SETMARQUEE, 0, 30)
  EndIf 
EndProcedure

Procedure ProgressBarSetPercent(gadget, percent.l)
  If g_pTaskbarList
    g_pTaskbarList\SetProgressValue(GetProp_(GadgetID(gadget), "windowid"), percent, 100)
  EndIf 
  If Not IsGadget(gadget) : ProcedureReturn : EndIf 
  SetGadgetState(gadget, percent)
EndProcedure

#PBM_SETSTATE      =      (#WM_USER+16)
#PBST_NORMAL      =       $0001
#PBST_ERROR       =       $0002
#PBST_PAUSED       =      $0003

Procedure ProgressBarSetState(gadget, state);0=normal, 1=error, 2=paused
  If g_pTaskbarList
    If state = 2
      g_pTaskbarList\SetProgressState(GetProp_(GadgetID(gadget), "windowid"), #TBPF_Paused)
    ElseIf state = 1
      g_pTaskbarList\SetProgressState(GetProp_(GadgetID(gadget), "windowid"), #TBPF_Error)
    ElseIf state = -1
      g_pTaskbarList\SetProgressState(GetProp_(GadgetID(gadget), "windowid"), #TBPF_NoProgress)
    Else
      g_pTaskbarList\SetProgressState(GetProp_(GadgetID(gadget), "windowid"), #TBPF_Normal)
    EndIf 
  EndIf
  If Not IsGadget(gadget) : ProcedureReturn : EndIf 
  If state = 2
    SendMessage_(GadgetID(gadget), #PBM_SETSTATE, 0, #PBST_PAUSED)
  ElseIf state = 1
    SendMessage_(GadgetID(gadget), #PBM_SETSTATE, 0, #PBST_ERROR)
  Else
    SendMessage_(GadgetID(gadget), #PBM_SETSTATE, 0, #PBST_NORMAL)
  EndIf 
EndProcedure

CompilerEndIf
CompilerEndIf
;}

Procedure.s GetASMCompilerCommand(isbatch.i)
  Static asmCommand.s
  Static lastisbatch
  
  If asmCommand <> "" And lastisbatch = isbatch
    ;debug asmCommand
    ProcedureReturn asmCommand
  Else 
    If isbatch
      asmCommand=#DQUOTE$+PBFolder$+"compilers\fasm.exe"+#DQUOTE$
    Else
      asmCommand = PBFolder$+"compilers\fasm.exe"
    EndIf
    lastisbatch = isbatch
    Debug asmCommand
  EndIf 
  
  ProcedureReturn asmCommand
EndProcedure

Procedure.s ASMCompileParams(asmFile.s, outFile.s, isbatch.i)
  Protected asmCommand.s
  
  If isbatch
    asmCommand = #DQUOTE$+asmfile+#DQUOTE$;+" "+#DQUOTE$+outFile+#DQUOTE$
  Else
    asmCommand = asmfile;+" "+outFile
  EndIf 
  ;If isbatch : asmCommand+#DQUOTE$ : EndIf
  ;asmCommand+asmFile
  ;If isbatch : asmCommand+#DQUOTE$ : EndIf
  ;
  ;asmCommand+" "
  ;If isbatch : asmCommand+#DQUOTE$ : EndIf
  ;asmCommand+outFile
  ;If isbatch : asmCommand+#DQUOTE$ : EndIf
  
  ProcedureReturn asmCommand
EndProcedure

Macro HandleASMCompileFailure(asmCompilerOutput, FileString)
  ;Debug asmCompilerOutput
  If Right(asmCompilerOutput, Len(FasmOk$))<>FasmOk$
    TBError("FAsm: "+FileString+NL$+NL$+asmCompilerOutput, 1, TBTempPath$)
    CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0
      End
    CompilerEndIf
  EndIf
EndMacro

CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
  IncludeFile "inc_fasm.pb"
  Procedure.s CompileAsm(file.s, out.s)
    ProcedureReturn CompileAsmFasm(TBTempPath$+file, TBTempPath$+out)
  EndProcedure
CompilerElse
  IncludeFile "inc_fasmstandby.pb"
  Procedure.s CompileAsm(file.s, out.s)
    ProcedureReturn FasmStandby(TBTempPath$+file, TBTempPath$+out)
  EndProcedure
CompilerEndIf

;{ TBError
  Global ThID
  Procedure TBError(message.s, fatal.l, DelFolder.s, ShowLastError.l=#True)
    Protected WinErrorMsg.s 
    
    ;- Bug in PB4.20 Beta 4 Thread : http://www.purebasic.fr/english/viewtopic.php?t=31981
    ;WinErrorMsg = GetErrorDLL()
    CompilerIf Defined(TB_Enable_Progress, #PB_Constant)
    CompilerIf #TB_Enable_Progress = 1
      If IsGadget(#progress)
        ProgressBarSetIndeterminate(#progress, 0)
        ProgressBarSetState(#progress, 1)
        While WindowEvent() : Wend 
      EndIf 
    CompilerEndIf
    CompilerEndIf
    
    If WinErrorMsg<>"" And ShowLastError
      message+#LF$+WinErrorMsg
    EndIf
    WriteLog(message)
    MessageRequester(Language("TBError","Error"), message)
    CallDebugger
    
    If DelFolder<>""
      DeleteDirectory(DelFolder, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
    EndIf
    
    If fatal
      Quit = 1
    EndIf
    
    If ThID And fatal
      PauseThread(ThID)
    EndIf
  EndProcedure
;}

;{ RunOneInstance
  ; Run only one instance
  #MUTEX_ALL_ACCESS = $1F0001 ; PB4.20 included
  Global NewList Process.s()
  
Procedure RunOne(ThisProcess$)
  Protected sa.SECURITY_ATTRIBUTES,PGlobal$="",hMutex.l
 
  AddElement(Process())
  Process() = ThisProcess$
  If OSVersion()>#PB_OS_Windows_ME
    PGlobal$="Global\"
    ThisProcess$ = PGlobal$+ThisProcess$
  EndIf
  ForEach Process()
    Process() = PGlobal$+Process()
    hMutex = OpenMutex_(#MUTEX_ALL_ACCESS, #True, @Process())
    If hMutex
      If Process()<>ThisProcess$
        While WaitForSingleObject_(hMutex, 2000)<>#WAIT_OBJECT_0
        Wend
        CloseHandle_(hMutex)
      Else
        CloseHandle_(hMutex)
        CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0
          End
        CompilerEndIf
      EndIf
    EndIf
  Next
  With sa
    \nLength              = SizeOf(SECURITY_ATTRIBUTES)
    \lpSecurityDescriptor = #Null
    \bInheritHandle       = #True
  EndWith
  LastElement(Process())
  CreateMutex_(sa, #True, Process())
  ClearList(Process())
EndProcedure 
;}

;{ GetHHCFolder
  Procedure.s GetHHCFolder(RKey, KeyString.s, KeyName.s)
    Protected Folder.s, cbData.l, lpbData.l
    Protected hKey1.l, Type.l
    cbData  = (#MAX_PATH*2)+2
    lpbData = AllocateMemory(cbData)
    If RegOpenKeyEx_(RKey, KeyString, 0, #KEY_QUERY_VALUE, @hKey1)=#ERROR_SUCCESS ;#KEY_ALL_ACCESS
      If RegQueryValueEx_(hKey1, KeyName, 0, @Type, lpbData, @cbData)=#ERROR_SUCCESS
        Folder = PeekS(lpbData)
      EndIf
      RegCloseKey_(hKey1)
    EndIf
    FreeMemory(lpbData)
    ProcedureReturn Folder
  EndProcedure
;}

;{ BuildApiList
  Global TBPreferencesPath$,PBFolder$
  Global NewList ApilistAPI.s()
  Global NewList ApilistDLL.s()
  
  #TB_FILTER1$="__imp__"
  #TB_FILTER2$=Chr($7F)
  Procedure.s ReadStringEx(FileID,EofChar$=#CR$+#LF$)
    Protected char,String$,idx
    If FileID And IsFile(FileID)
      String$=""
      idx=1
      Repeat
        If Eof(FileID)
          Break
        EndIf
        char=ReadByte(FileID)&$FF
        If char=Asc(Mid(EofChar$,idx,1))
          idx+1
          If idx>Len(EofChar$)
            idx=1
            Break
          EndIf
        Else
          String$+Chr(char)
          idx=1
        EndIf
      ForEver
      
      ProcedureReturn String$
    EndIf
  EndProcedure
  Procedure AnalyzeLibFormat(DLLName$,*Buffer,Length)
    Protected FunctionCount.l,AlreadyThere.l,ApiEnd.l,ApiSeeker.l,idx.l,String$
    
    DLLName$=RemoveString(UCase(DLLName$),".LIB")+".DLL"
    ; look if DLLName is already there
    AlreadyThere=0
    ForEach ApilistDLL()
      If ApilistDLL()=DLLName$
        AlreadyThere=1
        Break
      EndIf
    Next
    If AlreadyThere=0
      AddElement(ApilistDLL())
      ApilistDLL()=DLLName$
    EndIf
    FunctionCount=0
    PokeB(@FunctionCount+3,PeekB(*Buffer+0))
    PokeB(@FunctionCount+2,PeekB(*Buffer+1))
    PokeB(@FunctionCount+1,PeekB(*Buffer+2))
    PokeB(@FunctionCount+0,PeekB(*Buffer+3))
    ApiEnd=*Buffer+Length
    ApiSeeker=*Buffer+4+FunctionCount*4
    idx=0
    While FunctionCount < $FFFF And FunctionCount>0
      String$=""
      While ApiSeeker<ApiEnd And PeekB(ApiSeeker)<>0
        String$+Chr(PeekB(ApiSeeker))
        ApiSeeker+1
      Wend
      idx+1
      If Left(String$,Len(#TB_FILTER1$))<>#TB_FILTER1$ And Left(String$,Len(#TB_FILTER2$))<>#TB_FILTER2$
        ;include API-Function without "@" 9.12.2008 13:41 ABBKlaus
        ;If CountString(String$,"@")=1
          ;Debug Str(idx)+":"+String$
          AddElement(ApilistAPI())
          ApilistAPI()=String$+"  "+Str(ListIndex(ApilistDLL()))
        ;EndIf
      EndIf
      FunctionCount-1
      ApiSeeker+1
    Wend
  EndProcedure
  Procedure BuildApiList()
    Protected ApiList$,WindowsLibsFolder$,Dir0.l,DLLName$,File1.l,ApiListSize.l,*ApiList,ApiEnd.l,ApiSeeker.l
    Protected ThisAPIFunction$,nArg.l,Header$,Idx.l,Info1$,Info2$,Info3$,Info4$,Info5$,test$,Length.l,*Buffer
    
    Debug "BuildApiList()"
    ApiList$=TBPreferencesPath$+"APILIST.TXT"
    WindowsLibsFolder$ = PBFolder$+"PureLibraries\Windows\"
    ClearList(ApilistAPI())
    ClearList(ApilistDLL())
    
    Dir0=ExamineDirectory(#PB_Any, WindowsLibsFolder$, "")
    If Dir0
      While NextDirectoryEntry(Dir0)
        If DirectoryEntryType(Dir0)=#PB_DirectoryEntry_File
          DLLName$ = DirectoryEntryName(Dir0)
          File1=ReadFile(#PB_Any, WindowsLibsFolder$+DLLName$)
          If File1
            ApiListSize = Lof(File1)
            If ApiListSize>0 
              *ApiList = AllocateMemory(ApiListSize+2) ; 5.1.2009 15:26 ABBKlaus PeekS() was causing an invalid memory access
              ReadData(File1, *ApiList, ApiListSize)
              ApiEnd = *ApiList+ApiListSize
              ApiSeeker = *ApiList+9+Len(DLLName$)+1
              While ApiSeeker<ApiEnd
                ThisAPIFunction$ = PeekS(ApiSeeker,-1,#PB_Ascii)
                ApiSeeker+Len(ThisAPIFunction$)+3
                nArg = PeekB(ApiSeeker-2)*4
                AddElement(ApilistAPI())
                ApilistAPI()="_"+ThisAPIFunction$+"@"+Str(nArg)+"  "+Str(ListSize(ApilistDLL()))
                ;-Bugfix TailBite warning: Unknown Windows API function: ABBKlaus 19.5.2007 20:34
                ;now there are 2 more versions *A for ANSI *W for Unicode in the API-List
                If PeekB(ApiSeeker-1)>0 ; And Right(ThisAPIFunction$, 1)<>"A"
                  AddElement(ApilistAPI())
                  ApilistAPI()="_"+ThisAPIFunction$+"A@"+Str(nArg)+"  "+Str(ListSize(ApilistDLL()))
                  AddElement(ApilistAPI())
                  ApilistAPI()="_"+ThisAPIFunction$+"W@"+Str(nArg)+"  "+Str(ListSize(ApilistDLL()))
                EndIf
              Wend
              FreeMemory(*ApiList)
              AddElement(ApilistDLL())
              ApilistDLL()=DLLName$+".DLL"
            EndIf
            CloseFile(File1)
          EndIf
        EndIf
      Wend
      FinishDirectory(Dir0)
    EndIf
    
    ;Examine Windows\Libraries folder
    WindowsLibsFolder$+"Libraries\"
    Dir0=ExamineDirectory(#PB_Any, WindowsLibsFolder$, "")
    If Dir0
      While NextDirectoryEntry(Dir0)
        If DirectoryEntryType(Dir0)=#PB_DirectoryEntry_File
          DLLName$ = DirectoryEntryName(Dir0)
          File1=ReadFile(#PB_Any, WindowsLibsFolder$+DLLName$)
          If File1
            If Lof(File1)>0
              ;Header 
              ;!<arch>$0A
              ;/               1071350603              0       194       $0A
              Header$=ReadStringEx(File1,Chr(10))
              If Left(Header$,7)="!<arch>"
                Idx=0
                Info5$="`"
                Repeat
                  test$=ReadStringEx(File1,Chr(10))
                  ;Debug test$
                  If test$
                    test$=Trim(test$)
                    Info1$=StringField(test$,1," ")
                    ;Debug "Info1$="+Info1$ ; "/"
                    test$=Trim(Right(test$,Len(test$)-Len(Info1$)))
                    Info2$=StringField(test$,1," ")
                    If Info2$="1071350603"
                      ;Debug "Info2$="+Info2$ ; 1071350603
                    EndIf
                    test$=Trim(Right(test$,Len(test$)-Len(Info2$)))
                    Info3$=StringField(test$,1," ")
                    ;Debug "Info3$="+Info3$ ; 0
                    test$=Trim(Right(test$,Len(test$)-Len(Info3$)))
                    Info4$=StringField(test$,1," ")
                    Length=Val(Info4$)
                    ;Debug "Info4$="+Info4$ ; 194 Bytes to next header
                    test$=Trim(Right(test$,Len(test$)-Len(Info4$)))
                    Info5$=StringField(test$,1," ")
                    ;Debug "Info5$="+Info5$ ; `
                    If Length ;And FindString(Info1$,".dll",1)
                      ;Debug "Parsing DLL "+StringField(Info1$,1,"/")
                      *Buffer=AllocateMemory(Length)
                      If *Buffer
                        ReadData(File1,*Buffer,Length)
                        AnalyzeLibFormat(DLLName$,*Buffer,Length)
                        ;CallDebugger
                        FreeMemory(*Buffer)
                      EndIf
                      ;FileSeek(File1,Loc(File1)+Length)
                    EndIf
                  Else
                    ;Debug "Empty"+Str(Loc(1))
                  EndIf
                  Idx+1
                Until Eof(File1)
              EndIf
            EndIf
            CloseFile(File1)
          EndIf
        EndIf
      Wend
      FinishDirectory(Dir0)
    EndIf
  EndProcedure
;}

;{ HelpCompile
  Procedure HelpCompile(HhpFile$)
    Protected Path.s,HhcFolder$,HhcOk$,HhExeFound.l,HhExe$,HhaDll$,HhaDllFound.l,cs$
    
    If SizeOf(integer)=4
      ; X32
      HhcFolder$ = GetHHCFolder(#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\App Paths\hhw.exe", "Path")
    Else
      ; X64
      HhcFolder$ = GetHHCFolder(#HKEY_LOCAL_MACHINE, "Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths\hhw.exe", "Path")
    EndIf
    
    If HhcFolder$
      HhcOk$ = " bytes."
      If Right(HhcFolder$, 1)<>"\":HhcFolder$+"\":EndIf
      Path=GetEnvironmentVariable("PATH")
      HhExeFound = 0
      HhExe$ = GetHHCFolder(#HKEY_CLASSES_ROOT, "chm.file\shell\open\command", "")
      If HhExe$
        HhExe$ = StringField(HhExe$, 1, " ")
        HhExe$ = RemoveString(HhExe$, #DQUOTE$)
        If FindString(Path,HhExe$,1)
          HhExeFound = 1
        EndIf
        If HhExeFound=0
          Path+";"+HhExe$
        EndIf
      EndIf
      HhaDll$ = GetHHCFolder(#HKEY_USERS, ".DEFAULT\Software\Microsoft\HtmlHelp Author", "location")
      If HhaDll$
        HhaDllFound = 0
        If FindString(Path,HhaDll$,1)
          HhaDllFound = 1
        EndIf
        If HhaDllFound=0
          Path+";"+HhaDll$
        EndIf
      EndIf
      If HhaDllFound=0 And HhExeFound=0
        SetEnvironmentVariable("PATH",Path)
      EndIf
      cs$ = ExecuteProgram(#DQUOTE$+HhcFolder$+"hhc.exe"+#DQUOTE$, #DQUOTE$+HhpFile$+#DQUOTE$, "")
      If FindString(cs$,HhcOk$,1)=0
        TBError("Hhc: "+NL$+NL$+cs$+NL$+NL$+"Defaulting to HTML help.", 0, "")
        ProcedureReturn #False
      Else
        ProcedureReturn #True
      EndIf
    Else
      TBError("hhw.exe: ", 0, "")
      ProcedureReturn #False
    EndIf
  EndProcedure
;}

;{ SpecialFolder
  Procedure.s SpecialFolder(folderno)
    Protected listptr,Result$
    listptr=0 
    Result$=Space(#MAX_PATH) 
    SHGetSpecialFolderLocation_(0,folderno,@listptr) 
    SHGetPathFromIDList_(listptr,@Result$) 
    ProcedureReturn Trim(Result$) 
  EndProcedure
;}

CompilerIf Defined(PB_OS_Windows_7,#PB_Constant)=0
  #PB_OS_Windows_7 = 80
CompilerEndIf
CompilerIf Defined(PB_OS_Windows_8,#PB_Constant)=0
  #PB_OS_Windows_8 = 90
CompilerEndIf

;{ GetPBFolder
  Procedure.s GetPBFolder()
    Protected hKey1.l, Type.l, Res.l, Folder$, lpbData.l, cbData.l, OS.s, Key.s, PBRegKey.s, PBRegKey1.s
    
    WriteLog("GetPBFolder()")
    
    Folder$   = ""
    hKey1     = 0
    Type      = 0
    Res       = -1
    PBRegKey1 = ""
    
    Select OSVersion()
      Case #PB_OS_Windows_95,#PB_OS_Windows_98,#PB_OS_Windows_ME
        OS        = "Detected OS : Windows 95/98/ME"
        Key       = "HKLM\"
        PBRegKey  = "Software\Classes\PureBasic.exe\shell\open\command"
        Res       = RegOpenKeyEx_(#HKEY_LOCAL_MACHINE, PBRegKey, 0, #KEY_ALL_ACCESS, @hKey1)
        If Res<>#ERROR_SUCCESS
          Key       = "HKLM\"
          PBRegKey  = "Software\Microsoft\Windows\CurrentVersion\Uninstall\PureBasic_is1"
          PBRegKey1 = "InstallLocation"
          Res       = RegOpenKeyEx_(#HKEY_LOCAL_MACHINE, PBRegKey, 0, #KEY_ALL_ACCESS , @hKey1)
        EndIf
      Case #PB_OS_Windows_NT3_51,#PB_OS_Windows_NT_4,#PB_OS_Windows_2000
        OS        = "Detected OS : Windows NT/2000/XP"
        Key       = "HKCR\"
        PBRegKey  = "Applications\PureBasic.exe\shell\open\command"
        Res       = RegOpenKeyEx_(#HKEY_CLASSES_ROOT, PBRegKey, 0, #KEY_ALL_ACCESS, @hKey1)
        If Res<>#ERROR_SUCCESS
          Key       = "HKLM\"
          PBRegKey  = "Software\Microsoft\Windows\CurrentVersion\Uninstall\PureBasic_is1"
          PBRegKey1 = "InstallLocation"
          Res       = RegOpenKeyEx_(#HKEY_LOCAL_MACHINE, PBRegKey, 0, #KEY_ALL_ACCESS , @hKey1)
        EndIf
      Case #PB_OS_Windows_XP,#PB_OS_Windows_Server_2003
        OS        = "Detected OS : Windows XP/Server 2003"
        ;PB 4.00-4.10 old registry keys
        ;Key       = "HKCR\"
        ;PBRegKey  = "Applications\PureBasic.exe\shell\open\command"
        Key       = "HKCU\"
        PBRegKey  = "Software\Classes\PureBasic.exe\shell\open\command"
        Res       = RegOpenKeyEx_(#HKEY_CURRENT_USER, PBRegKey, 0, #KEY_ALL_ACCESS , @hKey1)
        If Res<>#ERROR_SUCCESS
          Key       = "HKLM\"
          PBRegKey  = "Software\Microsoft\Windows\CurrentVersion\Uninstall\PureBasic_is1"
          PBRegKey1 = "InstallLocation"
          Res       = RegOpenKeyEx_(#HKEY_LOCAL_MACHINE, PBRegKey, 0, #KEY_ALL_ACCESS , @hKey1)
        EndIf
      Case #PB_OS_Windows_Vista,#PB_OS_Windows_Server_2008,#PB_OS_Windows_Future, #PB_OS_Windows_7, #PB_OS_Windows_8,  #PB_OS_Windows_10
        OS        = "Detected OS : Windows Vista/Server 2008/Windows 7"
        Key       = "HKCU\"
        PBRegKey  = "Software\Classes\PureBasic.exe\shell\open\command"
        Res       = RegOpenKeyEx_(#HKEY_CURRENT_USER, PBRegKey, 0, #KEY_ALL_ACCESS , @hKey1)
        If Res<>#ERROR_SUCCESS
          Key       = "HKLM\"
          PBRegKey  = "Software\Microsoft\Windows\CurrentVersion\Uninstall\PureBasic_is1"
          PBRegKey1 = "InstallLocation"
          Res       = RegOpenKeyEx_(#HKEY_LOCAL_MACHINE, PBRegKey, 0, #KEY_ALL_ACCESS , @hKey1)
        EndIf
    EndSelect
    
    WriteLog(OS)
    
    If Res = #ERROR_SUCCESS And hKey1
      ; get the amount of data needed
      If RegQueryValueEx_(hKey1, PBRegKey1, 0, @Type, 0, @cbData)=#ERROR_SUCCESS
        lpbData = AllocateMemory(cbData)
      EndIf
      If lpbData And RegQueryValueEx_(hKey1, PBRegKey1, 0, @Type, lpbData, @cbData)=#ERROR_SUCCESS
        Folder$ = PeekS(lpbData)
        If PBRegKey1<>""
          PBRegKey1="\"+PBRegKey1
        EndIf
        WriteLog(Key+PBRegKey+PBRegKey1+"="+Folder$)
        If Left(Folder$,1)=#DQUOTE$
          Folder$ = GetPathPart(StringField(Folder$,2,Chr(34)))
        EndIf
      EndIf
      RegCloseKey_(hKey1)
    EndIf
    
    If lpbData
      FreeMemory(lpbData)
      lpbData=0
    EndIf
    
    ProcedureReturn Folder$
  EndProcedure
;}

;{ GetProcessList()
  Global GetProcessListResult$, hIDE
  
  Structure FindProcInfo
    Terminate.l
    ProcessName$
    FindText$
    NoText$
  EndStructure
 
  Procedure EnumWindowsProc(hWnd, *lParam.FindProcInfo)
    Protected result.l,*szBuffer,WText$
    
    result = #True
    *szBuffer = AllocateMemory(1024)
    GetWindowText_(hWnd, *szBuffer, 1024)
    WText$ = PeekS(*szBuffer)
    FreeMemory(*szBuffer)
    If Left(WText$, Len(*lParam\FindText$))=*lParam\FindText$
      If WText$<>*lParam\NoText$
        hIDE = hWnd
        GetProcessListResult$ = Right(WText$, Len(WText$)-Len(*lParam\FindText$))
        result = #False
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure

  Procedure GetProcessListNt(*ThisProc.FindProcInfo); Fred's List processes on WinNT. 
    Protected psapi.l,found.l=#False,EnumProcesses.i,EnumProcessModules.i,GetModuleBaseName.i,nProcesses.l,k.l
    Protected hProcess.l,BaseModule.l,cbNeeded.l,*szName,ExitCode.l,ModuleName.s,PID.l
    
    #NbProcessesMax = 10000
    
    psapi=OpenLibrary(#PB_Any, "psapi.dll") 
    If psapi
      Dim ProcessesArray.l(#NbProcessesMax)
      EnumProcesses = GetFunction(psapi, "EnumProcesses")
      EnumProcessModules = GetFunction(psapi, "EnumProcessModules")
      GetModuleBaseName  = GetFunction(psapi, "GetModuleBaseNameA")
      If EnumProcesses And EnumProcessModules And GetModuleBaseName
        CallFunctionFast(EnumProcesses, ProcessesArray(), #NbProcessesMax, @nProcesses) 
        For k=1 To nProcesses/4
          PID=ProcessesArray(k-1)
          hProcess = OpenProcess_(#PROCESS_QUERY_INFORMATION|#PROCESS_VM_READ|#PROCESS_TERMINATE, 0, PID)
          If hProcess
            If CallFunctionFast(EnumProcessModules, hProcess, @BaseModule, 4, @cbNeeded)
              Debug "EnumProcessModules PID="+Str(PID)
              *szName = AllocateMemory(1024)
              If CallFunctionFast(GetModuleBaseName, hProcess, BaseModule, *szName, 1024)
                ModuleName=PeekS(*szName)
                Debug "ModuleName="+ModuleName
                If UCase(Right(ModuleName, Len(*ThisProc\ProcessName$)))=*ThisProc\ProcessName$
                  If *ThisProc\Terminate
                    If GetExitCodeProcess_(hProcess, @ExitCode)
                      Debug "TerminateProcess_()"
                      TerminateProcess_(hProcess, ExitCode)
                    EndIf
                  Else
                    Debug "EnumWindows_()"
                    EnumWindows_(@EnumWindowsProc(), *ThisProc)
                  EndIf
                  found=#True
                EndIf
              EndIf
              FreeMemory(*szName)
            EndIf
            CloseHandle_(hProcess)
          EndIf
        Next
      EndIf
      CloseLibrary(psapi)
    EndIf
    Dim ProcessesArray(0)
    ProcedureReturn found
  EndProcedure

  Procedure GetProcessList9x(*ThisProc.FindProcInfo); Fred's List processes on Win9x
    Protected kernel32.l,found.l=#False,ProcessFound.l,Process.PROCESSENTRY32
    Protected CreateToolhelpSnapshot.l,Snapshot.l,ProcessFirst.l,ProcessNext.l,hProcess.l,ExitCode.l
    
    ;#TH32CS_SNAPPROCESS = $2
    found = 0
    kernel32=OpenLibrary(#PB_Any, "KERNEL32.DLL")
    If kernel32
      CreateToolhelpSnapshot = GetFunction(kernel32, "CreateToolhelp32Snapshot")
      ProcessFirst = GetFunction(kernel32, "Process32First")
      ProcessNext = GetFunction(kernel32, "Process32Next")
      If CreateToolhelpSnapshot And ProcessFirst And ProcessNext
        Process\dwSize = SizeOf(PROCESSENTRY32)
        Snapshot = CallFunctionFast(CreateToolhelpSnapshot, #TH32CS_SNAPPROCESS, 0)
        If Snapshot
          ProcessFound = CallFunctionFast(ProcessFirst, Snapshot, @Process)
          While ProcessFound
            If UCase(Right(PeekS(@Process\szExeFile), Len(*ThisProc\ProcessName$)))=UCase(*ThisProc\ProcessName$)
              If *ThisProc\Terminate
                hProcess = OpenProcess_(#PROCESS_TERMINATE|#PROCESS_QUERY_INFORMATION, #False, Process\th32ProcessID)
                If hProcess
                  If GetExitCodeProcess_(hProcess, @ExitCode)
                    TerminateProcess_(hProcess, ExitCode)
                  EndIf
                  CloseHandle_(hProcess)
                EndIf
              Else
                EnumWindows_(@EnumWindowsProc(), *ThisProc)
              EndIf
              ProcessFound = 0
              found = 1
            Else
              ProcessFound = CallFunctionFast(ProcessNext, Snapshot, @Process)
            EndIf
          Wend
        EndIf
        CloseHandle_(Snapshot)
      EndIf 
      CloseLibrary(kernel32)
    EndIf
    ProcedureReturn found
  EndProcedure

  Procedure GetProcessList(*PBProc)
    If OSVersion()>#PB_OS_Windows_ME
      ProcedureReturn GetProcessListNt(*PBProc)
    Else
      ProcedureReturn GetProcessList9x(*PBProc)
    EndIf
  EndProcedure
;}
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 667
; FirstLine = 622
; Folding = ------
; EnableXP