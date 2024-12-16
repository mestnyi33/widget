
IncludePath "../../../"
XIncludeFile "widgets.pbi"

Macro Message( title, Text, flag=0, parentID=0 )
   MessageRequester( title, Text, flag, parentID )
EndMacro

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  Procedure CallBack( )
    Select WidgetEvent( )
      Case #__event_leftclick
        Select GetText( EventWidget())
          Case "Button_0_close"
            If #PB_MessageRequester_Yes = Message( "message", "Close a "+GetTitle( EventWidget( )\window )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
              Close( GetWindow( EventWidget( ) ) )
            EndIf
            
          Case "Button_1_close"
            ; Close( GetWindow( EventWidget( ) ) )
            ; PostEvent( #PB_Event_CloseWindow, EventWidget( )\root\canvas\window, #PB_Default )
             
             ;Close( GetWindow( EventWidget( ) ) )
             Post( GetWindow( EventWidget( ) ), #__event_Close )
            
          Case "Button_2_close"
            If #PB_MessageRequester_Yes = Message( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
              Close( #PB_All )
            EndIf
            
        EndSelect
        
      Case #__event_close
        ;Debug "close - event " + EventWidget( )\class ;+" --- "+ GetTitle( EventWidget( ) ) +" "+ Type( EventWidget( )\window ) 
        
        ;\\ demo main window
        If GetTitle( EventWidget( ) ) = "window_2"
           If #PB_MessageRequester_Yes = Message( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
              ProcedureReturn #PB_All
           Else
              ProcedureReturn 1
           EndIf
           
        ElseIf GetTitle( EventWidget( ) ) = "window_0"
           If #PB_MessageRequester_Yes = Message( "message", "Close a "+GetTitle( EventWidget( ) )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
              ProcedureReturn 0
           Else
              ProcedureReturn 1
           EndIf
        EndIf
        
        
      Case #__event_free
        Debug "free - event " + GetClass( EventWidget( ) ) 
        
        ;             ;\\ to send not free
;                      ProcedureReturn 1
        
    EndSelect
  EndProcedure
  
  If Open(0, 0, 0, 800, 600, "window", #PB_Window_SystemMenu |
                                         #PB_Window_ScreenCentered )
     ;\\
     Window( 30, 30, 300, 200, "window_0", #PB_Window_SystemMenu )
     
     SetClass(widget( ), "window_0" )
     Button(10,10,200,50,"Button_0_close")
     SetClass(widget( ), "Button_0_close" )
     
     ;\\
     Window( 230, 130, 300, 200, "window_1", #PB_Window_SystemMenu )
     
     SetClass(widget( ), "window_1" )
     Button(10,10,200,50,"Button_1_close")
     SetClass(widget( ), "Button_1_close" )
     
     ;\\
     Window( 430, 230, 300, 200, "window_2", #PB_Window_SystemMenu )
     
     SetClass(widget( ), "window_2" )
     Button(10,10,200,50,"Button_2_close")
     SetClass(widget( ), "Button_2_close" )
     
     Bind( #PB_All, @CallBack( ) )
     WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 28
; FirstLine = 36
; Folding = --
; EnableXP
; DPIAware