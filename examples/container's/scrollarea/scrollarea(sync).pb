XIncludeFile "../../../widgets.pbi" ; ok

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  Global *g, Quit, *scroll1._s_widget,*scroll2._s_widget,x_0,y_0
  
  Procedure syncCB()
    Protected *eWidget = EventWidget( )
    x_0 = GetAttribute(*eWidget, #PB_ScrollArea_X)
    y_0 = GetAttribute(*eWidget, #PB_ScrollArea_Y)
    
    Select *eWidget 
    	Case *scroll1
    		SetAttribute(*scroll2, #PB_ScrollArea_X, x_0)
    		SetAttribute(*scroll2, #PB_ScrollArea_Y, y_0)
    		
    	Case *scroll2
    		SetAttribute(*scroll1, #PB_ScrollArea_X,x_0)
    		SetAttribute(*scroll1, #PB_ScrollArea_Y,y_0) 
    		
    EndSelect
    
    If *eWidget <> EventWidget( )
    	Debug "test - "+ *eWidget +" "+ EventWidget( )
    EndIf
    
 EndProcedure
  
  LoadImage(0, #PB_Compiler_Home + "examples/Sources/Data/PureBasicLogo.bmp")
  Define imgw = ImageWidth(0)
  Define imgh = ImageHeight(0)
  
  Open(0, 0, 0, 500, 430,"demonstration of how to sync two scroll area bars", #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)
  *scroll1 = ScrollArea(10, 10, 480,200, 2000, 2000, 1, #PB_ScrollArea_Flat|#PB_ScrollArea_Center)
  Button(0,0,imgw,imgh, "", 0,0)
  Button(imgw,imgh,2000-imgw*2,2000-imgh*2, "")
  Button(2000-imgw,2000-imgh,imgw,imgh, "", 0,0)
  CloseList()
  
  *scroll2 = ScrollArea(10, 220, 480,200, 2000, 2000, 1, #PB_ScrollArea_Flat|#PB_ScrollArea_Center)
  Button(0,0,imgw,imgh, "", 0,0)
  Button(imgw,imgh,2000-imgw*2,2000-imgh*2, "")
  Button(2000-imgw,2000-imgh,imgw,imgh, "", 0,0)
  CloseList()
  
  Splitter( 10, 10, 480, 410, *scroll1,*scroll2 )
  
  Bind(*scroll1, @syncCB(), #__Event_ScrollChange)
  Bind(*scroll2, @syncCB(), #__Event_ScrollChange)
  
  Repeat
    Select WaitWindowEvent(1)
      Case #PB_Event_CloseWindow
        Quit = 1
        
    EndSelect
  Until Quit = 1
  End
CompilerEndIf
; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 48
; FirstLine = 29
; Folding = -
; EnableXP
; DPIAware