

OpenWindow(0, 0, 0, 320, 256, "MyPaintBoxGadget test", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget)
SetWindowLong_(WindowID(0), #GWL_STYLE, GetWindowLong_(WindowID(0), #GWL_STYLE)|#WS_CLIPCHILDREN)
;CreateGadgetList(WindowID())
gadget = EC_MyPaintBoxGadget(#PB_Any, 0, 0, 320, 256, 4, $FF00, $FF0000)
;Debug GetGadgetState(0)

Repeat
  ev = WaitWindowEvent()
  If ev = #PB_Event_SizeWindow
    ResizeGadget(gadget, 0, 0, WindowWidth(0), WindowHeight(0))
    ;Debug "resized"
  ElseIf ev = #WM_RBUTTONUP
    SetGadgetState(gadget, RGB(Random(255), Random(255), Random(255)))
  ElseIf ev = #PB_Event_CloseWindow
    quit = 1
  EndIf
Until quit=1
; IDE Options = PureBasic 4.30 (Windows - x64)
; CursorPosition = 1
; Folding = -