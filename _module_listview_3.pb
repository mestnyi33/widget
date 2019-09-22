
DeclareModule Macros
  Macro StartDrawingCanvas(_canvas_)
    Bool(IsGadget(_canvas_) And StartDrawing(CanvasOutput(_canvas_)))
  EndMacro
  
  Macro StopDrawingCanvas()
    Bool(ListSize(List()) And IsGadget(List()\Widget\Canvas\Gadget) And Not StopDrawing())
  EndMacro
  
  Macro From(_this_, _buttons_=0)
    Bool(_this_\Canvas\Mouse\X>=_this_\x[_buttons_] And _this_\Canvas\Mouse\X<_this_\x[_buttons_]+_this_\Width[_buttons_] And 
         _this_\Canvas\Mouse\Y>=_this_\y[_buttons_] And _this_\Canvas\Mouse\Y<_this_\y[_buttons_]+_this_\Height[_buttons_])
  EndMacro
  
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
        List()\Widget\Index = ListIndex(List())
      Wend
      PopListPosition(List())
    EndIf
  EndMacro
  
  Macro _clip_output_(_this_, _x_,_y_,_width_,_height_)
    If _x_<>#PB_Ignore : _this_\Clip\X = _x_ : EndIf
    If _y_<>#PB_Ignore : _this_\Clip\Y = _y_ : EndIf
    If _width_<>#PB_Ignore : _this_\Clip\Width = _width_ : EndIf
    If _height_<>#PB_Ignore : _this_\Clip\Height = _height_ : EndIf
    
    CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
      ClipOutput(_this_\Clip\X,_this_\Clip\Y,_this_\Clip\Width,_this_\Clip\Height)
    CompilerEndIf
  EndMacro
  
  Macro _frame_(_this_, _x_,_y_,_width_,_height_, _color_1_, _color_2_);, _radius_=0)
    ClipOutput(_x_-1,_y_-1,_width_+1,_height_+1)
    RoundBox(_x_-1,_y_-1,_width_+2,_height_+2, _this_\Radius,_this_\Radius, _color_1_)  
    
    ClipOutput(_x_+_this_\Radius/3,_y_+_this_\Radius/3,_width_+2,_height_+2)
    RoundBox(_x_-1,_y_-1,_width_+2,_height_+2,_this_\Radius,_this_\Radius, _color_2_)  
    
