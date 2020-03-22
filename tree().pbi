; _module_tree_20.pb

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/Widget/widgets()"
  XIncludeFile "../fixme(mac).pbi"
CompilerEndIf


;-
;- XIncludeFile
;-
; CompilerIf Not Defined(macros, #PB_Module)
;   XIncludeFile "macros.pbi"
; CompilerEndIf
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

CompilerIf Not Defined(constants, #PB_Module)
  XIncludeFile "constants.pbi"
CompilerEndIf

CompilerIf Not Defined(structures, #PB_Module)
  XIncludeFile "structures.pbi"
CompilerEndIf

CompilerIf Not Defined(colors, #PB_Module)
  XIncludeFile "colors.pbi"
CompilerEndIf

CompilerIf Not Defined(Bar, #PB_Module)
  XIncludeFile "widgets.pbi"
CompilerEndIf


;- >>> 
DeclareModule Tree
  EnableExplicit
  CompilerIf Defined(fixme, #PB_Module)
    ;Macro PB(Function) : Function : EndMacro
    UseModule fixme
  CompilerEndIf
  UseModule Constants
  UseModule Structures
  

  
  Macro _get_colors_()
    colors::*this\blue
  EndMacro
  
  Macro Root()
    *event\root
  EndMacro
  
  Macro GetActive() ; Returns active window
    *event\active
  EndMacro
  
  Macro SetActive(_this_) ; Returns active window
    *event\active\gadget = _this_
  EndMacro
  
  Macro GetCanvas(_this_)
    _this_\root\canvas\gadget
  EndMacro
  
  Global *event._s_event = AllocateStructure(_s_event)
  
  *event\active = 0
  *event\widget = 0
  *event\data = 0
  *event\type =- 1
  *event\item =- 1
  
  
  Declare.l Tree_CountItems(*this)
  Declare   Tree_ClearItems(*this) 
  Declare   Tree_RemoveItem(*this, Item.l)
  
  Declare.l Tree_SetText(*this, Text.s)
  Declare.i Tree_SetFont(*this, Font.i)
  Declare.l Tree_SetState(*this, State.l)
  Declare.i Tree_SetItemFont(*this, Item.l, Font.i)
  Declare.l Tree_SetItemState(*this, Item.l, State.b)
  Declare.i Tree_SetItemImage(*this, Item.l, Image.i)
  Declare.i Tree_SetAttribute(*this, Attribute.i, Value.l)
  Declare.l Tree_SetItemText(*this, Item.l, Text.s, Column.l=0)
  Declare.l Tree_SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l=0)
  ;Declare.i Tree_SetItemAttribute(*this, Item.l, Attribute.i, Value.l, Column.l=0)
  
  Declare.s Tree_GetText(*this)
  Declare.i Tree_GetFont(*this)
  Declare.l Tree_GetState(*this)
  Declare.i Tree_GetItemFont(*this, Item.l)
  Declare.l Tree_GetItemState(*this, Item.l)
  Declare.i Tree_GetItemImage(*this, Item.l)
  Declare.i Tree_GetAttribute(*this, Attribute.i)
  Declare.s Tree_GetItemText(*this, Item.l, Column.l=0)
  Declare.i Tree_GetItemAttribute(*this, Item.l, Attribute.i, Column.l=0)
  Declare.l Tree_GetItemColor(*this, Item.l, ColorType.l, Column.l=0)
  
  Declare.i Tree_AddItem(*this, position.l, Text.s, Image.i=-1, sublevel.i=0)
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
  Declare.i Tree(X.l, Y.l, Width.l, Height.l, Flag.i=0, round.l=0)
  Declare.l Tree_CallBack(*this, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
  Declare   Free(*this)
  
  Declare.l Tree_Draw(*this)
  Declare.l Tree_ReDraw(*this, canvas_backcolor=#Null)
  Declare.l Tree_Resize(*this, X.l,Y.l,Width.l,Height.l)
  
  Declare.b Bind(*this, *callBack, eventtype.l=#PB_All)
  Declare.b Post(eventtype.l, *this, item.l=#PB_All, *data=0)
EndDeclareModule

Module Tree
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  ;-
  Macro _tree_box_(_x_,_y_, _width_, _height_, _checked_, _type_, _color_=$FFFFFFFF, _round_=2, _alpha_=255) 
    
    If _type_ = 1
      If _checked_
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        RoundBox(_x_,_y_,_width_,_height_, 4,4, $F67905&$FFFFFF|255<<24)
        RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $F67905&$FFFFFF|255<<24)
        RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $F67905&$FFFFFF|255<<24)
        
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        BackColor($FFB775&$FFFFFF|255<<24) 
        FrontColor($F67905&$FFFFFF|255<<24)
        
        LinearGradient(_x_,_y_, _x_, (_y_+_height_))
        RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
        RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
        RoundBox(_x_+1,_y_+1,_width_-2,_height_-2, 4,4)
      Else
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        RoundBox(_x_,_y_,_width_,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
        RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $7E7E7E&$FFFFFF|255<<24)
        RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
        
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        BackColor($FFFFFF&$FFFFFF|255<<24)
        FrontColor($EEEEEE&$FFFFFF|255<<24)
        
        LinearGradient(_x_,_y_, _x_, (_y_+_height_))
        RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
        RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
        RoundBox(_x_+1,_y_+1,_width_-2,_height_-2, 4,4)
      EndIf
    Else
      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
      
      If _checked_
        BackColor($FFB775&$FFFFFF|255<<24) 
        FrontColor($F67905&$FFFFFF|255<<24)
        
        LinearGradient(_x_,_y_, _x_, (_y_+_height_))
        RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(_x_,_y_,_width_,_height_, _round_,_round_, $F67905&$FFFFFF|255<<24)
        
        If _type_ = 1
          RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $F67905&$FFFFFF|255<<24)
          RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $F67905&$FFFFFF|255<<24)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
          RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
        EndIf
        
      Else
        BackColor($FFFFFF&$FFFFFF|255<<24)
        FrontColor($EEEEEE&$FFFFFF|255<<24)
        
        LinearGradient(_x_,_y_, _x_, (_y_+_height_))
        RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(_x_,_y_,_width_,_height_, _round_,_round_, $7E7E7E&$FFFFFF|255<<24)
        
        If _type_ = 1
          RoundBox(_x_,_y_+1,_width_,_height_-2, 4,4, $7E7E7E&$FFFFFF|255<<24)
          RoundBox(_x_+1,_y_,_width_-2,_height_, 4,4, $7E7E7E&$FFFFFF|255<<24)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox(_x_+3,_y_+1,_width_-6,_height_-2, 2,2)
          RoundBox(_x_+1,_y_+3,_width_-2,_height_-6, 2,2)
        EndIf
      EndIf
    EndIf
    
    If _checked_
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      
      If _type_ = 1
        RoundBox(_x_+(_width_-4)/2,_y_+(_height_-4)/2, 4,4, 4,4,_color_&$FFFFFF|_alpha_<<24) ; правая линия
                                                                                             ; RoundBox(_x_+(_width_-8)/2,_y_+(_height_-8)/2, 8,8, 4,4,_color_&$FFFFFF|_alpha_<<24) ; правая линия
      ElseIf _type_ = 3
        If _checked_ > 1
          Box(_x_+(_width_-4)/2,_y_+(_height_-4)/2, 4,4, _color_&$FFFFFF|_alpha_<<24) ; правая линия
        Else
          If _width_ = 15
            LineXY((_x_+4),(_y_+8),(_x_+5),(_y_+9),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
            LineXY((_x_+4),(_y_+9),(_x_+5),(_y_+10),_color_&$FFFFFF|_alpha_<<24); Левая линия
            
            LineXY((_x_+9),(_y_+4),(_x_+6),(_y_+10),_color_&$FFFFFF|_alpha_<<24) ; правая линия
            LineXY((_x_+10),(_y_+4),(_x_+7),(_y_+10),_color_&$FFFFFF|_alpha_<<24); правая линия
            
          Else
            LineXY((_x_+2),(_y_+6),(_x_+4),(_y_+7),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
            LineXY((_x_+2),(_y_+7),(_x_+4),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
            
            LineXY((_x_+8),(_y_+2),(_x_+5),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; правая линия
            LineXY((_x_+9),(_y_+2),(_x_+6),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; правая линия
          EndIf
        EndIf
      EndIf
    EndIf
    
  EndMacro
  
  Macro _tree_multi_select_(_this_,  _index_, _selected_index_)
    PushListPosition(_this_\row\_s()) 
    ForEach _this_\row\_s()
      If _this_\row\_s()\draw
        _this_\row\_s()\color\state =  Bool((_selected_index_ >= _this_\row\_s()\index And _index_ =< _this_\row\_s()\index) Or ; верх
                                              (_selected_index_ =< _this_\row\_s()\index And _index_ >= _this_\row\_s()\index)) * 2  ; вниз
      EndIf
    Next
    PopListPosition(_this_\row\_s()) 
    
    ;     PushListPosition(_this_\row\draws()) 
    ;     ForEach _this_\row\draws()
    ;       If _this_\row\draws()\draw
    ;         _this_\row\draws()\color\state =  Bool((_selected_index_ >= _this_\row\draws()\index And _index_ =< _this_\row\draws()\index) Or ; верх
    ;                                            (_selected_index_ =< _this_\row\draws()\index And _index_ >= _this_\row\draws()\index)) * 2  ; вниз
    ;       EndIf
    ;     Next
    ;     PopListPosition(_this_\row\draws()) 
  EndMacro
  
  Macro _tree_set_item_image_(_this_, _item_, _image_)
    _item_\image\change = IsImage(_image_)
    
    If _item_\image\change
      If _this_\flag\iconsize
        _item_\image\width = _this_\flag\iconsize
        _item_\image\height = _this_\flag\iconsize
        ResizeImage(_image_, _item_\image\width, _item_\image\height)
        
      Else
        _item_\image\width = ImageWidth(_image_)
        _item_\image\height = ImageHeight(_image_)
        
      EndIf  
      
      _item_\image\index = _image_ 
      _item_\image\handle = ImageID(_image_)
      _this_\row\sublevel = _this_\image\padding\left + _item_\image\width
    Else
      _item_\image\index =- 1
    EndIf
  EndMacro
  
  Procedure _tree_set_active_(*this._s_widget)
    Protected Result
    
    If *event\active <> *this
      If *event\active 
        *event\active\color\state = 0
        *event\active\root\mouse\buttons = 0
        
        If *event\active\row\selected 
          *event\active\row\selected\color\state = 3
        EndIf
        
        If *this\root\canvas\gadget <> *event\active\root\canvas\gadget 
          ; set lost focus canvas
          PostEvent(#PB_Event_Gadget, *event\active\root\window, *event\active\root\canvas\gadget, #__Event_Repaint);, *event\active)
        EndIf
        
        ;Result | Tree_Events(*event\active, #__Event_LostFocus, *event\active\root\mouse\x, *event\active\root\mouse\y)
      EndIf
      
      If *this\row\selected And *this\row\selected\color\state = 3
        *this\row\selected\color\state = 2
      EndIf
      
      *this\color\state = 2
      *event\active = *this
      ;Result | Tree_Events(*this, #__Event_Focus, mouse_x, mouse_y)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Macro _tree_set_state_(_this_, _items_, _state_)
    If _this_\flag\option_group And _items_\parent
      If _items_\option_group\option_group <> _items_
        If _items_\option_group\option_group
          _items_\option_group\option_group\box[1]\checked = 0
        EndIf
        _items_\option_group\option_group = _items_
      EndIf
      
      _items_\box[1]\checked ! Bool(_state_)
      
    Else
      If _this_\flag\threestate
        If _state_ & #__tree_Inbetween
          _items_\box[1]\checked = 2
        ElseIf _state_ & #__tree_Checked
          _items_\box[1]\checked = 1
        Else
          Select _items_\box[1]\checked 
            Case 0
              _items_\box[1]\checked = 2
            Case 1
              _items_\box[1]\checked = 0
            Case 2
              _items_\box[1]\checked = 1
          EndSelect
        EndIf
      Else
        _items_\box[1]\checked ! Bool(_state_)
      EndIf
    EndIf
  EndMacro
  
  Macro _tree_bar_update_(_this_, _pos_, _len_)
    Bool(Bool((_pos_-_this_\y-_this_\bar\page\pos) < 0 And bar_SetState(_this_, (_pos_-_this_\y))) Or
         Bool((_pos_-_this_\y-_this_\bar\page\pos) > (_this_\bar\page\len-_len_) And
              bar_SetState(_this_, (_pos_-_this_\y) - (_this_\bar\page\len-_len_)))) : _this_\change = 0
  EndMacro
  
  Macro _tree_repaint_(_this_)
    If _this_\countitems = 0 Or 
       (Not _this_\hide And _this_\row\count And 
        (_this_\countitems % _this_\row\count) = 0)
      
      _this_\change = 1
      _this_\row\count = _this_\countitems
      PostEvent(#PB_Event_Gadget, _this_\root\window, _this_\root\canvas\gadget, #__Event_Repaint, _this_)
    EndIf  
  EndMacro
  
  Macro _tree_make_scroll_height_(_this_)
    _this_\scroll\height + _this_\row\_s()\height + _this_\flag\gridLines
    
;     If _this_\scroll\v\scrollStep <> _this_\row\_s()\height + Bool(_this_\flag\gridLines)
;       _this_\scroll\v\scrollStep = _this_\row\_s()\height + Bool(_this_\flag\gridLines)
;     EndIf
  EndMacro
  
  Macro _tree_make_scroll_width_(_this_)
    If _this_\scroll\width < (_this_\row\_s()\text\x+_this_\row\_s()\text\width + _this_\flag\fullSelection + _this_\scroll\h\bar\page\pos)-_this_\x[2]
      _this_\scroll\width = (_this_\row\_s()\text\x+_this_\row\_s()\text\width + _this_\flag\fullSelection + _this_\scroll\h\bar\page\pos)-_this_\x[2]
    EndIf
  EndMacro
  
  
  
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
  
  Macro _bar_thumb_pos_(_bar_, _scroll_pos_)
    (_bar_\area\pos + Round((_scroll_pos_-_bar_\min) * _bar_\percent, #PB_Round_Nearest)) 
    ; (_bar_\area\pos + Round((_scroll_pos_-_bar_\min) * (_bar_\area\len / (_bar_\max-_bar_\min)), #PB_round_nearest)) 
  EndMacro
  
  Macro _bar_thumb_len_(_bar_)
    Round(_bar_\area\len - (_bar_\area\len / (_bar_\max-_bar_\min)) * ((_bar_\max-_bar_\min) - _bar_\page\len), #PB_Round_Nearest)
  EndMacro
  
  ; Then scroll bar start position
  Macro _bar_in_start_(_bar_) : Bool(_bar_\page\pos =< _bar_\min) : EndMacro
  
  ; Then scroll bar end position
  Macro _bar_in_stop_(_bar_) : Bool(_bar_\page\pos >= (_bar_\max-_bar_\page\len)) : EndMacro
  
  ; Inverted scroll bar position
  Macro _bar_invert_(_bar_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_bar_\min + (_bar_\max - _bar_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  ;   Macro _bar_scrolled_(_this_, _pos_, _len_)
  ;     bar::_scrolled_(_this_, _pos_, _len_)
  ;   EndMacro
  
  ;   Macro _bar_area_pos_(_this_)
  ;     bar::_area_pos_(_this_)
  ;   EndMacro
  
  ;   Macro _bar_ThumbPos(_this_, _scroll_pos_)
  ;     bar::ThumbPos(_this_, _scroll_pos_)
  ;   EndMacro
  ;   
  ;   Procedure.i Bar_Change(*bar.structures::_s_bar, ScrollPos.f)
  ;     ProcedureReturn bar::Change(*bar, ScrollPos)
  ;   EndProcedure
  ;   
  ;   Procedure.b Bar_Update(*this._s_widget)
  ;     ProcedureReturn bar::update(*this)
  ;   EndProcedure
  ;   
  ;   Procedure.i Bar_SetPos(*this._s_widget, ThumbPos.i)
  ;     ProcedureReturn bar::setpos(*this, ThumbPos)
  ;   EndProcedure
  ;   
  ;   Procedure.b Bar_SetState(*this._s_widget, ScrollPos.f)
  ;     ProcedureReturn bar::setstate(*this, ScrollPos)
  ;   EndProcedure
  ;   
  ;   Procedure.l Bar_SetAttribute(*this._s_widget, Attribute.l, Value.l)
  ;     ProcedureReturn bar::setattribute(*this, Attribute, Value)
  ;   EndProcedure
  ;   
  ;   Procedure.b Bar_Resizes(*scroll.structures::_s_scroll, X.l,Y.l,Width.l,Height.l )
  ;      bar::resizes(*scroll, X,Y,Width,Height) 
  ;     Resize(*scroll\v, *scroll\v\parent\width[2]-16, y, #PB_Ignore, Height)
  ;     Resize(*scroll\h, x, *scroll\h\parent\height[2]-16, Width, #PB_Ignore)
  ;     
  ;   EndProcedure
  ;   
  ;   Procedure.i bar_create(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scroll_step.f=1.0)
  ;     ProcedureReturn bar::create(type, size, min, max, pagelength, flag, round, parent, scroll_step)
  ;   EndProcedure
  
  Macro _bar_scrolled_(_this_, _pos_, _len_)
    Bool(Bool(((_pos_)-_this_\bar\page\pos) < 0 And Bar_SetState(_this_, (_pos_))) Or
         Bool(((_pos_)-_this_\bar\page\pos) > (_this_\bar\page\len-(_len_)) And Bar_SetState(_this_, (_pos_)-(_this_\bar\page\len-(_len_)))))
  EndMacro
  
  Macro _bar_area_pos_(_this_)
    If _this_\bar\vertical
      _this_\bar\area\pos = _this_\y + _this_\bar\button[#__b_1]\len
      _this_\bar\area\len = _this_\height - (_this_\bar\button[#__b_1]\len + _this_\bar\button[#__b_2]\len)
    Else
      _this_\bar\area\len = _this_\width - (_this_\bar\button[#__b_1]\len + _this_\bar\button[#__b_2]\len)
      _this_\bar\area\pos = _this_\x + _this_\bar\button[#__b_1]\len
    EndIf
    
    _this_\bar\area\end = _this_\bar\area\pos + (_this_\bar\area\len - _this_\bar\thumb\len)
    _this_\bar\percent = (_this_\bar\area\len / (_this_\bar\max - _this_\bar\min))
  EndMacro
  
  Macro _bar_ThumbPos(_this_, _scroll_pos_)
    _bar_thumb_pos_(_this_\bar, _scroll_pos_)
    
    If _this_\bar\thumb\pos < _this_\bar\area\pos 
      _this_\bar\thumb\pos = _this_\bar\area\pos 
    EndIf 
    
    If _this_\bar\thumb\pos > _this_\bar\area\end
      _this_\bar\thumb\pos = _this_\bar\area\end
    EndIf
    
    If _this_\type=#__Type_Spin
      If _this_\bar\vertical 
        _this_\bar\button\x = _this_\X + _this_\width - #__spin_buttonsize2
        _this_\bar\button\width = #__spin_buttonsize2
      Else 
        _this_\bar\button\y = _this_\Y + _this_\Height - #__spin_buttonsize2
        _this_\bar\button\height = #__spin_buttonsize2 
      EndIf
    Else
      If _this_\bar\vertical 
        _this_\bar\button\x = _this_\X + Bool(_this_\type=#__Type_ScrollBar) 
        _this_\bar\button\width = _this_\width - Bool(_this_\type=#__Type_ScrollBar) 
        _this_\bar\button\y = _this_\bar\area\pos
        _this_\bar\button\height = _this_\bar\area\len               
      Else 
        _this_\bar\button\y = _this_\Y + Bool(_this_\type=#__Type_ScrollBar) 
        _this_\bar\button\height = _this_\Height - Bool(_this_\type=#__Type_ScrollBar)  
        _this_\bar\button\x = _this_\bar\area\pos
        _this_\bar\button\width = _this_\bar\area\len
      EndIf
    EndIf
    
    ; _start_
    If _this_\bar\button[#__b_1]\len 
      If _scroll_pos_ = _this_\bar\min
        _this_\bar\button[#__b_1]\color\state = #__s_3
        _this_\bar\button[#__b_1]\interact = 0
      Else
        If _this_\bar\button[#__b_1]\color\state <> #__s_2
          _this_\bar\button[#__b_1]\color\state = #__s_0
        EndIf
        _this_\bar\button[#__b_1]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type=#__Type_ScrollBar Or 
       _this_\type=#__Type_Spin
      
      If _this_\bar\vertical 
        ; Top button coordinate on vertical scroll bar
        _this_\bar\button[#__b_1]\x = _this_\bar\button\x
        _this_\bar\button[#__b_1]\y = _this_\Y 
        _this_\bar\button[#__b_1]\width = _this_\bar\button\width
        _this_\bar\button[#__b_1]\height = _this_\bar\button[#__b_1]\len                   
      Else 
        ; Left button coordinate on horizontal scroll bar
        _this_\bar\button[#__b_1]\x = _this_\X 
        _this_\bar\button[#__b_1]\y = _this_\bar\button\y
        _this_\bar\button[#__b_1]\width = _this_\bar\button[#__b_1]\len 
        _this_\bar\button[#__b_1]\height = _this_\bar\button\height 
      EndIf
      
    ElseIf _this_\type = #__Type_TrackBar
    Else
      _this_\bar\button[#__b_1]\x = _this_\X
      _this_\bar\button[#__b_1]\y = _this_\Y
      
      If _this_\bar\vertical
        _this_\bar\button[#__b_1]\width = _this_\width
        _this_\bar\button[#__b_1]\height = _this_\bar\thumb\pos-_this_\y 
      Else
        _this_\bar\button[#__b_1]\width = _this_\bar\thumb\pos-_this_\x 
        _this_\bar\button[#__b_1]\height = _this_\height
      EndIf
    EndIf
    
    ; _stop_
    If _this_\bar\button[#__b_2]\len
      ; Debug ""+ Bool(_this_\bar\thumb\pos = _this_\bar\area\end) +" "+ Bool(_scroll_pos_ = _this_\bar\page\end)
      If _scroll_pos_ = _this_\bar\page\end
        _this_\bar\button[#__b_2]\color\state = #__s_3
        _this_\bar\button[#__b_2]\interact = 0
      Else
        If _this_\bar\button[#__b_2]\color\state <> #__s_2
          _this_\bar\button[#__b_2]\color\state = #__s_0
        EndIf
        _this_\bar\button[#__b_2]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type = #__Type_ScrollBar Or 
       _this_\type = #__Type_Spin
      If _this_\bar\vertical 
        ; Botom button coordinate on vertical scroll bar
        _this_\bar\button[#__b_2]\x = _this_\bar\button\x
        _this_\bar\button[#__b_2]\width = _this_\bar\button\width
        _this_\bar\button[#__b_2]\height = _this_\bar\button[#__b_2]\len 
        _this_\bar\button[#__b_2]\y = _this_\Y+_this_\Height-_this_\bar\button[#__b_2]\height
      Else 
        ; Right button coordinate on horizontal scroll bar
        _this_\bar\button[#__b_2]\y = _this_\bar\button\y
        _this_\bar\button[#__b_2]\height = _this_\bar\button\height
        _this_\bar\button[#__b_2]\width = _this_\bar\button[#__b_2]\len 
        _this_\bar\button[#__b_2]\x = _this_\X+_this_\width-_this_\bar\button[#__b_2]\width 
      EndIf
      
    ElseIf _this_\type = #__Type_TrackBar
    Else
      If _this_\bar\vertical
        _this_\bar\button[#__b_2]\x = _this_\x
        _this_\bar\button[#__b_2]\y = _this_\bar\thumb\pos+_this_\bar\thumb\len
        _this_\bar\button[#__b_2]\width = _this_\width
        _this_\bar\button[#__b_2]\height = _this_\height-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\y)
      Else
        _this_\bar\button[#__b_2]\x = _this_\bar\thumb\pos+_this_\bar\thumb\len
        _this_\bar\button[#__b_2]\y = _this_\Y
        _this_\bar\button[#__b_2]\width = _this_\width-(_this_\bar\thumb\pos+_this_\bar\thumb\len-_this_\x)
        _this_\bar\button[#__b_2]\height = _this_\height
      EndIf
    EndIf
    
    ; Thumb coordinate on scroll bar
    If _this_\bar\thumb\len
      ;       If _this_\bar\button[#__b_3]\len <> _this_\bar\thumb\len
      ;         _this_\bar\button[#__b_3]\len = _this_\bar\thumb\len
      ;       EndIf
      
      If _this_\bar\vertical
        _this_\bar\button[#__b_3]\x = _this_\bar\button\x 
        _this_\bar\button[#__b_3]\width = _this_\bar\button\width 
        _this_\bar\button[#__b_3]\y = _this_\bar\thumb\pos
        _this_\bar\button[#__b_3]\height = _this_\bar\thumb\len                              
      Else
        _this_\bar\button[#__b_3]\y = _this_\bar\button\y 
        _this_\bar\button[#__b_3]\height = _this_\bar\button\height
        _this_\bar\button[#__b_3]\x = _this_\bar\thumb\pos 
        _this_\bar\button[#__b_3]\width = _this_\bar\thumb\len                                  
      EndIf
      
    Else
      If _this_\type = #__Type_Spin Or 
         _this_\type = #__Type_ScrollBar
        ; ????? ???? ???????
        If _this_\bar\vertical
          _this_\bar\button[#__b_2]\Height = _this_\Height/2 
          _this_\bar\button[#__b_2]\y = _this_\y+_this_\bar\button[#__b_2]\Height+Bool(_this_\Height%2) 
          
          _this_\bar\button[#__b_1]\y = _this_\y 
          _this_\bar\button[#__b_1]\Height = _this_\Height/2
          
        Else
          _this_\bar\button[#__b_2]\width = _this_\width/2 
          _this_\bar\button[#__b_2]\x = _this_\x+_this_\bar\button[#__b_2]\width+Bool(_this_\width%2) 
          
          _this_\bar\button[#__b_1]\x = _this_\x 
          _this_\bar\button[#__b_1]\width = _this_\width/2
        EndIf
      EndIf
    EndIf
    
    If _this_\type = #__Type_Spin
      If _this_\bar\vertical      
        ; Top button coordinate
        _this_\bar\button[#__b_2]\y = _this_\y+_this_\height/2 + Bool(_this_\height%2) 
        _this_\bar\button[#__b_2]\height = _this_\height/2 
        _this_\bar\button[#__b_2]\width = _this_\bar\button\len 
        _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button\len
        
        ; Bottom button coordinate
        _this_\bar\button[#__b_1]\y = _this_\y 
        _this_\bar\button[#__b_1]\height = _this_\height/2 
        _this_\bar\button[#__b_1]\width = _this_\bar\button\len 
        _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button\len                                 
      Else    
        ; Left button coordinate
        _this_\bar\button[#__b_1]\y = _this_\y 
        _this_\bar\button[#__b_1]\height = _this_\height 
        _this_\bar\button[#__b_1]\width = _this_\bar\button\len/2 
        _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button\len    
        
        ; Right button coordinate
        _this_\bar\button[#__b_2]\y = _this_\y 
        _this_\bar\button[#__b_2]\height = _this_\height 
        _this_\bar\button[#__b_2]\width = _this_\bar\button\len/2 
        _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button\len/2                               
      EndIf
    EndIf
    
    ; draw track bar coordinate
    If _this_\type = #__Type_TrackBar
      If _this_\bar\vertical
        _this_\bar\button[#__b_1]\width = 4
        _this_\bar\button[#__b_2]\width = 4
        _this_\bar\button[#__b_3]\width = _this_\bar\button[#__b_3]\len+(Bool(_this_\bar\button[#__b_3]\len<10)*_this_\bar\button[#__b_3]\len)
        
        _this_\bar\button[#__b_1]\y = _this_\Y
        _this_\bar\button[#__b_1]\height = _this_\bar\thumb\pos-_this_\y + _this_\bar\thumb\len/2
        
        _this_\bar\button[#__b_2]\y = _this_\bar\thumb\pos+_this_\bar\thumb\len/2
        _this_\bar\button[#__b_2]\height = _this_\height-(_this_\bar\thumb\pos+_this_\bar\thumb\len/2-_this_\y)
        
        If _this_\bar\inverted
          _this_\bar\button[#__b_1]\x = _this_\x+6
          _this_\bar\button[#__b_2]\x = _this_\x+6
          _this_\bar\button[#__b_3]\x = _this_\bar\button[#__b_1]\x-_this_\bar\button[#__b_3]\width/4-1- Bool(_this_\bar\button[#__b_3]\len>10)
        Else
          _this_\bar\button[#__b_1]\x = _this_\x+_this_\width-_this_\bar\button[#__b_1]\width-6
          _this_\bar\button[#__b_2]\x = _this_\x+_this_\width-_this_\bar\button[#__b_2]\width-6 
          _this_\bar\button[#__b_3]\x = _this_\bar\button[#__b_1]\x-_this_\bar\button[#__b_3]\width/2 + Bool(_this_\bar\button[#__b_3]\len>10)
        EndIf
      Else
        _this_\bar\button[#__b_1]\height = 4
        _this_\bar\button[#__b_2]\height = 4
        _this_\bar\button[#__b_3]\height = _this_\bar\button[#__b_3]\len+(Bool(_this_\bar\button[#__b_3]\len<10)*_this_\bar\button[#__b_3]\len)
        
        _this_\bar\button[#__b_1]\x = _this_\X
        _this_\bar\button[#__b_1]\width = _this_\bar\thumb\pos-_this_\x + _this_\bar\thumb\len/2
        
        _this_\bar\button[#__b_2]\x = _this_\bar\thumb\pos+_this_\bar\thumb\len/2
        _this_\bar\button[#__b_2]\width = _this_\width-(_this_\bar\thumb\pos+_this_\bar\thumb\len/2-_this_\x)
        
        If _this_\bar\inverted
          _this_\bar\button[#__b_1]\y = _this_\y+_this_\height-_this_\bar\button[#__b_1]\height-6
          _this_\bar\button[#__b_2]\y = _this_\y+_this_\height-_this_\bar\button[#__b_2]\height-6 
          _this_\bar\button[#__b_3]\y = _this_\bar\button[#__b_1]\y-_this_\bar\button[#__b_3]\height/2 + Bool(_this_\bar\button[#__b_3]\len>10)
        Else
          _this_\bar\button[#__b_1]\y = _this_\y+6
          _this_\bar\button[#__b_2]\y = _this_\y+6
          _this_\bar\button[#__b_3]\y = _this_\bar\button[#__b_1]\y-_this_\bar\button[#__b_3]\height/4-1- Bool(_this_\bar\button[#__b_3]\len>10)
        EndIf
      EndIf
    EndIf
    
    ;     If _this_\Scroll And _this_\Scroll\v And _this_\Scroll\h
    ;       _this_\Scroll\x = _this_\Scroll\h\x-_this_\Scroll\h\bar\page\pos
    ;       _this_\Scroll\y = _this_\Scroll\v\y-_this_\Scroll\v\bar\page\pos
    ;       _this_\Scroll\width = _this_\Scroll\h\bar\max
    ;       _this_\Scroll\height = _this_\Scroll\v\bar\max
    ;     EndIf
    
    If _this_\Splitter 
      ; Splitter childrens auto resize       
      _bar_splitter_size_(_this_)
    EndIf
    
    If _this_\bar\page\change
      If _this_\text
        _this_\text\change = 1
        _this_\text\string = "%"+Str(_this_\bar\page\Pos)
        
      EndIf
      
      
      ; ScrollArea childrens auto resize 
      If _this_\parent\scroll And 
         _this_\parent\scroll\v And 
         _this_\parent\scroll\h
        _this_\parent\change =- 1
        
        If _this_\bar\vertical
          _this_\parent\scroll\y =- _this_\bar\page\pos ; _this_\y 
                                                         ;_this_\parent\scroll\height = _this_\bar\max
          _childrens_move_(_this_\parent, 0, _this_\bar\page\change)
        Else
          _this_\parent\scroll\x =- _this_\bar\page\pos ; _this_\x 
                                                         ;_this_\parent\scroll\width = _this_\bar\max
          _childrens_move_(_this_\parent, _this_\bar\page\change, 0)
        EndIf
      EndIf
      
    EndIf
    
  EndMacro
  
  ;   Procedure.i Bar_Change(*this._s_widget, ScrollPos.f)
  ;     Protected *bar._s_bar
  ;     
  ;     If *this\type = #__Type_Panel
  ;       *bar = *this\tab\bar
  ;     Else
  ;       *bar = *this\bar
  ;     EndIf
  
  Procedure.i Bar_Change(*bar.structures::_s_bar, ScrollPos.f)
    With *bar
      If ScrollPos < \min : ScrollPos = \min : EndIf
      
      If \max And ScrollPos > \max-\page\len
        If \max > \page\len 
          ScrollPos = \max-\page\len
        Else
          ScrollPos = \min 
        EndIf
      EndIf
      
      If \page\pos <> ScrollPos
        \page\change = \page\pos - ScrollPos
        
        If \page\pos > ScrollPos
          \direction =- ScrollPos
          
          If ScrollPos = \min Or \mode = #__bar_ticks 
            \button[#__b_3]\arrow\direction = Bool(Not \vertical) + Bool(\vertical = \inverted) * 2
          Else
            \button[#__b_3]\arrow\direction = Bool(\vertical) + Bool(\inverted) * 2
          EndIf
        Else
          \direction = ScrollPos
          
          If ScrollPos = \page\end Or \mode = #__bar_ticks
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
  
  Procedure.b Bar_Update(*this._s_widget)
    With *this
      If (\bar\max-\bar\min) >= \bar\page\len
        ; Get area screen coordinate 
        ; pos (x&y) And Len (width&height)
        _bar_area_pos_(*this)
        
        ;
        If Not \bar\max And \width And \height And (\splitter Or \bar\page\pos) 
          \bar\max = \bar\area\len-\bar\button[#__b_3]\len
          
          If Not \bar\page\pos
            \bar\page\pos = (\bar\max)/2 - Bool(  (\splitter And \bar\fixed=#__b_1))
          EndIf
          
          ;           ; if splitter fixed set splitter pos to center
          ;           If \splitter And \bar\fixed = #__b_1
          ;             \bar\fixed[\bar\fixed] = \bar\page\pos
          ;           EndIf
          ;           If \splitter And \bar\fixed = #__b_2
          ;             \bar\fixed[\bar\fixed] = \bar\area\len-\bar\page\pos-\bar\button[#__b_3]\len  + 1
          ;           EndIf
        EndIf
        
        If \splitter 
          If \bar\fixed
            If \bar\area\len - \bar\button[#__b_3]\len > \bar\fixed[\bar\fixed] 
              \bar\page\pos = Bool(\bar\fixed = 2) * \bar\max
              
              If \bar\fixed[\bar\fixed] > \bar\button[#__b_3]\len
                \bar\area\pos + \bar\fixed[1]
                \bar\area\len - \bar\fixed[2]
              EndIf
            Else
              \bar\fixed[\bar\fixed] = \bar\area\len - \bar\button[#__b_3]\len
              \bar\page\pos = Bool(\bar\fixed = 1) * \bar\max
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
          \bar\thumb\len = _bar_thumb_len_(\bar)
          
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
          \bar\percent = (\bar\area\len / (\bar\max - \bar\min))
          \bar\thumb\pos = _bar_ThumbPos(*this, _bar_invert_(*this\bar, \bar\page\pos, \bar\inverted))
          
          If #__Type_ScrollBar = \type And \bar\thumb\pos = \bar\area\end And \bar\page\pos <> \bar\page\end And _bar_in_stop_(\bar)
            ;    Debug " line-" + #PB_compiler_line +" "+  \bar\max 
            ;             If \bar\inverted
            ;              SetState(*this, _bar_invert_(*this\bar, \bar\max, \bar\inverted))
            ;             Else
            SetState(*this, \bar\page\end)
            ;             EndIf
          EndIf
        EndIf
      EndIf
      
      If \type = #__Type_ScrollBar
        \bar\hide = Bool(Not ((\bar\max-\bar\min) > \bar\page\len))
      EndIf
      
      ProcedureReturn \bar\hide
    EndWith
  EndProcedure
  
  Procedure.i Bar_SetPos(*this._s_widget, ThumbPos.i)
    Protected ScrollPos.f, result.i
    
    With *this
      If \splitter And \bar\fixed
        _bar_area_pos_(*this)
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
        
        Result = SetState(*this, _bar_invert_(*this\bar, ScrollPos, \bar\inverted))
      EndIf
    EndWith
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.b Bar_SetState(*this._s_widget, ScrollPos.f)
    Protected Result.b
    
    With *this
      If Bar_Change(*this\bar, ScrollPos)
        \bar\thumb\pos = _bar_ThumbPos(*this, _bar_invert_(*this\bar, \bar\page\pos, \bar\inverted))
        
        If \splitter And \bar\fixed = #__b_1
          \bar\fixed[\bar\fixed] = \bar\thumb\pos - \bar\area\pos
          \bar\page\pos = 0
        EndIf
        If \splitter And \bar\fixed = #__b_2
          \bar\fixed[\bar\fixed] = \bar\area\len - ((\bar\thumb\pos+\bar\thumb\len)-\bar\area\pos)
          \bar\page\pos = \bar\max
        EndIf
        
        \bar\page\change = #False
        \change = #True
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Bar_SetAttribute(*this._s_widget, Attribute.l, Value.l)
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
            \bar\increment = Value
            
          Case #__bar_buttonSize
            If \bar\button[#__b_3]\len <> Value
              \bar\button[#__b_3]\len = Value
              
              If \type = #__Type_ScrollBar
                \bar\button[#__b_1]\len = Value
                \bar\button[#__b_2]\len = Value
              EndIf
              Result = #True
            EndIf
            
          Case #__bar_inverted
            If \bar\inverted <> Bool(Value)
              \bar\inverted = Bool(Value)
              \bar\thumb\pos = _bar_ThumbPos(*this, _bar_invert_(*this\bar, \bar\page\pos, \bar\inverted))
              ;  \bar\thumb\pos = _bar_ThumbPos(*this, \bar\page\pos)
              ;  Result = 1
            EndIf
            
        EndSelect
      EndIf
      
      If Result ; And \width And \height ; ???? ???????? ? imagegadget ? scrollareagadget
        \hide = Bar_update(*this)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b Bar_Resizes(*scroll.structures::_s_scroll, X.l,Y.l,Width.l,Height.l )
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
      
      If \v\bar\page\len<>iHeight : Bar_SetAttribute(\v, #__bar_pageLength, iHeight) : EndIf
      If \h\bar\page\len<>iWidth : Bar_SetAttribute(\h, #__bar_pageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\bar\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\bar\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\bar\page\len<>iHeight : Bar_SetAttribute(\v, #__bar_pageLength, iHeight) : EndIf
      If \h\bar\page\len<>iWidth : Bar_SetAttribute(\h, #__bar_pageLength, iWidth) : EndIf
      
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
  
  Procedure.i Bar_Create(type.l, size.l, min.l, max.l, pagelength.l, flag.i=0, round.l=7, parent.i=0, scroll_step.f=1.0)
    Protected *this._s_widget = AllocateStructure(_s_widget)
    
    With *this
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
      \bar\mode = Bool(Flag&#__bar_ticks=#__bar_ticks)*#__bar_ticks
      \bar\vertical = Bool(Flag&#__flag_vertical=#__flag_vertical)
      \bar\inverted = Bool(Flag&#__bar_inverted=#__bar_inverted)
      \bar\increment = scroll_step
      
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
      
      If Not Bool(Flag&#__bar_buttonSize)
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
      
      If Type = #__Type_ScrollBar
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
      If Type = #__Type_ProgressBar
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
      If Type = #__Type_TrackBar
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
        
        \bar\mode = Bool(flag&#__bar_ticks) * #__bar_ticks
      EndIf
      
      If Type = #__Type_Spin
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
      
      If \bar\min <> Min : Bar_SetAttribute(*this, #__bar_minimum, Min) : EndIf
      If \bar\max <> Max : Bar_SetAttribute(*this, #__bar_maximum, Max) : EndIf
      If \bar\page\len <> Pagelength : Bar_SetAttribute(*this, #__bar_pageLength, Pagelength) : EndIf
      If Bool(Flag&#__bar_inverted=#__bar_inverted) : Bar_SetAttribute(*this, #__bar_inverted, #True) : EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  ;- PROCEDUREs
  ;-
  Declare Tree_Events(*this, eventtype.l, mouse_x.l=-1, mouse_y.l=-1, position.l=0)
  
  Procedure Tree_Selection(X, Y, SourceColor, TargetColor)
    Protected Color, Dot.b=4, line.b = 10, Length.b = (Line+Dot*2+1)
    Static Len.b
    
    If ((Len%Length)<line Or (Len%Length)=(line+Dot))
      If (Len>(Line+Dot)) : Len=0 : EndIf
      Color = SourceColor
    Else
      Color = TargetColor
    EndIf
    
    Len+1
    ProcedureReturn Color
  EndProcedure
  
  Procedure Tree_PlotX(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If x%2
      Color = SourceColor
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure Tree_PlotY(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If y%2
      Color = SourceColor
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  ;- DRAWs
  Procedure.l Tree_Draw(*this._s_widget)
    Protected Y, state.b
    
    Macro _tree_lines_(_this_, _items_)
      ; vertical lines for tree widget
      If _items_\parent 
        
        If _items_\draw
          If _items_\parent\last
            _items_\parent\last\l\v\height = 0
            
            _items_\parent\last\first = 0
          EndIf
          
          _items_\first = _items_\parent
          _items_\parent\last = _items_
        Else
          
          If _items_\parent\last
            _items_\parent\last\l\v\height = (_this_\y[2] + _this_\height[2]) -  _items_\parent\last\l\v\y 
          EndIf
          
        EndIf
        
      Else
        If _items_\draw
          If _this_\row\first\last And
             _this_\row\first\sublevel = _this_\row\first\last\sublevel
            If _this_\row\first\last\first
              _this_\row\first\last\l\v\height = 0
              
              _this_\row\first\last\first = 0
            EndIf
          EndIf
          
          _items_\first = _this_\row\first
          _this_\row\first\last = _items_
          
        Else
          If _this_\row\first\last And
             _this_\row\first\sublevel = _this_\row\first\last\sublevel
            
            _this_\row\first\last\l\v\height = (_this_\y[2] + _this_\height[2]) -  _this_\row\first\last\l\v\y
            ;Debug _items_\text\string
          EndIf
        EndIf
      EndIf
      
      _items_\l\h\y = _items_\box[0]\y+_items_\box[0]\height/2
      _items_\l\v\x = _items_\box[0]\x+_items_\box[0]\width/2
      
      If (_this_\x[2]-_items_\l\v\x) < _this_\flag\lines
        If _items_\l\v\x<_this_\x[2]
          _items_\l\h\width =  (_this_\flag\lines - (_this_\x[2]-_items_\l\v\x))
        Else
          _items_\l\h\width = _this_\flag\lines
        EndIf
        
        If _items_\draw And _items_\l\h\y > _this_\y[2] And _items_\l\h\y < _this_\y[2]+_this_\height[2]
          _items_\l\h\x = _items_\l\v\x + (_this_\flag\lines-_items_\l\h\width)
          _items_\l\h\height = 1
        Else
          _items_\l\h\height = 0
        EndIf
        
        ; Vertical plot
        If _items_\first And _this_\x[2]<_items_\l\v\x
          _items_\l\v\y = (_items_\first\y+_items_\first\height- Bool(_items_\first\sublevel = _items_\sublevel) * _items_\first\height/2) - _this_\scroll\v\bar\page\pos
          If _items_\l\v\y < _this_\y[2] : _items_\l\v\y = _this_\y[2] : EndIf
          
          _items_\l\v\height = (_items_\y+_items_\height/2)-_items_\l\v\y - _this_\scroll\v\bar\page\pos
          If _items_\l\v\height < 0 : _items_\l\v\height = 0 : EndIf
          If _items_\l\v\y + _items_\l\v\height > _this_\y[2]+_this_\height[2] 
            If _items_\l\v\y > _this_\y[2]+_this_\height[2] 
              _items_\l\v\height = 0
            Else
              _items_\l\v\height = (_this_\y[2] + _this_\height[2]) -  _items_\l\v\y 
            EndIf
          EndIf
          
          If _items_\l\v\height
            _items_\l\v\width = 1
          Else
            _items_\l\v\width = 0
          EndIf
        EndIf 
        
      EndIf
    EndMacro
    
    Macro _update_(_this_, _items_)
      If _this_\change <> 0
        _this_\scroll\width = 0
        _this_\scroll\height = 0
      EndIf
      
      If (_this_\change Or _this_\scroll\v\change Or _this_\scroll\h\change)
        ClearList(_this_\row\draws())
      EndIf
      
      PushListPosition(_items_)
      ForEach _items_
        ; 
        If _items_\text\fontID
          If _items_\fontID <> _items_\text\fontID
            _items_\fontID = _items_\text\fontID
            
            DrawingFont(_items_\fontID) 
            _items_\text\height = TextHeight("A") 
            ; Debug  " - "+_items_\text\height +" "+ _items_\text\string
          EndIf
        ElseIf _this_\text\fontID  
          If _items_\fontID <> _this_\text\fontID
            _items_\fontID = _this_\text\fontID
            
            DrawingFont(_items_\fontID) 
            _items_\text\height = _this_\text\height
            ; Debug  " - "+_items_\text\height +" "+ _items_\text\string
          EndIf
        EndIf
        
        
        ; Получаем один раз после изменения текста  
        If _items_\text\change
          _items_\text\width = TextWidth(_items_\text\string.s) 
          _items_\text\change = #False
        EndIf 
        
        If _items_\hide
          _items_\draw = 0
        Else
          If _this_\change
            _items_\x = _this_\x[2]
            _items_\height = _items_\text\height + 2 ;
            _items_\y = _this_\y[2] + _this_\scroll\height
            
            _items_\width = _this_\width[2] ; ???
          EndIf
          
          If (_this_\change Or _this_\scroll\v\change Or _this_\scroll\h\change)
            ; check box
            If _this_\flag\checkBoxes Or _this_\flag\option_group
              _items_\box[1]\x = _items_\x + 3 - _this_\scroll\h\bar\page\pos
              _items_\box[1]\y = (_items_\y+_items_\height)-(_items_\height+_items_\box[1]\height)/2-_this_\scroll\v\bar\page\pos
            EndIf
            
            ; expanded & collapsed box
            If _this_\flag\buttons Or _this_\flag\lines 
              _items_\box[0]\x = _items_\x + _items_\sublevellen - _this_\row\sublevellen + Bool(_this_\flag\buttons) * 4 + Bool(Not _this_\flag\buttons And _this_\flag\lines) * 8 - _this_\scroll\h\bar\page\pos 
              _items_\box[0]\y = (_items_\y+_items_\height)-(_items_\height+_items_\box[0]\height)/2-_this_\scroll\v\bar\page\pos
            EndIf
            
            ;
            _items_\image\x = _items_\x + _this_\image\padding\left + _items_\sublevellen - _this_\scroll\h\bar\page\pos
            _items_\image\y = _items_\y + (_items_\height-_items_\image\height)/2-_this_\scroll\v\bar\page\pos
            
            _items_\text\x = _items_\x + _this_\text\padding\left + _items_\sublevellen + _this_\row\sublevel - _this_\scroll\h\bar\page\pos
            _items_\text\y = _items_\y + (_items_\height-_items_\text\height)/2-_this_\scroll\v\bar\page\pos
            
            _items_\draw = Bool(_items_\y+_items_\height-_this_\scroll\v\bar\page\pos>_this_\y[2] And 
                                (_items_\y-_this_\y[2])-_this_\scroll\v\bar\page\pos<_this_\height[2])
            
            ; lines for tree widget
            If _this_\flag\lines And _this_\row\sublevellen
              _tree_lines_(_this_, _items_)
            EndIf
            
            If _items_\draw And 
               AddElement(_this_\row\draws())
              _this_\row\draws() = _items_
            EndIf
          EndIf
          
          If _this_\change <> 0
            ; _this_\scroll\height + _items_\height + _this_\flag\GridLines
            _tree_make_scroll_height_(_this_)
            _tree_make_scroll_width_(_this_)
            
;             If _this_\scroll\width < ((_items_\text\x + _items_\text\width + _this_\scroll\h\bar\page\pos) - _this_\x[2])
;               _this_\scroll\width = ((_items_\text\x + _items_\text\width + _this_\scroll\h\bar\page\pos) - _this_\x[2])
;             EndIf
            
          EndIf
        EndIf
      Next
      PopListPosition(_items_)
      
      ; 
      If _this_\change <> 0
        _this_\scroll\height-Bool(_this_\flag\gridlines)
      EndIf
      
      If _this_\scroll\v\bar\page\len And _this_\scroll\v\bar\max<>_this_\scroll\height And
         bar_SetAttribute(_this_\scroll\v, #__bar_Maximum, _this_\scroll\height)
        
        Bar_Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      ; Debug ""+_this_\scroll\v\bar\max +" "+ _this_\scroll\height +" "+ _this_\scroll\v\bar\page\pos +" "+ _this_\scroll\v\bar\page\len
      
      If _this_\scroll\h\bar\page\len And _this_\scroll\h\bar\max<>_this_\scroll\width And
         bar_SetAttribute(_this_\scroll\h, #__bar_Maximum, _this_\scroll\width)
        
        Bar_Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If _this_\change <> 0
        _this_\width[2] = (_this_\scroll\v\x + Bool(_this_\scroll\v\hide) * _this_\scroll\v\width) - _this_\x[2]
        _this_\height[2] = (_this_\scroll\h\y + Bool(_this_\scroll\h\hide) * _this_\scroll\h\height) - _this_\y[2]
        
        If _this_\row\selected And _this_\row\scrolled
          bar_SetState(_this_\scroll\v, ((_this_\row\selected\y-_this_\scroll\v\y) - (Bool(_this_\row\scrolled>0) * (_this_\scroll\v\bar\page\len-_this_\row\selected\height))) ) 
          _this_\scroll\v\change = 0 
          _this_\row\scrolled = 0
          
          Tree_Draw(_this_)
        EndIf
      EndIf
      
    EndMacro
    
    Macro _draws_(_this_, _items_)
      
      PushListPosition(_items_)
      ForEach _items_
        If _items_\draw
          If _items_\width <> _this_\width[2]
            _items_\width = _this_\width[2]
          EndIf
          
          If _items_\fontID And
             _this_\row\fontID <> _items_\fontID
            _this_\row\fontID = _items_\fontID
            DrawingFont(_items_\fontID) 
            
            ;  Debug "    "+ _items_\text\height +" "+ _items_\text\string
          EndIf
          
          
          Y = _items_\y - _this_\scroll\v\bar\page\pos
          state = _items_\color\state + Bool(_this_\color\state<>2 And _items_\color\state=2)
          
          ; Draw select back
          If _items_\color\back[state]
            DrawingMode(#PB_2DDrawing_Default)
            RoundBox(_this_\x[2],Y,_this_\width[2],_items_\height,_items_\round,_items_\round,_items_\color\back[state])
          EndIf
          
          ; Draw select frame
          If _items_\color\frame[state]
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(_this_\x[2],Y,_this_\width[2],_items_\height,_items_\round,_items_\round, _items_\color\frame[state])
          EndIf
          
          ; Draw checkbox
          ; Draw option
          If _this_\flag\option_group And _items_\parent
            DrawingMode(#PB_2DDrawing_Default)
            _tree_box_(_items_\box[1]\x, _items_\box[1]\y, _items_\box[1]\width, _items_\box[1]\height, _items_\box[1]\checked, 1, $FFFFFFFF, 7, 255)
            
          ElseIf _this_\flag\checkboxes
            DrawingMode(#PB_2DDrawing_Default)
            _tree_box_(_items_\box[1]\x, _items_\box[1]\y, _items_\box[1]\width, _items_\box[1]\height, _items_\box[1]\checked, 3, $FFFFFFFF, 2, 255)
          EndIf
          
          ; Draw image
          If _items_\image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(_items_\image\handle, _items_\image\x, _items_\image\y, _items_\color\alpha)
          EndIf
          
          ; Draw text
          If _items_\text\string.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(_items_\text\x, _items_\text\y, _items_\text\string.s, _this_\text\rotate, _items_\color\front[state])
          EndIf
          
          ; Horizontal line
          If _this_\flag\GridLines And 
             _items_\color\line <> _items_\color\back
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(_items_\x, (_items_\y+_items_\height+Bool(_this_\flag\gridlines>1))-_this_\scroll\v\bar\page\pos, _this_\width[2], 1, _this_\color\line)
          EndIf
        EndIf
      Next
      
      ; Draw plots
      If _this_\flag\lines
        DrawingMode(#PB_2DDrawing_XOr)
        ; DrawingMode(#PB_2DDrawing_CustomFilter) 
        
        ForEach _items_
          If _items_\draw 
            If _items_\l\h\height
              ;  CustomFilterTree_CallBack(@Tree_PlotX())
              Line(_items_\l\h\x, _items_\l\h\y, _items_\l\h\width, _items_\l\h\height, _items_\color\line)
            EndIf
            
            If _items_\l\v\width
              ;  CustomFilterTree_CallBack(@Tree_PlotY())
              Line(_items_\l\v\x, _items_\l\v\y, _items_\l\v\width, _items_\l\v\height, _items_\color\line)
            EndIf
          EndIf    
        Next
      EndIf
      
      ; Draw arrow
      If _this_\flag\buttons ;And Not _this_\flag\option_group
        DrawingMode(#PB_2DDrawing_Default)
        
        ForEach _items_
          If _items_\draw And _items_\childrens
            Bar_Arrow(_items_\box[0]\x+(_items_\box[0]\width-6)/2,_items_\box[0]\y+(_items_\box[0]\height-6)/2, 6, Bool(Not _items_\box[0]\checked)+2, _items_\color\front[_items_\color\state], 0,0) 
            ;             DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            ;             ;RoundBox(_items_\box[0]\x-3, _items_\box[0]\y-3, _items_\box[0]\width+6, _items_\box[0]\height+6, 7,7, _items_\color\front[_items_\color\state])
            ;             RoundBox(_items_\box[0]\x-1, _items_\box[0]\y-1, _items_\box[0]\width+2, _items_\box[0]\height+2, 7,7, _items_\color\front[_items_\color\state])
            ;             Bar_Arrow(_items_\box[0]\x+(_items_\box[0]\width-4)/2,_items_\box[0]\y+(_items_\box[0]\height-4)/2, 4, Bool(Not _items_\box[0]\checked)+2, _items_\color\front[_items_\color\state], 0,0) 
          EndIf    
        Next
      EndIf
      
      PopListPosition(_items_) ; 
    EndMacro
    
    With *this
      If Not \hide
        If \text\fontID 
          DrawingFont(\text\fontID) 
        EndIf
        
        If \change
          If \text\change
            \text\height = TextHeight("A") + Bool(#PB_Compiler_OS = #PB_OS_Windows) * 2
            \text\width = TextWidth(\text\string.s)
          EndIf
          
          _update_(*this, \row\_s())
          \change = 0
        EndIf 
        
        ; Draw background
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\back[\color\state])
        
        ; Draw background image
        If \image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
        EndIf
        
        ; Draw all items
        ClipOutput(\x[2],\y[2],\width[2],\height[2])
        
        ;_draws_(*this, \row\_s())
        _draws_(*this, \row\draws())
        
        UnclipOutput()
        
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        If \color\state
          ; RoundBox(\x[1]+Bool(\fs),\y[1]+Bool(\fs),\width[1]-Bool(\fs)*2,\height[1]-Bool(\fs)*2,\round,\round,0);\color\back)
          RoundBox(\x[2]-Bool(\fs),\y[2]-Bool(\fs),\width[2]+Bool(\fs)*2,\height[2]+Bool(\fs)*2,\round,\round,\color\back)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\frame[2])
          ;           If \round : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\round,\round,\color\frame[2]) : EndIf  ; Сглаживание краев )))
          ;           RoundBox(\x[1]-1,\y[1]-1,\width[1]+2,\height[1]+2,\round,\round,\color\frame[2])
        ElseIf \fs
          RoundBox(\x[1],\y[1],\width[1],\height[1],\round,\round,\color\frame[\color\state])
        EndIf
        
        ; Draw scroll bars
        bar_scrollarea_draw_(*this)
        
        If \text\change : \text\change = 0 : EndIf
        If \resize : \resize = 0 : EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.l Tree_ReDraw(*this._s_widget, canvas_backcolor=#Null)
    If *this
      With *this
        If StartDrawing(CanvasOutput(\root\canvas\gadget))
          If canvas_backcolor And *event\_draw = 0 : *event\_draw = 1
            FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), canvas_backcolor)
          EndIf
          
          Tree_Draw(*this)
          StopDrawing()
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  ;- SETs
  Procedure.l Tree_SetText(*this._s_widget, Text.s)
    Protected Result.l
    
    If *this\row\selected 
      *this\row\selected\text\string = Text
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Tree_SetFont(*this._s_widget, Font.i)
    Protected Result.i, FontID.i = FontID(Font)
    
    With *this
      If \text\fontID <> FontID 
        \text\fontID = FontID
        \text\change = 1
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Tree_SetState(*this._s_widget, State.l)
    Protected *Result
    
    With *this
      If State >= 0 And State < \countitems
        *Result = SelectElement(\row\_s(), State) 
      EndIf
      
      If \row\selected <> *Result
        If \row\selected
          \row\selected\color\state = 0
        EndIf
        
        \row\selected = *Result
        
        If \row\selected
          \row\selected\color\state = 2
          \row\scrolled = 1
        EndIf
        
        _tree_repaint_(*this)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Tree_SetAttribute(*this._s_widget, Attribute.i, Value.l)
    Protected Result.i =- 1
    
    Select Attribute
      Case #__tree_Collapse
        *this\flag\collapse = Bool(Not Value) 
        
      Case #__tree_OptionBoxes
        *this\flag\option_group = Bool(Value)*12
        *this\flag\checkBoxes = *this\flag\option_group
        
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Tree_SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l=0)
    Protected Result
    
    With *this
      If Item =- 1
        PushListPosition(\row\_s()) 
        ForEach \row\_s()
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
        Next
        PopListPosition(\row\_s()) 
        
      Else
        If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item)
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
  
  Procedure.i Tree_SetItemFont(*this._s_widget, Item.l, Font.i)
    Protected Result.i, FontID.i = FontID(Font)
    
    If Item >= 0 And Item < *this\countitems And 
       SelectElement(*this\row\_s(), Item) And 
       *this\row\_s()\text\fontID <> FontID
      *this\row\_s()\text\fontID = FontID
      ;       *this\row\_s()\text\change = 1
      ;       *this\change = 1
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Tree_SetItemText(*this._s_widget, Item.l, Text.s, Column.l=0)
    Protected Result.l
    
    If Item >= 0 And Item < *this\countitems And 
       SelectElement(*this\row\_s(), Item) And 
       *this\row\_s()\text\string <> Text 
      *this\row\_s()\text\string = Text 
      *this\row\_s()\text\change = 1
      *this\change = 1
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Macro _tree_tree_set_state_(_this_, _items_, _state_)
    If _this_\flag\option_group And _items_\parent
      If _items_\option_group\option_group <> _items_
        If _items_\option_group\option_group
          _items_\option_group\option_group\box[1]\checked = 0
        EndIf
        _items_\option_group\option_group = _items_
      EndIf
      
      _items_\box[1]\checked ! Bool(_state_)
      
    Else
      If _this_\flag\threestate
        If _state_ & #__tree_Inbetween
          _items_\box[1]\checked = 2
        ElseIf _state_ & #__tree_Checked
          _items_\box[1]\checked = 1
        Else
          Select _items_\box[1]\checked 
            Case 0
              _items_\box[1]\checked = 2
            Case 1
              _items_\box[1]\checked = 0
            Case 2
              _items_\box[1]\checked = 1
          EndSelect
        EndIf
      Else
        _items_\box[1]\checked ! Bool(_state_)
      EndIf
    EndIf
  EndMacro
   
  Procedure.l Tree_SetItemState(*this._s_widget, Item.l, State.b)
    Protected Result.l, collapsed.b, sublevel.l
    
    ;If (*this\flag\multiSelect Or *this\flag\clickSelect)
      If Item < 0 : Item = 0 : EndIf
      If Item > *this\countitems - 1 
        Item = *this\countitems - 1 
      EndIf
      
      Result = SelectElement(*this\row\_s(), Item) 
      
      If Result 
        If State & #__tree_Selected
          *this\row\_s()\color\state = 2
          *this\row\selected = *this\row\_s()
        EndIf
        
        If State & #__tree_Checked
          *this\row\_s()\box[1]\checked = 1
        EndIf
        
        If State & #__tree_Collapsed
          collapsed = 1
        EndIf
        
        If collapsed Or State & #__tree_Expanded
          *this\row\_s()\box[0]\checked = collapsed
          
          sublevel = *this\row\_s()\sublevel
          
          PushListPosition(*this\row\_s())
          While NextElement(*this\row\_s())
            If *this\row\_s()\sublevel = sublevel
              Break
            ElseIf *this\row\_s()\sublevel > sublevel 
              *this\row\_s()\hide = collapsed
              ;*this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\checked | *this\row\_s()\parent\hide)
                  
            EndIf
          Wend
          PushListPosition(*this\row\_s())
        EndIf   
      EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l _Tree_SetItemState(*this._s_widget, Item.l, State.b)
    Protected Result.l, Repaint.b, collapsed.b
    
;     ;If (*this\flag\multiSelect Or *this\flag\clickSelect)
    If Item < 0 Or Item > *this\countitems - 1 
      ProcedureReturn 0
    EndIf
;     If Item < 0 : Item = 0 : EndIf
;       If Item > *this\countitems - 1 
;         Item = *this\countitems - 1 
;       EndIf
      
    Result = SelectElement(*this\row\_s(), Item) 
    
    If Result 
      If State & #__tree_Selected
        If *this\row\selected <> *this\row\_s()
;           If *this\row\selected
;             *this\row\selected\color\state = 0
;           EndIf
          
          *this\row\selected = *this\row\_s()
          *this\row\selected\color\state = 2 + Bool(GetActive()<>*this)
          Repaint = 1
        Else
          State &~ #__tree_Selected
        EndIf
      EndIf
      
      If State & #__tree_Inbetween Or State & #__tree_Checked
        _tree_set_state_(*this, *this\row\_s(), State)
        
        Repaint = 2
      EndIf
      
      If State & #__tree_Collapsed
        *this\row\_s()\box[0]\checked = 1
        collapsed = 1
      ElseIf State & #__tree_Expanded
        *this\row\_s()\box[0]\checked = 0
        collapsed = 1
      EndIf
      
      If collapsed And *this\row\_s()\childrens
        ; 
        If Not *this\hide And *this\row\count And (*this\countitems % *this\row\count) = 0
          *this\change = 1
          Repaint = 3
        EndIf  
        
        PushListPosition(*this\row\_s())
        While NextElement(*this\row\_s())
          If *this\row\_s()\parent And *this\row\_s()\sublevel > *this\row\_s()\parent\sublevel 
            *this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\checked | *this\row\_s()\parent\hide)
          Else
            Break
          EndIf
        Wend
        PopListPosition(*this\row\_s())
      EndIf
      
      If Repaint
        If Repaint = 2
          Post(#__Event_StatusChange, *this, Item)
        EndIf
        
        If Repaint = 1
          Post(#__Event_Change, *this, Item)
          ;Tree_Events(*this, #__Event_Change)
        EndIf
        
        _tree_repaint_(*this)
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Tree_SetItemImage(*this._s_widget, Item.l, Image.i) ; Ok
    If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item)
      If *this\row\_s()\image\index <> Image
        _tree_set_item_image_(*this, *this\row\_s(), Image)
        _tree_repaint_(*this)
      EndIf
    EndIf
  EndProcedure
  
  Procedure.i Tree_SetItemAttribute(*this._s_widget, Item.l, Attribute.i, Value.l)
    
  EndProcedure
  
  
  ;- GETs
  Procedure.s Tree_GetText(*this._s_widget)
    If *this\row\selected 
      ProcedureReturn *this\row\selected\text\string
    EndIf
  EndProcedure
  
  Procedure.i Tree_GetFont(*this._s_widget)
    ProcedureReturn *this\text\fontID
  EndProcedure
  
  Procedure.l Tree_GetState(*this._s_widget)
    Protected Result.l =- 1
    
    If *this\row\selected And *this\row\selected\color\state
      Result = *this\row\selected\index
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Tree_GetAttribute(*this._s_widget, Attribute.i)
    Protected Result.i
    
    Select Attribute
      Case #__tree_Collapse
        Result = *this\flag\collapse
        
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Tree_GetItemColor(*this._s_widget, Item.l, ColorType.l, Column.l=0)
    Protected Result
    
    With *this
      If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item)
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
  
  Procedure.i Tree_GetItemFont(*this._s_widget, Item.l)
    Protected Result.i =- 1
    
    If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item) 
      Result = *this\row\_s()\text\fontID
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s Tree_GetItemText(*this._s_widget, Item.l, Column.l=0)
    Protected Result.s
    
    If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item) 
      Result = *this\row\_s()\text\string
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Tree_GetItemState(*this._s_widget, Item.l)
    Protected Result.l
    
    If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item) 
      If *this\row\_s()\color\state
        Result | #__tree_Selected
      EndIf
      
      If *this\row\_s()\box[1]\checked
        If *this\flag\threestate And *this\row\_s()\box[1]\checked = 2
          Result | #__tree_Inbetween
        Else
          Result | #__tree_Checked
        EndIf
      EndIf
      
      If *this\row\_s()\childrens And 
         *this\row\_s()\box[0]\checked = 0
        Result | #__tree_Expanded
      Else
        Result | #__tree_Collapsed
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Tree_GetItemImage(*this._s_widget, Item.l)
    Protected Result.i =- 1
    
    If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item)
      Result = *this\row\_s()\image\index
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Tree_GetItemAttribute(*this._s_widget, Item.l, Attribute.i, Column.l=0)
    Protected Result.i =- 1
    
    If Item < 0 : Item = 0 : EndIf
    If Item > *this\countitems - 1 
      Item = *this\countitems - 1 
    EndIf
    
    If SelectElement(*this\row\_s(), Item)
      Select Attribute
        Case #__tree_SubLevel
          Result = *this\row\_s()\sublevel
      EndSelect
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  Procedure Tree_RemoveItem(*this._s_widget, Item.l) 
    Protected sublevel.l
    
    If Item >= 0 And 
       Item < *this\countitems And
       SelectElement(*this\row\_s(), Item)
      ;       Debug ""+*this\row\_s()\index +" "+ Item
      ; *this\row\sublevel = 0
      
      If *this\row\_s()\childrens
        sublevel = *this\row\_s()\sublevel
        
        PushListPosition(*this\row\_s())
        While NextElement(*this\row\_s())
          If *this\row\_s()\sublevel > sublevel 
            ;Debug *this\row\_s()\text\string
            DeleteElement(*this\row\_s())
            *this\countitems - 1
            *this\row\count - 1
          Else
            Break
          EndIf
        Wend
        PopListPosition(*this\row\_s())
        
        *this\change = 1
      EndIf
      
      DeleteElement(*this\row\_s())
      
      If (*this\row\count And (*this\countitems % *this\row\count) = 0) Or 
         *this\row\count < 2 ; Это на тот случай когда итеми менше первого обнавления
        
        ; Debug "    "+*this\countitems +" "+ *this\row\count
        
        PushListPosition(*this\row\_s())
        ForEach *this\row\_s()
          ; *this\row\sublevel = *this\image\padding\left + *this\row\_s()\image\width
          *this\row\_s()\index = ListIndex(*this\row\_s())
        Next
        PopListPosition(*this\row\_s())
      EndIf 
      
      If *this\row\selected And *this\row\selected\index >= Item 
        *this\row\selected\color\state = 0
        
        PushListPosition(*this\row\_s())
        If *this\row\selected\index <> Item 
          SelectElement(*this\row\_s(), *this\row\selected\index)
        EndIf
        
        While NextElement(*this\row\_s())
          If *this\row\_s()\sublevel = sublevel 
            *this\row\selected = *this\row\_s()
            *this\row\selected\color\state = 2 + Bool(*event\active<>*this)
            Break
          EndIf
        Wend
        PopListPosition(*this\row\_s())
      EndIf
      
      _tree_repaint_(*this)
      *this\countitems - 1
      ; надо подумать
      ; *this\row\sublevel = 0
    EndIf
  EndProcedure
  
  Procedure.l Tree_CountItems(*this._s_widget) ; Ok
    ProcedureReturn *this\countitems
  EndProcedure
  
  Procedure Tree_ClearItems(*this._s_widget) ; Ok
    If *this\countitems <> 0
      *this\change =- 1
      *this\row\count = 0
      *this\countitems = 0
      *this\row\sublevel = 0
      
      If *this\row\selected 
        *this\row\selected\color\state = 0
        *this\row\selected = 0
      EndIf
      
      ClearList(*this\row\_s())
      
      If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
        Tree_Draw(*this)
        StopDrawing()
      EndIf
      Post(#__Event_Change, *this, #PB_All)
    EndIf
  EndProcedure
  
  Procedure.i Tree_AddItem(*this._s_widget, position.l, Text.s, Image.i=-1, subLevel.i=0)
    Protected handle, *parent._s_rows
    
    With *this
      If *this
        If sublevel =- 1
          *parent = *this
          \flag\option_group = 12
          \flag\checkBoxes = \flag\option_group
        EndIf
        
        If \flag\option_group
          If subLevel > 1
            subLevel = 1
          EndIf
        EndIf
        
        ;{ Генерируем идентификатор
        If position < 0 Or position > ListSize(\row\_s()) - 1
          LastElement(\row\_s())
          handle = AddElement(\row\_s()) 
          position = ListIndex(\row\_s())
        Else
          handle = SelectElement(\row\_s(), position)
          
          Protected Lastlevel, Parent, mac = 0
          If mac 
            PreviousElement(\row\_s())
            If \row\_s()\sublevel = sublevel
              Lastlevel = \row\_s()\sublevel 
              \row\_s()\childrens = 0
            EndIf
            SelectElement(\row\_s(), position)
          Else
            If sublevel < \row\_s()\sublevel
              sublevel = \row\_s()\sublevel  
            EndIf
          EndIf
          
          handle = InsertElement(\row\_s())
          
          If mac And subLevel = Lastlevel
            \row\_s()\childrens = 1
            Parent = \row\_s()
          EndIf
          
          ; Исправляем идентификатор итема  
          PushListPosition(\row\_s())
          While NextElement(\row\_s())
            \row\_s()\index = ListIndex(\row\_s())
            
            If mac And \row\_s()\sublevel = sublevel + 1
              \row\_s()\parent = Parent
            EndIf
          Wend
          PopListPosition(\row\_s())
        EndIf
        ;}
        
        If handle
          ;;;; \row\_s() = AllocateStructure(_s_rows) с ним setstate работать перестает
;           \row\_s()\handle = handle
          
          If \row\sublevellen
            If Not position
              \row\first = \row\_s()
            EndIf
            
            If subLevel
              If sublevel>position
                sublevel=position
              EndIf
              
              PushListPosition(\row\_s())
              While PreviousElement(\row\_s()) 
                If subLevel = \row\_s()\sublevel
                  *parent = \row\_s()\parent
                  Break
                ElseIf subLevel > \row\_s()\sublevel
                  *parent = \row\_s()
                  Break
                EndIf
              Wend 
              PopListPosition(\row\_s())
              
              If *parent
                If subLevel > *parent\sublevel
                  sublevel = *parent\sublevel + 1
                  *parent\childrens + 1
                  
                  If \flag\collapse
                    *parent\box[0]\checked = 1 
                    \row\_s()\hide = 1
                  EndIf
                EndIf
                \row\_s()\parent = *parent
              EndIf
              
              \row\_s()\sublevel = sublevel
            EndIf
          EndIf
          
          ; set option group
          If \flag\option_group 
            If \row\_s()\parent
              \row\_s()\option_group = \row\_s()\parent
            Else
              \row\_s()\option_group = *this
            EndIf
          EndIf
          
          ; add lines
          \row\_s()\index = position
          
          \row\_s()\color = _get_colors_()
          \row\_s()\color\state = 0
          
          \row\_s()\color\back = 0;\color\back 
          \row\_s()\color\frame = 0;\color\back 
          
          \row\_s()\color\fore[0] = 0 
          \row\_s()\color\fore[1] = 0
          \row\_s()\color\fore[2] = 0
          \row\_s()\color\fore[3] = 0
          
          If Text
            \row\_s()\text\string = StringField(Text.s, 1, #LF$)
            \row\_s()\text\change = 1
          EndIf
          
          _tree_set_item_image_(*this, \row\_s(), Image)
          
          If \flag\buttons
            \row\_s()\box[0]\width = \flag\buttons
            \row\_s()\box[0]\height = \flag\buttons
          EndIf
          
          If \flag\checkBoxes Or \flag\option_group
            \row\_s()\box[1]\width = \flag\checkBoxes
            \row\_s()\box[1]\height = \flag\checkBoxes
          EndIf
          
          If \row\sublevellen 
            If (\flag\buttons Or \flag\lines)
              \row\_s()\sublevellen = \row\_s()\sublevel * \row\sublevellen + Bool(\flag\buttons) * 19 + Bool(\flag\checkBoxes) * 18
            Else
              \row\_s()\sublevellen =  Bool(\flag\checkBoxes) * 18 
            EndIf
          EndIf
          
          If *this\row\selected 
            *this\row\selected\color\state = 0
            *this\row\selected = *this\row\_s() 
            *this\row\selected\color\state = 2 + Bool(*event\active<>*this)
          EndIf
          
          _tree_repaint_(*this)
          \countitems + 1
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn handle
  EndProcedure
  
  Procedure.l Tree_Resize(*this._s_widget, X.l,Y.l,Width.l,Height.l)
    Protected scroll_width
    Protected scroll_height
    
    With *this
      
      If \scroll And \scroll\v And \scroll\h
        If X=#PB_Ignore
          x=\x
        EndIf
        
        If y=#PB_Ignore
          y=\y
        EndIf
        
        If Width=#PB_Ignore
          Width=\width
        EndIf
        
        If Height=#PB_Ignore
          Height=\height
        EndIf
        
        Bar_Resizes(\scroll, x+\bs,Y+\bs,Width-\bs*2,Height-\bs*2)
        
        If x=\x
          X=#PB_Ignore
        EndIf
        
        If y=\y
          y=#PB_Ignore
        EndIf
        
        If Width=\width
          Width=#PB_Ignore
        EndIf
        
        If Height=\height
          Height=#PB_Ignore
        EndIf
        
        If Not \scroll\v\hide
          scroll_width = \scroll\v\width
        EndIf
        
        If Not \scroll\h\hide
          scroll_height = \scroll\h\height
        EndIf
      EndIf
      
      If X<>#PB_Ignore And 
         \x[0] <> X
        \x[0] = X 
        \x[2]=\x[0]+\bs
        \x[1]=\x[2]-\fs
        \resize = 1<<1
      EndIf
      If Y<>#PB_Ignore And 
         \y[0] <> Y
        \y[0] = Y
        \y[2]=\y[0]+\bs
        \y[1]=\y[2]-\fs
        \resize = 1<<2
      EndIf
      If Width<>#PB_Ignore And
         \width[0] <> Width 
        \width[0] = Width 
        \width[2] = \width[0]-\bs*2-scroll_width
        \width[1] = \width[0]-\bs*2+\fs*2
        \resize = 1<<3
      EndIf
      If Height<>#PB_Ignore And 
         \height[0] <> Height
        \height[0] = Height 
        \height[2] = \height[0]-\bs*2-scroll_height
        \height[1] = \height[0]-\bs*2+\fs*2
        \resize = 1<<4
      EndIf
      
      If \resize
        ; можно обновлять если 
        ; виджет измениля в размерах 
        ; а не канвас гаджет
        ; _tree_repaint_(*this)
      EndIf
      
      ProcedureReturn \resize
    EndWith
  EndProcedure
  
  ;-
  Procedure.i Tree(X.l, Y.l, Width.l, Height.l, Flag.i=0, round.l=0)
    Static index
    Protected *this._s_widget = AllocateStructure(_s_widget)
    
    If *this
      With *this
        \root = Root()
        \handle = *this
        \index = index : index + 1
        \type = #PB_GadgetType_Tree
        \x =- 1
        \y =- 1
        \row\index =- 1
        \change = 1
        
        \interact = 1
        \round = round
        
        \text\change = 1 ; set auto size items
        \text\height = 18 
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          ;                     Protected TextGadget = TextGadget(#PB_Any, 0,0,0,0,"")
          ;                     \text\fontID = GetGadTree_GetFont(TextGadget) 
          ;                     FreeGadget(TextGadget)
          Protected FontSize.CGFloat ;= 12.0  boldSystemFontOfSize  fontWithSize
                                     ;\text\fontID = CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @FontSize) 
                                     ; CocoaMessage(@FontSize,0,"NSFont systemFontSize")
          
          ;\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica Neue", 12))
          ;\text\fontID = FontID(LoadFont(#PB_Any, "Tahoma", 12))
          ;\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 12))
          ;
          \text\fontID = CocoaMessage(0, 0, "NSFont controlContentFontOfSize:@", @FontSize)
          CocoaMessage(@FontSize, \text\fontID, "pointSize")
          
          ;FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
          
          ; Debug PeekS(CocoaMessage(0,  CocoaMessage(0, \text\fontID,"displayName"), "UTF8String"), -1, #PB_UTF8)
          
        CompilerElse
          \text\fontID = GetGadTree_GetFont(#PB_Default) ; Bug in Mac os
        CompilerEndIf
        
        \text\padding\left = 4
        \image\padding\left = 2
        
        \fs = Bool(Not Flag&#__tree_BorderLess)*2
        \bs = \fs
        
        \flag\gridlines = Bool(flag&#__tree_GridLines)
        \flag\multiSelect = Bool(flag&#__tree_MultiSelect)
        \flag\clickSelect = Bool(flag&#__tree_ClickSelect)
        \flag\alwaysSelection = Bool(flag&#__tree_AlwaysSelection)
        
        \flag\lines = Bool(Not flag&#__tree_NoLines)*8 ; Это еще будет размер линии
        \flag\buttons = Bool(Not flag&#__tree_NoButtons)*9 ; Это еще будет размер кнопки
        \flag\checkBoxes = Bool(flag&#__tree_CheckBoxes)*12; Это еще будет размер чек бокса
        \flag\collapse = Bool(flag&#__tree_Collapse) 
        \flag\threestate = Bool(flag&#__tree_ThreeState) 
        
        \flag\option_group = Bool(flag&#__tree_OptionBoxes)*12; Это еще будет размер
        If \flag\option_group
          \flag\checkBoxes = 12; Это еще будет размер чек бокса
        EndIf
        
        
        If \flag\lines Or \flag\buttons Or \flag\checkBoxes
          \row\sublevellen = 18
        EndIf
        
        ;\color = _get_colors_()
        ;         \color\fore[0] = 0
        ;         \color\fore[1] = 0
        ;         \color\fore[2] = 0
        \color\frame[#__s_0] = $80C8C8C8 
        ;\color\frame[#__s_1] = $80FFC288 
        \color\frame[#__s_2] = $C8DC9338 
        \color\frame[#__s_3] = $FFBABABA
        \color\back[#__s_0] = $FFFFFFFF 
        ;\color\back[#__s_1] = $FFFFFFFF 
        \color\back[#__s_2] = $FFFFFFFF 
        \color\back[#__s_3] = $FFE2E2E2 
        ; \color\line = $FFF0F0F0
      EndIf
      
;       \scroll\v = Bar_Scroll(0, 0, 16, 0, 0,0,0, #__bar_Vertical, 7)
;       \scroll\h = Bar_Scroll(0, 0, 0, Bool((\flag\buttons=0 And \flag\lines=0)=0)*16, 0,0,0, 0, 7)
;       \scroll\v = Bar_create(#PB_GadgetType_ScrollBar, 16, 0,0,0, #__bar_Vertical, 7, *this)
;       \scroll\h = Bar_create(#PB_GadgetType_ScrollBar, Bool((\flag\buttons=0 And \flag\lines=0)=0)*16, 0,0,0, 0, 7, *this)
      \scroll\v = Bar_Create(#PB_GadgetType_ScrollBar, *this, 0,0,0,0, 0,0,0, 16, #PB_ScrollBar_Vertical, 7)
      \scroll\h = Bar_Create(#PB_GadgetType_ScrollBar, *this, 0,0,0,0, 0,0,0, 16, 0, 7)
      
      Tree_Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  
  ;-
  Declare tt_close(*this._s_tt)
  
  Procedure tt_Tree_Draw(*this._s_tt, *color._s_color=0)
    With *this
      If *this And IsGadget(\gadget) And StartDrawing(CanvasOutput(\gadget))
        If Not *color
          *color = \color
        EndIf
        
        If \text\fontID 
          DrawingFont(\text\fontID) 
        EndIf 
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,1,\width,\height-2, *color\back[*color\state])
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(\text\x, \text\y, \text\string, *color\front[*color\state])
        DrawingMode(#PB_2DDrawing_Outlined)
        Line(0,0,\width,1, *color\frame[*color\state])
        Line(0,\height-1,\width,1, *color\frame[*color\state])
        Line(\width-1,0,1,\height, *color\frame[*color\state])
        StopDrawing()
      EndIf 
    EndWith
  EndProcedure
  
  Procedure tt_Tree_CallBack()
    ;     ;SetActiveWindow(*event\widget\root\window)
    ;     ;SetActiveGadget(*event\widget\root\canvas\gadget)
    ;     
    ;     If *event\widget\row\selected
    ;       *event\widget\row\selected\color\State = 0
    ;     EndIf
    ;     
    ;     *event\widget\row\selected = *event\widget\row\_s()
    ;     *event\widget\row\_s()\color\State = 2
    ;     *event\widget\color\State = 2
    ;     
    ;     ;Tree_ReDraw(*event\widget)
    
    tt_close(GetWindowData(EventWindow()))
  EndProcedure
  
  Procedure tt_creare(*this._s_widget, x,y)
    With *this
      If *this
        *event\widget = *this
        \row\tt = AllocateStructure(_s_tt)
        \row\tt\visible = 1
        \row\tt\x = x+\row\_s()\x+\row\_s()\width-1
        \row\tt\y = y+\row\_s()\y-\scroll\v\bar\page\pos
        
        \row\tt\width = \row\_s()\text\width-\width[2] + (\row\_s()\text\x - \row\_s()\x) + 5 ;- (\scroll\width-\width);- \row\_s()\text\x; 105 ;\row\_s()\text\width - (\scroll\width-\row\_s()\width)  ; - 32 + 5 
        
        If \row\tt\width < 6
          \row\tt\width = 0
        EndIf
        
        Debug \row\tt\width ;Str(\row\_s()\text\x - \row\_s()\x)
        
        \row\tt\height = \row\_s()\height
        Protected flag
        CompilerIf #PB_Compiler_OS = #PB_OS_Linux
          flag = #PB_Window_Tool
        CompilerEndIf
        
        \row\tt\Window = OpenWindow(#PB_Any, \row\tt\x, \row\tt\y, \row\tt\width, \row\tt\height, "", 
                                    #PB_Window_BorderLess|#PB_Window_NoActivate|flag, WindowID(\root\window))
        
        \row\tt\gadget = CanvasGadget(#PB_Any,0,0, \row\tt\width, \row\tt\height)
        \row\tt\color = \row\_s()\color
        \row\tt\text = \row\_s()\text
        \row\tt\text\fontID = \row\_s()\fontID
        \row\tt\text\x =- (\width[2]-(\row\_s()\text\x-\row\_s()\x)) + 1
        \row\tt\text\y = (\row\_s()\text\y-\row\_s()\y)+\scroll\v\bar\page\pos
        
        BindEvent(#PB_Event_ActivateWindow, @tt_Tree_CallBack(), \row\tt\Window)
        SetWindowData(\row\tt\Window, \row\tt)
        tt_Tree_Draw(\row\tt)
      EndIf
    EndWith              
  EndProcedure
  
  Procedure tt_close(*this._s_tt)
    If IsWindow(*this\window)
      *this\visible = 0
      ;UnbindEvent(#PB_Event_ActivateWindow, @tt_Tree_CallBack(), *this\window)
      CloseWindow(*this\window)
      ; ClearStructure(*this, _s_tt) ;??????
    EndIf
  EndProcedure
  
  ;-
  Procedure Tree_Events(*this._s_widget, eventtype.l, mouse_x.l=-1, mouse_y.l=-1, position.l=0)
    Protected Result, down
    
    Select eventtype
      Case #__Event_LeftClick
        Debug "click - "+*this
        Post(eventtype, *this, *this\row\index)
        
      Case #__Event_Change
        Debug "change - "+*this
        Post(eventtype, *this, *this\row\index)
        Result = 1
        
      Case #__Event_DragStart
        Debug "drag - "+*this
        Post(eventtype, *this, *this\row\index)
        
      Case #__Event_Drop
        Debug "drop - "+*this
        Post(eventtype, *this, *this\row\index)
        
      Case #__Event_Focus
        Debug "focus - "+*this
        Result = 1
        
      Case #__Event_LostFocus
        Debug "lost focus - "+*this
        Result = 1
        
      Case #__Event_LeftButtonDown
        Debug "left down - "+*this
        
      Case #__Event_LeftButtonUp
        Debug "left up - "+*this
        
      Case #__Event_MouseEnter
        Debug "enter - "+*this +" "+ *this\root\mouse\buttons
        Result = 1
        
      Case #__Event_MouseLeave
        Debug "leave - "+*this
        Result = 1
        
      Case #__Event_MouseMove
        ; Debug "move - "+*this
        
        If position And *this\row\index >= 0
          ;down = *this\root\mouse\buttons
          
          ; event mouse enter line
          If position > 0
            If down And *this\flag\multiselect 
              _tree_multi_select_(*this, *this\row\index, *this\row\selected\index)
              
            ElseIf *this\row\_s()\color\state = 0
              *this\row\_s()\color\state = 1+Bool(down)
              
              If down
                *this\row\selected = *this\row\_s()
              EndIf
            EndIf
            
            ; create tooltip on the item
            If Bool((*this\flag\buttons=0 And *this\flag\lines=0)) And *this\scroll\h\bar\max > *this\width[2]
              tt_creare(*this, GadgetX(*this\root\canvas\gadget, #PB_Gadget_ScreenCoordinate), GadgetY(*this\root\canvas\gadget, #PB_Gadget_ScreenCoordinate))
            EndIf
            
            ; event mouse leave line
          Else
            If (*this\row\_s()\color\state = 1 Or down)
              *this\row\_s()\color\state = 0
            EndIf
            
            ; close tooltip on the item
            If *this\row\tt And *this\row\tt\visible
              tt_close(*this\row\tt)
            EndIf
            
          EndIf
          
          Result = #True
        EndIf
    EndSelect
    
    If (Not position And *this\scroll And *this\scroll\v And *this\scroll\h)
      Result | bar_Events(*this\scroll\v, eventtype, mouse_x, mouse_y, *this\root\mouse\wheel\x, *this\root\mouse\wheel\y)
      Result | bar_Events(*this\scroll\h, eventtype, mouse_x, mouse_y, *this\root\mouse\wheel\x, *this\root\mouse\wheel\y)
      
      If (*this\scroll\v\change Or *this\scroll\h\change)
        If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
          _update_(*this, *this\row\_s())
          StopDrawing()
        EndIf
        
        *this\scroll\v\change = 0 
        *this\scroll\h\change = 0
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Tree_Tree_Events(*this._s_widget, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
    Protected Result, from =- 1
    Static cursor_change, Down, *row_selected._s_rows
    
    With *this
      ; post widget events                     
      Select EventType 
        Case #__Event_LeftButtonDown
          If *this = *event\enter  ; *event\leave;
            *this\root\mouse\delta\x = mouse_x
            *this\root\mouse\delta\y = mouse_y
            
            If *event\active <> *this
              _tree_set_active_(*this)
            EndIf
            
            Result | Tree_Events(*this, EventType, mouse_x, mouse_y)
            
            If *this\row\index >= 0
              If _from_point_(mouse_x, mouse_y, *this\row\_s()\box[1])
                _tree_set_state_(*this, *this\row\_s(), 1)
                *this\row\box\checked = 1
                
                Result = #True
              ElseIf *this\flag\buttons And *this\row\_s()\childrens And _from_point_(mouse_x, mouse_y, *this\row\_s()\box[0])
                *this\change = 1
                *this\row\box\checked = 2
                *this\row\_s()\box[0]\checked ! 1
                
                PushListPosition(*this\row\_s())
                While NextElement(*this\row\_s())
                  If *this\row\_s()\parent And *this\row\_s()\sublevel > *this\row\_s()\parent\sublevel 
                    *this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\checked | *this\row\_s()\parent\hide)
                  Else
                    Break
                  EndIf
                Wend
                PopListPosition(*this\row\_s())
                
                If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
                  _update_(*this, *this\row\_s())
                  StopDrawing()
                EndIf
                
                Result = #True
              Else
                
                If *row_selected <> *this\row\_s()
                  If *this\row\selected 
                    *this\row\selected\color\state = 0
                  EndIf
                  
                  *row_selected = *this\row\_s()
                  *this\row\_s()\color\state = 2
                EndIf
                
                
                ;                   If \flag\multiselect
                ;                     _tree_multi_select_(*this, \row\index, \row\selected\index)
                ;                   EndIf
                
                If *this\row\tt And *this\row\tt\visible
                  tt_close(*this\row\tt)
                EndIf
                
                Result = #True
              EndIf
            EndIf
            
          Else
            *event\leave = *event\enter
          EndIf
          
        Case #__Event_LeftButtonUp 
          If *this = *event\leave And *event\leave\root\mouse\buttons
            *event\leave\root\mouse\buttons = 0
            
            If *this\row\box\checked 
              *this\row\box\checked = 0
              
            ElseIf *this\row\index >= 0 And Not *this\row\drag
              
              If *this\row\selected <> *row_selected
                *this\row\selected = *row_selected
                *this\row\selected\color\state = 2
                
                Result | Tree_Events(*this, #__Event_Change, mouse_x, mouse_y)
              EndIf
            EndIf
            
            Result | Tree_Events(*this, #__Event_LeftButtonUp, mouse_x, mouse_y)
            
            If *this\row\drag 
              *this\row\drag = 0
              
            ElseIf *this\row\index >= 0 
              Result | Tree_Events(*this, #__Event_LeftClick, mouse_x, mouse_y)
            EndIf
            
            If *event\leave <> *event\enter
              Result | Tree_Events(*event\leave, #__Event_MouseLeave, mouse_x, mouse_y) 
              *event\leave\row\index =- 1
              *event\leave = *event\enter
              
              ; post enter event
              If *event\enter
                Result | Tree_Events(*event\enter, #__Event_MouseEnter, mouse_x, mouse_y)
              EndIf
            EndIf
            
            ; post drop event
            CompilerIf Defined(DD, #PB_Module)
              If DD::EventDrop(*event\enter, #__Event_LeftButtonUp)
                Result | Tree_Events(*event\enter, #__Event_Drop, mouse_x, mouse_y)
              EndIf
              
              If Not *event\enter
                DD::EventDrop(-1, #__Event_LeftButtonUp)
              EndIf
            CompilerEndIf
            
          EndIf
          
          If *this = *event\enter And Not *event\leave
            Result | Tree_Events(*event\enter, #__Event_MouseEnter, mouse_x, mouse_y)
            *event\leave = *event\enter
          EndIf
          
        Case #__Event_LostFocus
          ; если фокус получил PB gadget
          ; то убираем фокус с виджета
          If *this = *event\active
            If *event\active\row\selected 
              *event\active\row\selected\color\state = 3
            EndIf
            
            Result | Tree_Events(*this, #__Event_LostFocus, mouse_x, mouse_y)
            
            *event\active\color\state = 0
            *event\active = 0
          EndIf
          
        Case #__Event_KeyDown
          If *this = *event\active
            
            Select *this\root\keyboard\key
              Case #PB_Shortcut_PageUp
                If bar_SetState(*this\scroll\v, 0) 
                  *this\change = 1 
                  Result = 1
                EndIf
                
              Case #PB_Shortcut_PageDown
                If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\end) 
                  *this\change = 1 
                  Result = 1
                EndIf
                
              Case #PB_Shortcut_Up, #PB_Shortcut_Home
                If *this\row\selected
                  If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                     (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                    
                    If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos-18) 
                      *this\change = 1 
                      Result = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index > 0
                    ; select modifiers key
                    If (*this\root\keyboard\key = #PB_Shortcut_Home Or
                        (*this\root\keyboard\key[1] & #PB_Canvas_Alt))
                      SelectElement(*this\row\_s(), 0)
                    Else
                      SelectElement(*this\row\_s(), *this\row\selected\index - 1)
                      
                      If *this\row\_s()\hide
                        While PreviousElement(*this\row\_s())
                          If Not *this\row\_s()\hide
                            Break
                          EndIf
                        Wend
                      EndIf
                    EndIf
                    
                    If *this\row\selected <> *this\row\_s()
                      *this\row\selected\color\state = 0
                      *this\row\selected  = *this\row\_s()
                      *this\row\_s()\color\state = 2
                      *row_selected = *this\row\_s()
                      
                      Result | Tree_Events(*this, #__Event_Change, mouse_x, mouse_y)
                    EndIf
                    
                    *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down, #PB_Shortcut_End
                If *this\row\selected
                  If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                     (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                    
                    If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos+18) 
                      *this\change = 1 
                      Result = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index < (*this\countitems - 1)
                    ; select modifiers key
                    If (*this\root\keyboard\key = #PB_Shortcut_End Or
                        (*this\root\keyboard\key[1] & #PB_Canvas_Alt))
                      SelectElement(*this\row\_s(), (*this\countitems - 1))
                    Else
                      SelectElement(*this\row\_s(), *this\row\selected\index + 1)
                      
                      If *this\row\_s()\hide
                        While NextElement(*this\row\_s())
                          If Not *this\row\_s()\hide
                            Break
                          EndIf
                        Wend
                      EndIf
                    EndIf
                    
                    If *this\row\selected <> *this\row\_s()
                      *this\row\selected\color\state = 0
                      *this\row\selected  = *this\row\_s()
                      *this\row\_s()\color\state = 2
                      *row_selected = *this\row\_s()
                      
                      Result | Tree_Events(*this, #__Event_Change, mouse_x, mouse_y)
                    EndIf
                    
                    *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Left
                If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                   (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                  
                  *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos-(*this\scroll\h\bar\page\end/10)) 
                  Result = 1
                EndIf
                
              Case #PB_Shortcut_Right
                If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                   (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                  
                  *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos+(*this\scroll\h\bar\page\end/10)) 
                  Result = 1
                EndIf
                
            EndSelect
            
          EndIf
          
      EndSelect
      
      If *this = *event\enter And
         *this\scroll\v\from =- 1 And *this\scroll\h\from =- 1 ;And Not *this\root\key; And Not *this\root\mouse\buttons
        
        If _from_point_(mouse_x, mouse_y, *this, [2]) 
          
          ; at item from points
          ForEach *this\row\draws()
            If (mouse_y >= *this\row\draws()\y-*this\scroll\v\bar\page\pos And
                mouse_y < *this\row\draws()\y+*this\row\draws()\height-*this\scroll\v\bar\page\pos)
              
              If *this\row\index <> *this\row\draws()\index
                If *this\row\index >= 0 ;And SelectElement(\row\_s(), \row\index)
                  Result | Tree_Events(*this, #__Event_MouseMove, mouse_x, mouse_y, -1)
                EndIf
                
                *this\row\index = *this\row\draws()\index
                
                If *this\row\index >= 0 And SelectElement(*this\row\_s(), *this\row\index)
                  Result | Tree_Events(*this, #__Event_MouseMove, mouse_x, mouse_y, 1)
                EndIf
              EndIf
              
              Break
            EndIf
          Next
          
          If *this\row\index >= 0 And Not (mouse_y >= *this\row\_s()\y-*this\scroll\v\bar\page\pos And
                                           mouse_y < *this\row\_s()\y+*this\row\_s()\height-*this\scroll\v\bar\page\pos)
            Result | Tree_Events(*this, #__Event_MouseMove, mouse_x, mouse_y, -1)
            *this\row\index =- 1
          EndIf
        Else
          
          If *this\row\index >= 0
            ;Debug " leave items"
            Result | Tree_Events(*this, #__Event_MouseMove, mouse_x, mouse_y, -1)
            *this\row\index =- 1
          EndIf
          
        EndIf
        
        ; post change and drag start 
        If *this\root\mouse\buttons And *this\row\drag = 0 And 
           (Abs((mouse_x-*this\root\mouse\delta\x)+(mouse_y-*this\root\mouse\delta\y)) >= 6)
          *this\row\drag = 1
          
          If *this\row\selected <> *row_selected
            *this\row\selected = *row_selected
            ;*this\row\selected\color\state = 2
            
            Result | Tree_Events(*this, #__Event_Change, mouse_x, mouse_y)
          EndIf
          
          Result | Tree_Events(*this, #__Event_DragStart, mouse_x, mouse_y)
        EndIf
      EndIf
      
      If EventType = #__Event_MouseMove
        If *event\leave And *event\leave\row\index =- 1
          Result | Tree_Events(*event\leave, #__Event_MouseMove, mouse_x, mouse_y)
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Tree_CallBack(*this._s_widget, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
    Protected Result, from =- 1
    Static cursor_change, Down, *row_selected._s_rows
    
    If Not *this Or 
       Not *this\handle
      ProcedureReturn 0
    EndIf
    
    Select EventType
      Case #__Event_Repaint
        Debug " -- Canvas repaint -- " + *this\row\count
      Case #__Event_MouseWheel
        *this\root\mouse\wheel\y = GetGadTree_GetAttribute(*this\root\canvas\gadget, #PB_Canvas_WheelDelta)
      Case #__Event_Input 
        *this\root\keyboard\input = GetGadTree_GetAttribute(*this\root\canvas\gadget, #PB_Canvas_Input)
      Case #__Event_KeyDown, #__Event_KeyUp
        *this\root\keyboard\Key = GetGadTree_GetAttribute(*this\root\canvas\gadget, #PB_Canvas_Key)
        *this\root\keyboard\Key[1] = GetGadTree_GetAttribute(*this\root\canvas\gadget, #PB_Canvas_Modifiers)
      Case #__Event_MouseEnter, #__Event_MouseMove, #__Event_MouseLeave
        *this\root\mouse\x = GetGadTree_GetAttribute(*this\root\canvas\gadget, #PB_Canvas_MouseX)
        *this\root\mouse\y = GetGadTree_GetAttribute(*this\root\canvas\gadget, #PB_Canvas_MouseY)
        
    EndSelect
    
    mouse_x = *this\root\mouse\x
    mouse_y = *this\root\mouse\y
    
    With *this
      ;       DD::DropStart(_this_)
      ;       Post(#__Event_Drop, DD::DropStop(_this_), _this_\row\index)
      
      Protected enter = Bool(*event\enter <> *this And Not (*event\enter And *event\enter\index > *this\index) And _from_point_(mouse_x, mouse_y, *this))
      Protected leave = Bool(*event\enter And (enter Or (*event\enter = *this And Not _from_point_(mouse_x, mouse_y, *event\enter))))
      
      If leave
        If *event\enter\countitems And *event\enter\row\index >= 0 ;And SelectElement(*event\enter\row\_s(), *event\enter\row\index)
          Result | Tree_Events(*event\enter, #__Event_MouseMove, mouse_x, mouse_y, -1)
        EndIf
        
        ;If Not *event\enter\mouse\buttons
        If Not *this\root\mouse\buttons ; And *event\enter <> *this\parent
          Result | Tree_Events(*event\enter, #__Event_MouseLeave, mouse_x, mouse_y)
          
          If *event\enter And *event\enter\root\canvas\gadget <> *this\root\canvas\gadget
            Tree_ReDraw(*event\enter)
            ; _tree_repaint_(*event\enter)
          EndIf
          
          *event\leave = *event\enter ; надо проверить нужен или нет (а так для них нужен *event\enter <> *this\parent)
        EndIf
        
        ; reset drop start
        CompilerIf Defined(DD, #PB_Module)
          If *event\leave And *event\leave\row\drag
            DD::EventDrop(0, #__Event_MouseLeave)
          EndIf
        CompilerEndIf
        
        *event\enter\row\index =- 1
        *event\enter = 0
      EndIf
      
      If enter
        *event\enter = *this
        
        ; set drop start
        CompilerIf Defined(DD, #PB_Module)
          If *event\leave And *event\leave\row\drag
            DD::EventDrop(*event\enter, #__Event_MouseEnter)
          EndIf
        CompilerEndIf
        
        If Not *this\root\mouse\buttons ; And Not (*event\leave And *event\leave\parent = *this)
          Result | Tree_Events(*event\enter, #__Event_MouseEnter, mouse_x, mouse_y)
          *event\leave = *event\enter
        EndIf
      EndIf
      
      ; set mouse buttons
      If *this = *event\enter 
        If EventType = #__Event_LeftButtonDown
          \root\mouse\buttons | #PB_Canvas_LeftButton
        ElseIf EventType = #__Event_RightButtonDown
          \root\mouse\buttons | #PB_Canvas_RightButton
        ElseIf EventType = #__Event_MiddleButtonDown
          \root\mouse\buttons | #PB_Canvas_MiddleButton
        EndIf
      EndIf
      
      
      If (*this = *event\enter Or *this = *event\leave Or *this = *event\active)
       Result = Tree_Tree_Events(*this, EventType, mouse_x, mouse_y)
      EndIf
      
      
      ; reset mouse buttons
      If \root\mouse\buttons
        If EventType = #__Event_LeftButtonUp
          \root\mouse\buttons &~ #PB_Canvas_LeftButton
        ElseIf EventType = #__Event_RightButtonUp
          \root\mouse\buttons &~ #PB_Canvas_RightButton
        ElseIf EventType = #__Event_MiddleButtonUp
          \root\mouse\buttons &~ #PB_Canvas_MiddleButton
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure g_Tree_CallBack()
    Protected Repaint.b
    Protected EventType.i = EventType()
    Protected *this._s_widget = GetGadgetData(EventGadget())
    
    With *this
      Select EventType
        Case #__Event_Repaint
          \row\count = \countitems
          Repaint = 1
          
        Case #__Event_Resize : ResizeGadget(\root\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Tree_Resize(*this, #PB_Ignore, #PB_Ignore, GadgetWidth(\root\canvas\gadget), GadgetHeight(\root\canvas\gadget))   
          
          If \scroll\v\bar\page\len And \scroll\v\bar\max<>\scroll\height-Bool(\flag\gridlines) And
             bar_SetAttribute(\scroll\v, #__bar_Maximum, \scroll\height-Bool(\flag\gridlines))
            
            Bar_Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
          
          If \scroll\h\bar\page\len And \scroll\h\bar\max<>\scroll\width And
             bar_SetAttribute(\scroll\h, #__bar_Maximum, \scroll\width)
            
            Bar_Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
          
          If \resize = 1<<3
            \width[2] = (\scroll\v\x + Bool(\scroll\v\hide) * \scroll\v\width) - \x[2]
          EndIf 
          
          If \resize = 1<<4
            \height[2] = (\scroll\h\y + Bool(\scroll\h\hide) * \scroll\h\height) - \y[2]
          EndIf
          
          If StartDrawing(CanvasOutput(\root\canvas\gadget))
            Tree_Draw(*this)
            StopDrawing()
          EndIf
      EndSelect
      
      Repaint | Tree_CallBack(*this, EventType)
      
      If Repaint And 
         StartDrawing(CanvasOutput(\root\canvas\gadget))
        ; Debug \root\canvas\gadget
        Tree_Draw(*this)
        StopDrawing()
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected *this._s_widget = Tree(0, 0, Width, Height, Flag)
    
    If *this
      With *this
         *this\root = AllocateStructure(_s_root)
        *this\root\window = GetActiveWindow()
        *this\root\canvas\gadget = Gadget
        GetActive() = *this\root
        GetActive()\root = *this\root
        
        SetGadgetData(Gadget, *this)
        BindGadgetEvent(Gadget, @g_Tree_CallBack())
        ;BindEvent(#PB_Event_Repaint, @w_Tree_CallBack() )
        
        ; z-order
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE, GetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE ) | #WS_CLIPSIBLINGS )
          SetWindowPos_( GadgetID(Gadget), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        CompilerEndIf
        
        _tree_repaint_(*this)
      EndWith
    EndIf
    
    ProcedureReturn Gadget
  EndProcedure
  
  ;-
  Procedure.b Post(eventtype.l, *this._s_widget, item.l=#PB_All, *data=0)
    If *this And *this\event And 
       (*this\event\type = #PB_All Or 
        *this\event\type = eventtype)
      
      *event\widget = *this
      *event\type = eventtype
      *event\data = *data
      *event\item = item
      
      ;If *this\event\callback
      *this\event\Tree_CallBack()
      ;EndIf
      
      *event\widget = 0
      *event\data = 0
      *event\type =- 1
      *event\item =- 1
    EndIf
  EndProcedure
  
  Procedure.b Bind(*this._s_widget, *callBack, eventtype.l=#PB_All)
    *this\event = AllocateStructure(_s_event)
    *this\event\type = eventtype
    *this\event\callback = *callBack
  EndProcedure
  
  Procedure Free(*this._s_widget)
    Protected Gadget = *this\root\canvas\gadget
    
    ClearStructure(*this\scroll\v, _s_bar)
    ClearStructure(*this\scroll\h, _s_bar)
    ClearStructure(*this, _s_widget)
    ; FreeStructure(*this)
    
    If *this = GetGadgetData(Gadget)
      FreeGadget(Gadget)
    EndIf
  EndProcedure
  
EndModule

;-
;- EXAMPLE
;-
CompilerIf #PB_Compiler_IsMainFile
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Procedure GadgetsClipTree_CallBack( GadgetID, lParam )
      If GadgetID
        Protected Gadget = GetProp_( GadgetID, "PB_ID" )
        
        If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
          SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS|#WS_CLIPCHILDREN )
          
          If IsGadget( Gadget ) 
            Select GadgetType( Gadget )
              Case #PB_GadgetType_ComboBox
                Protected Height = GadgetHeight( Gadget )
                
              Case #PB_GadgetType_Text
                If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE) & #SS_NOTIFY) = #False
                  SetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE) | #SS_NOTIFY)
                EndIf
                
              Case #PB_GadgetType_Frame, #PB_GadgetType_Image
                If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                  SetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                EndIf
                
                ; Для панел гаджета темный фон убирать
              Case #PB_GadgetType_Panel 
                If Not IsGadget( Gadget ) And (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                  SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                EndIf
                
            EndSelect
            
            ;             If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
            ;               SetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
            ;             EndIf
          EndIf
          
          
          If Height
            ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
          EndIf
          
          SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        EndIf
        
      EndIf
      
      ProcedureReturn GadgetID
    EndProcedure
  CompilerEndIf
  
  Procedure ClipGadgets( WindowID )
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      WindowID = GetAncestor_( WindowID, #GA_ROOT )
      If Not (GetWindowLongPtr_(WindowID, #GWL_STYLE)&#WS_CLIPCHILDREN)
        SetWindowLongPtr_( WindowID, #GWL_STYLE, GetWindowLongPtr_( WindowID, #GWL_STYLE )|#WS_CLIPCHILDREN )
      EndIf
      EnumChildWindows_( WindowID, @GadgetsClipTree_CallBack(), 0 )
    CompilerEndIf
  EndProcedure
  
  
  UseModule tree
  UseModule constants
  UseModule structures
  
  Global Canvas_0
  Global *g._s_widget
  Global *g0._s_widget
  Global *g1._s_widget
  Global *g2._s_widget
  Global *g3._s_widget
  Global *g4._s_widget
  Global *g5._s_widget
  Global *g6._s_widget
  Global *g7._s_widget
  Global *g8._s_widget
  Global *g9._s_widget
  
  Procedure LoadControls(Widget, Directory$)
    Protected ZipFile$ = Directory$ + "SilkTheme.zip"
    
    If FileSize(ZipFile$) < 1
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        ZipFile$ = #PB_Compiler_Home+"themes\silkTheme.zip"
      CompilerElse
        ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
      CompilerEndIf
      If FileSize(ZipFile$) < 1
        MessageRequester("Designer Error", "Themes\silkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
        End
      EndIf
    EndIf
    ;   Directory$ = GetCurrentDirectory()+"images/" ; "";
    ;   Protected ZipFile$ = Directory$ + "images.zip"
    
    
    If FileSize(ZipFile$) > 0
      UsePNGImageDecoder()
      
      CompilerIf #PB_Compiler_Version > 522
        UseZipPacker()
      CompilerEndIf
      
      Protected PackEntryName.s, ImageSize, *Image, Image, ZipFile
      ZipFile = OpenPack(#PB_Any, ZipFile$, #PB_PackerPlugin_Zip)
      
      If ZipFile  
        If ExaminePack(ZipFile)
          While NextPackEntry(ZipFile)
            
            PackEntryName.S = PackEntryName(ZipFile)
            ImageSize = PackEntrySize(ZipFile)
            If ImageSize
              *Image = AllocateMemory(ImageSize)
              UncompressPackMemory(ZipFile, *Image, ImageSize)
              Image = CatchImage(#PB_Any, *Image, ImageSize)
              PackEntryName.S = ReplaceString(PackEntryName.S,".png","")
              If PackEntryName.S="application_form" 
                PackEntryName.S="vd_windowgadget"
              EndIf
              
              PackEntryName.S = ReplaceString(PackEntryName.S,"page_white_edit","vd_scintillagadget")   ;vd_scintillagadget.png not found. Use page_white_edit.png instead
              
              Select PackEntryType(ZipFile)
                Case #PB_Packer_File
                  If Image
                    If FindString(Left(PackEntryName.S, 3), "vd_")
                      PackEntryName.S = ReplaceString(PackEntryName.S,"vd_"," ")
                      PackEntryName.S = Trim(ReplaceString(PackEntryName.S,"gadget",""))
                      
                      Protected Left.S = UCase(Left(PackEntryName.S,1))
                      Protected Right.S = Right(PackEntryName.S,Len(PackEntryName.S)-1)
                      PackEntryName.S = " "+Left.S+Right.S
                      
                      If IsGadget(Widget)
                        If FindString(LCase(PackEntryName.S), "cursor")
                          
                          ;Debug "add cursor"
                          AddGadgetItem(Widget, 0, PackEntryName.S, ImageID(Image))
                          SetGadgetItemData(Widget, 0, ImageID(Image))
                          
                        ElseIf FindString(LCase(PackEntryName.S), "window")
                          
                          ;Debug "add gadget window"
                          AddGadgetItem(Widget, 1, PackEntryName.S, ImageID(Image))
                          SetGadgetItemData(Widget, 1, ImageID(Image))
                          
                        Else
                          AddGadgetItem(Widget, -1, PackEntryName.S, ImageID(Image))
                          SetGadgetItemData(Widget, CountGadgetItems(Widget)-1, ImageID(Image))
                        EndIf
                        
                      Else
                        If FindString(LCase(PackEntryName.S), "cursor")
                          
                          ;Debug "add cursor"
                          Tree_AddItem(Widget, 0, PackEntryName.S, Image)
                          ;SetItemData(Widget, 0, Image)
                          
                        ElseIf FindString(LCase(PackEntryName.S), "window")
                          
                          Debug "add window"
                          Tree_AddItem(Widget, 1, PackEntryName.S, Image)
                          ;SetItemData(Widget, 1, Image)
                          
                        Else
                          Tree_AddItem(Widget, -1, PackEntryName.S, Image)
                          ;SetItemData(Widget, Tree_CountItems(Widget)-1, Image)
                        EndIf
                      EndIf
                    EndIf
                  EndIf    
              EndSelect
              
              FreeMemory(*Image)
            EndIf
          Wend  
        EndIf
        
        ClosePack(ZipFile)
      EndIf
    EndIf
  EndProcedure
  
  Global g_Canvas, NewList *List._s_widget()
  
  Procedure _Tree_ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
      
      ; PushListPosition(*List())
      ForEach *List()
        If Not *List()\hide
          Tree_Draw(*List())
        EndIf
      Next
      ; PopListPosition(*List())
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i Canvas_Tree_Events()
    Protected Canvas.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadTree_GetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadTree_GetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadTree_GetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    Protected *this._s_widget ; = GetGadgetData(Canvas)
    
    Select EventType
      Case #__Event_Repaint
        *this = EventData()
        
        If *this And *this\handle
          *this\row\count = *this\countitems
          Tree_CallBack(*this, EventType)
          
          If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
            If *event\_draw = 0
              *event\_draw = 1
              FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
            EndIf
            
            Tree_Draw(*this)
            StopDrawing()
          EndIf
          
          ;Tree_ReDraw(*this, $F6)
          ProcedureReturn
        Else
          Repaint = 1
        EndIf
        
      Case #__Event_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Tree_Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #__Event_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      If Not *List()\handle
        DeleteElement(*List())
      EndIf
      
      *List()\root\canvas\gadget = EventGadget()
      *List()\root\window = EventWindow()
      
      Repaint | Tree_CallBack(*List(), EventType);, MouseX, MouseY)
    Next
    
    If Repaint 
      _Tree_ReDraw(Canvas)
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Procedure events_tree_gadget()
    ;Debug " gadget - "+EventGadget()+" "+EventType()
    Protected EventGadget = EventGadget()
    Protected EventType = EventType()
    Protected EventData = EventData()
    Protected EventItem = GetGadTree_GetState(EventGadget)
    
    Select EventType
      Case #__Event_ScrollChange : Debug "gadget scroll change data "+ EventData
      Case #__Event_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #__Event_DragStart : Debug "gadget dragStart item = " + EventItem +" data "+ EventData
      Case #__Event_Change    : Debug "gadget change item = " + EventItem +" data "+ EventData
      Case #__Event_LeftClick : Debug "gadget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  Procedure events_tree_widget()
    ;Debug " widget - "+*event\widget+" "+*event\type
    Protected EventGadget = *event\widget
    Protected EventType = *event\type
    Protected EventData = *event\data
    Protected EventItem = Tree_GetState(EventGadget)
    
    Select EventType
      Case #__Event_ScrollChange : Debug "widget scroll change data "+ EventData
      Case #__Event_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #__Event_DragStart : Debug "widget dragStart item = " + EventItem +" data "+ EventData
      Case #__Event_Change    : Debug "widget change item = " + EventItem +" data "+ EventData
      Case #__Event_LeftClick : Debug "widget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  If OpenWindow(0, 0, 0, 1110, 650, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a,g = 1
    TreeGadget(g, 10, 10, 210, 210, #__tree_AlwaysSelection|#__tree_CheckBoxes)                                         
    ; 1_example
    AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
    AddGadgetItem(g, -1, "Node "+Str(a), ImageID(0), 0)      
    AddGadgetItem(g, -1, "Sub-Item 1", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 2", 0, 11)
    AddGadgetItem(g, -1, "Sub-Item 3", 0, 1)
    AddGadgetItem(g, -1, "Sub-Item 4", 0, 1)         
    AddGadgetItem(g, -1, "Sub-Item 5", 0, 11)
    AddGadgetItem(g, -1, "Sub-Item 6", 0, 1)
    AddGadgetItem(g, -1, "File "+Str(a), 0, 0) 
    For i=0 To CountGadgetItems(g) : SetGadTree_GetItemState(g, i, #__tree_Expanded) : Next
    
    ; RemoveGadgetItem(g,1)
    SetGadTree_GetItemState(g, 1, #__tree_Selected|#__tree_Collapsed|#__tree_Checked)
    ;BindGadgetEvent(g, @Tree_Events())
    
    ;SetActiveGadget(g)
    ;SetGadTree_GetState(g, 1)
    ;     Debug "g "+ GetGadTree_GetText(g)
    
    g = 2
    TreeGadget(g, 230, 10, 210, 210, #__tree_AlwaysSelection)                                         
    ; 3_example
    AddGadgetItem(g, 0, "Tree_0", 0 )
    AddGadgetItem(g, 1, "Tree_1_1", ImageID(0), 1) 
    AddGadgetItem(g, 4, "Tree_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "Tree_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    AddGadgetItem(g, 9, "Tree_2" )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    AddGadgetItem(g, 11, "Tree_4" )
    AddGadgetItem(g, 12, "Tree_5", 0 )
    AddGadgetItem(g, 13, "Tree_6", 0 )
    
    For i=0 To CountGadgetItems(g) : SetGadTree_GetItemState(g, i, #__tree_Expanded) : Next
    
    
    g = 3
    TreeGadget(g, 450, 10, 210, 210, #__tree_AlwaysSelection|#__tree_CheckBoxes |#__tree_NoLines|#__tree_NoButtons | #__tree_ThreeState)                                      
    ;  2_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)",ImageID(0)) 
    For i=1 To 20
      If i=5
        AddGadgetItem(g, -1, "Tree_"+Str(i), 0) 
      Else
        AddGadgetItem(g, -1, "Tree_"+Str(i), ImageID(0)) 
      EndIf
    Next
    For i=0 To CountGadgetItems(g) : SetGadTree_GetItemState(g, i, #__tree_Expanded) : Next
    
    SetGadTree_GetItemState(g, 0, #__tree_Selected|#__tree_Checked)
    SetGadTree_GetItemState(g, 5, #__tree_Selected|#__tree_Inbetween)
    BindGadgetEvent(g, @events_tree_gadget())
    
    
    g = 4
    TreeGadget(g, 670, 10, 210, 210, #__tree_AlwaysSelection|#__tree_NoLines)                                         
    ; 4_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadTree_GetItemState(g, i, #__tree_Expanded) : Next
    
    g = 5
    TreeGadget(g, 890, 10, 103, 210, #__tree_AlwaysSelection|#__tree_NoButtons)                                         
    ; 5_example
    AddGadgetItem(g, 0, "Tree_0",0 )
    AddGadgetItem(g, 1, "Tree_1",0, 0) 
    AddGadgetItem(g, 2, "Tree_2",0, 0) 
    AddGadgetItem(g, 3, "Tree_3",0, 0) 
    AddGadgetItem(g, 0, "Tree_0 (NoButtons)",0 )
    AddGadgetItem(g, 1, "Tree_1",0, 1) 
    AddGadgetItem(g, 2, "Tree_2_1",0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2",0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadTree_GetItemState(g, i, #__tree_Expanded) : Next
    SetGadTree_GetItemImage(g, 0, ImageID(0))
    
    g = 6
    TreeGadget(g, 890+106, 10, 103, 210, #__tree_AlwaysSelection)                                         
    ;  6_example
    AddGadgetItem(g, 0, "Tree_1", 0, 1) 
    AddGadgetItem(g, 0, "Tree_2_1", 0, 2) 
    AddGadgetItem(g, 0, "Tree_2_2", 0, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddGadgetItem(g, -1, "Directory" + Str(i), 0, 0)
      Else
        AddGadgetItem(g, -1, "Item" + Str(i), 0, 1)
      EndIf
    Next i
    
    ;For i=0 To CountGadgetItems(g) : SetGadTree_GetItemState(g, i, #__tree_Expanded) : Next
    
    Define widget = 0
    
    ;If widget
    g_Canvas = CanvasGadget(-1, 0, 225, 1110, 425, #PB_Canvas_Keyboard|#PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Tree_Events())
    ;PostEvent(#PB_Event_Gadget, 0,g_Canvas, #__Event_Resize)
    ;EndIf
    
    g = 10
    
    If widget
      *g = Tree(10, 100, 210, 210, #__tree_CheckBoxes)                                         
      *g\root\canvas\gadget = g_Canvas
      AddElement(*List()) : *List() = *g
    Else
      *g = GetGadgetData(Gadget(g, 10, 100, 210, 210, #__tree_CheckBoxes|#__tree_MultiSelect))
    EndIf
    
    ; 1_example
    Tree_Tree_AddItem(*g, 0, "Normal Item "+Str(a), -1, 0)                                   
    Tree_Tree_AddItem(*g, -1, "Node "+Str(a), 0, 0)                                         
    Tree_Tree_AddItem(*g, -1, "Sub-Item 1", -1, 1)                                           
    Tree_Tree_AddItem(*g, -1, "Sub-Item 2", -1, 11)
    Tree_Tree_AddItem(*g, -1, "Sub-Item 3", -1, 1)
    Tree_Tree_AddItem(*g, -1, "Sub-Item 4", -1, 1)                                           
    Tree_Tree_AddItem(*g, -1, "Sub-Item 5", -1, 11)
    Tree_Tree_AddItem(*g, -1, "Sub-Item 6", -1, 1)
    Tree_Tree_AddItem(*g, -1, "File "+Str(a), -1, 0)  
    ;For i=0 To Tree_CountItems(*g) : Tree_SetItemState(*g, i, #__tree_Expanded) : Next
    
    ; Tree_RemoveItem(*g,1)
    Tree_SetItemState(*g, 1, #__tree_Selected|#__tree_Collapsed|#__tree_Checked)
    ;BindGadgetEvent(g, @Tree_Events())
    ;     Tree_SetState(*g, 3)
    ;     Tree_SetState(*g, -1)
    ;Debug " - "+Tree_GetText(*g)
    LoadFont(3, "Arial", 18)
    Tree_SetFont(*g, 3)
    
    g = 11
    If widget
      *g = Tree(230, 100, 210, 210, #__tree_AlwaysSelection);|#__tree_Collapsed)                                         
      *g\root\canvas\gadget = g_Canvas
      AddElement(*List()) : *List() = *g
    Else
      *g = GetGadgetData(Gadget(g, 160, 120, 210, 210, #__tree_AlwaysSelection))
    EndIf
    
    ;  3_example
    Tree_AddItem(*g, 0, "Tree_0", -1 )
    Tree_AddItem(*g, 1, "Tree_1_1", 0, 1) 
    Tree_AddItem(*g, 4, "Tree_1_1_1", -1, 2) 
    Tree_AddItem(*g, 5, "Tree_1_1_2", -1, 2) 
    Tree_AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    Tree_AddItem(*g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
    Tree_AddItem(*g, 7, "Tree_1_1_2_2 980980_", -1, 3) 
    Tree_AddItem(*g, 2, "Tree_1_2", -1, 1) 
    Tree_AddItem(*g, 3, "Tree_1_3", -1, 1) 
    Tree_AddItem(*g, 9, "Tree_2",-1 )
    Tree_AddItem(*g, 10, "Tree_3", -1 )
    Tree_AddItem(*g, 11, "Tree_4", -1 )
    Tree_AddItem(*g, 12, "Tree_5", -1 )
    Tree_AddItem(*g, 13, "Tree_6", -1 )
    
    g = 12
    *g = Tree(450, 100, 210, 210, #__tree_CheckBoxes|#__tree_NoLines|#__tree_NoButtons|#__tree_GridLines | #__tree_ThreeState | #__tree_OptionBoxes)                            
     *g\root = AllocateStructure(_s_root)
       *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  2_example
    Tree_Tree_AddItem(*g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5 ;Or i%3=0
        Tree_AddItem(*g, -1, "Tree_"+Str(i), -1, 0) 
      Else
        Tree_AddItem(*g, -1, "Tree_"+Str(i), 0, -1) 
      EndIf
    Next
    ;For i=0 To Tree_CountItems(*g) : Tree_SetItemState(*g, i, #__tree_Expanded) : Next
    Tree_SetItemState(*g, 0, #__tree_Selected|#__tree_Checked)
    Tree_SetItemState(*g, 5, #__tree_Selected|#__tree_Inbetween)
    
    LoadFont(5, "Arial", 16)
    Tree_SetItemFont(*g, 3, 5)
    Tree_SetItemText(*g, 3, "16_font and text change")
    Tree_SetItemColor(*g, 5, #__color_front, $FFFFFF00)
    Tree_SetItemColor(*g, 5, #__color_back, $FFFF00FF)
    Tree_SetItemText(*g, 5, "backcolor and text change")
    LoadFont(6, "Arial", 25)
    Tree_SetItemFont(*g, 4, 6)
    Tree_SetItemText(*g, 4, "25_font and text change")
    Tree_SetItemFont(*g, 14, 6)
    Tree_SetItemText(*g, 14, "25_font and text change")
    Bind(*g, @events_tree_widget())
    
    g = 13
    *g = Tree(600+70, 100, 210, 210, #__tree_OptionBoxes|#__tree_NoButtons|#__tree_NoLines|#__tree_ClickSelect) ;                                        
    *g\root = AllocateStructure(_s_root)
     *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  4_example
    ; ;     Tree_AddItem(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    ; ;     Tree_AddItem(*g, 1, "Tree_1", -1, 1) 
    ; ;     Tree_AddItem(*g, 2, "Tree_2_2", -1, 2) 
    ; ;     Tree_AddItem(*g, 2, "Tree_2_1", -1, 1) 
    ; ;     Tree_AddItem(*g, 3, "Tree_3_1", -1, 1) 
    ; ;     Tree_AddItem(*g, 3, "Tree_3_2", -1, 2) 
    ; ;     For i=0 To Tree_CountItems(*g) : Tree_SetItemState(*g, i, #__tree_Expanded) : Next
    Tree_Tree_AddItem(*g, -1, "#PB_Window_MinimizeGadget", -1) ; Adds the minimize gadget To the window title bar. Tree_Tree_AddItem(*g, -1, "#PB_Window_SystemMenu is automatically added.
    Tree_Tree_AddItem(*g, -1, "#PB_Window_MaximizeGadget", -1) ; Adds the maximize gadget To the window title bar. Tree_Tree_AddItem(*g, -1, "#PB_Window_SystemMenu is automatically added.
                                                      ;                              (MacOS only", -1) ; Tree_Tree_AddItem(*g, -1, "#PB_Window_SizeGadget", -1) ; will be also automatically added", -1).
    Tree_Tree_AddItem(*g, -1, "#PB_Window_SizeGadget    ", -1) ; Adds the sizeable feature To a window.
    Tree_Tree_AddItem(*g, -1, "#PB_Window_Invisible     ", -1) ; Creates the window but don't display.
    Tree_Tree_AddItem(*g, -1, "#PB_Window_SystemMenu    ", -1) ; Enables the system menu on the window title bar (Default", -1).
    Tree_Tree_AddItem(*g, -1, "#PB_Window_TitleBar      ", -1,1) ; Creates a window With a titlebar.
    Tree_Tree_AddItem(*g, -1, "#PB_Window_Tool          ", -1,1) ; Creates a window With a smaller titlebar And no taskbar entry. 
    Tree_Tree_AddItem(*g, -1, "#PB_Window_BorderLess    ", -1,1) ; Creates a window without any borders.
    Tree_Tree_AddItem(*g, -1, "#PB_Window_ScreenCentered", -1)   ; Centers the window in the middle of the screen. x,y parameters are ignored.
    Tree_Tree_AddItem(*g, -1, "#PB_Window_WindowCentered", -1)   ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified", -1). x,y parameters are ignored.
    Tree_Tree_AddItem(*g, -1, "#PB_Window_Maximize      ", -1, 1); Opens the window maximized. (Note", -1) ; on Linux, Not all Windowmanagers support this", -1)
    Tree_Tree_AddItem(*g, -1, "#PB_Window_Minimize      ", -1, 1); Opens the window minimized.
    Tree_Tree_AddItem(*g, -1, "#PB_Window_NoGadgets     ", -1)   ; Prevents the creation of a GadgetList. UseGadgetList(", -1) can be used To do this later.
    Tree_Tree_AddItem(*g, -1, "#PB_Window_NoActivate    ", -1)   ; Don't activate the window after opening.
    
    
    
    g = 14
    *g = Tree(750+135, 100, 103, 210, #__tree_NoButtons)                                         
    *g\root = AllocateStructure(_s_root)
     *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  5_example
    Tree_AddItem(*g, 0, "Tree_0", -1 )
    Tree_AddItem(*g, 1, "Tree_1", -1, 0) 
    Tree_AddItem(*g, 2, "Tree_2", -1, 0) 
    Tree_AddItem(*g, 3, "Tree_3", -1, 0) 
    Tree_AddItem(*g, 0, "Tree_0 (NoButtons)", -1 )
    Tree_AddItem(*g, 1, "Tree_1", -1, 1) 
    Tree_AddItem(*g, 2, "Tree_2_1", -1, 1) 
    Tree_AddItem(*g, 2, "Tree_2_2", -1, 2) 
    For i=0 To Tree_CountItems(*g) : Tree_SetItemState(*g, i, #__tree_Expanded) : Next
    Tree_SetItemImage(*g, 0, 0)
    
    g = 15
    *g = Tree(890+106, 100, 103, 210, #__tree_BorderLess|#__tree_Collapse)                                         
    *g\root = AllocateStructure(_s_root)
     *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  6_example
    Tree_AddItem(*g, 0, "Tree_1", -1, 1) 
    Tree_AddItem(*g, 0, "Tree_2_1", -1, 2) 
    Tree_AddItem(*g, 0, "Tree_2_2", -1, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        Tree_AddItem(*g, -1, "Directory" + Str(i), -1, 0)
      Else
        Tree_AddItem(*g, -1, "Item" + Str(i), -1, 1)
      EndIf
    Next i
    
    ; Free(*g)
    ;ClipGadgets( UseGadgetList(0) )
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          CloseWindow(EventWindow()) 
          Break
      EndSelect
    ForEver
  EndIf
CompilerEndIf

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Tree
  CompilerIf Defined(DD, #PB_Module)
    UseModule DD
  CompilerEndIf
  ;
  ; ------------------------------------------------------------
  ;
  ;   PureBasic - Drag & Drop
  ;
  ;    (c) Fantaisie Software
  ;
  ; ------------------------------------------------------------
  ;
  
  #Window = 0
  
  Enumeration    ; Images
    #ImageSource
    #ImageTarget
  EndEnumeration
  
  Global SourceText,
         SourceImage,
         SourceFiles,
         SourcePrivate,
         TargetText,
         TargetImage,
         TargetFiles,
         TargetPrivate1,
         TargetPrivate2
  
  Global g_Canvas, *g._s_widget, NewList *List._s_widget()
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Procedure Tree_Events()
    Protected EventGadget.i, EventType.i, EventItem.i, EventData.i
    
    EventGadget = *event\widget ; Widget()
    EventType = *event\type     ; Type()
    EventItem = *event\item     ; Item()
    EventData = *event\data     ; Data()
    
    Protected i, Text$, Files$, Count
    ;Debug "     "+EventType
    ; DragStart event on the source s, initiate a drag & drop
    ;
    Select EventType
      Case #__Event_DragStart
        Select EventGadget
            
          Case SourceText
            Text$ = Tree_GetItemText(SourceText, Tree_GetState(SourceText))
            DragText(Text$)
            
            ;           Case SourceImage
            ;             DragImage((#ImageSource))
            ;             
            ;           Case SourceFiles
            ;             Files$ = ""       
            ;             For i = 0 To Tree_CountItems(SourceFiles)-1
            ;               If Tree_GetItemState(SourceFiles, i) & #PB_Explorer_Selected
            ;                 Files$ + Tree_GetText(SourceFiles) + Tree_GetItemText(SourceFiles, i) + Chr(10)
            ;               EndIf
            ;             Next i 
            ;             If Files$ <> ""
            ;               DragFiles(Files$)
            ;             EndIf
            ;             
            ;             ; "Private" Drags only work within the program, everything else
            ;             ; also works with other applications (Explorer, Word, etc)
            ;             ;
            ;           Case SourcePrivate
            ;             If Tree_GetState(SourcePrivate) = 0
            ;               DragPrivate(1)
            ;             Else
            ;               DragPrivate(2)
            ;             EndIf
            
        EndSelect
        
        ; Drop event on the target gadgets, receive the dropped data
        ;
      Case #__Event_Drop
        
        Select EventGadget
            
          Case TargetText
            Tree_AddItem(TargetText, -1, EventDropText())
            
            ;           Case TargetImage
            ;             If DropImage(#ImageTarget)
            ;               Tree_SetState(TargetImage, (#ImageTarget))
            ;             EndIf
            ;             
            ;           Case TargetFiles
            ;             Files$ = EventDropFiles()
            ;             Count  = CountString(Files$, Chr(10)) + 1
            ;             For i = 1 To Count
            ;               Tree_AddItem(TargetFiles, -1, StringField(Files$, i, Chr(10)))
            ;             Next i
            ;             
            ;           Case TargetPrivate1
            ;             Tree_AddItem(TargetPrivate1, -1, "Private type 1 dropped")
            ;             
            ;           Case TargetPrivate2
            ;             Tree_AddItem(TargetPrivate2, -1, "Private type 2 dropped")
            
        EndSelect
        
    EndSelect
    
  EndProcedure
  
  If OpenWindow(#Window, 0, 0, 760, 310, "Drag & Drop", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    
    g_Canvas = CanvasGadget(0, 0, 0, 760, 310, #PB_Canvas_Keyboard|#PB_Canvas_Container);, @Canvas_Tree_Events())
    BindGadgetEvent(g_Canvas, @Canvas_Tree_Events())
    
    ; create some images for the image demonstration
    ; 
    Define i, Event
    CreateImage(#ImageSource, 136, 136)
    If StartDrawing(ImageOutput(#ImageSource))
      Box(0, 0, 136, 136, $FFFFFF)
      DrawText(5, 5, "Drag this image", $000000, $FFFFFF)        
      For i = 45 To 1 Step -1
        Circle(70, 80, i, Random($FFFFFF))
      Next i        
      
      StopDrawing()
    EndIf  
    
    CreateImage(#ImageTarget, 136, 136)
    If StartDrawing(ImageOutput(#ImageTarget))
      Box(0, 0, 136, 136, $FFFFFF)
      DrawText(5, 5, "Drop images here", $000000, $FFFFFF)
      StopDrawing()
    EndIf  
    
    
    ; create and fill the source s
    ;
    SourceText = Tree(10, 10, 140, 140);, "Drag Text here", 130)   
    *g = SourceText
    *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;SourceImage = Image(160, 10, 140, 140, (#ImageSource), #PB_Image_Border) 
    ;SourceFiles = ExplorerList(310, 10, 290, 140, GetHomeDirectory(), #PB_Explorer_MultiSelect)
    ;SourcePrivate = ListIcon(610, 10, 140, 140, "Drag private stuff here", 260)
    
    Tree_AddItem(SourceText, -1, "hello world")
    Tree_AddItem(SourceText, -1, "The quick brown fox jumped over the lazy dog")
    Tree_AddItem(SourceText, -1, "abcdefg")
    Tree_AddItem(SourceText, -1, "123456789")
    
    ;     Tree_AddItem(SourcePrivate, -1, "Private type 1")
    ;     Tree_AddItem(SourcePrivate, -1, "Private type 2")
    
    
    ; create the target s
    ;
    TargetText = Tree(10, 160, 140, 140);, "Drop Text here", 130)
    *g = TargetText
    *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    
    TargetImage = Tree(160, 160, 140, 140);, (#ImageTarget), #PB_Image_Border) 
    *g = TargetImage
    *g\root\canvas\gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    
    ;     TargetFiles = ListIcon(310, 160, 140, 140, "Drop Files here", 130)
    ;     TargetPrivate1 = ListIcon(460, 160, 140, 140, "Drop Private Type 1 here", 130)
    ;     TargetPrivate2 = ListIcon(610, 160, 140, 140, "Drop Private Type 2 here", 130)
    
    
    ; Now enable the dropping on the target s
    ;
    CompilerIf Defined(DD, #PB_Module)
      EnableDrop(TargetText,     #PB_Drop_Text,    #PB_Drag_Copy)
      ;     EnableDrop(TargetImage,    #PB_Drop_Image,   #PB_Drag_Copy)
      ;     EnableDrop(TargetFiles,    #PB_Drop_Files,   #PB_Drag_Copy)
      ;     EnableDrop(TargetPrivate1, #PB_Drop_Private, #PB_Drag_Copy, 1)
      ;     EnableDrop(TargetPrivate2, #PB_Drop_Private, #PB_Drag_Copy, 2)
    CompilerEndIf
    
    Bind(SourceText, @Tree_Events(), #__Event_DragStart)
    Bind(TargetText, @Tree_Events(), #__Event_Drop)
    
    ;     Bind(@Tree_Events())
    ;     Tree_ReDraw(Root())
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
  
  End
CompilerEndIf
; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 1197
; FirstLine = 1167
; Folding = -------------------------------------------------------------------------------
; EnableXP