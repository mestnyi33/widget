XIncludeFile "../../../widgets.pbi" 

Uselib(widget)

; Procedure events_gadgets()
;   ClearDebugOutput()
;   ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
;   
;   Select EventType()
;     Case #PB_EventType_LeftClick
;       ;SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
;       Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
;   EndSelect
; EndProcedure
; 
; Procedure events_widgets()
;   ClearDebugOutput()
;   ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +this()\type+ "  state - " GetState(EventWidget( )) ; 
;   
;   Select WidgetEventType( )
;     Case #PB_EventType_Change
;       SetGadgetState(GetIndex(EventWidget( )), GetState(EventWidget( )))
;       Debug  Str(GetIndex(EventWidget( )))+" - widget change " + GetState(EventWidget( ))
;   EndSelect
; EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 500+500, 340, "disable - state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 500,0, 500);,140)
  ScrollBarGadget  (0,  10, 42+30*0, 250,  20, 30, 100, 0) : SetGadgetState   (0,  50)                                            ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (1,  10, 42+30*1, 250,  20, 30, 100, 50) ;: SetGadgetState   (1,  50)                                           ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (2,  10, 42+30*2, 250,  20, 30, 100, 50) : SetGadgetState   (2,  50)                                           ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (3,  10, 42+30*3, 250,  20, 30, 100, 100) : SetGadgetState   (3,  50)                                           ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (4,  10, 42+30*4, 250,  20, 30, 100, 200) : SetGadgetState   (4,  50)                                           ; set 1st scrollbar (ID = 0) to 50 of 100
  
;   Debug GetGadgetAttribute(4, #PB_ScrollBar_Minimum )
;   Debug GetGadgetAttribute(4, #PB_ScrollBar_Maximum )
;   Debug GetGadgetAttribute(4, #PB_ScrollBar_PageLength )
;   Debug ""
  Debug GetGadgetState   (4)
;   
;   For i = 0 To 3
;     BindGadgetEvent(i, @events_gadgets())
;   Next

;   ; disabled
  Scroll(10, 42+30*0, 250,  20, 30, 100, 0) : SetState   (widget( ),  50)
  Scroll(10, 42+30*1, 250,  20, 30, 100, 50) ;: SetState   (widget( ),  50)
  Scroll(10, 42+30*2, 250,  20, 30, 100, 50) : SetState   (widget( ),  50)
  Scroll(10, 42+30*3, 250,  20, 30, 100, 100) : SetState   (widget( ),  50)
  Scroll(10, 42+30*4, 250,  20, 30, 100, 200) : SetState   (widget( ),  50)
   
   ; ;   Debug " - "
  Debug widget( )\bar\page\pos
  Debug widget( )\bar\page\len
  Debug widget( )\bar\page\end
  Debug widget( )\bar\page\change
  Debug widget( )\bar\percent
  Debug widget( )\bar\area\end
  Debug widget( )\bar\thumb\pos
  Debug widget( )\bar\thumb\len
  Debug widget( )\bar\thumb\end
  Debug widget( )\bar\thumb\change
  Debug ""
 
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP