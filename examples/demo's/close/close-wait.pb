
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure OpenMessage( title.s, Text.s, flags = 0, parentID = 0)
     ; ProcedureReturn Message(title, Text, flags, parentID )
     ProcedureReturn MessageRequester(title, Text, flags, parentID );
   EndProcedure

   Procedure CallBack( )
      Select WidgetEvent( )
         Case #__event_close
            Debug "  do close - [" + EventWidget( )\class +"]"
            
            If EventWindow( ) = 2 
;                If #PB_MessageRequester_Yes = OpenMessage( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
                    ProcedureReturn #PB_All
;                Else
;                   ProcedureReturn #False
;                EndIf
            EndIf
            ProcedureReturn #True
             
         Case #__event_free
            Debug "    do free - [" + EventWidget( )\class +"]"
            
            ;             ;\\ to send not free
           ; ProcedureReturn #True
           ; ProcedureReturn #False
            
      EndSelect
   EndProcedure
   
   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_0_root" )
   Button(10,10,200,50,"Button_0")
   SetClass(widget( ), "Button_0" )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_1_root" )
   Button(10,10,200,50,"Button_1")
   SetClass(widget( ), "Button_1" )
   
   ;\\
   Open(2, 400, 200, 300, 200, "window_2 (main)", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_2_root" )
   Button(10,10,200,50,"Button_2")
   SetClass(widget( ), "Button_2" )
   
   
;    
;    ;\\
;    ForEach roots( )
;       Debug roots( )\class
;    Next
;    
;    ;   Debug ""
;    ;   Define canvas, window
;    ;   ForEach roots( )
;    ;      Debug roots( )\class
;    ;      canvas = roots( )\canvas\gadget
;    ;      window = roots( )\canvas\window
;    ;      
;    ;      DeleteMapElement(roots( ))
;    ;      FreeGadget( canvas )
;    ;      CloseWindow( window )
;    ;      
;    ;      ResetMap(roots( ))
;    ;   Next
;    ;   
;    ;   If Not MapSize(roots( ))
;    ;     Debug "0"
;    ;     End
;    ;   EndIf
;    ;   
   
   Bind( #PB_All, @CallBack( ) )
   
   ;\\
   ; Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 21
; FirstLine = 3
; Folding = -
; EnableXP