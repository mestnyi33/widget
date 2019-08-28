
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
      _adress_\Color[_i_]\Line[_iii_] = _adress_\Color[0]\Line[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Fore[_ii_]
      _adress_\Color[_i_]\Fore[_iii_] = _adress_\Color[_i_]\Fore[_ii_]
    Else
      _adress_\Color[_i_]\Fore[_iii_] = _adress_\Color[0]\Fore[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Back[_ii_]
      _adress_\Color[_i_]\Back[_iii_] = _adress_\Color[_i_]\Back[_ii_]
    Else
      _adress_\Color[_i_]\Back[_iii_] = _adress_\Color[0]\Back[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Front[_ii_]
      _adress_\Color[_i_]\Front[_iii_] = _adress_\Color[_i_]\Front[_ii_]
    Else
      _adress_\Color[_i_]\Front[_iii_] = _adress_\Color[0]\Front[_ii_]
    EndIf
    
    If _adress_\Color[_i_]\Frame[_ii_]
      _adress_\Color[_i_]\Frame[_iii_] = _adress_\Color[_i_]\Frame[_ii_]
    Else
      _adress_\Color[_i_]\Frame[_iii_] = _adress_\Color[0]\Frame[_ii_]
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
    #PB__S_flagingle
    
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
  #PB_Flag_FullSelection = 512  ; #PB_ListIcon_FullRowSelect
  
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
  Prototype pFunc2()
  
  ;- STRUCTUREs
  ;- - _S_event
  Structure _S_event
    widget.i
    type.l
    item.l
    *data
    *callback.pFunc2
  EndStructure
  
  Structure _S_point
    y.i
    x.i
  EndStructure
  
  Structure _S_coordinate
    y.i[5]
    x.i[5]
    height.i[5]
    width.i[5]
  EndStructure
  
  Structure _S_mouse
    X.i
    Y.i
    From.i ; at point widget
    Buttons.i
    *Delta._S_mouse
  EndStructure
  
  Structure _S_align
    Right.b
    Bottom.b
    Vertical.b
    Horizontal.b
  EndStructure
  
  Structure _S_page
    Pos.i
    Len.i
    *end
  EndStructure
  
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
  
  Structure _S_flag
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
  
  Structure _S_image Extends _S_coordinate
    handle.i[2]
    change.b
    Align._S_align
  EndStructure
  
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
    
    Align._S_align
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
  
  ;- - _S_bar
  Structure _S_bar Extends _S_coordinate
    type.l
    from.l
    focus.l
    radius.l
    
    mode.l
    change.l
    cursor.l
    hide.b[2]
    vertical.b
    inverted.b
    direction.l
    scrollstep.l
    
    max.l
    min.l
    page._S_page
    area._S_page
    thumb._S_page
    color._S_color[4]
    button._S_button[4] 
    
    *text._S_text
    *event._S_event 
    *splitter._S_splitter
  EndStructure
  
  ;   Structure _S_bar Extends _S_coordinate
  ;     Window.i
  ;     Gadget.i
  ;       ScrollStep.i
  ;   
  ;     ;Both.b ; we see both scrolbars
  ;     
  ;     Size.i[4]
  ;     Type.i[4]
  ;     Focus.i
  ;     from.i
  ;     Radius.i
  ;     
  ;     Hide.b[2]
  ;     Disable.b[2]
  ;     Vertical.b
  ;     DrawingMode.i
  ;     
  ;     Max.i
  ;     Min.i
  ;     Page.Page_S
  ;     Area.Page_S
  ;     Thumb.Page_S
  ;     Button._S_button
  ;     Color._S_color[4]
  ;   EndStructure
  ;   
  Structure _S_scroll ;Extends _S_coordinate
    height.i[5]
    width.i[5]
    ;Orientation.b
    *V._S_bar
    *H._S_bar
  EndStructure
  
  Structure _S_canvas
    Mouse._S_mouse
    Gadget.i
    Window.i
    Widget.i
    
    Input.c
    Key.i[2]
  EndStructure
  
  Structure _S_widget Extends _S_coordinate
    Index.i  ; Index of new list element
    Handle.i ; Adress of new list element
             ;
    
    *Widget._S_widget
    Canvas._S_canvas
    Color._S_color[4]
    Text._S_text[4]
    Clip._S_coordinate
    *ToolTip._S_text
    
    Scroll._S_scroll
    
    Image._S_image
    box._S_coordinate
    Flag._S_flag
    
    *i_parent._S_widget
    *selected._S_widget
    
    bSize.b
    fSize.b[2]
    
    Hide.b[2]
    Disable.b[2]
    Cursor.i[2]
    
    Caret.i[3] ; 0 = Pos ; 1 = PosFixed
    Line.i[2]  ; 0 = Pos ; 1 = PosFixed
    
    
    Type.i
    
    From.i  ; at point widget | item
    Focus.i
    LostFocus.i
    
    Drag.b[2]
    Resize.b ; 
    Toggle.b ; 
    Checked.b[2]
    Vertical.b
    Interact.b ; будет ли взаимодействовать с пользователем?
    Radius.i
    Buttons.i
    
    
    ; tree
    time.i
    address.i[2]
    
    sublevel.i
    sublevellen.i
    sublevelpos.i
    
    *Data
    collapsed.b
    childrens.i
    Item.i
    Attribute.i
    change.b
    
    
    *Default
    Alpha.a[2]
    
    DrawingMode.i
    
    List Items._S_widget()
    List Columns._S_widget()
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
    \Back[2] = $C8E89C3D; $80E89C3D
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

;- >>> DECLAREMODULE
DeclareModule Bar
  EnableExplicit
  
  ;- CONSTANTs
  #PB_Bar_Vertical = 1
  
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 4
    #PB_Bar_ArrowSize 
    #PB_Bar_ButtonSize 
    #PB_Bar_ScrollStep
    #PB_Bar_NoButtons 
    #PB_Bar_Direction 
    #PB_Bar_Inverted 
    #PB_Bar_Ticks
    
    #PB_Bar_First
    #PB_Bar_Second
    #PB_Bar_FirstFixed
    #PB_Bar_SecondFixed
    #PB_Bar_FirstMinimumSize
    #PB_Bar_SecondMinimumSize
  EndEnumeration
  
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
  
  #_b_1 = 1
  #_b_2 = 2
  #_b_3 = 3
  
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
  UseModule Structures
  ;   Prototype pFunc2()
  
  ;   ;- STRUCTUREs
  ;   ;- - _S_event
  ;   Structure _S_event
  ;     widget.i
  ;     type.l
  ;     item.l
  ;     *data
  ;     *callback.pFunc2
  ;   EndStructure
  ;   
  ;   ;- - _S_coordinate
  ;   Structure _S_coordinate
  ;     x.l
  ;     y.l
  ;     width.l
  ;     height.l
  ;   EndStructure
  ;   
  ;   ;- - _S_color
  ;   Structure _S_color
  ;     state.b
  ;     alpha.a[2]
  ;     front.l[4]
  ;     fore.l[4]
  ;     back.l[4]
  ;     frame.l[4]
  ;   EndStructure
  ;   
  ;   ;- - _S_page
  ;   Structure _S_page
  ;     pos.l
  ;     len.l
  ;     *end
  ;   EndStructure
  ;   
  ;   ;- - _S_button
  ;   Structure _S_button Extends _S_coordinate
  ;     len.a
  ;     interact.b
  ;     arrow_size.a
  ;     arrow_type.b
  ;   EndStructure
  ;   
  ;   ;- - _S_scroll
  ;   Structure _S_scroll Extends _S_coordinate
  ;     *v._S_bar
  ;     *h._S_bar
  ;   EndStructure
  ;   
  ;   ;- - _S_splitter
  ;   Structure _S_splitter
  ;     *first;._S_bar
  ;     *second;._S_bar
  ;     
  ;     fixed.l[3]
  ;     
  ;     g_first.b
  ;     g_second.b
  ;   EndStructure
  ;   
  ;   ;- - _S_Text
  ;   Structure _S_text Extends _S_coordinate
  ;     fontID.i
  ;     string.s
  ;     change.b
  ;     rotate.f
  ;   EndStructure
  ;   
  ;   ;- - _S_bar
  ;   Structure _S_bar Extends _S_coordinate
  ;     type.l
  ;     from.l
  ;     focus.l
  ;     radius.l
  ;     
  ;     mode.l
  ;     change.l
  ;     cursor.l
  ;     hide.b[2]
  ;     vertical.b
  ;     inverted.b
  ;     direction.l
  ;     scrollstep.l
  ;     
  ;     max.l
  ;     min.l
  ;     page._S_page
  ;     area._S_page
  ;     thumb._S_page
  ;     color._S_color[4]
  ;     button._S_button[4] 
  ;     
  ;     *text._S_text
  ;     *event._S_event 
  ;     *splitter._S_splitter
  ;   EndStructure
  
  Global *event._S_event = AllocateStructure(_S_event)
  
  ;-
  ;- DECLAREs
  Declare.b Draw(*this)
  Declare.l Y(*this)
  Declare.l X(*this)
  Declare.l Width(*this)
  Declare.l Height(*this)
  Declare.b Hide(*this, State.b=#PB_Default)
  Declare.i SetPos(*this._S_bar, ThumbPos.i)
  
  Declare.i GetState(*this)
  Declare.i GetAttribute(*this, Attribute.i)
  
  Declare.b SetState(*this, ScrollPos.l)
  Declare.l SetAttribute(*this, Attribute.l, Value.l)
  Declare.b SetColor(*this, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  
  Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b CallBack(*this, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
  
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, Radius.l=0)
  Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=0)
  Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.l=0, Radius.l=0)
  Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=7)
  
  Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
  Declare.b Updates(*scroll._S_scroll, ScrollArea_X.l, ScrollArea_Y.l, ScrollArea_Width.l, ScrollArea_Height.l)
  Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
  
  Declare.b Post(eventtype.l, *this, item.l=#PB_All, *data=0)
  Declare.b Bind(*callBack, *this, eventtype.l=#PB_All)
  
  ;- MACROs
  Macro Widget()
    *event\widget
  EndMacro
  
  Macro Type()
    *event\type
  EndMacro
  
  Macro Item()
    *event\item
  EndMacro
  
  Macro Data()
    *event\data
  EndMacro
  
  ; Extract thumb len from (max area page) len
  ; Draw gradient box
  Macro _box_gradient_(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
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
  
EndDeclareModule

;- >>> MODULE
Module Bar
  ;- GLOBALs
  Global def_colors._S_color
  
  With def_colors                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[#Normal] = $80000000
    \fore[#Normal] = $FFF6F6F6 ; $FFF8F8F8 
    \back[#Normal] = $FFE2E2E2 ; $80E2E2E2
    \frame[#Normal] = $FFBABABA; $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[#Entered] = $80000000
    \fore[#Entered] = $FFEAEAEA ; $FFFAF8F8
    \back[#Entered] = $FFCECECE ; $80FCEADA
    \frame[#Entered] = $FF8F8F8F; $80FFC288
    
    ; Цвета если нажали на виджет
    \front[#Selected] = $FFFEFEFE
    \fore[#Selected] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    \back[#Selected] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    \frame[#Selected] = $FF6F6F6F; $C8DC9338 ; $80DC9338
    
    ; Цвета если дисабле виджет
    \front[#Disabled] = $FFBABABA
    \fore[#Disabled] = $FFF6F6F6 
    \back[#Disabled] = $FFE2E2E2 
    \frame[#Disabled] = $FFBABABA
    
  EndWith
  
  Macro _thumb_pos_(_this_, _scroll_pos_)
    (_this_\area\pos + Round(((_scroll_pos_)-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
    If _this_\thumb\pos < _this_\area\pos 
      _this_\thumb\pos = _this_\area\pos 
    EndIf 
    
    If _this_\thumb\pos > _this_\area\end
      _this_\thumb\pos = _this_\area\end
    EndIf
    
    If _this_\Vertical 
      _this_\button\x = _this_\X + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
      _this_\button\y = _this_\area\pos
      _this_\button\width = _this_\width - Bool(_this_\type=#PB_GadgetType_ScrollBar) 
      _this_\button\height = _this_\area\len               
    Else 
      _this_\button\x = _this_\area\pos
      _this_\button\y = _this_\Y + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
      _this_\button\width = _this_\area\len
      _this_\button\height = _this_\Height - Bool(_this_\type=#PB_GadgetType_ScrollBar)  
    EndIf
    
    ; _start_
    If _this_\button[#_b_1]\len And _this_\page\len
      If _scroll_pos_ = _this_\min
        _this_\color[#_b_1]\state = #Disabled
        _this_\button[#_b_1]\interact = 0
      Else
        _this_\color[#_b_1]\state = #Normal
        _this_\button[#_b_1]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type=#PB_GadgetType_ScrollBar
      If _this_\Vertical 
        ; Top button coordinate on vertical scroll bar
        _this_\button[#_b_1]\x = _this_\button\x
        _this_\button[#_b_1]\y = _this_\Y 
        _this_\button[#_b_1]\width = _this_\button\width
        _this_\button[#_b_1]\height = _this_\button[#_b_1]\len                   
      Else 
        ; Left button coordinate on horizontal scroll bar
        _this_\button[#_b_1]\x = _this_\X 
        _this_\button[#_b_1]\y = _this_\button\y
        _this_\button[#_b_1]\width = _this_\button[#_b_1]\len 
        _this_\button[#_b_1]\height = _this_\button\height 
      EndIf
    Else
      _this_\button[#_b_1]\x = _this_\X
      _this_\button[#_b_1]\y = _this_\Y
      
      If _this_\Vertical
        _this_\button[#_b_1]\width = _this_\width
        _this_\button[#_b_1]\height = _this_\thumb\pos-_this_\y
      Else
        _this_\button[#_b_1]\width = _this_\thumb\pos-_this_\x
        _this_\button[#_b_1]\height = _this_\height
      EndIf
    EndIf
    
    ; _stop_
    If _this_\button[#_b_2]\len And _this_\page\len
      If _scroll_pos_ = _this_\page\end
        _this_\color[#_b_2]\state = #Disabled
        _this_\button[#_b_2]\interact = 0
      Else
        _this_\color[#_b_2]\state = #Normal
        _this_\button[#_b_2]\interact = 1
      EndIf 
    EndIf
    
    If _this_\type=#PB_GadgetType_ScrollBar
      If _this_\Vertical 
        ; Botom button coordinate on vertical scroll bar
        _this_\button[#_b_2]\x = _this_\button\x
        _this_\button[#_b_2]\width = _this_\button\width
        _this_\button[#_b_2]\height = _this_\button[#_b_2]\len 
        _this_\button[#_b_2]\y = _this_\Y+_this_\Height-_this_\button[#_b_2]\height
      Else 
        ; Right button coordinate on horizontal scroll bar
        _this_\button[#_b_2]\y = _this_\button\y
        _this_\button[#_b_2]\height = _this_\button\height
        _this_\button[#_b_2]\width = _this_\button[#_b_2]\len 
        _this_\button[#_b_2]\x = _this_\X+_this_\width-_this_\button[#_b_2]\width 
      EndIf
      
    Else
      If _this_\Vertical
        _this_\button[#_b_2]\x = _this_\x
        _this_\button[#_b_2]\y = _this_\thumb\pos+_this_\thumb\len
        _this_\button[#_b_2]\width = _this_\width
        _this_\button[#_b_2]\height = _this_\height-(_this_\thumb\pos+_this_\thumb\len-_this_\y)
      Else
        _this_\button[#_b_2]\x = _this_\thumb\pos+_this_\thumb\len
        _this_\button[#_b_2]\y = _this_\Y
        _this_\button[#_b_2]\width = _this_\width-(_this_\thumb\pos+_this_\thumb\len-_this_\x)
        _this_\button[#_b_2]\height = _this_\height
      EndIf
    EndIf
    
    ; Thumb coordinate on scroll bar
    If _this_\thumb\len
      If _this_\button[#_b_3]\len <> _this_\thumb\len
        _this_\button[#_b_3]\len = _this_\thumb\len
      EndIf
      
      If _this_\Vertical
        _this_\button[#_b_3]\x = _this_\button\x 
        _this_\button[#_b_3]\width = _this_\button\width 
        _this_\button[#_b_3]\y = _this_\thumb\pos
        _this_\button[#_b_3]\height = _this_\thumb\len                              
      Else
        _this_\button[#_b_3]\y = _this_\button\y 
        _this_\button[#_b_3]\height = _this_\button\height
        _this_\button[#_b_3]\x = _this_\thumb\pos 
        _this_\button[#_b_3]\width = _this_\thumb\len                                  
      EndIf
      
    Else
      If _this_\type <> #PB_GadgetType_ProgressBar
        ; Эфект спин гаджета
        If _this_\Vertical
          _this_\button[#_b_2]\Height = _this_\Height/2 
          _this_\button[#_b_2]\y = _this_\y+_this_\button[#_b_2]\Height+Bool(_this_\Height%2) 
          
          _this_\button[#_b_1]\y = _this_\y 
          _this_\button[#_b_1]\Height = _this_\Height/2
          
        Else
          _this_\button[#_b_2]\width = _this_\width/2 
          _this_\button[#_b_2]\x = _this_\x+_this_\button[#_b_2]\width+Bool(_this_\width%2) 
          
          _this_\button[#_b_1]\x = _this_\x 
          _this_\button[#_b_1]\width = _this_\width/2
        EndIf
      EndIf
    EndIf
    
    If _this_\text
      _this_\text\change = 1
    EndIf
    
    ; Splitter childrens auto resize       
    If _this_\Splitter
      splitter_size(_this_)
    EndIf
    
    If _this_\change
      Post(#PB_EventType_StatusChange, _this_, _this_\from, _this_\direction)
    EndIf
  EndMacro
  
  ; Inverted scroll bar position
  Macro _scroll_invert_(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro _set_area_coordinate_(_this_)
    If _this_\vertical
      _this_\area\pos = _this_\y + _this_\button[#_b_1]\len
      _this_\area\len = _this_\height - (_this_\button[#_b_1]\len + _this_\button[#_b_2]\len)
    Else
      _this_\area\pos = _this_\x + _this_\button[#_b_1]\len
      _this_\area\len = _this_\width - (_this_\button[#_b_1]\len + _this_\button[#_b_2]\len)
    EndIf
    
    _this_\area\end = _this_\area\pos + (_this_\area\len-_this_\thumb\len)
  EndMacro
  
  Procedure.b splitter_size(*this._S_bar)
    If *this\splitter
      If *this\splitter\first
        If *this\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\vertical
            ResizeGadget(*this\splitter\first, *this\button[#_b_1]\x, (*this\button[#_b_2]\height+*this\thumb\len)-*this\button[#_b_1]\y, *this\button[#_b_1]\width, *this\button[#_b_1]\height)
          Else
            ResizeGadget(*this\splitter\first, *this\button[#_b_1]\x, *this\button[#_b_1]\y, *this\button[#_b_1]\width, *this\button[#_b_1]\height)
          EndIf
        Else
          Resize(*this\splitter\first, *this\button[#_b_1]\x, *this\button[#_b_1]\y, *this\button[#_b_1]\width, *this\button[#_b_1]\height)
        EndIf
      EndIf
      
      If *this\splitter\second
        If *this\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\vertical
            ResizeGadget(*this\splitter\second, *this\button[#_b_2]\x, (*this\button[#_b_1]\height+*this\thumb\len)-*this\button[#_b_2]\y, *this\button[#_b_2]\width, *this\button[#_b_2]\height)
          Else
            ResizeGadget(*this\splitter\second, *this\button[#_b_2]\x, *this\button[#_b_2]\y, *this\button[#_b_2]\width, *this\button[#_b_2]\height)
          EndIf
        Else
          Resize(*this\splitter\second, *this\button[#_b_2]\x, *this\button[#_b_2]\y, *this\button[#_b_2]\width, *this\button[#_b_2]\height)
        EndIf   
      EndIf   
    EndIf
  EndProcedure
  
  ;-
  ;- - DRAW
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
  
  Procedure.b Draw_Scroll(*this._S_bar)
    With *this
      
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X,\Y,\width,\height,\Radius,\Radius,\Color\Back&$FFFFFF|\color\alpha<<24)
        
        If \Vertical
          If (\page\len+Bool(\Radius)*(\width/4)) = \height
            Line( \x, \y, 1, \page\len+1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Else
            Line( \x, \y, 1, \height, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          EndIf
        Else
          If (\page\len+Bool(\Radius)*(\height/4)) = \width
            Line( \x, \y, \page\len+1, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Else
            Line( \x, \y, \width, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          EndIf
        EndIf
        
        If \thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_3]\x,\button[#_b_3]\y,\button[#_b_3]\width,\button[#_b_3]\height,\Color[3]\fore[\color[3]\state],\Color[3]\Back[\color[3]\state], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_3]\x,\button[#_b_3]\y,\button[#_b_3]\width,\button[#_b_3]\height,\Radius,\Radius,\Color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          
          Protected h=9
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2-3,h,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2,h,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2+3,h,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Else
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2-3,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2+3,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\Color[#_b_1]\fore[\color[#_b_1]\state],\Color[#_b_1]\Back[\color[#_b_1]\state], \Radius, \color\alpha)
          _box_gradient_(\Vertical,\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\Color[#_b_2]\fore[\color[#_b_2]\state],\Color[#_b_2]\Back[\color[#_b_2]\state], \Radius, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\Radius,\Radius,\Color[#_b_1]\frame[\color[#_b_1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\Radius,\Radius,\Color[#_b_2]\frame[\color[#_b_2]\state]&$FFFFFF|\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_b_1]\x+(\button[#_b_1]\width-\button[#_b_1]\arrow_size)/2,\button[#_b_1]\y+(\button[#_b_1]\height-\button[#_b_1]\arrow_size)/2, \button[#_b_1]\arrow_size, Bool(\Vertical), \Color[#_b_1]\front[\color[#_b_1]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_1]\arrow_type)
          Arrow(\button[#_b_2]\x+(\button[#_b_2]\width-\button[#_b_2]\arrow_size)/2,\button[#_b_2]\y+(\button[#_b_2]\height-\button[#_b_2]\arrow_size)/2, \button[#_b_2]\arrow_size, Bool(\Vertical)+2, \Color[#_b_2]\front[\color[#_b_2]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_2]\arrow_type)
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.b Draw_Track(*this._S_bar)
    With *This
      
      If Not \Hide
        Protected _pos_ = 6, _size_ = 4
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X,\Y,\Width,\Height,\Color\Back)
        
        If \Vertical
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+_pos_,\thumb\pos+\thumb\len-\button[#_b_2]\len,_size_,\Height-(\thumb\pos+\thumb\len-\y),\Color[#_b_2]\fore[\color[#_b_2]\state],\Color[#_b_2]\back[\color[#_b_2]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+_pos_,\thumb\pos+\thumb\len-\button[#_b_2]\len,_size_,\Height-(\thumb\pos+\thumb\len-\y),Bool(\radius),Bool(\radius),\Color[#_b_2]\frame[\color[#_b_2]\state])
          
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+_pos_,\Y+\button[#_b_1]\len,_size_,\thumb\pos-\y,\Color[#_b_1]\fore[\color[#_b_1]\state],\Color[#_b_1]\back[\color[#_b_1]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+_pos_,\Y+\button[#_b_1]\len,_size_,\thumb\pos-\y,Bool(\radius),Bool(\radius),\Color[#_b_1]\frame[\color[#_b_1]\state])
          
        Else
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+\button[#_b_1]\len,\Y+_pos_,\thumb\pos-\x,_size_,\Color[#_b_1]\fore[\color[#_b_1]\state],\Color[#_b_1]\back[\color[#_b_1]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+\button[#_b_1]\len,\Y+_pos_,\thumb\pos-\x,_size_,Bool(\radius),Bool(\radius),\Color[#_b_1]\frame[\color[#_b_1]\state])
          
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \thumb\pos+\thumb\len-\button[#_b_2]\len,\Y+_pos_,\Width-(\thumb\pos+\thumb\len-\x),_size_,\Color[#_b_2]\fore[\color[#_b_2]\state],\Color[#_b_2]\back[\color[#_b_2]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\thumb\pos+\thumb\len-\button[#_b_2]\len,\Y+_pos_,\Width-(\thumb\pos+\thumb\len-\x),_size_,Bool(\radius),Bool(\radius),\Color[#_b_2]\frame[\color[#_b_2]\state])
        EndIf
        
        
        If \thumb\len
          Protected i, track_pos.f, _thumb_ = (\thumb\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          If \vertical
            If \mode = #PB_Bar_Ticks
              For i=0 To \page\end-\min
                track_pos = (\area\pos + Round(i * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
                Line(\button[3]\x+\button[3]\width-4,track_pos,4, 1,\Color[3]\Frame)
              Next
            Else
              Line(\button[3]\x+\button[3]\width-4,\area\pos + _thumb_,4, 1,\Color[3]\Frame)
              Line(\button[3]\x+\button[3]\width-4,\area\pos + \area\len + _thumb_,4, 1,\Color[3]\Frame)
            EndIf
          Else
            If \mode = #PB_Bar_Ticks
              For i=0 To \page\end-\min
                track_pos = (\area\pos + Round(i * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
                Line(track_pos, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
              Next
            Else
              Line(\area\pos + _thumb_, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
              Line(\area\pos + \area\len + _thumb_, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
            EndIf
          EndIf
          
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_b_3]\x+Bool(\vertical),\button[#_b_3]\y+Bool(Not \vertical),\button[#_b_3]\len,\button[#_b_3]\len,\Color[3]\fore[#_b_2],\Color[3]\Back[#_b_2], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_3]\x+Bool(\vertical),\button[#_b_3]\y+Bool(Not \vertical),\button[#_b_3]\len,\button[#_b_3]\len,\Radius,\Radius,\Color[3]\frame[#_b_2]&$FFFFFF|\color\alpha<<24)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_b_3]\x+(\button[#_b_3]\len-\button[#_b_3]\arrow_size)/2+Bool(\Vertical),\button[#_b_3]\y+(\button[#_b_3]\len-\button[#_b_3]\arrow_size)/2+Bool(Not \Vertical), 
                \button[#_b_3]\arrow_size, Bool(\Vertical)+Bool(Not \inverted And \direction>0)*2+Bool(\inverted And \direction=<0)*2, \Color[#_b_3]\frame[\color[#_b_3]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_3]\arrow_type)
          
        EndIf
        
      EndIf
      
    EndWith 
    
  EndProcedure
  
  Procedure.b Draw_Progress(*this._S_bar)
    
    ; Selected Back
    DrawingMode(#PB_2DDrawing_Gradient)
    _box_gradient_(*this\vertical, *this\button[#_b_1]\X,*this\button[#_b_1]\Y,*this\button[#_b_1]\width,*this\button[#_b_1]\height,*this\color[#_b_1]\fore[*this\color[#_b_1]\state],*this\color[#_b_1]\back[*this\color[#_b_1]\state])
    
    ; Normal Back
    DrawingMode(#PB_2DDrawing_Gradient)
    _box_gradient_(*this\vertical, *this\button[#_b_2]\x, *this\button[#_b_2]\y,*this\button[#_b_2]\width,*this\button[#_b_2]\height,*this\color[#_b_2]\fore[*this\color[#_b_2]\state],*this\color[#_b_2]\back[*this\color[#_b_2]\state])
    
    If *this\vertical
      ; Frame_1
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\pos
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,1,*this\button[#_b_1]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,*this\button[#_b_1]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\X+*this\button[#_b_1]\width-1,*this\button[#_b_1]\Y,1,*this\button[#_b_1]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      Else
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,*this\button[#_b_1]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      EndIf
      
      ; Frame_2
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\end
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\y,1,*this\button[#_b_2]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\Y+*this\button[#_b_2]\height-1,*this\button[#_b_2]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x+*this\button[#_b_2]\width-1,*this\button[#_b_2]\y,1,*this\button[#_b_2]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      Else
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\Y+*this\button[#_b_2]\height-1,*this\button[#_b_2]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      EndIf
      
    Else
      ; Frame_1
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\pos
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,*this\button[#_b_1]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,1,*this\button[#_b_1]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y+*this\button[#_b_1]\height-1,*this\button[#_b_1]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      Else
        Line(*this\button[#_b_1]\X,*this\button[#_b_1]\Y,1,*this\button[#_b_1]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      EndIf
      
      ; Frame_2
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\end
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\Y,*this\button[#_b_2]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x+*this\button[#_b_2]\width-1,*this\button[#_b_2]\Y,1,*this\button[#_b_2]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\Y+*this\button[#_b_2]\height-1,*this\button[#_b_2]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      Else
        Line(*this\button[#_b_2]\x+*this\button[#_b_2]\width-1,*this\button[#_b_2]\Y,1,*this\button[#_b_2]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      EndIf
    EndIf
    
    ; Text
    If *this\text
      If *this\text\change 
        *this\text\change = 0
        *this\text\string = "%"+Str(*this\Page\Pos)
        *this\text\width = TextWidth(*this\text\string)
        *this\text\height = TextHeight("A")
        
        If *this\vertical
          If *this\text\rotate = 90
            *this\text\x = *this\x+(*this\width-*this\text\height)/2
            *this\text\y = *this\y+(*this\height+*this\text\width)/2
          ElseIf *this\text\rotate = 270
            *this\text\x = *this\x+(*this\width+*this\text\height)/2  + Bool(#PB_Compiler_OS = #PB_OS_MacOS)*1
            *this\text\y = *this\y+(*this\height-*this\text\width)/2
          EndIf
        Else
          *this\text\x = *this\x+(*this\width-*this\text\width)/2
          *this\text\y = *this\y+(*this\height-*this\text\height)/2
        EndIf
      EndIf
      
      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
      DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color[3]\frame)
    EndIf
    
  EndProcedure
  
  Procedure.b Draw_Splitter(*this._S_bar)
    Protected Pos, Size, Radius.d = 2
    
    With *this
      If *this > 0
        DrawingMode(#PB_2DDrawing_Outlined)
        If \mode
          Protected *first._S_bar = \splitter\first
          Protected *second._S_bar = \splitter\second
          
          If Not \splitter\g_first And (Not *first Or (*first And Not *first\splitter))
            Box(\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\Color[3]\frame[\color[#_b_1]\state])
          EndIf
          If Not \splitter\g_second And (Not *second Or (*second And Not *second\splitter))
            Box(\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\Color[3]\frame[\color[#_b_2]\state])
          EndIf
        EndIf
        
        If \mode = #PB_Splitter_Separator
          ; Позиция сплиттера 
          Size = \Thumb\len/2
          Pos = \Thumb\Pos+Size
          
          If \Vertical ; horisontal
            Circle(\button[#_b_3]\X+((\button[#_b_3]\Width-Radius)/2-((Radius*2+2)*2+2)), Pos,Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(\button[#_b_3]\X+((\button[#_b_3]\Width-Radius)/2-(Radius*2+2)),       Pos,Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(\button[#_b_3]\X+((\button[#_b_3]\Width-Radius)/2),                    Pos,Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(\button[#_b_3]\X+((\button[#_b_3]\Width-Radius)/2+(Radius*2+2)),       Pos,Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(\button[#_b_3]\X+((\button[#_b_3]\Width-Radius)/2+((Radius*2+2)*2+2)), Pos,Radius,\Color[#_b_3]\Frame[#Selected])
          Else
            Circle(Pos,\button[#_b_3]\Y+((\button[#_b_3]\Height-Radius)/2-((Radius*2+2)*2+2)),Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(Pos,\button[#_b_3]\Y+((\button[#_b_3]\Height-Radius)/2-(Radius*2+2)),      Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(Pos,\button[#_b_3]\Y+((\button[#_b_3]\Height-Radius)/2),                   Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(Pos,\button[#_b_3]\Y+((\button[#_b_3]\Height-Radius)/2+(Radius*2+2)),      Radius,\Color[#_b_3]\Frame[#Selected])
            Circle(Pos,\button[#_b_3]\Y+((\button[#_b_3]\Height-Radius)/2+((Radius*2+2)*2+2)),Radius,\Color[#_b_3]\Frame[#Selected])
          EndIf
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.b Draw(*this._S_bar)
    With *this
      If \text And \text\fontID 
        DrawingFont(\text\fontID)
      EndIf
      
      Select \type
        Case #PB_GadgetType_TrackBar    : Draw_Track(*this)
        Case #PB_GadgetType_ScrollBar   : Draw_Scroll(*this)
        Case #PB_GadgetType_Splitter    : Draw_Splitter(*this)
        Case #PB_GadgetType_ProgressBar : Draw_Progress(*this)
      EndSelect
      
    EndWith
  EndProcedure
  
  ;-
  Procedure.l X(*this._S_bar)
    ProcedureReturn *this\x + Bool(*this\hide[1]) * *this\width
  EndProcedure
  
  Procedure.l Y(*this._S_bar)
    ProcedureReturn *this\y + Bool(*this\hide[1]) * *this\height
  EndProcedure
  
  Procedure.l Width(*this._S_bar)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\width
  EndProcedure
  
  Procedure.l Height(*this._S_bar)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\height
  EndProcedure
  
  Procedure.b Hide(*this._S_bar, State.b = #PB_Default)
    *this\hide ! Bool(*this\hide <> State And State <> #PB_Default)
    ProcedureReturn *this\hide
  EndProcedure
  
  ;- GET
  Procedure.i GetState(*this._S_bar)
    ProcedureReturn *this\page\pos
  EndProcedure
  
  Procedure.i GetAttribute(*this._S_bar, Attribute.i)
    Protected Result.i
    
    With *this
      Select Attribute
        Case #PB_Bar_Minimum : Result = \min  ; 1
        Case #PB_Bar_Maximum : Result = \max  ; 2
        Case #PB_Bar_PageLength : Result = \page\len
        Case #PB_Bar_Inverted : Result = \inverted
        Case #PB_Bar_Direction : Result = \direction
        Case #PB_Bar_NoButtons : Result = \button\len 
        Case #PB_Bar_ScrollStep : Result = \scrollstep
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;- SET
  Procedure.i SetPos(*this._S_bar, ThumbPos.i)
    Protected ScrollPos.i, Result.i
    
    With *this
      If \splitter And \splitter\fixed
        _set_area_coordinate_(*this)
      EndIf
      
      If ThumbPos < \area\pos : ThumbPos = \area\pos : EndIf
      If ThumbPos > \area\end : ThumbPos = \area\end : EndIf
      
      If \thumb\end <> ThumbPos 
        \thumb\end = ThumbPos
        
        ; from thumb pos get scroll pos 
        If \area\end <> ThumbPos
          ScrollPos = \min + Round((ThumbPos - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
        Else
          ScrollPos = \page\end
        EndIf
        
        If (#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical
          ScrollPos = _scroll_invert_(*this, ScrollPos, \inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState(*this._S_bar, ScrollPos.l)
    Protected Result.b
    
    With *this
      If ScrollPos < \min : ScrollPos = \min : EndIf
      
      If \max And ScrollPos > \max-\page\len
        If \max > \page\len 
          ScrollPos = \max-\page\len
        Else
          ScrollPos = \min 
        EndIf
      EndIf
      
      ;       If ScrollPos > \page\end 
      ;         ScrollPos = \page\end 
      ;         Debug \page\end
      ;       EndIf
      
      If Not ((#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical)
        ScrollPos = _scroll_invert_(*this, ScrollPos, \inverted)
      EndIf
      
      If \page\pos <> ScrollPos
        \change = \page\pos - ScrollPos
        
        If \type = #PB_GadgetType_TrackBar Or 
           \type = #PB_GadgetType_ProgressBar
          
          If \page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
        Else
          If \page\pos > ScrollPos
            If \inverted
              \direction = _scroll_invert_(*this, ScrollPos, \inverted)
            Else
              \direction =- ScrollPos
            EndIf
          Else
            If \inverted
              \direction =- _scroll_invert_(*this, ScrollPos, \inverted)
            Else
              \direction = ScrollPos
            EndIf
          EndIf
        EndIf
        
        \page\pos = ScrollPos
        \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, ScrollPos, \inverted))
        
        If \splitter And \splitter\fixed = #_b_1
          \splitter\fixed[\splitter\fixed] = \thumb\pos - \area\pos
          \page\pos = 0
        EndIf
        If \splitter And \splitter\fixed = #_b_2
          \splitter\fixed[\splitter\fixed] = \area\len - ((\thumb\pos+\thumb\len)-\area\pos)
          \page\pos = \max
        EndIf
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*this._S_bar, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      If \splitter
        Select Attribute
          Case #PB_Splitter_FirstMinimumSize : Attribute = #PB_Bar_FirstMinimumSize
          Case #PB_Splitter_SecondMinimumSize : Attribute = #PB_Bar_SecondMinimumSize
        EndSelect
      EndIf
      
      Select Attribute
        Case #PB_Bar_ScrollStep 
          \scrollstep = Value
          
        Case #PB_Bar_FirstMinimumSize
          \button[#_b_1]\len = Value
          Result = Bool(\max)
          
        Case #PB_Bar_SecondMinimumSize
          \button[#_b_2]\len = Value
          Result = Bool(\max)
          
        Case #PB_Bar_NoButtons
          If \button\len <> Value
            \button\len = Value
            \button[#_b_1]\len = Value
            \button[#_b_2]\len = Value
            Result = #True
          EndIf
          
        Case #PB_Bar_Inverted
          If \inverted <> Bool(Value)
            \inverted = Bool(Value)
            \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
          EndIf
          
        Case #PB_Bar_Minimum
          If \min <> Value
            \min = Value
            \page\pos = Value
            Result = #True
          EndIf
          
        Case #PB_Bar_Maximum
          If \max <> Value
            If \min > Value
              \max = \min + 1
            Else
              \max = Value
            EndIf
            
            Result = #True
          EndIf
          
        Case #PB_Bar_PageLength
          If \page\len <> Value
            If Value > (\max-\min) 
              \max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
              \page\len = (\max-\min)
            Else
              \page\len = Value
            EndIf
            
            Result = #True
          EndIf
          
      EndSelect
      
      If Result
        \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetColor(*this._S_bar, ColorType.l, Color.l, Item.l=- 1, State.l=1)
    Protected Result
    
    With *this
      Select ColorType
        Case #PB_Gadget_LineColor
          If Item=- 1
            \Color\front[State] = Color
          Else
            \Color[Item]\front[State] = Color
          EndIf
          
        Case #PB_Gadget_BackColor
          If Item=- 1
            \Color\Back[State] = Color
          Else
            \Color[Item]\Back[State] = Color
          EndIf
          
        Case #PB_Gadget_FrontColor
        Default ; Case #PB_Gadget_FrameColor
          If Item=- 1
            \Color\frame[State] = Color
          Else
            \Color[Item]\frame[State] = Color
          EndIf
          
      EndSelect
    EndWith
    
    ; ResetColor(*this)
    
    ProcedureReturn Bool(Color)
  EndProcedure
  
  ;-
  Procedure.b Resize(*this._S_bar, X.l,Y.l,Width.l,Height.l)
    With *this
      If X <> #PB_Ignore : \X = X : EndIf 
      If Y <> #PB_Ignore : \Y = Y : EndIf 
      If Width <> #PB_Ignore : \width = Width : EndIf 
      If Height <> #PB_Ignore : \Height = height : EndIf
      
      ;
      If (\max-\min) >= \page\len
        ; Get area screen coordinate pos (x&y) and len (width&height)
        _set_area_coordinate_(*this)
        
        If Not \max And \width And \height
          \max = \area\len-\button\len
          
          If Not \page\pos
            \page\pos = \max/2
          EndIf
          
          ;           ; if splitter fixed set splitter pos to center
          ;           If \splitter And \splitter\fixed = #_b_1
          ;             \splitter\fixed[\splitter\fixed] = \page\pos
          ;           EndIf
          ;           If \splitter And \splitter\fixed = #_b_2
          ;             \splitter\fixed[\splitter\fixed] = \area\len-\page\pos-\button\len
          ;           EndIf
        EndIf
        
        ;
        If \splitter 
          If \splitter\fixed
            If \area\len - \button\len > \splitter\fixed[\splitter\fixed] 
              \page\pos = Bool(\splitter\fixed = 2) * \max
              
              If \splitter\fixed[\splitter\fixed] > \button\len
                \area\pos + \splitter\fixed[1]
                \area\len - \splitter\fixed[2]
              EndIf
            Else
              \splitter\fixed[\splitter\fixed] = \area\len - \button\len
              \page\pos = Bool(\splitter\fixed = 1) * \max
            EndIf
          EndIf
          
          ; Debug ""+\area\len +" "+ Str(\button[#_b_1]\len + \button[#_b_2]\len)
          
          If \area\len =< \button\len
            \page\pos = \max/2
            
            If \Vertical
              \area\pos = \Y 
              \area\len = \Height
            Else
              \area\pos = \X
              \area\len = \width 
            EndIf
          EndIf
          
        EndIf
        
        If \area\len > \button\len
          \thumb\len = Round(\area\len - (\area\len / (\max-\min)) * ((\max-\min) - \page\len), #PB_Round_Nearest)
          
          If \thumb\len > \area\len 
            \thumb\len = \area\len 
          EndIf 
          
          If \thumb\len > \button\len
            \area\end = \area\pos + (\area\len-\thumb\len)
          Else
            \area\len = \area\len - (\button\len-\thumb\len)
            \area\end = \area\pos + (\area\len-\thumb\len)                              
            \thumb\len = \button\len
          EndIf
          
        Else
          If \splitter
            \thumb\len = \width
          Else
            \thumb\len = 0
          EndIf
          
          If \Vertical
            \area\pos = \Y
            \area\len = \Height
          Else
            \area\pos = \X
            \area\len = \width 
          EndIf
          
          \area\end = \area\pos + (\area\len - \thumb\len)
        EndIf
        
        \page\end = \max - \page\len
        \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
        
        If \thumb\pos = \area\end And \type = #PB_GadgetType_ScrollBar
          ; Debug " line-" + #PB_Compiler_Line +" "+  \type 
          SetState(*this, \max)
        EndIf
      EndIf
      
      \hide[1] = Bool(Not ((\max-\min) > \page\len))
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*scroll._S_scroll, ScrollArea_X.l, ScrollArea_Y.l, ScrollArea_Width.l, ScrollArea_Height.l)
    With *scroll
      Protected iWidth = (\v\x + Bool(\v\hide) * \v\width) - \h\x, iHeight = (\h\y + Bool(\h\hide) * \h\height) - \v\y
      ;Protected iWidth = \h\page\len, iHeight = \v\page\len
      Static hPos, vPos : vPos = \v\page\pos : hPos = \h\page\pos
      
      ; Вправо работает как надо
      If ScrollArea_Width<\h\page\pos+iWidth 
        ScrollArea_Width=\h\page\pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\page\pos And
             ScrollArea_Width=\h\page\pos+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<\v\page\pos+iHeight
        ScrollArea_Height=\v\page\pos+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\page\pos And
             ScrollArea_Height=\v\page\pos+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
      
      If ScrollArea_X<\h\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      ;       If -\v\page\pos > ScrollArea_Y : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      ;       If -\h\page\pos > ScrollArea_X : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      If -\v\page\pos > ScrollArea_Y And ScrollArea_Y<>\v\Page\Pos 
        SetState(\v, -ScrollArea_Y)
      EndIf
      
      If -\h\page\pos > ScrollArea_X And ScrollArea_X<>\h\Page\Pos 
        SetState(\h, -ScrollArea_X) 
      EndIf
      
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y + Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\width/4))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x + Bool(Not \v\hide And \v\Radius And \h\Radius)*(\h\height/4), #PB_Ignore)
      
      ;       *Scroll\Y =- \v\Page\Pos
      ;       *Scroll\X =- \h\Page\Pos
      ;       *Scroll\width = \v\Max
      ;       *Scroll\height = \h\Max
      
      
      
      If \v\hide : \v\page\pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\page\pos = vPos : EndIf
      If \h\hide : \h\page\pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\page\pos = hPos : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    If Not (*scroll\v And *scroll\h)
      ProcedureReturn
    EndIf
    
    With *scroll
      Protected iHeight, iWidth
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\page\len) : EndIf
      If \h\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\Radius And \h\Radius)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\Radius And \h\Radius)*(\h\height/4))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  ;-
  Macro _bar_(_this_, _min_, _max_, _page_length_, _flag_, _radius_=0)
    *event\widget = _this_
    _this_\scrollstep = 1
    _this_\radius = _radius_
    
    ; Цвет фона скролла
    _this_\color\alpha[0] = 255
    _this_\color\alpha[1] = 0
    
    _this_\color\back = $FFF9F9F9
    _this_\color\frame = _this_\color\back
    _this_\color\front = $FFFFFFFF ; line
    
    _this_\color[#_b_1] = def_colors
    _this_\color[#_b_2] = def_colors
    _this_\color[#_b_3] = def_colors
    
    _this_\vertical = Bool(_flag_&#PB_Bar_Vertical=#PB_Bar_Vertical)
    _this_\inverted = Bool(_flag_&#PB_Bar_Inverted=#PB_Bar_Inverted)
    
    If _this_\min <> _min_ : SetAttribute(_this_, #PB_Bar_Minimum, _min_) : EndIf
    If _this_\max <> _max_ : SetAttribute(_this_, #PB_Bar_Maximum, _max_) : EndIf
    If _this_\page\len <> _page_length_ : SetAttribute(_this_, #PB_Bar_PageLength, _page_length_) : EndIf
  EndMacro
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, Radius.l=0)
    Protected *this._S_bar = AllocateStructure(_S_bar)
    _bar_(*this, min, max, PageLength, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_ScrollBar
      \button[#_b_1]\arrow_type = 1
      \button[#_b_2]\arrow_type = 1
      \button[#_b_1]\arrow_size = 6
      \button[#_b_2]\arrow_size = 6
      ;\interact = 1
      \button[#_b_1]\interact = 1
      \button[#_b_2]\interact = 1
      \button[#_b_3]\interact = 1
      \from =- 1
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If Not Bool(Flag&#PB_Bar_NoButtons=#PB_Bar_NoButtons)
        If \vertical
          If width < 21
            \button\len = width - 1
          Else
            \button\len = 17
          EndIf
        Else
          If height < 21
            \button\len = height - 1
          Else
            \button\len = 17
          EndIf
        EndIf
        
        \button[#_b_1]\len = \button\len
        \button[#_b_2]\len = \button\len
      EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=7)
    Protected *this._S_bar = AllocateStructure(_S_bar)
    _bar_(*this, min, max, 0, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_TrackBar
      \inverted = \vertical
      \mode = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks) * #PB_Bar_Ticks
      \color[#_b_1]\state = Bool(Not \vertical) * #Selected
      \color[#_b_2]\state = Bool(\vertical) * #Selected
      \button\len = 15
      \button[#_b_1]\len = 1
      \button[#_b_2]\len = 1
      
      \button[#_b_3]\interact = 1
      \button[#_b_3]\arrow_size = 6
      \button[#_b_3]\arrow_type = 0
      
      \cursor = #PB_Cursor_Hand
      \from =- 1
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=0)
    Protected *this._S_bar = AllocateStructure(_S_bar)
    _bar_(*this, min, max, 0, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_ProgressBar
      \inverted = \vertical
      \color[#_b_1]\state = Bool(Not \vertical) * #Selected
      \color[#_b_2]\state = Bool(\vertical) * #Selected
      
      \button[#_b_3]\interact = 1
      \text = AllocateStructure(_S_text)
      \text\change = 1
      \text\rotate = \vertical * 90 ; 270
      
      CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
        \text\fontID = GetGadgetFont(#PB_Default)
      CompilerEndIf
      \from =- 1
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.l=0, Radius.l=0)
    Protected *this._S_bar = AllocateStructure(_S_bar)
    _bar_(*this, 0, 0, 0, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_Splitter
      \vertical ! 1 ; = Bool(Flag&#PB_Splitter_Vertical=0)
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If \vertical
        \cursor = #PB_Cursor_UpDown
      Else
        \cursor = #PB_Cursor_LeftRight
      EndIf
      
      \Splitter = AllocateStructure(_S_splitter)
      \Splitter\first = First
      \Splitter\second = Second
      \splitter\g_first = IsGadget(First)
      \splitter\g_second = IsGadget(Second)
      \button[#_b_3]\interact = 1
      
      If Flag&#PB_Splitter_SecondFixed
        \splitter\fixed = 2
      EndIf
      If Flag&#PB_Splitter_FirstFixed
        \splitter\fixed = 1
      EndIf
      
      If Bool(Flag&#PB_Splitter_Separator)
        \mode = #PB_Splitter_Separator
        \button\len = 7
      Else
        \mode = 1
        \button\len = 3
      EndIf
      \from =- 1
      
      ;\thumb\len=\button\len
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.b Post(eventtype.l, *this._S_bar, item.l=#PB_All, *data=0)
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
  
  Procedure.b Bind(*callBack, *this._S_bar, eventtype.l=#PB_All)
    *this\event = AllocateStructure(_S_event)
    *this\event\type = eventtype
    *this\event\callback = *callBack
  EndProcedure
  
  
  Procedure.b CallBack(*this._S_bar, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
    Protected Result, from
    Static cursor_change, LastX, LastY, Last, *leave._S_bar, Down
    
    Macro _callback_(_this_, _type_)
      Select _type_
        Case #PB_EventType_MouseLeave
          ; Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Normal 
          
          If _this_\cursor And cursor_change
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default) ; cursor_change - 1)
            cursor_change = 0
          EndIf
          Result = #True
          
        Case #PB_EventType_MouseEnter
          ; Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Entered 
          
          ; Set splitter cursor
          If _this_\from = #_b_3 And _this_\type = #PB_GadgetType_Splitter And _this_\cursor
            cursor_change = 1;GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) + 1
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, _this_\cursor)
          EndIf
          Result = #True
          
        Case #PB_EventType_LeftButtonDown
          ; Debug ""+#PB_Compiler_Line +" нажали " + _this_ +" "+ _this_\from
          
          Select _this_\from
            Case 1 
              If _this_\inverted
                Result = SetState(_this_, _scroll_invert_(_this_, (_this_\page\pos + _this_\scrollstep), _this_\inverted))
              Else
                Result = SetState(_this_, _scroll_invert_(_this_, (_this_\page\pos - _this_\scrollstep), _this_\inverted))
              EndIf
              
            Case 2 
              If _this_\inverted
                Result = SetState(_this_, _scroll_invert_(_this_, (_this_\page\pos - _this_\scrollstep), _this_\inverted))
              Else
                Result = SetState(_this_, _scroll_invert_(_this_, (_this_\page\pos + _this_\scrollstep), _this_\inverted))
              EndIf
              
            Case 3 
              LastX = MouseX - _this_\thumb\pos 
              LastY = MouseY - _this_\thumb\pos
              
            Default
              Result = #True
              
          EndSelect
          
          _this_\color[_this_\from]\state = #Selected
          
        Case #PB_EventType_LeftButtonUp
          ; Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Entered 
          Result = #True
          
      EndSelect
    EndMacro
    
    With *this
      ; from the very beginning we'll process 
      ; the splitter children’s widget
      If \splitter And \from <> #_b_3
        If \splitter\first And Not \splitter\g_first
          If CallBack(\splitter\first, EventType, MouseX, MouseY)
            ProcedureReturn 1
          EndIf
        EndIf
        If \splitter\second And Not \splitter\g_second
          If CallBack(\splitter\second, EventType, MouseX, MouseY)
            ProcedureReturn 1
          EndIf
        EndIf
      EndIf
      
      ; get at point buttons
      If Down ; GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
        If \from =- 1 Or (\from > 0 And MouseX>\button[\from ]\x And MouseX=<\button[\from ]\x+\button[\from ]\width And 
                          MouseY>\button[\from ]\y And MouseY=<\button[\from ]\y+\button[\from ]\height)
          from = \from 
        EndIf
      Else
        If Not \hide And (Mousex>=\x And Mousex<\x+\width And Mousey>\y And Mousey=<\y+\height) 
          If \button 
            If \button[#_b_3]\len And (MouseX>\button[#_b_3]\x And MouseX=<\button[#_b_3]\x+\button[#_b_3]\width And 
                                       MouseY>\button[#_b_3]\y And MouseY=<\button[#_b_3]\y+\button[#_b_3]\height)
              from = #_b_3
            ElseIf \button[#_b_2]\len And (MouseX>\button[#_b_2]\x And MouseX=<\button[#_b_2]\x+\button[#_b_2]\width And 
                                           MouseY>\button[#_b_2]\y And MouseY=<\button[#_b_2]\y+\button[#_b_2]\height)
              from = #_b_2
            ElseIf \button[#_b_1]\len And (MouseX>\button[#_b_1]\x And MouseX=<\button[#_b_1]\x+\button[#_b_1]\width And 
                                           MouseY>\button[#_b_1]\y And MouseY=<\button[#_b_1]\y+\button[#_b_1]\height)
              from = #_b_1
            ElseIf (MouseX>\button\x And MouseX=<\button\x+\button\width And 
                    MouseY>\button\y And MouseY=<\button\y+\button\height)
              from =- 1
            EndIf
            
            If \type = #PB_GadgetType_TrackBar ;Or \type = #PB_GadgetType_ProgressBar
              Select from
                Case #_b_1, #_b_2
                  from =- 1
                  
              EndSelect
              ; ElseIf \type = #PB_GadgetType_ProgressBar
              ;  from = 0
            EndIf
            
          Else
            from =- 1
          EndIf 
        Else
          If \from > 0 And \button[\from]\interact
            If EventType = #PB_EventType_LeftButtonUp
              _callback_(*this, #PB_EventType_LeftButtonUp)
            EndIf
            
            ; Debug ""+#PB_Compiler_Line +" Мышь покинул итем"
            _callback_(*this, #PB_EventType_MouseLeave)
          EndIf 
          
          \from = 0
        EndIf 
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseWheel  
          If *leave = *this
            Select WheelDelta
              Case-1 : Result = SetState(*this, \page\pos - (\max-\min)/30)
              Case 1 : Result = SetState(*this, \page\pos + (\max-\min)/30)
            EndSelect
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Down : \from = 0 : from = 0 : LastX = 0 : LastY = 0 : EndIf
          
        Case #PB_EventType_LeftButtonUp 
          Down = 0 : LastX = 0 : LastY = 0
          
          If \from > 0 And \button[\from]\interact
            _callback_(*this, #PB_EventType_LeftButtonUp)
            
            If Not from > 0
              ; Debug ""+#PB_Compiler_Line +" Мышь cнаружи итема"
              _callback_(*this, #PB_EventType_MouseLeave)
              \from = 0
            EndIf
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If from =- 1 And \button[#_b_3]\interact 
            If \Vertical
              Result = SetPos(*this, (MouseY-\thumb\len/2))
            Else
              Result = SetPos(*this, (MouseX-\thumb\len/2))
            EndIf
            
            from = 3
          EndIf
          
          If from > 0 And \button[from]\interact
            Down = 1
            \from = from 
            *leave = *this
            
            _callback_(*this, #PB_EventType_LeftButtonDown)
          EndIf
          
          ; Чтобы не пропускать событие
          ; внутри детей сплиттера
          If \from ; > 0 And \button[\from]\interact 
            Result = #True
          EndIf
          
        Case #PB_EventType_MouseMove
          If Down
            
            If *leave = *this And Bool(LastX|LastY) 
              If \Vertical
                Result = SetPos(*this, (MouseY-LastY))
              Else
                Result = SetPos(*this, (MouseX-LastX))
              EndIf
            EndIf
            
          Else
            If from
              If \from <> from
                If *leave > 0 And *leave\from > 0
                  If Not (MouseX>*leave\button[*leave\from]\x And MouseX=<*leave\button[*leave\from]\x+*leave\button[*leave\from]\width And 
                          MouseY>*leave\button[*leave\from]\y And MouseY=<*leave\button[*leave\from]\y+*leave\button[*leave\from]\height)
                    
                    ; set mouse leave from item
                    If *leave\button[*leave\from]\interact
                      _callback_(*leave, #PB_EventType_MouseLeave)
                      *leave\from = 0
                    EndIf
                  Else
                    *leave\from = 0 
                    *leave = 0
                  EndIf
                EndIf
                
                \from = from
                
                If \from > 0 And \button[\from]\interact
                  ; 10>>20>>30 
                  ;                   If (*leave And *leave\from =- 1)
                  ; ;                     If *leave
                  ; ;                       Debug ""+#PB_Compiler_Line +" "+ *this +" "+ *leave +" "+ *this\from +" "+ *leave\from
                  ; ;                     Else
                  ; ;                       Debug ""+#PB_Compiler_Line +" "+ *this +" "+ *leave +" "+ *this\from
                  ; ;                     EndIf
                  ;                     _callback_(*this, #PB_EventType_MouseEnter)
                  ;                    ; *leave\from = 0
                  ;                    ; ProcedureReturn
                  ;                   EndIf
                  ;                   
                  ;                   If Not (*leave And *leave\from =- 1)
                  _callback_(*this, #PB_EventType_MouseEnter)
                  ;                   EndIf
                EndIf
                
                If *leave <> *this 
                  
                  *leave = *this
                EndIf
              EndIf
              
            ElseIf *leave = *this
              If \from > 0 And \button[\from]\interact
                ; Debug ""+#PB_Compiler_Line +" Мышь перешел с итем"
                _callback_(*this, #PB_EventType_MouseLeave)
              EndIf 
              
              ; Debug ""+#PB_Compiler_Line +" Мышь находится снаружи"
              \from = 0
              *leave = 0
            EndIf
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  ;- - ENDMODULE
  ;-
EndModule


DeclareModule Tree
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  
  ;- - DECLAREs MACROs
  Macro CountItems(_this_)
    _this_\Text\Count
  EndMacro
  
  Macro ClearItems(_this_) 
    _this_\Text\Count = 0
    _this_\Text\Change = 1 
    If _this_\Text\Editable
      _this_\Text\String = #LF$
    EndIf
    PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
  EndMacro
  
  Macro RemoveItem(_this_, _item_) 
    _this_\Text\Count - 1
    _this_\Text\Change = 1
    If _this_\Text\Count =- 1 
      _this_\Text\Count = 0 
      _this_\Text\String = #LF$
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
    Else
      _this_\Text\String = RemoveString(_this_\Text\String, StringField(_this_\Text\String, _item_+1, #LF$) + #LF$)
    EndIf
  EndMacro
  
  
  ;- DECLAREs PROCEDUREs
  Declare.i GetState(*This._S_widget)
  Declare.i SetState(*This._S_widget, State.i)
  Declare.i AddItem(*This._S_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
  Declare.i SetFont(*This._S_widget, FontID.i)
  ; Declare.i GetItemState(*This._S_widget, Item.i)
  Declare.i SetItemState(*This._S_widget, Item.i, State.i)
  ;Declare.i CallBack(*This._S_widget, EventType.i)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
EndDeclareModule

Module Tree
  Macro _set_scroll_width_(_this_)
    If Not _this_\items()\hide And _this_\scroll\width < ((_this_\items()\text\x + _this_\items()\text\width) - _this_\x)
      _this_\scroll\width = ((_this_\items()\text\x + _this_\items()\text\width) - _this_\x)
      ; Debug "  w - "+_this_\width +" "+ _this_\scroll\width
    EndIf
  EndMacro
  
  Macro _set_scroll_height_(_this_)
    If Not _this_\Items()\hide
      _this_\scroll\height+_this_\text\height
      ; Debug "  h - "+_this_\height +" "+ _this_\scroll\height
    EndIf
  EndMacro
  
  
  ;-
  ;- PROCEDUREs
  ;-
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
  
  Procedure Selection(X, Y, SourceColor, TargetColor)
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
  
  Procedure.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
    Protected line$, ret$="", LineRet$=""
    Protected.i CountString, i, start, ii, found, length
    
    ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CR$, #LF$)
    ;     Text.s + #LF$
    ;     
    CountString = CountString(Text.s, #LF$) 
    
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
            If mode = 2 And CountString(Left((line$),ii), " ") > 1     And width > 71 ; button
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
        Width = \Width[1]-\Text\X*2  
        Height = \Height[1]-\Text\y*2 
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
      
      \Items()\Line =- 1
      \Items()\Focus =- 1
      \Items()\Item = Line
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
      
      If \Line[1] = ListIndex(\Items())
        ;Debug " string "+String.s
        \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret) : \Items()\Text[1]\Change = #True
        \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
      EndIf
      
      ;       ; Is visible lines
      ;       \Items()\Hide = Bool(Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
      
      ; Scroll width length
      _set_scroll_width_(*This)
      
      ; Scroll hight length
      _set_scroll_height_(*This)
      
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i MultiLine(*This._S_widget)
    Protected Repaint, String.s, text_width
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *This
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2
        Height = \Width[1]-\Text\y*2
      Else
        Width = \Width[1]-\Text\X*2  
        Height = \Height[1]-\Text\y*2 
      EndIf
      
      If \Text\MultiLine > 0
        String.s = Wrap(\Text\String.s, Width, \Text\MultiLine)
      Else
        String.s = \Text\String.s
      EndIf
      
      \Text\Position = 0
      
      If \Text\String.s[2] <> String.s Or \Text\Vertical
        If \Text\Editable And \Text\Change=-1 
          ; Посылаем сообщение об изменении содержимого 
          PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Change)
        EndIf
        
        \Text\String.s[2] = String.s
        \Text\Count = CountString(String.s, #LF$)
        
        ; Scroll width reset 
        \Scroll\Width = 0 
        _set_content_Y_(*This)
        
        ; 
        If ListSize(\Items()) 
          Protected Left,Right
          
          Right =- TextWidth(Mid(\Text\String.s, \Items()\Text\Position, \Caret))
          Left = (Width + Right)
          ; Debug " "+\Width[1] +" "+ Width +" "+ Left +" "+ Right
          
          If -*This\scroll\h\Page\Pos < Right
            *This\scroll\h\Page\Pos = Right
          ElseIf -*This\scroll\h\Page\Pos > Left
            *This\scroll\h\Page\Pos = Left
          ElseIf (-*This\scroll\h\Page\Pos < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
            *This\scroll\h\Page\Pos = (\Items()\Width-\Items()\Text[3]\Width) + Right
            If -*This\scroll\h\Page\Pos>0
              *This\scroll\h\Page\Pos=0
            EndIf
          EndIf
          
        EndIf
        
        If \Text\Count[1] <> \Text\Count Or \Text\Vertical
          \Text\Count[1] = \Text\Count
          
          ; Scroll hight reset 
          \Scroll\Height = 0
          ClearList(\Items())
          
          If \Text\Vertical
            For IT = \Text\Count To 1 Step - 1
              If AddElement(\Items())
                String = StringField(\Text\String.s[2], IT, #LF$)
                
                \Items()\Focus =- 1
                \Items()\Line =- 1
                
                If \Type = #PB_GadgetType_Button
                  \Items()\Text\Width = TextWidth(RTrim(String))
                Else
                  \Items()\Text\Width = TextWidth(String)
                EndIf
                
                If \Text\Align\Right
                  Text_X=(Width-\Items()\Text\Width) 
                ElseIf \Text\Align\Horizontal
                  Text_X=(Width-\Items()\Text\Width-Bool(\Items()\Text\Width % 2))/2 
                EndIf
                
                \Items()\x = \X[1]+\Text\Y+\Scroll\Height+Text_Y
                \Items()\y = \Y[1]+\Text\X+Text_X
                \Items()\Width = \Text\Height
                \Items()\Height = Width
                \Items()\Item = ListIndex(\Items())
                
                \Items()\Text\Editable = \Text\Editable 
                \Items()\Text\Vertical = \Text\Vertical
                If \Text\Rotate = 270
                  \Items()\Text\x = \Image\Width+\Items()\x+\Text\Height+\Text\X
                  \Items()\Text\y = \Items()\y
                Else
                  \Items()\Text\x = \Image\Width+\Items()\x
                  \Items()\Text\y = \Items()\y+\Items()\Text\Width
                EndIf
                \Items()\Text\Height = \Text\Height
                \Items()\Text\String.s = String.s
                \Items()\Text\Len = Len(String.s)
                
                _set_scroll_height_(*This)
              EndIf
            Next
          Else
            For IT = 1 To \Text\Count
              String = StringField(\Text\String.s[2], IT, #LF$)
              
              If AddElement(\Items())
                If \Type = #PB_GadgetType_Button
                  \Items()\Text\Width = TextWidth(RTrim(String.s))
                Else
                  \Items()\Text\Width = TextWidth(String.s)
                EndIf
                
                \Items()\Line =- 1
                \Items()\Focus =- 1
                \Items()\Radius = \Radius
                \Items()\Text\String.s = String.s
                \Items()\Item = ListIndex(\Items())
                
                ; Set line default colors             
                \Items()\Color = \Color
                \Items()\Color\State = 1
                \Items()\Color\Fore[\Items()\Color\State] = 0
                
                ; Update line pos in the text
                \Items()\Text\Position = \Text\Position
                \Items()\Text\Len = Len(String.s)
                \Text\Position + \Items()\Text\Len + 1 ; Len(#LF$)
                
                _set_content_X_(*This)
                _line_resize_X_(*This)
                _line_resize_Y_(*This)
                
                If \Line[1] = ListIndex(\Items())
                  ;Debug " string "+String.s
                  \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret) : \Items()\Text[1]\Change = #True
                  \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
                EndIf
                
                ; Scroll width length
                _set_scroll_width_(*This)
                
                ; Scroll hight length
                _set_scroll_height_(*This)
                
                ;                 AddLine(*This, ListIndex(\Items()), String.s)
              EndIf
            Next
          EndIf
        Else
          For IT = 1 To \Text\Count
            String.s = StringField(\Text\String.s[2], IT, #LF$)
            
            If SelectElement(\Items(), IT-1)
              If \Items()\Text\String.s <> String.s Or \Items()\Text\Change
                \Items()\Text\String.s = String.s
                
                If \Type = #PB_GadgetType_Button
                  \Items()\Text\Width = TextWidth(RTrim(String.s))
                Else
                  \Items()\Text\Width = TextWidth(String.s)
                EndIf
              EndIf
              
              ; Update line pos in the text
              \Items()\Text\Position = \Text\Position
              \Items()\Text\Len = Len(String.s)
              \Text\Position + \Items()\Text\Len + 1 ; Len(#LF$)
              
              ; Resize item
              If (Left And Not  Bool(-*This\scroll\h\Page\Pos = Left))
                _set_content_X_(*This)
              EndIf
              
              _line_resize_X_(*This)
              
              ; Set scroll width length
              _set_scroll_width_(*This)
            EndIf
          Next
        EndIf
      Else
        ; Scroll hight reset 
        \Scroll\Height = 0
        _set_content_Y_(*This)
        
        PushListPosition(\Items())
        ForEach \Items()
          If Not \Items()\Hide
            _set_content_X_(*This)
            _line_resize_X_(*This)
            _line_resize_Y_(*This)
            
            ; Scroll hight length
            _set_scroll_height_(*This)
          EndIf
        Next
        PopListPosition(\Items())
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Draw(*This._S_widget)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    
    Protected line_size = *This\Flag\Lines
    Protected box_size = *This\Flag\Buttons
    Protected check_box_size = *This\Flag\CheckBoxes
    
    If Not *This\Hide
      
      With *This
        iX=\X[2]
        iY=\Y[2]
        iwidth = *This\width[2]
        iheight = *This\height[2]
        
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          If \Text\Change
            \Text\Height[1] = TextHeight("A") + Bool(\Text\Count<>1 And \Flag\GridLines)
            If \Type = #PB_GadgetType_Tree
              \Text\Height = 20
            Else
              \Text\Height = \Text\Height[1]
            EndIf
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          MultiLine(*This)
        EndIf 
        
        _clip_output_(*This, \X,\Y,\Width,\Height)
        
        ; Draw back color
        If \Color\Fore[\Color\State]
          DrawingMode(#PB_2DDrawing_Gradient)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Back[\Color\State])
        EndIf
      EndWith 
      
      ; Draw items text
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height-*this\scroll\v\page\pos>*This\y[2] And (\y-*This\y[2])-*this\scroll\v\page\pos<iheight)
            ;\Hide = Bool(Not Drawing)
            
            If \hide
              Drawing = 0
            EndIf
            
            If Drawing
              If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
              _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
              
              If \Text\Change : \Text\Change = #False
                \Text\Width = TextWidth(\Text\String.s) 
                
                If \Text\FontID 
                  \Text\Height = TextHeight("A") 
                Else
                  \Text\Height = *This\Text\Height[1]
                EndIf
              EndIf 
              
              If \Text[1]\Change : \Text[1]\Change = #False
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              EndIf 
              
              If \Text[3]\Change : \Text[3]\Change = #False 
                \Text[3]\Width = TextWidth(\Text[3]\String.s)
              EndIf 
              
              If \Text[2]\Change : \Text[2]\Change = #False 
                \Text[2]\X = \Text\X+\Text[1]\Width
                \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf 
              
              ;               
              Protected Left,Right
              If *This\Focus = *This And *This\Text\Editable
                Left =- TextWidth(Mid(*This\Text\String.s, \Text\Position, *This\Caret))
                ; Left =- (\Text[1]\Width+(Bool(*This\Caret>*This\Caret[1])*\Text[2]\Width))
                Right = (\Width + Left)
                
                If -*this\scroll\h\page\pos < Left
                  *this\scroll\h\page\pos = Left
                ElseIf -*this\scroll\h\page\pos > Right
                  *this\scroll\h\page\pos = Right
                ElseIf (-*this\scroll\h\page\pos < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
                  *this\scroll\h\page\pos = (\Width-\Text[3]\Width) + Left
                  If -*this\scroll\h\page\pos>0
                    *this\scroll\h\page\pos=0
                  EndIf
                EndIf
              EndIf
            EndIf
            
            
            If \change = 1 : \change = 0
              Protected indent = 8 + Bool(*This\Image\width)*4
              ; Draw coordinates 
              \sublevellen = *This\Text\X + (7 - *This\sublevellen) + ((\sublevel + Bool(*This\Flag\Buttons)) * *This\sublevellen) + Bool(*This\Flag\CheckBoxes)*17
              \Image\X + \sublevellen + indent
              \Text\X + \sublevellen + *This\Image\width + indent
              
              ; Scroll width length
              _set_scroll_width_(*This)
            EndIf
            
            Height = \Height
            Y = \Y-*this\scroll\v\page\pos
            Text_X = \Text\X-*this\scroll\h\page\pos
            Text_Y = \Text\Y-*this\scroll\v\page\pos
            
            ; expanded & collapsed box
            If *This\Flag\Buttons Or *This\Flag\Lines 
              \box\width = box_size
              \box\height = box_size
              \box\x = *This\x+\sublevellen-(\box\width)/2-*this\scroll\h\page\pos
              \box\y = (Y+height)-(height+\box\height)/2
            EndIf
            
            If *This\Flag\CheckBoxes
              \box\width[1] = check_box_size
              \box\height[1] = check_box_size
              \box\x[1] = *This\x+(\box\width[1])/2-*this\scroll\h\page\pos
              \box\y[1] = (Y+height)-(height+\box\height[1])/2
            EndIf
            
            ; Draw selections
            If Drawing And (\Item=*This\Line Or \Item=\focus Or \Item=\line) ; \Color\State;
              If \Color\Fore[\Color\State]
                DrawingMode(#PB_2DDrawing_Gradient)
                BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
              Else
                DrawingMode(#PB_2DDrawing_Default)
                RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,\Color\Back[\Color\State])
              EndIf
              
              DrawingMode(#PB_2DDrawing_Outlined)
              RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, \Color\Frame[\Color\State])
            EndIf
            
            ; Draw plot
            If Not \hide And *This\Flag\Lines And *This\sublevellen
              Protected start
              Protected alpha = 255
              Protected point_color=$7E7E7E
              Protected x_point=\box\x+\box\width/2
              Protected y_point=\box\y+\box\height/2
              
              If x_point>*This\x[2]
                ; Horisontal plot
                ;DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotX())
                Line(x_point,y_point,*This\Flag\Lines,1, $FF000000)
                
                ; Vertical plot
                If \i_Parent
                  If \sublevel 
                    start = \i_Parent\y+\i_Parent\height+\i_Parent\height/2 -*this\scroll\v\page\pos - line_size
                  Else 
                    start = *This\y[2]+\i_Parent\height/2 -*this\scroll\v\page\pos
                  EndIf
                  
                  If start < *This\y[2]
                    start = *This\y[2]
                  EndIf
                  
                  If (y_point-start) > *This\height[2]
                    y_point = *This\height[2]
                  EndIf
                  
                  ;Debug ""+start +" "+ Str(y_point-start) +" "+ *This\y[2] +" "+ *This\height[2]
                  DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotY())
                  Line(x_point,start,1,y_point-start, $FF000000)
                EndIf
              EndIf
            EndIf
            
            If Drawing
              ; Draw boxes
              If *This\Flag\Buttons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                CompilerIf Defined(Bar, #PB_Module)
                  Bar::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, \Color\Front[\Color\State], 0,0) 
                CompilerEndIf
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                CheckBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, \Image\x-*this\scroll\h\page\pos, \Image\y-*this\scroll\v\page\pos, \alpha)
              EndIf
              
              ; Draw text
              _clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
              
              ; Draw string
              If \Text[2]\Len > 0
                DrawingMode(#PB_2DDrawing_Default)
                Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
              EndIf
              
              If \Color\State = 2
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, \Color\Front[\Color\State])
              Else
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
              EndIf
              
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            ; Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ;And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              If Bool(Not \Text[1]\Width Or *This\Caret > *This\Caret[1])
                Line((\Text\X-*this\scroll\h\page\pos) + \Text[1]\Width + \Text[2]\Width - Bool(-*this\scroll\h\page\pos = Right), \Y-*this\scroll\v\page\pos, 1, Height, $FFFFFFFF)
              Else
                Line((\Text\X-*this\scroll\h\page\pos) + \Text[1]\Width - Bool(-*this\scroll\h\page\pos = Right), \Y-*this\scroll\v\page\pos, 1, Height, $FFFFFFFF)
              EndIf
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(*This\Items())
          ; Draw scroll bars
          CompilerIf Defined(Bar, #PB_Module)
            UnclipOutput()
            
            If \scroll\v\Page\len And \scroll\v\Max<>\Scroll\Height-Bool(\Text\Count<>1 And \Flag\GridLines) And
               Bar::SetAttribute(\scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height-Bool(\Text\Count<>1 And \Flag\GridLines))
              
              \width[2] = \scroll\v\x - \bsize + Bool(\scroll\v\hide) * \scroll\v\width
            EndIf
            If \scroll\h\Page\len And \scroll\h\Max<>\Scroll\Width And
               Bar::SetAttribute(\scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
              
              \height[2] = \scroll\h\y - \bsize + Bool(\scroll\h\hide) * \scroll\h\height
            EndIf
            
            Bar::Draw(\scroll\v)
            Bar::Draw(\scroll\h)
          CompilerEndIf
          
          _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
          
          ; Draw image
          If \Image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
          EndIf
        EndIf
        
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Focus = *This
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[2])
          If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[2]) : EndIf  ; Сглаживание краев )))
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[2])
        ElseIf \fSize
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[\Color\State])
        EndIf
        
        If \Default
          ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF) : EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
          Else
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i ReDraw(*This._S_widget, Canvas =- 1, BackColor=$FFF0F0F0)
    If *This
      With *This
        If Canvas =- 1 
          Canvas = \Canvas\Gadget 
        ElseIf Canvas <> \Canvas\Gadget
          ProcedureReturn 0
        EndIf
        
        If StartDrawing(CanvasOutput(Canvas))
          Draw(*This)
          StopDrawing()
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  Procedure.i SetFont(*This._S_widget, FontID.i)
    Protected Result.i
    
    With *This
      If \Text\FontID <> FontID 
        \Text\FontID = FontID
        \Text\Change = 1
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i AddItem(*This._S_widget, Item.i,Text.s,Image.i=-1,Flag.i=0)
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
            \Items()\Item = ListIndex(\Items())
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
                adress = \Items()\address
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
                \Items()\address[1] = *Item
                \Items()\childrens + 1
                ;\Items()\collapsed = 1
                hide = 1
              EndIf
            EndIf
            PopListPosition(\Items())
            
            \Items()\sublevel = sublevel
            ;\Items()\hide = hide
          Else                                      
            ; ChangeCurrentElement(\Items(), *Item)
            ; PushListPosition(\Items()) 
            ; PopListPosition(\Items())
            adress = first
          EndIf
          
          \Items()\i_parent = adress
          
          If \Items()\address <> adress : \Items()\address = adress
            \Items()\change = Bool(\Type = #PB_GadgetType_Tree)
          EndIf
          \Items()\Text\FontID = \Text\FontID
          \Items()\alpha = 255
          \Items()\Line =- 1
          \Items()\focus =- 1
          \Items()\lostfocus =- 1
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
            \Items()\Image\handle[1] = Image
            
            \Image\width = \Items()\Image\width
          EndIf
          
          ; add lines
          AddLine(*This, Item.i, Text.s)
          
          \Items()\Color = Colors
          \Items()\Color[0]\State = 1
          \Items()\Color[0]\Fore[0] = 0 
          \Items()\Color[0]\Fore[1] = 0
          \Items()\Color[0]\Fore[2] = 0
          
          If Item = 0
            PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
          EndIf
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *Item
  EndProcedure
  
  Procedure.i SetItemState(*This._S_widget, Item.i, State.i)
    Protected Result
    
    With *This
      If (\Flag\MultiSelect Or \Flag\ClickSelect)
        PushListPosition(\Items())
        Result = SelectElement(\Items(), Item) 
        If Result 
          \Items()\Line = \Items()\Item
          \Items()\Color\State = Bool(State)+1
        EndIf
        PopListPosition(\Items())
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This._S_widget, State.i)
    With *This
      Redraw(*This, \Canvas\Gadget)
      
      PushListPosition(\Items())
      SelectElement(\Items(), State) : \Items()\Focus = State : \Items()\Line = \Items()\Item : \Items()\Color\State = 2
      Bar::SetState(\scroll\v, ((State*\Text\Height)-\scroll\v\Height) + \Text\Height) ; в конце
                                                                                       ; Bar::SetState(\scroll\v, (State*\Text\Height)) : \scroll\v\Page\Pos =- \scroll\v\Page\Pos ; в начале 
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  Procedure.i GetState(*This._S_widget)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Focus = \Items()\Item
          Result = \Items()\Item
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Resize(*This._S_widget, X.i,Y.i,Width.i,Height.i)
    Protected scroll_width
    Protected scroll_height
    
    With *This
      
      If \scroll And \scroll\v And \scroll\h
        If X=#PB_Ignore
          x=\x
        EndIf
        
        If y=#PB_Ignore
          y=\y
        EndIf
        
        If Width=#PB_Ignore
          Width=\Width
        EndIf
        
        If Height=#PB_Ignore
          Height=\Height
        EndIf
        
        Bar::Resizes(\scroll, x+\bSize,Y+\bSize,Width-\bSize*2,Height-\bSize*2)
        
        If x=\x
          X=#PB_Ignore
        EndIf
        
        If y=\y
          y=#PB_Ignore
        EndIf
        
        If Width=\Width
          Width=#PB_Ignore
        EndIf
        
        If Height=\Height
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
         \X[0] <> X
        \X[0] = X 
        \X[2]=\X[0]+\bSize
        \X[1]=\X[2]-\fSize
        \Resize = 1<<1
      EndIf
      If Y<>#PB_Ignore And 
         \Y[0] <> Y
        \Y[0] = Y
        \Y[2]=\Y[0]+\bSize
        \Y[1]=\Y[2]-\fSize
        \Resize = 1<<2
      EndIf
      If Width<>#PB_Ignore And
         \Width[0] <> Width 
        \Width[0] = Width 
        \Width[2] = \Width[0]-\bSize*2-scroll_width
        \Width[1] = \Width[0]-\bSize*2+\fSize*2
        \Resize = 1<<3
      EndIf
      If Height<>#PB_Ignore And 
         \Height[0] <> Height
        \Height[0] = Height 
        \Height[2] = \Height[0]-\bSize*2-scroll_height
        \Height[1] = \Height[0]-\bSize*2+\fSize*2
        \Resize = 1<<4
      EndIf
      
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure ToolTip(*This._S_text=0, ColorFont=0, ColorBack=0, ColorFrame=$FF)
    Protected Gadget
    Static Window
    Protected Color._S_color = Colors
    With *This
      If *This
        ; Debug "show tooltip "+\string
        ;         If Not Window
        Window = OpenWindow(#PB_Any, \x[1]-3,\y[1],\width+8,\height[1], "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Tool) ;|#PB_Window_NoGadgets
        Gadget = CanvasGadget(#PB_Any,0,0,\width+8,\height[1])
        If StartDrawing(CanvasOutput(Gadget))
          If \FontID : DrawingFont(\FontID) : EndIf 
          DrawingMode(#PB_2DDrawing_Default)
          Box(1,1,\width-2+8,\height[1]-2, Color\Back[1])
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText(3, (\height[1]-\height)/2, \String, Color\Front[1])
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(0,0,\width+8,\height[1], Color\Frame[1])
          StopDrawing()
        EndIf
        
        ; ;         Window = OpenWindow(#PB_Any, \x[1]-3,\y[1],\width+8,\height[1], "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Tool) ;|#PB_Window_NoGadgets
        ; ;         SetGadgetColor(ContainerGadget(#PB_Any,1,1,\width-2+8,\height[1]-2), #PB_Gadget_BackColor, Color\Back[1])
        ; ;         Gadget = StringGadget(#PB_Any,0,(\height[1]-\height)/2-1,\width-2+8,\height[1]-2, \string, #PB_String_BorderLess)
        ; ;         SetGadgetColor(Gadget, #PB_Gadget_BackColor, Color\Back[1])
        ; ;         SetWindowColor(Window, Color\Frame[1])
        ; ;         SetGadgetFont(Gadget, \FontID)
        ; ;         CloseGadgetList()
        
        
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
  
  Procedure.b _CallBack(*this._S_widget, EventType.l, MouseX.l=0, MouseY.l=0, WheelDelta.l=0)
    Protected Result, from =- 1
    Static *l._S_widget
    Static cursor_change, LastX, LastY, Last, *leave._S_widget, Down
    
    Macro _callback_(_this_, _type_)
      Select _type_
        Case #PB_EventType_MouseLeave  ;: Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          
          If (_this_\Items()\Color\State <> 2 Or down)
            _this_\Items()\Line =- 1
            _this_\Items()\Focus =- 1
            _this_\Items()\Color\State = 0
            Result = #True
          EndIf
          
        Case #PB_EventType_MouseEnter  ;: Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          
          If down And _this_\flag\multiselect 
            PushListPosition(_this_\Items()) 
            ForEach _this_\Items()
              If  Not _this_\Items()\Hide
                If ((_this_\selected\Item >= _this_\Items()\Item And _this_\from =< _this_\Items()\Item) Or ; верх
                    (_this_\selected\Item =< _this_\Items()\Item And _this_\from >= _this_\Items()\Item))   ; вниз
                  
                  If _this_\Items()\Line <> _this_\Items()\Item
                    _this_\Items()\Line = _this_\Items()\Item
                    _this_\items()\Color\State = 2
                  EndIf
                Else
                  _this_\Items()\Line =- 1
                  _this_\Items()\Color\State = 1
                  _this_\Items()\Focus =- 1
                EndIf
              EndIf
            Next
            PopListPosition(_this_\Items()) 
            
            Result = #True
            
          ElseIf _this_\Items()\Color\State <> 2
            _this_\Items()\Line = _this_\Items()\item
            _this_\Items()\Focus = _this_\Items()\item
            _this_\Items()\Color\State = 1+Bool(down)
            
            Result = #True
          EndIf
          
          
          ;           If _this_\Canvas\Mouse\Y < _this_\scroll\v\page\pos
          ;             
          ;             Bar::SetState(_this_\scroll\v, _this_\scroll\v\page\pos - _this_\Text\Height)
          ;           ElseIf _this_\Canvas\Mouse\Y >= _this_\scroll\v\max - _this_\scroll\v\page\end
          ;             
          ;             Bar::SetState(_this_\scroll\v, _this_\scroll\v\page\pos + _this_\Text\Height)
          ;           EndIf
          ;           _this_\Scroll\Y =- _this_\scroll\v\Page\Pos 
          
          ;           If Down And (_this_\Canvas\Mouse\Y < 0 And _this_\scroll\v\page\pos) Or _this_\Canvas\Mouse\Y >= _this_\scroll\v\max - _this_\scroll\v\page\end
          ;             Bar::SetState(_this_\scroll\v, ((_this_\from * _this_\Text\Height)-_this_\Scroll\v\Height) + _this_\Text\Height)
          ;             _this_\Scroll\Y =- _this_\scroll\v\Page\Pos                                   ; в конце
          ;           EndIf
          
          
          
        Case #PB_EventType_LeftButtonDown ; : Debug ""+#PB_Compiler_Line +" нажали " + _this_ +" "+ _this_\from
          
          If Not _this_\flag\clickselect And _this_\selected
            _this_\selected\Line =- 1
            _this_\selected\Color\State = 0
            _this_\selected\Focus =- 1
          EndIf
          
          If _this_\Items()\Color\State = 2
            _this_\Items()\Line =- 1
            _this_\Items()\Color\State = 0
            _this_\Items()\Focus =- 1
          Else
            _this_\Items()\Line = _this_\Items()\item
            _this_\Items()\Color\State = 2
            _this_\Items()\Focus = _this_\Items()\item
          EndIf
          
          _this_\selected = _this_\Items()
          
          If  _this_\flag\multiselect
            PushListPosition(_this_\Items()) 
            ForEach _this_\Items()
              If  Not _this_\Items()\Hide
                If ((_this_\selected\Item >= _this_\Items()\Item And _this_\from =< _this_\Items()\Item) Or ; верх
                    (_this_\selected\Item =< _this_\Items()\Item And _this_\from >= _this_\Items()\Item))   ; вниз
                  
                  If _this_\Items()\Line <> _this_\Items()\Item
                    _this_\Items()\Line = _this_\Items()\Item
                    _this_\items()\Color\State = 2
                  EndIf
                Else
                  _this_\Items()\Line =- 1
                  _this_\Items()\Color\State = 1
                  _this_\Items()\Focus =- 1
                EndIf
              EndIf
            Next
            PopListPosition(_this_\Items()) 
          EndIf
          
          Result = #True
          
        Case #PB_EventType_LeftButtonUp ; : Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
          
          If Not _this_\flag\multiselect
            If Not _this_\flag\clickselect
              If _this_\selected 
                _this_\selected\Line =- 1
                _this_\selected\Color\State = 0
                _this_\selected\Focus =- 1
              EndIf
              
              _this_\selected = _this_\Items()
              _this_\Items()\Line = _this_\Items()\item
              _this_\Items()\Color\State = 2
              _this_\Items()\Focus = _this_\Items()\item
              
              Result = #True
            EndIf
          EndIf
          
      EndSelect
    EndMacro
    
    With *this
      ;       ; from the very beginning we'll process 
      ;       ; the splitter children’s widget
      ;       If \splitter And \from <> #_b_3
      ;         If \splitter\first And Not \splitter\g_first
      ;           If CallBack(\splitter\first, EventType, MouseX, MouseY)
      ;             ProcedureReturn 1
      ;           EndIf
      ;         EndIf
      ;         If \splitter\second And Not \splitter\g_second
      ;           If CallBack(\splitter\second, EventType, MouseX, MouseY)
      ;             ProcedureReturn 1
      ;           EndIf
      ;         EndIf
      ;       EndIf
      
      ; get at point buttons
      If Not \hide And ((Mousex>\x[2] And Mousex=<\x[2]+\width[2] And Mousey>\y[2] And Mousey=<\y[2]+\height[2]) Or Down)
        
        PushListPosition(\items())
        ForEach \items()
          If Not \items()\hide And (MouseY>\items()\y And MouseY=<\items()\y+\items()\height)
            from = \items()\item
            Break
          EndIf
        Next
        PopListPosition(\items())
        
        ; from = ((\Canvas\Mouse\Y-\Y-\Text\Y+\scroll\v\Page\Pos) / \Text\Height)
        
        ;         If from < 0 : from = 0 : Else : If from < ListSize(\items()) : SelectElement(\items(), from) : Else : from = ListSize(\items()) - 1 : EndIf : EndIf
        
        If \from <> from
          If *leave > 0 And *leave\from >= 0
            SelectElement(\items(), *leave\from)
            
            If Not (MouseX>*leave\items()\x And MouseX=<*leave\items()\x+*leave\items()\width And 
                    MouseY>*leave\items()\y And MouseY=<*leave\items()\y+*leave\items()\height) ; And \button[\from]\interact
              
              _callback_(*leave, #PB_EventType_MouseLeave)
            EndIf
            
            *leave\from =- 1
          EndIf
          
          \from = from
          *leave = *this
          
          If \from >= 0 ; And \button[\from]\interact
            SelectElement(\items(), \from)
            
            _callback_(*this, #PB_EventType_MouseEnter)
          EndIf
        EndIf
        
      Else
        If \from >= 0 ;And \button[\from]\interact
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
          Down = 0 : LastX = 0 : LastY = 0
          
          If \from >= 0 ;And \button[\from]\interact
            If (\Canvas\Mouse\Y > (\Items()\box\y[1]) And \Canvas\Mouse\Y =< ((\Items()\box\y[1]+\Items()\box\height[1]))) And 
               ((\Canvas\Mouse\X > \Items()\box\x[1]) And (\Canvas\Mouse\X =< (\Items()\box\x[1]+\Items()\box\width[1])))
              
            ElseIf (\Flag\Buttons And \Items()\childrens) And
                   (\Canvas\Mouse\Y > (\Items()\box\y[0]) And \Canvas\Mouse\Y =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                   ((\Canvas\Mouse\X > \Items()\box\x[0]) And (\Canvas\Mouse\X =< (\Items()\box\x[0]+\Items()\box\width[0])))
              
            Else
              _callback_(*this, #PB_EventType_LeftButtonUp)
            EndIf
            
            If from =- 1
              ; Debug ""+#PB_Compiler_Line +" Мышь cнаружи итема"
              _callback_(*this, #PB_EventType_MouseLeave)
              \from =- 1
            EndIf
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If from >= 0 ;And \button[from]\interact
            Down = 1
            \from = from 
            *leave = *this
            
            If \from >= 0
              If (\Canvas\Mouse\Y > (\Items()\box\y[1]) And \Canvas\Mouse\Y =< ((\Items()\box\y[1]+\Items()\box\height[1]))) And 
                 ((\Canvas\Mouse\X > \Items()\box\x[1]) And (\Canvas\Mouse\X =< (\Items()\box\x[1]+\Items()\box\width[1])))
                
                \Items()\checked ! 1
                
              ElseIf (\Flag\Buttons And \Items()\childrens) And
                     (\Canvas\Mouse\Y > (\Items()\box\y[0]) And \Canvas\Mouse\Y =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                     ((\Canvas\Mouse\X > \Items()\box\x[0]) And (\Canvas\Mouse\X =< (\Items()\box\x[0]+\Items()\box\width[0])))
                
                Protected sublevel = \Items()\sublevel
                \Items()\collapsed ! 1
                
                PushListPosition(\Items())
                While NextElement(\Items())
                  If \Items()\sublevel = sublevel
                    Break
                  ElseIf \Items()\sublevel > sublevel 
                    \Items()\hide = Bool(\Items()\i_parent\collapsed | \Items()\i_parent\hide)
                  EndIf
                Wend
                
                Protected y=2
                \Scroll\Height = 0
                ForEach \Items()
                  If Not \items()\hide
                    \Items()\y = y
                    \Items()\text\y = y+(\Items()\height-\Items()\text\height)/2
                    ;\Items()\box\y = y
                    
                    y + \Text\Height;\Items()\height
                    _set_scroll_height_(*this)
                  EndIf
                Next
                PopListPosition(\Items())
                
                ; Break
              Else
                _callback_(*this, #PB_EventType_LeftButtonDown)
              EndIf
            EndIf
            
            
          EndIf
          
          ; Чтобы не пропускать событие
          ; внутри детей сплиттера
          If \from >= 0 ;And \button[\from]\interact 
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i CallBack(*This._S_widget, EventType.i)
    With *This
      Select EventType
        Case #PB_EventType_Repaint
          Debug " -- Canvas repaint -- "
        Case #PB_EventType_Input 
          \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
          \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
        Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
          \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
          \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
        Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
          \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
          \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
        Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
             #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
             #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
          
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            \Canvas\Mouse\Buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                    (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                    (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
          CompilerElse
            \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
          CompilerEndIf
      EndSelect
      
    EndWith
    
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      
      ;If *This And (Not *This\scroll\v\from And Not *This\scroll\h\from)
      ;\Flag\clickselect = 1
      
      If Not (\scroll\v\from=-1 Or \scroll\h\from=-1) And _CallBack(*this, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
        ProcedureReturn 1
      ElseIf \from =- 1
        Repaint | Bar::CallBack(\scroll\v, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
        Repaint | Bar::CallBack(\scroll\h, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
        ProcedureReturn Repaint
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  
  Procedure.i Widget(*This._S_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Tree
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \sublevellen = 18
        \Alpha = 255
        \Interact = 1
        \Caret[1] =- 1
        \Line =- 1
        \X =- 1
        \Y =- 1
        \from =- 1
        
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
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)*2
        \bSize = \fSize
        
        If Resize(*This, X,Y,Width,Height)
          \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
          \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
          \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
          \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
          \Flag\GridLines = 1;Bool(flag&#PB_Flag_GridLines)
          
          \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
          \Flag\Buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
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
          ;               \Text\X = \fSize 
          ;               \Text\y = \fSize+5
          ;             Else
          ;               \Text\X = \fSize+5
          ;               \Text\y = \fSize
          ;             EndIf
          ;           CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
          ;             If \Text\Vertical
          ;               \Text\X = \fSize 
          ;               \Text\y = \fSize+1
          ;             Else
          \Text\X = \fSize+2
          \Text\y = \fSize
          ;             EndIf
          ;           CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
          ;             If \Text\Vertical
          ;               \Text\X = \fSize 
          ;               \Text\y = \fSize+6
          ;             Else
          ;               \Text\X = \fSize+6
          ;               \Text\y = \fSize
          ;             EndIf
          ;           CompilerEndIf 
          
          \Text\Change = 1
          \Color = Colors
          \Color\Fore[0] = 0
          
          If \Text\Editable
            \Text\Editable = 0
            \Color[0]\Back[0] = $FFFFFFFF 
          Else
            \Color[0]\Back[0] = $FFF0F0F0  
          EndIf
          
        EndIf
        
        \scroll\v = Bar::Scroll(0, 0, 16, 0, 0,0,0, #PB_ScrollBar_Vertical, 7)
        \scroll\h = Bar::Scroll(0, 0, 0, Bool( Not Bool(\flag\Buttons And \flag\Lines))*16, 0,0,0, 0, 7)
        
        Bar::Resizes(\scroll, \x[2],\Y[2],\Width[2],\Height[2])
        
        ;         Bar::Widget(\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        ;         If Not Bool(Not \flag\Buttons And Not \flag\Lines)
        ;           Bar::Widget(\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        ;         EndIf
        ;         Bar::Resizes(\vScroll, \hScroll, \x[2],\y[2],\width[2],\height[2])
        \Resize = 0
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *This._S_widget = AllocateStructure(_S_widget)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
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
        ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This._S_widget = AllocateStructure(_S_widget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
EndModule


;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Tree
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
      If GadgetType(EventGadget()) = #PB_GadgetType_Tree
        Debug GetGadgetText(EventGadget())
        Debug GetGadgetState(EventGadget())
        Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
      Else
        ;         Debug Tree::GetText(GetGadgetData(EventGadget()))
        ;         Debug Tree::GetState(GetGadgetData(EventGadget()))
        ; Debug Tree::GetItemState(GetGadgetData(EventGadget()), Tree::GetState(GetGadgetData(EventGadget())))
      EndIf
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  
  If OpenWindow(0, 0, 0, 1110, 450, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a,g = 1
    TreeGadget(g, 10, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)                                         
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
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; RemoveGadgetItem(g,1)
    SetGadgetItemState(g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    BindGadgetEvent(g, @Events())
    
    ;SetActiveGadget(g)
    ;SetGadgetState(g, 1)
    ;     Debug "g "+ GetGadgetText(g)
    
    g = 2
    TreeGadget(g, 230, 10, 210, 210, #PB_Tree_AlwaysShowSelection)                                         
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
    
    ;     AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    ;     AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    ;     AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    ;     AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    ;     AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    ;     AddGadgetItem(g, 9, "Tree_2" )
    ;     AddGadgetItem(g, 10, "Tree_3", 0 )
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; ClearGadgetItems(g)
    
    g = 3
    TreeGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines|#PB_Tree_NoButtons|#PB_Tree_CheckBoxes)                                         
    ;   ;  2_example
    ;   AddGadgetItem(g, 0, "Normal Item "+Str(a), 0, 0) 
    ;   AddGadgetItem(g, 1, "Node "+Str(a), 0, 1)       
    ;   AddGadgetItem(g, 4, "Sub-Item 1", 0, 2)          
    ;   AddGadgetItem(g, 2, "Sub-Item 2", 0, 1)
    ;   AddGadgetItem(g, 3, "Sub-Item 3", 0, 1)
    
    ;  2_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)",ImageID(0)) 
    For i=1 To 20
      If i=5
        AddGadgetItem(g, -1, "Tree_"+Str(i), 0) 
      Else
        AddGadgetItem(g, -1, "Tree_"+Str(i), ImageID(0)) 
      EndIf
    Next
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 4
    TreeGadget(g, 670, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines)                                         
    ; 4_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 5
    TreeGadget(g, 890, 10, 103, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoButtons)                                         
    ; 5_example
    AddGadgetItem(g, 0, "Tree_0 (NoButtons)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 6
    TreeGadget(g, 890+106, 10, 103, 210, #PB_Tree_AlwaysShowSelection)                                         
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
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    
    g = 10
    Gadget(g, 10, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Tree_CheckBoxes|#PB_Flag_FullSelection)                                         
    *g._S_widget = GetGadgetData(g)
    ; 1_example
    AddItem (*g, 0, "Normal Item "+Str(a), -1, 0)                                   
    AddItem (*g, -1, "Node "+Str(a), 0, 0)                                         
    AddItem (*g, -1, "Sub-Item 1", -1, 1)                                           
    AddItem (*g, -1, "Sub-Item 2", -1, 11)
    AddItem (*g, -1, "Sub-Item 3", -1, 1)
    AddItem (*g, -1, "Sub-Item 4", -1, 1)                                           
    AddItem (*g, -1, "Sub-Item 5", -1, 11)
    AddItem (*g, -1, "Sub-Item 6", -1, 1)
    AddItem (*g, -1, "File "+Str(a), -1, 0)  
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    ; RemoveItem(*g,1)
    Tree::SetItemState(*g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    BindGadgetEvent(g, @Events())
    ;Tree::SetState(*g, 1)
    ;Tree::SetState(*g, -1)
    ;     Debug "c "+Tree::GetText(*g)
    
    g = 11
    Gadget(g, 230, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection)                                         
    *g = GetGadgetData(g)
    ;  3_example
    AddItem(*g, 0, "Tree_0", -1 )
    AddItem(*g, 1, "Tree_1_1", 0, 1) 
    AddItem(*g, 4, "Tree_1_1_1", -1, 2) 
    AddItem(*g, 5, "Tree_1_1_2", -1, 2) 
    AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(*g, 8, "Tree_1_1_2_1_1_4jhhhhhhhhhhhhh", -1, 4) 
    AddItem(*g, 7, "Tree_1_1_2_2", -1, 3) 
    AddItem(*g, 2, "Tree_1_2", -1, 1) 
    AddItem(*g, 3, "Tree_1_3", -1, 1) 
    AddItem(*g, 9, "Tree_2",-1 )
    AddItem(*g, 10, "Tree_3", -1 )
    
    ;     AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    ;     AddItem(*g, 8, "Tree_1_1_2_1_1_8", -1, 4) 
    ;     AddItem(*g, 7, "Tree_1_1_2_2", -1, 3) 
    ;     AddItem(*g, 2, "Tree_1_2", -1, 1) 
    ;     AddItem(*g, 3, "Tree_1_3", -1, 1) 
    ;     AddItem(*g, 9, "Tree_2",-1 )
    ;     AddItem(*g, 10, "Tree_3", -1 )
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    ; ClearItems(*g)
    
    g = 12
    Gadget(g, 450, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection|#PB_Flag_CheckBoxes)         ; |#PB_Flag_NoLines|#PB_Flag_NoButtons                                
    *g = GetGadgetData(g)
    ;   ;  2_example
    ;   AddItem (*g, 0, "Normal Item "+Str(a), -1, 0)                                    
    ;   AddItem (*g, 1, "Node "+Str(a), -1, 1)                                           
    ;   AddItem (*g, 4, "Sub-Item 1", -1, 2)                                            
    ;   AddItem (*g, 2, "Sub-Item 2", -1, 1)
    ;   AddItem (*g, 3, "Sub-Item 3", -1, 1)
    
    ;  2_example
    AddItem (*g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5
        AddItem(*g, -1, "Tree_"+Str(i), -1) 
      Else
        AddItem(*g, -1, "Tree_"+Str(i), 0) 
      EndIf
    Next
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    g = 13
    Gadget(g, 670, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Tree_NoLines)                                         
    *g = GetGadgetData(g)
    ;  4_example
    AddItem(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 3, "Tree_3_1", -1, 1) 
    AddItem(*g, 3, "Tree_3_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    
    g = 14
    Gadget(g, 890, 230, 103, 210, #PB_Flag_AlwaysSelection|#PB_Tree_NoButtons)                                         
    *g = GetGadgetData(g)
    ;  5_example
    AddItem(*g, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    g = 15
    Gadget(g, 890+106, 230, 103, 210, #PB_Flag_AlwaysSelection|#PB_Flag_BorderLess)                                         
    *g = GetGadgetData(g)
    ;  6_example
    AddItem(*g, 0, "Tree_1", -1, 1) 
    AddItem(*g, 0, "Tree_2_1", -1, 2) 
    AddItem(*g, 0, "Tree_2_2", -1, 3) 
    
    For i = 0 To 24
      If i % 5 = 0
        AddItem(*g, -1, "Directory" + Str(i), -1, 0)
      Else
        AddItem(*g, -1, "Item" + Str(i), -1, 1)
      EndIf
    Next i
    
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    ;Free(*g)
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          End 
        Case #PB_Event_Widget
          Select EventGadget()
            Case 12
              Select EventType()
                Case #PB_EventType_ScrollChange : Debug "widget ScrollChange" +" "+ EventData()
                Case #PB_EventType_DragStart : Debug "widget dragStart"
                Case #PB_EventType_Change, #PB_EventType_LeftClick
                  Debug "widget id = " + GetState(GetGadgetData(EventGadget()))
                  
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
; Folding = ----------------------------------------------------------------------------------
; EnableXP