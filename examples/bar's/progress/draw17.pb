Macro _draw_v_progress_2(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _frame_color_, _frame_size_)
  If Not _round_
    Box(_x_ + _frame_size_, _y_ + _frame_size_, _width_ - _frame_size_*2, (_pos_) - _frame_size_)
  Else 
    If (_pos_) > _round_
      ; рисуем прямоуголную часть
      If _round_ > (_height_ - (_pos_))
        Box(_x_ + _frame_size_, _y_ + _round_, _width_ - _frame_size_*2, ((_pos_) - _frame_size_ - _round_) + (_height_ - _round_ - (_pos_)))
      Else
        Box(_x_ + _frame_size_, _y_ + _round_, _width_ - _frame_size_*2, ((_pos_) - _frame_size_ - _round_))
      EndIf
      
      For a = _frame_size_ To _round_
        For i = _frame_size_ To (_width_ - _frame_size_*2)
          If Point(_x_ + i, _y_ + a) & $FFFFFF = _frame_color_ & $FFFFFF
            Line(_x_ + i, _y_ + a, _width_ - i*2, 1)
            Break
          EndIf
        Next i
      Next a
      
      ; если позиция ползунка больше начало второго округленыя
      If _round_ > (_height_ - (_pos_))
        For a = (_height_ - _frame_size_ - _round_) To (_pos_) - _frame_size_
          For i = _frame_size_ To (_width_ - _frame_size_*2)
            If Point(_x_ + i, _y_ + a) & $FFFFFF = _frame_color_ & $FFFFFF
              Line(_x_ + i, _y_ + a, _width_ - i*2, 1)
              Break
            EndIf
          Next i
        Next a
      EndIf
      
    Else
      For a = _frame_size_ To (_pos_) + _frame_size_
        For i = _frame_size_ To (_width_ - _frame_size_*2)
          If Point(_x_ + i, _y_ + a) & $FFFFFF = _frame_color_ & $FFFFFF
            Line(_x_ + i, _y_ + a, _width_ - i*2, 1)
            Break
          EndIf
        Next i
      Next a
    EndIf
    
  EndIf 
  
EndMacro

Macro _draw_v_progress_1(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _frame_color_, _frame_size_)
  If Not _round_
    Box(_x_ + _frame_size_, _y_ + (_pos_), _width_ - _frame_size_*2, (_height_ - _frame_size_ - (_pos_)))
  Else 
    If (_height_ - (_pos_)) > _round_
      ; рисуем прямоуголную часть
      If _round_ > (_pos_)
        Box(_x_ + _frame_size_, _y_ + (_pos_) + (_round_ - (_pos_)), _width_ - _frame_size_*2, (_height_ - _round_ - (_pos_)) - (_round_ - (_pos_)))
      Else
        Box(_x_ + _frame_size_, _y_ + (_pos_), _width_ - _frame_size_*2, (_height_ - _round_ - (_pos_)))
      EndIf
      
      For a = (_height_ - _round_) To (_height_ - _frame_size_)
        For i = _frame_size_ To (_width_ - _frame_size_)
          If Point(_x_ + i, _y_ + a) & $FFFFFF = _frame_color_ & $FFFFFF
            Line(_x_ + i, _y_ + a, _width_ - i*2, 1)
            Break
          EndIf
        Next i
      Next a
      
      ; если позиция ползунка больше начало второго округленыя
      If _round_ > (_pos_)
        For a = _frame_size_ + (_pos_) To _round_
          For i = _frame_size_ To (_width_ - _frame_size_)
            If Point(_x_ + i, _y_ + a) & $FFFFFF = _frame_color_ & $FFFFFF
              Line(_x_ + i, _y_ + a, _width_ - i*2, 1)
              Break
            EndIf
          Next i
        Next a
      EndIf
      
    Else
      For a = (_pos_) - _frame_size_ To (_height_ - _frame_size_)
        For i = _frame_size_ To (_width_ - _frame_size_)
          If Point(_x_ + i, _y_ + a) & $FFFFFF = _frame_color_ & $FFFFFF
            Line(_x_ + i, _y_ + a, _width_ - i*2, 1)
            Break
          EndIf
        Next i
      Next a
    EndIf
  EndIf 
  
EndMacro

