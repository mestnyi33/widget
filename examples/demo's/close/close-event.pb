
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   test_delete = 1
   
   Declare CallBack( )
   
   Procedure OpenMessage( title.s, Text.s, flags = 0, parentID = 0)
     ProcedureReturn Message(title, Text, flags, parentID )
     ; ProcedureReturn MessageRequester(title, Text, flags, parentID );
   EndProcedure

   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_ScreenCentered |
                                       #PB_Window_SystemMenu |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_0_root" ) : SetBackColor( root( ), $FFB3FDFF )
   Button(10,10,200,50,"button_0_close") : SetClass(widget( ), GetText(widget( )) )
   Button(10,70,200,50,"button_1_close") : SetClass(widget( ), GetText(widget( )) )
   Button(10,130,200,50,"button_2_close") : SetClass(widget( ), GetText(widget( )) )
   
   
   
   
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
               Case "button_0_close"
                  Free( window )
                  
               Case "button_1_close"
                  Post( window, #__event_Close )
               
               Case "button_2_close"
                  Free( #PB_All )
                  
            EndSelect
            
         Case #__event_close
            Debug "  do close - [" + EventWidget( )\class +"]"
            
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
            Debug "    do free - [" + EventWidget( )\class +"]" 
            
            ;\\ to send not free
            ProcedureReturn #False
            
      EndSelect
      
      ProcedureReturn #True
   EndProcedure
   
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 57
; FirstLine = 38
; Folding = --
; EnableXP
; DPIAware