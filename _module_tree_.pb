
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
  
  Macro _set_scroll_width_(_this_)
    If Not _this_\hide And Not _this_\items()\hide And _this_\Scroll\width<(_this_\items()\text\x+_this_\items()\text\width)-_this_\x
      _this_\scroll\width=(_this_\items()\text\x+_this_\items()\text\width)-_this_\x
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
    Horizontal.b
  EndStructure
  
  Structure Page_S
    Pos.i
    Length.i
    ScrollStep.i
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
  
  Structure Scrolls_S Extends Coordinate_S
    Orientation.b
    *Vertical.Scroll_S
    *Horizontal.Scroll_S
  EndStructure
  
  Structure Canvas_S
    Mouse.Mouse_S
    Gadget.i
    Window.i
    Widget.i
    
    Input.c
    Key.i[2]
  EndStructure
  
  Structure Widget_S Extends Coordinate_S
    Index.i  ; Index of new list element
    Handle.i ; Adress of new list element
             ;
    
    *Widget.Widget_S
    Canvas.Canvas_S
    Color.Color_S[4]
    Text.Text_S[4]
    Clip.Coordinate_S
    *ToolTip.Text_S
    
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
    adress.i[2]
    
    *Default
    Alpha.a[2]
    
    DrawingMode.i
    
    List Items.Widget_S()
    List Columns.Widget_S()
    ;ColumnWidth.i
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
  
  
  Declare.b Draw(*Scroll.Scroll_S)
