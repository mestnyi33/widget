Procedure RedrawCanvas()
  If StartVectorDrawing(CanvasVectorOutput(0))
    w=VectorOutputWidth()
    h=VectorOutputHeight()
    VectorSourceCircularGradient(w/2, h/2, (w+h)/2)
    VectorSourceGradientColor(RGBA(255, 255, 255, 255), 0.0)
    VectorSourceGradientColor(RGBA(0, 0, 0, 255), 1.0)
    FillVectorOutput()
    StopVectorDrawing()
  EndIf
EndProcedure

CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  ProcedureC _drawcanvas_0 (*self, *event.GdkEventConfigure, user_data)
    Debug "signal configure-event - " + *event\x + "," + *event\y + " / " + *event\width + "," + *event\height
    RedrawCanvas()
  EndProcedure
CompilerEndIf

Procedure UpdateWindow()
  Protected dx, dy
  dx = WindowWidth(0)
  dy = WindowHeight(0)
  ResizeGadget(0, 5, 5, dx-10, dy-10)
;  RedrawCanvas()
EndProcedure

If OpenWindow(0,0,0,400,400,"#PB_EventType_Resize Test",#PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_SizeGadget)
  SetWindowColor(0,$ff)
  CanvasGadget(0,5,5,390,390)
  RedrawCanvas()
  
  BindEvent(#PB_Event_SizeWindow, @UpdateWindow(), 0)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    Define signal_connect_conf_gd_0 = g_signal_connect_(GadgetID(0), "configure-event", @_drawcanvas_0(), 0)
  CompilerElse
    BindGadgetEvent(0, @RedrawCanvas(), #PB_EventType_Resize)
  CompilerEndIf
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 35
; FirstLine = 6
; Folding = --
; EnableXP
; DPIAware