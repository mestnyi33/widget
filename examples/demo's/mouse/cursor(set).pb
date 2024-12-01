XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
   Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
   
   If Open(0, 0, 0, 430, 280, "установить курсор для виджета", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      Button_1 = Button(0,0,0,0, "Button 1")
      Button_2 = Button(0,0,0,0, "Button 2") 
      
      Splitter_0 = Splitter(0,0,0,0, -1, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
      Splitter_1 = Splitter(0,0,0,0, Button_2, -1, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
      
      Splitter_4 = Splitter(10, 10, 410, 210, Splitter_0, Splitter_1, #PB_Splitter_Vertical)
      
      SetCursor( Splitter_4, #PB_Cursor_Hand )
      
      TextGadget(#PB_Any, 10, 230, 410, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
      
      WaitClose( )
   EndIf
   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP
; DPIAware