Macro _draw_h_progress_1(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _frame_color_, _frame_size_)
  If Not _round_
    Box(_x_ + _frame_size_, _y_ + _frame_size_, (_pos_) - _frame_size_, _height_ - _frame_size_*2)
  Else 
    If (_pos_) > _round_
      ; рисуем прямоуголную часть
      If _round_ > (_width_ - (_pos_))
        Box(_x_ + _round_, _y_ + _frame_size_, ((_pos_) - _frame_size_ - _round_) + (_width_ - _round_ - (_pos_)), _height_ - _frame_size_*2)
      Else
        Box(_x_ + _round_, _y_ + _frame_size_, ((_pos_) - _frame_size_ - _round_) , _height_ - _frame_size_*2)
      EndIf
      
      For a = _frame_size_ To _round_; + _frame_size_
        For i = _frame_size_ To (_height_ - _frame_size_*2)
          If Point(_x_ + a, _y_ + i) & $FFFFFF = _frame_color_ & $FFFFFF
            Line(_x_ + a, _y_ + i, 1, _height_ - i*2)
            Break
          EndIf
        Next i
      Next a
      
      ; если позиция ползунка больше начало второго округленыя
      If _round_ > (_width_ - (_pos_))
        For a = (_width_ - _frame_size_ - _round_) To (_pos_) - _frame_size_
          For i = _frame_size_ To (_height_ - _frame_size_*2)
            If Point(_x_ + a, _y_ + i) & $FFFFFF = _frame_color_ & $FFFFFF
              Line(_x_ + a, _y_ + i, 1, _height_ - i*2)
              Break
            EndIf
          Next i
        Next a
      EndIf
      
    Else
      For a = _frame_size_ To (_pos_) + _frame_size_
        For i = _frame_size_ To (_height_ - _frame_size_*2)
          If Point(_x_ + a, _y_ + i) & $FFFFFF = _frame_color_ & $FFFFFF
            Line(_x_ + a, _y_ + i, 1, (_height_) - i*2)
            Break
          EndIf
        Next i
      Next a
    EndIf
    
  EndIf 
EndMacro

Macro _draw_h_progress_2(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _frame_color_, _frame_size_)
  If Not _round_
    Box(_x_ + (_pos_), _y_ + _frame_size_, (_width_ - _frame_size_ - (_pos_)), _height_ - _frame_size_*2)
  Else 
    If (_width_ - (_pos_)) > _round_
      ; рисуем прямоуголную часть
      If _round_ > (_pos_)
        Box(_x_ + (_pos_) + (_round_ - (_pos_)), _y_ + _frame_size_, (_width_ - _round_ - (_pos_)) - (_round_ - (_pos_)), _height_ - _frame_size_*2)
      Else
        Box(_x_ + (_pos_), _y_ + _frame_size_, (_width_ - _round_ - (_pos_)), _height_ - _frame_size_*2)
      EndIf
      
      For a = (_width_ - _round_) To (_width_ - _frame_size_)
        For i = _frame_size_ To (_height_ - _frame_size_*2)
          If Point(_x_ + a, _y_ + i) & $FFFFFF = _frame_color_ & $FFFFFF
            Line(_x_ + a, _y_ + i, 1, (_height_) - i*2)
            Break
          EndIf
        Next i
      Next a
      
      ; если позиция ползунка больше начало второго округленыя
      If _round_ > (_pos_)
        For a = _frame_size_ + (_pos_) To _round_
          For i = _frame_size_ To (_height_ - _frame_size_*2)
            If Point(_x_ + a, _y_ + i) & $FFFFFF = _frame_color_ & $FFFFFF
              Line(_x_ + a, _y_ + i, 1, (_height_) - i*2)
              Break
            EndIf
          Next i
        Next a
      EndIf
      
    Else
      For a = (_pos_) - _frame_size_ To (_width_ - _frame_size_)
        For i = _frame_size_ To (_height_ - _frame_size_*2)
          If Point(_x_ + a, _y_ + i) & $FFFFFF = _frame_color_ & $FFFFFF
            Line(_x_ + a, _y_ + i, 1, (_height_) - i*2)
            Break
          EndIf
        Next i
      Next a
    EndIf
  EndIf 
  
EndMacro

