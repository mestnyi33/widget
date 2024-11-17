 IncludePath "../../../"
 XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseWidgets( )
  
  Enumeration
    #window_0
    #window
  EndEnumeration
  
  OpenRootWidget(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  Define Text.s, m.s   = #LF$, a
  a_init(root())
  
;   Define *g = EditorWidget(50, 50, 200 + 60-Bool(#PB_Compiler_OS=#PB_OS_Windows)*16, 200);, #__flag_autosize)
;   
;   Text.s = "This is a long line." + m.s +
;            "Who should show." + m.s +
;            m.s +
;            m.s +
;            m.s +
;            "I have to write the text in the box or not." + m.s +
;            m.s +
;            m.s +
;            m.s +
;            "The string must be very long." + m.s +
;            "Otherwise it will not work."
;   
;   SetTextWidget(*g, Text.s)
;   For a = 0 To 2
;     AddItem(*g, a, Str(a) + " Line " + Str(a))
;   Next
;   AddItem(*g, 7 + a, "_")
;   For a = 4 To 6
;     AddItem(*g, a, Str(a) + " Line " + Str(a))
;   Next
;   
;   ;CloseWidgetList( ) ; close panel lists
  
  Define *g = TreeWidget(50, 50, 200 + 60-Bool(#PB_Compiler_OS=#PB_OS_Windows)*16, 200);, #__flag_autosize)
  
  a=-1
  AddItem(*g, a, "This is a long line.")
  AddItem(*g, a, "Who should show.")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "I have to write the text in the box or not.")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "")
  AddItem(*g, a, "The string must be very long.")
  AddItem(*g, a, "Otherwise it will not work.")
  
  For a = 0 To 2
     AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  AddItem(*g, 7 + a, "_")
  For a = 4 To 6
     AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  
  
  WaitCloseRootWidget( ) ;;;
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 1
; Folding = -
; EnableXP