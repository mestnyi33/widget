Macro _draw_v_progress_(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_, _frame_size_, _gradient_=1)
  FrontColor(_color1_)
  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
  RoundBox(_x_ + _frame_size_, _y_ + _frame_size_, _width_ - _frame_size_*2,_height_ - _frame_size_*2, _round_,_round_)
  
  If _gradient_
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    LinearGradient(_x_,_y_, (_x_ + _width_), _y_)
  EndIf
  
  FrontColor(_color2_)
  If (_height_ - _pos_)
    For i = 0 To (_len_)
      If Point(_x_ + i, _y_ + (_height_ - _pos_)) & $00FFFFFF = _color1_ & $00FFFFFF
        Line(_x_ + i, _y_ + (_height_ - _pos_), (_len_) - i*2, 1)
        Break
      EndIf
    Next i
    
    FillArea(_x_ + (_len_)/2, _y_ + (_height_ - _pos_)/2,  -1) 
  EndIf
  
  If _gradient_
    FrontColor(_color1_)
    If (_pos_)
      For i = 0 To (_len_)
        If Point(_x_ + i, _y_ + (_height_ - _pos_)) & $00FFFFFF = _color1_ & $00FFFFFF
          Line(_x_ + i, _y_ + (_height_ - _pos_), (_len_) - i*2, 1)
          Break
        EndIf
      Next i
      
      FillArea(_x_ + (_len_)/2, _y_ + (_height_ - _frame_size_) - 1,  -1) 
    EndIf
  EndIf
EndMacro

Macro _draw_h_progress_2(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_, _frame_size_, _gradient_=1)
  FrontColor(_color1_)
  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
  RoundBox(_x_ + _frame_size_, _y_ + _frame_size_, _width_ - _frame_size_*2,_height_ - _frame_size_*2, _round_,_round_)
  
  If _gradient_
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
  EndIf
  
  
  FrontColor(_color2_)
  For y = _y_ To _y_ + _height_
    For x = _x_ + (_pos_) To _x_ + _width_
      If Point(x, y) & $00FFFFFF = _color1_ & $00FFFFFF
        Plot(x, y)
      EndIf
    Next x
  Next y
  
 If _gradient_
    FrontColor(_color1_)
    For y = _y_ To _y_ + _height_
      For x = _x_ To (_x_ + (_pos_))
        If Point(x, y) & $00FFFFFF = _color1_ & $00FFFFFF
          Plot(x, y)
        EndIf
      Next x
    Next y
  EndIf
 EndMacro

Macro _draw_h_progress_(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_, _frame_size_, _gradient_=1)
  FrontColor(_color1_)
  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
  RoundBox(_x_ + _frame_size_, _y_ + _frame_size_, _width_ - _frame_size_*2,_height_ - _frame_size_*2, _round_,_round_)
  
  If _gradient_
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
  EndIf 
  
  FrontColor(_color2_)
  
  For i = 0 To (_len_)
    If Point(_x_ + (_pos_), _y_ + i) & $00FFFFFF = _color1_ & $00FFFFFF
      Line(_x_ + (_pos_), _y_ + i, 1, (_len_) - i*2)
      Break
    EndIf
  Next i
  
  If (_width_- ((_pos_) + 1)) > 0
   ;; FrontColor(_color2_)
      Debug " blue "
      Debug Str((_pos_) + 1) +" "+ Point(_x_ + (_pos_) + 1, _y_ + (_len_)/2)
      Debug Str(_pos_ + (_width_ - _pos_)/2) +" "+ Point(_x_ + ((_width_ - _pos_)/2), _y_ + (_len_)/2)
      If _width_/2 > _pos_
        FillArea(_x_ + ((_width_ - _pos_)/2 ), _y_ + (_len_)/2,  -1) 
      Else
        FillArea(_x_ + (_pos_) + 1, _y_ + (_len_)/2,  -1) 
  EndIf
EndIf
  
    If _gradient_ And ((_pos_) - 1) > 0