Macro _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  ;https://www.purebasic.fr/english/viewtopic.php?f=13&t=75757&p=557936#p557936 ; thank you infratec
  ; BackColor(_fore_color1_)
  
  FrontColor($fff0f0f0)
  FrontColor(_frame_color_)
  DrawingMode(#PB_2DDrawing_Outlined)
  RoundBox(_x_, _y_, _width_, _height_, _round_,_round_)
  FrontColor(_frame_color_)
  RoundBox(_x_ + _frame_size_, _y_ + _frame_size_, _width_ - _frame_size_*2, _height_ - _frame_size_*2, _round_,_round_)
  RoundBox(_x_ + _frame_size_+1, _y_ + _frame_size_+1, _width_ - _frame_size_*2-2, _height_ - _frame_size_*2-2, _round_,_round_)
  ; ;   RoundBox(_x_ + _frame_size_+2, _y_ + _frame_size_+2, _width_ - _frame_size_*2-4, _height_ - _frame_size_*2-4, _round_,_round_)
  ;   
  ;   For i = 0 To 1
  ;     RoundBox(_x_ + (_frame_size_+i), _y_ + (_frame_size_+i), _width_ - (_frame_size_+i)*2, _height_ - (_frame_size_+i)*2, _round_,_round_)
  ;   Next
  
  If _vertical_
    If _gradient_
      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
      LinearGradient(_x_,_y_, (_x_ + _width_), _y_)
    Else
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
    EndIf 
    
    If Not _reverse_
      _pos_ = _height_ - _pos_
    EndIf
    
    BackColor(_fore_color1_)
    FrontColor(_back_color1_)
    _draw_v_progress_1(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _frame_color_, _frame_size_)
    
    BackColor(_fore_color2_)
    FrontColor(_back_color2_)
    _draw_v_progress_2(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _frame_color_, _frame_size_)
    
  Else
    If _gradient_
      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
      LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
    Else
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
    EndIf 
    
    If _reverse_
      _pos_ = _width_ - _pos_
    EndIf
    
    BackColor(_fore_color1_)
    FrontColor(_back_color1_)
    _draw_h_progress_1(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _frame_color_, _frame_size_)
    
    BackColor(_fore_color2_)
    FrontColor(_back_color2_)
    _draw_h_progress_2(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _frame_color_, _frame_size_)
    
  EndIf
EndMacro

OpenWindow(0, 100, 100, 300, 310, "2DDrawing Example", #PB_Window_SystemMenu)
If CreateImage(0, 300, 310) And StartDrawing(ImageOutput(0))
  Box(0, 0, 300, 310, RGB(255, 255, 255))
  
  _x_ = 30
  _width_ = 240
  _height_ = 50
  _gradient_ = 0
  _reverse_ = 0
  _vertical_ = 0
  _frame_size_ = 10
  
  _pos_ = 0
  _round_ = 50
  _fore_color1_ = $e0E9BA81
  _back_color1_ = $e0E89C3D
  _fore_color2_ = $e0F8F8F8
  _back_color2_ = $e0E2E2E2
  _frame_color_ = $e0303030
  
  _y_ = 10
  
  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  
  _y_ = 70
  _pos_ = 30
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  
  _y_ = 130
  _pos_ = 120
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  
  _y_ = 190
  _pos_ = 210
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  
  _y_ = 250
  _pos_ = 240
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  
  StopDrawing() 
  ImageGadget(0, 0, 0, 300, 300, ImageID(0))
EndIf

OpenWindow(10, 500, 100, 310, 300, "2DDrawing Example", #PB_Window_SystemMenu)
If CreateImage(10, 310, 300) And StartDrawing(ImageOutput(10))
  Box(0, 0, 310, 300, RGB(255, 255, 255))
  
  _y_ = 30
  _width_ = 50
  _height_ = 240
  _reverse_ = 0
  _vertical_ = 1
  _gradient_ = 1
  
  _pos_ = 0
  _round_ = 50
  _frame_color1_ = $f0E9BA81
  _back_color1_ = $f0E89C3D
  _frame_color2_ = $e0F8F8F8
  _back_color2_ = $e0E2E2E2
  
  _x_ = 10
  
  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  
  _x_ = 70
  _pos_ = 20
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  
  _x_ = 130
  _pos_ = 120
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  
  _x_ = 190
  _pos_ = 220
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  
  _x_ = 250
  _pos_ = 240
  _round_ = 50
  
  _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _fore_color1_, _fore_color2_, _back_color1_, _back_color2_, _frame_color_)
  
  StopDrawing() 
  ImageGadget(10, 0, 0, 300, 300, ImageID(10))
EndIf

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP