
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Declare CallBack( )
   
   Procedure OpenMessage( title.s, Text.s, flags = 0, parentID = 0)
     ; ProcedureReturn Message(title, Text, flags, parentID )
     ProcedureReturn MessageRequester(title, Text, flags, parentID );
   EndProcedure

   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_0_root" )
   Button(10,10,200,50,"Button_0_close")
   SetClass(widget( ), "Button_0_close" )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_1_root" )
   Button(10,10,200,50,"Button_1_close")
   SetClass(widget( ), "Button_1_close" )
   
   ;\\
   Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_2_root" )
   Button(10,10,200,50,"Button_2_close")
   SetClass(widget( ), "Button_2_close" )
   
   
   Procedure buttonEvent( )
      If #PB_MessageRequester_Yes = MessageRequester( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
         
         PostCloseCanvasWindow( EventWindow( ) )
         
      EndIf
   EndProcedure
   ButtonGadget(1, 10,70,200,50, "Button_2_close")
   BindGadgetEvent(1, @buttonEvent( ))
   
   ;\\
   Bind( #PB_All, @CallBack( ) )
   WaitClose( )
   
   ;\\
   Procedure CallBack( )
      Select WidgetEvent( )
         Case #__event_leftclick
            Select GetText( EventWidget( ))
               Case "Button_0_close"
                  If #PB_MessageRequester_Yes = OpenMessage( "message", "Close a "+GetWindowTitle( EventWindow( ) )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
                     Free( EventWidget( ) )
                  EndIf
                  
               Case "Button_1_close"
                  PostClose( EventWidget( ) )
               
               Case "Button_2_close"
                  If #PB_MessageRequester_Yes = OpenMessage( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info | #__message_ScreenCentered )
                     
                     ;PostCloseCanvasWindow( EventWindow( ) )
                     PostClose( EventWidget( ) )
                     
                  EndIf
                  
            EndSelect
            
         Case #__event_close
            Debug "close - event " + EventWidget( )\class +" --- "+ GetWindowTitle( EventWindow( ) )
            
            ;\\ demo main window
            If EventWindow( ) = 2
               If #PB_MessageRequester_Yes = OpenMessage( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
                  ProcedureReturn #PB_All
               Else
                  ProcedureReturn 1
               EndIf
               
            ElseIf EventWindow( ) = 0
               If #PB_MessageRequester_Yes = OpenMessage( "message", "Close a "+GetWindowTitle( EventWindow( ) )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
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
; CursorPosition = 75
; FirstLine = 81
; Folding = ---
; EnableXP