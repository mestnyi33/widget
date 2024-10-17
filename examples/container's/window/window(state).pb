XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Procedure CallBack( )
      Select WidgetEvent( )
         Case #__event_Close
            Debug "disable (close - event)"
            ProcedureReturn 1
            
         Case #__event_Maximize
            Debug "maximize - event " + EventWidget( )\class
            
         Case #__event_Minimize
            Debug "minimize - event " + EventWidget( )\class
            
         Case #__event_Restore
            Debug "restore - event " + EventWidget( )\class 
            
            
         Case #__event_LeftClick
            Select GetText( EventWidget( ))
               Case "window_0_minimize", "window_1_minimize", "window_2_minimize"
                  If GetState( EventWidget( )\window ) = #PB_Window_Minimize
                     SetState( EventWidget( )\window, #PB_Window_Normal )
                  Else
                     SetState( EventWidget( )\window, #PB_Window_Minimize )
                  EndIf
                  
               Case "window_0_maximize", "window_1_maximize", "window_2_maximize"
                  If GetState( EventWidget( )\window ) = #PB_Window_Maximize
                     SetState( EventWidget( )\window, #PB_Window_Normal )
                  Else
                     SetState( EventWidget( )\window, #PB_Window_Maximize )
                  EndIf
               
         EndSelect
            
      EndSelect
   EndProcedure
   
   If Open(0, 0, 0, 800, 600, " set (minimize & maximize - state) and disable (close - state) ", #PB_Window_SystemMenu |
                                                             #PB_Window_ScreenCentered )
      
      ;\\
      Window( 30, 30, 300, 200, "window_0", #PB_Window_SystemMenu |
                                            #PB_Window_MinimizeGadget |
                                            #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_0" )
      Button(10,10,200,50,"window_0_maximize")
      SetClass(widget( ), "window_0_maximize" )
      Button(10,65,200,50,"window_0_minimize")
      SetClass(widget( ), "window_0_minimize" )
      
      ;\\
      Window( 230, 130, 300, 200, "window_1", #PB_Window_SystemMenu |
                                              #PB_Window_MinimizeGadget |
                                              #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_1" )
      Button(10,10,200,50,"window_1_maximize")
      SetClass(widget( ), "window_1_maximize" )
      Button(10,65,200,50,"window_1_minimize")
      SetClass(widget( ), "window_1_minimize" )
      
      ;\\
      Window( 430, 230, 300, 200, "window_2", #PB_Window_SystemMenu |
                                              #PB_Window_MinimizeGadget |
                                              #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_2" )
      Button(10,10,200,50,"window_2_maximize")
      SetClass(widget( ), "window_2_maximize" )
      Button(10,65,200,50,"window_2_minimize")
      SetClass(widget( ), "window_2_minimize" )
      
      WaitEvent( @CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 8
; FirstLine = 4
; Folding = --
; EnableXP
; DPIAware