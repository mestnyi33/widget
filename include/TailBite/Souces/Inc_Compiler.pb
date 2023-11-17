  Procedure.s ExecuteProgram(Exe.s, Par.s, DelFolder.s, Dir.s="")
    Protected Temp.s,Output.s,Prog.l,Error.s
    
    CompilerIf #PB_Compiler_OS <> #PB_OS_Windows;-RunProgram should _NOT_ really have " " around the exe parameter - windows might not care, but linux does. AFAIK PB would insert the " if needed...
      If Left(exe, 1) = #DQUOTE$
        exe = Right(exe, Len(exe)-1)
      EndIf
      If Right(exe, 1) = #DQUOTE$
        exe = Left(exe, Len(exe)-1)
      EndIf
    CompilerEndIf
    
    WriteLog("RunProgram("+Exe+","+Par+","+Dir+")")
    
    Prog=RunProgram(Exe,Par,Dir,#PB_Program_Read|#PB_Program_Open|#PB_Program_Hide|#PB_Program_Error)
    If Prog
      ;Output = ""
      While ProgramRunning(Prog)
        Temp=ReadProgramString(Prog)
        If Temp<>""
          Output+Temp+#SystemEOL
        EndIf
        Temp=ReadProgramError(Prog)
        If Temp<>""
          Error+Temp+#SystemEOL
        EndIf
      Wend
      
      If Error<>""
        Output+Error
      EndIf
      
      If Right(Output,Len(#SystemEOL))=#SystemEOL; this should always be true if there are chars in the string, as we add it if there is something from readprogstring
        Output=Left(Output,Len(Output)-Len(#SystemEOL))
      EndIf
      CloseProgram(Prog)
    Else
      TBError(Exe+" "+Par+Language("TailBite","NotFound"), 1, DelFolder)
    EndIf
    
    ProcedureReturn Output
  EndProcedure
  Procedure.b PBCompile(ThisFile.s, ExeName.s, Extra.s, Icon, DelFolder.s, fatal)
    Protected CmdLine.s,PBOutput$
    
    
    WriteLog("PBCompile("+ThisFile+","+ExeName+","+Extra+")")
    
    If ThisFile.s<>""
      CmdLine.s = ThisFile.s
      If Left(CmdLine.s, 1)<>#DQUOTE$
        CmdLine.s = #DQUOTE$+CmdLine.s
      EndIf
      If Right(CmdLine.s, 1)<>#DQUOTE$
        CmdLine.s+#DQUOTE$
      EndIf
    ElseIf FindString(Extra.s, #Switch_Resident, 1)=0
      TBError(Language("TBManager","NoFile"), fatal, DelFolder.s)
      ProcedureReturn #False
    EndIf
    CmdLine.s+Extra.s
    If ExeName.s
      CmdLine.s+" "+#Switch_Executable+" "+#DQUOTE$+ExeName.s+#DQUOTE$
    EndIf
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      If Icon
        CmdLine.s+" /ICON "+#DQUOTE$+GetPathPart(ThisFile.s)+"tb_infobite.ico"+#DQUOTE$
      EndIf
    CompilerElse
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        If Icon
        CmdLine.s+" -n "+#DQUOTE$+GetPathPart(ThisFile.s)+"tb_infobite.icns"+#DQUOTE$
      EndIf
      CompilerEndIf
    CompilerEndIf
    
    
    ; gnozal
    If UseThreadOption
      CmdLine.s+" "+#Switch_ThreadSafe
    EndIf
    If UseUnicodeOption
      CmdLine.s+" "+#Switch_Unicode
    EndIf
    ;
    ; ABBKlaus
    If UseSubsystem ; Compile with Subsystem
      CmdLine.s+" "+#Switch_SubSystem+" "+#DQUOTE$+PBSubsystem$+#DQUOTE$
    EndIf
    ;Text$=#DQUOTE$+PBCompilerFolder$+"PBCompiler.exe"+#DQUOTE$+NL$+CmdLine.s+NL$+DelFolder.s
    WriteLog(" ExecuteProgram("+#DQUOTE$+PBCompilerFolder$+"pbcompiler"+#SystemExeExt+#DQUOTE$+","+CmdLine+","+DelFolder+")")
    PBOutput$ = ExecuteProgram(PBCompilerFolder$+"pbcompiler"+#SystemExeExt, CmdLine.s, DelFolder.s)
    If Left(Extra.s, 10)<>" "+#switch_resident
      If FindString(PBOutput$,PureOk$,1)=0 Or PBOutput$=""
        If FindString(extra, #Switch_Commented, 1)
          WriteLog(PBOutput$)
          If FindString(PBOutput$, #SystemLinkerError,1)
            WriteLog("Ignoring unresolved external error(s) - compiling in commented asm mode")
            ProcedureReturn #True;asm will have been generated, but because certain symbols are not linked to the exe, (unwanted) linking fails. (eg debugger symbols)
          Else;some other error
            CompilerIf Defined(TB_Enable_Progress, #PB_Constant) 
            CompilerIf #TB_Enable_Progress = 1; will only be called when enabled in Tailbite.pb or Tailbite_DLL.pb
              ProgressBarSetPercent(#progress, 100);makes the taskbar button turn ruby red
            CompilerEndIf
            CompilerEndIf
            TBError("PBCompiler: "+Extra.s+NL$+NL$+PBOutput$, fatal, DelFolder.s)
            ProcedureReturn #False
          EndIf
        Else 
          WriteLog(PBOutput$)
          TBError("PBCompiler: "+Extra.s+NL$+NL$+PBOutput$, fatal, DelFolder.s)
          ProcedureReturn #False
        EndIf
      EndIf
    Else
      If FindString(PBOutput$,PureResOk$,1)=0 Or PBOutput$=""
        WriteLog(PBOutput$)
        TBError("PBCompiler: "+Extra.s+NL$+NL$+PBOutput$, fatal, DelFolder.s)
        ProcedureReturn #False
      EndIf
    EndIf
    ProcedureReturn #True
  EndProcedure
; IDE Options = PureBasic 4.41 RC 1 (Windows - x86)
; CursorPosition = 104
; FirstLine = 84
; Folding = -