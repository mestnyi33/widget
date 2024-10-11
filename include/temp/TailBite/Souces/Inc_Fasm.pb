CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  CompilerError "This can only be compiled in x86 mode; fasm.obj is 32bit only"
CompilerEndIf

IncludeFile "fasm.ash.pbi"

Declare do_asmcompile(file.s, out.s)

Global *membuf.FASM_STATE
Global cons
Global fasm_memSize = 8388608;8mb

CompilerIf Defined(TB_Installer, #PB_Constant) = 0
;if OpenLibrary(0, "fasm.dll")
  
  ;fasm_AssembleFile.fasm_AssembleFile_ = GetFunction(0, "fasm_AssembleFile")
  ;if fasm_AssembleFile = 0
  ;  TBError("Error; Could not find fasm_assemblefile in fasm.dll", 1, TBTempPath$)
  ;  OutputDebugString_("Error; Could not find fasm_assemblefile in fasm.dll")
  ;  CompilerIf Defined(TB_Building_DLL, #PB_Constant) = 0 : End : CompilerEndIf
  ;endif 
  Global *membuf.FASM_STATE = AllocateMemory(fasm_memSize)
  Global cons =  GetStdHandle_(#STD_OUTPUT_HANDLE)
  Import "fasm.obj"
    fasm_AssembleFile(lpSourceFile.s,lpMemory,cbMemorySize,nPassesLimit,hDisplayPipe) As "fasm_AssembleFile"
  EndImport
  
;else
  ;TBError("Error; Could not open fasm.dll", 1, TBTempPath$)
  ;OutputDebugString_("could not open fasm.dll")
;Endif
CompilerElse;no need to link fasm into the installer...
  
  Prototype fasm_AssembleFile_(lpSourceFile.s,lpMemory,cbMemorySize,nPassesLimit,hDisplayPipe)
  Global fasm_AssembleFile.fasm_AssembleFile_
  
CompilerEndIf

Procedure.s CompileAsmFasm(file.s, out.s)
  Protected *newbuf,res,ofile,MyString.s
  Static MembufIncrease=0
  
  #MembufIncreaseMax=5
  
  res = fasm_AssembleFile(file, *membuf, fasm_memSize, 100, cons)
  Select res
    Case #FASM_OK
      ;debug "yes"
      ofile = CreateFile(#PB_Any, out)
      If ofile
        WriteData(ofile, *membuf\output_data, *membuf\output_length)
        CloseFile(ofile)
        MyString="Ok, "+Str(*membuf\output_length)+" bytes."
        OutputDebugString_(@MyString)
        ProcedureReturn MyString
      Else
        MyString="Could not create obj file to write data to"
        OutputDebugString_(@MyString)
        ProcedureReturn MyString
      EndIf 
    Case #FASM_ERROR	; FASM_STATE contains error code
      MyString="Error"
      OutputDebugString_(@MyString)
      ProcedureReturn ("Error"+#CRLF$+"Line no: "+Str(*membuf\error_line\line_number)+#CRLF$+"Error code: "+Str(*membuf\error_code)+#CRLF$+"Error String: "+ErrorCodeToString(*membuf\error_code))
    Case #FASM_INVALID_PARAMETER	
      ProcedureReturn ("Invalid Parameter")
    Case #FASM_OUT_OF_MEMORY	
      If MembufIncrease >= #MembufIncreaseMax;6 tries max - 256mb ram...
        ; we are already at the maximum, so don´t try again ;-)
        ProcedureReturn ("Out of memory")
      Else
        MembufIncrease+1
        fasm_memSize = fasm_memSize*2
        MyString=Str(MembufIncrease)+".trying to allocate new membuf of MB: "+Str(fasm_memSize/1024/1024) 
        WriteLog(MyString)
        OutputDebugString_(@MyString)
        *newbuf = ReAllocateMemory(*membuf, fasm_memSize)
        If *newbuf
          *membuf = *newbuf
          MyString="new memory buffer succeeded"
          WriteLog(MyString)
          OutputDebugString_(@MyString)
          ProcedureReturn CompileAsmFasm(file.s, out.s)
        Else 
          fasm_memSize / 2;since it didnt work
          MyString="allocation of new memory buffer failed"
          WriteLog(MyString)
          OutputDebugString_(@MyString)
          ProcedureReturn ("Out of memory")
        EndIf
      EndIf
    Case #FASM_STACK_OVERFLOW	;	 = -3
      ProcedureReturn ("Stack Overflow")
    Case #FASM_SOURCE_NOT_FOUND;= -4
      ProcedureReturn ("Source not found")
    Case #FASM_UNEXPECTED_END_OF_SOURCE	; = -5
      ProcedureReturn ("Unexpected end of source")
    Case #FASM_CANNOT_GENERATE_CODE	; = -6
      ProcedureReturn ("Cannot Generate Code")
    Case #FASM_FORMAT_LIMITATIONS_EXCEDDED ;= -7
      ProcedureReturn ("Format Limitations Exceeded")
    Case #FASM_WRITE_FAILED		; = -8
      ProcedureReturn ("Write Failed")
    Default
      MyString="Unhandled Error: "+Str(res)
      WriteLog(MyString)
      OutputDebugString_(@MyString)
      ProcedureReturn ("Unhandled Error: "+Str(res))
  EndSelect
EndProcedure
; IDE Options = PureBasic 5.40 LTS Beta 1 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 106
; FirstLine = 57
; Folding = -
; EnableXP
; EnableUser
; Executable = ..\fasmstandby\fasmstandby.exe
; TB_MultiLib