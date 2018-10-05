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
    Buttons.i
  EndStructure
  
  Structure PAGE
    Pos.l
    Length.l
    ScrollStep.l
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
  
  Structure TEXT Extends COORDINATE
    ;     Char.c
    Len.i
    String.s[3]
    CountString.i
    Change.b
    
    Align.i
    Align_Bottom.i
    Align_Right.i
    Align_Vertical.i
    Align_Horisontal.i
    
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    WordWrap.b
    MultiLine.b
    
    CaretPos.i[2] ; 0 = Pos ; 1 = PosFixed
    
    Mode.i
  EndStructure
  
  Structure SCROLL Extends COORDINATE
    Window.l
    Gadget.l
    
    Max.l
    Min.l
    
    Both.b ; we see both scrolbars
    
    Size.l[4]
    Type.l[4]
    Focus.l
    Buttons.l
    Radius.l
    
    Hide.b[2]
    Alpha.a[2]
    Disable.b[2]
    Vertical.b
    DrawingMode.l
    
    Page.PAGE
    Area.PAGE
    Thumb.PAGE
    Button.PAGE
    Color.COLOR[4]
  EndStructure
  
  Structure WIDGET Extends COORDINATE
    Canvas.CANVAS
    Color.COLOR[4]
    
    FontID.i
    Text.TEXT[4]
    
    fSize.i
    bSize.i
    Hide.b[2]
    Disable.b[2]
    
    Type.i
    Resize.i ; 
    
    Focus.i
    
    Buttons.i
    Vertical.i
    
    Scroll.SCROLL
  
    DrawingMode.i
  EndStructure
  
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Structures
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; CursorPosition = 107
; FirstLine = 87
; Folding = --
; EnableXP