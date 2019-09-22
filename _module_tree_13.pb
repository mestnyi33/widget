
DeclareModule mac_os_bug_fix
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Structure _S_drawing
      mode.i
      Attributes.i
      FontID.i
      size.NSSize
    EndStructure
    
    Global *drawing._S_drawing = AllocateStructure(_S_drawing)
    
    Macro PB(Function)
      Function
    EndMacro
    
    Macro TextHeight(Text)
      TextHeight_(Text)
    EndMacro
    
    Macro TextWidth(Text)
      TextWidth_(Text)
    EndMacro
    
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
  CompilerEndIf
EndDeclareModule 

Module mac_os_bug_fix
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Procedure.i TextHeight_(Text.s)
      ;       Protected NSString, Attributes, NSSize.NSSize
      ;       NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
      ;       ;Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
      ;       CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", *drawing\attributes)
      ;       ProcedureReturn NSSize\height
      ProcedureReturn*drawing\size\height
    EndProcedure
    
    Procedure.i TextWidth_(Text.s)
      If Text
        Protected NSString, Attributes, NSSize.NSSize
        NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
        ;Attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
        CocoaMessage(@NSSize, NSString, "sizeWithAttributes:", *drawing\attributes)
        ProcedureReturn NSSize\width
      EndIf
    EndProcedure
    
    
    ;     Macro PB(Function)
    ;       Function
    ;     EndMacro
    Procedure.i DrawingFont_(FontID.i)
      *drawing\fontID = FontID
      
      ; *drawing\attributes = CocoaMessage(0, 0, "NSDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
      *drawing\attributes = CocoaMessage(0, 0, "NSMutableDictionary dictionaryWithObject:", *drawing\fontID, "forKey:$", @"NSFont")
      CocoaMessage(@*drawing\size, CocoaMessage(0, 0, "NSString stringWithString:$", @""), "sizeWithAttributes:", *drawing\attributes)
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
        ;Attributes = *drawing\attributes
        
        ;         Protected FontSize.CGFloat = 24.0
        ;          Protected Font = CocoaMessage(0, 0, "NSFont fontWithName:$", @"Arial", "size:@", @FontSize)
        CocoaMessage(0, Attributes, "setValue:", *drawing\fontID, "forKey:$", @"NSFont")
        
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
    
    Procedure OSX_NSColorToRGBA(NSColor)
      Protected.cgfloat red, green, blue, alpha
      Protected nscolorspace, rgba
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        CocoaMessage(@alpha, nscolorspace, "alphaComponent")
        rgba = RGBA(red * 255.9, green * 255.9, blue * 255.9, alpha * 255.)
        ProcedureReturn rgba
      EndIf
    EndProcedure
    
    Procedure OSX_NSColorToRGB(NSColor)
      Protected.cgfloat red, green, blue
      Protected r, g, b, a
      Protected nscolorspace, rgb
      nscolorspace = CocoaMessage(0, nscolor, "colorUsingColorSpaceName:$", @"NSCalibratedRGBColorSpace")
      If nscolorspace
        CocoaMessage(@red, nscolorspace, "redComponent")
        CocoaMessage(@green, nscolorspace, "greenComponent")
        CocoaMessage(@blue, nscolorspace, "blueComponent")
        rgb = RGB(red * 255.0, green * 255.0, blue * 255.0)
        ProcedureReturn rgb
      EndIf
    EndProcedure
    
  CompilerEndIf
EndModule 

UseModule mac_os_bug_fix

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
  EndEnumeration
  
  ;- TREE CONSTANTs
  #PB_Flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  #PB_Flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #PB_Flag_CheckBoxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
  #PB_Flag_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
  
  EnumerationBinary 16
    #PB_Flag_Collapse
    #PB_Flag_AlwaysSelection
    #PB_Flag_ClickSelect
    #PB_Flag_MultiSelect
    #PB_Flag_GridLines
    #PB_Flag_OptionBoxes
    #PB_Flag_BorderLess
  EndEnumeration
  
  #PB_Tree_Collapse = #PB_Flag_Collapse
  #PB_Tree_GridLines = #PB_Flag_GridLines
  
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
Module Constants
  
EndModule 

UseModule Constants

;- >>>
;- STRUCTUREs
DeclareModule Structures
  UseModule Constants
  
  Prototype pFunc2()
  
  ;- - _S_event
  Structure _S_event
    *active._S_widget
    *widget._S_widget
    type.l
    item.l
    draw.b
    *callback.pFunc2
    
    *data
  EndStructure
  
  ;- - _S_point
  Structure _S_point
    y.i
    x.i
  EndStructure
  
  ;- - _S_font
  Structure _S_font
    index.l  
    handle.i
    change.b
    name.s
    *size
  EndStructure
  
  ;- - _S_coordinate
  Structure _S_coordinate
    y.i[5]
    x.i[5]
    height.i[5]
    width.i[5]
  EndStructure
  
  ;- - _S_mouse
  Structure _S_mouse Extends _S_point
    wheel._S_point
    
    From.i ; at point widget
    Buttons.i
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
    OptionBoxes.b
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
  
  ;- - _S_tt
  Structure _S_tt Extends _S_coordinate
    window.i
    gadget.i
    
    visible.b
    
    text._S_text
    image._S_image
    color._S_color
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
    
    ;Font._S_font
    fontID.i
    len.l
    *optiongroup._S_items
    
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
    ;resize.l
    
    count.l
    FontID.i
    tovisible.b
    
    *tt._S_tt
    
    sublevel.l
    sublength.l
    
    ;Font._S_font
    
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
    height.l
    width.l
    
    *v._S_bar
    *h._S_bar
  EndStructure
  
  ;- - _S_canvas
  Structure _S_canvas
    window.i
    gadget.i
    ; widget.i
    
    input.c
    key.i[2]
    mouse._S_mouse
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
    
    resize.b ; 
    radius.i
    attribute.i
    
    *widget._S_widget
    *event._S_event
    
    row._S_row
    List *draws._S_items()
    List items._S_items()
    
    delta._S_point
  
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
      _this_\button\height = _this_\height - Bool(_this_\type=#PB_GadgetType_ScrollBar)  
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
      _this_\button[#_b_2]\y = _this_\Y+_this_\height-_this_\button[#_b_2]\height
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
        _this_\button[#_b_2]\height = _this_\height/2 
        _this_\button[#_b_2]\y = _this_\y+_this_\button[#_b_2]\height+Bool(_this_\height%2) 
        
        _this_\button[#_b_1]\y = _this_\y 
        _this_\button[#_b_1]\height = _this_\height/2
        
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
            
            If \max = 0
              \page\pos = 0
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
  UseModule mac_os_bug_fix
  UseModule Constants
  UseModule Structures
  
  Macro GetCanvas(_this_)
    _this_\canvas\gadget
  EndMacro
  
  Global *event._S_event = AllocateStructure(_S_event)
  
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
  
  Declare.i AddItem(*this, Item.l, Text.s, Image.i=-1, sublevel.i=0)
  
  Declare.i Gadget(Gadget.i, X.l, Y.l, Width.l, Height.l, Flag.i=0)
  Declare.i Widget(X.l, Y.l, Width.l, Height.l, Flag.i=0, Radius.l=0)
  Declare.l CallBack(*this, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
  Declare   Free(*this)
  
  Declare.l Draw(*this)
  Declare.l ReDraw(*this, canvas_backcolor=#Null)
  Declare.l Resize(*this, X.l,Y.l,Width.l,Height.l)
  
  Declare.b Bind(*this, *callBack, eventtype.l=#PB_All)
  Declare.b Post(eventtype.l, *this, item.l=#PB_All, *data=0)
EndDeclareModule

Module Tree
  Macro _box_(_x_,_y_, _width_, _height_, _checked_, _type_, _color_=$FFFFFFFF, _radius_=2, _alpha_=255) 
    
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
        RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_, $F67905&$FFFFFF|255<<24)
        
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
        RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_, $7E7E7E&$FFFFFF|255<<24)
        
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
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ =< (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ =< (_type_\y#_mode_+_type_\height#_mode_))
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
      _item_\image\handle = ImageID(_image_)
      _this_\row\sublevel = _this_\image\padding\left + _item_\image\width
    Else
      _item_\image\index =- 1
    EndIf
  EndMacro
  
  Macro _set_active_(_this_)
    If *event\active <> _this_
      If *event\active 
        If *event\active\row\selected 
          *event\active\row\selected\color\state = 3
        EndIf
        
        If _this_\canvas\gadget <> *event\active\canvas\gadget 
          ; set lost focus canvas
          PostEvent(#PB_Event_Gadget, *event\active\canvas\window, *event\active\canvas\gadget, #PB_EventType_Repaint, *event\active)
        EndIf
        
        *event\active\color\state = 0
      EndIf
      
      If _this_\row\selected And _this_\row\selected\color\state = 3
        _this_\row\selected\color\state = 2
      EndIf
      
      _this_\color\state = 2
      *event\active = _this_
      Result = #True
    EndIf
  EndMacro
  
  Macro _repaint_(_this_)
    If _this_\row\count = 0 Or 
       (Not _this_\hide And _this_\row\draw And 
        (_this_\row\count % _this_\row\draw) = 0)
      
      _this_\change = 1
      _this_\row\draw = _this_\row\count
      PostEvent(#PB_Event_Gadget, _this_\canvas\window, _this_\canvas\gadget, #PB_EventType_Repaint, _this_)
    EndIf  
  EndMacro
  
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
    
    Macro _update_(_this_, _items_)
      If _this_\change <> 0
        _this_\scroll\width = 0
        _this_\scroll\height = 0
      EndIf
      
      If (_this_\change Or _this_\scroll\v\change Or _this_\scroll\h\change)
        ClearList(_this_\draws())
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
            If _this_\flag\checkBoxes Or _this_\flag\OptionBoxes
              _items_\box[1]\x = _items_\x + 3 - _this_\scroll\h\page\pos
              _items_\box[1]\y = (_items_\y+_items_\height)-(_items_\height+_items_\box[1]\height)/2-_this_\scroll\v\page\pos
            EndIf
            
            ; expanded & collapsed box
            If _this_\flag\buttons Or _this_\flag\lines 
              _items_\box[0]\x = _items_\x + _items_\sublength - _this_\row\sublength + Bool(_this_\flag\buttons) * 4 + Bool(Not _this_\flag\buttons And _this_\flag\lines) * 8 - _this_\scroll\h\page\pos 
              _items_\box[0]\y = (_items_\y+_items_\height)-(_items_\height+_items_\box[0]\height)/2-_this_\scroll\v\page\pos
            EndIf
            
            ;
            _items_\image\x = _items_\x + _this_\image\padding\left + _items_\sublength - _this_\scroll\h\page\pos
            _items_\image\y = _items_\y + (_items_\height-_items_\image\height)/2-_this_\scroll\v\page\pos
            
            _items_\text\x = _items_\x + _this_\text\padding\left + _items_\sublength + _this_\row\sublevel - _this_\scroll\h\page\pos
            _items_\text\y = _items_\y + (_items_\height-_items_\text\height)/2-_this_\scroll\v\page\pos
            
            _items_\draw = Bool(_items_\y+_items_\height-_this_\scroll\v\page\pos>_this_\y[2] And 
                                (_items_\y-_this_\y[2])-_this_\scroll\v\page\pos<_this_\height[2])
            
            ; lines for tree widget
            If _this_\flag\lines And _this_\row\sublength
              _lines_(_this_, _items_)
            EndIf
            
            If _items_\draw And 
               AddElement(_this_\Draws())
              _this_\draws() = _items_
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
        
        If _this_\row\selected And _this_\row\tovisible
          Bar::SetState(_this_\scroll\v, ((_this_\row\selected\index * (_this_\row\selected\height + _this_\flag\GridLines)) - _this_\scroll\v\height) + _this_\row\selected\height ) 
          _this_\scroll\v\change = 0 
          _this_\row\tovisible = 0
          ;_this_\change = 1
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
            RoundBox(_this_\x[2],Y,_this_\width[2],_items_\height,_items_\radius,_items_\radius,_items_\color\back[state])
          EndIf
          
          ; Draw select frame
          If _items_\color\frame[state]
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(_this_\x[2],Y,_this_\width[2],_items_\height,_items_\radius,_items_\radius, _items_\color\frame[state])
          EndIf
          
          ; Draw checkbox
          ; Draw option
          If _this_\flag\OptionBoxes And _items_\parent
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
        If \text\fontID 
          DrawingFont(\text\fontID) 
        EndIf
        
        If \change
          If \text\change
            \text\height = TextHeight("A") + Bool(#PB_Compiler_OS = #PB_OS_Windows) * 2
            \text\width = TextWidth(\text\string.s)
          EndIf
          
          _update_(*this, \items())
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
  
  Procedure.l ReDraw(*this._S_widget, canvas_backcolor=#Null)
    If *this
      With *this
        If StartDrawing(CanvasOutput(\canvas\gadget))
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
    Protected *Result
    
    With *this
      If State >= 0 And State < \row\count
        *Result = SelectElement(\items(), State) 
      EndIf
      
      If \row\selected <> *Result
        If \row\selected
          \row\selected\color\state = 0
        EndIf
        
        \row\selected = *Result
        
        If \row\selected
          \row\selected\color\state = 2
          \row\tovisible = 1
        EndIf
        
        _repaint_(*this)
      EndIf
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
        If Item >= 0 And Item < *this\row\count And SelectElement(*this\items(), Item)
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
       SelectElement(*this\items(), Item) And 
       *this\items()\text\fontID <> FontID
      *this\items()\text\fontID = FontID
      ;       *this\items()\text\change = 1
      ;       *this\change = 1
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetItemText(*this._S_widget, Item.l, Text.s, Column.l=0)
    Protected Result.l
    
    If Item >= 0 And Item < *this\row\count And 
       SelectElement(*this\items(), Item) And 
       *this\items()\text\string <> Text 
      *this\items()\text\string = Text 
      *this\items()\text\change = 1
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
          If *this\row\selected
            *this\row\selected\color\state = 0
          EndIf
          
          *this\row\selected = *this\items()
          *this\row\selected\color\state = 2 + Bool(*event\active<>*this)
          Repaint = 1
        Else
          State &~ #PB_Tree_Selected
        EndIf
      EndIf
      
      If State & #PB_Tree_Inbetween
        *this\items()\box[1]\checked = 2
      ElseIf State & #PB_Tree_Checked
        *this\items()\box[1]\checked = 1
      EndIf
      
      If State & #PB_Tree_Collapsed
        *this\items()\box[0]\checked = 1
        collapsed = 1
      ElseIf State & #PB_Tree_Expanded
        *this\items()\box[0]\checked = 0
        collapsed = 1
      EndIf
      
      If collapsed And *this\items()\childrens
        ; 
        If Not *this\hide And *this\row\draw And (*this\row\count % *this\row\draw) = 0
          *this\change = 1
          Repaint = 1
        EndIf  
        
        PushListPosition(*this\items())
        While NextElement(*this\items())
          If *this\items()\parent And *this\items()\sublevel > *this\items()\parent\sublevel 
            *this\items()\hide = Bool(*this\items()\parent\box[0]\checked | *this\items()\parent\hide)
          Else
            Break
          EndIf
        Wend
        PopListPosition(*this\items())
      EndIf
      
      If State & #PB_Tree_Checked Or State & #PB_Tree_Inbetween
        Post(#PB_EventType_StatusChange, *this, Item)
      EndIf
      
      If State & #PB_Tree_Selected
        Post(#PB_EventType_Change, *this, Item)
      EndIf
      
      If Repaint
        _repaint_(*this)
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemImage(*this._S_widget, Item.l, Image.i) ; Ok
    If Item >= 0 And Item < *this\row\count And SelectElement(*this\items(), Item)
      If *this\items()\image\index <> Image
        _set_item_image_(*this, *this\items(), Image)
        _repaint_(*this)
      EndIf
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
      If Item >= 0 And Item < *this\row\count And SelectElement(*this\items(), Item)
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
      Result = *this\items()\text\fontID
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
      
      If *this\items()\box[1]\checked
        If *this\flag\threestate And *this\items()\box[1]\checked = 2
          Result | #PB_Tree_Inbetween
        Else
          Result | #PB_Tree_Checked
        EndIf
      EndIf
      
      If *this\items()\childrens And 
         *this\items()\box[0]\checked = 0
        Result | #PB_Tree_Expanded
      Else
        Result | #PB_Tree_Collapsed
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemImage(*this._S_widget, Item.l)
    Protected Result.i =- 1
    
    If Item >= 0 And Item < *this\row\count And SelectElement(*this\items(), Item)
      Result = *this\items()\image\index
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemAttribute(*this._S_widget, Item.l, Attribute.i, Column.l=0)
    Protected Result.i =- 1
    
    If Item < 0 : Item = 0 : EndIf
    If Item > *this\row\count - 1 
      Item = *this\row\count - 1 
    EndIf
    
    If SelectElement(*this\items(), Item)
      Select Attribute
        Case #PB_Tree_SubLevel
          Result = *this\items()\sublevel
      EndSelect
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  Procedure RemoveItem(*this._S_widget, Item.l) 
    Protected sublevel.l
    
    If Item >= 0 And Item < *this\row\count And SelectElement(*this\items(), Item)
      ;       Debug ""+*this\items()\index +" "+ Item
      
      If *this\items()\childrens
        sublevel = *this\items()\sublevel
        
        PushListPosition(*this\items())
        While NextElement(*this\items())
          If *this\items()\sublevel > sublevel 
            ;Debug *this\items()\text\string
            DeleteElement(*this\items())
            *this\row\count - 1
            *this\row\draw - 1
          Else
            Break
          EndIf
        Wend
        PopListPosition(*this\items())
        
        *this\change = 1
      EndIf
      
      DeleteElement(*this\items())
      
      If (*this\row\draw And (*this\row\count % *this\row\draw) = 0) Or 
         *this\row\draw < 2 ; Это на тот случай когда итеми менше первого обнавления
        
        ; Debug "    "+*this\row\count +" "+ *this\row\draw
        
        PushListPosition(*this\items())
        ForEach *this\items()
          *this\items()\index = ListIndex(*this\items())
        Next
        PopListPosition(*this\items())
      EndIf 
      
      If *this\row\selected And *this\row\selected\index >= Item 
        *this\row\selected\color\state = 0
        
        PushListPosition(*this\items())
        If *this\row\selected\index <> Item 
          SelectElement(*this\items(), *this\row\selected\index)
        EndIf
        
        While NextElement(*this\items())
          If *this\items()\sublevel = sublevel 
            *this\row\selected = *this\items()
            *this\row\selected\color\state = 2 + Bool(*event\active<>*this)
            Break
          EndIf
        Wend
        PopListPosition(*this\items())
      EndIf
      
      _repaint_(*this)
      *this\row\count - 1
      ; надо подумать
      ; *this\row\sublevel = 0
    EndIf
  EndProcedure
  
  Procedure.l CountItems(*this._S_widget) ; Ok
    ProcedureReturn *this\row\count
  EndProcedure
  
  Procedure ClearItems(*this._S_widget) ; Ok
    If *this\row\count <> 0
      *this\change =- 1
      *this\row\draw = 0
      *this\row\count = 0
      *this\row\sublevel = 0
      
      If *this\row\selected 
        *this\row\selected\color\state = 0
        *this\row\selected = 0
      EndIf
      
      ClearList(*this\items())
      
      If StartDrawing(CanvasOutput(*this\canvas\gadget))
        Draw(*this)
        StopDrawing()
      EndIf
      Post(#PB_EventType_Change, *this, #PB_All)
    EndIf
  EndProcedure
  
  Procedure.i AddItem(*this._S_widget, Item.l, Text.s, Image.i=-1, subLevel.i=0)
    Protected handle, *parent._S_items
    
    With *this
      If *this
        If \flag\OptionBoxes
          If subLevel > 1
            subLevel = 1
          EndIf
        EndIf
        
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
          
          
          If \flag\OptionBoxes 
            If \items()\parent ; ListSize(*Value\OpenedList()\childrens()) 
                               ;               If \items()\parent\optiongroup; *Value\OpenedList()\childrens()\type = #PB_GadgetType_Option
                               ;                 \items()\optiongroup = *Value\OpenedList()\childrens()\optiongroup 
                               ;               Else
                               ;                 \items()\optiongroup = *Value\OpenedList()\childrens() 
                               ;               EndIf
              \items()\optiongroup = \items()\parent
            Else
              \items()\optiongroup = \row\first
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
          
          _set_item_image_(*this, \items(), Image)
          
          If \flag\buttons
            \items()\box[0]\width = \flag\buttons
            \items()\box[0]\height = \flag\buttons
          EndIf
          
          If \flag\checkBoxes Or \flag\OptionBoxes
            \items()\box[1]\width = \flag\checkBoxes
            \items()\box[1]\height = \flag\checkBoxes
          EndIf
          
          If \row\sublength 
            If (\flag\buttons Or \flag\lines)
              \items()\sublength = \items()\sublevel * \row\sublength + Bool(\flag\buttons) * 20 + Bool(\flag\checkBoxes) * 18 
            Else
              \items()\sublength =  Bool(\flag\checkBoxes) * 18 
            EndIf
          EndIf
          
          If *this\row\selected 
            *this\row\selected\color\state = 0
            *this\row\selected = *this\items() 
            *this\row\selected\color\state = 2 + Bool(*event\active<>*this)
          EndIf
          
          _repaint_(*this)
          \row\count + 1
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
  Declare tt_close(*this._S_tt)
  
  Procedure tt_draw(*this._S_tt, *color._S_color=0)
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
    ;     ;SetActiveWindow(*event\widget\canvas\window)
    ;     ;SetActiveGadget(*event\widget\canvas\gadget)
    ;     
    ;     If *event\widget\row\selected
    ;       *event\widget\row\selected\color\State = 0
    ;     EndIf
    ;     
    ;     *event\widget\row\selected = *event\widget\items()
    ;     *event\widget\items()\color\State = 2
    ;     *event\widget\color\State = 2
    ;     
    ;     ;ReDraw(*event\widget)
    
    tt_close(GetWindowData(EventWindow()))
  EndProcedure
  
  Procedure tt_creare(*this._S_widget, x,y)
    With *this
      If *this
        *event\widget = *this
        \row\tt = AllocateStructure(_S_tt)
        \row\tt\visible = 1
        \row\tt\x = x+\items()\x+\items()\width-1
        \row\tt\y = y+\items()\y-\scroll\v\page\pos
        \row\tt\width = \items()\len - \items()\width + 5
        \row\tt\height = \items()\height
        
        \row\tt\Window = OpenWindow(#PB_Any, \row\tt\x, \row\tt\y, \row\tt\width, \row\tt\height, "", 
                                    #PB_Window_BorderLess|#PB_Window_NoActivate, WindowID(\canvas\window))
        
        \row\tt\gadget = CanvasGadget(#PB_Any,0,0, \row\tt\width, \row\tt\height)
        \row\tt\color = \items()\color
        \row\tt\text = \items()\text
        \row\tt\text\fontID = \items()\fontID
        \row\tt\text\x =- (\width[2]-(\items()\text\x-\items()\x)) + 1
        \row\tt\text\y = (\items()\text\y-\items()\y)+\scroll\v\page\pos
        
        BindEvent(#PB_Event_ActivateWindow, @tt_CallBack(), \row\tt\Window)
        SetWindowData(\row\tt\Window, \row\tt)
        tt_draw(\row\tt)
      EndIf
    EndWith              
  EndProcedure
  
  Procedure tt_close(*this._S_tt)
    If IsWindow(*this\window)
      *this\visible = 0
      ;UnbindEvent(#PB_Event_ActivateWindow, @tt_CallBack(), *this\window)
      CloseWindow(*this\window)
      ; ClearStructure(*this, _S_tt) ;??????
    EndIf
  EndProcedure
  
  
  ;-
  Procedure.l CallBack(*this._S_widget, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
    Protected Result, from =- 1
    Static *leave._S_widget
    
    If Not *this\handle
      ProcedureReturn 0
    EndIf
    
    Static cursor_change, LastX, LastY, Last, Down
    
    If mouse_x =- 1 And mouse_y =- 1
      Select EventType
        Case #PB_EventType_Repaint
          Debug " -- Canvas repaint -- " + *this\row\draw
        Case #PB_EventType_MouseWheel
          *this\canvas\mouse\wheel\y = GetGadgetAttribute(*this\canvas\gadget, #PB_Canvas_WheelDelta)
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
        Case #PB_EventType_MouseLeave  ;: Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          
          If _this_\row\from >= 0 
            If (_this_\items()\color\state = 1 Or down)
              _this_\items()\color\state = 0
            EndIf
            
            ; close tooltip on the item
            If _this_\row\tt And _this_\row\tt\visible
              tt_close(_this_\row\tt)
            EndIf
            
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
            
            ; create tooltip on the item
            If Bool((_this_\flag\buttons=0 And _this_\flag\lines=0)) And _this_\items()\len > _this_\width[2]
              tt_creare(_this_, GadgetX(_this_\canvas\gadget, #PB_Gadget_ScreenCoordinate), GadgetY(_this_\canvas\gadget, #PB_Gadget_ScreenCoordinate))
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
          
          If _this_\row\tt And _this_\row\tt\visible
            tt_close(_this_\row\tt)
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
        Result | Bar::CallBack(\scroll\v, EventType, mouse_x, mouse_y, \canvas\mouse\wheel\x, \canvas\mouse\wheel\y)
        Result | Bar::CallBack(\scroll\h, EventType, mouse_x, mouse_y, \canvas\mouse\wheel\x, \canvas\mouse\wheel\y)
        
        If (\scroll\v\change Or \scroll\h\change)
          If StartDrawing(CanvasOutput(\canvas\gadget))
            _update_(*this, \items())
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
          If (mouse_y >= \draws()\y-\scroll\v\page\pos And
              mouse_y < \draws()\y+\draws()\height-\scroll\v\page\pos)
            from = \draws()\index   ;  ListIndex(\draws());
            Break
          EndIf
        Next
        ;PopListPosition(\draws())
        ;         PushListPosition(\items())
        ;         ForEach \items()
        ;           If \items()\draw And (mouse_y >= \items()\y-\scroll\v\page\pos And
        ;               mouse_y < \items()\y+\items()\height-\scroll\v\page\pos)
        ;             from = \items()\index ; ListIndex(\items());\index
        ;             Break
        ;           EndIf
        ;         Next
        ;         PopListPosition(\items())
        
        If \from <> from And Not (from =- 1 And Down)
          If *leave > 0 And *leave\from >= 0
            ; _from_point_(mouse_x, mouse_y, *leave, [2]) And
            If SelectElement(*leave\items(), *leave\from)
              
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
          ;         Case #PB_EventType_MouseEnter
          ;           If *leave = *this
          ;             Debug \from
          ;             If \from >= 0 And SelectElement(\items(), \from)
          ;               Debug " - "+ \items()\text\string
          ;               _callback_(*this, #PB_EventType_MouseEnter)
          ;             EndIf
          ;           EndIf
          
          ;         Case #PB_EventType_MouseLeave
          ; ;          If *leave = *this
          ; ; ;           If Not \row\tt ; \from >= 0 And SelectElement(\items(), \from)
          ; ; ;             Debug " ---- -- "+ \items()\text\string
          ; ; ;             _callback_(*this, #PB_EventType_MouseLeave)
          ; ; ;           EndIf
          ; ;         EndIf
          ;         Case #PB_EventType_MouseLeave 
          ;           If Not Down : \from =- 1 : from =- 1 : LastX = 0 : LastY = 0 : EndIf
          ;           
          
        Case #PB_EventType_MouseMove
          If Down And Down = *this And \row\drag = 0 And
             (Abs((mouse_x-\delta\x)+(mouse_y-\delta\y)) >= 6)
            \row\drag = 1
            
            If \row\from <> \from
              Post(#PB_EventType_Change, *this, \from)
            EndIf
            Post(#PB_EventType_DragStart, *this, \from)
            
          EndIf
          
          ;         Case #PB_EventType_Focus
          ;           If *leave = *this
          ;             _set_active_(*this)
          ;           EndIf
          
        Case #PB_EventType_LostFocus
          ; если фокус получил PB gadget
          ; то убираем фокус с виджета
          If *event\active = *this
            If *event\active\row\selected 
              *event\active\row\selected\color\state = 3
            EndIf
            
            PostEvent(#PB_Event_Gadget, *event\active\canvas\window, *event\active\canvas\gadget, #PB_EventType_Repaint)
            *event\active\color\state = 0
            *event\active = 0
            Result = #True
          EndIf
          
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
            
            ; Debug " "+\row\from +" "+\from
            
            If Not ((\flag\buttons And \items()\childrens And 
                     _from_point_(\canvas\mouse\x, \canvas\mouse\y, \items()\box[0])) Or
                    _from_point_(\canvas\mouse\x, \canvas\mouse\y, \items()\box[1]))
              
              _callback_(*this, #PB_EventType_LeftButtonUp)
              
              If (\row\from >= 0 And \row\from <> \from) Or Not \row\from : \row\from = \from
                If Not \row\drag
                  Post(#PB_EventType_Change, *this, \from)
                EndIf
              EndIf
            EndIf
            
            If \row\drag 
              \row\drag = 0
            Else
              Post(#PB_EventType_LeftClick, *this, \from)
            EndIf
            
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
            \delta\x = mouse_x
            \delta\y = mouse_y
            
            If _from_point_(\canvas\mouse\x, \canvas\mouse\y, \items()\box[1])
              \row\from =- 2
              
              If \flag\OptionBoxes
                
                ;Debug ""+\items()\optiongroup\text\string +" "+ \items()\optiongroup\box[1]\checked
                If \items()\optiongroup\box[1]\checked  And (Not \items()\parent  And Not \items()\childrens)
                  \items()\optiongroup\box[1]\checked = 0
                EndIf
                
                If \items()\optiongroup\optiongroup <> \items()  And \items()\parent
                  If \items()\optiongroup\optiongroup
                    \items()\optiongroup\optiongroup\box[1]\checked = 0
                  EndIf
                  \items()\optiongroup\optiongroup = \items()
                EndIf
                
                \items()\box[1]\checked ! 1
                
              Else
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
              EndIf
              
              Result = #True
            ElseIf (\flag\buttons And \items()\childrens) And
                   _from_point_(\canvas\mouse\x, \canvas\mouse\y, \items()\box[0])
              
              \change = 1
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
                _update_(*this, \items())
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
  
  Procedure w_Callback()
    Debug "-- Window repaint --"
  EndProcedure
  
  Procedure g_CallBack()
    Protected Repaint.b
    Protected EventType.i = EventType()
    Protected *this._S_widget = GetGadgetData(EventGadget())
    
    With *this
      Select EventType
        Case #PB_EventType_Repaint
          \row\draw = \row\count
          Repaint = 1
          
        Case #PB_EventType_Resize : ResizeGadget(\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Resize(*this, #PB_Ignore, #PB_Ignore, GadgetWidth(\canvas\gadget), GadgetHeight(\canvas\gadget))   
          
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
          
          If StartDrawing(CanvasOutput(\canvas\gadget))
            Draw(*this)
            StopDrawing()
          EndIf
      EndSelect
      
      Repaint | CallBack(*this, EventType)
      
      If Repaint And 
         StartDrawing(CanvasOutput(\canvas\gadget))
        Draw(*this)
        StopDrawing()
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Widget(X.l, Y.l, Width.l, Height.l, Flag.i=0, Radius.l=0)
    Static index
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    If *this
      With *this
        \handle = *this
        \index = index : index + 1
        \type = #PB_GadgetType_Tree
        \x =- 1
        \y =- 1
        \from =- 1
        \change = 1
        
        \interact = 1
        \radius = Radius
        
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
        
        \flag\OptionBoxes = Bool(flag&#PB_Flag_OptionBoxes)*12; Это еще будет размер
        If \flag\OptionBoxes
          \flag\checkBoxes = 12; Это еще будет размер чек бокса
        EndIf
        
        
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
        BindGadgetEvent(Gadget, @g_CallBack())
        ;BindEvent(#PB_Event_Repaint, @w_CallBack() )
        _repaint_(*this)
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
  
  Procedure Free(*this._S_widget)
    Protected Gadget = *this\canvas\gadget
    
    ClearStructure(*this\scroll\v, _S_bar)
    ClearStructure(*this\scroll\h, _S_bar)
    ClearStructure(*this, _S_widget)
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
  UseModule tree
  Global Canvas_0
  Global *g._S_widget
  Global *g0._S_widget
  Global *g1._S_widget
  Global *g2._S_widget
  Global *g3._S_widget
  Global *g4._S_widget
  Global *g5._S_widget
  Global *g6._S_widget
  Global *g7._S_widget
  Global *g8._S_widget
  Global *g9._S_widget
  
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
  
  Global g_Canvas, NewList *List._S_widget()
  
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
    Protected *this._S_widget ; = GetGadgetData(Canvas)
    
    Select EventType
      Case #PB_EventType_Repaint
        *this = EventData()
        
        If *this And *this\handle
          *this\row\draw = *this\row\count
          CallBack(*this, EventType)
          
          If StartDrawing(CanvasOutput(*this\canvas\gadget))
            If *event\draw = 0
              *event\draw = 1
              FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
            EndIf
            
            Draw(*this)
            StopDrawing()
          EndIf
          
          ;ReDraw(*this, $F6)
          ProcedureReturn
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
      
      *List()\canvas\gadget = EventGadget()
      *List()\canvas\window = EventWindow()
      
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
    ;BindGadgetEvent(g, @Events())
    
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
    AddGadgetItem(g, 11, "Tree_4" )
    AddGadgetItem(g, 12, "Tree_5", 0 )
    AddGadgetItem(g, 13, "Tree_6", 0 )
    
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    
    g = 3
    TreeGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes |#PB_Tree_NoLines|#PB_Tree_NoButtons|#PB_ListView_MultiSelect | #PB_Tree_ThreeState)                                      
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
    
    BindGadgetEvent(g, @events_tree_gadget())
    
    
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
    SetGadgetItemImage(g, 0, ImageID(0))
    
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
    
    ;For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    Define widget = 0
    
    ;If widget
    g_Canvas = CanvasGadget(-1, 0, 225, 1110, 425, #PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    ;PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    ;EndIf
    
    g = 10
    
    If widget
      *g = Widget(10, 100, 210, 210, #PB_Tree_CheckBoxes)                                         
      *g\canvas\Gadget = g_Canvas
      AddElement(*List()) : *List() = *g
    Else
      *g = GetGadgetData(Gadget(g, 10, 100, 210, 210, #PB_Tree_CheckBoxes|#PB_Flag_MultiSelect))
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
    ;For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    ; RemoveItem(*g,1)
    SetItemState(*g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    ;BindGadgetEvent(g, @Events())
    ;     SetState(*g, 3)
    ;     SetState(*g, -1)
    ;Debug " - "+GetText(*g)
    LoadFont(3, "Arial", 18)
    SetFont(*g, 3)
    
    g = 11
    If widget
      *g = Widget(230, 100, 210, 210, #PB_Flag_AlwaysSelection);|#PB_Flag_Collapsed)                                         
      *g\canvas\Gadget = g_Canvas
      AddElement(*List()) : *List() = *g
    Else
      *g = GetGadgetData(Gadget(g, 160, 120, 210, 210, #PB_Flag_AlwaysSelection))
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
    *g = Widget(450, 100, 210, 210, #PB_Flag_CheckBoxes|#PB_Flag_NoLines|#PB_Flag_NoButtons|#PB_Flag_GridLines | #PB_Flag_ThreeState )                            
    *g\canvas\Gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  2_example
    AddItem (*g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5
        AddItem(*g, -1, "Tree_"+Str(i), -1) 
      Else
        AddItem(*g, -1, "Tree_"+Str(i), 0) 
      EndIf
    Next
    ;For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    LoadFont(5, "Arial", 16)
    SetItemFont(*g, 3, 5)
    SetItemText(*g, 3, "16_font and text change")
    SetItemColor(*g, 5, #PB_Gadget_FrontColor, $FFFFFF00)
    SetItemColor(*g, 5, #PB_Gadget_BackColor, $FFFF00FF)
    SetItemText(*g, 5, "backcolor and text change")
    LoadFont(6, "Arial", 25)
    SetItemFont(*g, 7, 6)
    SetItemText(*g, 7, "25_font and text change")
    Bind(*g, @events_tree_widget())
    
    g = 13
    *g = Widget(600, 120, 210, 210, #PB_Flag_OptionBoxes|#PB_Flag_NoLines|#PB_Flag_NoButtons|#PB_Flag_ClickSelect)                                         
    *g\canvas\Gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  4_example
    ; ;     AddItem(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    ; ;     AddItem(*g, 1, "Tree_1", -1, 1) 
    ; ;     AddItem(*g, 2, "Tree_2_2", -1, 2) 
    ; ;     AddItem(*g, 2, "Tree_2_1", -1, 1) 
    ; ;     AddItem(*g, 3, "Tree_3_1", -1, 1) 
    ; ;     AddItem(*g, 3, "Tree_3_2", -1, 2) 
    ; ;     For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
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
    *g = Widget(890, 100, 103, 210, #PB_Tree_NoButtons)                                         
    *g\canvas\Gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  5_example
    ;     AddItem(*g, 0, "Tree_0", -1 )
    ;     AddItem(*g, 1, "Tree_1", -1, 0) 
    ;     AddItem(*g, 2, "Tree_2", -1, 0) 
    ;     AddItem(*g, 3, "Tree_3", -1, 0) 
    AddItem(*g, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    SetItemImage(*g, 0, 0)
    
    g = 15
    *g = Widget(890+106, 100, 103, 210, #PB_Flag_BorderLess|#PB_Flag_Collapse)                                         
    *g\canvas\Gadget = g_Canvas
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
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          End 
      EndSelect
    ForEver
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----------------------------------------------------------------------------
; EnableXP