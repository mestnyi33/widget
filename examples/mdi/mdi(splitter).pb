;
; Module name   : elements
; Author        : mestnyi
; Last updated  : mar 12, 2020
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70662
; 

XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  
  Global *mdi, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  If OpenWindow(0, 0, 0, 700, 280, "MDI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If Open(0);, 425, 40)
      Container(10,10, 260,260) : a_init(widget())
      *mdi = MDI(30, 30, 200, 120) ; as they will be sized automatically
      Define *g0 = AddItem(*mdi, -1, "form_0")
  
      CloseList()
      CloseList()
      
      Debug ""
      Button_2 = MDI(0, 0, 0, 0) ; as they will be sized automatically
      Splitter_3 = Splitter(0, 0, 0, 0, Button_2, Splitter_2)
      Splitter_4 = Splitter(280-GadgetX(GetGadget(Root())), 10-GadgetY(GetGadget(Root())), 410, 260, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
    EndIf
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP