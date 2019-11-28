
DeclareModule Macros
  Macro From(_this_, _buttons_=0)
    Bool(_this_\Canvas\Mouse\X>=_this_\x[_buttons_] And _this_\Canvas\Mouse\X<_this_\x[_buttons_]+_this_\Width[_buttons_] And 
         _this_\Canvas\Mouse\Y>=_this_\y[_buttons_] And _this_\Canvas\Mouse\Y<_this_\y[_buttons_]+_this_\Height[_buttons_])
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
    
  EndMacro
  
  Macro Distance(_mouse_x_, _mouse_y_, _position_x_, _position_y_, _round_)
    Bool(Sqr(Pow(((_position_x_+_round_) - _mouse_x_),2) + Pow(((_position_y_+_round_) - _mouse_y_),2)) =< _round_)
  EndMacro
EndDeclareModule 

Module Macros
  
EndModule 

UseModule Macros

;-
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
    ;     #PB_Button_Toggle = 4
    ;     #PB_Button_Default = 8
    
    #PB_Text_MultiLine = #PB_Button_MultiLine
    #PB_Text_Numeric = #PB_String_Numeric
    
    #PB_Widget_BorderLess = #PB_String_BorderLess 
    #PB_Widget_Vertical
    
    #PB_Text_Password = 128
    #PB_Text_ReadOnly
    #PB_Text_LowerCase 
    #PB_Text_UpperCase
    #PB_Text_WordWrap
    
    #PB_Text_Bottom
    #PB_Text_Middle 
    #PB_Text_Left
    #PB_Text_Top
    #PB_Text_Invert
    
    #PB_Widget_Double
    #PB_Widget_Flat
    #PB_Widget_Raised
    #PB_Widget_Single
    
    #PB_Widget_Invisible
  EndEnumeration
  
  #__sOC = SizeOf(Character)
  
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
  Structure _S_coordinate
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
  
  ;- - _S_align
  Structure _S_align
    width.l
    height.l
    
    left.b
    top.b
    right.b
    bottom.b
    vertical.b
    horizontal.b
    autosize.b
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
  
  Structure IMAGE Extends _S_coordinate
    handle.i[2]
    change.b
  EndStructure
  
  ;- - _S_text
  Structure _S_text Extends _S_coordinate
    big.l[3]
    pos.l
    len.l
    caret.l[3] ; 0 = Pos ; 1 = PosFixed
    
    fontID.i
    string.s[3]
    change.b
    
    pass.b
    lower.b
    upper.b
    numeric.b
    editable.b
    multiLine.b
    WordWrap.b
    vertical.b
    rotate.f
    padding.l
    
    align._S_align
  EndStructure
  
  ;- - _S_count
  Structure _S_count
    items.l
    
    childrens.l
  EndStructure
  
  Structure WIDGET Extends _S_coordinate
    Index.i  ; Index of new list element
    Handle.i ; Adress of new list element
    
    count._S_count
    *Widget.WIDGET
    Canvas.CANVAS
    Color.COLOR[4]
    Text._S_text[4]
    
    fs.i
    bs.i
    Hide.b[2]
    Disable.b[2]
    Cursor.i[2]
    
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
    round.i
    Buttons.i
    
    ; edit
    LinePos.i[2] ; 0 = Pos ; 1 = PosFixed
    Caret.i[2]   ; 0 = Pos ; 1 = PosFixed
    
    ; tree
    time.i
    adress.i[2]
    sublevel.i
    box._S_coordinate
    *data
    collapsed.b
    childrens.i
    Item.i
    Attribute.l
    change.b
    flag.i
    Image.IMAGE
    
    *Default
    Alpha.a[2]
    
    DrawingMode.i
    
    List Items.WIDGET()
  EndStructure
  
  Global NewList List.Widget()
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Structures
;-
DeclareModule Button
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  ;- - DECLAREs MACROs
  
  Declare.i Draw(*This.Widget, Canvas.i=-1)
  Declare.s GetText(*This.Widget)
  Declare.i SetText(*This.Widget, Text.s)
  Declare.i SetFont(*This.Widget, FontID.i)
  Declare.i GetColor(*This.Widget, ColorType.i)
  Declare.i SetColor(*This.Widget, ColorType.i, Color.i)
  Declare.i Resize(*This.Widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
  
  ;- - DECLAREs PRACEDUREs
  Declare.i GetState(*This.Widget)
  Declare.i SetState(*This.Widget, Value.i)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, round.i=0, Image.i=-1)
  Declare.i CallBack(*This.Widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1) ; .i CallBack(*This.Widget, Canvas.i, EventType.i, MouseX.i, MouseY.i, WheelDelta.i=0)
  Declare.i Widget(*This.Widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, round.i=0, Image.i=-1)
  
EndDeclareModule

Module Button
  ;-
  ;- - MACROS
  ;- - PROCEDUREs
  ;   Procedure.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
  ;     Protected line$, ret$="", LineRet$=""
  ;     Protected.i CountString, i, start, ii, found, length
  ;     
  ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
  ;     Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
  ;     Text.s = ReplaceString(Text.s, #CR$, #LF$)
  ;     Text.s + #LF$
  ;     
  ;     CountString = CountString(Text.s, #LF$) 
  ;     
  ;     For i = 1 To CountString
  ;       line$ = StringField(Text.s, i, #LF$)
  ;       start = Len(line$)
  ;       length = start
  ;       
  ;       ; Get text len
  ;       While length > 1
  ;         If width > TextWidth(RTrim(Left(line$, length)))
  ;           Break
  ;         Else
  ;           length - 1 
  ;         EndIf
  ;       Wend
  ;       
  ;       While start > length 
  ;         If mode
  ;           For ii = length To 0 Step - 1
  ;             If mode =- 1 And CountString(Left((line$),ii), " ") > 1     And width > 71 ; button
  ;               found + FindString(delimList$, Mid(RTrim(line$),ii,1))
  ;               If found <> 2
  ;                 Continue
  ;               EndIf
  ;             Else
  ;               found = FindString(delimList$, Mid(line$,ii,1))
  ;             EndIf
  ;             
  ;             If found
  ;               start = ii
  ;               Break
  ;             EndIf
  ;           Next
  ;         EndIf
  ;         
  ;         If found
  ;           found = 0
  ;         Else
  ;           start = length
  ;         EndIf
  ;         
  ;         LineRet$ + Left(line$, start) + nl$
  ;         line$ = LTrim(Mid(line$, start+1))
  ;         start = Len(line$)
  ;         length = start
  ;         
  ;         ; Get text len
  ;         While length > 1
  ;           If width > TextWidth(RTrim(Left(line$, length)))
  ;             Break
  ;           Else
  ;             length - 1 
  ;           EndIf
  ;         Wend
  ;       Wend
  ;       
  ;       ret$ +  LineRet$ + line$ + nl$
  ;       LineRet$=""
  ;     Next
  ;     
  ;     If Width > 1
  ;       ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
  ;     EndIf
  ;   EndProcedure
  ;   
  ;   Macro _text_change_(_this_, _x_, _y_, _width_, _height_)
  ;     ;If _this_\text\vertical
  ;       If _this_\text\rotate = 90
  ;         If _this_\y<>_y_
  ;           _this_\text\x = _x_ + _this_\y
  ;         Else
  ;           _this_\text\x = _x_ + (_width_-_this_\text\height)/2
  ;         EndIf
  ;         
  ;         If _this_\text\align\right
  ;           _this_\text\y = _y_ +_this_\text\align\height+ _this_\text\padding+_this_\text\width
  ;         ElseIf _this_\text\align\horizontal
  ;           _this_\text\y = _y_ + (_height_+_this_\text\align\height+_this_\text\width)/2
  ;         Else
  ;           _this_\text\y = _y_ + _height_-_this_\text\padding
  ;         EndIf
  ;         
  ;       ElseIf _this_\text\rotate = 270
  ;         _this_\text\x = _x_ + (_width_-_this_\y)
  ;         
  ;         If _this_\text\align\right
  ;           _this_\text\y = _y_ + (_height_-_this_\text\width-_this_\text\padding) 
  ;         ElseIf _this_\text\align\horizontal
  ;           _this_\text\y = _y_ + (_height_-_this_\text\width)/2 
  ;         Else
  ;           _this_\text\y = _y_ + _this_\text\padding 
  ;         EndIf
  ;         
  ;       EndIf
  ;       
  ;     ;Else
  ;       If _this_\text\rotate = 0
  ;         If _this_\x<>_x_
  ;           _this_\text\y = _y_ + _this_\y
  ;         Else
  ;           _this_\text\y = _y_ + (_height_-_this_\text\height)/2
  ;         EndIf
  ;         
  ;         If _this_\text\align\right
  ;           _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width-_this_\text\padding) 
  ;         ElseIf _this_\text\align\horizontal
  ;           _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width)/2
  ;         Else
  ;           _this_\text\x = _x_ + _this_\text\padding
  ;         EndIf
  ;         
  ;       ElseIf _this_\text\rotate = 180
  ;         _this_\text\y = _y_ + (_height_-_this_\y)
  ;         
  ;         If _this_\text\align\right
  ;           _this_\text\x = _x_ + _this_\text\padding+_this_\text\width
  ;         ElseIf _this_\text\align\horizontal
  ;           _this_\text\x = _x_ + (_width_+_this_\text\width)/2 
  ;         Else
  ;           _this_\text\x = _x_ + _width_-_this_\text\padding 
  ;         EndIf
  ;         
  ;       EndIf
  ;     ;EndIf
  ;   EndMacro
  ;   
  
  
  Procedure.s Wrap (text$, softWrapPosn.i, hardWrapPosn.i=-1, delimList$=" "+Chr(9), nl$=#LF$, liStart$="")
    ; ## Main function ##
    ; -- Word wrap in *one or more lines* of a text file, or in a window with a fixed-width font
    ; in : text$       : text which is to be wrapped;
    ;                    may contain #CRLF$ (Windows), or #LF$ (Linux and modern Mac systems) as line breaks
    ;      softWrapPosn: the desired maximum length (number of characters) of each resulting line
    ;                    if a delimiter was found (not counting the length of the inserted nl$);
    ;                    if no delimiter was found at a position <= softWrapPosn, a line might
    ;                    still be longer if hardWrapPosn = 0 or > softWrapPosn
    ;      hardWrapPosn: guaranteed maximum length (number of characters) of each resulting line
    ;                    (not counting the length of the inserted nl$);
    ;                    if hardWrapPosn <> 0, each line will be wrapped at the latest at
    ;                    hardWrapPosn, even if it doesn't contain a delimiter;
    ;                    default setting: hardWrapPosn = softWrapPosn
    ;      delimList$  : list of characters which are used as delimiters;
    ;                    any delimiter in line$ denotes a position where a soft wrap is allowed
    ;      nl$         : string to be used as line break (normally #CRLF$ or #LF$)
    ;      liStart$    : string at the beginning of each list item
    ;                    (providing this information makes proper indentation possible)
    ;
    ; out: return value: text$ with given nl$ inserted at appropriate positions
    ;
    ; <http://www.purebasic.fr/english/viewtopic.php?f=12&t=53800>
    Protected.i numLines, i, indentLen=-1, length
    Protected line$, line1$, indent$, ret$="", ret1$="", start, start1, found, length1
    
    ;numLines = CountString(text$, #LF$) + 1
    
    text$+#LF$
    ;hardWrapPosn = 0
    ;softWrapPosn/6
    If hardWrapPosn > 0
      length = softWrapPosn/6
    EndIf
    
    Protected *Sta.Character = @text$
    Protected *End.Character = @text$
    
    If softWrapPosn > 0
      While *End\c 
        If *End\c = #LF And *Sta <> *End
          start = (*End-*Sta)>>#PB_Compiler_Unicode
          line$ = PeekS (*Sta, start)
          
          ; Get text len
          If hardWrapPosn < 0
            If length <> start
              length = start
              
              While length > 1
                If softWrapPosn > TextWidth(Left(line$, length)) 
                  Break
                Else
                  length - 1 
                EndIf
              Wend
            EndIf
          EndIf
          
          While start > length
            For i = length To 1 Step -1
              If FindString(" ", Mid(line$,i,1))
                start = i
                Break
              EndIf
            Next
            
            If i = 0 
              start = length
            EndIf
            
            ret$ + RTrim(Left(line$, start)) + nl$
            line$ = LTrim(Mid(line$, start+1))
            start = Len(line$)
          Wend
          
          ret$ + line$ + nl$
          
          *Sta = *End + #__sOC 
        EndIf 
        
        *End + #__sOC 
      Wend
    EndIf
    
    ProcedureReturn ret$
  EndProcedure
  
  Macro _text_change_(_this_, _x_, _y_, _width_, _height_)
    ;If _this_\text\vertical
    If _this_\text\rotate = 90
      If _this_\y<>_y_
        _this_\text\x = _x_ + _this_\y
      Else
        _this_\text\x = _x_ + (_width_-_this_\text\height)/2
      EndIf
      
      If _this_\text\align\right
        _this_\text\y = _y_ + _this_\text\align\height+_this_\text\width + _this_\text\padding
      ElseIf _this_\text\align\horizontal
        _this_\text\y = _y_ + (_height_+_this_\text\align\height+_this_\text\width)/2
      Else
        _this_\text\y = _y_ + _height_-_this_\text\padding
      EndIf
      
    ElseIf _this_\text\rotate = 270
      _this_\text\x = _x_ + (_width_-_this_\y)
      
      If _this_\text\align\right
        _this_\text\y = _y_ + (_height_-_this_\text\width-_this_\text\padding) 
      ElseIf _this_\text\align\horizontal
        _this_\text\y = _y_ + (_height_-_this_\text\width)/2 
      Else
        _this_\text\y = _y_ + _this_\text\padding 
      EndIf
      
    EndIf
    
    ;Else
    If _this_\text\rotate = 0
      If _this_\y<>_y_
        _this_\text\y = _y_ + _this_\y ; - Bool(_this_\text\align\bottom)*_this_\text\padding
      Else
        _this_\text\y = _y_ + (_height_-_this_\text\height)/2
      EndIf
      
      If _this_\text\align\right
        _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width - _this_\text\padding) 
      ElseIf _this_\text\align\horizontal
        _this_\text\x = _x_ + (_width_-_this_\text\align\width-_this_\text\width)/2
      Else
        _this_\text\x = _x_ + _this_\text\padding
      EndIf
      
    ElseIf _this_\text\rotate = 180
      _this_\text\y = _y_ + (_height_-_this_\y); + Bool(_this_\text\align\bottom)*_this_\text\padding)
      
      If _this_\text\align\right
        _this_\text\x = _x_ + _this_\text\width + _this_\text\padding 
      ElseIf _this_\text\align\horizontal
        _this_\text\x = _x_ + (_width_+_this_\text\width)/2 
      Else
        _this_\text\x = _x_ + _width_-_this_\text\padding 
      EndIf
      
    EndIf
    ;EndIf
  EndMacro
  
  
  Procedure.i Draw(*This.Widget, Canvas.i=-1)
    Protected String.s, StringWidth
    Protected IT,Text_Y,Text_X,Width,Height
    
    If Not *This\Hide
      With *This
        If Canvas=-1 
          Canvas = EventGadget()
        EndIf
        If Canvas <> \Canvas\Gadget
          ProcedureReturn
        EndIf
        
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        DrawingMode(\DrawingMode)
        BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore,\Color\Back,\round)
        
        
        ; Make output text
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          If (\Text\Change Or \Resize)
            If \Text\Vertical
              Width = \Height[1]
              Height = \Width[1]
            Else
              Width = \Width[1]
              Height = \Height[1]
            EndIf
            
            ;             If \Text\MultiLine
            ;               \Text\String.s[2] = Wrap(\Text\String.s, Width-\Text\padding*2, \Text\MultiLine)
            ;               \count\items = CountString(\Text\String.s[2], #LF$)
            ;             Else
            ;               ;  \Text\String.s[1] = Wrap(\Text\String.s, Width, 0)
            ;               \Text\String.s[2] = \Text\String.s
            \count\items = 1
            ;             EndIf
            
            If \count\items
              ClearList(\Items())
              ;\Text\Align\horizontal = 0
              
              ;               If \Text\Align\Bottom
              ;                 Text_Y = (Height-\Text\padding-(\Text\Height*\count\items)) 
              ;               ElseIf \Text\Align\Vertical
              ;                 Text_Y = (Height-(\Text\Height*\count\items))/2
              ;               Else
              ;                 Text_Y = \bs
              ;               EndIf
              
              
              
              
              
              Protected.i numLines, i, indentLen=-1, length
              Protected line$, line1$, indent$, ret$="", ret1$="", start, start1, found, length1
              
              ;numLines = CountString(text$, #LF$) + 1
              Protected text$ = \Text\String.s
              text$+#LF$
              Protected nl$ = #LF$
              Protected softWrapPosn = Width-\Text\padding*2
              Protected hardWrapPosn =-1
              ;softWrapPosn/6
              If hardWrapPosn > 0
                length = softWrapPosn/6
              EndIf
              
              Protected *Sta.Character = @text$
              Protected *End.Character = @text$
              
              If softWrapPosn > 0
                Text_Y = 0
                \count\items = 0
                While *End\c 
                  If *End\c = #LF And *Sta <> *End
                    start = (*End-*Sta)>>#PB_Compiler_Unicode
                    line$ = PeekS (*Sta, start)
                    
                    ; Get text len
                    If hardWrapPosn < 0
                      If length <> start
                        length = start
                        
                        While length > 1
                          If softWrapPosn > TextWidth(Left(line$, length)) 
                            Break
                          Else
                            length - 1 
                          EndIf
                        Wend
                      EndIf
                    EndIf
                    
                    \count\items + 1 
                    While start > length
                      For i = length To 1 Step -1
                        If FindString(" ", Mid(line$,i,1))
                          start = i
                          Break
                        EndIf
                      Next
                      
                      If i = 0 
                        start = length
                      EndIf
                      
                      \count\items + 1 
                      ret$ + RTrim(Left(line$, start)) + nl$
                      line$ = LTrim(Mid(line$, start+1))
                      start = Len(line$)
                    Wend
                    
                    ret$ + line$ ;+ nl$
                    Debug ret$ +" "+ TextWidth(ret$)
                    
                    
                    
                    AddElement(\items())
                    ;\items()\text\pos = pos+ListSize(\items()) : pos + \items()\text\Len
                    ;\items()\text\Len = Len(ret$);(*End-*Sta)>>#PB_Compiler_Unicode
                    \items()\text\string.s = ret$
                    \items()\text\width = TextWidth(\items()\text\string.s)
                    \Items()\Text\Height = \Text\Height
                    
                    ;Debug \count\items
                    ; Debug ""+\items()\text\pos +" "+ \items()\text\string.s
                    ;                     
                    If Text_Y = 0
                      If \Text\Align\Bottom
                        Text_Y = (Height-\Text\padding-(\Text\Height*\count\items)) 
                      ElseIf \Text\Align\Vertical
                        Text_Y = (Height-(\Text\Height*\count\items))/2
                      Else
                        Text_Y = \bs
                      EndIf
                    EndIf
                    
                    \Items()\y = Text_Y : Text_Y + \Text\Height
                    
                    \items()\text\align = \text\align
                    \items()\text\rotate = \text\rotate
                    \items()\text\padding = \text\padding
                    
                    _text_change_(\Items(), *this\x, *this\y, *this\width, *this\height)
                    
                    *Sta = *End + #__sOC 
                  EndIf 
                  
                  *End + #__sOC 
                Wend
              EndIf
              
              ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
              ;Debug Str(ElapsedMilliseconds()-time) + " text parse time "
              
            EndIf
            ;             EndIf
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
      If ListSize(*This\Items())
        With *This\Items()
          PushListPosition(*This\Items())
          ForEach *This\Items()
            
            ; Draw image
            If \Image\handle
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
            EndIf
            
            ; Draw string
            If \Text\String.s
              If \Text\FontID 
                DrawingFont(\Text\FontID) 
              EndIf
              If \Text[1]\Change 
                \Text[1]\Width = TextWidth(\Text[1]\String.s) 
                \Text[2]\X = \Text[0]\X+\Text[1]\Width
                \Text[1]\Change = #False
              EndIf
              If \Text[2]\Change
                \Text[2]\Width = TextWidth(\Text[2]\String.s)
                \Text[3]\X = \Text[2]\X+\Text[2]\Width
                \Text[2]\Change = #False
              EndIf 
              
              If \Text[2]\Len And #PB_Compiler_OS <> #PB_OS_MacOS
                If \Text[1]\String.s
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(\Text[0]\X, \Text[0]\Y, \Text[1]\String.s, *This\Text\Rotate, *This\Color\Front)
                EndIf
                If \Text[2]\String.s
                  DrawingMode(#PB_2DDrawing_Default)
                  ;                   If \Text[0]\String.s = \Text[1]\String.s+\Text[2]\String.s
                  ;                     Box(\Text[2]\X, \Text[0]\Y,*This\width[2]-\Text[2]\X, \Text[0]\Height, $DE9541)
                  ;                   Else
                  Box(\Text[2]\X, \Text[0]\Y, \Text[2]\Width, \Text[0]\Height+1, $DE9541)
                  ;                   EndIf
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(\Text[2]\X, \Text[0]\Y, \Text[2]\String.s, *This\Text\Rotate, $FFFFFF)
                EndIf
                If \Text[3]\String.s
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(\Text[3]\X, \Text[0]\Y, \Text[3]\String.s, *This\Text\Rotate, *This\Color\Front)
                EndIf
              Else
                If \Text[2]\Len
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, \Text[0]\Y, \Text[2]\Width, \Text[0]\Height+1, $FADBB3);$DE9541)
                EndIf
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText(\Text[0]\X, \Text[0]\Y, \Text[0]\String.s, *This\Text\Rotate, *This\Color\Front)
              EndIf
            EndIf
            
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            ; Debug ""+ \Text[0]\Caret +" "+ \Text[0]\Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If *This\Text\Editable And \Text\Caret = \Text\Caret[1] 
              DrawingMode(#PB_2DDrawing_XOr)             
              Line(\Text[0]\X + \Text[1]\Width, \Text[0]\Y, 1, \Text[0]\Height, $FFFFFF)
            EndIf
          EndIf
        EndWith  
      EndIf
      
      ; Draw frames
      With *This
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
          If \round 
            ; Сглаживание краев)))
            RoundBox(\X[1]+1+1,\Y[1]+2+1,\Width[1]-2-2,\Height[1]-4-2,\round,\round,$D5A719)
          EndIf
          
          RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\round,\round,$D5A719)
          RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\round,\round,$D5A719)
        EndIf
        
        If \Focus = *This 
          ;  Debug "\Focus "+\Focus
          If \round 
            ; Сглаживание краев)))
            RoundBox(\X[1],\Y[1],\Width[1]+1,\Height[1]+1,\round,\round,$D5A719)
            RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\round,\round,$D5A719)
          EndIf
          
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\round,\round,$D5A719)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\round,\round,$D5A719)
        Else
          If \fs
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\round,\round,\Color\Frame)
          EndIf
        EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.s GetText(*This.Widget)
    ProcedureReturn *This\Text\String.s
  EndProcedure
  
  Procedure.i SetText(*This.Widget, Text.s)
    Protected Result
    
    If *This\Text\String.s <> Text.s
      *This\Text\String.s = Text.s
      *This\Text\Change = #True
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*This.Widget, FontID.i)
    Protected Result
    
    If *This\Text\FontID <> FontID
      *This\Text\FontID = FontID
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*This.Widget, ColorType.i, Color.i)
    Protected Result
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor
          If \Color\Line <> Color 
            \Color\Line = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_BackColor
          If \Color\Back <> Color 
            \Color\Back = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_FrontColor
          If \Color\Front <> Color 
            \Color\Front = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_FrameColor
          If \Color\Frame <> Color 
            \Color\Frame = Color
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetColor(*This.Widget, ColorType.i)
    Protected Color.i
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor  : Color = \Color\Line
        Case #PB_Gadget_BackColor  : Color = \Color\Back
        Case #PB_Gadget_FrontColor : Color = \Color\Front
        Case #PB_Gadget_FrameColor : Color = \Color\Frame
      EndSelect
    EndWith
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i GetState(*This.Widget)
    ProcedureReturn *This\Toggle
  EndProcedure
  
  Procedure.i SetState(*This.Widget, Value.i)
    Protected Result
    
    If *This\Toggle <> Bool(Value)
      *This\Toggle = Bool(Value)
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Resize(*This.Widget, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    Protected Result
    
    With *This
      If Canvas=-1 
        Canvas = EventGadget()
      EndIf
      If Canvas <> \Canvas\Gadget
        ProcedureReturn
      EndIf
      
      If X<>#PB_Ignore 
        \X[0] = X 
        \X[2]=X+\bs
        \X[1]=\X[2]-\fs
        Result = 1
      EndIf
      If Y<>#PB_Ignore 
        \Y[0] = Y
        \Y[2]=Y+\bs
        \Y[1]=\Y[2]-\fs
        Result = 2
      EndIf
      If Width<>#PB_Ignore 
        \Width[0] = Width 
        \Width[2] = \Width-\bs*2
        \Width[1] = \Width[2]+\fs*2
        Result = 3
      EndIf
      If Height<>#PB_Ignore 
        \Height[0] = Height 
        \Height[2] = \Height-\bs*2
        \Height[1] = \Height[2]+\fs*2
        Result = 4
      EndIf
      
      \Resize = Result
      ProcedureReturn Result
    EndWith
  EndProcedure
  
  Procedure.i Events(*This.Widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    Static Text$, DoubleClickCaret =- 1
    Protected Repaint, StartDrawing, Update_Text_Selected
    
    Protected Buttons, Widget.i
    Static *Focus.Widget, *Last.Widget, *Widget.Widget, LastX, LastY, Last, Drag
    
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
           \Type <> #PB_GadgetType_Button
          ProcedureReturn
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
    
    If (*Last = *This) ;And ListSize(*This\items())
      With *This       ;\items()
        Select EventType
          Case #PB_EventType_MouseEnter    
            \Buttons = \Canvas\Mouse\From
            If Not \Checked : Buttons = \Buttons : EndIf
            
          Case #PB_EventType_LeftButtonDown : Drag = 1 : LastX = \Canvas\Mouse\X : LastY = \Canvas\Mouse\Y
            If \Buttons
              Buttons = \Buttons
              If \Toggle 
                \Checked[1] = \Checked
                \Checked ! 1
              EndIf
            EndIf
            
          Case #PB_EventType_LeftButtonUp : Drag = 0
            If \Toggle 
              If Not \Checked And Not CanvasModifiers
                Buttons = \Buttons
              EndIf
            Else
              Buttons = \Buttons
            EndIf
            ;Debug "LeftButtonUp"
            
          Case #PB_EventType_LeftClick ; Bug in mac os afte move mouse dont post event click
                                       ;Debug "LeftClick"
            PostEvent(#PB_Event_Widget, \Canvas\Window, Widget, #PB_EventType_LeftClick)
            
          Case #PB_EventType_MouseLeave
            If \Drag 
              \Checked = \Checked[1]
            EndIf
            
          Case #PB_EventType_MouseMove
            If Drag And \Drag=0 And (Abs((\Canvas\Mouse\X-LastX)+(\Canvas\Mouse\Y-LastY)) >= 6) : \Drag=1 : EndIf
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseEnter, #PB_EventType_LeftButtonUp, #PB_EventType_LeftButtonDown
            If Buttons 
              Buttons = 0
              \Color[Buttons]\Fore = \Color[Buttons]\Fore[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Back = \Color[Buttons]\Back[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Frame = \Color[Buttons]\Frame[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              \Color[Buttons]\Line = \Color[Buttons]\Line[2+Bool(EventType=#PB_EventType_LeftButtonDown)]
              Repaint = #True
            EndIf
            
          Case #PB_EventType_MouseLeave
            If Not \Checked
              ResetColor(*This)
            EndIf
            
            Repaint = #True
        EndSelect 
        
        Select EventType
          Case #PB_EventType_Focus : Repaint = #True
          Case #PB_EventType_LostFocus : Repaint = #True
        EndSelect
        
        
        
      EndWith
    EndIf
    
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Text_CallBack(*Function, *This.Widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
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
          Case #PB_EventType_KeyDown
            \Canvas\Key = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Key)
            \Canvas\Key[1] = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            \Canvas\Mouse\X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
            \Canvas\Mouse\Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            \Canvas\Mouse\Buttons = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_Buttons)
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
            Result | CallCFunctionFast(*Function, *This, #PB_EventType_LeftButtonUp, Canvas, CanvasModifiers)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | CallCFunctionFast(*Function, *This, EventType, Canvas, CanvasModifiers)
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i CallBack(*This.Widget, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text_CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure Widget(*This.Widget, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, round.i=0, Image.i=-1)
    If *This
      With *This
        \Type = #PB_GadgetType_Button
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Gradient
        \Canvas\Gadget = Canvas
        \round = round
        
        \Alpha = 255
        \Interact = 1
        
        ; Set the default widget flag
        Flag|#PB_Text_ReadOnly
        
        If Bool(Flag&#PB_Text_Left)
          Flag&~#PB_Text_Center
        Else
          Flag|#PB_Text_Center
        EndIf
        
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
        
        \fs = Bool(Not Flag&#PB_Widget_BorderLess)
        \bs = \fs
        
        If IsImage(Image)
          \Image\handle[1] = Image
          \Image\handle = ImageID(Image)
          \Image\width = ImageWidth(Image)
          \Image\height = ImageHeight(Image)
        EndIf
        
        If Resize(*This, X,Y,Width,Height, Canvas)
          \Default = Bool(Flag&#PB_Button_Default)
          \Toggle = Bool(Flag&#PB_Button_Toggle)
          
          \Text\Vertical = Bool(Flag&#PB_Widget_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          ;           \Text\WordWrap = Bool(Flag&#PB_Text_WordWrap)
          ;           \Text\MultiLine = Bool(Flag&#PB_Text_MultiLine)
          If Flag&#PB_Text_WordWrap
            \Text\MultiLine = 1
          ElseIf Flag&#PB_Text_MultiLine
            \Text\MultiLine =- 1
          EndIf
          
          \Text\Align\horizontal = Bool(Flag&#PB_Text_Center)
          \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          \Text\Align\Right = Bool(Flag&#PB_Text_Right)
          \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          \Text\padding = 5
          ;           If \Text\Vertical
          ;             \Text\X = \fs 
          ;             \Text\y = \fs+12 ; 2,6,1
          ;           Else
          ;             \Text\X = \fs+12 ; 2,6,12 
          ;             \Text\y = \fs
          ;           EndIf
          If Bool(Flag&#PB_Text_Invert)
            \Text\Rotate = Bool(\text\vertical)*90+Bool(Not \text\vertical)*180 ;90; 90;
          Else
            \Text\Rotate = Bool(\text\vertical)*270;90+Bool(Not \text\vertical)*180 ;90; 90;
          EndIf
          
          \Text\String.s = Text.s
          \Text\Change = #True
          
          \Color[0]\Fore[1] = $F6F6F6 
          \Color[0]\Back[1] = $E2E2E2  
          \Color[0]\Frame[1] = $BABABA 
          
          ; Цвет если мышь на виджете
          \Color[0]\Fore[2] = $EAEAEA
          \Color[0]\Back[2] = $CECECE
          \Color[0]\Frame[2] = $8F8F8F
          
          ; Цвет если нажали на виджет
          \Color[0]\Fore[3] = $E2E2E2
          \Color[0]\Back[3] = $B4B4B4
          \Color[0]\Frame[3] = $6F6F6F
          
          ; Устанавливаем цвет по умолчанию первый
          ResetColor(*This)
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, round.i=0, Image.i=-1)
    Protected *Widget, *This.Widget = AllocateStructure(Widget)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, round, Image)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  UseModule Button
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  
  Global *Button_0.Widget = AllocateStructure(Widget)
  Global *Button_1.Widget = AllocateStructure(Widget)
  
  UsePNGImageDecoder()
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Window = EventWindow()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Resize
        Resize(*Button_0, Width-70, #PB_Ignore, #PB_Ignore, Height-20)
        Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-50, #PB_Ignore)
        
        Result = 1
      Default
        ;         ; First window
        ;         Result | CallBack(*B_0, EventType()) 
        ;         Result | CallBack(*B_1, EventType()) 
        ;         Result | CallBack(*B_2, EventType()) 
        ;         Result | CallBack(*B_3, EventType()) 
        ;         Result | CallBack(*B_4, EventType()) 
        ;         
        ;         ; Second window
        ;         Result | CallBack(*Button_0, EventType()) 
        ;         Result | CallBack(*Button_1, EventType()) 
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        ForEach List()
          ; If List()\Widget\Canvas\Gadget = GetActiveGadget()
          Result | CallBack(List()\Widget, EventType()) 
          ; EndIf
        Next
        
    EndSelect
    
    If Result Or EventType() = #PB_EventType_Repaint
      If StartDrawing(CanvasOutput(Canvas))
        Box(0,0,Width,Height, $F0F0F0)
        
        ForEach List()
          Draw(List()\Widget)
        Next
        
        StopDrawing()
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure Events()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  LoadFont(0, "Arial", 18)
  
  If OpenWindow(0, 0, 0, 222+222, 205+70, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    CanvasGadget(10,  0, 0, 222+222, 205+70, #PB_Canvas_Keyboard)
    BindGadgetEvent(10, @CallBacks())
    
    *B_0 = Create(10, -1, 10, 10, 100, 80, "Standard Button Button (horizontal)", #PB_Text_MultiLine,8)
    *B_1 = Create(10, -1, 10, 100, 80, 100, "Standard Button Button (Vertical)", #PB_Widget_Vertical|#PB_Text_MultiLine,8)
    *B_2 = Create(10, -1, 120, 10, 100, 80, "Standard Button Button (horizontal)", #PB_Text_MultiLine|#PB_Text_Invert,8)
    *B_3 = Create(10, -1, 100, 100, 80, 100, "Standard Button Button (Vertical)", #PB_Widget_Vertical|#PB_Text_MultiLine|#PB_Text_Invert,8)
    
    
    ;         *B_0 = Create(10, -1, 10, 10, 100, 80, "Standard Button Button (horizontal)", #PB_Text_Right|#PB_Text_MultiLine,8)
    ;         *B_1 = Create(10, -1, 10, 100, 80, 100, "Standard Button Button (Vertical)", #PB_Text_Right|#PB_Text_Vertical|#PB_Text_MultiLine,8)
    ;         *B_2 = Create(10, -1, 120, 10, 100, 80, "Standard Button Button (horizontal)", #PB_Text_Right|#PB_Text_MultiLine|#PB_Text_Invert,8)
    ;         *B_3 = Create(10, -1, 100, 100, 80, 100, "Standard Button Button (Vertical)", #PB_Text_Right|#PB_Text_Vertical|#PB_Text_MultiLine|#PB_Text_Invert,8)
    
    
    ;     *B_0 = Create(10, -1, 10, 10, 100, 80, "Standard Button Button (horizontal)", #PB_Text_Bottom|#PB_Text_MultiLine,8)
    ;     *B_1 = Create(10, -1, 10, 100, 80, 100, "Standard Button Button (Vertical)", #PB_Text_Bottom|#PB_Text_Vertical|#PB_Text_MultiLine,8)
    ;     *B_2 = Create(10, -1, 120, 10, 100, 80, "Standard Button Button (horizontal)", #PB_Text_Bottom|#PB_Text_MultiLine|#PB_Text_Invert,8)
    ;     *B_3 = Create(10, -1, 100, 100, 80, 100, "Standard Button Button (Vertical)", #PB_Text_Bottom|#PB_Text_Vertical|#PB_Text_MultiLine|#PB_Text_Invert,8)
    
    ;     *B_4 = Create(10, -1, 230, 10, 100, 80, "Standard Button Button (horizontal)", #PB_Text_MultiLine,8)
    ;     *B_5 = Create(10, -1, 190, 100, 80, 100, "Standard Button Button (Vertical)", #PB_Text_Vertical|#PB_Text_MultiLine,8)
    
    
    *B_0 = Create(10, -1, 230, 10, 200, 20, "Standard Button", 0,8)
    *B_1 = Create(10, -1, 230, 40, 200, 20, "Left Button", #PB_Text_Left)
    *B_2 = Create(10, -1, 230, 70, 200, 20, "Right Button", #PB_Text_Right)
    *B_3 = Create(10, -1, 230,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Text_WordWrap|#PB_Button_Default, 4)
    *B_4 = Create(10, -1, 230,170, 200, 60, "Multiline Button  (longer text gets automatically multiline)", #PB_Text_MultiLine, 4)
    *B_5 = Create(10, -1, 230,170+70, 200, 25, "Toggle Button", #PB_Button_Toggle,0, 10)
    SetState(*B_5, 1)
    
    BindEvent(#PB_Event_Widget, @Events())
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
  EndIf
  
  
  Procedure ResizeCallBack()
    ResizeGadget(11, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  If OpenWindow(11, 0, 0, 325+80, 160, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    g=11
    CanvasGadget(g,  10,10,305,140, #PB_Canvas_Keyboard)
    SetGadgetAttribute(g, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    
    With *Button_0
      *Button_0 = Create(g, -1, 270, 10,  60, 120, "Button (Vertical)", #PB_Text_MultiLine | #PB_Widget_Vertical)
      ;       SetColor(*Button_0, #PB_Gadget_BackColor, $CCBFB4)
      SetColor(*Button_0, #PB_Gadget_FrontColor, $D56F1A)
      SetFont(*Button_0, FontID(0))
    EndWith
    
    With *Button_1
      ResizeImage(0, 32,32)
      *Button_1 = Create(g, -1, 10, 42, 250,  60, "Button (horizontal)", #PB_Text_MultiLine,0,0)
      ;       SetColor(*Button_1, #PB_Gadget_BackColor, $D58119)
      \Cursor = #PB_Cursor_Hand
      SetColor(*Button_1, #PB_Gadget_FrontColor, $4919D5)
      SetFont(*Button_1, FontID(0))
    EndWith
    
    ResizeWindow(11, #PB_Ignore, WindowY(0)+WindowHeight(0, #PB_Window_FrameCoordinate)+10, #PB_Ignore, #PB_Ignore)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 11)
    PostEvent(#PB_Event_SizeWindow, 11, #PB_Ignore)
    
    BindGadgetEvent(g, @CallBacks())
    PostEvent(#PB_Event_Gadget, 11,11, #PB_EventType_Resize)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf

; IDE Options = PureBasic 5.62 (MacOS X - x64)
; CursorPosition = 435
; FirstLine = 427
; Folding = ------------
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---v-f--7------------
; EnableXP
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ------------------------------
; EnableXP