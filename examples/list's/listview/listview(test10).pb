XIncludeFile "../../../widgets.pbi"



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  Define a
  LoadFont(0, "Helvetica", 13)
  
If Open(0, 0, 0, 270*2, 140, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListView(10, 10, 250, 120)
  For a = 1 To 12
    AddItem (ID(0), -1, "Item yyy " + Str(a) + " of the Listview")   ; definieren des Listview-Inhalts
  Next
  SetState(ID(0), 0)
  ListView(10+270, 10, 250, 120)
  SetFont(ID(1), FontID(0))
  For a = 1 To 12
    AddItem (ID(1), -1, "Item yyy " + Str(a) + " of the Listview")   ; definieren des Listview-Inhalts
  Next
  SetState(ID(1), 0)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 22
; Folding = -
; EnableXP