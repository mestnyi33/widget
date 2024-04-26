;
; Module name   : elements
; Author        : mestnyi
; Last updated  : mar 12, 2020
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70662
; 

XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Uselib(widget)
   
   Global w = 410, Button_0, Button_1, Button_2, Splitter_0, Splitter_1
   
   If Open(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      ;
      Splitter_0 = SplitterGadget(#PB_Any, 10, 10, w, 210, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
      ;
      Button_2 = TextGadget(#PB_Any, 0,0,0,0, "")
      Splitter_1 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Splitter_0, Button_2, #PB_Splitter_Vertical|#PB_Splitter_Separator)
      ;
      TextGadget(#PB_Any, 80, 225, 270, 50, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
      
      
      ;\\
      Button_0 = Button(0, 0, 0, 0, "Button 0") ; as they will be sized automatically
      Button_1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
      ;
      Splitter_0 = Splitter(430, 10, w, 210, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      ;
      Button_2 = Text(0,0,0,0, "")
      Splitter_1 = Splitter(430, 10, 410, 210, Splitter_0, Button_2, #PB_Splitter_Vertical)
      ;
      Text(500, 225, 270, 50, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
      
      ;\\
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 13
; FirstLine = 9
; Folding = -
; EnableXP