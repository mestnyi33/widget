IncludePath "../../../"
XIncludeFile "widgets.pbi"

UseLib(widget)

LN=5
Global *w._S_widget

If OpenWindow(0, 100, 50, 530, 170, "editor set&get item state", #PB_Window_SystemMenu)
  EditorGadget(0, 10, 10, 250, 150)  
  
  Open(0, 270, 10, 250, 150)
  *w=Editor(0, 0, 250, 150, #__Flag_GridLines)  
  
  a=0
  For a = 0 To LN
    AddItem (*w, -1, "Item "+Str(a), 0)
  Next
  
  SetState(*w, 5) ; set (beginning with 0) the tenth item as the active one
  
  ;
  a=0
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0)
  Next
  
  SetGadgetState(0, 5) ; set (beginning with 0) the tenth item as the active one
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP