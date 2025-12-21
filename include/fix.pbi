XIncludeFile "os/fix/events.pbi"

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
   XIncludeFile "os/fix/mac/event.pbi"
   XIncludeFile "os/fix/mac/draw.pbi"
   
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
   ;XIncludeFile "os/fix/lin/events.pbi"
   
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
   ;XIncludeFile "os/fix/win/events.pbi"
   XIncludeFile "os/fix/win/draw.pbi"
   
CompilerEndIf

;- MACOS
DeclareModule fix
   Macro PB(Function)
      Function
   EndMacro
   
   ;- mac
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS And Defined( Draw, #PB_Module )
      Macro PB_(Function)
         Draw::mac_#Function
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
      
      Macro ClipOutput(X, Y, Width, Height)
         PB(ClipOutput)(X, Y, Width, Height)
         PB_(ClipOutput)(X, Y, Width, Height)
      EndMacro
      
      Macro UnclipOutput()
         PB(UnclipOutput)()
         PB_(ClipOutput)(0, 0, OutputWidth(), OutputHeight())
      EndMacro
      
      Macro DrawText(X, Y, Text, FrontColor=$ffffff, BackColor=0)
         PB_(DrawRotatedText)(X, Y, Text, 0, FrontColor, BackColor)
      EndMacro
      
      Macro DrawRotatedText(X, Y, Text, Angle, FrontColor=$ffffff, BackColor=0)
         PB_(DrawRotatedText)(X, Y, Text, Angle, FrontColor, BackColor)
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
; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; Folding = ---
; EnableXP