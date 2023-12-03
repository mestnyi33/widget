
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)
  
  Procedure Close( window )
    If window = #PB_All
      ForEach Root( )
        If Free( Root( ) )
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            CocoaMessage(0, WindowID( Root( )\canvas\window ), "close")
          CompilerElse 
            CloseWindow( Root( )\canvas\window )
          CompilerEndIf
        EndIf
      Next  
    Else
      PushMapPosition( Root( ) )
      ForEach Root( )
        If Root( )\canvas\window = window
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
            CocoaMessage(0, WindowID( window ), "close")
          CompilerElse 
            CloseWindow( window )
          CompilerEndIf
        EndIf
      Next  
      PopMapPosition( Root( ) )
    EndIf
  EndProcedure
  
  Procedure CallBack( )
    Select WidgetEventType( )
      Case #__event_close
        Debug "close - event " + EventWidget( )\class +" --- "+ GetWindowTitle( EventWindow( ) )
        
        ;\\ demo main window
        If EventWindow( ) = 2
          If #PB_MessageRequester_Yes = MessageRequester( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
            ; Close( #PB_All )
            
            ProcedureReturn #PB_All
          Else
            ProcedureReturn 1
          EndIf
          
        ElseIf EventWindow( ) = 0
          If #PB_MessageRequester_Yes = MessageRequester( "message", "Close a "+GetWindowTitle( EventWindow( ) )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
            ProcedureReturn 0
          Else
            ProcedureReturn 1
          EndIf
        EndIf
        
        
      Case #__event_free
        Debug "free - event " + EventWidget( )\class 
        
        ;             ;\\ to send not free
        ;             ProcedureReturn 1
        
    EndSelect
  EndProcedure
  
  ;\\
  Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                      #PB_Window_SizeGadget |
                                      #PB_Window_MinimizeGadget |
                                      #PB_Window_MaximizeGadget )
  SetClass(Root( ), "window_0_root" )
  Button(10,10,200,50,"window_0_root_butt_1")
  SetClass(widget( ), "window_0_root_butt_1" )
  
  ;\\
  Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetClass(Root( ), "window_1_root" )
  Button(10,10,200,50,"window_1_root_butt_1")
  SetClass(widget( ), "window_1_root_butt_1" )
  
  ;\\
  Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  SetClass(Root( ), "window_2_root" )
  Button(10,10,200,50,"window_2_root_butt_1")
  SetClass(widget( ), "window_2_root_butt_1" )
  
  WaitEvent( #PB_All, @CallBack( ) )
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = ---
; EnableXP