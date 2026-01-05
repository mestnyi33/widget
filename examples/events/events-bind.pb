
IncludePath "../../"
XIncludeFile "widgets.pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global.i gEvent, gQuit
   Global *bind_active, *bind_deactive
   
   Procedure all_events( )
      If WidgetEvent( ) = #__event_MouseMove 
         ProcedureReturn 1
      EndIf
      Debug "  "+ EventWidget( )\index +" - "+ EventString( WidgetEvent( ) )
   EndProcedure
   
   Procedure click_events( )
      Select EventWidget( ) 
         Case *bind_active
            Debug "left click"
            
         Case *bind_deactive
            If GetState(*bind_deactive)
               Unbind(*bind_active, @all_events())
               SetText(*bind_deactive, "bind-all-events" )
            Else
               Bind(*bind_active, @all_events())
               SetText(*bind_deactive, "un-bind-all-events" )
            EndIf
      EndSelect
   EndProcedure
   
   If Open(0, 0, 0, 480, 180, "Demo binded events for the test-button", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      *bind_active = Button(50, 50, 80, 80, "") 
      Bind( *bind_active, @click_events( ), #__event_LeftClick )
      
      *bind_deactive = Button(150, 50, 280, 80, "bind-all-events", #PB_Button_Toggle )
      Bind( *bind_deactive, @click_events( ), #__event_LeftClick )
      
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 17
; FirstLine = 7
; Folding = --
; EnableXP
; DPIAware