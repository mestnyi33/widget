; bug mouse enter & leave
Procedure   Canvas(gadget)
   Protected color = RGB( Random(255), Random(255), Random(255) )
   CanvasGadget(gadget, 0, 0, 200, 200)    
   StartDrawing(CanvasOutput(gadget))
   DrawingMode(#PB_2DDrawing_Default)
   Box(0,0,OutputWidth(), OutputHeight(), color)
   DrawText(10,10, Str(gadget))
   StopDrawing()
EndProcedure

OpenWindow(1, 0, 0, 500, 500, "", #PB_Window_BorderLess)
Canvas(1)  

Global _dpiScaleFactorX.d
Global _dpiScaleFactorY.d

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
   _dpiScaleFactorX = GetDeviceCaps_(GetDC_(0),#LOGPIXELSX) / 96
   _dpiScaleFactorY = GetDeviceCaps_(GetDC_(0),#LOGPIXELSY) / 96
CompilerEndIf

Repeat 
   event = WaitWindowEvent()
   If event = #PB_Event_Gadget
      If EventType() = #PB_EventType_LeftButtonDown
         mouse_x = DesktopMouseX()
         ResizeGadget(EventGadget(), mouse_x / _dpiScaleFactorX, #PB_Ignore, #PB_Ignore, #PB_Ignore)
         Debug "mouse_x = "+mouse_x +" gadget_x = "+ Str(GadgetX(EventGadget(), #PB_Gadget_ScreenCoordinate) * _dpiScaleFactorX)
         GetWindowRect_(GadgetID(EventGadget()), @rc.RECT)
         Debug rc\left
      EndIf
   EndIf
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 4.61 (Windows - x64)
; CursorPosition = 28
; Folding = -
; EnableXP
; DPIAware