IncludePath "../../../"
XIncludeFile "widgets.pbi"

UseWidgets( )

LN=5
Global *w._S_widget

If OpenWindow(0, 100, 50, 530, 170, "editor set&get item state", #PB_Window_SystemMenu)
  EditorGadget(0, 10, 10, 250, 150)  
  
   SetGadgetFont(#PB_All, GetGadgetFont(0))
   Open(0, 270, 10, 250, 150)
  *w=Editor(0, 0, 250, 150, #__Flag_GridLines)  
  
  a=0
  For a = 0 To LN
    AddItem (*w, a, "Item "+Str(a), 0)
  Next
  
  Define i = 2
  ; SetState(*w, - 1) 
  SetState(*w, i*7+5) ; set (beginning with 0) the tenth item as the active one
  SetActive( *w )
  
  ;
  a=0
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0)
  Next
  
  SetGadgetState(0, 5) ; set (beginning with 0) the tenth item as the active one
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 12
; Folding = -
; EnableXP