Structure screen
  Width.i
  Height.i
EndStructure

Define ScreenSize.screen

Procedure GetScreenWorkAreaSize(*size.screen)
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      ; A check for the 'working area' on the Windows desktop, being aware of the size/position of the task bar:
      ; (see my question / answer by netmaestro here: https://www.purebasic.fr/english/viewtopic.php?f=13&t=75410)
      SystemParametersInfo_(#SPI_GETWORKAREA,0,@wr.RECT,0)
      *size\width = wr\right-wr\left-GetSystemMetrics_(#SM_CXBORDER)*2
      *size\height = wr\bottom-wr\top-(GetSystemMetrics_(#SM_CYCAPTION)+GetSystemMetrics_(#SM_CYBORDER)*2)
      
    CompilerCase #PB_OS_MacOS
      Protected ActiveScreen.i, MaxWindowHeight.i, MaxWindowWidth.i
      Protected MenuBarHeight.CGFloat
      Protected UsableDesktopArea.NSRect
      ; ----- Get screen area with subtracted dock size:
      ActiveScreen = CocoaMessage(0, 0, "NSScreen mainScreen")
      CocoaMessage(@UsableDesktopArea, ActiveScreen, "visibleFrame")
      MaxWindowHeight = UsableDesktopArea\size\height
      MaxWindowWidth = UsableDesktopArea\size\width
      ; ----- Get height of MenuBar:
      CocoaMessage(@MenuBarHeight, CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "mainMenu"), "menuBarHeight")
      ; ----- Subtract height of MenuBar
      MaxWindowHeight - MenuBarHeight
      *size\Width = MaxWindowWidth
      *size\Height = MaxWindowHeight
    CompilerCase #PB_OS_Linux
      ; TODO!
     
  CompilerEndSelect
EndProcedure 

; Example - fill the pre-defined variable with the width/height values:
GetScreenWorkAreaSize(@ScreenSize)
Debug "Working area size = " + ScreenSize\width + "x" + ScreenSize\height

; Test output on my PC with Win10, FullHD (1440x900) and 125% DPI setting:
; -------------------------------------------------------------------------
; compiled with PB compiler options =
; a) DPI-aware off: 1534x799
; b) DPI-aware on:  1918x999
;
; (Please note, that the PB functions DesktopWidth()/DesktopHeight() always output 1920x1024 independent of the DPI-aware option!)
;
; Test output on my Mac:
; 1440x830
; -------------------------------------------------------------------------
; TODO!
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP