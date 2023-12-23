; bug иногда когда вызывается мессадже пропадают событыя в нутри окна с котороговызвали мессадже пока не покинешь оено и не вернешся обратно
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)
  Declare CallBack( )
  
  ;\\
  Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                      #PB_Window_SizeGadget |
                                      #PB_Window_MinimizeGadget |
                                      #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), "window_0_root" )
  Container( 10,10,240,140 ) : SetClass(widget( ), "window_0_root_container" )
  Button(10,10,200,50,"window_0_root_butt_1")
  SetClass(widget( ), "window_0_root_butt_1" )
  Button(10,65,200,50,"window_0_root_butt_2")
  SetClass(widget( ), "window_0_root_butt_2" )
  
  ;\\
  Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), "window_1_root" )
  Container( 10,10,240,140 ) : SetClass(widget( ), "window_1_root_container" )
  Button(10,10,200,50,"window_1_root_butt_1")
  SetClass(widget( ), "window_1_root_butt_1" )
  Button(10,65,200,50,"window_1_root_butt_2")
  SetClass(widget( ), "window_1_root_butt_2" )
  
  ;\\
  Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), "window_2_root" )
  Container( 10,10,240,140 ) : SetClass(widget( ), "window_2_root_container" )
  Button(10,10,200,50,"button_message")
  SetClass(widget( ), "button_message" )
  Button(10,65,200,50,"window_2_root_butt_2")
  SetClass(widget( ), "window_2_root_butt_2" )
  
  ;\\
  Bind( #PB_All, @CallBack( ) )
  ; Message( "message", "test", #__message_ScreenCentered )
  
  ;\\
  ;WaitQuit( )
  WaitClose( )
  
  ;\\
  Procedure CallBack( )
    Select WidgetEventType( )
      Case #__event_Focus
        Debug "focus "+EventWidget( )\class
        
      Case #__event_LostFocus
        Debug "lostfocus "+EventWidget( )\class
        
      Case #__event_Repaint
        Debug "repaint " + EventWidget( )\class 
        ;ReDraw( EventWidget( ) )
        ;ProcedureReturn 1
        
      Case #__event_LeftClick
        Select GetText( EventWidget( ) )
          Case "button_message"
            Message( "message", "test", #__message_ScreenCentered )
            
            ; WaitQuit( )
            
        EndSelect
        
      Default
        ; Debug ""+classfromevent(WidgetEventType( )) +" "+ Root( )\class +" "+ EventWidget( )\root\class +" "+ WidgetEventType( )
        
    EndSelect
  EndProcedure
  
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -
; EnableXP