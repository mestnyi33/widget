
IncludePath "../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global.i gEvent, gQuit
   Global *butt
   
   Procedure events_1( )
      Debug "procedure "+ #PB_Compiler_Procedure +"( "+ EventString( WidgetEvent( ) ) +" )"
      
      If WidgetEvent( ) = #__event_MouseLeave
         ProcedureReturn #PB_Ignore
      EndIf
   EndProcedure
   
   Procedure events_2( )
      Debug "procedure "+ #PB_Compiler_Procedure +"( "+ EventString( WidgetEvent( ) ) +" )"
      
      If WidgetEvent( ) = #__event_MouseEnter
         ProcedureReturn #PB_Ignore
      EndIf
   EndProcedure
   
   Procedure events_root( )
      If Not is_root_(EventWidget( ))
         Debug "procedure "+ #PB_Compiler_Procedure +"( "+ EventString( WidgetEvent( ) ) +" )"
      EndIf
   EndProcedure
   
   Procedure Window_0( )
      If Open(0, 0, 0, 480, 180, "Демонстрация очередь привязки событий", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
         
         *butt = Button(50, 50, 380, 70, "Наведите курсор мыши, чтобы увидеть") 
         
         Bind( *butt, @events_1( ), #__event_MouseEnter )
         Bind( *butt, @events_1( ), #__event_MouseLeave )
         Bind( *butt, @events_1( ), #__event_Down )
         
         Bind( *butt, @events_2( ), #__event_MouseEnter )
         Bind( *butt, @events_2( ), #__event_MouseLeave )
         Bind( *butt, @events_2( ), #__event_Down )
         
         Bind( #PB_All, @events_root( ), #__event_MouseEnter )
         Bind( #PB_All, @events_root( ), #__event_MouseLeave )
         Bind( #PB_All, @events_root( ), #__event_Down )
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
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 31
; FirstLine = 10
; Folding = --
; EnableXP
; DPIAware