;     If _radius_ And _this_\Radius : RoundBox(_x_,_y_-1,_width_,_height_+1,_this_\Radius,_this_\Radius,_color_1_) : EndIf  ; Сглаживание краев )))
;     If _radius_ And _this_\Radius : RoundBox(_x_-1,_y_-1,_width_+1,_height_+1,_this_\Radius,_this_\Radius,_color_1_) : EndIf  ; Сглаживание краев )))
    
    UnclipOutput() : _clip_output_(_this_, _this_\X[1]-1,_this_\Y[1]-1,_this_\Width[1]+2,_this_\Height[1]+2)
  EndMacro
  
  Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  EndMacro
  
  Macro _colors_(_adress_, _i_, _ii_, _iii_)
    ; Debug ""+_i_+" "+ _ii_+" "+ _iii_
    
    If _adress_\Color[_i_]\Line[_ii_]
      _adress_\Color[_i_]\Line[_iii_] = _adress_\Color[_i_]\Line[_ii_]
    Else
      _adress_\Color[_i_]\Line[_iii_] = _adress_\Color\Line[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Fore[_ii_]
      _adress_\Color[_i_]\Fore[_iii_] = _adress_\Color[_i_]\Fore[_ii_]
    Else
      _adress_\Color[_i_]\Fore[_iii_] = _adress_\Color\Fore[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Back[_ii_]
      _adress_\Color[_i_]\Back[_iii_] = _adress_\Color[_i_]\Back[_ii_]
    Else
      _adress_\Color[_i_]\Back[_iii_] = _adress_\Color\Back[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Front[_ii_]
      _adress_\Color[_i_]\Front[_iii_] = _adress_\Color[_i_]\Front[_ii_]
    Else
      _adress_\Color[_i_]\Front[_iii_] = _adress_\Color\Front[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Frame[_ii_]
      _adress_\Color[_i_]\Frame[_iii_] = _adress_\Color[_i_]\Frame[_ii_]
    Else
      _adress_\Color[_i_]\Frame[_iii_] = _adress_\Color\Frame[_ii_]
    EndIf
  EndMacro
  
  Macro ResetColor(_adress_)
    
    _colors_(_adress_, 0, 1, 0)
    
    _colors_(_adress_, 1, 1, 0)
    _colors_(_adress_, 2, 1, 0)
    _colors_(_adress_, 3, 1, 0)
    
    _colors_(_adress_, 1, 1, 1)
    _colors_(_adress_, 2, 1, 1)
    _colors_(_adress_, 3, 1, 1)
    
    _colors_(_adress_, 1, 2, 2)
    _colors_(_adress_, 2, 2, 2)
    _colors_(_adress_, 3, 2, 2)
    
    _colors_(_adress_, 1, 3, 3)
    _colors_(_adress_, 2, 3, 3)
    _colors_(_adress_, 3, 3, 3)
    
  EndMacro
  
  Macro Distance(_mouse_x_, _mouse_y_, _position_x_, _position_y_, _radius_)
    Bool(Sqr(Pow(((_position_x_+_radius_) - _mouse_x_),2) + Pow(((_position_y_+_radius_) - _mouse_y_),2)) =< _radius_)
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
  
  Macro _set_scroll_width_(_this_)
    If Not _this_\hide And Not _this_\Items()\hide And _this_\Scroll\width<(_this_\Items()\text\x+_this_\Items()\text\width)-_this_\x
      _this_\scroll\width=(_this_\Items()\text\x+_this_\Items()\text\width)-_this_\x
    ; Debug "   "+_this_\width +" "+ _this_\scroll\width
    EndIf
  EndMacro
  
  ; val = %10011110
  ; Debug Bin(GetBits(val, 0, 3))
  
EndDeclareModule 

Module Macros
  
EndModule 

UseModule Macros


DeclareModule Constants
  #VectorDrawing = 0
  
  ;CompilerIf #VectorDrawing
  ;  UseModule Draw
  ;CompilerEndIf
  
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf #PB_Compiler_Version =< 546
      #PB_EventType_Resize
    CompilerEndIf
    #PB_EventType_Free
    #PB_EventType_Create
    
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
  EndEnumeration
  
  EnumerationBinary WidgetFlags
;     #PB_Text_Center
;     #PB_Text_Right
    #PB_Text_Left = 4
    #PB_Text_Bottom
    #PB_Text_Middle 
    #PB_Text_Top
    
    #PB_Text_Numeric
    #PB_Text_ReadOnly
    #PB_Text_LowerCase 
    #PB_Text_UpperCase
    #PB_Text_Password
    #PB_Text_WordWrap
    #PB_Text_MultiLine 
     
    #PB_Text_Reverse ; Mirror
    #PB_Text_InLine
    
    #PB_Flag_Vertical
    #PB_Flag_BorderLess
    #PB_Flag_Double
    #PB_Flag_Flat
    #PB_Flag_Raised
    #PB_Flag_Single
    
    #PB_Flag_Default
    #PB_Flag_Toggle
    
    #PB_Flag_GridLines
    #PB_Flag_Invisible
    
    #PB_Flag_MultiSelect
    #PB_Flag_ClickSelect
    
    #PB_Flag_AutoSize
    #PB_Flag_AutoRight
    #PB_Flag_AutoBottom
    
    ; #____End____
  EndEnumeration
  
  #PB_Flag_Numeric = #PB_Text_Numeric
  #PB_Flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #PB_Flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  
  #PB_Flag_CheckBoxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
  #PB_Flag_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
    
  #PB_Flag_AlwaysSelection = 32 ; #PB_Tree_AlwaysShowSelection ; 0 32 Even If the gadget isn't activated, the selection is still visible.
  #PB_Flag_FullSelection = 512 ; #PB_ListIcon_FullRowSelect
  
  #PB_Attribute_Selected = #PB_Tree_Selected                       ; 1
  #PB_Attribute_Expanded = #PB_Tree_Expanded                       ; 2
  #PB_Attribute_Checked = #PB_Tree_Checked                         ; 4
  #PB_Attribute_Collapsed = #PB_Tree_Collapsed                     ; 8
  
  #PB_Attribute_SmallIcon = #PB_ListIcon_LargeIcon                 ; 0 0
  #PB_Attribute_LargeIcon = #PB_ListIcon_SmallIcon                 ; 1 1
  
  #PB_Attribute_Numeric = 1
;   #PB_Text_Left = ~#PB_Text_Center
;   #PB_Text_Top = ~#PB_Text_Middle
;   
   EnumerationBinary WidgetFlags
      #PB_Flag_Limit
    EndEnumeration
    
    If (#PB_Flag_Limit>>1) > 2147483647 ; 8589934592
    Debug "Исчерпан лимит в x32 ("+Str(#PB_Flag_Limit>>1)+")"
  EndIf
  
  #PB_Gadget_FrameColor = 10
  
EndDeclareModule 

Module Constants
  
EndModule 

UseModule Constants
    
DeclareModule Structures
  
  ;- STRUCTURE
  ;- - _S_color
  Structure _S_color
    State.b
    Front.i[4]
    Fore.i[4]
    Back.i[4]
    Line.i[4]
    Frame.i[4]
    Arrows.i[4]
    Alpha.a[2]
    
  EndStructure
  
  Structure Point_S
    y.i
    x.i
  EndStructure
  
  ;- - _S_coordinate
  Structure _S_coordinate
    y.i[5]
    x.i[5]
    height.i[5]
    width.i[5]
  EndStructure
  
  Structure Mouse_S
    X.i
    Y.i
    From.i ; at point widget
    Buttons.i
    *Delta.Mouse_S
  EndStructure
  
  Structure Align_S
    Right.b
    Bottom.b
    Vertical.b
    Horizontal.b
  EndStructure
  
  Structure Page_S
    Pos.i
    Length.i
    ScrollStep.i
  EndStructure
  
  Structure Flag_S
    InLine.b
    Lines.b
    Buttons.b
    GridLines.b
    CheckBoxes.b
    FullSelection.b
    AlwaysSelection.b
    MultiSelect.b
    ClickSelect.b
  EndStructure
  
  Structure Image_S Extends _S_coordinate
    handle.i[2]
    change.b
    Align.Align_S
  EndStructure
  
  Structure Text_S Extends _S_coordinate
    ;     Char.c
    Len.i
    FontID.i
    String.s[3]
    Count.i[2]
    Change.b
    Position.i
    
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    MultiLine.b
    Vertical.b
    Rotate.f
    
    Align.Align_S
  EndStructure
  
  Structure _S_Bar Extends _S_coordinate
    Window.i
    Gadget.i
    
    Both.b ; we see both scrolbars
    
    Size.i[4]
    Type.i[4]
    Focus.i
    from.l
    Radius.i
    
    Hide.b[2]
    Alpha.a[2]
    Disable.b[2]
    Vertical.b
    DrawingMode.i
    
    Max.i
    Min.i
    Page.Page_S
    Area.Page_S
    Thumb.Page_S
    Button.Page_S
    Color._S_color[4]
  EndStructure
  
  Structure Scrolls_S Extends _S_coordinate
    Orientation.b
    *v._S_Bar
    *h._S_Bar
  EndStructure
  
  Structure Canvas_S
    Mouse.Mouse_S
    Gadget.i
    Window.i
    Widget.i
    
    Input.c
    Key.i[2]
  EndStructure
  
  
  ;- - _S_image
  Structure _S_image Extends _S_coordinate
    index.l
    handle.i
    change.b
;     Align._S_align
  EndStructure
  
  ;- - _S_text
  Structure _S_text Extends _S_coordinate
    ;     Char.c
    Len.i
    FontID.i
    String.s[3]
    Count.i[2]
    Change.b
    Position.i
    
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    MultiLine.b
    Vertical.b
    Rotate.f
    
;     Align._S_align
  EndStructure
  
  ;- - _S_box
  Structure _S_box
    y.i;[4]
    x.i;[4]
    height.i;[4]
    width.i ;[4]
    
    ;     size.i;[4]
    ;     hide.b;[4]
    checked.b;[2] 
             ;     ;toggle.b
             ;     
             ;     arrow_size.a;[3]
             ;     arrow_type.b;[3]
             ;     
             ;     threeState.b
             ;     *color._S_color;[4]
  EndStructure
  
  ;- - _S_button
  Structure _S_button Extends _S_coordinate
    len.a
    interact.b
    arrow_size.a
    arrow_type.b
  EndStructure
  
  ;- - _S_splitter
  Structure _S_splitter
    *first;._S_bar
    *second;._S_bar
    
    fixed.l[3]
    
    g_first.b
    g_second.b
  EndStructure
  
  ;- - _S_Items
  Structure _S_items Extends _S_coordinate
    index.l
    sublevel.l[3]
    childrens.l
    
    text._S_text
    color._S_color
    
    box._S_box[2]
    image._S_image
    *parent._S_items
    
    draw.b
    hide.b
    radius.a
    change.b
    
    *data      ; set/get item data
  EndStructure
  
  Structure _S_columns Extends _S_coordinate
    Index.i  ; Index of new list element
    Handle.i ; Adress of new list element
             ;
    
    *Widget._S_widget
    Canvas.Canvas_S
    Color._S_color;[4]
    Text.Text_S;[1]
    ;Clip._S_coordinate
    *ToolTip.Text_S
    
    Scroll.Scrolls_S
    
    Image._S_Image
    box._S_box[2]
    Flag.Flag_S
    
    
    bs.b
    fs.b[2]
    
    Hide.b[2]
;     Disable.b[2]
;     Cursor.i[2]
    
    ;Caret.i[3] ; 0 = Pos ; 1 = PosFixed
    Line.i[2]  ; 0 = Pos ; 1 = PosFixed
    
    
    Type.i
    
    From.i  ; at point widget | item
    Focus.i
    LostFocus.i
    
    Drag.b[2]
    Resize.b ; 
    Toggle.b ; 
    ;Checked.b;[2]
    Vertical.b
    Interact.b ; будет ли взаимодействовать с пользователем?
    Radius.i
    Buttons.i
    
    
    ; tree
   ; time.i
    *parent._S_items
    
    sublevel.i[3]
    ;sublevellen.i
    ;sublevelpos.i
    
    *Data
    ;collapsed.b
    childrens.i
    ;Item.i
    Attribute.i
    change.b
    
    
    *Default
    ;Alpha.a[2]
    
    ;DrawingMode.i
    
    *_i_selected._S_items
    List Items._S_items()

    ;ColumnWidth.i
  EndStructure
  
  Structure _S_widget Extends _S_coordinate
    Index.i  ; Index of new list element
    Handle.i ; Adress of new list element
             ;
    
    *Widget._S_widget
    Canvas.Canvas_S
    Color._S_color;[4]
    Text.Text_S;[1]
    ;Clip._S_coordinate
    *ToolTip.Text_S
    
    Scroll.Scrolls_S
    
    Image._S_Image
    box._S_box[2]
    Flag.Flag_S
    
    
    bs.b
    fs.b[2]
    
    Hide.b[2]
;     Disable.b[2]
;     Cursor.i[2]
    
    ;Caret.i[3] ; 0 = Pos ; 1 = PosFixed
    Line.i[2]  ; 0 = Pos ; 1 = PosFixed
    
    
    Type.i
    
    From.i  ; at point widget | item
    Focus.i
    LostFocus.i
    
    Drag.b[2]
    Resize.b ; 
    Toggle.b ; 
    ;Checked.b;[2]
    Vertical.b
    Interact.b ; будет ли взаимодействовать с пользователем?
    Radius.i
    Buttons.i
    
    
    ; tree
   ; time.i
    *parent._S_items
    
    sublevel.i[3]
    ;sublevellen.i
    ;sublevelpos.i
    
    *Data
    ;collapsed.b
    childrens.i
    ;Item.i
    Attribute.i
    change.b
    
    
    *Default
    ;Alpha.a[2]
    
    ;DrawingMode.i
    
    *_i_selected._S_items
    List Items._S_items()
    List Columns._S_columns()
    ;ColumnWidth.i
  EndStructure
  
  ; $FF24B002 ; $FFD5A719 ; $FFE89C3D ; $FFDE9541 ; $FFFADBB3 ;
  Global Colors._S_color
  With Colors                          
    \State = 0
    
    ;     ;- Серые цвета 
    ;     ; Цвета по умолчанию
    ;     \Front[0] = $FF000000
    ;     \Fore[0] = $FFFCFCFC ; $FFF6F6F6 
    ;     \Back[0] = $FFE2E2E2 ; $FFE8E8E8 ; 
    ;     \Line[0] = $FFA3A3A3
    ;     \Frame[0] = $FFA5A5A5 ; $FFBABABA
    ;     
    ;     ; Цвета если мышь на виджете
    ;     \Front[1] = $FF000000
    ;     \Fore[1] = $FFF5F5F5 ; $FFF5F5F5 ; $FFEAEAEA
    ;     \Back[1] = $FFCECECE ; $FFEAEAEA ; 
    ;     \Line[1] = $FF5B5B5B
    ;     \Frame[1] = $FF8F8F8F
    ;     
    ;     ; Цвета если нажали на виджет
    ;     \Front[2] = $FFFFFFFF
    ;     \Fore[2] = $FFE2E2E2
    ;     \Back[2] = $FFB4B4B4
    ;     \Line[2] = $FFFFFFFF
    ;     \Frame[2] = $FF6F6F6F
    
    ;             ;- Зеленые цвета
    ;             ; Цвета по умолчанию
    ;             \Front[0] = $FF000000
    ;             \Fore[0] = $FFFFFFFF
    ;             \Back[0] = $FFDAFCE1  
    ;             \Frame[0] = $FF6AFF70 
    ;             
    ;             ; Цвета если мышь на виджете
    ;             \Front[1] = $FF000000
    ;             \Fore[1] = $FFE7FFEC
    ;             \Back[1] = $FFBCFFC5
    ;             \Frame[1] = $FF46E064 ; $FF51AB50
    ;             
    ;             ; Цвета если нажали на виджет
    ;             \Front[2] = $FFFEFEFE
    ;             \Fore[2] = $FFC3FDB7
    ;             \Back[2] = $FF00B002
    ;             \Frame[2] = $FF23BE03
    
    ;- Синие цвета
    ; Цвета по умолчанию
    \Front[0] = $80000000
    \Fore[0] = $FFF8F8F8 
    \Back[0] = $80E2E2E2
    \Frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \Front[1] = $80000000
    \Fore[1] = $FFFAF8F8
    \Back[1] = $80FCEADA
    \Frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \Front[2] = $FFFEFEFE
    \Fore[2] = $C8E9BA81;$C8FFFCFA
    \Back[2] = $C8E89C3D ; $80E89C3D
    \Frame[2] = $C8DC9338; $80DC9338
    
    ;         ;- Синие цвета 2
    ;         ; Цвета по умолчанию
    ;         \Front[0] = $FF000000
    ;         \Fore[0] = $FFF8F8F8 ; $FFF0F0F0 
    ;         \Back[0] = $FFE5E5E5
    ;         \Frame[0] = $FFACACAC 
    ;         
    ;         ; Цвета если мышь на виджете
    ;         \Front[1] = $FF000000
    ;         \Fore[1] = $FFFAF8F8 ; $FFFCF4EA
    ;         \Back[1] = $FFFAE8DB ; $FFFCECDC
    ;         \Frame[1] = $FFFC9F00
    ;         
;             ; Цвета если нажали на виджет
;             \Front[2] = $FF000000;$FFFFFFFF
;             \Fore[2] = $FFFDF7EF
;             \Back[2] = $FFFBD9B7
;             \Frame[2] = $FFE59B55
    
  EndWith
  
  Global *Focus._S_widget
  Global NewList List._S_widget()
  Global Use_List_Canvas_Gadget
  
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Structures

DeclareModule Bar
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  Macro x(_this_)
    _this_\x+Bool(_this_\hide[1] Or Not _this_\alpha)*_this_\width
  EndMacro
  Macro y(_this_)
    _this_\y+Bool(_this_\hide[1] Or Not _this_\alpha)*_this_\height
  EndMacro
  Macro width(_this_)
    Bool(Not _this_\hide[1] And _this_\alpha)*_this_\width
  EndMacro
  Macro height(_this_)
    Bool(Not _this_\hide[1] And _this_\alpha)*_this_\height
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\Length / (_this_\Max-_this_\Min)), #PB_Round_Nearest)) : If _this_\Vertical : _this_\Y[3] = _this_\Thumb\Pos : _this_\Height[3] = _this_\Thumb\Length : Else : _this_\X[3] = _this_\Thumb\Pos : _this_\Width[3] = _this_\Thumb\Length : EndIf
  EndMacro
  
  
  Declare.b Draw(*Scroll._S_Bar)
; ;   Declare.i Y(*Scroll._S_Bar)
; ;   Declare.i X(*Scroll._S_Bar)
; ;   Declare.i Width(*Scroll._S_Bar)
; ;   Declare.i Height(*Scroll._S_Bar)
  Declare.b SetState(*Scroll._S_Bar, ScrollPos.i)
  Declare.i SetAttribute(*Scroll._S_Bar, Attribute.i, Value.i)
  Declare.i SetColor(*Scroll._S_Bar, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.b Resize(*This._S_Bar, iX.i,iY.i,iWidth.i,iHeight.i, *Scroll._S_Bar=#Null)
  Declare.b Resizes(*v._S_Bar, *h._S_Bar, X.i,Y.i,Width.i,Height.i)
  Declare.b Updates(*v._S_Bar, *h._S_Bar, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*This._S_Bar, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0, AutoHide.b=0, *Scroll._S_Bar=#Null, Window=-1, Gadget=-1)
  Declare.i Widget(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
EndDeclareModule

Module Bar
  Macro ThumbLength(_this_)
    Round(_this_\Area\Length - (_this_\Area\Length / (_this_\Max-_this_\Min))*((_this_\Max-_this_\Min) - _this_\Page\Length), #PB_Round_Nearest)
  EndMacro
  
  Procedure Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
    Protected I
    
    If Length=0
      Thickness = - 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Thickness),(X+1+i)+Size,(Y+i-1)+(Thickness),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Thickness),((X+1+(Size))-i),(Y+i-1)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Thickness =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Thickness),(X+1+i),(Y+i)+(Thickness),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Thickness),((X+1+(Size*2))-i),(Y+i)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Thickness =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Thickness),(((Y+1)+(Size))-i),((X+1)+i)+(Thickness),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Thickness),((Y+1)+i)+Size,((X+1)+i)+(Thickness),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Thickness =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+2)+i)-(Thickness),((Y+1)+i),((X+2)+i)+(Thickness),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+2)+i)-(Thickness),(((Y+1)+(Size*2))-i),((X+2)+i)+(Thickness),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Thickness =- 1
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
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    If Grid 
      Value = Round((Value/Grid), #PB_Round_Nearest) * Grid : If (Value>Max) : Value=Max : EndIf
    EndIf
    
    ProcedureReturn Value
  EndProcedure
  
  Procedure.i Pos(*This._S_Bar, ThumbPos.i)
    Protected ScrollPos.i
    
    With *This
      ScrollPos = Match(\Min + Round((ThumbPos - \Area\Pos) / (\Area\Length / (\Max-\Min)), #PB_Round_Nearest), \Page\ScrollStep) : If (\Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Max-\Min)-ScrollPos) : EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.b Draw(*Scroll._S_Bar)
    With *Scroll
      If Not \Hide And \Alpha
        
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[0],\Y[0],\Width[0],\Height[0],\Radius,\Radius,\Color\Back[\Color\State]&$FFFFFF|\Alpha<<24)
        
        If \Vertical
          ; Draw left line
          If \Both
            ; "Это пустое пространство между двумя скроллами тоже закрашиваем если скролл бара кнопки не круглые"
            If Not \Radius : Box(\X[2],\Y[2]+\height[2]+1,\Width[2],\Height[2],\Color\Back[\Color\State]&$FFFFFF|\Alpha<<24) : EndIf
            Line(\X[0],\Y[0],1,\height[0]-\Radius/2,$FFFFFFFF&$FFFFFF|\Alpha<<24)
          Else
            Line(\X[0],\Y[0],1,\Height[0],$FFFFFFFF&$FFFFFF|\Alpha<<24)
          EndIf
        Else
          ; Draw top line
          If \Both
            Line(\X[0],\Y[0],\width[0]-\Radius/2,1,$FFFFFFFF&$FFFFFF|\Alpha<<24)
          Else
            Line(\X[0],\Y[0],\Width[0],1,$FFFFFFFF&$FFFFFF|\Alpha<<24)
          EndIf
        EndIf
        
        If \Thumb\Length
          ; Draw thumb
          DrawingMode(\DrawingMode|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\X[3],\Y[3],\Width[3],\Height[3],\Color[3]\Fore[\Color[3]\State],\Color[3]\Back[\Color[3]\State], \Radius, \Alpha)
          
          ; Draw thumb frame
          If \DrawingMode = #PB_2DDrawing_Gradient
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[3],\Y[3],\Width[3],\Height[3],\Radius,\Radius,\Color[3]\Frame[\Color[3]\State]&$FFFFFF|\Alpha<<24)
          EndIf
        EndIf
        
        If \Button\Length
          ; Draw buttons
          DrawingMode(\DrawingMode|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color[1]\Fore[\Color[1]\State],\Color[1]\Back[\Color[1]\State], \Radius, \Alpha)
          BoxGradient(\Vertical,\X[2],\Y[2],\Width[2],\Height[2],\Color[2]\Fore[\Color[2]\State],\Color[2]\Back[\Color[2]\State], \Radius, \Alpha)
          
          ; Draw buttons frame
          If \DrawingMode = #PB_2DDrawing_Gradient
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color[1]\Frame[\Color[1]\State]&$FFFFFF|\Alpha<<24)
            RoundBox(\X[2],\Y[2],\Width[2],\Height[2],\Radius,\Radius,\Color[2]\Frame[\Color[2]\State]&$FFFFFF|\Alpha<<24)
          EndIf
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\X[1]+(\Width[1]-\Size[1])/2,\Y[1]+(\Height[1]-\Size[1])/2, \Size[1], Bool(\Vertical), \Color[1]\Front[\Color[1]\State]&$FFFFFF|\Alpha<<24,\Type[1])
          Arrow(\X[2]+(\Width[2]-\Size[2])/2,\Y[2]+(\Height[2]-\Size[2])/2, \Size[2], Bool(\Vertical)+2, \Color[2]\Front[\Color[2]\State]&$FFFFFF|\Alpha<<24,\Type[2])
        EndIf
        
        If \DrawingMode = #PB_2DDrawing_Gradient
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line(\X[3]+(\Width[3]-8)/2,\Y[3]+\Height[3]/2-3,9,1,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
            Line(\X[3]+(\Width[3]-8)/2,\Y[3]+\Height[3]/2,9,1,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
            Line(\X[3]+(\Width[3]-8)/2,\Y[3]+\Height[3]/2+3,9,1,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
          Else
            Line(\X[3]+\Width[3]/2-3,\Y[3]+(\Height[3]-8)/2,1,9,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
            Line(\X[3]+\Width[3]/2,\Y[3]+(\Height[3]-8)/2,1,9,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
            Line(\X[3]+\Width[3]/2+3,\Y[3]+(\Height[3]-8)/2,1,9,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Alpha<<24)
          EndIf
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
; ;   Procedure.i X(*Scroll._S_Bar)
; ;     Protected Result.i
; ;     
; ;     If *Scroll
; ;       With *Scroll
; ;         If Not \Hide[1] And \Alpha
; ;           Result = \X
; ;         Else
; ;           Result = \X+\Width
; ;         EndIf
; ;       EndWith
; ;     EndIf
; ;     
; ;     ProcedureReturn Result
; ;   EndProcedure
; ;   
; ;   Procedure.i Y(*Scroll._S_Bar)
; ;     Protected Result.i
; ;     
; ;     If *Scroll
; ;       With *Scroll
; ;         If Not \Hide[1] And \Alpha
; ;           Result = \Y
; ;         Else
; ;           Result = \Y+\Height
; ;         EndIf
; ;       EndWith
; ;     EndIf
; ;     
; ;     ProcedureReturn Result
; ;   EndProcedure
  
; ;   Procedure.i Width(*Scroll._S_Bar)
; ;     Protected Result.i
; ;     
; ;     If *Scroll
; ;       With *Scroll
; ;         If Not \Hide[1] And \Width And \Alpha
; ;           Result = \Width
; ;         EndIf
; ;       EndWith
; ;     EndIf
; ;     
; ;     ProcedureReturn Result
; ;   EndProcedure
; ;   
; ;   Procedure.i Height(*Scroll._S_Bar)
; ;     Protected Result.i
; ;     
; ;     If *Scroll
; ;       With *Scroll
; ;         If Not \Hide[1] And \Height And \Alpha
; ;           Result = \Height
; ;         EndIf
; ;       EndWith
; ;     EndIf
; ;     
; ;     ProcedureReturn Result
; ;   EndProcedure
  
  Procedure.b SetState(*Scroll._S_Bar, ScrollPos.i)
    Protected Result.b, Direction
    
    With *Scroll
      If (\Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Max-\Min)-ScrollPos) : EndIf
      
      If ScrollPos < \Min : ScrollPos = \Min : EndIf
      If ScrollPos > (\Max-\Page\Length)
        ScrollPos = (\Max-\Page\Length)
      EndIf
      
      If \Page\Pos<>ScrollPos 
        If \Page\Pos>ScrollPos
          Direction =- ScrollPos
        Else
          Direction = ScrollPos
        EndIf
        
        \Page\Pos=ScrollPos
        \Thumb\Pos = ThumbPos(*Scroll, ScrollPos)
        
; ; ;         If \Vertical
; ; ;           \Y[3] = \Thumb\Pos
; ; ;           \Height[3] = \Thumb\Length
; ; ;         Else
; ; ;           \X[3] = \Thumb\Pos
; ; ;           \Width[3] = \Thumb\Length
; ; ;         EndIf
        
        If \Gadget >- 1 
          ;Debug \Window
          If \Window =- 1
            \Window = EventWindow()
          EndIf
          
          PostEvent(#PB_Event_Widget, \Window, \Gadget, #PB_EventType_ScrollChange, Direction) 
        EndIf
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*Scroll._S_Bar, Attribute.i, Value.i)
    Protected Result.i
    
    With *Scroll
      Select Attribute
        Case #PB_ScrollBar_Minimum
          If \Min <> Value
            \Min = Value
            \Page\Pos = Value
            Result = #True
          EndIf
          
        Case #PB_ScrollBar_Maximum
          If \Max <> Value
            If \Min > Value
              \Max = \Min + 1
            Else
              \Max = Value
            EndIf
            
            ; \Page\ScrollStep = (\Max-\Min) / 100
            
            Result = #True
          EndIf
          
        Case #PB_ScrollBar_PageLength
          If \Page\Length <> Value
            If Value > (\Max-\Min) 
              If Not \Max : \Max = Value : EndIf ; Если этого page_length вызвать раньше maximum то не правильно работает
              \Page\Length = (\Max-\Min)
            Else
              \Page\Length = Value
            EndIf
            
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*Scroll._S_Bar, ColorType.i, Color.i, State.i=0, Item.i=0)
    Protected Result, Count 
    State =- 1
    If Item < 0 
      Item = 0 
    ElseIf Item > 3 
      Item = 3 
    EndIf
    
    With *Scroll
      If State =- 1
        Count = 2
        \Color\State = 0
      Else
        Count = State
        \Color\State = State
      EndIf
      
      For State = \Color\State To Count
        
        Select ColorType
          Case #PB_Gadget_LineColor
            If \Color[Item]\Line[State] <> Color 
              \Color[Item]\Line[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_BackColor
            If \Color[Item]\Back[State] <> Color 
              \Color[Item]\Back[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrontColor
            If \Color[Item]\Front[State] <> Color 
              \Color[Item]\Front[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrameColor
            If \Color[Item]\Frame[State] <> Color 
              \Color[Item]\Frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b Resize(*This._S_Bar, X.i,Y.i,Width.i,Height.i, *Scroll._S_Bar=#Null)
    Protected Result, Lines, ScrollPage
    
    With *This
      ScrollPage = ((\Max-\Min) - \Page\Length)
      Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
      
      If *Scroll
        If \Vertical
          If Height=#PB_Ignore : If *Scroll\Hide : Height=(*Scroll\Y+*Scroll\Height)-\Y : Else : Height = *Scroll\Y-\Y : EndIf : EndIf
        Else
          If Width=#PB_Ignore : If *Scroll\Hide : Width=(*Scroll\X+*Scroll\Width)-\X : Else : Width = *Scroll\X-\X : EndIf : EndIf
        EndIf
      EndIf
      
      ;
      If X=#PB_Ignore : X = \X[0] : EndIf 
      If Y=#PB_Ignore : Y = \Y[0] : EndIf 
      If Width=#PB_Ignore : Width = \Width[0] : EndIf 
      If Height=#PB_Ignore : Height = \Height[0] : EndIf
      
      ;
      If ((\Max-\Min) > \Page\Length) ; = 
        If \Vertical
          \Area\Pos = Y+\Button\Length
          \Area\Length = (Height-\Button\Length*2)
        Else
          \Area\Pos = X+\Button\Length
          \Area\Length = (Width-\Button\Length*2)
        EndIf
        
        If \Area\Length
          \Thumb\Length = ThumbLength(*This)
          
          If (\Area\Length > \Button\Length)
            If \Button\Length
              If (\Thumb\Length < \Button\Length)
                \Area\Length = Round(\Area\Length - (\Button\Length-\Thumb\Length), #PB_Round_Nearest)
                \Thumb\Length = \Button\Length 
              EndIf
            Else
              If (\Thumb\Length < 7)
                \Area\Length = Round(\Area\Length - (7-\Thumb\Length), #PB_Round_Nearest)
                \Thumb\Length = 7
              EndIf
            EndIf
          Else
            \Thumb\Length = \Area\Length 
          EndIf
          
          If \Area\Length > 0
            ; Debug " scroll set state "+\Max+" "+\Page\Length+" "+Str(\Thumb\Pos+\Thumb\Length) +" "+ Str(\Area\Length+\Button\Length)
            If (\Type <> #PB_GadgetType_TrackBar) And (\Thumb\Pos+\Thumb\Length) >= (\Area\Pos+\Area\Length)
              SetState(*This, ScrollPage)
            EndIf
            
            \Thumb\Pos = ThumbPos(*This, \Page\Pos)
          EndIf
        EndIf
      EndIf
      
      
      \X[0] = X : \Y[0] = Y : \Width[0] = Width : \Height[0] = Height                                             ; Set scroll bar coordinate
      
      If \Vertical
        \X[1] = X + Lines : \Y[1] = Y : \Width[1] = Width - Lines : \Height[1] = \Button\Length                   ; Top button coordinate on scroll bar
        \X[2] = X + Lines : \Width[2] = Width - Lines : \Height[2] = \Button\Length : \Y[2] = Y+Height-\Height[2] ; Botom button coordinate on scroll bar
        \X[3] = X + Lines : \Width[3] = Width - Lines : \Y[3] = \Thumb\Pos : \Height[3] = \Thumb\Length           ; Thumb coordinate on scroll bar
      Else
        \X[1] = X : \Y[1] = Y + Lines : \Width[1] = \Button\Length : \Height[1] = Height - Lines                  ; Left button coordinate on scroll bar
        \Y[2] = Y + Lines : \Height[2] = Height - Lines : \Width[2] = \Button\Length : \X[2] = X+Width-\Width[2]  ; Right button coordinate on scroll bar
        \Y[3] = Y + Lines : \Height[3] = Height - Lines : \X[3] = \Thumb\Pos : \Width[3] = \Thumb\Length          ; Thumb coordinate on scroll bar
      EndIf
      
      \Hide[1] = Bool(Not ((\Max-\Min) > \Page\Length))
      ProcedureReturn \Hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*v._S_Bar, *h._S_Bar, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    Protected iWidth = X(*v), iHeight = Y(*h)
    Static hPos, vPos : vPos = *v\Page\Pos : hPos = *h\Page\Pos
    
    ; Вправо работает как надо
    If ScrollArea_Width<*h\Page\Pos+iWidth 
      ScrollArea_Width=*h\Page\Pos+iWidth
      ; Влево работает как надо
    ElseIf ScrollArea_X>*h\Page\Pos And
           ScrollArea_Width=*h\Page\Pos+iWidth 
      ScrollArea_Width = iWidth 
    EndIf
    
    ; Вниз работает как надо
    If ScrollArea_Height<*v\Page\Pos+iHeight
      ScrollArea_Height=*v\Page\Pos+iHeight 
      ; Верх работает как надо
    ElseIf ScrollArea_Y>*v\Page\Pos And
           ScrollArea_Height=*v\Page\Pos+iHeight 
      ScrollArea_Height = iHeight 
    EndIf
    
    If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
    If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
    
    If ScrollArea_X<*h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
    If ScrollArea_Y<*v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
    
    If *v\Max<>ScrollArea_Height : SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
    If *h\Max<>ScrollArea_Width : SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
    
    If *v\Page\Length<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\Page\Length<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If ScrollArea_Y<0 : SetState(*v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
    If ScrollArea_X<0 : SetState(*h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    
    *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h) 
    *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *v)
    
    If *v\Hide : *v\Page\Pos = 0 : If vPos : *v\Hide = vPos : EndIf : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
    If *h\Hide : *h\Page\Pos = 0 : If hPos : *h\Hide = hPos : EndIf : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure.b Resizes(*v._S_Bar, *h._S_Bar, X.i,Y.i,Width.i,Height.i)
    If Width=#PB_Ignore : Width = *v\X : Else : Width+x-*v\Width : EndIf
    If Height=#PB_Ignore : Height = *h\Y : Else : Height+y-*h\Height : EndIf
    
    Protected indent = 2
    Protected iWidth = x(*v)-*h\x+indent
    Protected iHeight = y(*h)-*v\y+indent
    
    If *v\width And *v\Page\Length<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\height And *h\Page\Length<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    *v\Hide = Resize(*v, Width, Y, #PB_Ignore, #PB_Ignore, *h) : iWidth = x(*v)-*h\x+indent
    *h\Hide = Resize(*h, X, Height, #PB_Ignore, #PB_Ignore, *v) : iHeight = y(*h)-*v\y+indent
    
    If *v\width And *v\Page\Length<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\height And *h\Page\Length<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If *v\width : *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h) : EndIf
    If *h\height : *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *v) : EndIf
    
    ; Do we see both scrolbars?
    *v\Both = Bool(Not *h\Hide) : *h\Both = Bool(Not *v\Hide) 
    
    If *v\Hide : *v\Page\Pos = 0 : Else
      If *h\Radius : Resize(*h, #PB_Ignore, #PB_Ignore, (*v\x-*h\x)+Bool(*v\Radius)*4, #PB_Ignore) : EndIf
    EndIf
    If *h\Hide : *h\Page\Pos = 0 : Else
      If *v\Radius : Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*h\y-*v\y)+Bool(*h\Radius)*4) : EndIf
    EndIf

    ProcedureReturn Bool(*v\Hide|*h\Hide)
  EndProcedure
  
  Procedure.b CallBack(*This._S_Bar, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0, AutoHide.b=0, *Scroll._S_Bar=#Null, Window=-1, Gadget=-1)
    Protected Result, Buttons
    Static LastX, LastY, Last, *Thisis._S_Bar, Cursor, Drag, Down
    
    If *This
      If EventType = #PB_EventType_LeftButtonDown
        ;  Debug "CallBack(*This._S_Bar)"
      EndIf
      
      With *This
        If \Type = #PB_GadgetType_ScrollBar
          If \Hide And *This = *Thisis
            \from = 0
            *Thisis = 0
            \Focus = 0
          EndIf
          
          ; get at point buttons
          If Down
            Buttons = \from 
          Else
            If (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\Height) 
              If (Mousex>\x[1] And Mousex=<\x[1]+\Width[1] And  Mousey>\y[1] And Mousey=<\y[1]+\Height[1])
                Buttons = 1
              ElseIf (Mousex>\x[3] And Mousex=<\x[3]+\Width[3] And Mousey>\y[3] And Mousey=<\y[3]+\Height[3])
                Buttons = 3
              ElseIf (Mousex>\x[2] And Mousex=<\x[2]+\Width[2] And Mousey>\y[2] And Mousey=<\y[2]+\Height[2])
                Buttons = 2
              Else
                Buttons =- 1
              EndIf
            EndIf
          EndIf
          
          ; get
          Select EventType
            Case #PB_EventType_MouseWheel  
              If *Thisis = *This
                Select WheelDelta
                  Case-1 : Result = SetState(*This, \Page\Pos - (\Max-\Min)/30)
                  Case 1 : Result = SetState(*This, \Page\Pos + (\Max-\Min)/30)
                EndSelect
              EndIf
              
            Case #PB_EventType_MouseLeave 
              If Not Drag : \from = 0 : Buttons = 0 : LastX = 0 : LastY = 0 : EndIf
            Case #PB_EventType_LeftButtonUp : Down = 0 :  Drag = 0 :  LastX = 0 : LastY = 0
            Case #PB_EventType_LeftButtonDown 
              If Not \Hide : Down = 1
                If Buttons : \from = Buttons : Drag = 1 : *Thisis = *This : EndIf
                
                Select Buttons
                  Case - 1
                    If *Thisis = *This Or (\Height>(\Y[2]+\Height[2]) And \from =- 1) 
                      If \Vertical
                        Result = SetState(*This, Pos(*This, (MouseY-\Thumb\Length/2)))
                      Else
                        Result = SetState(*This, Pos(*This, (MouseX-\Thumb\Length/2)))
                      EndIf
                    EndIf
                  Case 1 : Result = SetState(*This, (\Page\Pos - \Page\ScrollStep))
                  Case 2 : Result = SetState(*This, (\Page\Pos + \Page\ScrollStep))
                  Case 3 : LastX = MouseX - \Thumb\Pos : LastY = MouseY - \Thumb\Pos
                EndSelect
              EndIf
              
            Case #PB_EventType_MouseMove
              If Drag
                If Bool(LastX|LastY) 
                  If *Thisis = *This
                    If \Vertical
                      Result = SetState(*This, Pos(*This, (MouseY-LastY)))
                    Else
                      Result = SetState(*This, Pos(*This, (MouseX-LastX)))
                    EndIf
                  EndIf
                EndIf
              Else
                If Not \Hide
                  If Buttons
                    If Last <> Buttons
                      If *Thisis>0 : CallBack(*Thisis, #PB_EventType_MouseLeave, MouseX, MouseY, WheelDelta) : EndIf
                      EventType = #PB_EventType_MouseEnter
                      Last = Buttons
                    EndIf
                    
                    If *Thisis <> *This 
                      Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                      SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
                      ; Debug "Мышь находится внутри"
                      *Thisis = *This
                    EndIf
                    
                    If Window >- 1 : \Window = Window : EndIf
                    If Window >- 1 : \Gadget = Gadget : EndIf
                    \from = Buttons
                  Else   ;   If *Thisis = *This
                    EventType = #PB_EventType_MouseLeave
                    \from = 0
                    Last = 0
                  EndIf
                EndIf
              EndIf
              
          EndSelect
          
          ; set colors
          If Not \Hide
            Select EventType
              Case #PB_EventType_Focus : \Focus = #True : Result = #True
              Case #PB_EventType_LostFocus : \Focus = #False : Result = #True
              Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
                If Buttons>0
                  \Color[Buttons]\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
                ElseIf Not Drag And Not Buttons 
                  If *Thisis = *This And ((EventType = #PB_EventType_MouseLeave) And 
                                          Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)) Or 
                     EventType() = #PB_EventType_MouseLeave
                    SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
                    ; Debug "Мышь находится снаружи"
                    *Thisis = 0
                  EndIf
                  \Color[1]\State = 0
                  \Color[2]\State = 0
                  \Color[3]\State = 0
                EndIf
                
                Result = #True
                
            EndSelect
          EndIf
          
          If AutoHide =- 1 : *Scroll = 0
            AutoHide = Bool(EventType() = #PB_EventType_MouseLeave)
          EndIf
          
          ; Auto hides
          If (AutoHide And Not Drag And Not Buttons) 
            If \Alpha <> \Alpha[1] : \Alpha = \Alpha[1] 
              Result =- 1
            EndIf 
          EndIf
          If EventType = #PB_EventType_MouseEnter And (*Thisis = *This Or Not *Scroll)
            If \Alpha < 255 : \Alpha = 255
              
              If *Scroll
                If \Vertical
                  Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*Scroll\y+*Scroll\height)-\y) 
                Else
                  Resize(*This, #PB_Ignore, #PB_Ignore, (*Scroll\x+*Scroll\width)-\x, #PB_Ignore) 
                EndIf
              EndIf
              
              Result =- 2
            EndIf 
          EndIf
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Widget(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
    
    Protected *Scroll._S_Bar = AllocateStructure(_S_Bar)
    With *Scroll
      \Alpha = 255
      \Alpha[1] = 0
      \Radius = Radius
      \Type[1] =- 1 ; -1 0 1
      \Type[2] =- 1 ; -1 0 1
      \Size[1] = 4
      \Size[2] = 4
      \Window =- 1
      \Gadget =- 1
      \X =- 1
      \Y =- 1
        
      ; Цвет фона скролла
      \Color\State = 0
      \Color\Back[0] = $FFF9F9F9
      \Color\Frame[0] = \Color\Back[0]
      
      \Color[1] = Colors
      \Color[2] = Colors
      \Color[3] = Colors
      
      \Type = #PB_GadgetType_ScrollBar
      \DrawingMode = #PB_2DDrawing_Gradient
      \Vertical = Bool(Flag&#PB_ScrollBar_Vertical)
      
      If \Vertical
        If width < 21
          \Button\Length = width - 1
        Else
          \Button\Length = 17
        EndIf
      Else
        If height < 21
          \Button\Length = height - 1
        Else
          \Button\Length = 17
        EndIf
      EndIf
      
      If \Min <> Min : SetAttribute(*Scroll, #PB_ScrollBar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*Scroll, #PB_ScrollBar_Maximum, Max) : EndIf
      If \Page\Length <> Pagelength : SetAttribute(*Scroll, #PB_ScrollBar_PageLength, Pagelength) : EndIf
    EndWith
              Resize(*Scroll, X,Y,Width,Height)
    ProcedureReturn *Scroll
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
    Protected *Widget, *This._S_widget = AllocateStructure(_S_widget)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      *This = Widget(x, y, Width, Height, Min, Max, PageLength, Flag, Radius)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
EndModule

DeclareModule ListIcon
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  
  Declare.i AddColumn(*This._S_widget, Position.i, Text.s, Width.i, Image.i=-1)
  Declare.i Gadget(Gadget.i, x.i, y.i, width.i, height.i, ColumnTitle.s, ColumnWidth.i, flag.i=0)
  Declare AddItem(*This._S_widget,Item.i,Text.s,Image.i=-1,sublevel.i=0)
  Declare ClearItems(*This._S_widget)
  Declare CountItems(*This._S_widget, Item.i=-1)
  Declare RemoveItem(*This._S_widget, Item.i)
  Declare GetItemAttribute(Gadget.i, Item.i, Attribute.i)
  Declare GetItemData(Gadget.i, Item.i)
  Declare SetItemData(Gadget.i, Item.i, *data)
  Declare GetItemColor(Gadget.i, Item.i, ColorType.i, Column.i=0)
  Declare SetItemColor(Gadget.i, Item.i, ColorType.i, Color.i, Column.i=0)
  Declare GetItemImage(Gadget.i, Item.i)
  Declare SetItemImage(Gadget.i, Item.i, Image.i)
  Declare GetState(Gadget.i)
  Declare SetState(Gadget.i, Item.i)
  Declare GetItemState(Gadget.i, Item.i)
  Declare SetItemState(Gadget.i, Item.i, State.i)
  Declare.s GetText(Gadget.i)
  Declare   SetText(Gadget.i, Text.s)
  Declare.s GetItemText(Gadget.i, Item.i)
  Declare SetItemText(Gadget.i, Item.i, Text.s)
  Declare Free(Gadget.i)
  Declare ReDraw(*This._S_widget)
  
  
  Declare.l CallBack(*this, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, ColumnTitle.s, ColumnWidth.i, Flag.i=0, Radius.i=0)
EndDeclareModule

Module ListIcon
  
  ;- - DRAWINGs
  Procedure CheckBox(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) 
    Protected I, checkbox_backcolor
    
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    If Checked
      BackColor = $F67905&$FFFFFF|255<<24
      BackColor($FFB775&$FFFFFF|255<<24) 
      FrontColor($F67905&$FFFFFF|255<<24)
    Else
      BackColor = $7E7E7E&$FFFFFF|255<<24
      BackColor($FFFFFF&$FFFFFF|255<<24)
      FrontColor($EEEEEE&$FFFFFF|255<<24)
    EndIf
    
    LinearGradient(X,Y, X, (Y+Height))
    RoundBox(X,Y,Width,Height, Radius,Radius)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
    
    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    RoundBox(X,Y,Width,Height, Radius,Radius, BackColor)
    
    If Checked
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      If Type = 1
        Circle(x+5,y+5,2,Color&$FFFFFF|alpha<<24)
      ElseIf Type = 3
        For i = 0 To 1
          LineXY((X+2),(i+Y+6),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
          LineXY((X+7+i),(Y+2),(X+4+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
                                                                      ;           LineXY((X+1),(i+Y+5),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
                                                                      ;           LineXY((X+8+i),(Y+3),(X+3+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure PlotX(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If x%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure PlotY(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If y%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Case $FFF1F1F1, $FFF3F3F3, $FFF5F5F5, $FFF7F7F7, $FFF9F9F9, $FFFBFBFB, $FFFDFDFD, $FFFCFCFC, $FFFEFEFE, $FF7E7E7E
          Color = TargetColor
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure Draw(*This._S_widget)
    Protected x_content,y_point,x_point, iwidth, iheight, w=18, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 128
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = 4
    Protected Drawing.b,column_width,column_height,column_x,l=1, n, height = 18, text_color=$000000
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      height = 16
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      height = 20
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      height = 18
    CompilerEndIf
    
    
    ;     If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      If *This\Text\FontID : DrawingFont(*This\Text\FontID) : EndIf
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\bs, *This\bs, *This\width[2], *This\height[2], back_color)
      
      With *This\Columns()\Items()
        If *This\image\width
          n=19
          column_x = *This\bs+(n*(1+Bool(*This\flag\CheckBoxes))) + 4
        EndIf
        column_x - *This\scroll\h\Page\Pos
        column_width = column_x
        *This\scroll\v\Page\ScrollStep = height+Bool(*This\flag\GridLines)*2+l
        
        ForEach *This\Columns()
          ;If ListSize(*This\Columns()\Items())
          column_height = *This\Columns()\height
          ;*This\Scroll\Width=*This\bs
          *This\Scroll\height=*This\bs+column_height
          *This\Columns()\x=column_width ; + 20;*This\Columns()\Image\width
          iWidth = *This\Columns()\x + *This\Columns()\width
          iWidth = *This\width[2]-Bar::Width(*This\scroll\v)
          iHeight = *This\height[2]-Bar::Height(*This\scroll\h)
          
          
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            ClipOutput(*This\bs, *This\bs, *This\width[2], iHeight)
          CompilerEndIf
          
          If *This\Columns()\text\change = 1
            *This\Columns()\text\height = TextHeight("A") 
            *This\Columns()\text\width = TextWidth(*This\Columns()\text\string.s)
            *This\Columns()\text\change = 0
          EndIf
          
          *This\Columns()\text\x = 5+*This\Columns()\x
          *This\Columns()\text\y = *This\Columns()\y+(column_height+2-*This\Columns()\text\height)/2
          
          ;Drawing = Bool(\y+\height>*This\bs+*This\Columns()\height And \y<*This\height[2])
          
          PushListPosition(*This\Columns()\Items())
          ForEach *This\Columns()\Items()
            
            If Not \hide
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                ClipOutput(*This\bs, *This\bs+column_height, iwidth, iHeight) ; Bug
              CompilerEndIf
              
              
              \x=*This\bs+*This\Columns()\x-column_x; ;
              \width=iwidth
              \height=height
              \y=*This\Scroll\height-*This\scroll\v\Page\Pos
              
              If \text\change = 1
                \text\height = TextHeight("A") 
                \text\width = TextWidth(\text\string.s)
                \text\change = 0
              EndIf
              
              If *This\Flag\buttons 
                x_content=*This\bs+column_width-column_x+2+(w+\sublevel*w)-*This\scroll\h\Page\Pos
              Else
                x_content=*This\bs+column_width-column_x+2+(\sublevel*w)-*This\scroll\h\Page\Pos
              EndIf
              
              \box\width = box_size
              \box\height = box_size
              \box\x = x_content-(w+\box\width)/2
              \box\y = \y+(\height-\box\height)/2
              
              If \Image\handle
                \Image\x = 2+x_content
                \Image\y = \y+(\height-\Image\height)/2
                
                *This\Image\handle = \Image\handle
                *This\Columns()\Image\width = \Image\width+10
              EndIf
              
              If \text\width
                \text\x = 1+x_content+*This\Columns()\Image\width+Bool(*This\Flag\CheckBoxes)
                \text\y = \y+(\height-\text\height)/2
              EndIf
              
              If *This\Flag\CheckBoxes
                \box\x+n-2
                \text\x+n-2
                \Image\x+n-2
                
                \box[1]\width = box_1_size
                \box[1]\height = box_1_size
                
                \box[1]\x = *This\bs+4
                \box[1]\y = \y+(\height-\box[1]\height)/2
              EndIf
              
              *This\Scroll\height+\height+l+Bool(*This\Flag\GridLines)*2
;               If *This\Scroll\Width < (\text\x+\text\width+n)+*This\scroll\h\Page\Pos
;                 *This\Scroll\Width = (\text\x+\text\width+n)+*This\scroll\h\Page\Pos
;               EndIf
              
              Drawing = Bool(\y+\height>*This\bs+*This\Columns()\height And \y<*This\height[2])
              If Drawing
                If \color\state Or
                   (*This\focus And *This\Flag\FullSelection And *This\index = \index )
                  
                  box_color = $FFFFFF
                  text_color=$FFFFFF
                Else
                  box_color = $7E7E7E
                  text_color=$000000
                EndIf
                
                ; Draw selections
                If \color\state ; \index=*This\Line ; с этим остается последное виделеное слово
                  Protected SelectionPos, SelectionLen 
                  If *This\Flag\FullSelection
                    SelectionPos = *This\bs
                    SelectionLen = iwidth
                  Else
                    SelectionPos = \Text\X - 2
                    SelectionLen = \Text\width + 4
                  EndIf
                  
                  ; Draw items back color
                  If \Color\Fore
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(0,SelectionPos,\Y,SelectionLen,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    RoundBox(SelectionPos,\Y,SelectionLen,\Height,\Radius,\Radius,\Color\Back[\Color\State])
                  EndIf
                  ;Debug Point(\x+2,\y+2)
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(SelectionPos,\y,SelectionLen,\height, \Color\Frame[\Color\State])
                EndIf
                
                ; Draw boxes
                If *This\Flag\buttons And \childrens
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Bar::Arrow(\box[0]\x+(\box[0]\width-6)/2,\box[0]\y+(\box[0]\height-6)/2, 6, Bool(Not \box[0]\checked)+2, box_color&$FFFFFF|alpha<<24, 0,0) 
                EndIf
              EndIf
              
              
              If Drawing
                If ListIndex(*This\Columns())=0
                  ; Draw checkbox
                  If *This\Flag\CheckBoxes
                    CheckBox(\box[1]\x,\box[1]\y,\box[1]\width,\box[1]\height, 3, \box[1]\checked, checkbox_color, box_color, 2, alpha);, box_type)
                  EndIf
                  
                  ; Draw image
                  If \Image\handle
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawAlphaImage(\Image\handle, \Image\x, \Image\y, alpha)
                  EndIf
                EndIf
                
                ; Draw string
                If \text\string.s
                  CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                    ClipOutput(*This\Columns()\x, *This\bs+column_height, *This\Columns()\width, iHeight)
                  CompilerEndIf
                  
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawText(\text\x, \text\y, \text\string.s, text_color&$FFFFFF|alpha<<24)
                  
                  CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                    UnclipOutput()
                  CompilerEndIf
                EndIf
                
                If *This\Flag\GridLines
                  ; Horizontal line
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(*This\bs, (\y+\height)+l, iwidth, l, $ADADAE&$FFFFFF|alpha<<24)
                  ;Box(*This\Columns()\x-column_x, (\y+\height)+l, *This\Columns()\width+column_x, l, $ADADAE&$FFFFFF|alpha<<24)
                EndIf
              EndIf
            EndIf
          Next
          PopListPosition(*This\Columns()\Items())
          
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            UnclipOutput()
          CompilerEndIf
          
          
          
          
          
          
          DrawingMode(#PB_2DDrawing_Default)
          ; Box(*This\bs, 0, iwidth, column_height+3, back_color)
          ; Draw
          DrawingMode(#PB_2DDrawing_Gradient)
          ;BoxGradient(0,*This\Columns()\x+1, 0, *This\Columns()\width-1, column_height, $FFFFFF,$F4F4F5)
          
          If ListIndex(*This\Columns())=0
            DrawingMode(#PB_2DDrawing_Gradient)
            BoxGradient(0,*This\bs, 0, iwidth, column_height, $FFFFFF,$F4F4F5)
          EndIf
          
          DrawingMode(#PB_2DDrawing_Default)
          Box(*This\Columns()\x-column_x, column_height, iwidth,1,$ADADAE)
          
          
          ; Vertical line
          If *This\Flag\GridLines
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(column_x, *This\bs, l, iheight, $ADADAE&$FFFFFF|alpha<<24)
            Box(*This\Columns()\x+*This\Columns()\width, *This\bs, l, iheight, $ADADAE&$FFFFFF|alpha<<24)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(column_x, *This\bs, l, column_height, $ADADAE&$FFFFFF|alpha<<24)
            Box(*This\Columns()\x+*This\Columns()\width, *This\bs, l, column_height, $ADADAE&$FFFFFF|alpha<<24)
          EndIf
          
          If *This\Columns()\text\string.s
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(*This\Columns()\text\x, *This\Columns()\text\y, *This\Columns()\text\string.s, $000000&$FFFFFF|alpha<<24)
          EndIf
          
          If *This\bs
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(*This\bs-1, *This\Columns()\height+1, *This\width[2]+2, 1, $FFFFFF)
          EndIf
          
          column_width + *This\Columns()\width
          ;EndIf
        Next
        
        *This\Scroll\Height = *This\Scroll\Height-l-Bool(*This\Flag\GridLines)*2
        
        ; Задаем размеры скролл баров
        If *This\scroll\v\Page\Length And *This\scroll\v\Max<>*This\Scroll\Height And 
           Bar::SetAttribute(*This\scroll\v, #PB_ScrollBar_Maximum, *This\Scroll\Height)
          Bar::Resizes(*This\scroll\v, *This\scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        If *This\scroll\h\Page\Length And *This\scroll\h\Max<>*This\Scroll\Width+1 And 
           Bar::SetAttribute(*This\scroll\h, #PB_ScrollBar_Maximum, *This\Scroll\Width+1)
          Bar::Resizes(*This\scroll\v, *This\scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        
        Bar::Draw(*This\scroll\v)
        Bar::Draw(*This\scroll\h)
        
        If *This\fs
          DrawingMode(#PB_2DDrawing_Outlined)
          Box((*This\bs-*This\fs), (*This\bs-*This\fs), *This\width[1], *This\height[1], $ADADAE)
        EndIf
        
        If *This\bs
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*This\bs-1, *This\bs-1, *This\width[2]+2, *This\height[2]+2, $FFFFFF)
        EndIf
        
        
      EndWith
    EndIf
  EndProcedure
  
  Procedure ReDraw(*This._S_widget)
    If *This And StartDrawing(CanvasOutput(*This\Canvas\Gadget))
      Draw(*This)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i AddColumn(*This._S_widget, Position.i, Text.s, Width.i, Image.i=-1)
    
    With *This
      LastElement(\Columns())
      AddElement(\Columns()) 
;       Position = ListIndex(\Columns())
      
      \Columns()\text\string.s = Text.s
      \Columns()\text\change = 1
      \Columns()\x = \scroll\width
      \Columns()\width = Width
      \Columns()\height = 24
      \scroll\width + Width
      \Scroll\height = \bs*2+\Columns()\height
      ;      ; ReDraw(*This)
;       If Position = 0
;      ;   PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
;       EndIf
    EndWith
  EndProcedure
  
  Procedure AddLine(*This._S_widget,Line.i,String.s) ;,Image.i=-1,Sublevel.i=0)
    Protected Image_Y, Image_X, Text_X, Text_Y, Height, Width, Indent = 4
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\handle
        If _this_\Flag\InLine
          Text_Y=((Height-(_this_\Text\Height*_this_\Text\Count))/2)
          Image_Y=((Height-_this_\Image\Height)/2)
        Else
          If _this_\Text\Align\Bottom
            Text_Y=((Height-_this_\Image\Height-(_this_\Text\Height*_this_\Text\Count))/2)-Indent/2
            Image_Y=(Height-_this_\Image\Height+(_this_\Text\Height*_this_\Text\Count))/2+Indent/2
          Else
            Text_Y=((Height-(_this_\Text\Height*_this_\Text\Count)+_this_\Image\Height)/2)+Indent/2
            Image_Y=(Height-(_this_\Text\Height*_this_\Text\Count)-_this_\Image\Height)/2-Indent/2
          EndIf
        EndIf
      Else
        If _this_\Text\Align\Bottom
          Text_Y=(Height-(_this_\Text\Height*_this_\Text\Count)-Text_Y-Image_Y) 
        ElseIf _this_\Text\Align\Vertical
          Text_Y=((Height-(_this_\Text\Height*_this_\Text\Count))/2)
        EndIf
      EndIf
    EndMacro
    
    Macro _set_content_X_(_this_)
      If _this_\Image\handle
        If _this_\Flag\InLine
          If _this_\Text\Align\Right
            Text_X=((Width-_this_\Image\Width-_this_\Items()\Text\Width)/2)-Indent/2
            Image_X=(Width-_this_\Image\Width+_this_\Items()\Text\Width)/2+Indent
          Else
            Text_X=((Width-_this_\Items()\Text\Width+_this_\Image\Width)/2)+Indent
            Image_X=(Width-_this_\Items()\Text\Width-_this_\Image\Width)/2-Indent
          EndIf
        Else
          Image_X=(Width-_this_\Image\Width)/2 
          Text_X=(Width-_this_\Items()\Text\Width)/2 
        EndIf
      Else
        If _this_\Text\Align\Right
          Text_X=(Width-_this_\Items()\Text\Width) 
        ElseIf _this_\Text\Align\Horizontal
          Text_X=(Width-_this_\Items()\Text\Width-Bool(_this_\Items()\Text\Width % 2))/2 
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_X_(_this_)
      _this_\Items()\x = _this_\X[1]+_this_\Text\X
      _this_\Items()\Width = Width
      _this_\Items()\Text\x = _this_\Items()\x+Text_X
      
      _this_\Image\X = _this_\X[1]+_this_\Text\X+Image_X
      _this_\Items()\Image\X = _this_\Items()\x+Image_X-4
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\Items()\y = _this_\Y[1]+_this_\Text\Y+_this_\Scroll\Height+Text_Y
        _this_\Items()\Height = _this_\Text\Height - Bool(_this_\Text\Count<>1 And _this_\Flag\GridLines)
        _this_\Items()\Text\y = _this_\Items()\y + (_this_\Text\Height-_this_\Text\Height[1])/2 - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\Text\Count<>1)
        _this_\Items()\Text\Height = _this_\Text\Height[1]
        
        _this_\Image\Y = _this_\Y[1]+_this_\Text\Y+Image_Y
        _this_\Items()\Image\Y = _this_\Items()\y + (_this_\Text\Height-_this_\Items()\Image\Height)/2 + Image_Y
    EndMacro
    
    With *This
      \Text\Count = ListSize(\Items())
        
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2 
        Height = \Width[1]-\Text\y*2
      Else
        CompilerIf Defined(Scroll, #PB_Module)
          Width = Abs(\Width[1]-\Text\X*2 )   ;-Bar::Width(\scroll\v)) ; bug in linux иногда
          Height = \Height[1]-\Text\y*2      ;-Bar::Height(\scroll\h)
        CompilerElse
          Width = \Width[1]-\Text\X*2  
          Height = \Height[1]-\Text\y*2 
        CompilerEndIf
      EndIf
      
;       ; If Not \Text\Height And StartDrawing(CanvasOutput(\Canvas\Gadget)) ; с ним три раза быстрее
;       If StartDrawing(CanvasOutput(\Canvas\Gadget))
;         If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
;         If Not \Text\Height : \Text\Height = TextHeight("A") + 1 : EndIf
;         
;         If \Type = #PB_GadgetType_Button
;           \Items()\Text\Width = TextWidth(RTrim(String.s))
;         Else
;           \Items()\Text\Width = TextWidth(String.s)
;         EndIf
;         StopDrawing()
;       EndIf
      
      \Items()\index = Line
      \Items()\Radius = \Radius
      \Items()\Text\String.s = String.s
      
      ; Set line default colors             
      \Items()\Color = \Color
      \Items()\Color\State = 1
      \Items()\Color\Fore[\Items()\Color\State] = 0
      
      ; Update line pos in the text
      \Items()\Text\Len = Len(String.s)
      \Items()\Text\Position = \Text\Position
      \Text\Position + \Items()\Text\Len + 1 ; Len(#LF$)
      
      _set_content_X_(*This)
      _line_resize_X_(*This)
      _line_resize_Y_(*This)
      
;       If \Line[1] = ListIndex(\Items())
;         ;Debug " string "+String.s
;         \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret) : \Items()\Text[1]\Change = #True
;         \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
;       EndIf
      
;       ; Is visible lines
;       \Items()\Hide = Bool(Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
      Macro _set_scroll_height_(_this_)
    If Not _this_\Items()\Hide
      _this_\Scroll\Height+_this_\Text\Height
    EndIf
  EndMacro
  
      ; Scroll width length
      _set_scroll_width_(*This)
      
      ; Scroll hight length
      _set_scroll_height_(*This)
            
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i list_AddItem(*This._S_columns, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static adress.i, first.i
    Protected *Item, subLevel, hide
    ;     If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        If \Type = #PB_GadgetType_Tree
          subLevel = Flag
        EndIf
        
        ;{ Генерируем идентификатор
        If Item < 0 Or Item > ListSize(\Items()) - 1
          LastElement(\Items())
          *Item = AddElement(\Items()) 
          Item = ListIndex(\Items())
        Else
          SelectElement(\Items(), Item)
          If \Items()\sublevel>sublevel
            sublevel=\Items()\sublevel 
          EndIf
          *Item = InsertElement(\Items())
          
          ; Исправляем идентификатор итема  
          PushListPosition(\Items())
          While NextElement(\Items())
            \Items()\index = ListIndex(\Items())
          Wend
          PopListPosition(\Items())
        EndIf
        ;}
        
        If *Item
          If Item = 0
            First = *Item
          EndIf
          
          If subLevel
            If sublevel>Item
              sublevel=Item
            EndIf
            
            PushListPosition(\Items())
            While PreviousElement(\Items()) 
              If subLevel = \Items()\subLevel
                adress = \Items()\parent
                Break
              ElseIf subLevel > \Items()\subLevel
                adress = @\Items()
                Break
              EndIf
            Wend 
            If adress
              ChangeCurrentElement(\Items(), adress)
              If subLevel > \Items()\subLevel
                sublevel = \Items()\sublevel + 1
                ;\Items()\parent[1] = *Item
                \Items()\childrens + 1
                \Items()\box[0]\checked = 1
                hide = 1
              EndIf
            EndIf
            PopListPosition(\Items())
            
            \Items()\sublevel = sublevel
            \Items()\hide = hide
          Else                                      
            ; ChangeCurrentElement(\Items(), *Item)
            ; PushListPosition(\Items()) 
            ; PopListPosition(\Items())
            adress = first
          EndIf
          
          If \Items()\parent <> adress : \Items()\parent = adress
            \Items()\change = Bool(\Type = #PB_GadgetType_Tree)
          EndIf
            \Items()\Text\FontID = \Text\FontID
            \Items()\text\change = 1
          
          If IsImage(Image)
            
            Select \Attribute
              Case #PB_Attribute_LargeIcon
                \Items()\Image\width = 32
                \Items()\Image\height = 32
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Case #PB_Attribute_SmallIcon
                \Items()\Image\width = 16
                \Items()\Image\height = 16
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Default
                \Items()\Image\width = ImageWidth(Image)
                \Items()\Image\height = ImageHeight(Image)
            EndSelect   
            
            \Items()\Image\handle = ImageID(Image)
            \Items()\image\index = Image
            
            \Image\width = \Items()\Image\width
          EndIf
          
          ; add lines
          AddLine(*This, Item.i, Text.s)
          
          \Items()\Color = Colors
          \Items()\Color\State = 1
          \Items()\Color\Fore[0] = 0 
          \Items()\Color\Fore[1] = 0
          \Items()\Color\Fore[2] = 0
       
          If Item = 0
            PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
          EndIf
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *Item
  EndProcedure
  
  Procedure AddItem(*This._S_widget,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static adress.i
    Protected Childrens.i, hide.b, height.i
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      height = 16
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      height = 20
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      height = 18
    CompilerEndIf
    
    If Not *This
      ProcedureReturn -1
    EndIf
    
    With *This
      ForEach \Columns()
        
        list_AddItem(\Columns(),Item.i,Text.s,Image.i,sublevel.i)
        \Columns()\Items()\text\string.s = StringField(Text.s, ListIndex(\Columns()) + 1, #LF$)
        \Columns()\Items()\Color = Colors
        \Columns()\Items()\Color\Fore[0] = 0 
        \Columns()\Items()\Color\Fore[1] = 0
        \Columns()\Items()\Color\Fore[2] = 0
        
        \Columns()\Items()\Y = \Scroll\height
        \Columns()\Items()\height = height
        \Columns()\Items()\change = 1
        
        \image\width = \Columns()\Items()\image\width
        If ListIndex(\Columns()\Items()) = 0
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        EndIf
      Next
      
       \Scroll\height + height
     EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure ClearItems(*This._S_widget)
    Protected Result.i
    
    If *This
      With *This
        Result = ClearList(\Columns()\Items())
        \scroll\v\hide = 1
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure CountItems(*This._S_widget, Item.i=-1)
    Protected Result.i, sublevel.i
    
    If *This
      With *This
        If Item.i=-1
          Result = ListSize(\Columns()\Items())
        Else
          PushListPosition(\Items()) 
          ForEach \Items()
            If \Items()\index = Item 
              ; Result = \Items()\childrens 
              sublevel = \Items()\sublevel
              
              PushListPosition(\Items())
              While NextElement(\Items())
                If \Items()\sublevel > sublevel 
                  Result + 1
                Else
                  Break
                EndIf
              Wend
              PopListPosition(\Items())
              Break
            EndIf
          Next
          PopListPosition(\Items())
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure RemoveItem(*This._S_widget, Item.i)
    Protected Result.i, sublevel.i
    
    If *This
      With *This
        ;PushListPosition(\Columns()\Items()) 
        ForEach \Columns()\Items()
          If \Columns()\Items()\index = Item 
            Result = DeleteElement(\Columns()\Items(), 1) 
            Break
          EndIf
        Next
        ;PopListPosition(\Columns()\Items())
        
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        ;ReDraw(*This)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemAttribute(Gadget.i, Item.i, Attribute.i)
    Protected Result.i, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\index = Item 
            Select Attribute
              Case #PB_Tree_SubLevel
                Result = \Items()\sublevel
                
            EndSelect
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure GetItemData(Gadget.i, Item.i)
    Protected Result.i, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\index = Item 
            Result = \Items()\data
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemData(Gadget.i, Item.i, *data)
    Protected Result.i, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\index = Item 
            \Items()\data = *data
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemColor(Gadget.i, Item.i, ColorType.i, Column.i=0)
    Protected Result.i, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\index = Item 
            
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemColor(Gadget.i, Item.i, ColorType.i, Color.i, Column.i=0)
    Protected Result.i, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\index = Item 
            
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemImage(Gadget.i, Item.i)
    Protected Result.i, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\index = Item 
            Result = \Items()\Image
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemImage(Gadget.i, Item.i, image.i)
    Protected Result.i, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\index = Item And IsImage(image)
            \Items()\Image\handle = ImageID(image)
            \Items()\image\index = image 
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.i, Item.i)
    Protected Result.i, *This._S_widget, lostfocus.i=-1, collapsed.i, sublevel.i, adress.i, coll.i
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected Result.i, *This._S_widget 
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This 
      With *This
        Result = \index
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemState(Gadget.i, Item.i, State.i)
    Protected Result.i, *This._S_widget, lostfocus.i=-1, collapsed.i, sublevel.i, adress.i, coll.i
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemState(Gadget.i, Item.i)
    Protected Result.i, *This._S_widget, lostfocus.i=-1, collapsed.i, sublevel.i, adress.i, coll.i
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\index = Item
            Result = #PB_Attribute_Selected
            If \Items()\box[0]\checked
              Result | #PB_Attribute_Collapsed
            Else
              Result | #PB_Attribute_Expanded
            EndIf
            If \Items()\box[1]\checked
              Result | #PB_Attribute_Checked
            EndIf
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetText(Gadget.i)
    Protected Result.s, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\color\state = 2
            Result = \Items()\text\string
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf  
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetText(Gadget.i, Text.s)
    Protected Result.i, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\color\state = 2
            \Items()\text\string = Text
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(Gadget.i, Item.i)
    Protected Result.s, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\index = Item
            Result = \Items()\text\string
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemText(Gadget.i, Item.i, Text.s)
    Protected Result.i, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\index = Item
            \Items()\text\string = Text
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  Procedure ToolTip(*This.Text_S=0, ColorFont=0, ColorBack=0, ColorFrame=$FF)
    Protected Gadget
    Static Window
    Protected Color._S_color = Colors
    With *This
      If *This
        ; Debug "show tooltip "+\string
;         If Not Window
; ;         Window = OpenWindow(#PB_Any, \x[1]-3,\y[1],\width+8,\height[1], "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Tool) ;|#PB_Window_NoGadgets
; ;         Gadget = CanvasGadget(#PB_Any,0,0,\width+8,\height[1])
; ;         If StartDrawing(CanvasOutput(Gadget))
; ;           If \FontID : DrawingFont(\FontID) : EndIf 
; ;           DrawingMode(#PB_2DDrawing_Default)
; ;           Box(1,1,\width-2+8,\height[1]-2, Color\Back[1])
; ;           DrawingMode(#PB_2DDrawing_Transparent)
; ;           DrawText(3, (\height[1]-\height)/2, \String, Color\Front[1])
; ;           DrawingMode(#PB_2DDrawing_Outlined)
; ;           Box(0,0,\width+8,\height[1], Color\Frame[1])
; ;           StopDrawing()
; ;         EndIf
        
        Window = OpenWindow(#PB_Any, \x[1]-3,\y[1],\width+8,\height[1], "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Tool) ;|#PB_Window_NoGadgets
        SetGadgetColor(ContainerGadget(#PB_Any,1,1,\width-2+8,\height[1]-2), #PB_Gadget_BackColor, Color\Back[1])
        Gadget = StringGadget(#PB_Any,0,(\height[1]-\height)/2-1,\width-2+8,\height[1]-2, \string, #PB_String_BorderLess)
        SetGadgetColor(Gadget, #PB_Gadget_BackColor, Color\Back[1])
        SetWindowColor(Window, Color\Frame[1])
        SetGadgetFont(Gadget, \FontID)
        CloseGadgetList()
        
        
        SetWindowData(Window, Gadget)
;         Else
;           ResizeWindow(Window, \x[1],\y[1],\width,\height[1])
;           SetGadgetText(GetWindowData(Window), \string)
;           HideWindow(Window, 0, #PB_Window_NoActivate)
;         EndIf
      ElseIf IsWindow(Window)
;         HideWindow(Window, 1, #PB_Window_NoActivate)
        CloseWindow(Window)
      ;  Debug "hide tooltip "
      EndIf
    EndWith              
  EndProcedure
  
  Procedure.i Resize(*This._S_widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *This
      If X<>#PB_Ignore And 
         \X[0] <> X
        \X[0] = X 
        \X[2]=\X[0]+\bs
        \X[1]=\X[2]-\fs
        \Resize = 1<<1
      EndIf
      If Y<>#PB_Ignore And 
         \Y[0] <> Y
        \Y[0] = Y
        \Y[2]=\Y[0]+\bs
        \Y[1]=\Y[2]-\fs
        \Resize = 1<<2
      EndIf
      If Width<>#PB_Ignore And
         \Width[0] <> Width 
        \Width[0] = Width 
        \Width[2] = \Width[0]-\bs*2
        \Width[1] = \Width[2]+\fs*2
        \Resize = 1<<3
      EndIf
      If Height<>#PB_Ignore And 
         \Height[0] <> Height
        \Height[0] = Height 
        \Height[2] = \Height[0]-\bs*2
        \Height[1] = \Height[2]+\fs*2
        \Resize = 1<<4
      EndIf
      
      If \Resize
        Bar::Resizes(\scroll\v, \scroll\h, \x[2],\Y[2],\Width[2],\Height[2])
      EndIf
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.l CallBack(*this._S_widget, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
    Protected Result, from =- 1
    Shared *focus._S_widget
    Static *leave._S_widget
    
    Static cursor_change, LastX, LastY, Last, Down
    
    If mouse_x =- 1 And mouse_y =- 1
      Select EventType
        Case #PB_EventType_Repaint
          Debug " -- Canvas repaint -- "
        Case #PB_EventType_Input 
          *this\canvas\input = GetGadgetAttribute(*this\canvas\gadget, #PB_Canvas_Input)
          *this\canvas\Key[1] = GetGadgetAttribute(*this\canvas\gadget, #PB_Canvas_Modifiers)
        Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
          *this\canvas\Key = GetGadgetAttribute(*this\canvas\gadget, #PB_Canvas_Key)
          *this\canvas\Key[1] = GetGadgetAttribute(*this\canvas\gadget, #PB_Canvas_Modifiers)
        Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
          *this\canvas\mouse\x = GetGadgetAttribute(*this\canvas\gadget, #PB_Canvas_MouseX)
          *this\canvas\mouse\y = GetGadgetAttribute(*this\canvas\gadget, #PB_Canvas_MouseY)
        Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
             #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
             #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
          
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            *this\canvas\mouse\from = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                         (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                         (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
          CompilerElse
            *this\canvas\mouse\from = GetGadgetAttribute(*this\canvas\gadget, #PB_Canvas_Buttons)
          CompilerEndIf
      EndSelect
      
      mouse_x = *this\canvas\mouse\x
      mouse_y = *this\canvas\mouse\y
    EndIf
    
    Macro _callback_(_this_, _type_)
      ;SelectElement(_this_\columns(), 0)
      Select _type_
          ;         Case #PB_EventType_LostFocus  : Debug ""+#PB_Compiler_Line +" lost focus " + _this_ +" "+ _this_\from
          ;           
          ;           _this_\items()\color\state = 3
          ;           _this_\color\state = 0
          ;           Result = #True
          ;           
          ;         Case #PB_EventType_Focus  : Debug ""+#PB_Compiler_Line +" focus " + _this_ +" "+ _this_\from
          ;           
          ;           _this_\color\state = 2
          ;           Result = #True
          
        Case #PB_EventType_MouseLeave  ;: Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          If (_this_\columns()\items()\color\state = 1 Or down)
            _this_\columns()\items()\color\state = 0
            Result = #True
          EndIf
          
        Case #PB_EventType_MouseEnter  ;: Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          
          If down And _this_\flag\multiselect 
            PushListPosition(_this_\columns()\items()) 
            ForEach _this_\columns()\items()
              If  Not _this_\columns()\items()\hide
                If ((_this_\_i_selected\index >= _this_\columns()\items()\index And _this_\from =< _this_\columns()\items()\index) Or ; верх
                    (_this_\_i_selected\index =< _this_\columns()\items()\index And _this_\from >= _this_\columns()\items()\index))   ; вниз
                  
                  _this_\columns()\items()\color\state = 2
                Else
                  _this_\columns()\items()\color\state = 1
                EndIf
              EndIf
            Next
            PopListPosition(_this_\columns()\items()) 
            
            Result = #True
            
          ElseIf _this_\columns()\items()\color\state = 0
            _this_\columns()\items()\color\state = 1+Bool(down)
            
            Result = #True
          EndIf
          
        Case #PB_EventType_LeftButtonDown ; : Debug ""+#PB_Compiler_Line +" нажали " + _this_ +" "+ _this_\from
          
          If Not _this_\flag\clickselect And _this_\_i_selected
            _this_\_i_selected\color\state = 0
          EndIf
          
          If _this_\columns()\items()\color\state = 2
            _this_\columns()\items()\color\state = 0
          Else
            _this_\columns()\items()\color\state = 2
          EndIf
          
          _this_\_i_selected = _this_\columns()\items()
          
          If  _this_\flag\multiselect
            PushListPosition(_this_\columns()\items()) 
            ForEach _this_\columns()\items()
              If  Not _this_\columns()\items()\hide
                If ((_this_\_i_selected\index >= _this_\columns()\items()\index And _this_\from =< _this_\columns()\items()\index) Or ; верх
                    (_this_\_i_selected\index =< _this_\columns()\items()\index And _this_\from >= _this_\columns()\items()\index))   ; вниз
                  
                  _this_\columns()\items()\color\state = 2
                Else
                  _this_\columns()\items()\color\state = 1
                EndIf
              EndIf
            Next
            PopListPosition(_this_\columns()\items()) 
          EndIf
          
          Result = #True
          
        Case #PB_EventType_LeftButtonUp ; : Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
          
          If Not _this_\flag\multiselect
            If Not _this_\flag\clickselect
              If _this_\_i_selected 
                _this_\_i_selected\color\state = 0
              EndIf
              
              _this_\_i_selected = _this_\columns()\items()
              _this_\columns()\items()\color\state = 2
              
              Result = #True
            EndIf
          EndIf
          
      EndSelect
    EndMacro
    
    Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ =< (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ =< (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
    With *this
;       If \from =- 1
;         Result | Bar::CallBack(\scroll\v, EventType, mouse_x, mouse_y)
;         Result | Bar::CallBack(\scroll\h, EventType, mouse_x, mouse_y)
;         
; ;         If (\scroll\v\change Or \scroll\h\change)
; ;           _update_(*this)
; ;           \scroll\v\change = 0 
; ;           \scroll\h\change = 0
; ;         EndIf
;         
;         If Result
;           ProcedureReturn Result
;         EndIf
;       EndIf
      
      ; get at point buttons
      If Not \hide And ;\scroll\v\from =- 1 And \scroll\h\from =- 1 And
         ((_from_point_(mouse_x, mouse_y, *this, [2]) And Not Down) Or Down = *this)
        
        SelectElement(\columns(), 0)
        PushListPosition(\columns()\items())
        ;ForEach \columns()
        ForEach \columns()\items()
;           If \items()\hide Or (Not \items()\draw And Not Down)
;             Continue
;           EndIf
          
          If (mouse_y > \columns()\items()\y-\scroll\v\page\pos And
              mouse_y =< \columns()\items()\y+\columns()\items()\height-\scroll\v\page\pos)
            from = \columns()\items()\index
            Break 
          EndIf
        Next
        ;Next
        PopListPosition(\columns()\items())
        
        If \from <> from And Not (from =- 1 And Down)
          If *leave > 0 And *leave\from >= 0
            ; _from_point_(mouse_x, mouse_y, *leave, [2]) And
            If SelectElement(*leave\columns()\Items(), *leave\from)
              
              _callback_(*leave, #PB_EventType_MouseLeave)
              *leave\from =- 1
            EndIf
          EndIf
          
          \from = from
          *leave = *this
          
          If \from >= 0 And SelectElement(\columns()\items(), \from)
            _callback_(*this, #PB_EventType_MouseEnter)
          EndIf
        EndIf
      Else
        If \from >= 0 ;And SelectElement(\columns()\items(), \from)
          If EventType = #PB_EventType_LeftButtonUp
            _callback_(*this, #PB_EventType_LeftButtonUp)
          EndIf
          
          ; Debug ""+#PB_Compiler_Line +" Мышь покинул итем"
          _callback_(*this, #PB_EventType_MouseLeave)
        EndIf
        
        \from =- 1
        
        If *leave = *this
          *leave = 0
        EndIf
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseLeave 
          If Not Down : \from =- 1 : from =- 1 : LastX = 0 : LastY = 0 : EndIf
          
        Case #PB_EventType_LeftButtonUp 
          If \from >= 0 And Down = *this ; SelectElement(\items(), \from)
            Down = 0 : LastX = 0 : LastY = 0
            
            If Not ((\Flag\buttons And \columns()\items()\childrens And 
                     _from_point_(\canvas\mouse\x, \canvas\mouse\y, \columns()\items()\box[0])) Or
                    _from_point_(\canvas\mouse\x, \canvas\mouse\y, \columns()\items()\box[1]))
              
              _callback_(*this, #PB_EventType_LeftButtonUp)
            EndIf
            
            If from =- 1
              ; Debug ""+#PB_Compiler_Line +" Мышь cнаружи итема"
              _callback_(*this, #PB_EventType_MouseLeave)
              \from =- 1
            EndIf
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If from >= 0 ; And SelectElement(\items(), from)
            Down = *this
            \from = from 
            *leave = *this
            
            If *focus <> *this
              If *focus And *focus\_i_selected 
                ;                 If SelectElement(*focus\items(), *focus\_i_selected\index)
                ;                   _callback_(*focus, #PB_EventType_LostFocus)
                ;                 EndIf
                *focus\_i_selected\color\state = 3
                *focus\color\state = 0
              EndIf
              
              ;               If SelectElement(\items(), \from)
              ;                 _callback_(*this, #PB_EventType_Focus)
              ;               EndIf
              \color\state = 2
              *focus = *this
            EndIf
            
            If _from_point_(\canvas\mouse\x, \canvas\mouse\y, \columns()\items()\box[1])
              
              \items()\box[1]\checked ! 1
              
              Result = #True
            ElseIf (\Flag\buttons And \items()\childrens) And
                   _from_point_(\canvas\mouse\x, \canvas\mouse\y, \columns()\items()\box[0])
              
              Protected sublevel
              sublevel = \columns()\items()\sublevel
              \columns()\items()\box[0]\checked ! 1
              
              PushListPosition(\columns()\items())
              While NextElement(\columns()\items())
                If \columns()\items()\sublevel = sublevel
                  Break
                ElseIf \items()\sublevel > sublevel 
                  \items()\hide = Bool(\columns()\items()\parent\box[0]\checked | \columns()\items()\parent\hide)
                EndIf
              Wend
              PopListPosition(\columns()\items())
              
              ;               If StartDrawing(CanvasOutput(EventGadget()))
              \change = 1
;               _update_(*this)
              ;                 StopDrawing()
              ;               EndIf
              
              Result = #True
            Else
              _callback_(*this, #PB_EventType_LeftButtonDown)
            EndIf
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Widget(X.i, Y.i, Width.i, Height.i, ColumnTitle.s, ColumnWidth.i, Flag.i=0, Radius.i=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    If *This
      With *This
        \Type = #PB_GadgetType_ListIcon
;         \Cursor = #PB_Cursor_Default
;         \DrawingMode = #PB_2DDrawing_Default
        
        \Radius = Radius
        \sublevel = 18
        \Interact = 1
;         \Caret[1] =- 1
        \from =- 1
        \X =- 1
        \Y =- 1
        
        ; Set the Default widget flag
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fs = Bool(Not Flag&#PB_Flag_BorderLess)*2
        \bs = \fs
        
          \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
          \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
          \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
          \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
          \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
          
           \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
           \Flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
           \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
          
          \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine = 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine = 2
          Else
            \Text\MultiLine =- 1
          EndIf
          
          \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
          \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
          \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
          \Text\Pass = Bool(Flag&#PB_Text_Password)
          
          ;\Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
          ;\Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          ;\Text\Align\Right = Bool(Flag&#PB_Text_Right)
          ;\Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          ;           CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          ;             If \Text\Vertical
          ;               \Text\X = \fs 
          ;               \Text\y = \fs+5
          ;             Else
          ;               \Text\X = \fs+5
          ;               \Text\y = \fs
          ;             EndIf
          ;           CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
          ;             If \Text\Vertical
          ;               \Text\X = \fs 
          ;               \Text\y = \fs+1
          ;             Else
          \Text\X = \fs+2
          \Text\y = \fs
          ;             EndIf
          ;           CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
          ;             If \Text\Vertical
          ;               \Text\X = \fs 
          ;               \Text\y = \fs+6
          ;             Else
          ;               \Text\X = \fs+6
          ;               \Text\y = \fs
          ;             EndIf
          ;           CompilerEndIf 
          
          \Text\Change = 1
          \Color = Colors
          \Color\Fore[0] = 0
          
          If \Text\Editable
            \Text\Editable = 0
            \Color\Back[0] = $FFFFFFFF 
          Else
            \Color\Back[0] = $FFF0F0F0  
          EndIf
        
        \scroll\v = Bar::Widget(#PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        \scroll\h = Bar::Widget(#PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        Bar::Resizes(\scroll\v, \scroll\h, \bs,\bs,\Width[2],\Height[2])
        
        AddColumn(*This, 0,ColumnTitle, ColumnWidth)
        If Resize(*This, X,Y,Width,Height)
        EndIf
        \Resize = 0
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, ColumnTitle.s, ColumnWidth.i, Flag.i=0, Radius.i=0)
    Protected *Widget, *This._S_widget = AllocateStructure(_S_widget)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      *This = Widget(x, y, Width, Height, ColumnTitle.s, Flag, Radius)
      *this\canvas\gadget = Canvas
      If Not *this\canvas\window
        *this\canvas\window = GetGadgetData(Canvas)
      EndIf
      
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint, *This._S_widget = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint : Repaint = 1
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
        If *this And StartDrawing(CanvasOutput(\canvas\gadget))
          Draw(*this)
          StopDrawing()
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, x.i, y.i, width.i, height.i, ColumnTitle.s, ColumnWidth.i, flag.i=0)
    Protected g = CanvasGadget(Gadget, x, y, width, height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget = g : EndIf
    
    Protected *This._S_widget = AllocateStructure(_S_widget)
    With *This
      If *This
        *This = Widget(0, 0, Width.i, Height.i, ColumnTitle.s, ColumnWidth.i, Flag|#PB_Flag_NoButtons|#PB_Flag_NoLines)
        
        *this\canvas\gadget = Gadget
        If Not *this\canvas\window
          *this\canvas\window = GetGadgetData(Gadget)
        EndIf
        
        PostEvent(#PB_Event_Gadget, \Canvas\Window, Gadget, #PB_EventType_Resize)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndIf
    EndWith
    
    ProcedureReturn g
  EndProcedure
  
  Procedure Free(Gadget.i)
    Protected Result, *This._S_widget
    If IsGadget(Gadget) : *This._S_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      FreeStructure(*This)
      ; SetGadgetData(Gadget, #Null)
      UnbindGadgetEvent(Gadget, @CallBack())
      ; SetGadgetColor(Gadget, #PB_Gadget_BackColor, $FFFFFF)
      If StartDrawing(CanvasOutput(Gadget))
        Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
        StopDrawing()
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
EndModule

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule ListIcon
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
      If GadgetType(EventGadget()) = #PB_GadgetType_ListIcon
        Debug GetGadgetText(EventGadget())
        Debug GetGadgetState(EventGadget())
        Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
      Else
        Debug ListIcon::GetText(EventGadget())
        Debug ListIcon::GetState(EventGadget())
        Debug ListIcon::GetItemState(EventGadget(), ListIcon::GetState(EventGadget()))
      EndIf
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Define a,i
  
  If OpenWindow(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetActiveWindow(0)
    
    Define Count = 500
    Debug "Create items count - "+Str(Count)
    
    ;{ - gadget 
    Define t=ElapsedMilliseconds()
    Define g = 1
    ListIconGadget(g, 10, 10, 165, 210,"Column_1",90)                                         
    For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
    For i=0 To 7
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
    Next
    
    g = 2
    ListIconGadget(g, 180, 10, 165, 210,"Column_1",90)                                         
    For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
    For i=0 To Count
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                           
    Next
    
    g = 3
    ListIconGadget(g, 350, 10, 430, 210,"Column_1",90, #PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_CheckBoxes)                                         
    
    ;HideGadget(g,1)
    For i=1 To 2
      AddGadgetColumn(g, i,"Column_"+Str(i+1),90)
    Next
    ; 1_example
    For i=0 To 15
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
    Next
    ;HideGadget(g,0)
    
    Debug " time create gadget (listicon) - "+Str(ElapsedMilliseconds()-t)
    ;}
    
    
    ;{ - widget
    t=ElapsedMilliseconds()
    g = 11
    Gadget(g, 10, 230, 165, 210,"Column_1",90) : *g = GetGadgetData(g)                                        
    For i=1 To 2 : AddColumn(*g, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    For i=0 To 7
      AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                          
    Next
    
    g = 12
    Gadget(g, 180, 230, 165, 210,"Column_1",90, #PB_Flag_FullSelection) : *g = GetGadgetData(g)                                          
    For i=1 To 2 : AddColumn(*g, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    For i=0 To Count
      AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", -1)                                          
    Next
    
    g = 13
    Gadget(g, 350, 230, 430, 210,"Column_1",90, #PB_Flag_FullSelection|#PB_Flag_GridLines|#PB_Flag_CheckBoxes) : *g = GetGadgetData(g)                                          
    
    ;HideGadget(g,1)
    For i=1 To 2
      AddColumn(*g, i,"Column_"+Str(i+1),90)
    Next
    ; 1_example
    For i=0 To 15
      AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                         
    Next
    ;HideGadget(g,0)
    
    Debug " time create canvas (listicon) - "+Str(ElapsedMilliseconds()-t)
    ;}
    
    ;   Define *This.Gadget = GetGadgetData(g)
    ;   
    ;   With *This\Columns()
    ;     Debug "Scroll_Height "+*This\Scroll\Height
    ;   EndWith
    
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          End 
        Case #PB_Event_Widget
          Select EventGadget()
            Case 13
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "widget ScrollChange" +" "+ EventData()
                Case #PB_EventType_DragStart : Debug "widget dragStart"
                Case #PB_EventType_Change, #PB_EventType_LeftClick
                  Debug "widget id = " + GetState(EventGadget())
                  
                  If EventType() = #PB_EventType_Change
                    Debug "  widget change"
                  EndIf
              EndSelect
          EndSelect
          
        Case #PB_Event_Gadget
          Select EventGadget()
            Case 3
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "ScrollChange" +" "+ EventData()
                Case #PB_EventType_DragStart : Debug "gadget dragStart"
                Case #PB_EventType_Change, #PB_EventType_LeftClick
                  Debug "gadget id = " + GetGadgetState(EventGadget())
                  
                  If EventType() = #PB_EventType_Change
                    Debug "  gadget change"
                  EndIf
              EndSelect
          EndSelect
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -------v-----------------------------8----------------------------------
; EnableXP