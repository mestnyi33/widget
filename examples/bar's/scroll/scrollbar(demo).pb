; 1410 коммет каждое нажатие на стрелки горизонтального бара не перемещает скролл бар
;\\ ScrollBarWidget( x.l, y.l, width.l, height.l, Min.l, Max.l, PageLength.l, flag.q = 0, round.l = 0 )

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Define i
      
   Procedure events_gadgets()
      Select EventType()
         Case #PB_EventType_LeftClick
            SetState(ID(EventGadget()), GetGadgetState(EventGadget()))
            Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
      EndSelect
   EndProcedure
   
   Procedure events_widgets()
      Select WidgetEvent( )
         Case #__event_Change
            SetGadgetState(IDWidget(EventWidget( )), GetState(EventWidget( )))
            Debug  Str(IDWidget(EventWidget( )))+" - widget change " + GetState(EventWidget( ))
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
      
      Text     (10, 10, 250,  30, "ScrollBar Standard  (start=50, page=30/100)",#__flag_Textcenter)
      Text     (10,105, 250,  30, "ScrollBar Vertical  (start=100, page=50/300)",#__flag_Textright)
      
      For i = 0 To 1
         Bind  (ID(i), @events_widgets())
      Next
   EndIf
   
   WaitCloseRootWidget( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1
; Folding = --
; Optimizer
; EnableXP
; DPIAware