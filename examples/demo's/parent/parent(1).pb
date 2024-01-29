XIncludeFile "../../../widgets.pbi" 
Uselib(widget)
;Macro widget( ) : enumwidget( ) : EndMacro

Global i, *w._s_widget, *p1,*p2._s_widget, *ch

Procedure events_widgets()
  Select WidgetEventType()
    Case #__event_LeftClick
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
  If Open(0, 150, 110, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu)
    *p2 = Container(20, 180, 200, 200)
    CloseList()
  EndIf
  
  If Open(1, 0, 0, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *p1 = Container(10, 10, 200, 200)
    *w = Container(10, 10, 100, 100)
    *ch = Button(-25, 10, 100, 20, "Button")
    CloseList()
    CloseList()
    
    Define change = Button(10,430, 200, 30, "change parent");, #__Button_Toggle)
    
    i = 1
    SetParent(*w, *p2)
    *w\root = *p2\root
    
    ForEach __widgets( )
      If __widgets( ) = *w
        __widgets( )\root = *p2\root
      EndIf
      
      Debug  ""+__widgets( )\root +" "+ *p2\root +" - "+ __widgets( )\text\string
    Next
            
    Bind(change, @events_widgets())
    
    WaitClose( )
    ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 34
; FirstLine = 14
; Folding = --
; EnableXP