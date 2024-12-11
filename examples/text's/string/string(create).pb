
IncludePath "../../../" : XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  EnableExplicit
  ;test_area = 1
  
  Macro Create(Index, X,Y,Width,Height, Text, flag=0)
    String(X,Y,Width,Height, Text, flag)
    If flag & #PB_String_BorderLess = 0
      SetFrame(widget( ), 1)
    EndIf
    ; Editor(x,y,width,height, flag) : setText(widget(), text)
  EndMacro
  
 If OpenWindow(0, 0, 0, 615, 310, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define Height, Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      Height = 20
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      Height = 18
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      Height = 20
      LoadFont(0, "monospace", 9)
      SetGadgetFont(-1,FontID(0))
    CompilerEndIf
    
    ;\\
    StringGadget(0, 8,  10, 290, Height, "Normal StringGadget...")
    StringGadget(1, 8,  35, 290, Height, "1234567", #PB_String_Numeric)
    StringGadget(2, 8,  60, 290, Height, "Read-only StringGadget", #PB_String_ReadOnly)
    StringGadget(3, 8,  85, 290, Height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, 110, 290, Height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, 140, 290, Height, "Borderless StringGadget", #PB_String_BorderLess)
    StringGadget(6, 8, 170, 290, Height, "Password", #PB_String_Password)
    
    StringGadget(7, 8,  200, 290, 100, Text)
    
    SetGadgetText(6, "GaT")
    
    ;\\
    Open( 0, 308 )
    Create(0, 8,  10, 290, Height, "Normal StringGadget...")
    Create(1, 8,  35, 290, Height, "1234567", #PB_String_Numeric)
    Create(2, 8,  60, 290, Height, "Read-only StringGadget", #PB_String_ReadOnly)
    Create(3, 8,  85, 290, Height, "LOWERCASE...", #PB_String_LowerCase)
    Create(4, 8, 110, 290, Height, "uppercase...", #PB_String_UpperCase)
    Create(5, 8, 140, 290, Height, "Borderless StringGadget", #PB_String_BorderLess)
    Create(6, 8, 170, 290, Height, "Password", #PB_String_Password)
    
    Create(7, 8,  200, 290, 100, Text)
    
    SetText(ID(6), "GaT")
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP