CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_scroll.pbi"
  XIncludeFile "module_Text.pbi"
CompilerEndIf

DeclareModule ListIcon
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
  #GridLines = 1024
  
  #SmallIcon = #PB_ListIcon_LargeIcon                 ; 0 0
  #LargeIcon = #PB_ListIcon_SmallIcon                 ; 1 1
  
 
  Declare AddColumn(Gadget,Item,Text.s,Width.l,Image.l=-1)
  Declare.l Gadget(Gadget.l, x.l, y.l, width.l, height.l, ColumnTitle.s, ColumnWidth.l, flag.l=0)
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

Module ListIcon
  
  Procedure item_from(*This.Widget_S, MouseX=-1, MouseY=-1, focus=0)
    Protected lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    
    With *This\Columns()
      ;PushListPosition(\Items()) 
      ForEach *This\Columns()
        ForEach \Items()
          If \Items()\from = \Items()\Item 
            \Items()\from =- 1
            adress = @\Items()
            Break
          EndIf
        Next
      Next
      
      ForEach *This\Columns()
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
      Next
      
      If Not Bool(MouseX=-1 And MouseY=-1)
        FirstElement(*This\Columns())
        ; ForEach *This\Columns()
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
                
                ; 
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
            
            \Items()\from = \Items()\Item
            adress = @\Items()
            Break
          EndIf
        Next
        ; Next
        
        
      EndIf
      ; PopListPosition(\Items())
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
  
  Procedure Draw(*This.Widget_S)
    Protected x_content,y_point,x_point, iwidth, iheight, w=18, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 128
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = 4
    Protected Drawing.b,column_width,column_height,column_x,l=1, n, height = 18, text_color=$000000
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      height = 16
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      height = 20
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      height = 18
    CompilerEndIf
    
    
    ;     If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If Bool(*This And StartDrawing(CanvasOutput(*This\Canvas\Gadget))) : If *This\Text\FontID : DrawingFont(*This\Text\FontID) : EndIf
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\x[2], *This\y[2], *This\width[2], *This\height[2], back_color)
      
      With *This\Columns()\Items()
        If *This\image\width
          n=19
          column_x = *This\x[2]+(n*(1+Bool(*This\flag&#CheckBoxes))) + 4
        EndIf
        column_x - *This\hScroll\Page\Pos
        column_width = column_x
        *This\vScroll\Page\ScrollStep = height+Bool(*This\flag&#GridLines)*2+l
        
        ForEach *This\Columns()
          ;If ListSize(*This\Columns()\Items())
          column_height = *This\Columns()\height
          *This\Scroll\Width=*This\x[2]
          *This\Scroll\height=*This\y[2]+column_height
          *This\Columns()\x=column_width ; + 20;*This\Columns()\Image\width
          iWidth = *This\Columns()\x + *This\Columns()\width
          iWidth = *This\width[2]-Scroll::Width(*This\vScroll)
          iHeight = *This\height[2]-Scroll::Height(*This\hScroll)
          
          
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            ClipOutput(*This\x[2], *This\y[2], *This\width[2], iHeight)
          CompilerEndIf
          
          If *This\Columns()\text\change = 1
            *This\Columns()\text\height = TextHeight("A")
            *This\Columns()\text\width = TextWidth(*This\Columns()\text\string.s)
            *This\Columns()\text\change = 0
          EndIf
          
          *This\Columns()\text\x = 5+*This\Columns()\x
          *This\Columns()\text\y = *This\Columns()\y+(column_height+2-*This\Columns()\text\height)/2
          
          ;Drawing = Bool(\y+\height>*This\y[2]+*This\Columns()\height And \y<*This\height[2])
          
          PushListPosition(*This\Items())
          ForEach *This\Columns()\Items()
            If Not \hide
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                ClipOutput(*This\x[2], *This\y[2]+column_height, iwidth, iHeight) ; Bug
              CompilerEndIf
              
              
              \x=*This\x[2]+*This\Columns()\x-column_x; ;
              \width=iwidth
              \height=height
              \y=*This\Scroll\height-*This\vScroll\Page\Pos
              
              If \text\change = 1
                \text\height = TextHeight("A")
                \text\width = TextWidth(\text\string.s)
                \text\change = 0
              EndIf
              
              If *This\flag&#NoButtons 
                x_content=*This\x[2]+column_width-column_x+2+(\sublevel*w)-*This\hScroll\Page\Pos
              Else
                x_content=*This\x[2]+column_width-column_x+2+(w+\sublevel*w)-*This\hScroll\Page\Pos
              EndIf
              
              \box\width = box_size
              \box\height = box_size
              \box\x = x_content-(w+\box\width)/2
              \box\y = \y+(\height-\box\height)/2
              
              If \Image\handle
                \Image\x = 2+x_content
                \Image\y = \y+(\height-\Image\height)/2
                
                *This\Image\handle = \Image\handle
                *This\Columns()\Image\width = \Image\width+10
              EndIf
              
              If \text\width
                \text\x = 1+x_content+*This\Columns()\Image\width+Bool(*This\flag&#CheckBoxes)
                \text\y = \y+(\height-\text\height)/2
              EndIf
              
              If *This\flag&#CheckBoxes
                \box\x+n-2
                \text\x+n-2
                \Image\x+n-2
                
                \box\width[1] = box_1_size
                \box\height[1] = box_1_size
                
                \box\x[1] = *This\x[2]+4
                \box\y[1] = \y+(\height-\box\height[1])/2
              EndIf
              
              *This\Scroll\height+\height+l+Bool(*This\flag&#GridLines)*2
              If *This\Scroll\Width < (\text\x+\text\width+n)+*This\hScroll\Page\Pos
                *This\Scroll\Width = (\text\x+\text\width+n)+*This\hScroll\Page\Pos
              EndIf
              
              Drawing = Bool(\y+\height>*This\y[2]+*This\Columns()\height And \y<*This\height[2])
              If Drawing
                If (\Item=\focus And \lostfocus<>\focus) Or
                   (*This\focus And *This\flag&#FullSelection And *This\Item = \Item )
                  
                  box_color = $FFFFFF
                  text_color=$FFFFFF
                Else
                  box_color = $7E7E7E
                  text_color=$000000
                EndIf
                
                
                ; Draw selections
                If *This\flag&#FullSelection
                  If ListIndex(*This\Columns()) = 0;ListSize(*This\Columns()) - 1
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
                    Scroll::DrawArrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, box_color&$FFFFFF|alpha<<24, 0,0) 
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
              
              
              If Drawing
                If ListIndex(*This\Columns())=0
                  ; Draw checkbox
                  If *This\flag&#CheckBoxes
                    DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, checkbox_color, box_color, 2, alpha);, box_type)
                  EndIf
                  
                  ; Draw image
                  If \Image\handle
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawAlphaImage(\Image\handle, \Image\x, \Image\y, alpha)
                  EndIf
                EndIf
                
                ; Draw string
                If \text\string.s
                  CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                    ClipOutput(*This\Columns()\x, *This\y[2]+column_height, *This\Columns()\width, iHeight)
                  CompilerEndIf
                  
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawText(\text\x, \text\y, \text\string.s, text_color&$FFFFFF|alpha<<24)
                  
                  CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                    UnclipOutput()
                  CompilerEndIf
                EndIf
                
                If *This\flag&#GridLines
                  ; Horisontal line
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(*This\x[2], (\y+\height)+l, iwidth, l, $ADADAE&$FFFFFF|alpha<<24)
                  ;Box(*This\Columns()\x-column_x, (\y+\height)+l, *This\Columns()\width+column_x, l, $ADADAE&$FFFFFF|alpha<<24)
                EndIf
              EndIf
            EndIf
          Next
          PopListPosition(*This\Items())
          
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            UnclipOutput()
          CompilerEndIf
          
          
          
          
          
          
          DrawingMode(#PB_2DDrawing_Default)
          ; Box(*This\x[2], 0, iwidth, column_height+3, back_color)
          ; Draw
          DrawingMode(#PB_2DDrawing_Gradient)
          ;BoxGradient(0,*This\Columns()\x+1, 0, *This\Columns()\width-1, column_height, $FFFFFF,$F4F4F5)
          
          If ListIndex(*This\Columns())=0
            DrawingMode(#PB_2DDrawing_Gradient)
            BoxGradient(0,*This\x[2], 0, iwidth, column_height, $FFFFFF,$F4F4F5)
          EndIf
          
          DrawingMode(#PB_2DDrawing_Default)
          Box(*This\Columns()\x-column_x, column_height, iwidth,1,$ADADAE)
          
          
          ; Vertical line
          If *This\flag&#GridLines
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(column_x, *This\y[2], l, iheight, $ADADAE&$FFFFFF|alpha<<24)
            Box(*This\Columns()\x+*This\Columns()\width, *This\y[2], l, iheight, $ADADAE&$FFFFFF|alpha<<24)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(column_x, *This\y[2], l, column_height, $ADADAE&$FFFFFF|alpha<<24)
            Box(*This\Columns()\x+*This\Columns()\width, *This\y[2], l, column_height, $ADADAE&$FFFFFF|alpha<<24)
          EndIf
          
          If *This\Columns()\text\string.s
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(*This\Columns()\text\x, *This\Columns()\text\y, *This\Columns()\text\string.s, $000000&$FFFFFF|alpha<<24)
          EndIf
          
          If *This\bSize
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(*This\x[2]-1, *This\Columns()\height+1, *This\width[2]+2, 1, $FFFFFF)
          EndIf
          
          column_width + *This\Columns()\width
          ;EndIf
        Next
        
        *This\Scroll\Height = *This\Scroll\Height-l-Bool(*This\flag&#GridLines)*2
        
        ; Задаем размеры скролл баров
        If *This\vScroll\Page\Length And *This\vScroll\Max<>*This\Scroll\Height And 
           Scroll::SetAttribute(*This\vScroll, #PB_ScrollBar_Maximum, *This\Scroll\Height)
          Scroll::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        If *This\hScroll\Page\Length And *This\hScroll\Max<>*This\Scroll\Width And 
           Scroll::SetAttribute(*This\hScroll, #PB_ScrollBar_Maximum, *This\Scroll\Width)
          Scroll::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
        EndIf
        
        Scroll::Draw(*This\vScroll)
        Scroll::Draw(*This\hScroll)
        
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
    Protected *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    If *This
      Draw(*This)
    EndIf
  EndProcedure
  
  Procedure AddColumn(Gadget, Item,Text.s,Width.l,Image.l=-1)
    Protected *This.Widget_S = GetGadgetData(Gadget)
    Static Adress
    
    With *This\Columns()
      LastElement(*This\Columns())
      AddElement(*This\Columns()) 
      
      \text\change = 1
      \text\string.s = Text.s
      \height = 24
      
      \Width = Width
      ;       If Scroll::SetAttribute(*This\vScroll, #PB_ScrollBar_Minimum, -\height)
      ;         Scroll::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;       EndIf
    EndWith
    
    Draw(*This)
  EndProcedure
  
  Procedure AddItem(Gadget.l,Item.l,Text.s,Image.l=-1,sublevel.l=0)
    Static adress.i
    Protected *This.Widget_S, Childrens.l, hide.b
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If Not *This
      ProcedureReturn -1
    EndIf
    
    With *This\Columns()
      ForEach *This\Columns()
        
        ;{ Генерируем идентификатор
        If Item =- 1 Or Item > ListSize(\Items()) - 1
          LastElement(\Items())
          AddElement(\Items()) 
          Item = ListIndex(\Items())
        Else
          SelectElement(\Items(), Item)
          If \Items()\sublevel>sublevel
            sublevel=\Items()\sublevel 
          EndIf
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
              \Items()\childrens + 1
              \Items()\collapsed = 1
              hide = 1
            EndIf
          EndIf
          
          PopListPosition(\Items()) 
          \Items()\hide = hide
          ;         Else
          ;           If Not Item 
          ;             adress = FirstElement(\Items()) 
          ;           EndIf
        EndIf
        
        \Items()\from =- 1
        \Items()\focus =- 1
        \Items()\lostfocus =- 1
        \Items()\time = ElapsedMilliseconds()
        \Items()\Item = Item
        \Items()\adress = adress
        \Items()\text\change = 1
        \Items()\text\string.s = StringField(Text.s, ListIndex(*This\Columns()) + 1, #LF$)
        ;\text\string.s = Text.s ;+" ("+Str(iadress)+"-"+Str(SubLevel)+")" 
        \Items()\sublevel = sublevel
        
        If IsImage(Image)
          Select *This\Attribute
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
          *This\image\width = \Items()\image\width
        EndIf
        
        ;       Re(*This)
        
        If *This\Scroll\Height=<*This\height
          ;  Draw(*This)
        EndIf
      Next
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure ClearItems(Gadget.l)
    Protected Result.l, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S, sublevel.l
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S, sublevel.l
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S 
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This 
      With *This
        Result = \Item
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemState(Gadget.l, Item.l, State.l)
    Protected Result.l, *This.Widget_S, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S, lostfocus.l=-1, collapsed.l, sublevel.l, adress.i, coll.l
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.s, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.s, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected Result.l, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
    Protected *This.Widget_S = GetGadgetData(Canvas)
    Static MoveX, MoveY
    
    If *This
      With *This
        If Not \hide
          AutoHide.b = 0; Bool(\vScroll\Buttons=0 And \hScroll\Buttons=0)
          
          If \vScroll
            Repaint = Scroll::CallBack(\vScroll, Event, MouseX, MouseY, WheelDelta, AutoHide, \hScroll, Window, Canvas)
            If Repaint
              ReDraw(Canvas)
            EndIf
          EndIf
          
          If \hScroll
            Repaint = Scroll::CallBack(\hScroll, Event, MouseX, MouseY, WheelDelta, AutoHide, \vScroll, Window, Canvas)
            If Repaint
              ReDraw(Canvas)
            EndIf
          EndIf
          
          If Not (\vScroll\Buttons Or \hScroll\Buttons)
            Select Event
              Case #PB_EventType_MouseWheel
                If Not \vScroll\Hide
                  Select -WheelDelta
                    Case-1 : Repaint = Scroll::SetState(\vScroll, \vScroll\Page\Pos - (\vScroll\Max-\vScroll\Min)/30)
                    Case 1 : Repaint = Scroll::SetState(\vScroll, \vScroll\Page\Pos + (\vScroll\Max-\vScroll\Min)/30)
                  EndSelect
                EndIf
                
              Case #PB_EventType_LeftClick ; Bug in mac os button down and afte move mouse dont post event click
                If \change : \change = 0
                  PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_Change)
                EndIf
                ;If \Drag[1] : \Drag[1] = 0 : Else
                PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_LeftClick)
                ;EndIf
                
              Case #PB_EventType_LeftButtonUp 
                If \Drag=1                                         
                  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                    PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_LeftClick)
                  CompilerEndIf
                  \Drag=0 
                EndIf
                
              Case #PB_EventType_LeftButtonDown : \Focus = 1
                Repaint = item_from(*This, MouseX, MouseY, 1)
                MoveX = MouseX : MoveY = MouseY
                
              Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter
                Protected from = \from
                Repaint = item_from(*This, MouseX, MouseY)
                
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
                Repaint = item_from(*This,-1,-1, 0)
                
              Case #PB_EventType_LostFocus
                Repaint = item_from(*This,-1,-1, 1)
                
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
                
              Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
                \Width = GadgetWidth(\Canvas\Gadget)
                \Height = GadgetHeight(\Canvas\Gadget)
                
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
                
                Scroll::Resizes(\vScroll, \hScroll, \X[2],\Y[2],\Width[2],\Height[2])   ; -24
                Repaint = 1
            EndSelect
          Else
            Repaint = item_from(*This,-1,-1, 0)
          EndIf
        EndIf
      EndWith 
    EndIf
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure.l Gadget(Gadget.l, x.l, y.l, width.l, height.l, ColumnTitle.s, ColumnWidth.l, flag.l=0)
    Protected g = CanvasGadget(Gadget, x, y, width, height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget = g : EndIf
    
    Protected *This.Widget_S=AllocateStructure(Widget_S)
    If *This
      With *This
        If Not flag&#BorderLess
          \bSize = 2
          \fSize = 2
        EndIf
        
        \Item =- 1
        \Canvas\Window = GetActiveWindow()
        
        \Attribute=-1
        \Text\FontID = GetGadgetFont(#PB_Default) ; FontID(LoadFont(#PB_Any,"Tahoma",8)) ; 
        \Canvas\Gadget = Gadget
        \flag = flag|#NoLines|#NoButtons
        
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
        
        ;
        Scroll::Widget(*This\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 8)
        If flag&#NoButtons = 0 Or flag&#NoLines=0
          Scroll::Widget(*This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 8)
        EndIf
        
        
        PostEvent(#PB_Event_Gadget, \Canvas\Window, Gadget, #PB_EventType_Resize)
        ; ;         AddWindowTimer(\Canvas\Window, 12, 5000)
        ; ;         BindEvent(#PB_Event_Timer, @bind(), \Canvas\Window, Gadget)
        
        ;         ; Set style windows 8
        ;         *This\vScroll\DrawingMode = #PB_2DDrawing_Default
        ;         Scroll::SetColor(*This\vScroll, #PB_Gadget_BackColor, *This\vScroll\Color\Back, 1)
        ;         Scroll::SetColor(*This\vScroll, #PB_Gadget_BackColor, *This\vScroll\Color\Back, 2)
        ;         
        ;         *This\hScroll\DrawingMode = #PB_2DDrawing_Default
        ;         Scroll::SetColor(*This\hScroll, #PB_Gadget_BackColor, *This\hScroll\Color\Back, 1)
        ;         Scroll::SetColor(*This\hScroll, #PB_Gadget_BackColor, *This\hScroll\Color\Back, 2)
        
        SetGadgetData(Gadget, *This)
        
        BindGadgetEvent(Gadget, @CallBack())
        
        AddColumn(Gadget,0,ColumnTitle,ColumnWidth)
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
  Procedure Free(Gadget.l)
    Protected Result, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
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
  UseModule ListIcon
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
      If GadgetType(EventGadget()) = #PB_GadgetType_ListIcon
        Debug GetGadgetText(EventGadget())
        Debug GetGadgetState(EventGadget())
        Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
      Else
        Debug ListIcon::GetText(EventGadget())
        Debug ListIcon::GetState(EventGadget())
        Debug ListIcon::GetItemState(EventGadget(), ListIcon::GetState(EventGadget()))
      EndIf
    EndIf
  EndProcedure
  
  UsePNGImageDecoder()
  ;Debug #PB_Compiler_Home+"examples/sources/Data/Toolbar/Paste.png"
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Define a,i
  
  If OpenWindow(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetActiveWindow(0)
    
    Define Count = 500
    Debug "Create items count - "+Str(Count)
    
    ;{ - gadget 
    Define t=ElapsedMilliseconds()
    Define g = 1
    ListIconGadget(g, 10, 10, 165, 210,"Column_1",90)                                         
    For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
    For i=0 To 7
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
    Next
    
    g = 2
    ListIconGadget(g, 180, 10, 165, 210,"Column_1",90)                                         
    For i=1 To 2 : AddGadgetColumn(g, i,"Column_"+Str(i+1),90) : Next
    For i=0 To Count
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                           
    Next
    
    g = 3
    ListIconGadget(g, 350, 10, 430, 210,"Column_1",90, #PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_CheckBoxes)                                         
    
    ;HideGadget(g,1)
    For i=1 To 2
      AddGadgetColumn(g, i,"Column_"+Str(i+1),90)
    Next
    ; 1_example
    For i=0 To 15
      AddGadgetItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", ImageID(0))                                           
    Next
    ;HideGadget(g,0)
    
    Debug " time create gadget (listicon) - "+Str(ElapsedMilliseconds()-t)
    ;}
    
    
    ;{ - widget
    t=ElapsedMilliseconds()
    g = 11
    Gadget(g, 10, 230, 165, 210,"Column_1",90)                                         
    For i=1 To 2 : AddColumn(g, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    For i=0 To 7
      AddItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                           
    Next
    
    g = 12
    Gadget(g, 180, 230, 165, 210,"Column_1",90, #FullSelection)                                         
    For i=1 To 2 : AddColumn(g, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    For i=0 To Count
      AddItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", -1)                                           
    Next
    
    g = 13
    Gadget(g, 350, 230, 430, 210,"Column_1",90, #FullSelection|#GridLines|#CheckBoxes)                                         
    
    ;HideGadget(g,1)
    For i=1 To 2
      AddColumn(g, i,"Column_"+Str(i+1),90)
    Next
    ; 1_example
    For i=0 To 15
      AddItem(g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                           
    Next
    ;HideGadget(g,0)
    
    Debug " time create canvas (listicon) - "+Str(ElapsedMilliseconds()-t)
    ;}
    
    ;   Define *This.Gadget = GetGadgetData(g)
    ;   
    ;   With *This\Columns()
    ;     Debug "Scroll_Height "+*This\Scroll\Height
    ;   EndWith
    
    
    Repeat
      Select WaitWindowEvent()   
        Case #PB_Event_CloseWindow
          End 
        Case #PB_Event_Widget
          Select EventGadget()
            Case 13
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
; Folding = ---------------------------------------
; EnableXP