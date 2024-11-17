XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Global i, *CHILD._s_widget, *CONT2,*CONT1._s_widget, *root1._s_widget, *root2._s_widget


Procedure show_DEBUG( )
   Define line.s
   ;\\ 
   Debug "---->>"
   ForEach widgets( )
      If widgets( )\root = *root1
         line = "  ";+ widgets( )\class +" "
         
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
      EndIf
   Next
   Debug "<<----"
   
   ;\\ 
   Debug "---->>"
   ForEach widgets( )
      If widgets( )\root = *root2
         line = "  ";+ widgets( )\class +" "
         
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
      EndIf
   Next
   Debug "<<----"
EndProcedure

Procedure events_widgets()
   Select WidgetEvent()
      Case #__event_LeftClick
         If i 
            SetParent(*CHILD, *CONT2)
         Else
            SetParent(*CHILD, *CONT1)
         EndIf
         
         show_DEBUG( )
         i!1
   EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If OpenRootWidget(1, 150, 110, 222, 470, "ROOT1", #PB_Window_SystemMenu) : SetWidgetClass(widget( ), "ROOT1" )
   *root1 = root( )
   *CONT1 = ContainerWidget(20, 180, 200, 200) : SetWidgetClass(widget( ), "CONT2" ) 
   ButtonWidget(10,20, 200, 30, "CONT2_but1", #__flag_ButtonToggle) : SetWidgetClass(widget( ), "CONT2_but1" )
   CloseWidgetList()
EndIf

If OpenRootWidget(2, 0, 0, 222, 470, "ROOT2", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) : SetWidgetClass(widget( ), "ROOT2" )
   *root2 = root( )
   *CONT2 = ContainerWidget(10, 10, 200, 200) : SetWidgetClass(widget( ), "CONT1" ) 
   ButtonWidget(10,20, 200, 30, "CONT1_but1", #__flag_ButtonToggle) : SetWidgetClass(widget( ), "CONT1_but1" )
   *CHILD = ContainerWidget(10, 10, 100, 100) : SetWidgetClass(widget( ), "CHILD" )
   ButtonWidget(-25, 10, 100, 40, "CHILD_but1") : SetWidgetClass(widget( ), "CHILD_but1" )
   CloseWidgetList()
   CloseWidgetList()
   
   ButtonWidget(10,430, 200, 30, "change parent", #__flag_ButtonToggle) : SetWidgetClass(widget( ), "change_parent" )
;    
    SetParent(*CHILD, *CONT1)
    SetParent(*CHILD, *CONT2)
   
   show_DEBUG( )
   
   WaitEvent( @events_widgets() )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 48
; FirstLine = 27
; Folding = ---
; EnableXP
; DPIAware