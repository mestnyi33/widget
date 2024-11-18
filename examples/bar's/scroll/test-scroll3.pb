XIncludeFile "../../../widgets.pbi" 

UseWidgets( )



; Procedure events_gadgets()
;   ClearDebugOutput()
;   ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadGetWidgetState(EventGadget()) ; 
;   
;   Select EventType()
;     Case #PB_EventType_LeftClick
;       ;SetWidgetState(ID(EventGadget()), GetGadGetWidgetState(EventGadget()))
;       Debug  ""+ EventGadget() +" - gadget change " + GetGadGetWidgetState(EventGadget())
;   EndSelect
; EndProcedure
; 
; Procedure events_widgets()
;   ClearDebugOutput()
;   ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +this()\type+ "  state - " GetWidgetState(EventWidget( )) ; 
;   
;   Select WidgetEvent( )
;     Case #PB_EventType_Change
;       SetGadGetWidgetState(GetIndex(EventWidget( )), GetWidgetState(EventWidget( )))
;       Debug  Str(GetIndex(EventWidget( )))+" - widget change " + GetWidgetState(EventWidget( ))
;   EndSelect
; EndProcedure

OpenWindow(0, 0, 0, 500+500, 340, "disable - state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

If OpenRoot(0, 500,0, 500);,140)
  ScrollBarGadget  (0,  10, 42+30*0, 250,  20, 30, 100, 0) : SetGadGetWidgetState   (0,  50)                                            ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (1,  10, 42+30*1, 250,  20, 30, 100, 50) ;: SetGadGetWidgetState   (1,  50)                                           ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (2,  10, 42+30*2, 250,  20, 30, 100, 50) : SetGadGetWidgetState   (2,  50)                                           ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (3,  10, 42+30*3, 250,  20, 30, 100, 100) : SetGadGetWidgetState   (3,  50)                                           ; set 1st scrollbar (ID = 0) to 50 of 100
;   ScrollBarGadget  (4,  10, 42+30*4, 250,  20, 30, 100, 200) : SetGadGetWidgetState   (4,  50)                                           ; set 1st scrollbar (ID = 0) to 50 of 100
;   
; ;   Debug GetWidgetAttribute(4, #PB_ScrollBar_Minimum )
; ;   Debug GetWidgetAttribute(4, #PB_ScrollBar_Maximum )
; ;   Debug GetWidgetAttribute(4, #PB_ScrollBar_PageLength )
; ;   Debug ""
;   Debug GetGadGetWidgetState   (4)
; ;   
; ;   For i = 0 To 3
; ;     BindGadgetEvent(i, @events_gadgets())
; ;   Next
; 
; ;   ; disabled
  ScrollBarWidget(10, 42+30*0, 250,  20, 30, 100, 0) : SetWidgetState   (widget( ),  50)
  ScrollBarWidget(10, 42+30*1, 250,  20, 30, 100, 50) ;: SetWidgetState   (widget( ),  50)
  ScrollBarWidget(10, 42+30*2, 250,  20, 30, 100, 50) : SetWidgetState   (widget( ),  50)
  ScrollBarWidget(10, 42+30*3, 250,  20, 30, 100, 100) : SetWidgetState   (widget( ),  50)
  ScrollBarWidget(10, 42+30*4, 250,  20, 30, 100, 200) : SetWidgetState   (widget( ),  50)
   
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
 
  WaitCloseRoot( )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 52
; FirstLine = 37
; Folding = -
; EnableXP
; DPIAware