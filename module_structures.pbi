DeclareModule Structures
  
  ;- STRUCTURE
  Structure Coordinate
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  Structure Mouse
    X.i
    Y.i
    Buttons.i
  EndStructure
  
  Structure Page
    Pos.l
    Length.l
    ScrollStep.l
  EndStructure
  
  Structure Canvas
    Mouse.Mouse
    Gadget.i
    Window.i
    
    Input.c
    Key.i[2]
  EndStructure
  
  Structure Color
    Front.i[4]
    Fore.i[4]
    Back.i[4]
    Line.i[4]
    Frame.i[4]
    Arrows.i[4]
  EndStructure
  
  Structure Text Extends Coordinate
    ;     Char.c
    Len.i
    String.s[3]
    Change.b
    
    Align.i
    
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
  
  Structure Scroll Extends COORDINATE
    Window.l
    Gadget.l
    Max.l
    Min.l
    
    Both.b ; we see both scrolbars
    
    Size.l[4]
    Type.l[4]
    Focus.l
    Buttons.l
    Button.Page
    Radius.l
    
    Hide.b[2]
    Alpha.a[2]
    Disable.b[2]
    Vertical.b
    DrawingMode.l
    
    Page.PAGE
    Area.PAGE
    Thumb.PAGE
    Color.Color[4]
  EndStructure
  
  Structure Widget Extends Coordinate
    Canvas.Canvas
    Color.Color[4]
    
    FontID.i
    Text.Text[4]
    
    fSize.i
    bSize.i
    Hide.b[2]
    Disable.b[2]
    
    Type.i
    
    
    Buttons.i
    Focus.i
    
    Vertical.i
    ButtonLength.i
    DrawingMode.i
    
;     Max.i
;     Min.i
;     
;     Pos.i
;     PageLength.i
;     
;     AreaPos.i
;     AreaLength.i
;     
;     ThumbPos.i
;     ThumbLength.i
    
    Scroll.Scroll
  
  EndStructure
  
EndDeclareModule 

Module Structures 
  
EndModule 

UseModule Structures
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; CursorPosition = 7
; Folding = --
; EnableXP