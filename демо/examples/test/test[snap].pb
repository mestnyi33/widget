IncludePath "../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_snap = 1
   
   Procedure EventsHandler( )
      Protected event = WidgetEvent( ) 
      Protected g = EventWidget( )
      
      If event = #__event_MouseMove
      EndIf
   EndProcedure
   
   If Open(0, 0, 0, 500, 500, "Тест Z-Order (Next[1])", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Define CONTAINER_1 = Container( 5, 5, 200, 200 )
      Define BUTTON_0 = Button( 10, 10, 180, 50, "B1 (Перекрыта)")
      Define BUTTON_1 = Button( 30, 30, 180, 50, "B2 (Сверху над B1)")
      
      Define BUTTON_2 = Button( 10, 150, 180, 50, "B3 (Свободна)") 
      CloseList( )
      
      WaitClose( @EventsHandler( ))
   EndIf
   
CompilerEndIf

; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 8
; Folding = -
; EnableXP
; DPIAware