;
; bug then resized no first fixed splitter
; 

XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global b_0,b_1,b_2,s_0,b_2,b_3,s_1, s_2
   
   Procedure resize_window_0()
      Protected Width = WindowWidth(EventWindow())
      
      ResizeGadget(7, #PB_Ignore, #PB_Ignore, Width - 250, #PB_Ignore)
      
      ; ResizeGadget(GetCanvasGadget(root()), #PB_Ignore, #PB_Ignore, Width, #PB_Ignore)
      If Resize(s_2, #PB_Ignore, #PB_Ignore, Width - 250, #PB_Ignore)
         Repaint( )
      EndIf
   EndProcedure
   
   OpenWindow(0, 10, 10, 510, 340, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
   BindEvent(#PB_Event_SizeWindow, @resize_window_0())
   
   widget::Open(0);, 0, 0, 510, 340)
   
   ;\\ gadget
   ButtonGadget(1, 0, 0, 0, 0, "BTN1")
   ButtonGadget(2, 0, 0, 0, 0, "BTN2")
   SplitterGadget(3, 125, 10, 250, 70, 1, 2, #PB_Splitter_Separator | #PB_Splitter_Vertical );| #PB_Splitter_FirstFixed)
   
   ButtonGadget(4, 0, 0, 0, 0, "BTN1")
   ButtonGadget(5, 0, 0, 0, 0, "BTN2")
   SplitterGadget(6, 125, 90, 250, 70, 4, 5, #PB_Splitter_Separator | #PB_Splitter_Vertical );| #PB_Splitter_SecondFixed)
                                                                                             ;
   SplitterGadget(7, 125, 10, 250, 70, 3, 6, #PB_Splitter_Separator | #PB_Splitter_Vertical)
   
   
   ;\\ widget
   b_0 = widget::Button(0, 0, 0, 0, "BTN1")
   b_1 = widget::Button(0, 0, 0, 0, "BTN2")
   s_0 = widget::Splitter(125, 170, 250, 70, b_0, b_1, #PB_Splitter_Separator | #PB_Splitter_Vertical );| #PB_Splitter_FirstFixed)
   
   b_2 = widget::Button(0, 0, 0, 0, "BTN1")
   b_3 = widget::Button(0, 0, 0, 0, "BTN2")
   s_1 = widget::Splitter(125, 170+80, 250, 70, b_2, b_3, #PB_Splitter_Separator | #PB_Splitter_Vertical );| #PB_Splitter_SecondFixed)
                                                                                                          ;
   s_2 = widget::Splitter(125, 170, 250, 70, s_0, s_1, #PB_Splitter_Separator | #PB_Splitter_Vertical)
   
   ;\\
   SetGadgetAttribute( 3, #PB_Splitter_FirstMinimumSize, 30 )
   SetGadgetAttribute( 6, #PB_Splitter_SecondMinimumSize, 30 )
   SetAttribute( s_0, #PB_Splitter_FirstMinimumSize, 30 )
   SetAttribute( s_1, #PB_Splitter_SecondMinimumSize, 30 )
   
   ;\\ state
   SetGadgetState(3, 10)
   SetGadgetState(6, 250-#__bar_splitter_size-10)
   SetState(s_0, 10)
   SetState(s_1, 250-#__bar_splitter_size-10)
   
   ;SetState(s_2, 10)
   
   Define event
   Repeat
      event = WaitWindowEvent()
   Until event = #PB_Event_CloseWindow
   End
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 18
; Folding = -
; EnableXP
; DPIAware