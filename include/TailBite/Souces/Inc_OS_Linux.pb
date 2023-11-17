Declare   WriteLog(Text.s,Close.l=#False)
Declare.s ExecuteProgram(Exe$, Par$, DelFolder$,Dir$="")
Declare TBError(message.s, fatal.l, DelFolder.s, ShowLastError.l=#True)

#DirSeparator = "/"
#SystemExeExt = ""
#SystemEOL = #LF$ 
#SystemHelpExt = ""
#SystemBatchExt = ".sh"

#SystemLinkerError = "Error: Linker"

#Switch_Commented = "-c"
#Switch_Unicode = "-u"
#Switch_ThreadSafe = "-t"
#Switch_InlineASM = "-i"
#Switch_Executable = "-e"
#Switch_StandBy = "-sb"
#Switch_SubSystem = "-s"
#Switch_Version = "-v"
#Switch_Resident = "-r"
#Switch_Debugger = "-d"

#Asm_Format = "ELF"
#Asm_Formatx64 = "ELF64"
#Asm_TextSection = "section '.text' executable"
#Asm_MOV_EAX_EXTERNAL = "MOV    eax,"

#MAXLONG = 2147483647
#MAX_PATH = 260
#CCS_NODIVIDER = 0;not used on linux, so it doesn't matter what it's set to



;{ Linux > OnError
 
  
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
      End
    EndIf
    ProcedureReturn 0
  EndProcedure
  
  CompilerIf #PB_Compiler_Debugger=0
    OnErrorCall(@ErrorHook())
  CompilerEndIf
;} 

CompilerIf Defined(TB_Enable_Progress, #PB_Constant) 
CompilerIf #TB_Enable_Progress = 1

Procedure ProgressBarGadgetExtended(Gadget, x, y, Width, Height, WindowID, Flags=0)
  ProgressBarGadget(gadget, x, y, width, height, 0, 100, flags)
EndProcedure

Procedure update_progress_bar(progbar)
    gtk_progress_bar_pulse_(progbar)
    ProcedureReturn #True 
EndProcedure

Procedure ProgressBarSetIndeterminate(gadget, state)
  Static func_ref
  If IsGadget(gadget)
    If state
      func_ref = g_timeout_add_(150, @update_progress_bar(), GadgetID(gadget))
    Else
      g_source_remove_ (func_ref)
    EndIf
  EndIf
EndProcedure

Procedure ProgressBarSetPercent(gadget, percent.l)
  If IsGadget(gadget)
    SetGadgetState(gadget, percent)
  EndIf
EndProcedure

Procedure ProgressBarSetState(gadget, state)

EndProcedure

CompilerEndIf
CompilerEndIf

Procedure.s GetASMCompilerCommand(isbatch.i)
  Protected asmCommand.s
  
  If isbatch : asmCommand+#DQUOTE$ : EndIf
  asmCommand+PBFolder$+"compilers/fasm"
  If isbatch : asmCommand+#DQUOTE$ : EndIf
  
  ProcedureReturn asmCommand
EndProcedure

Procedure.s ASMCompileParams(asmFile.s, outFile.s, isbatch.i)
  Protected asmCommand.s

  ;asmCommand+" "
  If isbatch : asmCommand+#DQUOTE$ : EndIf
  asmCommand+asmFile
  If isbatch : asmCommand+#DQUOTE$ : EndIf
  
  asmCommand+" "
  If isbatch : asmCommand+#DQUOTE$ : EndIf
  asmCommand+outFile
  If isbatch : asmCommand+#DQUOTE$ : EndIf
  
  ProcedureReturn asmCommand
EndProcedure

Procedure.s CompileAsm(file.s, out.s)
  ProcedureReturn ExecuteProgram(PBFolder$+"compilers/fasm", #DQUOTE$+file+#DQUOTE$+" "+#DQUOTE$+out+#DQUOTE$, TBDestFolder$, TBDestFolder$)
EndProcedure

Procedure HandleASMCompileFailure(asmCompilerOutput.s, FileString$)
  If Right(asmCompilerOutput, Len(FasmOk$))<>FasmOk$
    TBError("FAsm: "+FileString$+NL$+NL$+asmCompilerOutput, 1, TBTempPath$)
    End
  EndIf
EndProcedure

;{ TBError
  Global ThID
  Procedure TBError(message.s, fatal.l, DelFolder.s, ShowLastError.l=#True)
    Protected WinErrorMsg.s 
    
    ;- Bug in PB4.20 Beta 4 Thread : http://www.purebasic.fr/english/viewtopic.php?t=31981
    ;WinErrorMsg = GetErrorDLL()
    
    If WinErrorMsg<>"" And ShowLastError
      message+#LF$+WinErrorMsg
    EndIf
    
    MessageRequester(Language("TBError","Error"), message)
    
    If DelFolder<>""
      DeleteDirectory(DelFolder, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)
    EndIf
    
    If fatal
      Quit = 1
    EndIf
    
    If ThID
      PauseThread(ThID)
    EndIf
  EndProcedure
;}

;{ RunOneInstance
  ; Run only one instance
  #MUTEX_ALL_ACCESS = $1F0001 ; PB4.20 included
  Global NewList Process.s()
  
Procedure RunOne(ThisProcess$)
;   Protected sa.SECURITY_ATTRIBUTES,PGlobal$="",hMutex.l
;  
;   AddElement(Process())
;   Process() = ThisProcess$
;   If OSVersion()>#PB_OS_Windows_ME
;     PGlobal$="Global\"
;     ThisProcess$ = PGlobal$+ThisProcess$
;   EndIf
;   ForEach Process()
;     Process() = PGlobal$+Process()
;     hMutex = OpenMutex_(#MUTEX_ALL_ACCESS, #True, Process())
;     If hMutex
;       If Process()<>ThisProcess$
;         While WaitForSingleObject_(hMutex, 2000)<>#WAIT_OBJECT_0
;         Wend
;         CloseHandle_(hMutex)
;       Else
;         CloseHandle_(hMutex)
;         End
;       EndIf
;     EndIf
;   Next
;   With sa
;     \nLength              = SizeOf(SECURITY_ATTRIBUTES)
;     \lpSecurityDescriptor = #Null
;     \bInheritHandle       = #True
;   EndWith
;   LastElement(Process())
;   CreateMutex_(sa, #True, Process())
;   ClearList(Process())
EndProcedure 
;}

;{ GetHHCFolder
  Procedure.s GetHHCFolder(RKey, KeyString.s, KeyName.s)
    Protected Folder.s, cbData.l, lpbData.l
    Protected hKey1.l, Type.l
;     cbData  = (#MAX_PATH*2)+2
;     lpbData = AllocateMemory(cbData)
;     If RegOpenKeyEx_(RKey, KeyString, 0, #KEY_QUERY_VALUE, @hKey1)=#ERROR_SUCCESS ;#KEY_ALL_ACCESS
;       If RegQueryValueEx_(hKey1, KeyName, 0, @Type, lpbData, @cbData)=#ERROR_SUCCESS
;         Folder = PeekS(lpbData)
;       EndIf
;       RegCloseKey_(hKey1)
;     EndIf
;     FreeMemory(lpbData)
    ProcedureReturn Folder
  EndProcedure
;}

;{ BuildApiList
  Global TBPreferencesPath$,PBFolder$
  Global NewList ApilistAPI.s()
  Global NewList ApilistDLL.s()
  
  #TB_FILTER1$="__imp__"
  #TB_FILTER2$=Chr($7F)
  Procedure.s ReadStringEx(FileID,EofChar$=#LF$)
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
    
    DLLName$=LCase(RemoveString(UCase(DLLName$),".LIB")+".so")
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
    WindowsLibsFolder$ = PBFolder$+"purelibraries/linux/"
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
              ApilistDLL()=DLLName$+".so"
            EndIf
            CloseFile(File1)
          EndIf
        EndIf
      Wend
      FinishDirectory(Dir0)
    EndIf
    
    ;Examine Windows\Libraries folder
    WindowsLibsFolder$+"libraries/"
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
    
;     If SizeOf(integer)=4
;       ; X32
;       HhcFolder$ = GetHHCFolder(#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\App Paths\hhw.exe", "Path")
;     Else
;       ; X64
;       HhcFolder$ = GetHHCFolder(#HKEY_LOCAL_MACHINE, "Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths\hhw.exe", "Path")
;     EndIf
;     
;     If HhcFolder$
;       HhcOk$ = " bytes."
;       If Right(HhcFolder$, 1)<>"\":HhcFolder$+"\":EndIf
;       Path=GetEnvironmentVariable("PATH")
;       HhExeFound = 0
;       HhExe$ = GetHHCFolder(#HKEY_CLASSES_ROOT, "chm.file\shell\open\command", "")
;       If HhExe$
;         HhExe$ = StringField(HhExe$, 1, " ")
;         HhExe$ = RemoveString(HhExe$, #DQUOTE$)
;         If FindString(Path,HhExe$,1)
;           HhExeFound = 1
;         EndIf
;         If HhExeFound=0
;           Path+";"+HhExe$
;         EndIf
;       EndIf
;       HhaDll$ = GetHHCFolder(#HKEY_USERS, ".DEFAULT\Software\Microsoft\HtmlHelp Author", "location")
;       If HhaDll$
;         HhaDllFound = 0
;         If FindString(Path,HhaDll$,1)
;           HhaDllFound = 1
;         EndIf
;         If HhaDllFound=0
;           Path+";"+HhaDll$
;         EndIf
;       EndIf
;       If HhaDllFound=0 And HhExeFound=0
;         SetEnvironmentVariable("PATH",Path)
;       EndIf
;       cs$ = ExecuteProgram(#DQUOTE$+HhcFolder$+"hhc.exe"+#DQUOTE$, #DQUOTE$+HhpFile$+#DQUOTE$, "")
;       If FindString(cs$,HhcOk$,1)=0
;         TBError("Hhc: "+NL$+NL$+cs$+NL$+NL$+"Defaulting to HTML help.", 0, "")
;         ProcedureReturn #False
;       Else
;         ProcedureReturn #True
;       EndIf
;     Else
;       TBError("hhw.exe: ", 0, "")
;       ProcedureReturn #False
;     EndIf
  EndProcedure
;}

;{ SpecialFolder
#CSIDL_PERSONAL = 1
  Procedure.s SpecialFolder(folderno)
    Protected Result$
    
    Select folderno
      Case #CSIDL_PERSONAL
        Result$ = GetEnvironmentVariable("HOME")
    EndSelect
    
    ProcedureReturn Trim(Result$) 
  EndProcedure
;}

;{ GetPBFolder
  Procedure.s GetPBFolder()
    Protected hCompiler.l, PBFolder.s
      hCompiler = RunProgram("which", "pbcompiler ", "", #PB_Program_Open|#PB_Program_Read|#PB_Program_Hide)
      PBFolder = ""
      If hCompiler
        While ProgramRunning(hCompiler)
          PBFolder + ReadProgramString(hCompiler) ;+ Chr(13)
        Wend
        If Right(PBFolder, 20) = "compilers/pbcompiler"
          PBFolder = Left(PBFolder, Len(PBFolder)-20)
        EndIf
        CloseProgram(hCompiler)
      Else
        PBFolder = ""
      EndIf
      If PBFolder = "" And GetEnvironmentVariable ( "PUREBASIC_HOME" ) <> ""
        PBFolder = GetEnvironmentVariable ( "PUREBASIC_HOME" )
        If Right(PBFolder, 1) <> "/"
          PBFolder = PBFolder + "/"
        EndIf
      EndIf
      
      ;MessageRequester("PB Folder", PBFolder)
      ProcedureReturn PBFolder
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
    
    ProcedureReturn #False;result
  EndProcedure

  Procedure GetProcessListNt(*ThisProc.FindProcInfo); Fred's List processes on WinNT. 
    
    ProcedureReturn #False;found
  EndProcedure

  Procedure GetProcessList9x(*ThisProc.FindProcInfo); Fred's List processes on Win9x
    
    ProcedureReturn #False;found
  EndProcedure

  Procedure GetProcessList(*PBProc)
    ProcedureReturn #False
  EndProcedure
;}
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 26
; Folding = ------