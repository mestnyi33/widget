IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(Widget)
   
   Global *test._s_widget
   
   Procedure events_1()
      Debug " "+Str(GetIndex( EventWidget( ) ))+ " - 1event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (widget)"
   EndProcedure
   
   Procedure events_2()
      Debug " "+Str(GetIndex( EventWidget( ) ))+ " - 2event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (widget)"
   EndProcedure
   
   
   If OpenWindow(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      If Open(0, 10,10, 480, 480)
         Window(80, 100, 300, 280, "Window_2")
         
         
         *test = Tree(10,  10, 280, 170)
         AddItem( *test, -1, "item-0" )
         AddItem( *test, -1, "item-1" )
         AddItem( *test, -1, "item-2" )
         AddItem( *test, -1, "item-3" )
         ;
         Button(10, 190, 135, 80, "Bind")
         Button(155, 190, 135, 80, "Unbind")
         
         ; post all default events
         ;Bind(id, @events_widgets())
         
         ; post this events
         Bind(*test, @events_1(), #__event_MouseEnter)
         Bind(*test, @events_2(), #__event_MouseLeave)
         ;
         Bind(*test, @events_1(), #__event_LeftDown)
         Bind(*test, @events_2(), #__event_LeftDown)
         
;          Bind(*test, @events_1(), #__event_LeftUp)
;          Bind(*test, @events_2(), #__event_LeftUp)
         
         Bind(*test, @events_1(), #__event_LeftUp, 1)
         Bind(*test, @events_2(), #__event_LeftUp, 2)
         
      EndIf
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 44
; FirstLine = 17
; Folding = -
; EnableXP