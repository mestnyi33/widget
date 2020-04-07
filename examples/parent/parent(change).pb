XIncludeFile "../../widgets.pbi" : Uselib(widget)

Global i, *w, *p1,*p2, *ch, *b

Procedure events_widgets()
  Select *event\type
    Case #PB_EventType_LeftClick
      If *b = *event\widget
        If i 
        SetParent(*w, *p1)
      Else
        SetParent(*w, *p2)
      EndIf
      
      Debug GetParent(*w)
      Debug ""+*w +" "+ GetParent(*ch) +" "+  Y(*ch) +" "+  Y(*ch, 3)
      
      i!1
    EndIf
EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
  If Open(OpenWindow(#PB_Any, 0, 0, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    *p1 = Container(10, 10, 200, 200)
    *w = Container(10, 10, 100, 100)
     Container(10, 10, 100, 100)
    *ch = Button(-25, 10, 100, 20, "Button")
    CloseList()
    CloseList()
    CloseList()
    *p2 = Container(20, 180, 200, 200)
     Button(-25, 10, 100, 30, "Button")
    CloseList()
    
    *b=Button(10,430, 200, 30, "change parent", #__Button_Toggle)
    
    i = 1
    SetParent(*w, *p2)
    
    ForEach GetChildrens(Root())
      Debug  GetChildrens(Root())\class +" - "+ GetChildrens(Root())\text\string
    Next
    
            
    Bind(#PB_All, @events_widgets())
   
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP