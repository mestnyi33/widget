;
; example demo resize draw splitter - OS gadgets
; 

XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   ;widget::test_draw_repaint = 1
   
   Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
   
   Procedure OpenSplitter( )
      Open(ID::Window(UseGadgetList(0)))
   EndProcedure
   
   Procedure CloseSplitter( )
      Protected *g._s_WIDGET = widget( )
      If *g And *g\type = #__type_Splitter
         ResizeGadget( *g\root\canvas\gadget, X(*g), Y(*g), Width(*g), Height(*g)) 
         Resize( *g, 0, 0, #PB_Ignore, #PB_Ignore )
      EndIf
   EndProcedure
   
   If OpenWindow(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      SetWindowColor(0, $ff00ff)
      ;ButtonGadget(#PB_Any, 0, 0, 850, 280, "Button")
      
      ;\\
      Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = EditorGadget(#PB_Any, 0, 0, 0, 0): SetGadgetText(Button_1, "Button 1");ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      
      Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
      Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
      Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
      Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
      
      Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
      Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
      Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
      Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
      Splitter_4 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
      
      ; bug in mac os
      SetGadgetState(Splitter_0, GadgetWidth(Splitter_0)/2-5)
      SetGadgetState(Splitter_1, GadgetWidth(Splitter_1)/2-5)
      
      ;\\
      Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = EditorGadget(#PB_Any, 0, 0, 0, 0): SetGadgetText(Button_1, "Button 1");ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      
      Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
      Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
      Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
      Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
      
      OpenSplitter( )
      Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
      Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_5)
      Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_2, Splitter_2)
      Splitter_4 = widget::Splitter(430, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical )
      CloseSplitter( )
      
      ;       SetState(Splitter_0, Width(Splitter_0)/2-5)
      ;       SetState(Splitter_1, Width(Splitter_1)/2-5)
      
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 19
; FirstLine = 11
; Folding = -
; EnableXP
; DPIAware