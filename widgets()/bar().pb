CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/widgets()"
  XIncludeFile "../fixme(mac).pbi"
CompilerEndIf


CompilerIf Not Defined(constants, #PB_Module)
  XIncludeFile "../constants.pbi"
CompilerEndIf

CompilerIf Not Defined(structures, #PB_Module)
  XIncludeFile "../structures.pbi"
CompilerEndIf

CompilerIf Not Defined(colors, #PB_Module)
  XIncludeFile "../colors.pbi"
CompilerEndIf


CompilerIf Not Defined(Bar, #PB_Module)
  ;- >>>
  DeclareModule bar
  UseModule constants
  UseModule structures
  
  Macro _get_colors_()
    colors::*this\grey
  EndMacro
  
  Macro Root()
    *event\root
  EndMacro
  
  Macro Widget()
    *event\widget
  EndMacro
  
  Macro width(_this_)
    (Bool(Not _this_\hide) * _this_\width)
  EndMacro

  Macro height(_this_)
    (Bool(Not _this_\hide) * _this_\height)
  EndMacro

  Macro _is_scroll_(_this_)
    Bool(_this_\parent And _this_\parent\scroll And (_this_\parent\scroll\v = _this_ Or _this_ = _this_\parent\scroll\h))
  EndMacro
  
  Macro _scrolled_(_this_, _pos_, _len_)
    Bool(Bool(((_pos_+_this_\bar\min)-_this_\bar\page\pos) < 0 And 
              Bar::SetState(_this_, (_pos_+_this_\bar\min))) Or
         Bool(((_pos_+_this_\bar\min)-_this_\bar\page\pos) > (_this_\bar\page\len-(_len_)) And 
              Bar::SetState(_this_, (_pos_+_this_\bar\min)-(_this_\bar\page\len-(_len_)))))
  EndMacro
  
  Macro _get_scroll_pos_(_bar_, _thumb_pos_)
    ; _bar_\increment = (_bar_\area\len / (_bar_\max-_bar_\min))
    (_bar_\min + Round(((_thumb_pos_) - _bar_\area\pos) / _bar_\increment, #PB_Round_Nearest))
  EndMacro
  
  Macro _get_thumb_pos_(_bar_, _scroll_pos_)
    ; _bar_\increment = (_bar_\area\len / (_bar_\max-_bar_\min))
    (_bar_\area\pos + Round(((_scroll_pos_) - _bar_\min) * _bar_\increment, #PB_Round_Nearest)) 
  EndMacro
  
  Macro _get_thumb_len_(_bar_)
    ; _bar_\increment = (_bar_\area\len / (_bar_\max-_bar_\min))
    Round(_bar_\area\len - _bar_\increment * ((_bar_\max-_bar_\min) - _bar_\page\len), #PB_Round_Nearest)
  EndMacro
  
  Macro get_page_height(_scroll_, _round_ = 0)
    (_scroll_\v\bar\page\len + Bool(_round_ And _scroll_\v\round And _scroll_\h\round And Not _scroll_\h\hide) * (_scroll_\h\height/4)) 
  EndMacro
  
  Macro get_page_width(_scroll_, _round_ = 0)
    (_scroll_\h\bar\page\len + Bool(_round_ And _scroll_\v\round And _scroll_\h\round And Not _scroll_\v\hide) * (_scroll_\v\width/4))
  EndMacro
  
  Macro make_area_height(_scroll_, _width_, _height_)
    (_height_ - (Bool((_scroll_\width > _width_) Or Not _scroll_\h\hide) * _scroll_\h\height)) 
  EndMacro
  
  Macro make_area_width(_scroll_, _width_, _height_)
    (_width_ - (Bool((_scroll_\height > _height_) Or Not _scroll_\v\hide) * _scroll_\v\width))
  EndMacro
  
  ; Then scroll bar start position
  Macro _in_start_(_bar_) : Bool(_bar_\page\pos =< _bar_\min) : EndMacro
  
  ; Then scroll bar end position
  Macro _in_stop_(_bar_) : Bool(_bar_\page\pos >= (_bar_\max-_bar_\page\len)) : EndMacro
  
  ; Inverted scroll bar position
  Macro _invert_(_bar_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_bar_\min + (_bar_\max - _bar_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro _area_pos_(_this_)
    If _this_\bar\vertical
      _this_\bar\area\pos = _this_\y + _this_\bar\button[#__b_1]\len
      _this_\bar\area\len = _this_\height - (_this_\bar\button[#__b_1]\len + _this_\bar\button[#__b_2]\len)
    Else
      _this_\bar\area\len = _this_\width - (_this_\bar\button[#__b_1]\len + _this_\bar\button[#__b_2]\len)
      _this_\bar\area\pos = _this_\x + _this_\bar\button[#__b_1]\len
    EndIf
    
    _this_\bar\area\end = _this_\bar\area\pos + (_this_\bar\area\len - _this_\bar\thumb\len)
    _this_\bar\increment = (_this_\bar\area\len / (_this_\bar\max - _this_\bar\min))
  EndMacro
  
  
  ;   ;- GLOBALs
  Declare.b Draw(*this)
  
  Declare.b Update(*this)
  Declare.b Change(*bar, ScrollPos.f)
  Declare.b SetPos(*this, ThumbPos.i)
  Declare   ThumbPos(*this, _scroll_pos_)
  
  Declare.f GetState(*this)
  Declare.b SetState(*this, ScrollPos.f)
  Declare.l SetAttribute(*this, Attribute.l, Value.l)
  
  Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=7)
  Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0)
  Declare.i Spin(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0, increment.f=1.0)
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
  Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
  
  Declare.i create(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scrollstep.f=1.0)
  ;Declare.i create(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, round.l=0)
  Declare.b events(*this, EventType.l, mouse_x.l, mouse_y.l, wheel_x.b=0, wheel_y.b=0)
  
  Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
  Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
EndDeclareModule

Module bar
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _box_gradient_(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  EndMacro
  
  Procedure.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    Protected I
    
    If Not Length
      Style =- 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Style),(X+1+i)+Size,(Y+i-1)+(Style),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Style),((X+1+(Size))-i),(Y+i-1)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Style =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Style),(X+1+i),(Y+i)+(Style),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Style),((X+1+(Size*2))-i),(Y+i)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Style > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size))-i),((X+1)+i)+(Style),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Style),((Y+1)+i)+Size,((X+1)+i)+(Style),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Style =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Style > 0 : y-1 : x + 1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+1)+i)-(Style),((Y+1)+i),((X+1)+i)+(Style),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size*2))-i),((X+1)+i)+(Style),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x, y+i, Size+x, y+Length, Color)
            LineXY(x, y+Length*2-i, Size+x, y+Length, Color)
          Else
            LineXY(x+i/2-Bool(i=0), y+i, Size+x, y+Length, Color)
            LineXY(x+i/2-Bool(i=0), y+Length*2-i, Size+x, y+Length, Color)
          EndIf
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  ;-
  ; SCROLLBAR
  Macro _childrens_move_(_this_, _change_x_, _change_y_)
    ;Debug  Str(_this_\x-_this_\bs) +" "+ _this_\x[2]
    
    If ListSize(_this_\childrens())
      ForEach _this_\childrens()
        Resize(_this_\childrens(), 
               (_this_\childrens()\x-_this_\x-_this_\bs) + _change_x_,
               (_this_\childrens()\y-_this_\y-_this_\bs-_this_\__height) + _change_y_, 
               #PB_Ignore, #PB_Ignore)
      Next
    EndIf
  EndMacro
  
  Procedure.b splitter_size(*this._s_widget)
    If *this\splitter
      If *this\splitter\first
        If *this\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\bar\vertical
            ResizeGadget(*this\splitter\first, *this\bar\button[#__b_1]\x-*this\x, ((*this\bar\button[#__b_2]\height+*this\bar\thumb\len)-*this\bar\button[#__b_1]\y)-*this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
          Else
            ResizeGadget(*this\splitter\first, *this\bar\button[#__b_1]\x-*this\x, *this\bar\button[#__b_1]\y-*this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
          EndIf
        Else
          Resize(*this\splitter\first, *this\bar\button[#__b_1]\x-*this\x, *this\bar\button[#__b_1]\y-*this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
        EndIf
      EndIf
      
      If *this\splitter\second
        If *this\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\bar\vertical
            ResizeGadget(*this\splitter\second, *this\bar\button[#__b_2]\x-*this\x, ((*this\bar\button[#__b_1]\height+*this\bar\thumb\len)-*this\bar\button[#__b_2]\y)-*this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
          Else
            ResizeGadget(*this\splitter\second, *this\bar\button[#__b_2]\x-*this\x, *this\bar\button[#__b_2]\y-*this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
          EndIf
        Else
          Resize(*this\splitter\second, *this\bar\button[#__b_2]\x-*this\x, *this\bar\button[#__b_2]\y-*this\y, *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
        EndIf   
      EndIf   
    EndIf
  EndProcedure
  
  Macro _splitter_size_(_this_)
    If _this_\splitter
      If _this_\splitter\first
        If _this_\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And _this_\bar\vertical
            ResizeGadget(_this_\splitter\first, _this_\bar\button[#__b_1]\x, (_this_\bar\button[#__b_2]\height+_this_\bar\thumb\len)-_this_\bar\button[#__b_1]\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
          Else
            ResizeGadget(_this_\splitter\first, _this_\bar\button[#__b_1]\x, _this_\bar\button[#__b_1]\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
          EndIf
        Else
          Resize(_this_\splitter\first, _this_\bar\button[#__b_1]\x, _this_\bar\button[#__b_1]\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
        EndIf
      EndIf
      
      If _this_\splitter\second
        If _this_\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And _this_\bar\vertical
            ResizeGadget(_this_\splitter\second, _this_\bar\button[#__b_2]\x, (_this_\bar\button[#__b_1]\height+_this_\bar\thumb\len)-_this_\bar\button[#__b_2]\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
          Else
            ResizeGadget(_this_\splitter\second, _this_\bar\button[#__b_2]\x, _this_\bar\button[#__b_2]\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
          EndIf
        Else
          Resize(_this_\splitter\second, _this_\bar\button[#__b_2]\x, _this_\bar\button[#__b_2]\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
        EndIf   
      EndIf   
    EndIf
  EndMacro
  ;   Macro _splitter_size_(_this_)
  ;     ;     If _this_\bar\Vertical
  ;     ;       Resize(_this_\splitter\first, 0, 0, _this_\width, _this_\bar\thumb\pos-_this_\y)
  ;     ;       Resize(_this_\splitter\second, 0, (_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\y))
  ;     ;     Else
  ;     ;       Resize(_this_\splitter\first, 0, 0, _this_\bar\thumb\pos-_this_\x, _this_\height)
  ;     ;       Resize(_this_\splitter\second, (_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\x, 0, _this_\width-((_this_\bar\thumb\pos+_this_\bar\thumb\len)-_this_\x), _this_\height)
  ;     ;     EndIf
  ;     
  ;     Resize(_this_\splitter\first, _this_\bar\button[#__b_1]\x-_this_\x, _this_\bar\button[#__b_1]\y-_this_\y, _this_\bar\button[#__b_1]\width, _this_\bar\button[#__b_1]\height)
  ;     Resize(_this_\splitter\second, _this_\bar\button[#__b_2]\x-_this_\x, _this_\bar\button[#__b_2]\y-_this_\y, _this_\bar\button[#__b_2]\width, _this_\bar\button[#__b_2]\height)
  ;     
  ;   EndMacro
  
  Macro _text_change_(_this_, _x_, _y_, _width_, _height_)
    ;If _this_\text\vertical
    If _this_\text\rotate = 90
      If _this_\y<>_y_
        _this_\text\x = _x_ + _this_\y
      Else
        _this_\text\x = _x_ + (_width_-_this_\text\height)/2
      EndIf
      
      If _this_\text\align\right
        _this_\text\y = _y_ +_this_\text\align\height+ _this_\text\_padding+_this_\text\width
      ElseIf _this_\text\align\horizontal
        _this_\text\y = _y_ + (_height_+_this_\text\align\height+_this_\text\width)/2
      Else
        _this_\text\y = _y_ + _height_-_this_\text\_padding
      EndIf
      
    ElseIf _this_\text\rotate = 270
      _this_\text\x = _x_ + (_width_-_this_\y)
      
      If _this_\text\align\right
        _this_\text\y = _y_ + (_height_-_this_\text\width-_this_\text\_padding) 
      ElseIf _this_\text\align\horizontal
        _this_\text\y = _y_ + (_height_-_this_\text\width)/2 
      Else
        _this_\text\y = _y_ + _this_\text\_padding 
      EndIf
      
    EndIf
    
    ;Else
    If _this_\text\rotate = 0
      If _this_\x<>_x_
        _this_\text\y = _y_ + _this_\y
      Else
        _this_\text\y = _y_ + (_height_-_this_\text\height)/2
      EndIf
      
      If _this_\text\align\right
        _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width-_this_\text\_padding) 
      ElseIf _this_\text\align\horizontal
        _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width)/2
      Else
        _this_\text\x = _x_ + _this_\text\_padding
      EndIf
      
    ElseIf _this_\text\rotate = 180
      _this_\text\y = _y_ + (_height_-_this_\y)
      
      If _this_\text\align\right
        _this_\text\x = _x_ + _this_\text\_padding+_this_\text\width
      ElseIf _this_\text\align\horizontal
        _this_\text\x = _x_ + (_width_+_this_\text\width)/2 
      Else
        _this_\text\x = _x_ + _width_-_this_\text\_padding 
      EndIf
      
    EndIf
    ;EndIf
  EndMacro
  
  
  Procedure ThumbPos(*this._s_widget, _scroll_pos_)
    *this\bar\thumb\pos = _get_thumb_pos_(*this\bar, _scroll_pos_)
    
    If *this\bar\thumb\pos < *this\bar\area\pos 
      *this\bar\thumb\pos = *this\bar\area\pos 
    EndIf 
    
    If *this\bar\thumb\pos > *this\bar\area\end
      *this\bar\thumb\pos = *this\bar\area\end
    EndIf
    
    If *this\type = #PB_GadgetType_Spin
      If *this\bar\vertical 
        *this\bar\button\x = *this\X + *this\width - #__spin_buttonsize2
        *this\bar\button\width = #__spin_buttonsize2
      Else 
        *this\bar\button\y = *this\Y + *this\Height - #__spin_buttonsize2
        *this\bar\button\height = #__spin_buttonsize2 
      EndIf
    Else
      If *this\bar\vertical 
        *this\bar\button\x = *this\X + Bool(*this\type=#PB_GadgetType_ScrollBar) 
        *this\bar\button\width = *this\width - Bool(*this\type=#PB_GadgetType_ScrollBar) 
        *this\bar\button\y = *this\bar\area\pos
        *this\bar\button\height = *this\bar\area\len               
      Else 
        *this\bar\button\y = *this\Y + Bool(*this\type=#PB_GadgetType_ScrollBar) 
        *this\bar\button\height = *this\Height - Bool(*this\type=#PB_GadgetType_ScrollBar)  
        *this\bar\button\x = *this\bar\area\pos
        *this\bar\button\width = *this\bar\area\len
      EndIf
    EndIf
    
    ; _start_
    If *this\bar\button[#__b_1]\len 
      If _scroll_pos_ = *this\bar\min
        *this\bar\button[#__b_1]\color\state = #__s_3
        *this\bar\button[#__b_1]\interact = 0
      Else
        If *this\bar\button[#__b_1]\color\state <> #__s_2
          *this\bar\button[#__b_1]\color\state = #__s_0
        EndIf
        *this\bar\button[#__b_1]\interact = 1
      EndIf 
    EndIf
    
    If *this\type=#PB_GadgetType_ScrollBar Or 
       *this\type=#PB_GadgetType_Spin
      
      If *this\bar\vertical 
        ; Top button coordinate on vertical scroll bar
        *this\bar\button[#__b_1]\x = *this\bar\button\x
        *this\bar\button[#__b_1]\y = *this\Y 
        *this\bar\button[#__b_1]\width = *this\bar\button\width
        *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\len                   
      Else 
        ; Left button coordinate on horizontal scroll bar
        *this\bar\button[#__b_1]\x = *this\X 
        *this\bar\button[#__b_1]\y = *this\bar\button\y
        *this\bar\button[#__b_1]\width = *this\bar\button[#__b_1]\len 
        *this\bar\button[#__b_1]\height = *this\bar\button\height 
      EndIf
      
    ElseIf *this\type = #PB_GadgetType_TrackBar
    Else
      *this\bar\button[#__b_1]\x = *this\X
      *this\bar\button[#__b_1]\y = *this\Y
      
      If *this\bar\vertical
        *this\bar\button[#__b_1]\width = *this\width
        *this\bar\button[#__b_1]\height = *this\bar\thumb\pos-*this\y 
      Else
        *this\bar\button[#__b_1]\width = *this\bar\thumb\pos-*this\x 
        *this\bar\button[#__b_1]\height = *this\height
      EndIf
    EndIf
    
    ; _stop_
    If *this\bar\button[#__b_2]\len
      ; Debug ""+ Bool(*this\bar\thumb\pos = *this\bar\area\end) +" "+ Bool(_scroll_pos_ = *this\bar\page\end)
      If _scroll_pos_ = *this\bar\page\end
        *this\bar\button[#__b_2]\color\state = #__s_3
        *this\bar\button[#__b_2]\interact = 0
      Else
        If *this\bar\button[#__b_2]\color\state <> #__s_2
          *this\bar\button[#__b_2]\color\state = #__s_0
        EndIf
        *this\bar\button[#__b_2]\interact = 1
      EndIf 
    EndIf
    
    If *this\type = #PB_GadgetType_ScrollBar Or 
       *this\type = #PB_GadgetType_Spin
      If *this\bar\vertical 
        ; Botom button coordinate on vertical scroll bar
        *this\bar\button[#__b_2]\x = *this\bar\button\x
        *this\bar\button[#__b_2]\width = *this\bar\button\width
        *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\len 
        *this\bar\button[#__b_2]\y = *this\Y+*this\Height-*this\bar\button[#__b_2]\height
      Else 
        ; Right button coordinate on horizontal scroll bar
        *this\bar\button[#__b_2]\y = *this\bar\button\y
        *this\bar\button[#__b_2]\height = *this\bar\button\height
        *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len 
        *this\bar\button[#__b_2]\x = *this\X+*this\width-*this\bar\button[#__b_2]\width 
      EndIf
      
    ElseIf *this\type = #PB_GadgetType_TrackBar
    Else
      If *this\bar\vertical
        *this\bar\button[#__b_2]\x = *this\x
        *this\bar\button[#__b_2]\y = *this\bar\thumb\pos+*this\bar\thumb\len
        *this\bar\button[#__b_2]\width = *this\width
        *this\bar\button[#__b_2]\height = *this\height-(*this\bar\thumb\pos+*this\bar\thumb\len-*this\y)
      Else
        *this\bar\button[#__b_2]\x = *this\bar\thumb\pos+*this\bar\thumb\len
        *this\bar\button[#__b_2]\y = *this\Y
        *this\bar\button[#__b_2]\width = *this\width-(*this\bar\thumb\pos+*this\bar\thumb\len-*this\x)
        *this\bar\button[#__b_2]\height = *this\height
      EndIf
    EndIf
    
    ; Thumb coordinate on scroll bar
    If *this\bar\thumb\len
      ;       If *this\bar\button[#__b_3]\len <> *this\bar\thumb\len
      ;         *this\bar\button[#__b_3]\len = *this\bar\thumb\len
      ;       EndIf
      
      If *this\bar\vertical
        *this\bar\button[#__b_3]\x = *this\bar\button\x 
        *this\bar\button[#__b_3]\width = *this\bar\button\width 
        *this\bar\button[#__b_3]\y = *this\bar\thumb\pos
        *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
      Else
        *this\bar\button[#__b_3]\y = *this\bar\button\y 
        *this\bar\button[#__b_3]\height = *this\bar\button\height
        *this\bar\button[#__b_3]\x = *this\bar\thumb\pos 
        *this\bar\button[#__b_3]\width = *this\bar\thumb\len                                  
      EndIf
      
    Else
      If *this\type = #PB_GadgetType_Spin Or 
         *this\type = #PB_GadgetType_ScrollBar
        ; ????? ???? ???????
        If *this\bar\vertical
          *this\bar\button[#__b_2]\Height = *this\Height/2 
          *this\bar\button[#__b_2]\y = *this\y+*this\bar\button[#__b_2]\Height+Bool(*this\Height%2) 
          
          *this\bar\button[#__b_1]\y = *this\y 
          *this\bar\button[#__b_1]\Height = *this\Height/2
          
        Else
          *this\bar\button[#__b_2]\width = *this\width/2 
          *this\bar\button[#__b_2]\x = *this\x+*this\bar\button[#__b_2]\width+Bool(*this\width%2) 
          
          *this\bar\button[#__b_1]\x = *this\x 
          *this\bar\button[#__b_1]\width = *this\width/2
        EndIf
      EndIf
    EndIf
    
    If *this\type = #PB_GadgetType_Spin
      If *this\bar\vertical      
        ; Top button coordinate
        *this\bar\button[#__b_2]\y = *this\y+*this\height/2 + Bool(*this\height%2) 
        *this\bar\button[#__b_2]\height = *this\height/2 
        *this\bar\button[#__b_2]\width = *this\bar\button\len 
        *this\bar\button[#__b_2]\x = *this\x+*this\width-*this\bar\button\len
        
        ; Bottom button coordinate
        *this\bar\button[#__b_1]\y = *this\y 
        *this\bar\button[#__b_1]\height = *this\height/2 
        *this\bar\button[#__b_1]\width = *this\bar\button\len 
        *this\bar\button[#__b_1]\x = *this\x+*this\width-*this\bar\button\len                                 
      Else    
        ; Left button coordinate
        *this\bar\button[#__b_1]\y = *this\y 
        *this\bar\button[#__b_1]\height = *this\height 
        *this\bar\button[#__b_1]\width = *this\bar\button\len/2 
        *this\bar\button[#__b_1]\x = *this\x+*this\width-*this\bar\button\len    
        
        ; Right button coordinate
        *this\bar\button[#__b_2]\y = *this\y 
        *this\bar\button[#__b_2]\height = *this\height 
        *this\bar\button[#__b_2]\width = *this\bar\button\len/2 
        *this\bar\button[#__b_2]\x = *this\x+*this\width-*this\bar\button\len/2                               
      EndIf
    EndIf
    
    ; draw track bar coordinate
    If *this\type = #PB_GadgetType_TrackBar
      If *this\bar\vertical
        *this\bar\button[#__b_1]\width = 4
        *this\bar\button[#__b_2]\width = 4
        *this\bar\button[#__b_3]\width = *this\bar\button[#__b_3]\len+(Bool(*this\bar\button[#__b_3]\len<10)**this\bar\button[#__b_3]\len)
        
        *this\bar\button[#__b_1]\y = *this\Y
        *this\bar\button[#__b_1]\height = *this\bar\thumb\pos-*this\y + *this\bar\thumb\len/2
        
        *this\bar\button[#__b_2]\y = *this\bar\thumb\pos+*this\bar\thumb\len/2
        *this\bar\button[#__b_2]\height = *this\height-(*this\bar\thumb\pos+*this\bar\thumb\len/2-*this\y)
        
        If *this\bar\inverted
          *this\bar\button[#__b_1]\x = *this\x+6
          *this\bar\button[#__b_2]\x = *this\x+6
          *this\bar\button[#__b_3]\x = *this\bar\button[#__b_1]\x-*this\bar\button[#__b_3]\width/4-1- Bool(*this\bar\button[#__b_3]\len>10)
        Else
          *this\bar\button[#__b_1]\x = *this\x+*this\width-*this\bar\button[#__b_1]\width-6
          *this\bar\button[#__b_2]\x = *this\x+*this\width-*this\bar\button[#__b_2]\width-6 
          *this\bar\button[#__b_3]\x = *this\bar\button[#__b_1]\x-*this\bar\button[#__b_3]\width/2 + Bool(*this\bar\button[#__b_3]\len>10)
        EndIf
      Else
        *this\bar\button[#__b_1]\height = 4
        *this\bar\button[#__b_2]\height = 4
        *this\bar\button[#__b_3]\height = *this\bar\button[#__b_3]\len+(Bool(*this\bar\button[#__b_3]\len<10)**this\bar\button[#__b_3]\len)
        
        *this\bar\button[#__b_1]\x = *this\X
        *this\bar\button[#__b_1]\width = *this\bar\thumb\pos-*this\x + *this\bar\thumb\len/2
        
        *this\bar\button[#__b_2]\x = *this\bar\thumb\pos+*this\bar\thumb\len/2
        *this\bar\button[#__b_2]\width = *this\width-(*this\bar\thumb\pos+*this\bar\thumb\len/2-*this\x)
        
        If *this\bar\inverted
          *this\bar\button[#__b_1]\y = *this\y+*this\height-*this\bar\button[#__b_1]\height-6
          *this\bar\button[#__b_2]\y = *this\y+*this\height-*this\bar\button[#__b_2]\height-6 
          *this\bar\button[#__b_3]\y = *this\bar\button[#__b_1]\y-*this\bar\button[#__b_3]\height/2 + Bool(*this\bar\button[#__b_3]\len>10)
        Else
          *this\bar\button[#__b_1]\y = *this\y+6
          *this\bar\button[#__b_2]\y = *this\y+6
          *this\bar\button[#__b_3]\y = *this\bar\button[#__b_1]\y-*this\bar\button[#__b_3]\height/4-1- Bool(*this\bar\button[#__b_3]\len>10)
        EndIf
      EndIf
    EndIf
    
    ;     If *this\Scroll And *this\Scroll\v And *this\Scroll\h
    ;       *this\Scroll\x = *this\Scroll\h\x+*this\scroll\x
    ;       *this\Scroll\y = *this\Scroll\v\y+*this\scroll\y
    ;       *this\Scroll\width = *this\Scroll\h\bar\max
    ;       *this\Scroll\height = *this\Scroll\v\bar\max
    ;     EndIf
    
    If *this\Splitter 
      ; Splitter childrens auto resize       
      _splitter_size_(*this)
    EndIf
    
    If *this\bar\change
      If *this\text
        *this\text\change = 1
        *this\text\string = "%"+Str(*this\bar\page\Pos)
      EndIf
      
     If *this\parent And 
           *this\parent\scroll
          If *this\bar\vertical
            If *this\parent\scroll\v = *this
              *this\parent\change =- 1
              *this\parent\scroll\y =- *this\bar\page\pos
              ; ScrollArea childrens auto resize 
              _childrens_move_(*this\parent, 0, *this\bar\change)
            EndIf
          Else
            If *this\parent\scroll\h = *this
              *this\parent\change =- 1
              *this\parent\scroll\x =- *this\bar\page\pos
              ; ScrollArea childrens auto resize 
              _childrens_move_(*this\parent, *this\bar\change, 0)
            EndIf
          EndIf
        EndIf
        
       ;       ; bar change
      ;       Post(#PB_EventType_StatusChange, *this, *this\from, *this\bar\direction)
   EndIf
    
    ProcedureReturn *this\bar\thumb\pos
  EndProcedure
  
  Procedure.b Update(*this._s_widget)
    With *this
      If \bar\max >= \bar\page\len
        ; Get area screen coordinate 
        ; pos (x&y) And Len (width&height)
        _area_pos_(*this)
        
        ;
        If Not \bar\max And \width And \height And (\splitter Or \bar\page\pos) 
          \bar\max = \bar\area\len-\bar\button[#__b_3]\len
          
          If Not \bar\page\pos
            \bar\page\pos = (\bar\max)/2 - Bool((\splitter And \splitter\fixed = #__b_1))
          EndIf
          
          ;           ; if splitter fixed set splitter pos to center
          ;           If \splitter And \splitter\fixed = #__b_1
          ;             \splitter\fixed[\splitter\fixed] = \bar\page\pos
          ;           EndIf
          ;           If \splitter And \splitter\fixed = #__b_2
          ;             \splitter\fixed[\splitter\fixed] = \bar\area\len-\bar\page\pos-\bar\button[#__b_3]\len  + 1
          ;           EndIf
        EndIf
        
        If \splitter And Not (\splitter\g_first Or \splitter\g_second)
          If \splitter\fixed
            If \bar\area\len - \bar\button[#__b_3]\len > \splitter\fixed[\splitter\fixed] 
              \bar\page\pos = Bool(\splitter\fixed = 2) * \bar\max
              
              If \splitter\fixed[\splitter\fixed] > \bar\button[#__b_3]\len
                \bar\area\pos + \splitter\fixed[1]
                \bar\area\len - \splitter\fixed[2]
              EndIf
            Else
              \splitter\fixed[\splitter\fixed] = \bar\area\len - \bar\button[#__b_3]\len
              \bar\page\pos = Bool(\splitter\fixed = 1) * \bar\max
            EndIf
          EndIf
          
          ; Debug ""+\bar\area\len +" "+ Str(\bar\button[#__b_1]\len + \bar\button[#__b_2]\len)
          
          If \bar\area\len =< \bar\button[#__b_3]\len
            \bar\page\pos = \bar\max/2
            
            If \bar\vertical
              \bar\area\pos = \Y 
              \bar\area\len = \Height
            Else
              \bar\area\pos = \X
              \bar\area\len = \width 
            EndIf
          EndIf
          
        EndIf
        
        If \bar\area\len > \bar\button[#__b_3]\len
          \bar\thumb\len = _get_thumb_len_(\bar)
          
          If \bar\thumb\len > \bar\area\len 
            \bar\thumb\len = \bar\area\len 
          EndIf 
          
          If \bar\thumb\len > \bar\button[#__b_3]\len
            \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)
          Else
            \bar\area\len = \bar\area\len - (\bar\button[#__b_3]\len-\bar\thumb\len)
            \bar\area\end = \bar\area\pos + (\bar\area\len-\bar\thumb\len)                              
            \bar\thumb\len = \bar\button[#__b_3]\len
          EndIf
          
        Else
          If \splitter
            \bar\thumb\len = \width
          Else
            \bar\thumb\len = 0
          EndIf
          
          If \bar\vertical
            \bar\area\pos = \Y
            \bar\area\len = \Height
          Else
            \bar\area\pos = \X
            \bar\area\len = \width 
          EndIf
          
          \bar\area\end = \bar\area\pos + (\bar\area\len - \bar\thumb\len)
        EndIf
        
        If \bar\area\len 
          \bar\page\end = \bar\max - \bar\page\len
          \bar\increment = (\bar\area\len / (\bar\max - \bar\min))
          \bar\thumb\pos = ThumbPos(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
          
          If #PB_GadgetType_ScrollBar = \type And \bar\thumb\pos = \bar\area\end And \bar\page\pos <> \bar\page\end And _in_stop_(\bar)
            ;    Debug " line-" + #PB_compiler_line +" "+  \bar\max 
            ;             If \bar\inverted
            ;              SetState(*this, _invert_(*this\bar, \bar\max, \bar\inverted))
            ;             Else
            SetState(*this, \bar\page\end)
            ;             EndIf
          EndIf
        EndIf
      EndIf
        
      If \type = #PB_GadgetType_ScrollBar
        \bar\hide = Bool(Not (\bar\max > \bar\page\len))
          
          If \bar\hide
            \bar\page\pos = \bar\min
            \bar\thumb\pos = ThumbPos(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
          EndIf
      EndIf
      
      ProcedureReturn \bar\hide
    EndWith
  EndProcedure
  
  Procedure.b Change(*bar._s_bar, ScrollPos.f)
    With *bar
      If ScrollPos < \min 
        ScrollPos = \min 
        
      ElseIf \max And ScrollPos > \max-\page\len
        If \max > \page\len 
          ScrollPos = \max-\page\len
        Else
          ScrollPos = \min 
        EndIf
      EndIf
      
      If \page\pos <> ScrollPos
       ; Debug  "   "+ScrollPos
       \change = \page\pos - ScrollPos
        
        If \page\pos > ScrollPos
          \direction =- ScrollPos
          
          If ScrollPos = \min Or \mode = #PB_TrackBar_Ticks 
            \button[#__b_3]\arrow\direction = Bool(Not \vertical) + Bool(\vertical = \inverted) * 2
          Else
            \button[#__b_3]\arrow\direction = Bool(\vertical) + Bool(\inverted) * 2
          EndIf
        Else
          \direction = ScrollPos
          
          If ScrollPos = \page\end Or \mode = #PB_TrackBar_Ticks
            \button[#__b_3]\arrow\direction = Bool(Not \vertical) + Bool(\vertical = \inverted) * 2
          Else
            \button[#__b_3]\arrow\direction = Bool(\vertical) + Bool(Not \inverted ) * 2
          EndIf
        EndIf
        
        \page\pos = ScrollPos
        ProcedureReturn #True
      EndIf
    EndWith
  EndProcedure
  
  Procedure.b SetPos(*this._s_widget, ThumbPos.i)
    With *this
      If \splitter And \splitter\fixed
        _area_pos_(*this)
      EndIf
      
      If ThumbPos < \bar\area\pos : ThumbPos = \bar\area\pos : EndIf
      If ThumbPos > \bar\area\end : ThumbPos = \bar\area\end : EndIf
      
      If \bar\thumb\end <> ThumbPos 
        \bar\thumb\end = ThumbPos
        
        If \bar\area\end <> ThumbPos
          ProcedureReturn SetState(*this, _invert_(\bar, _get_scroll_pos_(\bar, ThumbPos), \bar\inverted))
        Else
          ProcedureReturn SetState(*this, _invert_(\bar, \bar\page\end, \bar\inverted))
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.f GetState(*this._s_widget)
    ProcedureReturn *this\bar\page\pos
  EndProcedure
    
  Procedure.b SetState(*this._s_widget, ScrollPos.f)
    Protected Result.b
    
    With *this

    If change(*this\bar, ScrollPos)
        \bar\thumb\pos = ThumbPos(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
        
        If \splitter And \splitter\fixed = #__b_1
          \splitter\fixed[\splitter\fixed] = \bar\thumb\pos - \bar\area\pos
          \bar\page\pos = 0
        EndIf
        If \splitter And \splitter\fixed = #__b_2
          \splitter\fixed[\splitter\fixed] = \bar\area\len - ((\bar\thumb\pos+\bar\thumb\len)-\bar\area\pos)
          \bar\page\pos = \bar\max
        EndIf
        
        ;\change = #True
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*this._s_widget, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      If \splitter
        Select Attribute
          Case #PB_Splitter_FirstMinimumSize
            \bar\button[#__b_1]\len = Value
            Result = Bool(\bar\max)
            
          Case #PB_Splitter_SecondMinimumSize
            \bar\button[#__b_2]\len = Value
            Result = Bool(\bar\max)
            
            
        EndSelect
        
      Else
        Select Attribute
          Case #__bar_minimum
            If \bar\min <> Value
              \bar\min = Value
              \bar\page\pos = Value
              ;Debug  " min "+\bar\min+" max "+\bar\max
              Result = #True
            EndIf
            
          Case #__bar_maximum
            If \bar\max <> Value
              If \bar\min > Value
                \bar\max = \bar\min + 1
              Else
                \bar\max = Value
              EndIf
              
              If Not \bar\max
                \bar\page\pos = \bar\max
              EndIf
              ;Debug  "   min "+\bar\min+" max "+\bar\max
              
              \bar\change = #True
              Result = #True
            EndIf
            
          Case #__bar_pagelength
            If \bar\page\len <> Value
              \bar\page\len = Value
              
              If Not \bar\max
                If \bar\min > Value
                  \bar\max = \bar\min + 1
                Else
                  \bar\max = Value
                EndIf
              EndIf
              
              Result = #True
            EndIf
            
          Case #__bar_buttonsize
            If \bar\button[#__b_3]\len <> Value
              \bar\button[#__b_3]\len = Value
              
              If \type = #PB_GadgetType_ScrollBar
                \bar\button[#__b_1]\len = Value
                \bar\button[#__b_2]\len = Value
              EndIf
              
              Result = #True
            EndIf
            
          Case #__bar_inverted
            \bar\inverted = Bool(Value)
            
          Case #__bar_scrollstep 
            \bar\scrollstep = Value
            
        EndSelect
      EndIf
      
      If Result ; And \width And \height ; есть проблемы с imagegadget и scrollareagadget
        ;\bar\change = #True
        ;Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
        \hide = update(*this)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure.b Resize(*this._s_widget, X.l,Y.l,Width.l,Height.l)
    With *this
      If X <> #PB_Ignore : \x = X : EndIf 
      If Y <> #PB_Ignore : \y = Y : EndIf 
      If Width <> #PB_Ignore : \width = Width : EndIf 
      If Height <> #PB_Ignore : \height = height : EndIf
      
      ProcedureReturn update(*this)
    EndWith
  EndProcedure
  
  Procedure.b _Resize(*this._s_widget, X.l,Y.l,Width.l,Height.l)
    Protected Lines.i, Change_x, Change_y, Change_width, Change_height
    
    If *this > 0
      With *this
        ; #__flag_autoSize
        If \parent And \parent\type <> #PB_GadgetType_Splitter And \align And \align\autoSize And \align\left And \align\top And \align\right And \align\bottom
          X = 0; \align\width
          Y = 0; \align\height
          Width = \parent\width[#__c_2] ; - \align\width
          Height = \parent\height[#__c_2] ; - \align\height
        EndIf
        
        ;         ; Resize vertical&horizontal scrollbar
        ;         If (\scroll And \scroll\v And \scroll\h)
        ;           ; Bar_resizes(\scroll, x,y, width,height)
        ;           Bar_resizes(\scroll, x,y, width-\bs*2,height-\bs*2)
        ;         EndIf
        
        ;         ; Set widget coordinate
        ;         If X<>#PB_Ignore : If \parent : \x[#__c_3] = X : X+\parent\x+\parent\bs : EndIf : If \x <> X : Change_x = x-\x : \x = X : \x[#__c_2] = \x+\bs : \x[#__c_1] = \x[#__c_2]-\fs : \resize | 1<<1 : EndIf : EndIf  
        ;         If Y<>#PB_Ignore : If \parent : \y[#__c_3] = Y : Y+\parent\y+\parent\bs+\parent\__height : EndIf : If \y <> Y : Change_y = y-\y : \y = Y : \y[#__c_2] = \y+\bs+\__height : \y[#__c_1] = \y[#__c_2]-\fs : \resize | 1<<2 : EndIf : EndIf  
        ;         
        ;         If IsRoot(*this)
        ;           If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width : \width[#__c_2] = \width-\bs*2 : \width[#__c_1] = \width[#__c_2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
        ;           If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height : \height[#__c_2] = \height-\bs*2-\__height-\__height : \height[#__c_1] = \height[#__c_2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        ;         Else
        ;           If Width<>#PB_Ignore : If \width <> Width : Change_width = width-\width : \width = Width+Bool(\type=-1)*(\bs*2) : \width[#__c_2] = width-Bool(\type<>-1)*(\bs*2) : \width[#__c_1] = \width[#__c_2]+\fs*2 : \resize | 1<<3 : EndIf : EndIf  
        ;           If Height<>#PB_Ignore : If \height <> Height : Change_height = height-\height : \height = Height+Bool(\type=-1)*(\__height+\bs*2) : \height[#__c_2] = height-Bool(\type<>-1)*(\__height+\bs*2) : \height[#__c_1] = \height[#__c_2]+\fs*2 : \resize | 1<<4 : EndIf : EndIf 
        ;         EndIf
        
        
        ; Set widget coordinate
        If X<>#PB_Ignore 
          If \parent 
            \x[#__c_3] = X 
            X+\parent\x+\parent\bs 
          EndIf 
          
          If \x <> X 
            Change_x = x-\x 
            \x = X 
            \x[#__c_2] = \x+\bs 
            \x[#__c_1] = \x[#__c_2]-\fs 
            \resize | 1<<1 
          EndIf 
        EndIf  
        
        If Y<>#PB_Ignore 
          If \parent 
            \y[#__c_3] = Y 
            Y+\parent\y+\parent\bs+\parent\__height 
          EndIf 
          
          If \y <> Y 
            Change_y = y-\y 
            \y = Y 
            \y[#__c_2] = \y+\bs+\__height 
            \y[#__c_1] = \y[#__c_2]-\fs 
            \resize | 1<<2 
          EndIf 
        EndIf  
        
        If *this And *this = *this\root ; IsRoot(*this)
          If Width <> #PB_Ignore 
            If \width <> Width 
              Change_width = width-\width 
              \width = Width 
              \width[#__c_2] = \width-\bs*2 
              \width[#__c_1] = \width[#__c_2]+\fs*2 
              \resize | 1<<3 
            EndIf 
          EndIf  
          
          If Height <> #PB_Ignore 
            If \height <> Height 
              Debug "root resize height"
              
              Change_height = height-\height 
              \height = Height 
              \height[#__c_2] = height-\bs*2-\__height ; -\__height 
              \height[#__c_1] = \height[#__c_2]+\fs*2 
              \resize | 1<<4 
            EndIf 
          EndIf 
          
        Else
          If Width <> #PB_Ignore 
            If \width <> Width 
              Change_width = width-\width 
              \width = Width+Bool(\type=-1)*(\bs*2) 
              \width[#__c_2] = width-Bool(\type<>-1)*(\bs*2) 
              \width[#__c_1] = \width[#__c_2]+\fs*2 
              \resize | 1<<3 
            EndIf 
          EndIf  
          
          If Height <> #PB_Ignore 
            If \height <> Height 
              Change_height = height-\height 
              \height = Height+Bool(\type=-1)*(\__height+\bs*2) 
              \height[#__c_2] = height-Bool(\type<>-1)*(\__height+\bs*2) 
              \height[#__c_1] = \height[#__c_2]+\fs*2 
              \resize | 1<<4 
              
              If Bool(\type=-1)
                Debug "resize window height "+\height +" "+ \height[#__c_2]
              EndIf
            EndIf 
          EndIf 
        EndIf
        
        ; Resize vertical&horizontal scrollbars
        If (\scroll And \scroll\v And \scroll\h)
          Bar::resizes(\scroll, 0,0, width-\bs*2, height-\bs*2-\__height)
          
          ;  Bar_SetAttribute(\scroll\h, #__bar_maximum, \scroll\width)
          ;           ;Bar_resizes(\scroll, 0,0, \width[#__c_2],\height[#__c_2])
          \width[#__c_2] = \scroll\h\bar\page\len
          \height[#__c_2] = \scroll\v\bar\page\len
          
          ;           If StartDrawing(CanvasOutput(*this\root\canvas))
          ;             _tree_items_update_(*this, *this\row\_s())
          ;             StopDrawing()
          ;           EndIf
          
        EndIf
        
        
            
            update(*this)
            
        
        ; set clip coordinate
        If Not (*this And *this = *this\root) And *this\parent 
          Protected clip_v, clip_h, clip_x, clip_y, clip_width, clip_height
          
          If \parent\scroll 
            If \parent\scroll\v : clip_v = Bool(\parent\width=\parent\width[#__c_4] And Not \parent\scroll\v\hide And \parent\scroll\v\type = #PB_GadgetType_ScrollBar)*\parent\scroll\v\width : EndIf
            If \parent\scroll\h : clip_h = Bool(\parent\height=\parent\height[#__c_4] And Not \parent\scroll\h\hide And \parent\scroll\h\type = #PB_GadgetType_ScrollBar)*\parent\scroll\h\height : EndIf
          EndIf
          
          clip_x = \parent\x[#__c_4]+Bool(\parent\x[#__c_4]<\parent\x+\parent\bs)*\parent\bs
          clip_y = \parent\y[#__c_4]+Bool(\parent\y[#__c_4]<\parent\y+\parent\bs)*(\parent\bs+\parent\__height) 
          clip_width = ((\parent\x[#__c_4]+\parent\width[#__c_4])-Bool((\parent\x[#__c_4]+\parent\width[#__c_4])>(\parent\x[#__c_2]+\parent\width[#__c_2]))*\parent\bs)-clip_v 
          clip_height = ((\parent\y[#__c_4]+\parent\height[#__c_4])-Bool((\parent\y[#__c_4]+\parent\height[#__c_4])>(\parent\y[#__c_2]+\parent\height[#__c_2]))*\parent\bs)-clip_h 
        EndIf
        
        If clip_x And \x < clip_x : \x[#__c_4] = clip_x : Else : \x[#__c_4] = \x : EndIf
        If clip_y And \y < clip_y : \y[#__c_4] = clip_y : Else : \y[#__c_4] = \y : EndIf
        If clip_width And (\x+\width) > clip_width : \width[#__c_4] = clip_width - \x[#__c_4] : Else : \width[#__c_4] = \width - (\x[#__c_4]-\x) : EndIf
        If clip_height And (\y+\height) > clip_height : \height[#__c_4] = clip_height - \y[#__c_4] : Else : \height[#__c_4] = \height - (\y[#__c_4]-\y) : EndIf
        
        ; Debug ""+height+" "+\height[#__c_0]+" "+\height[#__c_1]+" "+\height[#__c_2]+" "+\height[#__c_3]+" "+\height[#__c_4]
        
        ;         ; Resize vertical&horizontal scrollbar
        ;         If (\scroll And \scroll\v And \scroll\h)
        ;           Bar_resizes(\scroll, 0,0, \width[#__c_2],\height[#__c_2])
        ;           ;           If StartDrawing(CanvasOutput(*this\root\canvas))
        ;           ;             _tree_items_update_(*this, *this\row\_s())
        ;           ;             StopDrawing()
        ;           ;           EndIf
        ;           
        ;         EndIf
        ;         
        ; Resize childrens
        If \count\childrens
          If \type = #PB_GadgetType_Splitter
            _splitter_size_(*this)
          Else
            ForEach \childrens()
              If \childrens()\align
                If \childrens()\align\horizontal
                  x = (\width[#__c_2] - (\childrens()\align\width+\childrens()\width))/2
                ElseIf \childrens()\align\right And Not \childrens()\align\left
                  x = \width[#__c_2] - \childrens()\align\width
                Else
                  If \x[#__c_2]
                    x = (\childrens()\x-\x[#__c_2]) + Change_x 
                  Else
                    x = 0
                  EndIf
                EndIf
                
                If \childrens()\align\Vertical
                  y = (\height[#__c_2] - (\childrens()\align\height+\childrens()\height))/2 
                ElseIf \childrens()\align\bottom And Not \childrens()\align\top
                  y = \height[#__c_2] - \childrens()\align\height
                Else
                  If \y[#__c_2]
                    y = (\childrens()\y-\y[#__c_2]) + Change_y 
                  Else
                    y = 0
                  EndIf
                EndIf
                
                If \childrens()\align\top And \childrens()\align\bottom
                  Height = \height[#__c_2] - \childrens()\align\height
                Else
                  Height = #PB_Ignore
                EndIf
                
                If \childrens()\align\left And \childrens()\align\right
                  Width = \width[#__c_2] - \childrens()\align\width
                Else
                  Width = #PB_Ignore
                EndIf
                
                Resize(\childrens(), x, y, Width, Height)
              Else
                Resize(\childrens(), (\childrens()\x-\x[#__c_2]) + Change_x, (\childrens()\y-\y[#__c_2]) + Change_y, #PB_Ignore, #PB_Ignore)
              EndIf
            Next
          EndIf
        EndIf
        
;         ; anchors widgets
;         If *this And (\root And \root\anchor And \root\anchor\widget = *this)
;           a_resize(*this)
;         EndIf
;         
        If \type = #PB_GadgetType_ScrollBar
          ProcedureReturn \bar\hide
          
        ElseIf (Change_x Or Change_y Or Change_width Or Change_height)
          ProcedureReturn 1
        EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.b edit_Resizes(*scroll._s_scroll, X.l,Y.l,Width.l,Height.l)
    With *scroll
      Protected iHeight, iWidth
      
      If Not *scroll\v Or Not *scroll\h
        ProcedureReturn
      EndIf
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - (Bool(Not \h\hide) * \h\height) + Bool(\v\bar\min<0) * \v\bar\min
      iWidth = Width - (Bool(Not \v\hide) * \v\width) + Bool(\h\bar\min<0) * \h\bar\min 
      
      If \v\bar\page\len <> iHeight 
        bar::SetAttribute(\v, #__bar_pageLength, iHeight) 
      EndIf
      If \h\bar\page\len <> iWidth 
        bar::SetAttribute(\h, #__bar_pageLength, iWidth) 
      EndIf
      
      \v\hide = bar::Resize(\v, Width+x-\v\width, y, #PB_Ignore, ((\h\y + Bool(\h\hide) * \h\height)-\v\y) + Bool(\v\round And \h\round And Not \h\hide)*(\h\height/4))
      \h\hide = bar::Resize(\h, x, Height+y-\h\height, ((\v\x + Bool(\v\hide) * \v\width)-\h\x) + Bool(\v\round And \h\round And Not \v\hide)*(\v\width/4), #PB_Ignore)
      
;       iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height + \v\bar\min
;       iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width + \h\bar\min
;       
;       If \v\bar\page\len <> iHeight 
;         bar::SetAttribute(\v, #__bar_pageLength, iHeight) 
;       EndIf
;       If \h\bar\page\len <> iWidth 
;         bar::SetAttribute(\h, #__bar_pageLength, iWidth) 
;       EndIf
;       
;       \v\hide = bar::Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((\h\y + Bool(\h\hide) * \h\height)-\v\y) + Bool(\v\round And \h\round And Not \h\hide)*(\h\height/4))
;       \h\hide = bar::Resize(\h, #PB_Ignore, #PB_Ignore, ((\v\x + Bool(\v\hide) * \v\width)-\h\x) + Bool(\v\round And \h\round And Not \v\hide)*(\v\width/4), #PB_Ignore)
     
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  Procedure.b edit2_Resizes(*scroll._s_scroll, X.l,Y.l,Width.l,Height.l)
    With *scroll
      Protected iHeight, iWidth
      
      If Not *scroll\v Or Not *scroll\h
        ProcedureReturn
      EndIf
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
           
      Bar::SetAttribute(*scroll\v, #__bar_pagelength, make_area_height(*scroll, Width, Height))
      *scroll\v\hide = Bar::Resize(*scroll\v, Width+x-*scroll\v\width, y, #PB_Ignore, get_page_height(*scroll, 1))
      
      Bar::SetAttribute(*scroll\h, #__bar_pagelength, make_area_width(*scroll, Width, Height))
      *scroll\h\hide = Bar::Resize(*scroll\h, x, Height+y-*scroll\h\height, get_page_width(*scroll, 1), #PB_Ignore)
      
      If Bar::SetAttribute(*scroll\v, #__bar_pagelength, make_area_height(*scroll, Width, Height))
        *scroll\v\hide = Bar::Resize(*scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, get_page_height(*scroll, 1))
      EndIf
      
      If Bar::SetAttribute(*scroll\h, #__bar_pagelength, make_area_width(*scroll, Width, Height))
        *scroll\h\hide = Bar::Resize(*scroll\h, #PB_Ignore, #PB_Ignore, get_page_width(*scroll, 1), #PB_Ignore)
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  Procedure.b Resizes(*scroll._s_scroll, X.l,Y.l,Width.l,Height.l)
    ProcedureReturn edit2_Resizes(*scroll, X,Y,Width,Height)
    
    
    With *scroll
      Protected iHeight, iWidth
      
      If Not *scroll\v Or Not *scroll\h
        ProcedureReturn
      EndIf
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width 
      
      If \v\bar\page\len<>iHeight : SetAttribute(\v, #__bar_pageLength, iHeight) : EndIf
      If \h\bar\page\len<>iWidth : SetAttribute(\h, #__bar_pageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\bar\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\bar\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\bar\page\len<>iHeight : SetAttribute(\v, #__bar_pageLength, iHeight) : EndIf
      If \h\bar\page\len<>iWidth : SetAttribute(\h, #__bar_pageLength, iWidth) : EndIf
      
      If \v\bar\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\bar\page\len) : EndIf
      If \h\bar\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\bar\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\round And \h\round)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\round And \h\round)*(\h\height/4))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  
  ;-
  Procedure.b Post(eventtype.l, *this._s_widget, item.l=#PB_All, *data=0)
    If *this\event And 
       (*this\event\type = #PB_All Or 
        *this\event\type = eventtype)
      
      *event\widget = *this
      *event\type = eventtype
      *event\data = *data
      *event\item = item
      
      ;If *this\event\callback
      *this\event\callback()
      ;EndIf
    EndIf
  EndProcedure
  
  Procedure.b Bind(*callBack, *this._s_widget, eventtype.l=#PB_All)
    *this\event = AllocateStructure(_s_event)
    *this\event\type = eventtype
    *this\event\callback = *callBack
  EndProcedure
  
  Procedure.b events(*this._s_widget, EventType.l, mouse_x.l, mouse_y.l, Wheel_X.b=0, Wheel_Y.b=0)
    Protected Result, from =- 1 
    Static cursor_change, LastX, LastY, Last, *leave._s_widget, Down
    
    Macro _callback_(_this_, _type_)
      Select _type_
        Case #PB_EventType_MouseLeave ; : Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          _this_\bar\button[_this_\from]\color\state = #__s_0 
          
          If _this_\cursor And cursor_change
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default) ; cursor_change - 1)
            cursor_change = 0
          EndIf
          
        Case #PB_EventType_MouseEnter ; : Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          _this_\bar\button[_this_\from]\color\state = #__s_1 
          
          ; Set splitter cursor
          If _this_\from = #__b_3 And _this_\type = #PB_GadgetType_Splitter And _this_\cursor
            cursor_change = 1;GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) + 1
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, _this_\cursor)
          EndIf
          
        Case #PB_EventType_LeftButtonUp ; : Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
          _this_\bar\button[_this_\from]\color\state = #__s_1 
          
      EndSelect
    EndMacro
    
    With *this
      ; from the very beginning we'll process 
      ; the splitter children’s widget
      If \splitter And \from <> #__b_3
        If \splitter\first And Not \splitter\g_first
          If events(\splitter\first, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
        EndIf
        If \splitter\second And Not \splitter\g_second
          If events(\splitter\second, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
        EndIf
      EndIf
      
      ; get at point buttons
      If Not \hide And (_from_point_(mouse_x, mouse_y, *this) Or Down)
        If \bar\button 
          If \bar\button[#__b_3]\len And _from_point_(mouse_x, mouse_y, \bar\button[#__b_3])
            from = #__b_3
          ElseIf \bar\button[#__b_2]\len And _from_point_(mouse_x, mouse_y, \bar\button[#__b_2])
            from = #__b_2
          ElseIf \bar\button[#__b_1]\len And _from_point_(mouse_x, mouse_y, \bar\button[#__b_1])
            from = #__b_1
          ElseIf _from_point_(mouse_x, mouse_y, \bar\button[0])
            from = 0
          EndIf
          
          If \type = #PB_GadgetType_TrackBar ;Or \type = #PB_GadgetType_ProgressBar
            Select from
              Case #__b_1, #__b_2
                from = 0
                
            EndSelect
            ; ElseIf \type = #PB_GadgetType_ProgressBar
            ;  
          EndIf
        Else
          from =- 1; 0
        EndIf 
        
        If \from <> from And Not Down
          If *leave > 0 And *leave\from >= 0 And *leave\bar\button[*leave\from]\interact And 
             Not _from_point_(mouse_x, mouse_y, *leave\bar\button[*leave\from])
            
            _callback_(*leave, #PB_EventType_MouseLeave)
            *leave\from =- 1; 0
            
            Result = #True
          EndIf
          
          ; If from > 0
          \from = from
          *leave = *this
          ; EndIf
          
          If \from >= 0 And \bar\button[\from]\interact
            _callback_(*this, #PB_EventType_MouseEnter)
            
            Result = #True
          EndIf
        EndIf
        
      Else
        If \from >= 0 And \bar\button[\from]\interact
          If EventType = #PB_EventType_LeftButtonUp
            ; Debug ""+#PB_Compiler_Line +" Мышь up"
            _callback_(*this, #PB_EventType_LeftButtonUp)
          EndIf
          
          ; Debug ""+#PB_Compiler_Line +" Мышь покинул итем"
          _callback_(*this, #PB_EventType_MouseLeave)
          
          Result = #True
        EndIf 
        
        \from =- 1
        
        If *leave = *this
          *leave = 0
        EndIf
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseWheel
          If *This = *event\active
            If \bar\vertical
              Result = SetState(*This, (\bar\page\pos + Wheel_Y))
            Else
              Result = SetState(*This, (\bar\page\pos + Wheel_X))
            EndIf
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Down : \from =- 1 : from =- 1 : LastX = 0 : LastY = 0 : EndIf
          
        Case #PB_EventType_LeftButtonUp : Down = 0 : LastX = 0 : LastY = 0
          
          If \from >= 0 And \bar\button[\from]\interact
            _callback_(*this, #PB_EventType_LeftButtonUp)
            
            If from =- 1
              _callback_(*this, #PB_EventType_MouseLeave)
              \from =- 1
            EndIf
            
            Result = #True
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If *leave = *this And Not _is_scroll_(*this)
            Macro _set_active_(_this_)
            If *event\active <> _this_
              If *event\active 
                ;                 If *event\active\row\selected 
                ;                   *event\active\row\selected\color\state = 3
                ;                 EndIf
                
                *event\active\color\state = 0
              EndIf
              
              ;               If _this_\row\selected And _this_\row\selected\color\state = 3
              ;                 _this_\row\selected\color\state = 2
              ;               EndIf
              
              _this_\color\state = 2
              *event\active = _this_
              Result = #True
            EndIf
          EndMacro
          
           _set_active_(*this)
          EndIf
          
          If from = 0 And \bar\button[#__b_3]\interact 
            If \bar\vertical
              Result = SetPos(*this, (mouse_y-\bar\thumb\len/2))
            Else
              Result = SetPos(*this, (mouse_x-\bar\thumb\len/2))
            EndIf
            
            from = 3
          EndIf
          
          If from >= 0 And *this = *leave
            Down = *this
            \from = from 
            ; Debug "  "+*this +"  "+ *this\parent +" - get parent bar()"
          
            If \bar\button[from]\interact
              \bar\button[\from]\color\state = #__s_2
              
              Select \from
                Case #__b_1 
                  If \bar\inverted
                    Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos + \bar\scrollstep), Bool(\type <> #PB_GadgetType_Spin And \bar\inverted)))
                  Else
                    Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos - \bar\scrollstep), \bar\inverted))
                  EndIf
                  
                Case #__b_2 
                  If \bar\inverted
                    Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos - \bar\scrollstep), Bool(\type <> #PB_GadgetType_Spin And \bar\inverted)))
                  Else
                    Result = SetState(*this, _invert_(*this\bar, (\bar\page\pos + \bar\scrollstep), \bar\inverted))
                  EndIf
                  
                Case #__b_3 
                  LastX = mouse_x - \bar\thumb\pos 
                  LastY = mouse_y - \bar\thumb\pos
                  Result = #True
                  
              EndSelect
              
            Else
              Result = #True
            EndIf
          EndIf
          
        Case #PB_EventType_MouseMove
          If Down And *leave = *this And Bool(LastX|LastY) 
            If \bar\vertical
              Result = SetPos(*this, (mouse_y-LastY))
            Else
              Result = SetPos(*this, (mouse_x-LastX))
            EndIf
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  
  Macro _set_last_parameters_(_this_, _type_, _flag_, _parent_)
    ;     *event\widget = _this_
    ;     _this_\type = _type_
    ;     _this_\class = #PB_Compiler_Procedure
    ;     
    ;     ; Set parent
    ;     SetParent(_this_, _parent_, _parent_\tab\opened)
    ;     
    _this_\parent = _this_
    
    ;     ; _set_auto_size_
    ;     If Bool(_flag_ & #__flag_autoSize=#__flag_autoSize) : x=0 : y=0
    ;       _this_\align = AllocateStructure(_s_align)
    ;       _this_\align\autoSize = 1
    ;       _this_\align\left = 1
    ;       _this_\align\top = 1
    ;       _this_\align\right = 1
    ;       _this_\align\bottom = 1
    ;     EndIf
    ;     
    ;     If Bool(_flag_ & #__flag_anchorsGadget=#__flag_anchorsGadget)
    ;       
    ;       a_add(_this_)
    ;       a_Set(_this_)
    ;       
    ;     EndIf
    ;     
  EndMacro
  
  ;-
  Procedure.b Draw_Scroll(*this._s_widget)
    With *this
      
      If Not \hide And \color\alpha
        If \color\back <> - 1
          ; Draw scroll bar background
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(\X,\Y,\width,\height,\round,\round,\Color\Back&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \type = #PB_GadgetType_ScrollBar
          If \bar\vertical
            If (\bar\page\len+Bool(\round)*(\width/4)) = \height
              Line( \x, \y, 1, \bar\page\len+1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            Else
              Line( \x, \y, 1, \height, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            EndIf
          Else
            If (\bar\page\len+Bool(\round)*(\height/4)) = \width
              Line( \x, \y, \bar\page\len+1, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            Else
              Line( \x, \y, \width, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
            EndIf
          EndIf
        EndIf
        
        If (\bar\vertical And \bar\button[#__b_1]\height) Or (Not \bar\vertical And \bar\button[#__b_1]\width) ;\bar\button[#__b_1]\len
                                                                                                               ; Draw buttons
          If \bar\button[#__b_1]\color\fore <> - 1
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,
                           \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], \bar\button[#__b_1]\round, \bar\button[#__b_1]\color\alpha)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          EndIf
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          
          ; Draw arrows
          If \bar\button[#__b_1]\arrow\size
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Arrow(\bar\button[#__b_1]\x+(\bar\button[#__b_1]\width-\bar\button[#__b_1]\arrow\size)/2,\bar\button[#__b_1]\y+(\bar\button[#__b_1]\height-\bar\button[#__b_1]\arrow\size)/2, 
                  \bar\button[#__b_1]\arrow\size, Bool(\bar\vertical), \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24, \bar\button[#__b_1]\arrow\type)
          EndIf
        EndIf
        
        If (\bar\vertical And \bar\button[#__b_2]\height) Or (Not \bar\vertical And \bar\button[#__b_2]\width)
          ; Draw buttons
          If \bar\button[#__b_2]\color\fore <> - 1
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,
                           \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], \bar\button[#__b_2]\round, \bar\button[#__b_2]\color\alpha)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          EndIf
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          
          ; Draw arrows
          If \bar\button[#__b_2]\arrow\size
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Arrow(\bar\button[#__b_2]\x+(\bar\button[#__b_2]\width-\bar\button[#__b_2]\arrow\size)/2,\bar\button[#__b_2]\y+(\bar\button[#__b_2]\height-\bar\button[#__b_2]\arrow\size)/2, 
                  \bar\button[#__b_2]\arrow\size, Bool(\bar\vertical)+2, \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
          EndIf
        EndIf
        
        If \bar\thumb\len And \type <> #PB_GadgetType_ProgressBar
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\bar\vertical,\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,
                         \bar\button[#__b_3]\color\fore[\bar\button[#__b_3]\color\state],\bar\button[#__b_3]\color\Back[\bar\button[#__b_3]\color\state], \bar\button[#__b_3]\round, \bar\button[#__b_3]\color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,\bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\frame[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24)
          
          If \bar\button[#__b_3]\arrow\type ; \type = #PB_GadgetType_ScrollBar
            If \bar\button[#__b_3]\arrow\size
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Arrow(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2, 
                    \bar\button[#__b_3]\arrow\size, \bar\button[#__b_3]\arrow\direction, \bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24, \bar\button[#__b_3]\arrow\type)
            EndIf
          Else
            ; Draw thumb lines
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            If \bar\vertical
              Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2-3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+(\bar\button[#__b_3]\width-\bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2+3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
            Else
              Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2-3,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2+3,\bar\button[#__b_3]\y+(\bar\button[#__b_3]\height-\bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
            EndIf
            
          EndIf
        EndIf
        
        If \type = #PB_GadgetType_TrackBar And \bar\thumb\len
          Protected i, _thumb_ = (\bar\button[3]\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          ;\mode = #PB_TrackBar_Ticks
          
          If \bar\vertical
            If \bar\mode = #PB_TrackBar_Ticks
              For i=0 To \bar\page\end-\bar\min
                Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3+4)-2, 
                     (\bar\area\pos + _thumb_ + Round(i * \bar\increment, #PB_Round_Nearest)),3, 1,\bar\button[#__b_1]\color\frame)
              Next
            EndIf
            
            Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3-2)+1,\bar\area\pos + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            Line(\bar\button[3]\x+Bool(\bar\inverted)*(\bar\button[3]\width-3-2)+1,\bar\area\pos + \bar\area\len + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            
          Else
            If \bar\mode = #PB_TrackBar_Ticks
              For i=0 To \bar\page\end-\bar\min
                Line((\bar\area\pos + _thumb_ + Round(i * \bar\increment, #PB_Round_Nearest)), 
                     \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3+4)-2,1,3,\bar\button[#__b_3]\color\Frame)
              Next
            EndIf
            
            Line(\bar\area\pos + _thumb_, \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3-2)+1,1,3,\bar\button[#__b_3]\color\Frame)
            Line(\bar\area\pos + \bar\area\len + _thumb_, \bar\button[3]\y+Bool(Not \bar\inverted)*(\bar\button[3]\height-3-2)+1,1,3,\bar\button[#__b_3]\color\Frame)
          EndIf
          
          ;           If \bar\button[#__b_3]\len
          ;             If \bar\vertical
          ;               DrawingMode(#PB_2DDrawing_Default)
          ;               Box(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\height,\bar\button[#__b_3]\color\back[_state_3_])
          ;               
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,1,\bar\button[#__b_3]\height,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width/2,1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height-1,\bar\button[#__b_3]\width/2,1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\height/2+1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height-1,\bar\button[#__b_3]\width/2,-\bar\button[#__b_3]\height/2-1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               
          ;             Else
          ;               DrawingMode(#PB_2DDrawing_Default)
          ;               Box(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\back[_state_3_])
          ;               
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,1,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width-1,\bar\button[#__b_3]\y,1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\width/2+1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;               Line(\bar\button[#__b_3]\x+\bar\button[#__b_3]\width-1,\bar\button[#__b_3]\y+\bar\button[#__b_3]\height/2,-\bar\button[#__b_3]\width/2-1,\bar\button[#__b_3]\height/2,\bar\button[#__b_3]\color\frame[_state_3_])
          ;             EndIf
          ;           EndIf
          
        EndIf
        
        If \type = #PB_GadgetType_ProgressBar 
          
          ;           DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_alphaBlend)
          ;           RoundBox(\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\y,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height,
          ;                    \bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\back[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
          ;           RoundBox(\bar\thumb\pos+\bar\button[#__b_2]\round,\bar\button[#__b_1]\y,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height,
          ;                    \bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\back[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
          
          If \bar\button[#__b_1]\round
            If \bar\vertical
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Line(\bar\button[#__b_1]\x, \bar\thumb\pos-\bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\button[#__b_1]\x+\bar\button[#__b_1]\width-1, \bar\thumb\pos-\bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\button[#__b_2]\x, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\button[#__b_2]\x+\bar\button[#__b_2]\width-1, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Line(\bar\thumb\pos-\bar\button[#__b_1]\round,\bar\button[#__b_1]\y, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\thumb\pos-\bar\button[#__b_1]\round,\bar\button[#__b_1]\y+\bar\button[#__b_1]\height-1, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y+\bar\button[#__b_2]\height-1, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            EndIf
          EndIf
          
          If \bar\page\pos > \bar\min
            If \bar\vertical
              If \bar\button[#__b_1]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\button[#__b_1]\x+1,\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\width-2,1+\bar\button[#__b_2]\round,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
                
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\button[#__b_2]\x+1,\bar\thumb\pos,\bar\button[#__b_2]\width-2,1+\bar\button[#__b_2]\round,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            Else
              If \bar\button[#__b_1]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\thumb\pos-1-\bar\button[#__b_2]\round,\bar\button[#__b_1]\y+1,1+\bar\button[#__b_2]\round,\bar\button[#__b_1]\height-2,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
                
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <> - 1
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\bar\vertical,\bar\thumb\pos,\bar\button[#__b_2]\y+1,1+\bar\button[#__b_2]\round,\bar\button[#__b_2]\height-2,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            EndIf
          EndIf
          
        EndIf
        
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.b Draw_progress(*this._s_widget)
    *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
    *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
    
    Draw_Scroll(*this)
    
    ; Draw string
    If *this\text And *this\text\string
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\bar\button[#__b_3]\color\frame[*this\bar\button[#__b_3]\color\state])
    EndIf
  EndProcedure
  
  Procedure.b Draw_track(*this._s_widget)
    *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
    *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
    *this\bar\button[#__b_3]\color\state = 2
    
    Draw_Scroll(*this)
  EndProcedure
  
  Procedure.i Draw_Spin(*this._s_widget) 
    Draw_Scroll(*this)
    
    ; Draw string
    If *this\text And *this\text\string
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[*this\color\state])
    EndIf
  EndProcedure
  
  Procedure.b Draw_Splitter(*this._s_widget)
    Protected Pos, Size, round.d = 2
    
    With *this
      If *this > 0
        DrawingMode(#PB_2DDrawing_Outlined)
        If \bar\mode
          Protected *first._s_widget = \splitter\first
          Protected *second._s_widget = \splitter\second
          
          If Not \splitter\g_first And (Not *first Or (*first And Not *first\splitter))
            Box(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\Color\state])
          EndIf
          If Not \splitter\g_second And (Not *second Or (*second And Not *second\splitter))
            Box(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\Color\state])
          EndIf
        EndIf
        
        If \bar\mode = #PB_Splitter_Separator
          ; ??????? ????????? 
          Size = \bar\thumb\len/2
          Pos = \bar\thumb\Pos+Size
          
          If \bar\vertical ; horisontal
            Circle(\bar\button\X+((\bar\button\Width-round)/2-((round*2+2)*2+2)), Pos,round,\bar\button\Color\Frame[#__s_2])
            Circle(\bar\button\X+((\bar\button\Width-round)/2-(round*2+2)),       Pos,round,\bar\button\Color\Frame[#__s_2])
            Circle(\bar\button\X+((\bar\button\Width-round)/2),                    Pos,round,\bar\button\Color\Frame[#__s_2])
            Circle(\bar\button\X+((\bar\button\Width-round)/2+(round*2+2)),       Pos,round,\bar\button\Color\Frame[#__s_2])
            Circle(\bar\button\X+((\bar\button\Width-round)/2+((round*2+2)*2+2)), Pos,round,\bar\button\Color\Frame[#__s_2])
          Else
            Circle(Pos,\bar\button\Y+((\bar\button\Height-round)/2-((round*2+2)*2+2)),round,\bar\button\Color\Frame[#__s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-round)/2-(round*2+2)),      round,\bar\button\Color\Frame[#__s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-round)/2),                   round,\bar\button\Color\Frame[#__s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-round)/2+(round*2+2)),      round,\bar\button\Color\Frame[#__s_2])
            Circle(Pos,\bar\button\Y+((\bar\button\Height-round)/2+((round*2+2)*2+2)),round,\bar\button\Color\Frame[#__s_2])
          EndIf
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.b draw(*this._s_widget)
    With *this
      If *this
        If \text 
        If \text\fontID 
          DrawingFont(\text\fontID)
        EndIf
        
        If \text\change
          
          If \type = #PB_GadgetType_Spin
            Protected i
            
            ;*this\bar\scrollstep = 1.19
            For i=0 To 3
              If *this\bar\scrollstep = ValF(StrF(*this\bar\scrollstep, i))
                *this\text\string = StrF(*this\bar\page\Pos, i)
                Break
              EndIf
            Next
          EndIf
          
          *this\text\height = TextHeight("A")
          *this\text\width = TextWidth(*this\text\string)
          
          _text_change_(*this, *this\x, *this\y, *this\width, *this\height)
        EndIf
      EndIf
      
      Select \type
        Case #PB_GadgetType_Spin        : Draw_Spin(*this)
        Case #PB_GadgetType_TrackBar    : Draw_Track(*this)
        Case #PB_GadgetType_ScrollBar   : Draw_Scroll(*this)
        Case #PB_GadgetType_Splitter    : Draw_Splitter(*this)
        Case #PB_GadgetType_ProgressBar : Draw_Progress(*this)
      EndSelect
      
      If \text\change
        \text\change = 0
      EndIf
      
      If *this\change <> *this\bar\change
        *this\change = *this\bar\change
        *this\bar\change = 0
      EndIf
      
      EndIf
    EndWith
  EndProcedure
  
  
  ;-
  Procedure.i create(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scrollstep.f=1.0)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    
    With *this
      *event\widget = *this
      \x =- 1
      \y =- 1
      
      ;\hide = Bool(Not pagelength)  ; add
      
      \type = Type
      
      \parent = parent
      If \parent
        \root = \parent\root
        \window = \parent\window
      EndIf
      
      \round = round
      \bar\scrollstep = scrollstep
      
      ; ???? ???? ???????
      \color\alpha = 255
      \color\alpha[1] = 0
      \color\state = 0
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\line = $FFFFFFFF
      \color\front = $FFFFFFFF
      
      \bar\button[#__b_1]\color = _get_colors_()
      \bar\button[#__b_2]\color = _get_colors_()
      \bar\button[#__b_3]\color = _get_colors_()
      
      \bar\vertical = Bool(Type = #PB_GadgetType_ScrollBar And 
                           (Bool(Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical) Or
                            Bool(Flag & #__Bar_Vertical = #__Bar_Vertical)))
      
      If Not Bool(Flag&#__bar_nobuttons)
        If \bar\vertical
          \width = Size
        Else
          \height = Size
        EndIf
        
        If Size < 21
          Size - 1
        Else
          size = 17
        EndIf
      EndIf
        
        
      ; min thumb size
      \bar\button[#__b_3]\len = size
      
      If Type = #PB_GadgetType_ScrollBar
        \bar\inverted = Bool(Flag & #__bar_inverted = #__bar_inverted)
      
        \bar\button[#__b_1]\interact = #True
        \bar\button[#__b_2]\interact = #True
        \bar\button[#__b_3]\interact = #True
        
        \bar\button[#__b_1]\len = size
        \bar\button[#__b_2]\len = size
        
        \bar\button[#__b_1]\arrow\size = 4
        \bar\button[#__b_2]\arrow\size = 4
        \bar\button[#__b_3]\arrow\size = 3
        
        \bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
        \bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
        
        \bar\button[#__b_1]\round = \round
        \bar\button[#__b_2]\round = \round
        \bar\button[#__b_3]\round = \round
      EndIf
      
      If Type = #PB_GadgetType_ProgressBar
        \bar\vertical = Bool(Flag & #PB_ProgressBar_Vertical = #PB_ProgressBar_Vertical Or
                            Bool(Flag & #__Bar_Vertical = #__Bar_Vertical))
        \bar\inverted = \bar\vertical
        
        ; \text = AllocateStructure(_s_text)
        \text\change = 1
        
        \text\align\vertical = 1
        \text\align\horizontal = 1
        \text\rotate = \bar\vertical * 90 ; 270
        
        \bar\button[#__b_1]\interact = #False
        \bar\button[#__b_2]\interact = #False
        
        \bar\button[#__b_1]\round = \round
        \bar\button[#__b_2]\round = \round
      EndIf
      
      If Type = #PB_GadgetType_TrackBar
        \bar\vertical = Bool(Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical); Or Bool(Flag & #__Bar_Vertical = #__Bar_Vertical))
        \bar\inverted = \bar\vertical
        
        \bar\button[#__b_1]\interact = #False
        \bar\button[#__b_2]\interact = #False
        \bar\button[#__b_3]\interact = #True
        
        
    
        \bar\button[#__b_1]\len = 1
        \bar\button[#__b_2]\len = 1
        
        \bar\button[#__b_3]\arrow\size = 4
        \bar\button[#__b_3]\arrow\type = #__arrow_type
        
        \bar\button[#__b_1]\round = 2
        \bar\button[#__b_2]\round = 2
        \bar\button[#__b_3]\round = \round
        
        If \round < 7
          \bar\button[#__b_3]\len = 9
        EndIf
        
        \bar\mode = Bool(flag & #PB_TrackBar_Ticks) * #PB_TrackBar_Ticks
      EndIf
      
      If Type = #PB_GadgetType_Spin
        \bar\vertical = Bool(Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical)
        \bar\inverted = \bar\vertical
        
        ; \text = AllocateStructure(_s_text)
        \text\change = 1
        \text\editable = 1
        \text\align\Vertical = 1
        \text\_padding = #__spin_padding_text
        
        ; ???? ???? ???????
        \color = _get_colors_()
        \color\alpha = 255
        \color\back = $FFFFFFFF
        
        \bar\button\len = #__spin_buttonsize
        
        \bar\button[#__b_3]\len = 0
        \bar\button[#__b_1]\len = Size
        \bar\button[#__b_2]\len = Size
        
        \bar\button[#__b_1]\arrow\size = 4
        \bar\button[#__b_2]\arrow\size = 4
        
        \bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
        \bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
      EndIf
      
      If Type = #PB_GadgetType_Splitter
        \container = #PB_GadgetType_Splitter
        \bar\vertical = Bool(Not Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical)
        
        \bar\button[#__b_1]\interact = #False
        \bar\button[#__b_2]\interact = #False
        \bar\button[#__b_3]\interact = #True
        
        \bar\button\len = 7
        \bar\thumb\len = 7
        \bar\mode = #PB_Splitter_Separator
        
        \splitter = AllocateStructure(_s_splitter)
        If Flag & #PB_Splitter_FirstFixed 
          \splitter\fixed = #__b_1 
        ElseIf Flag & #PB_Splitter_SecondFixed 
          \splitter\fixed = #__b_2 
        EndIf
      EndIf
      
        
      
      If \bar\min <> Min : SetAttribute(*this, #__bar_minimum, Min) : EndIf
      If \bar\max <> Max : SetAttribute(*this, #__bar_maximum, Max) : EndIf
      If \bar\page\len <> Pagelength : SetAttribute(*this, #__bar_pageLength, Pagelength) : EndIf
      If \bar\inverted : SetAttribute(*this, #__bar_inverted, #True) : EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=7)
    Protected *this._s_widget = create(#PB_GadgetType_TrackBar, 15, Min, Max, 0, Flag|#__bar_nobuttons, round)
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened)
    Resize(*this, X,Y,Width,Height)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0)
    Protected *this._s_widget = create(#PB_GadgetType_ProgressBar, 0, Min, Max, 0, Flag|#__bar_nobuttons, round)
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Spin(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0, Increment.f=1.0)
    Protected *this._s_widget
    If Flag&#__bar_vertical
      Flag&~#__bar_vertical
      ;Flag|#__bar_inverted
    Else
      Flag|#__bar_vertical
      Flag|#__bar_inverted
    EndIf
    
    If Flag&#__bar_reverse
      Flag|#__bar_inverted
    EndIf
    
    *this = create(#PB_GadgetType_Spin, 16, Min, Max, 0, Flag, round, 0, Increment)
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    Protected *this._s_widget
    
    If (Bool(Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical) Or Bool(Flag & #__Bar_Vertical = #__Bar_Vertical))
      *this = create(#PB_GadgetType_ScrollBar, width, Min, Max, PageLength, Flag, round)
    Else
      *this = create(#PB_GadgetType_ScrollBar, height, Min, Max, PageLength, Flag, round)
    EndIf
    
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
    Protected *this._s_widget 
    
    If Bool(Not Flag&#PB_Splitter_Vertical)
      *this = create(#PB_GadgetType_Splitter, 7, 0, Height, 0, Flag|#__bar_nobuttons, 0)
    Else
      *this = create(#PB_GadgetType_Splitter, 7, 0, Width, 0, Flag|#__bar_nobuttons, 0)
    EndIf
    
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    
    With *this
      *this\index[#__s_1] =- 1
      *this\index[#__s_2] = 0
      
      \splitter\first = First
      \splitter\second = Second
      
      Resize(*this, X,Y,Width,Height)
      
      If \bar\vertical
        \cursor = #PB_Cursor_UpDown
        SetState(*this, \height/2-1)
      Else
        \cursor = #PB_Cursor_LeftRight
        SetState(*this, \width/2-1)
      EndIf
      
      \splitter\first\parent = *this
      \splitter\second\parent = *this
      ;       SetParent(\splitter\first, *this)
      ;       SetParent(\splitter\second, *this)
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  
EndModule
;- <<< 
CompilerEndIf

;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  UseModule Constants
  UseModule Structures
  
  Global g_Canvas, NewList *List._s_widget()
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    Procedure GetCurrentEvent()
      Protected app = CocoaMessage(0,0,"NSApplication sharedApplication")
      If app
        ProcedureReturn CocoaMessage(0,app,"currentEvent")
      EndIf
    EndProcedure
    
    Procedure.CGFloat GetWheelDeltaX()
      Protected wheelDeltaX.CGFloat = 0.0
      Protected currentEvent = GetCurrentEvent()
      If currentEvent
        CocoaMessage(@wheelDeltaX,currentEvent,"scrollingDeltaX")
      EndIf
      ProcedureReturn wheelDeltaX
    EndProcedure
    
    Procedure.CGFloat GetWheelDeltaY()
      Protected wheelDeltaY.CGFloat = 0.0
      Protected currentEvent = GetCurrentEvent()
      If currentEvent
        CocoaMessage(@wheelDeltaY,currentEvent,"scrollingDeltaY")
      EndIf
      ProcedureReturn wheelDeltaY
    EndProcedure
  CompilerEndIf
  
  Procedure ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
      
      ; PushListPosition(*List())
      ForEach *List()
        If Not *List()\hide
          Draw(*List())
        EndIf
      Next
      ; PopListPosition(*List())
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure v_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    
    
    ForEach *List()
      If *List()\bar\vertical And *List()\type = GadgetType(EventGadget())
        Repaint | SetState(*List(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(g_Canvas)
    EndIf
  EndProcedure
  
  Procedure h_GadgetCallBack()
    Protected Repaint.b, state = GetGadgetState(EventGadget())
    
    ForEach *List()
      If Not *List()\bar\vertical And *List()\type = GadgetType(EventGadget())
        Repaint | SetState(*List(), state)
      EndIf
    Next
    
    If Repaint
      SetWindowTitle(EventWindow(), Str(state))
      ReDraw(g_Canvas)
    EndIf
  EndProcedure
  
  Procedure v_CallBack(GetState, type)
    Select type
      Case #PB_GadgetType_ScrollBar
        SetGadgetState(2, GetState)
      Case #PB_GadgetType_TrackBar
        SetGadgetState(12, GetState)
      Case #PB_GadgetType_ProgressBar
        SetGadgetState(22, GetState)
      Case #PB_GadgetType_Splitter
        ; SetGadgetState(Splitter_4, GetState)
    EndSelect
    
    SetWindowTitle(EventWindow(), Str(GetState))
  EndProcedure
  
  Procedure h_CallBack(GetState, type)
    Select type
      Case #PB_GadgetType_ScrollBar
        SetGadgetState(1, GetState)
      Case #PB_GadgetType_TrackBar
        SetGadgetState(11, GetState)
      Case #PB_GadgetType_ProgressBar
        SetGadgetState(21, GetState)
      Case #PB_GadgetType_Splitter
        ; SetGadgetState(Splitter_3, GetState)
    EndSelect
    
    SetWindowTitle(EventWindow(), Str(GetState))
  EndProcedure
  
  Procedure.i Canvas_Events()
    Protected Canvas.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta ; = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    ;     Protected *this._s_widget = GetGadgetData(Canvas)
    
    If EventType = #PB_EventType_MouseWheel
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        Protected wheel_X.CGFloat = GetWheelDeltaX()
        Protected wheel_Y.CGFloat = GetWheelDeltaY()
      CompilerElse
        Protected wheel_X
        Protected wheel_Y
      CompilerEndIf
    EndIf
    
    Select EventType
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      Repaint | events(*List(), EventType, MouseX, MouseY, wheel_X, wheel_Y)
      
      If *List()\bar\change
        
        If *List()\bar\vertical
          v_CallBack(*List()\bar\page\pos, *List()\type)
        Else
          h_CallBack(*List()\bar\page\pos, *List()\type)
        EndIf
        
        *List()\bar\change = 0
      EndIf
    Next
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure ev()
    ;Debug ""+Widget() +" "+ Type() +" "+ Item() +" "+ Data()     ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  Procedure ev2()
    ;Debug "  "+Widget() +" "+ Type() +" "+ Item() +" "+ Data()   ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 605, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    g_Canvas = CanvasGadget(-1, 0, 0, 605, 140+200+140+140, #PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    
    TextGadget       (-1,  10, 15, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ScrollBarGadget  (1,  10, 42, 250,  20, 30, 100, 30)
    SetGadgetState   (1,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBarGadget  (2, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    ;ScrollBarGadget  (2, 270, 10,  25, 100 ,0, 521, 96, #PB_ScrollBar_Vertical)
    SetGadgetState   (2, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    TextGadget       (-1,  300+10, 15, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    AddElement(*List()) : *List() = Spin  (300+10, 72, 250,  21, 0, 10, 0)
    SetState   (Widget(),  5)   ; set 1st scrollbar (ID = 0) to 50 of 100
    AddElement(*List()) : *List() = Scroll  (300+10, 42, 250,  20, 30, 100, 30, 0)
    SetState   (Widget(),  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    
    TextGadget       (-1,  300+10,110, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    AddElement(*List()) : *List() = Scroll  (300+270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical);|#__bar_inverted)
                                                                                                ;AddElement(*List()) : *List() = Scroll  (300+270, 10,  25, 100 ,0, 521, 96, #PB_ScrollVertical)
    SetState   (Widget(), 100)                                                                  ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    BindGadgetEvent(1,@h_GadgetCallBack())
    BindGadgetEvent(2,@v_GadgetCallBack())
    ;Bind(@ev(), Widget())
    
    
    ; example_2
    TextGadget    (-1, 10,  140+10, 250, 20,"TrackBar Standard", #PB_Text_Center)
    TrackBarGadget(10, 10,  140+40, 250, 20, 0, 10000)
    SetGadgetState(10, 5000)
    TextGadget    (-1, 10, 140+90, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    ;     TrackBarGadget(11, 10, 140+120, 250, 20, 0, 30, #PB_TrackTicks)
    TrackBarGadget(11, 10, 140+120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    SetGadgetState(11, 60)
    TextGadget    (-1,  60, 140+160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    TrackBarGadget(12, 270, 140+10, 25, 170, 0, 10000, #PB_TrackBar_Vertical)
    SetGadgetState(12, 8000)
    
    
    TextGadget    (-1, 300+10,  140+10, 250, 20,"TrackBar Standard", #PB_Text_Center)
    AddElement(*List()) : *List() = Track(300+10,  140+40, 250, 20, 0, 10000, 0)
    SetState(Widget(), 5000)
    TextGadget    (-1, 300+10, 140+90, 250, 20, "TrackBar Ticks", #PB_Text_Center)
    ;     AddElement(*List()) : *List() = Track(300+10, 140+120, 250, 20, 0, 30, #__bar_ticks)
    AddElement(*List()) : *List() = Track(300+10, 140+120, 250, 20, 30, 60, #PB_TrackBar_Ticks)
    SetState(Widget(), 60)
    TextGadget    (-1,  300+60, 140+160, 200, 20, "TrackBar Vertical", #PB_Text_Right)
    AddElement(*List()) : *List() = Track(300+270, 140+10, 25, 170, 0, 10000, #PB_TrackBar_Vertical)
    SetState(Widget(), 8000)
    
    BindGadgetEvent(11,@h_GadgetCallBack())
    BindGadgetEvent(12,@v_GadgetCallBack())
    
    ;
    ; example_3
    TextGadget       (-1,  10, 140+200+10, 250,  20, "ProgressBar Standard  (start=65, page=30/100)",#PB_Text_Center)
    ProgressBarGadget  (21,  10, 140+200+42, 250,  20, 30, 100)
    SetGadgetState   (21,  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,140+200+100, 250,  20, "ProgressBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ProgressBarGadget  (22, 270, 140+200,  25, 120 ,0, 300, #PB_ProgressBar_Vertical)
    SetGadgetState   (22, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    
    TextGadget       (-1,  300+10, 140+200+10, 250,  20, "ProgressBar Standard  (start=65, page=30/100)",#PB_Text_Center)
    AddElement(*List()) : *List() = Progress  (300+10, 140+200+42, 250,  20, 30, 100, 0)
    SetState   (Widget(),  65)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  300+10,140+200+100, 250,  20, "ProgressBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    AddElement(*List()) : *List() = Progress  (300+270, 140+200,  25, 120 ,0, 300, #PB_ProgressBar_Vertical)
    SetState   (Widget(), 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    BindGadgetEvent(21,@h_GadgetCallBack())
    BindGadgetEvent(22,@v_GadgetCallBack())
    
    
    ; example_4
    ;     TextGadget       (-1,  10, 140+200+140+10, 230,  20, "SplitterBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ;     ScrollBarGadget(100, 0, 0, 0, 0, 30,71, 0) ; No need to specify size or coordinates
    ;     ProgressBarGadget(200, 0, 0, 0, 0, 30,100) ; as they will be sized automatically
    ;     SetGadgetState   (100, 30)
    ;     SetGadgetState   (200, 50)
    ;     SplitterGadget  (31,  10, 140+200+140+42, 230,  60, 100, 200, #PB_Splitter_Vertical)
    ;     SetGadgetState   (31,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    ;     TextGadget       (-1,  10,140+200+140+110, 230,  20, "SplitterBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ;     TrackBarGadget(300, 0, 0, 250,  20, 30, 100) ; No need to specify size or coordinates
    ;     ProgressBarGadget(400, 0, 0, 0, 0, 30,100)   ; as they will be sized automatically
    ;     SetGadgetState   (300, 30)
    ;     SetGadgetState   (400, 50)
    ;     SplitterGadget  (32, 250, 140+200+140+10,  45, 120 ,300, 400, 0)
    ;     SetGadgetState   (32, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    ;     TextGadget       (-1,  300+10, 140+200+140+10, 230,  20, "SplitterBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ;     *b1 = Splitter  (0, 0, 0, 0, 0, 0, #PB_Splitter_Vertical|#PB_Splitter_Separator);|#PB_Splitter_FirstFixed)
    ;     *b2 = Progress  (0, 0, 0, 0, 30, 100, 0)
    ;     ;SetState   (*b1, 30) 
    ;     SetState   (*b2, 50) 
    ;     AddElement(*List()) : *List() = *b1
    ;     AddElement(*List()) : *List() = *b2
    ;     
    ;     AddElement(*List()) : *List() = Splitter  (300+10, 140+200+140+42, 230,  60, *b1, *b2, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    ;     SetState   (Widget(),  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    ;     SetAttribute(Widget(), #__FirstMinimumSize, 20)
    ;     SetAttribute(Widget(), #__SecondMinimumSize, 20)
    ;     TextGadget       (-1,  300+10,140+200+140+110, 230,  20, "SplitterBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ;     
    ;     *b3 = Track  (0, 0, 0, 0, 30, 60)
    ;     *b4 = Progress  (0, 0, 0, 0, 30, 100)
    ;     SetState   (*b3, 30) 
    ;     SetState   (*b4, 50) 
    ;     AddElement(*List()) : *List() = *b3
    ;     AddElement(*List()) : *List() = *b4
    ;     
    ;     AddElement(*List()) : *List() = Splitter  (300+250, 140+200+140+10,  45, 120 ,*b3, *b4, #PB_Splitter_Separator)
    ;     ;SetState   (*List(), 40)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    ;     
    ;     BindGadgetEvent(31,@h_GadgetCallBack())
    ;     BindGadgetEvent(32,@v_GadgetCallBack())
    ;     
    ;     Post(333, Widget())
    ;     Bind(@ev2(), Widget(), #PB_EventType_StatusChange)
    
    
    
    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    
    Button_2 = SpinGadget(#PB_Any, 0, 0, 0, 0, 0,20) ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
    
    Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    ;     ;SetGadgetState(Splitter_1, 20)
    Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = SplitterGadget(#PB_Any, 10, 140+200+130, 285, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    
    Button_0 = Bar::Progress(0, 0, 0, 0, 0,100) ; No need to specify size or coordinates
    Button_1 = Bar::Progress(0, 0, 0, 0, 10, 100); No need to specify size or coordinates
    Button_2 = Bar::Spin(0, 0, 0, 0, 0,20)       ; as they will be sized automatically
    Button_3 = Bar::Progress(0, 0, 0, 0, 0, 100, 30) ; as they will be sized automatically
    
    Button_4 = Bar::Progress(0, 0, 0, 0, 40,100) ; as they will be sized automatically
    Button_5 = Bar::Spin(0, 0, 0, 0, 50,100, #__bar_vertical) ; as they will be sized automatically
    
    Splitter_0 = Bar::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = Bar::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    ;SetState(Splitter_1, 410/2-20)
    Splitter_2 = Bar::Splitter(0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = Bar::Splitter(0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = Bar::Splitter(300+10, 140+200+130, 285, 140, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    SetState(Button_2, 5)
    SetState(Button_5, 65)
    
    ;     Widget() = Button_3
    ;     Widget()\height = 30
    ;     Widget()\width = 30
    ;     Widget()\bar\button[#__b_3]\len = 30
    ;     Resize(Widget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    
    AddElement(*List()) : *List() = Button_0
    AddElement(*List()) : *List() = Button_1
    AddElement(*List()) : *List() = Button_2
    AddElement(*List()) : *List() = Button_3
    AddElement(*List()) : *List() = Button_4
    AddElement(*List()) : *List() = Button_5
    
    AddElement(*List()) : *List() = Splitter_0
    ; *List()\focus = 10
    AddElement(*List()) : *List() = Splitter_1
    ; *List()\focus = 11
    AddElement(*List()) : *List() = Splitter_2
    AddElement(*List()) : *List() = Splitter_3
    AddElement(*List()) : *List() = Splitter_4
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = x9+vLA9-BAAAAA----8ff-+LAAA-Ag-+--PCAAQAAAAAAAAAAgAkHACAAAA0
; EnableXP