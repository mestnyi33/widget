; bug иногда когда вызывается мессадже пропадают событыя в нутри окна с котороговызвали мессадже пока не покинешь оено и не вернешся обратно
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  Declare CallBack( )
  
  Procedure OpenMessage( title.s, Text.s, flags = 0, parentID = 0)
     ProcedureReturn Message(title, Text, flags|#__message_ScreenCentered, parentID )
     ProcedureReturn MessageRequester(title, Text, flags, parentID );
  EndProcedure

  ;\\
  Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                      #PB_Window_SizeGadget |
                                      #PB_Window_MinimizeGadget |
                                      #PB_Window_MaximizeGadget )
  
  SetClass(root( ), "window_0_root" )
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
  
  SetClass(root( ), "window_1_root" )
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
  
  SetClass(root( ), "window_2_root" )
  Container( 10,10,240,140 ) : SetClass(widget( ), "window_2_root_container" )
  Button(10,10,200,50,"button_message")
  SetClass(widget( ), "button_message" )
  Button(10,65,200,50,"window_2_root_butt_2")
  SetClass(widget( ), "window_2_root_butt_2" )
  
  ;\\
  Bind( #PB_All, @CallBack( ) )
  ; Message( "message", "test", #__message_ScreenCentered )
  
  ;\\
  WaitQuit( root( ) )
  ;WaitClose( )
  
  ;\\
  Procedure CallBack( )
    Select WidgetEvent( )
      Case #__event_Focus
        Debug "focus "+EventWidget( )\class
        
      Case #__event_LostFocus
        Debug "lostfocus "+EventWidget( )\class
        
      Case #__event_Draw
        Debug "draw " + EventWidget( )\class 
        ;ProcedureReturn 1
        
      Case #__event_LeftClick
        Select GetText( EventWidget( ) )
          Case "button_message"
            OpenMessage( "message", "test" )
            
            ; WaitQuit( )
            
        EndSelect
        
      Default
        ; Debug ""+classfromevent(WidgetEvent( )) +" "+ Root( )\class +" "+ EventWidget( )\root\class +" "+ WidgetEvent( )
        
    EndSelect
  EndProcedure
  
  
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 59
; FirstLine = 54
; Folding = -
; EnableXP