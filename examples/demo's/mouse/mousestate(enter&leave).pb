; #__from_mouse_state = 1

XIncludeFile "../../../widgets.pbi" 
UseWidgets( )

Declare EventsHandler( )

Global.l colorback = colors::*this\blue\fore,
       colorframe = colors::*this\blue\frame, 
       colorback1 = $ff00ff00,
       colorframe1 = $ff0000ff

;\\
Procedure EventsHandler( )
   Protected repaint
   
   Select WidgetEvent( )
      Case #__event_MouseEnter, ;#__event_MouseMove,
           #__event_MouseLeave
         
         If EventWidget( ) <> root( )
            If EventWidget( )\enter 
               If EventWidget( )\color\frame <> colorframe1 
                  EventWidget( )\color\frame = colorframe1
                  repaint = 1 
               EndIf
               If EventWidget( )\color\back <> colorback1 
                  EventWidget( )\color\back = colorback1
                  repaint = 1 
               EndIf
               
               If repaint
                  Debug "" + GetData( EventWidget( ) ) + " change frame&back color"
               EndIf
               
            Else 
               If EventWidget( )\color\back = colorback1
                  EventWidget( )\color\back = colorback
                  repaint = 1
               EndIf
               If EventWidget( )\color\frame = colorframe1 
                  EventWidget( )\color\frame = colorframe
                  repaint = 1 
               EndIf
               
               If repaint
                  Debug "" + GetData( EventWidget( ) ) + " return frame&back color"
               EndIf
               
            EndIf
         EndIf
         
   EndSelect
   
   If repaint            
      
      ; ReDraw( EventWidget( )\root )
   EndIf
EndProcedure

;\\
Open( 0, 0, 0, 260, 260, "enter&leave demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
;a_init( root( ) )

;\\
Define *w._S_WIDGET = ScrollArea( 30, 30, 200, 200, 300,300,1, #__flag_BorderFlat )
SetData( *w, 1 )
SetData( *w\scroll\v, -1 )
SetData( *w\scroll\h, -2 )

SetData( Container( 70, 10, 70, 200, #__Flag_NoGadgets|#__flag_BorderFlat ), 2 ) 
SetData( Container( 40, 20, 200, 200, #__flag_BorderFlat ), 3 )
SetData( Container( 20, 20, 200, 200, #__flag_BorderFlat ), 4 )

SetData( Container( 5, 30, 200, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 5 ) 
SetData( Container( 5, 45, 200, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 6 ) 
SetData( Container( 5, 60, 200, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 7 ) 

Define w1 = Container( 0,0,0,0, #__Flag_NoGadgets|#__flag_BorderFlat )
Define w2 = Container( 0,0,0,0, #__Flag_NoGadgets|#__flag_BorderFlat )
SetData( w1, 101 )
SetData( w2, 102 )
SetData( Splitter( 5, 80, 200, 50, w1, w2, #PB_Splitter_Vertical|#__flag_BorderFlat ), 8 ) 

CloseList( )
CloseList( )
SetData( Container( 10, 45, 70, 200, #__flag_BorderFlat ), 11 ) 
SetData( Container( 10, 10, 70, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 12 ) 
SetData( Container( 10, 20, 70, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 13 ) 
SetData( Container( 10, 30, 170, 130, #__Flag_NoGadgets|#__flag_BorderFlat ), 14 ) 
SetData( Container( 10, 45, 70, 200, #__flag_BorderFlat ), 11 ) 
SetData( Container( 10, 5, 70, 200, #__flag_BorderFlat ), 11 ) 
SetData( Container( 10, 5, 70, 200, #__flag_BorderFlat ), 11 ) 
SetData( Container( 10, 10, 70, 30, #__Flag_NoGadgets|#__flag_BorderFlat ), 12 ) 
CloseList( )
CloseList( )
CloseList( )
CloseList( )

;\\
Bind( #PB_All, @EventsHandler( ), #__event_MouseEnter )
Bind( #PB_All, @EventsHandler( ), #__event_MouseMove )
Bind( #PB_All, @EventsHandler( ), #__event_MouseLeave )

;\\
WaitClose( )

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 17
; FirstLine = 14
; Folding = --
; EnableXP
; DPIAware