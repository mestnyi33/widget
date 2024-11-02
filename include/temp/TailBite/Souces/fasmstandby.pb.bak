CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  CompilerError "This can only be compiled in x86 mode; fasm.obj is 32bit only"
CompilerEndIf

;IncludeFile "fasm.ash.pbi"
IncludeFile "inc_fasm.pb"

global cons 

;Procedure.s GetInput()
  ;OutputDebugString_("getinput()")
  ;Protected *inbuf = AllocateMemory(#MAX_PATH*2+10)
  ;Protected result.s
  ;while result = ""
    ;ReadConsoleData(*inbuf, #MAX_PATH*2+10)
    ;ReadFile_(cons, *inbuf, #MAX_PATH*2+10, 0, 0)
    ;result.s = PeekS(*inbuf)
    ;result = RemoveString(RemoveString(result, #lf$), #CR$)
    ;if result = ""
      ;Delay(20)
    ;endif 
  ;wend 
  ;FreeMemory(*inbuf)
  ;ProcedureReturn result
;EndProcedure

;Declare do_asmcompile(file.s, out.s)

;if OpenLibrary(0, "fasm.dll")
OpenConsole()
  
  ;global fasm_AssembleFile.fasm_AssembleFile_ = GetFunction(0, "fasm_AssembleFile")
  ;if fasm_AssembleFile = 0
    ;PrintN("Error; Could not find fasm_assemblefile in fasm.dll")
    ;OutputDebugString_("Error; Could not find fasm_assemblefile in fasm.dll")
    ;end
  ;endif 
  
  ;global *membuf.FASM_STATE = AllocateMemory(8388608);8mb
  ;global cons =  GetStdHandle_(#STD_OUTPUT_HANDLE)
  ;import "fasm.obj"
    ;fasm_AssembleFile(lpSourceFile.s,lpMemory,cbMemorySize,nPassesLimit,hDisplayPipe) as "fasm_AssembleFile"
  ;EndImport
  
  Repeat
    command.s = Input()
    select LCase(StringField(command, 1, #TAB$))
      case "end"
        OutputDebugString_("exiting")
        end
      case "compile"
        OutputDebugString_("compiling")
        PrintN(CompileAsmFasm(StringField(command, 2, #TAB$), StringField(command, 3, #TAB$)))
      case ""
        ;OutputDebugString_("empty command")
        Delay(20)
        Continue
      Default
        PrintN("Unknown command: "+#DQUOTE$+ LCase(StringField(command, 1, #TAB$))+#DQUOTE$)
    EndSelect
  ForEver
  
  CloseConsole()
;else
  ;PrintN("Error; Could not open fasm.dll")
  ;OutputDebugString_("could not open fasm.dll")
;Endif
;
;
;Procedure do_asmcompile(file.s, out.s)
  ;res = fasm_AssembleFile(file, *membuf, 8388608, 100, cons)
  ;select res
    ;case #FASM_OK
      ;debug "yes"
      ;if CreateFile(0, out)
        ;WriteData(0, *membuf\output_data, *membuf\output_length)
        ;CloseFile(0)
        ;PrintN("Ok, "+Str(*membuf\output_length)+" bytes.")
        ;OutputDebugString_("Ok, "+Str(*membuf\output_length)+" bytes.")
      ;else
        ;PrintN("Could not create obj file to write data to")
        ;OutputDebugString_("Could not create obj file to write data to")
      ;endif 
    ;case #FASM_ERROR	; FASM_STATE contains error code
      ;PrintN("Error")
      ;OutputDebugString_("Error")
      ;PrintN("Line no: "+Str(*membuf\error_line\line_number))
      ;PrintN("Error code: "+Str(*membuf\error_code))
      ;PrintN("Error String: "+ErrorCodeToString(*membuf\error_code))
    ;case #FASM_INVALID_PARAMETER	
      ;PrintN("Invalid Parameter")
    ;case #FASM_OUT_OF_MEMORY	
      ;PrintN("Out of memory")
    ;case #FASM_STACK_OVERFLOW	;	 = -3
      ;PrintN("Stack Overflow")
    ;case #FASM_SOURCE_NOT_FOUND;= -4
      ;PrintN("Source not found")
    ;case #FASM_UNEXPECTED_END_OF_SOURCE	; = -5
      ;PrintN("Unexpected end of source")
    ;case #FASM_CANNOT_GENERATE_CODE	; = -6
      ;PrintN("Cannot Generate Code")
    ;case #FASM_FORMAT_LIMITATIONS_EXCEDDED ;= -7
      ;PrintN("Format Limitations Exceeded")
    ;case #FASM_WRITE_FAILED		; = -8
      ;PrintN("Write Failed")
    ;Default
      ;PrintN("Unhandled Error: "+Str(res))
      ;OutputDebugString_("Unhandled Error: "+Str(res))
  ;EndSelect
;EndProcedure
; IDE Options = DuplicaPBe Windows v 0.3
; CursorPosition = 52
; FirstLine = 35
; EnableXP
; EnableUser
; ExecutableFormat = Console
; Executable = fasmstandby.exe