IncludePath "../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  
  Uselib(Widget)
  EnableExplicit
  
  Global g, Text.s, a,i, *g._s_widget
  ; Global m.s=#CRLF$
  Global m.s=#LF$
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  
  Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s +
  
  If Open(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    *g = Editor(0, 0, 422, 491, #__flag_autosize) 
    
    SetText(*g, Text.s) 
    For a = 0 To 2
      AddItem(*g, a, "Line "+Str(a))
    Next
    AddItem(*g, 7+a, "_")
    For a = 4 To 6
      AddItem(*g, a, "Line "+Str(a))
    Next
    ;SetFont(*g, FontID(0))
    
    Repeat 
      Define Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP