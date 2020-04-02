CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget"
  XIncludeFile "fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget"
CompilerElse
  IncludePath "Z:/Documents/GitHub/Widget"
CompilerEndIf


; CompilerIf Not Defined(constants, #PB_Module)
;   XIncludeFile "constants.pbi"
; CompilerEndIf
; 
; CompilerIf Not Defined(structures, #PB_Module)
;   XIncludeFile "structures.pbi"
; CompilerEndIf

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "";""""/Users/As/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
  ;  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  ;  IncludePath "/Users/a/Documents/GitHub/Widget/"
CompilerEndIf


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
    
    #PB_Flag_MultiSelect
    #PB_Flag_ClickSelect
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
  
  #PB_Attribute_Numeric = 1
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
  
  Structure _s_color
    Alpha.a[2]
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
    NoLines.b
    NoButtons.b
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
  
  Structure _s_bar Extends Coordinate_S
    Window.i
    Gadget.i
    
    Both.b ; we see both scrolbars
    
    Size.i[4]
    Type.i[4]
    Focus.i
    Buttons.i
    round.i
    
    Hide.b[2]
    Disable.b[2]
    Vertical.b
    DrawingMode.i
    
    Max.i
    Min.i
    Page.Page_S
    Area.Page_S
    Thumb.Page_S
    Button.Page_S
    Color._s_color[4]
  EndStructure
  
  Structure _s_scroll Extends Coordinate_S
    v._s_bar
    h._s_bar
  EndStructure
  
  ;- _s_widget
  Structure _s_widget Extends Coordinate_S
    Index.i  ; Index of new list element
    Handle.i ; Adress of new list element
             ;
    
    *Widget._s_widget
    *root._s_root
    Color._s_color[4]
    Text.Text_S[4]
    ;Clip.Coordinate_S
    
    bar._s_bar
    
    Scroll._s_scroll
    
    Image.Image_S
    box.Coordinate_S
    Flag.Flag_S
    
    
    bs.b
    fs.b[2]
    
    Hide.b[2]
    Cursor.i[2]
    
    ;Caret.i[3] ; 0 = Pos ; 1 = PosFixed
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
    round.i
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
  
  ;- - _s_keyboard
  Structure _s_keyboard
    change.b
    input.c
    key.i[2]
  EndStructure
  
  ;- - _s_canvas
  Structure _s_canvas
    window.i
    gadget.i
  EndStructure
  
  ;- _s_root
  Structure _s_root
    Mouse.Mouse_S
    canvas._s_canvas
    keyboard._s_keyboard
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
  ;UseModule Macros
  UseModule Constants
  UseModule Structures
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\Length / (_this_\Max-_this_\Min)), #PB_Round_Nearest)) : If _this_\Vertical : _this_\Y[3] = _this_\Thumb\Pos : _this_\Height[3] = _this_\Thumb\Length : Else : _this_\X[3] = _this_\Thumb\Pos : _this_\Width[3] = _this_\Thumb\Length : EndIf
  EndMacro
  
  
  Declare.b Draw(*Scroll._s_bar)
  Declare.i Y(*Scroll._s_bar)
  Declare.i X(*Scroll._s_bar)
  Declare.i Width(*Scroll._s_bar)
  Declare.i Height(*Scroll._s_bar)
  Declare.b SetState(*Scroll._s_bar, ScrollPos.i)
  Declare.i SetAttribute(*Scroll._s_bar, Attribute.i, Value.i)
  Declare.i SetColor(*Scroll._s_bar, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.b Resize(*This._s_bar, iX.i,iY.i,iWidth.i,iHeight.i, *Scroll._s_bar=#Null)
  Declare.b Resizes(*v._s_bar, *h._s_bar, X.i,Y.i,Width.i,Height.i)
  Declare.b Updates(*v._s_bar, *h._s_bar, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.b CallBack(*This._s_bar, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0, AutoHide.b=0, *Scroll._s_bar=#Null, Window=-1, Gadget=-1)
  Declare.i Widget(*Scroll._s_bar, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, round.i=0)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, PageLength.i, Flag.i, round.i=0)
  Declare Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
EndDeclareModule

Module Scroll
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
  
  Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_=0, _alpha_=255)
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
  
  Procedure.i Pos(*This._s_bar, ThumbPos.i)
    Protected ScrollPos.i
    
    With *This
      ScrollPos = Match(\Min + Round((ThumbPos - \Area\Pos) / (\Area\Length / (\Max-\Min)), #PB_Round_Nearest), \Page\ScrollStep) : If (\Vertical And \Type = #PB_GadgetType_TrackBar) : ScrollPos = ((\Max-\Min)-ScrollPos) : EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Procedure.b Draw(*Scroll._s_bar)
    With *Scroll
      If Not \Hide And \Color\alpha
        
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[0],\Y[0],\Width[0],\Height[0],\round,\round,\Color[0]\Back[\Color[0]\State]&$FFFFFF|\Color\alpha<<24)
        
        If \Vertical
          ; Draw left line
          If \Both
            ; "Это пустое пространство между двумя скроллами тоже закрашиваем если скролл бара кнопки не круглые"
            If Not \round : Box(\X[2],\Y[2]+\height[2]+1,\Width[2],\Height[2],\Color[0]\Back[\Color[0]\State]&$FFFFFF|\Color\alpha<<24) : EndIf
            Line(\X[0],\Y[0],1,\height[0]-\round/2,$FFFFFFFF&$FFFFFF|\Color\alpha<<24)
          Else
            Line(\X[0],\Y[0],1,\Height[0],$FFFFFFFF&$FFFFFF|\Color\alpha<<24)
          EndIf
        Else
          ; Draw top line
          If \Both
            Line(\X[0],\Y[0],\width[0]-\round/2,1,$FFFFFFFF&$FFFFFF|\Color\alpha<<24)
          Else
            Line(\X[0],\Y[0],\Width[0],1,$FFFFFFFF&$FFFFFF|\Color\alpha<<24)
          EndIf
        EndIf
        
        If \Thumb\Length
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\X[3],\Y[3],\Width[3],\Height[3],\Color[3]\Fore[\Color[3]\State],\Color[3]\Back[\Color[3]\State], \round, \Color\alpha)
          
          ; Draw thumb frame
          If #PB_2DDrawing_Default = #PB_2DDrawing_Gradient
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[3],\Y[3],\Width[3],\Height[3],\round,\round,\Color[3]\Frame[\Color[3]\State]&$FFFFFF|\Color\alpha<<24)
          EndIf
        EndIf
        
        If \Button\Length
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color[1]\Fore[\Color[1]\State],\Color[1]\Back[\Color[1]\State], \round, \Color\alpha)
          BoxGradient(\Vertical,\X[2],\Y[2],\Width[2],\Height[2],\Color[2]\Fore[\Color[2]\State],\Color[2]\Back[\Color[2]\State], \round, \Color\alpha)
          
          ; Draw buttons frame
          If #PB_2DDrawing_Default = #PB_2DDrawing_Gradient
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\round,\round,\Color[1]\Frame[\Color[1]\State]&$FFFFFF|\Color\alpha<<24)
            RoundBox(\X[2],\Y[2],\Width[2],\Height[2],\round,\round,\Color[2]\Frame[\Color[2]\State]&$FFFFFF|\Color\alpha<<24)
          EndIf
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\X[1]+(\Width[1]-\Size[1])/2,\Y[1]+(\Height[1]-\Size[1])/2, \Size[1], Bool(\Vertical), \Color[1]\Front[\Color[1]\State]&$FFFFFF|\Color\alpha<<24,\Type[1])
          Arrow(\X[2]+(\Width[2]-\Size[2])/2,\Y[2]+(\Height[2]-\Size[2])/2, \Size[2], Bool(\Vertical)+2, \Color[2]\Front[\Color[2]\State]&$FFFFFF|\Color\alpha<<24,\Type[2])
        EndIf
        
        If #PB_2DDrawing_Default = #PB_2DDrawing_Gradient
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line(\X[3]+(\Width[3]-8)/2,\Y[3]+\Height[3]/2-3,9,1,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Color\alpha<<24)
            Line(\X[3]+(\Width[3]-8)/2,\Y[3]+\Height[3]/2,9,1,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Color\alpha<<24)
            Line(\X[3]+(\Width[3]-8)/2,\Y[3]+\Height[3]/2+3,9,1,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Color\alpha<<24)
          Else
            Line(\X[3]+\Width[3]/2-3,\Y[3]+(\Height[3]-8)/2,1,9,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Color\alpha<<24)
            Line(\X[3]+\Width[3]/2,\Y[3]+(\Height[3]-8)/2,1,9,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Color\alpha<<24)
            Line(\X[3]+\Width[3]/2+3,\Y[3]+(\Height[3]-8)/2,1,9,\Color[3]\Front[\Color[3]\State]&$FFFFFF|\Color\alpha<<24)
          EndIf
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i X(*Scroll._s_bar)
    Protected Result.i
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Color\alpha
          Result = \X
        Else
          Result = \X+\Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Y(*Scroll._s_bar)
    Protected Result.i
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Color\alpha
          Result = \Y
        Else
          Result = \Y+\Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Width(*Scroll._s_bar)
    Protected Result.i
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Width And \Color\alpha
          Result = \Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Height(*Scroll._s_bar)
    Protected Result.i
    
    If *Scroll
      With *Scroll
        If Not \Hide[1] And \Height And \Color\alpha
          Result = \Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState(*Scroll._s_bar, ScrollPos.i)
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
  
  Procedure.i SetAttribute(*Scroll._s_bar, Attribute.i, Value.i)
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
  
  Procedure.i SetColor(*Scroll._s_bar, ColorType.i, Color.i, State.i=0, Item.i=0)
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
  
  Procedure.b Resize(*This._s_bar, X.i,Y.i,Width.i,Height.i, *Scroll._s_bar=#Null)
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
  
  Procedure.b Updates(*v._s_bar, *h._s_bar, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
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
  
  Procedure.b Resizes(*v._s_bar, *h._s_bar, X.i,Y.i,Width.i,Height.i )
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
      If *h\round : Resize(*h, #PB_Ignore, #PB_Ignore, *v\x+*v\round/2-1, #PB_Ignore) : EndIf
    EndIf
    If *h\Hide : *h\Page\Pos = 0 : Else
      If *v\round : Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h\y+*v\round/2-1) : EndIf
    EndIf
    
    ProcedureReturn Bool(*v\Hide|*h\Hide)
  EndProcedure
  
  Procedure.b CallBack(*This._s_bar, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0, AutoHide.b=0, *Scroll._s_bar=#Null, Window=-1, Gadget=-1)
    Protected Result, Buttons
    Static LastX, LastY, Last, *Thisis._s_bar, Cursor, Drag, Down
    
    If *This
      If EventType = #PB_EventType_LeftButtonDown
        ;  Debug "CallBack(*This._s_bar)"
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
            If \Color\alpha <> \Color\alpha[1] : \Color\alpha = \Color\alpha[1] 
              Result =- 1
            EndIf 
          EndIf
          If EventType = #PB_EventType_MouseEnter And (*Thisis = *This Or Not *Scroll)
            If \Color\alpha < 255 : \Color\alpha = 255
              
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
  
  Procedure.i Widget(*Scroll._s_bar, X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i, round.i=0)
    
    With *Scroll
      \Color\alpha = 255
      \Color\alpha[1] = 0
      \round = round
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
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, PageLength.i, Flag.i, round.i=0)
    Protected *Widget, *This._s_widget = AllocateStructure(_s_widget)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, x, y, Width, Height, Min, Max, PageLength, Flag, round)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
EndModule
;-

;-
DeclareModule Text
  
  EnableExplicit
  ;UseModule Macros
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
    _this_\Text\String = #LF$
    PostEvent(#PB_Event_Gadget, *This\root\canvas\window, *This\root\canvas\gadget, #PB_EventType_Repaint)
  EndMacro
  
  Macro RemoveItem(_this_, _item_) 
    _this_\Text\Count - 1
    _this_\Text\Change = 1
    If _this_\Text\Count =- 1 
      _this_\Text\Count = 0 
      _this_\Text\String = #LF$
    Else
      _this_\Text\String = RemoveString(_this_\Text\String, StringField(_this_\Text\String, _item_+1, #LF$) + #LF$)
    EndIf
    PostEvent(#PB_Event_Gadget, *This\root\canvas\window, *This\root\canvas\gadget, #PB_EventType_Repaint)
  EndMacro
  
  ;- - DECLAREs PROCEDUREs
  Declare.i AddItem(Gadget.i,Item.i,Text.s,Image.i=-1,Flag.i=0)
  
  Declare.i Draw(*This_s_widget)
   Declare.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  Declare.i CallBack(*Function, *This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Widget(*This._s_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, round.i=0)
  Declare.i ReDraw(*This._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
EndDeclareModule

Module Text
 Macro _clip_output_(_this_, _x_,_y_,_width_,_height_)
    If _x_<>#PB_Ignore : _this_\x[4] = _x_ : EndIf
    If _y_<>#PB_Ignore : _this_\y[4] = _y_ : EndIf
    If _width_<>#PB_Ignore : _this_\width[4] = _width_ : EndIf
    If _height_<>#PB_Ignore : _this_\height[4] = _height_ : EndIf
    
    CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
      ClipOutput(_this_\x[4],_this_\y[4],_this_\width[4],_this_\height[4])
    CompilerEndIf
  EndMacro
  
  ;- MACROS
  ;- PROCEDUREs
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
  
  Procedure AddLine(*This._s_widget,Line.i,String.s) ;,Image.i=-1,Sublevel.i=0)
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
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\Items()\y = _this_\Y[1]+_this_\Text\Y+_this_\Scroll\Height+Text_Y
      _this_\Items()\Height = _this_\Text\Height - Bool(_this_\Text\Count<>1 And _this_\Flag\GridLines)
      _this_\Items()\Text\y = _this_\Items()\y - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\Text\Count<>1)
      _this_\Items()\Text\Height = _this_\Text\Height
      
      _this_\Image\Y = _this_\Y[1]+_this_\Text\Y+Image_Y
    EndMacro
    
    With *This
      \Text\Count = ListSize(\Items())
        
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2
        Height = \Width[1]-\Text\y*2
      Else
        CompilerIf Defined(Scroll, #PB_Module)
          Width = Abs(\Width[1]-\Text\X*2    -Scroll::Width(\scroll\v)) ; bug in linux иногда
          Height = \Height[1]-\Text\y*2      -Scroll::Height(\scroll\h)
        CompilerElse
          Width = \Width[1]-\Text\X*2  
          Height = \Height[1]-\Text\y*2 
        CompilerEndIf
      EndIf
      
;       ; If Not \Text\Height And StartDrawing(CanvasOutput(\root\canvas\gadget)) ; с ним три раза быстрее
;       If StartDrawing(CanvasOutput(\root\canvas\gadget))
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
      \Items()\round = \round
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
      
      ; Scroll width length
      If \Scroll\Width<\Items()\Text\Width
        \Scroll\Width=\Items()\Text\Width
      EndIf
      
      ; Scroll hight length
      \Scroll\Height+\Text\Height
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i MultiLine(*This._s_widget)
    Protected Repaint, String.s, text_width
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *This
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2
        Height = \Width[1]-\Text\y*2
      Else
        CompilerIf Defined(Scroll, #PB_Module)
          Width = Abs(\Width[1]-\Text\X*2    -Scroll::Width(\scroll\v)) ; bug in linux иногда
          Height = \Height[1]-\Text\y*2  -Scroll::Height(\scroll\h)
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
          PostEvent(#PB_Event_Widget, \root\canvas\window, *This, #PB_EventType_Change)
        EndIf
        
        \Text\String.s[2] = String.s
        \Text\Count = CountString(String.s, #LF$)
        
        ; Scroll width reset 
        \Scroll\Width = 0 
        _set_content_Y_(*This)
          
       
        If \Text\Count[1] <> \Text\Count Or \Text\Vertical
          \Text\Count[1] = \Text\Count
          
          ; Scroll hight reset 
          \Scroll\Height = 0
          ClearList(\Items())
          
          If \Text\Vertical
            For IT = \Text\Count To 1 Step - 1
              AddElement(\Items())
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
              
;               ; Указываем какие линии будут видни
;               If Not Bool(\Items()\x >\x[2] And (\Items()\x-\x[2])+\Items()\width<\width[2])
;                 \Items()\Hide = 1
;               EndIf
              
              \Scroll\Height+\Text\Height 
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
                \Items()\round = \round
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
                
               
;                 ; Is visible lines
;                 \Items()\Hide = Bool(Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
                
                ; Scroll width length
                If \Scroll\Width<\Items()\Text\Width
                  \Scroll\Width=\Items()\Text\Width
                EndIf
                
                ; Scroll hight length
                \Scroll\Height+\Text\Height
                
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
                
                ; Set scroll width length
                If \Scroll\Width<\Items()\Text\Width
                  \Scroll\Width=\Items()\Text\Width
                EndIf
              EndIf
              
              ; Update line pos in the text
              \Items()\Text\Position = \Text\Position
              \Items()\Text\Len = Len(String.s)
              \Text\Position + \Items()\Text\Len + 1 ; Len(#LF$)
              
              
              _line_resize_X_(*This)
              
;               ; Is visible lines ---
;               \Items()\Hide = Bool(Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
                
            EndIf
          Next
        EndIf
      Else
        ; Scroll hight reset 
        \Scroll\Height = 0
        _set_content_Y_(*This)
        
;         ; Это для второго способа добавления линии
;         If \Text\String.s[2] = \Text\String.s
;           String.s = ""
;         EndIf
      
        PushListPosition(\Items())
        ForEach \Items()
          _set_content_X_(*This)
          _line_resize_X_(*This)
          _line_resize_Y_(*This)
          
          ; Scroll hight length
          \Scroll\Height + \Text\Height
          
;           ; Is visible lines
;           \Items()\Hide = Bool(Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
                
;           If \Text\String.s[2] = \Text\String.s
;             If String.s
;               String.s +#LF$+ \Items()\Text\String.s 
;             Else
;               String.s + \Items()\Text\String.s
;             EndIf
;           EndIf
        Next
        
;         If \Text\String.s[2] = \Text\String.s And
;            \Text\String.s <> String.s+#LF$
;           \Text\String.s = String.s+#LF$
;           \Text\Len = Len(String.s+#LF$)
;          ; Debug "new add texts len "+\Text\Len
;         EndIf
        
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
  
  Procedure.i Draw(*This._s_widget)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    
    If Not *This\Hide
      
      With *This
        iX=\X[2]
        iY=\Y[2]
        CompilerIf Defined(Scroll, #PB_Module)
          iwidth = *This\width[2]-Scroll::Width(*This\scroll\v)
          iheight = *This\height[2]-Scroll::Height(*This\scroll\h)
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
            Debug "   resize "+\Resize
            ; Посылаем сообщение об изменении размера 
            PostEvent(#PB_Event_Widget, \root\canvas\window, *This, #PB_EventType_Resize, \Resize)
          EndIf
          If \Text\Change
            \Text\Height = TextHeight("A") + Bool(\Text\Count<>1 And \Flag\GridLines)
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          MultiLine(*This)
        EndIf 
        
        _clip_output_(*This, \X,\Y,\Width,\Height)
        
        ; Draw back color
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\round,\round,\Color\Back[\Color\State])
      EndWith 
      
      ; Draw items text
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            \Hide = Bool( Not Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
            
            If Not \Hide
              Height = \Height
              Y = \Y+*This\Scroll\Y
              Text_X = \Text\X+*This\Scroll\X
              Text_Y = \Text\Y+*This\Scroll\Y
                
              If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
              _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
              
;               ; Scroll width length
;               If *This\Text\Change 
;                 \Text\Change = 1
;                 \Text[1]\Change = 1
;                 \Text[2]\Change = 1
;                 \Text[3]\Change = 1
;                 
;                 If *This\Scroll\Width<*This\Text\X*2+\Text\Width
;                   *This\Scroll\Width=*This\Text\X*2+\Text\Width
;                 EndIf
;               EndIf
              
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
              If \Item=*This\Line Or \Item=\focus Or \Item=\line ; \Color\State;
                ; Draw items back color
                  DrawingMode(#PB_2DDrawing_Default)
                  RoundBox(*This\X[2],Y,iwidth,\Height,\round,\round,\Color\Back[\Color\State])
                
                DrawingMode(#PB_2DDrawing_Outlined)
                RoundBox(*This\x[2],Y,iwidth,\height,\round,\round, \Color\Frame[\Color\State])
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, \Image\x, \Image\y+*This\Scroll\Y, \Color\alpha)
              EndIf
              
              ; Draw text
              If 1;\Text\String.s
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
                
                
                  If \Text[2]\Len > 0
                    DrawingMode(#PB_2DDrawing_Default)
                    Box((\Text[2]\X+*This\Scroll\X), Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
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
          
          
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(*This\Items())
          ; Draw scroll bars
          CompilerIf Defined(Scroll, #PB_Module)
            UnclipOutput()
            If \scroll\v\Page\Length And \scroll\v\Max<>\Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines) And
               Scroll::SetAttribute(\scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines))
              Scroll::Resizes(\scroll\v, \scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            If \scroll\h\Page\Length And \scroll\h\Max<>\Scroll\Width And
               Scroll::SetAttribute(\scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
              Scroll::Resizes(\scroll\v, \scroll\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            
            Scroll::Draw(\scroll\v)
            Scroll::Draw(\scroll\h)
            
            ;           ; >>>|||
            ;           If \Scroll\Widget\Vertical\Page\Length And \Scroll\Widget\Vertical\Max<>\Scroll\Height And
            ;              Scroll::SetAttribute(\Scroll\Widget\Vertical, #PB_ScrollBar_Maximum, \Scroll\Height)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           If \Scroll\Widget\Horizontal\Page\Length And \Scroll\Widget\Horizontal\Max<>\Scroll\Width And
            ;              Scroll::SetAttribute(\Scroll\Widget\Horizontal, #PB_ScrollBar_Maximum, \Scroll\Width)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           Scroll::Draw(\Scroll\Widget\Vertical)
            ;           Scroll::Draw(\Scroll\Widget\Horizontal)
          CompilerEndIf
          
          _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
          
          ; Draw image
          If \Image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \Color\alpha)
          EndIf
        EndIf
      
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        
        Macro _frame_(_this_, _x_,_y_,_width_,_height_, _color_1_, _color_2_);, _round_=0)
    ClipOutput(_x_-1,_y_-1,_width_+1,_height_+1)
    RoundBox(_x_-1,_y_-1,_width_+2,_height_+2, _this_\round,_this_\round, _color_1_)  
    
    ClipOutput(_x_+_this_\round/3,_y_+_this_\round/3,_width_+2,_height_+2)
    RoundBox(_x_-1,_y_-1,_width_+2,_height_+2,_this_\round,_this_\round, _color_2_)  
    
;     If _round_ And _this_\round : RoundBox(_x_,_y_-1,_width_,_height_+1,_this_\round,_this_\round,_color_1_) : EndIf  ; Сглаживание краев )))
;     If _round_ And _this_\round : RoundBox(_x_-1,_y_-1,_width_+1,_height_+1,_this_\round,_this_\round,_color_1_) : EndIf  ; Сглаживание краев )))
    
    UnclipOutput() : _clip_output_(_this_, _this_\X[1]-1,_this_\Y[1]-1,_this_\Width[1]+2,_this_\Height[1]+2)
  EndMacro
  
        If \Focus = *This
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\round,\round,\Color\Frame[2])
          If \round : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\round,\round,\Color\Frame[2]) : EndIf  ; Сглаживание краев )))
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\round,\round,\Color\Frame[2])
        ElseIf \fs
          Select \fs[1] 
            Case 1 ; Flat
              RoundBox(iX-1,iY-1,iWidth+2,iHeight+2,\round,\round, $FFE1E1E1)  
              
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
              If \round : RoundBox(iX-1,iY-1-1,iWidth+2,iHeight+2+1,\round,\round,$FF888888) : EndIf  ; Сглаживание краев )))
              If \round : RoundBox(iX-2,iY-1-1,iWidth+3,iHeight+2+1,\round,\round,$FF888888) : EndIf  ; Сглаживание краев )))
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
              If \round : RoundBox(iX-1,iY-1,iWidth+3,iHeight+2+1,\round,\round,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              If \round : RoundBox(iX-1,iY-1,iWidth+2,iHeight+2+1,\round,\round,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FFFFFFFF, $FF888888)
              
              
            Default 
              RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\round,\round,\Color\Frame[\Color\State])
              
          EndSelect
        EndIf
        
        If \Default
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\round,\round, $FFF1F1FF)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\round,\round,$FF004DFF)
            If \round 
              RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\round,\round,$FF004DFF)
            EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\round,\round,$FF004DFF)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText((\Width[1]-TextWidth("!!! Недопустимый символ"))/2, \Items()\Text[0]\Y, "!!! Недопустимый символ", $FF0000FF)
          Else
            ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\round,\round,\Color\Frame[2])
            ;           If \round : RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\round,\round,\Color\Frame[2]) : EndIf ; Сглаживание краев )))
            ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\round,\round,\Color\Frame[2])
          EndIf
        EndIf
        
          If \Text\Change : \Text\Change = 0 : EndIf
          If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i ReDraw(*This._s_widget, Canvas =- 1, BackColor=$FFF0F0F0)
    If *This
      With *This
        If Canvas =- 1 
          Canvas = \root\canvas\gadget 
        ElseIf Canvas <> \root\canvas\gadget
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
            If Canvas = \root\canvas\gadget
              Draw(List()\Widget)
            EndIf
          Next
        EndWith
        
        StopDrawing()
      EndIf
    EndIf
  EndProcedure
  
  ;-
  Procedure.i AddItem(Gadget.i,Item.i,Text.s,Image.i=-1,Flag.i=0)
    Protected *This._s_widget, *Item
    If IsGadget(Gadget) : *This._s_widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        ;{ Генерируем идентификатор
        If Item < 0 Or Item > ListSize(\Items()) - 1
          LastElement(\Items())
          *Item = AddElement(\Items()) 
          Item = ListIndex(\Items())
        Else
          SelectElement(\Items(), Item)
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
          AddLine(*This, Item.i, Text.s)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *Item
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
      If Canvas = \root\canvas\gadget
        \root\canvas\window = EventWindow()
      Else
        ProcedureReturn
      EndIf
      
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
      
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.i Events(*Function, *This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static *Last._s_widget, *Widget._s_widget    ; *Focus._s_widget, 
    Static Text$, DoubleClick, LastX, LastY, Last, Drag
    Protected.i Result, Repaint, Control, Buttons, Widget
    Macro From(_this_, _buttons_=0)
    Bool(_this_\root\Mouse\X>=_this_\x[_buttons_] And _this_\root\Mouse\X<_this_\x[_buttons_]+_this_\Width[_buttons_] And 
         _this_\root\Mouse\Y>=_this_\y[_buttons_] And _this_\root\Mouse\Y<_this_\y[_buttons_]+_this_\Height[_buttons_])
  EndMacro
  
    ; widget_events_type
    If *This
      With *This
        If Canvas=-1 
          Widget = *This
          Canvas = EventGadget()
        Else
          Widget = Canvas
        EndIf
;         If Canvas <> \root\canvas\gadget
;           ProcedureReturn 
;         EndIf
        
        ; Get at point widget
        \root\Mouse\From = From(*This)
        
        Select EventType 
          Case #PB_EventType_LeftButtonUp 
            If *Last = *This
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick 
            ; Debug ""+\root\Mouse\Buttons+" Last - "+*Last +" Widget - "+*Widget +" Focus - "+*Focus +" This - "+*This
            If *Last = *This : *Last = *Widget
              If *Widget <> *Focus
                ProcedureReturn 0 
              EndIf
            EndIf
            
            If Not *This\root\Mouse\From 
              ProcedureReturn 0
            EndIf
        EndSelect
        
        If Not \Hide And \Interact And Widget <> Canvas And CanvasModifiers 
          Select EventType 
            Case #PB_EventType_Focus : ProcedureReturn 0 ; Bug in mac os because it is sent after the mouse left down
            Case #PB_EventType_MouseMove, #PB_EventType_LeftButtonUp
              If Not \root\Mouse\Buttons 
                If \root\Mouse\From
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
                    Events(*Function, List()\Widget, #PB_EventType_LostFocus, List()\Widget\root\canvas\gadget, 0)
                    *Last = *Widget 
                    
                    ; 
                    PostEvent(#PB_Event_Gadget, List()\Widget\root\canvas\window, List()\Widget\root\canvas\gadget, #PB_EventType_Repaint)
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
              If Not \root\Mouse\Delta
                \root\Mouse\Delta = AllocateStructure(Mouse_S)
                \root\Mouse\Delta\X = \root\Mouse\X
                \root\Mouse\Delta\Y = \root\Mouse\Y
                \root\Mouse\Delta\From = \root\Mouse\From
                \root\Mouse\Delta\Buttons = \root\Mouse\Buttons
              EndIf
              
            Case #PB_EventType_LeftButtonUp : \Drag = 0
              FreeStructure(\root\Mouse\Delta) : \root\Mouse\Delta = 0
              
            Case #PB_EventType_MouseMove
              If \Drag = 0 And \root\Mouse\Buttons And \root\Mouse\Delta And 
                 (Abs((\root\Mouse\X-\root\Mouse\Delta\X)+(\root\Mouse\Y-\root\Mouse\Delta\Y)) >= 6) : \Drag=1
                ; PostEvent(#PB_Event_Widget, \root\canvas\window, \root\canvas\gadget, #PB_EventType_DragStart)
              EndIf
              
            Case #PB_EventType_MouseLeave
              If CanvasModifiers 
                ; Если перешли на другой виджет
                PushListPosition(List())
                ForEach List()
                  If List()\Widget\root\canvas\gadget = Canvas And List()\Widget\Focus <> List()\Widget And List()\Widget <> *This
                    List()\Widget\root\Mouse\From = From(List()\Widget)
                    
                    If List()\Widget\root\Mouse\From
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
              
              If \Cursor[1] <> GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor)
                SetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor, \Cursor[1])
                \Cursor[1] = 0
              EndIf
              
            Case #PB_EventType_MouseEnter    
              If Not \Cursor[1] 
                \Cursor[1] = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor)
              EndIf
              SetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor, \Cursor)
              
            Case #PB_EventType_MouseMove ; bug mac os
              If \root\Mouse\Buttons And #PB_Compiler_OS = #PB_OS_MacOS ; And \Cursor <> GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor)
                                                                          ; Debug 555
                SetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Cursor, \Cursor)
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
            \root\keyboard\input = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Input)
            \root\keyboard\key[1] = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
            \root\keyboard\key = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Key)
            \root\keyboard\key[1] = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            \root\Mouse\X = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseX)
            \root\Mouse\Y = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Linux
              \root\Mouse\Buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                      (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                      (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
            CompilerElse
              \root\Mouse\Buttons = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_Buttons)
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
  
  Procedure Widget(*This._s_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, round.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Text
        \Cursor = #PB_Cursor_Default
        #PB_2DDrawing_Default = #PB_2DDrawing_Default
        \root\canvas\gadget = Canvas
        \root\canvas\window = GetActiveWindow()
        \round = round
        \Color\alpha = 255
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
        
        \fs = Bool(Not Flag&#PB_Flag_BorderLess)
        \bs = \fs
        
        If Resize(*This, X,Y,Width,Height, Canvas)
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
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
            \Text\X = \fs 
            \Text\y = \fs+1+Bool(Flag&#PB_Text_WordWrap)*4 ; 2,6,12
          Else
            \Text\X = \fs+1+Bool(Flag&#PB_Text_WordWrap)*4 ; 2,6,12 
            \Text\y = \fs
          EndIf
          
          \Color = Colors
          \Color\Back = \Color\Fore
          \Color\Fore = 0
          
          If Not \bs
            \Color\Frame = \Color\Back
          EndIf
          

          \Resize = 0
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
EndModule


DeclareModule ListView
  EnableExplicit
 ; UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  
  ;- - DECLAREs MACROs
  Macro ClearItems(_gadget_)
    Text::ClearItems(_gadget_)
  EndMacro
  
  Macro CountItems(_gadget_)
    Text::CountItems(_gadget_)
  EndMacro
  
  Macro RemoveItem(_gadget_, _item_)
    Text::RemoveItem(_gadget_, _item_)
  EndMacro
  
  Macro AddItem(_gadget_,_item_,_text_,_image_=-1,_flag_=0)
    Text::AddItem(_gadget_,_item_,_text_,_image_,_flag_)
  EndMacro
  
  Macro SetText(_gadget_,_text_)
    Text::SetText(_gadget_,_text_,0)
  EndMacro
  
  
  Macro GetText(_gadget_)
    Text::GetText(GetGadgetData(_gadget_))
  EndMacro
  
  ;- DECLAREs PROCEDUREs
  Declare.i SetFont(*This._s_widget, FontID.i)
  Declare.i SetState(Gadget.i, State.i)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, round.i=0)
  Declare.i CallBack(*This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare.i SetItemState(Gadget.i, Item.i, State.i)
EndDeclareModule

Module ListView
  ;-
  ;- PROCEDUREs
  ;-
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
  
  Procedure.i SetItemState(Gadget.i, Item.i, State.i)
    Protected Result, *This._s_widget = GetGadgetData(Gadget)
    
    With *This
      If (\Flag\MultiSelect Or \Flag\ClickSelect)
        PushListPosition(\Items())
        Result = SelectElement(\Items(), Item) 
        If Result 
          \Items()\Color\State = Bool(State)+1
          \Items()\Line = \Items()\Item
          PostEvent(#PB_Event_Gadget, \root\canvas\window, \root\canvas\gadget, #PB_EventType_Repaint)
        EndIf
        PopListPosition(\Items())
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(Gadget.i, State.i)
    Protected *This._s_widget = GetGadgetData(Gadget)
    
    With *This
      Text::Redraw(*This, \root\canvas\gadget)
      
      PushListPosition(\Items())
      ChangeCurrentElement(\Items(), SetItemState(Gadget, State, 2)) : \Items()\Focus = State
      Scroll::SetState(\scroll\v, (State*\Text\Height)-\scroll\v\Height + \Text\Height) : \Scroll\Y =- \scroll\v\Page\Pos
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
;   Procedure.i SetState(Gadget.i, State.i)
;     Protected *This._s_widget = GetGadgetData(Gadget)
;     
;     With *This
;       Text::Redraw(*This, \root\canvas\gadget)
;       
;       PushListPosition(\Items())
;       SelectElement(\Items(), State) : \Items()\Focus = State : \Items()\Color\State = 2
;       Scroll::SetState(\scroll\v, (State*\Text\Height)-\scroll\v\Height + \Text\Height) : \Scroll\Y =- \scroll\v\Page\Pos
;       PostEvent(#PB_Event_Gadget, \root\canvas\window, \root\canvas\gadget, #PB_EventType_Repaint)
;       PopListPosition(\Items())
;     EndWith
;   EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected Result, *This._s_widget = GetGadgetData(Gadget)
    
    With *This
;       PushListPosition(\Items())
;       SelectElement(\Items(), State) 
;       Result = \Items()\Color\State 
;       PopListPosition(\Items())
    EndWith
    
   ProcedureReturn Result
 EndProcedure
  
  Procedure.i Resize(*This._s_widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *This
      If Text::Resize(*This, X,Y,Width,Height)
        Scroll::Resizes(\scroll\v, \scroll\h, \x[2],\Y[2],\Width[2],\Height[2])
      EndIf
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.i Events(*This._s_widget, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\scroll\v, EventType, \root\Mouse\X, \root\Mouse\Y,0, 0, \scroll\h, \root\canvas\window, \root\canvas\gadget)
      If Repaint
        \Scroll\Y =- \scroll\v\Page\Pos
      EndIf
      Repaint | Scroll::CallBack(\scroll\h, EventType, \root\Mouse\X, \root\Mouse\Y,0, 0, \scroll\v, \root\canvas\window, \root\canvas\gadget)
      If Repaint
        \Scroll\X =- \scroll\h\Page\Pos
      EndIf
    EndWith
    
    If *This And (Not *This\scroll\v\Buttons And Not *This\scroll\h\Buttons)
      If ListSize(*This\items())
        With *This
          If Not \Hide And \Interact
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\root\keyboard\key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\root\keyboard\key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType 
              Case #PB_EventType_LeftClick : PostEvent(#PB_Event_Widget, \root\canvas\window, *This, #PB_EventType_LeftClick)
              Case #PB_EventType_RightClick : PostEvent(#PB_Event_Widget, \root\canvas\window, *This, #PB_EventType_RightClick)
              Case #PB_EventType_LeftDoubleClick : PostEvent(#PB_Event_Widget, \root\canvas\window, *This, #PB_EventType_LeftDoubleClick)
                
              Case #PB_EventType_MouseLeave
                \Line =- 1
                
              Case #PB_EventType_LeftButtonDown
                PushListPosition(\Items()) 
                ForEach \Items()
                  If \Line = \Items()\Item 
                    \Line[1] = \Line
                    
                    If \Flag\ClickSelect
                      \Items()\Color\State ! 2
                    Else
                       \Items()\Line = \Items()\Item
                       \Items()\Color\State = 2
                    EndIf
                    
                    ; \Items()\Focus = \Items()\Item 
                  ElseIf ((Not \Flag\ClickSelect And \Items()\Focus = \Items()\Item) Or \Flag\MultiSelect) And Not Control
                    \Items()\Line =- 1
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
                    If (Not \Flag\MultiSelect And Not \Flag\ClickSelect)
                      \items()\Color\State = 1
                    EndIf
                  EndIf
                Next
                PopListPosition(\Items()) 
                Repaint = 1
                
              Case #PB_EventType_MouseMove  
                If \root\Mouse\Y < \Y Or \root\Mouse\X > Scroll::X(\scroll\v)
                  Item.i =- 1
                ElseIf \Text\Height
                  Item.i = ((\root\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
                EndIf
                
                If \Line <> Item And Item =< ListSize(\Items())
                  Macro isItem(_item_, _list_)
    Bool(_item_ >= 0 And _item_ < ListSize(_list_))
  EndMacro
  Macro itemSelect(_item_, _list_)
    Bool(isItem(_item_, _list_) And _item_ <> ListIndex(_list_) And SelectElement(_list_, _item_))
  EndMacro
  
  If isItem(\Line, \Items()) 
                    If \Line <> ListIndex(\Items())
                      SelectElement(\Items(), \Line) 
                    EndIf
                    
                    If \root\Mouse\Buttons & #PB_Canvas_LeftButton 
                      If (\Flag\MultiSelect And Not Control)
                       \items()\Color\State = 2
                      ElseIf Not \Flag\ClickSelect
                        \items()\Color\State = 1
                      EndIf
                    EndIf
                  EndIf
                  
                  If \root\Mouse\Buttons & #PB_Canvas_LeftButton And itemSelect(Item, \Items())
                    If Not \Flag\ClickSelect And (\Flag\MultiSelect And Not Control)
                       \Items()\Line = \Items()\Item
                       \items()\Color\State = 2
                    EndIf
                  EndIf
                  
                  \Line = Item
                   Repaint = #True
                EndIf
                
                If \root\Mouse\Buttons & #PB_Canvas_LeftButton
                  If (\Flag\MultiSelect And Not Control)
                    PushListPosition(\Items()) 
                    ForEach \Items()
                      If  Not \Items()\Hide
                        If ((\Line[1] =< \Line And \Line[1] =< \Items()\Item And \Line >= \Items()\Item) Or
                            (\Line[1] >= \Line And \Line[1] >= \Items()\Item And \Line =< \Items()\Item)) 
                          If \Items()\Line <> \Items()\Item
                            \Items()\Line = \Items()\Item
                            \items()\Color\State = 2
                          EndIf
                        Else
                          \Items()\Line =- 1
                          \Items()\Color\State = 1
                          \Items()\Focus =- 1
                        EndIf
                      EndIf
                    Next
                    PopListPosition(\Items()) 
                  EndIf
                
; ; ;                   If \Line[1] =< \Line
; ; ;                     PushListPosition(\Items()) 
; ; ;                     While PreviousElement(\Items()) And \Line[1] < \Items()\Item And Not \Items()\Hide
; ; ;                       If \Items()\Line <> \Items()\Item
; ; ;                         \Items()\Line = \Items()\Item
; ; ;                         \items()\Color\State = 2
; ; ;                       EndIf
; ; ;                     Wend
; ; ;                     PopListPosition(\Items()) 
; ; ;                     PushListPosition(\Items()) 
; ; ;                     While NextElement(\Items()) And \Items()\Line = \Items()\Item And Not \Items()\Hide
; ; ;                       \Items()\Line =- 1
; ; ;                       \Items()\Color\State = 1
; ; ;                       \Items()\Focus =- 1
; ; ;                     Wend
; ; ;                     PopListPosition(\Items()) 
; ; ;                     PushListPosition(\Items()) 
; ; ;                     If \Line[1] = \Line And PreviousElement(\Items()) And \Items()\Line = \Items()\Item And Not \Items()\Hide
; ; ;                       \Items()\Line =- 1
; ; ;                       \Items()\Color\State = 1
; ; ;                       \Items()\Focus =- 1
; ; ;                     EndIf
; ; ;                     PopListPosition(\Items()) 
; ; ;                   ElseIf \Line[1] > \Line
; ; ;                     PushListPosition(\Items()) 
; ; ;                     While NextElement(\Items()) And \Line[1] > \Items()\Item And Not \Items()\Hide
; ; ;                       If \Items()\Line <> \Items()\Item
; ; ;                         \Items()\Line = \Items()\Item
; ; ;                         \items()\Color\State = 2
; ; ;                       EndIf
; ; ;                     Wend
; ; ;                     PopListPosition(\Items()) 
; ; ;                     PushListPosition(\Items()) 
; ; ;                     While PreviousElement(\Items()) And \Items()\Line = \Items()\Item And Not \Items()\Hide
; ; ;                       \Items()\Line =- 1
; ; ;                       \Items()\Color\State = 1
; ; ;                       \Items()\Focus =- 1
; ; ;                     Wend
; ; ;                     PopListPosition(\Items()) 
; ; ;                   EndIf
                EndIf
                
              Default
                itemSelect(\Line[1], \Items())
            EndSelect
          EndIf
        EndWith    
        
        With *This\items()
          If *Focus = *This
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\root\keyboard\key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\root\keyboard\key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType
              Case #PB_EventType_KeyUp
              Case #PB_EventType_KeyDown
                Select *This\root\keyboard\key
                  Case #PB_Shortcut_V
                EndSelect 
                
            EndSelect
          EndIf
          
          
        EndWith
      EndIf
    Else
      *This\Line =- 1
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This._s_widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Widget(*This._s_widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, round.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_ListView
        \Cursor = #PB_Cursor_Default
        
        \root = AllocateStructure(_s_root)
        \root\canvas\gadget = Canvas
        \root\canvas\window = GetActiveWindow()
        \round = round
        \Interact = 1
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
        
        \fs = Bool(Not Flag&#PB_Flag_BorderLess)+1
        \bs = \fs
        
        If Text::Resize(*This, X,Y,Width,Height, Canvas)
          \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
          \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
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
          
          \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If \Text\Vertical
              \Text\X = \fs 
              \Text\y = \fs+5
            Else
              \Text\X = \fs+5
              \Text\y = \fs
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If \Text\Vertical
              \Text\X = \fs 
              \Text\y = \fs+1
            Else
              \Text\X = \fs+1
              \Text\y = \fs
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If \Text\Vertical
              \Text\X = \fs 
              \Text\y = \fs+6
            Else
              \Text\X = \fs+6
              \Text\y = \fs
            EndIf
          CompilerEndIf 
          
          \Text\Change = 1
          \Color = Colors
          \Color\Fore[0] = 0
          \Color\alpha = 255
        
          If \Text\Editable
            \Text\Editable = 0
            \Color[0]\Back[0] = $FFFFFFFF 
          Else
            \Color[0]\Back[0] = $FFF0F0F0  
          EndIf
          
        EndIf
        
        Scroll::Widget(\scroll\v, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        Scroll::Resizes(\scroll\v, \scroll\h, \x[2],\Y[2],\Width[2],\Height[2])
        \Resize = 0
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, round.i=0)
    Protected *Widget, *This._s_widget = AllocateStructure(_s_widget)
    
    If *This
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
  add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, round)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint, *This._s_widget = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint : Repaint = 1
        Case #PB_EventType_Resize : ResizeGadget(\root\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\root\canvas\gadget), GadgetHeight(\root\canvas\gadget))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
        Text::ReDraw(*This)
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
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
EndModule

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile

If OpenWindow(0, 100, 50, 530, 700, "ListViewGadget", #PB_Window_SystemMenu)
  ListViewGadget(0, 10, 10, 250, 680, #PB_ListView_MultiSelect)
  ListView::Gadget(1, 270, 10, 250, 680, #PB_Flag_FullSelection|#PB_Flag_GridLines|#PB_Flag_MultiSelect)
  LN = 150
  
  For a = 0 To LN
    ListView::AddItem (1, -1, "Item "+Str(a), 0,1)
  Next
;   Define time = ElapsedMilliseconds()
;   For a = 0 To LN
;     ListView::SetItemState(1, a, 1) ; set (beginning with 0) the tenth item as the active one
;     If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
;     EndIf
;     If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
;       Debug a
;     EndIf
;   Next
;   Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + Text::CountItems(1)
  
  Text::Redraw(GetGadgetData(1), 1)
  
  ; HideGadget(0, 1)
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0, Random(5)+1)
  Next
;   Define time = ElapsedMilliseconds()
;   For a = 0 To LN
;     SetGadgetItemState(0, a, 1) ; set (beginning with 0) the tenth item as the active one
;     If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
;     EndIf
;     If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
;       Debug a
;     EndIf
;   Next
;   Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
  ; HideGadget(0, 0)
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf

  
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s;=#LF$
  
  Text.s = "This is a long line" + m.s +
           "Who should show," + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long" + m.s +
           "Otherwise it will not work."
  
  Procedure ResizeCallBack()
    ;ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
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
  
  If OpenWindow(0, 0, 0, 422, 491, "ListViewGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ;ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    ListViewGadget(0, 8, 8, 306, 233) ;: SetGadgetText(0, Text.s) 
    For a = 0 To 2
      AddGadgetItem(0, a, "Line "+Str(a)+ " of the Listview")
    Next
    AddGadgetItem(0, a, Text)
    For a = 4 To 16
      AddGadgetItem(0, a, "Line "+Str(a)+ " of the Listview")
    Next
    SetGadgetFont(0, FontID(0))
    
    
    g=16
    ListView::Gadget(g, 8, 133+5+8, 306, 233, #PB_Flag_GridLines) ;: ListView::SetText(g, Text.s) 
    For a = 0 To 2
      ListView::AddItem(g, a, "Line "+Str(a)+ " of the Listview")
    Next
    ListView::AddItem(g, a, Text)
    For a = 4 To 16
      ListView::AddItem(g, a, "Line "+Str(a)+ " of the Listview")
    Next
    ListView::SetFont(g, FontID(0))
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    ; Debug "высота "+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E._s_widget = GetGadgetData(g)
                
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
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -------------------------------------------------------------------------
; EnableXP