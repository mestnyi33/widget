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
  If OpenRoot(0, 150, 110, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu)
    *p2 = ContainerWidget(20, 180, 200, 200) : SetWidgetClass( widget( ), "CONT2" )
    CloseWidgetList()
  EndIf
  
  If OpenRoot(1, 0, 0, 222, 470, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    *p1 = ContainerWidget(10, 10, 200, 200) : SetWidgetClass( widget( ), "CONT1" )
    *w = ContainerWidget(10, 10, 100, 100) : SetWidgetClass( widget( ), "CHILD" )
    *ch = ButtonWidget(-25, 10, 100, 20, "Button")
    CloseWidgetList()
    CloseWidgetList()
    
    Define change = ButtonWidget(10,430, 200, 30, "change parent") : SetWidgetClass( widget( ), "change parent" );, #__flag_ButtonToggle)
    
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
            
    BindWidgetEvent(change, @events_widgets())
    
    WaitCloseRoot( )
    ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 42
; FirstLine = 38
; Folding = --
; EnableXP
; DPIAware