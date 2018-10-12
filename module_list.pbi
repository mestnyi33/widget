
CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_scrollbar.pbi"
  XIncludeFile "module_Text.pbi"
CompilerEndIf

DeclareModule Tree
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
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
  

  Declare CallBack()
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
  
  Procedure from(*This.Widget, MouseX=-1, MouseY=-1, focus=0)
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
            *This\focus = 0
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
                
                \Items()\checked ! 1
                *This\Change = 1
              EndIf
              
              If (Not \flag&#NoButtons And \Items()\childrens) And
                 (MouseY > (\Items()\box\y[0]) And MouseY =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                 ((MouseX > \Items()\box\x[0]) And (MouseX =< (\Items()\box\x[0]+\Items()\box\width[0])))
                
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
                ; Get entered item only on image and text 
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
                    *This\Item = \Items()\Item
                    *This\Change = 1
                  EndIf
                EndIf
                
                \Items()\focus = \Items()\Item
              EndIf
              
            EndIf
            
            If \Items()\from <> \Items()\Item 
              \Items()\from = \Items()\Item
              *This\from = \Items()\from
              *This\text = \Items()\text 
            EndIf
            
            adress = @\Items()
            
            Break
          EndIf
        Next
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn adress
  EndProcedure
  
  Procedure DrawBox(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) 
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
  
  Procedure Draw(*This.Widget)
    Protected x_content,y_point,x_point, iwidth, iheight, w=18, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 128, height =20
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b =- 1
    Protected Drawing.b, text_color
    
    If Bool(*This And StartDrawing(CanvasOutput(*This\canvas\gadget))) : If *This\Text\FontID : DrawingFont(*This\Text\FontID) : EndIf
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\x[2], *This\y[2], *This\width[2], *This\height[2], back_color)
      
      With *This\Items()
        If ListSize(*This\Items())
          *This\Scroll\Width=*This\x[2]
          *This\Scroll\height=*This\y[2]
          iwidth = *This\width[2]-Scrollbar::Width(*This\vScroll)
          iheight = *This\height[2]-Scrollbar::Height(*This\hScroll)
          
          ForEach *This\Items()
            If Not \hide
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                ClipOutput(*This\x[2], *This\y[2], iwidth, *This\height[2]-Scrollbar::Height(*This\hScroll)) ; Bug
              CompilerEndIf
              
              \x=*This\x[2]
              \width=iwidth
              \height=height
              \y=*This\Scroll\height-*This\vScroll\Page\Pos
              
              If \text\change = 1
                \text\height = TextHeight("A")
                \text\width = TextWidth(\text\string.s)
                \text\change = 0
              EndIf
              
              If *This\flag&#NoButtons 
                x_content=2+\x+(\sublevel*w)-*This\hScroll\Page\Pos
              Else
                x_content=2+\x+(w+\sublevel*w)-*This\hScroll\Page\Pos
              EndIf
              
              \box\width = box_size
              \box\height = box_size
              \box\x = x_content-(w+\box\width)/2
              \box\y = (\y+height)-(height+\box\height)/2
              
              If \Image\handle
                \Image\x = 3+x_content
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
                
                \box\x[1] = 3+(w-\box\width[1])/2 
                \box\y[1] = (\y+height)-(height+\box\height[1])/2
              EndIf
              
              *This\Scroll\height+\height
              If *This\Scroll\Width < (\text\x+\text\width)+*This\hScroll\Page\Pos
                *This\Scroll\Width = (\text\x+\text\width)+*This\hScroll\Page\Pos
              EndIf
              
              
              Drawing = Bool(\y+\height>*This\y[2] And \y<*This\height[2])
              If Drawing
                If (\Item=\focus And \lostfocus<>\focus) Or
                   (*This\focus And *This\flag&#FullSelection And *This\Item = \Item )
                  
                  If *This\flag&#FullSelection
                    box_color = $FFFFFF
                  EndIf
                  text_color=$FFFFFF
                Else
                  box_color = $7E7E7E
                  text_color=$000000
                EndIf
                
                ; Draw selections
                If *This\flag&#FullSelection
                  If \Item=\from
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\x+1,\y+1,\width-2,\height-2, $FCEADA&back_color|item_alpha<<24)  ; ((Color & $FFFFFF) << 32) $FCEADA $00A5FF $CBC0FF
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\x,\y,\width,\height, $FFC288&back_color|item_alpha<<24) ; $FFC288 $0045FF
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
                      ;Box(\x+1,\y+1,\width-2,\height-2, $ECAF7C&back_color|item_alpha<<24)
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
                    Scrollbar::DrawArrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, box_color&$FFFFFF|alpha<<24, 0,0) 
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
;                     For i=0 To line_size Step 2
;                       If Not \childrens Or (i>box_size/2) Or *This\flag&#NoButtons
;                         Line(x_point+i,y_point,1,1, point_color&$FFFFFF|alpha<<24)
;                       EndIf
;                     Next
                    Line(x_point+i,y_point,line_size,1, point_color&$FFFFFF|alpha<<24);
                  EndIf
                  
                  ; Vertical plot
                  If \adress 
                    start=Bool(Not \sublevel) ;  And Not \childrens
                    
                    PushListPosition(*This\Items())
                    ChangeCurrentElement(*This\Items(), \adress) 
                    If start 
                      start = (*This\y[2]+\height/2)-*This\vScroll\Page\Pos 
                    Else 
                      start = \y+\height+\height/2-line_size 
                    EndIf
                    PopListPosition(*This\Items())
                    
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Line(x_point,start,1, (y_point-start), point_color&$FFFFFF|alpha<<24);, point_color&$FFFFFF|alpha<<24)
                    
