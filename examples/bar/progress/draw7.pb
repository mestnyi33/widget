Macro _draw_v_progress_(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_)
  RoundBox(_x_, _y_, _width_ ,_height_, _round_, _round_)
  
  If (_pos_)
    For i = 0 To (_len_)
      If Point(_x_ + i, _y_ + (_pos_)) & $00FFFFFF = _color1_ & $00FFFFFF
        Line(_x_ + i, _y_ + (_pos_), (_len_) - i*2, 1, _color2_)
        Break
      EndIf
    Next i
    
    FillArea(_x_ + (_len_)/2, _y_ + (_pos_)/2,  -1, _color2_) 
  EndIf
EndMacro

Macro _draw_h_progress_(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_)
  
  FrontColor(_color2_)
  LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
  
  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
  RoundBox(_x_, _y_, _width_ ,_height_, _round_,_round_)
  
  If (_pos_)
   FrontColor(_color1_)
    
    For y = _y_ To _y_ + _height_
      For x = _x_ To (_x_ + (_pos_))
        color = Point(x, y)
        
        If Red(color) < 255 Or
           Blue(color) < 255 Or
           Green(color) < 255 
          
          Plot(x, y)
        EndIf
      Next x
    Next y
  EndIf
  
;   RoundBox(_x_, _y_, _width_ ,_height_, _round_, _round_)
;   
;   If (_pos_)
;     For y = _y_ + 1 To _y_ + 1 + _height_ - 2
;       For x = _x_ + 1 To _x_ + 1 + (_pos_)
;         color = Point(x, y)
;         
;         If Red(color) < 255 Or
;            Blue(color) < 255 Or
;            Green(color) < 255 
;           
;           Plot(x, y)
;         EndIf
;       Next x
;     Next y
;     
; ;     For i = _y_ To (_len_)
; ;       
; ;       If Point(_x_ + (_pos_), i) & $00FFFFFF = _color2_ & $00FFFFFF
; ;         Line(_x_ + (_pos_), i, 1, (_len_-_y_) - (i - _y_)*2, _color1_)
; ;         ;Plot(_x_ + (_pos_), i, _color1_)
; ;         Break
; ;       EndIf
; ;     Next i
; ;     
; ;     FillArea(_x_ + (_pos_)/2, _y_ + (_len_-_y_)/2,  -1, _color1_) 
;   EndIf
EndMacro

Macro _draw_h_progress_2(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_)
  FrontColor(_color1_)
  LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    
    For y = _y_ To _y_ + _height_
      For x = _x_ To (_x_ + (_pos_))
        color = Point(x, y)
        
        If Point(x, y) & $00FFFFFF = _color2_ & $00FFFFFF
        
          Plot(x, y)
        EndIf
      Next x
    Next y
EndMacro
Macro _draw_h_progress_3(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_)
  FrontColor(_color2_)
  LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    
    For y = _y_ To _y_ + _height_
      For x = _x_ + (_pos_) To _x_ + _width_
        color = Point(x, y)
        
        If color & $00FFFFFF = _color2_ & $00FFFFFF
        
          Plot(x, y)
        EndIf
      Next x
    Next y
EndMacro


Macro _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  ;https://www.purebasic.fr/english/viewtopic.php?f=13&t=75757&p=557936#p557936 ; thank you infratec
  If _vertical_
    If _reverse_
;       _pos_ = _height_ - _pos_
;       BackColor(_fore_color1_)
;       FrontColor(_frame_color1_)
;       LinearGradient(_x_,_y_, (_x_ + _width_), _y_)
;       _draw_v_progress_(_pos_, _width_, _x_, _y_, _width_ ,_height_, _round_, _frame_color1_, _frame_color2_)
;       
;       BackColor(_fore_color1_)
;       FrontColor(_back_color1_)
;       LinearGradient(_x_+1,_y_+1, (_x_+1 + _width_-2), _y_+1)
;       _draw_v_progress_(_pos_, _width_, _x_+1, _y_+1, _width_-2 ,_height_-2, _round_, _back_color1_, _back_color2_)
;       
    Else
      
      BackColor(_fore_color1_)
      FrontColor(_frame_color2_)
      ;LinearGradient(_x_,_y_, (_x_ + _width_), _y_)
      _draw_v_progress_(_pos_, _width_, _x_, _y_, _width_ ,_height_, _round_, _frame_color1_, _frame_color2_)
      
