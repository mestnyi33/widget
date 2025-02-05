
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  Declare CallBack( )
  
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
  Button(10,10,200,50,"window_2_root_butt_1")
  SetClass(widget( ), "window_2_root_butt_1" )
  Button(10,65,200,50,"window_2_root_butt_2")
  SetClass(widget( ), "window_2_root_butt_2" )
  
  ;\\
  WaitEvent( #PB_All, @CallBack( ) )
  
  ;\\
  Procedure CallBack( )
    ; Debug ""+classfromevent(WidgetEvent( )) +" "+ Root( )\class +" "+ EventWidget( )\root\class +" "+ WidgetEvent( )
    
    Select WidgetEvent( )
      Case #__event_LeftClick
        Select GetText( EventWidget( ) )
          Case "window_2_root_butt_1"
            Message( "message", "test WaitQuit( ) and PostQuit( )", #__message_ScreenCentered )
            
        EndSelect
        
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
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 57
; FirstLine = 53
; Folding = -
; EnableXP