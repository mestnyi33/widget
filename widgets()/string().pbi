

DeclareModule Macros
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

;IncludePath "/Users/as/Documents/GitHub/Widget/widgets()"

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  XIncludeFile "../fixme(mac).pbi"
CompilerEndIf

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


CompilerIf Not Defined(Bar, #PB_Module)
  XIncludeFile "bar().pb"
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
  
  ;   Macro _s_widget
  ;     structures::_s_widget
  ;   EndMacro
  
  Macro Root()
    *event\root
  EndMacro
  
  Macro GetActive() ; Returns active window
    *event\active
  EndMacro
  
  
  ;- - DECLAREs MACROs
  ;Declare.i Update(*this)
  
  ;- DECLARE
  Declare   SetFont(*this, FontID.i)
  Declare   GetState(*this)
  Declare   SetState(*this, State.l)
  Declare.s GetText(*this)
  Declare   SetText(*this, Text.s, Item.l=0)
  Declare   ClearItems(*this)
  Declare   CountItems(*this)
  Declare   RemoveItem(*this, Item.l)
  Declare   GetAttribute(*this, Attribute.i)
  Declare   SetAttribute(*this, Attribute.i, Value.i)
  Declare   AddItem(*this, Item.l, Text.s, Image.i=-1, Flag.i=0)
  Declare   SetItemState(*this, Item.l, State.i)
  Declare.l GetItemColor(*this, Item.l, ColorType.l, Column.l=0)
  Declare.l SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l=0)
  
  Declare   Draw(*this)
  Declare   ReDraw(*this)
  Declare   events(*this, EventType.l)
  Declare   events_key_editor(*this, eventtype.l, mouse_x.l, mouse_y.l)
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
  Declare.i Editor(X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=0, round.i=0)
  
EndDeclareModule

Module Editor
  CompilerIf Defined(fixme, #PB_Module)
    UseModule fixme
  CompilerEndIf
  
  ;   Global *Buffer = AllocateMemory(10000000)
  ;   Global *Pointer = *Buffer
  ;   
  ;   Procedure.i Update(*this._s_widget)
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
  
  
  Macro _set_content_X_(_this_)
;     If _this_\text\align\right
;       If _this_\row\_s()\text\width > _this_\scroll\width
;         _this_\scroll\x = ((_this_\width - _this_\bs*2 - _this_\text\x*2) - _this_\row\_s()\text\width)
;       Else
;         _this_\scroll\x = ((_this_\width - _this_\bs*2) - _this_\scroll\width)
;       EndIf
;       
;     ElseIf _this_\text\align\horizontal
;       If _this_\row\_s()\text\width > _this_\scroll\width
;         _this_\scroll\x = ((_this_\width - _this_\bs*2 - _this_\text\x*2 + _this_\row\margin\width)-_this_\row\_s()\text\width-Bool(_this_\row\_s()\text\width % 2))/2 
;       Else
;         _this_\scroll\x = ((_this_\width - _this_\bs*2 + _this_\row\margin\width) - _this_\scroll\width - Bool(_this_\scroll\width % 2))/2 
;       EndIf 
;       
;     Else
;       _this_\scroll\x = _this_\row\margin\width
;     EndIf
  EndMacro
  
  Macro _set_content_Y_(_this_)
;     If _this_\text\align\bottom
;       _this_\scroll\y = ((_this_\height - _this_\bs*2 - _this_\text\y*2)-(_this_\text\height*_this_\count\items)) 
;       
;     ElseIf _this_\text\align\vertical
;       _this_\scroll\y = (((_this_\height - _this_\bs*2 -_this_\text\y*2)-(_this_\text\height*_this_\count\items))/2)
;       
;     Else
;       _this_\scroll\y = 0
;     EndIf
  EndMacro
  
  Macro _line_resize_X_(_this_)
    If _this_\vertical
    Else
      _this_\row\_s()\width = Width
      _this_\row\_s()\x = _this_\x[2] + _this_\text\x ;+ _this_\x[2]                              ; + Bool(_this_\text\Rotate = 180) * _this_\row\_s()\text\width ; + _this_\row\margin\width
      _this_\row\_s()\text\x = _this_\row\_s()\x
    EndIf
  EndMacro
  
  Macro _line_resize_Y_(_this_)
    If _this_\vertical
    Else  
      _this_\row\_s()\height = _this_\text\height
      _this_\row\_s()\text\height = _this_\text\height
      _this_\row\_s()\y = _this_\y[2] + (_this_\scroll\height  - _this_\text\y)     ; + Bool(_this_\text\Rotate = 180) * _this_\row\_s()\text\height
      _this_\row\_s()\text\y = _this_\row\_s()\y + (_this_\row\_s()\height-_this_\row\_s()\text\height)/2
    EndIf
  EndMacro
  
  Macro _make_line_pos_(_this_, _len_)
    _this_\row\_s()\text\len = _len_
    _this_\row\_s()\text\pos = _this_\text\pos
    _this_\text\pos + _this_\row\_s()\text\len + 1 ; Len(#LF$)
  EndMacro
  
  
  Macro _make_scroll_x_(_this_)
    If _this_\text\align\right
       _this_\scroll\x = ((_this_\width - _this_\bs*2) - _this_\scroll\width)
      
    ElseIf _this_\text\align\horizontal
       _this_\scroll\x = ((_this_\width - _this_\bs*2 + _this_\row\margin\width) - _this_\scroll\width - Bool(_this_\scroll\width % 2))/2 
      
    Else
      _this_\scroll\x = _this_\row\margin\width
    EndIf
  EndMacro
  
  Macro _make_scroll_y_(_this_)
    If _this_\text\align\bottom
      _this_\scroll\y = ((_this_\height - _this_\bs*2 - _this_\text\y*2 - _this_\flag\gridlines*2) - (_this_\text\height*_this_\count\items)) 
      
    ElseIf _this_\text\align\vertical
      _this_\scroll\y = (((_this_\height - _this_\bs*2 -_this_\text\y*2) - (_this_\text\height*_this_\count\items))/2)
      
    Else
      _this_\scroll\y = 0
    EndIf
  EndMacro
  
  Macro _make_scroll_height_(_this_)
;     If _this_\vertical
;       _this_\scroll\width + _this_\row\_s()\width + _this_\flag\gridlines
;     Else
      _this_\scroll\height + _this_\row\_s()\height + _this_\flag\gridlines
;     EndIf
  
    If _this_\scroll\v And 
       _this_\scroll\v\bar\scrollstep <> _this_\row\_s()\height + Bool(_this_\flag\gridlines)
      _this_\scroll\v\bar\scrollstep = _this_\row\_s()\height + Bool(_this_\flag\gridlines)
    EndIf
  EndMacro
  
  Macro _make_scroll_width_(_this_)
;     If _this_\vertical
;       If _this_\text\multiline < 0
;         _this_\scroll\height = _this_\width[2] - _this_\row\margin\width ; - Bool(_this_\scroll\height > _this_\height[2]) * _this_\scroll\v\width
;       Else
;         If _this_\scroll\height < _this_\row\_s()\text\width+_this_\text\x*2
;           _this_\scroll\height = _this_\row\_s()\text\width+_this_\text\x*2
;         EndIf
;       EndIf
;     Else
      If _this_\text\multiline < 0
        _this_\scroll\width = _this_\width[2] - _this_\row\margin\width - Bool(_this_\scroll\height > _this_\height[2]) * _this_\scroll\v\width
      Else
        If _this_\scroll\width < _this_\row\_s()\text\width+_this_\text\x*2 + *this\text\caret\width
          _this_\scroll\width = _this_\row\_s()\text\width+_this_\text\x*2 + *this\text\caret\width
        EndIf
      EndIf
;     EndIf
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
  Procedure _start_drawing_(*this._s_widget)
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
  
  Macro _text_scroll_x_(_this_)
    *this\change = bar::_scrolled_(*this\scroll\h, _this_\text\caret\x-Bool(_this_\text\caret\x>0) * (_this_\scroll\h\x+_this_\text\x), (_this_\text\x*2+_this_\row\margin\width+2)) ; ok
  EndMacro
  
  Macro _text_scroll_y_(_this_)
    *this\change = bar::_scrolled_(*this\scroll\v, _this_\text\caret\y-Bool(_this_\text\caret\y>0) * (_this_\scroll\v\y+_this_\text\y), (_this_\text\y*2+_this_\text\caret\height)) ; ok
  EndMacro
  
  
  ;-
  Procedure.l _text_caret_(*this._s_widget)
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
  
  Procedure   _edit_sel_(*this._s_widget, _pos_, _len_)
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
    
    ; для красоты
    If *this\row\_s()\text\edit[2]\width > *this\scroll\width
      *this\row\_s()\text\edit[2]\width - _caret_last_len_
    EndIf
    
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
      
      ;*this\text\caret\width = 1
      
      ProcedureReturn 1
      ;       EndIf
    EndIf
    
  EndProcedure
  
  Procedure   _edit_sel_set_(*this._s_widget, _line_, _scroll_) ; Ok
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
  
  Procedure   _edit_sel_draw_(*this._s_widget, _line_, _caret_=-1) ; Ok
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
  
  Procedure   _edit_sel_update_(*this._s_widget)
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
  
  Procedure.i _edit_sel_start_(*this._s_widget)
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
  
  Procedure.i _edit_sel_stop_(*this._s_widget)
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
  
  Procedure.s _text_insert_make_(*this._s_widget, Text.s)
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
  
  Procedure.b _text_paste_(*this._s_widget, Chr.s, Count.l=0)
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
  
  Procedure.b _text_insert_(*this._s_widget, Chr.s)
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
  Procedure.s make_multiline(*this._s_widget, String.s)
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
      
      If \text\multiline
        String = Text_wrap(String + #LF$, Width-\text\padding*2, \text\multiline)
        \count\items = CountString(String, #LF$)
      Else
        String + #LF$
        \count\items = 1
      EndIf
      
      If \count\items
        ClearList(\Items())
        
        If \text\Align\Bottom
          Text_Y = (Height-(\text\Height*\count\items)) - \text\padding
        ElseIf \text\Align\Vertical
          Text_Y = (Height-(\text\Height*\count\items))/2
        Else
          Text_Y = \bs
        EndIf
        
        Protected time = ElapsedMilliseconds()
        
        
        Protected pos, *Sta.Character = @String, *End.Character = @String 
        While *End\c 
          If Text_Y+\text\Height < \bs : Text_Y+\text\Height : Continue : EndIf
          
          If *End\c = #LF And *Sta <> *End And AddElement(\items())
            \items() = AllocateStructure(structures::_s_items)
            
            \items()\text\pos = pos+ListSize(\items()) : pos + \items()\text\Len
            \items()\text\Len = (*End-*Sta)>>#PB_Compiler_Unicode
            \items()\text\string.s = PeekS (*Sta, \items()\text\Len)
            \items()\text\width = TextWidth(\items()\text\string.s)
            \Items()\text\Height = \text\Height
            
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
            : Text_Y + \text\Height
                
            *Sta = *End + #__sOC 
          EndIf 
          
         If Text_Y > Height : Break : EndIf
           *End + #__sOC 
        Wend
        
        
; ;         ;             ; 239
; ;         If CreateRegularExpression(0, ~".*\n?")
; ;           If ExamineRegularExpression(0, string.s)
; ;             While NextRegularExpressionMatch(0) 
; ;               If Text_Y+\text\Height < \bs : Text_Y+\text\Height : Continue : EndIf
; ;               
; ;               If AddElement(\items())
; ;                 \items() = AllocateStructure(_s_items)
; ;                 \items()\text\pos = RegularExpressionMatchPosition(0)
; ;                 \items()\text\len = RegularExpressionMatchLength(0)
; ;                 \items()\text\string.s = RegularExpressionMatchString(0) ; Trim(RegularExpressionMatchString(0), #LF$)
; ;                 \items()\text\width = TextWidth(\items()\text\string.s) 
; ;                 \Items()\text\Height = \text\Height
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
; ;                 Text_Y + \text\Height
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
; ; ;             \Items()\text\Height = \text\Height
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
; ; ;             : Text_Y + \text\Height
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
  Procedure.i text_multiline_make(*this._s_widget)
     ;*this\text\string.s = make_multiline(*this, *this\text\string.s+#LF$) : ProcedureReturn
     
    Static string_out.s
    Protected Repaint, String.s, text_width, len
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *this
;       If \text\y = 0 And \flag\gridlines
;         \text\y = \flag\gridlines * 2
;       EndIf
      
      If \vertical
        Width = \height[2]
        Height = \width[2]
      Else
        width = \width[2]; -\text\x   -\row\margin\width
        height = \height[2]
      EndIf
      
      If \text\multiline < 0
        String.s = text_wrap(\text\string.s+#LF$, Width, \text\multiline) ; Trim(text_wrap(\text\string.s+#LF$, Width, \text\multiline), #LF$)+#LF$
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
          \scroll\height = \text\y*2 ; 0
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
             _set_content_X_(*this)
              _line_resize_X_(*this)
             
            If \countitems = 0
              \row\_s()\text\width = TextWidth(\row\_s()\text\string)
              
              ; Scroll width length
              _make_scroll_width_(*this)
              _edit_sel_update_(*this)
            Else
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
      
      If \flag\gridlines
        \scroll\height - \flag\gridlines
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure Draw(*this._s_widget)
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
          _make_scroll_x_(*this)
          _make_scroll_y_(*this)
          
          If *this\scroll\y <> *this\scroll\v\bar\min
            If *this\scroll\y < 0
              *this\scroll\y = 0
            EndIf
            
            Bar::SetAttribute(*this\scroll\v, #__bar_Minimum, -*this\scroll\y)
          EndIf
          
          If *this\scroll\x <> *this\scroll\h\bar\min
            If *this\scroll\x < 0
              *this\scroll\x = *this\row\margin\width 
            EndIf
            
            If Not *this\vertical
              If *this\text\align\right
                PushListPosition(*this\row\_s())
                ForEach *this\row\_s()
                  *this\row\_s()\text\x = *this\x[2] + *this\scroll\width - *this\row\_s()\text\width - *this\text\x - *this\text\caret\width  
                  ; \row\_s()\x =  \row\_s()\text\x
                Next
                PopListPosition(*this\row\_s())
              EndIf
              
              If *this\text\align\horizontal
                PushListPosition(*this\row\_s())
                ForEach *this\row\_s()
                  *this\row\_s()\text\x = *this\x[2] + (*this\scroll\width - *this\row\_s()\text\width)/2
                  ; *this\row\_s()\x =  *this\row\_s()\text\x
                Next
                PopListPosition(*this\row\_s())
              EndIf
            EndIf
            
            Bar::SetAttribute(*this\scroll\h, #__bar_Minimum, -*this\scroll\x)
          EndIf
          
          Protected bar_change
          
          If *this\scroll\v And *this\scroll\v\bar\max <> *this\scroll\height
            bar_change | Bar::SetAttribute(*this\scroll\v, #__bar_Maximum, *this\scroll\height)
            ;If \text\multiline
            Bar::Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;EndIf
          EndIf
              
          If \scroll\h And \scroll\h\bar\max <> \scroll\width  
            bar_change | Bar::SetAttribute(\scroll\h, #__bar_Maximum, \scroll\width)
            ;If \text\multiline
            Bar::Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;EndIf
          EndIf
             
          If bar_change
            \height[2] = \scroll\v\bar\page\len
            \width[2] = \scroll\h\bar\page\len ; - \row\margin\width 
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
        
        
;         ; then change bar position
;         \scroll\y =- (*this\scroll\v\bar\page\pos-*this\scroll\v\bar\min)
;         \scroll\x =- (*this\scroll\h\bar\page\pos-*this\scroll\h\bar\min)
        
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
                                  \row\_s()\y+\row\_s()\height+*this\scroll\y>*this\y[2] And 
                                  (\row\_s()\y-*this\y[2])+*this\scroll\y<*this\height[2])
            
            ; Draw selections
            If *this\row\_s()\draw 
              Y = *this\row\_s()\y + *this\scroll\y
              Text_X = *this\row\_s()\text\x + *this\scroll\x + Bool(*this\text\Rotate = 180) * *this\row\_s()\text\width
              Text_Y = *this\row\_s()\text\y + *this\scroll\y + Bool(*this\text\Rotate = 180) * *this\row\_s()\text\height
              
              Protected text_x_sel = \row\_s()\text\edit[2]\x+*this\scroll\x
              Protected sel_x = \x[2] + *this\text\y
              Protected sel_width = \width[2] - *this\text\y*2
              Protected text_sel_state = 2 + Bool(GetActive() <> *this)
              Protected text_sel_width = \row\_s()\text\edit[2]\width + Bool(GetActive() <> *this) * *this\text\caret\width
              
              If *this\text\editable
                ; Draw lines
                ; Если для итема установили задный фон отличный от заднего фона едитора
                If *this\row\_s()\color\Back  
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\back[0] )
                  
                  If *this\color\Back And 
                     *this\color\Back <> *this\row\_s()\color\Back
                    ; Draw margin back color
                    If *this\row\margin\width > 0
                      ; то рисуем вертикальную линию на границе поля нумерации и начало итема
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(*this\row\margin\x, *this\row\_s()\y, *this\row\margin\width, *this\row\_s()\height, *this\row\margin\color\back)
                      Line(*this\x[2]+*this\row\margin\width, *this\row\_s()\y, 1, *this\row\_s()\height, *this\color\Back) ; $FF000000);
                    EndIf
                  EndIf
                EndIf
                
                ; Draw entered selection
                ; GetActive() = *this
                If *this\row\_s()\index = *this\index[1] ; \color\state;
                  If *this\row\_s()\color\back[*this\row\_s()\color\state]<>-1              ; no draw transparent
                    If *this\row\_s()\color\fore[*this\row\_s()\color\state]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      _box_gradient_(*this\vertical,sel_x,Y,sel_width, *this\row\_s()\height, *this\row\_s()\color\fore[*this\row\_s()\color\state], *this\row\_s()\color\back[*this\row\_s()\color\state], *this\row\_s()\round)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\back[*this\row\_s()\color\state] )
                    EndIf
                  EndIf
                  
                  If *this\row\_s()\color\frame[*this\row\_s()\color\state]<>-1 ; no draw transparent
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\frame[*this\row\_s()\color\state] )
                  EndIf
                EndIf
              EndIf
              
              ; Draw text
              ; Draw string
              If *this\text\editable And *this\row\_s()\text\edit[2]\width And *this\color\front <> *this\row\_s()\color\front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  ; to right
                  If (*this\index[1] > *this\index[2] Or 
                      (*this\index[1] = *this\index[2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]))
                    
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawRotatedText(Text_X, Text_Y, \row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    
                    If *this\row\_s()\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      _box_gradient_(*this\vertical,text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\fore[text_sel_state], *this\row\_s()\color\back[text_sel_state], \row\_s()\round)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state])
                    EndIf
                    
                    If \row\_s()\text\edit[2]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(text_x_sel, Text_Y, \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                    EndIf
                    
                  Else
                    If *this\row\_s()\color\fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      _box_gradient_(*this\vertical,text_x_sel, Y, text_sel_width, \row\_s()\height,*this\row\_s()\color\fore[text_sel_state], *this\row\_s()\color\back[text_sel_state], \row\_s()\round)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state] )
                    EndIf
                    
                    If \row\_s()\text\edit[3]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\row\_s()\text\edit[3]\x+*this\scroll\x, Text_Y, \row\_s()\text\edit[3]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    EndIf
                    
                    If \row\_s()\text\edit[2]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \row\_s()\text\edit[1]\string.s+\row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                    EndIf
                    
                    If \row\_s()\text\edit[1]\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \row\_s()\text\edit[1]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    EndIf
                  EndIf
                  
                CompilerElse
                  If *this\row\_s()\color\fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    _box_gradient_(*this\vertical,text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\fore[text_sel_state], *this\row\_s()\color\back[text_sel_state], \row\_s()\round)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(text_x_sel, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state])
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Transparent)
                  
                  If \row\_s()\text\edit[1]\string.s
                    DrawRotatedText(\row\_s()\text\edit[1]\x+*this\scroll\x, Text_Y, \row\_s()\text\edit[1]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                  EndIf
                  If \row\_s()\text\edit[2]\string.s
                    DrawRotatedText(text_x_sel, Text_Y, \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                  EndIf
                  If \row\_s()\text\edit[3]\string.s
                    DrawRotatedText(\row\_s()\text\edit[3]\x+*this\scroll\x, Text_Y, \row\_s()\text\edit[3]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                  EndIf
                CompilerEndIf
                
              Else
                If *this\row\_s()\text\edit[2]\width
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(text_x_sel, Y, text_sel_width, *this\row\_s()\height, $FFFBD9B7);*this\row\_s()\color\back[2])
                EndIf
                
                If *this\color\state = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, *this\row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, *this\row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                EndIf
              EndIf
              
              ; Draw margin text
              If *this\row\margin\width > 0
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(*this\row\_s()\margin\x, *this\row\_s()\margin\y+*this\scroll\y, *this\row\_s()\margin\string, *this\row\margin\color\front)
              EndIf
              
              ; Horizontal line
              If *this\flag\GridLines And *this\row\_s()\color\line And *this\row\_s()\color\line <> *this\row\_s()\color\back : DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(*this\row\_s()\x, (*this\row\_s()\y+*this\row\_s()\height+Bool(*this\flag\gridlines>1))+*this\scroll\y, *this\row\_s()\width, 1, *this\color\line)
              EndIf
            EndIf
          Next
          PopListPosition(*this\row\_s()) ; 
        EndIf
        
        ; Draw caret
        If *this\text\editable And GetActive() = *this ; *this\color\state
          DrawingMode(#PB_2DDrawing_XOr)             
          Box(*this\text\caret\x+*this\scroll\x, *this\text\caret\y+*this\scroll\y, *this\text\caret\width, *this\text\caret\height, $FFFFFFFF)
        EndIf
        
        ; Draw scroll bars
        If *this\scroll
          ;If *this\scroll\v\bar\change Or *this\repaint
            bar::draw(*this\scroll\v)
          ;EndIf
          ;If *this\scroll\v\bar\change Or *this\repaint
            bar::draw(*this\scroll\h)
          ;EndIf
        EndIf
      
        ; Draw frames
        If *this\errors
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round, $FF0000FF)
          If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round, $FF0000FF) : EndIf  ; Сглаживание краев )))
        ElseIf *this\bs
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\frame[\color\state])
          If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round,\color\front[\color\state]) : EndIf  ; Сглаживание краев )))
        EndIf
        
        If \scroll And \scroll\v And \scroll\h
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          ; Scroll area coordinate
          Box(\scroll\h\x+*this\scroll\x, \scroll\v\y+*this\scroll\y, \scroll\width, (\scroll\height), $FF0000FF) ; + \text\y*2 - \flag\gridlines), $FF0000FF)
          
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
  
  Procedure ReDraw(*this._s_widget)
    If *this And *this\root And StartDrawing(CanvasOutput(*this\root\canvas))
      ; If *this\root\fontID : DrawingFont(*this\root\fontID) : EndIf
        FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FFf0f0f0)
      
      Draw(*this) 
      StopDrawing()
    EndIf
  EndProcedure
  
  ;-
  ;- - (SET&GET)s
  Procedure   AddItem(*this._s_widget, Item.l,Text.s,Image.i=-1,Flag.i=0)
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
  
  Procedure   SetAttribute(*this._s_widget, Attribute.i, Value.i)
    With *this
      
    EndWith
  EndProcedure
  
  Procedure   GetAttribute(*this._s_widget, Attribute.i)
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
  
  Procedure   SetItemState(*this._s_widget, Item.l, State.i)
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
  
  Procedure   SetState(*this._s_widget, State.l) ; Ok
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
  
  Procedure   GetState(*this._s_widget)
    ProcedureReturn *this\text\caret\pos
  EndProcedure
  
  Procedure   ClearItems(*this._s_widget)
    *this\count\items = 0
    *this\text\change = 1 
    
    If *this\text\editable
      *this\text\string = #LF$
    EndIf
    
    _repaint_(*this)
    
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*this._s_widget)
    ProcedureReturn *this\count\items
  EndProcedure
  
  Procedure.i RemoveItem(*this._s_widget, Item.l)
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
  
  Procedure.s GetText(*this._s_widget)
    With *this
      If \text\pass
        ProcedureReturn \text\edit\string
      Else
        ProcedureReturn \text\string
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetText(*this._s_widget, Text.s, Item.l=0)
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
  
  Procedure.i SetFont(*this._s_widget, FontID.i)
    
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
  
  Procedure.l SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l=0)
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
  
  Procedure.l GetItemColor(*this._s_widget, Item.l, ColorType.l, Column.l=0)
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
  
  
  Procedure.i Resize(*this._s_widget, X.l,Y.l,Width.l,Height.l)
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
        
        \width[2] = \scroll\h\bar\page\len ; - \row\margin\width 
        \height[2] = \scroll\v\bar\page\len
        
      EndIf
      
      
      ProcedureReturn \resize
    EndWith
  EndProcedure
  
  ;-
  ;- - KEYBOARDs
  Procedure   events_key_editor(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
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
  Procedure   events(*this._s_widget, eventtype.l)
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
            If (\root\mouse\y-\y[2]-\text\y+\scroll\v\bar\page\pos) > 0
             _line_ = ((\root\mouse\y-\y[2]-\text\y-\scroll\y) / (\text\height + \flag\gridlines))
             ;  _line_ = ((\root\mouse\y-\y[2]-\text\y+\scroll\v\bar\page\pos) / (\text\height + \flag\gridlines))
            Else
              _line_ =- 1
            EndIf
            ;EndIf
            ;Debug  _line_; (\root\mouse\y-\y[2]-\text\y+\scroll\v\bar\page\pos)
            
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
                EndIf
                
                If _line_ = \row\_s()\index
                  \row\_s()\color\State = 1
                  
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
                 If \index[2] >= 0 And 
                   \index[2] < \count\items And 
                   \index[2] <> \row\_s()\index  
                  \row\_s()\color\State = 0
                  SelectElement(*this\row\_s(), \index[2]) 
                EndIf
                
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
    Protected Repaint, *this._s_widget = GetGadgetData(EventGadget)
    Protected *deactive._s_widget = GetActive()
    
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
  
   Macro _set_text_flag_(_this_, _flag_)
;     If Not _this_\text
;       _this_\text = AllocateStructure(_s_text)
;     EndIf
    
    If _this_\text
      _this_\text\x = 2
      _this_\text\y = 2
      ; _this_\text\padding = 5
      _this_\text\change = #True
      
      _this_\text\editable = Bool(Not constants::_check_(_flag_, #__text_readonly))
      _this_\text\lower = constants::_check_(_flag_, #__text_lowercase)
      _this_\text\upper = constants::_check_(_flag_, #__text_uppercase)
      _this_\text\pass = constants::_check_(_flag_, #__text_password)
      
      If _flag_&#__align_text
        _this_\text\align\top = constants::_check_(_flag_, #__text_top)
        _this_\text\align\left = constants::_check_(_flag_, #__text_left)
        _this_\text\align\right = constants::_check_(_flag_, #__text_right)
        _this_\text\align\bottom = constants::_check_(_flag_, #__text_bottom)
        
        If constants::_check_(_flag_, #__text_center)
          _this_\text\align\horizontal = Bool(Not _this_\text\align\right And Not _this_\text\align\left)
          _this_\text\align\vertical = Bool(Not _this_\text\align\bottom And Not _this_\text\align\top)
        EndIf
      EndIf
      
      If constants::_check_(_flag_, #__text_wordwrap)
        _this_\text\multiLine =- 1
      ElseIf constants::_check_(_flag_, #__text_multiline)
        _this_\text\multiLine = 1
      Else
        _this_\text\multiLine = 0 
      EndIf
      
      If constants::_check_(_flag_, #__text_invert)
        _this_\text\Rotate = Bool(_this_\vertical)*90 + Bool(Not _this_\vertical)*180
      Else
        _this_\text\Rotate = Bool(_this_\vertical)*270
      EndIf
      
      If _this_\type = #PB_GadgetType_Editor Or
         _this_\type = #PB_GadgetType_String
        
        _this_\color\fore = 0
        _this_\text\caret\pos[1] =- 1
        _this_\text\caret\pos[2] =- 1
        _this_\cursor = #PB_Cursor_IBeam
        
        If _this_\text\editable
          _this_\text\caret\width = 1
          _this_\color\back[0] = $FFFFFFFF 
        Else
          _this_\color\back[0] = $FFF0F0F0  
        EndIf
      EndIf
    
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        ;                     Protected TextGadget = TextGadget(#PB_Any, 0,0,0,0,"")
        ;                     \text\fontID = GetGadgetFont(TextGadget) 
        ;                     FreeGadget(TextGadget)
        ;Protected FontSize.CGFloat = 12.0 ; boldSystemFontOfSize  fontWithSize
        ;\text\fontID = CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @FontSize) 
        ; CocoaMessage(@FontSize,0,"NSFont systemFontSize")
        
        ;\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica Neue", 12))
        ;\text\fontID = FontID(LoadFont(#PB_Any, "Tahoma", 12))
        _this_\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 12))
        ;
        ;           \text\fontID = CocoaMessage(0, 0, "NSFont controlContentFontOfSize:@", @FontSize)
        ;           CocoaMessage(@FontSize, \text\fontID, "pointSize")
        ;           
        ;           ;FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
        
        ;  Debug PeekS(CocoaMessage(0,  CocoaMessage(0, \text\fontID, "displayName"), "UTF8String"), -1, #PB_UTF8)
        
      CompilerElse
        _this_\text\fontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
      CompilerEndIf
    EndIf
    
  EndMacro
 
  Procedure.i Editor(X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=0, round.i=0)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    
    If *this
      With *this
        \type = #PB_GadgetType_Editor
        
        \x =- 1
        \y =- 1
        \interact = 1
        
        \index[1] =- 1
        \index[2] =- 1
        \round = round
        
        \color = _get_colors_()
   
        \vertical = constants::_check_(Flag, #__flag_Vertical)
        \fs = Bool(Not constants::_check_(Flag, #__flag_BorderLess)) * 2
        \bs = \fs
        
        If Not Bool(flag&#__flag_wordwrap)
          Flag|#__text_multiline
        EndIf
        
        \flag\multiSelect = 1
        \flag\fullselection = Bool(Not constants::_check_(Flag, #__flag_fullselection))*7
        \flag\alwaysselection = constants::_check_(Flag, #__flag_alwaysselection)
        \flag\gridlines = constants::_check_(Flag, #__flag_gridlines)
        ;\flag\checkBoxes = constants::_check_(Flag, #__flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
        ;\flag\bar\buttons = constants::_check_(Flag, #__flag_NoButtons)
        ;\flag\lines = constants::_check_(Flag, #__flag_NoLines)
        
        \row\margin\hide = Bool(Not constants::_check_(Flag, #__text_numeric))
        \row\margin\color\front = $C8000000 ; \color\back[0] 
        \row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
        
        _set_text_flag_(*this, Flag)
        
     EndIf
      
     If Width Or Height
       \scroll = AllocateStructure(_s_scroll) 
       \scroll\v = Bar::create(#PB_GadgetType_ScrollBar,16, 0,0,0, #PB_ScrollBar_Vertical, 7, *this)
       \scroll\h = Bar::create(#PB_GadgetType_ScrollBar, 16, 0,0,0, 0, 7, *this)
       
       Resize(*this, X,Y,Width,Height)
     EndIf
     
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
    
    CompilerIf #PB_Compiler_IsMainFile
      Protected *this._s_widget = Editor(50, 0, Width-100, Height, "", Flag)
    CompilerElse
      Protected *this._s_widget = Editor(0, 0, Width, Height, "", Flag)
    CompilerEndIf

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
  
  Structure _s_widget Extends structures::_s_widget : EndStructure
  
  Macro GetText(_this_) : Editor::GetText(_this_) : EndMacro
  Macro SetText(_this_, _text_) : Editor::SetText(_this_, _text_) : EndMacro
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
EndDeclareModule

Module String
  Procedure.i Widget(X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected *this._s_widget = editor::editor(X, Y, Width, Height, "", Flag)
    
    *this\type = #PB_GadgetType_String
    *this\text\multiline = Bool(Flag&#__string_multiline)
    *this\text\numeric = Bool(Flag&#__string_numeric)
    *this\row\margin\hide = 1
    ;*this\text\align\Vertical = 1
    
    If Text.s
      editor::SetText(*this, Text.s)
    EndIf
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s, Flag.i=#Null)
    Protected result.i, *this._s_widget
    
    result = Editor::Gadget(Gadget, X, Y, Width, Height, Flag)
    
    *this = GetGadgetData(result)
    *this\type = #PB_GadgetType_String
    
    If Flag&#__string_multiline
      *this\text\multiline = 1
    ElseIf Flag&#__text_wordwrap
      *this\text\multiline =- 1
    Else
      *this\text\multiline = 0
    EndIf
  
    If *this\text\multiline
      *this\row\margin\hide = 0;Bool(Not Flag&#__string_numeric)
      *this\row\margin\color\front = $C8000000 ; \color\back[0] 
      *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
    Else
      *this\row\margin\hide = 1
      *this\text\numeric = Bool(Flag&#__string_numeric)
    EndIf
    
    ;*this\text\align\left = Bool(Not Flag&#__string_center)
    
    *this\text\align\vertical = Bool(Not *this\text\align\bottom And Not *this\text\align\top)
          
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
  
  Global *S_0._s_widget
  Global *S_1._s_widget
  Global *S_2._s_widget
  Global *S_3._s_widget
  Global *S_4._s_widget
  Global *S_5._s_widget
  Global *S_6._s_widget
  Global *S_7._s_widget
  Global *S_8._s_widget
  Global *S_9._s_widget
  
  ;   *this._const_
  ;   
  ;   Debug *this;Structures::_s_widget ; String::_s_widget; _s_widget
  
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
  
  Define height=60, Text1.s = "Borderless StringGadget" + #LF$ + " Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
  
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
  
  If OpenWindow(0, 0, 0, 615, (height+5)*8+20+90+150, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
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
    StringGadget(1, 8,  (height+5)*1+10, 290, height, "1234567", #PB_String_Numeric|Bool(#PB_Compiler_OS = #PB_OS_Windows) * #PB_Text_Center)
    StringGadget(2, 8,  (height+5)*2+10, 290, height, "Right-text StringGadget", Bool(#PB_Compiler_OS = #PB_OS_Windows) * #PB_Text_Right)
    StringGadget(3, 8,  (height+5)*3+10, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, (height+5)*4+10, 290, height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, (height+5)*5+10, 290, height, Text1, #PB_String_BorderLess)
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
    
    *S_0 = GetGadgetData(Gadget(10, 305+8,  10, 290, height, "Read-only StringGadget...", #__string_readonly|#__text_top))
    *S_1 = GetGadgetData(Gadget(11, 305+8,  (height+5)*1+10, 290, height, "123-only-4567", #__string_numeric|#__string_center))
    *S_2 = GetGadgetData(Gadget(12, 305+8,  (height+5)*2+10, 290, height, "Right-text StringGadget", #__string_right|#__text_bottom))
    *S_3 = GetGadgetData(Gadget(13, 305+8,  (height+5)*3+10, 290, height, "LOWERCASE...", #__string_lowercase))
    *S_4 = GetGadgetData(Gadget(14, 305+8, (height+5)*4+10, 290, height, "uppercase...", #__string_uppercase))
    *S_5 = GetGadgetData(Gadget(15, 305+8, (height+5)*5+10, 290, height, Text1, #__flag_borderless))
    *S_6 = GetGadgetData(Gadget(16, 305+8, (height+5)*6+10, 290, height, "Password", #__string_password))
    *S_7 = GetGadgetData(Gadget(17, 305+8, (height+5)*7+10, 290, height, ""))
   ; *S_8 = GetGadgetData(Gadget(18, 305+8, (height+5)*8+10, 290, 90+150, Text, #__flag_gridlines|#__flag_numeric|#__text_multiline))
     *S_8 = GetGadgetData(Gadget(18, 305+8, (height+5)*8+10, 290, 90+30, Text, #__flag_gridlines|#__flag_numeric|#__text_multiline))
     *S_9 = GetGadgetData(Gadget(19, 305+8, (height+5)*9+10+60, 290, 90+30, Text, #__flag_gridlines|#__flag_numeric|#__text_wordwrap))
                               
    SetText(*S_6, "GaT")
    Debug "Get widget text "+GetText(*S_6)
    
    ;     BindEvent(#PB_Event_Widget, @Events())
    ;     PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -----------8----------------------0---------v4+-------------------ff----
; EnableXP