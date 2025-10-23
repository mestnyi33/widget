XIncludeFile "../../../widgets.pbi" 


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_event_repost = 1
   test_resize = 1
   
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
               Case "window_root_minimize"
                  If GetState( EventWidget( )\window ) = #PB_Window_Minimize
                     SetState( EventWidget( )\window, #PB_Window_Normal )
                  Else
                     SetState( EventWidget( )\window, #PB_Window_Minimize )
                  EndIf
                  
               Case "window_root_maximize"
                  If GetState( EventWidget( )\window ) = #PB_Window_Maximize
                     SetState( EventWidget( )\window, #PB_Window_Normal )
                  Else
                     SetState( EventWidget( )\window, #PB_Window_Maximize )
                  EndIf
                  
            EndSelect
      EndSelect
   EndProcedure
   
   ; Open(0, 0, 0, 600, 400, " set (minimize & maximize - state) and disable (close - state) ", #PB_Window_SystemMenu ) 
   Open(0, 0, 0, 600, 400, " set (minimize & maximize - state) and disable (close - state) ", #PB_Window_SystemMenu | #PB_Window_SizeGadget )
   ; Open(0, 0, 0, 600, 400, " set (minimize & maximize - state) and disable (close - state) ", #PB_Window_BorderLess )
   ; Open(0, 0, 0, 600, 400, " set (minimize & maximize - state) and disable (close - state) ", #PB_Window_BorderLess | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget )
   ; Open(0, 0, 0, 600, 400, " set (minimize & maximize - state) and disable (close - state) ", #PB_Window_SystemMenu | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget )
   
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
;    Button(#PB_Ignore,#PB_Ignore,200,50,"window_root_close")
;    SetClass(widget( ), "window_root_close" )
;    
;    ;SetAlign(widget( ), #__align_right|#__align_bottom)
;    ;SetAlign(widget( ), #__align_auto, 0,0,-10,-10) : ResizeWindow(root()\canvas\window, #PB_Ignore,#PB_Ignore,801,#PB_Ignore) ; bug
   
   Bind( #PB_All, @CallBack( ))
   
   ; Repeat : Until WaitWindowEvent(1) = #PB_Event_CloseWindow
   WaitClose( )
   
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 47
; FirstLine = 34
; Folding = --
; EnableXP
; DPIAware