XIncludeFile "../../../widgets.pbi"
; commit 1796 ok

CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  If OpenWindow(0, 0, 0, 470, 280, "tab focus demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If Open(0);, 425, 40)
      Button_0 = Button(0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      
      Button_2 = Button(0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
      Button_3 = Button(0, 0, 0, 0, "Button 3") ; as they will be sized automatically
      Button_4 = Button(0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
      Button_5 = Button(0, 0, 0, 0, "Button 5") ; as they will be sized automatically
      
;       Hide(Button_0, 1 ) 
;       Hide(Button_1, 1 ) 
;       Hide(Button_2, 1 ) 
;       Hide(Button_3, 1 ) 
;       Hide(Button_4, 1 ) 
;       Hide(Button_5, 1 ) 

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
      Splitter_4 = Splitter(30, 30, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
      
      SetText(Splitter_0, "0")
      SetText(Splitter_1, "1")
      SetText(Splitter_2, "2")
      SetText(Splitter_3, "3")
      SetText(Splitter_4, "4")
      
      SetState(Splitter_1, 20)
      ;SetState(Splitter_1, 410-20)
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; DPIAware