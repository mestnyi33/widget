Macro _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color_=0)
  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
  BackColor($FFFFFFFF)
  FrontColor(_back_color2_)
  LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
  RoundBox(_x_, _y_, _width_ ,_height_, _round_,_round_)
  
  If (_pos_)
    FrontColor(_back_color1_)
    
    For y = _y_ + 1 To _y_ + 1 + _height_ - 2
      For x = _x_ + 1 To _x_ + 1 + (_pos_)
        color = Point(x, y)
        
        If Red(color) < 255 Or
           Blue(color) < 255 Or
           Green(color) < 255 
          
          Plot(x, y)
        EndIf
      Next x
    Next y
  EndIf

  
  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
  RoundBox(_x_, _y_, _width_ ,_height_, _round_,_round_, _frame_color_)
EndMacro


If OpenWindow(0, 0, 0, 300, 310, "2DDrawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  If CreateImage(0, 300, 310) And StartDrawing(ImageOutput(0))
    Box(0, 0, 300, 310, RGB(255, 255, 255))
   
    _x_ = 30
    _width_ = 240
    _height_ = 50
    _round_ = 150
   
    _back_color1_ = $ff0000FF
    _back_color2_ = $ff00FF00
    _frame_color_ = $ffFF0000
   
    _pos_ = 0
    _y_ = 10
    
    
    _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color_)
   
    _pos_ = 5
    _y_ = 70
   
    _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color_)
   
    _pos_ = 10
    _y_ = 130
   
    _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color_)
   
    _pos_ = 20
    _y_ = 190
   
    _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color_)
   
    _pos_ = 30
    _y_ = 250
   
    _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color_)
   
    StopDrawing()
    ImageGadget(0, 0, 0, 300, 300, ImageID(0))
  EndIf
 
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP