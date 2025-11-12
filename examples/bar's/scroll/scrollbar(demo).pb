; 1410 коммет каждое нажатие на стрелки горизонтального бара не перемещает скролл бар
;\\ Scroll( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define i
      
   Procedure events_gadgets()
      Select EventType()
         Case #PB_EventType_LeftClick
            Define state = GetGadgetState(EventGadget())
            Debug "["+ state +"] - gadget change " + EventGadget()
            SetState(ID(EventGadget()), state)
            Repaint( )
      EndSelect
   EndProcedure
   
   Procedure events_widgets()
      Select WidgetEvent( )
         Case #__event_Change
            Define state = GetState(EventWidget( ))
            Debug "  ["+ state +"] - widget change " + Str(Index(EventWidget( )))
            SetGadgetState(Index(EventWidget( )), state)
      EndSelect
   EndProcedure
   
   ;\\
   If OpenWindow       (0, 0, 0, 305+305, 140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ScrollBarGadget  (0,  10, 42, 250,  20, 30, 100, 30)
      SetGadgetState   (0,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
      
      ScrollBarGadget  (1, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
      SetGadgetState   (1, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
      
      TextGadget       (#PB_Any,  10, 10, 250,  30, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
      TextGadget       (#PB_Any,  10,105, 250,  30, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
      
      For i = 0 To 1
         BindGadgetEvent(i, @events_gadgets())
      Next
   EndIf
   
   ;\\
   If Open     (0, 305,0, 305,140)
      Scroll   (10, 42, 250,  20, 30, 100, 30)
      SetState (ID(0),  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
      
      Scroll   (270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
      SetState (ID(1), 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
      
      Text     (10, 10, 250,  30, "ScrollBar Standard  (start=50, page=30/100)",#__flag_TextCenter)
      Text     (10,105, 250,  30, "ScrollBar Vertical  (start=100, page=50/300)",#__flag_TextRight)
      
      For i = 0 To 1
         Bind  (ID(i), @events_widgets())
      Next
   EndIf
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 26
; FirstLine = 13
; Folding = --
; Optimizer
; EnableXP
; DPIAware