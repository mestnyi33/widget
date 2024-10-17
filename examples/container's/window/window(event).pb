IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseLib(widget)
   
   Procedure CallBack( )
      Protected result = 0
      If result
         Protected text$ = "disable"
      EndIf
            
      Select WidgetEvent( )
         Case #__event_Create
            Debug ""
            Debug text$ + " create - event " + EventWidget( )\class
            
         Case #__event_Focus
            Debug text$ + " focus - event " + EventWidget( )\class
            
         Case #__event_LostFocus
            Debug text$ + " lostfocus - event " + EventWidget( )\class
            
         Case #__event_Maximize
            Debug text$ + " maximize - event " + EventWidget( )\class
            
         Case #__event_Minimize
            Debug text$ + " minimize - event " + EventWidget( )\class
            
         Case #__event_Restore
            Debug text$ + " restore - event " + EventWidget( )\class 
            
         Case #__event_Close
            Debug text$ + " close - event " + EventWidget( )\class 
            
         Case #__event_Resize
            Debug text$ + " resize - event " + EventWidget( )\class +"( "+ EventWidget( )\x +" "+ EventWidget( )\y +" "+ EventWidget( )\width +" "+ EventWidget( )\height +" ) "; + EventWidget( )\root\canvas\gadget
            
         Case #__event_Free
            Debug text$ + " free - event " + EventWidget( )\class 
            
      EndSelect
      
      ProcedureReturn result
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
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 14
; FirstLine = 10
; Folding = -
; EnableXP