IncludeFile #PB_Compiler_Home+"tailbite/Helper Libraries/TB_Debugger.pb";If you installed TB somewhere else, you will need to change the path shown here.

ProcedureDLL MyDiv(a, b);set b to zero to trigger compiler error
  ProcedureReturn a/b
EndProcedure
ProcedureCDLL MyDiv_DEBUG(a, b)
  If b=0
    TB_DebugError("Division by zero! From TB!")
  EndIf
EndProcedure
   
ProcedureDLL MyString(string.s)
 MessageRequester("hi", string)
EndProcedure
ProcedureCDLL MyString_DEBUG(*string);set string to "bobo" to trigger compiler warning
 Protected string2.s
 ;MessageRequester("Test", "debug function of mystring!")
  If TB_DebugCheckUnicode()
    TB_DebugWarning("Running in unicode mode")
    string2 = PeekS(*string, MemoryStringLength(*string, #PB_Unicode), #PB_Unicode)
    TB_DebugWarning(#DQUOTE$+string2+#DQUOTE$)
  Else
    string2 = PeekS(*string , -1, #PB_Ascii)
  EndIf
  If string2 = "bobo"
    TB_DebugError("string can't be bobo!!!")
  EndIf
EndProcedure

ProcedureDLL Mylabel(*label)
  
EndProcedure
ProcedureCDLL Mylabel_DEBUG(*label);set to 0 or an invalid label to trigger compiler error
  If Not TB_DebugCheckLabel(*label)
    TB_DebugError("Label not valid")
  EndIf
EndProcedure

ProcedureDLL myfile(file.s);set to a non-existant file to trigger warning
  
EndProcedure
ProcedureCDLL myfile_DEBUG(file.s)
  If Not TB_DebugFileExists(file)
    TB_DebugWarning("(TB) File does not exist: "+file)
  EndIf
EndProcedure

ProcedureDLL MyProcedure(proc.i);expects a pointer to a procedure that returns an integer, has two arguments: a string and an integer. vary this to see warnings.
 
EndProcedure
ProcedureCDLL MyProcedure_DEBUG(proc.i)
  procparams.TB_Debug_CheckParams\arg0=#PB_String
  procparams\arg1=#PB_Integer
  returnval.l = TB_DebugCheckProcedure(proc, #PB_Integer, 2, procparams)
  ;TB_DebugWarning(Str(returnval))
  Select returnval
    Case #PB_Procedure_NotFound
      TB_DebugWarning("Procedure not found, or is non-PB procedure")
    Case #PB_Procedure_WrongType
      TB_DebugWarning("Proc not correct type, or not PB procedure")
  EndSelect
EndProcedure
; IDE Options = PureBasic 4.31 (MacOS X - x86)
; CursorPosition = 19
; Folding = --
; EnableXP