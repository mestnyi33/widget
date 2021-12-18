;- MACOS
CompilerIf #PB_Compiler_OS = #PB_OS_Windows 
  DeclareModule fixme
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows 
      Macro PB(Function)
        Function
      EndMacro
      
      Macro PB_(Function)
        ;Function#_
        Function
      EndMacro
      
    CompilerEndIf
  EndDeclareModule 
  
  Module fixme
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
       
    CompilerEndIf
  EndModule 
  
  UseModule fixme
  
CompilerEndIf

; IDE Options = PureBasic 5.71 LTS (Windows - x64)
; CursorPosition = 10
; Folding = --
; EnableXP