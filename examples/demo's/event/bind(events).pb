
IncludePath "../../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global.i gEvent, gQuit
   Global *butt0, *butt1
   
   Procedure events_roots( )
      If WidgetEvent( ) <> #__event_MouseMove
         Debug "  "+ EventWidget( )\index +" - widget event - "+ WidgetEvent( ) +" item - "+ WidgetEventItem( ) ;;+ " event - " + WidgetEvent()
      EndIf
   EndProcedure
   
   Procedure events_deactive( )
      Unbind(*butt0, @events_roots())
      SetText(*butt0, "un-bind-button-events" )
      
      Unbind(*butt1, @events_roots())
      SetText(*butt1, "un-binds-button-events" )
   EndProcedure
   
   Procedure Window_0( )
      If Open(0, 0, 0, 480, 180, "Demo binded events for the test-button", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
         
         *butt0 = Button(50, 50, 280, 35, "bind-button-events") 
         Bind( *butt0, @events_roots( ) )
         
         *butt1 = Button(50, 50+45, 280, 35, "binds-button-events") 
         Bind( *butt1, @events_roots( ), #__event_Change )
         Bind( *butt1, @events_roots( ), #__event_Down )
         Bind( *butt1, @events_roots( ), #__event_DragStart )
         Bind( *butt1, @events_roots( ), #__event_Focus )
         Bind( *butt1, @events_roots( ), #__event_Input )
         Bind( *butt1, @events_roots( ), #__event_KeyDown )
         Bind( *butt1, @events_roots( ), #__event_KeyUp )
         Bind( *butt1, @events_roots( ), #__event_LeftDown )
         Bind( *butt1, @events_roots( ), #__event_LeftUp )
         Bind( *butt1, @events_roots( ), #__event_LeftClick )
         Bind( *butt1, @events_roots( ), #__event_Left2Click )
         Bind( *butt1, @events_roots( ), #__event_LostFocus )
         Bind( *butt1, @events_roots( ), #__event_MiddleDown )
         Bind( *butt1, @events_roots( ), #__event_MiddleUp )
         Bind( *butt1, @events_roots( ), #__event_MouseEnter )
         Bind( *butt1, @events_roots( ), #__event_MouseLeave )
         Bind( *butt1, @events_roots( ), #__event_MouseMove )
         Bind( *butt1, @events_roots( ), #__event_MouseWheel )
         Bind( *butt1, @events_roots( ), #__event_Resize )
         Bind( *butt1, @events_roots( ), #__event_RightDown )
         Bind( *butt1, @events_roots( ), #__event_RightUp )
         Bind( *butt1, @events_roots( ), #__event_RightClick )
         Bind( *butt1, @events_roots( ), #__event_Right2Click )
         Bind( *butt1, @events_roots( ), #__event_StatusChange )
         Bind( *butt1, @events_roots( ), #__event_Up )
         
         Define *butt = Button(350, 50, 80, 80, "un-bind")
         Bind( *butt, @events_deactive( ), #__event_LeftClick )
         
      EndIf
   EndProcedure
   
   Window_0( )
   
   Repeat
      gEvent = WaitWindowEvent( )
      
      Select gEvent
         Case #PB_Event_CloseWindow
            gQuit = #True
      EndSelect
      
   Until gQuit
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 67
; FirstLine = 24
; Folding = --
; EnableXP
; DPIAware