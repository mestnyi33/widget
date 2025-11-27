XIncludeFile "../../widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile ;= 100
   UseWidgets( )
   EnableExplicit
   Global state = 0 ; bug windows pb commit 1899
   Global Button_2, Button_3, Splitter_1
   
   
   Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget
   Open(0, 100,100,750,140, "first min size & second min size", flag)
   
   Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "")
   Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "")
   Splitter_1 = SplitterGadget(#PB_Any, 10, 10, 350, 50, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
   SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
   SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
   If state
      SetGadgetState(Splitter_1, 50)
   EndIf
   
   Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "")
   Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "")
   Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
   SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
   SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
   If state
      SetGadgetState(Splitter_1, 50)
   EndIf
   ResizeGadget( Splitter_1, 10, 80, 350, 50 )
   
   Button_2 = 0
   Button_3 = 0
   Splitter_1 = widget::Splitter(390, 10, 350, 50, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
   widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
   widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
   If state
      SetState(Splitter_1, 50)
   EndIf
   
   Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_2, Button_3, #PB_Splitter_Vertical | #PB_Splitter_SecondFixed)
   widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
   widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
   If state
      SetState(Splitter_1, 50)
   EndIf
   Resize( Splitter_1, 390, 80, 350, 50 )
   
   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 6
; Folding = -
; EnableXP
; DPIAware