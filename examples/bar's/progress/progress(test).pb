XIncludeFile "../../../widgets.pbi"  

EnableExplicit
UseWidgets( )

Global progress_0, progress_1, track_1, track_0, track_3, track_2, Splitter_0, Splitter_1

Procedure events_widgets()
   Select WidgetEvent( )
      Case #__event_Change
         Select EventWidget( )
            Case track_1
               EventWidget( ) = progress_1
               EventWidget( )\round = GetState(track_1)
               EventWidget( )\bar\button[1]\round = EventWidget( )\round
               EventWidget( )\bar\button[2]\round = EventWidget( )\round
               
            Case track_0
               SetState(progress_1, GetState(track_0))
               
            Case track_3
               EventWidget( ) = progress_0
               EventWidget( )\round = GetState(track_3)
               EventWidget( )\bar\button[1]\round = EventWidget( )\round
               EventWidget( )\bar\button[2]\round = EventWidget( )\round
               
            Case track_2
               SetState(progress_0, GetState(track_2))
               
         EndSelect
   EndSelect
EndProcedure

If OpenRootWidget(0, 0, 0, 450+20, 290+20, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   SetWidgetColor( root(), #__Color_Back, $ff00ffff)
   
   progress_0 = ProgressBarWidget(0, 0, 0, 0, 0,100,0, 120) ; as they will be sized automatically
   progress_1 = ProgressBarWidget(0, 0, 0, 0, 0,100,#PB_ProgressBar_Vertical,120) ; as they will be sized automatically
   
   Splitter_0 = SplitterWidget(0, 0, 0, 0, progress_0, progress_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
   Splitter_1 = SplitterWidget(10, 10, 400, 250, 0, Splitter_0, #PB_Splitter_FirstFixed)
   
   track_0 = Track    (400+20, 10, 20,  250, 0,100, #PB_TrackBar_Vertical) 
   track_1 = Track    (400+20+20, 10, 20,  250, 0, 100, #PB_TrackBar_Vertical)
   
   track_2 = Track    (10, 260,  400, 20, 0, 100)
   track_3 = Track    (10, 280,  400, 20, 0, 100)
   
   BindWidgetEvent(track_1, @events_widgets())
   BindWidgetEvent(track_0, @events_widgets())
   
   BindWidgetEvent(track_3, @events_widgets())
   BindWidgetEvent(track_2, @events_widgets())
   
   SetState(track_0, 40)
   SetState(track_2, 40)
   
   SetState(track_1, 120)
   SetState(track_3, 120)
   
   SetState(Splitter_0, 269)
   WaitCloseRootWidget( )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 37
; FirstLine = 30
; Folding = -
; EnableXP