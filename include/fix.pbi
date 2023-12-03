XIncludeFile "os/fix/events.pbi"

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
   ;XIncludeFile "os/fix/mac/events.pbi"
   XIncludeFile "os/fix/mac/draw.pbi"
   
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
   ;XIncludeFile "os/fix/lin/events.pbi"
   
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
   ;XIncludeFile "os/fix/win/events.pbi"
   
CompilerEndIf

;- MACOS
DeclareModule fix
   Macro PB(Function)
      Function
   EndMacro
   
   ;- mac
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS And Defined( draw, #PB_Module )
      Macro PB_(Function)
         draw::mac_#Function
      EndMacro
      
      Macro TextHeight(Text)
         PB_(TextHeight)(Text)
      EndMacro
      
      Macro TextWidth(Text)
         PB_(TextWidth)(Text)
      EndMacro
      
      Macro DrawingMode(_mode_)
         PB_(DrawingMode)(_mode_)
         PB(DrawingMode)(_mode_) 
      EndMacro
      
      Macro DrawingFont(FontID)
         PB_(DrawingFont)(FontID)
      EndMacro
      
      Macro ClipOutput(x, y, width, height)
         PB(ClipOutput)(x, y, width, height)
         PB_(ClipOutput)(x, y, width, height)
      EndMacro
      
      Macro UnclipOutput()
         PB(UnclipOutput)()
         PB_(ClipOutput)(0, 0, OutputWidth(), OutputHeight())
      EndMacro
      
      Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
         PB_(DrawRotatedText)(x, y, Text, 0, FrontColor, BackColor)
      EndMacro
      
      Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
         PB_(DrawRotatedText)(x, y, Text, Angle, FrontColor, BackColor)
      EndMacro
      
      ;     ;- lin
      ;   CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      
      ;     ;- win
      ;   CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
   CompilerElse
      Macro PB_(Function)
         Function
      EndMacro
      
   CompilerEndIf
EndDeclareModule 

Module fix
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
   CompilerEndIf
EndModule 

UseModule fix
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 10
; Folding = ---
; EnableXP