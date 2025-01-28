XIncludeFile "../../../widgets.pbi"

;-
; Sticky window example
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   UseWidgets( )
   
   Global Desktop_0
   Global Desktop_0_Window_0, Desktop_0_Window_0_Button_0, Desktop_0_Window_0_Button_1
   Global Desktop_0_Window_1, Desktop_0_Window_1_Button_0, Desktop_0_Window_1_Button_1
   Global Desktop_0_Window_2, Desktop_0_Window_2_Button_0, Desktop_0_Window_2_Button_1
   
   Desktop_0 = Open(0, #PB_Ignore,#PB_Ignore, 600,400,"", #PB_Window_SystemMenu)
   
   Desktop_0_Window_0 = Window(50,50, 200,150,"Window_0", #PB_Window_SystemMenu)
   Desktop_0_Window_0_Button_0 = Button(10,10, 100, 25,"Button_0")
   Desktop_0_Window_0_Button_1 = Button(25,25, 100, 25,"Button_1")
   ;CloseList()
   
   Desktop_0_Window_1 = Window(100,100, 200,150,"Window_1", #PB_Window_SystemMenu)
   Desktop_0_Window_1_Button_0 = Button(10,10, 100, 25,"Button_0")
   Desktop_0_Window_1_Button_1 = Button(25,25, 100, 25,"Button_1")
   ;CloseList()
   
   Desktop_0_Window_2 = Window(150,150, 200,150,"Window_2", #PB_Window_SystemMenu)
   Desktop_0_Window_2_Button_0 = Button(10,10, 100, 25,"Button_0")
   Desktop_0_Window_2_Button_1 = Button(25,25, 100, 25,"Button_1")
   ;CloseList()
   
   
   ; WaitClose(Desktop_0)
   WaitClose(Desktop_0_Window_2)
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 31
; FirstLine = 1
; Folding = -
; EnableXP
; DPIAware