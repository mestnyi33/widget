
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
  ButtonWidget(10,10,200,50,"Button_0_close")
  SetWidgetClass(widget( ), "Button_0_close" )
  
  ;\\
  OpenRootWidget(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetWidgetClass(Root( ), "window_1_root" )
  ButtonWidget(10,10,200,50,"Button_1_close")
  SetWidgetClass(widget( ), "Button_1_close" )
  
  ;\\
  OpenRootWidget(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                          #PB_Window_SizeGadget |
                                          #PB_Window_MinimizeGadget |
                                          #PB_Window_MaximizeGadget )
  
  SetWidgetClass(Root( ), "window_2_root" )
  ButtonWidget(10,10,200,50,"Button_2_close")
  SetWidgetClass(widget( ), "Button_2_close" )
  
  
  Procedure buttonEvent( )
     If #PB_MessageRequester_Yes = MessageRequester( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
        Close( #PB_All )
     EndIf
  EndProcedure
  ButtonGadget(1, 10,70,200,50, "Button_2_close")
  BindGadgetEvent(1, @buttonEvent( ))
  
  ;\\
  WaitEvent( #PB_All, @CallBack( ) )
  
  ;\\
  Procedure CallBack( )
    Select WidgetEvent( )
      Case #__event_leftclick
        Select GetTextWidget( EventWidget())
          Case "Button_0_close"
            If #PB_MessageRequester_Yes = MessageWidget( "message", "Close a "+GetWindowTitle( EventWindow( ) )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
              Close( EventWindow( ) )
            EndIf
            
          Case "Button_1_close"
            ; Close( EventWindow( ) )
            ;Close( EventWidget( )\window )
            
            ;  PostWidgetEvent( EventWidget( )\window, #__event_Close )
            SendWidgetEvent( EventWidget( )\window, #__event_Close )
            ; PostEvent( #PB_Event_CloseWindow, EventWidget( )\root\canvas\window, #PB_Default )
            
          Case "Button_2_close"
            If #PB_MessageRequester_Yes = MessageWidget( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info | #__message_ScreenCentered )
              Close( #PB_All )
            EndIf
            
        EndSelect
        
      Case #__event_close
        Debug "close - event " + EventWidget( )\class +" --- "+ GetWindowTitle( EventWindow( ) )
        
        ;\\ demo main window
        If EventWindow( ) = 2
          If #PB_MessageRequester_Yes = MessageWidget( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
            ProcedureReturn #PB_All
          Else
            ProcedureReturn 1
          EndIf
          
        ElseIf EventWindow( ) = 0
          If #PB_MessageRequester_Yes = MessageWidget( "message", "Close a "+GetWindowTitle( EventWindow( ) )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
            ProcedureReturn 0
          Else
            ProcedureReturn 1
          EndIf
        EndIf
        
        
      Case #__event_free
        Debug "free - event " + EventWidget( )\class 
        
        ;             ;\\ to send not free
        ;                      ProcedureReturn 1
        
    EndSelect
  EndProcedure
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 54
; FirstLine = 50
; Folding = --
; EnableXP