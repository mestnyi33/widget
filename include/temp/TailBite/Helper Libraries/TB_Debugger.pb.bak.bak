;-Planned usage in UserLibs:
; IncludeFile #pb_compiler_home+"/TailBite/Addons/TB_Debugger.pb" (naturally user will change to location of their TB install)

CompilerIf #PB_Compiler_Processor = #PB_Processor_x64;in here we define a constant for the As decoration, and use the correct Import
  #tb_debugger_decoration = ""
  Import ""
CompilerElse
  CompilerSelect  #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      #tb_debugger_decoration = "_"
      Import ""
      
    CompilerCase #PB_OS_Linux
      #tb_debugger_decoration = ""
      ImportC ""
      
    CompilerCase #PB_OS_MacOS
      #tb_debugger_decoration = "_"
      ImportC ""
  CompilerEndSelect
CompilerEndIf
  
PB_DEBUGGER_SendError(Message.p-ascii)
PB_DEBUGGER_SendWarning(Message.p-ascii)
PB_DEBUGGER_FileExists(Filename.s)
PB_DEBUGGER_CheckLabel(*Label)
;PB_DEBUGGER_Unicode.i
EndImport

ImportC "";This one is always cdecl
PB_DEBUGGER_CheckProcedure(*Proc, ReturnType, Count) As #tb_debugger_decoration+"PB_DEBUGGER_CheckProcedure"
PB_DEBUGGER_CheckProcedure1(*Proc, ReturnType, Count, arg0) As #tb_debugger_decoration+"PB_DEBUGGER_CheckProcedure"
PB_DEBUGGER_CheckProcedure2(*Proc, ReturnType, Count, arg0, arg1) As #tb_debugger_decoration+"PB_DEBUGGER_CheckProcedure"
PB_DEBUGGER_CheckProcedure3(*Proc, ReturnType, Count, arg0, arg1, arg2) As #tb_debugger_decoration+"PB_DEBUGGER_CheckProcedure"
PB_DEBUGGER_CheckProcedure4(*Proc, ReturnType, Count, arg0, arg1, arg2, arg3) As #tb_debugger_decoration+"PB_DEBUGGER_CheckProcedure"
PB_DEBUGGER_CheckProcedure5(*Proc, ReturnType, Count, arg0, arg1, arg2, arg3, arg4) As #tb_debugger_decoration+"PB_DEBUGGER_CheckProcedure"
PB_DEBUGGER_CheckProcedure6(*Proc, ReturnType, Count, arg0, arg1, arg2, arg3, arg4, arg5) As #tb_debugger_decoration+"PB_DEBUGGER_CheckProcedure"
EndImport

Procedure TB_DebugError(message.s)
;   
; EndProcedure
; ProcedureCDLL TB_DebugError_DEBUG(message.s)
  ;If PB_DEBUGGER_Unicode; And TailBiteLibrary_IsMultiLib
    ;message = PeekS(@message, -1, #PB_Unicode)
  ;EndIf
  PB_DEBUGGER_SendError(Message)
EndProcedure

Procedure TB_DebugWarning(message.s)
;   
; EndProcedure
; ProcedureCDLL TB_DebugWarning_DEBUG(message.s)
  ;If PB_DEBUGGER_Unicode; And TailBiteLibrary_IsMultiLib
    ;message = PeekS(@message, -1, #PB_Unicode)
  ;EndIf
  PB_DEBUGGER_SendWarning(message)
EndProcedure

Procedure TB_DebugFileExists(filename.s)
;   
; EndProcedure
; ProcedureCDLL TB_DebugFileExists_DEBUG(*filename)
  ProcedureReturn PB_DEBUGGER_FileExists(filename)
EndProcedure

Procedure TB_DebugCheckLabel(*Label)
;   
; EndProcedure
; ProcedureCDLL TB_DebugCheckLabel_DEBUG(*Label)
  ProcedureReturn PB_DEBUGGER_CheckLabel(*Label)
EndProcedure

Structure TB_Debug_CheckParams
arg0.i
arg1.i
arg2.i
arg3.i
arg4.i
arg5.i
EndStructure

#PB_Procedure_Ok = 0 ;// Procedure matches
#PB_Procedure_NotFound = 1 ;// Not a valid Procedure pointer (might be an external function though!)
#PB_Procedure_WrongType = 2 ;// Prototype Not matching

Procedure TB_DebugCheckProcedure(*Proc, ReturnType, Count, *params.TB_Debug_CheckParams)
;   
; EndProcedure
; ProcedureCDLL TB_DebugCheckProcedure_DEBUG(*Proc, ReturnType, Count, *params.TB_Debug_CheckParams)
  Select count
    Case 0
      ProcedureReturn PB_DEBUGGER_CheckProcedure(*Proc, ReturnType, Count)
    Case 1
      ProcedureReturn PB_DEBUGGER_CheckProcedure1(*Proc, ReturnType, Count, *params\arg0)
    Case 2
      ProcedureReturn PB_DEBUGGER_CheckProcedure2(*Proc, ReturnType, Count, *params\arg0, *params\arg1)
    Case 3
      ProcedureReturn PB_DEBUGGER_CheckProcedure3(*Proc, ReturnType, Count, *params\arg0, *params\arg1, *params\arg2)
    Case 4
      ProcedureReturn PB_DEBUGGER_CheckProcedure4(*Proc, ReturnType, Count, *params\arg0, *params\arg1, *params\arg2, *params\arg3)
    Case 5
      ProcedureReturn PB_DEBUGGER_CheckProcedure5(*Proc, ReturnType, Count, *params\arg0, *params\arg1, *params\arg2, *params\arg3, *params\arg4)
    Case 6
      ProcedureReturn PB_DEBUGGER_CheckProcedure6(*Proc, ReturnType, Count, *params\arg0, *params\arg1, *params\arg2, *params\arg3, *params\arg4, *params\arg5)
    Default
      PB_DEBUGGER_SendWarning("TB_Debugger: TB_DebugCheckProcedure used with count > 6. Contact userlib maker")
  EndSelect
EndProcedure

Macro ExtrnIt
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    !extern PB_DEBUGGER_Unicode
  CompilerElse
    !extrn PB_DEBUGGER_Unicode
  CompilerEndIf
EndMacro

Procedure TB_DebugCheckUnicode()
;   ProcedureReturn ;PB_DEBUGGER_Unicode
; EndProcedure
; ProcedureCDLL TB_DebugCheckUnicode_DEBUG()
  CompilerIf #PB_Compiler_Debugger = 0
    ExtrnIt
  CompilerEndIf
  
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
    !mov rax, qword [PB_DEBUGGER_Unicode]
  CompilerElse
    !mov eax, dword [PB_DEBUGGER_Unicode]
  CompilerEndIf
  ProcedureReturn; PB_DEBUGGER_Unicode
EndProcedure
; IDE Options = PureBasic 4.31 (MacOS X - x86)
; CursorPosition = 49
; FirstLine = 29
; Folding = --
; EnableXP