; _module_tree_20.pb

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "../" ;/Users/As/Documents/GitHub/Widget"
  IncludeFile "fixme(mac).pbi"
CompilerEndIf


;- >>>
DeclareModule Constants
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
    #PB_Event_Create
    #PB_Event_MouseMove
    #PB_Event_LeftButtonDown
    #PB_Event_LeftButtonUp
    #PB_Event_Destroy
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_Move
    #PB_EventType_Size
    
    CompilerIf #PB_Compiler_Version < 547
      #PB_EventType_Resize
    CompilerEndIf
    
    #PB_EventType_Free
    #PB_EventType_Create
    ;#PB_EventType_Destroy
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
    #PB_EventType_Drop
  EndEnumeration
  
  ;- TREE CONSTANTs
  #__tree_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  #__tree_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #__tree_CheckBoxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
  #__tree_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
  
  EnumerationBinary 16
    #__tree_Collapse
    #__tree_AlwaysSelection
    #__tree_ClickSelect
    #__tree_MultiSelect
    #__tree_GridLines
    #__tree_OptionBoxes
    #__tree_BorderLess
    #__tree_FullSelection
  EndEnumeration
  
  #PB_Tree_Collapse = #__tree_Collapse
  #PB_Tree_GridLines = #__tree_GridLines
  
  Enumeration 1
    #__color_front
    #__color_back
    #__color_line
    #__color_titlefront
    #__color_titleback
    #__color_graytext 
    #__color_frame
  EndEnumeration
  
  #s_0 = 0
  #s_1 = 1
  #s_2 = 2
  #s_3 = 3
  
  #bb_1 = 1
  #bb_2 = 2
  #bb_3 = 3
  
  #__tree_Selected = #PB_Tree_Selected
  #__tree_Checked = #PB_Tree_Checked
  #__tree_Collapsed = #PB_Tree_Collapsed
  #__tree_Inbetween = #PB_Tree_Inbetween
  #__tree_Expanded = #PB_Tree_Expanded
  #__tree_SubLevel = #PB_Tree_SubLevel
  
  ;- BAR CONSTANTs
  #__bar_Vertical = 1
  
  #__bar_Minimum = 1
  #__bar_Maximum = 2
  #__bar_PageLength = 3
  
  EnumerationBinary 4
    #__bar_ArrowSize 
    #__bar_ButtonSize 
    #__bar_ScrollStep
    #__bar_NoButtons 
    #__bar_Direction 
    #__bar_Inverted 
    #__bar_Ticks
    
    #__bar_First
    #__bar_Second
    #__bar_FirstFixed
    #__bar_SecondFixed
    #__bar_FirstMinimumSize
    #__bar_SecondMinimumSize
  EndEnumeration
EndDeclareModule 
;- <<<
Module Constants
  
EndModule 

UseModule Constants

;- >>>
;- STRUCTUREs
DeclareModule Structures
  UseModule Constants
  
  Prototype fcallback()
  
  ;- - _s_event
  Structure _s_event
    *leave._s_widget  
    *enter._s_widget  
    *active._s_widget
    *widget._s_widget
    
    type.l
    item.l
    draw.b
    
    *callback.fcallback
    *data
  EndStructure
  
  ;- - _s_point
  Structure _s_point
    y.i
    x.i
  EndStructure
  
  ;- - _s_font
  Structure _s_font
    index.l  
    handle.i
    change.b
    name.s
    *size
  EndStructure
  
  ;- - _s_coordinate
  Structure _s_coordinate
    y.i[5]
    x.i[5]
    height.i[5]
    width.i[5]
  EndStructure
  
  ;- - _s_mouse
  Structure _s_mouse Extends _s_point
    wheel._s_point
    delta._s_point
    Buttons.i
  EndStructure
  
  ;- - _s_keyboard
  Structure _s_keyboard
    change.b
    input.c
    key.i[2]
  EndStructure
  
  ;- - _s_align
  Structure _s_align
    Right.b
    Bottom.b
    Vertical.b
    Horizontal.b
  EndStructure
  
  ;- - _s_page
  Structure _s_page
    Pos.i
    Len.i
    *end
  EndStructure
  
  ;- - _s_flag
  Structure _s_flag
    ; InLine.b
    lines.b
    buttons.b
    gridlines.b
    checkboxes.b
    option_group.b
    threestate.b
    collapse.b
    alwaysselection.b
    multiselect.b
    clickselect.b
    iconsize.b
  EndStructure
  
  ;- - _s_color
  Structure _s_color
    State.b
    Front.i[4]
    Fore.i[4]
    Back.i[4]
    Line.i[4]
    Frame.i[4]
    Arrows.i[4]
    Alpha.a[2]
    
  EndStructure
  
  ;- - _s_padding
  Structure _s_padding
    left.l
    top.l
    right.l
    bottom.l
  EndStructure
  
  ;- - _s_image
  Structure _s_image Extends _s_coordinate
    index.l
    handle.i
    change.b
    
    padding._s_padding
    align._s_align
  EndStructure
  
  ;- - _s_text
  Structure _s_text Extends _s_coordinate
    ;     Char.c
    len.i
    fontID.i
    string.s[3]
    count.i[2]
    change.b
    position.i
    
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    MultiLine.b
    Vertical.b
    Rotate.f
    
    padding._s_padding
    align._s_align
  EndStructure
  
  ;- - _s_box
  Structure _s_box
    y.l
    x.l
    height.l
    width.l
    checked.b
  EndStructure
  
  ;- - _s_arrow
  Structure _s_arrow
    size.a
    type.b
   ; direction.b
  EndStructure
  
  ;- - _s_button
  Structure _s_button Extends _s_coordinate
    len.a
    interact.b
    arrow._s_arrow
  EndStructure
  
  ;- - _s_splitter
  Structure _s_splitter
    *first;._s_bar
    *second;._s_bar
    
    fixed.l[3]
    
    g_first.b
    g_second.b
  EndStructure
  
  
  ;- - _s_tt
  Structure _s_tt Extends _s_coordinate
    window.i
    gadget.i
    
    visible.b
    
    text._s_text
    image._s_image
    color._s_color
  EndStructure
  
  ;- - _s_line
  Structure _s_line
    v._s_coordinate
    h._s_coordinate
  EndStructure
  
  ;- - _s_caret
  Structure _s_caret
    x.l
    y.l
    width.l
    height.l
    
    start.l
    stop.l
    time.l
  EndStructure
  
  ;- - _s_margin
  Structure _s_margin
    y.l
    x.l
    height.l
    width.l
    
    level.l
    color._s_color
  EndStructure
  
  ;- - _s_rows
  Structure _s_rows 
    x.l
    y.l
    width.l
    height.l
    
    ; list view
    sublevel.l
    sublevellen.l
    
    len.l ; ширина самого длиного итема
    fontID.i
    childrens.l
    
    l._s_line ; 
    *last._s_rows
    *first._s_rows
    *parent._s_rows
    box._s_box[2]
    *option_group._s_rows
    
;     ; edit
;     margin._s_text
    
    ;
    index.l  ; Index of new list element
    hide.b
    draw.b
    round.a
    text._s_text ; [4]
    image._s_image
    color._s_color
    *data  ; set/get item data
  EndStructure
  
  ;- - _s_row
  Structure _s_row
    ; list view
    drag.b
    FontID.i
    scrolled.b
    
    sublevel.l
    sublevellen.l
    
    *tt._s_tt
    *first._s_rows
    List *draws._s_rows()
    
;     ; edit
;     caret._s_caret
;     color._s_color
;     margin._s_margin
    
    ;
    count.l
    index.l
    box._s_box          ; editor - edit rectangle
    *selected._s_rows
    List _s._s_rows()
  EndStructure
  
  ;- - _s_bar
  Structure _s_bar Extends _s_coordinate
    type.l
    from.l
    focus.l
    round.l
    
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
    page._s_page
    area._s_page
    thumb._s_page
    color._s_color[4]
    button._s_button[4] 
    
    *text._s_text
    *event._s_event 
    *splitter._s_splitter
  EndStructure
  
  ;- - _s_scroll
  Structure _s_scroll
    height.l
    width.l
    
    *v._s_bar
    *h._s_bar
  EndStructure
  
  ;- - _s_root
  Structure _s_root
    window.i
    canvas.i
    ; widget.i
    
    mouse._s_mouse
    keyboard._s_keyboard
  EndStructure
  
  ;- - _s_widget
  Structure _s_widget Extends _s_coordinate
    index.l  ; Index of new list element
    handle.i ; Adress of new list element
    
    type.l   ; 
    from.l   ; at point item index
    hide.b[2]; [1] - hide state
    change.b ; is repaint widget?
    Interact.b ; будет ли взаимодействовать с пользователем?
    
    countitems.l
    
    root._s_root
    scroll._s_scroll
    image._s_image
    text._s_text
    color._s_color
    flag._s_flag
    
    bs.b
    fs.b
    
    resize.b ; 
    round.i
    attribute.i
    
    *widget._s_widget
    *event._s_event
    
    row._s_row
    ;mouse._s_mouse
    
    *data
  EndStructure
  
  
  Global def_colors._s_color
  
  With def_colors                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ;- Синие цвета
    ; Цвета по умолчанию
    \front[#s_0] = $80000000
    \fore[#s_0] = $FFF8F8F8 
    \back[#s_0] = $80E2E2E2
    \frame[#s_0] = $80C8C8C8
    \line[#s_0] = $FF7E7E7E
    
    ; Цвета если мышь на виджете
    \front[#s_1] = $80000000
    \fore[#s_1] = $FFFAF8F8
    \back[#s_1] = $80FCEADA
    \frame[#s_1] = $80FFC288
    \line[#s_1] = $FF7E7E7E
    
    ; Цвета если нажали на виджет
    \front[#s_2] = $FFFEFEFE
    \fore[#s_2] = $C8E9BA81;$C8FFFCFA
    \back[#s_2] = $C8E89C3D; $80E89C3D
    \frame[#s_2] = $C8DC9338; $80DC9338
    \line[#s_2] = $FF7E7E7E
    
    ; Цвета если дисабле виджет
    \front[#s_3] = $FFBABABA
    \fore[#s_3] = $FFF6F6F6 
    \back[#s_3] = $FFE2E2E2 
    \frame[#s_3] = $FFBABABA
    \line[#s_3] = $FF7E7E7E
    
    ;     ; - Серые цвета
    ;     ; Цвета по умолчанию
    ;     \front[#s_0] = $80000000
    ;     \fore[#s_0] = $FFF6F6F6 ; $FFF8F8F8 
    ;     \back[#s_0] = $FFE2E2E2 ; $80E2E2E2
    ;     \frame[#s_0] = $FFBABABA; $80C8C8C8
    ;     \line[#s_0] = $FF7E7E7E
    ;     
    ;     ; Цвета если мышь на виджете
    ;     \front[#s_1] = $80000000
    ;     \fore[#s_1] = $FFEAEAEA ; $FFFAF8F8
    ;     \back[#s_1] = $FFCECECE ; $80FCEADA
    ;     \frame[#s_1] = $FF8F8F8F; $80FFC288
    ;     \line[#s_1] = $FF7E7E7E
    ;     
    ;     ; Цвета если нажали на виджет
    ;     \front[#s_2] = $FFFEFEFE
    ;     \fore[#s_2] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    ;     \back[#s_2] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    ;     \frame[#s_2] = $FF6F6F6F; $C8DC9338 ; $80DC9338
    ;     \line[#s_2] = $FF7E7E7E
    ;     
    ;     ; Цвета если дисабле виджет
    ;     \front[#s_3] = $FFBABABA
    ;     \fore[#s_3] = $FFF6F6F6 
    ;     \back[#s_3] = $FFE2E2E2 
    ;     \frame[#s_3] = $FFBABABA
    ;     \line[#s_3] = $FF7E7E7E
  EndWith
  
EndDeclareModule 

Module Structures 
  
EndModule 
;- <<<

UseModule Structures

;- >>>
DeclareModule Bar
  EnableExplicit
  UseModule Constants
  UseModule Structures
  
  Declare.b Draw(*this)
  
  Declare.b SetState(*this, ScrollPos.l)
  Declare.l SetAttribute(*this, Attribute.l, Value.l)
  
  Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b CallBack(*this, EventType.l, mouse_x.l, mouse_y.l, wheel_x.b=0, wheel_y.b=0)
  
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, round.l=0)
  
  Declare.b Update(*this, position.l, size.l)
  Declare.b Resizes(*scroll._s_scroll, X.l,Y.l,Width.l,Height.l)
  Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
  
  ; Draw gradient box
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
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
EndDeclareModule

;- >>> MODULE
Module Bar
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
      _this_\button\height = _this_\height - Bool(_this_\type=#PB_GadgetType_ScrollBar)  
    EndIf
    
    ; _start_
    If _this_\button[#bb_1]\len And _this_\page\len
      If _scroll_pos_ = _this_\min
        _this_\color[#bb_1]\state = #s_3
        _this_\button[#bb_1]\interact = 0
      Else
        If _this_\color[#bb_1]\state <> #s_2
          _this_\color[#bb_1]\state = #s_0
        EndIf
        _this_\button[#bb_1]\interact = 1
      EndIf 
    EndIf
    
    If _this_\Vertical 
      ; Top button coordinate on vertical scroll bar
      _this_\button[#bb_1]\x = _this_\button\x
      _this_\button[#bb_1]\y = _this_\Y 
      _this_\button[#bb_1]\width = _this_\button\width
      _this_\button[#bb_1]\height = _this_\button[#bb_1]\len                   
    Else 
      ; Left button coordinate on horizontal scroll bar
      _this_\button[#bb_1]\x = _this_\X 
      _this_\button[#bb_1]\y = _this_\button\y
      _this_\button[#bb_1]\width = _this_\button[#bb_1]\len 
      _this_\button[#bb_1]\height = _this_\button\height 
    EndIf
    
    ; _stop_
    If _this_\button[#bb_2]\len And _this_\page\len
      ; Debug ""+ Bool(_this_\thumb\pos = _this_\area\end) +" "+ Bool(_scroll_pos_ = _this_\page\end)
      If _scroll_pos_ = _this_\page\end
        _this_\color[#bb_2]\state = #s_3
        _this_\button[#bb_2]\interact = 0
      Else
        If _this_\color[#bb_2]\state <> #s_2
          _this_\color[#bb_2]\state = #s_0
        EndIf
        _this_\button[#bb_2]\interact = 1
      EndIf 
    EndIf
    
    If _this_\Vertical 
      ; Botom button coordinate on vertical scroll bar
      _this_\button[#bb_2]\x = _this_\button\x
      _this_\button[#bb_2]\width = _this_\button\width
      _this_\button[#bb_2]\height = _this_\button[#bb_2]\len 
      _this_\button[#bb_2]\y = _this_\Y+_this_\height-_this_\button[#bb_2]\height
    Else 
      ; Right button coordinate on horizontal scroll bar
      _this_\button[#bb_2]\y = _this_\button\y
      _this_\button[#bb_2]\height = _this_\button\height
      _this_\button[#bb_2]\width = _this_\button[#bb_2]\len 
      _this_\button[#bb_2]\x = _this_\X+_this_\width-_this_\button[#bb_2]\width 
    EndIf
    
    
    ; Thumb coordinate on scroll bar
    If _this_\thumb\len
      If _this_\button[#bb_3]\len <> _this_\thumb\len
        _this_\button[#bb_3]\len = _this_\thumb\len
      EndIf
      
      If _this_\Vertical
        _this_\button[#bb_3]\x = _this_\button\x 
        _this_\button[#bb_3]\width = _this_\button\width 
        _this_\button[#bb_3]\y = _this_\thumb\pos
        _this_\button[#bb_3]\height = _this_\thumb\len                              
      Else
        _this_\button[#bb_3]\y = _this_\button\y 
        _this_\button[#bb_3]\height = _this_\button\height
        _this_\button[#bb_3]\x = _this_\thumb\pos 
        _this_\button[#bb_3]\width = _this_\thumb\len                                  
      EndIf
      
    Else
      ; Эфект спин гаджета
      If _this_\Vertical
        _this_\button[#bb_2]\height = _this_\height/2 
        _this_\button[#bb_2]\y = _this_\y+_this_\button[#bb_2]\height+Bool(_this_\height%2) 
        
        _this_\button[#bb_1]\y = _this_\y 
        _this_\button[#bb_1]\height = _this_\height/2
        
      Else
        _this_\button[#bb_2]\width = _this_\width/2 
        _this_\button[#bb_2]\x = _this_\x+_this_\button[#bb_2]\width+Bool(_this_\width%2) 
        
        _this_\button[#bb_1]\x = _this_\x 
        _this_\button[#bb_1]\width = _this_\width/2
      EndIf
    EndIf
  EndMacro
  
  ; Inverted scroll bar position
  Macro _scroll_invert_(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro _set_area_coordinate_(_this_)
    If _this_\vertical
      _this_\area\pos = _this_\y + _this_\button[#bb_1]\len
      _this_\area\len = _this_\height - (_this_\button[#bb_1]\len + _this_\button[#bb_2]\len)
    Else
      _this_\area\pos = _this_\x + _this_\button[#bb_1]\len
      _this_\area\len = _this_\width - (_this_\button[#bb_1]\len + _this_\button[#bb_2]\len)
    EndIf
    
    _this_\area\end = _this_\area\pos + (_this_\area\len-_this_\thumb\len)
  EndMacro
  
  ;-
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
  
  Procedure.b Draw(*this._s_bar)
    With *this
      
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x,\y,\width,\height,\round,\round,\color\back&$FFFFFF|\color\alpha<<24)
        
        If \vertical
          If (\page\len+Bool(\round)*(\width/4)) = \height
            Line( \x, \y, 1, \page\len+1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Else
            Line( \x, \y, 1, \height, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          EndIf
        Else
          If (\page\len+Bool(\round)*(\height/4)) = \width
            Line( \x, \y, \page\len+1, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Else
            Line( \x, \y, \width, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          EndIf
        EndIf
        
        If \thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\vertical,\button[#bb_3]\x,\button[#bb_3]\y,\button[#bb_3]\width,\button[#bb_3]\height,\color[3]\fore[\color[3]\state],\color[3]\back[\color[3]\state], \round, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#bb_3]\x,\button[#bb_3]\y,\button[#bb_3]\width,\button[#bb_3]\height,\round,\round,\color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          
          Protected h=9
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \vertical
            Line(\button[#bb_3]\x+(\button[#bb_3]\width-h)/2,\button[#bb_3]\y+\button[#bb_3]\height/2-3,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#bb_3]\x+(\button[#bb_3]\width-h)/2,\button[#bb_3]\y+\button[#bb_3]\height/2,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#bb_3]\x+(\button[#bb_3]\width-h)/2,\button[#bb_3]\y+\button[#bb_3]\height/2+3,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Else
            Line(\button[#bb_3]\x+\button[#bb_3]\width/2-3,\button[#bb_3]\y+(\button[#bb_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#bb_3]\x+\button[#bb_3]\width/2,\button[#bb_3]\y+(\button[#bb_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#bb_3]\x+\button[#bb_3]\width/2+3,\button[#bb_3]\y+(\button[#bb_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\vertical,\button[#bb_1]\x,\button[#bb_1]\y,\button[#bb_1]\width,\button[#bb_1]\height,\color[#bb_1]\fore[\color[#bb_1]\state],\color[#bb_1]\back[\color[#bb_1]\state], \round, \color\alpha)
          _box_gradient_(\vertical,\button[#bb_2]\x,\button[#bb_2]\y,\button[#bb_2]\width,\button[#bb_2]\height,\color[#bb_2]\fore[\color[#bb_2]\state],\color[#bb_2]\back[\color[#bb_2]\state], \round, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#bb_1]\x,\button[#bb_1]\y,\button[#bb_1]\width,\button[#bb_1]\height,\round,\round,\color[#bb_1]\frame[\color[#bb_1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#bb_2]\x,\button[#bb_2]\y,\button[#bb_2]\width,\button[#bb_2]\height,\round,\round,\color[#bb_2]\frame[\color[#bb_2]\state]&$FFFFFF|\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#bb_1]\x+(\button[#bb_1]\width-\button[#bb_1]\arrow\size)/2,\button[#bb_1]\y+(\button[#bb_1]\height-\button[#bb_1]\arrow\size)/2, \button[#bb_1]\arrow\size, Bool(\vertical), \color[#bb_1]\front[\color[#bb_1]\state]&$FFFFFF|\color\alpha<<24, \button[#bb_1]\arrow\type)
          Arrow(\button[#bb_2]\x+(\button[#bb_2]\width-\button[#bb_2]\arrow\size)/2,\button[#bb_2]\y+(\button[#bb_2]\height-\button[#bb_2]\arrow\size)/2, \button[#bb_2]\arrow\size, Bool(\vertical)+2, \color[#bb_2]\front[\color[#bb_2]\state]&$FFFFFF|\color\alpha<<24, \button[#bb_2]\arrow\type)
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  ;- 
  Procedure.i SetPos(*this._s_bar, ThumbPos.i)
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
  
  Procedure.b SetState(*this._s_bar, ScrollPos.l)
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
        
        If \splitter And \splitter\fixed = #bb_1
          \splitter\fixed[\splitter\fixed] = \thumb\pos - \area\pos
          \page\pos = 0
        EndIf
        If \splitter And \splitter\fixed = #bb_2
          \splitter\fixed[\splitter\fixed] = \area\len - ((\thumb\pos+\thumb\len)-\area\pos)
          \page\pos = \max
        EndIf
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*this._s_bar, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      If \splitter
        Select Attribute
          Case #PB_Splitter_FirstMinimumSize : Attribute = #__bar_FirstMinimumSize
          Case #PB_Splitter_SecondMinimumSize : Attribute = #__bar_SecondMinimumSize
        EndSelect
      EndIf
      
      Select Attribute
        Case #__bar_ScrollStep 
          \scrollstep = Value
          
        Case #__bar_FirstMinimumSize
          \button[#bb_1]\len = Value
          Result = Bool(\max)
          
        Case #__bar_SecondMinimumSize
          \button[#bb_2]\len = Value
          Result = Bool(\max)
          
        Case #__bar_NoButtons
          If \button\len <> Value
            \button\len = Value
            \button[#bb_1]\len = Value
            \button[#bb_2]\len = Value
            Result = #True
          EndIf
          
        Case #__bar_Inverted
          If \inverted <> Bool(Value)
            \inverted = Bool(Value)
            \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
          EndIf
          
        Case #__bar_Minimum
          If \min <> Value
            \min = Value
            \page\pos = Value
            Result = #True
          EndIf
          
        Case #__bar_Maximum
          If \max <> Value
            If \min > Value
              \max = \min + 1
            Else
              \max = Value
            EndIf
            
            If \max = 0
              \page\pos = 0
            EndIf
            
            Result = #True
          EndIf
          
        Case #__bar_PageLength
          If \page\len <> Value
;             If Value > (\max-\min) 
;               ;\max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
;               If \Max = 0 
;                 \Max = Value 
;               EndIf
;               \page\len = (\max-\min)
;             Else
              \page\len = Value
;             EndIf
              
              If Not \max
                If \min > Value
                  \max = \min + 1
                Else
                  \max = Value
                EndIf
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
  
  ;-
  Procedure.b Update(*this._s_bar, position.l, size.l)
    Protected.b result
    
    With *this
      position - \y
      size = (\page\len-size)
      result | Bool((position-\page\pos) < 0 And SetState(*this, position))
      result | Bool((position-\page\pos) > size And SetState(*this, position-size))
      \change = 0
    EndWith
    
    ProcedureReturn result
  EndProcedure
  
  Procedure.b Resize(*this._s_bar, X.l,Y.l,Width.l,Height.l)
    With *this
      If X <> #PB_Ignore : \x = X : EndIf 
      If Y <> #PB_Ignore : \y = Y : EndIf 
      If Width <> #PB_Ignore : \width = Width : EndIf 
      If Height <> #PB_Ignore : \height = height : EndIf
      
      ;
      If (\max-\min) >= \page\len
        ; Get area screen coordinate pos (x&y) and len (width&height)
        _set_area_coordinate_(*this)
        
        If Not \max And \width And \height
          \max = \area\len-\button\len
          
          If Not \page\pos
            \page\pos = \max/2
          EndIf
        EndIf
        
        ;
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
          \thumb\len = 0
          
          If \vertical
            \area\pos = \y
            \area\len = \height
          Else
            \area\pos = \x
            \area\len = \width 
          EndIf
          
          \area\end = \area\pos + (\area\len - \thumb\len)
        EndIf
        
        \page\end = \max - \page\len
        \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
        
        If \thumb\pos = \area\end 
          SetState(*this, \max)
        EndIf
      EndIf
      
      \hide[1] = Bool(Not ((\max-\min) > \page\len))
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Resizes(*scroll._s_scroll, X.l,Y.l,Width.l,Height.l )
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
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\page\len) : EndIf
      If \h\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\page\len, #PB_Ignore) : EndIf
      
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
      If \v\page\len <> iHeight
        If iHeight > (\v\max-\v\min) 
          If \v\Max = 0 
            \v\Max = iHeight 
          EndIf
          \v\page\len = (\v\max-\v\min)
        Else
          \v\page\len = iHeight
        EndIf
      EndIf
      
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      If \h\page\len <> iWidth
        If iWidth > (\h\max-\h\min) 
          If \h\Max = 0 
            \h\Max = iWidth 
          EndIf
          \h\page\len = (\h\max-\h\min)
        Else
          \h\page\len = iWidth
        EndIf
      EndIf
      
      If \v\page\len <> \v\height 
        \v\x = Width+x-\v\width
        \v\y = y                         
        \v\height = \v\page\len
        
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If \h\page\len <> \h\width
        \h\x = x
        \h\y = Height+y-\h\height                         
        \h\width = \h\page\len
        
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      If \v\page\len <> iHeight
        If iHeight > (\v\max-\v\min) 
          If \v\Max = 0 
            \v\Max = iHeight 
          EndIf
          \v\page\len = (\v\max-\v\min)
        Else
          \v\page\len = iHeight
        EndIf
      EndIf
      
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      If \h\page\len <> iWidth
        If iWidth > (\h\max-\h\min) 
          If \h\Max = 0 
            \h\Max = iWidth 
          EndIf
          \h\page\len = (\h\max-\h\min)
        Else
          \h\page\len = iWidth
        EndIf
      EndIf
      
      If \v\page\len <> \v\height 
        ;         \v\x = Width+x-\v\width
        ;       \v\y = y                         
        \v\height = \v\page\len
        
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If \h\page\len <> \h\width
        ;       \h\x = x
        ;       \h\y = Height+y-\h\height                         
        \h\width = \h\page\len
        
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If Not \v\hide And \v\width 
        \h\width = (\v\x-\h\x) + Bool(\v\round And \h\round)*(\v\width/4)
        
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If Not \h\hide And \h\height
        \v\height = (\h\y-\v\y) + Bool(\v\round And \h\round)*(\h\height/4)
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  ;-
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, round.l=0)
    Protected *this._s_bar = AllocateStructure(_s_bar)
    
    With *this
      \type = #PB_GadgetType_ScrollBar
      \button[#bb_1]\arrow\type =- 1
      \button[#bb_2]\arrow\type =- 1
      \button[#bb_1]\arrow\size = 4
      \button[#bb_2]\arrow\size = 4
      ;\interact = 1
      \button[#bb_1]\interact = 1
      \button[#bb_2]\interact = 1
      \button[#bb_3]\interact = 1
      \from =- 1
      \scrollstep = 1
      \round = round
      
      ; Цвет фона скролла
      \color\alpha[0] = 255
      \color\alpha[1] = 0
      
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\front = $FFFFFFFF ; line
      
      \color[#bb_1] = def_colors
      \color[#bb_2] = def_colors
      \color[#bb_3] = def_colors
      
      \vertical = Bool(Flag&#__bar_Vertical=#__bar_Vertical)
      \inverted = Bool(Flag&#__bar_Inverted=#__bar_Inverted)
      
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If Not Bool(Flag&#__bar_NoButtons=#__bar_NoButtons)
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
        
        \button[#bb_1]\len = \button\len
        \button[#bb_2]\len = \button\len
      EndIf
      
      If \min <> Min : SetAttribute(*this, #__bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*this, #__bar_Maximum, Max) : EndIf
      If \page\len <> PageLength : SetAttribute(*this, #__bar_PageLength, PageLength) : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.b CallBack(*this._s_bar, EventType.l, mouse_x.l, mouse_y.l, wheel_x.b=0, wheel_y.b=0)
    Protected Result, from =- 1 
    Static cursor_change, LastX, LastY, Last, *leave._s_bar, *active._s_bar, Down
    
    Macro _callback_(_this_, _type_)
      Select _type_
        Case #PB_EventType_MouseLeave ; : Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #s_0 
          
        Case #PB_EventType_MouseEnter ; : Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #s_1 
          
        Case #PB_EventType_LeftButtonDown ; : Debug ""+#PB_Compiler_Line +" нажали " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #s_2
          
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
              LastX = mouse_x - _this_\thumb\pos 
              LastY = mouse_y - _this_\thumb\pos
              Result = #True
          EndSelect
          
        Case #PB_EventType_LeftButtonUp ; : Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #s_1 
          
      EndSelect
    EndMacro
    
    With *this
      ; get at point buttons
      If Not \hide And (_from_point_(mouse_x, mouse_y, *this) Or Down)
        If \button 
          If \button[#bb_3]\len And _from_point_(mouse_x, mouse_y, \button[#bb_3])
            from = #bb_3
          ElseIf \button[#bb_2]\len And _from_point_(mouse_x, mouse_y, \button[#bb_2])
            from = #bb_2
          ElseIf \button[#bb_1]\len And _from_point_(mouse_x, mouse_y, \button[#bb_1])
            from = #bb_1
          ElseIf _from_point_(mouse_x, mouse_y, \button[0])
            from = 0
          EndIf
        Else
          from = 0
        EndIf 
        
        If \from <> from And Not Down
          If *leave > 0 And *leave\from >= 0 And *leave\button[*leave\from]\interact And 
             Not (mouse_x>*leave\button[*leave\from]\x And mouse_x=<*leave\button[*leave\from]\x+*leave\button[*leave\from]\width And 
                  mouse_y>*leave\button[*leave\from]\y And mouse_y=<*leave\button[*leave\from]\y+*leave\button[*leave\from]\height)
            
            _callback_(*leave, #PB_EventType_MouseLeave)
            *leave\from = 0
            
            Result = #True
          EndIf
          
          If from > 0
            \from = from
            *leave = *this
          EndIf
          
          If \from >= 0 And \button[\from]\interact
            _callback_(*this, #PB_EventType_MouseEnter)
            
            Result = #True
          EndIf
        EndIf
        
      Else
        If \from >= 0 And \button[\from]\interact
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
          If *This = *active
            If \vertical
              Result = SetState(*This, (\page\pos + wheel_y))
            Else
              Result = SetState(*This, (\page\pos + wheel_x))
            EndIf
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Down 
            \from =- 1 : from =- 1 : LastX = 0 : LastY = 0 
          EndIf
          
        Case #PB_EventType_LeftButtonUp : Down = 0 : LastX = 0 : LastY = 0
          
          If \from >= 0 And \button[\from]\interact
            _callback_(*this, #PB_EventType_LeftButtonUp)
            
            If from =- 1
              _callback_(*this, #PB_EventType_MouseLeave)
              \from =- 1
            EndIf
            
            Result = #True
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If from = 0 And \button[#bb_3]\interact 
            If \vertical
              Result = SetPos(*this, (mouse_y-\thumb\len/2))
            Else
              Result = SetPos(*this, (mouse_x-\thumb\len/2))
            EndIf
            
            from = 3
          EndIf
          
          If from >= 0
            Down = 1
            \from = from 
            *active = *this 
            
            If \button[from]\interact
              _callback_(*this, #PB_EventType_LeftButtonDown)
            Else
              Result = #True
            EndIf
          EndIf
          
        Case #PB_EventType_MouseMove
          If Down And *leave = *this And Bool(LastX|LastY) 
            If \vertical
              Result = SetPos(*this, (mouse_y-LastY))
            Else
              Result = SetPos(*this, (mouse_x-LastX))
            EndIf
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
EndModule
;- <<< 

;- >>> 
DeclareModule Tree
  EnableExplicit
  CompilerIf Defined(fixme, #PB_Module)
    Macro PB(Function) : Function : EndMacro
    UseModule fixme
  CompilerEndIf
  UseModule Constants
  UseModule Structures
  
  Structure _struct_ Extends structures::_s_widget : EndStructure
  
  Macro GetCanvas(_this_)
    _this_\root\canvas
  EndMacro
  
  Global *event._s_event = AllocateStructure(_s_event)
  
  *event\active = 0
  *event\widget = 0
  *event\data = 0
  *event\type =- 1
  *event\item =- 1
  
  
  Declare.l CountItems(*this)
  Declare   ClearItems(*this) 
  Declare   RemoveItem(*this, Item.l)
  
  Declare.l SetText(*this, Text.s)
  Declare.i SetFont(*this, Font.i)
  Declare.l SetState(*this, State.l)
  Declare.i SetItemFont(*this, Item.l, Font.i)
  Declare.l SetItemState(*this, Item.l, State.b)
  Declare.i SetItemImage(*this, Item.l, Image.i)
  Declare.i SetAttribute(*this, Attribute.i, Value.l)
  Declare.l SetItemText(*this, Item.l, Text.s, Column.l=0)
  Declare.l SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l=0)
  ;Declare.i SetItemAttribute(*this, Item.l, Attribute.i, Value.l, Column.l=0)
  
  Declare.s GetText(*this)
  Declare.i GetFont(*this)
  Declare.l GetState(*this)
  Declare.i GetItemFont(*this, Item.l)
  Declare.l GetItemState(*this, Item.l)
  Declare.i GetItemImage(*this, Item.l)
  Declare.i GetAttribute(*this, Attribute.i)
  Declare.s GetItemText(*this, Item.l, Column.l=0)
  Declare.i GetItemAttribute(*this, Item.l, Attribute.i, Column.l=0)
  Declare.l GetItemColor(*this, Item.l, ColorType.l, Column.l=0)
  
  Declare.i AddItem(*this, position.l, Text.s, Image.i=-1, sublevel.i=0)
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
  Declare.i Tree(X.l, Y.l, Width.l, Height.l, Flag.i=0, round.l=0)
  Declare.l CallBack(*this, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
  Declare   Free(*this)
  
  Declare.l Draw(*this)
  Declare.l ReDraw(*this, canvas_backcolor=#Null)
  Declare.l Resize(*this, X.l,Y.l,Width.l,Height.l)
  
  Declare.b Bind(*this, *callBack, eventtype.l=#PB_All)
  Declare.b Post(eventtype.l, *this, item.l=#PB_All, *data=0)
EndDeclareModule

Module Tree
  Macro _box_(_x_,_y_, _width_, _height_, _checked_, _type_, _color_=$FFFFFFFF, _round_=2, _alpha_=255) 
    
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
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ < (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ < (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _multi_select_(_this_,  _index_, _selected_index_)
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
  
  Macro _set_item_image_(_this_, _item_, _image_)
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
  
  Macro _set_active_(_this_)
    If *event\active <> _this_
      If *event\active 
        *event\active\color\state = 0
        *event\active\root\mouse\buttons = 0
        
        If *event\active\row\selected 
          *event\active\row\selected\color\state = 3
        EndIf
        
        If _this_\root\canvas <> *event\active\root\canvas 
          ; set lost focus canvas
          PostEvent(#PB_Event_Gadget, *event\active\root\window, *event\active\root\canvas, #PB_EventType_Repaint);, *event\active)
        EndIf
        
        Result | Events(*event\active, #PB_EventType_LostFocus, mouse_x, mouse_y)
      EndIf
      
      If _this_\row\selected And _this_\row\selected\color\state = 3
        _this_\row\selected\color\state = 2
      EndIf
      
      _this_\color\state = 2
      *event\active = _this_
      Result | Events(_this_, #PB_EventType_Focus, mouse_x, mouse_y)
    EndIf
  EndMacro
  
  Macro _set_state_(_this_, _items_, _state_)
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
  
  Macro _bar_update_(_this_, _pos_, _len_)
    Bool(Bool((_pos_-_this_\y-_this_\page\pos) < 0 And Bar::SetState(_this_, (_pos_-_this_\y))) Or
         Bool((_pos_-_this_\y-_this_\page\pos) > (_this_\page\len-_len_) And
              Bar::SetState(_this_, (_pos_-_this_\y) - (_this_\page\len-_len_)))) : _this_\change = 0
  EndMacro
  
  Macro _repaint_(_this_)
    If _this_\countitems = 0 Or 
       (Not _this_\hide And _this_\row\count And 
        (_this_\countitems % _this_\row\count) = 0)
      
      _this_\change = 1
      _this_\row\count = _this_\countitems
      PostEvent(#PB_Event_Gadget, _this_\root\window, _this_\root\canvas, #PB_EventType_Repaint, _this_)
    EndIf  
  EndMacro
  
  ;-
  ;- PROCEDUREs
  ;-
  Declare Events(*this, eventtype.l, mouse_x.l=-1, mouse_y.l=-1, position.l=0)
  
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
      Color = SourceColor
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure PlotY(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If y%2
      Color = SourceColor
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  ;- DRAWs
  Procedure.l Draw(*this._struct_)
    Protected Y, state.b
    
    Macro _lines_(_this_, _items_)
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
          _items_\l\v\y = (_items_\first\y+_items_\first\height- Bool(_items_\first\sublevel = _items_\sublevel) * _items_\first\height/2) - _this_\scroll\v\page\pos
          If _items_\l\v\y < _this_\y[2] : _items_\l\v\y = _this_\y[2] : EndIf
          
          _items_\l\v\height = (_items_\y+_items_\height/2)-_items_\l\v\y - _this_\scroll\v\page\pos
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
              _items_\box[1]\x = _items_\x + 3 - _this_\scroll\h\page\pos
              _items_\box[1]\y = (_items_\y+_items_\height)-(_items_\height+_items_\box[1]\height)/2-_this_\scroll\v\page\pos
            EndIf
            
            ; expanded & collapsed box
            If _this_\flag\buttons Or _this_\flag\lines 
              _items_\box[0]\x = _items_\x + _items_\sublevellen - _this_\row\sublevellen + Bool(_this_\flag\buttons) * 4 + Bool(Not _this_\flag\buttons And _this_\flag\lines) * 8 - _this_\scroll\h\page\pos 
              _items_\box[0]\y = (_items_\y+_items_\height)-(_items_\height+_items_\box[0]\height)/2-_this_\scroll\v\page\pos
            EndIf
            
            ;
            _items_\image\x = _items_\x + _this_\image\padding\left + _items_\sublevellen - _this_\scroll\h\page\pos
            _items_\image\y = _items_\y + (_items_\height-_items_\image\height)/2-_this_\scroll\v\page\pos
            
            _items_\text\x = _items_\x + _this_\text\padding\left + _items_\sublevellen + _this_\row\sublevel - _this_\scroll\h\page\pos
            _items_\text\y = _items_\y + (_items_\height-_items_\text\height)/2-_this_\scroll\v\page\pos
            
            _items_\draw = Bool(_items_\y+_items_\height-_this_\scroll\v\page\pos>_this_\y[2] And 
                                (_items_\y-_this_\y[2])-_this_\scroll\v\page\pos<_this_\height[2])
            
            ; lines for tree widget
            If _this_\flag\lines And _this_\row\sublevellen
              _lines_(_this_, _items_)
            EndIf
            
            If _items_\draw And 
               AddElement(_this_\row\draws())
              _this_\row\draws() = _items_
            EndIf
          EndIf
          
          If _this_\change <> 0
            _this_\scroll\height + _items_\height + _this_\flag\GridLines
            _items_\len = ((_items_\text\x + _items_\text\width + _this_\scroll\h\page\pos) - _this_\x[2])
            
            If _this_\scroll\h\height And _this_\scroll\width < _items_\len
              _this_\scroll\width = _items_\len
            EndIf
          EndIf
        EndIf
      Next
      PopListPosition(_items_)
      
      If _this_\scroll\v\page\len And _this_\scroll\v\max<>_this_\scroll\height-Bool(_this_\flag\gridlines) And
         Bar::SetAttribute(_this_\scroll\v, #PB_ScrollBar_Maximum, _this_\scroll\height-Bool(_this_\flag\gridlines))
        
        Bar::Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      ; Debug ""+_this_\scroll\v\max +" "+ _this_\scroll\height +" "+ _this_\scroll\v\page\pos +" "+ _this_\scroll\v\page\len
      
      If _this_\scroll\h\page\len And _this_\scroll\h\max<>_this_\scroll\width And
         Bar::SetAttribute(_this_\scroll\h, #PB_ScrollBar_Maximum, _this_\scroll\width)
        
        Bar::Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If _this_\change <> 0
        _this_\width[2] = (_this_\scroll\v\x + Bool(_this_\scroll\v\hide) * _this_\scroll\v\width) - _this_\x[2]
        _this_\height[2] = (_this_\scroll\h\y + Bool(_this_\scroll\h\hide) * _this_\scroll\h\height) - _this_\y[2]
        
        If _this_\row\selected And _this_\row\scrolled
          Bar::SetState(_this_\scroll\v, ((_this_\row\selected\y-_this_\scroll\v\y) - (Bool(_this_\row\scrolled>0) * (_this_\scroll\v\page\len-_this_\row\selected\height))) ) 
          _this_\scroll\v\change = 0 
          _this_\row\scrolled = 0
          
          Draw(_this_)
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
          
          
          Y = _items_\y - _this_\scroll\v\page\pos
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
            _box_(_items_\box[1]\x, _items_\box[1]\y, _items_\box[1]\width, _items_\box[1]\height, _items_\box[1]\checked, 1, $FFFFFFFF, 7, 255)
            
          ElseIf _this_\flag\checkboxes
            DrawingMode(#PB_2DDrawing_Default)
            _box_(_items_\box[1]\x, _items_\box[1]\y, _items_\box[1]\width, _items_\box[1]\height, _items_\box[1]\checked, 3, $FFFFFFFF, 2, 255)
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
            Box(_items_\x, (_items_\y+_items_\height+Bool(_this_\flag\gridlines>1))-_this_\scroll\v\page\pos, _this_\width[2], 1, _this_\color\line)
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
              ;  CustomFilterCallback(@PlotX())
              Line(_items_\l\h\x, _items_\l\h\y, _items_\l\h\width, _items_\l\h\height, _items_\color\line)
            EndIf
            
            If _items_\l\v\width
              ;  CustomFilterCallback(@PlotY())
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
            Bar::Arrow(_items_\box[0]\x+(_items_\box[0]\width-6)/2,_items_\box[0]\y+(_items_\box[0]\height-6)/2, 6, Bool(Not _items_\box[0]\checked)+2, _items_\color\front[_items_\color\state], 0,0) 
            ;             DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            ;             ;RoundBox(_items_\box[0]\x-3, _items_\box[0]\y-3, _items_\box[0]\width+6, _items_\box[0]\height+6, 7,7, _items_\color\front[_items_\color\state])
            ;             RoundBox(_items_\box[0]\x-1, _items_\box[0]\y-1, _items_\box[0]\width+2, _items_\box[0]\height+2, 7,7, _items_\color\front[_items_\color\state])
            ;             Bar::Arrow(_items_\box[0]\x+(_items_\box[0]\width-4)/2,_items_\box[0]\y+(_items_\box[0]\height-4)/2, 4, Bool(Not _items_\box[0]\checked)+2, _items_\color\front[_items_\color\state], 0,0) 
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
        
        ; Scroll area coordinate
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Box(\scroll\h\x-\scroll\h\page\pos, \scroll\v\y-\scroll\v\page\pos, \scroll\h\max, \scroll\v\max, $FFFF0000)
        
        ; page coordinate
        Box(\scroll\h\x, \scroll\v\y, \scroll\h\page\len, \scroll\v\page\len, $FF00FF00)
        
        ; Draw scroll bars
        If \scroll
          CompilerIf Defined(Bar, #PB_Module)
            Bar::Draw(\scroll\v)
            Bar::Draw(\scroll\h)
          CompilerEndIf
        EndIf
        
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
        
        
        If \text\change : \text\change = 0 : EndIf
        If \resize : \resize = 0 : EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.l ReDraw(*this._struct_, canvas_backcolor=#Null)
    If *this
      With *this
        If StartDrawing(CanvasOutput(\root\canvas))
          If canvas_backcolor And *event\draw = 0 : *event\draw = 1
            FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), canvas_backcolor)
          EndIf
          
          Draw(*this)
          StopDrawing()
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  ;- SETs
  Procedure.l SetText(*this._struct_, Text.s)
    Protected Result.l
    
    If *this\row\selected 
      *this\row\selected\text\string = Text
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*this._struct_, Font.i)
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
  
  Procedure.l SetState(*this._struct_, State.l)
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
        
        _repaint_(*this)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetAttribute(*this._struct_, Attribute.i, Value.l)
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
  
  Procedure.i SetItemFont(*this._struct_, Item.l, Font.i)
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
  
  Procedure.l SetItemText(*this._struct_, Item.l, Text.s, Column.l=0)
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
  
  Macro GetActive()
    *event\active
  EndMacro
  
  Procedure.l SetItemState(*this._struct_, Item.l, State.b)
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
  
  Procedure.l _SetItemState(*this._struct_, Item.l, State.b)
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
        _set_state_(*this, *this\row\_s(), State)
        
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
          Post(#PB_EventType_StatusChange, *this, Item)
        EndIf
        
        If Repaint = 1
          Post(#PB_EventType_Change, *this, Item)
          ;Events(*this, #PB_EventType_Change)
        EndIf
        
        _repaint_(*this)
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemImage(*this._struct_, Item.l, Image.i) ; Ok
    If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item)
      If *this\row\_s()\image\index <> Image
        _set_item_image_(*this, *this\row\_s(), Image)
        _repaint_(*this)
      EndIf
    EndIf
  EndProcedure
  
  Procedure.i SetItemAttribute(*this._struct_, Item.l, Attribute.i, Value.l)
    
  EndProcedure
  
  
  ;- GETs
  Procedure.s GetText(*this._struct_)
    If *this\row\selected 
      ProcedureReturn *this\row\selected\text\string
    EndIf
  EndProcedure
  
  Procedure.i GetFont(*this._struct_)
    ProcedureReturn *this\text\fontID
  EndProcedure
  
  Procedure.l GetState(*this._struct_)
    Protected Result.l =- 1
    
    If *this\row\selected And *this\row\selected\color\state
      Result = *this\row\selected\index
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*this._struct_, Attribute.i)
    Protected Result.i
    
    Select Attribute
      Case #__tree_Collapse
        Result = *this\flag\collapse
        
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l GetItemColor(*this._struct_, Item.l, ColorType.l, Column.l=0)
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
  
  Procedure.i GetItemFont(*this._struct_, Item.l)
    Protected Result.i =- 1
    
    If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item) 
      Result = *this\row\_s()\text\fontID
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(*this._struct_, Item.l, Column.l=0)
    Protected Result.s
    
    If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item) 
      Result = *this\row\_s()\text\string
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l GetItemState(*this._struct_, Item.l)
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
  
  Procedure.i GetItemImage(*this._struct_, Item.l)
    Protected Result.i =- 1
    
    If Item >= 0 And Item < *this\countitems And SelectElement(*this\row\_s(), Item)
      Result = *this\row\_s()\image\index
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemAttribute(*this._struct_, Item.l, Attribute.i, Column.l=0)
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
  Procedure RemoveItem(*this._struct_, Item.l) 
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
      
      _repaint_(*this)
      *this\countitems - 1
      ; надо подумать
      ; *this\row\sublevel = 0
    EndIf
  EndProcedure
  
  Procedure.l CountItems(*this._struct_) ; Ok
    ProcedureReturn *this\countitems
  EndProcedure
  
  Procedure ClearItems(*this._struct_) ; Ok
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
      
      If StartDrawing(CanvasOutput(*this\root\canvas))
        Draw(*this)
        StopDrawing()
      EndIf
      Post(#PB_EventType_Change, *this, #PB_All)
    EndIf
  EndProcedure
  
  Procedure.i AddItem(*this._struct_, position.l, Text.s, Image.i=-1, subLevel.i=0)
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
          
          \row\_s()\color = def_colors
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
          
          _set_item_image_(*this, \row\_s(), Image)
          
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
          
          _repaint_(*this)
          \countitems + 1
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn handle
  EndProcedure
  
  Procedure.l Resize(*this._struct_, X.l,Y.l,Width.l,Height.l)
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
        
        Bar::Resizes(\scroll, x+\bs,Y+\bs,Width-\bs*2,Height-\bs*2)
        
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
        ; _repaint_(*this)
      EndIf
      
      ProcedureReturn \resize
    EndWith
  EndProcedure
  
  ;-
  Procedure.i Tree(X.l, Y.l, Width.l, Height.l, Flag.i=0, round.l=0)
    Static index
    Protected *this._struct_ = AllocateStructure(_struct_)
    
    If *this
      With *this
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
          ;                     \text\fontID = GetGadgetFont(TextGadget) 
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
          \text\fontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
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
        
        ;\color = def_colors
        ;         \color\fore[0] = 0
        ;         \color\fore[1] = 0
        ;         \color\fore[2] = 0
        \color\frame[#s_0] = $80C8C8C8 
        ;\color\frame[#s_1] = $80FFC288 
        \color\frame[#s_2] = $C8DC9338 
        \color\frame[#s_3] = $FFBABABA
        \color\back[#s_0] = $FFFFFFFF 
        ;\color\back[#s_1] = $FFFFFFFF 
        \color\back[#s_2] = $FFFFFFFF 
        \color\back[#s_3] = $FFE2E2E2 
        ; \color\line = $FFF0F0F0
      EndIf
      
      \scroll\v = Bar::Scroll(0, 0, 16, 0, 0,0,0, #PB_ScrollBar_Vertical, 7)
      \scroll\h = Bar::Scroll(0, 0, 0, Bool((\flag\buttons=0 And \flag\lines=0)=0)*16, 0,0,0, 0, 7)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  
  ;-
  Declare tt_close(*this._s_tt)
  
  Procedure tt_draw(*this._s_tt, *color._s_color=0)
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
  
  Procedure tt_CallBack()
    ;     ;SetActiveWindow(*event\widget\root\window)
    ;     ;SetActiveGadget(*event\widget\root\canvas)
    ;     
    ;     If *event\widget\row\selected
    ;       *event\widget\row\selected\color\State = 0
    ;     EndIf
    ;     
    ;     *event\widget\row\selected = *event\widget\row\_s()
    ;     *event\widget\row\_s()\color\State = 2
    ;     *event\widget\color\State = 2
    ;     
    ;     ;ReDraw(*event\widget)
    
    tt_close(GetWindowData(EventWindow()))
  EndProcedure
  
  Procedure tt_creare(*this._struct_, x,y)
    With *this
      If *this
        *event\widget = *this
        \row\tt = AllocateStructure(_s_tt)
        \row\tt\visible = 1
        \row\tt\x = x+\row\_s()\x+\row\_s()\width-1
        \row\tt\y = y+\row\_s()\y-\scroll\v\page\pos
        \row\tt\width = \row\_s()\len - \row\_s()\width + 5
        \row\tt\height = \row\_s()\height
        
;         \row\tt\width = \row\_s()\text\width-\width[2] + (\row\_s()\text\x - \row\_s()\x) + 5 
;         If \row\tt\width < 6 : \row\tt\width = 0 : EndIf
        Debug \row\tt\width
        
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
        \row\tt\text\y = (\row\_s()\text\y-\row\_s()\y)+\scroll\v\page\pos
        
        BindEvent(#PB_Event_ActivateWindow, @tt_CallBack(), \row\tt\Window)
        SetWindowData(\row\tt\Window, \row\tt)
        tt_draw(\row\tt)
      EndIf
    EndWith              
  EndProcedure
  
  Procedure tt_close(*this._s_tt)
    If IsWindow(*this\window)
      *this\visible = 0
      ;UnbindEvent(#PB_Event_ActivateWindow, @tt_CallBack(), *this\window)
      CloseWindow(*this\window)
      ; ClearStructure(*this, _s_tt) ;??????
    EndIf
  EndProcedure
  
  ;-
  Procedure Events(*this._struct_, eventtype.l, mouse_x.l=-1, mouse_y.l=-1, position.l=0)
    Protected Result, down
    
    Select eventtype
      Case #PB_EventType_LeftClick
        Debug "click - "+*this
        Post(eventtype, *this, *this\row\index)
        
      Case #PB_EventType_Change
        Debug "change - "+*this
        Post(eventtype, *this, *this\row\index)
        Result = 1
        
      Case #PB_EventType_DragStart
        Debug "drag - "+*this
        Post(eventtype, *this, *this\row\index)
        
      Case #PB_EventType_Drop
        Debug "drop - "+*this
        Post(eventtype, *this, *this\row\index)
        
      Case #PB_EventType_Focus
        Debug "focus - "+*this
        Result = 1
        
      Case #PB_EventType_LostFocus
        Debug "lost focus - "+*this
        Result = 1
        
      Case #PB_EventType_LeftButtonDown
        Debug "left down - "+*this
        
      Case #PB_EventType_LeftButtonUp
        Debug "left up - "+*this
        
      Case #PB_EventType_MouseEnter
        Debug "enter - "+*this +" "+ *this\root\mouse\buttons
        Result = 1
        
      Case #PB_EventType_MouseLeave
        Debug "leave - "+*this
        Result = 1
        
      Case #PB_EventType_MouseMove
        ; Debug "move - "+*this
        
        If position And *this\row\index >= 0
          ;down = *this\root\mouse\buttons
          
          ; event mouse enter line
          If position > 0
            If down And *this\flag\multiselect 
              _multi_select_(*this, *this\row\index, *this\row\selected\index)
              
            ElseIf *this\row\_s()\color\state = 0
              *this\row\_s()\color\state = 1+Bool(down)
              
              If down
                *this\row\selected = *this\row\_s()
              EndIf
            EndIf
            
            ; create tooltip on the item
            If Bool((*this\flag\buttons=0 And *this\flag\lines=0)) And *this\row\_s()\len > *this\width[2]
              tt_creare(*this, GadgetX(*this\root\canvas, #PB_Gadget_ScreenCoordinate), GadgetY(*this\root\canvas, #PB_Gadget_ScreenCoordinate))
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
      Result | Bar::CallBack(*this\scroll\v, eventtype, mouse_x, mouse_y, *this\root\mouse\wheel\x, *this\root\mouse\wheel\y)
      Result | Bar::CallBack(*this\scroll\h, eventtype, mouse_x, mouse_y, *this\root\mouse\wheel\x, *this\root\mouse\wheel\y)
      
      If (*this\scroll\v\change Or *this\scroll\h\change)
        If StartDrawing(CanvasOutput(*this\root\canvas))
          _update_(*this, *this\row\_s())
          StopDrawing()
        EndIf
        
        *this\scroll\v\change = 0 
        *this\scroll\h\change = 0
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l Tree_Events(*this._struct_, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
    Protected Result, from =- 1
    Static cursor_change, Down, *row_selected._s_rows
    
    With *this
      ; post widget events                     
      Select EventType 
        Case #PB_EventType_LeftButtonDown
          If *this = *event\enter  ; *event\leave;
            *this\root\mouse\delta\x = mouse_x
            *this\root\mouse\delta\y = mouse_y
            
            If *event\active <> *this
              _set_active_(*this)
            EndIf
            
            Result | Events(*this, EventType, mouse_x, mouse_y)
            
            If *this\row\index >= 0
              If _from_point_(mouse_x, mouse_y, *this\row\_s()\box[1])
                _set_state_(*this, *this\row\_s(), 1)
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
                
                If StartDrawing(CanvasOutput(*this\root\canvas))
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
                ;                     _multi_select_(*this, \row\index, \row\selected\index)
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
          
        Case #PB_EventType_LeftButtonUp 
          If *this = *event\leave And *event\leave\root\mouse\buttons
            *event\leave\root\mouse\buttons = 0
            
            If *this\row\box\checked 
              *this\row\box\checked = 0
              
            ElseIf *this\row\index >= 0 And Not *this\row\drag
              
              If *this\row\selected <> *row_selected
                *this\row\selected = *row_selected
                *this\row\selected\color\state = 2
                
                Result | Events(*this, #PB_EventType_Change, mouse_x, mouse_y)
              EndIf
            EndIf
            
            Result | Events(*this, #PB_EventType_LeftButtonUp, mouse_x, mouse_y)
            
            If *this\row\drag 
              *this\row\drag = 0
              
            ElseIf *this\row\index >= 0 
              Result | Events(*this, #PB_EventType_LeftClick, mouse_x, mouse_y)
            EndIf
            
            If *event\leave <> *event\enter
              Result | Events(*event\leave, #PB_EventType_MouseLeave, mouse_x, mouse_y) 
              *event\leave\row\index =- 1
              *event\leave = *event\enter
              
              ; post enter event
              If *event\enter
                Result | Events(*event\enter, #PB_EventType_MouseEnter, mouse_x, mouse_y)
              EndIf
            EndIf
            
            ; post drop event
            CompilerIf Defined(DD, #PB_Module)
              If DD::EventDrop(*event\enter, #PB_EventType_LeftButtonUp)
                Result | Events(*event\enter, #PB_EventType_Drop, mouse_x, mouse_y)
              EndIf
              
              If Not *event\enter
                DD::EventDrop(-1, #PB_EventType_LeftButtonUp)
              EndIf
            CompilerEndIf
            
          EndIf
          
          If *this = *event\enter And Not *event\leave
            Result | Events(*event\enter, #PB_EventType_MouseEnter, mouse_x, mouse_y)
            *event\leave = *event\enter
          EndIf
          
        Case #PB_EventType_LostFocus
          ; если фокус получил PB gadget
          ; то убираем фокус с виджета
          If *this = *event\active
            If *event\active\row\selected 
              *event\active\row\selected\color\state = 3
            EndIf
            
            Result | Events(*this, #PB_EventType_LostFocus, mouse_x, mouse_y)
            
            *event\active\color\state = 0
            *event\active = 0
          EndIf
          
        Case #PB_EventType_KeyDown
          If *this = *event\active
            
            Select *this\root\keyboard\key
              Case #PB_Shortcut_PageUp
                If Bar::SetState(*this\scroll\v, 0) 
                  *this\change = 1 
                  Result = 1
                EndIf
                
              Case #PB_Shortcut_PageDown
                If Bar::SetState(*this\scroll\v, *this\scroll\v\page\end) 
                  *this\change = 1 
                  Result = 1
                EndIf
                
              Case #PB_Shortcut_Up, #PB_Shortcut_Home
                If *this\row\selected
                  If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                     (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                    
                    If Bar::SetState(*this\scroll\v, *this\scroll\v\page\pos-18) 
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
                      
                      Result | Events(*this, #PB_EventType_Change, mouse_x, mouse_y)
                    EndIf
                    
                    *this\change = _bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down, #PB_Shortcut_End
                If *this\row\selected
                  If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                     (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                    
                    If Bar::SetState(*this\scroll\v, *this\scroll\v\page\pos+18) 
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
                      
                      Result | Events(*this, #PB_EventType_Change, mouse_x, mouse_y)
                    EndIf
                    
                    *this\change = _bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Left
                If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                   (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                  
                  *this\change = Bar::SetState(*this\scroll\h, *this\scroll\h\page\pos-(*this\scroll\h\page\end/10)) 
                  Result = 1
                EndIf
                
              Case #PB_Shortcut_Right
                If (*this\root\keyboard\key[1] & #PB_Canvas_Alt) And
                   (*this\root\keyboard\key[1] & #PB_Canvas_Control)
                  
                  *this\change = Bar::SetState(*this\scroll\h, *this\scroll\h\page\pos+(*this\scroll\h\page\end/10)) 
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
            If (mouse_y >= *this\row\draws()\y-*this\scroll\v\page\pos And
                mouse_y < *this\row\draws()\y+*this\row\draws()\height-*this\scroll\v\page\pos)
              
              If *this\row\index <> *this\row\draws()\index
                If *this\row\index >= 0 ;And SelectElement(\row\_s(), \row\index)
                  Result | Events(*this, #PB_EventType_MouseMove, mouse_x, mouse_y, -1)
                EndIf
                
                *this\row\index = *this\row\draws()\index
                
                If *this\row\index >= 0 And SelectElement(*this\row\_s(), *this\row\index)
                  Result | Events(*this, #PB_EventType_MouseMove, mouse_x, mouse_y, 1)
                EndIf
              EndIf
              
              Break
            EndIf
          Next
          
          If *this\row\index >= 0 And Not (mouse_y >= *this\row\_s()\y-*this\scroll\v\page\pos And
                                           mouse_y < *this\row\_s()\y+*this\row\_s()\height-*this\scroll\v\page\pos)
            Result | Events(*this, #PB_EventType_MouseMove, mouse_x, mouse_y, -1)
            *this\row\index =- 1
          EndIf
        Else
          
          If *this\row\index >= 0
            ;Debug " leave items"
            Result | Events(*this, #PB_EventType_MouseMove, mouse_x, mouse_y, -1)
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
            
            Result | Events(*this, #PB_EventType_Change, mouse_x, mouse_y)
          EndIf
          
          Result | Events(*this, #PB_EventType_DragStart, mouse_x, mouse_y)
        EndIf
      EndIf
      
      If EventType = #PB_EventType_MouseMove
        If *event\leave And *event\leave\row\index =- 1
          Result | Events(*event\leave, #PB_EventType_MouseMove, mouse_x, mouse_y)
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l CallBack(*this._struct_, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
    Protected Result, from =- 1
    Static cursor_change, Down, *row_selected._s_rows
    
    If Not *this Or 
       Not *this\handle
      ProcedureReturn 0
    EndIf
    
    Select EventType
      Case #PB_EventType_Repaint
        Debug " -- Canvas repaint -- " + *this\row\count
      Case #PB_EventType_MouseWheel
        *this\root\mouse\wheel\y = GetGadgetAttribute(*this\root\canvas, #PB_Canvas_WheelDelta)
      Case #PB_EventType_Input 
        *this\root\keyboard\input = GetGadgetAttribute(*this\root\canvas, #PB_Canvas_Input)
      Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
        *this\root\keyboard\Key = GetGadgetAttribute(*this\root\canvas, #PB_Canvas_Key)
        *this\root\keyboard\Key[1] = GetGadgetAttribute(*this\root\canvas, #PB_Canvas_Modifiers)
      Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
        *this\root\mouse\x = GetGadgetAttribute(*this\root\canvas, #PB_Canvas_MouseX)
        *this\root\mouse\y = GetGadgetAttribute(*this\root\canvas, #PB_Canvas_MouseY)
        
    EndSelect
    
    mouse_x = *this\root\mouse\x
    mouse_y = *this\root\mouse\y
    
    With *this
      ;       DD::DropStart(_this_)
      ;       Post(#PB_EventType_Drop, DD::DropStop(_this_), _this_\row\index)
      
      Protected enter = Bool(*event\enter <> *this And Not (*event\enter And *event\enter\index > *this\index) And _from_point_(mouse_x, mouse_y, *this))
      Protected leave = Bool(*event\enter And (enter Or (*event\enter = *this And Not _from_point_(mouse_x, mouse_y, *event\enter))))
      
      If leave
        If *event\enter\countitems And *event\enter\row\index >= 0 ;And SelectElement(*event\enter\row\_s(), *event\enter\row\index)
          Result | Events(*event\enter, #PB_EventType_MouseMove, mouse_x, mouse_y, -1)
        EndIf
        
        ;If Not *event\enter\mouse\buttons
        If Not *this\root\mouse\buttons ; And *event\enter <> *this\parent
          Result | Events(*event\enter, #PB_EventType_MouseLeave, mouse_x, mouse_y)
          
          If *event\enter And *event\enter\root\canvas <> *this\root\canvas
            ReDraw(*event\enter)
            ; _repaint_(*event\enter)
          EndIf
          
          *event\leave = *event\enter ; надо проверить нужен или нет (а так для них нужен *event\enter <> *this\parent)
        EndIf
        
        ; reset drop start
        CompilerIf Defined(DD, #PB_Module)
          If *event\leave And *event\leave\row\drag
            DD::EventDrop(0, #PB_EventType_MouseLeave)
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
            DD::EventDrop(*event\enter, #PB_EventType_MouseEnter)
          EndIf
        CompilerEndIf
        
        If Not *this\root\mouse\buttons ; And Not (*event\leave And *event\leave\parent = *this)
          Result | Events(*event\enter, #PB_EventType_MouseEnter, mouse_x, mouse_y)
          *event\leave = *event\enter
        EndIf
      EndIf
      
      ; set mouse buttons
      If *this = *event\enter 
        If EventType = #PB_EventType_LeftButtonDown
          \root\mouse\buttons | #PB_Canvas_LeftButton
        ElseIf EventType = #PB_EventType_RightButtonDown
          \root\mouse\buttons | #PB_Canvas_RightButton
        ElseIf EventType = #PB_EventType_MiddleButtonDown
          \root\mouse\buttons | #PB_Canvas_MiddleButton
        EndIf
      EndIf
      
      
      If (*this = *event\enter Or *this = *event\leave Or *this = *event\active)
       Result = Tree_Events(*this, EventType, mouse_x, mouse_y)
      EndIf
      
      
      ; reset mouse buttons
      If \root\mouse\buttons
        If EventType = #PB_EventType_LeftButtonUp
          \root\mouse\buttons &~ #PB_Canvas_LeftButton
        ElseIf EventType = #PB_EventType_RightButtonUp
          \root\mouse\buttons &~ #PB_Canvas_RightButton
        ElseIf EventType = #PB_EventType_MiddleButtonUp
          \root\mouse\buttons &~ #PB_Canvas_MiddleButton
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure g_CallBack()
    Protected Repaint.b
    Protected EventType.i = EventType()
    Protected *this._struct_ = GetGadgetData(EventGadget())
    
    With *this
      Select EventType
        Case #PB_EventType_Repaint
          \row\count = \countitems
          Repaint = 1
          
        Case #PB_EventType_Resize : ResizeGadget(\root\canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Resize(*this, #PB_Ignore, #PB_Ignore, GadgetWidth(\root\canvas), GadgetHeight(\root\canvas))   
          
          If \scroll\v\page\len And \scroll\v\max<>\scroll\height-Bool(\flag\gridlines) And
             Bar::SetAttribute(\scroll\v, #PB_ScrollBar_Maximum, \scroll\height-Bool(\flag\gridlines))
            
            Bar::Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
          
          If \scroll\h\page\len And \scroll\h\max<>\scroll\width And
             Bar::SetAttribute(\scroll\h, #PB_ScrollBar_Maximum, \scroll\width)
            
            Bar::Resizes(\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
          
          If \resize = 1<<3
            \width[2] = (\scroll\v\x + Bool(\scroll\v\hide) * \scroll\v\width) - \x[2]
          EndIf 
          
          If \resize = 1<<4
            \height[2] = (\scroll\h\y + Bool(\scroll\h\hide) * \scroll\h\height) - \y[2]
          EndIf
          
          If StartDrawing(CanvasOutput(\root\canvas))
            Draw(*this)
            StopDrawing()
          EndIf
      EndSelect
      
      Repaint | CallBack(*this, EventType)
      
      If Repaint And 
         StartDrawing(CanvasOutput(\root\canvas))
        ; Debug \root\canvas
        Draw(*this)
        StopDrawing()
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected *this._struct_ = Tree(0, 0, Width, Height, Flag)
    
    If *this
      With *this
        *this\root\window = GetActiveWindow()
        *this\root\canvas = Gadget
        
        SetGadgetData(Gadget, *this)
        BindGadgetEvent(Gadget, @g_CallBack())
        ;BindEvent(#PB_Event_Repaint, @w_CallBack() )
        
        ; z-order
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE, GetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE ) | #WS_CLIPSIBLINGS )
          SetWindowPos_( GadgetID(Gadget), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        CompilerEndIf
        
        _repaint_(*this)
      EndWith
    EndIf
    
    ProcedureReturn Gadget
  EndProcedure
  
  ;-
  Procedure.b Post(eventtype.l, *this._struct_, item.l=#PB_All, *data=0)
    If *this And *this\event And 
       (*this\event\type = #PB_All Or 
        *this\event\type = eventtype)
      
      *event\widget = *this
      *event\type = eventtype
      *event\data = *data
      *event\item = item
      
      ;If *this\event\callback
      *this\event\callback()
      ;EndIf
      
      *event\widget = 0
      *event\data = 0
      *event\type =- 1
      *event\item =- 1
    EndIf
  EndProcedure
  
  Procedure.b Bind(*this._struct_, *callBack, eventtype.l=#PB_All)
    *this\event = AllocateStructure(_s_event)
    *this\event\type = eventtype
    *this\event\callback = *callBack
  EndProcedure
  
  Procedure Free(*this._struct_)
    Protected Gadget = *this\root\canvas
    
    ClearStructure(*this\scroll\v, _s_bar)
    ClearStructure(*this\scroll\h, _s_bar)
    ClearStructure(*this, _struct_)
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
    Procedure GadgetsClipCallBack( GadgetID, lParam )
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
      EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
    CompilerEndIf
  EndProcedure
  
  
  UseModule tree
  Global Canvas_0
  Global *g._struct_
  Global *g0._struct_
  Global *g1._struct_
  Global *g2._struct_
  Global *g3._struct_
  Global *g4._struct_
  Global *g5._struct_
  Global *g6._struct_
  Global *g7._struct_
  Global *g8._struct_
  Global *g9._struct_
  
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
                          AddItem(Widget, 0, PackEntryName.S, Image)
                          ;SetItemData(Widget, 0, Image)
                          
                        ElseIf FindString(LCase(PackEntryName.S), "window")
                          
                          Debug "add window"
                          AddItem(Widget, 1, PackEntryName.S, Image)
                          ;SetItemData(Widget, 1, Image)
                          
                        Else
                          AddItem(Widget, -1, PackEntryName.S, Image)
                          ;SetItemData(Widget, CountItems(Widget)-1, Image)
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
  
  Global g_Canvas, NewList *List._struct_()
  
  Procedure _ReDraw(Canvas)
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
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    Protected *this._struct_ ; = GetGadgetData(Canvas)
    
    Select EventType
      Case #PB_EventType_Repaint
        *this = EventData()
        
        If *this And *this\handle
          *this\row\count = *this\countitems
          CallBack(*this, EventType)
          
          If StartDrawing(CanvasOutput(*this\root\canvas))
            If *event\draw = 0
              *event\draw = 1
              FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
            EndIf
            
            Draw(*this)
            StopDrawing()
          EndIf
          
          ;ReDraw(*this, $F6)
          ProcedureReturn
        Else
          Repaint = 1
        EndIf
        
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      If Not *List()\handle
        DeleteElement(*List())
      EndIf
      
      *List()\root\canvas = EventGadget()
      *List()\root\window = EventWindow()
      
      Repaint | CallBack(*List(), EventType);, MouseX, MouseY)
    Next
    
    If Repaint 
      _ReDraw(Canvas)
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
    Protected EventItem = GetGadgetState(EventGadget)
    
    Select EventType
      Case #PB_EventType_ScrollChange : Debug "gadget scroll change data "+ EventData
      Case #PB_EventType_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_DragStart : Debug "gadget dragStart item = " + EventItem +" data "+ EventData
      Case #PB_EventType_Change    : Debug "gadget change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_LeftClick : Debug "gadget click item = " + EventItem +" data "+ EventData
    EndSelect
  EndProcedure
  
  Procedure events_tree_widget()
    ;Debug " widget - "+*event\widget+" "+*event\type
    Protected EventGadget = *event\widget
    Protected EventType = *event\type
    Protected EventData = *event\data
    Protected EventItem = GetState(EventGadget)
    
    Select EventType
      Case #PB_EventType_ScrollChange : Debug "widget scroll change data "+ EventData
      Case #PB_EventType_StatusChange : Debug "widget status change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_DragStart : Debug "widget dragStart item = " + EventItem +" data "+ EventData
      Case #PB_EventType_Change    : Debug "widget change item = " + EventItem +" data "+ EventData
      Case #PB_EventType_LeftClick : Debug "widget click item = " + EventItem +" data "+ EventData
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
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    
    ; RemoveGadgetItem(g,1)
    SetGadgetItemState(g, 1, #__tree_Selected|#__tree_Collapsed|#__tree_Checked)
    ;BindGadgetEvent(g, @Events())
    
    ;SetActiveGadget(g)
    ;SetGadgetState(g, 1)
    ;     Debug "g "+ GetGadgetText(g)
    
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
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    
    
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
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    
    SetGadgetItemState(g, 0, #__tree_Selected|#__tree_Checked)
    SetGadgetItemState(g, 5, #__tree_Selected|#__tree_Inbetween)
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
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    
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
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    SetGadgetItemImage(g, 0, ImageID(0))
    
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
    
    ;For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #__tree_Expanded) : Next
    
    Define widget = 0
    
    ;If widget
    g_Canvas = CanvasGadget(-1, 0, 225, 1110, 425, #PB_Canvas_Keyboard|#PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    ;PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    ;EndIf
    
    g = 10
    
    If widget
      *g = Tree(10, 100, 210, 210, #__tree_CheckBoxes)                                         
      *g\root\canvas = g_Canvas
      AddElement(*List()) : *List() = *g
    Else
      *g = GetGadgetData(Gadget(g, 10, 100, 210, 210, #__tree_CheckBoxes|#__tree_MultiSelect))
    EndIf
    
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
    ;For i=0 To CountItems(*g) : SetItemState(*g, i, #__tree_Expanded) : Next
    
    ; RemoveItem(*g,1)
    SetItemState(*g, 1, #__tree_Selected|#__tree_Collapsed|#__tree_Checked)
    ;BindGadgetEvent(g, @Events())
    ;     SetState(*g, 3)
    ;     SetState(*g, -1)
    ;Debug " - "+GetText(*g)
    LoadFont(3, "Arial", 18)
    SetFont(*g, 3)
    
    g = 11
    If widget
      *g = Tree(230, 100, 210, 210, #__tree_AlwaysSelection);|#__tree_Collapsed)                                         
      *g\root\canvas = g_Canvas
      AddElement(*List()) : *List() = *g
    Else
      *g = GetGadgetData(Gadget(g, 160, 120, 210, 210, #__tree_AlwaysSelection))
    EndIf
    
    ;  3_example
    AddItem(*g, 0, "Tree_0", -1 )
    AddItem(*g, 1, "Tree_1_1", 0, 1) 
    AddItem(*g, 4, "Tree_1_1_1", -1, 2) 
    AddItem(*g, 5, "Tree_1_1_2", -1, 2) 
    AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(*g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
    AddItem(*g, 7, "Tree_1_1_2_2 980980_", -1, 3) 
    AddItem(*g, 2, "Tree_1_2", -1, 1) 
    AddItem(*g, 3, "Tree_1_3", -1, 1) 
    AddItem(*g, 9, "Tree_2",-1 )
    AddItem(*g, 10, "Tree_3", -1 )
    AddItem(*g, 11, "Tree_4", -1 )
    AddItem(*g, 12, "Tree_5", -1 )
    AddItem(*g, 13, "Tree_6", -1 )
    
    g = 12
    *g = Tree(450, 100, 210, 210, #__tree_CheckBoxes|#__tree_NoLines|#__tree_NoButtons|#__tree_GridLines | #__tree_ThreeState | #__tree_OptionBoxes)                            
    *g\root\canvas = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  2_example
    AddItem (*g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5 ;Or i%3=0
        AddItem(*g, -1, "Tree_"+Str(i), -1, 0) 
      Else
        AddItem(*g, -1, "Tree_"+Str(i), 0, -1) 
      EndIf
    Next
    ;For i=0 To CountItems(*g) : SetItemState(*g, i, #__tree_Expanded) : Next
    SetItemState(*g, 0, #__tree_Selected|#__tree_Checked)
    SetItemState(*g, 5, #__tree_Selected|#__tree_Inbetween)
    
    LoadFont(5, "Arial", 16)
    SetItemFont(*g, 3, 5)
    SetItemText(*g, 3, "16_font and text change")
    SetItemColor(*g, 5, #__color_front, $FFFFFF00)
    SetItemColor(*g, 5, #__color_back, $FFFF00FF)
    SetItemText(*g, 5, "backcolor and text change")
    LoadFont(6, "Arial", 25)
    SetItemFont(*g, 4, 6)
    SetItemText(*g, 4, "25_font and text change")
    SetItemFont(*g, 14, 6)
    SetItemText(*g, 14, "25_font and text change")
    Bind(*g, @events_tree_widget())
    
    g = 13
    *g = Tree(600+70, 100, 210, 210, #__tree_OptionBoxes|#__tree_NoButtons|#__tree_NoLines|#__tree_ClickSelect) ;                                        
    *g\root\canvas = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  4_example
    ; ;     AddItem(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    ; ;     AddItem(*g, 1, "Tree_1", -1, 1) 
    ; ;     AddItem(*g, 2, "Tree_2_2", -1, 2) 
    ; ;     AddItem(*g, 2, "Tree_2_1", -1, 1) 
    ; ;     AddItem(*g, 3, "Tree_3_1", -1, 1) 
    ; ;     AddItem(*g, 3, "Tree_3_2", -1, 2) 
    ; ;     For i=0 To CountItems(*g) : SetItemState(*g, i, #__tree_Expanded) : Next
    AddItem (*g, -1, "#PB_Window_MinimizeGadget", -1) ; Adds the minimize gadget To the window title bar. AddItem (*g, -1, "#PB_Window_SystemMenu is automatically added.
    AddItem (*g, -1, "#PB_Window_MaximizeGadget", -1) ; Adds the maximize gadget To the window title bar. AddItem (*g, -1, "#PB_Window_SystemMenu is automatically added.
                                                      ;                              (MacOS only", -1) ; AddItem (*g, -1, "#PB_Window_SizeGadget", -1) ; will be also automatically added", -1).
    AddItem (*g, -1, "#PB_Window_SizeGadget    ", -1) ; Adds the sizeable feature To a window.
    AddItem (*g, -1, "#PB_Window_Invisible     ", -1) ; Creates the window but don't display.
    AddItem (*g, -1, "#PB_Window_SystemMenu    ", -1) ; Enables the system menu on the window title bar (Default", -1).
    AddItem (*g, -1, "#PB_Window_TitleBar      ", -1,1) ; Creates a window With a titlebar.
    AddItem (*g, -1, "#PB_Window_Tool          ", -1,1) ; Creates a window With a smaller titlebar And no taskbar entry. 
    AddItem (*g, -1, "#PB_Window_BorderLess    ", -1,1) ; Creates a window without any borders.
    AddItem (*g, -1, "#PB_Window_ScreenCentered", -1)   ; Centers the window in the middle of the screen. x,y parameters are ignored.
    AddItem (*g, -1, "#PB_Window_WindowCentered", -1)   ; Centers the window in the middle of the parent window ('ParentWindowID' must be specified", -1). x,y parameters are ignored.
    AddItem (*g, -1, "#PB_Window_Maximize      ", -1, 1); Opens the window maximized. (Note", -1) ; on Linux, Not all Windowmanagers support this", -1)
    AddItem (*g, -1, "#PB_Window_Minimize      ", -1, 1); Opens the window minimized.
    AddItem (*g, -1, "#PB_Window_NoGadgets     ", -1)   ; Prevents the creation of a GadgetList. UseGadgetList(", -1) can be used To do this later.
    AddItem (*g, -1, "#PB_Window_NoActivate    ", -1)   ; Don't activate the window after opening.
    
    
    
    g = 14
    *g = Tree(750+135, 100, 103, 210, #__tree_NoButtons)                                         
    *g\root\canvas = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  5_example
    AddItem(*g, 0, "Tree_0", -1 )
    AddItem(*g, 1, "Tree_1", -1, 0) 
    AddItem(*g, 2, "Tree_2", -1, 0) 
    AddItem(*g, 3, "Tree_3", -1, 0) 
    AddItem(*g, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #__tree_Expanded) : Next
    SetItemImage(*g, 0, 0)
    
    g = 15
    *g = Tree(890+106, 100, 103, 210, #__tree_BorderLess|#__tree_Collapse)                                         
    *g\root\canvas = g_Canvas
    AddElement(*List()) : *List() = *g
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
  
  Global g_Canvas, *g._struct_, NewList *List._struct_()
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Procedure Events()
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
      Case #PB_EventType_DragStart
        Select EventGadget
            
          Case SourceText
            Text$ = GetItemText(SourceText, GetState(SourceText))
            DragText(Text$)
            
            ;           Case SourceImage
            ;             DragImage((#ImageSource))
            ;             
            ;           Case SourceFiles
            ;             Files$ = ""       
            ;             For i = 0 To CountItems(SourceFiles)-1
            ;               If GetItemState(SourceFiles, i) & #PB_Explorer_Selected
            ;                 Files$ + GetText(SourceFiles) + GetItemText(SourceFiles, i) + Chr(10)
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
            ;             If GetState(SourcePrivate) = 0
            ;               DragPrivate(1)
            ;             Else
            ;               DragPrivate(2)
            ;             EndIf
            
        EndSelect
        
        ; Drop event on the target gadgets, receive the dropped data
        ;
      Case #PB_EventType_Drop
        
        Select EventGadget
            
          Case TargetText
            AddItem(TargetText, -1, EventDropText())
            
            ;           Case TargetImage
            ;             If DropImage(#ImageTarget)
            ;               SetState(TargetImage, (#ImageTarget))
            ;             EndIf
            ;             
            ;           Case TargetFiles
            ;             Files$ = EventDropFiles()
            ;             Count  = CountString(Files$, Chr(10)) + 1
            ;             For i = 1 To Count
            ;               AddItem(TargetFiles, -1, StringField(Files$, i, Chr(10)))
            ;             Next i
            ;             
            ;           Case TargetPrivate1
            ;             AddItem(TargetPrivate1, -1, "Private type 1 dropped")
            ;             
            ;           Case TargetPrivate2
            ;             AddItem(TargetPrivate2, -1, "Private type 2 dropped")
            
        EndSelect
        
    EndSelect
    
  EndProcedure
  
  If OpenWindow(#Window, 0, 0, 760, 310, "Drag & Drop", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
    
    g_Canvas = CanvasGadget(-1, 0, 0, 760, 310, #PB_Canvas_Keyboard|#PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    
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
    *g\root\canvas = g_Canvas
    AddElement(*List()) : *List() = *g
    ;SourceImage = Image(160, 10, 140, 140, (#ImageSource), #PB_Image_Border) 
    ;SourceFiles = ExplorerList(310, 10, 290, 140, GetHomeDirectory(), #PB_Explorer_MultiSelect)
    ;SourcePrivate = ListIcon(610, 10, 140, 140, "Drag private stuff here", 260)
    
    AddItem(SourceText, -1, "hello world")
    AddItem(SourceText, -1, "The quick brown fox jumped over the lazy dog")
    AddItem(SourceText, -1, "abcdefg")
    AddItem(SourceText, -1, "123456789")
    
    ;     AddItem(SourcePrivate, -1, "Private type 1")
    ;     AddItem(SourcePrivate, -1, "Private type 2")
    
    
    ; create the target s
    ;
    TargetText = Tree(10, 160, 140, 140);, "Drop Text here", 130)
    *g = TargetText
    *g\root\canvas = g_Canvas
    AddElement(*List()) : *List() = *g
    
    TargetImage = Tree(160, 160, 140, 140);, (#ImageTarget), #PB_Image_Border) 
    *g = TargetImage
    *g\root\canvas = g_Canvas
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
    
    Bind(SourceText, @Events(), #PB_EventType_DragStart)
    Bind(TargetText, @Events(), #PB_EventType_Drop)
    
    ;     Bind(@Events())
    ;     ReDraw(Root())
    
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
  
  End
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -----------------------------------------------------------------------------------------
; EnableXP