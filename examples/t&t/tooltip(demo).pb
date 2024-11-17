IncludePath "../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure CallBack( )
      Static show
      
      Protected result = 0
      If result
         Protected text$ = "disable"
      EndIf
            
      Select WidgetEvent( )
         Case #__event_MouseLeave
            show = 0
            
         Case #__event_MouseEnter
         Case #__event_MouseMove
            If show = 0
               show = 1
               GadgetToolTip( GetCanvasGadget( EventWidget( ) ), EventWidget( )\class )
            EndIf
            
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
      
      SetWidgetClass(widget( ), "window_0" )
      ButtonWidget(10,10,200,50,"window_0_butt_1")
      SetWidgetClass(widget( ), "window_0_butt_1" )
      ButtonWidget(10,65,200,50,"window_0_butt_2")
      SetWidgetClass(widget( ), "window_0_butt_2" )
      
      ;\\
      Window( 230, 130, 300, 200, "window_1", #PB_Window_SystemMenu |
                                              #PB_Window_SizeGadget |
                                              #PB_Window_MinimizeGadget |
                                              #PB_Window_MaximizeGadget )
      
      SetWidgetClass(widget( ), "window_1" )
      ButtonWidget(10,10,200,50,"window_1_butt_1")
      SetWidgetClass(widget( ), "window_1_butt_1" )
      ButtonWidget(10,65,200,50,"window_1_butt_2")
      SetWidgetClass(widget( ), "window_1_butt_2" )
      
      ;\\
      Window( 430, 230, 300, 200, "window_2", #PB_Window_SystemMenu |
                                              #PB_Window_SizeGadget |
                                              #PB_Window_MinimizeGadget |
                                              #PB_Window_MaximizeGadget )
      
      SetWidgetClass(widget( ), "window_2" )
      ButtonWidget(10,10,200,50,"window_2_butt_1")
      SetWidgetClass(widget( ), "window_2_butt_1" )
      ButtonWidget(10,65,200,50,"window_2_butt_2")
      SetWidgetClass(widget( ), "window_2_butt_2" )
      
      WaitEvent( @CallBack( ) )
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 16
; FirstLine = 12
; Folding = --
; EnableXP