Debug #PB_Window_SystemMenu     ; 4  Enables the system menu on the window title bar (Default).
Debug #PB_Window_MinimizeGadget ; 32  Adds the minimize gadget To the window title bar. debug #PB_Window_SystemMenu is automatically added.
Debug #PB_Window_MaximizeGadget ; 16  Adds the maximize gadget To the window title bar. debug #PB_Window_SystemMenu is automatically added.
                                ; (MacOS only ;  debug #PB_Window_SizeGadget will be also automatically added).
Debug #PB_Window_SizeGadget     ; 2  Adds the sizeable feature To a window.
Debug #PB_Window_Invisible      ; 1 Creates the window but don't display.
Debug #PB_Window_TitleBar       ; 8 Creates a window With a titlebar.
Debug #PB_Window_Tool           ; 2048 Creates a window With a smaller titlebar And no taskbar entry. 
Debug #PB_Window_BorderLess     ; 128 Creates a window without any borders.
Debug #PB_Window_ScreenCentered ; 64 Centers the window in the middle of the screen. x,y parameters are ignored.
Debug #PB_Window_WindowCentered ; 256 Centers the window in the middle of the parent window ('ParentWindowID' must be specified).
                                ;                 x,y parameters are ignored.
Debug #PB_Window_Maximize       ; 512 Opens the window maximized. (Note ;  on Linux, Not all Windowmanagers support this)
Debug #PB_Window_Minimize       ; 1024 Opens the window minimized.
Debug #PB_Window_NoGadgets      ; 4096 Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
Debug #PB_Window_NoActivate     ; 8192  Don't activate the window after opening.


; ; windows
; #PB_Window_SystemMenu = 13107200
; #PB_Window_MinimizeGadget = 13238272
; #PB_Window_MaximizeGadget = 13172736
; #PB_Window_SizeGadget = 12845056
; #PB_Window_Invisible = 268435456
; #PB_Window_TitleBar = 12582912
; #PB_Window_Tool = 4
; #PB_Window_BorderLess = 2147483648
; #PB_Window_ScreenCentered = 1
; #PB_Window_WindowCentered = 2
; #PB_Window_Maximize = 16777216
; #PB_Window_Minimize = 536870912
; #PB_Window_NoGadgets = 8
; #PB_Window_NoActivate = 33554432

; ; mac os
; #PB_Window_SystemMenu = 4
; #PB_Window_MinimizeGadget = 32
; #PB_Window_MaximizeGadget = 16
; #PB_Window_SizeGadget = 2
; #PB_Window_Invisible = 1
; #PB_Window_TitleBar = 8
; #PB_Window_Tool = 2048
; #PB_Window_BorderLess = 128
; #PB_Window_ScreenCentered = 64
; #PB_Window_WindowCentered = 256
; #PB_Window_Maximize = 512
; #PB_Window_Minimize = 1024
; #PB_Window_NoGadgets = 4096
; #PB_Window_NoActivate = 8192

; ; linux
; #PB_Window_SystemMenu = 4
; #PB_Window_MinimizeGadget = 32
; #PB_Window_MaximizeGadget = 16
; #PB_Window_SizeGadget = 2
; #PB_Window_Invisible = 1
; #PB_Window_TitleBar = 8
; #PB_Window_Tool = 2048
; #PB_Window_BorderLess = 128
; #PB_Window_ScreenCentered = 64
; #PB_Window_WindowCentered = 256
; #PB_Window_Maximize = 512
; #PB_Window_Minimiz = 1024
; #PB_Window_NoGadgets = 4096
; #PB_Window_NoActivate = 8192
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; EnableXP