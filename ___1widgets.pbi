DeclareModule Structures
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ; PB Interne Struktur Gadget MacOS
    Structure sdkGadget
      *gadget
      *container
      *vt
      UserData.i
      Window.i
      Type.i
      Flags.i
    EndStructure
  CompilerEndIf
  
  ;- STRUCTURE
  ;- - Point_S
  Structure Point_S
    y.i
    x.i
  EndStructure
  
  ;- - Coordinate_S
  Structure Coordinate_S
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  ;- - Mouse_S
  Structure Mouse_S
    X.i
    Y.i
    at.i ; at point widget
    Wheel.i ; delta
    Buttons.i ; state
    *Delta.Mouse_S
  EndStructure
  
  ;- - Align_S
  Structure Align_S
    Right.b
    Bottom.b
    Vertical.b
    Horizontal.b
  EndStructure
  
  ;- - Page_S
  Structure Page_S
    Pos.i
    len.i
  EndStructure
  
  ;- - Color_S
  Structure Color_S
    State.b
    Front.i[4]
    Fore.i[4]
    Back.i[4]
    Line.i[4]
    Frame.i[4]
    Alpha.a[2]
  EndStructure
  
  ;- - Flag_S
  Structure Flag_S
    InLine.b
    Lines.b
    Buttons.b
    GridLines.b
    CheckBoxes.b
    FullSelection.b
    AlwaysSelection.b
    MultiSelect.b
    ClickSelect.b
  EndStructure
  
  ;- - Image_S
  Structure Image_S Extends Coordinate_S
    ImageID.i[2]
    change.b
    Align.Align_S
  EndStructure
  
  ;- - Text_S
  Structure Text_S Extends Coordinate_S
    Big.i[3]
    Pos.i
    Len.i
    Caret.i[3] ; 0 = Pos ; 1 = PosFixed
    
    FontID.i
    String.s[4]
    Change.b
    
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    MultiLine.b
    Vertical.b
    Rotate.f
    
    Align.Align_S
    ;List Char.c()
    ;Map Char.i()
  EndStructure
    
  ;- - Bar_S
  Structure Bar_S Extends Coordinate_S  ; Bar::Bar_S ; 
    *s.Scroll_S
    
    ; splitter bar
    *First.Bar_S 
    *Second.Bar_S
    
    ; track bar
    Ticks.b
    
    ; progress bar
    Smooth.b
    
    at.b
    Type.i[3] ; [2] for splitter
    Radius.a
    ArrowSize.a[3]
    ArrowType.b[3]
    
    Max.i
    Min.i
    *Step
    Hide.b[2]
    
    Focus.b
    Change.b
    Resize.b
    Vertical.b
    Inverted.b
    Direction.i
    ButtonLen.i[4]
    
    Page.Page_S
    Area.Page_S
    Thumb.Page_S
    Color.Color_S[4]
  EndStructure
  
  ;- - Event_S
  Structure Post_S
    Gadget.i
    Window.i
    Type.i
    Event.i
    *Function
    *Widget.Bar_S
    *Active.Bar_S
  EndStructure
  
  ;- - Scroll_S
  Structure Scroll_S Extends Coordinate_S
    ;Post.Post_S
    
    *v.Bar_S
    *h.Bar_S
  EndStructure
  
  Structure Keyboard_S
    Input.c
    Key.i[2]
  EndStructure
  
  Structure Root_S
    Canvas.i
    CanvasWindow.i
  EndStructure
  
  ;- - Margin_S
  Structure Margin_S
    FonyID.i
    Width.i
    Color.Color_S
  EndStructure
  
  ;- - Items_S
  Structure Items_S Extends Coordinate_S
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    *i_Parent.Items_S
    Drawing.i
    
    Image.Image_S
    Text.Text_S[4]
    *Box.Box_S
    
    State.b
    Hide.b[2]
    Caret.i[3]  ; 0 = Pos ; 1 = PosFixed
    Vertical.b
    Radius.a
    
    change.b
    sublevel.i
    sublevellen.i
    
    childrens.i
    *data      ; set/get item data
  EndStructure
  
  
  ;- - Widget_S
  Structure Widget_S Extends Coordinate_S
    Type.i
    handle.i    ; Adress of new list element
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
   ;;; line.i[3]   ; 
    
    CountItems.i[2]
    Root.Root_S
    
    Mouse.Mouse_S
    Keyboard.Keyboard_S
    Margin.Margin_S
    
    *Widget.Widget_S
    ;Canvas.Canvas_S
    Color.Color_S
    Text.Text_S[4]
    Clip.Coordinate_S
    *tooltip.Text_S
    scroll.Scroll_S
    image.Image_S
    flag.Flag_S
    
    bs.b
    fs.b[2]
    Hide.b[2]
    Disable.b[2]
    Interact.b ; будет ли взаимодействовать с пользователем?
    Cursor.i[2]
    
    
    Focus.i
    LostFocus.i
    
    Drag.b[2]
    Resize.b ; 
    Toggle.b ; 
    Buttons.i
    
    *data
    change.b
    radius.i
    vertical.b
    checked.b[2]
    sublevellen.i
    
    attribute.i
    
    *Default

    List *Items.Items_S()
    List *Lines.Items_S()
    List *Columns.Widget_S()
    Repaint.i ; Будем посылать сообщение что надо перерисовать а после надо сбрасывать переменую
  EndStructure
  
  ;-
  ;- Colors
  ; $FF24B002 ; $FFD5A719 ; $FFE89C3D ; $FFDE9541 ; $FFFADBB3 ;
  Global Color_Default.Color_S
  
  With Color_Default                          
    \State = 0
    
    ;- Серые цвета 
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
    
    ;- Зеленые цвета
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
    \Front[2] = $FFFEFEFE
    \Fore[2] = $FFE9BA81;$C8FFFCFA
    \Back[2] = $FFE89C3D ; $80E89C3D
    \Frame[2] = $FFDC9338; $80DC9338
    
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
  
 ; Global *Focus.Widget_S
  Global NewList List.Widget_S()
  Global Use_List_Canvas_Gadget,  _scroll_height_2
            
EndDeclareModule 

Module Structures 
  
EndModule 

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
    #PB_Flag_Single
    
    #PB_Flag_Default
    #PB_Flag_Toggle
    
    #PB_Flag_GridLines
    #PB_Flag_Invisible
    
    #PB_Flag_MultiSelect
    #PB_Flag_ClickSelect
    
    #PB_Flag_AutoSize
    #PB_Flag_AutoRight
    #PB_Flag_AutoBottom
    
    #PB_Flag_FullSelection; = 512 ; #PB_ListIcon_FullRowSelect
    ; #____End____
  EndEnumeration
  
  #PB_Flag_Numeric = #PB_Text_Numeric
  #PB_Flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #PB_Flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  
  #PB_Flag_CheckBoxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
  #PB_Flag_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
    
  #PB_Flag_AlwaysSelection = 32 ; #PB_Tree_AlwaysShowSelection ; 0 32 Even If the gadget isn't activated, the selection is still visible.
  
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
  
  #PB_ScrollBar_Direction = 1<<2
  #PB_ScrollBar_NoButtons = 1<<3
  #PB_ScrollBar_Inverted = 1<<4
  
EndDeclareModule 

Module Constants
  
EndModule 

UseModule Constants
UseModule Structures


CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_bar.pbi"
CompilerEndIf

DeclareModule Editor
  EnableExplicit

  UseModule Constants
  UseModule Structures
  
  ;- - DECLAREs MACROs
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
 
  Macro Text_CountItems(_this_)
    _this_\CountItems
  EndMacro
  
  Macro Text_ClearItems(_this_) 
    _this_\CountItems = 0
    _this_\Text\Change = 1 
    If _this_\Text\Editable
      _this_\Text\String = #LF$
    EndIf
    If Not _this_\Repaint : _this_\Repaint = 1
      PostEvent(#PB_Event_Gadget, _this_\Root\CanvasWindow, _this_\Root\Canvas, #PB_EventType_Repaint)
    EndIf
  EndMacro
  
  Macro Text_RemoveItem(_this_, _item_) 
    _this_\CountItems - 1
    _this_\Text\Change = 1
    If _this_\CountItems =- 1 
      _this_\CountItems = 0 
      _this_\Text\String = #LF$
      If Not _this_\Repaint : _this_\Repaint = 1
        PostEvent(#PB_Event_Gadget, _this_\Root\CanvasWindow, _this_\Root\Canvas, #PB_EventType_Repaint)
      EndIf
    Else
      _this_\Text\String = RemoveString(_this_\Text\String, StringField(_this_\Text\String, _item_+1, #LF$) + #LF$)
    EndIf
  EndMacro
  
  Declare.i Update(*This.Widget_S)
  
  ;- DECLARE
  Declare.i SetItemState(*This.Widget_S, Item.i, State.i)
  Declare GetState(*This.Widget_S)
  Declare.s GetText(*This.Widget_S)
  Declare.i ClearItems(*This.Widget_S)
  Declare.i CountItems(*This.Widget_S)
  Declare.i RemoveItem(*This.Widget_S, Item.i)
  Declare SetState(*This.Widget_S, State.i)
  Declare GetAttribute(*This.Widget_S, Attribute.i)
  Declare SetAttribute(*This.Widget_S, Attribute.i, Value.i)
  Declare SetText(*This.Widget_S, Text.s, Item.i=0)
  Declare SetFont(*This.Widget_S, FontID.i)
  Declare.i AddItem(*This.Widget_S, Item.i,Text.s,Image.i=-1,Flag.i=0)
  
  ;Declare.i Make(*This.Widget_S)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
  Declare.i ReDraw(*This.Widget_S, Canvas =- 1, BackColor=$FFF0F0F0)
  Declare.i Draw(*This.Widget_S)
EndDeclareModule

Module Editor
  Global *Buffer = AllocateMemory(10000000)
  Global *Pointer = *Buffer
  
  Procedure.i Update(*This.Widget_S)
    *This\Text\String.s = PeekS(*Buffer)
    *This\Text\Change = 1
  EndProcedure
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  
  Declare.i Canvas_CallBack()
  
  ;-
  ;- PUBLIC
  Procedure.s Text_Make(*This.Widget_S, Text.s)
    Protected String.s, i.i, Len.i
    
    With *This
      If \Text\Numeric And Text.s <> #LF$
        Static Dot, Minus
        Protected Chr.s, Input.i, left.s, count.i
        
        Len = Len(Text.s) 
        For i = 1 To Len 
          Chr = Mid(Text.s, i, 1)
          Input = Asc(Chr)
          
          Select Input
            Case '0' To '9', '.','-'
            Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Chr = Chr(Input)
            Default
              Input = 0
          EndSelect
          
          If Input
            If \Type = #PB_GadgetType_IPAddress
              left.s = Left(\Text\String.s[1], \Text\Caret)
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\Text\String.s[1], \Text\Caret+1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
                ;               ElseIf Mid(\Text\String, \Text\Caret + 1, 1) = "."
                ;                 \Text\Caret + 1 : \Text\Caret[1]=\Text\Caret
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\Text\String.s[1], \Text\Caret + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\Text\String.s[1], \Text\Caret + 1, 1) <> "-"
              Minus = 1
            ElseIf Input <> '-'
              Minus = 0
            Else
              Continue
            EndIf
            
            String.s + Chr
          EndIf
        Next
        
      ElseIf \Text\Pass
        Len = Len(Text.s) 
        For i = 1 To Len : String.s + "●" : Next
        
      Else
        Select #True
          Case \Text\Lower : String.s = LCase(Text.s)
          Case \Text\Upper : String.s = UCase(Text.s)
          Default
            String.s = Text.s
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.s Text_Wrap(*This.Widget_S, Text.s, Width.i, Mode=-1, nl$=#LF$, DelimList$=" "+Chr(9))
    Protected.i CountString, i, start, ii, found, length
    Protected line$, ret$="", LineRet$="", TextWidth
    
    ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CR$, #LF$)
    ;     Text.s + #LF$
    ;  
    
    
    CountString = CountString(Text.s, #LF$) 
    ; Protected time = ElapsedMilliseconds()
    
    ; ;     Protected Len
    ; ;     Protected *s_0.Character = @Text.s
    ; ;     Protected *e_0.Character = @Text.s 
    ; ;     #SOC = SizeOf (Character)
    ; ;       While *e_0\c 
    ; ;         If *e_0\c = #LF
    ; ;           Len = (*e_0-*s_0)>>#PB_Compiler_Unicode
    ; ;           line$ = PeekS(*s_0, Len) ;Trim(, #LF$)
    
    For i = 1 To CountString
      line$ = StringField(Text.s, i, #LF$)
      start = Len(line$)
      length = start
      
      ; Get text len
      While length > 1
        ; Debug ""+TextWidth(RTrim(Left(Line$, length))) +" "+ GetTextWidth(RTrim(Left(Line$, length)), length)
        If width > TextWidth(RTrim(Left(Line$, length))) ; GetTextWidth(RTrim(Left(Line$, length)), length) ;   
          Break
        Else
          length - 1
        EndIf
      Wend 
      
      ;  Debug ""+start +" "+ length
      While start > length 
        If mode
          For ii = length To 0 Step - 1
            If mode = 2 And CountString(Left(line$,ii), " ") > 1     And width > 71 ; button
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
          ; Debug ""+TextWidth(RTrim(Left(Line$, length))) +" "+ GetTextWidth(RTrim(Left(Line$, length)), length)
          If width > TextWidth(RTrim(Left(Line$, length))) ; GetTextWidth(RTrim(Left(Line$, length)), length) ; 
            Break
          Else
            length - 1
          EndIf
        Wend 
        
      Wend   
      
      ret$ + LineRet$ + line$ + #CR$+nl$
      LineRet$=""
    Next
    
    ; ;       *s_0 = *e_0 + #SOC : EndIf : *e_0 + #SOC : Wend
    ;Debug  ElapsedMilliseconds()-time
    ; MessageRequester("",Str( ElapsedMilliseconds()-time))
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  Procedure.i Editor_Caret(*This.Widget_S, Line.i = 0)
    Static LastLine.i =- 1,  LastItem.i =- 1
    Protected Item.i, SelectionLen.i
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, MouseX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If Line < 0 And FirstElement(*This\Items())
        ; А если выше всех линии текста,
        ; то позиция коректора начало текста.
        Position = 0
      ElseIf Line < ListSize(*This\Items()) And 
             SelectElement(*This\Items(), Line)
        ; Если находимся на линии текста, 
        ; то получаем позицию коректора.
        
        If ListSize(\Items())
          Len = \Items()\Text\Len
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s
          If Not FontID : FontID = \Text\FontID : EndIf
          MouseX = \Mouse\X - (\Items()\Text\X+\Scroll\X)
          
          If StartDrawing(CanvasOutput(\Root\Canvas)) 
            If FontID : DrawingFont(FontID) : EndIf
            
            ; Get caret pos & len
            For i = 0 To Len
              X = TextWidth(Left(String.s, i))
              Distance = (MouseX-X)*(MouseX-X)
              
              If MinDistance > Distance 
                MinDistance = Distance
                \Text\Caret[2] = X ; len
                Position = i       ; pos
              EndIf
            Next 
            
            ;             ; Длина переноса строки
            ;             PushListPosition(\Items())
            ;             If \Mouse\Y < \Y+(\Text\Height/2+1)
            ;               Item.i =- 1 
            ;             Else
            ;               Item.i = ((((\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / (\Text\Height/2+1)) - 1)/2
            ;             EndIf
            ;             
            ;             If LastLine <> \Index[1] Or LastItem <> Item
            ;               \Items()\Text[2]\Width[2] = 0
            ;               
            ;               If (\Items()\Text\String.s = "" And Item = \Index[1] And Position = len) Or
            ;                  \Index[2] > \Index[1] Or                                            ; Если выделяем снизу вверх
            ;                  (\Index[2] =< \Index[1] And \Index[1] = Item And Position = len) Or ; Если позиция курсора неже половини высоты линии
            ;                  (\Index[2] < \Index[1] And                                          ; Если выделяем сверху вниз
            ;                   PreviousElement(*This\Items()))                                    ; то выбираем предыдущую линию
            ;                 
            ;                 If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
            ;                   \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text\Width
            ;                 EndIf 
            ;                 
            ;                 ; \Items()\Text[2]\Width = (\Items()\Width-\Items()\Text\Width) + TextWidth(\Items()\Text[2]\String.s)
            ;                 
            ;                 If \Flag\FullSelection
            ;                   \Items()\Text[2]\Width[2] = \Flag\FullSelection
            ;                 Else
            ;                   \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
            ;                 EndIf
            ;               EndIf
            ;               
            ;               LastItem = Item
            ;               LastLine = \Index[1]
            ;             EndIf
            ;             PopListPosition(\Items())
            
            StopDrawing()
          EndIf
        EndIf
        
      ElseIf LastElement(*This\Items())
        ; Иначе, если ниже всех линии текста,
        ; то позиция коректора конец текста.
        Position = \Items()\Text\Len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure.i Editor_Change(*This.Widget_S, Pos.i, Len.i)
    With *This
      \Items()\Text[2]\Pos = Pos
      \Items()\Text[2]\Len = Len
      
      ; text string/pos/len/state
      If (\index[2] > \index[1] Or \index[2] = \Items()\index)
        \Text[1]\Change = #True
      EndIf
      If (\index[2] < \index[1] Or \index[2] = \Items()\index) 
        \Text[3]\Change = 1
      EndIf
      
      ; lines string/pos/len/state
      \Items()\Text[1]\Change = #True
      \Items()\Text[1]\Len = \Items()\Text[2]\Pos
      \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Items()\Text[1]\Len) 
      
      \Items()\Text[3]\Change = #True
      \Items()\Text[3]\Pos = (\Items()\Text[2]\Pos + \Items()\Text[2]\Len)
      \Items()\Text[3]\Len = (\Items()\Text\Len - \Items()\Text[3]\Pos)
      \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text[3]\Len) 
      
      If \Items()\Text[1]\Len = \Items()\Text[3]\Pos
        \Items()\Text[2]\String.s = ""
        \Items()\Text[2]\Width = 0
      Else
        \Items()\Text[2]\Change = #True 
        \Items()\Text[2]\String.s = Mid(\Items()\Text\String.s, 1 + \Items()\Text[2]\Pos, \Items()\Text[2]\Len) 
      EndIf
      
      If (\Text[1]\Change Or \Text[3]\Change)
        If \Text[1]\Change
          \Text[1]\Len = (\Items()\Text[0]\Pos + \Items()\Text[1]\len)
          \Text[1]\String.s = Left(\Text\String.s[1], \Text[1]\Len) 
          \Text[2]\Pos = \Text[1]\Len
        EndIf
        
        If \Text[3]\Change
          \Text[3]\Pos = (\Items()\Text[0]\Pos + \Items()\Text[3]\Pos)
          \Text[3]\Len = (\Text\Len - \Text[3]\Pos)
          \Text[3]\String.s = Right(\Text\String.s[1], \Text[3]\Len)
        EndIf
        
        If \Text[1]\Len <> \Text[3]\Pos 
          \Text[2]\Change = 1 
          \Text[2]\Len = (\Text[3]\Pos-\Text[2]\Pos)
          \Text[2]\String.s = Mid(\Text\String.s[1], 1 + \Text[2]\Pos, \Text[2]\Len) 
        Else
          \Text[2]\Len = 0 : \Text[2]\String.s = ""
        EndIf
        
        \Text[1]\Change = 0 : \Text[3]\Change = 0 
      EndIf
      
      
      
      ;       If CountString(\Text[3]\String.s, #LF$)
      ;         Debug "chang "+\Items()\Text\String.s +" "+ CountString(\Text[3]\String.s, #LF$)
      ;       EndIf
      ;       
    EndWith
  EndProcedure
  
  Procedure.i Editor_SelText(*This.Widget_S) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Pos.i, Len.i
    
    With *This
      ;Debug "7777    "+\Text\Caret +" "+ \Text\Caret[1] +" "+\Index[1] +" "+ \Index[2] +" "+ \Items()\Text\String
      
      If (Caret <> \Text\Caret Or Line <> \Index[1] Or (\Text\Caret[1] >= 0 And Caret1 <> \Text\Caret[1]))
        \Items()\Text[2]\String.s = ""
        
        PushListPosition(\Items())
        If \Index[2] = \Index[1]
          If \Text\Caret[1] = \Text\Caret And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
            \Items()\Text[2]\Width = 0 
          EndIf
          If PreviousElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Width[2] = 0 
            \Items()\Text[2]\Len = 0 
          EndIf
        ElseIf \Index[2] > \Index[1]
          If PreviousElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
          EndIf
        Else
          If NextElement(\Items()) And \Items()\Text[2]\Len 
            \Items()\Text[2]\Len = 0 
          EndIf
        EndIf
        PopListPosition(\Items())
        
        If \Index[2] = \Index[1]
          If \Text\Caret[1] = \Text\Caret 
            Pos = \Text\Caret[1]
            ;             If \Text\Caret[1] = \Items()\Text\Len
            ;              ; Debug 555
            ;             ;  Len =- 1
            ;             EndIf
            ; Если выделяем с право на лево
          ElseIf \Text\Caret[1] > \Text\Caret 
            ; |<<<<<< to left
            Pos = \Text\Caret
            Len = (\Text\Caret[1]-Pos)
          Else 
            ; >>>>>>| to right
            Pos = \Text\Caret[1]
            Len = (\Text\Caret-Pos)
          EndIf
          
          ; Если выделяем снизу вверх
        ElseIf \Index[2] > \Index[1]
          ; <<<<<|
          Pos = \Text\Caret
          Len = \Items()\Text\Len-Pos
          ; Len - Bool(\Items()\Text\Len=Pos) ; 
        Else
          ; >>>>>|
          Pos = 0
          Len = \Text\Caret
        EndIf
        
        Editor_Change(*This, Pos, Len)
        
        Line = \Index[1]
        Caret = \Text\Caret
        Caret1 = \Text\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Pos
  EndProcedure
  
  Procedure.i Editor_SelReset(*This.Widget_S)
    With *This
      PushListPosition(\Items())
      ForEach \Items() 
        If \Items()\Text[2]\Len <> 0
          \Items()\Text[2]\Len = 0 
          \Items()\Text[2]\Width[2] = 0 
          \Items()\Text[1]\String = ""
          \Items()\Text[2]\String = "" 
          \Items()\Text[3]\String = ""
          \Items()\Text[2]\Width = 0 
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  
  Procedure.i Editor_SelLimits(*This.Widget_S)
    Protected i, char.i
    
    Macro _is_selection_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *This
      char = Asc(Mid(\Items()\Text\String.s, \Text\Caret + 1, 1))
      If _is_selection_end_(char)
        \Text\Caret + 1
        \Items()\Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Text\Caret To 1 Step - 1
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Text\Caret To \Items()\Text\Len
          char = Asc(Mid(\Items()\Text\String.s, i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret = i - 1
        \Items()\Text[2]\Len = \Text\Caret[1] - \Text\Caret
      EndIf
    EndWith           
  EndProcedure
  
  ;-
  Procedure.i Editor_Move(*This.Widget_S, Width)
    Protected Left,Right
    
    With *This
      ; Если строка выходит за предели виджета
      PushListPosition(\items())
      If SelectElement(\items(), \Text\Big) ;And \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
        Protected Caret.i =- 1, i.i, cursor_x.i, Distance.f, MinDistance.f = Infinity()
        Protected String.s = \Items()\Text\String.s
        Protected string_len.i = \Items()\Text\Len
        Protected mouse_x.i = \Mouse\X-(\Items()\Text\X+\Scroll\X)
        
        For i = 0 To string_len
          cursor_x = TextWidth(Left(String.s, i))
          Distance = (mouse_x-cursor_x)*(mouse_x-cursor_x)
          
          If MinDistance > Distance 
            MinDistance = Distance
            Right =- cursor_x
            Caret = i
          EndIf
        Next
        
        Left = (Width + Right)
        \Items()\Text[3]\Width = TextWidth(Right(String.s, string_len-Caret))
        
        If \Scroll\X < Right
          Bar::SetState(\Scroll\h, -Right) ;: \Scroll\X = Right
        ElseIf \Scroll\X > Left
          Bar::SetState(\Scroll\h, -Left) ;: \Scroll\X = Left
        ElseIf (\Scroll\X < 0 And \Keyboard\Input = 65535 ) : \Keyboard\Input = 0
          \Scroll\X = (Width-\Items()\Text[3]\Width) + Right
          If \Scroll\X>0 : \Scroll\X=0 : EndIf
        EndIf
      EndIf
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  Procedure.i Editor_Paste(*This.Widget_S, Chr.s, Count.i=0)
    Protected Repaint.i
    
    With *This
      If \Index[1] <> \Index[2] ; Это значить строки выделени
        If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
        
        Editor_SelReset(*This)
        
        If Count
          \Index[2] + Count
          \Text\Caret = Len(StringField(Chr.s, 1 + Count, #LF$))
        ElseIf Chr.s = #LF$ ; to return
          \Index[2] + 1
          \Text\Caret = 0
        Else
          \Text\Caret = \Items()\Text[1]\Len + Len(Chr.s)
        EndIf
        
        \Text\Caret[1] = \Text\Caret
        \Index[1] = \Index[2]
        \Text\Change =- 1 ; - 1 post event change widget
        Repaint = 1 
      EndIf
      
      \Text\String.s[1] = \Text[1]\String + Chr.s + \Text[3]\String
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Insert(*This.Widget_S, Chr.s)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, String.s, Count.i
    
    With *This
      Chr.s = Text_Make(*This, Chr.s)
      
      If Chr.s
        Count = CountString(Chr.s, #LF$)
        
        If Not Editor_Paste(*This, Chr.s, Count)
          If \Items()\Text[2]\Len 
            If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
            \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          EndIf
          
          \Items()\Text[1]\Change = 1
          \Items()\Text[1]\String.s + Chr.s
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s)
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          If Count
            \Index[2] + Count
            \Index[1] = \Index[2] 
            \Text\Caret = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \Text\Caret + Len(Chr.s) 
          EndIf
          
          \Text\String.s[1] = \Text[1]\String + Chr.s + \Text[3]\String
          \Text\Caret[1] = \Text\Caret 
          ; \CountItems = CountString(\Text\String.s[1], #LF$)
          \Text\Change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\Items(), \index[2]) 
        Repaint = 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Cut(*This.Widget_S)
    ProcedureReturn Editor_Paste(*This.Widget_S, "")
  EndProcedure
  
  
  ;-
  Procedure Editor_AddLine(*This.Widget_S, Line.i, String.s) ;,Image.i=-1,Sublevel.i=0)
    Protected Image_Y, Image_X, Text_X, Text_Y, Height, Width, Indent = 4
    
    Macro _set_scroll_height_(_this_)
    If _this_\Scroll And Not _this_\hide And Not _this_\Items()\Hide
      _this_\Scroll\Height+_this_\Text\Height
      
      
     ; _this_\scroll\v\max = _this_\scroll\Height
    EndIf
  EndMacro
  
  Macro _set_scroll_width_(_this_)
    If _this_\Scroll And Not _this_\items()\hide And
       _this_\Scroll\width<(_this_\margin\width + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
      _this_\scroll\width=(_this_\margin\width + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
;        _this_\Scroll\width<(_this_\margin\width + (_this_\sublevellen -Bool(_this_\Scroll\h\Radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
;       _this_\scroll\width=(_this_\margin\width + (_this_\sublevellen -Bool(_this_\Scroll\h\Radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
      
;       If _this_\scroll\width < _this_\width[2]-(Bool(Not _this_\Scroll\v\Hide) * _this_\Scroll\v\width)
;         _this_\scroll\width = _this_\width[2]-(Bool(Not _this_\Scroll\v\Hide) * _this_\Scroll\v\width)
;       EndIf
      
;        If _this_\scroll\Height < _this_\Height[2]-(Bool(Not _this_\Scroll\h\Hide) * _this_\Scroll\h\Height)
;         _this_\scroll\Height = _this_\Height[2]-(Bool(Not _this_\Scroll\h\Hide) * _this_\Scroll\h\Height)
;       EndIf
     
      _this_\Text\Big = _this_\Items()\Index ; Позиция в тексте самой длинной строки
      _this_\Text\Big[1] = _this_\Items()\Text\Pos ; Может и не понадобятся
      _this_\Text\Big[2] = _this_\Items()\Text\Len ; Может и не понадобятся
      
          
     ; _this_\scroll\h\max = _this_\scroll\width
     ;  Debug "   "+_this_\width +" "+ _this_\scroll\width
    EndIf
  EndMacro
  
  Macro _set_content_Y_(_this_)
      If _this_\Image\ImageID
        If _this_\Flag\InLine
          Text_Y=((Height-(_this_\Text\Height*_this_\CountItems))/2)
          Image_Y=((Height-_this_\Image\Height)/2)
        Else
          If _this_\Text\Align\Bottom
            Text_Y=((Height-_this_\Image\Height-(_this_\Text\Height*_this_\CountItems))/2)-Indent/2
            Image_Y=(Height-_this_\Image\Height+(_this_\Text\Height*_this_\CountItems))/2+Indent/2
          Else
            Text_Y=((Height-(_this_\Text\Height*_this_\CountItems)+_this_\Image\Height)/2)+Indent/2
            Image_Y=(Height-(_this_\Text\Height*_this_\CountItems)-_this_\Image\Height)/2-Indent/2
          EndIf
        EndIf
      Else
        If _this_\Text\Align\Bottom
          Text_Y=(Height-(_this_\Text\Height*_this_\CountItems)-Text_Y-Image_Y) 
        ElseIf _this_\Text\Align\Vertical
          Text_Y=((Height-(_this_\Text\Height*_this_\CountItems))/2)
        EndIf
      EndIf
    EndMacro
    
    Macro _set_content_X_(_this_)
      If _this_\Image\ImageID
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
        Else
          Text_X=_this_\margin\width
        EndIf
      EndIf
    EndMacro
    
    Macro _line_resize_X_(_this_)
      _this_\Items()\x = _this_\X + 5
      _this_\Items()\Width = Width
      _this_\Items()\Text\x = _this_\Items()\x+Text_X
      
      _this_\Image\X = _this_\Text\X+Image_X
      _this_\Items()\Image\X = _this_\Items()\x+Image_X-4
    EndMacro
    
    Macro _line_resize_Y_(_this_)
      _this_\Items()\y = _this_\Y+_this_\Scroll\Height+Text_Y + 2
      _this_\Items()\Height = _this_\Text\Height - Bool(_this_\CountItems<>1 And _this_\Flag\GridLines)
      _this_\Items()\Text\y = _this_\Items()\y + (_this_\Text\Height-_this_\Text\Height[1])/2 - Bool(#PB_Compiler_OS <> #PB_OS_MacOS And _this_\CountItems<>1)
      _this_\Items()\Text\Height = _this_\Text\Height[1]
      
      _this_\Image\Y = _this_\Text\Y+Image_Y
      _this_\Items()\Image\Y = _this_\Items()\y + (_this_\Text\Height-_this_\Items()\Image\Height)/2 + Image_Y
    EndMacro
    
    Macro _set_line_pos_(_this_)
      _this_\Items()\Text\Pos = _this_\Text\Pos - Bool(_this_\Text\MultiLine = 1)*_this_\Items()\index ; wordwrap
      _this_\Items()\Text\Len = Len(_this_\Items()\Text\String.s)
      _this_\Text\Pos + _this_\Items()\Text\Len + 1 ; Len(#LF$)
    EndMacro
    
    
    With *This
      \CountItems = ListSize(\Items())
      
      If \Text\Vertical
        Width = \Height[1]-\Text\X*2 
        Height = \Width[1]-\Text\y*2
      Else
        CompilerIf Not Defined(Bar, #PB_Module)
          \scroll\width[2] = \width[2]-\margin\width
          \scroll\height[2] = \height[2]
        CompilerEndIf
      EndIf
      
      width = \scroll\width[2]
      height = \scroll\height[2]
      
      \Items()\Index[1] =- 1
      ;\Items()\Focus =- 1
      \Items()\Index = Line
      \Items()\Radius = \Radius
      \Items()\Text\String.s = String.s
      
      ; Set line default color state           
      \Items()\State = 1
      
      ; Update line pos in the text
      _set_line_pos_(*This)
      
      _set_content_X_(*This)
      _line_resize_X_(*This)
      _line_resize_Y_(*This)
      
      ;       ; Is visible lines
      ;       \Items()\Hide = Bool(Not Bool(\Items()\y>=\y[2] And (\Items()\y-\y[2])+\Items()\height=<\height[2]))
      
      ; Scroll width length
      _set_scroll_width_(*This)
      
      ; Scroll hight length
      _set_scroll_height_(*This)
      
      If \Index[2] = ListIndex(\Items())
        ;Debug " string "+String.s
        \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret) : \Items()\Text[1]\Change = #True
        \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len-(\Text\Caret + \Items()\Text[2]\Len)) : \Items()\Text[3]\Change = #True
      EndIf
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i Editor_MultiLine(*This.Widget_S)
    Protected Repaint, String.s, text_width, Len.i
    Protected IT,Text_Y,Text_X,Width,Height, Image_Y, Image_X, Indent=4
    
    With *This
      If \Text\Vertical
        Width = \Height[2]-\Text\X*2
        Height = \Width[2]-\Text\y*2
      Else
        width = \scroll\width[2]-\Text\X*2-\margin\width
        height = \scroll\height[2]
      EndIf
      
      ; Debug ""+\scroll\width[2] +" "+ \Width[0] +" "+ \Width[1] +" "+ \Width[2] +" "+ Width
      ;Debug ""+\scroll\width[2] +" "+ \scroll\height[2] +" "+ \Width[2] +" "+ \Height[2] +" "+ Width +" "+ Height
      
      If \Text\MultiLine > 0
        String.s = Text_Wrap(*This, \Text\String.s[1], Width, \Text\MultiLine)
      Else
        String.s = \Text\String.s[1]
      EndIf
      
      \Text\Pos = 0
      
      If \Text\String.s[2] <> String.s Or \Text\Vertical
        \Text\String.s[2] = String.s
        \CountItems = CountString(String.s, #LF$)
        
        ; Scroll width reset 
        \Scroll\Width = 0
        _set_content_Y_(*This)
        
        ; 
        If ListSize(\Items()) 
          Protected Left = Editor_Move(*This, Width)
        EndIf
        
        If \CountItems[1] <> \CountItems Or \Text\Vertical
          \CountItems[1] = \CountItems
          
          ; Scroll hight reset 
          \Scroll\Height = 0
          ClearList(\Items())
          
          If \Text\Vertical
            For IT = \CountItems To 1 Step - 1
              If AddElement(\Items())
                \Items() = AllocateStructure(Items_S)
                String = StringField(\Text\String.s[2], IT, #LF$)
                
                ;\Items()\Focus =- 1
                \Items()\Index[1] =- 1
                
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
                
                \Items()\x = \X[2]+\Text\Y+\Scroll\Height+Text_Y
                \Items()\y = \Y[2]+\Text\X+Text_X
                \Items()\Width = \Text\Height
                \Items()\Height = Width
                \Items()\Index = ListIndex(\Items())
                
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
                
                _set_scroll_height_(*This)
              EndIf
            Next
          Else
            Protected time = ElapsedMilliseconds()
            
            ; 239
            If CreateRegularExpression(0, ~".*\n?")
              If ExamineRegularExpression(0, \Text\String.s[2])
                While NextRegularExpressionMatch(0) 
                  If AddElement(\Items())
                    \Items() = AllocateStructure(Items_S)
                    
                    \Items()\Text\String.s = Trim(RegularExpressionMatchString(0), #LF$)
                    \Items()\Text\Width = TextWidth(\Items()\Text\String.s) ; Нужен для скролл бара
                    
                    ;\Items()\Focus =- 1
                    \Items()\Index[1] =- 1
                    \Items()\State = 1 ; Set line default colors
                    \Items()\Radius = \Radius
                    \Items()\Index = ListIndex(\Items())
                    
                    ; Update line pos in the text
                    _set_line_pos_(*This)
                    
                    _set_content_X_(*This)
                    _line_resize_X_(*This)
                    _line_resize_Y_(*This)
                    
                    ; Scroll width length
                    _set_scroll_width_(*This)
                    
                    ; Scroll hight length
                    _set_scroll_height_(*This)
                  EndIf
                Wend
              EndIf
              
              FreeRegularExpression(0)
            Else
              Debug RegularExpressionError()
            EndIf
            
            
            
            
            ;             ;; 294 ; 124
            ;             Protected *Sta.Character = @\Text\String.s[2], *End.Character = @\Text\String.s[2] : #SOC = SizeOf (Character)
            ;While *End\c 
            ;               If *End\c = #LF And AddElement(\Items())
            ;                 Len = (*End-*Sta)>>#PB_Compiler_Unicode
            ;                 
            ;                 \Items()\Text\String.s = PeekS (*Sta, Len) ;Trim(, #LF$)
            ;                 
            ; ;                 If \Type = #PB_GadgetType_Button
            ; ;                   \Items()\Text\Width = TextWidth(RTrim(\Items()\Text\String.s))
            ; ;                 Else
            ; ;                   \Items()\Text\Width = TextWidth(\Items()\Text\String.s)
            ; ;                 EndIf
            ;                 
            ;                 \Items()\Focus =- 1
            ;                 \Items()\Index[1] =- 1
            ;                 \Items()\Color\State = 1 ; Set line default colors
            ;                 \Items()\Radius = \Radius
            ;                 \Items()\Index = ListIndex(\Items())
            ;                 
            ;                 ; Update line pos in the text
            ;                 ; _set_line_pos_(*This)
            ;                 \Items()\Text\Pos = \Text\Pos - Bool(\Text\MultiLine = 1)*\Items()\index ; wordwrap
            ;                 \Items()\Text\Len = Len                                                  ; (\Items()\Text\String.s)
            ;                 \Text\Pos + \Items()\Text\Len + 1                                        ; Len(#LF$)
            ;                 
            ;                 ; Debug "f - "+String.s +" "+ CountString(String, #CR$) +" "+ CountString(String, #LF$) +" - "+ \Items()\Text\Pos +" "+ \Items()\Text\Len
            ;                 
            ;                 _set_content_X_(*This)
            ;                 _line_resize_X_(*This)
            ;                 _line_resize_Y_(*This)
            ;                 
            ;                 ; Scroll width length
            ;                 _set_scroll_width_(*This)
            ;                 
            ;                 ; Scroll hight length
            ;                 _set_scroll_height_(*This)
            ;                 
            ;                 *Sta = *End + #SOC 
            ;               EndIf 
            ;               
            ;               *End + #SOC 
            ;             Wend
            ;;;;  FreeMemory(*End)
            
            ;  MessageRequester("", Str(ElapsedMilliseconds()-time) + " text parse time ")
            Debug Str(ElapsedMilliseconds()-time) + " text parse time "
          EndIf
        Else
          Protected time2 = ElapsedMilliseconds()
          
          If CreateRegularExpression(0, ~".*\n?")
            If ExamineRegularExpression(0, \Text\String.s[2])
              While NextRegularExpressionMatch(0) : IT+1
                String.s = Trim(RegularExpressionMatchString(0), #LF$)
                
                If SelectElement(\Items(), IT-1)
                  If \Items()\Text\String.s <> String.s
                    \Items()\Text\String.s = String.s
                    
                    If \Type = #PB_GadgetType_Button
                      \Items()\Text\Width = TextWidth(RTrim(String.s))
                    Else
                      \Items()\Text\Width = TextWidth(String.s)
                    EndIf
                  EndIf
                  
                  ; Update line pos in the text
                  _set_line_pos_(*This)
                  
                  ; Resize item
                  If (Left And Not  Bool(\Scroll\X = Left))
                    _set_content_X_(*This)
                  EndIf
                  
                  _line_resize_X_(*This)
                  
                  ; Set scroll width length
                  _set_scroll_width_(*This)
                EndIf
                
              Wend
            EndIf
            
            FreeRegularExpression(0)
          Else
            Debug RegularExpressionError()
          EndIf
          
          Debug Str(ElapsedMilliseconds()-time2) + " text parse time2 "
          
        EndIf
      Else
        ; Scroll hight reset 
        \Scroll\Height = 0
        _set_content_Y_(*This)
        
        ForEach \Items()
          If Not \Items()\Hide
            _set_content_X_(*This)
            _line_resize_X_(*This)
            _line_resize_Y_(*This)
            
            ; Scroll hight length
            _set_scroll_height_(*This)
          EndIf
        Next
      EndIf
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  ;- - DRAWINGs
  Procedure.i Draw_Editor(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    Protected angle.f, widget_state
    
    If Not *This\Hide
      
      With *This
        widget_state = \color\state
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        
        ; Then changed text
        If \Text\Change
;           If set_text_width
;             SetTextWidth(set_text_width, Len(set_text_width))
;             set_text_width = ""
;           EndIf
          
          \Text\Height[1] = TextHeight("A") + Bool(\CountItems<>1 And \Flag\GridLines)
          If \Type = #PB_GadgetType_Tree
            \Text\Height = 20
          Else
            \Text\Height = \Text\Height[1]
          EndIf
          \Text\Width = TextWidth(\Text\String.s[1])
          
          If \margin\width 
            \CountItems = CountString(\Text\String.s[1], #LF$)
            \margin\width = TextWidth(Str(\CountItems))+11
            ;  Bar::Resizes(\Scroll, \x[2]+\margin\width+1,\Y[2],\Width[2]-\margin\width-1,\Height[2])
          EndIf
        EndIf
        
        ; Then resized widget
        If \Resize
            \scroll\width[2] = \width[2]
            \scroll\height[2] = \height[2]
        EndIf
        
        ; Widget inner coordinate
        iX=\X[2]
        iY=\Y[2]
        iwidth = \width[2]
        iheight = \height[2]
        
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          Editor_MultiLine(*This)
        EndIf 
        
        
        ;
        If \Text\Editable And ListSize(\Items())
          If \Text\Change =- 1
            \Text[1]\Change = 1
            \Text[3]\Change = 1
            \Text\Len = Len(\Text\String.s[1])
            Editor_Change(*This, \Text\Caret, 0)
          EndIf
          
          ; Caaret pos & len
          If \Items()\Text[1]\Change : \Items()\Text[1]\Change = #False
            \Items()\Text[1]\Width = TextWidth(\Items()\Text[1]\String.s)
            
            ; Положение карета
            If \Text\Caret[1] = \Text\Caret
              \Text\Caret[2] = \Items()\Text[1]\Width
            EndIf
            
            ; Если перешли за границы итемов
            If \index[1] =- 1
              \Text\Caret[2] = 0
            ElseIf \index[1] = ListSize(\Items())
              \Text\Caret[2] = \Items()\Text\Width
            ElseIf \Items()\Text\Len = \Items()\Text[2]\Len
              \Text\Caret[2] = \Items()\Text\Width
            EndIf
            
          EndIf
          
          If \Items()\Text[2]\Change : \Items()\Text[2]\Change = #False 
            \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text[1]\Width
            \Items()\Text[2]\Width = TextWidth(\Items()\Text[2]\String.s) ; + Bool(\Items()\Text[2]\Len =- 1) * \Flag\FullSelection ; TextWidth() - bug in mac os
            
            \Items()\Text[3]\X = \Items()\Text[2]\X+\Items()\Text[2]\Width
          EndIf 
          
          If \Items()\Text[3]\Change : \Items()\Text[3]\Change = #False 
            \Items()\Text[3]\Width = TextWidth(\Items()\Text[3]\String.s)
          EndIf 
          
          If (\Focus And \Mouse\Buttons And (Not \Scroll\v\at And Not \Scroll\h\at)) 
            Protected Left = Editor_Move(*This, \Items()\Width)
          EndIf
        EndIf
        
        ; Draw back color
        If \Color\Fore[widget_state]
          DrawingMode(#PB_2DDrawing_Gradient)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore[widget_state],\Color\Back[widget_state],\Radius)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Back[widget_state])
        EndIf
        
        ; Draw margin back color
        If \margin\width
          DrawingMode(#PB_2DDrawing_Default)
          Box(ix, iy, \margin\width, \Height[2], \margin\Color\Back); $C8D7D7D7)
        EndIf
      
      ; Draw Lines text
        If ListSize(\Items())
          PushListPosition(\Items())
          ForEach \Items()
            Protected Item_state = \Items()\state
            
            ; Is visible lines ---
            \Items()\Drawing = Bool(Not \Items()\hide And (\Items()\y+\Items()\height+*This\Scroll\Y>*This\y[2] And (\Items()\y-*This\y[2])+*This\Scroll\Y<iheight))
            
            If \Items()\Drawing
              If \Items()\Text\FontID 
                DrawingFont(\Items()\Text\FontID) 
                ;               ElseIf *This\Text\FontID 
                ;                 DrawingFont(*This\Text\FontID) 
              EndIf
              
              If \Items()\Text\Change : \Items()\Text\Change = #False
                \Items()\Text\Width = TextWidth(\Items()\Text\String.s) 
                
                If \Items()\Text\FontID 
                  \Items()\Text\Height = TextHeight("A") 
                Else
                  \Items()\Text\Height = *This\Text\Height[1]
                EndIf
              EndIf 
              
              If \Items()\Text[1]\Change : \Items()\Text[1]\Change = #False
                \Items()\Text[1]\Width = TextWidth(\Items()\Text[1]\String.s) 
              EndIf 
              
              If \Items()\Text[3]\Change : \Items()\Text[3]\Change = #False 
                \Items()\Text[3]\Width = TextWidth(\Items()\Text[3]\String.s)
              EndIf 
              
              If \Items()\Text[2]\Change : \Items()\Text[2]\Change = #False 
                \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text[1]\Width
                ; Debug "get caret "+\Items()\Text[3]\Len
                \Items()\Text[2]\Width = TextWidth(\Items()\Text[2]\String.s) + Bool(\Items()\Text\Len = \Items()\Text[2]\Len Or \Items()\Text[2]\Len =- 1 Or \Items()\Text[3]\Len = 0) * *This\Flag\FullSelection ; TextWidth() - bug in mac os
                \Items()\Text[3]\X = \Items()\Text[2]\X+\Items()\Text[2]\Width
              EndIf 
            EndIf
            
            
            Height = \Items()\Height
            Y = \Items()\Y+*This\Scroll\Y
            Text_X = \Items()\Text\X+*This\Scroll\X
            Text_Y = \Items()\Text\Y+*This\Scroll\Y
            ; Debug Text_X
            
            ; Draw selections
            If \Items()\Drawing And (\Items()\Index=*This\Index[1] Or \Items()\Index=\Items()\Index[1]) ; Or \Index=\focus Item_state;
              If *This\Color\Back[Item_state]<>-1                                 ; no draw transparent
                If *This\Color\Fore[Item_state]
                  DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                  BoxGradient(\Items()\Vertical,*This\X[2],Y,iwidth,\Items()\Height,*This\Color\Fore[Item_state]&$FFFFFFFF|*This\color\alpha<<24, *This\Color\back[Item_state]&$FFFFFFFF|*This\color\alpha<<24) ;*This\Color\Fore[Item_state]&$FFFFFFFF|*This\color\alpha<<24 ,RowBackColor(*This, Item_state) ,\Radius)
                Else
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(*This\X[2],Y,iwidth,\Items()\Height,\Items()\Radius,\Items()\Radius,*This\Color\back[Item_state]&$FFFFFFFF|*This\color\alpha<<24 )
                EndIf
              EndIf
              
              If *This\Color\Frame[Item_state]<>-1 ; no draw transparent
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(*This\x[2],Y,iwidth,\Items()\height,\Items()\Radius,\Items()\Radius, *This\Color\Frame[Item_state]&$FFFFFFFF|*This\color\alpha<<24 )
              EndIf
            EndIf
            
            If \Items()\Drawing
              ; Draw text
              Angle = Bool(\Text\Vertical)**This\Text\Rotate
              Protected Front_BackColor_1 = *This\Color\Front[widget_state]&$FFFFFFFF|*This\color\alpha<<24
              Protected Front_BackColor_2 = *This\Color\Front[2]&$FFFFFFFF|*This\color\alpha<<24
              
              ; Draw string
              If \Items()\Text[2]\Len And *This\Color\Front <> *This\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Text\Caret[1] > *This\Text\Caret And *This\Index[2] = *This\Index[1]) Or
                     (\Items()\Index = *This\Index[1] And *This\Index[2] > *This\Index[1])
                    \Items()\Text[3]\X = \Items()\Text\X+TextWidth(Left(\Items()\Text\String.s, *This\Text\Caret[1])) 
                    
                    If *This\Index[2] = *This\Index[1]
                      \Items()\Text[2]\X = \Items()\Text[3]\X-\Items()\Text[2]\Width
                    EndIf
                    
                    If \Items()\Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Items()\Text[3]\X+*This\Scroll\X, Text_Y, \Items()\Text[3]\String.s, angle, Front_BackColor_1)
                    EndIf
                    
                    If *This\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Items()\Vertical,\Items()\Text[2]\X+*This\Scroll\X, Y, \Items()\Text[2]\Width+\Items()\Text[2]\Width[2], Height,*This\Color\Fore[2]&$FFFFFFFF|*This\color\alpha<<24,*This\Color\back[2]&$FFFFFFFF|*This\color\alpha<<24,\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Items()\Text[2]\X+*This\Scroll\X, Y, \Items()\Text[2]\Width+\Items()\Text[2]\Width[2], Height, *This\Color\back[2]&$FFFFFFFF|*This\color\alpha<<24 )
                    EndIf
                    
                    If \Items()\Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \Items()\Text[1]\String.s+\Items()\Text[2]\String.s, angle, Front_BackColor_2)
                    EndIf
                    
                    If \Items()\Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \Items()\Text[1]\String.s, angle, Front_BackColor_1)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawRotatedText(Text_X, Text_Y, \Items()\Text\String.s, angle, Front_BackColor_1)
                    
                    If *This\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Items()\Vertical,\Items()\Text[2]\X+*This\Scroll\X, Y, \Items()\Text[2]\Width+\Items()\Text[2]\Width[2], Height,*This\Color\Fore[2]&$FFFFFFFF|*This\color\alpha<<24,*This\Color\back[2]&$FFFFFFFF|*This\color\alpha<<24,\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Items()\Text[2]\X+*This\Scroll\X, Y, \Items()\Text[2]\Width+\Items()\Text[2]\Width[2], Height, *This\Color\back[2]&$FFFFFFFF|*This\color\alpha<<24)
                    EndIf
                    
                    If \Items()\Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(\Items()\Text[2]\X+*This\Scroll\X, Text_Y, \Items()\Text[2]\String.s, angle, Front_BackColor_2)
                    EndIf
                  EndIf
                CompilerElse
                  If \Items()\Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Items()\Text[1]\String.s, angle, Front_BackColor_1)
                  EndIf
                  
                  If *This\Color\Fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(\Items()\Vertical,\Items()\Text[2]\X+*This\Scroll\X, Y, \Items()\Text[2]\Width+\Items()\Text[2]\Width[2], Height,*This\Color\Fore[2]&$FFFFFFFF|*This\color\alpha<<24,*This\Color\back[2]&$FFFFFFFF|*This\color\alpha<<24,\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\Items()\Text[2]\X+*This\Scroll\X, Y, \Items()\Text[2]\Width+\Items()\Text[2]\Width[2], Height, *This\Color\back[2]&$FFFFFFFF|*This\color\alpha<<24)
                  EndIf
                  
                  If \Items()\Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Items()\Text[2]\X+*This\Scroll\X, Text_Y, \Items()\Text[2]\String.s, angle, Front_BackColor_2)
                  EndIf
                  
                  If \Items()\Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Items()\Text[3]\X+*This\Scroll\X, Text_Y, \Items()\Text[3]\String.s, angle, Front_BackColor_1)
                  EndIf
                CompilerEndIf
                
              Else
                If \Items()\Text[2]\Len
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\Items()\Text[2]\X+*This\Scroll\X, Y, \Items()\Text[2]\Width+\Items()\Text[2]\Width[2], Height, *This\Color\back[2]&$FFFFFFFF|*This\color\alpha<<24)
                EndIf
                
                If Item_state = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Items()\Text[0]\String.s, angle, Front_BackColor_2)
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Items()\Text[0]\String.s, angle, Front_BackColor_1)
                EndIf
              EndIf
              
              
              ; Draw margin
              If *This\margin\width
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(ix+*This\margin\width-TextWidth(Str(\Items()\Index))-3, \Items()\Y+*This\Scroll\Y, Str(\Items()\Index), *This\margin\Color\Front);, *This\margin\Color\Back)
              EndIf
            EndIf
            
;             ; text x
;             Box(\Items()\text\x, *This\y, 2, *This\height, $FFFF0000)
;         
          Next
          PopListPosition(\Items()) ; 
        EndIf
        
        ; Draw caret
        If ListSize(\Items()) And (\Text\Editable Or \Items()\Text\Editable) And \Focus : DrawingMode(#PB_2DDrawing_XOr)             
          Line((\Items()\Text\X+\Scroll\X) + \Text\Caret[2] - Bool(#PB_Compiler_OS = #PB_OS_Windows) - Bool(Left < \Scroll\X), \Items()\Y+\Scroll\Y, 1, Height, $FFFFFFFF)
        EndIf
        
        ; Draw scroll bars
        CompilerIf Defined(Bar, #PB_Module)
          ;           If \Scroll\v And \Scroll\v\Max <> \Scroll\Height And 
          ;              Bar::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines))
          ;             Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          ;           If \Scroll\h And \Scroll\h\Max<>\Scroll\Width And 
          ;              Bar::SetAttribute(\Scroll\h, #PB_ScrollBar_Maximum, \Scroll\Width)
          ;             Bar::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ;           EndIf
          
          Bar::Draw(\Scroll\v)
          Bar::Draw(\Scroll\h)
         ; (_this_\margin\width + (_this_\sublevellen -Bool(_this_\Scroll\h\Radius)*4) + _this_\items()\text\x+_this_\items()\text\width)-_this_\x
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*This\Scroll\h\x-Bar::GetState(*This\Scroll\h), *This\Scroll\v\y-Bar::GetState(*This\Scroll\v), *This\Scroll\h\Max, *This\Scroll\v\Max, $FF0000)
          Box(*This\Scroll\h\x, *This\Scroll\v\y, *This\Scroll\h\Page\Len, *This\Scroll\v\Page\Len, $FF00FF00)
          Box(*This\Scroll\h\x, *This\Scroll\v\y, *This\Scroll\h\Area\Len, *This\Scroll\v\Area\Len, $FF00FFFF)
        CompilerEndIf
      EndWith
      
      ; Draw frames
      With *This
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  ;-
  ;- - KEYBOARDs
  Procedure.i Editor_ToUp(*This.Widget_S)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Index[2] > 0 And \Index[1] = \Index[2]) : \Index[2] - 1 : \Index[1] = \Index[2]
        SelectElement(\Items(), \Index[2])
        ;If (\Items()\y+\Scroll\Y =< \Y[2])
        Bar::SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
        ;EndIf
        ; При вводе перемещаем текста
        If \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
          Bar::SetState(\Scroll\h, (\Items()\text\x+\Items()\text\width))
        Else
          Bar::SetState(\Scroll\h, 0)
        EndIf
        ;Editor_Change(*This, \Text\Caret, 0)
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToDown(*This.Widget_S)
    Static Line
    Protected Repaint, Shift.i = Bool(*This\Keyboard\Key[1] & #PB_Canvas_Shift)
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If Shift
        
        If \Index[1] = \Index[2]
          SelectElement(\Items(), \Index[1]) 
          Editor_Change(*This, \Text\Caret[1], \Items()\Text\Len-\Text\Caret[1])
        Else
          SelectElement(\Items(), \Index[2]) 
          Editor_Change(*This, 0, \Items()\Text\Len)
        EndIf
        ; Debug \Text\Caret[1]
        \Index[2] + 1
        ;         \Text\Caret = Editor_Caret(*This, \Index[2]) 
        ;         \Text\Caret[1] = \Text\Caret
        SelectElement(\Items(), \Index[2]) 
        Editor_Change(*This, 0, \Text\Caret[1]) 
        Editor_SelText(*This)
        Repaint = 1 
        
      Else
        If (\Index[1] < ListSize(\Items()) - 1 And \Index[1] = \Index[2]) : \Index[2] + 1 : \Index[1] = \Index[2]
          SelectElement(\Items(), \Index[2]) 
          ;If (\Items()\y >= (\scroll\height[2]-\Items()\height))
          Bar::SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
          ;EndIf
          
          If \Items()\text\x+\Items()\text\width > \Items()\X+\Items()\width
            Bar::SetState(\Scroll\h, (\Items()\text\x+\Items()\text\width))
          Else
            Bar::SetState(\Scroll\h, 0)
          EndIf
          
          ;Editor_Change(*This, \Text\Caret, 0)
          Repaint =- 1 
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToLeft(*This.Widget_S) ; Ok
    Protected Repaint.i, Shift.i = Bool(*This\Keyboard\Key[1] & #PB_Canvas_Shift)
    
    With *This
      If \Items()\Text[2]\Len And Not Shift
        If \Index[2] > \Index[1] 
          Swap \Index[2], \Index[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Index[1] > \Index[2] And 
               \Text\Caret[1] > \Text\Caret
          Swap \Text\Caret[1], \Text\Caret
        ElseIf \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          Editor_SelReset(*This)
          \Index[1] = \Index[2]
        Else
          \Text\Caret[1] = \Text\Caret 
        EndIf 
        Repaint =- 1
        
      ElseIf \Text\Caret > 0
        If \Text\Caret > \Items()\text\len - CountString(\Items()\Text\String.s, #CR$) ; Без нее удаляеть последнюю строку 
          \Text\Caret = \Items()\text\len - CountString(\Items()\Text\String.s, #CR$)  ; Без нее удаляеть последнюю строку 
        EndIf
        \Text\Caret - 1 
        
        If Not Shift
          \Text\Caret[1] = \Text\Caret 
        EndIf
        
        Repaint =- 1 
        
      ElseIf Editor_ToUp(*This.Widget_S)
        \Text\Caret = \Items()\Text\Len
        \Text\Caret[1] = \Text\Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToRight(*This.Widget_S) ; Ok
    Protected Repaint.i, Shift.i = Bool(*This\Keyboard\Key[1] & #PB_Canvas_Shift)
    
    With *This
      ;       If \Index[1] <> \Index[2]
      ;         If Shift 
      ;           \Text\Caret + 1
      ;           Swap \Index[2], \Index[1] 
      ;         Else
      ;           If \Index[1] > \Index[2] 
      ;             Swap \Index[1], \Index[2] 
      ;             Swap \Text\Caret, \Text\Caret[1]
      ;             
      ;             If SelectElement(\Items(), \Index[2]) 
      ;               \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
      ;               \Items()\Text[1]\Change = #True
      ;             EndIf
      ;             
      ;             Editor_SelReset(*This)
      ;             \Text\Caret = \Text\Caret[1] 
      ;             \Index[1] = \Index[2]
      ;           EndIf
      ;           
      ;         EndIf
      ;         Repaint =- 1
      ;         
      ;       ElseIf \Items()\Text[2]\Len
      ;         If \Text\Caret[1] > \Text\Caret 
      ;           Swap \Text\Caret[1], \Text\Caret 
      ;         EndIf
      ;         
      ;         If Not Shift
      ;           \Text\Caret[1] = \Text\Caret 
      ;         Else
      ;           \Text\Caret + 1
      ;         EndIf
      ;         
      ;         Repaint =- 1
      If \Items()\Text[2]\Len And Not Shift
        If \Index[1] > \Index[2] 
          Swap \Index[1], \Index[2] 
          Swap \Text\Caret, \Text\Caret[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
          
          ;           Editor_SelReset(*This)
          ;           \Text\Caret = \Text\Caret[1] 
          ;           \Index[1] = \Index[2]
        EndIf
        
        If \Index[1] <> \Index[2]
          Editor_SelReset(*This)
          \Index[1] = \Index[2]
        Else
          \Text\Caret = \Text\Caret[1] 
        EndIf 
        Repaint =- 1
        
        
      ElseIf \Text\Caret < \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$) ; Без нее удаляеть последнюю строку
        \Text\Caret + 1
        
        If Not Shift
          \Text\Caret[1] = \Text\Caret 
        EndIf
        
        Repaint =- 1 
      ElseIf Editor_ToDown(*This)
        \Text\Caret = 0
        \Text\Caret[1] = \Text\Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToInput(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Keyboard\Input
        Repaint = Editor_Insert(*This, Chr(\Keyboard\Input))
        
        If Not Repaint
          \Default = *This
        EndIf
        
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToReturn(*This.Widget_S) ; Ok
    
    With  *This
      If Not Editor_Paste(*This, #LF$)
        \Index[2] + 1
        \Text\Caret = 0
        \Index[1] = \Index[2]
        \Text\Caret[1] = \Text\Caret
        \Text\Change =- 1 ; - 1 post event change widget
      EndIf
    EndWith
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure.i Editor_ToBack(*This.Widget_S)
    Protected Repaint, String.s, Cut.i
    
    If *This\Keyboard\Input : *This\Keyboard\Input = 0
      Editor_ToInput(*This) ; Сбросить Dot&Minus
    EndIf
    *This\Keyboard\Input = 65535
    
    With *This 
      If Not Editor_Cut(*This)
        If \Items()\Text[2]\Len
          
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s[1] = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] > 0 : \Text\Caret - 1 
          \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret)
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s) : \Items()\Text[1]\Change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s[1] = Left(\Text\String.s[1], \Items()\Text\Pos+\Text\Caret) + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
        Else
          ; Если дошли до начала строки то 
          ; переходим в конец предыдущего итема
          If \Index[2] > 0 
            \Text\String.s[1] = RemoveString(\Text\String.s[1], #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            
            Editor_ToUp(*This)
            
            \Text\Caret = \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$)
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
          
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToDelete(*This.Widget_S)
    Protected Repaint, String.s
    
    With *This 
      If Not Editor_Cut(*This)
        If \Items()\Text[2]\Len
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text\String.s[1] = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] < \Items()\Text\Len - CountString(\Items()\Text\String.s, #CR$)
          \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len - \Text\Caret - 1)
          \Items()\Text[3]\Len = Len(\Items()\Text[3]\String.s) : \Items()\Text[3]\Change = 1
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len : \Items()\Text\Change = 1
          
          \Text[3]\String = Right(\Text\String.s,  \Text\Len - (\Items()\Text\Pos + \Text\Caret) - 1)
          \Text[3]\len = Len(\Text[3]\String.s)
          
          \Text\String.s[1] = \Text[1]\String + \Text[3]\String
          \Text\Change =- 1 ; - 1 post event change widget
        Else
          If \Index[2] < (\CountItems-1) ; ListSize(\Items()) - 1
            \Text\String.s[1] = RemoveString(\Text\String.s[1], #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_ToPos(*This.Widget_S, Pos.i, Len.i)
    Protected Repaint
    
    With *This
      Editor_SelReset(*This)
      
      If Len
        Select Pos
          Case 1 : FirstElement(\items()) : \Text\Caret = 0
          Case - 1 : LastElement(\items()) : \Text\Caret = \items()\Text\Len
        EndSelect
        
        \index[1] = \items()\index
        Bar::SetState(\Scroll\v, (\Items()\y-((\scroll\height[2]+\Text\y)-\Items()\height)))
      Else
        SelectElement(\items(), \index[1]) 
        \Text\Caret = Bool(Pos =- 1) * \items()\Text\Len 
        Bar::SetState(\Scroll\h, Bool(Pos =- 1) * \Scroll\h\Max)
      EndIf
      
      \Text\Caret[1] = \Text\Caret
      \index[2] = \index[1] 
      Repaint =- 1 
      
    EndWith
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Editable(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s, Shift.i
    
    With *This
      Shift = Bool(*This\Keyboard\Key[1] & #PB_Canvas_Shift)
      
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
        Control = Bool((\Keyboard\Key[1] & #PB_Canvas_Control) Or (\Keyboard\Key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
      CompilerElse
        Control = Bool(*This\Keyboard\Key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
      CompilerEndIf
      
      Select EventType
        Case #PB_EventType_Input ; - Input (key)
          If Not Control         ; And Not Shift
            Repaint = Editor_ToInput(*This)
          EndIf
          
        Case #PB_EventType_KeyUp ; Баг в мак ос не происходить событие если зажать cmd
                                 ;  Debug "#PB_EventType_KeyUp "
                                 ;           If \items()\Text\Numeric
                                 ;             \items()\Text\String.s[3]=\items()\Text\String.s 
                                 ;           EndIf
                                 ;           Repaint = #True 
          
        Case #PB_EventType_KeyDown
          Select \Keyboard\Key
            Case #PB_Shortcut_Home : Repaint = Editor_ToPos(*This, 1, Control)
            Case #PB_Shortcut_End : Repaint = Editor_ToPos(*This, - 1, Control)
            Case #PB_Shortcut_PageUp : Repaint = Editor_ToPos(*This, 1, 1)
            Case #PB_Shortcut_PageDown : Repaint = Editor_ToPos(*This, - 1, 1)
              
            Case #PB_Shortcut_A
              If Control And (\Text[2]\Len <> \Text\Len Or Not \Text[2]\Len)
                ForEach \items()
                  \Items()\Text[2]\Len = \Items()\Text\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                  \Items()\Text[2]\String = \Items()\Text\String : \Items()\Text[2]\Change = 1
                  \Items()\Text[1]\String = "" : \Items()\Text[1]\Change = 1 : \Items()\Text[1]\Len = 0
                  \Items()\Text[3]\String = "" : \Items()\Text[3]\Change = 1 : \Items()\Text[3]\Len = 0
                Next
                
                \Text[1]\Len = 0 : \Text[1]\String = ""
                \Text[3]\Len = 0 : \Text[3]\String = #LF$
                \index[2] = 0 : \index[1] = ListSize(\Items()) - 1
                \Text\Caret = \Items()\Text\Len : \Text\Caret[1] = \Text\Caret
                \Text[2]\String = \Text\String : \Text[2]\Len = \Text\Len
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Up     : Repaint = Editor_ToUp(*This)      ; Ok
            Case #PB_Shortcut_Left   : Repaint = Editor_ToLeft(*This)    ; Ok
            Case #PB_Shortcut_Right  : Repaint = Editor_ToRight(*This)   ; Ok
            Case #PB_Shortcut_Down   : Repaint = Editor_ToDown(*This)    ; Ok
            Case #PB_Shortcut_Back   : Repaint = Editor_ToBack(*This)
            Case #PB_Shortcut_Return : Repaint = Editor_ToReturn(*This) 
            Case #PB_Shortcut_Delete : Repaint = Editor_ToDelete(*This)
              
            Case #PB_Shortcut_C, #PB_Shortcut_X
              If Control
                SetClipboardText(\Text[2]\String)
                
                If \Keyboard\Key = #PB_Shortcut_X
                  Repaint = Editor_Cut(*This)
                EndIf
              EndIf
              
            Case #PB_Shortcut_V
              If \Text\Editable And Control
                Repaint = Editor_Insert(*This, GetClipboardText())
              EndIf
              
          EndSelect 
          
      EndSelect
      
      If Repaint =- 1
        If \Text\Caret<\Text\Caret[1]
          ; Debug \Text\Caret[1]-\Text\Caret
          Editor_Change(*This, \Text\Caret, \Text\Caret[1]-\Text\Caret)
        Else
          ; Debug \Text\Caret-\Text\Caret[1]
          Editor_Change(*This, \Text\Caret[1], \Text\Caret-\Text\Caret[1])
        EndIf
      EndIf                                                  
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_SelSet(*This.Widget_S, Line.i)
    Macro isItem(_item_, _list_)
    Bool(_item_ >= 0 And _item_ < ListSize(_list_))
  EndMacro
  
  Macro itemSelect(_item_, _list_)
    Bool(isItem(_item_, _list_) And _item_ <> ListIndex(_list_) And SelectElement(_list_, _item_))
  EndMacro
  
  Protected Repaint.i
    
    With *This
      
      If \Index[1] <> Line And Line =< ListSize(\Items())
        If isItem(\Index[1], \Items()) 
          If \Index[1] <> ListIndex(\Items())
            SelectElement(\Items(), \Index[1]) 
          EndIf
          
          If \Index[1] > Line
            \Text\Caret = 0
          Else
            \Text\Caret = \Items()\Text\Len
          EndIf
          
          Repaint | Editor_SelText(*This)
        EndIf
        
        \Index[1] = Line
      EndIf
      
      If isItem(Line, \Items()) 
        \Text\Caret = Editor_Caret(*This, Line) 
        Repaint | Editor_SelText(*This)
      EndIf
      
      ; Выделение конца строки
      PushListPosition(\Items()) 
      ForEach \Items()
        If (\Index[1] = \Items()\Index Or \Index[2] = \Items()\Index)
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                                                             ;           
        ElseIf ((\Index[2] < \Index[1] And \Index[2] < \Items()\Index And \Index[1] > \Items()\Index) Or
                (\Index[2] > \Index[1] And \Index[2] > \Items()\Index And \Index[1] < \Items()\Index)) 
          
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\String = \Items()\Text\String 
          \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
          Repaint = #True
          
        ElseIf \Items()\Text[2]\Len
          \Items()\Text[2]\Change = 1
          \Items()\Text[2]\String =  "" 
          \Items()\Text[2]\Len = 0 
        EndIf
      Next
      PopListPosition(\Items()) 
      
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editor_Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i=-1
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      If *This
        If ListSize(*This\items())
          If Not \Hide ;And Not \Disable And \Interact
            ; Get line position
            If \Mouse\buttons
              If \Mouse\Y < \Y
                Item.i =- 1
              Else
                Item.i = ((\Mouse\Y-\Y-\Scroll\Y) / \Text\Height)
              EndIf
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftDoubleClick 
                \Items()\Text\Caret[1] =- 1 ; Запоминаем что сделали двойной клик
                Editor_SelLimits(*This)      ; Выделяем слово
                Editor_SelText(*This)
                
                ;                 \Items()\Text[2]\Change = 1
                ;                 \Items()\Text[2]\Len - Bool(Not \Items()\Text\Len) ; Выделение пустой строки
                
                Repaint = 1
                
              Case #PB_EventType_LeftButtonDown
                \Focus = *This
                
                itemSelect(Item, \Items())
                Caret = Editor_Caret(*This, Item)
                
                If \Items()\Text\Caret[1] =- 1 : \Items()\Text\Caret[1] = 0
                  *This\Text\Caret[1] = 0
                  *This\Text\Caret = \Items()\Text\Len
                  Editor_SelText(*This)
                  Repaint = 1
                  
                Else
                  Editor_SelReset(*This)
                  
                  If \Items()\Text[2]\Len
                    
                    
                    
                  Else
                    
                    \Text\Caret = Caret
                    \Text\Caret[1] = \Text\Caret
                    \Index[1] = \Items()\Index 
                    \Index[2] = \Index[1]
                    
                    PushListPosition(\Items())
                    ForEach \Items() 
                      If \Index[2] <> ListIndex(\Items())
                        \Items()\Text[1]\String = ""
                        \Items()\Text[2]\String = ""
                        \Items()\Text[3]\String = ""
                      EndIf
                    Next
                    PopListPosition(\Items())
                    
                    If \Text\Caret = DoubleClick
                      DoubleClick =- 1
                      \Text\Caret[1] = \Items()\Text\Len
                      \Text\Caret = 0
                    EndIf 
                    
                    Editor_SelText(*This)
                    Repaint = #True
                  EndIf
                EndIf
                
              Case #PB_EventType_MouseMove  
                If \Mouse\buttons & #PB_Canvas_LeftButton 
                  Repaint = Editor_SelSet(*This, Item)
                EndIf
                
              Default
                itemSelect(\Index[2], \Items())
            EndSelect
          EndIf
          
          ; edit events
          If *This\focus And (*This\Text\Editable Or \Text\Editable)
            Repaint | Editor_Editable(*This, EventType)
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  
  Procedure.i Draw(*This.Widget_S)
    Draw_Editor(*This)
  EndProcedure
  
  Procedure.i ReDraw(*This.Widget_S, Canvas =- 1, BackColor=$FFF0F0F0)
    If *This
      With *This
        If Canvas =- 1 
          Canvas = \Root\Canvas 
        ElseIf Canvas <> \Root\Canvas
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
            If Canvas = \Root\Canvas
              Draw(List()\Widget)
            EndIf
          Next
        EndWith
        
        StopDrawing()
      EndIf
    EndIf
  EndProcedure
  
  
  ;-
  ;- - (SET&GET)s
   Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i)
    
    With *This
      If X<>#PB_Ignore And 
         \X[0] <> X
        \X[0] = X 
        \X[2]=\X[0]+\bs
        \X[1]=\X[2]-\fs
        \Resize | 1<<1
      EndIf
      If Y<>#PB_Ignore And 
         \Y[0] <> Y
        \Y[0] = Y
        \Y[2]=\Y[0]+\bs
        \Y[1]=\Y[2]-\fs
        \Resize | 1<<2
      EndIf
      If Width<>#PB_Ignore And
         \Width[0] <> Width 
        \Width[0] = Width 
        \Width[2] = \Width[0]-\bs*2
        \Width[1] = \Width[2]+\fs*2
        \Resize | 1<<3
      EndIf
      If Height<>#PB_Ignore And 
         \Height[0] <> Height
        \Height[0] = Height 
        \Height[2] = \Height[0]-\bs*2
        \Height[1] = \Height[2]+\fs*2
        \Resize | 1<<4
      EndIf
      
      If \resize
          Bar::Resizes(\Scroll, \x[2],\Y[2],\Width[2],\Height[2])
        EndIf
        
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.i AddItem(*This.Widget_S, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static adress.i, first.i
    Protected *Item, subLevel, hide
    
    If *This
      With *This
        If \Type = #PB_GadgetType_Tree
          subLevel = Flag
        EndIf
        
        ;{ Генерируем идентификатор
        If Item < 0 Or Item > ListSize(\Items()) - 1
          LastElement(\Items())
          *Item = AddElement(\Items()) 
          Item = ListIndex(\Items())
        Else
          SelectElement(\Items(), Item)
          If \Items()\sublevel>sublevel
            sublevel=\Items()\sublevel 
          EndIf
          *Item = InsertElement(\Items())
          
          ; Исправляем идентификатор итема  
          PushListPosition(\Items())
          While NextElement(\Items())
            \Items()\Index = ListIndex(\Items())
          Wend
          PopListPosition(\Items())
        EndIf
        ;}
        
        If *Item
          ;\Items() = AllocateMemory(SizeOf(Items_S) )
          \Items() = AllocateStructure(Items_S)
          
          ;\Items()\handle = adress
          \Items()\change = Bool(\Type = #PB_GadgetType_Tree)
          ;\Items()\Text\FontID = \Text\FontID
          \Items()\Index[1] =- 1
          ;\Items()\focus =- 1
          ;\Items()\lostfocus =- 1
          \Items()\text\change = 1
          
          If IsImage(Image)
            
            Select \Attribute
              Case #PB_Attribute_LargeIcon
                \Items()\Image\width = 32
                \Items()\Image\height = 32
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Case #PB_Attribute_SmallIcon
                \Items()\Image\width = 16
                \Items()\Image\height = 16
                ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
                
              Default
                \Items()\Image\width = ImageWidth(Image)
                \Items()\Image\height = ImageHeight(Image)
            EndSelect   
            
            \Items()\Image\ImageID = ImageID(Image)
            \Items()\Image\ImageID[1] = Image
            
            \Image\width = \Items()\Image\width
          EndIf
          
          ; add lines
          Editor_AddLine(*This, Item.i, Text.s)
          \Text\Change = 1 ; надо посмотрет почему надо его вызивать раньше вед не нужно было
                           ;           \Items()\Color = Colors
                           ;           \Items()\Color\State = 1
                           ;           \Items()\Color\Fore[0] = 0 
                           ;           \Items()\Color\Fore[1] = 0
                           ;           \Items()\Color\Fore[2] = 0
          
          If Item = 0
            If Not \Repaint : \Repaint = 1
              PostEvent(#PB_Event_Gadget, \Root\CanvasWindow, \Root\Canvas, #PB_EventType_Repaint)
            EndIf
          EndIf
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *Item
  EndProcedure
  
  Procedure SetAttribute(*This.Widget_S, Attribute.i, Value.i)
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(*This.Widget_S, Attribute.i)
    Protected Result
    
    With *This
      ;       Select Attribute
      ;         Case #PB_ScrollBar_Minimum    : Result = \Scroll\min
      ;         Case #PB_ScrollBar_Maximum    : Result = \Scroll\max
      ;         Case #PB_ScrollBar_PageLength : Result = \Scroll\pageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*This.Widget_S, Item.i, State.i)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      Result = SelectElement(\Items(), Item) 
      If Result 
        \Items()\Index[1] = \Items()\Index
        \Text\Caret = State
        \Text\Caret[1] = \Text\Caret
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, State.i)
    Protected String.s, *Line
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If String.s
          String.s +#LF$+ \Items()\Text\String.s 
        Else
          String.s + \Items()\Text\String.s
        EndIf
      Next : String.s+#LF$
      PopListPosition(\Items())
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        Redraw(*This, \Root\Canvas)
      EndIf
      
      If State <> #PB_Ignore
        \Focus = *This
        If GetActiveGadget() <> \Root\Canvas
          SetActiveGadget(\Root\Canvas)
        EndIf
        
        PushListPosition(\Items())
        If State =- 1
          \Index[1] = \CountItems - 1
          *Line = LastElement(\Items())
          \Text\Caret = \Items()\Text\Len
        Else
          \Index[1] = CountString(Left(String, State), #LF$)
          *Line = SelectElement(\Items(), \Index[1])
          If *Line
            \Text\Caret = State-\Items()\Text\Pos
          EndIf
        EndIf
        
        ;If *Line
        ;         \Index[2] = \Index[1]
        ;         \Text[1]\Change = 1
        ;         \Text[3]\Change = 1
        ;         Editor_Change(*This, \Text\Caret, 0)
        
        \Items()\Text[1]\String = Left(\Items()\Text\String, \Text\Caret)
        \Items()\Text[1]\Change = 1
        \Text\Caret[1] = \Text\Caret
        
        \Items()\Index[1] = \Items()\Index 
        Bar::SetState(\Scroll\v, (\items()\y-((\scroll\height[2]+\Text\y)-\items()\height))) ;((\Index[1] * \Text\Height)-\Scroll\v\Height) + \Text\Height)
        
        ;         If Not \Repaint : \Repaint = 1
        ;           PostEvent(#PB_Event_Gadget, \Root\CanvasWindow, \Root\Canvas, #PB_EventType_Repaint)
        ;         EndIf
        Redraw(*This)
        ;EndIf
        PopListPosition(\Items())
        
        ; Debug \Index[2]
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(*This.Widget_S)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Index[1] = \Items()\Index
          Result = \Items()\Text\Pos + \Text\Caret
        EndIf
      Next
      PopListPosition(\Items())
      
      ; Debug \text[1]\len
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure ClearItems(*This.Widget_S)
    Text_ClearItems(*This)
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*This.Widget_S)
    ProcedureReturn Text_CountItems(*This)
  EndProcedure
  
  Procedure.i RemoveItem(*This.Widget_S, Item.i)
    Text_RemoveItem(*This, Item)
  EndProcedure
  
  Procedure.s GetText(*This.Widget_S)
    With *This
      If \Text\Pass
        ProcedureReturn \Text\String.s[3]
      Else
        ProcedureReturn \Text\String
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetText(*This.Widget_S, Text.s, Item.i=0)
    Protected Result.i, Len.i, String.s, i.i
    If Text.s="" : Text.s=#LF$ : EndIf
    
    
    With *This
      If *This And \Text And \Text\String.s[1] <> Text.s
        \Text\String.s[1] = Text_Make(*This, Text.s)
        
        If \Text\String.s[1]
          If \Text\MultiLine
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            
            If \Text\MultiLine > 0
              Text.s + #LF$
            EndIf
            
            \Text\String.s[1] = Text.s
            \CountItems = CountString(\Text\String.s[1], #LF$)
          Else
            \Text\String.s[1] = RemoveString(\Text\String.s[1], #LF$) ; + #LF$
                                                                      ; \Text\String.s = RTrim(ReplaceString(\Text\String.s[1], #LF$, " ")) + #LF$
          EndIf
          
          ;\Text\String.s = \Text\String.s[1]
          \Text\Len = Len(\Text\String.s[1])
          \Text\Change = #True
          Result = #True
        EndIf
      EndIf
    
      If Result
        If Not \Repaint : \Repaint = 1
          PostEvent(#PB_Event_Gadget, \Root\CanvasWindow, \Root\Canvas, #PB_EventType_Repaint)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i SetFont(*This.Widget_S, FontID.i)
      Protected Result.i
    
    With *This
      If \Text\FontID <> FontID 
        \Text\FontID = FontID
        \Text\Change = 1
        Result = #True
      EndIf
      
      If Result
        If Not Bool(\CountItems[1] And \CountItems[1] <> \CountItems)
          Redraw(*This, \Root\Canvas)
        EndIf
        ProcedureReturn 1
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    
    With *This
        Select EventType
          Case #PB_EventType_Repaint
            Debug " -- Canvas repaint -- "
          Case #PB_EventType_Input 
            \Keyboard\Input = GetGadgetAttribute(\Root\Canvas, #PB_Canvas_Input)
            \Keyboard\Key[1] = GetGadgetAttribute(\Root\Canvas, #PB_Canvas_Modifiers)
          Case #PB_EventType_KeyDown, #PB_EventType_KeyUp
            \Keyboard\Key = GetGadgetAttribute(\Root\Canvas, #PB_Canvas_Key)
            \Keyboard\Key[1] = GetGadgetAttribute(\Root\Canvas, #PB_Canvas_Modifiers)
          Case #PB_EventType_MouseEnter, #PB_EventType_MouseMove, #PB_EventType_MouseLeave
            \Mouse\X = GetGadgetAttribute(\Root\Canvas, #PB_Canvas_MouseX)
            \Mouse\Y = GetGadgetAttribute(\Root\Canvas, #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, 
               #PB_EventType_MiddleButtonDown, #PB_EventType_MiddleButtonUp, 
               #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Linux
              \Mouse\buttons = (Bool(EventType = #PB_EventType_LeftButtonDown) * #PB_Canvas_LeftButton) |
                                      (Bool(EventType = #PB_EventType_MiddleButtonDown) * #PB_Canvas_MiddleButton) |
                                      (Bool(EventType = #PB_EventType_RightButtonDown) * #PB_Canvas_RightButton) 
            CompilerElse
              \Mouse\buttons = GetGadgetAttribute(\Root\Canvas, #PB_Canvas_Buttons)
            CompilerEndIf
        EndSelect
      EndWith
      
      ProcedureReturn Editor_Events(*This, EventType);, Canvas, CanvasModifiers)
  EndProcedure
   
  Macro SetLastParent(_this_, _type_)
    _this_\Type = _type_
    
    ; Set parent
;     If LastElement(*Value\OpenedList())
;       If _this_\Type = #PB_GadgetType_Option
;         If ListSize(*Value\OpenedList()\Childrens()) 
;           If *Value\OpenedList()\Childrens()\Type = #PB_GadgetType_Option
;             _this_\OptionGroup = *Value\OpenedList()\Childrens()\OptionGroup 
;           Else
;             _this_\OptionGroup = *Value\OpenedList()\Childrens() 
;           EndIf
;         Else
;           _this_\OptionGroup = *Value\OpenedList()
;         EndIf
;       EndIf
;       SetParent(_this_, *Value\OpenedList(), *Value\OpenedList()\o_i)
;     EndIf
  EndMacro
  
  #PB_Vertical = Bar::#PB_Bar_Vertical
  Macro Bar(X,Y,Width,Height, Min, Max, PageLength, Flag=0, Radius=7)
    Bar::Scroll(X,Y,Width,Height, Min, Max, PageLength, Flag, Radius)
  EndMacro
  
  Procedure.i _Editor(X.i, Y.i, Width.i, Height.i, Flag.i=0, Radius.i=0)
    Protected Size=16, *This.Widget_S = AllocateStructure(Widget_S), Text.s = ""
    
    If *This
      With *This
        \Type = #PB_GadgetType_Editor
        \Cursor = #PB_Cursor_IBeam
        ;\DrawingMode = #PB_2DDrawing_Default
        \Radius = Radius
        \color\alpha = 255
        \Interact = 1
        \Text\Caret[1] =- 1
        \Index[1] =- 1
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
        
        \flag\buttons = Bool(flag&#PB_Flag_NoButtons)
        \Flag\Lines = Bool(flag&#PB_Flag_NoLines)
        \Flag\FullSelection = Bool(Not flag&#PB_Flag_FullSelection)*7
        \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
        \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
        \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
        
        \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
        \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
        
        If Bool(Flag&#PB_Text_WordWrap)
          \Text\MultiLine = 1
        ElseIf Bool(Flag&#PB_Text_MultiLine)
          \Text\MultiLine = 2
        Else
          \Text\MultiLine =- 1
        EndIf
        
        \Flag\MultiSelect = 1
        ;\Text\Numeric = Bool(Flag&#PB_Text_Numeric)
        \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
        \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
        \Text\Pass = Bool(Flag&#PB_Text_Password)
        
        \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
        \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
        \Text\Align\Right = Bool(Flag&#PB_Text_Right)
        \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
        
        If \Text\Vertical
          \Text\X = \fs 
          \Text\y = \fs+2
        Else
          \Text\X = \fs+2
          \Text\y = \fs
        EndIf
        
        
        \Color = Color_Default
        \Color\Fore[0] = 0
        
        \margin\width = Bool(Flag&#PB_Flag_Numeric)
        \margin\Color\Back = $C8F0F0F0 ; \Color\Back[0] 
        
        \color\alpha = 255
        \Color = Color_Default
        \Color\Fore[0] = 0
        \Color\Fore[1] = 0
        \Color\Fore[2] = 0
        \Color\Back[0] = \Color\Back[1]
        \Color\Frame[0] = \Color\Frame[1]
        ;\Color\Back[1] = \Color\Back[0]
        
        
        
        If \Text\Editable
          \Color\Back[0] = $FFFFFFFF 
        Else
          \Color\Back[0] = $FFF0F0F0  
        EndIf
        
      EndIf
      
      ; create scrollbars
     ; Bar::Bars(\Scroll, 16, 7, Bool(\Text\MultiLine <> 1))
      \Scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *This)
      \Scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *This)
      
      Resize(*This, X,Y,Width,Height)
      ;       \Text\String = #LF$
      ;       \Text\Change = 1  
      SetText(*This, Text.s)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Editor(X.i,Y.i,Width.i,Height.i, Flag.i=0, Radius.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_Editor)
    
    With *This
      \X =- 1
      \Y =- 1
      \Cursor = #PB_Cursor_IBeam
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      
      \bs = 1
      \fs = 1
      \Type = #PB_GadgetType_Editor
        \Cursor = #PB_Cursor_IBeam
        ;\DrawingMode = #PB_2DDrawing_Default
        
       
;       ;\Scroll = AllocateStructure(Scroll_S) 
;       \Scroll\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *This)
;       \Scroll\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *This)
      Bar::Bars(\Scroll, 16, 7, Bool(\Text\MultiLine <> 1))
      
      ;\Image = AllocateStructure(Image_S)
      
      
      ;\Text = AllocateStructure(Text_S)
;       \Text[1] = AllocateStructure(Text_S)
;       \Text[2] = AllocateStructure(Text_S)
;       \Text[3] = AllocateStructure(Text_S)
      \Text\Editable = 1
      \Text\x[2] = 3
      \Text\y[2] = 0
      ;\Text\Align\Vertical = 1
      
;       \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
      \Text\MultiLine = 1;(Bool(Flag&#PB_Text_MultiLine) * 1)+(Bool(Flag&#PB_Text_WordWrap) * - 1)
      ;\Text\Numeric = Bool(Flag&#PB_Text_Numeric)
      \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
      \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
      \Text\Pass = Bool(Flag&#PB_Text_Password)
      
;       ;\Text\Align\Vertical = Bool(Not Flag&#PB_Text_Top)
;       \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
;       \Text\Align\Right = Bool(Flag&#PB_Text_Right)
;       ;\Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
      
      
      
      \Color = Color_Default
        \Color\Fore[0] = 0
        
        \margin\width = 100;Bool(Flag&#PB_Flag_Numeric)
        \margin\Color\Back = $C8F0F0F0 ; \Color\Back[0] 
        
        \color\alpha = 255
        \Color = Color_Default
        \Color\Fore[0] = 0
        \Color\Fore[1] = 0
        \Color\Fore[2] = 0
        \Color\Back[0] = \Color\Back[1]
        \Color\Frame[0] = \Color\Frame[1]
        ;\Color\Back[1] = \Color\Back[0]
        
        
        
        If \Text\Editable
          \Color\Back[0] = $FFFFFFFF 
        Else
          \Color\Back[0] = $FFF0F0F0  
        EndIf
        
        
          \Interact = 1
      \Text\Caret[1] =- 1
      \Index[1] =- 1
       \flag\buttons = Bool(flag&#PB_Flag_NoButtons)
        \Flag\Lines = Bool(flag&#PB_Flag_NoLines)
        \Flag\FullSelection = Bool(Not flag&#PB_Flag_FullSelection)*7
        ;\Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
        \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
        \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
        
        ;\Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
         
      SetText(*This, "")
;       SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
;       Set_Anchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  
  Procedure Canvas_CallBack()
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint 
          If *This\Repaint : *This\Repaint = 0
            Repaint = 1
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(\Root\Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Root\Canvas), GadgetHeight(\Root\Canvas))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
        ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
      *This = Editor(60, 30, Width, Height, Flag)
     
    If *This
      With *This
       
       \Root\Canvas = Gadget
        If Not \Root\CanvasWindow
          \Root\CanvasWindow = GetActiveWindow() ; GetGadgetData(Canvas)
        EndIf
        
        ;         PostEvent(#PB_Event_Widget, *This\Root\CanvasWindow, *This, #PB_EventType_Create)
        ;         BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Root\CanvasWindow, *This, #PB_EventType_Create)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
EndModule



;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#CRLF$;#LF$
  
  Text.s = "This is a long line." + m.s +
           "Who should show." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "I have to write the text in the box or not." + 
           m.s +
           m.s +
           m.s +
           m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s +
                                         ;            m.s +
                                         ;            "Schol is a beautiful thing." + m.s +
                                         ;            "You ned it, that's true." + m.s +
                                         ;            "There was a group of monkeys siting on a fallen tree."
                                         ;  Text.s = "This is a long line. Who should show, i have to write the text in the box or not. The string must be very long. Otherwise it will not work."
                                         ; ;   ;Text.s + m + m                   ; " + m + "
                                         ; ;   Text.s + "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789" + m ; + m
                                         ; ;   Text.s + "The main features of PureBasic" + m
  
  Procedure ResizeCallBack()
    ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
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
  
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
    
    EditorGadget(0, 8, 8, 306, 233) : SetGadgetText(0, Text.s)    ; , #PB_Editor_WordWrap
                                                                  ;     For a = 0 To 2
                                                                  ;       AddGadgetItem(0, a, "Line "+Str(a))
                                                                  ;     Next
                                                                  ;     AddGadgetItem(0, a, "")
                                                                  ;     For a = 4 To 6
                                                                  ;       AddGadgetItem(0, a, "Line "+Str(a))
                                                                  ;     Next
                                                                  ;     SetGadgetFont(0, FontID(0))
    
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 233, #PB_Flag_GridLines|#PB_Flag_Numeric);|#PB_Text_Right)  #PB_Text_WordWrap|  #PB_Flag_FullSelection);|
    *w.Widget_S=GetGadgetData(g)
    
    Editor::SetText(*w, Text.s) 
    
;     ;     ;*w\CountItems = CountString(*w\text\string)
;     ;     *w\text\change = 1
;     Debug *w\text\string
;     Debug "------------ "+Len(*w\text\string)
;     Debug *w\text\string[2]
;     Debug "------------ "+Len(*w\text\string[2])
;     
    ;     For a = 0 To 2
    ;       Editor::AddItem(*w, a, "Line "+Str(a))
    ;     Next
    ;     Editor::AddItem(*w, a, "")
    ;     For a = 4 To 6
    ;       Editor::AddItem(*w, a, "Line "+Str(a))
    ;     Next
    ;     Editor::SetFont(*w, FontID(0))
    
    
    SplitterGadget(10,8, 8, 306, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug no linux
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    ;Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E.Widget_S = GetGadgetData(g)
                Debug Len(*e\text[2]\String)
                Debug *e\text[2]\String
                ; ;                 If *w\index[2]-1 > 0
                ; ;                   SelectElement(*w\Items(), *w\index[2]-1)
                ; ;                   count = CountString(*w\items()\text\string, #CR$)
                ; ;                 EndIf
                ; ;                 
                ; ;                 SelectElement(*w\Items(), *w\index[2])
                ; ;                 ; если в предыдущей строке нет #CR$ то в начало получаемой строки добавляем #CR$
                ; ;                 ;                 Debug CountString(*w\items()\text\string, #CR$)
                ; ;                 ;                 Debug CountString(*w\items()\text\string, #LF$)
                ; ;                 
                ; ;                 If Not count
                ; ;                   Debug "string - "+#CR$+Mid(*w\text\string, *w\items()\text\pos+1, 2)
                ; ;                 Else
                ; ;                   Debug "string - "+Mid(*w\text\string, *w\items()\text\pos, 3)
                ; ;                 EndIf
                ; ;                 Debug "string2 - "+Mid(*w\text\string[2], *w\items()\text\pos+*w\items()\index, 3)
                ; ;                 
                ; ;                 
                ; ;                 ; ;                 With *w 
                ; ;                 ; ;                   Debug Left(\Text\String.s, \Items()\Text\Pos+\text\caret)
                ; ;                 ; ;                   Debug "----"
                ; ;                 ; ;                   Debug Right(\Text\String.s, \Text\Len-(\Items()\Text\Pos+\text\caret))
                ; ;                 ; ;                   Debug " ===== "+ \CountItems
                ; ;                 ; ;                   Debug Left(\Text\String.s[2], \Items()\Text\Pos+\items()\index+\text\caret)
                ; ;                 ; ;                   Debug "----"
                ; ;                 ; ;                   Debug Right(\Text\String.s[2], Len(\Text\String.s[2])-(\Items()\Text\Pos+\items()\index+\text\caret))
                ; ;                 ; ;                 EndWith
                ; ;                 
                ; ;                 ;                With *w 
                ; ;                 ;                 Debug Left(\Text\String.s, \Items()\Text\Pos) + \Items()\Text[1]\String.s
                ; ;                 ;                 Debug "----"
                ; ;                 ;                 Debug \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Pos+\Items()\Text\Len))
                ; ;                 ;                 Debug " ====="
                ; ;                 ;                 Debug Left(\Text\String.s[2], \Items()\Text\Pos+\items()\index) + \Items()\Text[1]\String.s
                ; ;                 ;                 Debug "----"
                ; ;                 ;                 Debug \Items()\Text[3]\String.s + Right(\Text\String.s[2], Len(\Text\String.s[2])-(\Items()\Text\Pos+\items()\index+\Items()\Text\Len))
                ; ;                 ;                EndWith
                
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
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -------------------------+-----------3-8f--0--------+-----
; EnableXP