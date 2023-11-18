DeclareModule Macros
  Macro From(_this_, _buttons_=0)
    Bool(canvasaddress\Mouse\X>=_this_\x[_buttons_] And canvasaddress\Mouse\X<_this_\x[_buttons_]+_this_\Width[_buttons_] And 
         canvasaddress\Mouse\Y>=_this_\y[_buttons_] And canvasaddress\Mouse\Y<_this_\y[_buttons_]+_this_\Height[_buttons_])
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
      _hande_ = InsertElement(List())
      
      PushListPosition(List())
      While NextElement(List())
        List()\Widget\Index = ListIndex(List())
      Wend
      PopListPosition(List())
    EndIf
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
  
  Macro Colors(_adress_, _i_, _ii_, _iii_)
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
    
    Colors(_adress_, 0, 1, 0)
    
    ;     Colors(_adress_, 1, 1, 0)
    ;     Colors(_adress_, 2, 1, 0)
    ;     Colors(_adress_, 3, 1, 0)
    ;     
    ;     Colors(_adress_, 1, 1, 1)
    ;     Colors(_adress_, 2, 1, 1)
    ;     Colors(_adress_, 3, 1, 1)
    ;     
    ;     Colors(_adress_, 1, 2, 2)
    ;     Colors(_adress_, 2, 2, 2)
    ;     Colors(_adress_, 3, 2, 2)
    ;     
    ;     Colors(_adress_, 1, 3, 3)
    ;     Colors(_adress_, 2, 3, 3)
    ;     Colors(_adress_, 3, 3, 3)
    
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


DeclareModule Constants
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
    #PB_Text_Bottom = 4
    #PB_Text_Middle 
    
    #PB_Text_Vertical
    #PB_Text_Numeric
    
    #PB_Text_LowerCase 
    #PB_Text_UpperCase
    #PB_Text_Password
    
    #PB_Text_ReadOnly
    #PB_Text_WordWrap
    #PB_Text_MultiLine 
    
    #PB_Text_Left
    #PB_Text_Top
    
    #PB_Widget_Default
    #PB_Widget_Toggle
    
    #PB_Widget_BorderLess
    #PB_Widget_Double
    #PB_Widget_Flat
    #PB_Widget_Raised
    #PB_Widget_Single
    
    #PB_Widget_Invisible
  EndEnumeration
  
  
  
  #NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  
  #CheckBoxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
  #ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    #BorderSingle = 4
    #BorderDouble = 8
  CompilerElse
    #BorderSingle = 256 ; 4
    #BorderDouble = 65535 ; 8
  CompilerEndIf
  
  #BorderFlat = 16    
  #AlwaysShowSelection = 32 ; #PB_Tree_AlwaysShowSelection ; 0 32 Even If the gadget isn't activated, the selection is still visible.
  #BorderLess = 64
  #BorderRaised = 128  
  
  
  #Selected = #PB_Tree_Selected                       ; 1
  #Checked = #PB_Tree_Checked                         ; 4
  #Expanded = #PB_Tree_Expanded                       ; 2
  #Collapsed = #PB_Tree_Collapsed                     ; 8
  
  #FullSelection = 512 ; #PB_ListIcon_FullRowSelect
  
  #SmallIcon = #PB_ListIcon_LargeIcon                 ; 0 0
  #LargeIcon = #PB_ListIcon_SmallIcon                 ; 1 1
  
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

DeclareModule Structures
  
  ;- STRUCTURE
  Structure COORDINATE
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  Structure MOUSE
    X.i
    Y.i
    From.i ; at point widget
    Buttons.i
  EndStructure
  
  Structure ALIGN
    Right.b
    Bottom.b
    Vertical.b
    Horisontal.b
  EndStructure
  
  Structure PAGE
    Pos.i
    Length.i
    ScrollStep.i
  EndStructure
  
  Structure CANVAS
    Mouse.MOUSE
    Gadget.i
    Window.i
    *activeWidget.Widget_S
    Input.c
    Key.i[2]
  EndStructure
  
  Structure COLOR
    Front.i[4]
    Fore.i[4]
    Back.i[4]
    Line.i[4]
    Frame.i[4]
    Arrows.i[4]
  EndStructure
  
  Structure IMAGE Extends Coordinate
    handle.i[2]
    change.b
  EndStructure
  
  Structure TEXT Extends COORDINATE
    ;     Char.c
    Len.i
    FontID.i
    String.s[3]
    CountString.i
    Change.b
    
    Align.ALIGN
    
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    ; WordWrap.b
    MultiLine.b
    Vertical.b
    Rotate.f
    
    Mode.i
  EndStructure
  
  Structure SCROLL Extends COORDINATE
    Window.i
    Gadget.i
    
    Max.i
    Min.i
    
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
    
    Page.PAGE
    Area.PAGE
    Thumb.PAGE
    Button.PAGE
    Color.COLOR[4]
  EndStructure
  
  Structure Widget_S Extends COORDINATE
    Index.i  ; Index of new list element
    Handle.i ; Adress of new list element
    
    *Widget.Widget_S
    
    Color.COLOR[4]
    Text.TEXT[4]
    
    fSize.i
    bSize.i
    Hide.b[2]
    Disable.b[2]
    Cursor.i[2]
    
    Caret.i[2] ; 0 = Pos ; 1 = PosFixed
    Line.i[2] ; 0 = Pos ; 1 = PosFixed
    
    
    Type.i
    
    From.i  ; at point widget | item
    Focus.i
    LostFocus.i
    
    Drag.b
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
    box.Coordinate
    *data
    collapsed.b
    childrens.i
    Item.i
    Attribute.l
    change.b
    flag.i
    Image.IMAGE
    
    Scroll.SCROLL
    vScroll.SCROLL
    hScroll.SCROLL
    
    *Default
    Alpha.a[2]
    
    DrawingMode.i
    
    List Items.Widget_S()
    List Columns.Widget_S()
    
  EndStructure
  
  Global canvasaddress.CANVAS
  Global NewList List.Widget_S()
  Global Use_List_Canvas_Gadget
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Macros
  UseModule Constants
  UseModule Structures
  
  
  ;-
