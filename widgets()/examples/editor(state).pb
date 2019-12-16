IncludePath "../"
XIncludeFile "editor().pb"
;XIncludeFile "widgets().pbi"
UseModule editor

If OpenWindow(0, 0, 0, 270, 270, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  EditorGadget(0, 10, 10, 250, 120)
  Gadget(1, 10, 140, 250, 120) : *w=GetGadgetData(1)
    
  For a = 1 To 12
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  
  For a = 1 To 12
    AddItem (*w, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  
  SetState(*w, 278) ; - 1) ; set caret pos   
  
  Debug " get state - " + GetState(*w)
  Repeat 
    event = WaitWindowEvent() 
    Select event
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_LeftClick
            ClearDebugOutput()
            Debug " get state - " + GetState(*w)
            
        EndSelect
    EndSelect
  Until event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP