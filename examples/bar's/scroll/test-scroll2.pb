
XIncludeFile "../../../widgets.pbi" 

EnableExplicit
UseWidgets( )

Procedure events_gadgets()
  ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
      ;SetState(ID(EventGadget()), GetGadgetState(EventGadget()))
      Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ClearDebugOutput()
  ; Debug ""+Str(EventWidget( )\index - 1)+ " - widget  event - " +this()\type+ "  state - " GetState(EventWidget( )) ; 
  
  Select WidgetEvent( )
    Case #__event_Change
      SetGadgetState(GetIndex(EventWidget( )), GetState(EventWidget( )))
      Debug  Str(GetIndex(EventWidget( )))+" - widget change " + GetState(EventWidget( ))
  EndSelect
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 500+500, 340, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), 500,0, 500);,140)
  ScrollBarGadget  (0,  10, 42+30*0, 250,  20, 30, 100, 0) : SetGadgetState   (0,  88)                                            ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (1,  10, 42+30*1, 250,  20, 30, 100, 30) : SetGadgetState   (1,  50)                                           ; set 1st scrollbar (ID = 0) to 50 of 100
  ScrollBarGadget  (2,  10, 42+30*2, 250,  20, 100, 30, 30) 
  Debug GetGadgetAttribute(2, #PB_ScrollBar_Minimum )
  Debug GetGadgetAttribute(2, #PB_ScrollBar_Maximum )
  Debug GetGadgetAttribute(2, #PB_ScrollBar_PageLength )
  Debug ""
  SetGadgetState   (2,  99)   ; set 1st scrollbar (ID = 0) to 50 of 100
  Debug GetGadgetAttribute(2, #PB_ScrollBar_Minimum )
  Debug GetGadgetAttribute(2, #PB_ScrollBar_Maximum )
  Debug GetGadgetAttribute(2, #PB_ScrollBar_PageLength )
  Debug ""
  
  ScrollBarGadget  (3,  10, 42+30*3, 250,  20, 30, 100, 100) : SetGadgetState   (3,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
  
  ScrollBarGadget  (10, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical) : SetGadgetState   (10, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
  
  ;   TextGadget       (#PB_Any,  10, 20, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
  ;   TextGadget       (#PB_Any,  10,115, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
  
  ;   Define i
  For i = 0 To 3
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  Scroll(10, 42+30*0, 250,  20, 30, 100, 0) 
  SetState   (widget( ),  88)
  
  Scroll(10, 42+30*1, 250,  20, 30, 100, 30) 
  SetState   (widget( ),  50)
  
  Scroll(10, 42+30*2, 250,  20, 100, 30, 30) 
  SetState   (widget( ),  99) ; 50 - center 
  
  ; disabled
  Scroll(10, 42+30*3, 250,  20, 30, 100, 100) 
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
    SetState   (widget( ),  50)
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
    
  Scroll(10, 42+30*4, 250,  20, 30, 100, 0, #__bar_invert) 
  SetState   (widget( ),  88)
  
  Scroll(10, 42+30*5, 250,  20, 30, 100, 30, #__bar_invert) 
  SetState   (widget( ),  50)
  
  Scroll(10, 42+30*6, 250,  20, 100, 30, 30, #__bar_invert) 
  SetState   (widget( ),  99) ; 50 - center 
  
  
  ; vertical
  Scroll(280+30*0, 10,  20, 250, 30, 100, 0, #PB_ScrollBar_Vertical) 
  SetState   (widget( ),  88)
  
  Scroll(280+30*1, 10,20, 250, 30, 100, 30, #PB_ScrollBar_Vertical) 
  SetState   (widget( ),  50)
  
  Scroll(280+30*2, 10,20, 250, 100, 30, 30, #PB_ScrollBar_Vertical) 
  SetState   (widget( ),  99) ; 50 - center 
  
  ; disabled
  Scroll(280+30*3, 10,20, 250, 30, 100, 100, #PB_ScrollBar_Vertical) 
  SetState   (widget( ),  50)
    
  Scroll(280+30*4, 10,20, 250, 30, 100, 0, #PB_ScrollBar_Vertical|#__bar_invert) 
  SetState   (widget( ),  88)
  
  Scroll(280+30*5, 10,20, 250, 30, 100, 30, #PB_ScrollBar_Vertical|#__bar_invert) 
  SetState   (widget( ),  50)
  
  Scroll(280+30*6, 10,20, 250, 100, 30, 30, #PB_ScrollBar_Vertical|#__bar_invert) 
  SetState   (widget( ),  99) ; 50 - center 
  
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 12
; FirstLine = 8
; Folding = -
; EnableXP
; DPIAware