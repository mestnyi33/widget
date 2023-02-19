;
; Module name   : elements
; Author        : mestnyi
; Last updated  : mar 12, 2020
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70662
; 

XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  Global w = 410
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  If OpenWindow(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If Open(0);, 425, 40)
      Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      
      Splitter_0 = SplitterGadget(#PB_Any, 10, 10, w, 210, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
      
      Splitter_3 = TextGadget(#PB_Any, 0,0,0,0, "")
      Splitter_4 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
      
      TextGadget(#PB_Any, 110, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
      
      Button_0 = Button(0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      
      Splitter_0 = Splitter(430, 10, w, 210, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      
      Splitter_3 = Text(0,0,0,0, "")
      Splitter_4 = Splitter(430, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
      
      TextGadget(#PB_Any, 530, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP