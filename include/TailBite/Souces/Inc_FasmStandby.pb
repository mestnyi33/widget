
Global fasmHandle

Procedure.s FasmStandby(file.s, out.s)
  Protected result.s
  if fasmHandle = 0 or ProgramRunning(fasmHandle) = 0
    fasmHandle = RunProgram("fasmstandby.exe", "", GetCurrentDirectory(), #PB_Program_Hide|#PB_Program_Open|#PB_Program_Read|#PB_Program_Write)
    if fasmHandle = 0 
      ProcedureReturn "Could not start fasm in standby mode"
    endif
  endif
  WriteProgramStringN(fasmHandle, "compile"+#TAB$+file+#TAB$+out)
  result = ReadProgramString(fasmHandle)
  if result = "Error"
    result + #CRLF$+ReadProgramString(fasmHandle)+ #CRLF$+ReadProgramString(fasmHandle)+ #CRLF$+ReadProgramString(fasmHandle)
  endif
  
  ProcedureReturn result
EndProcedure
; IDE Options = DuplicaPBe Windows v 0.3
; CursorPosition = 17
; EnableXP
; EnableUser
; TB_MultiLib