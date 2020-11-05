Macro _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color_=0)
  ;https://www.purebasic.fr/english/viewtopic.php?f=13&t=75757&p=557936#p557936 ; thank you infratec
  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
  RoundBox(_x_, _y_, _width_ ,_height_, _round_,_round_, _back_color2_)
  
    
   
  For i = 0 To _height_-2
    ;If Point(_x_+(_pos_), _y_+1+i) = _back_color2_
    If Point(_x_+(_pos_), _y_+1+i) & $00FFFFFF = _back_color2_ & $00FFFFFF
      Line(_x_+(_pos_), _y_+1+i, 1, _height_-2-i*2, _back_color1_)
      Break
      ;  Plot(_x_+(_pos_), _y_+1+i, _back_color1_)
    EndIf
  Next i
  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
   
;   DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
;   If _frame_color_
;     RoundBox(_x_, _y_, _width_ ,_height_, _round_,_round_, _frame_color_)
;   Else
;     RoundBox(_x_, _y_, _width_ ,_height_, _round_,_round_, _back_color1_)
;   EndIf
  
  FillArea(_x_+(_pos_)/2, _y_+_height_/2,  -1, _back_color1_) 
EndMacro

If OpenWindow(0, 0, 0, 300, 310, "2DDrawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  If CreateImage(0, 300, 310) And StartDrawing(ImageOutput(0))
    Box(0, 0, 300, 310, RGB(255, 255, 255))
    
    _x_ = 30
    _width_ = 240
    _height_ = 50
    
    _pos_ = 0
    _round_ = 50
    _back_color1_ = $ff0000FF
    _back_color2_ = $ff00FF00
    _frame_color_ = $ffFF0000
    
    _y_ = 10
    
    _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color_)
    
    _y_ = 70
    _pos_ = 10
    _round_ = 50
    
    _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color_)
    
    _y_ = 130
    _pos_ = 120
    _round_ = 0
    
    _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color_)
    
    _y_ = 190
    _pos_ = 230
    _round_ = 50
    
    _round_box_(_pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_);, _frame_color_)
    
    _y_ = 250
    _pos_ = 240
    _round_ = 50
    
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