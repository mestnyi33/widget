IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseWidgets( )
  test_draw_area = 1
  
  Enumeration
    #window_0
    #window
  EndEnumeration
  
  Open(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  Define Text.s, m.s   = #LF$, a
  
  Define *g = Editor(50, 50, 200 + 60-Bool(#PB_Compiler_OS=#PB_OS_Windows)*16, 200);, #__flag_autosize)
  
  Text.s = "This is a long line." + m.s +
           "Who should show." + m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work."
  
  SetText(*g, Text.s)
;   For a = 0 To 2
;     AddItem(*g, a, Str(a) + " Line " + Str(a))
;   Next
;   AddItem(*g, 7 + a, "_")
;   For a = 4 To 6
;     AddItem(*g, a, Str(a) + " Line " + Str(a))
;   Next
;   
;   ;CloseList( ) ; close panel lists
;   
  
  WaitClose( ) ;;;
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 8
; Folding = -
; EnableXP