DeclareModule Structures
  
  ;- STRUCTURE
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
    
    
    bSize.b
    fSize.b[2]
    
    Hide.b[2]
    Disable.b[2]
    Cursor.i[2]
    
    Caret.i[2] ; 0 = Pos ; 1 = PosFixed
    Line.i[2]  ; 0 = Pos ; 1 = PosFixed
    
    
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
    *data
    collapsed.b
    childrens.i
    Item.i
    Attribute.l
    change.b
    flag.i
    
    
    *Default
    Alpha.a[2]
    
    DrawingMode.i
    
    List Items.Widget_S()
    List Columns.Widget_S()
    
  EndStructure
  
  ; $FF24B002 ; $FFD5A719 ; $FFE89C3D ; $FFDE9541 ; $FFFADBB3 ;
  Global Colors.Color_S
  With Colors                          
    ;- Серые цвета 
    ; Цвета по умолчанию
    \Front[1] = $FF000000
    \Fore[1] = $FFFCFCFC ; $FFF6F6F6 
    \Back[1] = $FFE2E2E2 ; $FFE8E8E8 ; 
    \Line[1] = $FFA3A3A3
    \Frame[1] = $FFA5A5A5 ; $FFBABABA
    
    ; Цвета если мышь на виджете
    \Front[2] = $FF000000
    \Fore[2] = $FFF5F5F5 ; $FFF5F5F5 ; $FFEAEAEA
    \Back[2] = $FFCECECE ; $FFEAEAEA ; 
    \Line[2] = $FF5B5B5B
    \Frame[2] = $FF8F8F8F
    
    ; Цвета если нажали на виджет
    \Front[3] = $FFFFFFFF
    \Fore[3] = $FFE2E2E2
    \Back[3] = $FFB4B4B4
    \Line[3] = $FFFFFFFF
    \Frame[3] = $FF6F6F6F
    
    ;         ;- Зеленые цвета
    ;         ; Цвета по умолчанию
    ;         \Front[1] = $FF000000
    ;         \Fore[1] = $FFE4FEDF 
    ;         \Back[1] = $FFD3FECA  
    ;         \Frame[1] = $FFA0FC8C 
    ;         
    ;         ; Цвета если мышь на виджете
    ;         \Front[2] = $FF000000
    ;         \Fore[2] = $FFD8FED0
    ;         \Back[2] = $FFA0FC8C
    ;         \Frame[2] = $FF2DEE04
    ;         
    ;         ; Цвета если нажали на виджет
    ;         \Front[3] = $FFFFFFFF
    ;         \Fore[3] = $FFC3FDB7
    ;         \Back[3] = $FF2DEE04
    ;         \Frame[3] = $FF23BE03
    
    ;         ;- Синие цвета
    ;         ; Цвета по умолчанию
    ;         \Front[1] = $FF000000
    ;         \Fore[1] = $FFF8F8F8 ; $FFF0F0F0 
    ;         \Back[1] = $FFE5E5E5
    ;         \Frame[1] = $FFACACAC 
    ;         
    ;         ; Цвета если мышь на виджете
    ;         \Front[2] = $FF000000
    ;         \Fore[2] = $FFFAF8F8 ; $FFFCF4EA
    ;         \Back[2] = $FFFAE8DB ; $FFFCECDC
    ;         \Frame[2] = $FFFC9F00
    ;         
    ;         ; Цвета если нажали на виджет
    ;         \Front[3] = $FFFFFFFF
    ;         \Fore[3] = $FFFDF7EF
    ;         \Back[3] = $FFFBD9B7
    ;         \Frame[3] = $FFE59B55
    
  EndWith
  
  Global *Focus.Widget_S
  Global NewList List.Widget_S()
  Global Use_List_Canvas_Gadget
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Structures
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---
; EnableXP