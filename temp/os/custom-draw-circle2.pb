OpenWindow(0, 0, 0, 640,640, "Image DC", #PB_Window_SystemMenu |#PB_Window_ScreenCentered)
  LoadImage(1, #PB_Compiler_Home + "Examples/Sources/Data/Background.bmp")
  ResizeImage(1,640,640)
  color = $0000FF
  cx = 320 : cy = 320: r = 200
  stroke = 40  
  x = cx - r + stroke/2
  y = cy 
  StartDrawing(ImageOutput(1))
    DrawingMode(#PB_2DDrawing_Outlined )
    Circle(cx,cy,r,color)
    Circle(cx,cy,r-stroke,color)
    FillArea(x,y,color,color)
  StopDrawing()  
  
  ImageGadget(2, 0, 0,640,640, ImageID(1))

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
         Quit = 1
  EndSelect
Until Quit = 1

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP