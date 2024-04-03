XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Procedure CallBack( )
      Select WidgetEventType( )
         Case #__event_Focus
            Debug "active - event " + EventWidget( )\class
            
         Case #__event_LostFocus
            Debug "deactive - event " + EventWidget( )\class
            
      EndSelect
   EndProcedure
   
   If Open(0, 0, 0, 800, 600, " focus demo ", #PB_Window_SystemMenu |
                                              #PB_Window_ScreenCentered )
      
      ;\\
      Window( 30, 30, 300, 200, "window_0", #PB_Window_SystemMenu |
                                            #PB_Window_MaximizeGadget |
                                            #PB_Window_MinimizeGadget )
      
      SetClass(widget( ), "window_0" ) : SetClass(widget( ), "window_0_container_1" )
      Container( 30,30,240,140 )
      Button(10,10,200,50,"window_0_button_1")
      SetClass(widget( ), "window_0_button_1" )
      Button(10,65,200,50,"window_0_button_2")
      SetClass(widget( ), "window_0_button_2" )
      CloseList( )
      
      ;\\
      Window( 230, 130, 300, 200, "window_1", #PB_Window_SystemMenu |
                                              #PB_Window_MaximizeGadget |
                                              #PB_Window_MinimizeGadget )
      
      SetClass(widget( ), "window_1" )
      Container( 30,30,240,140 ) : SetClass(widget( ), "window_1_container_1" )
      Button(10,10,200,50,"window_1_button_1")
      SetClass(widget( ), "window_1_button_1" )
      Button(10,65,200,50,"window_1_button_2")
      SetClass(widget( ), "window_1_button_2" )
      CloseList( )
      
      ;\\
      Window( 430, 230, 300, 200, "window_2", #PB_Window_SystemMenu |
                                              #PB_Window_MaximizeGadget |
                                              #PB_Window_MinimizeGadget )
      
      SetClass(widget( ), "window_2" )
      Container( 30,30,240,140 ) : SetClass(widget( ), "window_2_container_1" )
      Button(10,10,200,50,"window_2_button_1")
      SetClass(widget( ), "window_2_button_1" )
      Button(10,65,200,50,"window_2_button_2")
      SetClass(widget( ), "window_2_button_2" )
      CloseList( )
      
      WaitEvent( @CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 25
; FirstLine = 10
; Folding = -
; EnableXP