;  Debug Hex(16)
;  Debug Val("$10")
 
 #PB_Window_Normal         = $00000000 ; 0
 #PB_Window_ScreenCentered = $00000001 ; 1          ; Centers the window in the middle of the screen. x,y parameters are ignored.
 #PB_Window_WindowCentered = $00000002 ; 2          ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified).
 #PB_Window_Tool           = $00000004 ; 4          ; Creates a window with a smaller titlebar And no taskbar entry. 
 #PB_Window_NoGadgets      = $00000008 ; 8          ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
 
 #PB_Window_TitleBar       = $00C00000 ; 12582912   ; Creates a window with a titlebar.
 #PB_Window_SizeGadget     = $00C40000 ; 12845056   ; Adds the sizeable feature To a window.
 #PB_Window_SystemMenu     = $00C80000 ; 13107200   ; Enables the system menu on the window title bar (Default).
 #PB_Window_MaximizeGadget = $00C90000 ; 13172736   ; Adds the maximize gadget To the window title bar. #PB_Window_SystemMenu is automatically added.
 #PB_Window_MinimizeGadget = $00CA0000 ; 13238272   ; Adds the minimize gadget To the window title bar. #PB_Window_SystemMenu is automatically added.
                                                     ; (MacOS only ; #PB_Window_SizeGadget will be also automatically added).
 #PB_Window_Maximize       = $01000000 ; 16777216   ; Opens the window maximized. (Note ; on Linux, Not all Windowmanagers support this)
 #PB_Window_NoActivate     = $02000000 ; 33554432   ; Don't activate the window after opening.
 #PB_Window_Invisible      = $10000000 ; 268435456  ; Creates the window but don't display.
 #PB_Window_Minimize       = $20000000 ; 536870912  ;  Opens the window minimized.
 #PB_Window_BorderLess     = $80000000 ; 2147483648 ; Creates a window without any borders.
                                                   ;                 x,y parameters are ignored.
 
 flag = #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget
 flag | #PB_Window_Minimize|#PB_Window_Maximize|#PB_Window_NoActivate
 flag | #PB_Window_Invisible|#PB_Window_BorderLess
 
 ;flag = #PB_Window_MinimizeGadget
 
 If flag & #PB_Window_TitleBar = #PB_Window_TitleBar
   Debug "#PB_Window_TitleBar " + Hex(#PB_Window_TitleBar)
 EndIf
 
 If flag & #PB_Window_SizeGadget = #PB_Window_SizeGadget
   Debug "#PB_Window_SizeGadget " + Hex(#PB_Window_SizeGadget)
 EndIf
 
 If flag & #PB_Window_SystemMenu = #PB_Window_SystemMenu
   Debug "#PB_Window_SystemMenu " + Hex(#PB_Window_SystemMenu)
 EndIf
 
 If flag & #PB_Window_MaximizeGadget = #PB_Window_MaximizeGadget
   Debug "#PB_Window_MaximizeGadget " + Hex(#PB_Window_MaximizeGadget)
 EndIf
 
 If flag & #PB_Window_MinimizeGadget = #PB_Window_MinimizeGadget
   Debug "#PB_Window_MinimizeGadget " + Hex(#PB_Window_MinimizeGadget)
 EndIf
 
 If flag & #PB_Window_Maximize = #PB_Window_Maximize
   Debug "#PB_Window_Maximize " + Hex(#PB_Window_Maximize)
 EndIf
 
 If flag & #PB_Window_NoActivate = #PB_Window_NoActivate
   Debug "#PB_Window_NoActivate " + Hex(#PB_Window_NoActivate)
 EndIf
 
 If flag & #PB_Window_Invisible = #PB_Window_Invisible
   Debug "#PB_Window_Invisible " + Hex(#PB_Window_Invisible)
 EndIf
 
 If flag & #PB_Window_Minimize = #PB_Window_Minimize
   Debug "#PB_Window_Minimize " + Hex(#PB_Window_Minimize)
 EndIf
 
 If flag & #PB_Window_BorderLess = #PB_Window_BorderLess
   Debug "#PB_Window_BorderLess " + Hex(#PB_Window_BorderLess)
 EndIf
 
 If flag & #PB_Window_ScreenCentered = #PB_Window_ScreenCentered
   Debug "#PB_Window_ScreenCentered " + Hex(#PB_Window_ScreenCentered)
 EndIf
 
 If flag & #PB_Window_WindowCentered = #PB_Window_WindowCentered
   Debug "#PB_Window_WindowCentered " + Hex(#PB_Window_WindowCentered)
 EndIf
 
 If flag & #PB_Window_Tool = #PB_Window_Tool
   Debug "#PB_Window_Tool " + Hex(#PB_Window_Tool)
 EndIf
 
 If flag & #PB_Window_NoGadgets = #PB_Window_NoGadgets
   Debug "#PB_Window_NoGadgets " + Hex(#PB_Window_NoGadgets)
 EndIf
 
 
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = AA9
; EnableXP