
XIncludeFile "../../../widgets.pbi" 

EnableExplicit
UseWidgets( )

Procedure events_gadgets()
  ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadGetWidgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
      ;SetWidgetState(ID(EventGadget()), GetGadGetWidgetState(EventGadget()))
      Debug  ""+ EventGadget() +" - gadget change " + GetGadGetWidgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ClearDebugOutput()
  ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +this()\type+ "  state - " GetWidgetState(EventWidget( )) ; 
  
  Select WidgetEvent( )
    Case #__event_Change
      SetGadGetWidgetState(GetIndex(EventWidget( )), GetWidgetState(EventWidget( )))
      Debug  Str(GetIndex(EventWidget( )))+" - widget change " + GetWidgetState(EventWidget( ))
  EndSelect
EndProcedure

If OpenRoot(OpenWindow(#PB_Any, 0, 0, 500+500, 340, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 500,0, 500);,140)
  ScrollBarGadget  (0,  10, 42+30*0, 250,  20, 30, 100, 0) : SetGadGetWidgetState   (0,  88)                                            ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (1,  10, 42+30*1, 250,  20, 30, 100, 30) : SetGadGetWidgetState   (1,  50)                                           ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (2,  10, 42+30*2, 250,  20, 100, 30, 30) 
  Debug GetWidgetAttribute(2, #PB_ScrollBar_Minimum )
  Debug GetWidgetAttribute(2, #PB_ScrollBar_Maximum )
  Debug GetWidgetAttribute(2, #PB_ScrollBar_PageLength )
  Debug ""
  SetGadGetWidgetState   (2,  99)   ; set 1st scrollbar (ID = 0) to 50 of 100
  Debug GetWidgetAttribute(2, #PB_ScrollBar_Minimum )
  Debug GetWidgetAttribute(2, #PB_ScrollBar_Maximum )
  Debug GetWidgetAttribute(2, #PB_ScrollBar_PageLength )
  Debug ""
  
  ScrollBarGadget  (3,  10, 42+30*3, 250,  20, 30, 100, 100) : SetGadGetWidgetState   (3,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
  
  ScrollBarGadget  (10, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical) : SetGadGetWidgetState   (10, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
  
  ;   TextGadget       (#PB_Any,  10, 20, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
  ;   TextGadget       (#PB_Any,  10,115, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
  
  ;   Define i
  For i = 0 To 3
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  ScrollBarWidget(10, 42+30*0, 250,  20, 30, 100, 0) 
  SetWidgetState   (widget( ),  88)
  
  ScrollBarWidget(10, 42+30*1, 250,  20, 30, 100, 30) 
  SetWidgetState   (widget( ),  50)
  
  ScrollBarWidget(10, 42+30*2, 250,  20, 100, 30, 30) 
  SetWidgetState   (widget( ),  99) ; 50 - center 
  
  ; disabled
  ScrollBarWidget(10, 42+30*3, 250,  20, 30, 100, 100) 
;   Debug " - "
;   Debug widget( )\bar\page\pos
;   Debug widget( )\bar\page\len
;   Debug widget( )\bar\page\end
;   Debug widget( )\bar\page\change
;   Debug widget( )\bar\percent
;   Debug widget( )\bar\area\end
;   Debug widget( )\bar\thumb\pos
;   Debug widget( )\bar\thumb\len
;   Debug widget( )\bar\thumb\end
;   Debug widget( )\bar\thumb\change
;   Debug ""
    SetWidgetState   (widget( ),  50)
;   Debug " -- "
;   Debug widget( )\bar\page\pos
;   Debug widget( )\bar\page\len
;   Debug widget( )\bar\page\end
;   Debug widget( )\bar\page\change
;   Debug widget( )\bar\percent
;   Debug widget( )\bar\area\end
;   Debug widget( )\bar\thumb\pos
;   Debug widget( )\bar\thumb\len
;   Debug widget( )\bar\thumb\end
;   Debug widget( )\bar\thumb\change
;   Debug ""
;   
    
  ScrollBarWidget(10, 42+30*4, 250,  20, 30, 100, 0, #__bar_invert) 
  SetWidgetState   (widget( ),  88)
  
  ScrollBarWidget(10, 42+30*5, 250,  20, 30, 100, 30, #__bar_invert) 
  SetWidgetState   (widget( ),  50)
  
  ScrollBarWidget(10, 42+30*6, 250,  20, 100, 30, 30, #__bar_invert) 
  SetWidgetState   (widget( ),  99) ; 50 - center 
  
  
  ; vertical
  ScrollBarWidget(280+30*0, 10,  20, 250, 30, 100, 0, #PB_ScrollBar_Vertical) 
  SetWidgetState   (widget( ),  88)
  
  ScrollBarWidget(280+30*1, 10,20, 250, 30, 100, 30, #PB_ScrollBar_Vertical) 
  SetWidgetState   (widget( ),  50)
  
  ScrollBarWidget(280+30*2, 10,20, 250, 100, 30, 30, #PB_ScrollBar_Vertical) 
  SetWidgetState   (widget( ),  99) ; 50 - center 
  
  ; disabled
  ScrollBarWidget(280+30*3, 10,20, 250, 30, 100, 100, #PB_ScrollBar_Vertical) 
  SetWidgetState   (widget( ),  50)
    
  ScrollBarWidget(280+30*4, 10,20, 250, 30, 100, 0, #PB_ScrollBar_Vertical|#__bar_invert) 
  SetWidgetState   (widget( ),  88)
  
  ScrollBarWidget(280+30*5, 10,20, 250, 30, 100, 30, #PB_ScrollBar_Vertical|#__bar_invert) 
  SetWidgetState   (widget( ),  50)
  
  ScrollBarWidget(280+30*6, 10,20, 250, 100, 30, 30, #PB_ScrollBar_Vertical|#__bar_invert) 
  SetWidgetState   (widget( ),  99) ; 50 - center 
  
  
  WaitCloseRoot( )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 122
; FirstLine = 91
; Folding = -
; EnableXP
; DPIAware