IncludePath "/Users/as/Documents/GitHub/Widget/exemples/"
XIncludeFile "scroll_new000_____.pb"

; ; ;IncludePath "C:\Users\as\Documents\GitHub\"
; ; XIncludeFile "module_scroll.pbi"

;
; Name          : module_tree.pbi
; Module name   : Tree
; Author        : mestnyi
; Last updated  : Sep 17, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=71123
; 

DeclareModule Tree
  EnableExplicit
  
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
  
  Structure Coordinate
        y.l[4]
        x.l[4]
        height.l[4]
        width.l[4]
  EndStructure
  
  Structure Text Extends Coordinate
    change.b
    string.s[2]
  EndStructure
  
  Structure Image Extends Coordinate
    change.b
    handle.i[2]
  EndStructure
  
  Structure Struct Extends Coordinate
    hide.b[2]
    disable.b[2]
    
    bSize.l
    fSize.l
    
    flag.l
    
    box.Coordinate
    
    *data
    
    canvas.l
    canvas_window.l
    canvas_gadget.l
    time.l
    from.l
    focus.l
    lostfocus.l
    
    checkboxed.b
    collapsed.b
    childrens.l
    Item.l
    adress.i
    
    sublevel.l
    
    text.text[4]
    image.image
    
    FontID.i
    Attribute.l
    
    Scroll.Scroll::_S_scroll
    List Items.Struct()
  EndStructure
  
  
  Declare.l Gadget(Gadget.l, x.l, y.l, width.l, height.l, flag.l=0)
  Declare AddItem(Gadget.l,Item.l,Text.s,Image.l=-1,sublevel.l=0)
  Declare ClearItems(Gadget.l)
  Declare CountItems(Gadget.l, Item.l=-1)
  Declare RemoveItem(Gadget.l, Item.l)
  Declare GetItemAttribute(Gadget.l, Item.l, Attribute.l)
  Declare GetItemData(Gadget.l, Item.l)
  Declare SetItemData(Gadget.l, Item.l, *data)
  Declare GetItemColor(Gadget.l, Item.l, ColorType.l, Column.l=0)
  Declare SetItemColor(Gadget.l, Item.l, ColorType.l, Color.l, Column.l=0)
  Declare GetItemImage(Gadget.l, Item.l)
  Declare SetItemImage(Gadget.l, Item.l, Image.l)
  Declare GetState(Gadget.l)
  Declare SetState(Gadget.l, Item.l)
  Declare GetItemState(Gadget.l, Item.l)
  Declare SetItemState(Gadget.l, Item.l, State.l)
  Declare.s GetText(Gadget.l)
  Declare   SetText(Gadget.l, Text.s)
  Declare.s GetItemText(Gadget.l, Item.l)
  Declare SetItemText(Gadget.l, Item.l, Text.s)
  Declare Free(Gadget.l)
  Declare ReDraw(Gadget.l)
EndDeclareModule

Module Tree
  
  Procedure from(*This.Struct, MouseX=-1, MouseY=-1, focus=0)
    Protected adress.i
    Protected lostfocus.l=-1, collapsed.l, sublevel.l, coll.l
    
    With *This
      PushListPosition(\Items()) 
      ForEach \Items()
        If \Items()\from = \Items()\Item 
          \Items()\from =- 1
          adress = @\Items()
          Break
        EndIf
      Next
      
      ForEach \Items()
        If \Items()\Item = \Items()\focus
          If Bool(MouseX=-1 And MouseY=-1 And focus=1)
            \Items()\lostfocus = \Items()\focus
          EndIf
          adress = @\Items()
          Break
        EndIf
      Next
      
      If Not Bool(MouseX=-1 And MouseY=-1)
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If (MouseY > (\Items()\Y) And MouseY =< ((\Items()\Y+\Items()\Height))) And 
             ((MouseX > \Items()\X) And (MouseX =< (\Items()\X+\Items()\Width)))
            
            If focus
              If (MouseY > (\Items()\box\y[1]) And MouseY =< ((\Items()\box\y[1]+\Items()\box\height[1]))) And 
                 ((MouseX > \Items()\box\x[1]) And (MouseX =< (\Items()\box\x[1]+\Items()\box\width[1])))
                
                \Items()\checkboxed ! 1
              EndIf
              
              If (MouseY > (\Items()\box\y[0]) And MouseY =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                 ((MouseX > \Items()\box\x[0]) And (MouseX =< (\Items()\box\x[0]+\Items()\box\width[0]))) And (Not \flag&#NoButtons And \Items()\childrens)
                
                sublevel = \Items()\sublevel
                \Items()\collapsed ! 1
                
                PushListPosition(\Items())
                While NextElement(\Items())
                  If sublevel = \Items()\sublevel
                    Break
                  ElseIf sublevel < \Items()\sublevel 
                    If \Items()\adress
                      PushListPosition(\Items())
                      ChangeCurrentElement(\Items(), \Items()\adress)
                      collapsed = \Items()\collapsed
                      If \Items()\hide
                        collapsed = 1
                      EndIf
                      PopListPosition(\Items())
                    EndIf
                    
                    \Items()\hide = collapsed
                  EndIf
                Wend
                PopListPosition(\Items())
                
              Else
                
                If Not *This\flag&#FullSelection And
                   ((MouseX < \Items()\text\x-*This\Image\width) Or (MouseX > \Items()\text\x+\Items()\text\width))
                  Break
                EndIf
                
                If adress 
                  PushListPosition(\Items()) 
                  ChangeCurrentElement(\Items(), adress)
                  If \Items()\focus = \Items()\Item
                    lostfocus = \Items()\focus 
                    \Items()\lostfocus =- 1
                    \Items()\focus =- 1
                  EndIf
                  PopListPosition(\Items()) 
                  If lostfocus <> \Items()\Item
                    \Items()\lostfocus = lostfocus
                  EndIf
                EndIf
                
                \Items()\focus = \Items()\Item
              EndIf
              
            EndIf
            
            \Items()\from = \Items()\Item
            adress = @\Items()
            Break
          EndIf
        Next
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn adress
  EndProcedure
  
  Procedure DrawBox(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) ; Рисуем стрелки
    Protected I, checkbox_backcolor
    
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    If Checked
      BackColor = $F67905&$FFFFFF|255<<24
      BackColor($FFB775&$FFFFFF|255<<24) 
      FrontColor($F67905&$FFFFFF|255<<24)
    Else
      BackColor = $7E7E7E&$FFFFFF|255<<24
      BackColor($FFFFFF&$FFFFFF|255<<24)
      FrontColor($EEEEEE&$FFFFFF|255<<24)
    EndIf
    
    LinearGradient(X,Y, X, (Y+Height))
    RoundBox(X,Y,Width,Height, Radius,Radius)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
    
    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    RoundBox(X,Y,Width,Height, Radius,Radius, BackColor)
    
    If Checked
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      If Type = 1
        Circle(x+5,y+5,2,Color&$FFFFFF|alpha<<24)
      ElseIf Type = 3
        For i = 0 To 1
          LineXY((X+2),(i+Y+6),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
          LineXY((X+7+i),(Y+2),(X+4+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
;           LineXY((X+1),(i+Y+5),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
;           LineXY((X+8+i),(Y+3),(X+3+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
        Next
      EndIf
    EndIf
  
  EndProcedure
  
  Procedure Draw(*This.Struct)
    Protected x_content,y_point,x_point, width, w=18, level,iY, start,i, back_color=$FFFFFF
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 11, box_color=$7E7E7E, alpha = 255, item_alpha = 128, height =16
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = 4
    Protected Drawing.b
    
    If Bool(*This And StartDrawing(CanvasOutput(*This\canvas))) : If *This\FontID : DrawingFont(*This\FontID) : EndIf
      If *This\fSize
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(*This\x[1], *This\y[1], *This\width[1], *This\height[1], $ADADAE)
      EndIf
      
      If *This\bSize
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(*This\x[2]-1, *This\y[2]-1, *This\width[2]+2, *This\height[2]+2, $FFFFFF)
      EndIf
      
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\x[2], *This\y[2], *This\width[2], *This\height[2], back_color)
      
      With *This\Items()
        If ListSize(*This\Items())
          *This\Scroll\Width=*This\x[2]
          *This\Scroll\height=*This\y[2]
          width = *This\width[2]-Scroll::Width(*This\Scroll\v)
          
          ForEach *This\Items()
            If Not \hide
              ClipOutput(*This\x[2], *This\y[2], width, *This\height[2]-Scroll::Height(*This\Scroll\h))
              
              \x=*This\x[2]
              \width=width
              \height=height
              \y=*This\Scroll\height-*This\Scroll\v\Page\Pos        ; +  *This\fSize
              
              If \text\change = 1
                CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                  \text\height = TextHeight("A")
                CompilerElse
                  \text\height = 11 ; TextHeight("A") ; Bug in mac os
                CompilerEndIf
                \text\width = TextWidth(\text\string.s)
                \text\change = 0
              EndIf
              
              If *This\flag&#NoButtons 
                x_content=2+\x+(\sublevel*w)-*This\Scroll\h\Page\Pos
              Else
                x_content=2+\x+(w+\sublevel*w)-*This\Scroll\h\Page\Pos
              EndIf
              
              \box\width = box_size
              \box\height = box_size
              \box\x = x_content-(w+\box\width)/2
              \box\y = (\y+height)-(height+\box\height)/2
              
              If \Image\handle
                \Image\x = 2+x_content
                \Image\y = \y+(height-\Image\height)/2
                
                *This\Image\handle = \Image\handle
                *This\Image\width = \Image\width+4
              EndIf
              
              \text\x = 3+x_content+*This\Image\width
              \text\y = \y+(height-\text\height)/2
              
              If *This\flag&#CheckBoxes
                \box\x+w-2
                \text\x+w-2
                \Image\x+w-2 
                
                \box\width[1] = box_1_size
                \box\height[1] = box_1_size
                
                \box\x[1] = x_content-(w+\box\width[1])/2 - (\sublevel*w)
                \box\y[1] = (\y+height)-(height+\box\height[1])/2
              EndIf
              
              *This\Scroll\height+\height
              If *This\Scroll\Width < (\text\x+\text\width)+*This\Scroll\h\Page\Pos
                *This\Scroll\Width = (\text\x+\text\width)+*This\Scroll\h\Page\Pos
              EndIf
              
              
              Drawing = Bool(\y+\height>*This\y[2] And \y<*This\height[2])
              If Drawing
                ; Draw selections
                If *This\flag&#FullSelection
                  If \Item=\from
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\x+1,\y+1,\width-2,\height-2, $FCEADA&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\x,\y,\width,\height, $FFC288&back_color|item_alpha<<24)
                  EndIf
                  
                  If \Item=\focus
                    If \lostfocus=\focus 
                      If *This\flag&#AlwaysShowSelection
                        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                        Box(\x+1,\y+1,\width-2,\height-2, $E2E2E2&back_color|item_alpha<<24)
                        
                        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                        Box(\x,\y,\width,\height, $C8C8C8&back_color|item_alpha<<24)
                      EndIf
                    Else
                      item_alpha = 200
                      
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\x+1,\y+1,\width-2,\height-2, $E89C3D&back_color|item_alpha<<24)
                      
                      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                      Box(\x,\y,\width,\height, $DC9338&back_color|item_alpha<<24)
                    EndIf
                  EndIf
                Else
                  
                  If \Item=\focus
                    If \lostfocus=\focus 
                      If *This\flag&#AlwaysShowSelection
                        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                        Box(\text\x+1,\y+1,\text\width-2,\height-2, $E8E8E8&back_color|item_alpha<<24)
                        
                        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                        Box(\text\x,\y,\text\width,\height, $C4C4C4&back_color|item_alpha<<24)
                      EndIf
                    Else
                      item_alpha = 200
                      
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\text\x+1,\y+1,\text\width-2,\height-2, $E89C3D&back_color|item_alpha<<24)
                      
                      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                      Box(\text\x,\y,\text\width,\height, $DC9338&back_color|item_alpha<<24)
                    EndIf
                  EndIf
                  
                EndIf
                
                ; Draw boxes
                If Not *This\flag&#NoButtons And \childrens
                  If box_type=-1
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-3)/2, 3, Bool(Not \collapsed)+2, box_color&$FFFFFF|alpha<<24, 2) 
                  Else
                    DrawingMode(#PB_2DDrawing_Gradient)
                    BackColor($FFFFFF) : FrontColor($EEEEEE)
                    LinearGradient(\box\x, \box\y, \box\x, (\box\y+\box\height))
                    RoundBox(\box\x+1,\box\y+1,\box\width-2,\box\height-2,box_type,box_type)
                    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    RoundBox(\box\x,\box\y,\box\width,\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                    
                    Line(\box\x+2,\box\y+\box\height/2 ,\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                    If \collapsed : Line(\box\x+\box\width/2,\box\y+2,1,\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                  EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If Not *This\flag&#NoLines 
                x_point=\box\x+\box\width/2
                y_point=\box\y+\box\height/2
                
                If x_point>*This\x[2]
                  ; Horisontal plot
                  If Drawing
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    For i=0 To line_size Step 2
                      If Not \childrens Or (\childrens And i>box_size/2)
                        Line(x_point+i,y_point,1,1, box_color&$FFFFFF|alpha<<24)
                      EndIf
                    Next
                  EndIf
                  
                  ; Vertical plot
                  If \adress 
                    start=Bool(Not \childrens And Not \sublevel)
                    
                    PushListPosition(*This\Items())
                    ChangeCurrentElement(*This\Items(), \adress) 
                    If start : start = (*This\y[2]+\height/2)-*This\Scroll\v\Page\Pos : Else : start = \y+\height+\height/2-line_size : EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    For i=start To y_point Step 2
                      If Bool(i>*This\y And i<*This\height)
                        Select Point(x_point,i)
                          Case $F3F3F3, $F7F7F7, $FBFBFB, 16645629, 15856113, 16119285, 16382457, 4286479998, 4294177779, 4294704123
                            Continue
                          Default
                            ; Debug Point(x_point,i)
                            Line(x_point,i,1,1, box_color&$FFFFFF|alpha<<24)
                        EndSelect
                      EndIf
                    Next
                    
                    PopListPosition(*This\Items())
                  EndIf
                EndIf
              EndIf
              
              If Drawing
                ; Draw checkbox
                If *This\flag&#CheckBoxes
                  DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checkboxed, checkbox_color, box_color, 2, alpha);, box_type)
                EndIf
                
                ; Draw image
                If \Image\handle
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawAlphaImage(\Image\handle, \Image\x, \Image\y, alpha)
                EndIf
                
                ; Draw string
                If \text\string.s
                  ClipOutput(*This\x[2], *This\y[2], \width, *This\height[2])
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  If \Item=\focus And \lostfocus<>\focus
                    DrawText(\text\x, \text\y, \text\string.s, $FFFFFF&$FFFFFF|alpha<<24)
                  Else
                    DrawText(\text\x, \text\y, \text\string.s, $000000&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
            EndIf
          Next
        EndIf
        
        UnclipOutput()
        
        ; Задаем размеры скролл баров
        If *This\Scroll\v\Page\Len And *This\Scroll\v\Max<>*This\Scroll\Height And 
           Scroll::SetAttribute(*This\Scroll\v, #PB_ScrollBar_Maximum, *This\Scroll\Height)
          Scroll::Resizes(*This\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
         *This\Scroll\v\ScrollStep = height
        EndIf
        If *This\Scroll\h\Page\Len And *This\Scroll\h\Max<>*This\Scroll\Width And 
           Scroll::SetAttribute(*This\Scroll\h, #PB_ScrollBar_Maximum, *This\Scroll\Width)
          Scroll::Resizes(*This\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        
        Scroll::Draw(*This\Scroll\v)
        Scroll::Draw(*This\Scroll\h)
        
        StopDrawing()
      EndWith
    EndIf
  EndProcedure
  
  Procedure ReDraw(Gadget.l)
    Protected *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    If *This
      Draw(*This)
    EndIf
  EndProcedure
  
  Procedure AddItem(Gadget.l,Item.l,Text.s,Image.l=-1,sublevel.l=0)
    Static adress.i
    Protected *This.Struct, Childrens.l, hide.b
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If Not *This
      ProcedureReturn -1
    EndIf
    
    With *This\Items()
      ;{ Генерируем идентификатор
      If Item =- 1 Or Item > ListSize(*This\Items()) - 1
        LastElement(*This\Items())
        AddElement(*This\Items()) 
        Item = ListIndex(*This\Items())
      Else
        SelectElement(*This\Items(), Item)
        If \sublevel>sublevel
          sublevel=\sublevel 
        EndIf
        InsertElement(*This\Items())
        
        PushListPosition(*This\Items())
        While NextElement(*This\Items())
          \Item = ListIndex(*This\Items())
        Wend
        PopListPosition(*This\Items())
      EndIf
      ;}
      
      If subLevel
        If sublevel>ListIndex(*This\Items())
          sublevel=ListIndex(*This\Items())
        EndIf
        PushListPosition(*This\Items()) 
        While PreviousElement(*This\Items()) 
          If subLevel = *This\Items()\subLevel
            adress = *This\Items()\adress
            Break
          ElseIf subLevel > *This\Items()\subLevel
            adress = @*This\Items()
            Break
          EndIf
        Wend 
        If adress
          ChangeCurrentElement(*This\Items(), adress)
          If subLevel > *This\Items()\subLevel
            sublevel=*This\Items()\sublevel + 1
            *This\Items()\childrens + 1
            *This\Items()\collapsed = 1
            hide = 1
          EndIf
        EndIf
        
        PopListPosition(*This\Items()) 
        \hide = hide
      Else
        If Not Item 
          adress = FirstElement(*This\Items()) 
        EndIf
      EndIf
      
      \from =- 1
      \focus =- 1
      \lostfocus =- 1
      \time = ElapsedMilliseconds()
      \Item = Item
      \adress = adress
      \text\change = 1
      \text\string.s = Text.s ;+" ("+Str(iadress)+"-"+Str(SubLevel)+")" 
      \sublevel = sublevel
      
      If IsImage(Image)
        Select *This\Attribute
          Case #LargeIcon
            \Image\width = 32
            \Image\height = 32
            ResizeImage(Image, \Image\width,\Image\height)
            
          Case #SmallIcon
            \Image\width = 16
            \Image\height = 16
            ResizeImage(Image, \Image\width,\Image\height)
            
          Default
            \Image\width = ImageWidth(Image)
            \Image\height = ImageHeight(Image)
        EndSelect   
        
        \Image\handle = ImageID(Image)
        \Image\handle[1] = Image
      EndIf
      
      ;       Re(*This)
      
      If *This\Scroll\Height=<*This\height
        ;  Draw(*This)
      EndIf
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure ClearItems(Gadget.l)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        Result = ClearList(\Items())
        If StartDrawing(CanvasOutput(Gadget))
          Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
          StopDrawing()
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure CountItems(Gadget.l, Item.l=-1)
    Protected Result.l, *This.Struct, sublevel.l
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        If Item.l=-1
          Result = ListSize(\Items())
        Else
          PushListPosition(\Items()) 
          ForEach \Items()
            If \Items()\Item = Item 
              ; Result = \Items()\childrens 
              sublevel = \Items()\sublevel
              PushListPosition(\Items())
              While NextElement(\Items())
                If sublevel = \Items()\sublevel
                  Break
                ElseIf sublevel < \Items()\sublevel 
                  Result+1
                EndIf
              Wend
              PopListPosition(\Items())
              Break
            EndIf
          Next
          PopListPosition(\Items())
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure RemoveItem(Gadget.l, Item.l)
    Protected Result.l, *This.Struct, sublevel.l
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            sublevel = \Items()\sublevel
            PushListPosition(\Items())
            While NextElement(\Items())
              If sublevel = \Items()\sublevel
                Break
              ElseIf sublevel < \Items()\sublevel 
                Result = DeleteElement(\Items()) 
              EndIf
            Wend
            PopListPosition(\Items())
            Result = DeleteElement(\Items()) 
            Break
          EndIf
        Next
        PopListPosition(\Items())
        
        ReDraw(Gadget)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemAttribute(Gadget.l, Item.l, Attribute.l)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            Select Attribute
              Case #PB_Tree_SubLevel
                Result = \Items()\sublevel
                
            EndSelect
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure GetItemData(Gadget.l, Item.l)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            Result = \Items()\data
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemData(Gadget.l, Item.l, *data)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            \Items()\data = *data
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemColor(Gadget.l, Item.l, ColorType.l, Column.l=0)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemColor(Gadget.l, Item.l, ColorType.l, Color.l, Column.l=0)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemImage(Gadget.l, Item.l)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item 
            Result = \Items()\Image
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemImage(Gadget.l, Item.l, image.l)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Item = Item And IsImage(image)
            \Items()\Image\handle = ImageID(image)
            \Items()\Image\handle[1] = image 
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.l, Item.l)
    Protected Result.l, *This.Struct, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\from = \Items()\Item 
            \Items()\from =- 1
            Result = @\Items()
            Break
          EndIf
        Next
        
        ForEach \Items()
          If \Items()\Item = \Items()\focus
            \Items()\lostfocus = \Items()\focus
            If Item =- 1 : \Items()\focus =- 1 : EndIf
            Result = @\Items()
            Break
          EndIf
        Next
        
        If Item <>- 1
          ForEach \Items()
            If \Items()\hide : Continue : EndIf
            If \Items()\Item = Item
              
              If Result 
                PushListPosition(\Items()) 
                ChangeCurrentElement(\Items(), Result)
                If \Items()\focus = \Items()\Item
                  lostfocus = \Items()\focus 
                  \Items()\lostfocus =- 1
                  \Items()\focus =- 1
                EndIf
                PopListPosition(\Items()) 
                If lostfocus <> \Items()\Item
                  \Items()\lostfocus = lostfocus
                EndIf
              EndIf
              
              \Items()\focus = \Items()\Item
              \Items()\from = \Items()\Item
              
              If GetActiveGadget()<>Gadget
                \Items()\lostfocus = \Items()\focus
                \Items()\from =- 1
              EndIf
              
              Result = @\Items()
              Break
              
            EndIf
          Next
        EndIf
        PopListPosition(\Items())
        
        ReDraw(Gadget)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetState(Gadget.l)
    Protected Result.l, *This.Struct 
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This 
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = \Items()\focus
            Result = \Items()\Item
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemState(Gadget.l, Item.l, State.l)
    Protected Result.l, *This.Struct, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            If State&#Selected
              \Items()\focus = \Items()\Item
              
              If GetActiveGadget()<>Gadget
                \Items()\lostfocus = \Items()\focus
                \Items()\from =- 1
              EndIf
              
            EndIf
            If State&#Checked
              \Items()\checkboxed = 1
            EndIf
            If State&#Collapsed Or State&#Expanded
              \Items()\collapsed = Bool(State&#Collapsed)
              
              sublevel = \Items()\sublevel
              
              PushListPosition(\Items())
              While NextElement(\Items())
                If sublevel = \Items()\sublevel
                  Break
                ElseIf sublevel < \Items()\sublevel 
                  If State&#Collapsed
                    \Items()\hide = 1
                  ElseIf State&#Expanded
                    \Items()\hide = 0
                  EndIf
                EndIf
              Wend
            EndIf
            Break
          EndIf
        Next
        PopListPosition(\Items())
        
        ReDraw(Gadget)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemState(Gadget.l, Item.l)
    Protected Result.l, *This.Struct, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            Result = #Selected
            If \Items()\collapsed
              Result | #Collapsed
            Else
              Result | #Expanded
            EndIf
            If \Items()\checkboxed
              Result | #Checked
            EndIf
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetText(Gadget.l)
    Protected Result.s, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = \Items()\focus
            Result = \Items()\text\string
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf  
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetText(Gadget.l, Text.s)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = \Items()\focus
            \Items()\text\string = Text
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(Gadget.l, Item.l)
    Protected Result.s, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            Result = \Items()\text\string
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemText(Gadget.l, Item.l, Text.s)
    Protected Result.l, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            \Items()\text\string = Text
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure CallBack()
    Static m_b, m_x, m_y
    
    Protected Repaint.l
    Protected Event = EventType()
    Protected Window = EventWindow()
    Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(Canvas, #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(Canvas, #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
    
    Protected *This.Struct = GetGadgetData(Canvas)
    
    With *This
      If *This\Scroll\v
        Repaint = Scroll::CallBack(*This\Scroll\v, Event, MouseX, MouseY, WheelDelta)
        If Repaint 
          ReDraw(Canvas)
          PostEvent(#PB_Event_Gadget, Window, Canvas, #PB_EventType_Change)
        EndIf
      EndIf
      
      If *This\Scroll\h
        Repaint = Scroll::CallBack(*This\Scroll\h, Event, MouseX, MouseY, WheelDelta)
        If Repaint 
          ReDraw(Canvas)
          PostEvent(#PB_Event_Gadget, Window, Canvas, #PB_EventType_Change)
        EndIf
      EndIf
      
      If Not (*This\Scroll\v\from Or *This\Scroll\h\from)
        Select Event
          Case #PB_EventType_MouseWheel
            If Not *This\Scroll\v\Hide
              Select -WheelDelta
                Case-1 : Repaint = Scroll::SetState(*This\Scroll\v, *This\Scroll\v\Page\Pos - (*This\Scroll\v\Max-*This\Scroll\v\Min)/30)
                Case 1 : Repaint = Scroll::SetState(*This\Scroll\v, *This\Scroll\v\Page\Pos + (*This\Scroll\v\Max-*This\Scroll\v\Min)/30)
              EndSelect
            EndIf
            
          Case #PB_EventType_LeftClick
            m_b=0
            m_x=0
            m_y=0
            
          Case #PB_EventType_LeftButtonDown
            Repaint = from(*This, MouseX, MouseY, 1)
            GadgetToolTip(canvas, GetText(Canvas))
            
          Case #PB_EventType_MouseMove
            Repaint = from(*This, MouseX, MouseY)
            
            If Buttons
              If m_x = 0
                m_x=MouseX
              EndIf
              If m_y = 0
                m_y=MouseY
              EndIf
              
              If m_x<>MouseX 
                m_x=MouseX
              EndIf
              If m_y<>MouseY 
                m_y=MouseY
              EndIf
              
              If (m_x=MouseX Or m_y=MouseY) And m_b = 0
                m_b = 1
                ;Debug GetText(Canvas)
                PostEvent(#PB_Event_Gadget, EventWindow(), EventGadget(), #PB_EventType_DragStart)
              EndIf
            EndIf
            
          Case #PB_EventType_MouseLeave
            Repaint = from(*This,-1,-1, 0)
            
            If m_b
              m_x=0
              m_y=0
              m_b=0
            EndIf
            
          Case #PB_EventType_LostFocus
            Repaint = from(*This,-1,-1, 1)
            
          Case #PB_EventType_Focus
            PushListPosition(\Items()) 
            ForEach \Items()
              If \Items()\Item = \Items()\focus And \Items()\focus = \Items()\lostfocus 
                \Items()\lostfocus =- 1
                Repaint = 1
                Break
              EndIf
            Next
            PopListPosition(\Items()) 
            
          Case #PB_EventType_Resize : ResizeGadget(\Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
            \Width = GadgetWidth(\Canvas)
            \Height = GadgetHeight(\Canvas)
            
            ; Inner coordinate
            \X[2]=\bSize
            \Y[2]=\bSize
            \Width[2] = \Width-\bSize*2
            \Height[2] = \Height-\bSize*2
            
            ; Frame coordinae
            \X[1]=\X[2]-\fSize
            \Y[1]=\Y[2]-\fSize
            \Width[1] = \Width[2]+\fSize*2
            \Height[1] = \Height[2]+\fSize*2
            
            Scroll::Resizes(*This\Scroll, *This\X[2],*This\Y[2], *This\Width[2],*This\Height[2])
            Repaint = 1
        EndSelect
      Else
        Repaint = from(*This,-1,-1, 0)
      EndIf
    EndWith 
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure.l Gadget(Gadget.l, x.l, y.l, width.l, height.l, flag.l=0)
    Protected g = CanvasGadget(Gadget, x, y, width, height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget = g : EndIf
    
    Protected *This.Struct=AllocateStructure(Struct)
    If *This
      With *This
        If Not flag&#BorderLess
          \bSize = 2
          \fSize = 2
        EndIf
        
        \canvas_window = GetActiveWindow()
        
        \Attribute=-1
        \FontID = GetGadgetFont(#PB_Default) ; FontID(LoadFont(#PB_Any,"Tahoma",8)) ; 
        \canvas = Gadget
        \flag = flag
        
        \Width = width
        \Height = height
        
        ; Inner coordinate
        \X[2]=\bSize
        \Y[2]=\bSize
        \Width[2] = \Width-\bSize*2
        \Height[2] = \Height-\bSize*2
        
        ; Frame coordinae
        \X[1]=\X[2]-\fSize+1
        \Y[1]=\Y[2]-\fSize+1
        \Width[1] = \Width[2]+\fSize*2-2
        \Height[1] = \Height[2]+\fSize*2-2
        
        *This\Scroll\v = Scroll::Gadget(#PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 8)
        *This\Scroll\h = Scroll::Gadget(#PB_Ignore, #PB_Ignore, #PB_Ignore, Bool(flag&#NoButtons = 0 Or flag&#NoLines=0) * 16, 0,0,0, 0, 8)
        
        PostEvent(#PB_Event_Gadget, \canvas_window, Gadget, #PB_EventType_Resize)
        ; ;         AddWindowTimer(\canvas_window, 12, 5000)
        ; ;         BindEvent(#PB_Event_Timer, @bind(), \canvas_window, Gadget)
        
        
        ;         Debug SizeOf(*This\Scroll\h)
        ;         ; Set style windows 8
        ;         *This\Scroll\v\DrawingMode = #PB_2DDrawing_Default
        ;         Scroll::SetColor(*This\Scroll\v, #PB_Gadget_BackColor, *This\Scroll\v\Color\Back, 1)
        ;         Scroll::SetColor(*This\Scroll\v, #PB_Gadget_BackColor, *This\Scroll\v\Color\Back, 2)
        ;         
        ;         *This\Scroll\h\DrawingMode = #PB_2DDrawing_Default
        ;         Scroll::SetColor(*This\Scroll\h, #PB_Gadget_BackColor, *This\Scroll\h\Color\Back, 1)
        ;         Scroll::SetColor(*This\Scroll\h, #PB_Gadget_BackColor, *This\Scroll\h\Color\Back, 2)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
  Procedure Free(Gadget.l)
    Protected Result, *This.Struct
    If IsGadget(Gadget) : *This.Struct = GetGadgetData(Gadget) : EndIf
    
    If *This
      FreeStructure(*This)
      ; SetGadgetData(Gadget, #Null)
      UnbindGadgetEvent(Gadget, @CallBack())
      ; SetGadgetColor(Gadget, #PB_Gadget_BackColor, $FFFFFF)
      If StartDrawing(CanvasOutput(Gadget))
        Box(0,0,OutputWidth(),OutputHeight(), $FFFFFF)
        StopDrawing()
      EndIf
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
EndModule

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Tree
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
      If GadgetType(EventGadget()) = #PB_GadgetType_Tree
        Debug GetGadgetText(EventGadget())
        Debug GetGadgetState(EventGadget())
        Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
      Else
        Debug Tree::GetText(EventGadget())
        Debug Tree::GetState(EventGadget())
        Debug Tree::GetItemState(EventGadget(), Tree::GetState(EventGadget()))
      EndIf
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  If LoadImage(0, #PB_Compiler_Home + "examples/sources/data/toolbar/paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
  EndIf
  
  If OpenWindow(0, 0, 0, 1110, 450, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
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
    BindGadgetEvent(g, @Events())
    
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
    
    AddGadgetItem(g, 6, "Tree_1_1_2_1", 0, 3) 
    AddGadgetItem(g, 8, "Tree_1_1_2_1_1", 0, 4) 
    AddGadgetItem(g, 7, "Tree_1_1_2_2", 0, 3) 
    AddGadgetItem(g, 2, "Tree_1_2", 0, 1) 
    AddGadgetItem(g, 3, "Tree_1_3", 0, 1) 
    AddGadgetItem(g, 9, "Tree_2" )
    AddGadgetItem(g, 10, "Tree_3", 0 )
    For i=0 To CountGadgetItems(g) : SetGadgetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; ClearGadgetItems(g)
    
    g = 3
    TreeGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines|#PB_Tree_NoButtons)                                         
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
    
    
    g = 10
    Gadget(g, 10, 230, 210, 210, #AlwaysShowSelection|#PB_Tree_CheckBoxes|#FullSelection)                                         
    ; 1_example
    AddItem (g, 0, "Normal Item "+Str(a), -1, 0)                                   
    AddItem (g, -1, "Node "+Str(a), 0, 0)                                         
    AddItem (g, -1, "Sub-Item 1", -1, 1)                                           
    AddItem (g, -1, "Sub-Item 2", -1, 11)
    AddItem (g, -1, "Sub-Item 3", -1, 1)
    AddItem (g, -1, "Sub-Item 4", -1, 1)                                           
    AddItem (g, -1, "Sub-Item 5", -1, 11)
    AddItem (g, -1, "Sub-Item 6", -1, 1)
    AddItem (g, -1, "File "+Str(a), -1, 0)  
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; RemoveItem(g,1)
    Tree::SetItemState(g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
    BindGadgetEvent(g, @Events())
    ;Tree::SetState(g, 1)
    ;Tree::SetState(g, -1)
    ;     Debug "c "+Tree::GetText(g)
    
    g = 11
    Gadget(g, 230, 230, 210, 210, #AlwaysShowSelection|#FullSelection)                                         
    ;  3_example
    AddItem(g, 0, "Tree_0", -1 )
    AddItem(g, 1, "Tree_1_1", 0, 1) 
    AddItem(g, 4, "Tree_1_1_1", -1, 2) 
    AddItem(g, 5, "Tree_1_1_2", -1, 2) 
    AddItem(g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(g, 8, "Tree_1_1_2_1_1", -1, 4) 
    AddItem(g, 7, "Tree_1_1_2_2", -1, 3) 
    AddItem(g, 2, "Tree_1_2", -1, 1) 
    AddItem(g, 3, "Tree_1_3", -1, 1) 
    AddItem(g, 9, "Tree_2",-1 )
    AddItem(g, 10, "Tree_3", -1 )
    
    AddItem(g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(g, 8, "Tree_1_1_2_1_1", -1, 4) 
    AddItem(g, 7, "Tree_1_1_2_2", -1, 3) 
    AddItem(g, 2, "Tree_1_2", -1, 1) 
    AddItem(g, 3, "Tree_1_3", -1, 1) 
    AddItem(g, 9, "Tree_2",-1 )
    AddItem(g, 10, "Tree_3", -1 )
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; ClearItems(g)
    
    g = 12
    Gadget(g, 450, 230, 210, 210, #AlwaysShowSelection|#PB_Tree_NoLines|#PB_Tree_NoButtons|#FullSelection)                                        
    ;   ;  2_example
    ;   AddItem (g, 0, "Normal Item "+Str(a), -1, 0)                                    
    ;   AddItem (g, 1, "Node "+Str(a), -1, 1)                                           
    ;   AddItem (g, 4, "Sub-Item 1", -1, 2)                                            
    ;   AddItem (g, 2, "Sub-Item 2", -1, 1)
    ;   AddItem (g, 3, "Sub-Item 3", -1, 1)
    
    ;  2_example
    AddItem (g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
    For i=1 To 20
      If i=5
        AddItem(g, -1, "Tree_"+Str(i), -1) 
      Else
        AddItem(g, -1, "Tree_"+Str(i), 0) 
      EndIf
    Next
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 13
    Gadget(g, 670, 230, 210, 210, #AlwaysShowSelection|#PB_Tree_NoLines)                                         
    ;  4_example
    AddItem(g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    AddItem(g, 1, "Tree_1", -1, 1) 
    AddItem(g, 2, "Tree_2_2", -1, 2) 
    AddItem(g, 2, "Tree_2_1", -1, 1) 
    AddItem(g, 3, "Tree_3_1", -1, 1) 
    AddItem(g, 3, "Tree_3_2", -1, 2) 
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    
    g = 14
    Gadget(g, 890, 230, 103, 210, #AlwaysShowSelection|#PB_Tree_NoButtons)                                         
    ;  5_example
    AddItem(g, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(g, 1, "Tree_1", -1, 1) 
    AddItem(g, 2, "Tree_2_1", -1, 1) 
    AddItem(g, 2, "Tree_2_2", -1, 2) 
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    g = 15
    Gadget(g, 890+106, 230, 103, 210, #AlwaysShowSelection|#BorderLess)                                         
    ;  6_example
    AddItem(g, 0, "Tree_1", -1, 1) 
    AddItem(g, 0, "Tree_2_1", -1, 2) 
    AddItem(g, 0, "Tree_2_2", -1, 3) 
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ;Free(g)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = +------------------------------------
; EnableXP