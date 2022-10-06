;XIncludeFile "../../../-widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 
Uselib(widget)
;Macro widget( ) : enumwidget( ) : EndMacro

Global i, *w._s_widget, *p1,*p2._s_widget, *ch

Procedure events_widgets()
  Select WidgetEventType()
    Case #PB_EventType_LeftClick
      If i 
        SetParent(*w, *p1)
      Else
        SetParent(*w, *p2)
      EndIf
      
      Debug ""+GetParent(*w) +" "+ *w +" "+ GetParent(*ch) +" "+  Y(*ch) +" "+  Y(*ch, 3)
      
      i!1
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
  If Open(OpenWindow(#PB_Any, 150, 110, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu)): bind(-1,-1)
    *p2 = Container(20, 180, 200, 200)
    Button(10,20, 200, 30, "butt", #__Button_Toggle)
    CloseList()
  EndIf
  
  If Open(OpenWindow(#PB_Any, 0, 0, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)): bind(-1,-1)
    *p1 = Container(10, 10, 200, 200)
    Button(10,20, 200, 30, "butt", #__Button_Toggle)
    *w = Container(10, 10, 100, 100)
    *ch = Button(-25, 10, 100, 20, "Button")
    CloseList()
    CloseList()
    
    Button(10,430, 200, 30, "change parent", #__Button_Toggle)
    
    i = 1
    SetParent(*w, *p2)
    ;*w\root = *p2\root
    
    ForEach widget()
      If widget() = *w
        ;widget()\root = *p2\root
      EndIf
      
      Debug  ""+widget()\root +" "+ *p2\root +" - "+ widget()\text\string
    Next
            
    Bind(root(), @events_widgets())
   
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP