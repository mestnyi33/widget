
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  DeclareModule mac_os_bug_fix
    Structure _S_drawing
      mode.i
      Attributes.i
      FontID.i
      size.NSSize
    EndStructure
    
    Global *drawing._S_drawing = AllocateStructure(_S_drawing)
    
    Macro PB(Function) : Function : EndMacro
    Macro TextHeight(Text) : TextHeight_(Text) : EndMacro
    Macro TextWidth(Text) : TextWidth_(Text) : EndMacro
    
    Macro DrawingMode(_mode_)
      DrawingMode_(_mode_)
      PB(DrawingMode)(_mode_) 
    EndMacro
    
    Macro DrawingFont(FontID)
      DrawingFont_(FontID)
      ; PB(DrawingFont)(FontID)
    EndMacro
    
    Macro ClipOutput(x, y, width, height)
      PB(ClipOutput)(x, y, width, height)
      ClipOutput_(x, y, width, height)
    EndMacro
    
    Macro UnclipOutput()
      PB(UnclipOutput)()
      ClipOutput_(0, 0, OutputWidth(), OutputHeight())
    EndMacro
    
    Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, 0, FrontColor, BackColor)
    EndMacro
    
    Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, Angle, FrontColor, BackColor)
    EndMacro
    
    Declare.i TextHeight_(Text.s)
    Declare.i TextWidth_(Text.s)
    Declare.i DrawingMode_(Mode.i)
    Declare.i DrawingFont_(FontID.i)
    Declare.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
    Declare.i ClipOutput_(x.i, y.i, width.i, height.i)
  EndDeclareModule 
  
  Module mac_os_bug_fix
    Procedure.i TextHeight_(Text.s)
      ;       Protected NSString, Attributes, NSSize.NSSize
      ;       NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
      ;       ;Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\FontID, "forKey:$", @"NSFont")
      ;       CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", *drawing\Attributes)
      ;       ProcedureReturn NSSize\height
      ProcedureReturn*drawing\size\height
    EndProcedure
    
    Procedure.i TextWidth_(Text.s)
      If Text
        Protected NSString, Attributes, NSSize.NSSize
        NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
        ;Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\FontID, "forKey:$", @"NSFont")
        CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", *drawing\Attributes)
        ProcedureReturn NSSize\width
      EndIf
    EndProcedure
    
    
    ;     Macro PB(Function)
    ;       Function
    ;     EndMacro
    Procedure.i DrawingFont_(FontID.i)
      *drawing\FontID = FontID
      
      ; *drawing\Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\FontID, "forKey:$", @"NSFont")
      *drawing\Attributes = CocoaMessage(0, 0, "NSMutableDictionary dictionaryWithObject:", *drawing\FontID, "forKey:$", @"NSFont")
      CocoaMessage(@*drawing\Size, CocoaMessage(0, 0, "NSString stringWithString:$", @""), "sizeWithAttributes:", *drawing\Attributes)
    EndProcedure
    
    Procedure.i DrawingMode_(Mode.i)
      *drawing\mode = Mode
    EndProcedure
    
    Procedure.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
      Protected.CGFloat r,g,b,a
      Protected.i Transform, NSString, Attributes, Color
      Protected Size.NSSize, Point.NSPoint
      
      If Text.s
        CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
        ;Attributes = *drawing\Attributes
        
        ;         Protected FontSize.CGFloat = 24.0
        ;          Protected Font = CocoaMessage(0, 0, "NSFont fontWithName:$", @"Arial", "size:@", @FontSize)
        CocoaMessage(0, Attributes, "setValue:", *drawing\FontID, "forKey:$", @"NSFont")
        
        r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
        
        r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(*drawing\mode&#PB_2DDrawing_Transparent=0)
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
        
        NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
        CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
        
        
        If Angle
          CocoaMessage(0, 0, "NSGraphicsContext saveGraphicsState")
          
          y = OutputHeight()-y
          Transform = CocoaMessage(0, 0, "NSAffineTransform transform")
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "rotateByDegrees:@", @Angle)
          x = 0 : y = -Size\height
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "concat")
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
          
          CocoaMessage(0, 0,  "NSGraphicsContext restoreGraphicsState")
        Else
          Point\x = x : Point\y = OutputHeight()-Size\height-y
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i ClipOutput_(x.i, y.i, width.i, height.i)
      Protected Rect.NSRect
      Rect\origin\x = x 
      Rect\origin\y = OutputHeight()-height-y
      Rect\size\width = width 
      Rect\size\height = height
      
      CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "setClip")
      ;CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "addClip")
    EndProcedure
  EndModule 
CompilerEndIf


;- >>>
DeclareModule _Constants
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf #PB_Compiler_Version < 547
      #PB_EventType_Resize
    CompilerEndIf
    
    #PB_EventType_Free
   ; #PB_EventType_Create
    
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
  EndEnumeration
  
  ;- TREE CONSTANTs
  #PB_Flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  #PB_Flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #PB_Flag_CheckBoxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
  #PB_Flag_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
  
  EnumerationBinary 16
    #PB_Flag_Collapse
    #PB_Flag_ClickSelect
    #PB_Flag_MultiSelect
    #PB_Flag_GridLines
    #PB_Flag_BorderLess
    #PB_Flag_AlwaysSelection
  EndEnumeration
  
  #PB_Tree_Collapse = #PB_Flag_Collapse
  
  #PB_Gadget_FrameColor = 10
  
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
  
  #_b_1 = 1
  #_b_2 = 2
  #_b_3 = 3
  
  
  ;- BAR CONSTANTs
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
EndDeclareModule 
;- <<<
Module _Constants
  
EndModule 

UseModule _Constants

;- >>>
;- STRUCTUREs
DeclareModule _Structures
  UseModule _Constants
  
  Prototype pFunc2()
  
  ;- - _S_event
  Structure _S_event
    widget.i
    type.l
    item.l
    *data
    *callback.pFunc2
  EndStructure
  
  ;- - _S_point
  Structure _S_point
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
  
  ;- - _S_mouse
  Structure _S_mouse
    X.i
    Y.i
    wheel_x.b
    wheel_y.b
    
    From.i ; at point widget
    Buttons.i
    *Delta._S_mouse
  EndStructure
  
  ;- - _S_align
  Structure _S_align
    Right.b
    Bottom.b
    Vertical.b
    Horizontal.b
  EndStructure
  
  ;- - _S_page
  Structure _S_page
    Pos.i
    Len.i
    *end
  EndStructure
  
  ;- - _S_flag
  Structure _S_flag
    ; InLine.b
    lines.b
    buttons.b
    gridlines.b
    checkboxes.b
    threestate.b
    collapse.b
    alwaysselection.b
    multiselect.b
    clickselect.b
    iconsize.b
  EndStructure
  
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
  
  ;- - _S_padding
  Structure _S_padding
    left.l
    top.l
    right.l
    bottom.l
  EndStructure
  
  ;- - _S_image
  Structure _S_image Extends _S_coordinate
    index.l
    handle.i
    change.b
    
    padding._S_padding
    align._S_align
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
    
    padding._S_padding
    align._S_align
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
  
  ;- - _S_line
  Structure _S_line
    v._S_coordinate
    h._S_coordinate
  EndStructure
  
  ;- - _S_Items
  Structure _S_items Extends _S_coordinate
    index.l  ; Index of new list element
    handle.i ; Adress of new list element
    
    draw.b
    hide.b
    radius.a
    sublevel.l
    childrens.l
    sublength.l
    
    _to.b
    
    text._S_text
    color._S_color
    image._S_image
    box._S_box[2]
    l._S_line ; 
    
    *last._S_items
    *first._S_items
    *parent._S_items
    
    *data      ; set/get item data
  EndStructure
  
  ;- - _S_row
  Structure _S_row 
    from.l
    draw.l
    drag.b
    
    count.l
    FontID.i
    
    sublevel.l
    sublength.l
    
    *first._S_items
    *selected._S_items
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
  
  ;- - _S_scroll
  Structure _S_scroll
    height.i
    width.i
    
    *v._S_bar
    *h._S_bar
  EndStructure
  
  ;- - _S_canvas
  Structure _S_canvas
    Mouse._S_mouse
    Gadget.i
    Window.i
    Widget.i
    
    Input.c
    Key.i[2]
  EndStructure
  
  ;- - _S_widget
  Structure _S_widget Extends _S_coordinate
    index.l  ; Index of new list element
    handle.i ; Adress of new list element
    
    type.l   ; 
    from.l   ; at point item index
    hide.b
    change.b ; is repaint widget?
    Interact.b ; будет ли взаимодействовать с пользователем?
    
    canvas._S_canvas
    scroll._S_scroll
    image._S_image
    text._S_text
    color._S_color
    flag._S_flag
    
    bs.b
    fs.b
    
    Resize.b ; 
    Radius.i
    Attribute.i
    
    *widget._S_widget
    *event._S_event
    
    row._S_row
    List *draws._S_items()
    List items._S_items()
    
    *data
  EndStructure
  
  
  Global def_colors._S_color
  
  With def_colors                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ;- Синие цвета
    ; Цвета по умолчанию
    \front[#Normal] = $80000000
    \fore[#Normal] = $FFF8F8F8 
    \back[#Normal] = $80E2E2E2
    \frame[#Normal] = $80C8C8C8
    \line[#Normal] = $FF7E7E7E
    
    ; Цвета если мышь на виджете
    \front[#Entered] = $80000000
    \fore[#Entered] = $FFFAF8F8
    \back[#Entered] = $80FCEADA
    \frame[#Entered] = $80FFC288
    \line[#Entered] = $FF7E7E7E
    
    ; Цвета если нажали на виджет
    \front[#Selected] = $FFFEFEFE
    \fore[#Selected] = $C8E9BA81;$C8FFFCFA
    \back[#Selected] = $C8E89C3D; $80E89C3D
    \frame[#Selected] = $C8DC9338; $80DC9338
    \line[#Selected] = $FF7E7E7E
    
    ; Цвета если дисабле виджет
    \front[#Disabled] = $FFBABABA
    \fore[#Disabled] = $FFF6F6F6 
    \back[#Disabled] = $FFE2E2E2 
    \frame[#Disabled] = $FFBABABA
    \line[#Disabled] = $FF7E7E7E
    
  EndWith
EndDeclareModule 

Module _Structures 
  
EndModule 
;- <<<

UseModule _Structures

;- >>>
DeclareModule Bar
  EnableExplicit
  UseModule _Constants
  UseModule _Structures
  
  Declare.b Draw(*this)
  
  Declare.b SetState(*this, ScrollPos.l)
  Declare.l SetAttribute(*this, Attribute.l, Value.l)
  
  Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b CallBack(*this, EventType.l, mouse_x.l, mouse_y.l, wheel_x.b=0, wheel_y.b=0)
  
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, Radius.l=0)
  
  Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
  Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
  
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
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ =< (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ =< (_type_\y#_mode_+_type_\height#_mode_))
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
      _this_\button\height = _this_\Height - Bool(_this_\type=#PB_GadgetType_ScrollBar)  
    EndIf
    
    ; _start_
    If _this_\button[#_b_1]\len And _this_\page\len
      If _scroll_pos_ = _this_\min
        _this_\color[#_b_1]\state = #Disabled
        _this_\button[#_b_1]\interact = 0
      Else
        If _this_\color[#_b_1]\state <> #Selected
          _this_\color[#_b_1]\state = #Normal
        EndIf
        _this_\button[#_b_1]\interact = 1
      EndIf 
    EndIf
    
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
    
    ; _stop_
    If _this_\button[#_b_2]\len And _this_\page\len
      ; Debug ""+ Bool(_this_\thumb\pos = _this_\area\end) +" "+ Bool(_scroll_pos_ = _this_\page\end)
      If _scroll_pos_ = _this_\page\end
        _this_\color[#_b_2]\state = #Disabled
        _this_\button[#_b_2]\interact = 0
      Else
        If _this_\color[#_b_2]\state <> #Selected
          _this_\color[#_b_2]\state = #Normal
        EndIf
        _this_\button[#_b_2]\interact = 1
      EndIf 
    EndIf
    
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
  
  Procedure.b Draw(*this._S_bar)
    With *this
      
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\x,\y,\width,\height,\radius,\radius,\color\back&$FFFFFF|\color\alpha<<24)
        
        If \vertical
          If (\page\len+Bool(\radius)*(\width/4)) = \height
            Line( \x, \y, 1, \page\len+1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Else
            Line( \x, \y, 1, \height, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          EndIf
        Else
          If (\page\len+Bool(\radius)*(\height/4)) = \width
            Line( \x, \y, \page\len+1, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          Else
            Line( \x, \y, \width, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
          EndIf
        EndIf
        
        If \thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\vertical,\button[#_b_3]\x,\button[#_b_3]\y,\button[#_b_3]\width,\button[#_b_3]\height,\color[3]\fore[\color[3]\state],\color[3]\back[\color[3]\state], \radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_3]\x,\button[#_b_3]\y,\button[#_b_3]\width,\button[#_b_3]\height,\radius,\radius,\color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          
          Protected h=9
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \vertical
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2-3,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+(\button[#_b_3]\width-h)/2,\button[#_b_3]\y+\button[#_b_3]\height/2+3,h,1,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Else
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2-3,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_b_3]\x+\button[#_b_3]\width/2+3,\button[#_b_3]\y+(\button[#_b_3]\height-h)/2,1,h,\color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\vertical,\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\color[#_b_1]\fore[\color[#_b_1]\state],\color[#_b_1]\back[\color[#_b_1]\state], \radius, \color\alpha)
          _box_gradient_(\vertical,\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\color[#_b_2]\fore[\color[#_b_2]\state],\color[#_b_2]\back[\color[#_b_2]\state], \radius, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\radius,\radius,\color[#_b_1]\frame[\color[#_b_1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\radius,\radius,\color[#_b_2]\frame[\color[#_b_2]\state]&$FFFFFF|\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_b_1]\x+(\button[#_b_1]\width-\button[#_b_1]\arrow_size)/2,\button[#_b_1]\y+(\button[#_b_1]\height-\button[#_b_1]\arrow_size)/2, \button[#_b_1]\arrow_size, Bool(\vertical), \color[#_b_1]\front[\color[#_b_1]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_1]\arrow_type)
          Arrow(\button[#_b_2]\x+(\button[#_b_2]\width-\button[#_b_2]\arrow_size)/2,\button[#_b_2]\y+(\button[#_b_2]\height-\button[#_b_2]\arrow_size)/2, \button[#_b_2]\arrow_size, Bool(\vertical)+2, \color[#_b_2]\front[\color[#_b_2]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_2]\arrow_type)
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  ;- 
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
  
  ;-
  Procedure.b Resize(*this._S_bar, X.l,Y.l,Width.l,Height.l)
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
  
  Procedure.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
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
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\page\len) : EndIf
      If \h\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\radius And \h\radius)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\radius And \h\radius)*(\h\height/4))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  ;-
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, Radius.l=0)
    Protected *this._S_bar = AllocateStructure(_S_bar)
    
    With *this
      \type = #PB_GadgetType_ScrollBar
      \button[#_b_1]\arrow_type =- 1
      \button[#_b_2]\arrow_type =- 1
      \button[#_b_1]\arrow_size = 4
      \button[#_b_2]\arrow_size = 4
      ;\interact = 1
      \button[#_b_1]\interact = 1
      \button[#_b_2]\interact = 1
      \button[#_b_3]\interact = 1
      \from =- 1
      \scrollstep = 1
      \radius = Radius
      
      ; Цвет фона скролла
      \color\alpha[0] = 255
      \color\alpha[1] = 0
      
      \color\back = $FFF9F9F9
      \color\frame = \color\back
      \color\front = $FFFFFFFF ; line
      
      \color[#_b_1] = def_colors
      \color[#_b_2] = def_colors
      \color[#_b_3] = def_colors
      
      \vertical = Bool(Flag&#PB_Bar_Vertical=#PB_Bar_Vertical)
      \inverted = Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted)
      
      
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
      
      If \min <> Min : SetAttribute(*this, #PB_Bar_Minimum, Min) : EndIf
      If \max <> Max : SetAttribute(*this, #PB_Bar_Maximum, Max) : EndIf
      If \page\len <> PageLength : SetAttribute(*this, #PB_Bar_PageLength, PageLength) : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.b CallBack(*this._S_bar, EventType.l, mouse_x.l, mouse_y.l, wheel_x.b=0, wheel_y.b=0)
    Protected Result, from =- 1 
    Static cursor_change, LastX, LastY, Last, *leave._S_bar, *active._S_bar, Down
    
    Macro _callback_(_this_, _type_)
      Select _type_
        Case #PB_EventType_MouseLeave ; : Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Normal 
          
        Case #PB_EventType_MouseEnter ; : Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Entered 
          
        Case #PB_EventType_LeftButtonDown ; : Debug ""+#PB_Compiler_Line +" нажали " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Selected
          
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
          _this_\color[_this_\from]\state = #Entered 
          
      EndSelect
    EndMacro
    
    With *this
      ; get at point buttons
      If Not \hide And (_from_point_(mouse_x, mouse_y, *this) Or Down)
        If \button 
          If \button[#_b_3]\len And _from_point_(mouse_x, mouse_y, \button[#_b_3])
            from = #_b_3
          ElseIf \button[#_b_2]\len And _from_point_(mouse_x, mouse_y, \button[#_b_2])
            from = #_b_2
          ElseIf \button[#_b_1]\len And _from_point_(mouse_x, mouse_y, \button[#_b_1])
            from = #_b_1
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
          If from = 0 And \button[#_b_3]\interact 
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
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    UseModule mac_os_bug_fix
  CompilerEndIf
  
  UseModule _Constants
  UseModule _Structures
  
  Macro GetCanvas(_this_)
    _this_\canvas\gadget
  EndMacro
  Global *event._S_event = AllocateStructure(_S_event)
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
  Declare.l GetItemColor(*this._S_widget, Item.l, ColorType.l, Column.l=0)
  
  Declare.i AddItem(*this, Item.l, Text.s, Image.i=-1, sublevel.i=0)
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
  Declare.i Widget(X.l, Y.l, Width.l, Height.l, Flag.i=0, Radius.l=0)
  Declare.l CallBack(*this, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
  
  Declare.l Draw(*this)
  Declare.l ReDraw(*this)
  Declare.l Resize(*this, X.l,Y.l,Width.l,Height.l)
  
  Declare.b Bind(*this, *callBack, eventtype.l=#PB_All)
  Declare.b Post(eventtype.l, *this, item.l=#PB_All, *data=0)
EndDeclareModule

Module Tree
  Macro _box_(_x_,_y_, _width_, _height_, _checked_, _type_, _color_=$FFFFFFFF, _radius_=2, _alpha_=255) 
    
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    If _checked_
      BackColor($FFB775&$FFFFFF|255<<24) 
      FrontColor($F67905&$FFFFFF|255<<24)
      
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
      RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_, $F67905&$FFFFFF|255<<24)
      
    Else
      BackColor($FFFFFF&$FFFFFF|255<<24)
      FrontColor($EEEEEE&$FFFFFF|255<<24)
      
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
      RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_, $7E7E7E&$FFFFFF|255<<24)
    EndIf
    
    If _checked_
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      
      If _type_ = 1
        Circle(_x_+5,_y_+5,2,_color_&$FFFFFF|_alpha_<<24)
        
      ElseIf _type_ = 3
        If _checked_ > 1
          Protected h = 4
          Box(_x_+(_width_-h)/2,_y_+(_height_-h)/2, h,h, _color_&$FFFFFF|_alpha_<<24) ; правая линия
        Else
          LineXY((_x_+2),(_y_+6),(_x_+3),(_y_+7),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
          LineXY((_x_+2),(_y_+7),(_x_+3),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
          
          LineXY((_x_+7),(_y_+2),(_x_+4),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; правая линия
          LineXY((_x_+8),(_y_+2),(_x_+5),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; правая линия
        EndIf
      EndIf
    EndIf
    
  EndMacro
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ =< (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ =< (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _set_active_(_this_)
    If *active <> _this_
      If *active 
        If *active\row\selected 
          *active\row\selected\color\state = 3
        EndIf
        
        If _this_\canvas\gadget <> *active\canvas\gadget 
          ; set lost focus canvas
          PostEvent(#PB_Event_Gadget, *active\canvas\window, *active\canvas\gadget, #PB_EventType_Repaint)
        EndIf
        
        *active\color\state = 0
      EndIf
      
      If _this_\row\selected And _this_\row\selected\color\state = 3
        _this_\row\selected\color\state = 2
      EndIf
      _this_\color\state = 2
      *active = _this_
      Result = #True
    EndIf
  EndMacro
  
  Macro _multi_select_(_this_,  _index_, _selected_index_)
    PushListPosition(_this_\items()) 
    ForEach _this_\items()
      If _this_\items()\draw
        _this_\items()\color\state =  Bool((_selected_index_ >= _this_\items()\index And _index_ =< _this_\items()\index) Or ; верх
                                           (_selected_index_ =< _this_\items()\index And _index_ >= _this_\items()\index)) * 2  ; вниз
      EndIf
    Next
    PopListPosition(_this_\items()) 
    
    ;     PushListPosition(_this_\draws()) 
    ;     ForEach _this_\draws()
    ;       If _this_\draws()\draw
    ;         _this_\draws()\color\state =  Bool((_selected_index_ >= _this_\draws()\index And _index_ =< _this_\draws()\index) Or ; верх
    ;                                            (_selected_index_ =< _this_\draws()\index And _index_ >= _this_\draws()\index)) * 2  ; вниз
    ;       EndIf
    ;     Next
    ;     PopListPosition(_this_\draws()) 
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
      _item_\Image\handle = ImageID(_image_)
      _this_\row\sublevel = _this_\image\padding\left + _item_\image\width
    EndIf
  EndMacro
  
  
  Global *active._S_widget
  ;-
  ;- PROCEDUREs
  ;-
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
  Procedure.l Draw(*this._S_widget)
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
    
    Macro _update_(_this_)
      If _this_\change <> 0
        _this_\scroll\width = 0
        _this_\scroll\height = 0
        
        If _this_\text\change
          _this_\Text\Height = TextHeight("A") + Bool(_this_\Flag\GridLines) + Bool(#PB_Compiler_OS = #PB_OS_Windows) * 2
          _this_\Text\Width = TextWidth(_this_\Text\String.s)
        EndIf
      EndIf
      
      If (_this_\change Or _this_\scroll\v\change Or _this_\scroll\h\change)
        ClearList(_this_\draws())
      EndIf
      
      PushListPosition(_this_\items())
      ForEach _this_\items()
        ; 
        If _this_\items()\text\fontID 
          _this_\row\fontID = _this_\items()\text\fontID 
          DrawingFont(_this_\items()\text\fontID) 
          
        ElseIf _this_\text\fontID And 
               _this_\row\fontID <> _this_\text\fontID
          _this_\row\fontID = _this_\text\fontID
          DrawingFont(_this_\text\fontID) 
        EndIf
        
        ; Получаем один раз после изменения текста  
        If _this_\items()\text\change  ;Or  _this_\text\change
          _this_\items()\text\width = TextWidth(_this_\items()\text\string.s) 
          _this_\items()\text\height = TextHeight("A") 
          _this_\items()\text\change = #False
        EndIf 
        
        If _this_\items()\hide
          _this_\items()\draw = 0
        Else
          If _this_\change
            _this_\items()\height = _this_\Text\Height
            _this_\items()\y = _this_\y[2]+_this_\scroll\height
          EndIf
          
          If (_this_\change Or _this_\scroll\v\change Or _this_\scroll\h\change)
            ; check box
            If _this_\flag\checkBoxes
              _this_\items()\box[1]\x = _this_\x[2] + 3 - _this_\scroll\h\page\pos
              _this_\items()\box[1]\y = (_this_\items()\y+_this_\items()\height)-(_this_\items()\height+_this_\items()\box[1]\height)/2-_this_\scroll\v\page\pos
            EndIf
            
            ; expanded & collapsed box
            If _this_\flag\buttons Or _this_\flag\lines 
              _this_\items()\box[0]\x = _this_\x[2] + _this_\items()\sublength - _this_\row\sublength + Bool(_this_\flag\buttons) * 4 + Bool(Not _this_\flag\buttons And _this_\flag\lines) * 8 - _this_\scroll\h\page\pos 
              _this_\items()\box[0]\y = (_this_\items()\y+_this_\items()\height)-(_this_\items()\height+_this_\items()\box[0]\height)/2-_this_\scroll\v\page\pos
            EndIf
            
            ;
            _this_\items()\image\x = _this_\x[2] + _this_\image\padding\left + _this_\items()\sublength - _this_\scroll\h\page\pos
            _this_\items()\image\y = _this_\items()\y + (_this_\items()\height-_this_\items()\image\height)/2-_this_\scroll\v\page\pos
            
            _this_\items()\text\x = _this_\x[2] + _this_\text\padding\left + _this_\items()\sublength + _this_\row\sublevel - _this_\scroll\h\page\pos
            _this_\items()\text\y = _this_\items()\y + (_this_\items()\height-_this_\items()\text\height)/2-_this_\scroll\v\page\pos
            
            _this_\items()\draw = Bool(_this_\items()\y+_this_\items()\height-_this_\scroll\v\page\pos>_this_\y[2] And 
                                       (_this_\items()\y-_this_\y[2])-_this_\scroll\v\page\pos<_this_\height[2])
            
            ; lines for tree widget
            If _this_\flag\lines And _this_\row\sublength
              _lines_(_this_, _this_\items())
            EndIf
            
            If _this_\items()\draw And 
               AddElement(_this_\Draws())
              _this_\draws() = _this_\items()
            EndIf
          EndIf
          
          If _this_\change <> 0
            _this_\scroll\height + _this_\items()\height + _this_\Flag\GridLines
            
            If _this_\scroll\h\height And _this_\scroll\width < ((_this_\items()\text\x + _this_\items()\text\width + _this_\scroll\h\page\pos) - _this_\x[2])
              _this_\scroll\width = ((_this_\items()\text\x + _this_\items()\text\width + _this_\scroll\h\page\pos) - _this_\x[2])
            EndIf
          EndIf
        EndIf
      Next
      PopListPosition(_this_\items())
      
      If _this_\scroll\v\page\len And _this_\scroll\v\max<>_this_\scroll\height-Bool(_this_\flag\gridlines) And
         Bar::SetAttribute(_this_\scroll\v, #PB_ScrollBar_Maximum, _this_\scroll\height-Bool(_this_\flag\gridlines))
        
        Bar::Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If _this_\scroll\h\page\len And _this_\scroll\h\max<>_this_\scroll\width And
         Bar::SetAttribute(_this_\scroll\h, #PB_ScrollBar_Maximum, _this_\scroll\width)
        
        Bar::Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If _this_\change <> 0
        _this_\width[2] = (_this_\scroll\v\x + Bool(_this_\scroll\v\hide) * _this_\scroll\v\width) - _this_\x[2]
        _this_\height[2] = (_this_\scroll\h\y + Bool(_this_\scroll\h\hide) * _this_\scroll\h\height) - _this_\y[2]
        
        If _this_\row\selected And _this_\row\selected\_to 
          _this_\row\selected\_to = 0
          
          Bar::SetState(_this_\scroll\v, ((_this_\row\selected\index * (_this_\text\height + _this_\Flag\GridLines)) - _this_\scroll\v\height) + _this_\text\height ) 
          _this_\scroll\v\change = 0 
          _this_\change = 1
          Draw(_this_)
        EndIf
      EndIf
      
    EndMacro
    
    Macro _draws_(_this_, _items_)
      
      PushListPosition(_items_)
      ForEach _items_
        If _items_\draw
          
          If _items_\text\fontID 
            _this_\row\fontID = _items_\text\fontID 
            DrawingFont(_items_\text\fontID) 
            
          ElseIf _this_\text\fontID And 
                 _this_\row\fontID <> _this_\text\fontID
            _this_\row\fontID = _this_\text\fontID
            DrawingFont(_this_\text\fontID) 
          EndIf
          
          Y = _items_\y - _this_\scroll\v\page\pos
          state = _items_\color\state + Bool(_this_\color\state<>2 And _items_\color\state=2)
          
          ; Draw selections
          If _items_\color\back[state]
            DrawingMode(#PB_2DDrawing_Default)
            RoundBox(_this_\x[2],Y,_this_\width[2],_items_\height,_items_\radius,_items_\radius,_items_\color\back[state])
          EndIf
          
          If _items_\color\frame[state]
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(_this_\x[2],Y,_this_\width[2],_items_\height,_items_\radius,_items_\radius, _items_\color\frame[state])
          EndIf
          
          ;           ; Draw selections
          ;           If state > 1 Or (_this_\flag\alwaysSelection And state)
          ;             If _items_\color\fore[state]
          ;               DrawingMode(#PB_2DDrawing_Gradient)
          ;               Bar::_box_gradient_(0,_this_\x[2],Y,_this_\width[2],_items_\height,_items_\color\fore[state],_items_\color\back[state],_items_\radius)
          ;             Else
          ;               DrawingMode(#PB_2DDrawing_Default)
          ;               RoundBox(_this_\x[2],Y,_this_\width[2],_items_\height,_items_\radius,_items_\radius,_items_\color\back[state])
          ;             EndIf
          ;             
          ;             DrawingMode(#PB_2DDrawing_Outlined)
          ;             RoundBox(_this_\x[2],Y,_this_\width[2],_items_\height,_items_\radius,_items_\radius, _items_\color\frame[state])
          ;           EndIf
          
          
          If _this_\row\sublength
            ; ;             ; Draw plots
            ; ;             If _this_\flag\lines
            ; ;               ; DrawingMode(#PB_2DDrawing_CustomFilter) 
            ; ;               DrawingMode(#PB_2DDrawing_XOr)
            ; ;               
            ; ;               If _items_\l\h\height
            ; ;                 ;  CustomFilterCallback(@PlotX())
            ; ;                 Line(_items_\l\h\x, _items_\l\h\y, _items_\l\h\width, _items_\l\h\height, $FF7E7E7E)
            ; ;               EndIf
            ; ;               
            ; ;               If _items_\l\v\width
            ; ;                 ;  CustomFilterCallback(@PlotY())
            ; ;                 Line(_items_\l\v\x, _items_\l\v\y, _items_\l\v\width, _items_\l\v\height, $FF7E7E7E)
            ; ;               EndIf
            ; ;             EndIf
            
            ; Draw checkbox
            If _this_\flag\checkboxes
              DrawingMode(#PB_2DDrawing_Default)
              _box_(_items_\box[1]\x, _items_\box[1]\y, _items_\box[1]\width, _items_\box[1]\height, _items_\box[1]\checked, 3, $FFFFFFFF, 2, 255)
            EndIf
            
            ; ;             ; Draw arrow
            ; ;             If _this_\flag\buttons
            ; ;               DrawingMode(#PB_2DDrawing_Default)
            ; ;               If _items_\childrens
            ; ;                 Bar::Arrow(_items_\box[0]\x+(_items_\box[0]\width-6)/2,_items_\box[0]\y+(_items_\box[0]\height-6)/2, 6, Bool(Not _items_\box[0]\checked)+2, _items_\color\front[state], 0,0) 
            ; ;                 
            ; ; ;               ElseIf _this_\row\selected And _this_\row\selected\childrens
            ; ; ;                 Bar::Arrow(_this_\row\selected\box[0]\x+(_this_\row\selected\box[0]\width-6)/2,_this_\row\selected\box[0]\y+(_this_\row\selected\box[0]\height-6)/2, 6, Bool(Not _this_\row\selected\box[0]\checked)+2, _this_\row\selected\color\front[_this_\row\selected\color\state], 0,0) 
            ; ;               EndIf
            ; ;             EndIf
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
          If _this_\Flag\GridLines And 
             _items_\color\line <> _items_\color\back
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(_this_\x[2], (_items_\y+_items_\height+Bool(_this_\flag\gridlines>1))-_this_\scroll\v\page\pos, _this_\width[2], 1, _this_\color\line)
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
      If _this_\flag\buttons
        DrawingMode(#PB_2DDrawing_Default)
        
        ForEach _items_
          If _items_\draw And _items_\childrens
            Bar::Arrow(_items_\box[0]\x+(_items_\box[0]\width-6)/2,_items_\box[0]\y+(_items_\box[0]\height-6)/2, 6, Bool(Not _items_\box[0]\checked)+2, _items_\color\front[_items_\color\state], 0,0) 
          EndIf    
        Next
      EndIf
      
      PopListPosition(_items_) ; 
    EndMacro
    
    With *this
      If Not \hide
        ; ClearItems()
        If Not \row\count
          ClearList(\draws())
          ClearList(\items())
        EndIf
        
        If \text\fontID 
          DrawingFont(\text\fontID) 
        EndIf
        
        If \change
          _update_(*this)
          \change = 0
        EndIf 
        
        ; Draw background
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\x[1],\y[1],\width[1],\height[1],\radius,\radius,\color\back[\color\state])
        
        ; Draw background image
        If \image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
        EndIf
        
        ; Draw all items
        ClipOutput(\x[2],\y[2],\width[2],\height[2])
        
        ;_draws_(*this, \items())
        _draws_(*this, \draws())
        
        UnclipOutput()
        
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
          ; RoundBox(\x[1]+Bool(\fs),\y[1]+Bool(\fs),\width[1]-Bool(\fs)*2,\height[1]-Bool(\fs)*2,\radius,\radius,0);\color\back)
          RoundBox(\x[2]-Bool(\fs),\y[2]-Bool(\fs),\width[2]+Bool(\fs)*2,\height[2]+Bool(\fs)*2,\radius,\radius,\color\back)
          RoundBox(\x[1],\y[1],\width[1],\height[1],\radius,\radius,\color\frame[2])
          ;           If \radius : RoundBox(\x[1],\y[1]-1,\width[1],\height[1]+2,\radius,\radius,\color\frame[2]) : EndIf  ; Сглаживание краев )))
          ;           RoundBox(\x[1]-1,\y[1]-1,\width[1]+2,\height[1]+2,\radius,\radius,\color\frame[2])
        ElseIf \fs
          RoundBox(\x[1],\y[1],\width[1],\height[1],\radius,\radius,\color\frame[\color\state])
        EndIf
        
        
        If \text\change : \text\change = 0 : EndIf
        If \resize : \resize = 0 : EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.l ReDraw(*this._S_widget)
    If *this
      With *this
        *this\change = 1
        
        If StartDrawing(CanvasOutput(\canvas\gadget))
          Draw(*this)
          StopDrawing()
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  ;- SETs
  Procedure.l SetText(*this._S_widget, Text.s)
    Protected Result.l
    
    If *this\row\selected 
      *this\row\selected\text\string = Text
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*this._S_widget, Font.i)
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
  
  Procedure.l SetState(*this._S_widget, State.l)
    
    With *this
      If 0 > State Or State > \row\count - 1
        If \row\selected
          State = \row\selected\color\state
          \row\selected\color\state = 0
          \row\selected\_to = 0
          \row\selected = 0
        EndIf
        
        ProcedureReturn State
      EndIf
      
      If \row\selected
        \row\selected\color\state = 0
        \row\selected\_to = 0
      EndIf
      
      \row\selected = SelectElement(\items(), State) 
      \items()\color\state = 2 
      \items()\_to = 1
    EndWith
    
  EndProcedure
  
  Procedure.i SetAttribute(*this._S_widget, Attribute.i, Value.l)
    Protected Result.i =- 1
    
    Select Attribute
      Case #PB_Flag_Collapse
        *this\flag\collapse = Bool(Not Value) 
        
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetItemColor(*this._S_widget, Item.l, ColorType.l, Color.l, Column.l=0)
    Protected Result
    
    With *this
      If Item =- 1
        PushListPosition(\items()) 
        ForEach \items()
          Select ColorType
            Case #PB_Gadget_BackColor
              \items()\color\back[Column] = Color
              
            Case #PB_Gadget_FrontColor
              \items()\color\front[Column] = Color
              
            Case #PB_Gadget_FrameColor
              \items()\color\frame[Column] = Color
              
            Case #PB_Gadget_LineColor
              \items()\color\line[Column] = Color
              
          EndSelect
        Next
        PopListPosition(\items()) 
        
      Else
        If Item >= 0 And Item < *this\row\count And SelectElement(*this\Items(), Item)
          Select ColorType
            Case #PB_Gadget_BackColor
              \items()\color\back[Column] = Color
              
            Case #PB_Gadget_FrontColor
              \items()\color\front[Column] = Color
              
            Case #PB_Gadget_FrameColor
              \items()\color\frame[Column] = Color
              
            Case #PB_Gadget_LineColor
              \items()\color\line[Column] = Color
              
          EndSelect
        EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i SetItemFont(*this._S_widget, Item.l, Font.i)
    Protected Result.i, FontID.i = FontID(Font)
    
    If Item >= 0 And Item < *this\row\count And 
       SelectElement(*this\Items(), Item) And 
       *this\Items()\text\fontID <> FontID
      *this\Items()\text\fontID = FontID
      ;       *this\Items()\text\change = 1
      ;       *this\change = 1
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetItemText(*this._S_widget, Item.l, Text.s, Column.l=0)
    Protected Result.l
    
    If Item >= 0 And Item < *this\row\count And 
       SelectElement(*this\Items(), Item) And 
       *this\Items()\text\string <> Text 
      *this\Items()\text\string = Text 
      *this\Items()\text\change = 1
      *this\change = 1
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetItemState(*this._S_widget, Item.l, State.b)
    Protected Result.l, Repaint.b, collapsed.b
    
    ;If (*this\flag\multiSelect Or *this\flag\clickSelect)
    If Item < 0 Or Item > *this\row\count - 1 
      ProcedureReturn 0
    EndIf
    
    Result = SelectElement(*this\items(), Item) 
    
    If Result 
      If State & #PB_Tree_Selected
        If *this\row\selected <> *this\items()
          *this\row\selected = *this\items()
          *this\row\selected\color\state = 2 + Bool(*active<>*this)
          Repaint = 1
        Else
          State &~ #PB_Tree_Selected
        EndIf
      EndIf
      
      If State & #PB_Tree_Inbetween
        *this\Items()\box[1]\checked = 2
      ElseIf State & #PB_Tree_Checked
        *this\Items()\box[1]\checked = 1
      EndIf
      
      If State & #PB_Tree_Collapsed
        *this\Items()\box[0]\checked = 1
        collapsed = 1
      ElseIf State & #PB_Tree_Expanded
        *this\Items()\box[0]\checked = 0
        collapsed = 1
      EndIf
      
      If collapsed And *this\Items()\childrens
        ; 
        If Not *this\hide And *this\row\draw And (*this\row\count % *this\row\draw) = 0
          *this\change = 1
          Repaint = 1
        EndIf  
        
        PushListPosition(*this\Items())
        While NextElement(*this\Items())
          If *this\items()\parent And *this\items()\sublevel > *this\items()\parent\sublevel 
            *this\items()\hide = Bool(*this\items()\parent\box[0]\checked | *this\items()\parent\hide)
          Else
            Break
          EndIf
        Wend
        PopListPosition(*this\Items())
      EndIf
      
      If State & #PB_Tree_Checked Or State & #PB_Tree_Inbetween
        Post(#PB_EventType_StatusChange, *this, Item)
      EndIf
      
      If State & #PB_Tree_Selected
        Post(#PB_EventType_Change, *this, Item)
      EndIf
      
      If Repaint
        PostEvent(#PB_Event_Gadget, *this\canvas\window, *this\canvas\gadget, #PB_EventType_Repaint)
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemImage(*this._S_widget, Item.l, Image.i)
    If Item >= 0 And Item < *this\row\count And SelectElement(*this\Items(), Item)
      _set_item_image_(*this, *this\Items(), Image)
    EndIf
  EndProcedure
  
  Procedure.i SetItemAttribute(*this._S_widget, Item.l, Attribute.i, Value.l)
    
  EndProcedure
  
  
  ;- GETs
  Procedure.s GetText(*this._S_widget)
    If *this\row\selected 
      ProcedureReturn *this\row\selected\text\string
    EndIf
  EndProcedure
  
  Procedure.i GetFont(*this._S_widget)
    ProcedureReturn *this\text\fontID
  EndProcedure
  
  Procedure.l GetState(*this._S_widget)
    Protected Result.l =- 1
    
    If *this\row\selected And *this\row\selected\color\state
      Result = *this\row\selected\index
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*this._S_widget, Attribute.i)
    Protected Result.i
    
    Select Attribute
      Case #PB_Flag_Collapse
        Result = *this\flag\collapse
        
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l GetItemColor(*this._S_widget, Item.l, ColorType.l, Column.l=0)
    Protected Result
    
    With *this
      If Item >= 0 And Item < *this\row\count And SelectElement(*this\Items(), Item)
        Select ColorType
          Case #PB_Gadget_BackColor
            Result = \items()\color\back[Column]
            
          Case #PB_Gadget_FrontColor
            Result = \items()\color\front[Column]
            
          Case #PB_Gadget_FrameColor
            Result = \items()\color\frame[Column]
            
          Case #PB_Gadget_LineColor
            Result = \items()\color\line[Column]
            
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemFont(*this._S_widget, Item.l)
    Protected Result.i =- 1
    
    If Item >= 0 And Item < *this\row\count And SelectElement(*this\items(), Item) 
      Result = *this\items()\text\FontID
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(*this._S_widget, Item.l, Column.l=0)
    Protected Result.s
    
    If Item >= 0 And Item < *this\row\count And SelectElement(*this\items(), Item) 
      Result = *this\items()\text\string
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l GetItemState(*this._S_widget, Item.l)
    Protected Result.l
    
    If Item >= 0 And Item < *this\row\count And SelectElement(*this\items(), Item) 
      If *this\items()\color\state
        Result | #PB_Tree_Selected
      EndIf
      
      If *this\Items()\box[1]\checked
        If *this\flag\threestate And *this\Items()\box[1]\checked = 2
          Result | #PB_Tree_Inbetween
        Else
          Result | #PB_Tree_Checked
        EndIf
      EndIf
      
      If *this\Items()\childrens And 
         *this\Items()\box[0]\checked = 0
        Result | #PB_Tree_Expanded
      Else
        Result | #PB_Tree_Collapsed
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemImage(*this._S_widget, Item.l)
    Protected Result.i =- 1
    
    If Item >= 0 And Item < *this\row\count And SelectElement(*this\Items(), Item)
      Result = *this\Items()\Image\index
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemAttribute(*this._S_widget, Item.l, Attribute.i, Column.l=0)
    Protected Result.i =- 1
    
    If Item < 0 : Item = 0 : EndIf
    If Item > *this\row\count - 1 
      Item = *this\row\count - 1 
    EndIf
    
    If SelectElement(*this\Items(), Item)
      Select Attribute
        Case #PB_Tree_SubLevel
          Result = *this\Items()\sublevel
      EndSelect
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  Procedure RemoveItem(*this._S_widget, Item.l) 
    
    If Item >= 0 And Item < *this\row\count And SelectElement(*this\items(), Item)
      ;       Debug ""+*this\items()\index +" "+ Item
      
      If *this\Items()\childrens
        
        PushListPosition(*this\Items())
        While NextElement(*this\Items())
          If *this\items()\parent And *this\items()\sublevel > *this\items()\parent\sublevel 
            ;Debug *this\items()\text\string
            ;*this\items()\hide = Bool(*this\items()\parent\box[0]\checked | *this\items()\parent\hide)
            DeleteElement(*this\items())
          Else
            Break
          EndIf
        Wend
        PopListPosition(*this\Items())
        
        *this\change = 1
      EndIf
      
      DeleteElement(*this\items())
      
      If *this\row\selected And *this\row\selected\index = Item 
        NextElement(*this\items())
        *this\row\selected = *this\items()
        *this\row\selected\color\state = 2 + Bool(*active<>*this)
      EndIf
      
      ; "Это на тот случай когда итеми менше первого обнавления
      If Not *this\row\draw
        ; count items < 14
        Debug ""+*this\row\count +" "+ *this\row\draw
        PushListPosition(*this\items())
        While NextElement(*this\items())
          *this\items()\index = ListIndex(*this\items())
        Wend
        PopListPosition(*this\items())
      EndIf
      
      If *this\row\draw And (*this\row\count % *this\row\draw) = 0
        Debug "    "+*this\row\count +" "+ *this\row\draw
        
        PushListPosition(*this\items())
        ForEach *this\items()
          *this\items()\index = ListIndex(*this\items())
        Next
        PopListPosition(*this\items())
        
        *this\change = 1
        PostEvent(#PB_Event_Gadget, *this\canvas\window, *this\canvas\gadget, #PB_EventType_Repaint)
      EndIf 
      
      *this\row\count - 1
      
    EndIf
  EndProcedure
  
  Procedure.l CountItems(*this._S_widget)
    ProcedureReturn *this\row\count
  EndProcedure
  
  Procedure ClearItems(*this._S_widget) 
    If *this\row\count
      *this\change = 1
      *this\row\count = 0
      Post(#PB_EventType_Change, *this, *this\from)
      PostEvent(#PB_Event_Gadget, *this\canvas\window, *this\canvas\gadget, #PB_EventType_Repaint)
    EndIf
  EndProcedure
  
  Procedure.i AddItem(*this._S_widget, Item.l, Text.s, Image.i=-1, subLevel.i=0)
    Protected handle
    Protected *parent._S_items
    
    With *this
      If *this
        ;{ Генерируем идентификатор
        If Item < 0 Or Item > ListSize(\items()) - 1
          LastElement(\items())
          handle = AddElement(\items()) 
          Item = ListIndex(\items())
        Else
          handle = SelectElement(\items(), Item)
          
          Protected Lastlevel, Parent, mac = 0
          If mac 
            PreviousElement(\items())
            If \items()\sublevel = sublevel
              Lastlevel = \items()\sublevel 
              \items()\childrens = 0
            EndIf
            SelectElement(\items(), Item)
          Else
            If sublevel < \items()\sublevel
              sublevel = \items()\sublevel  
            EndIf
          EndIf
          
          handle = InsertElement(\items())
          
          If mac And subLevel = Lastlevel
            \items()\childrens = 1
            Parent = \items()
          EndIf
          
          ; Исправляем идентификатор итема  
          PushListPosition(\items())
          While NextElement(\items())
            \items()\index = ListIndex(\items())
            
            If mac And \items()\sublevel = sublevel + 1
              \items()\parent = Parent
            EndIf
          Wend
          PopListPosition(\items())
        EndIf
        ;}
        
        If handle
          ;;;; \items() = AllocateStructure(_S_items) с ним setstate работать перестает
          \items()\handle = handle
          
          If \row\sublength
            If Not item
              \row\first = \items()
            EndIf
            
            If subLevel
              If sublevel>Item
                sublevel=Item
              EndIf
              
              PushListPosition(\items())
              While PreviousElement(\items()) 
                If subLevel = \items()\sublevel
                  *parent = \items()\parent
                  Break
                ElseIf subLevel > \items()\sublevel
                  *parent = \items()
                  Break
                EndIf
              Wend 
              PopListPosition(\items())
              
              If *parent
                If subLevel > *parent\sublevel
                  sublevel = *parent\sublevel + 1
                  *parent\childrens + 1
                  
                  If \flag\collapse
                    *parent\box[0]\checked = 1 
                    \items()\hide = 1
                  EndIf
                EndIf
                \items()\parent = *parent
              EndIf
              
              \items()\sublevel = sublevel
            EndIf
          EndIf
          
          ; add lines
          \items()\index = Item
          
          \items()\color = def_colors
          \items()\color\state = 0
          
          \items()\color\back = 0;\color\back 
          \items()\color\frame = 0;\color\back 
          
          \items()\color\fore[0] = 0 
          \items()\color\fore[1] = 0
          \items()\color\fore[2] = 0
          \items()\color\fore[3] = 0
          
          If Text
            \items()\text\string = StringField(Text.s, 1, #LF$)
            \items()\text\change = 1
          EndIf
          
          _set_item_image_(*this, \Items(), Image)
          
          If \flag\buttons
            \items()\box[0]\width = \flag\buttons
            \items()\box[0]\height = \flag\buttons
          EndIf
          
          If \flag\checkBoxes
            \items()\box[1]\width = \flag\checkBoxes
            \items()\box[1]\height = \flag\checkBoxes
          EndIf
          
          If \row\sublength
            \items()\sublength = \items()\sublevel * \row\sublength + Bool(\flag\buttons) * 20 + Bool(\flag\checkBoxes) * 18 
          EndIf
          
          \row\count + 1
          
          If Not \hide And \row\draw And (\row\count % \row\draw) = 0
            \change = 1
            PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #PB_EventType_Repaint)
            ;ReDraw(*this)
          EndIf  
          
          If \row\count ; = 1
;           ; \row\draw = \row\count
            ; \change = 1
            ; PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #PB_EventType_Repaint)
;           ; Debug ""+\row\count+" "+\row\draw 
            ; ReDraw(*this)
          EndIf
          ; 
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn handle
  EndProcedure
  
  Procedure.l Resize(*this._S_widget, X.l,Y.l,Width.l,Height.l)
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
      
      ProcedureReturn \resize
    EndWith
  EndProcedure
  
  ;-
  Procedure ToolTip(*this._S_text=0, ColorFont=0, ColorBack=0, ColorFrame=$FF)
    Protected Gadget
    Static Window
    Protected Color._S_color = def_colors
    With *this
      If *this
        ; Debug "show tooltip "+\string
        ;         If Not Window
        Window = OpenWindow(#PB_Any, \x[1]-3,\y[1],\width+8,\height[1], "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Tool) ;|#PB_Window_NoGadgets
        Gadget = CanvasGadget(#PB_Any,0,0,\width+8,\height[1])
        If StartDrawing(CanvasOutput(Gadget))
          If \fontID : DrawingFont(\fontID) : EndIf 
          DrawingMode(#PB_2DDrawing_Default)
          Box(1,1,\width-2+8,\height[1]-2, Color\back[1])
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText(3, (\height[1]-\height)/2, \string, Color\front[1])
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(0,0,\width+8,\height[1], Color\frame[1])
          StopDrawing()
        EndIf
        
        ; ;         Window = OpenWindow(#PB_Any, \x[1]-3,\y[1],\width+8,\height[1], "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Tool) ;|#PB_Window_NoGadgets
        ; ;         SetGadgetColor(ContainerGadget(#PB_Any,1,1,\width-2+8,\height[1]-2), #PB_Gadget_BackColor, Color\back[1])
        ; ;         Gadget = StringGadget(#PB_Any,0,(\height[1]-\height)/2-1,\width-2+8,\height[1]-2, \string, #PB_String_BorderLess)
        ; ;         SetGadgetColor(Gadget, #PB_Gadget_BackColor, Color\back[1])
        ; ;         SetWindowColor(Window, Color\frame[1])
        ; ;         SetGadgetFont(Gadget, \fontID)
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
  
  Procedure.l CallBack(*this._S_widget, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
    Protected Result, from =- 1
    Shared *active._S_widget
    Static *leave._S_widget
    
    Static cursor_change, LastX, LastY, Last, Down
    
    If mouse_x =- 1 And mouse_y =- 1
      Select EventType
        Case #PB_EventType_Repaint
          Debug " -- Canvas repaint -- "
        Case #PB_EventType_MouseWheel
          *this\canvas\mouse\wheel_y = GetGadgetAttribute(*this\canvas\gadget, #PB_Canvas_WheelDelta)
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
            *this\canvas\mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                         (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                         (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
          CompilerElse
            *this\canvas\mouse\buttons = GetGadgetAttribute(*this\canvas\gadget, #PB_Canvas_Buttons)
          CompilerEndIf
      EndSelect
      
      mouse_x = *this\canvas\mouse\x
      mouse_y = *this\canvas\mouse\y
    EndIf
    
    Macro _callback_(_this_, _type_)
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
          
          If _this_\row\from >= 0 And (_this_\items()\color\state = 1 Or down)
            _this_\items()\color\state = 0
            Result = #True
          EndIf
          
        Case #PB_EventType_MouseEnter  ;: Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          
          If _this_\row\from >= 0
            If down And _this_\flag\multiselect 
              _multi_select_(_this_, _this_\from, _this_\row\selected\index)
              Result = #True
              
            ElseIf _this_\items()\color\state = 0
              _this_\items()\color\state = 1+Bool(down)
              
              If down
                _this_\row\selected = _this_\items()
              EndIf
              
              Result = #True
            EndIf
          EndIf
          
        Case #PB_EventType_LeftButtonDown ; : Debug ""+#PB_Compiler_Line +" нажали " + _this_ +" "+ _this_\from
          
          If _this_\row\selected And Not _this_\flag\clickselect
            _this_\row\selected\color\state = 0
          EndIf
          
          _this_\row\selected = _this_\items()
          
          If _this_\flag\clickselect
            If _this_\row\selected\color\state = 2
              _this_\row\selected\color\state = 0
            Else
              _this_\row\selected\color\state = 2
            EndIf
          Else
            _this_\row\selected\color\state = 2
          EndIf
          
          If _this_\flag\multiselect
            _multi_select_(_this_, _this_\from, _this_\row\selected\index)
          EndIf
          
          Result = #True
          
        Case #PB_EventType_LeftButtonUp ; : Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
          
          ;           If _this_\row\selected And _this_\row\from < 0
          ;             _this_\row\selected\color\state = 0
          ;             _this_\row\selected = _this_\items()
          ;             _this_\row\selected\color\state = 2
          ;           EndIf
          
          If _this_\row\selected <> _this_\items()
            
            _this_\row\selected = _this_\items()
            _this_\row\selected\color\state = 2
            Result = #True
            
          EndIf
          
      EndSelect
    EndMacro
    
    With *this
      If \from =- 1
        Result | Bar::CallBack(\scroll\v, EventType, mouse_x, mouse_y, \canvas\mouse\wheel_x, \canvas\mouse\wheel_y)
        Result | Bar::CallBack(\scroll\h, EventType, mouse_x, mouse_y, \canvas\mouse\wheel_x, \canvas\mouse\wheel_y)
        
        If (\scroll\v\change Or \scroll\h\change)
          If StartDrawing(CanvasOutput(\canvas\gadget))
            _update_(*this)
            StopDrawing()
          EndIf
          \scroll\v\change = 0 
          \scroll\h\change = 0
        EndIf
        
        If Result
          ProcedureReturn Result
        EndIf
      EndIf
      
      ; get at point buttons
      If Not \hide And \scroll\v\from =- 1 And \scroll\h\from =- 1 And
         ((_from_point_(mouse_x, mouse_y, *this, [2]) And Not Down) Or Down = *this)
        
        ; at item from points
        ;PushListPosition(\draws())
        ForEach \draws()
          If (mouse_y > \draws()\y-\scroll\v\page\pos And
              mouse_y =< \draws()\y+\draws()\height-\scroll\v\page\pos)
            from = \draws()\index   ;  ListIndex(\draws());
            Break
          EndIf
        Next
        ;PopListPosition(\draws())
        ;         PushListPosition(\Items())
        ;         ForEach \Items()
        ;           If \items()\draw And (mouse_y > \Items()\y-\scroll\v\page\pos And
        ;               mouse_y =< \Items()\y+\Items()\height-\scroll\v\page\pos)
        ;             from = \Items()\index ; ListIndex(\Items());\index
        ;             Break
        ;           EndIf
        ;         Next
        ;         PopListPosition(\Items())
        
        If \from <> from And Not (from =- 1 And Down)
          If *leave > 0 And *leave\from >= 0
            ; _from_point_(mouse_x, mouse_y, *leave, [2]) And
            If SelectElement(*leave\Items(), *leave\from)
              
              _callback_(*leave, #PB_EventType_MouseLeave)
              *leave\from =- 1
            EndIf
          EndIf
          
          \from = from
          
          If \from >= 0 And SelectElement(\items(), \from)
            _callback_(*this, #PB_EventType_MouseEnter)
          EndIf
        EndIf
        
        *leave = *this
      Else
        If \from >= 0 ;And SelectElement(\items(), \from)
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
        Case #PB_EventType_Focus
          If *leave = *this
            _set_active_(*this)
          EndIf
          
        Case #PB_EventType_LostFocus
          If *active = *this
            If *active\row\selected 
              *active\row\selected\color\state = 3
            EndIf
            
            PostEvent(#PB_Event_Gadget, *active\canvas\window, *active\canvas\gadget, #PB_EventType_Repaint)
            *active\color\state = 0
            *active = 0
            Result = #True
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Down : \from =- 1 : from =- 1 : LastX = 0 : LastY = 0 : EndIf
          
        Case #PB_EventType_LeftDoubleClick
          If \from >= 0
            Post(#PB_EventType_LeftDoubleClick, *this, \from)
          EndIf
          
        Case #PB_EventType_RightClick
          If \from >= 0
            Post(#PB_EventType_RightClick, *this, \from)
          EndIf
          
        Case #PB_EventType_LeftButtonUp 
          If \from >= 0 And Down = *this ; SelectElement(\items(), \from)
            Down = 0 : LastX = 0 : LastY = 0
            
            If \row\from < 0
              If \row\from =- 1
                Post(#PB_EventType_Up, *this, \from, \items()\box[0]\checked)
              EndIf
              
              If \row\from =- 2
                Post(#PB_EventType_StatusChange, *this, \from, \items()\box[1]\checked)
              EndIf
              
              If \row\selected
                \row\from = \row\selected\index
              Else
                \row\from = 0
              EndIf
            EndIf
            ;Debug " "+\row\from +" "+\from
            
            If Not ((\flag\buttons And \items()\childrens And 
                     _from_point_(\canvas\mouse\x, \canvas\mouse\y, \items()\box[0])) Or
                    _from_point_(\canvas\mouse\x, \canvas\mouse\y, \items()\box[1]))
              
              _callback_(*this, #PB_EventType_LeftButtonUp)
              
              If \row\from >= 0 And \row\from <> \from : \row\from = \from
                Post(#PB_EventType_Change, *this, \from)
              EndIf
            EndIf
            
            Post(#PB_EventType_LeftClick, *this, \from)
            
            If from =- 1
              ; Debug ""+#PB_Compiler_Line +" Мышь cнаружи итема"
              _callback_(*this, #PB_EventType_MouseLeave)
              \from =- 1
            EndIf
            
            
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If *leave = *this
            _set_active_(*this)
          EndIf
          
          If from >= 0 ; And SelectElement(\items(), from)
            Down = *this
            \from = from 
            ;*leave = *this
            
            If _from_point_(\canvas\mouse\x, \canvas\mouse\y, \items()\box[1])
              \row\from =- 2
              
              If \flag\threestate
                Select \items()\box[1]\checked 
                  Case 0
                    \items()\box[1]\checked = 2
                  Case 1
                    \items()\box[1]\checked = 0
                  Case 2
                    \items()\box[1]\checked = 1
                EndSelect
              Else
                \items()\box[1]\checked ! 1
              EndIf
              
              Result = #True
            ElseIf (\flag\buttons And \items()\childrens) And
                   _from_point_(\canvas\mouse\x, \canvas\mouse\y, \items()\box[0])
              
              \row\from =- 1
              \items()\box[0]\checked ! 1
              
              PushListPosition(\items())
              While NextElement(\items())
                If \items()\parent And \items()\sublevel > \items()\parent\sublevel 
                  \items()\hide = Bool(\items()\parent\box[0]\checked | \items()\parent\hide)
                Else
                  Break
                EndIf
              Wend
              PopListPosition(\items())
              
              If StartDrawing(CanvasOutput(\canvas\gadget))
                \change = 1
                _update_(*this)
                StopDrawing()
              EndIf
              
              Result = #True
            Else
              _callback_(*this, #PB_EventType_LeftButtonDown)
            EndIf
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint, *this._S_widget = GetGadgetData(EventGadget())
    
    With *this
      Select EventType()
        Case #PB_EventType_Repaint : Repaint = 1;Bool(\row\draw=0)
          \row\draw = \row\count
          
        Case #PB_EventType_Resize : ResizeGadget(\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Resize(*this, #PB_Ignore, #PB_Ignore, GadgetWidth(\canvas\gadget), GadgetHeight(\canvas\gadget))   
          Repaint = 1
      EndSelect
      
      Repaint | CallBack(*this, EventType())
      
      If Repaint 
        ;Debug \row\count
        If *this And StartDrawing(CanvasOutput(\canvas\gadget))
          Draw(*this)
          StopDrawing()
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Widget(X.l, Y.l, Width.l, Height.l, Flag.i=0, Radius.l=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    If *this
      With *this
        \type = #PB_GadgetType_Tree
        \x =- 1
        \y =- 1
        \from =- 1
        \change = 1
        \interact = 1
        \radius = Radius
        
        ;\text\change = 1 ; set auto size items
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
        
        \fs = Bool(Not Flag&#PB_Flag_BorderLess)*2
        \bs = \fs
        
        \flag\gridlines = Bool(flag&#PB_Flag_GridLines)
        \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
        \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
        \flag\alwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
        
        \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8 ; Это еще будет размер линии
        \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер кнопки
        \flag\checkBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
        \flag\collapse = Bool(flag&#PB_Flag_Collapse) 
        \flag\threestate = Bool(flag&#PB_Flag_ThreeState) 
        
        If \flag\lines Or \flag\buttons Or \flag\checkBoxes
          \row\sublength = 18
        EndIf
        
        ;\color = def_colors
        ;         \color\fore[0] = 0
        ;         \color\fore[1] = 0
        ;         \color\fore[2] = 0
        \color\frame[#Normal] = $80C8C8C8 
        ;\color\frame[#Entered] = $80FFC288 
        \color\frame[#Selected] = $C8DC9338 
        \color\frame[#Disabled] = $FFBABABA
        \color\back[#Normal] = $FFFFFFFF 
        ;\color\back[#Entered] = $FFFFFFFF 
        \color\back[#Selected] = $FFFFFFFF 
        \color\back[#Disabled] = $FFE2E2E2 
        ; \color\line = $FFF0F0F0
      EndIf
      
      \scroll\v = Bar::Scroll(0, 0, 16, 0, 0,0,0, #PB_ScrollBar_Vertical, 7)
      \scroll\h = Bar::Scroll(0, 0, 0, Bool((\flag\buttons=0 And \flag\lines=0)=0)*16, 0,0,0, 0, 7)
      
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    If *this
      With *this
        *this = Widget(0, 0, Width, Height, Flag)
        *this\canvas\window = GetActiveWindow()
        *this\canvas\gadget = Gadget
        
        SetGadgetData(Gadget, *this)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
        PostEvent(#PB_Event_Gadget, *this\canvas\window, *this\canvas\gadget, #PB_EventType_Repaint)
      EndWith
    EndIf
    
    ProcedureReturn Gadget
  EndProcedure
  
  ;-
  Procedure.b Post(eventtype.l, *this._S_widget, item.l=#PB_All, *data=0)
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
      
      *event\widget = 0
      *event\data = 0
      *event\type =- 1
      *event\item =- 1
    EndIf
  EndProcedure
  
  Procedure.b Bind(*this._S_widget, *callBack, eventtype.l=#PB_All)
    *this\event = AllocateStructure(_S_event)
    *this\event\type = eventtype
    *this\event\callback = *callBack
  EndProcedure
  
EndModule

DeclareModule Gadget
  EnableExplicit
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Import ""
    CompilerElse
      ImportC ""
      CompilerEndIf
      PB_Object_EnumerateStart(*Object)
      PB_Object_EnumerateNext(*Object,*ID.Integer)
      PB_Object_EnumerateAbort(*Object)
      PB_Window_Objects.i
      PB_Gadget_Objects.i
      PB_Image_Objects.i
    EndImport
    
    
  ;   
  Macro SetGadgetAttribute(_gadget_, _attribute_, _value_)
    SetGadgetAttribute_(_gadget_, _attribute_, _value_)
  EndMacro
  Macro SetGadgetColor(_gadget_, _color_type_, _color_)
    SetGadgetColor_(_gadget_, _color_type_, _color_)
  EndMacro
  ;   Macro SetGadgetData(_gadget_, _value_)
  ;   EndMacro
  Macro SetGadgetFont(_gadget_, _font_id_)
    SetGadgetFont_(_gadget_, _font_id_)
  EndMacro
  Macro SetGadgetItemAttribute(_gadget_, _item_, _attribute_, _value_, _column_=0)
    SetGadgetItemAttribute_(_gadget_, _item_, _attribute_, _value_, _column_)
  EndMacro
  Macro SetGadgetItemColor(_gadget_, _item_, _color_type_, _color_, _column_=0)
    SetGadgetItemColor_(_gadget_, _item_, _color_type_, _color_, _column_)
  EndMacro
  Macro SetGadgetItemData(_gadget_, _item_, _value_)
    SetGadgetItemData_(_gadget_, _item_, _value_)
  EndMacro
  Macro SetGadgetItemImage(_gadget_, _item_, _image_id_)
    SetGadgetItemImage_(_gadget_, _item_, _image_id_)
  EndMacro
  Macro SetGadgetItemFont(_gadget_, _item_, _font_id_)
    SetGadgetItemFont_(_gadget_, _item_, _font_id_)
  EndMacro
  Macro SetGadgetItemState(_gadget_, _position_, _state_)
    SetGadgetItemState_(_gadget_, _position_, _state_)
  EndMacro
  Macro SetGadgetItemText(_gadget_, _position_, _text_, _column_=0)
    SetGadgetItemText_(_gadget_, _position_, _text_, _column_)
  EndMacro
  Macro SetGadgetState(_gadget_, _state_)
    SetGadgetState_(_gadget_, _state_)
  EndMacro
  Macro SetGadgetText(_gadget_, _text_)
    SetGadgetText_(_gadget_, _text_)
  EndMacro
  
  Macro GetGadgetAttribute(_gadget_, _attribute_)
    GetGadgetAttribute_(_gadget_, _attribute_)
  EndMacro
  Macro GetGadgetColor(_gadget_, _color_type_)
    GetGadgetColor_(_gadget_, _color_type_)
  EndMacro
  ;   Macro GetGadgetData(_gadget_)
  ;   EndMacro
  Macro GetGadgetFont(_gadget_)
    GetGadgetFont_(_gadget_)
  EndMacro
  Macro GetGadgetItemAttribute(_gadget_, _item_, _attribute_, _column_=0)
    GetGadgetItemAttribute_(_gadget_, _item_, _attribute_, _column_)
  EndMacro
  Macro GetGadgetItemColor(_gadget_, _item_, _color_type_, _column_=0)
    GetGadgetItemColor_(_gadget_, _item_, _color_type_, _column_)
  EndMacro
  Macro GetGadgetItemData(_gadget_, _item_)
    GetGadgetItemData_(_gadget_, _item_)
  EndMacro
  Macro GetGadgetItemImage(_gadget_, _item_)
    GetGadgetItemImage_(_gadget_, _item_)
  EndMacro
  Macro GetGadgetItemState(_gadget_, _position_)
    GetGadgetItemState_(_gadget_, _position_)
  EndMacro
  Macro GetGadgetItemText(_gadget_, _position_, _column_=0)
    GetGadgetItemText_(_gadget_, _position_, _column_)
  EndMacro
  Macro GetGadgetState(_gadget_)
    GetGadgetState_(_gadget_)
  EndMacro
  Macro GetGadgetText(_gadget_)
    GetGadgetText_(_gadget_)
  EndMacro
  
;   Macro AddGadgetColumn(_gadget_, _position_, Title, Width)
;     AddGadgetColumn_(_gadget_, _position_, Title, Width)
;   EndMacro
  Macro AddGadgetItem(_gadget_, _position_, _text_, _image_id_=0, Flag=0)
    AddGadgetItem_(_gadget_, _position_, _text_, _image_id_, Flag)
  EndMacro
  
  Macro CountGadgetItems(_gadget_)
    CountGadgetItems_(_gadget_)
  EndMacro
  
  Macro ClearGadgetItems(_gadget_)
    ClearGadgetItems_(_gadget_)
  EndMacro
  
  Macro RemoveGadgetItem(_gadget_, _position_)
    RemoveGadgetItem_(_gadget_, _position_)
  EndMacro
  
  ;   Macro ResizeGadget(X,Y,Width,Height)
  ;   EndMacro
  
  Macro EventData() : EventData_() : EndMacro
  Macro EventGadget() : EventGadget_() : EndMacro
  Macro EventType() : EventType_() : EndMacro
  Macro GadgetType(_gadget_) : GadgetType_(_gadget_) : EndMacro


  Macro BindGadgetEvent(_gadget_, _callback_, _eventtype_=#PB_All)
    BindGadgetEvent_(_gadget_, _callback_, _eventtype_)
  EndMacro
  
  Macro TreeGadget(_gadget_, X,Y,Width,Height, Flags=0)
    Tree::Gadget(_gadget_, X,Y,Width,Height, Flags)
  EndMacro
  
  Declare SetGadgetAttribute_(Gadget, Attribute, Value)
  Declare SetGadgetColor_(Gadget, ColorType, Color)
  Declare SetGadgetData_(Gadget, Value)
  Declare SetGadgetFont_(Gadget, FontID)
  Declare SetGadgetItemAttribute_(Gadget, Item, Attribute, Value, Column=0)
  Declare SetGadgetItemColor_(Gadget, Item, ColorType, Color, Column=0)
  Declare SetGadgetItemData_(Gadget, Item, Value)
  Declare SetGadgetItemImage_(Gadget, Item, ImageID)
  Declare SetGadgetItemState_(Gadget, Position, State)
  Declare SetGadgetItemText_(Gadget, Position, Text$, Column=0)
  Declare SetGadgetState_(Gadget, State)
  Declare SetGadgetText_(Gadget, Text$)
  
  Declare GetGadgetAttribute_(Gadget, Attribute)
  Declare GetGadgetColor_(Gadget, ColorType)
  Declare GetGadgetData_(Gadget)
  Declare GetGadgetFont_(Gadget)
  Declare GetGadgetItemAttribute_(Gadget, Item, Attribute, Column=0)
  Declare GetGadgetItemColor_(Gadget, Item, ColorType, Column=0)
  Declare GetGadgetItemData_(Gadget, Item)
  Declare GetGadgetItemImage_(Gadget, Item)
  Declare GetGadgetItemState_(Gadget, Position)
  Declare.s GetGadgetItemText_(Gadget, Position, Column=0)
  Declare GetGadgetState_(Gadget)
  Declare.s GetGadgetText_(Gadget)
  
;   Declare AddGadgetColumn_(Gadget, Position, Title$, Width)
  Declare AddGadgetItem_(Gadget, Position, Text$, ImageID=0, Flag=0)
  
  Declare BindGadgetEvent_(Gadget, *Callback, EventType=#PB_All)
  ;   Declare ResizeGadget_(X,Y,Width,Height)
  Declare SetGadgetItemFont_(Gadget, Item, FontID)
  Declare CountGadgetItems_(Gadget)
  Declare RemoveGadgetItem_(Gadget, Position)
  Declare ClearGadgetItems_(Gadget)
  Declare GadgetType_(Gadget)
  Declare EventData_()
  Declare EventType_()
  Declare EventGadget_()
EndDeclareModule

Module Gadget
  Macro PB(Function)
    Function
  EndMacro
  
  Procedure IDImage(Handle.i) ;Returns purebasic image (ID) from handle
      Protected ID.i
      
      PB_Object_EnumerateStart(PB_Image_Objects)
      
      While PB_Object_EnumerateNext(PB_Image_Objects, @ID)
        If Handle = ImageID(ID) 
          PB_Object_EnumerateAbort(PB_Image_Objects)
          ProcedureReturn ID
        EndIf
      Wend
      
      ProcedureReturn -1
    EndProcedure
           
  
  Procedure EventData_()
    If Tree::*event\data
      ProcedureReturn Tree::*event\data
    Else
      ProcedureReturn PB(EventData)()
    EndIf
  EndProcedure
  
  Procedure EventType_()
    If Tree::*event\type =- 1
      ProcedureReturn PB(EventType)()
    Else
      ProcedureReturn Tree::*event\type
    EndIf
  EndProcedure
  
  Procedure EventGadget_()
    If Tree::*event\widget
      ProcedureReturn Tree::*event\widget
    Else
      ProcedureReturn PB(EventGadget)()
    EndIf
  EndProcedure
  
  Procedure GadgetType_(Gadget)
    Protected *this._Structures::_S_widget
    
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        Protected *data = PB(GetGadgetData)(Gadget)
        If *data
          *this = *data
          ProcedureReturn *this\type
        EndIf
      Else
        ProcedureReturn PB(GadgetType)(Gadget)
      EndIf
    Else
      *this = Gadget
      ProcedureReturn *this\type
    EndIf
  EndProcedure

  Procedure BindGadgetEvent_(Gadget, *Callback, EventType=#PB_All)
    Protected *this._Structures::_S_widget
    
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        Protected *data = PB(GetGadgetData)(Gadget)
        If *data
          *this = *data
          ProcedureReturn Tree::Bind(*this, *Callback, EventType)
        EndIf
      Else
        ProcedureReturn PB(BindGadgetEvent)(Gadget, *Callback, EventType)
      EndIf
    Else
      ProcedureReturn Tree::Bind(Gadget, *Callback, EventType)
    EndIf
  EndProcedure
  
  Procedure CountGadgetItems_(Gadget)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::CountItems(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(CountGadgetItems)(Gadget)
      EndIf
    Else
      ProcedureReturn Tree::CountItems(Gadget)
    EndIf
  EndProcedure
  
  Procedure ClearGadgetItems_(Gadget)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::ClearItems(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(ClearGadgetItems)(Gadget)
      EndIf
    Else
      ProcedureReturn Tree::ClearItems(Gadget)
    EndIf
  EndProcedure
  
  Procedure RemoveGadgetItem_(Gadget, Position)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::RemoveItem(PB(GetGadgetData)(Gadget), Position)
      Else
        ProcedureReturn PB(RemoveGadgetItem)(Gadget, Position)
      EndIf
    Else
      ProcedureReturn Tree::RemoveItem(Gadget, Position)
    EndIf
  EndProcedure
  
  Procedure SetGadgetAttribute_(Gadget, Attribute, Value)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetAttribute(PB(GetGadgetData)(Gadget), Attribute, Value)
      Else
        ProcedureReturn PB(SetGadgetAttribute)(Gadget, Attribute, Value)
      EndIf
    Else
      ProcedureReturn Tree::SetAttribute(Gadget, Attribute, Value)
    EndIf
  EndProcedure
  
  Procedure SetGadgetColor_(Gadget, ColorType, Color) ; no
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
;         ProcedureReturn Tree::SetColor(PB(GetGadgetData)(Gadget), ColorType, Color)
      Else
        ProcedureReturn PB(SetGadgetColor)(Gadget, ColorType, Color)
      EndIf
    Else
;       ProcedureReturn Tree::SetColor(Gadget, ColorType, Color)
    EndIf
  EndProcedure
  
  Procedure SetGadgetData_(Gadget, Value) ; no
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
;         ProcedureReturn Tree::SetData(PB(GetGadgetData)(Gadget), Value)
      Else
        ProcedureReturn PB(SetGadgetData)(Gadget, Value)
      EndIf
    Else
;       ProcedureReturn Tree::SetData(Gadget, Value)
    EndIf
  EndProcedure
  
  Procedure SetGadgetFont_(Gadget, FontID)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetFont(PB(GetGadgetData)(Gadget), FontID)
      Else
        ProcedureReturn PB(SetGadgetFont)(Gadget, FontID)
      EndIf
    Else
      ProcedureReturn Tree::SetFont(Gadget, FontID)
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemAttribute_(Gadget, Item, Attribute, Value, Column=0) ; no
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
;         ProcedureReturn Tree::SetItemAttribute(PB(GetGadgetData)(Gadget), Item, Attribute, Value, Column)
      Else
        ProcedureReturn PB(SetGadgetItemAttribute)(Gadget, Item, Attribute, Value, Column)
      EndIf
    Else
;       ProcedureReturn Tree::SetItemAttribute(Gadget, Item, Attribute, Value, Column)
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemColor_(Gadget, Item, ColorType, Color, Column=0)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetItemColor(PB(GetGadgetData)(Gadget), Item, ColorType, Color, Column)
      Else
        ProcedureReturn PB(SetGadgetItemColor)(Gadget, Item, ColorType, Color, Column)
      EndIf
    Else
      ProcedureReturn Tree::SetItemColor(Gadget, Item, ColorType, Color, Column)
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemData_(Gadget, Item, Value) ; no
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
;         ProcedureReturn Tree::SetItemData(PB(GetGadgetData)(Gadget), Item, Value)
      Else
        ProcedureReturn PB(SetGadgetItemData)(Gadget, Item, Value)
      EndIf
    Else
;       ProcedureReturn Tree::SetItemData(Gadget, Item, Value)
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemFont_(Gadget, Item, FontID)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetItemFont(PB(GetGadgetData)(Gadget), Item, FontID)
      Else
;         ProcedureReturn PB(SetGadgetItemFont)(Gadget, Item, FontID)
      EndIf
    Else
      ProcedureReturn Tree::SetItemFont(Gadget, Item, FontID)
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemImage_(Gadget, Item, ImageID)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetItemImage(PB(GetGadgetData)(Gadget), Item, IDImage(ImageID))
      Else
        ProcedureReturn PB(SetGadgetItemImage)(Gadget, Item, ImageID)
      EndIf
    Else
      ProcedureReturn Tree::SetItemImage(Gadget, Item, IDImage(ImageID))
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemState_(Gadget, Position, State)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetItemState(PB(GetGadgetData)(Gadget), Position, State)
      Else
        ProcedureReturn PB(SetGadgetItemState)(Gadget, Position, State)
      EndIf
    Else
      ProcedureReturn Tree::SetItemState(Gadget, Position, State)
    EndIf
  EndProcedure
  
  Procedure SetGadgetItemText_(Gadget, Position, Text$, Column=0)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetItemText(PB(GetGadgetData)(Gadget), Position, Text$, Column)
      Else
        ProcedureReturn PB(SetGadgetItemText)(Gadget, Position, Text$, Column)
      EndIf
    Else
      ProcedureReturn Tree::SetItemText(Gadget, Position, Text$, Column)
    EndIf
  EndProcedure
  
  Procedure SetGadgetState_(Gadget, State)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetState(PB(GetGadgetData)(Gadget), State)
      Else
        ProcedureReturn PB(SetGadgetState)(Gadget, State)
      EndIf
    Else
      ProcedureReturn Tree::SetState(Gadget, State)
    EndIf
  EndProcedure
  
  Procedure SetGadgetText_(Gadget, Text$)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::SetText(PB(GetGadgetData)(Gadget), Text$)
      Else
        ProcedureReturn PB(SetGadgetText)(Gadget, Text$)
      EndIf
    Else
      ProcedureReturn Tree::SetText(Gadget, Text$)
    EndIf
  EndProcedure
  
  Procedure GetGadgetAttribute_(Gadget, Attribute)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetAttribute(PB(GetGadgetData)(Gadget), Attribute)
      Else
        ProcedureReturn PB(GetGadgetAttribute)(Gadget, Attribute)
      EndIf
    Else
      ProcedureReturn Tree::GetAttribute(Gadget, Attribute)
    EndIf
  EndProcedure
  
  Procedure GetGadgetColor_(Gadget, ColorType) ; no
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
;         ProcedureReturn Tree::GetColor(PB(GetGadgetData)(Gadget), ColorType)
      Else
        ProcedureReturn PB(GetGadgetColor)(Gadget, ColorType)
      EndIf
    Else
;       ProcedureReturn Tree::GetColor(Gadget, ColorType)
    EndIf
  EndProcedure
  
  Procedure GetGadgetData_(Gadget) ; no
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
;         ProcedureReturn Tree::GetData(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(GetGadgetData)(Gadget)
      EndIf
    Else
;       ProcedureReturn Tree::GetData(Gadget)
    EndIf
  EndProcedure
  
  Procedure GetGadgetFont_(Gadget)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetFont(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(GetGadgetFont)(Gadget)
      EndIf
    Else
      ProcedureReturn Tree::GetFont(Gadget)
    EndIf
  EndProcedure
  
  Procedure GetGadgetItemAttribute_(Gadget, Item, Attribute, Column=0)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
         ProcedureReturn Tree::GetItemAttribute(PB(GetGadgetData)(Gadget), Item, Attribute, Column)
      Else
        ProcedureReturn PB(GetGadgetItemAttribute)(Gadget, Item, Attribute, Column)
      EndIf
    Else
       ProcedureReturn Tree::GetItemAttribute(Gadget, Item, Attribute, Column)
    EndIf
  EndProcedure
  
  Procedure GetGadgetItemColor_(Gadget, Item, ColorType, Column=0)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetItemColor(PB(GetGadgetData)(Gadget), Item, ColorType, Column)
      Else
        ProcedureReturn PB(GetGadgetItemColor)(Gadget, Item, ColorType, Column)
      EndIf
    Else
      ProcedureReturn Tree::GetItemColor(Gadget, Item, ColorType, Column)
    EndIf
  EndProcedure
  
  Procedure GetGadgetItemData_(Gadget, Item) ; no
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
;         ProcedureReturn Tree::GetItemData(PB(GetGadgetData)(Gadget), Item)
      Else
        ProcedureReturn PB(GetGadgetItemData)(Gadget, Item)
      EndIf
    Else
;       ProcedureReturn Tree::GetItemData(Gadget, Item)
    EndIf
  EndProcedure
  
  Procedure GetGadgetItemImage_(Gadget, Item)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetItemImage(PB(GetGadgetData)(Gadget), Item)
      Else
       ; ProcedureReturn PB(GetGadgetItemImage)(Gadget, Item)
      EndIf
    Else
      ProcedureReturn Tree::GetItemImage(Gadget, Item)
    EndIf
  EndProcedure
  
  Procedure GetGadgetItemState_(Gadget, Position)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetItemState(PB(GetGadgetData)(Gadget), Position)
      Else
        ProcedureReturn PB(GetGadgetItemState)(Gadget, Position)
      EndIf
    Else
      ProcedureReturn Tree::GetItemState(Gadget, Position)
    EndIf
  EndProcedure
  
  Procedure.s GetGadgetItemText_(Gadget, Position, Column=0)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetItemText(PB(GetGadgetData)(Gadget), Position, Column)
      Else
        ProcedureReturn PB(GetGadgetItemText)(Gadget, Position, Column)
      EndIf
    Else
      ProcedureReturn Tree::GetItemText(Gadget, Position, Column)
    EndIf
  EndProcedure
  
  Procedure GetGadgetState_(Gadget)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetState(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(GetGadgetState)(Gadget)
      EndIf
    Else
      ProcedureReturn Tree::GetState(Gadget)
    EndIf
  EndProcedure
  
  Procedure.s GetGadgetText_(Gadget)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::GetText(PB(GetGadgetData)(Gadget))
      Else
        ProcedureReturn PB(GetGadgetText)(Gadget)
      EndIf
    Else
      ProcedureReturn Tree::GetText(Gadget)
    EndIf
  EndProcedure
  
  Procedure AddGadgetItem_(Gadget, Position, Text$, ImageID=0, Flag=0)
    If PB(IsGadget)(Gadget)
      If PB(GadgetType)(Gadget) = #PB_GadgetType_Canvas
        ProcedureReturn Tree::AddItem(PB(GetGadgetData)(Gadget), Position, Text$, IDImage(ImageID), Flag)
      Else
        ProcedureReturn PB(AddGadgetItem)(Gadget, Position, Text$, ImageID, Flag)
      EndIf
    Else
      ProcedureReturn Tree::AddItem(Gadget, Position, Text$, IDImage(ImageID), Flag)
    EndIf
  EndProcedure
  
;   Procedure AddGadgetColumn_(Gadget, Position, Title$, Width)
;   ;  ProcedureReturn Tree::AddColumn(PB(GetGadgetData)(Gadget), Position, Title$, Width)
;   EndProcedure
  
;   Procedure ResizeGadget_(X,Y,Width,Height)
;   ;  ProcedureReturn Tree::Resize(PB(GetGadgetData)(Gadget),X,Y,Width,Height)
;   EndProcedure
  
EndModule

;-
;- EXAMPLE
;-
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Global widget, g
  ; comment\uncomment to see
  UseModule Gadget : widget = 1
  
  UseModule tree
  Global NewList *List._S_widget()
  
 
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
    ;     Protected *this._S_bar = GetGadgetData(Canvas)
    
    Select EventType
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      *List()\canvas\gadget = EventGadget()
      *List()\canvas\window = EventWindow()
      
      Repaint | CallBack(*List(), EventType);, MouseX, MouseY)
    Next
    
    If Repaint 
      _ReDraw(Canvas)
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  
  If Not LoadImage(1, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
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
  
  If OpenWindow(0, 0, 0, 1110, 230, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define i,a
    g = 10
    TreeGadget(g, 10, 10, 210, 210, #PB_Tree_CheckBoxes|#PB_Flag_Collapse)                                         
    
    ; 1_example
    AddGadgetItem (g, 0, "Normal Item "+Str(a), 0, 0)                                   
    AddGadgetItem (g, -1, "Node "+Str(a), ImageID(1), 0)                                         
    AddGadgetItem (g, -1, "Sub-Item 1", 0, 1)                                           
    AddGadgetItem (g, -1, "Sub-Item 2", 0, 11)
    AddGadgetItem (g, -1, "Sub-Item 3", 0, 1)
    AddGadgetItem (g, -1, "Sub-Item 4", 0, 1)                                           
    AddGadgetItem (g, -1, "Sub-Item 5", 0, 11)
    AddGadgetItem (g, -1, "Sub-Item 6", 0, 1)
    AddGadgetItem (g, -1, "File "+Str(a), 0, 0)  
    
    If Not widget
      For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    EndIf
    
    SetGadgetItemState(g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    
    If widget
      LoadFont(3, "Arial", 18)
      SetGadgetFont(g, 3)
    EndIf
  
    g = 11
    TreeGadget(g, 230, 10, 210, 210)                                         
    
    ;  3_example
    AddGadgetItem(g, 0, "Tree_0", 0 )
    AddGadgetItem(g, 1, "Tree_1_1", ImageID(1), 1) 
    AddGadgetItem(g, 4, "Tree_1_1_1", 0, 2) 
    AddGadgetItem(g, 5, "Tree_1_1_2", 0, 2) 
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2 980980_", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    AddGadgetItem(g, 9, "Tree_2",0 )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    AddGadgetItem(g, 11, "Tree_4", 0 )
    AddGadgetItem(g, 12, "Tree_5", 0 )
    AddGadgetItem(g, 13, "Tree_6", 0 )
    
    If Not widget
      For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    EndIf
    
    g = 12
    TreeGadget(g, 450, 10, 210, 210, #PB_Flag_CheckBoxes|#PB_Flag_NoLines|#PB_Flag_NoButtons|#PB_Flag_MultiSelect|#PB_Flag_GridLines | #PB_Flag_ThreeState  )                            
    
    ;  2_example
    AddGadgetItem (g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5
        AddGadgetItem(g, -1, "Tree_"+Str(i), 0) 
      Else
        AddGadgetItem(g, -1, "Tree_"+Str(i), ImageID(1)) 
      EndIf
    Next
    
    If Not widget
      For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    EndIf
    
    If widget
      LoadFont(5, "Arial", 16)
      Gadget::SetGadgetItemFont_(g, 3, 5)
    EndIf
    SetGadgetItemText(g, 3, "font and text change")
    SetGadgetItemColor(g, 3, #PB_Gadget_FrontColor, $FFFFFF00)
    SetGadgetItemColor(g, 3, #PB_Gadget_BackColor, $FFFF00FF)
    BindGadgetEvent(g, @events_tree_gadget())
    
    g = 13
    TreeGadget(g, 670, 10, 210, 210, #PB_Tree_NoLines|#PB_Flag_ClickSelect)                                         
    
    ;  4_example
    AddGadgetItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_1", 0, 1) 
    AddGadgetItem(g, 3, "Tree_3_2", 0, 2) 
    
    If Not widget
      For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    EndIf
    
    g = 14
    TreeGadget(g, 890, 10, 103, 210, #PB_Tree_NoButtons)                                         
    
    ;  5_example
    AddGadgetItem(g, 0, "Tree_0 (NoButtons)", 0 )
    AddGadgetItem(g, 1, "Tree_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_1", 0, 1) 
    AddGadgetItem(g, 2, "Tree_2_2", 0, 2) 
    
    If Not widget
      For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    EndIf
    SetGadgetItemImage(g, 0, ImageID(1))
    
    g = 15
    TreeGadget(g, 890+106, 10, 103, 210, #PB_Flag_BorderLess|#PB_Flag_MultiSelect|#PB_Flag_ClickSelect)                                         
    
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
    If Not widget
      For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    EndIf
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          End 
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 8AAQAAAAAAAAwQAAAgHA-PGOAAAAGQAAYAAAAAAAAAAhAMgAADAAIAAAEAAAwhBAaQ5lBiHAAAAAGAABAHHAwBAAAUEw
; EnableXP