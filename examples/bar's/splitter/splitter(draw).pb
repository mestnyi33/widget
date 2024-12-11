XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  If OpenWindow(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If Open(0);, 425, 40)
      Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      
      Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
      Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
      Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
      Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
      
      Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Separator|#PB_Splitter_FirstFixed);|#PB_Splitter_Vertical)
      Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Separator|#PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
      SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
      SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
      Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
      Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
      Splitter_4 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
      
      SetGadgetState(Splitter_0, GadgetWidth(Splitter_0)/2-5)
      SetGadgetState(Splitter_1, GadgetWidth(Splitter_1)/2-5)
      
      SetGadgetState(Splitter_1, 20)
      
;       HideGadget(Button_0, 1 ) 
;       HideGadget(Button_1, 1 ) 
;       HideGadget(Button_2, 1 ) 
;       HideGadget(Button_3, 1 ) 
;       HideGadget(Button_4, 1 ) 
;       HideGadget(Button_5, 1 ) 
      
      TextGadget(#PB_Any, 110, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
      
      Button_0 = Button(0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      
      Button_2 = Button(0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
      Button_3 = Button(0, 0, 0, 0, "Button 3") ; as they will be sized automatically
      Button_4 = Button(0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
      Button_5 = Button(0, 0, 0, 0, "Button 5") ; as they will be sized automatically
      
      Hide(Button_0, 1 ) 
      Hide(Button_1, 1 ) 
      Hide(Button_2, 1 ) 
      Hide(Button_3, 1 ) 
      Hide(Button_4, 1 ) 
      Hide(Button_5, 1 ) 

;       Button_0 = 0
;       Button_1 = 0
;       Button_2 = 0
;       Button_3 = 0
;       Button_4 = 0
;       Button_5 = 0
      
      Splitter_0 = Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_FirstFixed) ; #PB_Splitter_Vertical|
      Splitter_1 = Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
      SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
      SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
      Splitter_2 = Splitter(0, 0, 0, 0, Splitter_1, Button_5)
      Splitter_3 = Splitter(0, 0, 0, 0, Button_2, Splitter_2)
      Splitter_4 = Splitter(430-GadgetX(GetCanvasGadget(root())), 10-GadgetY(GetCanvasGadget(root())), 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
      
      SetText(Splitter_0, "0")
      SetText(Splitter_1, "1")
      SetText(Splitter_2, "2")
      SetText(Splitter_3, "3")
      SetText(Splitter_4, "4")
      
      SetState(Splitter_1, 20)
      ;SetState(Splitter_1, 410-20)
      
      TextGadget(#PB_Any, 530, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 52
; FirstLine = 43
; Folding = -
; EnableXP
; DPIAware