;       BackColor(_fore_color1_)
;       FrontColor(_back_color2_)
;       LinearGradient(_x_+1,_y_+1, (_x_+1 + _width_-2), _y_+1)
;       _draw_v_progress_(_pos_, _width_, _x_+1, _y_+1, _width_-2 ,_height_-2, _round_, _back_color1_, _back_color2_)
      
    EndIf
    
  Else
    If _reverse_
      _pos_ = _width_ - _pos_
      
;       ;BackColor(_fore_color1_)
;       FrontColor(_frame_color1_)
;       ;LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
;       _draw_h_progress_(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _frame_color1_, _frame_color2_)
;       
; ;       BackColor(_fore_color1_)
; ;       FrontColor(_back_color1_)
; ;       LinearGradient(_x_+1,_y_+1, _x_+1, (_y_+1 + _height_-2))
; ;       _draw_h_progress_(_pos_, _height_, _x_+1, _y_+1, _width_-2 ,_height_-2, _round_, _back_color1_, _back_color2_)
      
    Else
      
      BackColor(_fore_color1_)
      _draw_h_progress_(_pos_, _y_ + _height_, _x_, _y_, _width_ ,_height_, _round_, _frame_color1_, _frame_color2_)
      FrontColor(_back_color2_)
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox(_x_ + _frame_size_, _y_ + _frame_size_, _width_ - _frame_size_*2,_height_ - _frame_size_*2, _round_,_round_)
      
      _draw_h_progress_2(_pos_, _y_ + _height_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_)
      _draw_h_progress_3(_pos_, _y_ + _height_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_)
      ;_draw_h_progress_(_pos_, _y_ + 1 + _height_-2, _x_+5, _y_+5, _width_-10 ,_height_-10, _round_, _back_color1_, _back_color2_)
      
    EndIf
  EndIf
EndMacro

OpenWindow(0, 0, 0, 300, 310, "2DDrawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
If CreateImage(0, 300, 310) And StartDrawing(ImageOutput(0))
  Box(0, 0, 300, 310, RGB(255, 255, 255))
  
  _x_ = 30
  _width_ = 240
  _height_ = 50
  _reverse_ = 0
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
  _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _y_ = 70
  _pos_ = 10
  _round_ = 50
  
  _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _y_ = 130
  _pos_ = 120
  _round_ = 0
  
  _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _y_ = 190
  _pos_ = 230
  _round_ = 50
  
  _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  _y_ = 250
  _pos_ = 240
  _round_ = 50
  
  _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
  
  StopDrawing() 
  ImageGadget(0, 0, 0, 300, 300, ImageID(0))
EndIf

; ; ; OpenWindow(10, 0, 0, 310, 300, "2DDrawing Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
; ; ; If CreateImage(10, 310, 300) And StartDrawing(ImageOutput(10))
; ; ;   Box(0, 0, 310, 300, RGB(255, 255, 255))
; ; ;   
; ; ;   _y_ = 30
; ; ;   _width_ = 50
; ; ;   _height_ = 240
; ; ;   _reverse_ = 1
; ; ;   _vertical_ = 1
; ; ;   
; ; ;   _pos_ = 0
; ; ;   _round_ = 50
; ; ;   _back_color1_ = $ff0000FF
; ; ;   _back_color2_ = $ff00FF00
; ; ;   _frame_color1_ = $FFDC9338
; ; ;   _frame_color2_ = $FFCECECE
; ; ;   
; ; ;   _x_ = 10
; ; ;   
; ; ;   DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
; ; ;   _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
; ; ;   
; ; ;   _x_ = 70
; ; ;   _pos_ = 10
; ; ;   _round_ = 50
; ; ;   
; ; ;   _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
; ; ;   
; ; ;   _x_ = 130
; ; ;   _pos_ = 120
; ; ;   _round_ = 0
; ; ;   
; ; ;   _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
; ; ;   
; ; ;   _x_ = 190
; ; ;   _pos_ = 230
; ; ;   _round_ = 50
; ; ;   
; ; ;   _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
; ; ;   
; ; ;   _x_ = 250
; ; ;   _pos_ = 240
; ; ;   _round_ = 50
; ; ;   
; ; ;   _box_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_)
; ; ;   
; ; ;   StopDrawing() 
; ; ;   ImageGadget(10, 0, 0, 300, 300, ImageID(10))
; ; ; EndIf

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow

; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP