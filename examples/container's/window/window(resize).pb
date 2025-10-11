XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_event_repost = 1
   
   Procedure CallBack( )
      Select WidgetEvent( )
         Case #__event_Close
            Debug "disable (close - event)"
            ProcedureReturn #False
            
         Case #__event_Maximize
            Debug "maximize - event " + EventWidget( )\class
            ProcedureReturn #True
         Case #__event_Minimize
            Debug "minimize - event " + EventWidget( )\class
            ProcedureReturn #True
         Case #__event_Restore
            Debug "restore - event " + EventWidget( )\class 
            ProcedureReturn #True
            
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
                                                                                                 #PB_Window_SizeGadget |
                                                                                                 #PB_Window_MinimizeGadget |
                                                                                                 #PB_Window_MaximizeGadget | 
                                                                                                 #PB_Window_ScreenCentered )
      
      Window( 0, 0, 0, 0, "window_0", #__flag_autosize |
                                      #PB_Window_SystemMenu |
                                      #PB_Window_SizeGadget |
                                      #PB_Window_MinimizeGadget |
                                      #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_0" )
      Button(10,10,200,50,"window_0_maximize")
      SetClass(widget( ), "window_0_maximize" )
      Button(10,65,200,50,"window_0_minimize")
      SetClass(widget( ), "window_0_minimize" )
      
      
      Bind( #PB_All, @CallBack( ) )
      
      ; Repeat : Until WaitWindowEvent(1) = #PB_Event_CloseWindow
      WaitClose( )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 43
; FirstLine = 33
; Folding = --
; EnableXP