
XIncludeFile "../../../widgets.pbi" 
; ; 

EnableExplicit
UseWidgets( )

Define vertical = 0
Global._s_WIDGET *g1, *g2, *progress1,*progress2,*progress3

; progress( x.l, y.l, width.l, height.l, Min.l, Max.l, flag.q = 0, round.l = 0 )
Define min = - 3
Define event = #__event_LeftDown;Up;Click

Procedure button_events( )
   Protected state = GetState( *progress2 )
   
   Select EventWidget( )
      Case *g1
         state - 1
      Case *g2
         state + 1
   EndSelect
   
   If SetState( *progress2, state )
;       Debug ""+
;             *progress2\bar\button[1]\disable +" "+ 
;             *progress2\bar\button[2]\disable
   EndIf
EndProcedure

Procedure change_events( )
   SetWindowTitle( EventWindow(), "stste ["+Str(GetState( *progress2 ))+"]" )
   Disable( *g1, *progress2\bar\button[1]\disable )
   Disable( *g2, *progress2\bar\button[2]\disable )
EndProcedure

If vertical
   ;\\ vertical
   If Open(0, 0, 0, 210, 350, "vertical", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *progress1 = Progress(20, 50, 50, 250,  0, 30, #PB_ProgressBar_Vertical|#__flag_Invert)
      
      *g1=Button(90, 10, 30, 30, "") : SetRound( *g1, 15 ) : Bind( *g1, @button_events( ), event)
      *progress2 = Progress(80, 50, 50, 250,  min, 0, #PB_ProgressBar_Vertical) : Bind( *progress2, @change_events( ), #__event_Change)
      *g2=Button(90, 310, 30, 30, "") : SetRound( *g2, 15 ) : Bind( *g2, @button_events( ), event)
      
      *progress3 = Progress(140, 50, 50, 250,  0, 30, #PB_ProgressBar_Vertical, 30)
      
      Debug " -setstate- "
      SetState(*progress1, 5)
      SetState(*progress2, 0)
      SetState(*progress3, 5)
      
      WaitClose( )
   EndIf
Else
   
   ;\\ horizontal
   If Open(0, 0, 0, 350, 210, "horizontal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *progress1 = Progress(50, 20, 250, 50,  0, 30)
      
      *g1=Button(10, 90, 30, 30, "") : SetRound( *g1, 15 ) : Bind( *g1, @button_events( ), event)
      *progress2 = Progress(50, 80, 250, 50,  min, 0) : Bind( *progress2, @change_events( ), #__event_Change)
      *g2=Button(310, 90, 30, 30, "") : SetRound( *g2, 15 ) : Bind( *g2, @button_events( ), event)
      
      *progress3 = Progress(50, 140, 250, 50,  0, 30, #__flag_Invert)
      
      Debug " -setstate- "
      SetState(*progress1, 5)
      SetState(*progress2, 0)
      SetState(*progress3, 5)
      
      WaitClose( )
   EndIf
EndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 71
; FirstLine = 39
; Folding = --
; EnableXP