; ;   Declare.i Y(*Scroll.Scroll_S)
; ;   Declare.i X(*Scroll.Scroll_S)
; ;   Declare.i Width(*Scroll.Scroll_S)
; ;   Declare.i Height(*Scroll.Scroll_S)
  Declare.b SetState(*Scroll.Scroll_S, ScrollPos.i)
  Declare.i SetAttribute(*Scroll.Scroll_S, Attribute.i, Value.i)
  Declare.i SetColor(*Scroll.Scroll_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.b Resize(*This.Scroll_S, iX.i,iY.i,iWidth.i,iHeight.i, *Scroll.Scroll_S=#Null)
  Declare.b Resizes(*v.Scroll_S, *h.Scroll_S, X.i,Y.i,Width.i,Height.i)
  Declare.b Updates(*v.Scroll_S, *h.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*This.Scroll_S, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0, AutoHide.b=0, *Scroll.Scroll_S=#Null, Window=-1, Gadget=-1)
  Declare.i Widget(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
EndDeclareModule

Module Scroll
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
      ScrollPos = Match(\Min + Round((ThumbPos - \Area\Pos) / (\Area\Length / (\Max-\Min)), #PB_Round_Nearest), \Page\ScrollStep) : If (\Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Max-\Min)-ScrollPos) : EndIf
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
  
; ;   Procedure.i X(*Scroll.Scroll_S)
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
; ;   Procedure.i Y(*Scroll.Scroll_S)
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
  
; ;   Procedure.i Width(*Scroll.Scroll_S)
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
; ;   Procedure.i Height(*Scroll.Scroll_S)
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
  
  Procedure.b Resizes(*v.Scroll_S, *h.Scroll_S, X.i,Y.i,Width.i,Height.i)
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
      \X =- 1
      \Y =- 1
        
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
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, PageLength.i, Flag.i, Radius.i=0)
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, x, y, Width, Height, Min, Max, PageLength, Flag, Radius)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
EndModule

DeclareModule Text
  
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
  
  ;- - DECLAREs PROCEDUREs
  Declare.i Draw(*ThisWidget_S)
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
  Declare.i ReDraw(*This.Widget_S, Canvas =- 1, BackColor=$FFF0F0F0)

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
      If \Text\Numeric And Text.s <> #LF$
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
            If \Type = #PB_GadgetType_IPAddress
              left.s = Left(\Text\String, \Caret)
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\Text\String, \Caret+1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
;               ElseIf Mid(\Text\String, \Caret + 1, 1) = "."
;                 \Caret + 1 : \Caret[1]=\Caret
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\Text\String, \Caret + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\Text\String, \Caret + 1, 1) <> "-"
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
  
  Macro _set_scroll_height_(_this_)
    If Not _this_\Items()\Hide
      _this_\Scroll\Height+_this_\Text\Height
    EndIf
  EndMacro
  
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
  
  Procedure AddLine(*This.Widget_S,Line.i,String.s) ;,Image.i=-1,Sublevel.i=0)
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
          Width = Abs(\Width[1]-\Text\X*2    -Scroll::Width(\vScroll)) ; bug in linux иногда
          Height = \Height[1]-\Text\y*2      -Scroll::Height(\hScroll)
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
  
  Procedure.i MultiLine(*This.Widget_S)
    Protected Repaint, String.s, text_width
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
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
              If (Left And Not  Bool(\Scroll\X = Left))
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
  
  Procedure.i Draw(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    
    Protected line_size = *This\Flag\Lines
    Protected box_size = *This\Flag\Buttons
    Protected check_box_size = *This\Flag\CheckBoxes
    
    If Not *This\Hide
      
      With *This
        iX=\X[2]
        iY=\Y[2]
        CompilerIf Defined(Scroll, #PB_Module)
          iwidth = *This\width[2]-Scroll::Width(*This\vScroll)
          iheight = *This\height[2]-Scroll::Height(*This\hScroll)
        CompilerElse
          iwidth = *This\width[2]
          iheight = *This\height[2]
        CompilerEndIf
        
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          If \Resize
;             Debug "   resize "+\Resize
;             ; Посылаем сообщение об изменении размера 
            ;PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Resize, *This)
            ;PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Resize, \Resize)
          EndIf
          If \Text\Change
            \Text\Height[1] = TextHeight("A") + Bool(\Text\Count<>1 And \Flag\GridLines)
            If \Type = #PB_GadgetType_Tree
              \Text\Height = 20
            Else
              \Text\Height = \Text\Height[1]
            EndIf
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          Text::MultiLine(*This)
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
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
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
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X
            Text_Y = \Text\Y+*This\Scroll\Y
            
            ; expanded & collapsed box
            If *This\Flag\Buttons Or *This\Flag\Lines 
              \box\width = box_size
              \box\height = box_size
              \box\x = *This\x+\sublevellen-(\box\width)/2+*This\Scroll\X
              \box\y = (Y+height)-(height+\box\height)/2
            EndIf
            
            If *This\Flag\CheckBoxes
              \box\width[1] = check_box_size
              \box\height[1] = check_box_size
              \box\x[1] = *This\x+(\box\width[1])/2+*This\Scroll\X
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
            If *This\sublevellen And *This\Flag\Lines 
              Protected x_point=*This\x+\sublevellen+*This\Scroll\X
              
              If x_point>*This\x[2] 
                Protected y_point=\box\y+\box\height/2
                
                If Drawing
                  ; Horizontal plot
                  DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotX())
                  Line(x_point,y_point,line_size,1, $FF000000)
                EndIf
                
                ; Vertical plot
                If \address
                  Protected start = \sublevel
                  
                  ; это нужно если линия уходит за предели границы виджета
                  If \address[1]
                    PushListPosition(*This\Items())
                    ChangeCurrentElement(*This\Items(), \address[1]) 
                    ;If \Hide : Drawing = 2 : EndIf
                    PopListPosition(*This\Items())
                  EndIf
                  
                  PushListPosition(*This\Items())
                  ChangeCurrentElement(*This\Items(), \address) 
                  If Drawing  
                    If start
                      If *This\sublevellen > 10
                        start = (\y+\height+\height/2) + *This\Scroll\Y - line_size
                      Else
                        start = (\y+\height/2) + *This\Scroll\Y
                      EndIf
                    Else 
                      start = (*This\y[2]+\height/2)+*This\Scroll\Y
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotY())
                    Line(x_point,start,1, (y_point-start), $FF000000)
                  EndIf
                  PopListPosition(*This\Items())
                EndIf
              EndIf
            EndIf
            
            If Drawing
              ; Draw boxes
              If *This\Flag\Buttons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                CompilerIf Defined(Scroll, #PB_Module)
                  Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, \Color\Front[\Color\State], 0,0) 
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
                DrawAlphaImage(\Image\handle, \Image\x+*This\Scroll\X, \Image\y+*This\Scroll\Y, \alpha)
              EndIf
              
              ; Draw text
              _clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
              
              ; Draw string
              If \Text[2]\Len > 0 And *This\Color\Front <> *This\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Caret[1] > *This\Caret And *This\Line[1] = *This\Line) Or (*This\Line[1] > *This\Line And *This\Line = \Item)
                    \Text[3]\X = Text_X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                    
                    If *This\Line[1] = *This\Line
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[3]\X, Text_Y, \Text[3]\String.s, *This\Color\Front)
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s, *This\Color\Front)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText(Text_X, Text_Y, \Text\String.s, *This\Color\Front)
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[2]\X, Text_Y, \Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[2])
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                CompilerEndIf
                
              Else
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
              
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            ; Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ;And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              If Bool(Not \Text[1]\Width Or *This\Caret > *This\Caret[1])
                Line((\Text\X+*This\Scroll\X) + \Text[1]\Width + \Text[2]\Width - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              Else
                Line((\Text\X+*This\Scroll\X) + \Text[1]\Width - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              EndIf
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(*This\Items())
          ; Draw scroll bars
          CompilerIf Defined(Scroll, #PB_Module)
            UnclipOutput()
            
            If \vScroll\Page\Length And \vScroll\Max<>\Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines) And
               Scroll::SetAttribute(\vScroll, #PB_ScrollBar_Maximum, \Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines))
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            If \hScroll\Page\Length And \hScroll\Max<>\Scroll\Width And
               Scroll::SetAttribute(\hScroll, #PB_ScrollBar_Maximum, \Scroll\Width)
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            
            Scroll::Draw(\vScroll)
            Scroll::Draw(\hScroll)
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
          Select \fSize[1] 
            Case 1 ; Flat
              RoundBox(iX-1,iY-1,iWidth+2,iHeight+2,\Radius,\Radius, $FFE1E1E1)  
              
            Case 2 ; Single
               _frame_(*This, iX,iY,iWidth,iHeight, $FFE1E1E1, $FFFFFFFF)
              
            Case 3 ; Double
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FF888888, $FFFFFFFF)
              If \Radius : RoundBox(iX-1,iY-1-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-2,iY-1-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FF888888, $FFE1E1E1)
              
            Case 4 ; Raised
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FFE1E1E1, $FF9E9E9E)
              If \Radius : RoundBox(iX-1,iY-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-1,iY-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FFFFFFFF, $FF888888)
              
            Default 
              RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[\Color\State])
              
          EndSelect
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
  
  Procedure.i ReDraw(*This.Widget_S, Canvas =- 1, BackColor=$FFF0F0F0)
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
    Else
      If IsGadget(Canvas) And StartDrawing(CanvasOutput(Canvas))
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,0,OutputWidth(),OutputHeight(), BackColor)
        
        With List()\Widget
          ForEach List()
            If Canvas = \Canvas\Gadget
              Draw(List()\Widget)
            EndIf
          Next
        EndWith
        
        StopDrawing()
      EndIf
    EndIf
  EndProcedure
  
  ;- - SET&GET
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
      \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1)
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
            Case \Line[1] : String.s = Left(\Text\String.s, \Items()\Text\Position) + \Items()\Text[1]\String.s + #LF$
            Case \Line : String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Position+\Items()\Text\Len))
          EndSelect
        Next
        PopListPosition(\Items())
        
      Else
        String.s = Left(\Text\String.s, \Items()\Text\Position) + \Items()\Text[1]\String.s + #LF$ + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Position+\Items()\Text\Len))
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
    ; If Text.s="" : Text.s=#LF$ : EndIf
    
    With *This
      If \Text\String.s <> Text.s
        \Text\String.s = Make(*This, Text.s)
        
        If \Text\String.s
          \Text\String.s[1] = Text.s
          
          If \Text\MultiLine Or \Type = #PB_GadgetType_Editor  Or \Type = #PB_GadgetType_ListView Or \Type = #PB_GadgetType_Scintilla 
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
      If Canvas <> \Canvas\Gadget
        ProcedureReturn
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
        \Width[2] = \Width[0]-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        \Resize = 1<<3
      EndIf
      If Height<>#PB_Ignore And 
         \Height[0] <> Height
        \Height[0] = Height 
        \Height[2] = \Height[0]-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        \Resize = 1<<4
      EndIf
      
      If \Resize
        ; Debug "   resize "+\Resize
        ; ReDraw(*This, \Canvas\Gadget, $FFF0F0F0)
        ; PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Resize, \Resize)
        ; PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint, *This)
      EndIf
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.i Events(*Function, *This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static *Last.Widget_S, *Widget.Widget_S    ; *Focus.Widget_S, 
    Static Text$, DoubleClick, LastX, LastY, Last, Drag
    Protected.i Result, Repaint, Control, Buttons, Widget
    
    ; widget_events_type
    If *This
      With *This
        If Canvas=-1 
          Widget = *This
          Canvas = EventGadget()
        Else
          Widget = Canvas
        EndIf
;         If Canvas <> \Canvas\Gadget
;           ProcedureReturn 
;         EndIf
        
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
                        Events(*Function, *Last, #PB_EventType_MouseLeave, Canvas, 0)
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
                    Events(*Function, *Widget, #PB_EventType_LeftButtonUp, Canvas, 0)
                  EndIf
                  
                  EventType = #PB_EventType_MouseLeave
                  *Last = *Widget
                  *Widget = 0
                EndIf
              EndIf
              
            Case #PB_EventType_LostFocus
              If (*Focus = *This)
                *Last = *Focus
                Events(*Function, *Focus, #PB_EventType_LostFocus, Canvas, 0)
                *Last = *Widget
              EndIf
            
            Case #PB_EventType_LeftButtonDown
              If (*Last = *This)
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\Focus = List()\Widget And List()\Widget <> *This 
                    
                    List()\Widget\Focus = 0
                    *Last = List()\Widget
                    Events(*Function, List()\Widget, #PB_EventType_LostFocus, List()\Widget\Canvas\Gadget, 0)
                    *Last = *Widget 
                    
                    ; 
                    PostEvent(#PB_Event_Gadget, List()\Widget\Canvas\Window, List()\Widget\Canvas\Gadget, #PB_EventType_Repaint)
                    Break 
                  EndIf
                Next
                PopListPosition(List())
                
                If *This <> \Focus : \Focus = *This : *Focus = *This
                  Events(*Function, *This, #PB_EventType_Focus, Canvas, 0)
                EndIf
              EndIf
              
          EndSelect
        EndIf
        
        If (*Last = *This) 
          Select EventType
            Case #PB_EventType_LeftButtonDown
              If Not \Canvas\Mouse\Delta
                \Canvas\Mouse\Delta = AllocateStructure(Mouse_S)
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
                        Events(*Function, *Last, #PB_EventType_MouseLeave, Canvas, 0)
                      EndIf     
                      
                      *Last = List()\Widget
                      *Widget = List()\Widget
                      ProcedureReturn Events(*Function, *Last, #PB_EventType_MouseEnter, Canvas, 0)
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
    
    If (*Last = *This) Or (*Focus = *This And *This\Text\Editable); Or (*Last = *Focus)
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Result | CallFunctionFast(*Function, *This, EventType)
      CompilerElse
        Result | CallCFunctionFast(*Function, *This, EventType)
      CompilerEndIf
    EndIf
    
    ProcedureReturn Result
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
              Result | Events(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Events(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | Events(*Function, *This, EventType, Canvas, CanvasModifiers)
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Text
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \Alpha = 255
        \Line =- 1
        \X =- 1
        \Y =- 1
        
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
          \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine =- 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine = 1
          EndIf
          \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
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
          \Resize = 0
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
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
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
  
  ;- DECLARE
  Declare.i SetItemState(*This.Widget_S, Item.i, State.i)
  Declare GetState(*This.Widget_S)
  Declare.s GetText(*This.Widget_S)
  Declare.i ClearItems(*This.Widget_S)
  Declare.i CountItems(*This.Widget_S)
  Declare.i RemoveItem(*This.Widget_S, Item.i)
  Declare SetState(*This.Widget_S, State.i)
  Declare GetAttribute(*This.Widget_S, Attribute.i)
  Declare SetAttribute(*This.Widget_S, Attribute.i, Value.i)
  Declare SetText(*This.Widget_S, Text.s, Item.i=0)
  Declare SetFont(*This.Widget_S, FontID.i)
  Declare.i AddItem(*This.Widget_S, Item.i,Text.s,Image.i=-1,Flag.i=0)
  
  Declare.i Repaint(*This.Widget_S)
  Declare.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
EndDeclareModule

Module Editor
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  Procedure.i Repaint(*This.Widget_S)
    If *This
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
    Else
      ForEach List()
        PostEvent(#PB_Event_Widget, List()\Widget\Canvas\Window, List()\Widget, #PB_EventType_Create)
      Next
    EndIf
  EndProcedure
  
  Procedure Caret(*This.Widget_S, Line.i = 0)
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
  
  Procedure SelectionText(*This.Widget_S) ; Ok
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
  
  Procedure SelectionReset(*This.Widget_S)
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
  
  
  ;-
  Procedure RemoveText(*This.Widget_S)
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
  
  Procedure Remove(*This.Widget_S)
    Protected Caret
    
    With *This
      PushListPosition(\Items())
      FirstElement(\Items()) ; LastElement(\Items()) ; 
      While NextElement(\Items()) ; PreviousElement(\Items())  ; 
        
        If \Items()\Text[2]\Len = \Items()\Text\Len
          \Items()\Text\Position - Caret
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Text\Position, 1)
          Caret + \Items()\Text\Position
          *This\Line - 1
          
        ElseIf \Items()\Text[2]\Len > 0
          Debug " get "+\Items()\Text\String.s+" "+\Items()\Text[2]\String.s
          ; If \Caret < \Caret[1] : \Caret = \Caret[1] : EndIf
          
          If \Caret[1] < \Caret
            If \Items()\Text[2]\Width[2]
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret[1], 1) 
              ;             \Caret = \Items()\Text\Len - \Items()\Text[2]\Len
              ;             \Caret[1] = \Caret
            Else
              \Items()\Text\Position - Caret
              Debug \Items()\Text\Position
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position, 1) 
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
      ;       \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1)
      \Text\Len = Len(\Text\String.s)
      \Text\Change = 1
      
      Debug \Text\String.s
    EndWith
    
    ProcedureReturn 1
  EndProcedure
  Procedure _Remove(*This.Widget_S)
    Protected Caret
    
    With *This
      PushListPosition(\Items())
      FirstElement(\Items()) ; LastElement(\Items()) ; 
      While NextElement(\Items()) ; PreviousElement(\Items())  ; 
        
        If \Items()\Text[2]\Len = \Items()\Text\Len
          \Items()\Text\Position - Caret
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Text\Position, 1)
          Caret + \Items()\Text\Position
          *This\Line - 1
        ElseIf \Items()\Text[2]\Len > 0
          Debug " get "+\Items()\Text\String.s+" "+\Items()\Text[2]\String.s
          ; If \Caret < \Caret[1] : \Caret = \Caret[1] : EndIf
          
          If \Caret[1] > \Caret
            If \Items()\Text[2]\Width[2]
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s+#LF$, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1) 
              ;             \Caret = \Items()\Text\Len - \Items()\Text[2]\Len
              ;             \Caret[1] = \Caret
              Caret = \Items()\Text[2]\Len
            Else
              \Items()\Text\Position - Caret
              Debug \Items()\Text\Position
              \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position, 1) 
              *This\Line - 1
            EndIf
          EndIf
        EndIf
      Wend
      PopListPosition(\Items())
      
      ;       \Text\Len = Len(\Text\String.s)
      ; 
      ;         If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
      ;       \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1)
      \Text\Len = Len(\Text\String.s)
      \Text\Change = 1
      
      Debug \Text\String.s
    EndWith
    
    ProcedureReturn 1
  EndProcedure
  
  
  
  Procedure Cut(*This.Widget_S)
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
  
  Procedure.s Copy(*This.Widget_S)
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
  Procedure ToUp(*This.Widget_S)
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
  
  Procedure ToDown(*This.Widget_S)
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
  
  Procedure ToLeft(*This.Widget_S) ; Ok
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
      ElseIf Not Repaint And ToUp(*This.Widget_S)
        \Caret = \Items()\Text\Len
        \Caret[1] = \Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToRight(*This.Widget_S) ; Ok
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
  
  Procedure ToInput(*This.Widget_S)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, Chr.s
    
    With *This
      If \Canvas\Input
        Chr.s = Text::Make(*This, Chr(\Canvas\Input))
        
        If Chr.s
          If \Items()\Text[2]\Len 
            If \Caret > \Caret[1] : \Caret = \Caret[1] : EndIf
            \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1)
          EndIf
          
          \Caret + 1
          \Items()\Text\String.s = \Items()\Text[1]\String.s + Chr(\Canvas\Input) + \Items()\Text[3]\String.s
          \Text\String.s = InsertString(\Text\String.s, Chr.s, \Items()\Text\Position+\Caret)
          \Text\Len = Len(\Text\String.s) 
          \Caret[1] = \Caret 
          \Text\Change =- 1
        Else
          \Default = *This
        EndIf
        
        \Text\String.s[1] = InsertString(\Text\String.s[1], Chr(\Canvas\Input), \Items()\Text\Position+\Caret)
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToBack(*This.Widget_S)
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
        Debug " "+ListIndex(\Items())+" "+\Items()\Text\Position+" "+\Items()\Text\String.s; 
        \Text\String.s[1] = Left(\Text\String.s[1], \Items()\Text\Position+\Caret - 1) + Mid(\Text\String.s[1],  \Items()\Text\Position+\Caret + 1)
        \Text\String.s = Left(\Text\String.s, \Items()\Text\Position+\Caret - 1) + Mid(\Text\String.s,  \Items()\Text\Position+\Caret + 1)
        \Caret - 1 
        \Text\Change =- 1
      Else
        ; Если дошли до начала строки то 
        ; переходим в конец предыдущего итема
        If *This\Line[1] > 0 
          \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Text\Position+\Caret, 1)
          
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
  
  Procedure ToDelete(*This.Widget_S)
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
  
  Procedure.i ToReturn(*This.Widget_S) ; Ok
    Protected Repaint, String.s
    
    With  *This
      If \Items()\Text[2]\Len > 0
        If \Line[1] > \Line : Swap \Line[1], \Line : EndIf
        
        If \Line = \Line[1] 
          String.s = Left(\Text\String.s, \Items()\Text\Position) + \Items()\Text[1]\String.s + #LF$ + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Position+\Items()\Text\Len))
        Else    
          PushListPosition(\Items())
          ForEach \Items()
            Select ListIndex(\Items()) 
              Case \Line[1] : String.s = Left(\Text\String.s, \Items()\Text\Position) + \Items()\Text[1]\String.s + #LF$
              Case \Line : String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Position+\Items()\Text\Len))
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
        String.s = Left(\Text\String.s, \Items()\Text\Position) + String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Position+\Items()\Text\Len))
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
  Procedure SetAttribute(*This.Widget_S, Attribute.i, Value.i)
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(*This.Widget_S, Attribute.i)
    Protected Result
    
    With *This
      ;       Select Attribute
      ;         Case #PB_ScrollBar_Minimum    : Result = \Scroll\Min
      ;         Case #PB_ScrollBar_Maximum    : Result = \Scroll\Max
      ;         Case #PB_ScrollBar_PageLength : Result = \Scroll\PageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*This.Widget_S, Item.i, State.i)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      Result = SelectElement(\Items(), Item) 
      If Result 
        \Items()\Line = \Items()\Item
        \Caret = State
        \Caret[1] = \Caret
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, State.i)
    Protected String.s
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If String.s
          String.s +#LF$+ \Items()\Text\String.s 
        Else
          String.s + \Items()\Text\String.s
        EndIf
      Next : String.s+#LF$
      PopListPosition(\Items())
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        Text::Redraw(*This, \Canvas\Gadget)
      EndIf
      
      If State <> #PB_Ignore
        \Focus = *This
        If GetActiveGadget() <> \Canvas\Gadget
          SetActiveGadget(\Canvas\Gadget)
        EndIf
        
        If State =- 1
          \Line = \Text\Count - 1
          LastElement(\Items())
          \Caret = \Items()\Text\Len
        Else
          \Line = CountString(Left(String, State), #LF$)
          SelectElement(\Items(), \Line)
          \Caret = State-\Items()\Text\Position
        EndIf
        
        \Items()\Text[1]\String = Left(\Items()\Text\String, \Caret)
        \Items()\Text[1]\Change = 1
        \Caret[1] = \Caret
        
        \Items()\Line = \Items()\Item 
        ;PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
        Scroll::SetState(\vScroll, ((\Line * \Text\Height)-\vScroll\Height) + \Text\Height) : \Scroll\Y =- \vScroll\Page\Pos
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(*This.Widget_S)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Line = \Items()\Item
          Result = \Items()\Text\Position + \Caret
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure ClearItems(*This.Widget_S)
    Text::ClearItems(*This)
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*This.Widget_S)
    ProcedureReturn Text::CountItems(*This)
  EndProcedure
  
  Procedure.i RemoveItem(*This.Widget_S, Item.i)
    Text::RemoveItem(*This, Item)
  EndProcedure
  
  Procedure.i AddItem(*This.Widget_S, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static adress.i, first.i
    Protected *Item, subLevel, hide
    ;     If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
                \Items()\collapsed = 1
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
          Text::AddLine(*This, Item.i, Text.s)
          
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
  
  Procedure.s GetText(*This.Widget_S)
    ProcedureReturn Text::GetText(*This)
  EndProcedure
  
  Procedure.i SetText(*This.Widget_S, Text.s, Item.i=0)
    
    If Text::SetText(*This, Text.s) 
      Text::ReDraw(*This, *This\Canvas\Gadget)
      ProcedureReturn 1
    EndIf
    
  EndProcedure
  
  Procedure.i SetFont(*This.Widget_S, FontID.i)
    
    If Text::SetFont(*This, FontID)
      Text::ReDraw(*This, *This\Canvas\Gadget)
      ProcedureReturn 1
    EndIf
    
  EndProcedure
  
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *This
      If Text::Resize(*This, X,Y,Width,Height)
        Scroll::Resizes(\vScroll, \hScroll, \x[2],\Y[2],\Width[2],\Height[2])
      EndIf
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  ;-
  Procedure.i Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\vScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0, \hScroll, \Canvas\Window, \Canvas\Gadget)
      If Repaint
        \Scroll\Y =- \vScroll\Page\Pos
      EndIf
      Repaint | Scroll::CallBack(\hScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0, \vScroll, \Canvas\Window, \Canvas\Gadget)
      If Repaint
        \Scroll\X =- \hScroll\Page\Pos
      EndIf
    EndWith
    
    If *This And (Not *This\vScroll\Buttons And Not *This\hScroll\Buttons)
      If ListSize(*This\items())
        With *This
          If Not \Hide And Not \Disable And \Interact
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
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton 
                  
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
                  
                  Repaint = #True
                  
                  Protected SelectionLen
                  PushListPosition(\Items()) 
                  ForEach \Items()
                    If \Line = \Items()\Item Or \Line[1] = \Items()\Item
                      
                    ElseIf ((\Line[1] < \Line And \Line[1] < \Items()\Item And \Line > \Items()\Item) Or
                            (\Line[1] > \Line And \Line[1] > \Items()\Item And \Line < \Items()\Item)) 
                      
                      If \Items()\Text[2]\String <> \Items()\Text\String
                        \Items()\Text[2]\Len = \Items()\Text\Len
                        If Not \Items()\Text\Len : \Items()\Text[2]\Len = 1 : EndIf
                        \Items()\Text[1]\String = "" : \Items()\Text[1]\Len = 0 : \Items()\Text[1]\Change = 1
                        \Items()\Text[3]\String = "" : \Items()\Text[3]\Len = 0 : \Items()\Text[3]\Change = 1
                        \Items()\Text[2]\String = \Items()\Text\String : \Items()\Text[2]\Change = 1
                      EndIf
                      
                      SelectionLen=Bool(Not \Flag\FullSelection)*7
                      ; \Items()\Text[2]\X = 0;\Items()\Text\X+\Items()\Text\Width
                      
                      If Not SelectionLen
                        \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                      Else
                        \Items()\Text[2]\Width[2] = SelectionLen
                      EndIf
                      
                      ;\Items()\Line = \Items()\Item
                    Else  
                      ;\Items()\Line =- 1
                      \Items()\Text[2]\String =  "" : \Items()\Text[2]\Len = 0 : \Items()\Text[2]\Change = 1
                    EndIf
                  Next
                  PopListPosition(\Items()) 
                EndIf
                
              Default
                itemSelect(\Line[1], \Items())
            EndSelect
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
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure Widget_CallBack()
    Protected String.s, *This.Widget_S = EventGadget()
    
    With *This
      Select EventType() 
        Case #PB_EventType_Create
          SetState(*This, #PB_Ignore)
      EndSelect
    EndWith
  EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Editor
        \Cursor = #PB_Cursor_IBeam
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \Alpha = 255
        \Interact = 1
        \Caret[1] =- 1
        \Line =- 1
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
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)+1
        \bSize = \fSize
        
        If Text::Resize(*This, X,Y,Width,Height, Canvas)
          \Flag\Buttons = Bool(flag&#PB_Flag_NoButtons)
          \Flag\Lines = Bool(flag&#PB_Flag_NoLines)
          \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
          \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
          \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
          \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
          
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
          
          \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
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
        Scroll::Widget(\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        Scroll::Resizes(\vScroll, \hScroll, \x[2],\Y[2],\Width[2],\Height[2])
        \Resize = 0
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
      BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Canvas\Window, *This, #PB_EventType_Create)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  
  Procedure Canvas_CallBack()
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint : Repaint = 1
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
                                                                                                                 ;Debug "resize "+GadgetWidth(\Canvas\Gadget) +" "+ GadgetHeight(\Canvas\Gadget)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
        Text::ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
        BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Canvas\Window, *This, #PB_EventType_Create)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
EndModule

DeclareModule Tree
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  ;Declare CallBack()
  Declare ReDraw(*This.Widget_S)
  Declare Draw(*This.Widget_S)
  Declare.i Gadget(Gadget.i, x.i, y.i, width.i, height.i, flag.i=0)
  Declare AddItem(*This.Widget_S,Item.i,Text.s,Image.i=-1,sublevel.i=0)
  Declare ClearItems(*This.Widget_S)
  Declare CountItems(*This.Widget_S, Item.i=-1)
  Declare RemoveItem(*This.Widget_S, Item.i)
  Declare GetItemAttribute(*This.Widget_S, Item.i, Attribute.i)
  Declare GetItemData(*This.Widget_S, Item.i)
  Declare SetItemData(*This.Widget_S, Item.i, *data)
  Declare GetItemColor(*This.Widget_S, Item.i, ColorType.i, Column.i=0)
  Declare SetItemColor(*This.Widget_S, Item.i, ColorType.i, Color.i, Column.i=0)
  Declare GetItemImage(*This.Widget_S, Item.i)
  Declare SetItemImage(*This.Widget_S, Item.i, Image.i)
  Declare GetState(*This.Widget_S)
  Declare SetState(*This.Widget_S, Item.i)
  Declare GetItemState(*This.Widget_S, Item.i)
  Declare SetItemState(*This.Widget_S, Item.i, State.i)
  Declare.s GetText(*This.Widget_S)
  Declare   SetText(*This.Widget_S, Text.s)
  Declare.s GetItemText(*This.Widget_S, Item.i)
  Declare SetItemText(*This.Widget_S, Item.i, Text.s)
  Declare Free(*This.Widget_S)
  ;Declare ReDraw(*This)
EndDeclareModule

Module Tree
  
  Procedure item_from(*This.Widget_S, MouseX=-1, MouseY=-1, focus=0)
    Protected adress.i
    Protected lostfocus.i=-1, collapsed.i, sublevel.i, coll.i
    Protected Buttons
    
    With *This
      PushListPosition(\Items()) 
      ForEach \Items()
        If \Items()\Line = \Items()\Item 
          \Items()\Line =- 1
          adress = @\Items()
          Break
        EndIf
      Next
      
      ForEach \Items()
        If \Items()\Item = \Items()\focus
          If Bool(MouseX=-1 And MouseY=-1 And focus=1)
            \Items()\lostfocus = \Items()\focus
            *This\focus = 0
            
            ; then lost focus widget
            \Items()\Color\State = 0
            
          EndIf
          adress = @\Items()
          Break
        EndIf
      Next
      
      If Not Bool(MouseX=-1 And MouseY=-1)
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If (MouseY > (\Items()\Y) And MouseY =< ((\Items()\Y+\Items()\Height))) And 
             ((MouseX > \Items()\X) And (MouseX =< (\Items()\X+\Items()\Width)))
            
            If focus
              If (MouseY > (\Items()\box\y[1]) And MouseY =< ((\Items()\box\y[1]+\Items()\box\height[1]))) And 
                 ((MouseX > \Items()\box\x[1]) And (MouseX =< (\Items()\box\x[1]+\Items()\box\width[1])))
                
                \Items()\checked ! 1
                *This\Change = 1
              EndIf
              
              If (Not \Flag\Buttons And \Items()\childrens) And
                 (MouseY > (\Items()\box\y[0]) And MouseY =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                 ((MouseX > \Items()\box\x[0]) And (MouseX =< (\Items()\box\x[0]+\Items()\box\width[0])))
                
                sublevel = \Items()\sublevel
                \Items()\collapsed ! 1
                
                PushListPosition(\Items())
                While NextElement(\Items())
                  If sublevel = \Items()\sublevel
                    Break
                  ElseIf sublevel < \Items()\sublevel 
                    If \Items()\adress
                      PushListPosition(\Items())
                      ChangeCurrentElement(\Items(), \Items()\adress)
                      collapsed = \Items()\collapsed
                      If \Items()\hide
                        collapsed = 1
                      EndIf
                      PopListPosition(\Items())
                    EndIf
                    
                    \Items()\hide = collapsed
                  EndIf
                Wend
                PopListPosition(\Items())
                
              Else
                ; Get entered item only on image and text 
                If Not *This\Flag\FullSelection And
                   ((MouseX < \Items()\text\x-*This\Image\width) Or (MouseX > \Items()\text\x+\Items()\text\width))
                  Break
                EndIf
                
                If adress 
                  PushListPosition(\Items()) 
                  ChangeCurrentElement(\Items(), adress)
                  If \Items()\focus = \Items()\Item
                    lostfocus = \Items()\focus 
                    \Items()\lostfocus =- 1
                    \Items()\focus =- 1
                  EndIf
                  PopListPosition(\Items()) 
                  If lostfocus <> \Items()\Item
                    \Items()\lostfocus = lostfocus
                    *This\Item = \Items()\Item
                    *This\Change = 1
                  EndIf
                EndIf
                
                \Items()\focus = \Items()\Item
              EndIf
            EndIf
            
            If \Items()\Line <> \Items()\Item 
              \Items()\Line = \Items()\Item
              *This\Line = \Items()\Line
              *This\Text = \Items()\text 
              ;CopyStructure(\Items()\text, *This\Text, Text_S)
              
              
              If \Items()\lostfocus <> \Items()\Item
                \Items()\Color\State = 1+Bool(\Items()\Item=\Items()\focus)
              EndIf
              
            EndIf
            
            adress = @\Items()
            
            Break
          EndIf
        Next
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn adress
  EndProcedure
  
  Procedure DrawBox(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) 
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
  
  ;-
  Procedure DrawPlotXCallback(X, Y, SourceColor, TargetColor)
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
  
  Procedure DrawPlotYCallback(X, Y, SourceColor, TargetColor)
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
  
  Procedure Draw(*This.Widget_S)
    Protected x_content,y_point,x_point, iwidth, iheight, w=18, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 128, height =20
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b =- 1
    Protected Drawing.b, text_color
    
    ;box_type.b = 0
    
    If *This 
      If *This\Text\FontID : DrawingFont(*This\Text\FontID) : EndIf
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\x[2], *This\y[2], *This\width[2], *This\height[2], back_color)
      
      If Not *This\Text\Height
        *This\Text\Height = height;TextHeight("A") + 1
      EndIf
      
      With *This\Items()
        If ListSize(*This\Items())
          *This\Scroll\Width=*This\x[2]
          *This\Scroll\height=*This\y[2]
          iwidth = *This\width[2]-Scroll::Width(*This\vScroll)
          iheight = *This\height[2]-Scroll::Height(*This\hScroll)
          
          ForEach *This\Items()
            If Not \hide
              If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
              _clip_output_(*This, *This\x[2], *This\y[2], iwidth, iheight) ; Bug
              
              \x=*This\x[2]
              \width=iwidth
              \height=height
              \y=*This\Scroll\height-*This\vScroll\Page\Pos
              
              If \text\change = 1
                \text\height = TextHeight("A")
                \text\width = TextWidth(\text\string.s)
                \text\change = 0
              EndIf
              
              x_content=2+\x+(Bool(*This\Flag\Buttons=0)*w+\sublevel*w)-*This\hScroll\Page\Pos
              
              \box\width = box_size
              \box\height = box_size
              \box\x = x_content-(w+\box\width)/2
              \box\y = (\y+height)-(height+\box\height)/2
              
              If \Image\handle
                \Image\x = 3+x_content
                \Image\y = \y+(height-\Image\height)/2
                
                *This\Image\handle = \Image\handle
                *This\Image\width = \Image\width+4
              EndIf
              
              \text\x = 3+x_content+*This\Image\width
              \text\y = \y+(height-\text\height)/2
              
              If *This\Flag\CheckBoxes
                \box\x+w-2
                \text\x+w-2
                \Image\x+w-2 
                
                \box\width[1] = box_1_size
                \box\height[1] = box_1_size
                
                \box\x[1] = 3+(w-\box\width[1])/2 
                \box\y[1] = (\y+height)-(height+\box\height[1])/2
              EndIf
              
              *This\Scroll\height+\height
              If *This\Scroll\Width < (\text\x+\text\width)+*This\hScroll\Page\Pos
                *This\Scroll\Width = (\text\x+\text\width)+*This\hScroll\Page\Pos
              EndIf
              
              
              Drawing = Bool(\y+\height>*This\y[2] And \y<*This\height[2])
              If Drawing
                If (\Item=\focus And \lostfocus<>\focus) Or
                   (*This\focus And *This\Flag\FullSelection And *This\Item = \Item )
                  
                  If *This\Flag\FullSelection And box_type=-1
                    box_color = $FEFEFE
                  EndIf
                  text_color=$FEFEFE
                Else
                  box_color = $7E7E7E
                  text_color=$000000
                EndIf
                
                ; Draw selections
                If \Item=\Line Or \Item=\focus ; \Item=*This\Line ; с этим остается последное виделеное слово
                  Protected SelectionPos, SelectionLen 
                  If *This\Flag\FullSelection
                    SelectionPos = *This\X[2]
                    SelectionLen = iwidth
                  Else
                    SelectionPos = \Text\X - 2
                    SelectionLen = \Text\width + 4
                  EndIf
                  
                  ; Draw items back color
                  If \Color\Fore
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(\Vertical,SelectionPos,\Y,SelectionLen,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    RoundBox(SelectionPos,\Y,SelectionLen,\Height,\Radius,\Radius,\Color\Back[\Color\State])
                  EndIf
                  ;Debug Point(\x+2,\y+2)
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(SelectionPos,\y,SelectionLen,\height, \Color\Frame[\Color\State])
                EndIf
              EndIf  
              
              ; Draw plot
              If Not *This\Flag\Lines 
                x_point=\box\x+\box\width/2
                
                If x_point>*This\x[2] 
                  y_point=\box\y+\box\height/2
                  
                  If Drawing
                    ; Horizontal plot
                    DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotXCallback())
                    Line(x_point,y_point,line_size,1, point_color&$FFFFFF|alpha<<24)
                  EndIf
                  
                  ; Vertical plot
                  If \adress
                    start = \sublevel
                    
                    PushListPosition(*This\Items())
                    ChangeCurrentElement(*This\Items(), \adress) 
                    If Drawing Or (start = \sublevel And Bool(\y+\height>*This\y[2] And \y<*This\height[2]))
                      
                      If start
                        start = \y+\height+\height/2-line_size 
                      Else 
                        start = (*This\y[2]+\height/2)-*This\vScroll\Page\Pos 
                      EndIf
                      
                      DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotYCallback())
                      Line(x_point,start,1, (y_point-start), point_color&$FFFFFF|alpha<<24)
                    EndIf
                    PopListPosition(*This\Items())
                  EndIf
                EndIf
              EndIf
              
              If Drawing
                ; Draw boxes
                If Not *This\Flag\Buttons And \childrens
;                   DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
;                   Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, box_color&$FFFFFF|alpha<<24, 0,0) 
                  If box_type=-1
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, box_color&$FFFFFF|alpha<<24, 0,0) 
                  Else
                    DrawingMode(#PB_2DDrawing_Gradient)
                    BackColor($FFFFFF) : FrontColor($EEEEEE)
                    LinearGradient(\box\x, \box\y, \box\x, (\box\y+\box\height))
                    RoundBox(\box\x+1,\box\y+1,\box\width-2,\box\height-2,box_type,box_type)
                    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    RoundBox(\box\x,\box\y,\box\width,\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                    
                    Line(\box\x+2,\box\y+\box\height/2 ,\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                    If \collapsed : Line(\box\x+\box\width/2,\box\y+2,1,\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                  EndIf
                EndIf
                
                ; Draw checkbox
                If *This\Flag\CheckBoxes
                  DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, checkbox_color, box_color, 2, alpha);, box_type)
                EndIf
                
                ; Draw image
                If \Image\handle
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawAlphaImage(\Image\handle, \Image\x, \Image\y, alpha)
                EndIf
                
                ; Draw string
                If \text\string.s
                  _clip_output_(*This, *This\x[2], *This\y[2], \width, *This\height[2]) 
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawText(\text\x, \text\y, \text\string.s, text_color&$FFFFFF|alpha<<24)
                EndIf
              EndIf
            EndIf
          Next
        EndIf
        
        UnclipOutput()
        
        ; Задаем размеры скролл баров
        If *This\vScroll\Page\Length And *This\vScroll\Max<>*This\Scroll\Height And 
           Scroll::SetAttribute(*This\vScroll, #PB_ScrollBar_Maximum, *This\Scroll\Height)
          Scroll::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          *This\vScroll\Page\ScrollStep = height
        EndIf
        If *This\hScroll\Page\Length And *This\hScroll\Max<>*This\Scroll\Width And 
           Scroll::SetAttribute(*This\hScroll, #PB_ScrollBar_Maximum, *This\Scroll\Width)
          Scroll::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        
        Scroll::Draw(*This\vScroll)
        Scroll::Draw(*This\hScroll)
        
        If *This\fSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*This\x[1], *This\y[1], *This\width[1], *This\height[1], $ADADAE)
        EndIf
        
        If *This\bSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*This\x[2]-1, *This\y[2]-1, *This\width[2]+2, *This\height[2]+2, $FFFFFF)
        EndIf
        
      EndWith
    EndIf
  EndProcedure
  
  Procedure ReDraw(*This.Widget_S)
    If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
      Draw(*This)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure AddItem(*This.Widget_S,Item.i,Text.s,Image.i=-1,sublevel.i=0)
   ; ProcedureReturn Editor::AddItem(*This,Item,Text.s,Image,sublevel)
    Static adress.i
    Protected hide.b, *Item
    
    If Not *This
      ProcedureReturn -1
    EndIf
    
    With *This
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
      
      If subLevel
        If sublevel>ListIndex(\Items())
          sublevel=ListIndex(\Items())
        EndIf
        PushListPosition(\Items()) 
        While PreviousElement(\Items()) 
          If subLevel = \Items()\subLevel
            adress = \Items()\adress
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
            \Items()\adress[1] = *Item
            \Items()\childrens + 1
            \Items()\collapsed = 1
            hide = 1
          EndIf
        EndIf
        
        PopListPosition(\Items()) 
        \Items()\hide = hide
        \Items()\sublevel = sublevel
      EndIf
      
      \Items()\adress = adress
      \Items()\text\change = 1
      
      \Items()\Text\FontID = \Text\FontID
      \Items()\Line =- 1
      \Items()\focus =- 1
      \Items()\lostfocus =- 1
      \Items()\time = ElapsedMilliseconds()
      \Items()\Item = Item
      \Items()\text\string.s = Text.s ;+" ("+Str(iadress)+"-"+Str(SubLevel)+")" 
      
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
      EndIf
      
      ; Устанавливаем 
      ; цвета по умолчанию
      
      ;       If Item%2
      \Items()\Color = Colors
      ;       Else
      ;       ; Цвета по умолчанию
      ;       \Items()\Color[0]\Front[0] = $80000000
      \Items()\Color[0]\Fore[0] = 0 
      ;       \Items()\Color[0]\Back[0] = $80E2E2E2
      ;       \Items()\Color[0]\Frame[0] = $80C8C8C8
      ;       
      ;       ; Цвета если мышь на виджете
      ;       \Items()\Color[0]\Front[1] = $80000000
      \Items()\Color[0]\Fore[1] = 0
      ;       \Items()\Color[0]\Back[1] = $80FCEADA
      ;       \Items()\Color[0]\Frame[1] = $80FFC288
      ;       
      ;       ; Цвета если нажали на виджет
      ;       \Items()\Color[0]\Front[2] = $80FFFFFF
      \Items()\Color[0]\Fore[2] = 0
      ;       \Items()\Color[0]\Back[2] = $C8E89C3D ; $80E89C3D
      ;       \Items()\Color[0]\Frame[2] = $C8DC9338 ; $80DC9338
      
      ;     EndIf
      
      ;       If *This\Scroll\Height=<*This\height
      ;         ;  Draw(*This)
      ;       EndIf
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure ClearItems(*This.Widget_S)
    Protected Result.i
    
    If *This
      With *This
        Result = ClearList(\Items())
        If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
          Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
          StopDrawing()
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure CountItems(*This.Widget_S, Item.i=-1)
    Protected Result.i, sublevel.i
    
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
  
  Procedure RemoveItem(*This.Widget_S, Item.i)
    Protected Result.i, sublevel.i
    
    If *This
      With *This
        ;PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            sublevel = \Items()\sublevel
            PushListPosition(\Items())
            While NextElement(\Items())
              If sublevel = \Items()\sublevel
                Break
              ElseIf sublevel < \Items()\sublevel 
                Result = DeleteElement(\Items(), 1) 
              EndIf
            Wend
            PopListPosition(\Items())
            Result = DeleteElement(\Items()) 
            Break
          EndIf
        Next
        ;PopListPosition(\Items())
        
        ReDraw(*This)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemAttribute(*This.Widget_S, Item.i, Attribute.i)
    Protected Result.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
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
  
  Procedure GetItemData(*This.Widget_S, Item.i)
    Protected Result.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            Result = \Items()\data
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemData(*This.Widget_S, Item.i, *data)
    Protected Result.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            \Items()\data = *data
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemColor(*This.Widget_S, Item.i, ColorType.i, Column.i=0)
    Protected Result.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemColor(*This.Widget_S, Item.i, ColorType.i, Color.i, Column.i=0)
    Protected Result.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemImage(*This.Widget_S, Item.i)
    Protected Result.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            Result = \Items()\Image
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemImage(*This.Widget_S, Item.i, image.i)
    Protected Result.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item And IsImage(image)
            \Items()\Image\handle = ImageID(image)
            \Items()\Image\handle[1] = image 
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(*This.Widget_S, Item.i)
    Protected Result.i, lostfocus.i=-1, collapsed.i, sublevel.i, adress.i, coll.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Line = \Items()\Item 
            \Items()\Line =- 1
            Result = @\Items()
            Break
          EndIf
        Next
        
        ForEach \Items()
          If \Items()\Item = \Items()\focus
            \Items()\lostfocus = \Items()\focus
            If Item =- 1 : \Items()\focus =- 1 : EndIf
            Result = @\Items()
            Break
          EndIf
        Next
        
        If Item <>- 1
          ForEach \Items()
            If \Items()\hide : Continue : EndIf
            If \Items()\Item = Item
              
              If Result 
                PushListPosition(\Items()) 
                ChangeCurrentElement(\Items(), Result)
                If \Items()\focus = \Items()\Item
                  lostfocus = \Items()\focus 
                  \Items()\lostfocus =- 1
                  \Items()\focus =- 1
                EndIf
                PopListPosition(\Items()) 
                If lostfocus <> \Items()\Item
                  \Items()\lostfocus = lostfocus
                EndIf
              EndIf
              
              \Items()\focus = \Items()\Item
              \Items()\Line = \Items()\Item
              
              If GetActiveGadget()<>*This\Canvas\Gadget
                \Items()\lostfocus = \Items()\focus
                \Items()\Line =- 1
              EndIf
              
              Result = @\Items()
              Break
              
            EndIf
          Next
        EndIf
        PopListPosition(\Items())
        
        ReDraw(*This)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetState(*This.Widget_S)
    Protected Result.i
    
    If *This 
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = \Items()\focus
            Result = \Items()\Item
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemState(*This.Widget_S, Item.i, State.i)
    Protected Result.i, lostfocus.i=-1, collapsed.i, sublevel.i, adress.i, coll.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            If State&#PB_Attribute_Selected
              \Items()\focus = \Items()\Item
              
              If GetActiveGadget()<>*This\Canvas\Gadget
                \Items()\lostfocus = \Items()\focus
                \Items()\Line =- 1
              EndIf
              
              ; GetText()
              \text\string = \Items()\text\string
            EndIf
            If State&#PB_Attribute_Checked
              \Items()\checked = 1
            EndIf
            If State&#PB_Attribute_Collapsed Or State&#PB_Attribute_Expanded
              \Items()\collapsed = Bool(State&#PB_Attribute_Collapsed)
              
              sublevel = \Items()\sublevel
              
              PushListPosition(\Items())
              While NextElement(\Items())
                If sublevel = \Items()\sublevel
                  Break
                ElseIf sublevel < \Items()\sublevel 
                  If State&#PB_Attribute_Collapsed
                    \Items()\hide = 1
                  ElseIf State&#PB_Attribute_Expanded
                    \Items()\hide = 0
                  EndIf
                EndIf
              Wend
            EndIf
            Break
          EndIf
        Next
        PopListPosition(\Items())
        
        ReDraw(*This)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemState(*This.Widget_S, Item.i)
    Protected Result.i, lostfocus.i=-1, collapsed.i, sublevel.i, adress.i, coll.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            Result = #PB_Attribute_Selected
            If \Items()\collapsed
              Result | #PB_Attribute_Collapsed
            Else
              Result | #PB_Attribute_Expanded
            EndIf
            If \Items()\checked
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
  
  Procedure.s GetText(*This.Widget_S)
    Protected Result.s
    
    Result = *This\text\string
    ;     If *This
    ;       With *This
    ;         PushListPosition(\Items()) 
    ;         ForEach \Items()
    ;           If \Items()\hide : Continue : EndIf
    ;           If \Items()\Item = \Items()\focus
    ;             Result = \Items()\text\string
    ;             Break
    ;           EndIf
    ;         Next
    ;         PopListPosition(\Items())
    ;       EndWith
    ;     EndIf  
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetText(*This.Widget_S, Text.s)
    Protected Result.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = \Items()\focus
            \Items()\text\string = Text
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(*This.Widget_S, Item.i) ; Ok
    Protected Result.s
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            Result = \Items()\text\string
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemText(*This.Widget_S, Item.i, Text.s) ; Ok
    Protected Result.i
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            If \Items()\text\string <> Text 
              \Items()\text\string = Text
              \Items()\text\change = 1
              Result = 1
            EndIf
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    If Result
      Draw(*This)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *This
      If Text::Resize(*This, X,Y,Width,Height)
        Scroll::Resizes(\vScroll, \hScroll, \x[2],\Y[2],\Width[2],\Height[2])
      EndIf
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  ;-
  Procedure.i Events(*This.Widget_S, EventType.i)
    Protected Repaint.i, WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    If *This
      With *This
        If Not \hide
          If \vScroll
            Repaint = Scroll::CallBack(\vScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y, WheelDelta, 0, \hScroll, \Canvas\Window, \Canvas\Gadget)
            If Repaint
              *This\Scroll\Y =- *This\vScroll\Page\Pos
              ReDraw(*This)
            EndIf
          EndIf
          
          If \hScroll
            Repaint = Scroll::CallBack(\hScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y, WheelDelta, 0, \vScroll, \Canvas\Window, \Canvas\Gadget)
            If Repaint
              *This\Scroll\X =- *This\hScroll\Page\Pos
              ReDraw(*This)
            EndIf
          EndIf
          
          If Not (\vScroll\Buttons Or \hScroll\Buttons)
            Select EventType
              Case #PB_EventType_MouseWheel
                If Not \vScroll\Hide
                  Select -WheelDelta
                    Case-1 : Repaint = Scroll::SetState(\vScroll, \vScroll\Page\Pos - (\vScroll\Max-\vScroll\Min)/30)
                    Case 1 : Repaint = Scroll::SetState(\vScroll, \vScroll\Page\Pos + (\vScroll\Max-\vScroll\Min)/30)
                  EndSelect
                EndIf
                
              Case #PB_EventType_LeftClick 
                If \change : \change = 0 
                  PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) 
                EndIf
                PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_LeftClick)
                
              Case #PB_EventType_LeftButtonUp : \Drag[1]=0 
              Case #PB_EventType_LeftButtonDown : \Focus = 1
                Repaint = item_from(*This, \Canvas\Mouse\X, \Canvas\Mouse\Y, 1)
                
              Case #PB_EventType_MouseLeave, #PB_EventType_LostFocus
                Repaint = item_from(*This,-1,-1, Bool(EventType=#PB_EventType_LostFocus))
                
              Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter
                Protected from = \Line
                Repaint = item_from(*This, \Canvas\Mouse\X, \Canvas\Mouse\Y)
                
                If from <> \Line
                  If \text\x+\text\width>\width
                    GadgetToolTip(\Canvas\Gadget, \text\string)
                  Else
                    GadgetToolTip(\Canvas\Gadget, "")
                  EndIf
                  from = \Line
                EndIf
                
                If \Drag And \Drag[1]<>\Drag : \Drag[1]=\Drag 
                  If \change : \change = 0
                    PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
                  EndIf
                  PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_DragStart)
                EndIf
                
              Case #PB_EventType_Focus
                PushListPosition(\Items()) 
                ForEach \Items()
                  If \Items()\Item = \Items()\focus And \Items()\focus = \Items()\lostfocus 
                    \Items()\lostfocus =- 1
                    Repaint = 1
                    Break
                  EndIf
                Next
                PopListPosition(\Items()) 
                
            EndSelect
          Else
            Repaint = item_from(*This,-1,-1, 0)
          EndIf
        EndIf
      EndWith 
    EndIf
    
    If Repaint 
      ReDraw(*This)
    EndIf
  EndProcedure
  
  Procedure.i _Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\vScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0, \hScroll, \Canvas\Window, \Canvas\Gadget)
      If Repaint
        \Scroll\Y =- \vScroll\Page\Pos
      EndIf
      Repaint | Scroll::CallBack(\hScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0, \vScroll, \Canvas\Window, \Canvas\Gadget)
      If Repaint
        \Scroll\X =- \hScroll\Page\Pos
      EndIf
    EndWith
    
    If *This ;And (Not *This\vScroll\Buttons And Not *This\hScroll\Buttons)
      If ListSize(*This\items())
        With *This
          If Not \Hide And Not \Disable And \Interact
            Select EventType 
              Case #PB_EventType_MouseLeave
                \Line =- 1
                
              Case #PB_EventType_LeftButtonDown
                PushListPosition(\Items()) 
                ForEach \Items()
                  If \Line = \Items()\Item 
                    \Line[1] = \Line
                    \Items()\Color\State = 2
                    ; \Items()\Focus = \Items()\Item 
                  ElseIf \Items()\Focus = \Items()\Item 
                    \Items()\Color\State = 1
                    \Items()\Focus =- 1
                  EndIf
                Next
                PopListPosition(\Items()) 
                Repaint = 1
                
              Case #PB_EventType_LeftButtonUp
                PushListPosition(\Items()) 
                ForEach \Items()
                  If \Line = \Items()\Item 
                    \Items()\Focus = \Items()\Item 
                  Else
                    \Items()\Color\State = 1
                  EndIf
                Next
                PopListPosition(\Items()) 
                Repaint = 1
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\Y < \Y Or \Canvas\Mouse\X > Scroll::X(\vScroll)
                  Item.i =- 1
                Else
                  Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
                EndIf
                
                If \Line <> Item And Item =< ListSize(\Items())
                  If isItem(\Line, \Items()) 
                    If \Line <> ListIndex(\Items())
                      SelectElement(\Items(), \Line) 
                    EndIf
                    
                    ;If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton 
                      \items()\Color\State = 2 
                     \items()\Line =- 1
                    ;EndIf
                  EndIf
                  
                  itemSelect(Item, \Items())
                  ;If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton And itemSelect(Item, \Items())
                    \items()\Color\State = 1
                  \items()\Line = \items()\Item
                  ;EndIf
                  
                  \Line = Item
                   Repaint = #True
                EndIf
                
              Default
                itemSelect(\Line[1], \Items())
            EndSelect
          EndIf
        EndWith    
        
        With *This\items()
          If *Focus = *This
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType
              Case #PB_EventType_KeyUp
              Case #PB_EventType_KeyDown
                Select *This\Canvas\Key
                  Case #PB_Shortcut_V
                EndSelect 
                
            EndSelect
          EndIf
          
          
        EndWith
      EndIf
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
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
        \Alpha = 255
        \Interact = 1
        \Caret[1] =- 1
        \Line =- 1
        \X =- 1
        \Y =- 1
        
        ; Set the default widget flag
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
        
        \Flag\Buttons = Bool(flag&#PB_Flag_NoButtons)
        \Flag\Lines = Bool(flag&#PB_Flag_NoLines)
        \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
        \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
        \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)
        
        If Text::Resize(*This, X,Y,Width,Height, Canvas)
          \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
          
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine = 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine =- 1
          EndIf
          \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
          \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
          \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
          \Text\Pass = Bool(Flag&#PB_Text_Password)
          
          \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
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
          \Color\Fore = 0
          If \Text\Editable
            \Color\Back = $FFFFFFFF 
          Else
            \Color\Back = $FFF0F0F0  
          EndIf
          
        EndIf
        
        Scroll::Widget(\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        If Not Bool(\Text\MultiLine) And Bool(\flag\Buttons = 0 Or \flag\Lines=0)
          Scroll::Widget(\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
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
  
  Procedure CallBacks()
    
    Static LastX, LastY
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint
        ReDraw(*This)
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        
        SetGadgetData(Gadget, *This)
        ; ReDraw(*This)
        
        PostEvent(#PB_Event_Gadget, GetActiveWindow(), Gadget, #PB_EventType_Resize)
        BindGadgetEvent(Gadget, @CallBacks())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
  Procedure Free(*This.Widget_S)
    Protected Result
    
    If *This
      FreeStructure(*This)
      ; SetGadgetData(Gadget, #Null)
      UnbindGadgetEvent(*This\Canvas\Gadget, @CallBacks())
      ; SetGadgetColor(Gadget, #PB_Gadget_BackColor, $FFFFFF)
      If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
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
  UseModule Tree
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
      If GadgetType(EventGadget()) = #PB_GadgetType_Tree
        Debug GetGadgetText(EventGadget())
        Debug GetGadgetState(EventGadget())
        Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
      Else
        Debug Tree::GetText(GetGadgetData(EventGadget()))
        Debug Tree::GetState(GetGadgetData(EventGadget()))
        Debug Tree::GetItemState(GetGadgetData(EventGadget()), Tree::GetState(GetGadgetData(EventGadget())))
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
    *g = GetGadgetData(g)
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
; Folding = --------------------------------------------------------------------------------------------------------------------------------------------------------
; EnableXP