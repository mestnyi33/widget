;- MACOS
CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  DeclareModule fixme
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      Macro PB(Function)
        Function
      EndMacro
      
      Macro FreeFont(_font_)
        FreeFont_(_font_)
      EndMacro
      
      Declare.i FreeFont_(Font.i)
    CompilerEndIf
  EndDeclareModule 
  
  Module fixme
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      Procedure.i FreeFont_(Font.i)
        If FontID(Font) = PB(GetGadgetFont)(#PB_Default)
          SetGadgetFont(#PB_Default, #PB_Default)
        EndIf
        
        ProcedureReturn PB(FreeFont)(Font)
      EndProcedure
      
    CompilerEndIf
  EndModule 
  
  UseModule fixme
  
CompilerEndIf

; IDE Options = PureBasic 5.70 LTS (Linux - x64)
; CursorPosition = 1
; FirstLine = 7
; Folding = --
; EnableXP