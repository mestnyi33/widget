OpenWindow(0, 0, 0, 640,640, "Image DC", #PB_Window_SystemMenu |#PB_Window_ScreenCentered)
  LoadImage(1, #PB_Compiler_Home + "Examples/Sources/Data/Background.bmp")
  ResizeImage(1,640,640)
  color = $0000FF  
  stroke = 20  
  x1 = 10 : y1 = 30 : x2 = 500 : y2 = 500
  x3 = x1 + stroke 
  y3 = y1 - stroke 
  x4 = x2 + stroke 
  y4 = y2 - stroke
  
  StartDrawing(ImageOutput(1))
    LineXY(x1,y1,x2,y2,color)        
    LineXY(x3,y3,x4,y4,color)
    LineXY(x1,y1,x3,y3,color)
    LineXY(x2,y2,x4,y4,color)
    FillArea(x1+1,y1,color,color)
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