
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Global title$
  
  ;\\
  Procedure CallBack( )
    ; Debug ""+EventString(WidgetEvent( )) +" "+ Root( )\class +" "+ EventWidget( )\root\class +" "+ WidgetEvent( )
    
    Select WidgetEvent( )
      Case #__event_LeftClick
        Select GetText( EventWidget( ) )
          Case "window_2_butt_1"
            Message( "message", "test WaitQuit ( ) and PostQuit ( )", #__message_ScreenCentered )
            
        EndSelect
        
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
  
 ;\\
  title$ = "window_0"
  Open(0, 0, 0, 300, 200, title$, #PB_Window_SystemMenu |
                                      #PB_Window_SizeGadget |
                                      #PB_Window_MinimizeGadget |
                                      #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), title$+"_root" )
  SetClass(Container( 10,10,240,140 ), title$+"_container" )
  SetClass(Button(10,10,200,50,title$+"_butt_1"), title$+"_butt_1" )
  SetClass(Button(10,65,200,50,title$+"_butt_2"), title$+"_butt_2" )
  
  ;\\
  title$ = "window_1"
  Open(1, 200, 100, 300, 200, title$, #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), title$+"_root" )
  SetClass(Container( 10,10,240,140 ), title$+"_container" )
  SetClass(Button(10,10,200,50,title$+"_butt_1"), title$+"_butt_1" )
  SetClass(Button(10,65,200,50,title$+"_butt_2"), title$+"_butt_2" )
  
  ;\\
  title$ = "window_2"
  Open(2, 400, 200, 300, 200, title$, #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  SetClass(Root( ), title$+"_root" )
  SetClass(Container( 10,10,240,140 ), title$+"_container" )
  SetClass(Button(10,10,200,50,title$+"_butt_1"), title$+"_butt_1" )
  SetClass(Button(10,65,200,50,title$+"_butt_2"), title$+"_butt_2" )
  
  ;\\
  WaitClose( @CallBack( ))
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 18
; Folding = -
; EnableXP