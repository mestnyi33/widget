XIncludeFile "../../../widgetsDPI.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  #__color_state_selected = 2
  
Procedure events_progress_gadgets()
  ;ClearDebugOutput()
  ;Debug ""+EventType()+ " - " +#PB_Compiler_Procedure+ " - " +EventGadget() +" state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
     ; SetState(ID(EventGadget()), GetGadgetState(EventGadget()))
      ; Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_progress_widgets()
  ;ClearDebugOutput()
  ;Debug ""+WidgetEvent( )+ " - " +#PB_Compiler_Procedure+ " - " +Str(IDWidget(EventWidget( ))) + " state - "+ GetState(EventWidget( )) ; 
  
  Select WidgetEvent( )
    Case #__Event_Change
     ; SetGadgetState(IDWidget(EventWidget( )), GetState(EventWidget( )))
      ; Debug  Str(IDWidget(EventWidget( )))+" - widget change " + GetState(EventWidget( ))
  EndSelect
EndProcedure

Procedure events_track_gadgets()
  ;ClearDebugOutput()
 ;; Debug ""+EventType()+ " - " +#PB_Compiler_Procedure+ " - " +EventGadget() +" state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
      SetState(ID(EventGadget()), GetGadgetState(EventGadget()))
      SetGadgetState(EventGadget()-3, GetGadgetState(EventGadget()))
      ; Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_track_widgets()
  ;ClearDebugOutput()
 ;; Debug ""+WidgetEvent( )+ " - " +#PB_Compiler_Procedure+ " - " +Str(IDWidget(EventWidget( ))) + " state - "+ GetState(EventWidget( )) ; 
  
  Select WidgetEvent( )
    Case #__Event_Change
      SetGadgetState(IDWidget(EventWidget( )), GetState(EventWidget( )))
      SetState(ID(IDWidget(EventWidget( ))-3), GetState(EventWidget( )))
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(0, 0, 0, 330+330, 180, "Progress", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;\\
  ProgressBarGadget(0,  10, 30, 250,  30, 0, 100)
  SetGadgetState   (0, 50)   ;  set 1st progressbar (ID = 0) to 50 of 100
  
  ;\\
  ProgressBarGadget(1,  10, 110, 250,  30, 0, 200, #PB_ProgressBar_Smooth)
  SetGadgetState   (1, 50)   ;  set 2nd progressbar (ID = 1) to 50 of 200
  SetGadgetColor(1, #PB_Gadget_BackColor, $00FFFF)
  SetGadgetColor(1, #PB_Gadget_FrontColor, $FFFFFF)
      
  ;\\
  ProgressBarGadget(2, 270, 10,  30, 140, 0, 300, #PB_ProgressBar_Vertical)
  SetGadgetState   (2, 100)   ; set 3rd progressbar (ID = 2) to 100 of 300
  
  TrackBarGadget    (3, 10, 60, 250,  20, 0,100)
  SetGadgetState    (3, 50)   ;  set 1st progressbar (ID = 0) to 50 of 100
  TrackBarGadget    (4, 10, 140, 250,  20, 0, 200)
  SetGadgetState    (4, 50)   ;  set 2nd progressbar (ID = 1) to 50 of 200
  TrackBarGadget    (5, 301,10, 20,  140, 0, 300, #PB_TrackBar_Vertical)
  SetGadgetState    (5, 100)   ; set 3rd progressbar (ID = 2) to 100 of 300
  
  TextGadget       (6,  10, 10, 250,  20, "ProgressBar Standard  (50/100)", #PB_Text_Center)
  TextGadget       (7,  10, 90, 250,  20, "ProgressBar Smooth  (50/200)", #PB_Text_Center)
  TextGadget       (8, 100,155, 200,  20, "ProgressBar Vertical  (100/300)", #PB_Text_Right)
  
  Define i
  For i = 0 To 2
    BindGadgetEvent(i, @events_progress_gadgets())
  Next
  For i = 3 To 5
    BindGadgetEvent(i, @events_track_gadgets())
  Next
  
  ;\\
  ProgressBarWidget(0,0,0,0, 0, 100, 0, 40)
  SetState(widget( ), 50)   ;  set 1st progressbar (ID = 0) to 50 of 100
  Resize(widget( ), 10+330, 30, 250,  30)
  
  ;\\
  ProgressBarWidget(10+330, 110, 250,  30, 0, 200, #PB_ProgressBar_Smooth, 17)
  SetState(widget( ), 50)   ;  set 2nd progressbar (ID = 1) to 50 of 200
  
  SetColor(widget( ), #__color_back, $ff00ff00)
  SetColor(widget( ), #__color_fore, $FFC1FFBC)
  
  SetColor(widget( ), #__Color_Fore,  $FFBCBFFF, #__color_state_selected)
  SetColor(widget( ), #__Color_Back,  $ff0000ff, #__color_state_selected)
  
  ; SetColor(widget( ), #__color_frame, $ff0000ff)
  ; SetColor(widget( ), #__Color_Frame,  $ffff0000, #__color_state_selected)
  
  
  ;\\
  ProgressBarWidget(270+330, 10,  30, 140, 0, 300, #PB_ProgressBar_Vertical)
  SetState(widget( ), 100)   ; set 3rd progressbar (ID = 2) to 100 of 300
  
  ;\\
  Track    (10+330, 60, 250,  20, 0,100)
  SetState(widget( ), 50)   ;  set 1st progressbar (ID = 0) to 50 of 100
  Track    (10+330, 140, 250,  20, 0, 200)
  SetState(widget( ), 50)   ;  set 2nd progressbar (ID = 1) to 50 of 200
  Track    (301+330,10, 20,  140, 0, 300, #PB_TrackBar_Vertical)
  SetState(widget( ), 100)   ; set 3rd progressbar (ID = 2) to 100 of 300
  
  Text    (10+330, 10, 250,  20, "ProgressBar Standard  (50/100)", #__flag_Textcenter)
  Text    (10+330, 90, 250,  20, "ProgressBar Smooth  (50/200)", #__flag_Textcenter)
  Text    (100+330,155, 200,  20, "ProgressBar Vertical  (100/300)", #__flag_Textright)
  
  ;Bind(#PB_All, @events_widgets())
  
  For i = 0 To 2
    Bind(ID(i), @events_progress_widgets())
  Next
  For i = 3 To 5
    Bind(ID(i), @events_track_widgets())
  Next
  
  WaitClose( )
EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 108
; FirstLine = 85
; Folding = --
; Optimizer
; EnableXP
; DPIAware