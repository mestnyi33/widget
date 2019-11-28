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
     
    #PB_Text_Vertical
    #PB_Text_Reverse ; Mirror
    #PB_Text_InLine
    
    #PB_Flag_BorderLess
    #PB_Flag_Double
    #PB_Flag_Flat
    #PB_Flag_Raised
    #PB__s_flagingle
    
    #PB_Flag_Default
    #PB_Flag_Toggle
    
    #PB_Flag_GridLines
    #PB_Flag_Invisible
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
  
;   #PB_Text_Left = ~#PB_Text_Center
;   #PB_Text_Top = ~#PB_Text_Middle
;   
  If WidgetFlags > 2147483647
    Debug "Исчерпан лимит в x32"+WidgetFlags
  EndIf
  
  #PB_Gadget_FrameColor = 10
  
EndDeclareModule 

Module Constants
  
EndModule 

UseModule Constants

DeclareModule Structures
  
  ;- STRUCTURE
  Structure Point_S
    y.i
    x.i
  EndStructure
  
  Structure _s_Coordinate
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  Structure _s_mouse
    X.i
    Y.i
    From.i ; at point widget
    Buttons.i
    *Delta._s_mouse
  EndStructure
  
  Structure _s_align
    Right.b
    Bottom.b
    Vertical.b
    Horisontal.b
  EndStructure
  
  Structure _s_page
    Pos.i
    Length.i
    ScrollStep.i
  EndStructure
  
  Structure _s_canvas
    Mouse._s_mouse
    Gadget.i
    Window.i
    
    Input.c
    Key.i[2]
  EndStructure
  
  Structure _s_color
    State.b
    Front.i[4]
    Fore.i[4]
    Back.i[4]
    Line.i[4]
    Frame.i[4]
    Arrows.i[4]
  EndStructure
  
  Structure Style_S
    InLine.i
    NoLines.i
    NoButtons.i
    CheckBoxes.i
    FullRowSelect.i
    AlwaysShowSelection.i
  EndStructure
  
  Structure _s_image Extends _s_Coordinate
    handle.i[2]
    change.b
    Align._s_align
  EndStructure
  
  Structure _s_text Extends _s_Coordinate
    ;     Char.c
    Len.i
    FontID.i
    String.s[3]
    Count.i[2]
    Change.b
    
    Align._s_align
    
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    MultiLine.b
    Vertical.b
    Rotate.f
    
    Mode.i
  EndStructure
  
  Structure _s_scroll Extends _s_Coordinate
    Window.i
    Gadget.i
    
    Both.b ; we see both scrolbars
    
    Size.i[4]
    Type.i[4]
    Focus.i
    Buttons.i
    Radius.i
    
    Hide.b[2]
    Alpha.a[2]
    Disable.b[2]
    Vertical.b
    DrawingMode.i
    
    Max.i
    Min.i
    Page._s_page
    Area._s_page
    Thumb._s_page
    Button._s_page
    Color._s_color[4]
  EndStructure
  
  Structure S_S
    Vertical._s_scroll
    Horisontal._s_scroll
  EndStructure
  
  Structure Scrolls_S Extends _s_Coordinate
    *Widget.S_S
  EndStructure
  
  Structure _s_flag
    FullSelection.b
    AlwaysSelection.b
    NoButtons.b
    NoLines.b
    CheckBoxes.b
    GridLines.b
  EndStructure
  
  Structure _s_widget Extends _s_Coordinate
    Index.i  ; Index of new list element
    Handle.i ; Adress of new list element
             ;
    
    *Widget._s_widget
    Canvas._s_canvas
    Style.Style_S
    Color._s_color[4]
    Text._s_text[4]
    Clip._s_Coordinate
    
    Scroll.Scrolls_S
    vScroll._s_scroll
    hScroll._s_scroll
    
    Image._s_image
    box._s_Coordinate
    Flag._s_flag
    
    
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
    adress.i[2]
    sublevel.i
    *data
    collapsed.b
    childrens.i
    Item.i
    Attribute.i
    change.b
    
    
    *Default
    Alpha.a[2]
    
    DrawingMode.i
    
    List Items._s_widget()
    List Columns._s_widget()
    
  EndStructure
  
  ; $FF24B002 ; $FFD5A719 ; $FFE89C3D ; $FFDE9541 ; $FFFADBB3 ;
  Global Colors._s_color
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
    \Front[2] = $80FFFFFF
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
  
  Global *Focus._s_widget
  Global NewList List._s_widget()
  Global Use_List_Canvas_Gadget
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Structures