;       Debug " gray "
;       Debug Str((_pos_) - 1) +" "+ Point(_x_ + (_pos_) - 1, _y_ + (_len_)/2)
;       Debug Str((_pos_)/2) +" "+ Point(_x_ + (_pos_)/2, _y_ + (_len_)/2)
      
    FrontColor(_color1_)
  ;; FillArea(_x_ + (_pos_) - 1, _y_ + (_len_)/2,  -1) 
     FillArea(_x_ + (_pos_)/2, _y_ + (_len_)/2,  -1) 
  EndIf
  
EndMacro

Macro _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  ;https://www.purebasic.fr/english/viewtopic.php?f=13&t=75757&p=557936#p557936 ; thank you infratec
  BackColor(_fore_color1_)
  ClipOutput(_x_+150, _y_, _width_ ,_height_)
  ;ClipOutput(_x_, _y_, _width_-150 ,_height_)
  ;ClipOutput(_x_, _y_, _width_-110 ,_height_)
  ;ClipOutput(_x_+110, _y_, _width_ ,_height_)
  ;ClipOutput(_x_+50, _y_, _width_-100 ,_height_)
  
  If _vertical_
    If _reverse_
      _pos_ = _height_ - _pos_
      
      _draw_v_progress_(_pos_, _width_, _x_, _y_, _width_ ,_height_, _round_, _frame_color2_, _frame_color1_, 0, _gradient_)
      _draw_v_progress_(_pos_, _width_, _x_, _y_, _width_ ,_height_, _round_, _back_color2_, _back_color1_, _frame_size_, _gradient_)
    Else
      _draw_v_progress_(_pos_, _width_, _x_, _y_, _width_ ,_height_, _round_, _frame_color1_, _frame_color2_, 0, _gradient_)
      _draw_v_progress_(_pos_, _width_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_size_, _gradient_)
      
    EndIf
  Else
    If _reverse_
      _pos_ = _width_ - _pos_
      
      _draw_h_progress_(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _frame_color2_, _frame_color1_, 0, _gradient_)
      ;_draw_h_progress_(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _back_color2_, _back_color1_, _frame_size_, _gradient_)
    Else
      _draw_h_progress_(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _frame_color1_, _frame_color2_, 0, _gradient_)
      _draw_h_progress_(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_size_, _gradient_)
      
    EndIf
  EndIf
EndMacro

OpenWindow(0, 100, 100, 300, 310, "2DDrawing Example", #PB_Window_SystemMenu)
If CreateImage(0, 300, 310) And StartDrawing(ImageOutput(0))
  Box(0, 0, 300, 310, RGB(255, 255, 255))
  
  _x_ = 30
  _width_ = 240
  _height_ = 50
  _gradient_ = 1
  _reverse_ = 1
  _vertical_ = 0
  _frame_size_ = 5
  
  _pos_ = 0
  _round_ = 50
  _fore_color1_ = $fff0f0f0
  _fore_color2_ = $ffffffff
  
  _back_color1_ = $ff0000FF
  _back_color2_ = $ff00FF00
  _frame_color1_ = $FFDC9338
  _frame_color2_ = $FFCECECE
  
  _y_ = 10
  
  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _y_ = 70
  _pos_ = 10
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _y_ = 130
  _pos_ = 120
  _round_ = 0
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _y_ = 190
  _pos_ = 230
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _y_ = 250
  _pos_ = 240
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  StopDrawing() 
  ImageGadget(0, 0, 0, 300, 300, ImageID(0))
EndIf

OpenWindow(10, 500, 100, 310, 300, "2DDrawing Example", #PB_Window_SystemMenu)
If CreateImage(10, 310, 300) And StartDrawing(ImageOutput(10))
  Box(0, 0, 310, 300, RGB(255, 255, 255))
  
  _y_ = 30
  _width_ = 50
  _height_ = 240
  _vertical_ = 1
  
  _pos_ = 0
  _round_ = 50
  _back_color1_ = $ff0000FF
  _back_color2_ = $ff00FF00
  _frame_color1_ = $FFDC9338
  _frame_color2_ = $FFCECECE
  
  _x_ = 10
  
  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _x_ = 70
  _pos_ = 10
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _x_ = 130
  _pos_ = 120
  _round_ = 0
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _x_ = 190
  _pos_ = 230
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _x_ = 250
  _pos_ = 240
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  StopDrawing() 
  ImageGadget(10, 0, 0, 300, 300, ImageID(10))
EndIf

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP