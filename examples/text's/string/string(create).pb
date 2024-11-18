
IncludePath "../../../" : XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  EnableExplicit
  
  Global *S_0._s_WIDGET
  Global *S_1._s_WIDGET
  Global *S_2._s_WIDGET
  Global *S_3._s_WIDGET
  Global *S_4._s_WIDGET
  Global *S_5._s_WIDGET
  Global *S_6._s_WIDGET
  Global *S_7._s_WIDGET
    
  Macro Create(index, x,y,width,height, text, flag=0)
    StringWidget(x,y,width,height, text, flag)
    If flag & #PB_String_BorderLess = 0
      SetWidgetFrame(widget( ), 1)
    EndIf
    ; EditorWidget(x,y,width,height, flag) : SetWidgetText(widget(), text)
  EndMacro
  
 If OpenRoot(0, 0, 0, 615, 310, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define x=300
    Define height, Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      height = 20
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      height = 18
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      height = 20
      LoadFont(0, "monospace", 9)
      SetGadGetWidgetFont(-1,FontID(0))
    CompilerEndIf
    
    ;\\
    StringGadget(0, 8,  10, 290, height, "Normal StringGadget...")
    StringGadget(1, 8,  35, 290, height, "1234567", #PB_String_Numeric)
    StringGadget(2, 8,  60, 290, height, "Read-only StringGadget", #PB_String_ReadOnly)
    StringGadget(3, 8,  85, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, 110, 290, height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, 140, 290, height, "Borderless StringGadget", #PB_String_BorderLess)
    StringGadget(6, 8, 170, 290, height, "Password", #PB_String_Password)
    
    StringGadget(7, 8,  200, 290, 100, Text)
    
    SetGadGetWidgetText(6, "GaT")
    
    ;\\
    *S_0 = Create(0, x+8,  10, 290, height, "Normal StringGadget...")
    *S_1 = Create(1, x+8,  35, 290, height, "1234567", #PB_String_Numeric)
    *S_2 = Create(2, x+8,  60, 290, height, "Read-only StringGadget", #PB_String_ReadOnly)
    *S_3 = Create(3, x+8,  85, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    *S_4 = Create(4, x+8, 110, 290, height, "uppercase...", #PB_String_UpperCase)
    *S_5 = Create(5, x+8, 140, 290, height, "Borderless StringGadget", #PB_String_BorderLess)
    *S_6 = Create(6, x+8, 170, 290, height, "Password", #PB_String_Password)
    
    *S_7 = Create(7, x+8,  200, 290, 100, Text)
    
    SetWidgetText(*S_6, "GaT")
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP