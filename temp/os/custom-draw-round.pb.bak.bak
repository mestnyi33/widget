OpenWindow(0, 0, 0, 640,640, "Image DC", #PB_Window_SystemMenu |#PB_Window_ScreenCentered)
  LoadImage(1, #PB_Compiler_Home + "Examples/Sources/Data/Background.bmp")
  ResizeImage(1,640,640)
  color = $0000FF  
  stroke = 10  
  x1 = 100 : y1 = 200 : w1 = 400 : h1 = 100
  x2 = x1 + stroke 
  y2 = y1 + stroke 
  w2 = w1 - 2*stroke 
  h2 = h1 - 2*stroke
  
  
  r1 = 50
  r2 = r1-stroke ;1.0 *r1*h2/h1
  Debug ""+r1+" "+r2
  
  StartDrawing(ImageOutput(1))
    DrawingMode(#PB_2DDrawing_Outlined )
    RoundBox(x1,y1,w1,h1,r1,r1,color)
    RoundBox(x2,y2,w2,h2,r2,r2,color)
    FillArea(x2-1,y2+h2/2,color,color)
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