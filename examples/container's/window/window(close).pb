
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Procedure CallBack( )
    Select WidgetEvent( )
      Case #__event_leftclick
        Select GetWidgetText( EventWidget())
          Case "Button_0_close"
            If #PB_MessageRequester_Yes = MessageWidget( "message", "Close a "+GetTitle( EventWidget( )\window )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
              Close( EventWidget( )\window )
            EndIf
            
          Case "Button_1_close"
            ; Close( EventWindow( )\window )
            ; PostEvent( #PB_Event_CloseWindow, EventWidget( )\root\canvas\window, #PB_Default )
             
             ;Close( EventWidget( )\window )
             PostWidgetEvent( EventWidget( )\window, #__event_Close )
            
          Case "Button_2_close"
            If #PB_MessageRequester_Yes = MessageWidget( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
              Close( #PB_All )
            EndIf
            
        EndSelect
        
      Case #__event_close
        ;Debug "close - event " + EventWidget( )\class ;+" --- "+ GetTitle( EventWidget( ) ) +" "+ GetTypeCount( EventWidget( )\window ) 
        
        ;\\ demo main window
        If GetTitle( EventWidget( ) ) = "window_2"
           If #PB_MessageRequester_Yes = MessageWidget( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
              ProcedureReturn #PB_All
           Else
              ProcedureReturn 1
           EndIf
           
        ElseIf GetTitle( EventWidget( ) ) = "window_0"
           If #PB_MessageRequester_Yes = MessageWidget( "message", "Close a "+GetTitle( EventWidget( ) )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
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
  
  If OpenRoot(0, 0, 0, 800, 600, "window", #PB_Window_SystemMenu |
                                         #PB_Window_ScreenCentered )
     ;\\
     WindowWidget( 30, 30, 300, 200, "window_0", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
     
     SetWidgetClass(widget( ), "window_0" )
     ButtonWidget(10,10,200,50,"Button_0_close")
     SetWidgetClass(widget( ), "Button_0_close" )
     
     ;\\
     WindowWidget( 230, 130, 300, 200, "window_1", #PB_Window_SystemMenu |
                                             #PB_Window_SizeGadget |
                                             #PB_Window_MinimizeGadget |
                                             #PB_Window_MaximizeGadget )
     
     SetWidgetClass(widget( ), "window_1" )
     ButtonWidget(10,10,200,50,"Button_1_close")
     SetWidgetClass(widget( ), "Button_1_close" )
     
     ;\\
     WindowWidget( 430, 230, 300, 200, "window_2", #PB_Window_SystemMenu |
                                             #PB_Window_SizeGadget |
                                             #PB_Window_MinimizeGadget |
                                             #PB_Window_MaximizeGadget )
     
     SetWidgetClass(widget( ), "window_2" )
     ButtonWidget(10,10,200,50,"Button_2_close")
     SetWidgetClass(widget( ), "Button_2_close" )
     
     WaitEvent( #PB_All, @CallBack( ) )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 10
; FirstLine = 6
; Folding = --
; EnableXP
; DPIAware