IncludePath "../../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  
  EnableExplicit
  UseLIB(widget)
  
  Enumeration
    #window_0
    #window
  EndEnumeration
  
  Open(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  Define Text.s, m.s   = #LF$, a
  
  Define *g = Editor(50, 50, 200 + 60-Bool(#PB_Compiler_OS=#PB_OS_Windows)*17, 200);, #__flag_autosize)
  
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
  
  
  WaitClose( ) ;;;
CompilerEndIf
CompilerIf #PB_Compiler_IsMainFile = 99
  
  EnableExplicit
  UseLIB(widget)
  
  Enumeration
    #window_0
    #window
  EndEnumeration
  
  OpenWindow(#window, 0, 0, 800, 600, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ;\\ Open Root0
  Define *root0._S_WIDGET = Open(#window, 10, 10, 300 - 20, 300 - 20): *root0\class = "root0": SetText(*root0, "root0")
  ;BindWidgetEvent( *root2, @BindEvents( ) )
  
  Global *button_panel = Panel(10, 10, 200 + 60, 200)
  Define Text.s, m.s   = #LF$, a
  AddItem(*button_panel, -1, "1")
  Define *g = Editor(0, 0, 0, 0, #__flag_gridlines | #__flag_autosize)
  ;*g                 = Editor(10, 10, 200 + 60, 200, #__flag_gridlines);, #__flag_autosize)
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
  For a = 0 To 2
    AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  AddItem(*g, 7 + a, "_")
  For a = 4 To 6
    AddItem(*g, a, Str(a) + " Line " + Str(a))
  Next
  
  ;\\
  AddItem(*button_panel, -1, "2")
  *g = Tree(0, 0, 0, 0, #__flag_gridlines | #__flag_autosize)
  a  = - 1
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
  ;\\
  AddItem(*button_panel, -1, "3")
  *g = ListIcon(0, 0, 0, 0, "Column_1", 90, #__flag_autosize | #__Flag_FullSelection | #__Flag_GridLines | #__Flag_CheckBoxes) ;: *g = GetGadgetData(g)
  For a = 1 To 2
    AddColumn(*g, a, "Column_" + Str(a + 1), 90)
  Next
  For a = 0 To 15
    AddItem(*g, a, Str(a) + "_Column_1" + #LF$ + Str(a) + "_Column_2" + #LF$ + Str(a) + "_Column_3" + #LF$ + Str(a) + "_Column_4", 0)
  Next
  
  ;SetState(*button_panel, 2)
  CloseList( ) ; close panel lists
  
  *g = String(10, 220, 200, 50, "string gadget text text 1234567890 text text long long very long", #__string_password | #__string_right)
  
  ;\\
  Procedure button_panel_events( )
    Select GetText( EventWidget( ) )
      Case "1"
        SetState(*button_panel, 0)
      Case "2"
        SetState(*button_panel, 1)
    EndSelect
  EndProcedure
  Bind(Button( 220, 220, 25, 50, "1"), @button_panel_events( ), #__event_LeftClick )
  Bind(Button( 220 + 25, 220, 25, 50, "2"), @button_panel_events( ), #__event_LeftClick )
  ;\\Close( )
  
  
  WaitClose( ) ;;;
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = 0
; EnableXP