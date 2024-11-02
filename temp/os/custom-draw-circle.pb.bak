; https://www.purebasic.fr/english/viewtopic.php?f=12&t=78265
; https://www.purebasic.fr/english/viewtopic.php?f=13&t=78253
Enumeration
  #MainWindow
  #ImageGadget
EndEnumeration

WindowWidth = 640
WindowHeight = 480

If OpenWindow(#MainWindow, 0, 0, WindowWidth, WindowHeight, "Draw Circle", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ImageGadget(#ImageGadget, 0, 0, WindowWidth, WindowHeight, #Null)
  ImageCircle = CreateImage(#PB_Any, WindowWidth, WindowHeight)

  If IsImage(ImageCircle)
    If StartDrawing(ImageOutput(ImageCircle))
      xCenter = WindowWidth / 2
      yCenter = WindowHeight / 2
      nRadius = 200
      nThickness = 3
      nColor = RGB(0, 0, 255)
      nAngle.f = 0
      nDistance.f = 0.01

      While nAngle < #PI * 2
        ;Box(xCenter + Cos(nAngle) * nRadius, yCenter + Sin(nAngle) * nRadius, nThickness, nThickness, nColor)
        Circle(xCenter + Cos(nAngle) * nRadius, yCenter + Sin(nAngle) * nRadius, nThickness, nColor)
        nAngle + nDistance
      Wend
      StopDrawing()
    EndIf
    SetGadgetState(#ImageGadget, ImageID(ImageCircle))
  EndIf
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP