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
    WordWrap.b
    MultiLine.b
    Vertical.b
    Rotate.f
    
    Caret.i[2] ; 0 = Pos ; 1 = PosFixed
    
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
  
  Structure WIDGET Extends COORDINATE
    Handle.i
    *Widget.WIDGET
    Canvas.CANVAS
    Color.COLOR[4]
    Text.TEXT[4]
    
    fSize.i
    bSize.i
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
    Radius.i
    Buttons.i
    
    ; edit
    Pos.i[2] ; 0 = Pos ; 1 = PosFixed
    Caret.i[2] ; 0 = Pos ; 1 = PosFixed
    
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
    
    List Items.WIDGET()
    List Columns.WIDGET()
    
  EndStructure
  
  Global NewList List.Widget()
  Global Use_List_Canvas_Gadget
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Structures
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -4-
; EnableXP