; ;                     For i=y_point To start Step -2
; ;                       If Bool(i>*This\y And i<*This\height)
; ;                         Select Point(x_point,i)
; ;                           Case $F3F3F3, $F7F7F7, $FBFBFB, 16645629, 15856113, 16119285, 16382457, 4286479998, 4294177779, 4294704123
; ;                             Continue
; ;                           Default
; ;                             ; Debug Point(x_point,i)
; ;                             ;Protected p = Point(x_point,i) ; (RGBA(Red(p), Green(p), Blue(p), Alpha(p))&~$FFFFFF)&$FFFFFF|alpha<<24);
; ;                             Line(x_point,i,1,1);, point_color&$FFFFFF|alpha<<24)
; ;                         EndSelect
; ;                       EndIf
; ;                     Next
                  EndIf
                EndIf
              EndIf
              
              If Drawing
                ; Draw checkbox
                If *This\flag&#CheckBoxes
                  DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, checkbox_color, box_color, 2, alpha);, box_type)
                EndIf
                
                ; Draw image
                If \Image\handle
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawAlphaImage(\Image\handle, \Image\x, \Image\y, alpha)
                EndIf
                
                ; Draw string
                If \text\string.s
                  CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                    ClipOutput(*This\x[2], *This\y[2], \width, *This\height[2]) ; Bug
                  CompilerEndIf
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawText(\text\x, \text\y, \text\string.s, text_color&$FFFFFF|alpha<<24)
                EndIf
              EndIf
            EndIf
          Next
        EndIf
        
        CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
          UnclipOutput()
        CompilerEndIf
        
        ; Задаем размеры скролл баров
        If *This\vScroll\Page\Length And *This\vScroll\Max<>*This\Scroll\Height And 
           Scrollbar::SetAttribute(*This\vScroll, #PB_ScrollBar_Maximum, *This\Scroll\Height)
          Scrollbar::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          *This\vScroll\Page\ScrollStep = height
        EndIf
        If *This\hScroll\Page\Length And *This\hScroll\Max<>*This\Scroll\Width And 
           Scrollbar::SetAttribute(*This\hScroll, #PB_ScrollBar_Maximum, *This\Scroll\Width)
          Scrollbar::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        
        Scrollbar::Draw(*This\vScroll)
        Scrollbar::Draw(*This\hScroll)
        
        If *This\fSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*This\x[1], *This\y[1], *This\width[1], *This\height[1], $ADADAE)
        EndIf
        
        If *This\bSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*This\x[2]-1, *This\y[2]-1, *This\width[2]+2, *This\height[2]+2, $FFFFFF)
        EndIf
        
        StopDrawing()
      EndWith
    EndIf
  EndProcedure
  
  Procedure ReDraw(Gadget.l)
    Protected *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    If *This
      Draw(*This)
    EndIf
  EndProcedure
  
  Procedure AddItem(Gadget.l,Item.l,Text.s,Image.l=-1,sublevel.l=0)
    Static adress.i
    Protected *This.Widget, Childrens.l, hide.b, *Item
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
    If Not *This
      ProcedureReturn -1
    EndIf
    
    With *This
      ;{ Генерируем идентификатор
      If Item =- 1 Or Item > ListSize(\Items()) - 1
        LastElement(\Items())
        AddElement(\Items()) 
        Item = ListIndex(\Items())
        *Item = @\Items()
      Else
        SelectElement(\Items(), Item)
        If \Items()\sublevel>sublevel
          sublevel=\Items()\sublevel 
        EndIf
        *Item = @\Items()
        InsertElement(\Items())
        
        PushListPosition(\Items())
        While NextElement(\Items())
          \Items()\Item = ListIndex(\Items())
        Wend
        PopListPosition(\Items())
      EndIf
      ;}
      
      If subLevel
        If sublevel>ListIndex(\Items())
          sublevel=ListIndex(\Items())
        EndIf
        PushListPosition(\Items()) 
        While PreviousElement(\Items()) 
          If subLevel = \Items()\subLevel
            adress = \Items()\adress
            Break
          ElseIf subLevel > \Items()\subLevel
            adress = @\Items()
            Break
          EndIf
        Wend 
        If adress
          ChangeCurrentElement(\Items(), adress)
          If subLevel > \Items()\subLevel
            sublevel = \Items()\sublevel + 1
            \Items()\adress[1] = *Item
            \Items()\childrens + 1
            \Items()\collapsed = 1
            hide = 1
          EndIf
        EndIf
        
        PopListPosition(\Items()) 
        \Items()\hide = hide
        ;       Else
        ;         If Not \Item 
        ;           adress = FirstElement(\Items())
        ;         EndIf
      EndIf
      
      \Items()\from =- 1
      \Items()\focus =- 1
      \Items()\lostfocus =- 1
      \Items()\time = ElapsedMilliseconds()
      \Items()\Item = Item
      \Items()\adress = adress
      \Items()\text\change = 1
      \Items()\text\string.s = Text.s ;+" ("+Str(iadress)+"-"+Str(SubLevel)+")" 
      \Items()\sublevel = sublevel
      
      If IsImage(Image)
        Select \Attribute
          Case #LargeIcon
            \Items()\Image\width = 32
            \Items()\Image\height = 32
            ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
            
          Case #SmallIcon
            \Items()\Image\width = 16
            \Items()\Image\height = 16
            ResizeImage(Image, \Items()\Image\width,\Items()\Image\height)
            
          Default
            \Items()\Image\width = ImageWidth(Image)
            \Items()\Image\height = ImageHeight(Image)
        EndSelect   
        
        \Items()\Image\handle = ImageID(Image)
        \Items()\Image\handle[1] = Image
      EndIf
      
      ;       Re(*This)
      
      If *This\Scroll\Height=<*This\height
        ;  Draw(*This)
      EndIf
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure ClearItems(Gadget.l)
    Protected Result.l, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget, sublevel.l
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget, sublevel.l
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget 
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
              \Items()\checked = 1
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
    Protected Result.l, *This.Widget, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
            If \Items()\checked
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
    Protected Result.s, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
  
  Procedure.s GetItemText(Gadget.l, Item.l) ; Ok
    Protected Result.s, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
  
  Procedure SetItemText(Gadget.l, Item.l, Text.s) ; Ok
    Protected Result.l, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Item = Item
            If \Items()\text\string <> Text 
              \Items()\text\string = Text
              \Items()\text\change = 1
              Result = 1
            EndIf
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    If Result
      Draw(*This)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure CallBack()
    Protected Repaint.l, AutoHide.b
    Protected Event = EventType()
    Protected Window = EventWindow()
    Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(Canvas, #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(Canvas, #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected *This.Widget = GetGadgetData(Canvas)
    Static MoveX, MoveY
    
    If *This
      With *This
        If Not \hide
          AutoHide.b = 0; Bool(\vScroll\Buttons=0 And \hScroll\Buttons=0)
          
          If \vScroll
            Repaint = Scrollbar::CallBack(\vScroll, Event, MouseX, MouseY, WheelDelta, AutoHide, \hScroll, Window, Canvas)
            If Repaint
              ReDraw(Canvas)
            EndIf
          EndIf
          
          If \hScroll
            Repaint = Scrollbar::CallBack(\hScroll, Event, MouseX, MouseY, WheelDelta, AutoHide, \vScroll, Window, Canvas)
            If Repaint
              ReDraw(Canvas)
            EndIf
          EndIf
          
          If Not (\vScroll\Buttons Or \hScroll\Buttons)
            Select Event
              Case #PB_EventType_MouseWheel
                If Not \vScroll\Hide
                  Select -WheelDelta
                    Case-1 : Repaint = Scrollbar::SetState(\vScroll, \vScroll\Page\Pos - (\vScroll\Max-\vScroll\Min)/30)
                    Case 1 : Repaint = Scrollbar::SetState(\vScroll, \vScroll\Page\Pos + (\vScroll\Max-\vScroll\Min)/30)
                  EndSelect
                EndIf
                
              Case #PB_EventType_LeftClick ; Bug in mac os afte move mouse dont post event click
                If \change : \change = 0
                  PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_Change)
                EndIf
                ;If \Drag[1] : \Drag[1] = 0 : Else
                PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_LeftClick)
                ;EndIf
                
              Case #PB_EventType_LeftButtonUp 
;                 If \Drag =- 1
;                   
;                   PostEvent(#PB_Event_GadgetDrop, EventWindow(), 2)
;                 EndIf
                
                If \Drag=1                                         
                  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                    PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_LeftClick)
                  CompilerEndIf
                  \Drag=0 
                EndIf
                
              Case #PB_EventType_LeftButtonDown : \Focus = 1
                Repaint = from(*This, MouseX, MouseY, 1)
                MoveX = MouseX : MoveY = MouseY
                
              Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter
                Protected from = \from
                Repaint = from(*This, MouseX, MouseY)
               
                If from <> \from
                  If \text\x+\text\width>\width
                    GadgetToolTip(canvas, \text\string)
                  Else
                    GadgetToolTip(canvas, "")
                  EndIf
                  from = \from
                EndIf
                
                If Buttons And \Drag=0 And (Abs((MouseX-MoveX)+(MouseY-MoveY)) >= 6) : \Drag=1
                  If \change : \change = 0
                    PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_Change)
                  EndIf
                  PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_DragStart)
                EndIf
                
              Case #PB_EventType_MouseLeave
                Repaint = from(*This,-1,-1, 0)
;                 \Drag =- 1
                
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
                
              Case #PB_EventType_Resize : ResizeGadget(\Canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
                \Width = GadgetWidth(\Canvas\gadget)
                \Height = GadgetHeight(\Canvas\gadget)
                
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
                
                Scrollbar::Resizes(\vScroll, \hScroll, \X[2],\Y[2],\Width[2],\Height[2])
                Repaint = 1
            EndSelect
          Else
            Repaint = from(*This,-1,-1, 0)
          EndIf
        EndIf
      EndWith 
    EndIf
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure Events()
    Protected Repaint.l, AutoHide.b
    Protected Event = EventType()
    Protected Window = EventWindow()
    Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(Canvas, #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(Canvas, #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected *This.Widget = GetGadgetData(Canvas)
    
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure AllCallBack()
    
    If EventType() = #PB_EventType_DragStart
      Debug 88888
    EndIf
    
  EndProcedure
  
  Procedure.l Gadget(Gadget.l, x.l, y.l, width.l, height.l, flag.l=0)
    Protected g = CanvasGadget(Gadget, x, y, width, height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget = g : EndIf
    
    Protected *This.Widget=AllocateStructure(Widget)
    If *This
      With *This
        If Not flag&#BorderLess
          \bSize = 2
          \fSize = 2
        EndIf
        
        \Item =- 1
        \canvas\window = GetActiveWindow()
        \Type = #PB_GadgetType_Tree
        
        \Attribute=-1
        \Text\FontID = GetGadgetFont(#PB_Default) ; FontID(LoadFont(#PB_Any,"Tahoma",8)) ; 
        \canvas\gadget = Gadget
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
        
        Scrollbar::Widget(*This\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 8)
        If flag&#NoButtons = 0 Or flag&#NoLines=0
          Scrollbar::Widget(*This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 8)
        EndIf
        
        ;         \vScroll\alpha = 0
        ;         \hScroll\alpha = 0
        
        PostEvent(#PB_Event_Gadget, \canvas\window, Gadget, #PB_EventType_Resize)
        ; ;         AddWindowTimer(\canvas_window, 12, 5000)
        ; ;         BindEvent(#PB_Event_Timer, @bind(), \canvas\window, Gadget)
        
        
        ;         Debug SizeOf(*This\hScroll)
        ;         ; Set style windows 8
        ;         *This\vScroll\DrawingMode = #PB_2DDrawing_Default
        ;         Scrollbar::SetColor(*This\vScroll, #PB_Gadget_BackColor, *This\vScroll\Color\Back, 1)
        ;         Scrollbar::SetColor(*This\vScroll, #PB_Gadget_BackColor, *This\vScroll\Color\Back, 2)
        ;         
        ;         *This\hScroll\DrawingMode = #PB_2DDrawing_Default
        ;         Scrollbar::SetColor(*This\hScroll, #PB_Gadget_BackColor, *This\hScroll\Color\Back, 1)
        ;         Scrollbar::SetColor(*This\hScroll, #PB_Gadget_BackColor, *This\hScroll\Color\Back, 2)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @CallBack())
        
;         UnbindEvent(#PB_Event_Gadget,   @AllCallBack())
;         BindEvent(#PB_Event_Gadget,   @AllCallBack())

      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
  Procedure Free(Gadget.l)
    Protected Result, *This.Widget
    If IsGadget(Gadget) : *This.Widget = GetGadgetData(Gadget) : EndIf
    
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
  ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
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
    TreeGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_NoLines|#PB_Tree_NoButtons|#PB_Tree_CheckBoxes)                                         
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
    AddItem(g, 8, "Tree_1_1_2_1_1_4jhhhhhhhhhhhhh", -1, 4) 
    AddItem(g, 7, "Tree_1_1_2_2", -1, 3) 
    AddItem(g, 2, "Tree_1_2", -1, 1) 
    AddItem(g, 3, "Tree_1_3", -1, 1) 
    AddItem(g, 9, "Tree_2",-1 )
    AddItem(g, 10, "Tree_3", -1 )
    
    ;     AddItem(g, 6, "Tree_1_1_2_1", -1, 3) 
    ;     AddItem(g, 8, "Tree_1_1_2_1_1_8", -1, 4) 
    ;     AddItem(g, 7, "Tree_1_1_2_2", -1, 3) 
    ;     AddItem(g, 2, "Tree_1_2", -1, 1) 
    ;     AddItem(g, 3, "Tree_1_3", -1, 1) 
    ;     AddItem(g, 9, "Tree_2",-1 )
    ;     AddItem(g, 10, "Tree_3", -1 )
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ; ClearItems(g)
    
    g = 12
    Gadget(g, 450, 230, 210, 210, #AlwaysShowSelection|#NoLines|#NoButtons|#FullSelection|#CheckBoxes)                                        
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
    
    For i = 0 To 24
      If i % 5 = 0
        AddItem(g, -1, "Directory" + Str(i), -1, 0)
      Else
        AddItem(g, -1, "Item" + Str(i), -1, 1)
      EndIf
    Next i
    
    For i=0 To CountItems(g) : SetItemState(g, i, #PB_Tree_Expanded) : Next
    
    ;Free(g)
    
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
                  Debug "widget id = " + GetState(EventGadget())
                  
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
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ----------------------------------------
; EnableXP