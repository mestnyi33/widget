XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
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
            Select GetWidgetText( EventWidget( ))
               Case "window_0_minimize", "window_1_minimize", "window_2_minimize"
                  If GetWidgetState( EventWidget( )\window ) = #PB_Window_Minimize
                     SetWidgetState( EventWidget( )\window, #PB_Window_Normal )
                  Else
                     SetWidgetState( EventWidget( )\window, #PB_Window_Minimize )
                  EndIf
                  
               Case "window_0_maximize", "window_1_maximize", "window_2_maximize"
                  If GetWidgetState( EventWidget( )\window ) = #PB_Window_Maximize
                     SetWidgetState( EventWidget( )\window, #PB_Window_Normal )
                  Else
                     SetWidgetState( EventWidget( )\window, #PB_Window_Maximize )
                  EndIf
               
         EndSelect
            
      EndSelect
   EndProcedure
   
   If OpenRoot(0, 0, 0, 800, 600, " set (minimize & maximize - state) and disable (close - state) ", #PB_Window_SystemMenu |
                                                                                                 #PB_Window_SizeGadget |
                                                                                                 #PB_Window_MinimizeGadget |
                                                                                                 #PB_Window_MaximizeGadget | 
                                                                                                 #PB_Window_ScreenCentered )
   
; ;    If OpenRoot(0, 0, 0, 800, 600, " set (minimize & maximize - state) and disable (close - state) ", #PB_Window_BorderLess |
; ;                                                                                                  #PB_Window_SizeGadget |
; ;                                                                                                  #PB_Window_ScreenCentered )
; ;       
;      ; \\
;     If WindowWidget( 30, 30, 300, 200, "window_0", #PB_Window_SystemMenu |
;                                             #PB_Window_SizeGadget |
;                                             #PB_Window_MinimizeGadget |
;                                             #PB_Window_MaximizeGadget )
      
      WindowWidget( 0, 0, 0, 0, "window_0", #__flag_autosize |
                                            #PB_Window_SystemMenu |
                                            #PB_Window_SizeGadget |
                                            #PB_Window_MinimizeGadget |
                                            #PB_Window_MaximizeGadget )
      
      SetWidgetClass(widget( ), "window_0" )
      ButtonWidget(10,-10,200,50,"window_0_maximize")
      SetWidgetClass(widget( ), "window_0_maximize" )
      ButtonWidget(10,65,200,50,"window_0_minimize")
      SetWidgetClass(widget( ), "window_0_minimize" )
      
      
      WaitEvent( #PB_All, @CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 8
; FirstLine = 4
; Folding = --
; EnableXP