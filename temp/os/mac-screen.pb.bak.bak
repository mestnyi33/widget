; OpenWindow(0,0,0,0,0,"test",#PB_Window_SystemMenu|#PB_Window_Invisible)
Frame.CGRect
mainScreen = CocoaMessage(0,0,"NSScreen mainScreen")
CocoaMessage(@visibleFrame.NSRect, mainScreen,"visibleFrame")
CocoaMessage(@Frame, mainScreen, "frame")

Debug CocoaMessage(0, mainScreen,"windowScene")

Debug Frame\origin\x
Debug Frame\origin\y
Debug Frame\size\height
Debug Frame\size\width
Debug "----------------"
Debug visibleFrame\origin\x
Debug visibleFrame\origin\y
Debug visibleFrame\size\height
Debug visibleFrame\size\width


; ; origin\y starts from the bottom left corner of the screen, so to get the safe coordinates for PB we can calculate it like that:
; ExamineDesktops()
; winX = visibleFrame\origin\x
; winY = DesktopHeight(0)-visibleFrame\size\height-visibleFrame\origin\y
; titleBarH = WindowHeight(0,#PB_Window_FrameCoordinate)-WindowHeight(0,#PB_Window_InnerCoordinate)
; winMaxW = visibleFrame\size\width
; winMaxH = visibleFrame\size\height-titleBarH
; 
; Debug winX
; Debug winY
; Debug winMaxW
; Debug winMaxH
; 
; ResizeWindow(0,winX,winY,winMaxW,winMaxH)
; HideWindow(0,#False)
; 
; Repeat : ev = WaitWindowEvent() : Until ev = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; EnableXP