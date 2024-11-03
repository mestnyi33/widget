;  Debug Hex(16)
;  Debug Val("$10")
 
 #__Window_Normal         = $00000000 ; 0
 #__Window_ScreenCentered = $00000001 ; 1          ; Centers the window in the middle of the screen. x,y parameters are ignored.
 #__Window_WindowCentered = $00000002 ; 2          ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified).
 #__Window_Tool           = $00000004 ; 4          ; Creates a window with a smaller titlebar And no taskbar entry. 
 #__Window_NoGadgets      = $00000008 ; 8          ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
 
 #__Window_TitleBar       = $00C00000 ; 12582912   ; Creates a window with a titlebar.
 #__Window_SizeGadget     = $00C40000 ; 12845056   ; Adds the sizeable feature To a window.
 #__Window_SystemMenu     = $00C80000 ; 13107200   ; Enables the system menu on the window title bar (Default).
 #__Window_MaximizeGadget = $00C90000 ; 13172736   ; Adds the maximize gadget To the window title bar. #__Window_SystemMenu is automatically added.
 #__Window_MinimizeGadget = $00CA0000 ; 13238272   ; Adds the minimize gadget To the window title bar. #__Window_SystemMenu is automatically added.
                                                     ; (MacOS only ; #__Window_SizeGadget will be also automatically added).
 #__Window_Maximize       = $01000000 ; 16777216   ; Opens the window maximized. (Note ; on Linux, Not all Windowmanagers support this)
 #__Window_NoActivate     = $02000000 ; 33554432   ; Don't activate the window after opening.
 #__Window_Invisible      = $10000000 ; 268435456  ; Creates the window but don't display.
 #__Window_Minimize       = $20000000 ; 536870912  ;  Opens the window minimized.
 #__Window_BorderLess     = $80000000 ; 2147483648 ; Creates a window without any borders.
                                                   ;                 x,y parameters are ignored.
 
 flag = #__Window_SystemMenu|#__Window_MinimizeGadget|#__Window_MaximizeGadget|#__Window_SizeGadget
 flag | #__Window_Minimize|#__Window_Maximize|#__Window_NoActivate
 flag | #__Window_Invisible|#__Window_BorderLess
 
 ;flag = #__Window_MinimizeGadget
 
 If flag & #__Window_TitleBar = #__Window_TitleBar
   Debug "#__Window_TitleBar " + Hex(#__Window_TitleBar)
 EndIf
 
 If flag & #__Window_SizeGadget = #__Window_SizeGadget
   Debug "#__Window_SizeGadget " + Hex(#__Window_SizeGadget)
 EndIf
 
 If flag & #__Window_SystemMenu = #__Window_SystemMenu
   Debug "#__Window_SystemMenu " + Hex(#__Window_SystemMenu)
 EndIf
 
 If flag & #__Window_MaximizeGadget = #__Window_MaximizeGadget
   Debug "#__Window_MaximizeGadget " + Hex(#__Window_MaximizeGadget)
 EndIf
 
 If flag & #__Window_MinimizeGadget = #__Window_MinimizeGadget
   Debug "#__Window_MinimizeGadget " + Hex(#__Window_MinimizeGadget)
 EndIf
 
 If flag & #__Window_Maximize = #__Window_Maximize
   Debug "#__Window_Maximize " + Hex(#__Window_Maximize)
 EndIf
 
 If flag & #__Window_NoActivate = #__Window_NoActivate
   Debug "#__Window_NoActivate " + Hex(#__Window_NoActivate)
 EndIf
 
 If flag & #__Window_Invisible = #__Window_Invisible
   Debug "#__Window_Invisible " + Hex(#__Window_Invisible)
 EndIf
 
 If flag & #__Window_Minimize = #__Window_Minimize
   Debug "#__Window_Minimize " + Hex(#__Window_Minimize)
 EndIf
 
 If flag & #__Window_BorderLess = #__Window_BorderLess
   Debug "#__Window_BorderLess " + Hex(#__Window_BorderLess)
 EndIf
 
 If flag & #__Window_ScreenCentered = #__Window_ScreenCentered
   Debug "#__Window_ScreenCentered " + Hex(#__Window_ScreenCentered)
 EndIf
 
 If flag & #__Window_WindowCentered = #__Window_WindowCentered
   Debug "#__Window_WindowCentered " + Hex(#__Window_WindowCentered)
 EndIf
 
 If flag & #__Window_Tool = #__Window_Tool
   Debug "#__Window_Tool " + Hex(#__Window_Tool)
 EndIf
 
 If flag & #__Window_NoGadgets = #__Window_NoGadgets
   Debug "#__Window_NoGadgets " + Hex(#__Window_NoGadgets)
 EndIf
 
 
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = AA9
; EnableXP