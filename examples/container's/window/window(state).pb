XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_event_repost = 1
   
   Procedure CallBack( )
      Select WidgetEvent( )
         Case #__event_Close
            Debug "[disable] - (close event)"
            ProcedureReturn #False
            
         Case #__event_Maximize
            Debug "[maximize] - " + EventWidget( )\class
            ProcedureReturn #True
         Case #__event_Minimize
            Debug "[minimize] - " + EventWidget( )\class
            ProcedureReturn #True
         Case #__event_Restore
            Debug "[restore] - " + EventWidget( )\class 
            ProcedureReturn #True
            
         Case #__event_LeftClick
            Select GetText( EventWidget( ))
               Case "window_root_minimize", "window_0_minimize", "window_1_minimize", "window_2_minimize"
                  If GetState( EventWidget( )\window ) = #PB_Window_Minimize
                     SetState( EventWidget( )\window, #PB_Window_Normal )
                  Else
                     SetState( EventWidget( )\window, #PB_Window_Minimize )
                  EndIf
                  
               Case "window_root_maximize", "window_0_maximize", "window_1_maximize", "window_2_maximize"
                  If GetState( EventWidget( )\window ) = #PB_Window_Maximize
                     SetState( EventWidget( )\window, #PB_Window_Normal )
                  Else
                     SetState( EventWidget( )\window, #PB_Window_Maximize )
                  EndIf
                  
            EndSelect
            
      EndSelect
   EndProcedure
   
   If Open(0, 0, 0, 800, 600, " set (minimize & maximize - state) and disable (close - state) ", #PB_Window_SystemMenu |
                                                                                              #PB_Window_SizeGadget |
                                                                                              #PB_Window_MinimizeGadget |
                                                                                              #PB_Window_MaximizeGadget | 
                                                                                              #PB_Window_ScreenCentered )
      
      a_init( root())
      
      Window( 0, 0, 0, 0, "window_root", #__flag_autosize |
                                        #PB_Window_SystemMenu |
                                        #PB_Window_SizeGadget |
                                        #PB_Window_MinimizeGadget |
                                        #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_root" )
      Button(10,10,200,50,"window_root_maximize")
      SetClass(widget( ), "window_root_maximize" )
      Button(10,65,200,50,"window_root_minimize")
      SetClass(widget( ), "window_root_minimize" )
   
      
      ;\\
      Window( 250, 50, 250, 150, "window_0", #PB_Window_SystemMenu |
                                            #PB_Window_MinimizeGadget |
                                            #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_0" )
      Button(10,10,200,50,"window_0_maximize")
      SetClass(widget( ), "window_0_maximize" )
      Button(10,65,200,50,"window_0_minimize")
      SetClass(widget( ), "window_0_minimize" )
      
      ;\\
      Window( 350, 200, 250, 150, "window_1", #PB_Window_SystemMenu |
                                              #PB_Window_MinimizeGadget |
                                              #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_1" )
      Button(10,10,200,50,"window_1_maximize")
      SetClass(widget( ), "window_1_maximize" )
      Button(10,65,200,50,"window_1_minimize")
      SetClass(widget( ), "window_1_minimize" )
      
      ;\\
      Window( 450, 350, 250, 150, "window_2", #PB_Window_SystemMenu |
                                              #PB_Window_MinimizeGadget |
                                              #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_2" )
      Button(10,10,200,50,"window_2_maximize")
      SetClass(widget( ), "window_2_maximize" )
      Button(10,65,200,50,"window_2_minimize")
      SetClass(widget( ), "window_2_minimize" )
      
      WaitClose( @CallBack( ))
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 51
; FirstLine = 31
; Folding = --
; EnableXP
; DPIAware