XIncludeFile "../../../widgetsDPI.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  
  #__color_state_selected = 2
  
Procedure events_progress_gadgets()
  ;ClearDebugOutput()
  ;Debug ""+EventType()+ " - " +#PB_Compiler_Procedure+ " - " +EventGadget() +" state - " +GetGadGetWidgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
     ; SetWidgetState(ID(EventGadget()), GetGadGetWidgetState(EventGadget()))
      ; Debug  ""+ EventGadget() +" - gadget change " + GetGadGetWidgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_progress_widgets()
  ;ClearDebugOutput()
  ;Debug ""+WidgetEvent( )+ " - " +#PB_Compiler_Procedure+ " - " +Str(GetIndex(EventWidget( ))) + " state - "+ GetWidgetState(EventWidget( )) ; 
  
  Select WidgetEvent( )
    Case #__Event_Change
     ; SetGadGetWidgetState(GetIndex(EventWidget( )), GetWidgetState(EventWidget( )))
      ; Debug  Str(GetIndex(EventWidget( )))+" - widget change " + GetWidgetState(EventWidget( ))
  EndSelect
EndProcedure

Procedure events_track_gadgets()
  ;ClearDebugOutput()
 ;; Debug ""+EventType()+ " - " +#PB_Compiler_Procedure+ " - " +EventGadget() +" state - " +GetGadGetWidgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
      SetWidgetState(ID(EventGadget()), GetGadGetWidgetState(EventGadget()))
      SetGadGetWidgetState(EventGadget()-3, GetGadGetWidgetState(EventGadget()))
      ; Debug  ""+ EventGadget() +" - gadget change " + GetGadGetWidgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_track_widgets()
  ;ClearDebugOutput()
 ;; Debug ""+WidgetEvent( )+ " - " +#PB_Compiler_Procedure+ " - " +Str(GetIndex(EventWidget( ))) + " state - "+ GetWidgetState(EventWidget( )) ; 
  
  Select WidgetEvent( )
    Case #__Event_Change
      SetGadGetWidgetState(GetIndex(EventWidget( )), GetWidgetState(EventWidget( )))
      SetWidgetState(ID(GetIndex(EventWidget( ))-3), GetWidgetState(EventWidget( )))
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If OpenRoot(0, 0, 0, 330+330, 180, "Progress", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;\\
  ProgressBarGadget(0,  10, 30, 250,  30, 0, 100)
  SetGadGetWidgetState   (0, 50)   ;  set 1st progressbar (ID = 0) to 50 of 100
  
  ;\\
  ProgressBarGadget(1,  10, 110, 250,  30, 0, 200, #PB_ProgressBar_Smooth)
  SetGadGetWidgetState   (1, 50)   ;  set 2nd progressbar (ID = 1) to 50 of 200
  SetGadGetWidgetColor(1, #PB_Gadget_BackColor, $00FFFF)
  SetGadGetWidgetColor(1, #PB_Gadget_FrontColor, $FFFFFF)
      
  ;\\
  ProgressBarGadget(2, 270, 10,  30, 140, 0, 300, #PB_ProgressBar_Vertical)
  SetGadGetWidgetState   (2, 100)   ; set 3rd progressbar (ID = 2) to 100 of 300
  
  TrackBarGadget    (3, 10, 60, 250,  20, 0,100)
  SetGadGetWidgetState    (3, 50)   ;  set 1st progressbar (ID = 0) to 50 of 100
  TrackBarGadget    (4, 10, 140, 250,  20, 0, 200)
  SetGadGetWidgetState    (4, 50)   ;  set 2nd progressbar (ID = 1) to 50 of 200
  TrackBarGadget    (5, 301,10, 20,  140, 0, 300, #PB_TrackBar_Vertical)
  SetGadGetWidgetState    (5, 100)   ; set 3rd progressbar (ID = 2) to 100 of 300
  
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
  SetWidgetState(widget( ), 50)   ;  set 1st progressbar (ID = 0) to 50 of 100
  ResizeWidget(widget( ), 10+330, 30, 250,  30)
  
  ;\\
  ProgressBarWidget(10+330, 110, 250,  30, 0, 200, #PB_ProgressBar_Smooth, 17)
  SetWidgetState(widget( ), 50)   ;  set 2nd progressbar (ID = 1) to 50 of 200
  
  SetWidgetColor(widget( ), #__color_back, $ff00ff00)
  SetWidgetColor(widget( ), #__color_fore, $FFC1FFBC)
  
  SetWidgetColor(widget( ), #__Color_Fore,  $FFBCBFFF, #__color_state_selected)
  SetWidgetColor(widget( ), #__Color_Back,  $ff0000ff, #__color_state_selected)
  
  ; SetWidgetColor(widget( ), #__color_frame, $ff0000ff)
  ; SetWidgetColor(widget( ), #__Color_Frame,  $ffff0000, #__color_state_selected)
  
  
  ;\\
  ProgressBarWidget(270+330, 10,  30, 140, 0, 300, #PB_ProgressBar_Vertical)
  SetWidgetState(widget( ), 100)   ; set 3rd progressbar (ID = 2) to 100 of 300
  
  ;\\
  Track    (10+330, 60, 250,  20, 0,100)
  SetWidgetState(widget( ), 50)   ;  set 1st progressbar (ID = 0) to 50 of 100
  Track    (10+330, 140, 250,  20, 0, 200)
  SetWidgetState(widget( ), 50)   ;  set 2nd progressbar (ID = 1) to 50 of 200
  Track    (301+330,10, 20,  140, 0, 300, #PB_TrackBar_Vertical)
  SetWidgetState(widget( ), 100)   ; set 3rd progressbar (ID = 2) to 100 of 300
  
  Text    (10+330, 10, 250,  20, "ProgressBar Standard  (50/100)", #__flag_Textcenter)
  Text    (10+330, 90, 250,  20, "ProgressBar Smooth  (50/200)", #__flag_Textcenter)
  Text    (100+330,155, 200,  20, "ProgressBar Vertical  (100/300)", #__flag_Textright)
  
  ;BindWidgetEvent(#PB_All, @events_widgets())
  
  For i = 0 To 2
    BindWidgetEvent(ID(i), @events_progress_widgets())
  Next
  For i = 3 To 5
    BindWidgetEvent(ID(i), @events_track_widgets())
  Next
  
  WaitCloseRoot( )
EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 108
; FirstLine = 85
; Folding = --
; Optimizer
; EnableXP
; DPIAware