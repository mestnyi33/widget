Macro _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color_, _frame_color_)
  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
  RoundBox(_x_, _y_, _width_ ,_height_, _round_,_round_, _back_color_)
  
  ; DrawingMode(#PB_2DDrawing_XOr|#PB_2DDrawing_AlphaBlend)
  Line(_x_+(_pos_), _y_+1, 1, _height_-2, _frame_color_)
  
  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
  RoundBox(_x_, _y_, _width_ ,_height_, _round_,_round_, _frame_color_)
  
  FillArea(_x_+(_pos_)/2, _y_+_height_/2,  -1, _frame_color_) 
EndMacro


If OpenWindow(0, 0, 0, 300, 310, "2DDrawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If CreateImage(0, 300, 310) And StartDrawing(ImageOutput(0))
      Box(0, 0, 300, 310, RGB(255, 255, 255))
      
      _x_ = 30
      _width_ = 240
      _height_ = 50
      
      _pos_ = 0
      _round_ = 50
      _back_color_ = $ff00FF00
      _frame_color_ = $ff0000FF
      
      _y_ = 10
      
      _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color_, _frame_color_)
      
      _y_ = 70
      _pos_ = 10
      _round_ = 50
      _back_color_ = $ff00FF00
      _frame_color_ = $ff0000FF
      
      _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color_, _frame_color_)
      
      _y_ = 130
      _pos_ = 120
      _round_ = 0
      _back_color_ = $ff00FF00
      _frame_color_ = $ff0000FF
      
      _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color_, _frame_color_)
      
      _y_ = 190
      _pos_ = 230
      _round_ = 50
      _back_color_ = $ff00FF00
      _frame_color_ = $ff0000FF
      
      _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color_, _frame_color_)
      
      _y_ = 250
      _pos_ = 240
      _round_ = 50
      _back_color_ = $ff00FF00
      _frame_color_ = $ff0000FF
      
      _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color_, _frame_color_)
      
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