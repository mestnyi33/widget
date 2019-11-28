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
    #PB_Flag_Single
    
    #PB_Flag_Default
    #PB_Flag_Toggle
    
    #PB_Flag_GridLines
    #PB_Flag_Invisible
  EndEnumeration
  
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
  
  Structure Coordinate_S
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
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
    Horisontal.b
  EndStructure
  
  Structure Page_S
    Pos.i
    Length.i
    ScrollStep.i
  EndStructure
  
  Structure Canvas_S
    Mouse.Mouse_S
    Gadget.i
    Window.i
    
    Input.c
    Key.i[2]
  EndStructure
  
  Structure Color_S
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
  
  Structure Image_S Extends Coordinate_S
    handle.i[2]
    change.b
    Align.Align_S
  EndStructure
  
  Structure Text_S Extends Coordinate_S
    ;     Char.c
    Len.i
    FontID.i
    String.s[3]
    Count.i[2]
    Change.b
    
    Align.Align_S
    
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
  
  Structure Scroll_S Extends Coordinate_S
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
    Page.Page_S
    Area.Page_S
    Thumb.Page_S
    Button.Page_S
    Color.Color_S[4]
  EndStructure
  
  Structure S_S
    Vertical.Scroll_S
    Horisontal.Scroll_S
  EndStructure
  
  Structure Scrolls_S Extends Coordinate_S
    *Widget.S_S
  EndStructure
  
  Structure Flag_S
    FullSelection.b
    AlwaysSelection.b
    NoButtons.b
    NoLines.b
    CheckBoxes.b
    GridLines.b
  EndStructure
  
  Structure Widget_S Extends Coordinate_S
    Index.i  ; Index of new list element
    Handle.i ; Adress of new list element
             ;
    
    *Widget.Widget_S
    Canvas.Canvas_S
    Style.Style_S
    Color.Color_S[4]
    Text.Text_S[4]
    Clip.Coordinate_S
    
    Scroll.Scrolls_S
    vScroll.Scroll_S
    hScroll.Scroll_S
    
    Image.Image_S
    box.Coordinate_S
    Flag.Flag_S
    
    
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
    
    List Items.Widget_S()
    List Columns.Widget_S()
    
  EndStructure
  
  ; $FF24B002 ; $FFD5A719 ; $FFE89C3D ; $FFDE9541 ; $FFFADBB3 ;
  Global Colors.Color_S
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
  
  Global *Focus.Widget_S
  Global NewList List.Widget_S()
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
  
  
  Declare.b Draw(*Scroll.Scroll_S)
  Declare.i Y(*Scroll.Scroll_S)
  Declare.i X(*Scroll.Scroll_S)
  Declare.i Width(*Scroll.Scroll_S)
  Declare.i Height(*Scroll.Scroll_S)
  Declare.b SetState(*Scroll.Scroll_S, ScrollPos.i)
  Declare.i SetAttribute(*Scroll.Scroll_S, Attribute.i, Value.i)
  Declare.i SetColor(*Scroll.Scroll_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.b Resize(*This.Scroll_S, iX.i,iY.i,iWidth.i,iHeight.i, *Scroll.Scroll_S=#Null)
  Declare.b Resizes(*v.Scroll_S, *h.Scroll_S, X.i,Y.i,Width.i,Height.i)
  Declare.b Updates(*v.Scroll_S, *h.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*This.Scroll_S, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0, AutoHide.b=0, *Scroll.Scroll_S=#Null, Window=-1, Gadget=-1)
  Declare.i Widget(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  
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
  
  Procedure.i Pos(*This.Scroll_S, ThumbPos.i)
    Protected ScrollPos.i
    
    With *This
      ScrollPos = Match(\Min + Round((ThumbPos - \Area\Pos) / (\Area\Length / (\Max-\Min)), #PB_Round_Nearest), \Page\ScrollStep)
      If (\Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Max-\Min)-ScrollPos) : EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.b Draw(*Scroll.Scroll_S)
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
  
  Procedure.i X(*Scroll.Scroll_S)
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
  
  Procedure.i Y(*Scroll.Scroll_S)
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
  
  Procedure.i Width(*Scroll.Scroll_S)
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
  
  Procedure.i Height(*Scroll.Scroll_S)
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
  
  Procedure.b SetState(*Scroll.Scroll_S, ScrollPos.i)
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
  
  Procedure.i SetAttribute(*Scroll.Scroll_S, Attribute.i, Value.i)
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
  
  Procedure.i SetColor(*Scroll.Scroll_S, ColorType.i, Color.i, State.i=0, Item.i=0)
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
  
  Procedure.b Resize(*This.Scroll_S, X.i,Y.i,Width.i,Height.i, *Scroll.Scroll_S=#Null)
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
  
  Procedure.b Updates(*v.Scroll_S, *h.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
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
  
  Procedure.b Resizes(*v.Scroll_S, *h.Scroll_S, X.i,Y.i,Width.i,Height.i )
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
  
  Procedure.b CallBack(*This.Scroll_S, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0, AutoHide.b=0, *Scroll.Scroll_S=#Null, Window=-1, Gadget=-1)
    Protected Result, Buttons
    Static LastX, LastY, Last, *Thisis.Scroll_S, Cursor, Drag, Down
    
    If *This
      If EventType = #PB_EventType_LeftButtonDown
        ;  Debug "CallBack(*This.Scroll_S)"
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
  
  Procedure.i Widget(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
    
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
  Declare.i Draw(*ThisWidget_S, Canvas.i=-1)
  Declare.s Make(*This.Widget_S, Text.s)
  Declare.i MultiLine(*This.Widget_S)
  Declare.i SelectionLimits(*This.Widget_S)
  Declare.s GetText(*This.Widget_S)
  Declare.i SetText(*This.Widget_S, Text.s)
  Declare.i GetFont(*This.Widget_S)
  Declare.i SetFont(*This.Widget_S, FontID.i)
  Declare.i AddLine(*This.Widget_S, Line.i, Text.s)
  Declare.i GetColor(*This.Widget_S, ColorType.i, State.i=0)
  Declare.i SetColor(*This.Widget_S, ColorType.i, Color.i, State.i=1)
  Declare.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  Declare.i CallBack(*Function, *This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  ;Declare.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  
  Declare.i Caret(*This.Widget_S, Line.i = 0)
  Declare.i Remove(*This.Widget_S)
  Declare.i ToReturn(*This.Widget_S)
EndDeclareModule

Module Text
  ;- MACROS
  ;- PROCEDUREs
  Procedure.s Make(*This.Widget_S, Text.s)
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
  
  Procedure.i MultiLine(*This.Widget_S)
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
  
  Procedure.i Draw(*This.Widget_S, Canvas.i=-1)
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
  Procedure.i Caret(*This.Widget_S, Line.i = 0)
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
  
  Procedure.i SelectionLimits(*This.Widget_S)
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
  
  Procedure.i Remove(*This.Widget_S)
    With *This
      If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
      \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Caret+\Caret, 1)
      \Text\Len = Len(\Text\String.s)
    EndWith
  EndProcedure
  
  Procedure.i ToReturn(*This.Widget_S) ; Ok
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
  
  Procedure.i AddLine(*This.Widget_S, Line.i, Text.s)
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
  
  Procedure.s GetText(*This.Widget_S)
    With *This
      If \Text\Pass
        ProcedureReturn \Text\String.s[1]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetText(*This.Widget_S, Text.s)
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
  
  Procedure.i GetFont(*This.Widget_S)
    ProcedureReturn *This\Text\FontID
  EndProcedure
  
  Procedure.i SetFont(*This.Widget_S, FontID.i)
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
  
  Procedure.i SetColor(*This.Widget_S, ColorType.i, Color.i, State.i=1)
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
  
  Procedure.i GetColor(*This.Widget_S, ColorType.i, State.i=0)
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
  
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
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
  
  Procedure.i Events(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  EndProcedure
  
  Procedure.i CallBack(*Function, *This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
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
  
  Procedure Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
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
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
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



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile =99
  UseModule Text
  Global *T_0.Widget_S = AllocateStructure(Widget_S)
  Global *T_1.Widget_S = AllocateStructure(Widget_S)
  Global *T_2.Widget_S = AllocateStructure(Widget_S)
  Global *T_3.Widget_S = AllocateStructure(Widget_S)
  Global *T_4.Widget_S = AllocateStructure(Widget_S)
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Resize
        Result = 1
    EndSelect
    
    If Result
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height)
        Draw(*T_0, Canvas)
        Draw(*T_1, Canvas)
        Draw(*T_2, Canvas)
        Draw(*T_3, Canvas)
        Draw(*T_4, Canvas)
        StopDrawing()
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure Events()
    Debug "Left click "+EventGadget()+" "+EventType()
  EndProcedure
  
  LoadFont(0, "Courier", 14)
  
  If OpenWindow(0, 0, 0, 270, 160, "Text on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(0,  0, 0, 270, 160, #PB_Canvas_Keyboard)
    
    Widget(*T_0, 0, 10,  10, 250, 20, "TextGadget Standard (Left)")
    Widget(*T_1, 0, 10,  70, 250, 20, "TextGadget Center", #PB_Text_Center)
    Widget(*T_2, 0, 10,  40, 250, 20, "TextGadget Right", #PB_Text_Right)
    Widget(*T_3, 0, 10, 100, 250, 20, "TextGadget Border", #PB_Text_Border)
    Widget(*T_4, 0, 10, 130, 250, 20, "TextGadget Center + Border", #PB_Text_Center | #PB_Text_Border)
    
    BindEvent(#PB_Event_Widget, @Events())
    
    BindGadgetEvent(0, @CallBacks())
    PostEvent(#PB_Event_Gadget, 0,0, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Text
  Global *Text.Widget_S = AllocateStructure(Widget_S)
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  
  Procedure Canvas_CallBack()
    Select EventType()
      Case #PB_EventType_Resize : ResizeGadget(EventGadget(), #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        If StartDrawing(CanvasOutput(EventGadget()))
          DrawingMode(#PB_2DDrawing_Default)
          Box(0,0,OutputWidth(),OutputHeight(), $FFF0F0F0)
          
          ForEach List()
            If Resize(List()\Widget, #PB_Ignore, #PB_Ignore, GadgetWidth(EventGadget()), #PB_Ignore);, EventGadget())
              Draw(List()\Widget)
              ; Draw(*Text, EventGadget())
            EndIf
          Next
          StopDrawing()
        EndIf
        
    EndSelect
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    ResizeGadget(16, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    SetWindowTitle(0, Str(WindowWidth(EventWindow(), #PB_Window_FrameCoordinate)-20)+" - Text on the canvas")
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 18)
  CompilerElse
    LoadFont(0, "Arial", 16)
  CompilerEndIf 
  
  Text.s = "строка_1"+Chr(10)+
  "строка__2"+Chr(10)+
  "строка___3 эта длиняя строка оказалась ну, очень длиной, поэтому будем его переносить"+Chr(10)+
  "строка_4"+#CRLF$+
  "строка__5";+#CRLF$
             ; Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget"
             ; Debug "len - "+Len(Text)
  
  If OpenWindow(0, 0, 0, 290, 760, "CanvasGadget", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(16, 10, 10, 200, 140*4+30, #PB_Canvas_Keyboard)
    BindGadgetEvent(16, @Canvas_CallBack())
    
    *B_0 = Create(16, -1, 0, 0, 200, 140, Text, #PB_Text_Center)
    *B_1 = Create(16, -1, 0, 150, 200, 140, Text, #PB_Text_Middle)
    *B_2 = Create(16, -1, 0, 300, 200, 140, Text, #PB_Text_Middle|#PB_Text_Right)
    *B_3 = Create(16, -1, 0, 450, 200, 140, Text, #PB_Text_Center|#PB_Text_Bottom)
    
    TextGadget(0, 10, 610, 200, 140, Text, #PB_Text_Border|#PB_Text_Center)
    ;   EditorGadget(4, 10, 220, 200, 200) : AddGadgetItem(10, -1, Text)
    ;SetGadgetFont(0,FontID)
    
    ResizeCallBack()
    ; ResizeWindow(0,WindowX(0)-180,#PB_Ignore,#PB_Ignore,#PB_Ignore)
    BindEvent(#PB_Event_SizeWindow,@ResizeCallBack(),0)
    
    Repeat
      Define Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
  EndIf
  
  If OpenWindow(0, 0, 0, 104, 690, "Text on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ClearList(List())
    
    ;EditorGadget(0, 10, 10, 380, 330, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s)
    TextGadget(0, 10, 10, 380, 330, Text.s) 
    ;ButtonGadget(0, 10, 10, 380, 330, Text.s) 
    
    g=16
    CanvasGadget(g, 10, 350, 380, 330) 
    
    *Text = Create(g, -1, 0, 0, 380, 330, Text.s);, #PB_Text_Center|#PB_Text_Middle);
    SetColor(*Text, #PB_Gadget_BackColor, $FFCCBFB4)
    SetColor(*Text, #PB_Gadget_FrontColor, $FFD56F1A)
    SetFont(*Text, FontID(0))
    
    ; Get example
    SetGadgetFont(0, GetFont(*Text))
    SetGadgetColor(0, #PB_Gadget_BackColor, GetColor(*Text, #PB_Gadget_BackColor))
    SetGadgetColor(0, #PB_Gadget_FrontColor, GetColor(*Text, #PB_Gadget_FrontColor))
    
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore)
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    BindGadgetEvent(g, @Canvas_CallBack())
    PostEvent(#PB_Event_Gadget, 0,g, #PB_EventType_Resize) ; 
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --------------------------------------------------------------------
; EnableXP