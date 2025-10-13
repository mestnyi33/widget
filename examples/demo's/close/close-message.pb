
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
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_ScreenCentered |
                                       #PB_Window_SystemMenu |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_0_root" ) : SetBackColor( root( ), $FFB3FDFF )
   Button(10,10,200,50,"warning") : SetClass(widget( ), GetText(widget( )) )
   Button(10,70,200,50,"error") : SetClass(widget( ), GetText(widget( )) )
   Button(10,130,200,50,"info") : SetClass(widget( ), GetText(widget( )) )
   
   
   
   
   ;\\
   Bind( #PB_All, @CallBack( ) )
   WaitClose( )
   
   ;\\
   Procedure CallBack( )
      Protected widget = EventWidget( )
      Protected window = GetWindow( widget )
      
      Select WidgetEvent( )
         Case #__event_leftclick
            Select GetText( widget )
               Case "warning"
                  Message("message", "warning", #__message_YesNoCancel|#__message_Warning )
                  
               Case "error"
                  Message("message", "error", #__message_YesNo|#__message_Error)
               
               Case "info"
                  Message("message", "info", #__message_Ok|#__message_Info)
                  
            EndSelect
            
         Case #__event_close
            Debug "  [e-close] " + EventWidget( )\class +" --- "+ GetWindowTitle( EventWindow( ) )
            
            ;\\ demo main window
            If EventWindow( ) = 2
               ProcedureReturn #PB_All ; all close
               
            ElseIf EventWindow( ) = 0
               ProcedureReturn #True ; current close 
               
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
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 50
; FirstLine = 21
; Folding = --
; EnableXP