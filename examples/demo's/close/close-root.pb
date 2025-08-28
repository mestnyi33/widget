
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_delete = 1
   
   Declare CallBack( )
   
   Procedure OpenMessage( title.s, Text.s, flags = 0, parentID = 0)
     ProcedureReturn Message(title, Text, flags, parentID )
     ProcedureReturn MessageRequester(title, Text, flags, parentID );
   EndProcedure

   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_0_root" )
   SetBackColor( root( ), $FFB3FDFF )
   Button(10,10,200,50,"button_window_0_close")
   SetClass(widget( ), GetText(widget( )) )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_1_root" )
   SetBackColor( root( ), $FFB3FDFF )
   Button(10,10,200,50,"button_window_1_close")
   SetClass(widget( ), GetText(widget( )) )
   
   ;\\
   Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_2_root" )
   SetBackColor( root( ), $FFB3FDFF )
   Button(10,10,200,50,"button_window_all_close")
   SetClass(widget( ), GetText(widget( )) )
   
   
   Procedure buttonEvent( )
      If #PB_MessageRequester_Yes = MessageRequester( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
         
         Free( #PB_All )
                     
      EndIf
   EndProcedure
   ButtonGadget(1, 10,70,200,50, "window_all_close")
   BindGadgetEvent(1, @buttonEvent( ))
   
   ;\\
   Bind( #PB_All, @CallBack( ) )
   WaitClose( )
   
   ;\\
   Procedure CallBack( )
      Select WidgetEvent( )
         Case #__event_leftclick
            Select GetText( EventWidget( ))
               Case "button_window_0_close"
                  If #PB_MessageRequester_Yes = OpenMessage( "message", "Close a "+GetWindowTitle( EventWindow( ) )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
                     
                     Free( GetWindow(EventWidget( )) )
                     
                  EndIf
                  
               Case "button_window_1_close"
                  Post( GetWindow( EventWidget( ) ), #__event_Close )
               
               Case "button_window_all_close"
                  If #PB_MessageRequester_Yes = OpenMessage( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info | #__message_ScreenCentered )
                     
                     Free( #PB_All )
                     
                  EndIf
                  
            EndSelect
            
         Case #__event_close
            Debug "  [e-close] " + EventWidget( )\class +" --- "+ GetWindowTitle( EventWindow( ) )
            
            ;\\ demo main window
            If EventWindow( ) = 2
               If #PB_MessageRequester_Yes = OpenMessage( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
                  ProcedureReturn #PB_All ; all close
               Else
                  ProcedureReturn #False ; no close
               EndIf
               
            ElseIf EventWindow( ) = 0
               If #PB_MessageRequester_Yes = OpenMessage( "message", "Close a "+GetWindowTitle( EventWindow( ) )+"?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
                  ProcedureReturn #True ; current close 
               Else
                  ProcedureReturn #False ; no close
               EndIf
               
            ElseIf EventWindow( ) = 1
               ; CloseWindow( 1 )
               ; ProcedureReturn #True
            EndIf
           
         Case #__event_free
            Debug "  [e-free] " + EventWidget( )\class 
            
            ;\\ to send not free
            ; ProcedureReturn #False
            
      EndSelect
      
      ProcedureReturn #True
   EndProcedure
   
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 90
; FirstLine = 80
; Folding = ---
; EnableXP