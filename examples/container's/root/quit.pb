; bug иногда когда вызывается мессадже пропадают событыя в нутри окна с котороговызвали мессадже пока не покинешь оено и не вернешся обратно
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  Declare CallBack( )
  
  ;\\
  OpenRootWidget(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                      #PB_Window_SizeGadget |
                                      #PB_Window_MinimizeGadget |
                                      #PB_Window_MaximizeGadget )
  
  SetWidgetClass(Root( ), "window_0_root" )
  ContainerWidget( 10,10,240,140 ) : SetWidgetClass(widget( ), "window_0_root_container" )
  ButtonWidget(10,10,200,50,"window_0_root_butt_1")
  SetWidgetClass(widget( ), "window_0_root_butt_1" )
  ButtonWidget(10,65,200,50,"window_0_root_butt_2")
  SetWidgetClass(widget( ), "window_0_root_butt_2" )
  
  ;\\
  OpenRootWidget(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetWidgetClass(Root( ), "window_1_root" )
  ContainerWidget( 10,10,240,140 ) : SetWidgetClass(widget( ), "window_1_root_container" )
  ButtonWidget(10,10,200,50,"window_1_root_butt_1")
  SetWidgetClass(widget( ), "window_1_root_butt_1" )
  ButtonWidget(10,65,200,50,"window_1_root_butt_2")
  SetWidgetClass(widget( ), "window_1_root_butt_2" )
  
  ;\\
  OpenRootWidget(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetWidgetClass(Root( ), "window_2_root" )
  ContainerWidget( 10,10,240,140 ) : SetWidgetClass(widget( ), "window_2_root_container" )
  ButtonWidget(10,10,200,50,"button_message")
  SetWidgetClass(widget( ), "button_message" )
  ButtonWidget(10,65,200,50,"window_2_root_butt_2")
  SetWidgetClass(widget( ), "window_2_root_butt_2" )
  
  ;\\
  BindWidgetEvent( #PB_All, @CallBack( ) )
  ; MessageWidget( "message", "test", #__message_ScreenCentered )
  
  ;\\
  WaitQuit( )
  ;WaitClose( )
  
  ;\\
  Procedure CallBack( )
    Select WidgetEvent( )
      Case #__event_Focus
        Debug "focus "+EventWidget( )\class
        
      Case #__event_LostFocus
        Debug "lostfocus "+EventWidget( )\class
        
      Case #__event_Repaint
        Debug "repaint " + EventWidget( )\class 
        ;ProcedureReturn 1
        
      Case #__event_LeftClick
        Select GetTextWidget( EventWidget( ) )
          Case "button_message"
            MessageWidget( "message", "test", #__message_ScreenCentered )
            
            ; WaitQuit( )
            
        EndSelect
        
      Default
        ; Debug ""+classfromevent(WidgetEvent( )) +" "+ Root( )\class +" "+ EventWidget( )\root\class +" "+ WidgetEvent( )
        
    EndSelect
  EndProcedure
  
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 80
; FirstLine = 56
; Folding = -
; EnableXP