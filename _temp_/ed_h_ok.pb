

DeclareModule Macros
  Macro isItem(_item_, _list_)
    Bool(_item_ >= 0 And _item_ < ListSize(_list_))
  EndMacro
  
  Macro itemSelect(_item_, _list_)
    Bool(isItem(_item_, _list_) And _item_ <> ListIndex(_list_) And SelectElement(_list_, _item_))
  EndMacro
  
  Macro add_widget(_widget_, _hande_)
    If _widget_ =- 1 Or _widget_ > ListSize(List()) - 1
      LastElement(List())
      _hande_ = AddElement(List()) 
      _widget_ = ListIndex(List())
    Else
      _hande_ = SelectElement(List(), _widget_)
      ; _hande_ = InsertElement(List())
      PushListPosition(List())
      While NextElement(List())
        List()\widget\index = ListIndex(List())
      Wend
      PopListPosition(List())
    EndIf
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
  
  Macro _make_open_box_XY_(_this_, _items_, _x_, _y_)
    If (_this_\flag\bar\buttons Or _this_\flag\lines) 
      _items_\box\width = _this_\flag\bar\buttons
      _items_\box\height = _this_\flag\bar\buttons
      _items_\box\x = _x_+_items_\margin\width-(_items_\box\width)/2
      _items_\box\y = (_y_+_items_\height)-(_items_\height+_items_\box\height)/2
    EndIf
  EndMacro
  
  Macro _make_check_box_XY_(_this_, _items_, _x_, _y_)
    If _this_\flag\checkBoxes
      _items_\box\width[1] = _this_\flag\checkBoxes
      _items_\box\height[1] = _this_\flag\checkBoxes
      _items_\box\x[1] = _x_+(_items_\box\width[1])/2
      _items_\box\y[1] = (_y_+_items_\height)-(_items_\height+_items_\box\height[1])/2
    EndIf
  EndMacro
  
  Macro Distance(_mouse_x_, _mouse_y_, _position_x_, _position_y_, _round_)
    Bool(Sqr(Pow(((_position_x_+_round_) - _mouse_x_),2) + Pow(((_position_y_+_round_) - _mouse_y_),2)) =< _round_)
  EndMacro
  
  Macro Max(_a_, _b_)
    ((_a_) * Bool((_a_) > = (_b_)) + (_b_) * Bool((_b_) > (_a_)))
  EndMacro
  
  Macro Min(_a_, _b_)
    ((_a_) * Bool((_a_) < = (_b_)) + (_b_) * Bool((_b_) < (_a_)))
  EndMacro
  
  Macro SetBit(_var_, _bit_) ; Установка бита.
    _var_ | (_bit_)
  EndMacro
  
  Macro ClearBit(_var_, _bit_) ; Обнуление бита.
    _var_ & (~(_bit_))
  EndMacro
  
  Macro InvertBit(_var_, _bit_) ; Инвертирование бита.
    _var_ ! (_bit_)
  EndMacro
  
  Macro TestBit(_var_, _bit_) ; Проверка бита (#True - установлен; #False - обнулен).
    Bool(_var_ & (_bit_))
  EndMacro
  
  Macro NumToBit(_num_) ; Позиция бита по его номеру.
    (1<<(_num_))
  EndMacro
  
  Macro GetBits(_var_, _start_pos_, _end_pos_)
    ((_var_>>(_start_pos_))&(NumToBit((_end_pos_)-(_start_pos_)+1)-1))
  EndMacro
  
  Macro CheckFlag(_mask_, _flag_)
    ((_mask_ & _flag_) = _flag_)
  EndMacro
  
  ; val = %10011110
  ; Debug Bin(GetBits(val, 0, 3))
  
EndDeclareModule 

Module Macros
  
EndModule 

;UseModule Macros

;-
;- XIncludeFile
;-
CompilerIf Not Defined(constants, #PB_Module)
  XIncludeFile "../constants.pbi"
CompilerEndIf

CompilerIf Not Defined(structures, #PB_Module)
  XIncludeFile "../structures.pbi"
CompilerEndIf

CompilerIf Not Defined(colors, #PB_Module)
  XIncludeFile "../colors.pbi"
CompilerEndIf

;XIncludeFile "bar().pb"

CompilerIf Not Defined(Bar, #PB_Module)
  ;- >>>
  DeclareModule bar
  UseModule constants
  UseModule structures
  
  Macro _get_colors_()
    colors::this
  EndMacro
  
  Structure _struct_ Extends _s_widget : EndStructure
  
  Macro Root()
    *event\root
  EndMacro
  
  Macro Widget()
    *event\widget
  EndMacro
  
  ;   ;- GLOBALs
  Global *event._s_event_ = AllocateStructure(_s_event_)
  
  Declare.b Draw(*this)
  
  Declare.b SetState(*this, ScrollPos.f)
  Declare.l SetAttribute(*this, Attribute.l, Value.l)
  
  Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=7)
  Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0)
  Declare.i Spin(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0, increment.f=1.0)
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
  Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
  
  Declare.i Bar(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scrollstep.f=1.0)
  ;Declare.i Bar(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, round.l=0)
  Declare.b events(*this, EventType.l, mouse_x.l, mouse_y.l, wheel_x.b=0, wheel_y.b=0)
  
  Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
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
  
  Procedure.b splitter_size(*this._struct_)
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
        _this_\text\y = _y_ +_this_\text\align\height+ _this_\text\padding+_this_\text\width
      ElseIf _this_\text\align\horizontal
        _this_\text\y = _y_ + (_height_+_this_\text\align\height+_this_\text\width)/2
      Else
        _this_\text\y = _y_ + _height_-_this_\text\padding
      EndIf
      
    ElseIf _this_\text\rotate = 270
      _this_\text\x = _x_ + (_width_-_this_\y)
      
      If _this_\text\align\right
        _this_\text\y = _y_ + (_height_-_this_\text\width-_this_\text\padding) 
      ElseIf _this_\text\align\horizontal
        _this_\text\y = _y_ + (_height_-_this_\text\width)/2 
      Else
        _this_\text\y = _y_ + _this_\text\padding 
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
        _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width-_this_\text\padding) 
      ElseIf _this_\text\align\horizontal
        _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width)/2
      Else
        _this_\text\x = _x_ + _this_\text\padding
      EndIf
      
    ElseIf _this_\text\rotate = 180
      _this_\text\y = _y_ + (_height_-_this_\y)
      
      If _this_\text\align\right
        _this_\text\x = _x_ + _this_\text\padding+_this_\text\width
      ElseIf _this_\text\align\horizontal
        _this_\text\x = _x_ + (_width_+_this_\text\width)/2 
      Else
        _this_\text\x = _x_ + _width_-_this_\text\padding 
      EndIf
      
    EndIf
    ;EndIf
  EndMacro
  
  
  Macro _thumb_pos_(_bar_, _scroll_pos_)
    (_bar_\area\pos + Round((_scroll_pos_-_bar_\min) * _bar_\increment, #PB_Round_Nearest)) 
    ; (_bar_\area\pos + Round((_scroll_pos_-_bar_\min) * (_bar_\area\len / (_bar_\max-_bar_\min)), #PB_round_nearest)) 
  EndMacro
  
  Macro _thumb_len_(_bar_)
    Round(_bar_\area\len - (_bar_\area\len / (_bar_\max-_bar_\min)) * ((_bar_\max-_bar_\min) - _bar_\page\len), #PB_Round_Nearest)
  EndMacro
  
  Macro _scrolled_(_this_, _pos_, _len_)
    Bool(Bool(((_pos_)-_this_\bar\page\pos) < 0 And SetState(_this_, (_pos_))) Or
         Bool(((_pos_)-_this_\bar\page\pos) > (_this_\bar\page\len-(_len_)) And SetState(_this_, (_pos_)-(_this_\bar\page\len-(_len_)))))
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
  
  Procedure _pos_(*this._struct_, _scroll_pos_)
    *this\bar\thumb\pos = _thumb_pos_(*this\bar, _scroll_pos_)
    
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
    ;       *this\Scroll\y = *this\Scroll\v\y-*this\Scroll\v\bar\page\pos
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
      
      
      ; ScrollArea childrens auto resize 
      If *this\parent And *this\parent\scroll
        *this\parent\change =- 1
        
        If *this\bar\vertical
          *this\parent\scroll\y = - *this\bar\page\pos ; *this\y 
                                                         ;*this\parent\scroll\height = *this\bar\max
          _childrens_move_(*this\parent, 0, *this\bar\change)
        Else
          *this\parent\scroll\x = - *this\bar\page\pos ; *this\x 
                                                         ;*this\parent\scroll\width = *this\bar\max
          _childrens_move_(*this\parent, *this\bar\change, 0)
        EndIf
      EndIf
      
      ;       ; bar change
      ;       Post(#PB_EventType_StatusChange, *this, *this\from, *this\bar\direction)
      ;     Else
      ;       If *this\parent\scroll
      ;         If *this\bar\vertical
      ;           *this\parent\scroll\y = *this\y
      ;         Else
      ;           *this\parent\scroll\x = *this\x
      ;         EndIf
      ;       EndIf
    EndIf
    
    ProcedureReturn *this\bar\thumb\pos
  EndProcedure
  
  
;   Macro _pos_(_this_, _scroll_pos_)
;     _thumb_pos_(_this_\bar, _scroll_pos_)
;     
;     If _this_\bar\thumb\pos < _this_\bar\area\pos 
;       _this_\bar\thumb\pos = _this_\bar\area\pos 
;     EndIf 
;     
;     If _this_\bar\thumb\pos > _this_\bar\area\end
;       _this_\bar\thumb\pos = _this_\bar\area\end
;     EndIf
;     
;     If _this_\type = #PB_GadgetType_Spin
;       If _this_\bar\vertical 
;         _this_\bar\button\x = _this_\X + _this_\width - #__spin_buttonsize2
;         _this_\bar\button\width = #__spin_buttonsize2
;       Else 
;         _this_\bar\button\y = _this_\Y + _this_\Height - #__spin_buttonsize2
;         _this_\bar\button\height = #__spin_buttonsize2 
;       EndIf
;     Else
;       If _this_\bar\vertical 
;         _this_\bar\button\x = _this_\X + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
;         _this_\bar\button\width = _this_\width - Bool(_this_\type=#PB_GadgetType_ScrollBar) 
;         _this_\bar\button\y = _this_\bar\area\pos
;         _this_\bar\button\height = _this_\bar\area\len               
;       Else 
;         _this_\bar\button\y = _this_\Y + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
;         _this_\bar\button\height = _this_\Height - Bool(_this_\type=#PB_GadgetType_ScrollBar)  
;         _this_\bar\button\x = _this_\bar\area\pos
;         _this_\bar\button\width = _this_\bar\area\len
;       EndIf
;     EndIf
;     
;     ; _start_
;     If _this_\bar\button[#__b_1]\len 
;       If _scroll_pos_ = _this_\bar\min
;         _this_\bar\button[#__b_1]\color\state = #__s_3
;         _this_\bar\button[#__b_1]\interact = 0
;       Else
;         If _this_\bar\button[#__b_1]\color\state <> #__s_2
;           _this_\bar\button[#__b_1]\color\state = #__s_0
;         EndIf
;         _this_\bar\button[#__b_1]\interact = 1
;       EndIf 
;     EndIf
;     
;     If _this_\type=#PB_GadgetType_ScrollBar Or 
;        _this_\type=#PB_GadgetType_Spin
;       
;       If _this_\bar\vertical 
;         ; Top button coordinate on vertical scroll bar
;         _this_\bar\button[#__b_1]\x = _this_\bar\button\x
;         _this_\bar\button[#__b_1]\y = _this_\Y 
;         _this_\bar\button[#__b_1]\width = _this_\bar\button\width
;         _this_\bar\button[#__b_1]\height = _this_\bar\button[#__b_1]\len                   
;       Else 
;         ; Left button coordinate on horizontal scroll bar
;         _this_\bar\button[#__b_1]\x = _this_\X 
;         _this_\bar\button[#__b_1]\y = _this_\bar\button\y
;         _this_\bar\button[#__b_1]\width = _this_\bar\button[#__b_1]\len 
;         _this_\bar\button[#__b_1]\height = _this_\bar\button\height 
;       EndIf
;       
;     ElseIf _this_\type = #PB_GadgetType_TrackBar
;     Else
;       _this_\bar\button[#__b_1]\x = _this_\X
;       _this_\bar\button[#__b_1]\y = _this_\Y
;       
;       If _this_\bar\vertical
;         _this_\bar\button[#__b_1]\width = _this_\width
;         _this_\bar\button[#__b_1]\height = _this_\bar\thumb\pos-_this_\y 
;       Else
;         _this_\bar\button[#__b_1]\width = _this_\bar\thumb\pos-_this_\x 
;         _this_\bar\button[#__b_1]\height = _this_\height
;       EndIf
;     EndIf
;     
;     ; _stop_
;     If _this_\bar\button[#__b_2]\len
;       ; Debug ""+ Bool(_this_\bar\thumb\pos = _this_\bar\area\end) +" "+ Bool(_scroll_pos_ = _this_\bar\page\end)
;       If _scroll_pos_ = _this_\bar\page\end
;         _this_\bar\button[#__b_2]\color\state = #__s_3
;         _this_\bar\button[#__b_2]\interact = 0
;       Else
;         If _this_\bar\button[#__b_2]\color\state <> #__s_2
;           _this_\bar\button[#__b_2]\color\state = #__s_0
;         EndIf
;         _this_\bar\button[#__b_2]\interact = 1
;       EndIf 
;     EndIf
;     
;     If _this_\type = #PB_GadgetType_ScrollBar Or 
;        _this_\type = #PB_GadgetType_Spin
;       If _this_\bar\vertical 
;         ; Botom button coordinate on vertical scroll bar
;         _this_\bar\button[#__b_2]\x = _this_\bar\button\x
;         _this_\bar\button[#__b_2]\width = _this_\bar\button\width
;         _this_\bar\button[#__b_2]\height = _this_\bar\button[#__b_2]\len 
;         _this_\bar\button[#__b_2]\y = _this_\Y+_this_\Height-_this_\bar\button[#__b_2]\height
;       Else 
;         ; Right button coordinate on horizontal scroll bar
;         _this_\bar\button[#__b_2]\y = _this_\bar\button\y
;         _this_\bar\button[#__b_2]\height = _this_\bar\button\height
;         _this_\bar\button[#__b_2]\width = _this_\bar\button[#__b_2]\len 
;         _this_\bar\button[#__b_2]\x = _this_\X+_this_\width-_this_\bar\button[#__b_2]\width 
;       EndIf
;       
;     ElseIf _this_\type = #PB_GadgetType_TrackBar
;     Else
;       If _this_\bar\vertical
;         _this_\bar\button[#__b_2]\x = _this_\x
;         _this_\bar\button[#__b_2]\y = _this_\bar\thumb\pos+_this_\bar\thumb\len
;         _this_\bar\button[#__b_2]\width = _this_\width
;         _this_\bar\button[#__b_2]\height = _this_\height-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\y)
;       Else
;         _this_\bar\button[#__b_2]\x = _this_\bar\thumb\pos+_this_\bar\thumb\len
;         _this_\bar\button[#__b_2]\y = _this_\Y
;         _this_\bar\button[#__b_2]\width = _this_\width-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\x)
;         _this_\bar\button[#__b_2]\height = _this_\height
;       EndIf
;     EndIf
;     
;     ; Thumb coordinate on scroll bar
;     If _this_\bar\thumb\len
;       ;       If _this_\bar\button[#__b_3]\len <> _this_\bar\thumb\len
;       ;         _this_\bar\button[#__b_3]\len = _this_\bar\thumb\len
;       ;       EndIf
;       
;       If _this_\bar\vertical
;         _this_\bar\button[#__b_3]\x = _this_\bar\button\x 
;         _this_\bar\button[#__b_3]\width = _this_\bar\button\width 
;         _this_\bar\button[#__b_3]\y = _this_\bar\thumb\pos
;         _this_\bar\button[#__b_3]\height = _this_\bar\thumb\len                              
;       Else
;         _this_\bar\button[#__b_3]\y = _this_\bar\button\y 
;         _this_\bar\button[#__b_3]\height = _this_\bar\button\height
;         _this_\bar\button[#__b_3]\x = _this_\bar\thumb\pos 
;         _this_\bar\button[#__b_3]\width = _this_\bar\thumb\len                                  
;       EndIf
;       
;     Else
;       If _this_\type = #PB_GadgetType_Spin Or 
;          _this_\type = #PB_GadgetType_ScrollBar
;         ; ????? ???? ???????
;         If _this_\bar\vertical
;           _this_\bar\button[#__b_2]\Height = _this_\Height/2 
;           _this_\bar\button[#__b_2]\y = _this_\y+_this_\bar\button[#__b_2]\Height+Bool(_this_\Height%2) 
;           
;           _this_\bar\button[#__b_1]\y = _this_\y 
;           _this_\bar\button[#__b_1]\Height = _this_\Height/2
;           
;         Else
;           _this_\bar\button[#__b_2]\width = _this_\width/2 
;           _this_\bar\button[#__b_2]\x = _this_\x+_this_\bar\button[#__b_2]\width+Bool(_this_\width%2) 
;           
;           _this_\bar\button[#__b_1]\x = _this_\x 
;           _this_\bar\button[#__b_1]\width = _this_\width/2
;         EndIf
;       EndIf
;     EndIf
;     
;     If _this_\type = #PB_GadgetType_Spin
;       If _this_\bar\vertical      
;         ; Top button coordinate
;         _this_\bar\button[#__b_2]\y = _this_\y+_this_\height/2 + Bool(_this_\height%2) 
;         _this_\bar\button[#__b_2]\height = _this_\height/2 
;         _this_\bar\button[#__b_2]\width = _this_\bar\button\len 
;         _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button\len
;         
;         ; Bottom button coordinate
;         _this_\bar\button[#__b_1]\y = _this_\y 
;         _this_\bar\button[#__b_1]\height = _this_\height/2 
;         _this_\bar\button[#__b_1]\width = _this_\bar\button\len 
;         _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button\len                                 
;       Else    
;         ; Left button coordinate
;         _this_\bar\button[#__b_1]\y = _this_\y 
;         _this_\bar\button[#__b_1]\height = _this_\height 
;         _this_\bar\button[#__b_1]\width = _this_\bar\button\len/2 
;         _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button\len    
;         
;         ; Right button coordinate
;         _this_\bar\button[#__b_2]\y = _this_\y 
;         _this_\bar\button[#__b_2]\height = _this_\height 
;         _this_\bar\button[#__b_2]\width = _this_\bar\button\len/2 
;         _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button\len/2                               
;       EndIf
;     EndIf
;     
;     ; draw track bar coordinate
;     If _this_\type = #PB_GadgetType_TrackBar
;       If _this_\bar\vertical
;         _this_\bar\button[#__b_1]\width = 4
;         _this_\bar\button[#__b_2]\width = 4
;         _this_\bar\button[#__b_3]\width = _this_\bar\button[#__b_3]\len+(Bool(_this_\bar\button[#__b_3]\len<10)*_this_\bar\button[#__b_3]\len)
;         
;         _this_\bar\button[#__b_1]\y = _this_\Y
;         _this_\bar\button[#__b_1]\height = _this_\bar\thumb\pos-_this_\y + _this_\bar\thumb\len/2
;         
;         _this_\bar\button[#__b_2]\y = _this_\bar\thumb\pos+_this_\bar\thumb\len/2
;         _this_\bar\button[#__b_2]\height = _this_\height-(_this_\bar\thumb\pos+_this_\bar\thumb\len/2-_this_\y)
;         
;         If _this_\bar\inverted
;           _this_\bar\button[#__b_1]\x = _this_\x+6
;           _this_\bar\button[#__b_2]\x = _this_\x+6
;           _this_\bar\button[#__b_3]\x = _this_\bar\button[#__b_1]\x-_this_\bar\button[#__b_3]\width/4-1- Bool(_this_\bar\button[#__b_3]\len>10)
;         Else
;           _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button[#__b_1]\width-6
;           _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button[#__b_2]\width-6 
;           _this_\bar\button[#__b_3]\x = _this_\bar\button[#__b_1]\x-_this_\bar\button[#__b_3]\width/2 + Bool(_this_\bar\button[#__b_3]\len>10)
;         EndIf
;       Else
;         _this_\bar\button[#__b_1]\height = 4
;         _this_\bar\button[#__b_2]\height = 4
;         _this_\bar\button[#__b_3]\height = _this_\bar\button[#__b_3]\len+(Bool(_this_\bar\button[#__b_3]\len<10)*_this_\bar\button[#__b_3]\len)
;         
;         _this_\bar\button[#__b_1]\x = _this_\X
;         _this_\bar\button[#__b_1]\width = _this_\bar\thumb\pos-_this_\x + _this_\bar\thumb\len/2
;         
;         _this_\bar\button[#__b_2]\x = _this_\bar\thumb\pos+_this_\bar\thumb\len/2
;         _this_\bar\button[#__b_2]\width = _this_\width-(_this_\bar\thumb\pos+_this_\bar\thumb\len/2-_this_\x)
;         
;         If _this_\bar\inverted
;           _this_\bar\button[#__b_1]\y = _this_\y+_this_\height-_this_\bar\button[#__b_1]\height-6
;           _this_\bar\button[#__b_2]\y = _this_\y+_this_\height-_this_\bar\button[#__b_2]\height-6 
;           _this_\bar\button[#__b_3]\y = _this_\bar\button[#__b_1]\y-_this_\bar\button[#__b_3]\height/2 + Bool(_this_\bar\button[#__b_3]\len>10)
;         Else
;           _this_\bar\button[#__b_1]\y = _this_\y+6
;           _this_\bar\button[#__b_2]\y = _this_\y+6
;           _this_\bar\button[#__b_3]\y = _this_\bar\button[#__b_1]\y-_this_\bar\button[#__b_3]\height/4-1- Bool(_this_\bar\button[#__b_3]\len>10)
;         EndIf
;       EndIf
;     EndIf
;     
;     ;     If _this_\Scroll And _this_\Scroll\v And _this_\Scroll\h
;     ;       _this_\Scroll\x = _this_\Scroll\h\x-_this_\Scroll\h\bar\page\pos
;     ;       _this_\Scroll\y = _this_\Scroll\v\y-_this_\Scroll\v\bar\page\pos
;     ;       _this_\Scroll\width = _this_\Scroll\h\bar\max
;     ;       _this_\Scroll\height = _this_\Scroll\v\bar\max
;     ;     EndIf
;     
;     If _this_\Splitter 
;       ; Splitter childrens auto resize       
;       _splitter_size_(_this_)
;     EndIf
;     
;     If _this_\bar\change
;       If _this_\text
;         _this_\text\change = 1
;         _this_\text\string = "%"+Str(_this_\bar\page\Pos)
;       EndIf
;       
;       
;       ; ScrollArea childrens auto resize 
;       If _this_\parent And _this_\parent\scroll
;         _this_\parent\change =- 1
;         
;         If _this_\bar\vertical
;           _this_\parent\scroll\y = - _this_\bar\page\pos ; _this_\y 
;                                                          ;_this_\parent\scroll\height = _this_\bar\max
;           _childrens_move_(_this_\parent, 0, _this_\bar\change)
;         Else
;           _this_\parent\scroll\x = - _this_\bar\page\pos ; _this_\x 
;                                                          ;_this_\parent\scroll\width = _this_\bar\max
;           _childrens_move_(_this_\parent, _this_\bar\change, 0)
;         EndIf
;       EndIf
;       
;       ;       ; bar change
;       ;       Post(#PB_EventType_StatusChange, _this_, _this_\from, _this_\bar\direction)
;       ;     Else
;       ;       If _this_\parent\scroll
;       ;         If _this_\bar\vertical
;       ;           _this_\parent\scroll\y = _this_\y
;       ;         Else
;       ;           _this_\parent\scroll\x = _this_\x
;       ;         EndIf
;       ;       EndIf
;     EndIf
;     
;   EndMacro
;   
  Procedure.b change(*bar._s_bar, ScrollPos.f)
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
  
  Procedure.b update(*this._struct_)
    With *this
      If (\bar\max-\bar\min) >= \bar\page\len
        ; \bar\change = 1
        
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
        
        If \splitter 
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
          \bar\thumb\len = _thumb_len_(\bar)
          
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
          \bar\thumb\pos = _pos_(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
          
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
        \bar\hide = Bool(Not ((\bar\max-\bar\min) > \bar\page\len))
      EndIf
      
      ProcedureReturn \bar\hide
    EndWith
  EndProcedure
  
  Procedure.i SetPos(*this._struct_, ThumbPos.i)
    Protected ScrollPos.f, Result.i
    
    With *this
      If \splitter And \splitter\fixed
        _area_pos_(*this)
      EndIf
      
      If ThumbPos < \bar\area\pos : ThumbPos = \bar\area\pos : EndIf
      If ThumbPos > \bar\area\end : ThumbPos = \bar\area\end : EndIf
      
      If \bar\thumb\end <> ThumbPos 
        \bar\thumb\end = ThumbPos
        
        ; from thumb pos get scroll pos 
        If \bar\area\end <> ThumbPos
          ScrollPos = \bar\min + Round((ThumbPos - \bar\area\pos) / (\bar\area\len / (\bar\max-\bar\min)), #PB_Round_Nearest)
        Else
          ScrollPos = \bar\page\end
        EndIf
        
        Result = SetState(*this, _invert_(*this\bar, ScrollPos, \bar\inverted))
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState(*this._struct_, ScrollPos.f)
    Protected Result.b
    
    With *this

    If change(*this\bar, ScrollPos)
        \bar\thumb\pos = _pos_(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
        
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
  
  Procedure.l SetAttribute(*this._struct_, Attribute.l, Value.l)
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
              Result = #True
            EndIf
            
          Case #__bar_pageLength
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
            
          Case #__bar_ScrollStep 
            \bar\scrollstep = Value
            
          Case #__bar_buttonSize
            If \bar\button[#__b_3]\len <> Value
              \bar\button[#__b_3]\len = Value
              
              If \type = #PB_GadgetType_ScrollBar
                \bar\button[#__b_1]\len = Value
                \bar\button[#__b_2]\len = Value
              EndIf
              Result = #True
            EndIf
            
          Case #__bar_inverted
            If \bar\inverted <> Bool(Value)
              \bar\inverted = Bool(Value)
              ; \bar\thumb\pos = _bar_pos_(*this, _bar_invert_(*this, \bar\page\pos, \bar\inverted))
              ;  \bar\thumb\pos = _bar_pos_(*this, \bar\page\pos)
              ;  Result = 1
            EndIf
            
        EndSelect
      EndIf
      
      If Result ; And \width And \height ; есть проблемы с imagegadget и scrollareagadget
        \bar\change = #True
        ;\hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
        update(*this)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l _SetAttribute(*this._struct_, Attribute.l, Value.l)
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
              Result = #True
            EndIf
            
          Case #__bar_maximum
            If \bar\max <> Value
              If \bar\min > Value
                \bar\max = \bar\min + 1
              Else
                \bar\max = Value
              EndIf
              
              If \bar\max = 0
                \bar\page\pos = 0
              EndIf
              
              Result = #True
            EndIf
            
          Case #__bar_pageLength
            If \bar\page\len <> Value
              \bar\page\len = Value
              
              If Not \bar\max
                If \bar\min > Value
                  \bar\max = \bar\min + 1
                Else
                  \bar\max = Value
                EndIf
              EndIf
              
              ;               If Value > (\bar\max-\bar\min) 
              ;                 ;\bar\max = Value ; ???? ????? page_length ??????? ?????? maximum ?? ?? ????????? ????????
              ; ;                 If \bar\max = 0 
              ; ;                   \bar\max = Value 
              ; ;                 EndIf
              ; ;                 ; 14 ?????? 2019? ???????????
              ; ;                 If \bar\max < Value
              ; ;                   \bar\max = Value 
              ; ;                 EndIf
              ;                  \bar\page\len = (\bar\max-\bar\min)
              ;               Else
              ;                 \bar\page\len = Value
              ;               EndIf
              
              Result = #True
            EndIf
            
          Case #__bar_scrollstep 
            \bar\scrollstep = Value
            
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
            If \bar\inverted <> Bool(Value)
              \bar\inverted = Bool(Value)
              \bar\thumb\pos = _pos_(*this, _invert_(*this\bar, \bar\page\pos, \bar\inverted))
              ;  \bar\thumb\pos = _pos_(*this, \bar\page\pos)
              ;  Result = 1
            EndIf
            
        EndSelect
      EndIf
      
      If Result ; And \width And \height ; ???? ???????? ? imagegadget ? scrollareagadget
        \hide = update(*this)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b resize(*this._struct_, X.l,Y.l,Width.l,Height.l)
    With *this
      If X <> #PB_Ignore : \x = X : EndIf 
      If Y <> #PB_Ignore : \y = Y : EndIf 
      If Width <> #PB_Ignore : \width = Width : EndIf 
      If Height <> #PB_Ignore : \height = height : EndIf
      
      ProcedureReturn update(*this)
    EndWith
  EndProcedure
  
  Procedure.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    ;     If Not (*scroll\v And *scroll\h)
    ;       ProcedureReturn
    ;     EndIf
    
    With *scroll
      Protected iHeight, iWidth
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\bar\page\len<>iHeight : SetAttribute(\v, #__Bar_PageLength, iHeight) : EndIf
      If \h\height And \h\bar\page\len<>iWidth : SetAttribute(\h, #__Bar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\bar\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\bar\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\bar\page\len<>iHeight : SetAttribute(\v, #__Bar_PageLength, iHeight) : EndIf
      If \h\bar\page\len<>iWidth : SetAttribute(\h, #__Bar_PageLength, iWidth) : EndIf
      
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
  
  Procedure.b _Resizes(*scroll._s_scroll, X.l,Y.l,Width.l,Height.l )
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
    *this\event = AllocateStructure(_s_event_)
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
          
          If *leave = *this
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
            Debug *this
            
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
  
  Procedure.b Draw_Scroll(*this._struct_)
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
  
  Procedure.b Draw_progress(*this._struct_)
    *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
    *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
    
    Draw_Scroll(*this)
    
    ; Draw string
    If *this\text And *this\text\string
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\bar\button[#__b_3]\color\frame[*this\bar\button[#__b_3]\color\state])
    EndIf
  EndProcedure
  
  Procedure.b Draw_track(*this._struct_)
    *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
    *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
    *this\bar\button[#__b_3]\color\state = 2
    
    Draw_Scroll(*this)
  EndProcedure
  
  Procedure.i Draw_Spin(*this._struct_) 
    Draw_Scroll(*this)
    
    ; Draw string
    If *this\text And *this\text\string
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[*this\color\state])
    EndIf
  EndProcedure
  
  Procedure.b Draw_Splitter(*this._struct_)
    Protected Pos, Size, round.d = 2
    
    With *this
      If *this > 0
        DrawingMode(#PB_2DDrawing_Outlined)
        If \bar\mode
          Protected *first._struct_ = \splitter\first
          Protected *second._struct_ = \splitter\second
          
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
  
  Procedure.b draw(*this._struct_)
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
  Procedure.i Bar(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scrollstep.f=1.0)
    Protected *this._struct_ = AllocateStructure(_struct_)
    
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
        \bar\vertical = Bool(Flag & #PB_ProgressBar_Vertical = #PB_ProgressBar_Vertical)
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
        \bar\vertical = Bool(Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical)
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
        \text\padding = #__spin_padding_text
        
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
      
        
      ; set default text
      \bar\change = 1
      
      If \bar\min <> Min : SetAttribute(*this, #__bar_minimum, Min) : EndIf
      If \bar\max <> Max : SetAttribute(*this, #__bar_maximum, Max) : EndIf
      If \bar\page\len <> Pagelength : SetAttribute(*this, #__bar_pageLength, Pagelength) : EndIf
      If \bar\inverted : SetAttribute(*this, #__bar_inverted, #True) : EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=7)
    Protected *this._struct_ = Bar(#PB_GadgetType_TrackBar, 15, Min, Max, 0, Flag|#__bar_nobuttons, round)
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened)
    Resize(*this, X,Y,Width,Height)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0)
    Protected *this._struct_ = Bar(#PB_GadgetType_ProgressBar, 0, Min, Max, 0, Flag|#__bar_nobuttons, round)
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Spin(X.l,Y.l,Width.l,Height.l, Min.l,Max.l, Flag.i=0, round.l=0, Increment.f=1.0)
    Protected *this._struct_
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
    
    *this = Bar(#PB_GadgetType_Spin, 16, Min, Max, 0, Flag, round, 0, Increment)
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l,Max.l,PageLength.l, Flag.i=0, round.l=0)
    Protected *this._struct_
    
    If (Bool(Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical) Or Bool(Flag & #__Bar_Vertical = #__Bar_Vertical))
      *this = Bar(#PB_GadgetType_ScrollBar, width, Min, Max, PageLength, Flag, round)
    Else
      *this = Bar(#PB_GadgetType_ScrollBar, height, Min, Max, PageLength, Flag, round)
    EndIf
    
    _set_last_parameters_(*this, *this\type, Flag, Root()\opened) 
    Resize(*this, X,Y,Width,Height)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.i=0)
    Protected *this._s_widget 
    
    If Bool(Not Flag&#PB_Splitter_Vertical)
      *this = Bar(#PB_GadgetType_Splitter, 7, 0, Height, 0, Flag|#__bar_nobuttons, 0)
    Else
      *this = Bar(#PB_GadgetType_Splitter, 7, 0, Width, 0, Flag|#__bar_nobuttons, 0)
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
DeclareModule Editor
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  Macro _get_colors_()
    colors::this
  EndMacro
  
  
  ;   Macro _const_
  ;     constants::#__
  ;   EndMacro
  
  ;   Macro _struct_
  ;     structures::_s_widget
  ;   EndMacro
  
  Structure _struct_ Extends structures::_s_widget : EndStructure
  
  Global *event._s_event_ = AllocateStructure(_s_event_)
  
  Macro Root()
    *event\root
  EndMacro
  
  Macro GetActive() ; Returns active window
    *event\active
  EndMacro
  
  
  ;- - DECLAREs MACROs
  ;Declare.i Update(*this)
  
  ;- DECLARE
  Declare.i SetItemState(*this, Item.i, State.i)
  Declare   GetState(*this)
  Declare.s GetText(*this)
  Declare.i ClearItems(*this)
  Declare.i CountItems(*this)
  Declare.i RemoveItem(*this, Item.i)
  Declare   SetState(*this, State.l)
  Declare   GetAttribute(*this, Attribute.i)
  Declare   SetAttribute(*this, Attribute.i, Value.i)
  Declare   SetText(*this, Text.s, Item.i=0)
  Declare   SetFont(*this, FontID.i)
  Declare.i AddItem(*this, Item.i,Text.s,Image.i=-1,Flag.i=0)
  
  ;Declare.i Make(*this)
  Declare   events(*this, EventType.l)
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
  Declare.i Editor(X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=0, round.i=0)
  Declare   ReDraw(*this)
  Declare   Draw(*this)
  
  Declare.l SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l=0)
  Declare.l GetItemColor(*this, Item.l, ColorType.l, Column.l=0)
  
EndDeclareModule

Module Editor
  ;   Global *Buffer = AllocateMemory(10000000)
  ;   Global *Pointer = *Buffer
  ;   
  ;   Procedure.i Update(*this._struct_)
  ;     *this\text\string.s = PeekS(*Buffer)
  ;     *this\text\change = 1
  ;   EndProcedure
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  
  Declare.i g_callback()
  
  Macro _from_X_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool(_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_))
  EndMacro
  
  Macro _from_Y_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool(_mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool(_from_X_(_mouse_x_, _mouse_y_, _type_, _mode_) And _from_Y_(_mouse_x_, _mouse_y_, _type_, _mode_))
  EndMacro
  
  
  Macro _set_content_Y_(_this_)
    If _this_\text\align\bottom
      Text_Y=(Height-(_this_\text\height*_this_\count\items)-Text_Y) 
      
    ElseIf _this_\text\align\Vertical
      Text_Y=((Height-(_this_\text\height*_this_\count\items))/2)
    EndIf
  EndMacro
  
  Macro _set_content_X_(_this_)
    If _this_\text\align\right
      Text_X=((_this_\width[2]-_this_\text\x*2)-_this_\row\_s()\text\width)
      
    ElseIf _this_\text\align\horizontal
      Text_X=((_this_\width[2]-_this_\text\x*2)-_this_\row\_s()\text\width-Bool(_this_\row\_s()\text\width % 2))/2 
      
    Else
      Text_X=_this_\row\margin\width
    EndIf
  EndMacro
  
  Macro _line_resize_X_(_this_)
    _this_\row\_s()\width = Width
    _this_\row\_s()\x = _this_\x[2]+_this_\text\x
    _this_\row\_s()\text\x = _this_\row\_s()\x + Text_X
  EndMacro
  
  Macro _line_resize_Y_(_this_)
    _this_\row\_s()\height = _this_\text\height
    _this_\row\_s()\text\height = _this_\text\height
    _this_\row\_s()\y = _this_\y[1]+_this_\text\y + _this_\scroll\height + Text_Y
    _this_\row\_s()\text\y = _this_\row\_s()\y + (_this_\row\_s()\height-_this_\row\_s()\text\height)/2
  EndMacro
  
  Macro _make_line_pos_(_this_, _len_)
    _this_\row\_s()\text\len = _len_
    _this_\row\_s()\text\pos = _this_\text\pos
    _this_\text\pos + _this_\row\_s()\text\len + 1 ; Len(#LF$)
  EndMacro
  
  Macro _make_scroll_height_(_this_)
    _this_\scroll\height + _this_\row\_s()\height + _this_\flag\gridlines
    
    If _this_\scroll\v And _this_\scroll\v\bar\scrollstep <> _this_\row\_s()\height + Bool(_this_\flag\gridlines)
      _this_\scroll\v\bar\scrollstep = _this_\row\_s()\height + Bool(_this_\flag\gridlines)
    EndIf
  EndMacro
  
  Macro _make_scroll_width_(_this_)
;     If _this_\scroll\width < (_this_\row\_s()\text\x+_this_\row\_s()\text\width+_this_\text\x)-_this_\x[2]
;       _this_\scroll\width = (_this_\row\_s()\text\x+_this_\row\_s()\text\width+_this_\text\x)-_this_\x[2]
;     EndIf
    _this_\scroll\x = _this_\row\_s()\text\x-_this_\text\x-_this_\bs
    
    If _this_\scroll\width < _this_\row\_s()\text\width+_this_\text\x*2
      _this_\scroll\width = _this_\row\_s()\text\width+_this_\text\x*2
    EndIf
  EndMacro
  
  Macro _repaint_(_this_)
    If _this_\root And Not _this_\repaint : _this_\repaint = 1
      PostEvent(#PB_Event_Gadget, _this_\root\window, _this_\root\canvas, #PB_EventType_Repaint);, _this_)
    EndIf
  EndMacro 
  
  Macro _repaint_items_(_this_)
    If _this_\count\items = 0 Or 
       (Not _this_\hide And _this_\row\count And 
        (_this_\count\items % _this_\row\count) = 0)
      
      _this_\change = 1
      _this_\row\count = _this_\count\items
      _repaint_(_this_)
    EndIf  
  EndMacro
  
  
  
  ;-
  ;- PUBLIC
  Procedure _start_drawing_(*this._struct_)
    If StartDrawing(CanvasOutput(*this\root\canvas)) 
      
      If *this\text\fontID
        DrawingFont(*this\text\fontID) 
      EndIf
      
      ProcedureReturn #True
    EndIf    
  EndProcedure
  
  ;-
  Macro _text_cut_(_this_)
    _text_paste_(_this_, "")
  EndMacro
  
  Macro _bar_scrolled_(_this_, _pos_, _len_)
    Bool(Bool(((_pos_+_this_\bar\min)-_this_\bar\page\pos) < 0 And 
              Bar::SetState(_this_, (_pos_+_this_\bar\min))) Or
         Bool(((_pos_+_this_\bar\min)-_this_\bar\page\pos) > (_this_\bar\page\len-(_len_)) And 
              Bar::SetState(_this_, (_pos_+_this_\bar\min)-(_this_\bar\page\len-(_len_)))))
  EndMacro
  
  Macro _text_scroll_x_(_this_)
    *this\change = _bar_scrolled_(*this\scroll\h, _this_\text\caret\x-Bool(_this_\text\caret\x>0) * (_this_\scroll\h\x+_this_\text\x+_this_\bs-_this_\text\caret\width), (_this_\text\x*2+_this_\bs+_this_\text\caret\width)) ; ok
  EndMacro
  
  Macro _text_scroll_y_(_this_)
    *this\change = _bar_scrolled_(*this\scroll\v, _this_\text\caret\y-Bool(_this_\text\caret\y>0) * _this_\scroll\v\y, _this_\text\caret\height) ; ok
  EndMacro
  
  
  ;-
  Procedure.l _text_caret_(*this._struct_)
    Protected i.l, X.l, Position.l =- 1,  
              MouseX.l, Distance.f, MinDistance.f = Infinity()
    
    MouseX = *this\root\mouse\x - (*this\row\_s()\text\x+*this\scroll\x)
    
    ; Get caret pos
    For i = 0 To *this\row\_s()\text\len
      X = TextWidth(Left(*this\row\_s()\text\string, i))
      Distance = (MouseX-X)*(MouseX-X)
      
      If MinDistance > Distance 
        MinDistance = Distance
        Position = i
      EndIf
    Next 
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure   _edit_sel_(*this._struct_, _pos_, _len_)
    If _pos_ < 0 : _pos_ = 0 : EndIf
    If _len_ < 0 : _len_ = 0 : EndIf
    
    If _pos_ > *this\row\_s()\text\len
      _pos_ = *this\row\_s()\text\len
    EndIf
    
    If _len_ > *this\row\_s()\text\len
      _len_ = *this\row\_s()\text\len
    EndIf
    
    Protected _line_ = *this\index[1]
    Protected _caret_last_len_ = Bool(_line_ <> *this\index[2] And 
                                      (*this\row\_s()\index < *this\index[1] Or 
                                       *this\row\_s()\index < *this\index[2])) * *this\flag\fullselection
    
;     If  _caret_last_len_
;       _caret_last_len_ = *this\width[2]
;     EndIf
    
    *this\row\_s()\text\edit[1]\len = _pos_
    *this\row\_s()\text\edit[2]\len = _len_
    
    *this\row\_s()\text\edit[1]\pos = 0 
    *this\row\_s()\text\edit[2]\pos = *this\row\_s()\text\edit[1]\len
    
    *this\row\_s()\text\edit[3]\pos = *this\row\_s()\text\edit[2]\pos+*this\row\_s()\text\edit[2]\len 
    *this\row\_s()\text\edit[3]\len = *this\row\_s()\text\len-*this\row\_s()\text\edit[3]\pos
    
    ; set string & size (left;selected;right)
    If *this\row\_s()\text\edit[1]\len > 0
      *this\row\_s()\text\edit[1]\string = Left(*this\row\_s()\text\string, *this\row\_s()\text\edit[1]\len)
      *this\row\_s()\text\edit[1]\width = TextWidth(*this\row\_s()\text\edit[1]\string) 
    Else
      *this\row\_s()\text\edit[1]\string = ""
      *this\row\_s()\text\edit[1]\width = 0
    EndIf
    If *this\row\_s()\text\edit[2]\len > 0
      If *this\row\_s()\text\edit[2]\len <> *this\row\_s()\text\len
        *this\row\_s()\text\edit[2]\string = Mid(*this\row\_s()\text\string, 1 + *this\row\_s()\text\edit[2]\pos, *this\row\_s()\text\edit[2]\len)
        *this\row\_s()\text\edit[2]\width = TextWidth(*this\row\_s()\text\edit[2]\string) + _caret_last_len_ 
;         + Bool((_line_ <  *this\index[2] And *this\row\_s()\index = _line_) Or
;                                                                                                  ;(_line_ <> *this\row\_s()\index And *this\row\_s()\index <> *this\index[2]) Or
;         (_line_  > *this\index[2] And *this\row\_s()\index = *this\index[2])) * *this\flag\fullselection
      Else
        *this\row\_s()\text\edit[2]\string = *this\row\_s()\text\string
        *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width + _caret_last_len_
      EndIf
    Else
      *this\row\_s()\text\edit[2]\string = ""
      *this\row\_s()\text\edit[2]\width = _caret_last_len_
    EndIf
    If *this\row\_s()\text\edit[3]\len > 0
      *this\row\_s()\text\edit[3]\string = Right(*this\row\_s()\text\string, *this\row\_s()\text\edit[3]\len)
      *this\row\_s()\text\edit[3]\width = TextWidth(*this\row\_s()\text\edit[3]\string)  
    Else
      *this\row\_s()\text\edit[3]\string = ""
      *this\row\_s()\text\edit[3]\width = 0
    EndIf
    
    ; because bug in mac os
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      If *this\row\_s()\text\edit[2]\width And Not (_line_ = *this\index[2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]) And
         *this\row\_s()\text\edit[2]\width <> *this\row\_s()\text\width - (*this\row\_s()\text\edit[1]\width+*this\row\_s()\text\edit[3]\width) + _caret_last_len_
        *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width - (*this\row\_s()\text\edit[1]\width+*this\row\_s()\text\edit[3]\width) + _caret_last_len_
      EndIf
    CompilerEndIf
    
    ; set position (left;selected;right)
    *this\row\_s()\text\edit[1]\x = *this\row\_s()\text\x 
    *this\row\_s()\text\edit[2]\x = (*this\row\_s()\text\edit[1]\x+*this\row\_s()\text\edit[1]\width) 
    *this\row\_s()\text\edit[3]\x = (*this\row\_s()\text\edit[2]\x+*this\row\_s()\text\edit[2]\width)
    
    ; если выделили свнизу вверх
    ; то запоминаем позицию начала текста[3]
    If *this\index[2] >= *this\row\_s()\index
      *this\text\edit[1]\len = (*this\row\_s()\text\pos+*this\row\_s()\text\edit[2]\pos)
      *this\text\edit[2]\pos = *this\text\edit[1]\len
    EndIf
    
    ; если выделили сверху ввниз
    ; то запоминаем позицию начала текста[3]
    If *this\index[2] =< *this\row\_s()\index
      *this\text\edit[3]\pos = (*this\row\_s()\text\pos+*this\row\_s()\text\edit[3]\pos)
      *this\text\edit[3]\len = (*this\text\len-*this\text\edit[3]\pos)
    EndIf
    
    ; text/pos/len/state
    If _line_ = *this\row\_s()\index
      If *this\text\edit[2]\len <> (*this\text\edit[3]\pos-*this\text\edit[2]\pos)
        *this\text\edit[2]\len = (*this\text\edit[3]\pos-*this\text\edit[2]\pos)
      EndIf
      
      ; set text (left;selected;right)
      If *this\text\edit[1]\len > 0
        *this\text\edit[1]\string = Left(*this\text\string.s, *this\text\edit[1]\len) 
      Else
        *this\text\edit[1]\string = ""
      EndIf
      If *this\text\edit[2]\len > 0
        *this\text\edit[2]\string = Mid(*this\text\string.s, 1 + *this\text\edit[2]\pos, *this\text\edit[2]\len) 
      Else
        *this\text\edit[2]\string = ""
      EndIf
      If *this\text\edit[3]\len > 0
        *this\text\edit[3]\string = Right(*this\text\string.s, *this\text\edit[3]\len)
      Else
        *this\text\edit[3]\string = ""
      EndIf
      
      ;       ; set cursor pos
      ;       If _line_ = *this\row\_s()\index
      *this\text\caret\y = *this\row\_s()\text\y
      *this\text\caret\height = *this\row\_s()\text\height
      
      If _line_ > *this\index[2] Or
         (_line_ = *this\index[2] And *this\text\caret\pos[1] > *this\text\caret\pos[2])
        *this\text\caret\x = *this\row\_s()\text\edit[3]\x
        *this\text\caret\pos = *this\row\_s()\text\pos + *this\row\_s()\text\edit[3]\pos
      Else
        *this\text\caret\x = *this\row\_s()\text\edit[2]\x
        *this\text\caret\pos = *this\row\_s()\text\pos + *this\row\_s()\text\edit[2]\pos
      EndIf
      
      *this\text\caret\width = 1
      
      ProcedureReturn 1
      ;       EndIf
    EndIf
    
  EndProcedure
  
  Procedure   _edit_sel_set_(*this._struct_, _line_, _scroll_) ; Ok
                                                               ;     Debug  ""+*this\text\caret\pos[1] +" "+ *this\text\caret\pos[2]
                                                               ;     ProcedureReturn 3
    Macro _edit_sel_reset_(_this_)
      _this_\text\edit[1]\len = 0 
      _this_\text\edit[2]\len = 0 
      _this_\text\edit[3]\len = 0 
      
      _this_\text\edit[1]\pos = 0 
      _this_\text\edit[2]\pos = 0 
      _this_\text\edit[3]\pos = 0 
      
      _this_\text\edit[1]\width = 0 
      _this_\text\edit[2]\width = 0 
      _this_\text\edit[3]\width = 0 
      
      _this_\text\edit[1]\string = ""
      _this_\text\edit[2]\string = "" 
      _this_\text\edit[3]\string = ""
    EndMacro
    
    
    If _scroll_
      
      PushListPosition(*this\row\_s()) 
      ForEach *this\row\_s()
        If (_line_ = *this\row\_s()\index Or *this\index[2] = *this\row\_s()\index) Or    ; линия
           (_line_ < *this\row\_s()\index And *this\index[2] > *this\row\_s()\index) Or   ; верх
           (_line_ > *this\row\_s()\index And *this\index[2] < *this\row\_s()\index)      ; вниз
          
          If _line_ = *this\index[2]  ; And *this\index[2] = *this\row\_s()\index
            If *this\text\caret\pos[1] > *this\text\caret\pos[2]
              _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2])
            Else
              _edit_sel_(*this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1])
            EndIf
            
          ElseIf (_line_ < *this\row\_s()\index And *this\index[2] > *this\row\_s()\index) Or   ; верх
                 (_line_ > *this\row\_s()\index And *this\index[2] < *this\row\_s()\index)      ; вниз
            
            If _line_ < 0
              ; если курсор перешел за верхный предел
              *this\index[1] = 0
              *this\text\caret\pos[1] = 0
            ElseIf _line_ > *this\count\items - 1
              ; если курсор перешел за нижный предел
              *this\index[1] = *this\count\items - 1
              *this\text\caret\pos[1] = *this\row\_s()\text\len
            EndIf
            
            _edit_sel_(*this, 0, *this\row\_s()\text\len)
            
          ElseIf _line_ = *this\row\_s()\index 
            If _line_ > *this\index[2] 
              _edit_sel_(*this, 0, *this\text\caret\pos[1])
            Else
              _edit_sel_(*this, *this\text\caret\pos[1], *this\row\_s()\text\len - *this\text\caret\pos[1])
            EndIf
            
          ElseIf *this\index[2] = *this\row\_s()\index
            
            
            If *this\count\items = 1 And 
               (_line_ < 0 Or _line_ > *this\count\items - 1)
              ; если курсор перешел за пределы итемов
              *this\index[1] = 0
              
              If *this\text\caret\pos[2] > *this\text\caret\pos[1]
                _edit_sel_(*this, 0, *this\text\caret\pos[2])
              Else
                *this\text\caret\pos[1] = *this\row\_s()\text\len
                _edit_sel_(*this, *this\text\caret\pos[2], Bool(_line_ <> *this\index[2]) * (*this\row\_s()\text\len - *this\text\caret\pos[2]))
              EndIf
              
              *this\index[1] = _line_
            Else
              If _line_ < 0
                *this\index[1] = 0
                *this\text\caret\pos[1] = 0
              ElseIf _line_ > *this\count\items - 1
                *this\index[1] = *this\count\items - 1
                *this\text\caret\pos[1] = *this\row\_s()\text\len
              EndIf
              
              If *this\index[2] > _line_ 
                _edit_sel_(*this, 0, *this\text\caret\pos[2])
              Else
                _edit_sel_(*this, *this\text\caret\pos[2], (*this\row\_s()\text\len - *this\text\caret\pos[2]))
              EndIf
            EndIf
            
          EndIf
          
          If *this\index[1] = *this\row\_s()\index
            ; vertical scroll
            If _scroll_ = 1
              _text_scroll_y_(*this)
            EndIf
            
            ; horizontal scroll
            If _scroll_ =- 1
              _text_scroll_x_(*this)
            EndIf
          EndIf
          
        ElseIf (*this\row\_s()\text\edit[2]\width <> 0 And 
                *this\index[2] <> *this\row\_s()\index And _line_ <> *this\row\_s()\index)
          
          ; reset selected string
          _edit_sel_reset_(*this\row\_s())
          
        EndIf
      Next
      PopListPosition(*this\row\_s()) 
      
    EndIf 
    
    ProcedureReturn _scroll_
  EndProcedure
  
  Procedure   _edit_sel_draw_(*this._struct_, _line_, _caret_=-1) ; Ok
    Protected Repaint.b
    
    Macro _edit_sel_is_line_(_this_)
      Bool(_this_\row\_s()\text\edit[2]\width And 
           _this_\root\mouse\x > _this_\row\_s()\text\edit[2]\x-_this_\scroll\h\bar\page\pos And
           _this_\root\mouse\y > _this_\row\_s()\text\y-_this_\scroll\v\bar\page\pos And 
           _this_\root\mouse\y < (_this_\row\_s()\text\y+_this_\row\_s()\text\height)-_this_\scroll\v\bar\page\pos And
           _this_\root\mouse\x < (_this_\row\_s()\text\edit[2]\x+_this_\row\_s()\text\edit[2]\width)-_this_\scroll\h\bar\page\pos)
    EndMacro
    
    With *this
      ; select enter mouse item
      If _line_ >= 0 And 
         _line_ < *this\count\items And 
         _line_ <> *this\row\_s()\index
        \row\_s()\color\State = 0
        SelectElement(*this\row\_s(), _line_) 
        \row\_s()\color\State = 1
      EndIf
      
      If _start_drawing_(*this)
        
        If _caret_ =- 1
          _caret_ = _text_caret_(*this) 
        Else
          ; Ctrl - A
          Repaint =- 2
        EndIf
        
        ; если перемещаем выделеный текст
        If *this\row\box\checked 
          If *this\index[1] <> _line_
            *this\index[1] = _line_
            Repaint = 1
          EndIf
          
          If _edit_sel_is_line_(*this)
            If *this\text\caret\pos[2] <> *this\row\_s()\text\edit[1]\len
              *this\text\caret\pos[2] = *this\row\_s()\text\edit[1]\len
              *this\text\caret\pos[1] = *this\row\_s()\text\edit[1]\len+*this\row\_s()\text\edit[2]\len
              
              If _caret_ < *this\row\_s()\text\edit[1]\len+*this\row\_s()\text\edit[2]\len/2
                _caret_ = *this\row\_s()\text\edit[1]\len
              Else
                _caret_ = *this\row\_s()\text\edit[1]\len+*this\row\_s()\text\edit[2]\len
              EndIf
              
              Repaint =- 1
            EndIf
          Else
            If *this\text\caret\pos[2] <> _caret_
              *this\text\caret\pos[2] = _caret_
              *this\text\caret\pos[1] = _caret_
              Repaint =- 1
            EndIf
          EndIf
          
          If Repaint 
            ; set cursor pos
            *this\text\caret\y = *this\row\_s()\text\y
            *this\text\caret\height = *this\row\_s()\text\height - 1
            *this\text\caret\x = *this\row\_s()\text\x + TextWidth(Left(*this\row\_s()\text\string, _caret_))
            _text_scroll_x_(*this)
          EndIf
          
        Else
          If *this\text\caret\pos[1] <> _caret_
            *this\text\caret\pos[1] = _caret_
            Repaint =- 1 ; scroll horizontal
          EndIf
          
          If *this\index[1] <> _line_ 
            *this\index[1] = _line_ ; scroll vertical
            Repaint = 1
          EndIf
          
          Repaint = _edit_sel_set_(*this, _line_, Repaint)
        EndIf
        
        StopDrawing() 
      EndIf
    EndWith
    
    ProcedureReturn Bool(Repaint)
  EndProcedure
  
  Procedure   _edit_sel_update_(*this._struct_)
    ; ProcedureReturn 
    
    ; key - (return & backspace)
    If *this\index[2] = *this\row\_s()\index 
      *this\row\selected = *this\row\_s()
      
      If *this\index[2] = *this\index[1]
        If *this\text\caret\pos[1] > *this\text\caret\pos[2]
          _edit_sel_(*this, *this\text\caret\pos[2] , *this\text\caret\pos[1]-*this\text\caret\pos[2])
        Else
          _edit_sel_(*this, *this\text\caret\pos[1] , *this\text\caret\pos[2]-*this\text\caret\pos[1])
        EndIf
      EndIf
    EndIf
    
    ;     If *this\text\count = *this\count\items
    ;       ; move caret
    ;       If *this\index[2] + 1 = *this\row\_s()\index 
    ;         ;         *this\index[1] = *this\row\_s()\index 
    ;         ;         *this\index[2] = *this\index[1]
    ;         
    ;         If *this\index[2] = *this\index[1]
    ;           If *this\text\caret\pos[1]<>*this\text\caret\pos[2]
    ;             _edit_sel_(*this, 0, *this\text\caret\pos[1]-*this\row\selected\text\len)
    ;           Else
    ;             _edit_sel_(*this, *this\text\caret\pos[1]-*this\row\selected\text\len, 0)
    ;           EndIf
    ;         EndIf
    ;         
    ;       EndIf
    ;     EndIf
    
    
    
    
    Protected  _line_ = *this\index[1]
    
    
    If _line_ = *this\index[2]  ; And *this\index[2] = *this\row\_s()\index
      If *this\text\caret\pos[1] > *this\text\caret\pos[2]
        _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2])
      Else
        _edit_sel_(*this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1])
      EndIf
      
    ElseIf (*this\index[2] > *this\row\_s()\index And _line_ < *this\row\_s()\index) Or   ; верх
           (*this\index[2] < *this\row\_s()\index And _line_ > *this\row\_s()\index)      ; вниз
      
      _edit_sel_(*this, 0, *this\row\_s()\text\len)
      
    ElseIf _line_ = *this\row\_s()\index 
      If _line_ > *this\index[2] 
        _edit_sel_(*this, 0, *this\text\caret\pos[1])
      Else
        _edit_sel_(*this, *this\text\caret\pos[1], *this\row\_s()\text\len - *this\text\caret\pos[1])
      EndIf
      
    ElseIf *this\index[2] = *this\row\_s()\index
      If *this\index[2] > _line_ 
        _edit_sel_(*this, 0, *this\text\caret\pos[2])
      Else
        _edit_sel_(*this, *this\text\caret\pos[2], *this\row\_s()\text\len - *this\text\caret\pos[2])
      EndIf
      
    EndIf
    
    
    
    
    
    
    ProcedureReturn 
    
    If (*this\index[2] = *this\row\_s()\index Or *this\index[1] = *this\row\_s()\index) Or    ; линия
       (*this\index[2] > *this\row\_s()\index And *this\index[1] < *this\row\_s()\index) Or   ; верх
       (*this\index[2] < *this\row\_s()\index And *this\index[1] > *this\row\_s()\index)      ; вниз
      
      If (*this\index[2] > *this\row\_s()\index And *this\index[1] < *this\row\_s()\index) Or   ; верх
         (*this\index[2] < *this\row\_s()\index And *this\index[1] > *this\row\_s()\index)      ; вниз
        
        *this\row\_s()\text\edit[1]\len = 0 
        *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len
        
      ElseIf *this\index[1] = *this\row\_s()\index 
        If *this\index[1] > *this\index[2] 
          *this\row\_s()\text\edit[1]\len = 0 
          *this\row\_s()\text\edit[2]\len = *this\text\caret\pos[1]
        Else
          *this\row\_s()\text\edit[1]\len = *this\text\caret\pos[1] 
          *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[1]\len
        EndIf
        
      ElseIf *this\index[2] = *this\row\_s()\index
        If *this\index[2] > *this\index[1] 
          *this\row\_s()\text\edit[1]\len = 0 
          *this\row\_s()\text\edit[2]\len = *this\text\caret\pos[2]
        Else
          *this\row\_s()\text\edit[1]\len = *this\text\caret\pos[2] 
          *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[1]\len
        EndIf
        
      EndIf
      
      *this\row\_s()\text\edit[1]\pos = 0 
      *this\row\_s()\text\edit[2]\pos = *this\row\_s()\text\edit[1]\len
      
      *this\row\_s()\text\edit[3]\pos = *this\row\_s()\text\edit[2]\pos+*this\row\_s()\text\edit[2]\len 
      *this\row\_s()\text\edit[3]\len = *this\row\_s()\text\len-*this\row\_s()\text\edit[3]\pos
      
      ; set string & size (left;selected;right)
      If *this\row\_s()\text\edit[1]\len > 0
        *this\row\_s()\text\edit[1]\string = Left(*this\row\_s()\text\string, *this\row\_s()\text\edit[1]\len)
        *this\row\_s()\text\edit[1]\width = TextWidth(*this\row\_s()\text\edit[1]\string) 
      Else
        *this\row\_s()\text\edit[1]\string = ""
        *this\row\_s()\text\edit[1]\width = 0
      EndIf
      If *this\row\_s()\text\edit[2]\len > 0
        If *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len
          *this\row\_s()\text\edit[2]\string = *this\row\_s()\text\string
          *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width + *this\flag\fullselection
        Else
          *this\row\_s()\text\edit[2]\string = Mid(*this\row\_s()\text\string, 1 + *this\row\_s()\text\edit[2]\pos, *this\row\_s()\text\edit[2]\len)
          *this\row\_s()\text\edit[2]\width = TextWidth(*this\row\_s()\text\edit[2]\string) + Bool((*this\index[1] <  *this\index[2] And *this\row\_s()\index = *this\index[1]) Or
                                                                                                   ; (*this\index[1] <> *this\row\_s()\index And *this\row\_s()\index <> *this\index[2]) Or
          (*this\index[1]  > *this\index[2] And *this\row\_s()\index = *this\index[2])) * *this\flag\fullselection
        EndIf
      Else
        *this\row\_s()\text\edit[2]\string = ""
        *this\row\_s()\text\edit[2]\width = 0
      EndIf
      If *this\row\_s()\text\edit[3]\len > 0
        *this\row\_s()\text\edit[3]\string = Right(*this\row\_s()\text\string, *this\row\_s()\text\edit[3]\len)
        *this\row\_s()\text\edit[3]\width = TextWidth(*this\row\_s()\text\edit[3]\string)  
      Else
        *this\row\_s()\text\edit[3]\string = ""
        *this\row\_s()\text\edit[3]\width = 0
      EndIf
      
      ; set position (left;selected;right)
      *this\row\_s()\text\edit[1]\x = *this\row\_s()\text\x 
      *this\row\_s()\text\edit[2]\x = (*this\row\_s()\text\edit[1]\x+*this\row\_s()\text\edit[1]\width) 
      *this\row\_s()\text\edit[3]\x = (*this\row\_s()\text\edit[2]\x+*this\row\_s()\text\edit[2]\width)
      
      ; set cursor pos
      If *this\index[1] = *this\row\_s()\index 
        *this\text\caret\y = *this\row\_s()\text\y
        *this\text\caret\height = *this\row\_s()\text\height
        
        If *this\index[1] > *this\index[2] Or
           (*this\index[1] = *this\index[2] And *this\text\caret\pos[1] > *this\text\caret\pos[2])
          *this\text\caret\x = *this\row\_s()\text\edit[3]\x
        Else
          *this\text\caret\x = *this\row\_s()\text\edit[2]\x
        EndIf
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure.i _edit_sel_start_(*this._struct_)
    Protected result.i, i.i, char.i
    
    Macro _edit_sel_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *this
      ; |<<<<<< left edge of the word 
      If \text\caret\pos[1] > 0 
        For i = \text\caret\pos[1] - 1 To 1 Step - 1
          char = Asc(Mid(\row\_s()\text\string.s, i, 1))
          If _edit_sel_end_(char)
            Break
          EndIf
        Next 
        
        result = i
      EndIf
    EndWith  
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.i _edit_sel_stop_(*this._struct_)
    Protected result.i, i.i, char.i
    
    With *this
      ; >>>>>>| right edge of the word
      For i = \text\caret\pos[1] + 2 To \row\_s()\text\len
        char = Asc(Mid(\row\_s()\text\string.s, i, 1))
        If _edit_sel_end_(char)
          Break
        EndIf
      Next 
      
      result = i - 1
    EndWith  
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.s _text_insert_make_(*this._struct_, Text.s)
    Protected String.s, i.i, Len.i
    
    With *this
      If \text\numeric And Text.s <> #LF$
        Static Dot, Minus
        Protected Chr.s, Input.i, left.s, count.i
        
        Len = Len(Text.s) 
        For i = 1 To Len 
          Chr = Mid(Text.s, i, 1)
          Input = Asc(Chr)
          
          Select Input
            Case '0' To '9', '.','-'
            Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Chr = Chr(Input)
            Default
              Input = 0
          EndSelect
          
          If Input
            If \type = #PB_GadgetType_IPAddress
              left.s = Left(\text\string, \text\caret\pos[1] )
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\text\string, \text\caret\pos[1] +1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
                ;               ElseIf Mid(\text\string, \text\caret\pos[1] + 1, 1) = "."
                ;                 \text\caret\pos[1] + 1 : \text\caret\pos[2]=\text\caret\pos[1] 
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\text\string, \text\caret\pos[1] + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\text\string, \text\caret\pos[1] + 1, 1) <> "-"
              Minus = 1
            ElseIf Input <> '-'
              Minus = 0
            Else
              Continue
            EndIf
            
            String.s + Chr
          EndIf
        Next
        
      ElseIf \text\pass
        Len = Len(Text.s) 
        For i = 1 To Len : String.s + "●" : Next
        
      Else
        Select #True
          Case \text\lower : String.s = LCase(Text.s)
          Case \text\upper : String.s = UCase(Text.s)
          Default
            String.s = Text.s
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.s text_wrap(Text.s, Width.i, Mode.i=-1, nl$=#LF$, DelimList$=" "+Chr(9))
    Protected.i CountString, i, start, ii, found, length
    Protected line$, ret$="", LineRet$=""
    
    ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CR$, #LF$)
    ;     Text.s + #LF$
    ;     
    CountString = CountString(Text.s, #LF$) ;+ 1
    
    For i = 1 To CountString
      line$ = StringField(Text.s, i, #LF$)
      start = Len(line$)
      length = start
      
      ; Get text len
      While length > 1
        If width > TextWidth(RTrim(Left(line$, length)))
          Break
        Else
          length - 1 
        EndIf
      Wend
      
      While start > length 
        If mode
          For ii = length To 0 Step - 1
            If mode = 2 And CountString(Left(line$,ii), " ") > 1     And width > 71 ; button
              found + FindString(delimList$, Mid(RTrim(line$),ii,1))
              If found <> 2
                Continue
              EndIf
            Else
              found = FindString(delimList$, Mid(line$,ii,1))
            EndIf
            
            If found
              start = ii
              Break
            EndIf
          Next
        EndIf
        
        If found
          found = 0
        Else
          start = length
        EndIf
        
        LineRet$ + Left(line$, start) + nl$
        line$ = LTrim(Mid(line$, start+1))
        start = Len(line$)
        length = start
        
        ; Get text len
        While length > 1
          If width > TextWidth(RTrim(Left(line$, length)))
            Break
          Else
            length - 1 
          EndIf
        Wend
      Wend
      
      ret$ + LineRet$ + line$ + nl$
      LineRet$=""
    Next
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  Procedure.b _text_paste_(*this._struct_, Chr.s, Count.l=0)
    Protected Repaint.b
    
    With *this
      If \index[1] <> \index[2] ; Это значить строки выделени
        If \index[2] > \index[1] : Swap \index[2], \index[1] : EndIf
        
        If Count
          \index[2] + Count
          \text\caret\pos[1] = Len(StringField(Chr.s, 1 + Count, #LF$))
        ElseIf Chr.s = #LF$ ; to return
          \index[2] + 1
          \text\caret\pos[1] = 0
        Else
          SelectElement(\row\_s(), \index[2])
          ;Debug " sss "+\index[2]+" "+\row\_s()\text\string
          \text\caret\pos[1] = \row\_s()\text\edit[1]\len + Len(Chr.s)
        EndIf
        
        ; reset items selection
        PushListPosition(*this\row\_s())
        ForEach *this\row\_s()
          If *this\row\_s()\text\edit[2]\width <> 0 
            _edit_sel_reset_(*this\row\_s())
          EndIf
        Next
        PopListPosition(*this\row\_s())
        
        \text\caret\pos[2] = \text\caret\pos[1] 
        \index[1] = \index[2]
        \text\change =- 1 ; - 1 post event change widget
        Repaint = #True
      EndIf
      
      \text\string.s = \text\edit[1]\string + Chr.s + \text\edit[3]\string
    EndWith
    
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.b _text_insert_(*this._struct_, Chr.s)
    Static Dot, Minus, Color.i
    Protected Repaint.b, Input, Input_2, String.s, Count.i
    
    With *this
      Chr.s = _text_insert_make_(*this, Chr.s)
      
      If Chr.s
        Count = CountString(Chr.s, #LF$)
        
        If Not _text_paste_(*this, Chr.s, Count)
          If \row\_s()\text\edit[2]\len 
            If \text\caret\pos[1] > \text\caret\pos[2] : \text\caret\pos[1] = \text\caret\pos[2] : EndIf
            \row\_s()\text\edit[2]\len = 0 : \row\_s()\text\edit[2]\string.s = "" : \row\_s()\text\edit[2]\change = 1
          EndIf
          
          \row\_s()\text\edit[1]\change = 1
          \row\_s()\text\edit[1]\string.s + Chr.s
          \row\_s()\text\edit[1]\len = Len(\row\_s()\text\edit[1]\string.s)
          
          \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
          \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
          
          If Count
            \index[2] + Count
            \index[1] = \index[2] 
            \text\caret\pos[1] = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \text\caret\pos[1] + Len(Chr.s) 
          EndIf
          
          \text\string.s = \text\edit[1]\string + Chr.s + \text\edit[3]\string
          \text\caret\pos[2] = \text\caret\pos[1] 
          ;; \count\items = CountString(\text\string.s, #LF$)
          \text\change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\row\_s(), \index[2]) 
        Repaint = 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  
  ;-
  ;- - DRAWINGs
  Procedure.s make_multiline(*this._struct_, String.s)
    Protected StringWidth
    Protected IT,Text_Y,Text_X,Width,Height
    
    With *This
      ; Make output text
      If \Vertical
        Width = \Height[#__c_2]
        Height = \Width[#__c_2]
      Else
        Width = \Width[#__c_2]
        Height = \Height[#__c_2]
      EndIf
      
      If \Text\multiline
        String = Text_wrap(String + #LF$, Width-\Text\padding*2, \Text\multiline)
        \count\items = CountString(String, #LF$)
      Else
        String + #LF$
        \count\items = 1
      EndIf
      
      If \count\items
        ClearList(\Items())
        
        If \Text\Align\Bottom
          Text_Y = (Height-(\Text\Height*\count\items)) - \Text\padding
        ElseIf \Text\Align\Vertical
          Text_Y = (Height-(\Text\Height*\count\items))/2
        Else
          Text_Y = \bs
        EndIf
        
        Protected time = ElapsedMilliseconds()
        
        
        Protected pos, *Sta.Character = @String, *End.Character = @String 
        While *End\c 
          If Text_Y+\Text\Height < \bs : Text_Y+\Text\Height : Continue : EndIf
          
          If *End\c = #LF And *Sta <> *End And AddElement(\items())
            \items() = AllocateStructure(structures::_s_items)
            
            \items()\text\pos = pos+ListSize(\items()) : pos + \items()\text\Len
            \items()\text\Len = (*End-*Sta)>>#PB_Compiler_Unicode
            \items()\text\string.s = PeekS (*Sta, \items()\text\Len)
            \items()\text\width = TextWidth(\items()\text\string.s)
            \Items()\Text\Height = \Text\Height
            
            ; Debug ""+\items()\text\pos +" "+ \items()\text\string.s
            ;                     
            ;\Items()\y = Text_Y 
            
            \items()\text\align = \text\align
            \items()\text\rotate = \text\rotate
            \items()\text\padding = \text\padding
            
            
            
             Protected _x_=*this\x, _y_=*this\y, _width_=*this\width, _height_=*this\height, _y2_=Text_Y
                          
                ;If _this_\text\vertical
                If \Items()\text\rotate = 90
;                   If _y2_ < 0
;                     \Items()\text\x = _x_ + (_width_-\Items()\text\height)/2
;                   Else
                     \Items()\text\x = _x_ + _y2_
;                   EndIf
                  
                  If \Items()\text\align\right
                    \Items()\text\y = _y_ + \Items()\text\align\height+\Items()\text\width + \Items()\text\padding
                  ElseIf \Items()\text\align\horizontal
                    \Items()\text\y = _y_ + (_height_+\Items()\text\align\height+\Items()\text\width)/2
                  Else
                    \Items()\text\y = _y_ + _height_-\Items()\text\padding
                  EndIf
                  
                ElseIf \Items()\text\rotate = 270
                  \Items()\text\x = _x_ + (_width_-_y2_)
                  
                  If \Items()\text\align\right
                    \Items()\text\y = _y_ + (_height_-\Items()\text\width-\Items()\text\padding) 
                  ElseIf \Items()\text\align\horizontal
                    \Items()\text\y = _y_ + (_height_-\Items()\text\width)/2 
                  Else
                    \Items()\text\y = _y_ + \Items()\text\padding 
                  EndIf
                  
                EndIf
                
                ;Else
                If \Items()\text\rotate = 0
;                   If _y2_
;                     \Items()\text\y = _y_ + (_height_-\Items()\text\height)/2
;                   Else
                     \Items()\text\y = _y_ + _y2_ ; - Bool(\Items()\text\align\bottom)*\Items()\text\padding
;                   EndIf
                  
                  If \Items()\text\align\right
                    \Items()\text\x = _x_ + (_width_-\Items()\text\align\width-\Items()\text\width - \Items()\text\padding) 
                  ElseIf \Items()\text\align\horizontal
                    \Items()\text\x = _x_ + (_width_-\Items()\text\align\width-\Items()\text\width)/2
                  Else
                    \Items()\text\x = _x_ + \Items()\text\padding
                  EndIf
                  
                ElseIf \Items()\text\rotate = 180
                  \Items()\text\y = _y_ + (_height_-_y2_); + Bool(\Items()\text\align\bottom)*\Items()\text\padding)
                  
                  If \Items()\text\align\right
                    \Items()\text\x = _x_ + \Items()\text\width + \Items()\text\padding 
                  ElseIf \Items()\text\align\horizontal
                    \Items()\text\x = _x_ + (_width_+\Items()\text\width)/2 
                  Else
                    \Items()\text\x = _x_ + _width_-\Items()\text\padding 
                  EndIf
                  
                EndIf
                ;EndIf
            ;;;_text_change_(\Items(), *this\x, *this\y, *this\width, *this\height);, Text_Y)
            : Text_Y + \Text\Height
                
            *Sta = *End + #__sOC 
          EndIf 
          
         If Text_Y > Height : Break : EndIf
           *End + #__sOC 
        Wend
        
        
; ;         ;             ; 239
; ;         If CreateRegularExpression(0, ~".*\n?")
; ;           If ExamineRegularExpression(0, string.s)
; ;             While NextRegularExpressionMatch(0) 
; ;               If Text_Y+\Text\Height < \bs : Text_Y+\Text\Height : Continue : EndIf
; ;               
; ;               If AddElement(\items())
; ;                 \items() = AllocateStructure(_s_items)
; ;                 \items()\text\pos = RegularExpressionMatchPosition(0)
; ;                 \items()\text\len = RegularExpressionMatchLength(0)
; ;                 \items()\text\string.s = RegularExpressionMatchString(0) ; Trim(RegularExpressionMatchString(0), #LF$)
; ;                 \items()\text\width = TextWidth(\items()\text\string.s) 
; ;                 \Items()\Text\Height = \Text\Height
; ;                 
; ;                 ;Debug ""+\items()\text\pos +" "+ \items()\text\string.s
; ;                 
; ;                 \Items()\y = Text_Y
; ;                 
; ;                 \items()\text\align = \text\align
; ;                 \items()\text\rotate = \text\rotate
; ;                 \items()\text\padding = \text\padding
; ;                 
; ;                 _text_change_(\Items(), *this\x, *this\y, *this\width, *this\height, Text_Y)
; ;                 Text_Y + \Text\Height
; ;               EndIf
; ;                 
; ;               If Text_Y > Height : Break : EndIf
; ;             Wend
; ;           EndIf
; ;           
; ;           FreeRegularExpression(0)
; ;         Else
; ;           Debug RegularExpressionError()
; ;         EndIf
; ;         
; ;         
; ;         
; ; ;         Protected pos, *Sta.Character = @String, *End.Character = @String 
; ; ;         While *End\c 
; ; ;           If *End\c = #LF And *Sta <> *End And AddElement(\items())
; ; ;             \items() = AllocateStructure(_s_items)
; ; ;             
; ; ;             \items()\text\pos = pos+ListSize(\items()) : pos + \items()\text\Len
; ; ;             \items()\text\Len = (*End-*Sta)>>#PB_compiler_unicode
; ; ;             \items()\text\string.s = PeekS (*Sta, \items()\text\Len)
; ; ;             \items()\text\width = TextWidth(\items()\text\string.s)
; ; ;             \Items()\Text\Height = \Text\Height
; ; ;             
; ; ;             ; Debug ""+\items()\text\pos +" "+ \items()\text\string.s
; ; ;             ;                     
; ; ;             \Items()\y = Text_Y 
; ; ;             
; ; ;             \items()\text\align = \text\align
; ; ;             \items()\text\rotate = \text\rotate
; ; ;             \items()\text\padding = \text\padding
; ; ;             
; ; ;             _text_change_(\Items(), *this\x, *this\y, *this\width, *this\height, Text_Y)
; ; ;             : Text_Y + \Text\Height
; ; ;           If Text_Y > Height : Break : EndIf
; ;                 
; ; ;             *Sta = *End + #__sOC 
; ; ;           EndIf 
; ; ;           
; ; ;           *End + #__sOC 
; ; ;         Wend
        
        ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
        Debug Str(ElapsedMilliseconds()-time) + " text parse time "
        
      EndIf
      ;             EndIf
      
    EndWith 
    
    ProcedureReturn String
  EndProcedure
  Procedure.i text_multiline_make(*this._struct_)
     ;*this\text\string.s = make_multiline(*this, *this\text\string.s+#LF$) : ProcedureReturn
     
    Static string_out.s
    Protected Repaint, String.s, text_width, len
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *this
      If \vertical
        Width = \height[2]
        Height = \width[2]
      Else
        width = \width[2]-\text\x  ; -\row\margin\width
        height = \height[2]
      EndIf
      
      If \text\multiline > 0
        String.s = text_wrap(\text\string.s+#LF$, Width, \text\multiline);Trim(text_wrap(\text\string.s+#LF$, Width, \text\multiline), #LF$)+#LF$
      Else
        String.s = \text\string.s+#LF$
      EndIf
      
      
      If string_out <> String.s+Str(*this)     ;And (Not \text\multiline And Not ListSize(\row\_s()))
        string_out = String.s+Str(*this) 
        
        \text\len = Len(\text\string.s)
        \count\items = CountString(String.s, #LF$)
        
        If Not \row\margin\hide
          \row\margin\width = TextWidth(Str(\count\items))+11
        EndIf
        
        ; reset 
        \text\pos = 0
        \scroll\width = 0
        _set_content_Y_(*this)
        
        Protected *str.Character = @string_out
        Protected *end.Character = @string_out 
        Protected time = ElapsedMilliseconds()
        
        If \text\count <> \count\items 
          ; Scroll hight reset 
          \scroll\height = 0
          ClearList(\row\_s())
          Debug  "---- ClearList ----"
          
          While *end\c : If *end\c = #LF : len = (*end-*str)/#__sOC : String = PeekS (*str, len)
              
              ; ;           If CreateRegularExpression(0, ~".*\n?") : If ExamineRegularExpression(0, string_out) : While NextRegularExpressionMatch(0) : String.s = Trim(RegularExpressionMatchString(0), #LF$) : len = Len(string.s)
              If AddElement(\row\_s())
                \row\_s()\draw = 1
                \row\_s()\text\string.s = String.s
                \row\_s()\index = ListIndex(\row\_s())
                \row\_s()\text\width = TextWidth(String.s)
                
                \row\_s()\color = _get_colors_()
                \row\_s()\color\fore[0] = 0
                \row\_s()\color\fore[1] = 0
                \row\_s()\color\fore[2] = 0
                \row\_s()\color\fore[3] = 0
                \row\_s()\color\back[0] = 0 ;\color\back[0]
                \row\_s()\color\frame[0] = 0 ;\row\_s()\color\frame[1]
                
                ; set entered color
                If *this\row\_s()\index = *this\index[1]
                  *this\row\_s()\color\state = 1
                EndIf
              
                ; Update line pos in the text
                _make_line_pos_(*this, len)
                
                ; Debug "f - "+String.s +" "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ \row\_s()\text\pos +" "+ \row\_s()\text\len
                
                
                _set_content_X_(*this)
                _line_resize_X_(*this)
                _line_resize_Y_(*this)
                
                ; Scroll hight length
                _make_scroll_height_(*this)
                
                ; Scroll width length
                _make_scroll_width_(*this)
                
                ; Margin 
                *this\row\_s()\margin\y = \row\_s()\text\y
                *this\row\_s()\margin\string = Str(\row\_s()\index)
                *this\row\_s()\margin\x = *this\x[2] + *this\row\margin\width - TextWidth(*this\row\_s()\margin\string) - 3
                
                ;
                _edit_sel_update_(*this)
                
              EndIf
              
              ; ;               Wend : EndIf : FreeRegularExpression(0) : Else : Debug RegularExpressionError() : EndIf
          *str = *end + #__sOC : EndIf : *end + #__sOC : Wend
          
          \text\count = \count\items
        Else
          While *end\c 
            If *end\c = #LF 
              len = (*end-*str)/#__sOC
              String = PeekS (*str, len)
              
              If SelectElement(\row\_s(), IT)
                If \row\_s()\text\string.s <> String.s Or \row\_s()\text\change
                  \row\_s()\text\string.s = String.s
                  \row\_s()\text\width = TextWidth(String.s)
                EndIf
                
                ; Update line pos in the text
                _make_line_pos_(*this, len)
                
                ; Resize item
                _set_content_X_(*this)
                
                _line_resize_X_(*this)
                
                ; Set scroll width length
                _make_scroll_width_(*this)
                
                ;
                _edit_sel_update_(*this)
              EndIf
              
              IT+1
              *str = *end + #__sOC 
            EndIf 
            *end + #__sOC 
          Wend
        EndIf
        
        ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
        If ElapsedMilliseconds()-time > 0
          Debug Str(ElapsedMilliseconds()-time) + " text parse time " + Str(Bool(\text\count = \count\items))
        EndIf
        
      Else
        ; Scroll hight reset 
        If \countitems = 0
          \scroll\width = 0
        Else
          \scroll\height = 0
          _set_content_Y_(*this)
        EndIf
        Debug  "---- updatelist ----"
        
        ForEach \row\_s()
          If Not \row\_s()\hide
            
            If \countitems = 0
              \row\_s()\text\width = TextWidth(\row\_s()\text\string)
              
              ; Scroll width length
              _make_scroll_width_(*this)
              _edit_sel_update_(*this)
            Else
              _set_content_X_(*this)
              _line_resize_X_(*this)
              _line_resize_Y_(*this)
              
              ; Scroll hight length
              _make_scroll_height_(*this)
              
            EndIf
          
                ; ;             ; key - (return & backspace)
            ;             If \text\caret\x+4 > (\width[2]+\row\margin\width) And \index[2]+1 = \row\_s()\index 
            ;               Debug  ""+Str(\text\caret\x+\text\x+\flag\fullselection) +" "+ *this\scroll\h\width
            ;               Debug  \row\_s()\text\string
            ;               ; \row\selected = \row\_s()
            ;                 _edit_sel_(*this, \text\caret\pos[1]-\row\selected\text\len , 0)
            ;               _text_scroll_x_(*this)
            ;             
            ;             EndIf
            
            
          EndIf
        Next
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure Draw(*this._struct_)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width, Drawing
    
    If Not *this\hide
      
      With *this
        ; Draw back color
        If \color\fore[\color\state]
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\Vertical,\x[1],\y[1],\width[1],\height[1],\color\fore[\color\state],\color\back[\color\state],\round)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\back[\color\state])
        EndIf
        
        ;
        If \text\fontID 
          DrawingFont(\text\fontID) 
        EndIf
        
        ; Then changed text
        If \text\change
          \text\height = TextHeight("A")
          \text\width = TextWidth(\text\string.s)
        EndIf
        
        ; Make output multi line text
        If (\text\change); And \text\multiline); Or (\resize And \text\multiline))
          text_multiline_make(*this)
        EndIf
        
        If \scroll And \text\change
          If \scroll\v And \scroll\v\bar\max <> (\scroll\height - \flag\gridlines) 
            
            ; Bar::SetAttribute(\scroll\v, #__bar_minimum, -\scroll\y) 
            Bar::SetAttribute(\scroll\v, #__bar_Maximum, (\scroll\height - \flag\gridlines)) 
            Bar::Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            
            \width[2] = \scroll\h\bar\page\len - \row\margin\width 
          EndIf
          
          If \scroll\h And \scroll\h\bar\max <> \scroll\width  
            
            Bar::SetAttribute(\scroll\h, #__bar_Minimum, -\scroll\x)
            Bar::SetAttribute(\scroll\h, #__bar_Maximum, \scroll\width)
            Bar::Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            
            \height[2] = \scroll\v\bar\page\len
          EndIf
          
          ; This is for the caret and scroll when entering the key - (enter & backspace) ;
          ; При вводе enter выделенную строку перемещаем в конец страницы и прокручиваем ползунок
          If \scroll\v
            _text_scroll_y_(*this)
          EndIf 
          If \scroll\h
            _text_scroll_x_(*this)
          EndIf 
        EndIf 
        
        
        ; then change bar position
;         If \scroll\v\bar\change
;           \scroll\v\repaint = 1
;           Debug  " v\bar\change " +*this\scroll\v\bar\page\pos
;           ;\scroll\h\bar\change = 0
;           \scroll\y =- (*this\scroll\v\bar\page\pos-*this\scroll\v\bar\min)
;         EndIf
        
        If \scroll\h\bar\change
          \scroll\h\repaint = 1
          Debug  " h\bar\change " +*this\scroll\h\bar\page\pos
          ;\scroll\h\bar\change = 0
          \scroll\x =- (*this\scroll\h\bar\page\pos-*this\scroll\h\bar\min)
        EndIf
        
        ; Draw margin back color
        If \row\margin\width > 0
          If (\text\change Or \resize)
            \row\margin\x = \x[2]
            \row\margin\y = \y[2]
            \row\margin\height = \height[2]
          EndIf
          
          ; Draw margin
          DrawingMode(#PB_2DDrawing_Default);|#PB_2DDrawing_AlphaBlend)
          Box(\row\margin\x, \row\margin\y, \row\margin\width, \row\margin\height, \row\margin\color\back)
        EndIf
        
        ; Widget inner coordinate
        iX=\x[2] + \row\margin\width 
        iY=\y[2]
        iwidth = \width[2]
        iheight = \height[2]
        
        ; Draw Lines text
        If \count\items And \scroll\v And \scroll\h
          PushListPosition(\row\_s())
          ForEach \row\_s()
            ; Is visible lines ---
            \row\_s()\draw = Bool(Not \row\_s()\hide And 
                                  \row\_s()\y+\row\_s()\height-*this\scroll\v\bar\page\pos>*this\y[2] And 
                                  (\row\_s()\y-*this\y[2])-*this\scroll\v\bar\page\pos<*this\height[2])
            
            ; Draw selections
            If \row\_s()\draw 
              Y = \row\_s()\y-*this\scroll\v\bar\page\pos
              Text_X = \row\_s()\text\x+*this\scroll\x
              Text_Y = \row\_s()\text\y-*this\scroll\v\bar\page\pos
              
              Protected text_x_sel = \row\_s()\text\edit[2]\x+*this\scroll\x
              Protected sel_x = \x[2]
              
              
              ; Draw lines
              ; Если для итема установили задный фон отличный от заднего фона едитора
              If *this\row\_s()\color\Back  
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                RoundBox(sel_x,Y,iwidth+ \row\margin\width ,\row\_s()\height, \row\_s()\round,\row\_s()\round, *this\row\_s()\color\back[0] )
                
                If *this\color\Back And 
                   *this\color\Back <> *this\row\_s()\color\Back
                  ; Draw margin back color
                  If *this\row\margin\width > 0
                    ; то рисуем вертикальную линию на границе поля нумерации и начало итема
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\row\margin\x, \row\_s()\y, \row\margin\width, \row\_s()\height, \row\margin\color\back)
                    Line(*this\x[2]+*this\row\margin\width, \row\_s()\y, 1, \row\_s()\height, *this\color\Back) ; $FF000000);
                  EndIf
                EndIf
              EndIf
              
              ; Draw entered selection
              If \row\_s()\index = *this\index[1] ; \color\state;
                If *this\row\_s()\color\back[\row\_s()\color\state]<>-1              ; no draw transparent
                  If *this\row\_s()\color\fore[\row\_s()\color\state]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    _box_gradient_(*this\vertical,sel_x,Y,iwidth+ \row\margin\width, \row\_s()\height, *this\row\_s()\color\fore[*this\row\_s()\color\state], *this\row\_s()\color\back[*this\row\_s()\color\state], \row\_s()\round)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    RoundBox(sel_x,Y,iwidth+ \row\margin\width ,\row\_s()\height, \row\_s()\round,\row\_s()\round, *this\row\_s()\color\back[*this\row\_s()\color\state] )
                  EndIf
                EndIf
                
                If *this\row\_s()\color\frame[\row\_s()\color\state]<>-1 ; no draw transparent
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(sel_x,Y,iwidth+ \row\margin\width ,\row\_s()\height, \row\_s()\round,\row\_s()\round, *this\row\_s()\color\frame[*this\row\_s()\color\state] )
                EndIf
              EndIf
              
              ; Draw text
              ; Draw string
              If *this\text\editable And \row\_s()\text\edit[2]\width And *this\color\front <> *this\row\_s()\color\front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  ; to right
                  If (*this\index[1] > *this\index[2] Or 
                      (*this\index[1] = *this\index[2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]))
                    
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawRotatedText(Text_X, Text_Y, \row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    
                    If *this\row\_s()\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      _box_gradient_(*this\vertical,text_x_sel, Y, \row\_s()\text\edit[2]\width, \row\_s()\height, *this\row\_s()\color\fore[2], *this\row\_s()\color\back[2], \row\_s()\round)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(text_x_sel, Y, \row\_s()\text\edit[2]\width, \row\_s()\height, *this\row\_s()\color\back[2])
                    EndIf
                    
                    If \row\_s()\text\edit[2]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(text_x_sel, Text_Y, \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[2])
                    EndIf
                    
                  Else
                    If *this\row\_s()\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      _box_gradient_(*this\vertical,text_x_sel, Y, \row\_s()\text\edit[2]\width, \row\_s()\height,*this\row\_s()\color\fore[2], *this\row\_s()\color\back[2], \row\_s()\round)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(text_x_sel, Y, \row\_s()\text\edit[2]\width, \row\_s()\height, *this\row\_s()\color\back[2] )
                    EndIf
                    
                    If \row\_s()\text\edit[3]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\row\_s()\text\edit[3]\x+*this\scroll\x, Text_Y, \row\_s()\text\edit[3]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    EndIf
                    
                    If \row\_s()\text\edit[2]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \row\_s()\text\edit[1]\string.s+\row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[2])
                    EndIf
                    
                    If \row\_s()\text\edit[1]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \row\_s()\text\edit[1]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    EndIf
                  EndIf
                  
                CompilerElse
                  If *this\row\_s()\color\fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    _box_gradient_(*this\vertical,text_x_sel, Y, \row\_s()\text\edit[2]\width, \row\_s()\height, *this\row\_s()\color\fore[2], *this\row\_s()\color\back[2], \row\_s()\round)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(text_x_sel, Y, \row\_s()\text\edit[2]\width, \row\_s()\height, *this\row\_s()\color\back[2])
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Transparent)
                  
                  If \row\_s()\text\edit[1]\string.s
                    DrawRotatedText(\row\_s()\text\edit[1]\x+*this\scroll\x, Text_Y, \row\_s()\text\edit[1]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                  EndIf
                  If \row\_s()\text\edit[2]\string.s
                    DrawRotatedText(text_x_sel, Text_Y, \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[2])
                  EndIf
                  If \row\_s()\text\edit[3]\string.s
                    DrawRotatedText(\row\_s()\text\edit[3]\x+*this\scroll\x, Text_Y, \row\_s()\text\edit[3]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                  EndIf
                CompilerEndIf
                
              Else
                If \row\_s()\text\edit[2]\width
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(text_x_sel, Y, \row\_s()\text\edit[2]\width, \row\_s()\height, $FFFBD9B7);*this\row\_s()\color\back[2])
                EndIf
                
                If \color\state = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[2])
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                EndIf
              EndIf
              
              ; Draw margin text
              If *this\row\margin\width > 0
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(*this\row\_s()\margin\x, *this\row\_s()\margin\y-*this\scroll\v\bar\page\pos, *this\row\_s()\margin\string, *this\row\margin\color\front)
              EndIf
              
              ; Horizontal line
              If *this\flag\GridLines And *this\row\_s()\color\line And *this\row\_s()\color\line <> *this\row\_s()\color\back : DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(*this\row\_s()\x, (*this\row\_s()\y+*this\row\_s()\height+Bool(*this\flag\gridlines>1))-*this\scroll\v\bar\page\pos, *this\row\_s()\width, 1, *this\color\line)
              EndIf
            EndIf
          Next
          PopListPosition(*this\row\_s()) ; 
        EndIf
        
        ; Draw caret
        If *this\text\editable And GetActive() = *this ; *this\color\state
          DrawingMode(#PB_2DDrawing_XOr)             
          Box(*this\text\caret\x+*this\scroll\x, *this\text\caret\y-*this\scroll\v\bar\page\pos, *this\text\caret\width, *this\text\caret\height, $FFFFFFFF)
        EndIf
        
        ; Draw scroll bars
        If \scroll
          ;If *this\scroll\v\bar\change Or *this\repaint
            bar::draw(\scroll\v)
          ;EndIf
          ;If *this\scroll\v\bar\change Or *this\repaint
            bar::draw(\scroll\h)
          ;EndIf
        EndIf
      
        ; Draw frames
        If \errors
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round, $FF0000FF)
          If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round, $FF0000FF) : EndIf  ; Сглаживание краев )))
        Else
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\frame[\color\state])
          If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round,\color\front[\color\state]) : EndIf  ; Сглаживание краев )))
        EndIf
        
        If \scroll And \scroll\v And \scroll\h
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          ; Scroll area coordinate
          ;Box(-\scroll\h\bar\page\pos, -\scroll\v\bar\page\pos, \scroll\width, \scroll\height, $FFFF0000)
          ; Debug ""+\scroll\x +" "+ \scroll\y +" "+ \scroll\width +" "+ \scroll\height
          Box(\scroll\h\x-\scroll\h\bar\page\pos, \scroll\v\y-\scroll\v\bar\page\pos, \scroll\h\bar\max, \scroll\v\bar\max, $FFFF0000)
          
          ; page coordinate
          Box(\scroll\h\x, \scroll\v\y, \scroll\h\bar\page\len, \scroll\v\bar\page\len, $FF00FF00)
        EndIf
        
        
        
        If \text\change : \text\change = 0 : EndIf
        If \resize : \resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure ReDraw(*this._struct_)
    If *this And StartDrawing(CanvasOutput(*this\root\canvas))
      ; If *this\root\fontID : DrawingFont(*this\root\fontID) : EndIf
        FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FFf0f0f0)
      
      Draw(*this) 
      StopDrawing()
    EndIf
  EndProcedure
  
  ;-
  ;- - (SET&GET)s
  Procedure.i AddItem(*this._struct_, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static len.l
    Protected l.l, i.l
    
    If *this
      With *this  
        Protected string.s = \text\string + #LF$
        
        If Item > \count\items - 1
          Item = \count\items - 1
        EndIf
        
        If (Item > 0 And Item < \count\items - 1)
          Define *str.Character = @string 
          Define *end.Character = @string 
          len = 0
          
          While *end\c 
            If *end\c = #LF 
              
              If item = i 
                len + Item
                Break 
              Else
                ;Debug ""+ PeekS (*str, (*end-*str)/#__sOC) +" "+ Str((*end-*str)/#__sOC)
                len + (*end-*str)/#__sOC
              EndIf
              
              i+1
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
        EndIf
        
        \text\string = Trim(InsertString(string, Text.s+#LF$, len+1), #LF$)
        
        l = Len(Text.s) + 1
        \text\change = 1
        \text\len + l 
        Len + l
        
        ;_repaint_items_(*this)
        \count\items + 1
        
      EndWith
    EndIf
    
    ProcedureReturn *this\count\items
  EndProcedure
  
  Procedure   SetAttribute(*this._struct_, Attribute.i, Value.i)
    With *this
      
    EndWith
  EndProcedure
  
  Procedure   GetAttribute(*this._struct_, Attribute.i)
    Protected Result
    
    With *this
      ;       Select Attribute
      ;         Case #__bar_Minimum    : Result = \scroll\bar\min
      ;         Case #__bar_Maximum    : Result = \scroll\bar\max
      ;         Case #__bar_PageLength : Result = \scroll\bar\pageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure   SetItemState(*this._struct_, Item.i, State.i)
    Protected Result
    Protected i.l, len.l
    
    With *this
      If state < 0 Or 
         state > *this\text\len
        state = *this\text\len
      EndIf
      
      If *this\text\caret\pos <> State
        *this\text\caret\pos = State
        
        Protected *str.Character = @\text\string 
        Protected *end.Character = @\text\string 
        
        While *end\c 
          If *end\c = #LF 
            len + (*end-*str)/#__sOC
            ; Debug ""+Item+" "+Str(len + Item) +" "+ state
            
            If len + Item >= state
              *this\index[1] = Item
              *this\index[2] = Item
              
              *this\text\caret\pos[1] = state - (len-(*end-*str)/#__sOC) - Item
              *this\text\caret\pos[2] = *this\text\caret\pos[1]
              
              Break
            EndIf
            ; Item + 1
            
            *str = *end + #__sOC 
          EndIf 
          
          *end + #__sOC 
        Wend
        
        ; last line
        If *this\index[1] <> Item 
          *this\index[1] = Item
          *this\index[2] = Item
          
          *this\text\caret\pos[1] = (state - len - Item) 
          *this\text\caret\pos[2] = *this\text\caret\pos[1]
        EndIf
        
      EndIf
      
      ; ;       PushListPosition(\row\_s())
      ; ;       Result = SelectElement(\row\_s(), Item) 
      ; ;       
      ; ;       If Result 
      ; ;         \index[1] = \row\_s()\index
      ; ;         \index[2] = \row\_s()\index
      ; ;         \row\index = \row\_s()\index
      ; ;        ; \text\caret\pos[1] = State
      ; ;        ; \text\caret\pos[2] = \text\caret\pos[1] 
      ; ;       EndIf
      ; ;       PopListPosition(\row\_s())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure   SetState(*this._struct_, State.l) ; Ok
    Protected i.l, len.l
    
    With *this
      If state < 0 Or 
         state > *this\text\len
        state = *this\text\len
      EndIf
      
      If *this\text\caret\pos <> State
        *this\text\caret\pos = State
        
        Protected *str.Character = @\text\string 
        Protected *end.Character = @\text\string 
        
        While *end\c 
          If *end\c = #LF 
            len + (*end-*str)/#__sOC
            ; Debug ""+i+" "+Str(len + i) +" "+ state
            
            If len + i >= state
              *this\index[1] = i
              *this\index[2] = i
              
              *this\text\caret\pos[1] = state - (len-(*end-*str)/#__sOC) - i
              *this\text\caret\pos[2] = *this\text\caret\pos[1]
              
              Break
            EndIf
            i + 1
            
            *str = *end + #__sOC 
          EndIf 
          
          *end + #__sOC 
        Wend
        
        ; last line
        If *this\index[1] <> i 
          *this\index[1] = i
          *this\index[2] = i
          
          *this\text\caret\pos[1] = (state - len - i) 
          *this\text\caret\pos[2] = *this\text\caret\pos[1]
        EndIf
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure   GetState(*this._struct_)
    ProcedureReturn *this\text\caret\pos
  EndProcedure
  
  Procedure   ClearItems(*this._struct_)
    *this\count\items = 0
    *this\text\change = 1 
    
    If *this\text\editable
      *this\text\string = #LF$
    EndIf
    
    _repaint_(*this)
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*this._struct_)
    ProcedureReturn *this\count\items
  EndProcedure
  
  Procedure.i RemoveItem(*this._struct_, Item.i)
    *this\count\items - 1
    *this\text\change = 1
    
    If *this\count\items =- 1 
      *this\count\items = 0 
      *this\text\string = #LF$
      
      _repaint_(*this)
      
    Else
      *this\text\string = RemoveString(*this\text\string, StringField(*this\text\string, item+1, #LF$) + #LF$)
    EndIf
  EndProcedure
  
  Procedure.s GetText(*this._struct_)
    With *this
      If \text\pass
        ProcedureReturn \text\edit\string
      Else
        ProcedureReturn \text\string
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetText(*this._struct_, Text.s, Item.i=0)
    Protected Result.i, Len.i, String.s, i.i
    ; If Text.s="" : Text.s=#LF$ : EndIf
    Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    Text.s = ReplaceString(Text.s, #CR$, #LF$)
    
    With *this
      If ListSize(*this\row\_s())
        ClearItems(*this)
      EndIf
      
      If \text\edit\string.s <> Text.s
        \text\edit\string = Text.s
        
        \text\string.s = _text_insert_make_(*this, Text.s)
        
        If \text\string.s
          If \text\multiline
            \count\items = CountString(\text\string.s, #LF$)
          Else
;             If Not \count\items
              \count\items = 1
              \text\string.s = RemoveString(\text\string.s, #LF$) 
;               AddElement(\row\_s())
;               \row\_s()\text\string = \text\string.s
;             EndIf
          EndIf
          
          ;           If *this And StartDrawing(CanvasOutput(*this\root\canvas))
          ;             If \text\fontID 
          ;               DrawingFont(\text\fontID) 
          ;             EndIf
          ;             
          ;             text_multiline_make(*this)
          ;             StopDrawing()
          ;           EndIf
          
          
          \text\len = Len(\text\string.s)
          \text\change = #True
          
          _repaint_(*this)
          
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*this._struct_, FontID.i)
    
    With *this
      If \text\fontID <> FontID 
        \text\fontID = FontID
        \text\change = 1
        
        If Not Bool(\text\count And \text\count <> \count\items)
          Redraw(*this)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.l SetItemColor(*this._struct_, Item.l, ColorType.l, Color.l, Column.l=0)
    Protected Result
    
    With *this
      If Item =- 1
        PushListPosition(\row\_s()) 
        ForEach \row\_s()
          Select ColorType
            Case #__color_Back
              \row\_s()\color\back[Column] = Color
              
            Case #__color_Front
              \row\_s()\color\front[Column] = Color
              
            Case #__color_Frame
              \row\_s()\color\frame[Column] = Color
              
            Case #__color_Line
              \row\_s()\color\line[Column] = Color
              
          EndSelect
        Next
        PopListPosition(\row\_s()) 
        
      Else
        If Item >= 0 And Item < *this\count\items And SelectElement(*this\row\_s(), Item)
          Select ColorType
            Case #__color_back
              \row\_s()\color\back[Column] = Color
              
            Case #__color_front
              \row\_s()\color\front[Column] = Color
              
            Case #__color_frame
              \row\_s()\color\frame[Column] = Color
              
            Case #__color_line
              \row\_s()\color\line[Column] = Color
              
          EndSelect
        EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.l GetItemColor(*this._struct_, Item.l, ColorType.l, Column.l=0)
    Protected Result
    
    With *this
      If Item >= 0 And Item < *this\count\items And SelectElement(*this\row\_s(), Item)
        Select ColorType
          Case #__color_back
            Result = \row\_s()\color\back[Column]
            
          Case #__color_front
            Result = \row\_s()\color\front[Column]
            
          Case #__color_frame
            Result = \row\_s()\color\frame[Column]
            
          Case #__color_line
            Result = \row\_s()\color\line[Column]
            
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  Procedure.i Resize(*this._struct_, X.i,Y.i,Width.i,Height.i)
    With *this
      If x>=0 And X<>#PB_Ignore And 
         \x[0] <> X
        \x[0] = X 
        \x[2]=\x[0]+\bs
        \x[1]=\x[2]-\fs
        \resize = 1<<1
      EndIf
      If y>=0 And Y<>#PB_Ignore And 
         \y[0] <> Y
        \y[0] = Y
        \y[2]=\y[0]+\bs
        \y[1]=\y[2]-\fs
        \resize = 1<<2
      EndIf
      If Width>=0 And Width<>#PB_Ignore And
         \width[0] <> Width 
        \width[0] = Width 
        \width[2] = \width[0]-\bs*2
        \width[1] = \width[2]+\fs*2
        \resize = 1<<3
      EndIf
      If Height>=0 And Height<>#PB_Ignore And 
         \height[0] <> Height
        \height[0] = Height 
        \height[2] = \height[0]-\bs*2
        \height[1] = \height[2]+\fs*2
        \resize = 1<<4
      EndIf
      
      ; Then resized widget
      If \resize
        ; Посылаем сообщение об изменении размера 
        ; PostEvent(#PB_Event_Widget, \root\window, *this, #PB_EventType_Resize, \resize)
        
        ;  Bar::Resizes(\scroll, \x[2]+\row\margin\width,\y[2],\width[2]-\row\margin\width,\height[2])
        Bar::Resizes(\scroll, \x[0]+\bs,\y[0]+\bs, \width[0]-\bs*2, \height[0]-\bs*2)
        
        \width[2] = \scroll\h\bar\page\len - \row\margin\width 
        \height[2] = \scroll\v\bar\page\len
        
      EndIf
      
      
      ProcedureReturn \resize
    EndWith
  EndProcedure
  
  ;-
  ;- - KEYBOARDs
  Procedure.i events_key_editor(*this._struct_, eventtype.l, mouse_x.l, mouse_y.l)
    Static _caret_last_pos_, DoubleClick.i
    Protected Repaint.i, _key_control_.i, _key_shift_.i, Caret.i, Item.i, String.s
    Protected _line_, _step_ = 1, _caret_min_ = 0, _caret_max_ = *this\row\_s()\text\len, _line_first_ = 0, _line_last_ = *this\count\items - 1
    
    With *this
      _key_shift_ = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Shift)
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
        _key_control_ = Bool((\root\keyboard\key[1] & #PB_Canvas_Control) Or (\root\keyboard\key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
      CompilerElse
        _key_control_ = Bool(*this\root\keyboard\key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
      CompilerEndIf
      
      Select EventType
        Case #PB_EventType_Input ; - Input (key)
          If Not _key_control_   ; And Not _key_shift_
            If *this\root\keyboard\input
              
              If Not \errors
                If _text_insert_(*this, Chr(*this\root\keyboard\input))
                  Repaint = #True
                Else
                  *this\errors = 1
                  ProcedureReturn - 1
                EndIf
              EndIf
              
            EndIf
          EndIf
          
        Case #PB_EventType_KeyUp
          ; Чтобы перерисовать 
          ; рамку вокруг едитора 
          If \errors
            \errors = 0
            ProcedureReturn - 1
          EndIf
          
        Case #PB_EventType_KeyDown
          Select *this\root\keyboard\key
            Case #PB_Shortcut_Home : *this\text\caret\pos[2] = 0
              If _key_control_ : *this\index[2] = 0 : EndIf
              Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])
              
            Case #PB_Shortcut_End : *this\text\caret\pos[2] = *this\text\len
              If _key_control_ : *this\index[2] = *this\count\items - 1 : EndIf
              Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])
              
            Case #PB_Shortcut_PageUp   ;: Repaint = ToPos(*this, 1, 1)
              
            Case #PB_Shortcut_PageDown ;: Repaint = ToPos(*this, - 1, 1)
              
            Case #PB_Shortcut_A        ; Ok
              If _key_control_ And
                 \text\edit[2]\len <> \text\len
                
                ; set caret to begin
                \text\caret\pos[2] = 0 
                \text\caret\pos[1] = \text\len ; если поставить ноль то и прокручиваеть в конец строки
                
                ; select first item
                \index[2] = 0 
                \index[1] = \count\items - 1 ; если поставить ноль то и прокручиваеть в конец линии
                
                Repaint = _edit_sel_draw_(*this, \count\items - 1, \text\len)
              EndIf
              
            Case #PB_Shortcut_Up       ; Ok
              If *this\index[1] > _line_first_
                If _caret_last_pos_
                  If Not *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                    *this\text\caret\pos[1] = _caret_last_pos_
                    *this\text\caret\pos[2] = _caret_last_pos_
                  EndIf
                  _caret_last_pos_ = 0
                EndIf
                
                If _key_shift_
                  If _key_control_
                    Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                    Repaint = _edit_sel_draw_(*this, 0, 0)  
                  Else
                    Repaint = _edit_sel_draw_(*this, *this\index[1] - _step_, *this\text\caret\pos[1])  
                  EndIf
                ElseIf *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                  If *this\text\caret\pos[1] <> _caret_min_ 
                    *this\text\caret\pos[2] = _caret_min_
                  Else
                    *this\index[2] - _step_ 
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                  
                Else
                  If _key_control_
                    *this\index[2] = 0
                    *this\text\caret\pos[2] = 0
                  Else
                    *this\index[2] - _step_
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])
                EndIf
              ElseIf *this\index[1] = _line_first_
                
                If *this\text\caret\pos[1] <> _caret_min_ : *this\text\caret\pos[2] = _caret_min_ : _caret_last_pos_ = *this\text\caret\pos[1]
                  Repaint = _edit_sel_draw_(*this, _line_first_, *this\text\caret\pos[2])  
                EndIf
                
              EndIf
              
            Case #PB_Shortcut_Down     ; Ok
              If *this\index[1] < _line_last_
                If _caret_last_pos_
                  If Not *this\root\keyboard\key[1] & #PB_Canvas_Alt And Not _key_control_
                    *this\text\caret\pos[1] = _caret_last_pos_
                    *this\text\caret\pos[2] = _caret_last_pos_
                  EndIf
                  _caret_last_pos_ = 0
                EndIf
                
                If _key_shift_
                  If _key_control_
                    Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                    Repaint = _edit_sel_draw_(*this, \count\items - 1, *this\text\len)  
                  Else
                    Repaint = _edit_sel_draw_(*this, *this\index[1] + _step_, *this\text\caret\pos[1])  
                  EndIf
                ElseIf *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                  If *this\text\caret\pos[1] <> _caret_max_ 
                    *this\text\caret\pos[2] = _caret_max_
                  Else
                    *this\index[2] + _step_ 
                    
                    If SelectElement(*this\row\_s(), *this\index[2]) 
                      _caret_max_ = *this\row\_s()\text\len
                      
                      If *this\text\caret\pos[1] <> _caret_max_
                        *this\text\caret\pos[2] = _caret_max_
                        
                        Debug ""+#PB_Compiler_Procedure + "*this\text\caret\pos[1] <> _caret_max_"
                      EndIf
                    EndIf
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                  
                Else
                  If _key_control_
                    *this\index[2] = \count\items - 1
                    *this\text\caret\pos[2] = *this\text\len
                  Else
                    *this\index[2] + _step_
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                EndIf
              ElseIf *this\index[1] = _line_last_
                
                If *this\row\_s()\index <> _line_last_ And
                   SelectElement(*this\row\_s(), _line_last_) 
                  _caret_max_ = *this\row\_s()\text\len
                  Debug ""+#PB_Compiler_Procedure + "*this\row\_s()\index <> _line_last_"
                EndIf
                
                If *this\text\caret\pos[1] <> _caret_max_ : *this\text\caret\pos[2] = _caret_max_ : _caret_last_pos_ = *this\text\caret\pos[1]
                  Repaint = _edit_sel_draw_(*this, _line_last_, *this\text\caret\pos[2])  
                EndIf
                
              EndIf
              
            Case #PB_Shortcut_Left     ; Ok
              If _key_shift_        
                If _key_control_
                  Repaint = _edit_sel_draw_(*this, *this\index[2], 0)  
                Else
                  _line_ = *this\index[1] - Bool(*this\index[1] > _line_first_ And *this\text\caret\pos[1] = _caret_min_) * _step_
                  
                  ; коректируем позицию коректора
                  If *this\row\_s()\index <> _line_ And
                     SelectElement(*this\row\_s(), _line_) 
                  EndIf
                  If *this\text\caret\pos[1] > *this\row\_s()\text\len
                    *this\text\caret\pos[1] = *this\row\_s()\text\len
                  EndIf
                  
                  If *this\index[1] <> _line_
                    Repaint = _edit_sel_draw_(*this, _line_, *this\row\_s()\text\len)  
                  ElseIf *this\text\caret\pos[1] > _caret_min_
                    Repaint = _edit_sel_draw_(*this, _line_, *this\text\caret\pos[1] - _step_)  
                  EndIf
                EndIf
                
              ElseIf *this\index[1] > _line_first_
                If *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                  *this\text\caret\pos[2] = _edit_sel_start_(*this)
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                Else
                  If _key_control_
                    *this\text\caret\pos[2] = 0
                  Else
                    If *this\text\caret\pos[2] = *this\text\caret\pos[1]
                      *this\text\caret\pos[2] - _step_
                    Else
                      *this\text\caret\pos[2] = *this\text\caret\pos[1] - _step_ 
                    EndIf
                    
                    If *this\text\caret\pos[1] = _caret_min_
                      *this\index[2] - _step_
                      
                      If SelectElement(*this\row\_s(), *this\index[2]) 
                        *this\text\caret\pos[1] = *this\row\_s()\text\len
                        *this\text\caret\pos[2] = *this\row\_s()\text\len
                      EndIf
                    EndIf
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                EndIf
                
              ElseIf *this\index[1] = _line_first_
                
                If *this\text\caret\pos[1] > _caret_min_ 
                  *this\text\caret\pos[2] - _step_
                  Repaint = _edit_sel_draw_(*this, _line_first_, *this\text\caret\pos[2])  
                EndIf
                
              EndIf
              
            Case #PB_Shortcut_Right    ; Ok
              If _key_shift_       
                If _key_control_
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\len)  
                Else
                  If *this\row\_s()\index <> *this\index[1] And
                     SelectElement(*this\row\_s(), *this\index[1]) 
                    _caret_max_ = *this\row\_s()\text\len
                  EndIf
                  
                  If *this\text\caret\pos[1] > _caret_max_
                    *this\text\caret\pos[1] = _caret_max_
                  EndIf
                  
                  _line_ = *this\index[1] + Bool(*this\index[1] < _line_last_ And *this\text\caret\pos[1] = _caret_max_) * _step_
                  
                  ; если дошли в конец строки,
                  ; то переходим в начало
                  If *this\index[1] <> _line_ 
                    Repaint = _edit_sel_draw_(*this, _line_, 0)  
                  ElseIf *this\text\caret\pos[1] < _caret_max_
                    Repaint = _edit_sel_draw_(*this, _line_, *this\text\caret\pos[1] + _step_)  
                  EndIf
                EndIf
                
              ElseIf *this\index[1] < _line_last_
                If *this\root\keyboard\key[1] & #PB_Canvas_Alt 
                  *this\text\caret\pos[2] = _edit_sel_stop_(*this)
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                Else
                  If _key_control_
                    *this\text\caret\pos[2] = *this\text\len
                  Else
                    If *this\text\caret\pos[2] = *this\text\caret\pos[1]
                      *this\text\caret\pos[2] + _step_
                    Else
                      *this\text\caret\pos[2] = *this\text\caret\pos[1] + _step_ 
                    EndIf
                    
                    If *this\text\caret\pos[1] = _caret_max_
                      *this\index[2] + _step_
                      
                      If SelectElement(*this\row\_s(), *this\index[2]) 
                        *this\text\caret\pos[1] = 0
                        *this\text\caret\pos[2] = 0
                      EndIf
                    EndIf
                  EndIf
                  
                  Repaint = _edit_sel_draw_(*this, *this\index[2], *this\text\caret\pos[2])  
                EndIf
                
              ElseIf *this\index[1] = _line_last_
                
                If *this\text\caret\pos[1] < _caret_max_ 
                  *this\text\caret\pos[2] + _step_
                  
                  
                  Repaint = _edit_sel_draw_(*this, _line_last_, *this\text\caret\pos[2])  
                EndIf
                
              EndIf
              
              ;- backup  
            Case #PB_Shortcut_Back   
              ;               ; Сбросить Dot&Minus
              ;               If *this\root\keyboard\input
              ;                 *this\root\keyboard\input = 0
              ;                 
              ;                 If Not \errors
              ;                   If _text_insert_(*this, Chr(\root\keyboard\input))
              ;                     ProcedureReturn #True
              ;                   Else
              ;                     \errors = 1
              ;                     ProcedureReturn - 1
              ;                   EndIf
              ;                 EndIf
              ;                 
              ;               EndIf
              
              If Not \errors
                
                If Not _text_cut_(*this)
                  If \row\_s()\text\edit[2]\len
                    
                    If \text\caret\pos[1] > \text\caret\pos[2] : \text\caret\pos[1] = \text\caret\pos[2] : EndIf
                    \row\_s()\text\edit[2]\len = 0 : \row\_s()\text\edit[2]\string.s = "" : \row\_s()\text\edit[2]\change = 1
                    
                    \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                    \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                    
                    \text\string.s = \text\edit[1]\string + \text\edit[3]\string
                    \text\change =- 1 ; - 1 post event change widget
                    
                  ElseIf \text\caret\pos[2] > 0 : \text\caret\pos[1] - 1 
                    \row\_s()\text\edit[1]\string.s = Left(\row\_s()\text\string.s, \text\caret\pos[1] )
                    \row\_s()\text\edit[1]\len = Len(\row\_s()\text\edit[1]\string.s) : \row\_s()\text\edit[1]\change = 1
                    
                    \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                    \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                    
                    \text\string.s = Left(\text\string.s, \row\_s()\text\pos+\text\caret\pos[1] ) + \text\edit[3]\string
                    \text\change =- 1 ; - 1 post event change widget
                  Else
                    ; Если дошли до начала строки то 
                    ; переходим в конец предыдущего итема
                    If \index[1] > _line_first_ 
                      \text\string.s = RemoveString(\text\string.s, #LF$, #PB_String_CaseSensitive, \row\_s()\text\pos+\text\caret\pos[1], 1)
                      
                      ;to up
                      \index[1] - 1
                      \index[2] - 1
                      
                      If *this\row\_s()\index <> \index[2] And
                         SelectElement(*this\row\_s(), \index[2]) 
                      EndIf
                      ;: _edit_sel_draw_(*this, \index[2], \text\len)
                      
                      \text\caret\pos[1] = \row\_s()\text\len
                      \text\change =- 1 ; - 1 post event change widget
                      
                    Else
                      \errors = 1
                      ProcedureReturn - 1
                    EndIf
                    
                  EndIf
                EndIf
                
                If \text\change
                  \text\caret\pos[2] = \text\caret\pos[1] 
                  Repaint =- 1 
                EndIf
              EndIf
              
            Case #PB_Shortcut_Delete 
              If Not _text_cut_(*this)
                If \row\_s()\text\edit[2]\len
                  If \text\caret\pos[1] > \text\caret\pos[2] : \text\caret\pos[1] = \text\caret\pos[2] : EndIf
                  \row\_s()\text\edit[2]\len = 0 : \row\_s()\text\edit[2]\string.s = "" : \row\_s()\text\edit[2]\change = 1
                  
                  \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                  \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                  
                  \text\string.s = \text\edit[1]\string + \text\edit[3]\string
                  \text\change =- 1 ; - 1 post event change widget
                  
                ElseIf \text\caret\pos[2] < \row\_s()\text\len 
                  \row\_s()\text\edit[3]\string.s = Right(\row\_s()\text\string.s, \row\_s()\text\len - \text\caret\pos[1] - 1)
                  \row\_s()\text\edit[3]\len = Len(\row\_s()\text\edit[3]\string.s) : \row\_s()\text\edit[3]\change = 1
                  
                  \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                  \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                  
                  \text\edit[3]\string = Right(\text\string.s, \text\len - (\row\_s()\text\pos + \text\caret\pos[1] ) - 1)
                  \text\edit[3]\len = Len(\text\edit[3]\string.s)
                  
                  \text\string.s = \text\edit[1]\string + \text\edit[3]\string
                  \text\change =- 1 ; - 1 post event change widget
                Else
                  If \index[2] < \count\items - 1
                    \text\string.s = RemoveString(\text\string.s, #LF$, #PB_String_CaseSensitive, \row\_s()\text\pos+\text\caret\pos[1] , 1)
                    \text\change =- 1 ; - 1 post event change widget
                  EndIf
                EndIf
              EndIf
              
              If \text\change
                \text\caret\pos[2] = \text\caret\pos[1] 
                Repaint =- 1 
              EndIf
              
              ;- return
            Case #PB_Shortcut_Return 
              If *this\text\multiline
                If Not _text_paste_(*this, #LF$)
                  \index[2] + 1
                  \index[1] = \index[2]
                  \text\caret\pos[2] = 0
                  \text\caret\pos[1] = 0
                  \text\change =- 1 ; - 1 post event change widget
                EndIf
              Else
                *this\errors = 1
                ProcedureReturn - 1
              EndIf
              
              If \text\change 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_C, #PB_Shortcut_X
              If _key_control_
                SetClipboardText(\text\edit[2]\string)
                
                If \root\keyboard\key = #PB_Shortcut_X
                  Repaint = _text_cut_(*this)
                EndIf
              EndIf
              
            Case #PB_Shortcut_V
              If _key_control_ And \text\editable
                Protected text.s = GetClipboardText()
                
                If Not \text\multiLine
                  text = ReplaceString(text, #LFCR$, #LF$)
                  text = ReplaceString(text, #CRLF$, #LF$)
                  text = ReplaceString(text, #CR$, #LF$)
                  text = RemoveString(text, #LF$)
                EndIf
                
                Repaint = _text_insert_(*this, text)
              EndIf  
              
          EndSelect 
          
          Select *this\root\keyboard\key
            Case #PB_Shortcut_Home,
                 #PB_Shortcut_End,
                 #PB_Shortcut_PageUp, 
                 #PB_Shortcut_PageDown,
                 #PB_Shortcut_Up,
                 #PB_Shortcut_Down,
                 #PB_Shortcut_Left,
                 #PB_Shortcut_Right,
                 ;#PB_Shortcut_Back,
              #PB_Shortcut_Delete,
#PB_Shortcut_Return
              
              If Not Repaint
                *this\errors = 1
                ProcedureReturn - 1
              EndIf
              
            Case #PB_Shortcut_A,
                 #PB_Shortcut_C,
                 #PB_Shortcut_X, 
                 #PB_Shortcut_V
              
          EndSelect
          
          ;
          
      EndSelect
      
      ;       If Repaint =- 1
      ;         _start_drawing_(*this)
      ;         
      ;         If \text\caret\pos[1] < \text\caret\pos[2]
      ;           ; Debug \text\caret\pos[2]-\text\caret\pos[1] 
      ;           _edit_sel_(*this, \text\caret\pos[1] , \text\caret\pos[2]-\text\caret\pos[1] )
      ;         Else
      ;           ; Debug \text\caret\pos[1] -\text\caret\pos[2]
      ;           _edit_sel_(*this, \text\caret\pos[2], \text\caret\pos[1]-\text\caret\pos[2])
      ;         EndIf
      ;         
      ;         StopDrawing() 
      ;       EndIf                                                  
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  Procedure   events(*this._struct_, eventtype.l)
    Static DoubleClick.i=-1
    Protected Repaint.i, _key_control_.i, Caret.i, _line_.l, String.s
    
    With *this
      Repaint | Bar::events(\scroll\v, EventType, \root\mouse\x, \root\mouse\y)
      Repaint | Bar::events(\scroll\h, EventType, \root\mouse\x, \root\mouse\y)
      
      If *this And (*this\scroll\v\from =- 1 And *this\scroll\h\from =- 1)
        If ListSize(*this\row\_s())
          If Not \hide And \interact
            ; Get line position
            ;If \root\mouse\buttons ; сним двойной клик не работает
            If \root\mouse\y < \y
              _line_ =- 1
            Else
              _line_ = ((\root\mouse\y-\y-\text\y+\scroll\v\bar\page\pos) / (\text\height + \flag\gridlines))
            EndIf
            ;EndIf
            
            Select EventType 
              Case #PB_EventType_LeftDoubleClick 
                ; bug pb
                ; в мак ос в editorgadget ошибка
                ; при двойном клике на слове выделяет правильно 
                ; но стирает вместе с предшествующим пробелом
                ; в окнах выделяет уще и пробелл но стирает то что выделено
                
                ; Событие двойной клик происходит по разному
                ; - mac os -
                ; LeftButtonDown 
                ; LeftButtonUp 
                ; LeftClick 
                ; LeftDoubleClick 
                
                ; - windows & linux -
                ; LeftButtonDown
                ; LeftDoubleClick
                ; LeftButtonUp
                ; LeftClick
                
                *this\index[2] = _line_
                
                Caret = _edit_sel_stop_(*this)
                *this\text\caret\time = ElapsedMilliseconds()
                *this\text\caret\pos[2] = _edit_sel_start_(*this)
                Repaint = _edit_sel_draw_(*this, *this\index[2], Caret)
                *this\row\selected = \row\_s() ; *this\index[2]
                
              Case #PB_EventType_LeftButtonDown
                
                If _line_ >= 0 And 
                   _line_ < \count\items And 
                   _line_ <> \row\_s()\index  
                  
                  \row\_s()\color\State = 0
                  SelectElement(*this\row\_s(), _line_) 
                  \row\_s()\color\State = 1
                EndIf
                
                If _line_ = \row\_s()\index
                  If *this\row\selected And 
                     *this\row\selected = \row\_s() And
                     (ElapsedMilliseconds() - *this\text\caret\time) < 500
                    
                    *this\text\caret\pos[2] = 0
                    *this\row\box\checked = #False
                    *this\row\selected = #Null
                    *this\index[1] = _line_
                    *this\text\caret\pos[1] = \row\_s()\text\len ; Чтобы не прокручивало в конец строки
                    Repaint = _edit_sel_draw_(*this, _line_, \row\_s()\text\len)
                    
                  Else
                    _start_drawing_(*this)
                    *this\row\selected = \row\_s()
                    
                    If *this\text\editable And _edit_sel_is_line_(*this)
                      ; Отмечаем что кликнули
                      ; по выделеному тексту
                      *this\row\box\checked = 1
                      
                      Debug "sel - "+\row\_s()\text\edit[2]\width
                      SetGadgetAttribute(*this\root\canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
                    Else
                      ; reset items selection
                      PushListPosition(*this\row\_s())
                      ForEach *this\row\_s()
                        If *this\row\_s()\text\edit[2]\width <> 0 
                          _edit_sel_reset_(*this\row\_s())
                        EndIf
                      Next
                      PopListPosition(*this\row\_s())
                      
                      Caret = _text_caret_(*this)
                      
                      \index[2] = \row\_s()\index 
                      
                      
                      If *this\text\caret\pos[1] <> Caret
                        *this\text\caret\pos[1] = Caret
                        *this\text\caret\pos[2] = Caret 
                        Repaint =- 1
                      EndIf
                      
                      If *this\index[1] <> _line_ 
                        *this\index[1] = _line_
                        Repaint = 1
                      EndIf
                      
                      If Repaint
                        Repaint = Bool(_edit_sel_set_(*this, _line_, Repaint))
                      EndIf
                    EndIf
                    
                    StopDrawing() 
                  EndIf
                EndIf
                
                
              Case #PB_EventType_MouseMove  
                If \root\mouse\buttons & #PB_Canvas_LeftButton 
                  Repaint = _edit_sel_draw_(*this, _line_)
                EndIf
                
              Case #PB_EventType_LeftButtonUp  
                If *this\text\editable And *this\row\box\checked
                  ;                   
                  ;                   If _line_ >= 0 And 
                  ;                      _line_ < \count\items And 
                  ;                      _line_ <> \row\_s()\index And 
                  ;                      SelectElement(\row\_s(), _line_) 
                  ;                   EndIf
                  ;                    
                  _start_drawing_(*this)
                  
                  ; на одной линии работает
                  ; теперь надо сделать чтоб и на другие линии можно было бросать
                  If *this\text\caret\pos[2] = *this\text\caret\pos[1] 
                    
                    ; Если бросили на правую сторону от выделеного текста.
                    If *this\index[2] = *this\index[1] And *this\text\caret\pos[2] > *this\row\selected\text\edit[2]\pos + *this\row\selected\text\edit[2]\len
                      *this\text\caret\pos[2] - *this\row\selected\text\edit[2]\len
                    EndIf
                    ; Debug ""+*this\text\caret\pos[2] +" "+ *this\row\selected\text\edit[2]\pos
                    
                    *this\row\selected\text\string = RemoveString(*this\row\selected\text\string, *this\row\selected\text\edit[2]\string, #PB_String_CaseSensitive, *this\row\selected\text\edit[2]\pos, 1)
                    *this\text\string = RemoveString(*this\text\string, *this\row\selected\text\edit[2]\string, #PB_String_CaseSensitive, *this\row\selected\text\pos+*this\row\selected\text\edit[2]\pos, 1)
                    
                    *this\row\_s()\text\string = InsertString(*this\row\_s()\text\string, *this\row\selected\text\edit[2]\string, *this\text\caret\pos[2]+1)
                    *this\text\string = InsertString(*this\text\string, *this\row\selected\text\edit[2]\string, *this\row\_s()\text\pos+*this\text\caret\pos[2]+1)
                    
                    
;                       \row\_s()\text\edit[1]\string.s = Left(\row\_s()\text\string.s, \text\caret\pos[1] )
;                     \row\_s()\text\edit[1]\len = Len(\row\_s()\text\edit[1]\string.s) : \row\_s()\text\edit[1]\change = 1
;                     
;                     \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
;                     \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
;                     
;                     \text\string.s = Left(\text\string.s, \row\_s()\text\pos+\text\caret\pos[1] ) + \text\edit[3]\string
;                     \text\change =- 1 ; - 1 post event change widget
                  
                    ;                     _text_insert_(*this, *this\row\selected\text\edit[2]\string)
                    
                    Debug *this\row\selected\index
                    ;                     *this\index[1] = *this\row\selected\index
                    ;                     *this\index[2] = *this\row\selected\index
                    ;                     Protected len = *this\row\selected\text\edit[2]\len
                    ;                     ;
                    ;                     _line_ = *this\row\selected\index
                    ;                     If _line_ >= 0 And 
                    ;                      _line_ < \count\items And 
                    ;                      _line_ <> \row\_s()\index And 
                    ;                      SelectElement(\row\_s(), _line_) 
                    ;                   EndIf
                    ;                           
                    Debug *this\row\selected\text\string
                    
                    If *this\index[2] <> *this\index[1]
                      ; *this\text\change =- 1
                      _edit_sel_reset_(*this\row\selected)
                      *this\index[2] = *this\index[1]
                      
                      ;                          *this\text\change =- 1
                      ;                       text_multiline_make(*this)
                      ;                        *this\text\change = 0
                      ;                     
                    EndIf
                    
                    *this\text\caret\pos[1] = *this\row\selected\text\edit[2]\len
                    
                    ;Swap *this\text\caret\pos[1], *this\text\caret\pos[2]
                    *this\row\selected = #Null
                    
                    Repaint = _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1])
                    ;                     If *this\text\caret\pos[1] <> Caret  ; *this\text\caret\pos[2]); + *this\row\selected\text\edit[2]\len
                    ;                       *this\text\caret\pos[1] = Caret
                    ;                       Repaint =- 1
                    ;                     EndIf
                    ;                     
                    ;                     If *this\index[1] <> _line_ 
                    ;                       *this\index[1] = _line_
                    ;                       Repaint = 1
                    ;                     EndIf
                    ;Repaint = _edit_sel_set_(*this, *this\index[1], Repaint)
                    
                    SetGadgetAttribute(*this\root\canvas, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
                  Else
                    *this\text\caret\pos[2] = _text_caret_(*this)
                    *this\row\_s()\text\edit[2]\len = 0
                    *this\index[2] = _line_
                    
                    If *this\text\caret\pos[1] <> *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                      *this\text\caret\pos[1] = *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                      Repaint =- 1
                    EndIf
                    
                    If *this\index[1] <> _line_ 
                      *this\index[1] = _line_
                      Repaint = 1
                    EndIf
                    
                    Repaint = _edit_sel_set_(*this, _line_, Repaint)
                  EndIf
                  
                  StopDrawing() 
                  *this\row\box\checked = #False
                  *this\row\selected = #Null
                  Repaint = 1
                EndIf
                
              Default
                itemSelect(\index[2], \row\_s())
            EndSelect
          EndIf
          
          ; edit events
          If *this\text\editable And GetActive() = *this
            Repaint | events_key_editor(*this, EventType, \root\mouse\x, \root\mouse\y)
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure g_callback()
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.l = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    Protected Repaint, *this._struct_ = GetGadgetData(EventGadget)
    Protected *deactive._struct_ = GetActive()
    
    With *this
      If EventType = #PB_EventType_LeftButtonDown
        GetActive() = *this
        If *deactive
;           ForEach *deactive\row\_s()
;             If *deactive\row\_s()\color\state
;               *deactive\row\_s()\color\state = 3
;             EndIf
;           Next
          ReDraw(*deactive)
        EndIf
;         ForEach *this\row\_s()
;           If *this\row\_s()\color\state = 3
;             *this\row\_s()\color\state = 1
;           EndIf
;         Next
      EndIf
      
      Select EventType
        Case #PB_EventType_Repaint
          Debug " -- Canvas repaint -- "+EventGadget
          
        Case #PB_EventType_Input 
          \root\keyboard\input = GetGadgetAttribute(\root\canvas, #PB_Canvas_Input)
          \root\keyboard\key[1] = GetGadgetAttribute(\root\canvas, #PB_Canvas_Modifiers)
        Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
          \root\keyboard\key = GetGadgetAttribute(\root\canvas, #PB_Canvas_Key)
          \root\keyboard\key[1] = GetGadgetAttribute(\root\canvas, #PB_Canvas_Modifiers)
        Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
          \root\mouse\x = GetGadgetAttribute(\root\canvas, #PB_Canvas_MouseX)
          \root\mouse\y = GetGadgetAttribute(\root\canvas, #PB_Canvas_MouseY)
        Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
             #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
             #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
          
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            \root\mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                  (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                  (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
          CompilerElse
            \root\mouse\buttons = GetGadgetAttribute(\root\canvas, #PB_Canvas_Buttons)
          CompilerEndIf
      EndSelect
      
      
      Select EventType
        Case #PB_EventType_Repaint 
          \row\count = \count\items
          
          If *this\repaint 
            *this\repaint = 0
            Repaint = 1
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(\root\canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*this, #PB_Ignore, #PB_Ignore, GadgetWidth(\root\canvas)-*this\x*2, GadgetHeight(\root\canvas)-*this\y*2)
      EndSelect
      
      Repaint | events(*this, EventType)
      
      If Repaint 
        ReDraw(*this)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Editor(X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=0, round.i=0)
    Protected *this._struct_ = AllocateStructure(_struct_)
    
    If *this
      With *this
        \type = #PB_GadgetType_Editor
        \cursor = #PB_Cursor_IBeam
        ;\DrawingMode = #PB_2DDrawing_Default
        \round = round
        \color\alpha = 255
        \interact = 1
        
        \text\caret\pos[1] =- 1
        \text\caret\pos[2] =- 1
        
        \index[1] =- 1
        \x =- 1
        \y =- 1
        
        If Not \text\fontID
          \text\fontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fs = Bool(Not Flag&#__flag_BorderLess)+1
        \bs = \fs
        
        ;\flag\checkBoxes = Bool(flag&#__flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
        ;\flag\bar\buttons = Bool(flag&#__flag_NoButtons)
        ;\flag\lines = Bool(flag&#__flag_NoLines)
        
        \vertical = Bool(Flag&#__flag_Vertical)
        
        \flag\fullselection = Bool(Not flag&#__flag_fullselection)*7
        \flag\alwaysselection = Bool(flag&#__flag_alwaysselection)
        \flag\gridlines = Bool(flag&#__flag_gridlines)
        
        \flag\multiSelect = 1
        
        \text\editable = Bool(Not Flag&#__text_readonly)
        \text\lower = Bool(Flag&#__text_lowercase)
        \text\upper = Bool(Flag&#__text_uppercase)
        \text\pass = Bool(Flag&#__text_password)
        
        \row\margin\hide = Bool(Not Flag&#__text_numeric)
        \row\margin\color\front = $C8000000 ; \color\back[0] 
        \row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
        
        If Not Flag&#__editor_inline
          If Flag&#__text_wordwrap
            \text\multiline = 1
          ElseIf Bool(Flag&#__text_multiline)
            \text\multiline = 2
          Else
            \text\multiline =- 1
          EndIf
        EndIf
        
        \text\align\horizontal = Bool(Flag&#__text_Center)
        ;\text\align\Vertical = Bool(Flag&#__text_Middle)
        \text\align\right = Bool(Flag&#__text_Right)
        \text\align\bottom = Bool(Flag&#__text_Bottom)
        
        If \vertical
          \text\x = \fs 
          \text\y = \fs+2
        Else
          \text\x = 10;\fs+2
          \text\y = \fs
        EndIf
        
        \color = _get_colors_()
        \color\fore = 0
        
        ;\color\back[1] = \color\back[0]
        
        If \text\editable
          \color\back[0] = $FFFFFFFF 
        Else
          \color\back[0] = $FFF0F0F0  
        EndIf
      EndIf
      
      \scroll = AllocateStructure(_s_scroll) 
      ;Bar::Bars(\scroll, 16, 7, Bool(\text\multiline <> 1))
       ;\scroll\v = Bar::Scroll(0, 0, 16, 0, 0,0,0, #PB_ScrollBar_Vertical, 7)
     \scroll\v = Bar::Scroll(0, 0, 16, 0, 0,0,0, #__Bar_Vertical, 7)
      \scroll\h = Bar::Scroll(0, 0, 0, Bool(\text\multiline <> 1)*16, 0,0,0, 0, 7)
      
      Resize(*this, X,Y,Width,Height)
      
      ; set text
      If Text
        SetText(*this, Text.s)
      Else
        \repaint = #True
        \text\change = #True
        ;\text\string = #LF$
        ;\count\items = 1
        ;\text\len = 1
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    ;Protected *this._struct_ = Editor(30, 30, Width-60, Height-60, "", Flag)
    Protected *this._struct_ = Editor(0, 0, Width, Height, "", Flag)
    
    If *this
      With *this
        *this\root = AllocateStructure(_s_root)
        *this\root\window = GetActiveWindow()
        *this\root\canvas = Gadget
        
        ;
        If *this\repaint
          PostEvent(#PB_Event_Gadget, *this\root\window, *this\root\canvas, Constants::#PB_EventType_Repaint)
        EndIf
        
        SetGadgetData(Gadget, *this)
        BindGadgetEvent(Gadget, @g_callback())
        
        ; z-order
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE, GetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE ) | #WS_CLIPSIBLINGS )
          SetWindowPos_( GadgetID(Gadget), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        CompilerEndIf
      EndWith
    EndIf
    
    ProcedureReturn Gadget
  EndProcedure
EndModule


DeclareModule String
  UseModule constants
  
  Structure _struct_ Extends structures::_s_widget : EndStructure
  
  Macro GetText(_this_) : Editor::GetText(_this_) : EndMacro
  Macro SetText(_this_, _text_) : Editor::SetText(_this_, _text_) : EndMacro
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
EndDeclareModule

Module String
  Procedure.i Widget(X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected *this._struct_ = editor::editor(X, Y, Width, Height, "", Flag)
    
    *this\type = #PB_GadgetType_String
    *this\text\multiline = Bool(Flag&#__string_multiline)
    *this\text\Numeric = Bool(Flag&#__string_numeric)
    *this\row\margin\hide = 1
    ;*this\text\align\Vertical = 1
    
    If Text.s
      editor::SetText(*this, Text.s)
    EndIf
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected result.i, *this._struct_
    
    result = Editor::Gadget(Gadget, X, Y, Width, Height, Flag)
    
    *this = GetGadgetData(result)
    *this\type = #PB_GadgetType_String
    *this\text\multiline = Bool(Flag&#__string_multiline)
    *this\text\Numeric = Bool(Flag&#__string_numeric)
    *this\row\margin\hide = 1
    ;*this\text\align\Vertical = 1
    
    If Text.s
      Editor::SetText(*this, Text.s)
    EndIf
    
    ProcedureReturn result
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule String
  UseModule constants
  
  Global *S_0._struct_
  Global *S_1._struct_
  Global *S_2._struct_
  Global *S_3._struct_
  Global *S_4._struct_
  Global *S_5._struct_
  Global *S_6._struct_
  Global *S_7._struct_
  Global *S_8._struct_
  
  ;   *this._const_
  ;   
  ;   Debug *this;Structures::_s_widget ; String::_struct_; _struct_
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure Events()
    Protected String.s
    
    Select EventType()
      Case #PB_EventType_Focus
        String.s = "focus "+EventGadget()+" "+EventType()
      Case #PB_EventType_LostFocus
        String.s = "lostfocus "+EventGadget()+" "+EventType()
      Case #PB_EventType_Change
        String.s = "change "+EventGadget()+" "+EventType()
    EndSelect
    
    If IsGadget(EventGadget())
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - gadget" +" get text - "+ GetGadgetText(EventGadget()) ; Bug in mac os
      Else
        Debug String.s +" - gadget"
      EndIf
    Else
      If EventType() = #PB_EventType_Focus
        Debug String.s +" - widget" +" get text - "+ GetText(EventGadget())
      Else
        Debug String.s +" - widget"
      EndIf
    EndIf
    
  EndProcedure
  
  ; Alignment text
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ImportC ""
      gtk_entry_set_alignment(Entry.i, XAlign.f)
    EndImport
  CompilerEndIf
  
  Procedure SetTextAlignment()
    ; Alignment text
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(1),"setAlignment:", 2)
      CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE) & $FFFFFFFC | #SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
      
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ;       ImportC ""
      ;         gtk_entry_set_alignment(Entry.i, XAlign.f)
      ;       EndImport
      
      gtk_entry_set_alignment(GadgetID(1), 0.5)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
  EndProcedure
  
  Define height=60, Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
  
  Define Text.s, m.s=#LF$
  Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s; +
  
  If OpenWindow(0, 0, 0, 615, (height+5)*8+20+90, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    ;       height = 20
    ;     CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
    ;       height = 18
    ;     CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
    ;       height = 20
    ;       LoadFont(0, "monospace", 9)
    ;       SetGadgetFont(-1,FontID(0))
    ;     CompilerEndIf
    
    StringGadget(0, 8,  10, 290, height, "Read-only StringGadget...", #PB_String_ReadOnly)
    StringGadget(1, 8,  (height+5)*1+10, 290, height, "1234567", #PB_String_Numeric)
    StringGadget(2, 8,  (height+5)*2+10, 290, height, "Right-text StringGadget")
    StringGadget(3, 8,  (height+5)*3+10, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, (height+5)*4+10, 290, height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, (height+5)*5+10, 290, height, "Borderless StringGadget", #PB_String_BorderLess)
    StringGadget(6, 8, (height+5)*6+10, 290, height, "Password", #PB_String_Password)
    StringGadget(7, 8, (height+5)*7+10, 290, height, "")
    StringGadget(8, 8, (height+5)*8+10, 290, 90, Text)
    
    Define i
    For i=0 To 7
      BindGadgetEvent(i, @Events())
    Next
    
    SetTextAlignment()
    SetGadgetText(6, "GaT")
    Debug "Get gadget text "+GetGadgetText(6)
    
    *S_0 = GetGadgetData(Gadget(10, 305+8,  10, 290, height, "Read-only StringGadget...", #__string_readonly))
    *S_1 = GetGadgetData(Gadget(11, 305+8,  (height+5)*1+10, 290, height, "123-only-4567", #__string_numeric|#__string_center))
    *S_2 = GetGadgetData(Gadget(12, 305+8,  (height+5)*2+10, 290, height, "Right-text StringGadget", #__string_right))
    *S_3 = GetGadgetData(Gadget(13, 305+8,  (height+5)*3+10, 290, height, "LOWERCASE...", #__string_lowercase))
    *S_4 = GetGadgetData(Gadget(14, 305+8, (height+5)*4+10, 290, height, "uppercase...", #__string_uppercase))
    *S_5 = GetGadgetData(Gadget(15, 305+8, (height+5)*5+10, 290, height, "Borderless StringGadget", #__flag_borderless))
    *S_6 = GetGadgetData(Gadget(16, 305+8, (height+5)*6+10, 290, height, "Password", #__string_password))
    *S_7 = GetGadgetData(Gadget(17, 305+8, (height+5)*7+10, 290, height, ""))
    *S_8 = GetGadgetData(Gadget(18, 305+8, (height+5)*8+10, 290, 90, Text))
    
    SetText(*S_6, "GaT")
    Debug "Get widget text "+GetText(*S_6)
    
    ;     BindEvent(#PB_Event_Widget, @Events())
    ;     PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ----------------------------------------------------------------------------------------------------------------------
; EnableXP