DeclareModule Text
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  
  ;- - DECLAREs PROCEDUREs
  Declare.i Draw(*thisWidget_S, Canvas.i=-1)
  Declare.s GetText(*this.Widget_S)
  Declare.i SetText(*this.Widget_S, Text.s)
  Declare.i GetFont(*this.Widget_S)
  Declare.i SetFont(*this.Widget_S, FontID.i)
  Declare.i GetColor(*this.Widget_S, ColorType.i, State.i=0)
  Declare.i SetColor(*this.Widget_S, ColorType.i, Color.i, State.i=1)
  Declare.i Resize(*this.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  Declare.i CallBack(*Function, *this.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Widget(*this.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
  
EndDeclareModule

Module Text
  
  ;- MACROS
  ;- PROCEDUREs
  Procedure.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
    Protected line$, ret$="", LineRet$=""
    Protected.i CountString, i, start, ii, found, length
    
    Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    Text.s = ReplaceString(Text.s, #CR$, #LF$)
    Text.s + #LF$
    
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
            If mode =- 1 And CountString(Left((line$),ii), " ") > 1     And width > 71 ; button
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
      
      ret$ +  LineRet$ + line$ + nl$
      LineRet$=""
    Next
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  Procedure.i Draw(*this.Widget_S, Canvas.i=-1)
    Protected String.s, StringWidth
    Protected IT,Text_Y,Text_X,Width,Height
    
    If Not *this\Hide
      With *this
        If Canvas=-1 
          Canvas = EventGadget()
        EndIf
        If Canvas <> canvasaddress\Gadget
          ProcedureReturn
        EndIf
        
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
          ClipOutput(\X[2],\Y[2],\Width[2],\Height[2]) ; Bug in Mac os
        CompilerEndIf
        
        DrawingMode(\DrawingMode)
        BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore,\Color\Back,\Radius)
        
        ; Make output text
        If (\Text\String.s Or \Text\Change Or \Resize)
          If \Text\FontID 
            DrawingFont(\Text\FontID) 
          EndIf
          
          If \Text\Change
            \Text\Height = TextHeight("A") + 1
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          If (\Text\Change Or \Resize)
            If \Text\Vertical
              Width = \Height[1]-\Text\X*2
              Height = \Width[1]-\Text\y*2
            Else
              Width = \Width[1]-\Text\X*2
              Height = \Height[1]-\Text\y*2
            EndIf
            
            If \Text\MultiLine
              \Text\String.s[2] = Text::Wrap(\Text\String.s, Width, \Text\MultiLine)
              \Text\CountString = CountString(\Text\String.s[2], #LF$)
            EndIf
            
            If \Text\CountString
              ClearList(\Items())
              
              If \Text\Align\Bottom
                Text_Y=(Height-(\Text\Height*\Text\CountString)-Text_Y) 
              ElseIf \Text\Align\Vertical
                Text_Y=((Height-(\Text\Height*\Text\CountString))/2)
              EndIf
              
              If \Text\Vertical
                For IT = \Text\CountString To 1 Step - 1
                  If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                  
                  String = StringField(\Text\String.s[2], IT, #LF$)
                  StringWidth = TextWidth(RTrim(String))
                  
                  If \Text\Align\Right
                    Text_X=(Width-StringWidth) 
                  ElseIf \Text\Align\Horisontal
                    Text_X=(Width-StringWidth)/2 
                  EndIf
                  
                  AddElement(\Items())
                  \Items()\x = \X[1]+\Text\Y+Text_Y
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
                    \Items()\Text\y = \Items()\y+StringWidth
                  EndIf
                  \Items()\Text\Width = StringWidth
                  \Items()\Text\Height = \Text\Height
                  \Items()\Text\String.s = String.s
                  \Items()\Text\Len = Len(String.s)
                  
                  
                  ;DrawRotatedText(\X[1]+\Text\Y+Text_Y, \Y[1]+\Text\X+Text_X+StringWidth, String.s, 90, \Color\Front)
                  ;DrawRotatedText(\X[1]+\Text\Y+Text_Y+\Text\Height, \Y[1]+\Text\X+Text_X, String.s, 270, \Color\Front)
                  Text_Y+\Text\Height : If Text_Y > (Width) : Break : EndIf
                Next
              Else
                For IT = 1 To \Text\CountString
                  If \Text\Y+Text_Y < \bSize : Text_Y+\Text\Height : Continue : EndIf
                  
                  String = StringField(\Text\String.s[2], IT, #LF$)
                  StringWidth = TextWidth(RTrim(String))
                  
                  If \Text\Align\Right
                    Text_X=(Width-StringWidth) 
                  ElseIf \Text\Align\Horisontal
                    Text_X=(Width-StringWidth)/2 
                  EndIf
                  
                  AddElement(\Items())
                  \Items()\x = \X[1]+\Text\X
                  \Items()\y = \Y[1]+\Text\Y+Text_Y
                  \Items()\Width = Width
                  \Items()\Height = \Text\Height
                  \Items()\Item = ListIndex(\Items())
                  
                  \Items()\Text\Editable = \Text\Editable 
                  \Items()\Text\x = (\Image\Width+\Image\Width/2)+\Items()\x+Text_X
                  \Items()\Text\y = \Items()\y
                  \Items()\Text\Width = TextWidth(String)
                  \Items()\Text\Height = \Text\Height
                  \Items()\Text\String.s = String.s
                  \Items()\Text\Len = Len(String.s)
                  
                  \Image\X = \Items()\Text\x-(\Image\Width+\Image\Width/2)
                  \Image\Y = \Y[1]+\Text\Y +(Height-\Image\Height)/2
                  
                  ;DrawText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String.s, \Color\Front)
                  Text_Y+\Text\Height : If Text_Y > (Height-\Text\Height) : Break : EndIf
                Next
              EndIf
            EndIf
          EndIf
          
          If \Text\Change
            \Text\Change = 0
          EndIf
          
          If \Resize
            \Resize = 0
          EndIf
        EndIf 
      EndWith 
      
      ; Draw items text
      If ListSize(*this\Items())
        With *this\Items()
          PushListPosition(*this\Items())
          ForEach *this\Items()
            ; Draw image
            If \Image\handle
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
            EndIf
            
            ; Draw string
            If \Text[1]\Change : \Text[1]\Change = #False
              \Text[1]\Width = TextWidth(\Text[1]\String.s) 
            EndIf 
            
            If \Text\String.s
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
                ClipOutput(\X,\Y,\Width,\Height) ; Bug in Mac os
              CompilerEndIf
              
              If \Text\FontID 
                DrawingFont(\Text\FontID) 
              EndIf
              
              If \Text[2]\Change : \Text[2]\Change = #False 
                \Text[2]\X = \Text[0]\X+\Text[1]\Width
                \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
              EndIf 
              
              If \Text[3]\Change : \Text[3]\Change = #False 
                \Text[3]\Width = TextWidth(\Text[3]\String.s)
              EndIf 
              
              If *this\Focus 
                Protected Left,Right
                Left =- (\Text[1]\Width+(Bool(*this\Caret>*this\Caret[1])*\Text[2]\Width))
                Right = (\Width + Left)
                
                If *this\Scroll\X < Left
                  *this\Scroll\X = Left
                ElseIf *this\Scroll\X > Right
                  *this\Scroll\X = Right
                ElseIf (*this\Scroll\X < 0 And *this\Caret = *this\Caret[1] And Not canvasaddress\Input) ; Back string
                  *this\Scroll\X = (\Width-\Text[3]\Width) + Left
                  If *this\Scroll\X>0
                    *this\Scroll\X=0
                  EndIf
                EndIf
              EndIf
              
              If *this\Text\Editable And \Text[2]\Len > 0 ; And #PB_Compiler_OS <> #PB_OS_MacOS
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS ; Bug in Mac os 
                  If *this\Caret[1] > *this\Caret
                    \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *this\Caret[1])) 
                    \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText((\Text[3]\X+*this\Scroll\X), \Text\Y, \Text[3]\String.s, $0B0B0B)
                    EndIf
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Default)
                      Box((\Text[2]\X+*this\Scroll\X), \Text\Y, \Text[2]\Width+\Text[2]\Width[2], \Text\Height, $E89C3D)
                      
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText((\Text\X+*this\Scroll\X), \Text\Y, \Text[1]\String.s+\Text[2]\String.s, $FFFFFF)
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText((\Text\X+*this\Scroll\X), \Text\Y, \Text[1]\String.s, $0B0B0B)
                    EndIf
                    
                  Else
                    ;                     \Text[2]\X = \Text\X+\Text[1]\Width
                    ;                     \Text[3]\X = \Text[2]\X+\Text[2]\Width
                    
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText((\Text\X+*this\Scroll\X), \Text\Y, \Text\String.s, $0B0B0B)
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Default)
                      Box((\Text[2]\X+*this\Scroll\X), \Text\Y, (\Text[2]\Width+\Text[2]\Width[2]), \Text\Height, $E89C3D)
                      
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText((\Text[2]\X+*this\Scroll\X), \Text\Y, \Text[2]\String.s, $FFFFFF)
                    EndIf
                  EndIf
                  
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText((\Text[0]\X+*this\Scroll\X), \Text[0]\Y, \Text[1]\String.s, Bool(\Text\Vertical)**this\Text\Rotate, *this\Color\Front)
                  EndIf
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Default)
                    Box((\Text[2]\X+*this\Scroll\X), \Text[0]\Y, \Text[2]\Width+\Text[2]\Width[2], \Text[0]\Height, $DE9541)
                    
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText((\Text[2]\X+*this\Scroll\X), \Text[0]\Y, \Text[2]\String.s, Bool(\Text\Vertical)**this\Text\Rotate, $FFFFFF)
                  EndIf
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText((\Text[3]\X+*this\Scroll\X), \Text[0]\Y, \Text[3]\String.s, Bool(\Text\Vertical)**this\Text\Rotate, *this\Color\Front)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len > 0
                  DrawingMode(#PB_2DDrawing_Default)
                  Box((\Text[2]\X+*this\Scroll\X), \Text[0]\Y, \Text[2]\Width+\Text[2]\Width[2], \Text[0]\Height, $FADBB3);$DE9541)
                EndIf
                
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText((\Text[0]\X+*this\Scroll\X), \Text[0]\Y, \Text[0]\String.s, Bool(\Text\Vertical)**this\Text\Rotate, *this\Color\Front)
              EndIf
            EndIf
            
          Next
          PopListPosition(*this\Items()) ; 
          If *this\Focus 
            ; Debug ""+ \Text[0]\Caret +" "+ \Text[0]\Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If *this\Text\Editable And *this\Caret = *this\Caret[1] And *this\Line = *this\Line[1] 
              DrawingMode(#PB_2DDrawing_XOr)             
              Line(((\Text\X+*this\Scroll\X) + \Text[1]\Width) - Bool(*this\Scroll\X = Right), \Text[0]\Y, 1, \Text[0]\Height, $FFFFFF)
            EndIf
          EndIf
        EndWith  
      EndIf
      
      ; Draw frames
      With *this
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS 
          ClipOutput(\X[1]-2,\Y[1]-2,\Width[1]+4,\Height[1]+4) ; Bug in Mac os
        CompilerEndIf
        
        ; Draw image
        If \Image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
        EndIf
        
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Default
          RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[3])
          ;           If \Radius ; Сглаживание краев)))
          ;             RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[3]) ; $D5A719)
          ;           EndIf
          ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[3])
        EndIf
        
        If \Focus 
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[3])
          If \Radius ; Сглаживание краев))) ; RoundBox(\X[1],\Y[1],\Width[1]+1,\Height[1]+1,\Radius,\Radius,\Color\Frame[3])
            RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[3]) ; $D5A719)
          EndIf
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[3])
        Else
          If \fSize
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame)
          EndIf
        EndIf
      EndWith
    EndIf
    
  EndProcedure
  ;-
  Procedure.s GetText(*this.Widget_S)
    With *this
      If \Text\Pass
        ProcedureReturn \Text\String.s[1]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetText(*this.Widget_S, Text.s)
    Protected Result,i,Len
    
    With *this
      If \Text\String.s <> Text.s
        \Text\String.s[1] = Text.s
        
        If \Text\Pass
          Len = Len(Text.s) : Text.s = "" 
          For i = 1 To Len : Text.s + "●" : Next
        Else
          Select #True
            Case \Text\Lower : Text.s = LCase(Text.s)
            Case \Text\Upper : Text.s = UCase(Text.s)
          EndSelect
        EndIf
        
        If Not \Text\MultiLine
          \Text\String.s[2] = RemoveString(Text.s, #LF$)
          \Text\CountString = #True
        EndIf
        
        \Text\String.s = Text.s
        \Text\Len = Len(Text.s)
        \Text\Change = #True
        Result = #True
      EndIf
    EndWith
  
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetFont(*this.Widget_S)
    ProcedureReturn *this\Text\FontID
  EndProcedure
  
  Procedure.i SetFont(*this.Widget_S, FontID.i)
    Protected Result
    
    If *this\Text\FontID <> FontID
      *this\Text\FontID = FontID
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*this.Widget_S, ColorType.i, Color.i, State.i=1)
    Protected Result
    
    With *this
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
    EndWith
    
    ResetColor(*this)
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetColor(*this.Widget_S, ColorType.i, State.i=0)
    Protected Color.i
    
    With *this
      Select ColorType
        Case #PB_Gadget_LineColor  : Color = \Color\Line[State]
        Case #PB_Gadget_BackColor  : Color = \Color\Back[State]
        Case #PB_Gadget_FrontColor : Color = \Color\Front[State]
        Case #PB_Gadget_FrameColor : Color = \Color\Frame[State]
      EndSelect
    EndWith
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i Resize(*this.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *this
      If Canvas=-1 
        Canvas = EventGadget()
      EndIf
      If Canvas = canvasaddress\Gadget
        canvasaddress\Window = EventWindow()
      Else
        ProcedureReturn
      EndIf
      
      If X<>#PB_Ignore 
        \X[0] = X 
        \X[2]=X+\bSize
        \X[1]=\X[2]-\fSize
        \Resize = 1
      EndIf
      If Y<>#PB_Ignore 
        \Y[0] = Y
        \Y[2]=Y+\bSize
        \Y[1]=\Y[2]-\fSize
        \Resize = 2
      EndIf
      If Width<>#PB_Ignore 
        \Width[0] = Width 
        \Width[2] = \Width-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        \Resize = 3
      EndIf
      If Height<>#PB_Ignore 
        \Height[0] = Height 
        \Height[2] = \Height-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        \Resize = 4
      EndIf
      
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.i CallBack(*Function, *this.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    If Canvas =- 1
      With *this
        Select EventType
          Case #PB_EventType_Input 
            canvasaddress\Input = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_Input)
            canvasaddress\Key[1] = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown
            canvasaddress\Key = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_Key)
            canvasaddress\Key[1] = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            canvasaddress\Mouse\X = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_MouseX)
            canvasaddress\Mouse\Y = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            canvasaddress\Mouse\Buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                    (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                    (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
          CompilerElse
            canvasaddress\Mouse\Buttons = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_Buttons)
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
              Result | CallCFunctionFast(*Function, *this, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | CallCFunctionFast(*Function, *this, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | CallCFunctionFast(*Function, *this, EventType, Canvas, CanvasModifiers)
    ProcedureReturn Result
  EndProcedure
  
  Procedure Widget(*this.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *this
      With *this
        \Type = #PB_GadgetType_Text
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Default
        canvasaddress\Gadget = Canvas
        \Radius = Radius
        \Alpha = 255
        
        ; Set the default widget flag
        Flag|#PB_Text_MultiLine|#PB_Text_ReadOnly|#PB_Widget_BorderLess
        
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Widget_BorderLess)
        \bSize = \fSize
        
        If Resize(*this, X,Y,Width,Height, Canvas)
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine = 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine =- 1
          EndIf
          \Text\Align\Horisontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          
          If \Text\Vertical
            \Text\X = \fSize 
            \Text\y = \fSize+2+Bool(Flag&#PB_Text_WordWrap)*4 ; 2,6,12
          Else
            \Text\X = \fSize+2+Bool(Flag&#PB_Text_WordWrap)*4 ; 2,6,12 
            \Text\y = \fSize
          EndIf
          
          If \Text\Editable
            \Color[0]\Back[1] = $FFFFFF 
          Else
            \Color[0]\Back[1] = $F0F0F0  
          EndIf
          \Color[0]\Frame[1] = $BABABA
          ResetColor(*this)
          
          SetText(*this, Text.s)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *this
  EndProcedure
EndModule

;-
DeclareModule String
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  
  ;- - DECLAREs MACROs
  Macro Draw(_adress_, _canvas_=-1) : Text::Draw(_adress_, _canvas_) : EndMacro
  Macro GetText(_adress_) : Text::GetText(_adress_) : EndMacro
  Macro SetText(_adress_, _text_) : Text::SetText(_adress_, _text_) : EndMacro
  Macro SetFont(_adress_, _font_id_) : Text::SetFont(_adress_, _font_id_) : EndMacro
  Macro GetColor(_adress_, _color_type_, _state_=0) : Text::GetColor(_adress_, _color_type_, _state_) : EndMacro
  Macro SetColor(_adress_, _color_type_, _color_, _state_=1) : Text::SetColor(_adress_, _color_type_, _color_, _state_) : EndMacro
  Macro Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_=-1) : Text::Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_) : EndMacro
  
  ;- - DECLAREs PRACEDUREs
  Declare.i Widget(*this.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Events(*this.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
EndDeclareModule

Module String
  ;-
  ;- - MACROS
  ;- - PROCEDUREs
  
  Procedure Caret(*this.Widget_S, Line.i = 0)
    Static LastLine.i,  LastItem.i
    Protected Item.i, SelectionLen.i=0
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *this
      If Line < 0 And FirstElement(*this\Items())
        ; А если выше всех линии текста,
        ; то позиция коректора начало текста.
        Position = 0
      ElseIf Line < ListSize(*this\Items()) And 
             SelectElement(*this\Items(), Line)
        ; Если находимся на линии текста, 
        ; то получаем позицию коректора.
        
        If ListSize(\Items())
          X = (\Items()\Text\X+\Scroll\X)
          Len = \Items()\Text\Len
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s
          If Not FontID : FontID = \Text\FontID : EndIf
          
          If StartDrawing(CanvasOutput(canvasaddress\Gadget)) 
            If FontID : DrawingFont(FontID) : EndIf
            
            For i = 0 To Len
              CursorX = X + TextWidth(Left(String.s, i))
              Distance = (canvasaddress\Mouse\X-CursorX)*(canvasaddress\Mouse\X-CursorX)
              
              ; Получаем позицию коpректора
              If MinDistance > Distance 
                MinDistance = Distance
                Position = i
              EndIf
            Next
            
            StopDrawing()
          EndIf
        EndIf
        
      ElseIf LastElement(*this\Items())
        ; Иначе, если ниже всех линии текста,
        ; то позиция коректора конец текста.
        Position = \Items()\Text\Len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure RemoveText(*this.Widget_S)
    With *this\Items()
      If *this\Caret > *this\Caret[1] : *this\Caret = *this\Caret[1] : EndIf
      \Text\String.s = RemoveString(\Text\String.s, \Text[2]\String.s, #PB_String_CaseSensitive, *this\Caret, 1)
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, *this\Caret, 1)
      \Text\Len = Len(\Text\String.s)
      \Text[2]\String.s = ""
      \Text[2]\Len = 0
    EndWith
  EndProcedure
  
  Procedure SelectionText(*this.Widget_S) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *this\Items()
      If Caret <> *this\Caret Or Line <> *this\Line Or (*this\Caret[1] >= 0 And Caret1 <> *this\Caret[1])
        \Text[2]\String.s = ""
        
        If *this\Line[1] = *this\Line
          If *this\Caret[1] > *this\Caret 
            ; |<<<<<< to left
            Position = *this\Caret
            \Text[2]\Len = (*this\Caret[1]-Position)
          Else 
            ; >>>>>>| to right
            Position = *this\Caret[1]
            \Text[2]\Len = (*this\Caret-Position)
          EndIf
          ; Если выделяем снизу вверх
        Else
          ; Три разних поведения при виделении текста 
          ; когда курсор переходит за предели виджета
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If *this\Caret > *this\Caret[1]
              ; <<<<<|
              Position = *this\Caret[1]
              \Text[2]\Len = \Text\Len-Position
            Else
              ; >>>>>|
              Position = 0
              \Text[2]\Len = *this\Caret[1]
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If *this\Caret[1] > *this\Caret 
              ; |<<<<<< to left
              Position = *this\Caret
              \Text[2]\Len = (*this\Caret[1]-Position)
            Else 
              ; >>>>>>| to right
              Position = *this\Caret[1]
              \Text[2]\Len = (*this\Caret-Position)
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If *this\Line > *this\Line[1]
              ; <<<<<|
              Position = *this\Caret[1]
              \Text[2]\Len = \Text\Len-Position
            Else
              ; >>>>>|
              Position = 0
              \Text[2]\Len = *this\Caret[1]
            EndIf 
          CompilerEndIf
          
        EndIf
        
        \Text[1]\String.s = Left(\Text\String.s, Position) : \Text[1]\Change = #True
        If \Text[2]\Len > 0
          \Text[2]\String.s = Mid(\Text\String.s, 1+Position, \Text[2]\Len) : \Text[2]\Change = #True
        EndIf
        \Text[3]\String.s = Right(\Text\String.s, \Text\Len-(Position + \Text[2]\Len)) : \Text[3]\Change = #True
        
        Line = *this\Line
        Caret = *this\Caret
        Caret1 = *this\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  
  
  Procedure ToLeft(*this.Widget_S)
    Protected Repaint
    
    With *this
      If \Items()\Text[2]\Len
        If \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf  
      ElseIf \Caret[1] > 0 
        \Caret - 1 
      EndIf
      
      If \Caret[1] <> \Caret
        \Caret[1] = \Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToRight(*this.Widget_S)
    Protected Repaint
    
    With *this
      If \Items()\Text[2]\Len 
        If \Caret > \Caret[1] 
          Swap \Caret, \Caret[1]
        EndIf
      ElseIf \Caret[1] < \Items()\Text\Len
        \Caret[1] + 1 
      EndIf
      
      If \Caret <> \Caret[1] 
        \Caret = \Caret[1] 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToBack(*this.Widget_S)
    Protected Repaint
    
    With *this
      If \Caret[1] > 0
        If \Items()\Text[2]\Len
          RemoveText(*this)
        Else         
          \Items()\Text\String.s = Left(\Items()\Text\String.s, \Caret - 1) + 
                                   Right(\Items()\Text\String.s, (\Items()\Text\Len-\Caret)) : \Caret - 1 
          \Items()\Text\Len = Len(\Items()\Text\String.s)
        EndIf
        
        \Caret[1] = \Caret 
        Repaint =- 1 
        PostEvent(#PB_Event_Widget, canvasaddress\Window, *this, #PB_EventType_Change)
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDelete(*this.Widget_S)
    Protected Repaint
    
    With *this
      If \Caret[1] < \Items()\Text\Len
        If \Items()\Text[2]\Len 
          RemoveText(*this)
        Else
          \Items()\Text\String.s = Left(\Items()\Text\String.s, \Caret) + 
                                   Right(\Items()\Text\String.s, (\Items()\Text\Len-\Caret) + 1)
          \Items()\Text\Len = Len(\Items()\Text\String.s)
        EndIf
        
        \Caret[1] = \Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToInput(*this.Widget_S)
    Static Dot
    Protected Repaint, Input, Input_2
      
    With *this
      Select #True
        Case \Text\Lower : Input = Asc(LCase(Chr(canvasaddress\Input))) : Input_2 = Input
        Case \Text\Upper : Input = Asc(UCase(Chr(canvasaddress\Input))) : Input_2 = Input
        Case \Text\Pass  : Input = 9679 : Input_2 = canvasaddress\Input ; "●"
        Case \Text\Numeric                                             ; : Debug Chr(canvasaddress\Input)
          Select canvasaddress\Input 
            Case '.','0' To '9' : Input = canvasaddress\Input : Input_2 = Input
            Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Input_2 = Input
            Default
              Input_2 = canvasaddress\Input
          EndSelect
          
          ; Чтобы нельзя было ставить точки подряд
          If Not Dot And Input = '.'
            Dot = 1
          ElseIf Input <> '.'
            Dot = 0
          Else
            Input = 0
          EndIf
          
        Default
          Input = canvasaddress\Input : Input_2 = Input
      EndSelect
      
      If Input_2
        If Input
          If \Items()\Text[2]\Len : RemoveText(*this) : EndIf
          \Caret + 1 : \Caret[1] = \Caret
        EndIf
        
        ;\Items()\Text\String.s = Left(\Items()\Text\String.s, *this\Caret-1) + Chr(Input) + Mid(\Items()\Text\String.s, *this\Caret)
        \Items()\Text\String.s = InsertString(\Items()\Text\String.s, Chr(Input), \Caret)
        \Items()\Text\String.s[1] = InsertString(\Items()\Text\String.s[1], Chr(Input_2), \Caret)
        
        If Input
          ;\Text\Change = 1
          \Items()\Text\Len = Len(\Items()\Text\String.s)
          PostEvent(#PB_Event_Widget, canvasaddress\Window, *this, #PB_EventType_Change)
        EndIf
        
        canvasaddress\Input = 0
        Repaint = #True 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure SelectionLimits(*this.Widget_S)
    With *this\Items()
      Protected i, char = Asc(Mid(\Text\String.s, *this\Caret + 1, 1))
      
      If (char > =  ' ' And char < =  '/') Or 
         (char > =  ':' And char < =  '@') Or 
         (char > =  '[' And char < =  96) Or 
         (char > =  '{' And char < =  '~')
        
        *this\Caret + 1
        \Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = *this\Caret To 1 Step - 1
          char = Asc(Mid(\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or 
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next 
        
        *this\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = *this\Caret To \Text\Len
          char = Asc(Mid(\Text\String.s, i, 1))
          If (char > =  ' ' And char < =  '/') Or 
             (char > =  ':' And char < =  '@') Or
             (char > =  '[' And char < =  96) Or 
             (char > =  '{' And char < =  '~')
            Break
          EndIf
        Next 
        
        *this\Caret = i - 1
        \Text[2]\Len = *this\Caret[1] - *this\Caret
      EndIf
    EndWith           
  EndProcedure
  
  ;-
  Procedure.i Events(*this.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static *Last.Widget_S, *Widget.Widget_S
    Static Text$, DoubleClick, LastX, LastY, Last, Drag
    Protected.i Repaint, Control, Buttons, Widget
    
    ; widget_events_type
    If *this
      Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    
    Static MoveX, MoveY
    Protected Caret,Item.i, String.s
    
    If  canvasaddress\Mouse\Buttons
      If canvasaddress\Mouse\Y < *this\Y
        *this\Line =- 1
      Else
        *this\Line = (((canvasaddress\Mouse\Y-*this\Y-*this\Text\Y)-*this\Scroll\Y) / *this\Height[2])
      EndIf
    EndIf
    
    With *this\items()
      If ListSize(*this\items())
          Select EventType
            Case #PB_EventType_LostFocus 
              *this\Caret = 0
              *this\Caret[1] = 0 
              \Text[2]\Len = 0
              ;             \Text[1]\String.s = "" : \Text[1]\Change = #True
              ;             \Text[2]\String.s = "" : \Text[2]\Change = #True
              ;             \Text[3]\String.s = "" : \Text[3]\Change = #True
              \Text[1]\Width = 0
              \Text[2]\Width = 0
              \Text[3]\Width = 0
              Repaint = #True
              PostEvent(#PB_Event_Widget, canvasaddress\Window, *this, #PB_EventType_LostFocus)
              
            Case #PB_EventType_Focus : Repaint = #True : *this\Caret[1] = *this\Caret ; Показываем коректор
              PostEvent(#PB_Event_Widget, canvasaddress\Window, *this, #PB_EventType_Focus)
              
            Case #PB_EventType_LeftButtonDown
              *this\Caret = Caret(*this)
              
              If DoubleClick : DoubleClick = 0
                *this\Caret = 0
                *this\Caret[1] = \Text\Len
                \Text[2]\Len = \Text\Len
              Else
                *this\Caret[1] = *this\Caret
                \Text[2]\Len = 0
              EndIf 
              
              If \Text\Numeric
                \Text\String.s[1] = \Text\String.s
              EndIf
              
              Repaint = 2
              
            Case #PB_EventType_LeftDoubleClick : DoubleClick = 1
              SelectionLimits(*this)
              Repaint = 2
              
            Case #PB_EventType_MouseMove
              If canvasaddress\Mouse\Buttons & #PB_Canvas_LeftButton
                *this\Caret = Caret(*this)
                Repaint = 2
              EndIf
              
          EndSelect
        
        If *this\focus And *this\Text\Editable
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            Control = Bool(canvasaddress\Key[1] & #PB_Canvas_Command)
          CompilerElse
            Control = Bool(canvasaddress\Key[1] & #PB_Canvas_Control)
          CompilerEndIf
          
          Select EventType
            Case #PB_EventType_Input
              If Not Control
                Repaint = ToInput(*this)
              EndIf
              
            Case #PB_EventType_KeyUp
              If \Text\Numeric
                \Text\String.s[1]=\Text\String.s 
              EndIf
              Repaint = #True 
              
            Case #PB_EventType_KeyDown
              Select canvasaddress\Key
                Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *this\Caret = 0 : *this\Caret[1] = *this\Caret : Repaint = #True 
                Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *this\Caret = \Text\Len : *this\Caret[1] = *this\Caret : Repaint = #True 
                  
                Case #PB_Shortcut_Left, #PB_Shortcut_Up : Repaint = ToLeft(*this) ; Ok
                Case #PB_Shortcut_Right, #PB_Shortcut_Down : Repaint = ToRight(*this) ; Ok
                Case #PB_Shortcut_Back : Repaint = ToBack(*this)
                Case #PB_Shortcut_Delete : Repaint = ToDelete(*this)
                  
                Case #PB_Shortcut_A
                  If Control
                    *this\Caret = 0
                    *this\Caret[1] = \Text\Len
                    \Text[2]\Len = \Text\Len
                    Repaint = 1
                  EndIf
                  
                Case #PB_Shortcut_X
                  If Control And \Text[2]\String.s 
                    SetClipboardText(\Text[2]\String.s)
                    RemoveText(*this)
                    *this\Caret[1] = *this\Caret
                    \Text\Len = Len(\Text\String.s)
                    Repaint = #True 
                  EndIf
                  
                Case #PB_Shortcut_C
                  If Control And \Text[2]\String.s 
                    SetClipboardText(\Text[2]\String.s)
                  EndIf
                  
                Case #PB_Shortcut_V
                  If Control
                    Protected ClipboardText.s = GetClipboardText()
                    
                    If ClipboardText.s
                      If \Text[2]\String.s
                        RemoveText(*this)
                      EndIf
                      
                      Select #True
                        Case *this\Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                        Case *this\Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                        Case *this\Text\Numeric 
                          If Val(ClipboardText.s)
                            ClipboardText.s = Str(Val(ClipboardText.s))
                          EndIf
                      EndSelect
                      
                      \Text\String.s = InsertString(\Text\String.s, ClipboardText.s, *this\Caret + 1)
                      *this\Caret + Len(ClipboardText.s)
                      *this\Caret[1] = *this\Caret
                      \Text\Len = Len(\Text\String.s)
                      Repaint = #True
                    EndIf
                  EndIf
                  
              EndSelect 
              
          EndSelect
        EndIf
        
        If Repaint 
          *this\Text[3]\Change = Bool(Repaint =- 1)
          
          SelectionText(*this)
        EndIf
      EndIf
    EndWith
  EndIf
  
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Widget(*this.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *this
      With *this
        \Type = #PB_GadgetType_String
        \Cursor = #PB_Cursor_IBeam
        \DrawingMode = #PB_2DDrawing_Default
        canvasaddress\Gadget = Canvas
        \Radius = Radius
        \Alpha = 255
        \Interact = 1
        \Caret[1] =- 1
        
        ; Set the default widget flag
        If Bool(Flag&#PB_Text_Top)
          Flag&~#PB_Text_Middle
        Else
          Flag|#PB_Text_Middle
        EndIf
        
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Widget_BorderLess)
        \bSize = \fSize
        
        If Resize(*this, X,Y,Width,Height, Canvas)
          \Text\Vertical = Bool(Flag&#PB_Text_Vertical)
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
          
          \Text\Align\Horisontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If \Text\Vertical
              \Text\X = \fSize+5
              \Text\y = \fSize+5
            Else
              \Text\X = \fSize+5
              \Text\y = \fSize+5
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+2
            Else
              \Text\X = \fSize+2
              \Text\y = \fSize
            EndIf
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If \Text\Vertical
              \Text\X = \fSize 
              \Text\y = \fSize+5
            Else
              \Text\X = \fSize+5
              \Text\y = \fSize
            EndIf
          CompilerEndIf
          
          If \Text\Editable
            \Color[0]\Back[1] = $FFFFFF 
          Else
            \Color[0]\Back[1] = $FAFAFA  
          EndIf
          
          ; default frame color
          \Color[0]\Frame[1] = $BABABA
          
          ; focus frame color
          \Color[0]\Frame[3] = $D5A719
          
          ; set default colors
          ResetColor(*this)
          
          SetText(*this, Text.s)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *this.Widget_S = AllocateStructure(Widget_S)
    
    If *this
      add_widget(Widget, *Widget)
      
      *this\Index = Widget
      *this\Handle = *Widget
      List()\Widget = *this
      
      Widget(*this, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
    EndIf
    
    ProcedureReturn *this
  EndProcedure
  
EndModule

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule String
  
  Global *S_0.Widget_S = AllocateStructure(Widget_S)
  Global *S_1.Widget_S = AllocateStructure(Widget_S)
  Global *S_2.Widget_S = AllocateStructure(Widget_S)
  Global *S_3.Widget_S = AllocateStructure(Widget_S)
  Global *S_4.Widget_S = AllocateStructure(Widget_S)
  Global *S_5.Widget_S = AllocateStructure(Widget_S)
  Global *S_6.Widget_S = AllocateStructure(Widget_S)
  Global *S_7.Widget_S = AllocateStructure(Widget_S)
  
  Global *Button_0.Widget_S = AllocateStructure(Widget_S)
  Global *Button_1.Widget_S = AllocateStructure(Widget_S)
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected EventType = EventType()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    canvasaddress\Gadget = Canvas
        
    
    Select EventType
      Case #PB_EventType_Resize
        ForEach List()
          Resize(List()\Widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        Next
        
        Result = 1
      Default
        If EventType = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        
        Select EventType
          Case #PB_EventType_Input 
            canvasaddress\Input = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_Input)
            canvasaddress\Key[1] = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown
            canvasaddress\Key = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_Key)
            canvasaddress\Key[1] = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            canvasaddress\Mouse\X = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_MouseX)
            canvasaddress\Mouse\Y = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            
            canvasaddress\Mouse\Buttons = GetGadgetAttribute(canvasaddress\Gadget, #PB_Canvas_Buttons)
        EndSelect
      
        
        If EventType = #PB_EventType_KeyDown Or 
           EventType = #PB_EventType_KeyUp Or
           EventType = #PB_EventType_Input
          
          If canvasaddress\activeWidget
            Result | Events(canvasaddress\activeWidget, EventType) 
          EndIf
        Else
          ForEach List()
            canvasaddress\Mouse\From = From(List()\Widget)
            
            If canvasaddress\Mouse\From
              If EventType = #PB_EventType_LeftButtonDown
                If canvasaddress\activeWidget
                  canvasaddress\activeWidget\focus = 0
                EndIf
                canvasaddress\activeWidget = List()\Widget
                canvasaddress\activeWidget\focus = 1
              EndIf
              
              Result | Events(List()\Widget, EventType) 
            EndIf
          Next
        EndIf
    EndSelect
    
    If Result
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height, $F0F0F0)
        
        ForEach List()
          Draw(List()\Widget)
        Next
        
        StopDrawing()
      EndIf
    EndIf
    
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 615, 310, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define height, Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget H"
  
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      height = 20
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      height = 18
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      height = 20
      LoadFont(0, "monospace", 9)
      SetGadgetFont(-1,FontID(0))
    CompilerEndIf
    
    StringGadget(0, 8,  10, 290, height, "Normal StringGadget...")
    StringGadget(1, 8,  35, 290, height, "1234567", #PB_String_Numeric)
    StringGadget(2, 8,  60, 290, height, "Read-only StringGadget", #PB_String_ReadOnly)
    StringGadget(3, 8,  85, 290, height, "LOWERCASE...", #PB_String_LowerCase)
    StringGadget(4, 8, 110, 290, height, "uppercase...", #PB_String_UpperCase)
    StringGadget(5, 8, 140, 290, height, "Borderless StringGadget", #PB_String_BorderLess)
    StringGadget(6, 8, 170, 290, height, "Password", #PB_String_Password)
    
    StringGadget(7, 8,  200, 290, 100, Text)
    
    Define i
    
    SetGadgetText(6, "GaT")
    
    ; Demo draw string on the canvas
    CanvasGadget(10,  305, 0, 310, 310, #PB_Canvas_Keyboard)
    SetGadgetAttribute(10, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
    BindGadgetEvent(10, @CallBacks())
    
    *S_0 = Create(10, -1, 8,  10, 290, height, "Normal StringGadget...")
    *S_1 = Create(10, -1, 8,  35, 290, height, "1234567", #PB_Text_Numeric|#PB_Text_Center)
    *S_2 = Create(10, -1, 8,  60, 290, height, "Read-only StringGadget", #PB_Text_ReadOnly|#PB_Text_Right)
    *S_3 = Create(10, -1, 8,  85, 290, height, "LOWERCASE...", #PB_Text_LowerCase)
    *S_4 = Create(10, -1, 8, 110, 290, height, "uppercase...", #PB_Text_UpperCase)
    *S_5 = Create(10, -1, 8, 140, 290, height, "Borderless StringGadget", #PB_Widget_BorderLess)
    *S_6 = Create(10, -1, 8, 170, 290, height, "Password", #PB_Text_Password)
    ; Button::Create(10, -1, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Text_MultiLine|#PB_Widget_Default, 4)
    *S_7 = Create(10, -1, 8,  200, 290, 100, Text);, #PB_Text_Top)
    ; *S_7 = Create(10, -1, 8,  200, 290, height, "aaaaaaa bbbbbbb ccccccc ddddddd eeeeeee fffffff ggggggg hhhhhhh");, #PB_Text_Numeric|#PB_Text_Center)
    
    Text::SetText(*S_6, "GaT")
    
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = -------------------------------------------
; EnableXP