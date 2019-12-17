IncludePath "../"
XIncludeFile "editor().pb"
;XIncludeFile "widgets().pbi"
UseModule editor
Global *w._struct_

If OpenWindow(0, 0, 0, 270, 270, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  EditorGadget(0, 10, 10, 250, 120)
  Gadget(1, 10, 140, 250, 120) : *w=GetGadgetData(1)
    
  For a = 1 To 12
    AddGadgetItem (0, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  
  SetText(*w, "The" + #LF$ + "quick" + #LF$ + "brown" + #LF$ + "fox" + #LF$ + "jumps" + #LF$ + "over" + #LF$ + "the" + #LF$ + "lazy" + #LF$ + "dog."); + #LF$)
  For a = 1 To 12
    AddItem (*w, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  
;   *w\text\string = Trim(*w\text\string, #LF$) ;+#LF$
;   *w\text\len = Len(*w\text\string)
  
  SetState(*w,  278) ; set caret pos   
  ;SetState(*w,  -1) ; set last pos   
  
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