DeclareModule Scroll
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  
  Declare.b Draw(*Scroll._s_scroll)
  Declare.i Y(*Scroll._s_scroll)
  Declare.i X(*Scroll._s_scroll)
  Declare.i Width(*Scroll._s_scroll)
  Declare.i Height(*Scroll._s_scroll)
  Declare.b SetState(*Scroll._s_scroll, ScrollPos.i)
  Declare.i SetAttribute(*Scroll._s_scroll, Attribute.i, Value.i)
  Declare.i SetColor(*Scroll._s_scroll, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.b Resize(*This._s_scroll, iX.i,iY.i,iWidth.i,iHeight.i, *Scroll._s_scroll=#Null)
  Declare.b Resizes(*v._s_scroll, *h._s_scroll, X.i,Y.i,Width.i,Height.i)
  Declare.b Updates(*v._s_scroll, *h._s_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*This._s_scroll, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0, AutoHide.b=0, *Scroll._s_scroll=#Null, Window=-1, Gadget=-1)
  Declare.i Widget(*Scroll._s_scroll, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
EndDeclareModule

Module Scroll
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\Length / (_this_\Max-_this_\Min)), #PB_Round_Nearest))
  EndMacro
  
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
  
  Procedure.i Pos(*This._s_scroll, ThumbPos.i)
    Protected ScrollPos.i
    
    With *This
      ScrollPos = Match(\Min + Round((ThumbPos - \Area\Pos) / (\Area\Length / (\Max-\Min)), #PB_Round_Nearest), \Page\ScrollStep)
      If (\Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Max-\Min)-ScrollPos) : EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.b Draw(*Scroll._s_scroll)
    With *Scroll
      If Not \Hide And \Alpha
        
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[0],\Y[0],\Width[0],\Height[0],\Radius,\Radius,\Color[0]\Back[\Color[0]\State]&$FFFFFF|\Alpha<<24)
        
        If \Vertical
          ; Draw left line
          If \Both
            ; "Это пустое пространство между двумя скроллами тоже закрашиваем если скролл бара кнопки не круглые"
            If Not \Radius : Box(\X[2],\Y[2]+\height[2]+1,\Width[2],\Height[2],\Color[0]\Back[\Color[0]\State]&$FFFFFF|\Alpha<<24) : EndIf
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
  
  Procedure.i X(*Scroll._s_scroll)
    Protected Result.i
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Alpha
          Result = \X
        Else
          Result = \X+\Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Y(*Scroll._s_scroll)
    Protected Result.i
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Alpha
          Result = \Y
        Else
          Result = \Y+\Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Width(*Scroll._s_scroll)
    Protected Result.i
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Width And \Alpha
          Result = \Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Height(*Scroll._s_scroll)
    Protected Result.i
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Height And \Alpha
          Result = \Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState(*Scroll._s_scroll, ScrollPos.i)
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
        
        If \Vertical
          \Y[3] = \Thumb\Pos
          \Height[3] = \Thumb\Length
        Else
          \X[3] = \Thumb\Pos
          \Width[3] = \Thumb\Length
        EndIf
        
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
  
  Procedure.i SetAttribute(*Scroll._s_scroll, Attribute.i, Value.i)
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
            
            \Page\ScrollStep = (\Max-\Min) / 100
            
            Result = #True
          EndIf
          
        Case #PB_ScrollBar_PageLength
          If \Page\Length <> Value
            If Value > (\Max-\Min) : \Max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
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
  
  Procedure.i SetColor(*Scroll._s_scroll, ColorType.i, Color.i, State.i=0, Item.i=0)
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
  
  Procedure.b Resize(*This._s_scroll, X.i,Y.i,Width.i,Height.i, *Scroll._s_scroll=#Null)
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
      If X=#PB_Ignore : X = \X[0] : EndIf : If Y=#PB_Ignore : Y = \Y[0] : EndIf 
      If Width=#PB_Ignore : Width = \Width[0] : EndIf : If Height=#PB_Ignore : Height = \Height[0] : EndIf
      
      ;
      If ((\Max-\Min) >= \Page\Length)
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
            If (\Type <> #PB_GadgetType_TrackBar) And (\Thumb\Pos+\Thumb\Length) >= (\Area\Length+\Button\Length)
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
  
  Procedure.b Updates(*v._s_scroll, *h._s_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
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
  
  Procedure.b Resizes(*v._s_scroll, *h._s_scroll, X.i,Y.i,Width.i,Height.i )
    If Width=#PB_Ignore : Width = *v\X+*v\Width : Else : Width+x : EndIf
    If Height=#PB_Ignore : Height = *h\Y+*h\Height : Else : Height+y : EndIf
    
    Protected iWidth = Width-Width(*v), iHeight = Height-Height(*h)
    
    If *v\width And *v\Page\Length<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\height And *h\Page\Length<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    *v\Hide = Resize(*v, Width-*v\Width, Y, #PB_Ignore, #PB_Ignore, *h) : iWidth = Width-Width(*v)
    *h\Hide = Resize(*h, X, Height-*h\Height, #PB_Ignore, #PB_Ignore, *v) : iHeight = Height-Height(*h)
    
    If *v\width And *v\Page\Length<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\height And *h\Page\Length<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If *v\width : *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h) : EndIf
    If *h\height : *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *v) : EndIf
    
    ; Do we see both scrolbars?
    *v\Both = Bool(Not *h\Hide) 
    *h\Both = Bool(Not *v\Hide) 
    
    If *v\Hide : *v\Page\Pos = 0 : Else
      If *h\Radius : Resize(*h, #PB_Ignore, #PB_Ignore, *v\x+*v\Radius/2-1, #PB_Ignore) : EndIf
    EndIf
    If *h\Hide : *h\Page\Pos = 0 : Else
      If *v\Radius : Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h\y+*v\Radius/2-1) : EndIf
    EndIf
    
    ProcedureReturn Bool(*v\Hide|*h\Hide)
  EndProcedure
  
  Procedure.b CallBack(*This._s_scroll, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0, AutoHide.b=0, *Scroll._s_scroll=#Null, Window=-1, Gadget=-1)
    Protected Result, Buttons
    Static LastX, LastY, Last, *Thisis._s_scroll, Cursor, Drag, Down
    
    If *This
      If EventType = #PB_EventType_LeftButtonDown
        ;  Debug "CallBack(*This._s_scroll)"
      EndIf
      
      With *This
        If \Type = #PB_GadgetType_ScrollBar
          If \Hide And *This = *Thisis
            \Buttons = 0
            *Thisis = 0
            \Focus = 0
          EndIf
          
          ; get at point buttons
          If Down
            Buttons = \Buttons 
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
              If Not Drag : \Buttons = 0 : Buttons = 0 : LastX = 0 : LastY = 0 : EndIf
            Case #PB_EventType_LeftButtonUp : Down = 0 :  Drag = 0 :  LastX = 0 : LastY = 0
            Case #PB_EventType_LeftButtonDown 
              If Not \Hide : Down = 1
                If Buttons : \Buttons = Buttons : Drag = 1 : *Thisis = *This : EndIf
                
                Select Buttons
                  Case - 1
                    If *Thisis = *This Or (\Height>(\Y[2]+\Height[2]) And \Buttons =- 1) 
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
                    \Buttons = Buttons
                  Else   ;   If *Thisis = *This
                    EventType = #PB_EventType_MouseLeave
                    \Buttons = 0
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
  
  Procedure.i Widget(*Scroll._s_scroll, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
    
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
      
      ; Цвет фона скролла
      \Color[0]\State = 0
      \Color[0]\Back[0] = $FFF9F9F9
      \Color[0]\Frame[0] = \Color\Back[0]
      
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
    
    ProcedureReturn Resize(*Scroll, X,Y,Width,Height)
  EndProcedure
  
EndModule
;-

;-
DeclareModule Text
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  ;- - DECLAREs PROCEDUREs
  Declare.i Draw(*This_s_widget, Canvas.i=-1)
  Declare.s Make(*This._s_widget, Text.s)
  Declare.i MultiLine(*This._s_widget)
  Declare.i SelectionLimits(*This._s_widget)
  Declare.s GetText(*This._s_widget)
  Declare.i SetText(*This._s_widget, Text.s)
  Declare.i GetFont(*This._s_widget)
  Declare.i SetFont(*This._s_widget, FontID.i)
  Declare.i AddLine(*This._s_widget, Line.i, Text.s)
  Declare.i GetColor(*This._s_widget, ColorType.i, State.i=0)
  Declare.i SetColor(*This._s_widget, ColorType.i, Color.i, State.i=1)
  Declare.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  Declare.i CallBack(*Function, *This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Widget(*This._s_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  ;Declare.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  
  Declare.i Caret(*This._s_widget, Line.i = 0)
  Declare.i Remove(*This._s_widget)
  Declare.i ToReturn(*This._s_widget)
EndDeclareModule

Module Text
  ;- MACROS
  ;- PROCEDUREs
  Procedure.s Make(*This._s_widget, Text.s)
    Protected String.s, i.i, Len.i
    
    With *This
      If \Text\Numeric
        Static Dot, Minus
        Protected Chr.s, Input.i
        
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
            If Not Dot And Input = '.'
              Dot = 1
            ElseIf Input <> '.'
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-'
              Minus = 1
            ElseIf Input <> '-'
              Minus = 0
            Else
              Continue
            EndIf
            
            String.s + Chr
          EndIf
        Next
        
      ElseIf \Text\Pass
        Len = Len(Text.s) 
        For i = 1 To Len : String.s + "●" : Next
        
      Else
        Select #True
          Case \Text\Lower : String.s = LCase(Text.s)
          Case \Text\Upper : String.s = UCase(Text.s)
          Default
            String.s = Text.s
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn String.s
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
  
  Procedure.i MultiLine(*This._s_widget)
    Static Len
    Protected Repaint, String.s
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\handle
        If _this_\Style\InLine
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
        If _this_\Style\InLine
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
        ElseIf _this_\Text\Align\Horisontal
          Text_X=(Width-_this_\Items()\Text\Width-Bool(_this_\Items()\Text\Width % 2))/2 
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_(_this_)
      _this_\Items()\x = _this_\X[1]+_this_\Text\X
      _this_\Items()\Width = Width
      _this_\Items()\Text\x = _this_\Items()\x+Text_X
      
      _this_\Image\X = _this_\X[1]+_this_\Text\X+Image_X
      _this_\Image\Y = _this_\Y[1]+_this_\Text\Y+Image_Y
    EndMacro
    
    
    With *This
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2
        Height = \Width[1]-\Text\y*2
      Else
        CompilerIf Defined(Scroll, #PB_Module)
          Width = Abs(\Width[1]-\Text\X*2    -Scroll::Width(\vScroll)) ; bug in linux иногда
          Height = \Height[1]-\Text\y*2  -Scroll::Height(\hScroll)
        CompilerElse
          Width = \Width[1]-\Text\X*2  
          Height = \Height[1]-\Text\y*2 
        CompilerEndIf
      EndIf
      
      If \Text\MultiLine > 0
        String.s = Wrap(\Text\String.s, Width, \Text\MultiLine)
      Else
        String.s = \Text\String.s
      EndIf
      
      Len = 0
      
      If \Text\String.s[2] <> String.s Or \Text\Vertical
        ; Посылаем сообщение об изменении содержимого 
        If \Text\Editable And \Text\Change=-1 
          PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Change)
        EndIf
        
        \Text\String.s[2] = String.s
        \Text\Count = CountString(String.s, #LF$)
        
        \Scroll\Width = 0 
        _set_content_Y_(*This)
        
        ; 
        If ListSize(\Items()) 
          Protected Left,Right
          
          Right =- TextWidth(Mid(\Text\String.s, \Items()\Caret, \Caret))
          Left = (Width + Right)
          ; Debug " "+\Width[1] +" "+ Width +" "+ Left +" "+ Right
          
          If *This\Scroll\X < Right
            *This\Scroll\X = Right
          ElseIf *This\Scroll\X > Left
            *This\Scroll\X = Left
          ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
            *This\Scroll\X = (\Items()\Width-\Items()\Text[3]\Width) + Right
            If *This\Scroll\X>0
              *This\Scroll\X=0
            EndIf
          EndIf
          
        EndIf
        Debug *This\Scroll\X
        If \Text\Count[1] <> \Text\Count Or \Text\Vertical
          ClearList(\Items())
          \Scroll\Height = 0
          
          If \Text\Vertical
            For IT = \Text\Count To 1 Step - 1
              AddElement(\Items())
              String = StringField(\Text\String.s[2], IT, #LF$)
              
              If \Type = #PB_GadgetType_Button
                \Items()\Text\Width = TextWidth(RTrim(String))
              Else
                \Items()\Text\Width = TextWidth(String)
              EndIf
              
              If \Text\Align\Right
                Text_X=(Width-\Items()\Text\Width) 
              ElseIf \Text\Align\Horisontal
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
              
              ; Указываем какие линии будут видни
              If Not Bool(\Items()\x >\x[2] And (\Items()\x-\x[2])+\Items()\width<\width[2])
                \Items()\Hide = 1
              EndIf
              
              \Scroll\Height+\Text\Height 
            Next
          Else
            For IT = 1 To \Text\Count
              AddElement(\Items())
              String = StringField(\Text\String.s[2], IT, #LF$)
              
              ; Set line default colors             
              \Items()\Color = \Color
              \Items()\Color\State = 1
              \Items()\Color\Fore[\Items()\Color\State] = 0
              
              \Items()\Radius = \Radius
              
              If \Type = #PB_GadgetType_Button
                \Items()\Text\Width = TextWidth(RTrim(String))
              Else
                \Items()\Text\Width = TextWidth(String)
              EndIf
              
              ; Update line pos in the text
              \Items()\Caret = Len
              \Items()\Text\Len = Len(String.s)
              Len + \Items()\Text\Len + 1 ; Len(#LF$)
              
              _set_content_X_(*This)
              _line_resize_(*This)
              
              \Items()\y = \Y[1]+\Text\Y+\Scroll\Height+Text_Y
              If \Text\Count = 1
                \Items()\Height = \Text\Height
              Else
                \Items()\Height = \Text\Height - Bool(\Flag\GridLines)
              EndIf
              \Items()\Item = ListIndex(\Items())
              
              \Items()\Text\y = \Items()\y
              \Items()\Text\Height = \Text\Height
              \Items()\Text\String.s = String.s
              
              If \Line[1] = ListIndex(\Items())
                ;Debug " string "+String.s
                \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret) : \Items()\Text[1]\Change = #True
                \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
              EndIf
              
              ; Is visible lines
              \Items()\Hide = Bool( Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
              
              ; Scroll width length
              If \Scroll\Width<\Items()\Text\Width
                \Scroll\Width=\Items()\Text\Width
              EndIf
              
              ; Scroll hight length
              \Scroll\Height+\Text\Height
            Next
          EndIf
          
          \Text\Count[1] = \Text\Count
        Else
          For IT = 1 To \Text\Count
            SelectElement(\Items(), IT-1)
            String.s = StringField(\Text\String.s[2], IT, #LF$)
            
            If \Items()\Text\String.s <> String.s Or \Items()\Text\Change
              \Items()\Text\String.s = String.s
              
              If \Type = #PB_GadgetType_Button
                \Items()\Text\Width = TextWidth(RTrim(String.s))
              Else
                \Items()\Text\Width = TextWidth(String.s)
              EndIf
              
              \Items()\Text\String.s = String.s
              
              ; Scroll width length
              If \Scroll\Width<\Items()\Text\Width
                \Scroll\Width=\Items()\Text\Width
              EndIf
            EndIf
            
            ; Update line pos in the text
            \Items()\Caret = Len
            \Items()\Text\Len = Len(String.s)
            Len + \Items()\Text\Len + 1 ; Len(#LF$)
            
            ; Resize item
            If (Left And Not  Bool(\Scroll\X = Left))
              _set_content_X_(*This)
            EndIf
            
            _line_resize_(*This)
          Next
        EndIf
      Else
        _set_content_Y_(*This)
        
        PushListPosition(\Items())
        ForEach \Items()
          _set_content_X_(*This)
          _line_resize_(*This)
        Next
        PopListPosition(\Items())
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure DrawFilterCallback(X, Y, SourceColor, TargetColor)
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
  
  Procedure.i Draw(*This._s_widget, Canvas.i=-1)
    Protected String.s, StringWidth, iwidth, iheight
    Protected IT,Text_Y,Text_X,Width,Height, Drawing
    
    If Not *This\Hide
      
      With *This
        If Canvas=-1 : Canvas = EventGadget() : EndIf
        If Canvas <> \Canvas\Gadget : ProcedureReturn : EndIf
        
        Protected iX=\X[2],iY=\Y[2]
        
        If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
        _clip_output_(*This, \X[2],\Y[2],\Width[2],\Height[2])
        
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          If \Text\Change
            \Text\Height = TextHeight("A") + 1
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          MultiLine(*This)
          
          If \Text\Change : \Text\Change = 0 : EndIf
          If \Resize : \Resize = 0 : EndIf
        EndIf 
        
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
          CompilerIf Defined(Scroll, #PB_Module)
            iwidth = *This\width[2]-Scroll::Width(*This\vScroll)
            iheight = *This\height[2]-Scroll::Height(*This\hScroll)
          CompilerElse
            iwidth = *This\width[2]
            iheight = *This\height[2]
          CompilerEndIf
          
          PushListPosition(*This\Items())
          ForEach *This\Items()
            If *This\Type = #PB_GadgetType_Editor
              \Hide = Bool( Not Bool(\y+\height+*This\Scroll\Y>*This\y[2] And \y+*This\Scroll\Y<iheight))
            EndIf
            
            If Not \Hide
              If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
              _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
              
              If \Text\Change : \Text\Change = #False
                \Text\Width = TextWidth(\Text\String.s) 
                
                If \Text\FontID 
                  \Text\Height = TextHeight("A") 
                Else
                  \Text\Height = *This\Text\Height
                EndIf
              EndIf 
              
              If \Text[1]\Change : \Text[1]\Change = #False
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
              EndIf 
              
              ; Draw selections
              If \Item=*This\Line
                ; Draw items back color
                If \Color\Fore[\Color\State]
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BoxGradient(\Vertical,*This\X[2],\Y+*This\Scroll\Y,iwidth,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
                Else
                  DrawingMode(#PB_2DDrawing_Default)
                  RoundBox(*This\X[2],\Y+*This\Scroll\Y,iwidth,\Height,\Radius,\Radius,\Color\Back[\Color\State])
                EndIf
                
                DrawingMode(#PB_2DDrawing_Outlined)
                RoundBox(*This\x[2],\y+*This\Scroll\Y,iwidth,\height,\Radius,\Radius, \Color\Frame[\Color\State])
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, \Image\x, \Image\y+*This\Scroll\Y, \alpha)
              EndIf
              
              ; Draw text
              If 1;\Text\String.s
                Height = \Height
                _clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
                
                If \Text[2]\Change : \Text[2]\Change = #False 
                  \Text[2]\X = \Text[0]\X+\Text[1]\Width
                  \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
                  \Text[3]\X = \Text[2]\X+\Text[2]\Width
                EndIf 
                
                If \Text[3]\Change : \Text[3]\Change = #False 
                  \Text[3]\Width = TextWidth(\Text[3]\String.s)
                EndIf 
                ;               
                If *This\Focus = *This 
                  Protected Left,Right
                  Left =- TextWidth(Mid(*This\Text\String.s, \Caret, *This\Caret))
                  ; Left =- (\Text[1]\Width+(Bool(*This\Caret>*This\Caret[1])*\Text[2]\Width))
                  Right = (\Width + Left)
                  
                  If *This\Scroll\X < Left
                    *This\Scroll\X = Left
                  ElseIf *This\Scroll\X > Right
                    *This\Scroll\X = Right
                  ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
                    *This\Scroll\X = (\Width-\Text[3]\Width) + Left
                    If *This\Scroll\X>0
                      *This\Scroll\X=0
                    EndIf
                  EndIf
                EndIf
                
                ; Draw string
                If \Text[2]\Len > 0 And *This\Color\Front <> *This\Color\Front[2]
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                    If (*This\Caret[1] > *This\Caret And *This\Line[1] = *This\Line) Or (*This\Line[1] > *This\Line And *This\Line = \Item)
                      \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                      
                      If *This\Line[1] = *This\Line
                        \Text[2]\X = \Text[3]\X-\Text[2]\Width
                      EndIf
                      
                      If \Text[3]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawText((\Text[3]\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[3]\String.s, *This\Color\Front)
                      EndIf
                      
                      DrawingMode(#PB_2DDrawing_Default)
                      Box((\Text[2]\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                      
                      If \Text[2]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawText((\Text\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[1]\String.s+\Text[2]\String.s, *This\Color\Front[2])
                      EndIf
                      
                      If \Text[1]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawText((\Text\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[1]\String.s, *This\Color\Front)
                      EndIf
                    Else
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText((\Text\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text\String.s, *This\Color\Front)
                      
                      DrawingMode(#PB_2DDrawing_Default)
                      Box((\Text[2]\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                      
                      If \Text[2]\String.s
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawText((\Text[2]\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[2]\String.s, *This\Color\Front[2])
                      EndIf
                    EndIf
                  CompilerElse
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box((\Text[2]\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawRotatedText((\Text[2]\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[2])
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawRotatedText((\Text[3]\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                    EndIf
                  CompilerEndIf
                  
                Else
                  If \Text[2]\Len > 0
                    DrawingMode(#PB_2DDrawing_Default)
                    Box((\Text[2]\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText((\Text[0]\X+*This\Scroll\X), \Text\Y+*This\Scroll\Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
                EndIf
                
              EndIf
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            ; Debug ""+ \Text[0]\Caret +" "+ \Text[0]\Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ;And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              Line(((\Text\X+*This\Scroll\X) + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Text[0]\Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        ; Draw scroll bars
        CompilerIf Defined(Scroll, #PB_Module)
          If \vScroll\Page\Length And \vScroll\Max<>\Scroll\Height And
             Scroll::SetAttribute(\vScroll, #PB_ScrollBar_Maximum, \Scroll\Height)
            Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
          If \hScroll\Page\Length And \hScroll\Max<>\Scroll\Width And
             Scroll::SetAttribute(\hScroll, #PB_ScrollBar_Maximum, \Scroll\Width)
            Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
          
          Scroll::Draw(\vScroll)
          Scroll::Draw(\hScroll)
          
          ;           ; >>>|||
          ;           If \Scroll\Widget\Vertical\Page\Length And \Scroll\Widget\Vertical\Max<>\Scroll\Height And
          ;              Scroll::SetAttribute(\Scroll\Widget\Vertical, #PB_ScrollBar_Maximum, \Scroll\Height)
          ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horisontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          ;           
          ;           If \Scroll\Widget\Horisontal\Page\Length And \Scroll\Widget\Horisontal\Max<>\Scroll\Width And
          ;              Scroll::SetAttribute(\Scroll\Widget\Horisontal, #PB_ScrollBar_Maximum, \Scroll\Width)
          ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horisontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          ;           
          ;           Scroll::Draw(\Scroll\Widget\Vertical)
          ;           Scroll::Draw(\Scroll\Widget\Horisontal)
        CompilerEndIf
        
        _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
        
        ; Draw image
        If \Image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
        EndIf
        
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Focus = *This
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[2])
          If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[2]) : EndIf  ; Сглаживание краев )))
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[2])
        ElseIf \fSize
          Select \fSize[1] 
            Case 1 ; Flat
              RoundBox(iX-1,iY-1,iWidth+2,iHeight+2,\Radius,\Radius, $FFE1E1E1)  
              
            Case 2 ; Single
                   ;               Line(iX-1,iY-1,iWidth+2,1, $FF9E9E9E)
                   ;               Line(iX-1,iY-1,1,iHeight+2, $FF9E9E9E)
                   ;               Line(iX-1,(iY+iHeight),iWidth+2,1, $FFFFFFFF)
                   ;               Line((iX+iWidth),iY-1,1,iHeight+2, $FFFFFFFF)
              
              _frame_(*This, iX,iY,iWidth,iHeight, $FFE1E1E1, $FFFFFFFF)
              
            Case 3 ; Double
                   ;               Line(iX-2,iY-2,iWidth+4,1, $FF9E9E9E)
                   ;               Line(iX-2,iY-2,1,iHeight+4, $FF9E9E9E)
                   ;               
                   ;               Line(iX-1,iY-1,iWidth+2,1, $FF888888)
                   ;               Line(iX-1,iY-1,1,iHeight+2, $FF888888)
                   ;               Line(iX-1,(iY+iHeight),iWidth+2,1, $FFE1E1E1)
                   ;               Line((iX+iWidth),iY-1,1,iHeight+2, $FFE1E1E1)
                   ;               
                   ;               Line(iX-2,(iY+iHeight)+1,iWidth+4,1, $FFFFFFFF)
                   ;               Line((iX+iWidth)+1,iY-2,1,iHeight+4, $FFFFFFFF)
              
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FF888888, $FFFFFFFF)
              If \Radius : RoundBox(iX-1,iY-1-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-2,iY-1-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FF888888, $FFE1E1E1)
              
            Case 4 ; Raised
                   ;               Line(iX-2,iY-2,iWidth+4,1, $FFE1E1E1)
                   ;               Line(iX-2,iY-2,1,iHeight+4, $FFE1E1E1)
                   ;               
                   ;               Line(iX-1,iY-1,iWidth+2,1, $FFFFFFFF)
                   ;               Line(iX-1,iY-1,1,iHeight+2, $FFFFFFFF)
                   ;               Line(iX-1,(iY+iHeight),iWidth+2,1, $FF9E9E9E)
                   ;               Line((iX+iWidth),iY-1,1,iHeight+2, $FF9E9E9E)
                   ;               
                   ;               Line(iX-2,(iY+iHeight)+1,iWidth+4,1, $FF888888)
                   ;               Line((iX+iWidth)+1,iY-2,1,iHeight+4, $FF888888)
              
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FFE1E1E1, $FF9E9E9E)
              If \Radius : RoundBox(iX-1,iY-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-1,iY-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FFFFFFFF, $FF888888)
              
              
            Default 
              RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[\Color\State])
              
          EndSelect
        EndIf
        
        If \Default
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius, $FFF1F1FF)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius 
              RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF)
            EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText((\Width[1]-TextWidth("!!! Недопустимый символ"))/2, \Items()\Text[0]\Y, "!!! Недопустимый символ", $FF0000FF)
          Else
            ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            ;           If \Radius : RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[2]) : EndIf ; Сглаживание краев )))
            ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[2])
          EndIf
        EndIf
        
      EndWith
    EndIf
    
  EndProcedure
  
  ;-
  Procedure.i Caret(*This._s_widget, Line.i = 0)
    Static LastLine.i =- 1,  LastItem.i =- 1
    Protected Item.i, SelectionLen.i
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If Line < 0 And FirstElement(*This\Items())
        ; А если выше всех линии текста,
        ; то позиция коректора начало текста.
        Position = 0
      ElseIf Line < ListSize(*This\Items()) And 
             SelectElement(*This\Items(), Line)
        ; Если находимся на линии текста, 
        ; то получаем позицию коректора.
        
        If ListSize(\Items())
          X = (\Items()\Text\X+\Scroll\X)
          Len = \Items()\Text\Len; + Len(" ")
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s;+" "
          If Not FontID : FontID = \Text\FontID : EndIf
          
          If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
            If FontID : DrawingFont(FontID) : EndIf
            
            For i = 0 To Len
              CursorX = X + TextWidth(Left(String.s, i))
              Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
              
              ; Получаем позицию коpректора
              If MinDistance > Distance 
                MinDistance = Distance
                Position = i
              EndIf
            Next
            
            SelectionLen=Bool(Not \Flag\FullSelection)*7
            
            ; Длина переноса строки
            PushListPosition(\Items())
            If \Canvas\Mouse\Y < \Y+(\Text\Height/2+1)
              Item.i =- 1 
            Else
              Item.i = ((((\Canvas\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / (\Text\Height/2+1)) - 1)/2
            EndIf
            
            If LastLine <> \Line Or LastItem <> Item
              \Items()\Text[2]\Width[2] = 0
              
              If (\Items()\Text\String.s = "" And Item = \Line And Position = len) Or
                 \Line[1] > \Line Or ; Если выделяем снизу вверх
                 (\Line[1] =< \Line And \Line = Item And Position = len) Or ; Если позиция курсора неже половини высоты линии
                 (\Line[1] < \Line And                                      ; Если выделяем сверху вниз
                  PreviousElement(*This\Items()))                           ; то выбираем предыдущую линию
                
                If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
                  \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text\Width
                EndIf 
                
                If Not SelectionLen
                  \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                Else
                  \Items()\Text[2]\Width[2] = SelectionLen
                EndIf
              EndIf
              
              LastItem = Item
              LastLine = \Line
            EndIf
            PopListPosition(\Items())
            
            StopDrawing()
          EndIf
        EndIf
        
      ElseIf LastElement(*This\Items())
        ; Иначе, если ниже всех линии текста,
        ; то позиция коректора конец текста.
        Position = \Items()\Text\Len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure.i SelectionLimits(*This._s_widget)
    Protected i, char.i
    
    Macro _is_selection_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *This
      char = Asc(Mid(\Items()\Text\String.s, \Caret + 1, 1))
      If _is_selection_end_(char)
        \Caret + 1
        \Items()\Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Caret To 1 Step - 1
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Caret To \Items()\Text\Len
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Caret = i - 1
        \Items()\Text[2]\Len = \Caret[1] - \Caret
      EndIf
    EndWith           
  EndProcedure
  
  Procedure.i Remove(*This._s_widget)
    With *This
      If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
      \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1)
      \Text\Len = Len(\Text\String.s)
    EndWith
  EndProcedure
  
  Procedure.i ToReturn(*This._s_widget) ; Ok
    Protected Repaint, String.s
    
    With  *This
      If \Items()\Text[2]\Len > 0 And \Line[1] <> \Line
        If \Line[1] > \Line : Swap \Line[1], \Line : EndIf
        
        PushListPosition(\Items())
        ForEach \Items()
          Select ListIndex(\Items()) 
            Case \Line[1] : String.s = Left(\Text\String.s, \Items()\Caret) + \Items()\Text[1]\String.s + #LF$
            Case \Line : String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Caret+\Items()\Text\Len))
          EndSelect
        Next
        PopListPosition(\Items())
        
      Else
        String.s = Left(\Text\String.s, \Items()\Caret) + \Items()\Text[1]\String.s + #LF$ + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Caret+\Items()\Text\Len))
      EndIf
      
      \Line[1] + 1
      \Line = \Line[1]
      
      \Caret = 0
      \Caret[1] = \Caret
      
      \Text\String.s = String.s
      \Text\Len = Len(\Text\String.s)
      \Text\Change = 1
      
      ;       Scroll::SetState(\vScroll, \vScroll\Max)
      Repaint = #True
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i AddLine(*This._s_widget, Line.i, Text.s)
    Protected Result.i, String.s, i.i
    
    With *This
      If (Line > \Text\Count Or Line < 0)
        Line = \Text\Count
      EndIf
      
      For i = 0 To \Text\Count
        If Line = i
          If String.s
            String.s +#LF$+ Text
          Else
            String.s + Text
          EndIf
        EndIf
        
        If String.s
          String.s +#LF$+ StringField(\Text\String.s, i + 1, #LF$) 
        Else
          String.s + StringField(\Text\String.s, i + 1, #LF$)
        EndIf
      Next : \Text\Count = i
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        \Text\Change = 1
        Result = 1
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetText(*This._s_widget)
    With *This
      If \Text\Pass
        ProcedureReturn \Text\String.s[1]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetText(*This._s_widget, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    If Text.s="" : Text.s=#LF$ : EndIf
    
    With *This
      If \Text\String.s <> Text.s
        \Text\String.s = Make(*This, Text.s)
        
        If \Text\String.s
          \Text\String.s[1] = Text.s
          
          If \Text\MultiLine Or \Type = #PB_GadgetType_Editor 
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            Text.s + #LF$
            \Text\String.s = Text.s
           ; \Text\Count = CountString(\Text\String.s, #LF$)
          Else
            \Text\String.s = RemoveString(\Text\String.s, #LF$) + #LF$
          EndIf
          
          \Text\Len = Len(\Text\String.s)
          \Text\Change = #True
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetFont(*This._s_widget)
    ProcedureReturn *This\Text\FontID
  EndProcedure
  
  Procedure.i SetFont(*This._s_widget, FontID.i)
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
  
  Procedure.i SetColor(*This._s_widget, ColorType.i, Color.i, State.i=1)
    Protected Result, Count
    State = 0
    
    With *This
      If State = 0
        Count = 2
        \Color\State = 0
      Else
        Count = State
        \Color\State = State
      EndIf
      
      For State = \Color\State To Count
        Select ColorType
          Case #PB_Gadget_LineColor
            If \Color\Line[State] <> Color 
              \Color\Line[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_BackColor
            If \Color\Back[State] <> Color 
              \Color\Back[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrontColor
            If \Color\Front[State] <> Color 
              \Color\Front[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrameColor
            If \Color\Frame[State] <> Color 
              \Color\Frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetColor(*This._s_widget, ColorType.i, State.i=0)
    Protected Color.i
    
    With *This
      If Not State
        State = \Color\State
      EndIf
      
      Select ColorType
        Case #PB_Gadget_LineColor  : Color = \Color\Line[State]
        Case #PB_Gadget_BackColor  : Color = \Color\Back[State]
        Case #PB_Gadget_FrontColor : Color = \Color\Front[State]
        Case #PB_Gadget_FrameColor : Color = \Color\Frame[State]
      EndSelect
    EndWith
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *This
      If Canvas=-1 : Canvas = EventGadget() : EndIf
      If Canvas = \Canvas\Gadget
        \Canvas\Window = EventWindow()
      Else
        ProcedureReturn
      EndIf
      
      If X<>#PB_Ignore 
        \X[0] = X 
        \X[2]=X+\bSize
        \X[1]=\X[2]-\fSize
        \Resize = 1<<1
      EndIf
      If Y<>#PB_Ignore 
        \Y[0] = Y
        \Y[2]=Y+\bSize
        \Y[1]=\Y[2]-\fSize
        \Resize = 1<<2
      EndIf
      If Width<>#PB_Ignore 
        \Width[0] = Width 
        \Width[2] = \Width-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        \Resize = 1<<3
      EndIf
      If Height<>#PB_Ignore 
        \Height[0] = Height 
        \Height[2] = \Height-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        \Resize = 1<<4
      EndIf
      
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.i Events(*This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  EndProcedure
  
  Procedure.i CallBack(*Function, *This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    If Canvas =- 1
      With *This
        Select EventType
          Case #PB_EventType_Input 
            \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
            \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown
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
    EndIf
    
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | CallCFunctionFast(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              Result | CallFunctionFast(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
            CompilerElse
              Result | CallCFunctionFast(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
            CompilerEndIf
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      Result | CallFunctionFast(*Function, *This, EventType, Canvas, CanvasModifiers)
    CompilerElse
      Result | CallCFunctionFast(*Function, *This, EventType, Canvas, CanvasModifiers)
    CompilerEndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Widget(*This._s_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Text
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        \Radius = Radius
        \Alpha = 255
        \Line =- 1
        
        ; Set the default widget flag
        Flag|#PB_Text_MultiLine|#PB_Text_ReadOnly;|#PB_Flag_BorderLess
        
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)
        \bSize = \fSize
        
        If Resize(*This, X,Y,Width,Height, Canvas)
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine =- 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine = 1
          EndIf
          \Text\Align\Horisontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          If \Text\Vertical
            \Text\X = \fSize 
            \Text\y = \fSize+1+Bool(Flag&#PB_Text_WordWrap)*4 ; 2,6,12
          Else
            \Text\X = \fSize+1+Bool(Flag&#PB_Text_WordWrap)*4 ; 2,6,12 
            \Text\y = \fSize
          EndIf
          
          \Color = Colors
          \Color\Back = \Color\Fore
          \Color\Fore = 0
          
          If Not \bSize
            \Color\Frame = \Color\Back
          EndIf
          
          SetText(*This, Text.s)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *This._s_widget = AllocateStructure(_s_widget)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
EndModule



DeclareModule Editor
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  
  ;- - DECLAREs MACROs
  Macro Draw(_adress_, _canvas_=-1) : Text::Draw(_adress_, _canvas_) : EndMacro
  
  ;- DECLARE
  Declare GetState(Gadget.i)
  Declare.s GetText(Gadget.i)
  Declare SetState(Gadget.i, State.i)
  Declare GetAttribute(Gadget.i, Attribute.i)
  Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
  Declare SetText(Gadget, Text.s, Item.i=0)
  Declare SetFont(Gadget, FontID.i)
  Declare AddItem(Gadget,Item,Text.s,Image.i=-1,Flag.i=0)
  
  Declare.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare.i CallBack(*This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  
EndDeclareModule

Module Editor
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  Procedure ReDraw(*This._s_widget, Canvas =- 1)
    If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
      Draw(*This, Canvas)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Caret(*This._s_widget, Line.i = 0)
    ProcedureReturn Text::Caret(*This, Line)
    
    Static LastLine.i =- 1,  LastItem.i =- 1
    Protected Item.i, SelectionLen.i;=7
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If Line < 0 And FirstElement(*This\Items())
        ; А если выше всех линии текста,
        ; то позиция коректора начало текста.
        Position = 0
      ElseIf Line < ListSize(*This\Items()) And 
             SelectElement(*This\Items(), Line)
        ; Если находимся на линии текста, 
        ; то получаем позицию коректора.
        
        If ListSize(\Items())
          X = (\Items()\Text\X+\Scroll\X)
          Len = \Items()\Text\Len; + Len(" ")
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s;+" "
          If Not FontID : FontID = \Text\FontID : EndIf
          
          If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
            If FontID : DrawingFont(FontID) : EndIf
            
            For i = 0 To Len
              CursorX = X + TextWidth(Left(String.s, i))
              Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
              
              ; Получаем позицию коpректора
              If MinDistance > Distance 
                MinDistance = Distance
                Position = i
              EndIf
            Next
            
            ; Длина переноса строки
            PushListPosition(\Items())
            If \Canvas\Mouse\Y < \Y+(\Text\Height/2+1)
              Item.i =- 1 
            Else
              Item.i = ((((\Canvas\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / (\Text\Height/2+1)) - 1)/2
            EndIf
            
            If LastLine <> \Line Or LastItem <> Item
              \Items()\Text[2]\Width[2] = 0
              
              ; Если выделяем сверху вниз, 
              ; если каректор находится в конце слова, 
              ; и позиция курсора неже половини высоты линии
              If (\Line[1] < \Line And Item = \Line And Position = len)
                If Not SelectionLen
                  \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                Else
                  \Items()\Text[2]\Width[2] = SelectionLen
                EndIf
              EndIf
              
              If (\Items()\Text\String.s = "" And Item = \Line And Position = len) Or
                 \Line[1] > \Line Or ; Если выделяем снизу вверх
                 (\Line[1] = \Line And Item = \Line And Position = len) Or ; Если позиция курсора неже половини высоты линии
                 (\Line[1] < \Line And                                     ; Если выделяем сверху вниз
                  PreviousElement(*This\Items()))                          ; то выбираем предыдущую линию
                
                ;                 If \Items()\Text\String.s = ""
                ;                   \Items()\Text[2]\Len = 1
                ;                   \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text\Width
                ;                   Debug \Items()\Text[2]\Width[2] 
                ;                   \Items()\Text[2]\Width[2] = SelectionLen
                ;               ;\Items()\Text[2]\Width[2] = SelectionLen
                ;             EndIf
                ;             
                If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
                  \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text\Width
                EndIf 
                
                If Not SelectionLen
                  \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                Else
                  \Items()\Text[2]\Width[2] = SelectionLen
                EndIf
              EndIf
              
              LastItem = Item
              LastLine = \Line
            EndIf
            PopListPosition(\Items())
            
            
            StopDrawing()
          EndIf
        EndIf
        
      ElseIf LastElement(*This\Items())
        ; Иначе, если ниже всех линии текста,
        ; то позиция коректора конец текста.
        Position = \Items()\Text\Len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure SelectionText(*This._s_widget) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *This\Items()
      ;Debug "7777    "+*This\Caret +" "+ *This\Caret[1] +" "+*This\Line +" "+ *This\Line[1] +" "+ \Text\String
      
      If (Caret <> *This\Caret Or Line <> *This\Line Or (*This\Caret[1] >= 0 And Caret1 <> *This\Caret[1]))
        \Text[2]\String.s = ""
        ; Debug 8888
        PushListPosition(*This\Items())
        If *This\Line[1] = *This\Line
          If *This\Caret[1] = *This\Caret And \Text[2]\Len > 0 
            \Text[2]\Len = 0 
            \Text[2]\Width = 0 
          EndIf
          If PreviousElement(*This\Items()) And \Text[2]\Len > 0 
            \Text[2]\Width[2] = 0 
            \Text[2]\Len = 0 
          EndIf
        ElseIf *This\Line[1] > *This\Line
          If PreviousElement(*This\Items()) And \Text[2]\Len > 0 
            \Text[2]\Len = 0 
          EndIf
        Else
          If NextElement(*This\Items()) And \Text[2]\Len > 0 
            \Text[2]\Len = 0 
          EndIf
        EndIf
        PopListPosition(*This\Items())
        
        If *This\Line[1] = *This\Line
          If *This\Caret[1] = *This\Caret 
            Position = *This\Caret[1]
            ;             If *This\Caret[1] = \Text\Len
            ;              ; Debug 555
            ;             ;  \Text[2]\Len =- 1
            ;             EndIf
            ; Если выделяем с право на лево
          ElseIf *This\Caret[1] > *This\Caret 
            ; |<<<<<< to left
            Position = *This\Caret
            \Text[2]\Len = (*This\Caret[1]-Position)
          Else 
            ; >>>>>>| to right
            Position = *This\Caret[1]
            \Text[2]\Len = (*This\Caret-Position)
          EndIf
          
          ; Если выделяем снизу вверх
        ElseIf *This\Line[1] > *This\Line
          ; <<<<<|
          Position = *This\Caret
          \Text[2]\Len = \Text\Len-Position
          \Text[2]\Len | Bool(\Text\Len=Position) ; 
        Else
          ; >>>>>|
          Position = 0
          \Text[2]\Len = *This\Caret
        EndIf
        
        \Text[1]\String.s = Left(\Text\String.s, Position) : \Text[1]\Len = Len(\Text[1]\String.s) : \Text[1]\Change = #True
        If \Text[2]\Len > 0 : \Text[2]\String.s = Mid(\Text\String.s, 1+Position, \Text[2]\Len) : \Text[2]\Change = #True : EndIf
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(Position + \Text[2]\Len)) : \Text[3]\Len = Len(\Text[3]\String.s) : \Text[3]\Change = #True
        
        Line = *This\Line
        Caret = *This\Caret
        Caret1 = *This\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure SelectionReset(*This._s_widget)
    With *This
      PushListPosition(\Items())
      ForEach \Items() 
        If \Items()\Text[2]\Len <> 0
          \Items()\Text[2]\Len = 0 
          \Items()\Text[2]\Width[2] = 0 
          \Items()\Text[1]\String = ""
          \Items()\Text[2]\String = "" 
          \Items()\Text[3]\String = ""
          \Items()\Text[2]\Width = 0 
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  
  ;-
  Procedure RemoveText(*This._s_widget)
    ;ProcedureReturn
    
    With *This\Items()
      ;Debug *This\Line
      ;*This\Caret = 0
      If *This\Caret > *This\Caret[1] : *This\Caret = *This\Caret[1] : EndIf
      ; Debug "  "+*This\Caret +" "+ *This\Caret[1]
      ;\Text\String.s = RemoveString(\Text\String.s, Trim(\Text[2]\String.s, #LF$), #PB_String_CaseSensitive, 0, 1) ; *This\Caret
      \Text\String.s = RemoveString(\Text\String.s, \Text[2]\String.s, #PB_String_CaseSensitive, 0, 1) ; *This\Caret
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, 0, 1) ; *This\Caret
      \Text[2]\String.s[1] = \Text[2]\String.s
      \Text\Len = Len(\Text\String.s)
      \Text[2]\String.s = ""
      \Text[2]\Len = 0
    EndWith
  EndProcedure
  
  Procedure Remove(*This._s_widget)
    Protected Caret
    
    With *This
      PushListPosition(\Items())
      FirstElement(\Items()) ; LastElement(\Items()) ; 
      While NextElement(\Items()) ; PreviousElement(\Items())  ; 
        
        If \Items()\Text[2]\Len = \Items()\Text\Len
          \Items()\Caret - Caret
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Caret, 1)
          Caret + \Items()\Caret
          *This\Line - 1
          
        ElseIf \Items()\Text[2]\Len > 0
          Debug " get "+\Items()\Text\String.s+" "+\Items()\Text[2]\String.s
          ; If \Caret < \Caret[1] : \Caret = \Caret[1] : EndIf
          
          If \Caret[1] < \Caret
            If \Items()\Text[2]\Width[2]
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Caret+\Caret[1], 1) 
              ;             \Caret = \Items()\Text\Len - \Items()\Text[2]\Len
              ;             \Caret[1] = \Caret
            Else
              \Items()\Caret - Caret
              Debug \Items()\Caret
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret, 1) 
              *This\Line - 1
            EndIf
          EndIf
          Caret = \Items()\Text[2]\Len
        EndIf
      Wend
      PopListPosition(\Items())
      
      ;       \Text\Len = Len(\Text\String.s)
      ; 
      ;         If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
      ;       \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1)
      \Text\Len = Len(\Text\String.s)
      \Text\Change = 1
      
      Debug \Text\String.s
    EndWith
    
    ProcedureReturn 1
  EndProcedure
  Procedure _Remove(*This._s_widget)
    Protected Caret
    
    With *This
      PushListPosition(\Items())
      FirstElement(\Items()) ; LastElement(\Items()) ; 
      While NextElement(\Items()) ; PreviousElement(\Items())  ; 
        
        If \Items()\Text[2]\Len = \Items()\Text\Len
          \Items()\Caret - Caret
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Caret, 1)
          Caret + \Items()\Caret
          *This\Line - 1
        ElseIf \Items()\Text[2]\Len > 0
          Debug " get "+\Items()\Text\String.s+" "+\Items()\Text[2]\String.s
          ; If \Caret < \Caret[1] : \Caret = \Caret[1] : EndIf
          
          If \Caret[1] > \Caret
            If \Items()\Text[2]\Width[2]
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1) 
              ;             \Caret = \Items()\Text\Len - \Items()\Text[2]\Len
              ;             \Caret[1] = \Caret
              Caret = \Items()\Text[2]\Len
            Else
              \Items()\Caret - Caret
              Debug \Items()\Caret
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret, 1) 
              *This\Line - 1
            EndIf
          EndIf
        EndIf
      Wend
      PopListPosition(\Items())
      
      ;       \Text\Len = Len(\Text\String.s)
      ; 
      ;         If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
      ;       \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1)
      \Text\Len = Len(\Text\String.s)
      \Text\Change = 1
      
      Debug \Text\String.s
    EndWith
    
    ProcedureReturn 1
  EndProcedure
  
  
  
  Procedure Cut(*This._s_widget)
    Protected String.s
    ;;;ProcedureReturn Remove(*This)
    
    With *This\Items()
      If ListSize(*This\Items()) 
        ;If \Text[2]\Len > 0
        If *This\Line[1] = *This\Line
          Debug "Cut Black"
          If \Text[2]\Len > 0
            RemoveText(*This)
          Else
            \Text[2]\String.s[1] = Mid(\Text\String.s, *This\Caret, 1)
            \Text\String.s = Left(\Text\String.s, *This\Caret - 1) + Right(\Text\String.s, \Text\Len-*This\Caret)
            \Text\String.s[1] = Left(\Text\String.s[1], *This\Caret - 1) + Right(\Text\String.s[1], Len(\Text\String.s[1])-*This\Caret)
            *This\Caret - 1 
          EndIf
        Else
          Debug " Cut " +*This\Caret +" "+ *This\Caret[1]+" "+\Text[2]\Len
          
          If \Text[2]\Len > 0
            ;If *This\Line > *This\Line[1] 
            RemoveText(*This)
            ;EndIf
            
            If \Text[2]\Len = \Text\Len
              SelectElement(*This\Items(), *This\Line)
            EndIf
          EndIf
          
          ; Выделили сверх вниз
          If *This\Line > *This\Line[1] 
            Debug "  Cut_1_ForEach"
            
            PushListPosition(*This\Items())
            ForEach *This\Items() 
              If \Text[2]\Len > 0
                If \Text[2]\Len = \Text\Len
                  DeleteElement(*This\Items(), 1) 
                Else
                  RemoveText(*This)
                EndIf
              EndIf
            Next
            PopListPosition(*This\Items())
            
            *This\Caret = *This\Caret[1]
            ; Выделили снизу верх 
          ElseIf *This\Line[1] > *This\Line 
            *This\Line[1] = *This\Line 
            
            *This\Caret[1] = *This\Caret  ; Выделили пос = 0 фикс = 1
            
            ;             Debug "  Cut_21_ForEach"
            ;               
            ;             PushListPosition(*This\Items())
            ;             ForEach *This\Items() 
            ;               If \Text[2]\Len > 0
            ;                 If \Text[2]\Len = \Text\Len
            ;                   DeleteElement(*This\Items(), 1) 
            ;                 Else
            ;                   RemoveText(*This)
            ;                 EndIf
            ;               EndIf
            ;             Next
            ;             PopListPosition(*This\Items())
            
          EndIf
          
          
          If *This\Line[1]>=0 And *This\Line[1]<ListSize(*This\Items())
            ;If *This\Line > *This\Line[1]
            String.s = \Text\String.s
            DeleteElement(*This\Items(), 1)
            ;EndIf
            SelectElement(*This\Items(), *This\Line[1])
            
            If Not *This\Caret
              *This\Caret = \Text\Len-Len(#LF$)
            EndIf
            
            ; Выделили сверху вниз
            If *This\Line > *This\Line[1]
              *This\Line = *This\Line[1]
              *This\Caret = *This\Caret[1] ; Выделили пос = 0 фикс = 0
              \Text\String.s = String.s + \Text\String.s 
            Else
              ;;*This\Caret[1] = *This\Caret  ; Выделили пос = 0 фикс = 1
              \Text\String.s = \Text\String.s + String.s 
            EndIf
            
            \Text\Len = Len(\Text\String.s)
          EndIf
          
          PushListPosition(*This\Items())
          ForEach *This\Items()
            If \Text[2]\Len > 0 
              Debug "  Cut_2_ForEach"
              If \Text[2]\Len = \Text\Len
                DeleteElement(*This\Items(), 1) 
              Else
                RemoveText(*This)
              EndIf
            EndIf
          Next
          PopListPosition(*This\Items())
          
        EndIf
        ;EndIf  
      EndIf
    EndWith
  EndProcedure
  
  Procedure.s Copy(*This._s_widget)
    Protected String.s
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Text[2]\Len > 0 
          String.s+\Items()\Text[2]\String.s+#LF$
        EndIf
      Next
      PopListPosition(\Items())
      
      String.s = Trim(String.s, #LF$)
      
      ; Для совместимости с виндовсовским 
      If String.s And Not *This\Caret
        String.s+#LF$+#CR$
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  
  ;-
  Procedure ToUp(*This._s_widget)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Line[1] > 0 And \Line = \Line[1]) : \Line[1] - 1 : \Line = \Line[1]
        SelectElement(\Items(), \Line[1])
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDown(*This._s_widget)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Line < ListSize(\Items()) - 1 And \Line = \Line[1]) : \Line[1] + 1 : \Line = \Line[1]
        SelectElement(\Items(), \Line[1]) 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToLeft(*This._s_widget) ; Ok
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Line[1] > \Line 
          Swap \Line[1], \Line
          
          If SelectElement(\Items(), \Line[1]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Line > \Line[1] And 
               \Caret[1] > \Caret
          Swap \Caret[1], \Caret
        ElseIf \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf
        
        If \Line <> \Line[1]
          SelectionReset(*This)
          \Line = \Line[1]
          Repaint =- 1
        EndIf
      ElseIf \Caret[1] > 0 
        \Caret - 1 
      EndIf
      
      If \Caret[1] <> \Caret
        \Caret[1] = \Caret 
        Repaint =- 1 
      ElseIf Not Repaint And ToUp(*This._s_widget)
        \Caret = \Items()\Text\Len
        \Caret[1] = \Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToRight(*This._s_widget) ; Ok
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Line > \Line[1] 
          Swap \Line, \Line[1] 
          Swap \Caret, \Caret[1]
          
          If SelectElement(\Items(), \Line[1]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Line[1] = \Line And 
               \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf
        
        If \Line <> \Line[1]
          SelectionReset(*This)
          \Line = \Line[1]
          Repaint =- 1
        EndIf
      ElseIf \Caret[1] < \Items()\Text\Len 
        \Caret[1] + 1 
      EndIf
      
      If \Caret <> \Caret[1]
        \Caret = \Caret[1] 
        Repaint =- 1 
      ElseIf Not Repaint And ToDown(*This)
        \Caret[1] = 0
        \Caret = \Caret[1]
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToInput(*This._s_widget)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, Chr.s
    
    With *This
      If \Canvas\Input
        Chr.s = Text::Make(*This, Chr(\Canvas\Input))
        
        If Chr.s
          If \Items()\Text[2]\Len 
            If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
            \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1)
          EndIf
          
          \Caret + 1
          \Items()\Text\String.s = \Items()\Text[1]\String.s + Chr(\Canvas\Input) + \Items()\Text[3]\String.s
          \Text\String.s = InsertString(\Text\String.s, Chr.s, \Items()\Caret+\Caret)
          \Text\Len = Len(\Text\String.s) 
          \Caret[1] = \Caret 
          \Text\Change =- 1
        Else
          \Default = *This
        EndIf
        
        \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(\Canvas\Input), \Items()\Caret+\Caret)
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToBack(*This._s_widget)
    Protected Repaint, String.s 
    
    If *This\Canvas\Input : *This\Canvas\Input = 0
      ;ToInput(*This) ; Сбросить Dot&Minus
    EndIf
    
    With *This
      If \Items()\Text[2]\Len
        If \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf  
        Remove(*This)
        
      ElseIf \Caret[1] > 0 
        Debug " "+ListIndex(\Items())+" "+\Items()\Caret+" "+\Items()\Text\String.s; 
        \Text\String.s[1] = Left(\Text\String.s[1], \Items()\Caret+\Caret - 1) + Mid(\Text\String.s[1],  \Items()\Caret+\Caret + 1)
        \Text\String.s = Left(\Text\String.s, \Items()\Caret+\Caret - 1) + Mid(\Text\String.s,  \Items()\Caret+\Caret + 1)
        \Caret - 1 
        \Text\Change =- 1
      Else
        ; Если дошли до начала строки то 
        ; переходим в конец предыдущего итема
        If *This\Line[1] > 0 
          \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1)
          
          ToUp(*This)
          
          *This\Caret = \Items()\Text\Len 
          \Text\Change =- 1
        EndIf
        
      EndIf
      
      If \Text\Change
        \Text\Len = Len(\Text\String.s)  
        \Caret[1] = \Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDelete(*This._s_widget)
    Protected Repaint, String.s
    
    With *This\Items()
      If *This\Caret < \Text\Len
        If \Text[2]\String.s
          RemoveText(*This)
        Else
          \Text[2]\String.s[1] = Mid(\Text\String.s, (*This\Caret+1), 1)
          \Text\String.s = Left(\Text\String.s, *This\Caret) + Right(\Text\String.s, \Text\Len-(*This\Caret+1))
          \Text\String.s[1] = Left(\Text\String.s[1], *This\Caret) + Right(\Text\String.s[1], Len(\Text\String.s[1])-(*This\Caret+1))
        EndIf
        
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items() 
            If \Text[2]\Len = \Text\Len
              DeleteElement(*This\Items(), 1)
            EndIf
          Next
          PopListPosition(*This\Items())
          
          If *This\Caret = Len(\Text\String.s) : *This\Line[1]+1
            If *This\Line[1]>=0 And *This\Line[1]<ListSize(*This\Items())
              PushListPosition(*This\Items())
              SelectElement(*This\Items(), *This\Line[1])
              String.s = \Text\String.s
              DeleteElement(*This\Items(), 1)
              PopListPosition(*This\Items())
              \Text\String.s + String.s 
              *This\Line[1] - 1
            EndIf
          EndIf
        EndIf
        
        *This\Caret[1] = *This\Caret
        \Text\Len = Len(\Text\String.s)
        
        Repaint = #True
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToReturn(*This._s_widget) ; Ok
    Protected Repaint, String.s
    
    With  *This
      If \Items()\Text[2]\Len > 0
        If \Line[1] > \Line : Swap \Line[1], \Line : EndIf
        
        If \Line = \Line[1] 
          String.s = Left(\Text\String.s, \Items()\Caret) + \Items()\Text[1]\String.s + #LF$ + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Caret+\Items()\Text\Len))
        Else    
          PushListPosition(\Items())
          ForEach \Items()
            Select ListIndex(\Items()) 
              Case \Line[1] : String.s = Left(\Text\String.s, \Items()\Caret) + \Items()\Text[1]\String.s + #LF$
              Case \Line : String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Caret+\Items()\Text\Len))
            EndSelect
          Next
          PopListPosition(\Items())
        EndIf
      Else
        If \Items()\Text[1]\String.s And \Items()\Text[3]\String.s
          ; курсор в нутри слова
          String.s = \Items()\Text[1]\String.s + #LF$ + \Items()\Text[3]\String.s
        ElseIf \Items()\Text[3]\String.s
          ; курсор в начале слова
          String.s = #LF$ + \Items()\Text[3]\String.s
        ElseIf \Items()\Text[1]\String.s
          ; курсор в конце слова
          String.s = \Items()\Text[1]\String.s + #LF$
        Else
          ; курсор на линии где нету слово
          String.s = #LF$
        EndIf
        String.s = Left(\Text\String.s, \Items()\Caret) + String.s + Right(\Text\String.s, \Text\Len-(\Items()\Caret+\Items()\Text\Len))
      EndIf
      
      \Line[1] + 1
      \Line = \Line[1]
      
      \Caret = 0
      \Caret[1] = \Caret
      
      \Text\String.s = String.s
      \Text\Len = Len(\Text\String.s)
      \Text\Change = 1
      
      ;       Scroll::SetState(\vScroll, \vScroll\Max)
      Repaint = #True
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- PUBLIC
  Procedure SetAttribute(Gadget.i, Attribute.i, Value.i)
    Protected *This._s_widget = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.i, Attribute.i)
    Protected Result, *This._s_widget = GetGadgetData(Gadget)
    
    With *This
      ;       Select Attribute
      ;         Case #PB_ScrollBar_Minimum    : Result = \Scroll\Min
      ;         Case #PB_ScrollBar_Maximum    : Result = \Scroll\Max
      ;         Case #PB_ScrollBar_PageLength : Result = \Scroll\PageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.i, State.i)
    Protected *This._s_widget = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected ScrollPos, *This._s_widget = GetGadgetData(Gadget)
    
    With *This
      
    EndWith
  EndProcedure
  
  Procedure ClearItems(Gadget.i)
    Protected Result.i, *This._s_widget
    If IsGadget(Gadget) : *This._s_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        Result = ClearList(\Items())
        If StartDrawing(CanvasOutput(Gadget))
          Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
          StopDrawing()
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i CountItems(Gadget.i, Item.i=-1)
    Protected Result.i, *This._s_widget, sublevel.i
    If IsGadget(Gadget) : *This._s_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        If Item.i=-1
          Result = ListSize(\Items())
        Else
          PushListPosition(\Items()) 
          ForEach \Items()
            If \Items()\Item = Item 
              ; Result = \Items()\childrens 
              sublevel = \Items()\sublevel
              PushListPosition(\Items())
              While NextElement(\Items())
                If sublevel = \Items()\sublevel
                  Break
                ElseIf sublevel < \Items()\sublevel 
                  Result+1
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
  
  Procedure.i RemoveItem(Gadget.i, Item.i)
    Protected Result.i, *This._s_widget, sublevel.i
    If IsGadget(Gadget) : *This._s_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            sublevel = \Items()\sublevel
            PushListPosition(\Items())
            While NextElement(\Items())
              If sublevel = \Items()\sublevel
                Break
              ElseIf sublevel < \Items()\sublevel 
                Result = DeleteElement(\Items()) 
              EndIf
            Wend
            PopListPosition(\Items())
            Result = DeleteElement(\Items()) 
            Break
          EndIf
        Next
        PopListPosition(\Items())
        
        ReDraw(Gadget)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure AddLine(Gadget.i,Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static adress.i, Len
    Protected *This._s_widget, Childrens.i, hide.b, *Item, sublevel.i, Image_Y, Image_X, Text_X, Text_Y, Height, Width, Indent = 4
    If IsGadget(Gadget) : *This._s_widget = GetGadgetData(Gadget) : EndIf
    ;Item=0
    If Not *This
      ProcedureReturn -1
    EndIf
    
    Macro _set_content_Y_(_this_)
      If _this_\Image\handle
        If _this_\Style\InLine
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
        If _this_\Style\InLine
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
        ElseIf _this_\Text\Align\Horisontal
          Text_X=(Width-_this_\Items()\Text\Width-Bool(_this_\Items()\Text\Width % 2))/2 
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_(_this_)
      _this_\Items()\x = _this_\X[1]+_this_\Text\X
      _this_\Items()\Width = Width
      _this_\Items()\Text\x = _this_\Items()\x+Text_X
      
      _this_\Image\X = _this_\X[1]+_this_\Text\X+Image_X
      _this_\Image\Y = _this_\Y[1]+_this_\Text\Y+Image_Y
    EndMacro
    
    With *This
      Width = \Width[1]-\Text\X*2  
      Height = \Height[1]-\Text\y*2 
      
      ;{ Генерируем идентификатор
      If Item =- 1 Or Item > ListSize(\Items()) - 1
        LastElement(\Items())
        AddElement(\Items()) 
        Item = ListIndex(\Items())
        *Item = @\Items()
      Else
        SelectElement(\Items(), Item)
        If \Items()\sublevel>sublevel
          sublevel=\Items()\sublevel 
        EndIf
        *Item = @\Items()
        InsertElement(\Items())
        
        PushListPosition(\Items())
        While NextElement(\Items())
          \Items()\Item = ListIndex(\Items())
        Wend
        PopListPosition(\Items())
      EndIf
      ;}
      AddElement(\Items())
      Protected String.s = Text;StringField(\Text\String.s[2], IT, #LF$)
      
      ; Set line default colors             
      \Items()\Color = \Color
      \Items()\Color\State = 1
      \Items()\Color\Fore[\Items()\Color\State] = 0
      
      \Items()\Radius = \Radius
      
; ;       If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
; ;         If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
; ;         If \Type = #PB_GadgetType_Button
; ;           \Items()\Text\Width = TextWidth(RTrim(String))
; ;         Else
; ;           \Items()\Text\Width = TextWidth(String)
; ;         EndIf
; ;         StopDrawing()
; ;       EndIf
      \Items()\Text\Change = 1
      
      ; Update line pos in the text
      \Items()\Caret = Len
      \Items()\Text\Len = Len(String.s)
      Len + \Items()\Text\Len + 1 ; Len(#LF$)
      
      _set_content_X_(*This)
      _line_resize_(*This)
      
      \Items()\y = \Y[1]+\Text\Y+\Scroll\Height+Text_Y
      If \Text\Count = 1
        \Items()\Height = \Text\Height
      Else
        \Items()\Height = \Text\Height - Bool(\Flag\GridLines)
      EndIf
      \Items()\Item = ListIndex(\Items())
      
      \Items()\Text\y = \Items()\y
      \Items()\Text\Height = \Text\Height
      \Items()\Text\String.s = String.s
      
      If \Line[1] = ListIndex(\Items())
        ;Debug " string "+String.s
        \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Caret) : \Items()\Text[1]\Change = #True
        \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
      EndIf
      
      ; Is visible lines
      \Items()\Hide = Bool( Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
      
      ; Scroll width length
      If \Scroll\Width<\Items()\Text\Width
        \Scroll\Width=\Items()\Text\Width
      EndIf
      
      ; Scroll hight length
      \Scroll\Height+\Text\Height
      
      \Text\String.s = String.s +#LF$+ \Text\String.s
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure.i AddItem(Gadget, Item, Text.s,Image.i=-1,Flag.i=0)
    Protected *This._s_widget = GetGadgetData(Gadget)
    Protected Result.i, String.s, i.i
    Static Len
    
    With *This
      If (Item > \Text\Count Or Item < 0)
        Item = \Text\Count
      EndIf
      
      If Item = \Text\Count
        
        If Item     
          String.s = StringField(\Text\String.s, item, #LF$)+#LF$ : i = Len(String.s) : Len + i
          \Text\String.s = InsertString(\Text\String.s, #LF$ + Text.s, len )
          \Text\Len + i
        Else
          String.s = Text.s +#LF$
          \Text\String.s = String.s + \Text\String.s
          \Text\Len + Len(String.s)
        EndIf
        
        \Text\Count + 1
        
        ; AddLine(Gadget,Item,Text.s,Image,Flag)
      Else 
        Text::AddLine(*This, Item, Text.s) 
      EndIf
      
      ;         ; \Text\Change = 1
      ;         Result = 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure.s GetText(Gadget.i)
    Protected *This._s_widget = GetGadgetData(Gadget)
    ProcedureReturn Text::GetText(*This)
  EndProcedure
  
  Procedure.i SetText(Gadget, Text.s, Item.i=0)
    Protected *This._s_widget = GetGadgetData(Gadget)
    
    If Text::SetText(*This, Text.s) 
      ReDraw(*This, *This\Canvas\Gadget)
      ProcedureReturn 1
    EndIf
    
  EndProcedure
  
  Procedure.i SetFont(Gadget.i, FontID.i)
    Protected *This._s_widget = GetGadgetData(Gadget)
    
    If Text::SetFont(*This, FontID)
      ReDraw(*This, *This\Canvas\Gadget)
      ProcedureReturn 1
    EndIf
    
  EndProcedure
  
  Procedure.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *This
      If Text::Resize(*This, X,Y,Width,Height)
        Scroll::Resizes(\vScroll, \hScroll, \x[2],\Y[2],\Width[2],\Height[2])
      EndIf
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  ;-
  Procedure.i Events(*This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static *Focus._s_widget, *Last._s_widget, *Widget._s_widget
    Static Text$, DoubleClick, LastX, LastY, Last, Drag
    Protected.i Repaint, Control, Buttons, Widget
    
    ; widget_events_type
    If *This
      With *This
        If Canvas=-1 
          Widget = *This
          Canvas = EventGadget()
        Else
          Widget = Canvas
        EndIf
        If Canvas <> \Canvas\Gadget Or 
           \Type <> #PB_GadgetType_Editor
        EndIf
        
        ; Get at point widget
        \Canvas\Mouse\From = From(*This)
        
        Select EventType 
          Case #PB_EventType_LeftButtonUp 
            If *Last = *This
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick 
            ; Debug ""+\Canvas\Mouse\Buttons+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
            If *Last = *This : *Last = *Widget
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
            If Not *This\Canvas\Mouse\From 
              ProcedureReturn 0
            EndIf
        EndSelect
        
        If Not \Hide And Not \Disable And \Interact And Widget <> Canvas And CanvasModifiers 
          Select EventType 
            Case #PB_EventType_Focus : ProcedureReturn 0 ; Bug in mac os because it is sent after the mouse left down
            Case #PB_EventType_MouseMove, #PB_EventType_LeftButtonUp
              If Not \Canvas\Mouse\Buttons 
                If \Canvas\Mouse\From
                  If *Last <> *This 
                    If *Last
                      If (*Last\Index > *This\Index)
                        ProcedureReturn 0
                      Else
                        ; Если с нижнего виджета перешли на верхный, 
                        ; то посылаем событие выход для нижнего
                        Events(*Last, #PB_EventType_MouseLeave, Canvas, 0)
                        *Last = *This
                      EndIf
                    Else
                      *Last = *This
                    EndIf
                    
                    EventType = #PB_EventType_MouseEnter
                    *Widget = *Last
                  EndIf
                  
                ElseIf (*Last = *This)
                  If EventType = #PB_EventType_LeftButtonUp 
                    Events(*Widget, #PB_EventType_LeftButtonUp, Canvas, 0)
                  EndIf
                  
                  EventType = #PB_EventType_MouseLeave
                  *Last = *Widget
                  *Widget = 0
                EndIf
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              If (*Last = *This)
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Focus = List()\Widget And List()\Widget <> *This 
                    
                    List()\Widget\Focus = 0
                    *Last = List()\Widget
                    Events(List()\Widget, #PB_EventType_LostFocus, List()\Widget\Canvas\Gadget, 0)
                    *Last = *Widget 
                    
                    PostEvent(#PB_Event_Gadget, List()\Widget\Canvas\Window, List()\Widget\Canvas\Gadget, #PB_EventType_Repaint)
                    Break 
                  EndIf
                Next
                PopListPosition(List())
                
                If *This <> \Focus : \Focus = *This : *Focus = *This
                  Events(*This, #PB_EventType_Focus, Canvas, 0)
                EndIf
              EndIf
              
          EndSelect
        EndIf
        
        If (*Last = *This) 
          Select EventType
            Case #PB_EventType_LeftButtonDown
              If Not \Canvas\Mouse\Delta
                \Canvas\Mouse\Delta = AllocateStructure(_s_mouse)
                \Canvas\Mouse\Delta\X = \Canvas\Mouse\X
                \Canvas\Mouse\Delta\Y = \Canvas\Mouse\Y
                \Canvas\Mouse\Delta\From = \Canvas\Mouse\From
                \Canvas\Mouse\Delta\Buttons = \Canvas\Mouse\Buttons
              EndIf
              
            Case #PB_EventType_LeftButtonUp : \Drag = 0
              FreeStructure(\Canvas\Mouse\Delta) : \Canvas\Mouse\Delta = 0
              
            Case #PB_EventType_MouseMove
              If \Drag = 0 And \Canvas\Mouse\Buttons And \Canvas\Mouse\Delta And 
                 (Abs((\Canvas\Mouse\X-\Canvas\Mouse\Delta\X)+(\Canvas\Mouse\Y-\Canvas\Mouse\Delta\Y)) >= 6) : \Drag=1
                ; PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_DragStart)
              EndIf
              
            Case #PB_EventType_MouseLeave
              If CanvasModifiers 
                ; Если перешли на другой виджет
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Canvas\Gadget = Canvas And List()\Widget\Focus <> List()\Widget And List()\Widget <> *This
                    List()\Widget\Canvas\Mouse\From = From(List()\Widget)
                    
                    If List()\Widget\Canvas\Mouse\From
                      If *Last
                        Events(*Last, #PB_EventType_MouseLeave, Canvas, 0)
                      EndIf     
                      
                      *Last = List()\Widget
                      *Widget = List()\Widget
                      ProcedureReturn Events(*Last, #PB_EventType_MouseEnter, Canvas, 0)
                    EndIf
                  EndIf
                Next
                PopListPosition(List())
              EndIf
              
              If \Cursor[1] <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
                SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor[1])
                \Cursor[1] = 0
              EndIf
              
            Case #PB_EventType_MouseEnter    
              If Not \Cursor[1] 
                \Cursor[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
              EndIf
              SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
              
            Case #PB_EventType_MouseMove ; bug mac os
              If \Canvas\Mouse\Buttons And #PB_Compiler_OS = #PB_OS_MacOS ; And \Cursor <> GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor)
                                                                          ; Debug 555
                SetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Cursor, \Cursor)
              EndIf
              
          EndSelect
        EndIf 
        
      EndWith
    EndIf
    
    ;     If (*Last = *This)
    ;       Select EventType
    ;         Case #PB_EventType_Focus          : Debug "  "+Bool((*Last = *This))+" Focus"          +" "+ *This\Text\String.s
    ;         Case #PB_EventType_LostFocus      : Debug "  "+Bool((*Last = *This))+" LostFocus"      +" "+ *This\Text\String.s
    ;         Case #PB_EventType_MouseEnter     : Debug "  "+Bool((*Last = *This))+" MouseEnter"     +" "+ *This\Text\String.s ;+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
    ;         Case #PB_EventType_MouseLeave     : Debug "  "+Bool((*Last = *This))+" MouseLeave"     +" "+ *This\Text\String.s
    ;         Case #PB_EventType_LeftButtonDown : Debug "  "+Bool((*Last = *This))+" LeftButtonDown" +" "+ *This\Text\String.s ;+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
    ;         Case #PB_EventType_LeftButtonUp   : Debug "  "+Bool((*Last = *This))+" LeftButtonUp"   +" "+ *This\Text\String.s
    ;         Case #PB_EventType_LeftClick      : Debug "  "+Bool((*Last = *This))+" LeftClick"      +" "+ *This\Text\String.s
    ;       EndSelect
    ;     EndIf
    
    Protected Caret,Item.i, String.s
    
    If ListSize(*This\items())
      With *This
        If *Last = *This
          If Not \Hide And Not \Disable And \Interact ; And Widget <> Canvas And CanvasModifiers
                                                      ; Get line & caret position
            If \Canvas\Mouse\Buttons
              If \Canvas\Mouse\Y < \Y
                Item.i =- 1
              Else
                Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
              EndIf
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftButtonDown
                SelectionReset(*This)
                
                If \Items()\Text[2]\Len > 0
                  \Text[2]\Len = 1
                Else
                  \Caret = Caret(*This, Item) 
                  \Line = ListIndex(*This\Items()) 
                  \Line[1] = Item
                  
                  PushListPosition(\Items())
                  ForEach \Items() 
                    If \Line[1] <> ListIndex(\Items())
                      \Items()\Text[1]\String = ""
                      \Items()\Text[2]\String = ""
                      \Items()\Text[3]\String = ""
                    EndIf
                  Next
                  PopListPosition(\Items())
                  
                  \Caret[1] = \Caret
                  
                  If \Caret = DoubleClick
                    DoubleClick =- 1
                    \Caret[1] = \Items()\Text\Len
                    \Caret = 0
                  EndIf 
                  
                  SelectionText(*This)
                  Repaint = #True
                  
                  
                EndIf
                
              Case #PB_EventType_LeftButtonUp
                ;               If \Caret = \Caret[1] ; And \Line = \Line[1] 
                ; ;                 If Not \Drag
                ;                   ; Сбрасываем все виделения.
                ;                   PushListPosition(\Items())
                ;                   ForEach \Items() 
                ;                     If \Items()\Text[2]\Len <> 0
                ;                       \Items()\Text[2]\Len = 0 
                ;                     EndIf
                ;                   Next
                ;                   PopListPosition(\Items())
                ;                   Repaint = 1
                ; ;                 EndIf
                ;                   \Text[2]\Len = 0
                \Drag = 0
                ;               EndIf
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton 
                  
                  If Not \Text[2]\Len
                    If \Line <> Item And Item =< ListSize(\Items())
                      If isItem(\Line, \Items()) 
                        If \Line <> ListIndex(\Items())
                          SelectElement(\Items(), \Line) 
                        EndIf
                        
                        If \Line > Item
                          \Caret = 0
                        Else
                          \Caret = \Items()\Text\Len
                        EndIf
                        
                        SelectionText(*This)
                      EndIf
                      
                      \Line = Item
                    EndIf
                    
                    If isItem(Item, \Items()) 
                      \Caret = Caret(*This, Item) 
                      SelectionText(*This)
                    EndIf
                  EndIf
                  
                  Repaint = #True
                EndIf
                
              Case #PB_EventType_LeftDoubleClick 
                DoubleClick = \Caret
                Text::SelectionLimits(*This)
                SelectionText(*This) 
                Repaint = #True
                
                \Caret = Caret(*This, \Line[1]) 
                
              Case #PB_EventType_MouseEnter
                ; Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Items()\Text[1]\Width +" "+ \Items()\Text[1]\String.s
                ClearDebugOutput()
                Debug \Text\String.s
                
              Case #PB_EventType_LostFocus : Repaint = #True
                If Bool(\Type <> #PB_GadgetType_Editor)
                  ; StringGadget
                  \Items()\Text[2]\Len = 0 ; Убыраем выделение
                EndIf
                \Caret[1] =- 1 ; Прячем коректор
                
              Case #PB_EventType_Focus : Repaint = #True
                \Caret[1] = \Caret ; Показываем коректор
                
              Default
                itemSelect(\Line[1], \Items())
            EndSelect
          EndIf
        EndIf
      EndWith    
      
      With *This\items()
        If *Focus = *This And (*This\Text\Editable Or \Text\Editable)
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
          CompilerElse
            Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
          CompilerEndIf
          
          Select EventType
            Case #PB_EventType_Input ;- Input (key)
              If Not Control
                Repaint = ToInput(*This)
              EndIf
              
            Case #PB_EventType_KeyUp
              If \Text\Numeric
                \Text\String.s[1]=\Text\String.s 
              EndIf
              Repaint = #True 
              
            Case #PB_EventType_KeyDown
              Select *This\Canvas\Key
                Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Caret = 0 : *This\Caret[1] = *This\Caret : Repaint =- 1
                Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Caret = \Text\Len : *This\Caret[1] = *This\Caret : Repaint =- 1 
                  
                Case #PB_Shortcut_Up     : Repaint = ToUp(*This)      ; Ok
                Case #PB_Shortcut_Left   : Repaint = ToLeft(*This)    ; Ok
                Case #PB_Shortcut_Right  : Repaint = ToRight(*This)   ; Ok
                Case #PB_Shortcut_Down   : Repaint = ToDown(*This)    ; Ok
                Case #PB_Shortcut_Back   : Repaint = ToBack(*This)
                Case #PB_Shortcut_Return : Repaint = Text::ToReturn(*This) 
                Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
                  
                  
                Case #PB_Shortcut_C, #PB_Shortcut_X
                  If ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command)) 
                    SetClipboardText(Copy(*This))
                    
                    If *This\Canvas\Key = #PB_Shortcut_X
                      Cut(*This)
                      
                      *This\Caret[1] = *This\Caret
                      Repaint = #True 
                    EndIf
                  EndIf
                  
                Case #PB_Shortcut_V
                  If *This\Text\Editable And ((*This\Canvas\Key[1] & #PB_Canvas_Control) Or (*This\Canvas\Key[1] & #PB_Canvas_Command))
                    Protected ClipboardText.s = Trim(GetClipboardText(), #CR$)
                    
                    If ClipboardText.s
                      If \Text[2]\Len > 0
                        RemoveText(*This)
                        
                        If \Text[2]\Len = \Text\Len
                          ;*This\Line[1] = *This\Line
                          ClipboardText.s = Trim(ClipboardText.s, #LF$)
                        EndIf
                        ;                         
                        PushListPosition(*This\Items())
                        ForEach *This\Items()
                          If \Text[2]\Len > 0 
                            If \Text[2]\Len = \Text\Len
                              DeleteElement(*This\Items(), 1) 
                            Else
                              RemoveText(*This)
                            EndIf
                          EndIf
                        Next
                        PopListPosition(*This\Items())
                      EndIf
                      
                      Select #True
                        Case \Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                        Case \Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                        Case \Text\Numeric 
                          If Val(ClipboardText.s)
                            ClipboardText.s = Str(Val(ClipboardText.s))
                          EndIf
                      EndSelect
                      
                      \Text\String.s = InsertString( \Text\String.s, ClipboardText.s, *This\Caret + 1)
                      
                      If CountString(\Text\String.s, #LF$)
                        Caret = \Text\Len-*This\Caret
                        String.s = \Text\String.s
                        DeleteElement(*This\Items(), 1)
                        SetText(*This\Canvas\Gadget, String.s, *This\Line[1])
                        *This\Caret = Len(\Text\String.s)-Caret
                        ;                         SelectElement(*This\Items(), *This\Line)
                        ;                        *This\Caret = 0
                      Else
                        *This\Caret + Len(ClipboardText.s)
                      EndIf
                      
                      *This\Caret[1] = *This\Caret
                      \Text\Len = Len(\Text\String.s)
                      
                      Repaint = #True
                    EndIf
                  EndIf
                  
              EndSelect 
              
          EndSelect
        EndIf
        
        If Repaint
          ;\Text[3]\Change = Bool(Repaint =- 1)
          If Repaint =- 1
            SelectionText(*This) 
          EndIf
          
          If Repaint = 2
            *This\Text[0]\Change = Repaint
            \Text[1]\Change = Repaint
            \Text[2]\Change = Repaint
            \Text[3]\Change = Repaint
          EndIf
          ; *This\CaretLength = \CaretLength
          *This\Text[2]\String.s[1] = \Text[2]\String.s[1]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Protected Repaint
    
    With *This
      Repaint | Scroll::CallBack(\vScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0)
      If Repaint
        \Scroll\Y =- \vScroll\Page\Pos
      EndIf
      Repaint | Scroll::CallBack(\hScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0)
      If Repaint
        \Scroll\X =- \hScroll\Page\Pos
      EndIf
      
      If Not \vScroll\Buttons And Not \hScroll\Buttons
        Repaint | Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Widget(*This._s_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        
        \Type = #PB_GadgetType_Editor
        \Cursor = #PB_Cursor_IBeam
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        \Radius = Radius
        \Alpha = 255
        \Interact = 1
        \Caret[1] =- 1
        \Line =- 1
        
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
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)+1
        \bSize = \fSize
        
        If Text::Resize(*This, X,Y,Width,Height, Canvas)
          \Flag\NoButtons = Bool(flag&#PB_Flag_NoButtons)
          \Flag\NoLines = Bool(flag&#PB_Flag_NoLines)
          \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
          \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
          \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)
          \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
          
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
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
          
          \Text\Align\Horisontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+5
            Else
              \Text\X = \fSize+5
              \Text\y = \fSize
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+1
            Else
              \Text\X = \fSize+1
              \Text\y = \fSize
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+6
            Else
              \Text\X = \fSize+6
              \Text\y = \fSize
            EndIf
          CompilerEndIf 
          
          If \Text\Pass
            Protected i,Len = Len(Text.s)
            Text.s = "" : For i=0 To Len : Text.s + "●" : Next
          EndIf
          
          Select #True
            Case \Text\Lower : \Text\String.s = LCase(Text.s)
            Case \Text\Upper : \Text\String.s = UCase(Text.s)
            Default
              \Text\String.s = Text.s
          EndSelect
          \Text\Change = #True
          \Text\Len = Len(\Text\String.s)
          
          \Color = Colors
          \Color\Fore[0] = 0
          ;\Color\Back[1] = \Color\Back[0]
          
          If \Text\Editable
            \Color[0]\Back[0] = $FFFFFFFF 
          Else
            \Color[0]\Back[0] = $FFF0F0F0  
          EndIf
          
        EndIf
        
        Scroll::Widget(\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        If Bool(\flag\NoButtons = 0 Or \flag\NoLines=0)
          Scroll::Widget(\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *This._s_widget = AllocateStructure(_s_widget)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  
  Procedure CallBacks()
    Static LastX, LastY
    Protected Repaint, *This._s_widget = GetGadgetData(EventGadget())
    
    With *This
      \Canvas\Window = EventWindow()
      \Canvas\Input = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Input)
      \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
      \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
      \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
      
      Select EventType()
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
    Protected *This._s_widget = AllocateStructure(_s_widget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        
        SetGadgetData(Gadget, *This)
        ReDraw(*This)
        
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Gadget, #PB_EventType_Resize)
        BindGadgetEvent(Gadget, @CallBacks())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
  
  Procedure ResizeCallBack()
    ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    CompilerIf #PB_Compiler_Version =< 546
      PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
    CompilerEndIf
  EndProcedure
  
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s) 
    For a = 0 To 2
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    AddGadgetItem(0, a, "")
    For a = 4 To 6
      AddGadgetItem(0, a, "Line "+Str(a))
    Next
    SetGadgetFont(0, FontID(0))
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 133, #PB_Text_WordWrap|#PB_Flag_GridLines) ; |#PB_Flag_Numeric
    
    Editor::SetText(g, Text.s) 
    For a = 0 To 2
      Editor::AddItem(g, a, "Line "+Str(a))
    Next
    Editor::AddItem(g, a, "")
    For a = 4 To 6
      Editor::AddItem(g, a, "Line "+Str(a))
    Next
    Editor::SetFont(g, FontID(0))
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E._s_widget = GetGadgetData(g)
                
                *E\Text\MultiLine !- 1
                If  *E\Text\MultiLine = 1
                  SetGadgetText(100,"~wrap")
                Else
                  SetGadgetText(100,"wrap")
                EndIf
                
                CompilerSelect #PB_Compiler_OS
                  CompilerCase #PB_OS_Linux
                    If  *E\Text\MultiLine = 1
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_WORD)
                    Else
                      gtk_text_view_set_wrap_mode_(GadgetID(0), #GTK_WRAP_NONE)
                    EndIf
                    
                  CompilerCase #PB_OS_MacOS
                    
                    If  *E\Text\MultiLine = 1
                      EditorGadget(0, 8, 8, 306, 133, #PB_Editor_WordWrap)
                    Else
                      EditorGadget(0, 8, 8, 306, 133) 
                    EndIf
                    
                    SetGadgetText(0, Text.s) 
                    For a = 0 To 5
                      AddGadgetItem(0, a, "Line "+Str(a))
                    Next
                    SetGadgetFont(0, FontID(0))
                    
                    SplitterGadget(10,8, 8, 306, 276, 0,g)
                    
                    CompilerIf #PB_Compiler_Version =< 546
                      BindGadgetEvent(10, @SplitterCallBack())
                    CompilerEndIf
                    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug
                    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
                    
                    ; ;                     ImportC ""
                    ; ;                       GetControlProperty(Control, PropertyCreator, PropertyTag, BufferSize, *ActualSize, *PropertyBuffer)
                    ; ;                       TXNSetTXNObjectControls(TXNObject, ClearAll, ControlCount, ControlTags, ControlData)
                    ; ;                     EndImport
                    ; ;                     
                    ; ;                     Define TXNObject.i
                    ; ;                     Dim ControlTag.i(0)
                    ; ;                     Dim ControlData.i(0)
                    ; ;                     
                    ; ;                     ControlTag(0) = 'wwrs' ; kTXNWordWrapStateTag
                    ; ;                     ControlData(0) = 0     ; kTXNAutoWrap
                    ; ;                     
                    ; ;                     If GetControlProperty(GadgetID(0), 'PURE', 'TXOB', 4, 0, @TXNObject) = 0
                    ; ;                       TXNSetTXNObjectControls(TXNObject, #False, 1, @ControlTag(0), @ControlData(0))
                    ; ;                     EndIf
                  CompilerCase #PB_OS_Windows
                    SendMessage_(GadgetID(0), #EM_SETTARGETDEVICE, 0, 0)
                CompilerEndSelect
                
                
            EndSelect
          EndIf
          
        Case #PB_Event_LeftClick  
          SetActiveGadget(0)
        Case #PB_Event_RightClick 
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------------------0f-f----------------------------
; EnableXP
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = +--Pz--z-------------------------f0------------------------------------------------------------------------
; EnableXP