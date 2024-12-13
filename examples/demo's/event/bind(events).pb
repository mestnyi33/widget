IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global._s_widget *test, *bind, *unbind
   Global binded
   
   Procedure events_1()
      Debug " "+Str(Index( EventWidget( ) ))+ " - 1event - " +WidgetEvent()+ "  item - " +WidgetEventItem() +" (widget)"
   EndProcedure
   
   Procedure events_2()
      Debug " "+Str(Index( EventWidget( ) ))+ " - 2event - " +WidgetEvent()+ "  item - " +WidgetEventItem() +" (widget)"
   EndProcedure
   
   
   Procedure events_Bind()
      If binded = 0
         binded = 1
         ClearDebugOutput()
         Debug "binded"
         ; post this events
         Bind(*test, @events_1(), #__event_MouseEnter)
         Bind(*test, @events_2(), #__event_MouseLeave)
         ;
         Bind(*test, @events_1(), #__event_LeftDown)
         Bind(*test, @events_2(), #__event_LeftDown)
         
         Bind(*test, @events_1(), #__event_LeftUp, 1)
         Bind(*test, @events_2(), #__event_LeftUp, 2)
         
         Disable( *unbind, 0 )
         Disable( *bind, 1 )
      EndIf
   EndProcedure
   
   Procedure events_Unbind()
      If binded = 1
         binded = 0
         ClearDebugOutput()
         Debug "unbinded" 
         ; post this events
         Unbind(*test, @events_1(), #__event_MouseEnter)
         Unbind(*test, @events_2(), #__event_MouseLeave)
         ;
         Unbind(*test, @events_1(), #__event_LeftDown)
         Unbind(*test, @events_2(), #__event_LeftDown)
         
         Unbind(*test, @events_1(), #__event_LeftUp, 1)
         Unbind(*test, @events_2(), #__event_LeftUp, 2)
         
         
         Disable( *bind, 0 )
         Disable( *unbind, 1 )
         
      EndIf
   EndProcedure
   
   
   If OpenWindow(0, 0, 0, 500, 500, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      If Open(0, 100, 100, 300, 280)
         *test = Tree(10,  10, 280, 170)
         Define i
         For i = 0 To 12
            AddItem( *test, -1, "item-"+Str(i) )
         Next i
         ;
         *bind = Button(10, 190, 135, 80, "Bind (events)")
         *unbind = Button(155, 190, 135, 80, "Unbind (events)")
         Disable( *unbind, 1 )
         
         Bind(*unbind, @events_Unbind(), #__event_LeftClick)
         Bind(*bind, @events_Bind(), #__event_LeftClick)
      EndIf
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 16
; FirstLine = 12
; Folding = --
; EnableXP
; DPIAware