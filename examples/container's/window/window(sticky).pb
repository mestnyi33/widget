XIncludeFile "../../../widgets.pbi"
UseWidgets( )
  
;-
; Sticky window example
CompilerIf #PB_Compiler_IsMainFile
  Global Desktop_0
  Global Desktop_0_Window_0, Desktop_0_Window_0_Button_0, Desktop_0_Window_0_Button_1
  Global Desktop_0_Window_1, Desktop_0_Window_1_Button_0, Desktop_0_Window_1_Button_1
  Global Desktop_0_Window_2, Desktop_0_Window_2_Button_0, Desktop_0_Window_2_Button_1
  
  Desktop_0 = Open(#PB_Any, #PB_Ignore,#PB_Ignore, 600,400)
  
  Desktop_0_Window_0 = Window(100,50, 200,150,"Window_0", #PB_Window_SystemMenu)
  Desktop_0_Window_0_Button_0 = ButtonWidget(10,10, 100, 25,"Button_0")
  Desktop_0_Window_0_Button_1 = ButtonWidget(25,25, 100, 25,"Button_1")
  ;CloseList()
  
  Desktop_0_Window_1 = Window(#PB_Ignore,#PB_Ignore, 200,150,"Window_1", #PB_Window_SystemMenu)
  Desktop_0_Window_1_Button_0 = ButtonWidget(10,10, 100, 25,"Button_0")
  Desktop_0_Window_1_Button_1 = ButtonWidget(25,25, 100, 25,"Button_1")
  ;CloseList()
  
  Desktop_0_Window_2 = Window(#PB_Ignore,#PB_Ignore, 200,150,"Window_2", #PB_Window_SystemMenu)
  Desktop_0_Window_2_Button_0 = ButtonWidget(10,10, 100, 25,"Button_0")
  Desktop_0_Window_2_Button_1 = ButtonWidget(25,25, 100, 25,"Button_1")
  ;CloseList()
  
  Sticky(Desktop_0_Window_0, 1)
  Sticky(Desktop_0_Window_0, 0)
  Sticky(Desktop_0_Window_2, 1)
  
  SetTextWidget(Sticky( ),"StickyWindow")
  WaitClose(Desktop_0)
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP