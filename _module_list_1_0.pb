
DeclareModule Macros
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
        List()\widget\index = ListIndex(List())
      Wend
      PopListPosition(List())
    EndIf
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
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Global _drawing_mode_
    
    Macro PB(Function)
      Function
    EndMacro
    
    Macro DrawingMode(_mode_)
      PB(DrawingMode)(_mode_) : _drawing_mode_ = _mode_
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
    
    
    Declare.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
    Declare.i ClipOutput_(x.i, y.i, width.i, height.i)
  CompilerEndIf
EndDeclareModule 

Module Macros
  ;- MACOS
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    
    ;     Macro PB(Function)
    ;       Function
    ;     EndMacro
    
    Procedure.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
      Protected.CGFloat r,g,b,a
      Protected.i Transform, NSString, Attributes, Color
      Protected Size.NSSize, Point.NSPoint
      
      If Text.s
        CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
        
        r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
        
        r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(_drawing_mode_&#PB_2DDrawing_Transparent=0)
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

UseModule Macros

;- >>>
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
  
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
  
  #_b_1 = 1
  #_b_2 = 2
  #_b_3 = 3
  
  ;   Enumeration #PB_Event_FirstCustomValue
  ;     #PB_Event_Widget
  ;   EndEnumeration
  ;   
  ;   Enumeration #PB_EventType_FirstCustomValue
  ;     #PB_EventType_ScrollChange
  ;   EndEnumeration
  
EndDeclareModule 

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
    InLine.b
    Lines.b
    Buttons.b
    gridlines.b
    CheckBoxes.b
    FullSelection.b
    AlwaysSelection.b
    MultiSelect.b
    ClickSelect.b
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
    change.b
    sublevel.l
    childrens.l
    sublevellen.l
    
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
    count.l
    sublevel.l
    sublevellen.l
    FontID.i
    
    *first._S_items
    *selected._S_items
  EndStructure
  
  ;- - _S_columns
  Structure _S_columns Extends _S_coordinate
    index.l  ; Index of new list element
    handle.i ; Adress of new list element
    
    Color._S_color
    Text._S_Text
    Image._S_Image
    Hide.b[2]
    sublevel.i[3]
    
    row._S_row
    
    List *draws._S_items()
    List Items._S_items()
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
  Structure _S_scroll ;Extends _S_coordinate
    height.i
    width.i
    ;Orientation.b
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
    canvas._S_canvas
    
    *Data
    type.l   ; 
    from.l   ; at point index
    hide.b
    change.b ; 
    Interact.b ; будет ли взаимодействовать с пользователем?
    
    *widget._S_widget
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
    
    row._S_row
    List *draws._S_items()
    List items._S_items()
    List Columns._S_columns()
  EndStructure
  
  
  Global def_items_colors._S_color
  
  With def_items_colors                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ;- Синие цвета
    ; Цвета по умолчанию
    \front[#Normal] = $80000000
    \fore[#Normal] = $FFF8F8F8 
    \back[#Normal] = $80E2E2E2
    \frame[#Normal] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[#Entered] = $80000000
    \fore[#Entered] = $FFFAF8F8
    \back[#Entered] = $80FCEADA
    \frame[#Entered] = $80FFC288
    
    ; Цвета если нажали на виджет
    \front[#Selected] = $FFFEFEFE
    \fore[#Selected] = $C8E9BA81;$C8FFFCFA
    \back[#Selected] = $C8E89C3D; $80E89C3D
    \frame[#Selected] = $C8DC9338; $80DC9338
    
    ; Цвета если дисабле виджет
    \front[#Disabled] = $FFBABABA
    \fore[#Disabled] = $FFF6F6F6 
    \back[#Disabled] = $FFE2E2E2 
    \frame[#Disabled] = $FFBABABA
    
  EndWith
  
  ;Global *active._S_widget
  Global NewList List._S_widget()
  
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Structures

;- >>> DECLAREMODULE
DeclareModule Bar
  EnableExplicit
  
  ;   ;- CONSTANTs
  ;   #PB_Bar_Vertical = 1
  ;   
  ;   #PB_Bar_Minimum = 1
  ;   #PB_Bar_Maximum = 2
  ;   #PB_Bar_PageLength = 3
  ;   
  ;   EnumerationBinary 4
  ;     #PB_Bar_ArrowSize 
  ;     #PB_Bar_ButtonSize 
  ;     #PB_Bar_ScrollStep
  ;     #PB_Bar_NoButtons 
  ;     #PB_Bar_Direction 
  ;     #PB_Bar_Inverted 
  ;     #PB_Bar_Ticks
  ;     
  ;     #PB_Bar_First
  ;     #PB_Bar_Second
  ;     #PB_Bar_FirstFixed
  ;     #PB_Bar_SecondFixed
  ;     #PB_Bar_FirstMinimumSize
  ;     #PB_Bar_SecondMinimumSize
  ;   EndEnumeration
  ;   
  ;   #Normal = 0
  ;   #Entered = 1
  ;   #Selected = 2
  ;   #Disabled = 3
  ;   
  ;   #_b_1 = 1
  ;   #_b_2 = 2
  ;   #_b_3 = 3
  ;   
  ;   Enumeration #PB_Event_FirstCustomValue
  ;     #PB_Event_Widget
  ;   EndEnumeration
  ;   
  ;   Enumeration #PB_EventType_FirstCustomValue
  ;     #PB_EventType_ScrollChange
  ;   EndEnumeration
  
  UseModule Constants
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
  Declare.b CallBack(*this, EventType.l, mouse_x.l, mouse_y.l, WheelDelta.l=0)
  
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
    *event\index
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
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ =< (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ =< (_type_\y#_mode_+_type_\height#_mode_))
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
        If _this_\color[#_b_1]\state <> #Selected
          _this_\color[#_b_1]\state = #Normal
        EndIf
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
    
    If _this_\type = #PB_GadgetType_ScrollBar
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
  
  Procedure.b Draw_Track(*this._S_bar)
    With *this
      
      If Not \hide
        Protected _pos_ = 6, _size_ = 4
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x,\y,\width,\height,\color\back)
        
        If \vertical
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \x+_pos_,\thumb\pos+\thumb\len-\button[#_b_2]\len,_size_,\height-(\thumb\pos+\thumb\len-\y),\color[#_b_2]\fore[\color[#_b_2]\state],\color[#_b_2]\back[\color[#_b_2]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\x+_pos_,\thumb\pos+\thumb\len-\button[#_b_2]\len,_size_,\height-(\thumb\pos+\thumb\len-\y),Bool(\radius),Bool(\radius),\color[#_b_2]\frame[\color[#_b_2]\state])
          
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \x+_pos_,\y+\button[#_b_1]\len,_size_,\thumb\pos-\y,\color[#_b_1]\fore[\color[#_b_1]\state],\color[#_b_1]\back[\color[#_b_1]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\x+_pos_,\y+\button[#_b_1]\len,_size_,\thumb\pos-\y,Bool(\radius),Bool(\radius),\color[#_b_1]\frame[\color[#_b_1]\state])
          
        Else
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \x+\button[#_b_1]\len,\y+_pos_,\thumb\pos-\x,_size_,\color[#_b_1]\fore[\color[#_b_1]\state],\color[#_b_1]\back[\color[#_b_1]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\x+\button[#_b_1]\len,\y+_pos_,\thumb\pos-\x,_size_,Bool(\radius),Bool(\radius),\color[#_b_1]\frame[\color[#_b_1]\state])
          
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \thumb\pos+\thumb\len-\button[#_b_2]\len,\y+_pos_,\width-(\thumb\pos+\thumb\len-\x),_size_,\color[#_b_2]\fore[\color[#_b_2]\state],\color[#_b_2]\back[\color[#_b_2]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\thumb\pos+\thumb\len-\button[#_b_2]\len,\y+_pos_,\width-(\thumb\pos+\thumb\len-\x),_size_,Bool(\radius),Bool(\radius),\color[#_b_2]\frame[\color[#_b_2]\state])
        EndIf
        
        
        If \thumb\len
          Protected i, track_pos.f, _thumb_ = (\thumb\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          If \vertical
            If \mode = #PB_Bar_Ticks
              For i=0 To \page\end-\min
                track_pos = (\area\pos + Round(i * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
                Line(\button[3]\x+\button[3]\width-4,track_pos,4, 1,\color[3]\frame)
              Next
            Else
              Line(\button[3]\x+\button[3]\width-4,\area\pos + _thumb_,4, 1,\color[3]\frame)
              Line(\button[3]\x+\button[3]\width-4,\area\pos + \area\len + _thumb_,4, 1,\color[3]\frame)
            EndIf
          Else
            If \mode = #PB_Bar_Ticks
              For i=0 To \page\end-\min
                track_pos = (\area\pos + Round(i * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
                Line(track_pos, \button[3]\y+\button[3]\height-4,1,4,\color[3]\frame)
              Next
            Else
              Line(\area\pos + _thumb_, \button[3]\y+\button[3]\height-4,1,4,\color[3]\frame)
              Line(\area\pos + \area\len + _thumb_, \button[3]\y+\button[3]\height-4,1,4,\color[3]\frame)
            EndIf
          EndIf
          
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\vertical,\button[#_b_3]\x+Bool(\vertical),\button[#_b_3]\y+Bool(Not \vertical),\button[#_b_3]\len,\button[#_b_3]\len,\color[3]\fore[#_b_2],\color[3]\back[#_b_2], \radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_b_3]\x+Bool(\vertical),\button[#_b_3]\y+Bool(Not \vertical),\button[#_b_3]\len,\button[#_b_3]\len,\radius,\radius,\color[3]\frame[#_b_2]&$FFFFFF|\color\alpha<<24)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_b_3]\x+(\button[#_b_3]\len-\button[#_b_3]\arrow_size)/2+Bool(\vertical),\button[#_b_3]\y+(\button[#_b_3]\len-\button[#_b_3]\arrow_size)/2+Bool(Not \vertical), 
                \button[#_b_3]\arrow_size, Bool(\vertical)+Bool(Not \inverted And \direction>0)*2+Bool(\inverted And \direction=<0)*2, \color[#_b_3]\frame[\color[#_b_3]\state]&$FFFFFF|\color\alpha<<24, \button[#_b_3]\arrow_type)
          
        EndIf
        
      EndIf
      
    EndWith 
    
  EndProcedure
  
  Procedure.b Draw_Progress(*this._S_bar)
    
    ; Selected Back
    DrawingMode(#PB_2DDrawing_Gradient)
    _box_gradient_(*this\vertical, *this\button[#_b_1]\x,*this\button[#_b_1]\y,*this\button[#_b_1]\width,*this\button[#_b_1]\height,*this\color[#_b_1]\fore[*this\color[#_b_1]\state],*this\color[#_b_1]\back[*this\color[#_b_1]\state])
    
    ; Normal Back
    DrawingMode(#PB_2DDrawing_Gradient)
    _box_gradient_(*this\vertical, *this\button[#_b_2]\x, *this\button[#_b_2]\y,*this\button[#_b_2]\width,*this\button[#_b_2]\height,*this\color[#_b_2]\fore[*this\color[#_b_2]\state],*this\color[#_b_2]\back[*this\color[#_b_2]\state])
    
    If *this\vertical
      ; Frame_1
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\pos
        Line(*this\button[#_b_1]\x,*this\button[#_b_1]\y,1,*this\button[#_b_1]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\x,*this\button[#_b_1]\y,*this\button[#_b_1]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\x+*this\button[#_b_1]\width-1,*this\button[#_b_1]\y,1,*this\button[#_b_1]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      Else
        Line(*this\button[#_b_1]\x,*this\button[#_b_1]\y,*this\button[#_b_1]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      EndIf
      
      ; Frame_2
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\end
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\y,1,*this\button[#_b_2]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\y+*this\button[#_b_2]\height-1,*this\button[#_b_2]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x+*this\button[#_b_2]\width-1,*this\button[#_b_2]\y,1,*this\button[#_b_2]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      Else
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\y+*this\button[#_b_2]\height-1,*this\button[#_b_2]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      EndIf
      
    Else
      ; Frame_1
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\pos
        Line(*this\button[#_b_1]\x,*this\button[#_b_1]\y,*this\button[#_b_1]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\x,*this\button[#_b_1]\y,1,*this\button[#_b_1]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
        Line(*this\button[#_b_1]\x,*this\button[#_b_1]\y+*this\button[#_b_1]\height-1,*this\button[#_b_1]\width,1,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      Else
        Line(*this\button[#_b_1]\x,*this\button[#_b_1]\y,1,*this\button[#_b_1]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      EndIf
      
      ; Frame_2
      DrawingMode(#PB_2DDrawing_Outlined)
      If *this\thumb\pos <> *this\area\end
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\y,*this\button[#_b_2]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x+*this\button[#_b_2]\width-1,*this\button[#_b_2]\y,1,*this\button[#_b_2]\height,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
        Line(*this\button[#_b_2]\x,*this\button[#_b_2]\y+*this\button[#_b_2]\height-1,*this\button[#_b_2]\width,1,*this\color[#_b_2]\frame[*this\color[#_b_2]\state])
      Else
        Line(*this\button[#_b_2]\x+*this\button[#_b_2]\width-1,*this\button[#_b_2]\y,1,*this\button[#_b_2]\height,*this\color[#_b_1]\frame[*this\color[#_b_1]\state])
      EndIf
    EndIf
    
    ; Text
    If *this\text
      If *this\text\change 
        *this\text\change = 0
        *this\text\string = "%"+Str(*this\page\pos)
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
            Box(\button[#_b_1]\x,\button[#_b_1]\y,\button[#_b_1]\width,\button[#_b_1]\height,\color[3]\frame[\color[#_b_1]\state])
          EndIf
          If Not \splitter\g_second And (Not *second Or (*second And Not *second\splitter))
            Box(\button[#_b_2]\x,\button[#_b_2]\y,\button[#_b_2]\width,\button[#_b_2]\height,\color[3]\frame[\color[#_b_2]\state])
          EndIf
        EndIf
        
        If \mode = #PB_Splitter_Separator
          ; Позиция сплиттера 
          Size = \thumb\len/2
          Pos = \thumb\pos+Size
          
          If \vertical ; horisontal
            Circle(\button[#_b_3]\x+((\button[#_b_3]\width-Radius)/2-((Radius*2+2)*2+2)), Pos,Radius,\color[#_b_3]\frame[#Selected])
            Circle(\button[#_b_3]\x+((\button[#_b_3]\width-Radius)/2-(Radius*2+2)),       Pos,Radius,\color[#_b_3]\frame[#Selected])
            Circle(\button[#_b_3]\x+((\button[#_b_3]\width-Radius)/2),                    Pos,Radius,\color[#_b_3]\frame[#Selected])
            Circle(\button[#_b_3]\x+((\button[#_b_3]\width-Radius)/2+(Radius*2+2)),       Pos,Radius,\color[#_b_3]\frame[#Selected])
            Circle(\button[#_b_3]\x+((\button[#_b_3]\width-Radius)/2+((Radius*2+2)*2+2)), Pos,Radius,\color[#_b_3]\frame[#Selected])
          Else
            Circle(Pos,\button[#_b_3]\y+((\button[#_b_3]\height-Radius)/2-((Radius*2+2)*2+2)),Radius,\color[#_b_3]\frame[#Selected])
            Circle(Pos,\button[#_b_3]\y+((\button[#_b_3]\height-Radius)/2-(Radius*2+2)),      Radius,\color[#_b_3]\frame[#Selected])
            Circle(Pos,\button[#_b_3]\y+((\button[#_b_3]\height-Radius)/2),                   Radius,\color[#_b_3]\frame[#Selected])
            Circle(Pos,\button[#_b_3]\y+((\button[#_b_3]\height-Radius)/2+(Radius*2+2)),      Radius,\color[#_b_3]\frame[#Selected])
            Circle(Pos,\button[#_b_3]\y+((\button[#_b_3]\height-Radius)/2+((Radius*2+2)*2+2)),Radius,\color[#_b_3]\frame[#Selected])
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
            \color\front[State] = Color
          Else
            \color[Item]\front[State] = Color
          EndIf
          
        Case #PB_Gadget_BackColor
          If Item=- 1
            \color\back[State] = Color
          Else
            \color[Item]\back[State] = Color
          EndIf
          
        Case #PB_Gadget_FrontColor
        Default ; Case #PB_Gadget_FrameColor
          If Item=- 1
            \color\frame[State] = Color
          Else
            \color[Item]\frame[State] = Color
          EndIf
          
      EndSelect
    EndWith
    
    ; ResetColor(*this)
    
    ProcedureReturn Bool(Color)
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
            
            If \vertical
              \area\pos = \y 
              \area\len = \height
            Else
              \area\pos = \x
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
      If -\v\page\pos > ScrollArea_Y And ScrollArea_Y<>\v\page\pos 
        SetState(\v, -ScrollArea_Y)
      EndIf
      
      If -\h\page\pos > ScrollArea_X And ScrollArea_X<>\h\page\pos 
        SetState(\h, -ScrollArea_X) 
      EndIf
      
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y + Bool(Not \h\hide And \v\radius And \h\radius)*(\v\width/4))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x + Bool(Not \v\hide And \v\radius And \h\radius)*(\h\height/4), #PB_Ignore)
      
      ;       *Scroll\y =- \v\page\pos
      ;       *Scroll\x =- \h\page\pos
      ;       *Scroll\width = \v\max
      ;       *Scroll\height = \h\max
      
      
      
      If \v\hide : \v\page\pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\page\pos = vPos : EndIf
      If \h\hide : \h\page\pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\page\pos = hPos : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
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
      \button[#_b_1]\arrow_type =- 1
      \button[#_b_2]\arrow_type =- 1
      \button[#_b_1]\arrow_size = 4
      \button[#_b_2]\arrow_size = 4
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
      
      \splitter = AllocateStructure(_S_splitter)
      \splitter\first = First
      \splitter\second = Second
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
  
  
  Procedure.b CallBack(*this._S_bar, EventType.l, mouse_x.l, mouse_y.l, WheelDelta.l=0)
    Protected Result, from =- 1 
    Static cursor_change, LastX, LastY, Last, *leave._S_bar, Down
    
    Macro _callback_(_this_, _type_)
      Select _type_
        Case #PB_EventType_MouseLeave ; : Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Normal 
          
          If _this_\cursor And cursor_change
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default) ; cursor_change - 1)
            cursor_change = 0
          EndIf
          
        Case #PB_EventType_MouseEnter ; : Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
          _this_\color[_this_\from]\state = #Entered 
          
          ; Set splitter cursor
          If _this_\from = #_b_3 And _this_\type = #PB_GadgetType_Splitter And _this_\cursor
            cursor_change = 1;GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) + 1
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, _this_\cursor)
          EndIf
          
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
      ; from the very beginning we'll process 
      ; the splitter children’s widget
      If \splitter And \from <> #_b_3
        If \splitter\first And Not \splitter\g_first
          If CallBack(\splitter\first, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
        EndIf
        If \splitter\second And Not \splitter\g_second
          If CallBack(\splitter\second, EventType, mouse_x, mouse_y)
            ProcedureReturn 1
          EndIf
        EndIf
      EndIf
      
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
          
          If \type = #PB_GadgetType_TrackBar ;Or \type = #PB_GadgetType_ProgressBar
            Select from
              Case #_b_1, #_b_2
                from = 0
                
            EndSelect
            ; ElseIf \type = #PB_GadgetType_ProgressBar
            ;  
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
            ;*leave = *this ;; ??
            
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
  
  ;-
  ;- - ENDMODULE
  ;-
EndModule

;- >>>
DeclareModule ListIcon
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  ;- - DECLAREs MACROs
  Macro CountItems(_this_)
    _this_\row\count
  EndMacro
  
  Macro ClearItems(_this_) 
    _this_\row\count = 0
    _this_\text\change = 1 
    If _this_\text\editable
      _this_\text\string = #LF$
    EndIf
    PostEvent(#PB_Event_Gadget, *this\canvas\window, *this\canvas\gadget, #PB_EventType_Repaint)
  EndMacro
  
  Macro RemoveItem(_this_, _item_) 
    _this_\row\count - 1
    _this_\text\change = 1
    If _this_\row\count =- 1 
      _this_\row\count = 0 
      _this_\text\string = #LF$
      PostEvent(#PB_Event_Gadget, *this\canvas\window, *this\canvas\gadget, #PB_EventType_Repaint)
    Else
      _this_\text\string = RemoveString(_this_\text\string, StringField(_this_\text\string, _item_+1, #LF$) + #LF$)
    EndIf
  EndMacro
  
  
  ;- DECLAREs PROCEDUREs
  Declare.l SetText(*this, Text.s)
  Declare.i SetFont(*this, Font.i)
  Declare.l SetState(*this, State.l)
  Declare.i SetItemFont(*this, Item.l, Font.i)
  Declare.l SetItemText(*this, Item.l, Text.s)
  Declare.l SetItemState(*this, Item.l, State.b)
  Declare.i SetItemImage(*this, Item.l, Image.i)
  
  Declare.s GetText(*this)
  Declare.i GetFont(*this)
  Declare.l GetState(*this)
  Declare.i GetItemFont(*this, Item.l)
  Declare.s GetItemText(*this, Item.l)
  Declare.b GetItemState(*this, Item.l)
  Declare.i GetItemImage(*this, Item.l)
  
  Declare.i AddColumn(*this, Position.l, Text.s, Width.l, Image.i=-1)
  Declare.i AddItem(*this, Item.l, Text.s, Image.i=-1, sublevel.i=0)
  ;Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, ColumnTitle.s, ColumnWidth.i, Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, x.i, y.i, width.i, height.i, ColumnTitle.s, ColumnWidth.i, flag.i=0)
  Declare.i Widget(X.l, Y.l, Width.l, Height.l, ColumnTitle.s, ColumnWidth.i, Flag.i=0, Radius.l=0)
  Declare.l CallBack(*this, EventType.l, mouse_x.l=-1, mouse_y.l=-1)
  
  Declare.l Draw(*this)
  Declare.l Resize(*this, X.l,Y.l,Width.l,Height.l)
  Declare.l ReDraw(*this, Canvas =- 1, BackColor=$FFF0F0F0)
EndDeclareModule

Module ListIcon
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
        LineXY((_x_+2),(_y_+6),(_x_+3),(_y_+7),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
        LineXY((_x_+2),(_y_+7),(_x_+3),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; Левая линия
        
        LineXY((_x_+7),(_y_+2),(_x_+4),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; правая линия
        LineXY((_x_+8),(_y_+2),(_x_+5),(_y_+8),_color_&$FFFFFF|_alpha_<<24) ; правая линия
      EndIf
    EndIf
    
  EndMacro
  
  Macro _from_point_(_mouse_x_, _mouse_y_, _type_, _mode_=)
    Bool (_mouse_x_ > _type_\x#_mode_ And _mouse_x_ =< (_type_\x#_mode_+_type_\width#_mode_) And 
          _mouse_y_ > _type_\y#_mode_ And _mouse_y_ =< (_type_\y#_mode_+_type_\height#_mode_))
  EndMacro
  
  Macro _multi_select_(_this_, _index_)
    PushListPosition(_this_\items()) 
    ForEach _this_\items()
      If Not _this_\items()\hide
        _this_\items()\color\state =  Bool((_this_\row\selected\index >= _this_\items()\index And _index_ =< _this_\items()\index) Or ; верх
                                           (_this_\row\selected\index =< _this_\items()\index And _index_ >= _this_\items()\index)) * 2  ; вниз
        
      EndIf
    Next
    PopListPosition(_this_\items()) 
  EndMacro
  
  Macro _set_active_(_this_)
    If *active <> _this_
      If *active 
        If *active\columns()\row\selected 
          *active\columns()\row\selected\color\state = 3
        EndIf
        
        *active\color\state = 0
      EndIf
      
      If _this_\columns()\row\selected And _this_\columns()\row\selected\color\state = 3
        _this_\columns()\row\selected\color\state = 2
      EndIf
      _this_\color\state = 2
      *active = _this_
      Result = #True
    EndIf
  EndMacro
  
  Macro _set_item_image_(_this_, _item_, _image_)
    _item_\image\change = IsImage(_image_)
    
    If _item_\image\change
      Select _this_\attribute
        Case #PB_Attribute_LargeIcon
          _item_\image\width = 32
          _item_\image\height = 32
          ResizeImage(_item_\image\index, _item_\image\width, _item_\image\height)
          
        Case #PB_Attribute_SmallIcon
          _item_\image\width = 16
          _item_\image\height = 16
          ResizeImage(_item_\image\index, _item_\image\width, _item_\image\height)
          
        Default
          _item_\image\width = ImageWidth(_item_\image\index)
          _item_\image\height = ImageHeight(_item_\image\index)
      EndSelect   
      
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
  
  ;-
  Procedure.l Draw(*this._S_widget)
    Protected Y, state.b
    Protected line_size = *this\flag\lines
    Protected box_size = *this\flag\buttons
    Protected check_size = *this\flag\checkBoxes
    
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
      _items_\l\v\x = _items_\box[0]\x+_items_\box[0]\width/2 + Bool(_this_\flag\gridlines And _items_\sublevel) * 4
      
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
        _this_\scroll\width = Bool(_this_\flag\checkBoxes) * 20 + _this_\row\sublevel - Bool(_this_\flag\checkBoxes And Not _this_\Flag\GridLines) * 2
        
        If _this_\Text\Change
          _this_\Text\Height = TextHeight("A") + Bool(_this_\Flag\GridLines) + Bool(#PB_Compiler_OS = #PB_OS_Windows) * 2
          _this_\Text\Width = TextWidth(_this_\Text\String.s)
        EndIf
      EndIf
      
      PushListPosition(_this_\Columns())
      ForEach _this_\Columns()
        If _this_\Columns()\text\change = 1
          _this_\Columns()\text\height = TextHeight("A") 
          _this_\Columns()\text\width = TextWidth(_this_\Columns()\text\string.s)
          _this_\Columns()\text\change = 0
        EndIf
        
        If _this_\change <> 0
          _this_\scroll\height = _this_\Columns()\height
          
          _this_\Columns()\x = _this_\x[2] + _this_\scroll\width
          _this_\Columns()\y = _this_\y[1]
          
          ; 
          _this_\Columns()\x[1] = _this_\Columns()\x
          _this_\Columns()\y[1] = _this_\y[2]
          _this_\Columns()\width[1] = _this_\Columns()\width
          _this_\Columns()\height[1] = _this_\height[2]
        EndIf
        
        If (_this_\change Or _this_\scroll\v\change Or _this_\scroll\h\change)
          _this_\Columns()\text\x = _this_\Columns()\x - _this_\scroll\h\page\pos + _this_\Columns()\text\padding\left
          _this_\Columns()\text\y = _this_\Columns()\y + (_this_\Columns()\height - _this_\Columns()\text\height)/2
        EndIf
        
        ForEach _this_\Columns()\items()
          If _this_\Columns()\items()\hide
            _this_\Columns()\items()\draw = 0
          Else
            If _this_\Columns()\items()\text\change 
              _this_\Columns()\items()\text\change = #False
              
              If _this_\Columns()\items()\text\fontID 
                DrawingFont(_this_\Columns()\items()\text\fontID) 
              EndIf
              _this_\Columns()\items()\text\width = TextWidth(_this_\Columns()\items()\text\string.s) 
              _this_\Columns()\items()\text\height = TextHeight("A") 
            EndIf 
            
            If _this_\change
              _this_\Columns()\items()\height = _this_\Text\Height
              _this_\Columns()\items()\y = _this_\y[2]+_this_\scroll\height
            EndIf
            
            If (_this_\change Or _this_\scroll\v\change Or _this_\scroll\h\change)
              _this_\Columns()\items()\draw = Bool(_this_\Columns()\items()\y+_this_\Columns()\items()\height-_this_\scroll\v\page\pos>_this_\y[2]+_this_\Columns()\height And 
                                                   (_this_\Columns()\items()\y-_this_\y[2])-_this_\scroll\v\page\pos<_this_\height[2])
              If _this_\flag\checkBoxes
                _this_\Columns()\items()\box[1]\x = _this_\x[2] + 3 - _this_\scroll\h\page\pos
                _this_\Columns()\items()\box[1]\y = (_this_\Columns()\items()\y+_this_\Columns()\items()\height)-(_this_\Columns()\items()\height+_this_\Columns()\items()\box[1]\height)/2-_this_\scroll\v\page\pos
              EndIf
              
              ; expanded & collapsed box
              If _this_\flag\buttons Or _this_\flag\lines 
                _this_\Columns()\items()\box[0]\x = _this_\Columns()\x + _this_\Columns()\items()\sublevellen - _this_\row\sublevellen + Bool(_this_\flag\buttons And Not _this_\flag\gridlines) * 4 + Bool(Not _this_\flag\buttons And _this_\flag\lines) * 8 - _this_\scroll\h\page\pos - _this_\row\sublevel
                _this_\Columns()\items()\box[0]\y = (_this_\Columns()\items()\y+_this_\Columns()\items()\height)-(_this_\Columns()\items()\height+_this_\Columns()\items()\box[0]\height)/2-_this_\scroll\v\page\pos
              EndIf
              
              _this_\Columns()\items()\image\x = _this_\Columns()\x + _this_\image\padding\left + _this_\Columns()\items()\sublevellen -_this_\scroll\h\page\pos - _this_\row\sublevel
              _this_\Columns()\items()\text\x = _this_\Columns()\x + _this_\text\padding\left + _this_\Columns()\items()\sublevellen + _this_\Columns()\sublevel  -_this_\scroll\h\page\pos
              _this_\Columns()\items()\image\y = _this_\Columns()\items()\y + (_this_\Columns()\items()\height-_this_\Columns()\items()\image\height)/2-_this_\scroll\v\page\pos
              _this_\Columns()\items()\text\y = _this_\Columns()\items()\y + (_this_\Columns()\items()\height-_this_\Columns()\items()\text\height)/2-_this_\scroll\v\page\pos
              
              If _this_\flag\lines And _this_\row\sublevellen
                _lines_(_this_, _this_\Columns()\items())
              EndIf
              
            EndIf
            
            If _this_\change <> 0
              _this_\scroll\height + _this_\Columns()\items()\height + _this_\Flag\GridLines
            EndIf
          EndIf
        Next
        
        If _this_\change <> 0
          _this_\scroll\width + _this_\Columns()\width
        EndIf
      Next
      PopListPosition(_this_\Columns())
      
      If _this_\scroll\v\page\len And _this_\scroll\v\max<>_this_\scroll\height-_this_\flag\gridlines And
         Bar::SetAttribute(_this_\scroll\v, #PB_ScrollBar_Maximum, _this_\scroll\height-_this_\flag\gridlines)
        
        Bar::Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
      
      If _this_\scroll\h\page\len And _this_\scroll\h\max<>_this_\scroll\width And
         Bar::SetAttribute(_this_\scroll\h, #PB_ScrollBar_Maximum, _this_\scroll\width)
        
        Bar::Resizes(_this_\scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        ; Debug "  w - "+Str(_this_\scroll\h\page\pos) +" "+ _this_\scroll\h\page\end
      EndIf
      
      If _this_\change <> 0
        _this_\width[2] = (_this_\scroll\v\x + Bool(_this_\scroll\v\hide) * _this_\scroll\v\width) - _this_\x[2]
        _this_\height[2] = (_this_\scroll\h\y + Bool(_this_\scroll\h\hide) * _this_\scroll\h\height) - _this_\y[2]
        
        
        If _this_\columns()\row\selected And _this_\columns()\row\selected\change 
          _this_\columns()\row\selected\change = 0
          
          Bar::SetState(_this_\scroll\v, ((_this_\columns()\row\selected\index * _this_\text\height) - _this_\scroll\v\height) + _this_\text\height) 
          _this_\change = 1
          Draw(_this_)
        EndIf
      EndIf
      
    EndMacro
    
    Macro _draw_(_this_, _items_, _column_=0)
      
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
          If state 
            If _items_\color\fore[state]
              DrawingMode(#PB_2DDrawing_Gradient)
              Bar::_box_gradient_(0,_this_\x[2],Y,_this_\width[2],_items_\height,_items_\color\fore[state],_items_\color\back[state],_items_\radius)
            Else
              DrawingMode(#PB_2DDrawing_Default)
              RoundBox(_this_\x[2],Y,_this_\width[2],_items_\height,_items_\radius,_items_\radius,_items_\color\back[state])
            EndIf
            
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(_this_\x[2],Y,_this_\width[2],_items_\height,_items_\radius,_items_\radius, _items_\color\frame[state])
          EndIf
            
          If _column_=0
            ; Draw checkbox
            If _this_\flag\checkboxes
              DrawingMode(#PB_2DDrawing_Default)
              _box_(_items_\box[1]\x, _items_\box[1]\y, _items_\box[1]\width, _items_\box[1]\height, _items_\box[1]\checked, 3, $FFFFFFFF, 2, 255)
            EndIf
            
            ; Draw plots
            If _this_\row\sublevellen
              If _this_\flag\lines
                ; DrawingMode(#PB_2DDrawing_CustomFilter) 
                DrawingMode(#PB_2DDrawing_XOr)
                
                If _items_\l\h\height
                  ;  CustomFilterCallback(@PlotX())
                  Line(_items_\l\h\x, _items_\l\h\y, _items_\l\h\width, _items_\l\h\height, $FF7E7E7E)
                EndIf
                
                If _items_\l\v\width
                  ;  CustomFilterCallback(@PlotY())
                  Line(_items_\l\v\x, _items_\l\v\y, _items_\l\v\width, _items_\l\v\height, $FF7E7E7E)
                EndIf
              EndIf
              
              ; Draw arrow
              If _this_\flag\buttons
                DrawingMode(#PB_2DDrawing_Default)
                If _items_\childrens And state <> 2
                  Bar::Arrow(_items_\box[0]\x+(_items_\box[0]\width-6)/2,_items_\box[0]\y+(_items_\box[0]\height-6)/2, 6, Bool(Not _items_\box[0]\checked)+2, $FF2E7E7E, 0,0) 
                  
                ElseIf _this_\columns()\row\selected And _this_\columns()\row\selected\childrens
                  Bar::Arrow(_this_\columns()\row\selected\box[0]\x+(_this_\columns()\row\selected\box[0]\width-6)/2,_this_\columns()\row\selected\box[0]\y+(_this_\columns()\row\selected\box[0]\height-6)/2, 6, Bool(Not _this_\columns()\row\selected\box[0]\checked)+2, _this_\columns()\row\selected\color\front[_this_\columns()\row\selected\color\state], 0,0) 
                EndIf
              EndIf
            EndIf
            
            ; Draw image
            If _items_\image\handle
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(_items_\image\handle, _items_\image\x, _items_\image\y, _items_\color\alpha)
            EndIf
          EndIf
          
          ; Draw text
          If _items_\text\string.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(_items_\text\x, _items_\text\y, _items_\text\string.s, _this_\text\rotate, _items_\color\front[state])
          EndIf
          
        EndIf
      Next
      PopListPosition(_items_) ; 
      
    EndMacro
    
    With *this
      If Not \hide
        ; Draw back color
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\x[1],\y[1],\width[1],\height[1],\radius,\radius,\color\back[\color\state])
        
        If \text\fontID 
          DrawingFont(\text\fontID) 
        EndIf
        
        If \change
          _update_(*this)
          \change = 0
        EndIf 
        
        ; Draw items text
        If \row\count
          ClipOutput(\x[2],\y[2],\width[2],\height[2])
          
          PushListPosition(\Columns())
          ForEach \Columns()
            
            If \columns()\index
              ClipOutput(\Columns()\x,\y[2],\Columns()\width,\height[2])
            ElseIf ListSize(\columns()) > 1
              ClipOutput(\x[2],\y[2],(\Columns()\x+\Columns()\width)-\x[2],\height[2])
            EndIf
            
            _draw_(*this, \columns()\items(), \columns()\index)
            ; _draw_(*this, \columns()\draws(), \columns()\index)
            
            ;If \columns()\index
            ClipOutput(\x[2],\y[2],\width[2],\height[2])
            ;EndIf
            
            ;             If \from >= 0 
            ;               DrawingMode(#PB_2DDrawing_Default)
            ;               Box(\x[2],\y[2]+\columns()\height+\from*\text\height+(\flag\gridlines*\from),\width[2],\text\height,\color\back[state])
            ;               
            ;               DrawingMode(#PB_2DDrawing_Outlined)
            ;               Box(\x[2],\y[2]+\columns()\height+\from*\text\height+(\flag\gridlines*\from),\width[2],\text\height, \color\frame[state])
            ;             EndIf
            
            If \Flag\GridLines ;And Not \text\count
              Protected i, s=((\scroll\v\page\pos+\Columns()\height)/(\text\height+\flag\gridlines))
              Protected t=(\height[2]-\Columns()\height+\scroll\v\page\pos)/(\text\height+\Flag\GridLines)
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              For i=s To t
                Box(\x[2], \y[2]+\Columns()\height+(i*(\text\height+\flag\gridlines)-\scroll\v\page\pos)-\flag\gridlines+Bool(\flag\gridlines>1), \width[2], 1, $ADADAE&$FFFFFF|255<<24)
              Next
            EndIf
            
            ; Columns title
            If Not \Columns()\index
              DrawingMode(#PB_2DDrawing_Gradient)
              bar::_box_gradient_(0,\x[2], \Columns()\y, \width[2], \Columns()\height, $FFFFFF,$F4F4F5)
              DrawingMode(#PB_2DDrawing_Default)
              Box(\x[2], \Columns()\y+\Columns()\height, \width[2],1, $ADADAE)
            EndIf
            
            ; Text of the column
            If \Columns()\text\string.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawText(\Columns()\text\x, \Columns()\text\y, \Columns()\text\string.s, $000000&$FFFFFF|255<<24)
            EndIf
            
            ; Vertical grid lines
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            If Not \Columns()\index ; \Flag\GridLines And 
              Box(\Columns()\x - 1, \y[2], 1, \Columns()\height - 3+ Bool(\Flag\GridLines) * (\height[2]-\Columns()\height), $ADADAE&$FFFFFF|255<<24)
            EndIf
            Box(\Columns()\x+\Columns()\width - 1, \y[2], 1, \Columns()\height - 3+ Bool(\Flag\GridLines) * (\height[2]-\Columns()\height), $ADADAE&$FFFFFF|255<<24)
          Next
          PopListPosition(\Columns()) ; 
          
          UnclipOutput()
        EndIf
        
        ; Draw scroll bars
        If \scroll
          CompilerIf Defined(Bar, #PB_Module)
            Bar::Draw(\scroll\v)
            Bar::Draw(\scroll\h)
          CompilerEndIf
        EndIf
        
        ; Draw image
        If \image\handle
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\image\handle, \image\x, \image\y, \color\alpha)
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
  
  Procedure.l ReDraw(*this._S_widget, Canvas =- 1, BackColor=$FFF0F0F0)
    If *this
      With *this
        *this\change = 1
        
        If Canvas =- 1 
          Canvas = \canvas\gadget 
        ElseIf Canvas <> \canvas\gadget
          ProcedureReturn 0
        EndIf
        
        If StartDrawing(CanvasOutput(Canvas))
          Draw(*this)
          StopDrawing()
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  ;- SETs
  Procedure.l SetText(*this._S_widget, Text.s)
    Protected Result.l
    
    If *this\columns()\row\selected 
      *this\columns()\row\selected\text\string = Text
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*this._S_widget, Font.i)
    ;     Protected Result.i, FontID.i = FontID(Font)
    ;     
    ;     With *this
    ;       If \text\fontID <> FontID 
    ;         \text\fontID = FontID
    ;         \text\change = 1
    ;         Result = #True
    ;       EndIf
    ;     EndWith
    ;     
    ;     ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetState(*this._S_widget, State.l)
    ;     
    ;     With *this
    ;       If 0 > State Or State > \row\count - 1
    ;         If \row\selected
    ;           State = \columns()\row\selected\color\state
    ;           \columns()\row\selected\color\state = 0
    ;           \columns()\row\selected\change = 0
    ;           \columns()\row\selected = 0
    ;         EndIf
    ;         
    ;         ProcedureReturn State
    ;       EndIf
    ;       
    ;       If \columns()\row\selected
    ;         \columns()\row\selected\color\state = 0
    ;         \columns()\row\selected\change = 0
    ;       EndIf
    ;       
    ;       \columns()\row\selected = SelectElement(\items(), State) 
    ;       \items()\color\state = 2 
    ;       \items()\change = 1
    ;     EndWith
    ;     
  EndProcedure
  
  Procedure.i SetItemFont(*this._S_widget, Item.l, Font.i)
    ;     Protected Result.i, FontID.i = FontID(Font)
    ;     
    ;     If Item < 0 : Item = 0 : EndIf
    ;     If Item > *this\row\count - 1 
    ;       Item = *this\row\count - 1 
    ;     EndIf
    ;     
    ;     If SelectElement(*this\Items(), Item) And 
    ;        *this\Items()\text\fontID <> FontID
    ;       *this\Items()\text\fontID = FontID
    ;       ;       *this\Items()\text\change = 1
    ;       ;       *this\change = 1
    ;       Result = #True
    ;     EndIf
    ;     
    ;     ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetItemText(*this._S_widget, Item.l, Text.s)
    ;     Protected Result.l
    ;     
    ;     If Item < 0 : Item = 0 : EndIf
    ;     If Item > *this\row\count - 1 
    ;       Item = *this\row\count - 1 
    ;     EndIf
    ;     
    ;     If SelectElement(*this\Items(), Item) And 
    ;        *this\Items()\text\string <> Text 
    ;       *this\Items()\text\string = Text 
    ;       *this\Items()\text\change = 1
    ;       *this\change = 1
    ;       Result = #True
    ;     EndIf
    ;     
    ;     ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetItemState(*this._S_widget, Item.l, State.b)
    ;     Protected Result.l, collapsed.b, sublevel.l
    ;     
    ;     ;If (*this\flag\multiSelect Or *this\flag\clickSelect)
    ;     If Item < 0 : Item = 0 : EndIf
    ;     If Item > *this\row\count - 1 
    ;       Item = *this\row\count - 1 
    ;     EndIf
    ;     
    ;     Result = SelectElement(*this\items(), Item) 
    ;     
    ;     If Result 
    ;       If State & #PB_Tree_Selected
    ;         *this\items()\color\state = 2 + Bool(*active<>*this)
    ;         *this\row\selected = *this\items()
    ;       EndIf
    ;       
    ;       If State & #PB_Tree_Checked
    ;         *this\Items()\box[1]\checked = 1
    ;       EndIf
    ;       
    ;       If State & #PB_Tree_Collapsed
    ;         collapsed = 1
    ;       EndIf
    ;       
    ;       If collapsed Or State & #PB_Tree_Expanded
    ;         *this\Items()\box[0]\checked = collapsed
    ;         
    ;         sublevel = *this\Items()\sublevel
    ;         
    ;         PushListPosition(*this\Items())
    ;         While NextElement(*this\Items())
    ;           If *this\Items()\sublevel = sublevel
    ;             Break
    ;           ElseIf *this\Items()\sublevel > sublevel 
    ;             *this\Items()\hide = collapsed
    ;             ;*this\items()\hide = Bool(*this\items()\parent\box[0]\checked | *this\items()\parent\hide)
    ;             
    ;           EndIf
    ;         Wend
    ;         PushListPosition(*this\Items())
    ;       EndIf   
    ;     EndIf
    ;     
    ;     ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemImage(*this._S_widget, Item.l, Image.i)
    ;     If Item < 0 : Item = 0 : EndIf
    ;     If Item > *this\row\count - 1 
    ;       Item = *this\row\count - 1 
    ;     EndIf
    ;     
    ;     If SelectElement(*this\Items(), Item)
    ;       _set_item_image_(*this, Image)
    ;     EndIf
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
    
    If *this\row\selected
      Result = *this\row\selected\index
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemFont(*this._S_widget, Item.l)
    ;     Protected Result.i =- 1
    ;     
    ;     If Item < 0 : Item = 0 : EndIf
    ;     If Item > *this\row\count - 1 
    ;       Item = *this\row\count - 1 
    ;     EndIf
    ;     
    ;     If SelectElement(*this\items(), Item) 
    ;       Result = *this\items()\text\FontID
    ;     EndIf
    ;     
    ;     ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(*this._S_widget, Item.l)
    ;     Protected Result.s
    ;     
    ;     If Item < 0 : Item = 0 : EndIf
    ;     If Item > *this\row\count - 1 
    ;       Item = *this\row\count - 1 
    ;     EndIf
    ;     
    ;     If SelectElement(*this\items(), Item) 
    ;       Result = *this\items()\text\string
    ;     EndIf
    ;     
    ;     ProcedureReturn Result
  EndProcedure
  
  Procedure.b GetItemState(*this._S_widget, Item.l)
    ;     Protected Result.b
    ;     
    ;     If Item < 0 : Item = 0 : EndIf
    ;     If Item > *this\row\count - 1 
    ;       Item = *this\row\count - 1 
    ;     EndIf
    ;     
    ;     If SelectElement(*this\items(), Item) 
    ;       Result = *this\items()\color\state
    ;     EndIf
    ;     
    ;     ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemImage(*this._S_widget, Item.l)
    ;     Protected Result.i =- 1
    ;     
    ;     If Item < 0 : Item = 0 : EndIf
    ;     If Item > *this\row\count - 1 
    ;       Item = *this\row\count - 1 
    ;     EndIf
    ;     
    ;     If SelectElement(*this\Items(), Item)
    ;       Result = *this\Items()\Image\index
    ;     EndIf
    ;     
    ;     ProcedureReturn Result
  EndProcedure
  
  ;-
  Procedure.i AddColumn(*this._S_widget, Position.l, Text.s, Width.l, Image.i=-1)
    Protected Result.i
    
    With *this
      If Position =- 1
        Result = Position
      EndIf
      
      If Position < 0 Or 
         Position > ListSize(\Columns()) - 1
        LastElement(\Columns())
        \Columns()\handle = AddElement(\Columns()) 
        Position = ListIndex(\Columns())
      Else
        SelectElement(\Columns(), Position)
        \Columns()\handle = InsertElement(\Columns())
        
        ; Исправляем идентификатор
        PushListPosition(\Columns())
        While NextElement(\Columns())
          \Columns()\index = ListIndex(\Columns())
        Wend
        PopListPosition(\Columns())
      EndIf
      
      \Columns()\height = 24
      \Columns()\width = Width
      \Columns()\index = Position
      
      If Text.s
        \Columns()\text\string.s = Text.s
        \Columns()\text\change = 1
        \columns()\text\padding\left = 5
      EndIf
      
      ;       If Not \Columns()\index
      ;         \y[2] + \Columns()\height
      ;        \height[2] - \Columns()\height
      ;       EndIf
      
      If Result =- 1
        ProcedureReturn \Columns()\handle
      Else
        ProcedureReturn Position
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i AddItem(*this._S_widget, Item.l, Text.s, Image.i=-1, subLevel.i=0)
    Protected handle
    Protected *parent._S_items
    
    With *this
      If *this ;And SelectElement(\Columns(), 0)
        ForEach \Columns()
          
          ;{ Генерируем идентификатор
          If Item < 0 Or Item > ListSize(\Columns()\items()) - 1
            LastElement(\Columns()\items())
            handle = AddElement(\Columns()\items()) 
            Item = ListIndex(\Columns()\items())
          Else
            SelectElement(\Columns()\items(), Item)
            
            Protected Lastlevel, Parent, mac = 0
            If mac 
              PreviousElement(\Columns()\items())
              If \Columns()\items()\sublevel = sublevel
                Lastlevel = \Columns()\items()\sublevel 
                \Columns()\items()\childrens = 0
              EndIf
              SelectElement(\Columns()\items(), Item)
            Else
              If sublevel < \Columns()\items()\sublevel
                sublevel = \Columns()\items()\sublevel  
              EndIf
            EndIf
            
            handle = InsertElement(\Columns()\items())
            
            If mac And subLevel = Lastlevel
              \Columns()\items()\childrens = 1
              Parent = \Columns()\items()
            EndIf
            
            ; Исправляем идентификатор итема  
            PushListPosition(\Columns()\items())
            While NextElement(\Columns()\items())
              \Columns()\items()\index = ListIndex(\Columns()\items())
              
              If mac And \Columns()\items()\sublevel = sublevel + 1
                \Columns()\items()\parent = Parent
              EndIf
            Wend
            PopListPosition(\Columns()\items())
          EndIf
          ;}
          
          If handle
            ;;;; \Columns()\items() = AllocateStructure(_S_items) с ним setstate работать перестает
            \Columns()\items()\handle = handle
            
            If \row\sublevellen ;And Not \Columns()\index
              If Not item
                \row\first = \Columns()\items()
              EndIf
              
              If subLevel
                If sublevel>Item
                  sublevel=Item
                EndIf
                
                PushListPosition(\Columns()\items())
                While PreviousElement(\Columns()\items()) 
                  If subLevel = \Columns()\items()\sublevel
                    *parent = \Columns()\items()\parent
                    Break
                  ElseIf subLevel > \Columns()\items()\sublevel
                    *parent = \Columns()\items()
                    Break
                  EndIf
                Wend 
                PopListPosition(\Columns()\items())
                
                If *parent
                  If subLevel > *parent\sublevel
                    sublevel = *parent\sublevel + 1
                    *parent\childrens + 1
                    ;                   *parent\box[0]\checked = 1 
                    ;                   \Columns()\items()\hide = 1
                  EndIf
                  \Columns()\items()\parent = *parent
                EndIf
                
                \Columns()\items()\sublevel = sublevel
              EndIf
            EndIf
            
            ; add lines
            \Columns()\items()\index = Item
            
            \Columns()\items()\color = def_items_colors
            \Columns()\items()\color\state = 0
            \Columns()\items()\color\fore[0] = 0 
            \Columns()\items()\color\fore[1] = 0
            \Columns()\items()\color\fore[2] = 0
            \Columns()\items()\color\fore[3] = 0
            
            If Text
              \Columns()\items()\text\string = StringField(Text.s, \Columns()\index + 1, #LF$)
              \Columns()\items()\text\change = 1
            EndIf
            
            If Not \Columns()\index
              _set_item_image_(*this, \Columns()\items(), Image)
              
              If \flag\buttons
                \Columns()\items()\box[0]\width = \flag\buttons
                \Columns()\items()\box[0]\height = \flag\buttons
              EndIf
              
              If \flag\checkBoxes
                \Columns()\items()\box[1]\width = \flag\checkBoxes
                \Columns()\items()\box[1]\height = \flag\checkBoxes
              EndIf
              
              If \row\sublevellen
                \Columns()\items()\sublevellen = \Columns()\items()\sublevel * \row\sublevellen + Bool(\flag\buttons) * 20 ; + Bool(\flag\checkBoxes) * 18 
              EndIf
            EndIf
            
            \row\count + 1
            ;           If Item = 0
            ;           ;  PostEvent(#PB_Event_Gadget, \canvas\window, \canvas\gadget, #PB_EventType_Repaint)
            ;           EndIf
          EndIf
          
        Next
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
    Protected Color._S_color = def_items_colors
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
      PushListPosition(_this_\columns())
      ForEach _this_\columns()
        ;If _this_\from > =0
        SelectElement(_this_\columns()\items(), _this_\from)
        ; EndIf
        
        Select _type_
            ;         Case #PB_EventType_LostFocus  : Debug ""+#PB_Compiler_Line +" lost focus " + _this_ +" "+ _this_\from
            ;           
            ;           _this_\columns()\items()\color\state = 3
            ;           _this_\color\state = 0
            ;           Result = #True
            ;           
            ;         Case #PB_EventType_Focus  : Debug ""+#PB_Compiler_Line +" focus " + _this_ +" "+ _this_\from
            ;           
            ;           _this_\color\state = 2
            ;           Result = #True
            
          Case #PB_EventType_MouseLeave  ;: Debug ""+#PB_Compiler_Line +" Мышь находится снаружи итема " + _this_ +" "+ _this_\from
            
            If (_this_\columns()\items()\color\state = 1 Or down)
              _this_\columns()\items()\color\state = 0
              Result = #True
            EndIf
            
          Case #PB_EventType_MouseEnter  ;: Debug ""+#PB_Compiler_Line +" Мышь находится внутри итема " + _this_ +" "+ _this_\from
            
            If down And _this_\flag\multiselect 
              _multi_select_(_this_\columns(), _this_\from)
              Result = #True
              
            ElseIf _this_\columns()\items()\color\state = 0
              _this_\columns()\items()\color\state = 1+Bool(down)
              
              If down
                _this_\columns()\row\selected = _this_\columns()\items()
              EndIf
              
              Result = #True
            EndIf
            
          Case #PB_EventType_LeftButtonDown ; : Debug ""+#PB_Compiler_Line +" нажали " + _this_ +" "+ _this_\from
            
            If Not _this_\flag\clickselect And _this_\columns()\row\selected
              _this_\columns()\row\selected\color\state = 0
            EndIf
            
            If _this_\columns()\items()\color\state = 2
              _this_\columns()\items()\color\state = 0
            Else
              _this_\columns()\items()\color\state = 2
            EndIf
            
            _this_\columns()\row\selected = _this_\columns()\items()
            
            If _this_\flag\multiselect
              _multi_select_(_this_\columns(), _this_\from)
            EndIf
            
            Result = #True
            
          Case #PB_EventType_LeftButtonUp ; : Debug ""+#PB_Compiler_Line +" отпустили " + _this_ +" "+ _this_\from
            
            If Not _this_\flag\multiselect
              If Not _this_\flag\clickselect
                If _this_\columns()\row\selected 
                  _this_\columns()\row\selected\color\state = 0
                EndIf
                
                _this_\columns()\row\selected = _this_\columns()\items()
                _this_\columns()\items()\color\state = 2
                
                Result = #True
              EndIf
            EndIf
            
        EndSelect
        
      Next
      PopListPosition(_this_\columns())
      
    EndMacro
    
    With *this
      If \from =- 1
        Result | Bar::CallBack(\scroll\v, EventType, mouse_x, mouse_y)
        Result | Bar::CallBack(\scroll\h, EventType, mouse_x, mouse_y)
        
        If (\scroll\v\change Or \scroll\h\change)
          _update_(*this)
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
        
        SelectElement(\columns(), 0)
        ; at item from points
        ;         ;PushListPosition(\draws())
        ;         ForEach \draws()
        ;           If (mouse_y > \draws()\y-\scroll\v\page\pos And
        ;               mouse_y =< \draws()\y+\draws()\height-\scroll\v\page\pos)
        ;             from = \draws()\index
        ;             Break
        ;           EndIf
        ;         Next
        ;         ;PopListPosition(\draws())
        
        ;PushListPosition(\draws())
        ForEach \columns()\Items()
          If \columns()\Items()\draw And (mouse_y > \columns()\Items()\y-\scroll\v\page\pos And
                                          mouse_y =< \columns()\Items()\y+\columns()\Items()\height-\scroll\v\page\pos)
            from = \columns()\Items()\index
            Break
          EndIf
        Next
        ;PopListPosition(\draws())
        
        If \from <> from And Not (from =- 1 And Down)
          If *leave > 0 And *leave\from >= 0
            ; _from_point_(mouse_x, mouse_y, *leave, [2]) And
            If SelectElement(*leave\columns()\Items(), *leave\from)
              
              _callback_(*leave, #PB_EventType_MouseLeave)
              *leave\from =- 1
            EndIf
          EndIf
          
          \from = from
          
          If \from >= 0 And SelectElement(\columns()\items(), \from)
            _callback_(*this, #PB_EventType_MouseEnter)
          EndIf
        EndIf
        
        *leave = *this
      Else
        If \from >= 0 ;And SelectElement(\columns()\items(), \from)
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
          If \from >= 0 And Down = *this ; SelectElement(\columns()\items(), \from)
            Down = 0 : LastX = 0 : LastY = 0
            
            If Not ((\flag\buttons And \columns()\items()\childrens And 
                     _from_point_(\canvas\mouse\x, \canvas\mouse\y, \columns()\items()\box[0])) Or
                    _from_point_(\canvas\mouse\x, \canvas\mouse\y, \columns()\items()\box[1]))
              
              ;               PushListPosition(\columns())
              ;               ForEach \columns()
              ;                 SelectElement(\columns()\items(), \from)
              ;\columns()\items()\color\state = 2
              _callback_(*this, #PB_EventType_LeftButtonUp)
              ;               Next
              ;               PopListPosition(\columns())
              Result = 1
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
            ;*leave = *this
            
            If _from_point_(\canvas\mouse\x, \canvas\mouse\y, \columns()\items()\box[1])
              
              \columns()\items()\box[1]\checked ! 1
              
              Result = #True
            ElseIf (\flag\buttons And \columns()\items()\childrens) And
                   _from_point_(\canvas\mouse\x, \canvas\mouse\y, \columns()\items()\box[0])
              
              
              Protected sublevel
              sublevel = \columns()\items()\sublevel
              \columns()\items()\box[0]\checked ! 1
              
              PushListPosition(\columns()\items())
              While NextElement(\columns()\items())
                If \columns()\items()\sublevel = sublevel
                  Break
                ElseIf \columns()\items()\sublevel > sublevel 
                  Protected hide = Bool(\columns()\items()\parent\box[0]\checked | \columns()\items()\parent\hide)
                  
                  PushListPosition(\columns())
                  ForEach \columns()
                    ForEach \columns()\items()
                      If \columns()\items()\sublevel > sublevel
                        \columns()\items()\hide = hide
                      EndIf
                    Next
                  Next
                  PopListPosition(\columns())
                EndIf
              Wend
              PopListPosition(\columns()\items())
              
              ;               If \columns()\items()\box[0]\checked
              ;                  SetItemState(*this, \from, #PB_Tree_Collapsed)
              ;                Else
              ;                  SetItemState(*this, \from, #PB_Tree_Expanded)
              ;                EndIf
              
              If StartDrawing(CanvasOutput(\canvas\gadget))
                \change = 1
                _update_(*this)
                StopDrawing()
              EndIf
              
              Result = #True
            Else
              ; ForEach \columns()
              ;    SelectElement(\columns()\items(), \from)
              _callback_(*this, #PB_EventType_LeftButtonDown)
              ; Next
            EndIf
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Widget(X.l, Y.l, Width.l, Height.l, ColumnTitle.s, ColumnWidth.i, Flag.i=0, Radius.l=0)
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
          Protected FontSize.CGFloat
          \text\fontID = CocoaMessage(0, 0, "NSFont controlContentFontOfSize:@", @FontSize)
        CompilerElse
          \text\fontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        CompilerEndIf
        
        \text\padding\left = 4
        \image\padding\left = 2
        
        \fs = Bool(Not Flag&#PB_Flag_BorderLess)*2
        \bs = \fs
        
        \flag\multiSelect = Bool(flag&#PB_Flag_MultiSelect)
        \flag\clickSelect = Bool(flag&#PB_Flag_ClickSelect)
        \flag\fullSelection = Bool(flag&#PB_Flag_FullSelection)
        \flag\alwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
        \flag\gridlines = Bool(flag&#PB_Flag_GridLines)
        
        \flag\lines = Bool(Not flag&#PB_Flag_NoLines)*8
        \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер кнопки
        \flag\checkBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
        
        If \flag\lines Or \flag\buttons
          \row\sublevellen = 18
        EndIf
        
        \color = def_items_colors
        \color\fore[0] = 0
        \color\fore[1] = 0
        \color\fore[2] = 0
        \color\back[0] = $FFFFFFFF 
        \color\back[1] = $FFFFFFFF 
        \color\back[2] = $FFFFFFFF 
      EndIf
      
      \scroll\v = Bar::Scroll(0, 0, 16, 0, 0,0,0, #PB_ScrollBar_Vertical, 7)
      \scroll\h = Bar::Scroll(0, 0, 0, Bool((\flag\buttons=0 And \flag\lines=0)=0)*16, 0,0,0, 0, 7)
      
      AddColumn(*This, 0,ColumnTitle, ColumnWidth)
      Resize(*this, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint, *this._S_widget = GetGadgetData(EventGadget())
    
    With *this
      Select EventType()
        Case #PB_EventType_Repaint : Repaint = 1
        Case #PB_EventType_Resize : ResizeGadget(\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Resize(*this, #PB_Ignore, #PB_Ignore, GadgetWidth(\canvas\gadget), GadgetHeight(\canvas\gadget)) : Repaint = 1
        Default
          Repaint | CallBack(*this, EventType())
      EndSelect
      
      
      If Repaint 
        If StartDrawing(CanvasOutput(\canvas\gadget))
          Draw(*this)
          StopDrawing()
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, x.i, y.i, width.i, height.i, ColumnTitle.s, ColumnWidth.i, flag.i=0)
    Protected g = CanvasGadget(Gadget, x, y, width, height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget = g : EndIf
    Protected *This._S_widget = AllocateStructure(_S_widget)
    
    With *This
      If *This
        *This = Widget(0, 0, Width.i, Height.i, ColumnTitle.s, ColumnWidth.i, Flag|#PB_Flag_NoButtons|#PB_Flag_NoLines)
        *this\canvas\window = GetActiveWindow()
        *this\canvas\gadget = Gadget
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
        PostEvent(#PB_Event_Gadget, \Canvas\window, *this\canvas\gadget, #PB_EventType_Repaint)
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
EndModule

;-
;- EXAMPLE
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule ListIcon
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
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  
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
    
    ;;;;
    ;AddGadgetItem(1, 1, "Node "+Str(a), ImageID(0), 0)      
    
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
    TreeGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes) ; |#PB_Tree_NoLines|#PB_Tree_NoButtons                                       
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
    
    
    g_Canvas = CanvasGadget(-1, 0, 225, 1110, 425, #PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    
    g = 10
    *g = Widget(10, 100, 210, 210,"Column_0",90, #PB_Flag_AlwaysSelection|#PB_Tree_CheckBoxes|#PB_Flag_GridLines)                                         
    *g\canvas\Gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    
    ; 1_example
    For i=1 To 2 : AddColumn(*g, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    i=1
    AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0, 0)                                          
    i=2
    AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0, 1)                                          
    i=3
    AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0, 1)                                          
    i=4
    AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0, 0)                                          
    
    g = 11
    *g = Widget(230, 100, 210, 210,"Column_1",90, #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection)                                         
    *g\canvas\Gadget = g_Canvas
    ;  3_example
    AddItem(*g, 0, "Tree_0", -1 )
    AddItem(*g, 1, "Tree_1_1", 0, 1) 
    AddItem(*g, 2, "Tree_1_", 0, 1) 
    AddItem(*g, 5, "Tree_1_1_1", -1, 2) 
    AddItem(*g, 6, "Tree_1_1_2", -1, 2) 
    AddItem(*g, 7, "Tree_1_1_2_1", -1, 3) 
    AddItem(*g, 9, "Tree_1_1_2_1_1_4_hhhhhhhhhhhhh_", -1, 4) 
    AddItem(*g, 8, "Tree_1_1_2_2 980980_", -1, 3) 
    AddItem(*g, 3, "Tree_1_2", -1, 1) 
    AddItem(*g, 4, "Tree_1_3", -1, 1) 
    AddItem(*g, 10, "Tree_2",-1 )
    AddItem(*g, 11, "Tree_3", -1 )
    AddItem(*g, 12, "Tree_4", -1 )
    AddItem(*g, 13, "Tree_5", -1 )
    AddItem(*g, 14, "Tree_6", -1 )
    
    ;;;;
    ;     AddItem (*List(), 1, "Node "+Str(a), 0, 0)                                         
    AddElement(*List()) : *List() = *g
    
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
    *g = Widget(450, 100, 210, 210,"Column_1",90, #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection|#PB_Flag_CheckBoxes  |#PB_Flag_NoLines|#PB_Flag_NoButtons|#PB_Flag_MultiSelect  )                            
    *g\canvas\Gadget = g_Canvas
    AddElement(*List()) : *List() = *g
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
    *g = Widget(670, 100, 210, 210,"Column_1",90, #PB_Flag_AlwaysSelection|#PB_Tree_NoLines)                                         
    *g\canvas\Gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  4_example
    AddItem(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 3, "Tree_3_1", -1, 1) 
    AddItem(*g, 3, "Tree_3_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    
    g = 14
    *g = Widget(890, 100, 103, 210,"Column_1",90, #PB_Flag_AlwaysSelection|#PB_Tree_NoButtons)                                         
    *g\canvas\Gadget = g_Canvas
    AddElement(*List()) : *List() = *g
    ;  5_example
    AddItem(*g, 0, "Tree_0 (NoButtons)", 0)
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    g = 15
    *g = Widget(890+106, 100, 103, 210,"Column_1",90, #PB_Flag_AlwaysSelection|#PB_Flag_BorderLess)                                         
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
; IDE Options = PureBasic 5.71 LTS (Windows - x64)
; CursorPosition = 4182
; FirstLine = 4176
; Folding = ----------------------------------------------------------------------------
; EnableXP