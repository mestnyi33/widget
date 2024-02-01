XIncludeFile "../../../widgets.pbi" 
Uselib(widget)
;Macro widget( ) : enumwidget( ) : EndMacro

Global i, *w._s_widget, *p1,*p2._s_widget, *ch, *root1._s_widget, *root2._s_widget


Procedure show_DEBUG( )
   Define line.s
   ;\\ 
   Debug "---->>"
   ForEach __widgets( )
      If __widgets( )\root = *root1
         line = "  ";+ __widgets( )\class +" "
         
         If __widgets( )\before\widget
            line + __widgets( )\before\widget\class +" <<  "    ;  +"_"+__widgets( )\before\widget\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + __widgets( )\class ; __widgets( )\text\string
         
         If __widgets( )\after\widget
            line +"  >> "+ __widgets( )\after\widget\class ;+"_"+__widgets( )\after\widget\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      EndIf
   Next
   Debug "<<----"
   
   ;\\ 
   Debug "---->>"
   ForEach __widgets( )
      If __widgets( )\root = *root2
         line = "  ";+ __widgets( )\class +" "
         
         If __widgets( )\before\widget
            line + __widgets( )\before\widget\class +" <<  "    ;  +"_"+__widgets( )\before\widget\text\string
         Else
            line + "-------- <<  " 
         EndIf
         
         line + __widgets( )\class ; __widgets( )\text\string
         
         If __widgets( )\after\widget
            line +"  >> "+ __widgets( )\after\widget\class ;+"_"+__widgets( )\after\widget\text\string
         Else
            line + "  >> --------" 
         EndIf
         
         Debug line
      EndIf
   Next
   Debug "<<----"
EndProcedure

Procedure events_widgets()
   Select WidgetEventType()
      Case #__event_LeftClick
         If i 
            SetParent(*w, *p1)
         Else
            SetParent(*w, *p2)
         EndIf
         
         show_DEBUG( )
         i!1
   EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(1, 150, 110, 222, 470, "ROOT1", #PB_Window_SystemMenu) : SetClass(widget( ), "ROOT1" )
   *root1 = root( )
   *p2 = Container(20, 180, 200, 200) : SetClass(widget( ), "CONT2" ) 
   Button(10,20, 200, 30, "CONT2_but1", #__Button_Toggle) : SetClass(widget( ), "CONT2_but1" )
   CloseList()
EndIf

If Open(2, 0, 0, 222, 470, "ROOT2", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) : SetClass(widget( ), "ROOT2" )
   *root2 = root( )
   *p1 = Container(10, 10, 200, 200) : SetClass(widget( ), "CONT1" ) 
   Button(10,20, 200, 30, "CONT1_but1", #__Button_Toggle) : SetClass(widget( ), "CONT1_but1" )
   *w = Container(10, 10, 100, 100) : SetClass(widget( ), "CHILD" )
   *ch = Button(-25, 10, 100, 40, "CHILD_but1") : SetClass(widget( ), "CHILD_but1" )
   CloseList()
   CloseList()
   
   Button(10,430, 200, 30, "change parent", #__Button_Toggle) : SetClass(widget( ), "change_parent" )
   
   SetParent(*w, *p2)
   SetParent(*w, *p1)
   
   show_DEBUG( )
   
   WaitEvent( @events_widgets() )
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 94
; FirstLine = 61
; Folding = --
; EnableXP