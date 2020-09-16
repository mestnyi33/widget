XIncludeFile "../../widgets.pbi" : Uselib(widget)

Global i, *w, *p1,*p2, *ch, *b

Procedure events_widgets()
  Select this()\event
    Case #PB_EventType_LeftClick
      If *b = this()\widget
        If i 
          SetParent(*w, *p2)
        Else
          SetParent(*w, *p1)
        EndIf
        
        Debug GetParent(*w)
        Debug ""+*w +" "+ GetParent(*ch) +" "+  Y(*ch) +" "+  Y(*ch, 3)
        
        i!1
      EndIf
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(OpenWindow(#PB_Any, 0, 0, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  *p2 = Container(10, 10, 200, 200)
  CloseList()
  
  *p1 = Container(20, 180, 200, 200)
  Button(-25, 10, 100, 30, "Button")
  *w = Container(10, 10, 100, 100)
  Container(10, 10, 100, 100)
  *ch = Button(-25, 10, 100, 20, "Button")
  CloseList()
  CloseList()
  CloseList()
  
  *b=Button(10,430, 200, 30, "change parent", #__Button_Toggle)
  
  i = 1
  SetParent(*w, *p2)
  SetParent(*w, *p1)
  
  ForEach widget()
    Debug ""+ widget()\index +" - "+ ListIndex(widget()) +" - "+ widget()\parent\index +" - "+ widget()\class +" - "+ widget()\text\string
  Next
  
  
  Bind(#PB_All, @events_widgets())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP