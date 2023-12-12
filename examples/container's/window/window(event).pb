IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Procedure CallBack( )
      Select WidgetEventType( )
         Case #__event_Create
            Debug "create - event " + EventWidget( )\class
           
         Case #__event_Focus
            Debug "focus - event " + EventWidget( )\class
            
         Case #__event_LostFocus
            Debug "lostfocus - event " + EventWidget( )\class
            
         Case #__event_Maximize
            Debug "maximize - event " + EventWidget( )\class
            
         Case #__event_Minimize
            Debug "minimize - event " + EventWidget( )\class
            
         Case #__event_Restore
            Debug "restore - event " + EventWidget( )\class 
            
         Case #__event_Close
            Debug "close - event " + EventWidget( )\class 
            
         Case #__event_Resize
            Debug "resize - event " + EventWidget( )\class +"( "+ EventWidget( )\x +" "+ EventWidget( )\y +" "+ EventWidget( )\width +" "+ EventWidget( )\height +" ) "; + EventWidget( )\root\canvas\gadget
            
         Case #__event_Free
            Debug "free - event " + EventWidget( )\class 
            
      EndSelect
      
     ; ProcedureReturn 1
   EndProcedure
   
   If Open(0, 0, 0, 800, 600, "window", #PB_Window_SystemMenu |
                                        #PB_Window_ScreenCentered )
      
      ;\\
      Window( 30, 30, 300, 200, "window_0", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_0" )
      Button(10,10,200,50,"window_0_butt_1")
      SetClass(widget( ), "window_0_butt_1" )
      Button(10,65,200,50,"window_0_butt_2")
      SetClass(widget( ), "window_0_butt_2" )
      
      ;\\
      Window( 230, 130, 300, 200, "window_1", #PB_Window_SystemMenu |
                                              #PB_Window_SizeGadget |
                                              #PB_Window_MinimizeGadget |
                                              #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_1" )
      Button(10,10,200,50,"window_1_butt_1")
      SetClass(widget( ), "window_1_butt_1" )
      Button(10,65,200,50,"window_1_butt_2")
      SetClass(widget( ), "window_1_butt_2" )
      
      ;\\
      Window( 430, 230, 300, 200, "window_2", #PB_Window_SystemMenu |
                                              #PB_Window_SizeGadget |
                                              #PB_Window_MinimizeGadget |
                                              #PB_Window_MaximizeGadget )
      
      SetClass(widget( ), "window_2" )
      Button(10,10,200,50,"window_2_butt_1")
      SetClass(widget( ), "window_2_butt_1" )
      Button(10,65,200,50,"window_2_butt_2")
      SetClass(widget( ), "window_2_butt_2" )
      
      WaitEvent( #PB_All, @CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 18
; FirstLine = 3
; Folding = -
; EnableXP