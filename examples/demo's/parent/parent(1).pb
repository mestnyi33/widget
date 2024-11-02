XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Global i, *w._s_widget, *p1,*p2._s_widget, *ch

 Procedure Show_DEBUG( )
      Define line.s
      ;\\
      Debug "---->>"
      ForEach widgets( )
         ;Debug widgets( )\class
         line = "  "
         
         If widgets( )\before\widget
            line + widgets( )\before\widget\class +" <<  "    ;  +"_"+widgets( )\before\widget\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + widgets( )\class ; widgets( )\text\string
         
         If widgets( )\after\widget
            line +"  >> "+ widgets( )\after\widget\class ;+"_"+widgets( )\after\widget\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      Next
      Debug "<<----"
   EndProcedure
   

Procedure events_widgets()
  Select WidgetEvent()
    Case #__event_LeftClick
      If i 
        SetParent(*w, *p1)
      Else
        SetParent(*w, *p2)
      EndIf
      
      Debug ""+GetParent(*w) +" "+ *w +" "+ GetParent(*ch) +" "+  WidgetY(*ch) +" "+  WidgetY(*ch, 3)
      
      Show_DEBUG( )
      i!1
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
  If Open(0, 150, 110, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu)
    *p2 = Container(20, 180, 200, 200) : SetClass( widget( ), "CONT2" )
    CloseList()
  EndIf
  
  If Open(1, 0, 0, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *p1 = Container(10, 10, 200, 200) : SetClass( widget( ), "CONT1" )
    *w = Container(10, 10, 100, 100) : SetClass( widget( ), "CHILD" )
    *ch = Button(-25, 10, 100, 20, "Button")
    CloseList()
    CloseList()
    
    Define change = Button(10,430, 200, 30, "change parent") : SetClass( widget( ), "change parent" );, #__Button_Toggle)
    
    Show_DEBUG( )
    i = 1
    SetParent(*w, *p2)
    ;*w\root = *p2\root
    Show_DEBUG( )
    
;     ForEach widgets( )
;       If widgets( ) = *w
;         widgets( )\root = *p2\root
;       EndIf
;       
;       Debug  ""+widgets( )\root +" "+ *p2\root +" - "+ widgets( )\text\string
;     Next
            
    Bind(change, @events_widgets())
    
    WaitClose( )
    ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 75
; FirstLine = 55
; Folding = --
; EnableXP
; DPIAware