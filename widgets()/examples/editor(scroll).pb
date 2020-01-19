IncludePath "../"
XIncludeFile "editor().pbi"
;XIncludeFile "widgets().pbi"
UseModule editor
UseModule constants
UseModule structures

Global *w._s_widget, *w1._s_widget

If OpenWindow(0, 0, 0, 270+260, 140, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  Gadget(0, 10, 10, 250, 120) : *w=GetGadgetData(0)
  Gadget(1, 270, 10, 250, 120) : *w1=GetGadgetData(1)
    
  For a = 1 To 12
    AddItem (*w, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  
  ; SetText(*w1, "The" + #LF$ + "quick" + #LF$ + "brown" + #LF$ + "fox" + #LF$ + "jumps" + #LF$ + "over" + #LF$ + "the" + #LF$ + "lazy" + #LF$ + "dog."); + #LF$)
  For a = 1 To 12
    AddItem (*w1, -1, "Item " + Str(a) + " of the Listview") ; define listview content
  Next
  
;   *w\text\string = Trim(*w\text\string, #LF$) ;+#LF$
;   *w\text\len = Len(*w\text\string)
  
;   SetActiveGadget(0)
;   SetPos(0, 98)
  
  SetActive(*w)
  SetItemState(*w,  8, 6) ; set caret pos   
  
  SetActive(*w1)
  ; SetItemState(*w1,  GetState(*w), GetItemState(*w, GetState(*w))) ; set caret pos   
  SetState(*w1,  GetItemState(*w, - 1)) ; set caret pos   
  
  redraw(*w)
  redraw(*w1)
  
  Debug " get item - " + GetState(*w)
  Debug " get item caret pos - " + GetItemState(*w, GetState(*w))
  Debug " get text caret pos - " + GetItemState(*w, - 1)
  
  Repeat 
    event = WaitWindowEvent() 
    Select event
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_MouseMove
            If EventGadget() = *w\root\canvas And *w\scroll\v\change
              If bar::SetState(*w1\scroll\v, bar::GetState(*w\scroll\v))
                redraw(*w1)
              EndIf
            EndIf
            
            If EventGadget() = *w1\root\canvas And *w1\scroll\v\change
              If bar::SetState(*w\scroll\v, bar::GetState(*w1\scroll\v))
                redraw(*w)
              EndIf
            EndIf
            
            
          Case #PB_EventType_LeftClick
            ClearDebugOutput()
            Debug " get item - " + GetState(*w)
            Debug " get item caret pos - " + GetItemState(*w, GetState(*w))
            Debug " get text caret pos - " + GetItemState(*w, - 1)
            
        EndSelect
    EndSelect
  Until event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP