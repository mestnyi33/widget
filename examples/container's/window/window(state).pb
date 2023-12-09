XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Procedure CallBack( )
      Select WidgetEventType( )
         Case #__event_Close
            Debug "disable (close - event)"
            ProcedureReturn 1
            
         Case #__event_Maximize
            Debug "maximize - event " + EventWidget( )\class
            
         Case #__event_Minimize
            Debug "minimize - event " + EventWidget( )\class
            
         Case #__event_Restore
            Debug "restore - event " + EventWidget( )\class 
            
      EndSelect
   EndProcedure
   
   If Open(0, 0, 0, 800, 600, " set (minimize & maximize - state) and disable (close - state) ", #PB_Window_SystemMenu |
                                                             #PB_Window_ScreenCentered )
      
      ;\\
      Window( 30, 30, 300, 200, "window_0", #PB_Window_SystemMenu |
                                            #PB_Window_MinimizeGadget |
                                            #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_0" )
      Button(10,10,200,50,"window_0_minimize")
      SetClass(widget( ), "window_0_minimize" )
      Button(10,65,200,50,"window_0_maximize")
      SetClass(widget( ), "window_0_maximize" )
      
      ;\\
      Window( 230, 130, 300, 200, "window_1", #PB_Window_SystemMenu |
                                              #PB_Window_MinimizeGadget |
                                              #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_1" )
      Button(10,10,200,50,"window_1_minimize")
      SetClass(widget( ), "window_1_minimize" )
      Button(10,65,200,50,"window_1_maximize")
      SetClass(widget( ), "window_1_maximize" )
      
      ;\\
      Window( 430, 230, 300, 200, "window_2", #PB_Window_SystemMenu |
                                              #PB_Window_MinimizeGadget |
                                              #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_2" )
      Button(10,10,200,50,"window_2_minimize")
      SetClass(widget( ), "window_2_minimize" )
      Button(10,65,200,50,"window_2_maximize")
      SetClass(widget( ), "window_2_maximize" )
      
      WaitEvent( #PB_All, @CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP