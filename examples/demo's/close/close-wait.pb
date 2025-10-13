
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Procedure OpenMessage( title.s, Text.s, flags = 0, parentID = 0)
      ProcedureReturn #PB_MessageRequester_Yes
      ; ProcedureReturn Message(title, Text, flags, parentID )
      ProcedureReturn MessageRequester(title, Text, flags, parentID );
   EndProcedure
   
   Procedure CallBack( )
      Select WidgetEvent( )
         Case #__event_close
            Debug "  do close - [" + EventWidget( )\class +"]"
            
            If EventWindow( ) = 2 
               If #PB_MessageRequester_Yes = OpenMessage( "message", "Quit the program?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info )
                  ProcedureReturn #PB_All
               Else
                  ProcedureReturn #False
               EndIf
            EndIf
            ProcedureReturn #True
            
         Case #__event_free
            Debug "    do free - [" + EventWidget( )\class +"]"
            
;             ;\\ Uncomment to see deletions of buttons only
;             If #__type_button = EventWidget( )\type
;                ProcedureReturn #True
;             Else
;                If is_root_(EventWidget( ))
;                   ReDraw( EventWidget( )\root )
;                EndIf
;                ProcedureReturn #False
;             EndIf
            
            ProcedureReturn #True
      EndSelect
   EndProcedure
   
   ;\\
   Open(0, 0, 0, 300, 200, "window_0", #PB_Window_SystemMenu |
                                       #PB_Window_SizeGadget |
                                       #PB_Window_MinimizeGadget |
                                       #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_0_root" )
   Container( 10,10,240,140 ) : SetClass(widget( ), "window_0_cont_1" )
   Button(10,10,200,50,"window_0_butt_1")
   SetClass(widget( ), "window_0_butt_1" )
   Button(10,65,200,50,"window_0_butt_2")
   SetClass(widget( ), "window_0_butt_2" )
   
   ;\\
   Open(1, 200, 100, 300, 200, "window_1", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_1_root" )
   Container( 10,10,240,140 ) : SetClass(widget( ), "window_1_cont_1" )
   Button(10,10,200,50,"window_1_butt_1")
   SetClass(widget( ), "window_1_butt_1" )
   Button(10,65,200,50,"window_1_butt_2")
   SetClass(widget( ), "window_1_butt_2" )
   
   ;\\
   Open(2, 400, 200, 300, 200, "window_2", #PB_Window_SystemMenu |
                                           #PB_Window_SizeGadget |
                                           #PB_Window_MinimizeGadget |
                                           #PB_Window_MaximizeGadget )
   
   SetClass(root( ), "window_2_root" )
   Container( 10,10,240,140 ) : SetClass(widget( ), "window_2_cont_1" )
   Button(10,10,200,50,"button_2_butt_1")
   SetClass(widget( ), "button_2_butt_1" )
   Button(10,65,200,50,"window_2_butt_2")
   SetClass(widget( ), "window_2_butt_2" )
   
   
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
; CursorPosition = 40
; FirstLine = 21
; Folding = --
; EnableXP