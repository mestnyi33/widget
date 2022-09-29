;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  Global *g, Quit, *scroll1._s_widget,*scroll2._s_widget,x_0,y_0
  
  Procedure syncCB()
    x_0 = GetAttribute(EventWidget(), #PB_ScrollArea_X)
    y_0 = GetAttribute(EventWidget(), #PB_ScrollArea_Y)
      
    If EventWidget() = *scroll1
      SetAttribute(*scroll2, #PB_ScrollArea_X, x_0)
      SetAttribute(*scroll2, #PB_ScrollArea_Y, y_0)
      
    ElseIf EventWidget() = *scroll2
      SetAttribute(*scroll1, #PB_ScrollArea_X,x_0)
      SetAttribute(*scroll1, #PB_ScrollArea_Y,y_0) 
      
    EndIf
  EndProcedure
  
  LoadImage(0, #PB_Compiler_Home + "examples/Sources/Data/PureBasicLogo.bmp")
  Define imgw = ImageWidth(0)
  Define imgh = ImageHeight(0)
  
  Open(OpenWindow(-1, 0, 0, 500, 430,"Sync 2 ScrollArea", #PB_Window_SystemMenu|#PB_Window_ScreenCentered |#PB_Window_SizeGadget))
  *scroll1 = ScrollArea(10, 10, 480,200, 2000, 2000, 1, #PB_ScrollArea_Flat|#PB_ScrollArea_Center)
  *scroll1\class = "area_1"
  Button(0,0,imgw,imgh, "", 0,0)
  Button(imgw,imgh,2000-imgw*2,2000-imgh*2, "")
  Button(2000-imgw,2000-imgh,imgw,imgh, "", 0,0)
  CloseList()
  
  *scroll2 = ScrollArea(10, 220, 480,200, 2000, 2000, 1, #PB_ScrollArea_Flat|#PB_ScrollArea_Center)
  *scroll2\class = "area_2"
  Button(0,0,imgw,imgh, "", 0,0)
  Button(imgw,imgh,2000-imgw*2,2000-imgh*2, "")
  Button(2000-imgw,2000-imgh,imgw,imgh, "", 0,0)
  CloseList()
  
  Splitter( 10, 10, 480, 410, *scroll1,*scroll2 )
  Bind(*scroll1,@syncCB())
  Bind(*scroll2,@syncCB())
  
  Repeat
    Select WaitWindowEvent(1)
      Case #PB_Event_CloseWindow
        Quit = 1
        
    EndSelect
  Until Quit = 1
  End
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP