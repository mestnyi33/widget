
XIncludeFile "../../../widgets.pbi" 
; ; 

EnableExplicit
UseWidgets( )

Define vertical = 0
Global._s_WIDGET *g1, *g2, *track1,*track2,*track3

; track( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )
Define min = - 3
Define event = #__event_Down;Click

Procedure button_events( )
   Protected state = GetState( *track2 )
   Debug "click " + MouseClick( )
   
   Select EventWidget( )
      Case *g1
         state - 1
      Case *g2
         state + 1
   EndSelect
   
   If SetState( *track2, state )
;       Debug ""+
;             *track2\bar\button[1]\disable +" "+ 
;             *track2\bar\button[2]\disable
   EndIf
EndProcedure

Procedure change_events( )
   SetWindowTitle( EventWindow(), "stste ["+Str(GetState( *track2 ))+"]" )
   Disable( *g1, *track2\bar\button[1]\disable )
   Disable( *g2, *track2\bar\button[2]\disable )
EndProcedure

If vertical
   ;\\ vertical
   If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *track1 = Track(20, 50, 50, 250,  0, 30, #PB_TrackBar_Vertical|#__flag_Invert)
      
      *g1=Button(90, 10, 30, 30, "") : SetRound( *g1, 15 ) : Bind( *g1, @button_events( ), event)
      *track2 = Track(80, 50, 50, 250,  min, 0, #PB_TrackBar_Vertical) : Bind( *track2, @change_events( ), #__event_Change)
      *g2=Button(90, 310, 30, 30, "") : SetRound( *g2, 15 ) : Bind( *g2, @button_events( ), event)
      
      *track3 = Track(140, 50, 50, 250,  0, 30, #PB_TrackBar_Vertical, 30)
      
      Debug " -setstate-v "
      SetState(*track1, 5)
      ;SetState(*track2, 0)
      SetState(*track3, 5)
      
      WaitClose( )
   EndIf
Else
   
   ;\\ horizontal
   If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *track1 = Track(50, 20, 250, 50,  0, 30)
      
      *g1=Button(10, 90, 30, 30, "") : SetRound( *g1, 15 ) : Bind( *g1, @button_events( ), event)
      *track2 = Track(50, 80, 250, 50,  min, 0) : Bind( *track2, @change_events( ), #__event_Change)
      *g2=Button(310, 90, 30, 30, "") : SetRound( *g2, 15 ) : Bind( *g2, @button_events( ), event)
      
      *track3 = Track(50, 140, 250, 50,  0, 30, #__flag_Invert)
      
      Debug " -setstate-h "
      SetState(*track1, 5)
      ;SetState(*track2, 0)
      SetState(*track3, 5)
      
      WaitClose( )
   EndIf
EndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 16
; FirstLine = 12
; Folding = --
; EnableXP
; DPIAware