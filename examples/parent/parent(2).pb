XIncludeFile "../../widgets.pbi" : Uselib(widget)

Global i, *w, *p1,*p2, *ch, *b

Procedure events_widgets()
  Select this()\event
    Case #PB_EventType_LeftClick
      If *b = *event\widget
        If i 
          SetParent(*w, *p1)
        Else
          SetParent(*w, *p2)
        EndIf
        
        Debug GetParent(*w)
        If *ch
          Debug ""+*w +" "+ GetParent(*ch) +" "+  Y(*ch) +" "+  Y(*ch, 3)
        EndIf
        
        i!1
      EndIf
  EndSelect
EndProcedure

If Open(OpenWindow(#PB_Any, 150, 110, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu))
  *p1 = Container(10, 10, 200, 200)            ; 0
  *w = Container(10, 10, 100, 100)             ; 1
  ;Container(10, 10, 100, 100)                  ; 2
  Button(-25, 20, 120, 40, "Button_2_3") ; 3
 ; CloseList()
  CloseList()
  CloseList()
  EndIf
  
  If Open(OpenWindow(#PB_Any, 0, 0, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  
  *p2 = Container(20, 180, 200, 200)           ; 4
  Button(-25, 10, 100, 30, "Button_4_5")       ; 5
  CloseList()
  
  *b=Button(10,430, 200, 30, "change parent", #__Button_Toggle)
  
;   ForEach widget()
;     widget()\class = widget()\class +"-"+ widget()\index
;   Next
  
  i = 1
  SetParent(*w, *p2)
  
  ForEach widget()
    Debug  ""+ListIndex(widget()) +" - "+ widget()\index +" - "+ widget()\class +" - "+ widget()\text\string +" - "+ widget()\root
  Next
  
  
  Bind(#PB_All, @events_widgets())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP