; CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
;   IncludePath "/Users/as/Documents/GitHub/Widget/"
; CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_scroll.pbi"
  XIncludeFile "module_text.pbi"
  XIncludeFile "module_editor.pbi"
CompilerEndIf

DeclareModule ListIcon
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  
  Declare.i AddColumn(*This.Widget_S, Position.i, Text.s, Width.i, Image.i=-1)
  Declare.i Gadget(Gadget.i, x.i, y.i, width.i, height.i, ColumnTitle.s, ColumnWidth.i, flag.i=0)
  Declare AddItem(*This.Widget_S,Item.i,Text.s,Image.i=-1,sublevel.i=0)
  Declare ClearItems(*This.Widget_S)
  Declare CountItems(*This.Widget_S, Item.i=-1)
  Declare RemoveItem(*This.Widget_S, Item.i)
  Declare GetItemAttribute(Gadget.i, Item.i, Attribute.i)
  Declare GetItemData(Gadget.i, Item.i)
  Declare SetItemData(Gadget.i, Item.i, *data)
  Declare GetItemColor(Gadget.i, Item.i, ColorType.i, Column.i=0)
  Declare SetItemColor(Gadget.i, Item.i, ColorType.i, Color.i, Column.i=0)
  Declare GetItemImage(Gadget.i, Item.i)
  Declare SetItemImage(Gadget.i, Item.i, Image.i)
  Declare GetState(Gadget.i)
  Declare SetState(Gadget.i, Item.i)
  Declare GetItemState(Gadget.i, Item.i)
  Declare SetItemState(Gadget.i, Item.i, State.i)
  Declare.s GetText(Gadget.i)
  Declare   SetText(Gadget.i, Text.s)
  Declare.s GetItemText(Gadget.i, Item.i)
  Declare SetItemText(Gadget.i, Item.i, Text.s)
  Declare Free(Gadget.i)
  Declare ReDraw(*This.Widget_S)
  
  
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, ColumnTitle.s, ColumnWidth.i, Flag.i=0, Radius.i=0)
EndDeclareModule

Module ListIcon
  
  ;- - DRAWINGs
  Procedure CheckBox(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) 
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
  
  Procedure PlotX(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If x%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure PlotY(X, Y, SourceColor, TargetColor)
    Protected Color
    
    If y%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Case $FFF1F1F1, $FFF3F3F3, $FFF5F5F5, $FFF7F7F7, $FFF9F9F9, $FFFBFBFB, $FFFDFDFD, $FFFCFCFC, $FFFEFEFE, $FF7E7E7E
          Color = TargetColor
        Default
          Color = SourceColor
      EndSelect
    Else
      Color = TargetColor
    EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i _Draw(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing, column_height=24, column_x,l=1
    
    Protected line_size = *This\Flag\Lines
    Protected box_size = *This\flag\buttons
    Protected check_box_size = *This\Flag\CheckBoxes
    
    If Not *This\Hide
      
      With *This
        iX=\X[2]
        iY=\Y[2]
        CompilerIf Defined(Scroll, #PB_Module)
          iwidth = *This\width[2]-Scroll::Width(*This\Scroll\v)
          iheight = *This\height[2]-Scroll::Height(*This\Scroll\h)
        CompilerElse
          iwidth = *This\width[2]
          iheight = *This\height[2]
        CompilerEndIf
        
        If \Text\FontID 
          DrawingFont(\Text\FontID) 
        EndIf
        
        ; Make output multi line text
        If (\Text\Change Or \Resize)
          If \Resize
            Debug "   resize "+\Resize
            ; Посылаем сообщение об изменении размера 
            PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_Resize, \Resize)
          EndIf
          If \Text\Change
            \Text\Height[1] = TextHeight("A") + Bool(\Text\Count<>1 And \Flag\GridLines)
            If \Type = #PB_GadgetType_Tree
              \Text\Height = 20
            Else
              \Text\Height = \Text\Height[1]
            EndIf
            \Text\Width = TextWidth(\Text\String.s)
          EndIf
          
          ;Text::MultiLine(*This)
        EndIf 
        
        _clip_output_(*This, \X,\Y,\Width,\Height)
        
        ; Draw back color
        If \Color\Fore[\Color\State]
          DrawingMode(#PB_2DDrawing_Gradient)
          BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
        Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Back[\Color\State])
        EndIf
        
      EndWith 
      
      ; Draw items text
      With *This\Columns()\Items()
        If ListSize(*This\Columns()\Items())
          ForEach *This\Columns()
            column_x = *This\Columns()\x + Bool(*This\image\width)*25 + Bool(*This\Flag\CheckBoxes)*25 + *This\Scroll\X
            
            If *This\Columns()\text\change = 1
              *This\Columns()\text\height = TextHeight("A") 
              *This\Columns()\text\width = TextWidth(*This\Columns()\text\string.s)
              *This\Columns()\text\change = 0
            EndIf
            
            *This\Columns()\text\x = 5+column_x
            *This\Columns()\text\y = *This\x[2]+*This\Columns()\y+(*This\Columns()\height-*This\Columns()\text\height)/2
            
            PushListPosition(*This\Columns()\Items())
            ForEach *This\Columns()\Items()
              ; Is visible lines ---
              Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
              ;\Hide = Bool(Not Drawing)
              
              If \hide
                Drawing = 0
              EndIf
              
              If Drawing
                If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
                _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
                
                If \Text\Change : \Text\Change = #False
                  \Text\Width = TextWidth(\Text\String.s) 
                  
                  If \Text\FontID 
                    \Text\Height = TextHeight("A") 
                  Else
                    \Text\Height = *This\Text\Height[1]
                  EndIf
                EndIf 
                
                If \Text[1]\Change : \Text[1]\Change = #False
                  \Text[1]\Width = TextWidth(\Text[1]\String.s) 
                EndIf 
                
                If \Text[3]\Change : \Text[3]\Change = #False 
                  \Text[3]\Width = TextWidth(\Text[3]\String.s)
                EndIf 
                
                If \Text[2]\Change : \Text[2]\Change = #False 
                  \Text[2]\X = \Text\X+\Text[1]\Width
                  \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
                  \Text[3]\X = \Text[2]\X+\Text[2]\Width
                EndIf 
                
                ;               
                Protected Left,Right
                If *This\Focus = *This And *This\Text\Editable
                  Left =- TextWidth(Mid(*This\Text\String.s, \Text\Pos, *This\Text\Caret))
                  ; Left =- (\Text[1]\Width+(Bool(*This\Text\Caret>*This\Text\Caret[1])*\Text[2]\Width))
                  Right = (\Width + Left)
                  
                  If *This\Scroll\X < Left
                    *This\Scroll\X = Left
                  ElseIf *This\Scroll\X > Right
                    *This\Scroll\X = Right
                  ElseIf (*This\Scroll\X < 0 And *This\Text\Caret = *This\Text\Caret[1] And Not *This\Canvas\Input) ; Back string
                    *This\Scroll\X = (\Width-\Text[3]\Width) + Left
                    If *This\Scroll\X>0
                      *This\Scroll\X=0
                    EndIf
                  EndIf
                EndIf
              EndIf
              
              
              If \change = 1 : \change = 0
                Protected indent = 8 + Bool(*This\Image\width)*4
                \Text\Y = \Y
                \Image\Y = \Y
                \Text\X = 5+column_x
                \Image\X = 5+Bool(*This\Flag\CheckBoxes)*25
;                 ; Draw coordinates 
              ;   \sublevellen = column_x;+*This\Text\X + (7 - *This\sublevellen) + ((\sublevel + Bool(*This\flag\buttons)) * *This\sublevellen) + Bool(*This\Flag\CheckBoxes)*17
;                 \Image\X + \sublevellen + indent
;                 ;\Text\X + \sublevellen + *This\Image\width + indent
;                 ; Scroll width length
              EndIf
              
              If Drawing
                Height = \Height
                Y = \Y+*This\Scroll\Y
                Text_X = \Text\X+*This\Scroll\X
                Text_Y = \Text\Y+*This\Scroll\Y
              EndIf
            
              ; expanded & collapsed box
              If *This\flag\buttons Or *This\Flag\Lines 
                \box\width = box_size
                \box\height = box_size
                \box\x = \sublevellen-(\box\width)/2+*This\Scroll\X
                \box\y = (Y+height)-(height+\box\height)/2
              EndIf
              
              If *This\Flag\CheckBoxes
                \box\width[1] = check_box_size
                \box\height[1] = check_box_size
                \box\x[1] = (\box\width[1])/2+*This\Scroll\X
                \box\y[1] = (Y+height)-(height+\box\height[1])/2
              EndIf
              
              ; Draw selections
              If Drawing And (\index=*This\Index[1] Or \index=\focus Or \index=\Index[1]) ; \Color\State;
                If *This\Row\Color\Fore[\Color\State]
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,RowForeColor(*This, \Color\State) ,RowBackColor(*This, \Color\State),\Radius)
                Else
                  DrawingMode(#PB_2DDrawing_Default)
                  RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,RowBackColor(*This, \Color\State))
                EndIf
                
                DrawingMode(#PB_2DDrawing_Outlined)
                RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, RowFrameColor(*This, \Color\State))
              EndIf
              
              ; Draw plot
              If *This\sublevellen And *This\Flag\Lines 
                Protected x_point=*This\x+\sublevellen+*This\Scroll\X
                
                If x_point>*This\x[2] 
                  Protected y_point=\box\y+\box\height/2
                  
                  If Drawing
                    ; Horizontal plot
                    DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotX())
                    Line(x_point,y_point,line_size,1, $FF000000)
                  EndIf
                  
                  ; Vertical plot
                  If \handle
                    Protected start = \sublevel
                    
                    ; это нужно если линия уходит за предели границы виджета
                    If \handle[1]
                      PushListPosition(*This\Items())
                      ChangeCurrentElement(*This\Items(), \handle[1]) 
                      ;If \Hide : Drawing = 2 : EndIf
                      PopListPosition(*This\Items())
                    EndIf
                    
                    PushListPosition(*This\Items())
                    ChangeCurrentElement(*This\Items(), \handle) 
                    If Drawing  
                      If start
                        If *This\sublevellen > 10
                          start = (\y+\height+\height/2) + *This\Scroll\Y - line_size
                        Else
                          start = (\y+\height/2) + *This\Scroll\Y
                        EndIf
                      Else 
                        start = (*This\y[2]+\height/2)+*This\Scroll\Y
                      EndIf
                      
                      DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@PlotY())
                      Line(x_point,start,1, (y_point-start), $FF000000)
                    EndIf
                    PopListPosition(*This\Items())
                  EndIf
                EndIf
              EndIf
              
              If Drawing
                If ListIndex(*This\Columns())=0
                  ; Draw boxes
                  If *This\flag\buttons And \childrens
                    DrawingMode(#PB_2DDrawing_Default)
                    CompilerIf Defined(Scroll, #PB_Module)
                      Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, RowFontColor(*This, \Color\State), 0,0) 
                    CompilerEndIf
                  EndIf
                  
                  ; Draw checkbox
                  If *This\Flag\CheckBoxes
                    DrawingMode(#PB_2DDrawing_Default)
                    CheckBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
                  EndIf
                  
                  ; Draw image
                  If \Image\handle
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawAlphaImage(\Image\handle, \Image\x+*This\Scroll\X, \Image\y+*This\Scroll\Y, *This\row\color\alpha)
                  EndIf
                EndIf
                
                ; Draw text
                _clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
                
                ; Draw string
                If \Text[2]\Len > 0 And *This\Color\Front <> *This\Row\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Text\Caret[1] > *This\Text\Caret And *This\Index[2] = *This\Index[1]) Or (*This\Index[2] > *This\Index[1] And *This\Index[1] = \Index)
                    \Text[3]\X = Text_X+TextWidth(Left(\Text\String.s, *This\Text\Caret[1])) 
                    
                    If *This\Index[2] = *This\Index[1]
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawText(\Text[3]\X, Text_Y, \Text[3]\String.s, *This\Color\Front[*This\Color\State])
                    EndIf
                    
                    If *This\Row\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2) )
                    EndIf
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, RowFontColor(*This, 2))
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s, *This\Color\Front[*This\Color\State])
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    DrawText(Text_X, Text_Y, \Text\String.s, *This\Color\Front[*This\Color\State])
                    
                    If *This\Row\Color\Fore[2]
                      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                      BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                    Else
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                    EndIf
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawText(\Text[2]\X+*This\Scroll\X, Text_Y, \Text[2]\String.s, RowFontColor(*This, 2))
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, RowFontColor(*This, 0))
                  EndIf
                  
                  If *This\Row\Color\Fore[2]
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(\Vertical,\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,RowForeColor(*This, 2),RowBackColor(*This, 2),\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                  EndIf
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X+*This\Scroll\X, Text_Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, RowFontColor(*This, 2))
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X+*This\Scroll\X, Text_Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, RowFontColor(*This, 0))
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len > 0
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\Text[2]\X+*This\Scroll\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, RowBackColor(*This, 2))
                EndIf
                
;                 CompilerIf Defined(Scroll, #PB_Module)
;                   Debug ""+*This\Scroll\X +" "+ *This\Scroll\h\page\pos
;                 CompilerEndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, RowFontColor(*This, \Color\State))
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
                EndIf
              EndIf
                
              EndIf
            Next
            PopListPosition(*This\Columns()\Items()) ; 
            
            If *This\Focus = *This 
              ; Debug ""+ \Text\Caret +" "+ \Text\Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
              If (*This\Text\Editable Or \Text\Editable) ;And *This\Text\Caret = *This\Text\Caret[1] And *This\Index[1] = *This\Index[2] And Not \Text[2]\Width[2] 
                DrawingMode(#PB_2DDrawing_XOr)             
                If Bool(Not \Text[1]\Width Or *This\Text\Caret > *This\Text\Caret[1])
                  Line((\Text\X+*This\Scroll\X) + \Text[1]\Width + \Text[2]\Width - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
                Else
                  Line((\Text\X+*This\Scroll\X) + \Text[1]\Width - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
                EndIf
              EndIf
            EndIf
            
            
            If ListIndex(*This\Columns())=0
              ; Columns backcolor
              DrawingMode(#PB_2DDrawing_Gradient)
              BoxGradient(0,*This\x[2], *This\y[2], iwidth, column_height, $FFFFFF,$F4F4F5)
              
              ; Columns bottom line
              DrawingMode(#PB_2DDrawing_Default)
              Box(*This\x[2], *This\y[2]+column_height, iwidth,1,$ADADAE)
            EndIf
            
            ; Vertical line
            If *This\Flag\GridLines
              DrawingMode(#PB_2DDrawing_Default)
              Box(column_x, *This\bSize, l, iheight, $FFADADAE)
              Box(column_x+*This\Columns()\width, *This\bSize, l, iheight, $FFADADAE)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box(column_x, *This\bSize, l, column_height, $FFADADAE)
              Box(column_x+*This\Columns()\width, *This\bSize, l, column_height, $FFADADAE)
            EndIf
            
            ; Draw columns string
            If *This\Columns()\text\string.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawText(*This\Columns()\text\x, *This\Columns()\text\y, *This\Columns()\text\string.s, $FF000000)
            EndIf
            
          Next
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(\Columns()\Items())
          ; Draw scroll bars
          CompilerIf Defined(Scroll, #PB_Module)
            Scroll::Draws(\Scroll, \Scroll\Height, \Scroll\Width)
          CompilerEndIf
          
          _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
          
          ; Draw image
          If \Image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \color\alpha)
          EndIf
        EndIf
        
        ; Draw frames
        DrawingMode(#PB_2DDrawing_Outlined)
        
        If \Focus = *This
          RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[2])
          If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,\Color\Frame[2]) : EndIf  ; Сглаживание краев )))
          RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,\Color\Frame[2])
        ElseIf \fSize
          Select \fSize[1] 
            Case 1 ; Flat
              RoundBox(iX-1,iY-1,iWidth+2,iHeight+2,\Radius,\Radius, $FFE1E1E1)  
              
            Case 2 ; Single
                   ;               Line(iX-1,iY-1,iWidth+2,1, $FF9E9E9E)
                   ;               Line(iX-1,iY-1,1,iHeight+2, $FF9E9E9E)
                   ;               Line(iX-1,(iY+iHeight),iWidth+2,1, $FFFFFFFF)
                   ;               Line((iX+iWidth),iY-1,1,iHeight+2, $FFFFFFFF)
              
              _frame_(*This, iX,iY,iWidth,iHeight, $FFE1E1E1, $FFFFFFFF)
              
            Case 3 ; Double
                   ;               Line(iX-2,iY-2,iWidth+4,1, $FF9E9E9E)
                   ;               Line(iX-2,iY-2,1,iHeight+4, $FF9E9E9E)
                   ;               
                   ;               Line(iX-1,iY-1,iWidth+2,1, $FF888888)
                   ;               Line(iX-1,iY-1,1,iHeight+2, $FF888888)
                   ;               Line(iX-1,(iY+iHeight),iWidth+2,1, $FFE1E1E1)
                   ;               Line((iX+iWidth),iY-1,1,iHeight+2, $FFE1E1E1)
                   ;               
                   ;               Line(iX-2,(iY+iHeight)+1,iWidth+4,1, $FFFFFFFF)
                   ;               Line((iX+iWidth)+1,iY-2,1,iHeight+4, $FFFFFFFF)
              
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FF888888, $FFFFFFFF)
              If \Radius : RoundBox(iX-1,iY-1-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-2,iY-1-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF888888) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FF888888, $FFE1E1E1)
              
            Case 4 ; Raised
                   ;               Line(iX-2,iY-2,iWidth+4,1, $FFE1E1E1)
                   ;               Line(iX-2,iY-2,1,iHeight+4, $FFE1E1E1)
                   ;               
                   ;               Line(iX-1,iY-1,iWidth+2,1, $FFFFFFFF)
                   ;               Line(iX-1,iY-1,1,iHeight+2, $FFFFFFFF)
                   ;               Line(iX-1,(iY+iHeight),iWidth+2,1, $FF9E9E9E)
                   ;               Line((iX+iWidth),iY-1,1,iHeight+2, $FF9E9E9E)
                   ;               
                   ;               Line(iX-2,(iY+iHeight)+1,iWidth+4,1, $FF888888)
                   ;               Line((iX+iWidth)+1,iY-2,1,iHeight+4, $FF888888)
              
              _frame_(*This, iX-1,iY-1,iWidth+2,iHeight+2, $FFE1E1E1, $FF9E9E9E)
              If \Radius : RoundBox(iX-1,iY-1,iWidth+3,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              If \Radius : RoundBox(iX-1,iY-1,iWidth+2,iHeight+2+1,\Radius,\Radius,$FF9E9E9E) : EndIf  ; Сглаживание краев )))
              _frame_(*This, iX,iY,iWidth,iHeight, $FFFFFFFF, $FF888888)
              
              
            Default 
              RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,\Color\Frame[\Color\State])
              
          EndSelect
        EndIf
        
        If \Default
          ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius : RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF) : EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
          Else
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
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
    
    If *This
      If *This\Text\FontID : DrawingFont(*This\Text\FontID) : EndIf
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\bSize, *This\bSize, *This\width[2], *This\height[2], back_color)
      
      With *This\Columns()\Items()
        If *This\image\width
          n=19
          column_x = *This\bSize+(n*(1+Bool(*This\flag\CheckBoxes))) + 4
        EndIf
        column_x - *This\Scroll\h\page\Pos
        column_width = column_x
        *This\Scroll\v\page\ScrollStep = height+Bool(*This\flag\GridLines)*2+l
        
        ForEach *This\Columns()
          ;If ListSize(*This\Columns()\Items())
          column_height = *This\Columns()\height
          ;*This\Scroll\Width=*This\bSize
          *This\Scroll\height=*This\bSize+column_height
          *This\Columns()\x=column_width ; + 20;*This\Columns()\Image\width
          iWidth = *This\Columns()\x + *This\Columns()\width
          iWidth = *This\width[2]-Scroll::Width(*This\Scroll\v)
          iHeight = *This\height[2]-Scroll::Height(*This\Scroll\h)
          
          
          CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
            ClipOutput(*This\bSize, *This\bSize, *This\width[2], iHeight)
          CompilerEndIf
          
          If *This\Columns()\text\change = 1
            *This\Columns()\text\height = TextHeight("A") 
            *This\Columns()\text\width = TextWidth(*This\Columns()\text\string.s)
            *This\Columns()\text\change = 0
          EndIf
          
          *This\Columns()\text\x = 5+*This\Columns()\x
          *This\Columns()\text\y = *This\Columns()\y+(column_height+2-*This\Columns()\text\height)/2
          
          ;Drawing = Bool(\y+\height>*This\bSize+*This\Columns()\height And \y<*This\height[2])
          
          PushListPosition(*This\Items())
          ForEach *This\Columns()\Items()
            If Not \hide
              CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                ClipOutput(*This\bSize, *This\bSize+column_height, iwidth, iHeight) ; Bug
              CompilerEndIf
              
              
              \x=*This\bSize+*This\Columns()\x-column_x; ;
              \width=iwidth
              \height=height
              \y=*This\Scroll\height-*This\Scroll\v\page\Pos
              
              If \text\change = 1
                \text\height = TextHeight("A") 
                \text\width = TextWidth(\text\string.s)
                \text\change = 0
              EndIf
              
              If *This\flag\buttons 
                x_content=*This\bSize+column_width-column_x+2+(w+\sublevel*w)-*This\Scroll\h\page\Pos
              Else
                x_content=*This\bSize+column_width-column_x+2+(\sublevel*w)-*This\Scroll\h\page\Pos
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
                \text\x = 1+x_content+*This\Columns()\Image\width+Bool(*This\Flag\CheckBoxes)
                \text\y = \y+(\height-\text\height)/2
              EndIf
              
              If *This\Flag\CheckBoxes
                \box\x+n-2
                \text\x+n-2
                \Image\x+n-2
                
                \box\width[1] = box_1_size
                \box\height[1] = box_1_size
                
                \box\x[1] = *This\bSize+4
                \box\y[1] = \y+(\height-\box\height[1])/2
              EndIf
              
              *This\Scroll\height+\height+l+Bool(*This\Flag\GridLines)*2
;               If *This\Scroll\Width < (\text\x+\text\width+n)+*This\Scroll\h\page\Pos
;                 *This\Scroll\Width = (\text\x+\text\width+n)+*This\Scroll\h\page\Pos
;               EndIf
              
              Drawing = Bool(\y+\height>*This\bSize+*This\Columns()\height And \y<*This\height[2])
              If Drawing
                If (\index=\focus And \lostfocus<>\focus) Or
                   (*This\focus And *This\Flag\FullSelection And *This\Index[1] = \Index )
                  
                  box_color = $FFFFFF
                  text_color=$FFFFFF
                Else
                  box_color = $7E7E7E
                  text_color=$000000
                EndIf
                
                
                ; Draw selections
                If \index=\Index[1] Or \index=\focus ; \index=*This\Index[1] ; с этим остается последное виделеное слово
                  Protected SelectionPos, SelectionLen 
                  If *This\Flag\FullSelection
                    SelectionPos = *This\bSize
                    SelectionLen = iwidth
                  Else
                    SelectionPos = \Text\X - 2
                    SelectionLen = \Text\width + 4
                  EndIf
                  
                  ; Draw items back color
                  If *This\row\Color\Fore
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(\Vertical,SelectionPos,\Y,SelectionLen,\Height,*This\row\Color\Fore[\Color\State],*This\row\Color\Back[\Color\State],\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    RoundBox(SelectionPos,\Y,SelectionLen,\Height,\Radius,\Radius,*This\row\Color\Back[\Color\State])
                  EndIf
                  ;Debug Point(\x+2,\y+2)
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(SelectionPos,\y,SelectionLen,\height, *This\row\Color\Frame[\Color\State])
                EndIf
                
                ; Draw boxes
                If *This\flag\buttons And \childrens
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, box_color&$FFFFFF|alpha<<24, 0,0) 
                EndIf
              EndIf
              
              
              If Drawing
                If ListIndex(*This\Columns())=0
                  ; Draw checkbox
                  If *This\Flag\CheckBoxes
                    CheckBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, checkbox_color, box_color, 2, alpha);, box_type)
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
                    ClipOutput(*This\Columns()\x, *This\bSize+column_height, *This\Columns()\width, iHeight)
                  CompilerEndIf
                  
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawText(\text\x, \text\y, \text\string.s, text_color&$FFFFFF|alpha<<24)
                  
                  CompilerIf #PB_Compiler_OS <> #PB_OS_MacOS
                    UnclipOutput()
                  CompilerEndIf
                EndIf
                
                If *This\Flag\GridLines
                  ; Horizontal line
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(*This\bSize, (\y+\height)+l, iwidth, l, $ADADAE&$FFFFFF|alpha<<24)
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
          ; Box(*This\bSize, 0, iwidth, column_height+3, back_color)
          ; Draw
          DrawingMode(#PB_2DDrawing_Gradient)
          ;BoxGradient(0,*This\Columns()\x+1, 0, *This\Columns()\width-1, column_height, $FFFFFF,$F4F4F5)
          
          If ListIndex(*This\Columns())=0
            DrawingMode(#PB_2DDrawing_Gradient)
            BoxGradient(0,*This\bSize, 0, iwidth, column_height, $FFFFFF,$F4F4F5)
          EndIf
          
          DrawingMode(#PB_2DDrawing_Default)
          Box(*This\Columns()\x-column_x, column_height, iwidth,1,$ADADAE)
          
          
          ; Vertical line
          If *This\Flag\GridLines
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(column_x, *This\bSize, l, iheight, $ADADAE&$FFFFFF|alpha<<24)
            Box(*This\Columns()\x+*This\Columns()\width, *This\bSize, l, iheight, $ADADAE&$FFFFFF|alpha<<24)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(column_x, *This\bSize, l, column_height, $ADADAE&$FFFFFF|alpha<<24)
            Box(*This\Columns()\x+*This\Columns()\width, *This\bSize, l, column_height, $ADADAE&$FFFFFF|alpha<<24)
          EndIf
          
          If *This\Columns()\text\string.s
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(*This\Columns()\text\x, *This\Columns()\text\y, *This\Columns()\text\string.s, $000000&$FFFFFF|alpha<<24)
          EndIf
          
          If *This\bSize
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(*This\bSize-1, *This\Columns()\height+1, *This\width[2]+2, 1, $FFFFFF)
          EndIf
          
          column_width + *This\Columns()\width
          ;EndIf
        Next
        
        *This\Scroll\Height = *This\Scroll\Height-l-Bool(*This\Flag\GridLines)*2
        
        ; Задаем размеры скролл баров
        CompilerIf Defined(Scroll, #PB_Module)
            Scroll::Draws(*This\Scroll, *This\Scroll\Height, *This\Scroll\Width)
          CompilerEndIf
          
        If *This\fSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box((*This\bSize-*This\fSize), (*This\bSize-*This\fSize), *This\width[1], *This\height[1], $ADADAE)
        EndIf
        
        If *This\bSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(*This\bSize-1, *This\bSize-1, *This\width[2]+2, *This\height[2]+2, $FFFFFF)
        EndIf
        
        
      EndWith
    EndIf
  EndProcedure
  
  Procedure ReDraw(*This.Widget_S)
    If *This And StartDrawing(CanvasOutput(*This\Canvas\Gadget))
      Draw(*This)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i AddColumn(*This.Widget_S, Position.i, Text.s, Width.i, Image.i=-1)
    
    With *This
      LastElement(\Columns())
      AddElement(\Columns()) 
      \Columns() = AllocateStructure(Widget_S)
        
;       Position = ListIndex(\Columns())
      
      \Columns()\text\string.s = Text.s
      \Columns()\text\change = 1
      \Columns()\x = \scroll\width
      \Columns()\width = Width
      \Columns()\height = 24
      \scroll\width + Width
      \Scroll\height = \bSize*2+\Columns()\height
      ;      ; ReDraw(*This)
;       If Position = 0
;      ;   PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
;       EndIf
    EndWith
  EndProcedure
  
  Procedure AddItem(*This.Widget_S,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static adress.i
    Protected Childrens.i, hide.b, height.i
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      height = 16
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      height = 20
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      height = 18
    CompilerEndIf
    
    If Not *This
      ProcedureReturn -1
    EndIf
    
    With *This
      ForEach \Columns()
        
        Editor::AddItem(\Columns(),Item.i,Text.s,Image.i,sublevel.i)
        \Columns()\Items()\text\string.s = StringField(Text.s, ListIndex(\Columns()) + 1, #LF$)
        \Columns()\row\Color = Colors
        \Columns()\row\Color\Fore[0] = 0 
        \Columns()\row\Color\Fore[1] = 0
        \Columns()\row\Color\Fore[2] = 0
        
        \Columns()\Items()\Y = \Scroll\height
        \Columns()\Items()\height = height
        \Columns()\Items()\change = 1
        
        \image\width = \Columns()\Items()\image\width
        If ListIndex(\Columns()\Items()) = 0
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        EndIf
      Next
      
       \Scroll\height + height
     EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure ClearItems(*This.Widget_S)
    Protected Result.i
    
    If *This
      With *This
        Result = ClearList(\Columns()\Items())
        \Scroll\v\hide = 1
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure CountItems(*This.Widget_S, Item.i=-1)
    Protected Result.i, sublevel.i
    
    If *This
      With *This
        If Item.i=-1
          Result = ListSize(\Columns()\Items())
        Else
          PushListPosition(\Items()) 
          ForEach \Items()
            If \Items()\Index = Item 
              ; Result = \Items()\childrens 
              sublevel = \Items()\sublevel
              
              PushListPosition(\Items())
              While NextElement(\Items())
                If \Items()\sublevel > sublevel 
                  Result + 1
                Else
                  Break
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
  
  Procedure RemoveItem(*This.Widget_S, Item.i)
    Protected Result.i, sublevel.i
    
    If *This
      With *This
        ;PushListPosition(\Columns()\Items()) 
        ForEach \Columns()\Items()
          If \Columns()\Items()\Index = Item 
            Result = DeleteElement(\Columns()\Items(), 1) 
            Break
          EndIf
        Next
        ;PopListPosition(\Columns()\Items())
        
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        ;ReDraw(*This)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemAttribute(Gadget.i, Item.i, Attribute.i)
    Protected Result.i, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Index = Item 
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
  
  Procedure GetItemData(Gadget.i, Item.i)
    Protected Result.i, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Index = Item 
            Result = \Items()\data
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemData(Gadget.i, Item.i, *data)
    Protected Result.i, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Index = Item 
            \Items()\data = *data
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemColor(Gadget.i, Item.i, ColorType.i, Column.i=0)
    Protected Result.i, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Index = Item 
            
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemColor(Gadget.i, Item.i, ColorType.i, Color.i, Column.i=0)
    Protected Result.i, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Index = Item 
            
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemImage(Gadget.i, Item.i)
    Protected Result.i, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Index = Item 
            Result = \Items()\Image
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemImage(Gadget.i, Item.i, image.i)
    Protected Result.i, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Index = Item And IsImage(image)
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
  
  Procedure SetState(Gadget.i, Item.i)
    Protected Result.i, *This.Widget_S, lostfocus.i=-1, collapsed.i, sublevel.i, adress.i, coll.i
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\Index[1] = \Items()\Index 
            \Items()\Index[1] =- 1
            Result = @\Items()
            Break
          EndIf
        Next
        
        ForEach \Items()
          If \Items()\Index = \Items()\focus
            \Items()\lostfocus = \Items()\focus
            If Item =- 1 : \Items()\focus =- 1 : EndIf
            Result = @\Items()
            Break
          EndIf
        Next
        
        If Item <>- 1
          ForEach \Items()
            If \Items()\hide : Continue : EndIf
            If \Items()\Index = Item
              
              If Result 
                PushListPosition(\Items()) 
                ChangeCurrentElement(\Items(), Result)
                If \Items()\focus = \Items()\Index
                  lostfocus = \Items()\focus 
                  \Items()\lostfocus =- 1
                  \Items()\focus =- 1
                EndIf
                PopListPosition(\Items()) 
                If lostfocus <> \Items()\Index
                  \Items()\lostfocus = lostfocus
                EndIf
              EndIf
              
              \Items()\focus = \Items()\Index
              \Items()\Index[1] = \Items()\Index
              
              If GetActiveGadget()<>Gadget
                \Items()\lostfocus = \Items()\focus
                \Items()\Index[1] =- 1
              EndIf
              
              Result = @\Items()
              Break
              
            EndIf
          Next
        EndIf
        PopListPosition(\Items())
        
        ReDraw(*This)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected Result.i, *This.Widget_S 
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This 
      With *This
        Result = \index
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemState(Gadget.i, Item.i, State.i)
    Protected Result.i, *This.Widget_S, lostfocus.i=-1, collapsed.i, sublevel.i, adress.i, coll.i
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Index = Item
            If State&#PB_Attribute_Selected
              \Items()\focus = \Items()\Index
              
              If GetActiveGadget()<>Gadget
                \Items()\lostfocus = \Items()\focus
                \Items()\Index[1] =- 1
              EndIf
              
            EndIf
            If State&#PB_Attribute_Checked
              \Items()\checked = 1
            EndIf
            If State&#PB_Attribute_Collapsed Or State&#PB_Attribute_Expanded
              \Items()\collapsed = Bool(State&#PB_Attribute_Collapsed)
              
              sublevel = \Items()\sublevel
              
              PushListPosition(\Items())
              While NextElement(\Items())
                If sublevel = \Items()\sublevel
                  Break
                ElseIf sublevel < \Items()\sublevel 
                  If State&#PB_Attribute_Collapsed
                    \Items()\hide = 1
                  ElseIf State&#PB_Attribute_Expanded
                    \Items()\hide = 0
                  EndIf
                EndIf
              Wend
            EndIf
            Break
          EndIf
        Next
        PopListPosition(\Items())
        
        ReDraw(*This)
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure GetItemState(Gadget.i, Item.i)
    Protected Result.i, *This.Widget_S, lostfocus.i=-1, collapsed.i, sublevel.i, adress.i, coll.i
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Index = Item
            Result = #PB_Attribute_Selected
            If \Items()\collapsed
              Result | #PB_Attribute_Collapsed
            Else
              Result | #PB_Attribute_Expanded
            EndIf
            If \Items()\checked
              Result | #PB_Attribute_Checked
            EndIf
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetText(Gadget.i)
    Protected Result.s, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Index = \Items()\focus
            Result = \Items()\text\string
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf  
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetText(Gadget.i, Text.s)
    Protected Result.i, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Index = \Items()\focus
            \Items()\text\string = Text
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(Gadget.i, Item.i)
    Protected Result.s, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Index = Item
            Result = \Items()\text\string
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetItemText(Gadget.i, Item.i, Text.s)
    Protected Result.i, *This.Widget_S
    If IsGadget(Gadget) : *This.Widget_S = GetGadgetData(Gadget) : EndIf
    
    If *This
      With *This
        PushListPosition(\Items()) 
        ForEach \Items()
          If \Items()\hide : Continue : EndIf
          If \Items()\Index = Item
            \Items()\text\string = Text
            Break
          EndIf
        Next
        PopListPosition(\Items())
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  Procedure ToolTip(*This.Text_S=0, ColorFont=0, ColorBack=0, ColorFrame=$FF)
    Protected Gadget
    Static Window
    Protected Color.Color_S = Colors
    With *This
      If *This
        ; Debug "show tooltip "+\string
;         If Not Window
; ;         Window = OpenWindow(#PB_Any, \x[1]-3,\y[1],\width+8,\height[1], "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Tool) ;|#PB_Window_NoGadgets
; ;         Gadget = CanvasGadget(#PB_Any,0,0,\width+8,\height[1])
; ;         If StartDrawing(CanvasOutput(Gadget))
; ;           If \FontID : DrawingFont(\FontID) : EndIf 
; ;           DrawingMode(#PB_2DDrawing_Default)
; ;           Box(1,1,\width-2+8,\height[1]-2, Color\Back[1])
; ;           DrawingMode(#PB_2DDrawing_Transparent)
; ;           DrawText(3, (\height[1]-\height)/2, \String, Color\Front[1])
; ;           DrawingMode(#PB_2DDrawing_Outlined)
; ;           Box(0,0,\width+8,\height[1], Color\Frame[1])
; ;           StopDrawing()
; ;         EndIf
        
        Window = OpenWindow(#PB_Any, \x[1]-3,\y[1],\width+8,\height[1], "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Tool) ;|#PB_Window_NoGadgets
        SetGadgetColor(ContainerGadget(#PB_Any,1,1,\width-2+8,\height[1]-2), #PB_Gadget_BackColor, Color\Back[1])
        Gadget = StringGadget(#PB_Any,0,(\height[1]-\height)/2-1,\width-2+8,\height[1]-2, \string, #PB_String_BorderLess)
        SetGadgetColor(Gadget, #PB_Gadget_BackColor, Color\Back[1])
        SetWindowColor(Window, Color\Frame[1])
        SetGadgetFont(Gadget, \FontID)
        CloseGadgetList()
        
        
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
  
  Procedure item_from(*This.Widget_S, MouseX=-1, MouseY=-1, focus=0)
    Protected lostfocus.i=-1, collapsed.i, sublevel.i, adress.i, coll.i
    
    With *This\Columns()
      ;PushListPosition(\Items()) 
      ForEach *This\Columns()
        ForEach \Items()
          If \Items()\Index[1] = \Items()\Index 
            \Items()\Index[1] =- 1
            adress = @\Items()
            Break
          EndIf
        Next
      Next
      
      ForEach *This\Columns()
        ForEach \Items()
          If \Items()\Index = \Items()\focus
            If Bool(MouseX=-1 And MouseY=-1 And focus=1)
              \Items()\lostfocus = \Items()\focus
              *This\focus = 0
              
              ; then lost focus widget
              \Row\Color\State = 0
              
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
              
              If (\flag\buttons And \Items()\childrens) And
                 (MouseY > (\Items()\box\y[0]) And MouseY =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                 ((MouseX > \Items()\box\x[0]) And (MouseX =< (\Items()\box\x[0]+\Items()\box\width[0])))
                
                sublevel = \Items()\sublevel
                \Items()\collapsed ! 1
                
                PushListPosition(\Items())
                While NextElement(\Items())
                  If sublevel = \Items()\sublevel
                    Break
                  ElseIf sublevel < \Items()\sublevel 
                    If \Items()\handle
                      PushListPosition(\Items())
                      ChangeCurrentElement(\Items(), \Items()\handle)
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
                If Not *This\flag\FullSelection And
                   ((MouseX < \Items()\text\x-*This\Image\width) Or (MouseX > \Items()\text\x+\Items()\text\width))
                  Break
                EndIf
                
                If adress 
                  PushListPosition(\Items()) 
                  ChangeCurrentElement(\Items(), adress)
                  If \Items()\focus = \Items()\Index
                    lostfocus = \Items()\focus 
                    \Items()\lostfocus =- 1
                    \Items()\focus =- 1
                  EndIf
                  PopListPosition(\Items()) 
                  If lostfocus <> \Items()\Index
                    \Items()\lostfocus = lostfocus
                    *This\index[1] = \Items()\Index
                    *This\Change = 1
                  EndIf
                EndIf
                
                \Items()\focus = \Items()\Index
              EndIf
              
            EndIf
            
            If \Items()\Index[1] <> \Items()\Index 
              \Items()\Index[1] = \Items()\Index
              *This\Index[1] = \Items()\Index[1]
              ; *This\text = \Items()\text 
              
              
              If \Items()\lostfocus <> \Items()\Index
                \Row\Color\State = 1+Bool(\Items()\Index=\Items()\focus)
              EndIf
              
            EndIf
            
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
  
  Procedure get_from(*This.Widget_S, MouseX=-1, MouseY=-1, focus=0)
    Protected adress.i
    Protected lostfocus.i=-1, collapsed.i, sublevel.i
    Protected Buttons, Line.i =- 1
    
    With *This\Columns()
      ; PushListPosition(\Items()) 
      ForEach *This\Columns()
        ForEach \Items()
          If \Items()\Index[1] = \Items()\Index 
            \Items()\Index[1] =- 1
            adress = @\Items()
            Line =- 1; \Items()\Index 
            Break
          EndIf
        Next
      Next
      
      ForEach *This\Columns()
        ForEach \Items()
          If \Items()\Index = \Items()\focus
            If Bool(MouseX=-1 And MouseY=-1 And focus=1)
              \Items()\lostfocus = \Items()\focus
              *This\focus = 0
              
              ; then lost focus widget
              \Row\Color\State = 0
              
            EndIf
            
            adress = @\Items()
            Line =- 1 ; \Items()\Index 
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
              
              If (*This\flag\buttons And \Items()\childrens) And
                 (MouseY > (\Items()\box\y[0]) And MouseY =< ((\Items()\box\y[0]+\Items()\box\height[0]))) And 
                 ((MouseX > \Items()\box\x[0]) And (MouseX =< (\Items()\box\x[0]+\Items()\box\width[0])))
                
                sublevel = \Items()\sublevel
                \Items()\collapsed ! 1
                Protected Height = \Items()\Y+\Items()\Height, Y=Height
                
                PushListPosition(\Items())
                While NextElement(\Items())
                  If \Items()\sublevel > sublevel 
                    If \Items()\handle
                      PushListPosition(\Items())
                      ChangeCurrentElement(\Items(), \Items()\handle)
                      collapsed = \Items()\collapsed
                      collapsed | \Items()\hide
                      PopListPosition(\Items())
                    EndIf
                    \Items()\hide = collapsed
                    
                    If \Items()\hide
                      \Scroll\Height - \Items()\Height
                    Else
                      Height = \Items()\Y+\Items()\Height
                      If Not \Items()\Height
                        \Items()\Height = \Text\Height
                        \Items()\Text\Height = \Text\Height[1]
                      EndIf
                      \Items()\Y = Y
                      \Items()\Text\Y = \Items()\Y + (\Items()\Height-\Items()\Text\Height)/2
                      \Items()\Image\Y = \Items()\Y + (\Items()\Height-\Items()\Image\Height)/2
                      Y + \Items()\Height
                      *This\Scroll\Height + \Items()\Height
                    EndIf
                  Else
                    PushListPosition(\Items())
                    Repeat
                      If Not \Items()\hide
                        \Items()\Y = Height
                        \Items()\Text\Y = \Items()\Y + (\Items()\Height-\Items()\Text\Height)/2
                        \Items()\Image\Y = \Items()\Y + (\Items()\Height-\Items()\Image\Height)/2
                        Height + \Items()\Height
                      EndIf
                    Until Not NextElement(\Items())
                    PopListPosition(\Items())
                    *This\Scroll\Width = 0
                    *This\Scroll\Height = Height
                    PushListPosition(\Items())
                    ForEach \Items()
                      _set_scroll_width_(*This)
                    Next
                    PopListPosition(\Items())
                    
                    Break
                  EndIf
                Wend
                PopListPosition(\Items())
                
              Else
                ; Get entered item only on image and text 
                If Not *This\Flag\FullSelection And
                   ((MouseX < \Items()\text\x-*This\Image\width) Or (MouseX > \Items()\text\x+\Items()\text\width))
                  Break
                EndIf
                
                If adress 
                  PushListPosition(\Items()) 
                  ChangeCurrentElement(\Items(), adress)
                  If \Items()\focus = \Items()\Index
                    lostfocus = \Items()\focus 
                    \Row\Color\State = 1
                    \Items()\lostfocus =- 1
                    \Items()\focus =- 1
                  EndIf
                  PopListPosition(\Items()) 
                EndIf
                
                If lostfocus <> \Items()\Index
                  \Items()\lostfocus = lostfocus
                  *This\Index[1] = \Items()\Index
                  *This\Change = 1
                EndIf
                
                \Row\Color\State = 2
                \Items()\focus = \Items()\Index
              EndIf
            EndIf
            
            
            adress = @\Items()
            Line = \Items()\Index 
            
            If \Items()\Index[1] <> \Items()\Index 
              \Items()\Index[1] = \Items()\Index
;               *This\Index[1] = \Items()\Index[1]
;               *This\text = \Items()\text 
              
              
              If \Items()\lostfocus <> \Items()\Index
                \Row\Color\State = 1+Bool(\Items()\Index=\Items()\focus)
              EndIf
              
            EndIf
            
            Break
          EndIf
        Next
        ; Next
      EndIf
      ; PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Line
  EndProcedure
  
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i)
    With *This
      If Text::Resize(*This, X,Y,Width,Height)
        Scroll::Resizes(\Scroll, \x[2],\Y[2],\Width[2],\Height[2])
      EndIf
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.i Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\Scroll\v, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      Repaint | Scroll::CallBack(\Scroll\h, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
    EndWith
    
    If *This And (Not *This\Scroll\v\at And Not *This\Scroll\h\at)
      If ListSize(*This\Columns()\items())
        FirstElement(*This\Columns())
        With *This\Columns()
          If Not *This\Hide And Not *This\Disable And *This\Interact
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
                  
            Select EventType 
              Case #PB_EventType_LostFocus 
                ; \Focus =- 1
;                 \Index[1] =- 1
                ; \Items()\Focus =- 1
;                 \Items()\Index[1] = \Items()\Index
               itemSelect(*This\Index[2], \Items())
                Debug "  LostFocus   "+*This\Index[2]+" "+\Items()\Text\String 
               \Row\Color\State = 0
                Repaint = #True
                PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
                
              Case #PB_EventType_Focus 
                itemSelect(*This\Index[2], \Items())
                Debug "  Focus   "+*This\Index[2]+" "+\Items()\Text\String 
                \Items()\Index[1] = \Items()\Index
                \Row\Color\State = 2
                Repaint = #True
                PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
               
              Case #PB_EventType_LeftClick 
                If *This\change : *This\change = 0 
                  PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Change) 
                EndIf
                PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_LeftClick)
                
              Case #PB_EventType_RightClick : PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_RightClick)
              Case #PB_EventType_LeftDoubleClick : PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_LeftDoubleClick)
                
              Case #PB_EventType_MouseLeave
                If *This\ToolTip 
                  ; Debug ""+DesktopMouseY()+" "+Str(\ToolTip\Y+\ToolTip\Height)
                  If Bool(DesktopMouseY() > (*This\ToolTip\Y[1]) And DesktopMouseY() =< ((*This\ToolTip\Y[1]+*This\ToolTip\Height[1]))) And 
                     ((DesktopMouseX() > *This\ToolTip\X[1]) And (DesktopMouseX() =< (*This\ToolTip\X[1]+*This\ToolTip\Width)))
                    
                  Else
                    ;Debug 77777
                    ToolTip(0)
                    *This\Index[1] =- 1
                  EndIf
                Else
                  *This\Index[1] =- 1
                EndIf
                
              Case #PB_EventType_LeftButtonUp : *This\Drag[1] = 0
                Repaint = 1
                    
              Case #PB_EventType_LeftButtonDown
                *This\Index[1] = get_from(*This, *This\Canvas\Mouse\X, *This\Canvas\Mouse\Y, 1) : *This\Index[2] = *This\Index[1]
                Repaint = 1
                
              Case #PB_EventType_MouseMove  
                Protected from = *This\Index[1]
                Protected Line = get_from(*This, *This\Canvas\Mouse\X, *This\Canvas\Mouse\Y)
                
                If *This\Index[1]<>Line : *This\Index[1]=Line
                 If *This\Scroll\h\hide And from <> *This\Index[1]
                  itemSelect(*This\Index[1], \Items())
                  If \Items()\text\x+\Items()\text\width>\Items()\width
                    If *This\ToolTip : ToolTip(0) : EndIf
                    *This\ToolTip = \Items()\text
                    *This\tooltip\x[1]=\Items()\text\x+GadgetX(*This\canvas\gadget, #PB_Gadget_ScreenCoordinate)+*This\Scroll\X
                    *This\tooltip\y[1]=\Items()\y+GadgetY(*This\canvas\gadget, #PB_Gadget_ScreenCoordinate)+*This\Scroll\Y
                    *This\tooltip\width[1]=\Items()\width
                    *This\tooltip\height[1]=\Items()\height
                    ToolTip(*This\ToolTip)
                  ElseIf *This\ToolTip : *This\ToolTip = 0
                    ToolTip(0)
                  EndIf
                  from = *This\Index[1]
                EndIf
                
                If *This\Drag And *This\Drag[1] = 0 : *This\Drag[1] = 1
                  If *This\change : *This\change = 0 
                    PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Change) 
                  EndIf
                  PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_DragStart)
                EndIf
                
                Repaint = 1
              EndIf
              
              Default
                itemSelect(*This\Index[2], \Items())
            EndSelect
          EndIf
        EndWith    
        
        With *This\Columns()\items()
          If *Focus = *This
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType
              Case #PB_EventType_KeyUp
              Case #PB_EventType_KeyDown
                Select *This\Canvas\Key
                  Case #PB_Shortcut_V
                EndSelect 
                
            EndSelect
          EndIf
          
          
        EndWith
      EndIf
    Else
      *This\Index[1] =- 1
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, ColumnTitle.s, ColumnWidth.i, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_ListIcon
        \Cursor = #PB_Cursor_Default
        ;\DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \sublevellen = 18
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
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)*2
        \bSize = \fSize
        
        If Text::Resize(*This, X,Y,Width,Height)
          \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
          \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
          \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
          \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
          \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
          
           \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
           \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
           \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
          
          \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          
          If Bool(Flag&#PB_Text_WordWrap)
            \Text\MultiLine = 1
          ElseIf Bool(Flag&#PB_Text_MultiLine)
            \Text\MultiLine = 2
          Else
            \Text\MultiLine =- 1
          EndIf
          
          \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
          \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
          \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
          \Text\Pass = Bool(Flag&#PB_Text_Password)
          
          ;\Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
          ;\Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
          ;\Text\Align\Right = Bool(Flag&#PB_Text_Right)
          ;\Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
          
          ;           CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          ;             If \Text\Vertical
          ;               \Text\X = \fSize 
          ;               \Text\y = \fSize+5
          ;             Else
          ;               \Text\X = \fSize+5
          ;               \Text\y = \fSize
          ;             EndIf
          ;           CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
          ;             If \Text\Vertical
          ;               \Text\X = \fSize 
          ;               \Text\y = \fSize+1
          ;             Else
          \Text\X = \fSize+2
          \Text\y = \fSize
          ;             EndIf
          ;           CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
          ;             If \Text\Vertical
          ;               \Text\X = \fSize 
          ;               \Text\y = \fSize+6
          ;             Else
          ;               \Text\X = \fSize+6
          ;               \Text\y = \fSize
          ;             EndIf
          ;           CompilerEndIf 
          
          \Text\Change = 1
          \Color = Colors
          \Color\Fore[0] = 0
          
          \Row\Color = Colors
          \Row\Color\Fore[0] = 0
          
          If \Text\Editable
            \Text\Editable = 0
            \Color\Back[0] = $FFFFFFFF 
          Else
            \Color\Back[0] = $FFF0F0F0  
          EndIf
        EndIf
        
;         Scroll::Widget(\Scroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
;         Scroll::Widget(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        ; create scrollbars
        Scroll::Bars(\Scroll, 16, 7, 1) ; Bool(Not Bool(Not \flag\buttons And Not \flag\Lines)))
        Scroll::Resizes(\Scroll, \bSize,\bSize,\Width[2],\Height[2])
       
        AddColumn(*This, 0,ColumnTitle, ColumnWidth)
        \Resize = 0
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, ColumnTitle.s, ColumnWidth.i, Flag.i=0, Radius.i=0)
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, ColumnTitle.s, Flag, Radius)
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Canvas_CallBack()
    Protected Repaint.i, AutoHide.b
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
;         \Canvas\Mouse\X = MouseX
;         \Canvas\Mouse\Y = MouseY
;         \Canvas\Mouse\Buttons = Buttons
        
        If Not \hide
          AutoHide.b = 0; Bool(\Scroll\v\buttons=0 And \Scroll\h\buttons=0)
          
          If \Scroll\v
            Repaint = Scroll::CallBack(\Scroll\v, Event, MouseX, MouseY);, WheelDelta, AutoHide, \Scroll\h, Window, Canvas)
            If Repaint
              ReDraw(*This)
            EndIf
          EndIf
          
          If \Scroll\h
            Repaint = Scroll::CallBack(\Scroll\h, Event, MouseX, MouseY);, WheelDelta, AutoHide, \Scroll\v, Window, Canvas)
            If Repaint
              ReDraw(*This)
            EndIf
          EndIf
          
          If Not (\Scroll\v\at Or \Scroll\h\at)
            Select Event
              Case #PB_EventType_MouseWheel
                If Not \Scroll\v\hide
                  Select -WheelDelta
                    Case-1 : Repaint = Scroll::SetState(\Scroll\v, \Scroll\v\page\Pos - (\Scroll\v\max-\Scroll\v\min)/30)
                    Case 1 : Repaint = Scroll::SetState(\Scroll\v, \Scroll\v\page\Pos + (\Scroll\v\max-\Scroll\v\min)/30)
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
                Protected from = \Index[1]
                Repaint = item_from(*This, MouseX, MouseY)
                
                If from <> \Index[1]
                  If \text\x+\text\width>\width
                    GadgetToolTip(canvas, \text\string)
                  Else
                    GadgetToolTip(canvas, "")
                  EndIf
                  from = \Index[1]
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
                  If \Items()\Index = \Items()\focus And \Items()\focus = \Items()\lostfocus 
                    \Items()\lostfocus =- 1
                    Repaint = 1
                    Break
                  EndIf
                Next
                PopListPosition(\Items()) 
                
              Case #PB_EventType_Repaint : Repaint = 1
              Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
                  Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      
            EndSelect
          Else
            Repaint = item_from(*This,-1,-1, 0)
          EndIf
        EndIf
      EndWith 
    EndIf
    
    If Repaint 
      ReDraw(*This)
    EndIf
  EndProcedure
  
  Procedure _Canvas_CallBack()
    Protected Repaint, *This.Widget_S = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint : Repaint = 1
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
        ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, x.i, y.i, width.i, height.i, ColumnTitle.s, ColumnWidth.i, flag.i=0)
    Protected g = CanvasGadget(Gadget, x, y, width, height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget = g : EndIf
    
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    With *This
      If *This
        Widget(*This, Gadget.i, 0, 0, Width.i, Height.i, ColumnTitle.s, ColumnWidth.i, Flag|#PB_Flag_NoButtons|#PB_Flag_NoLines)
        
        PostEvent(#PB_Event_Gadget, \Canvas\Window, Gadget, #PB_EventType_Resize)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndIf
    EndWith
    
    ProcedureReturn g
  EndProcedure
  
  Procedure Free(Gadget.i)
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
    Gadget(g, 10, 230, 165, 210,"Column_1",90) : *g = GetGadgetData(g)                                        
    For i=1 To 2 : AddColumn(*g, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    For i=0 To 7
      AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                          
    Next
    
    g = 12
    Gadget(g, 180, 230, 165, 210,"Column_1",90, #PB_Flag_FullSelection) : *g = GetGadgetData(g)                                          
    For i=1 To 2 : AddColumn(*g, i,"Column_"+Str(i+1),90) : Next
    ; 1_example
    For i=0 To Count
      AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", -1)                                          
    Next
    
    g = 13
    Gadget(g, 350, 230, 430, 210,"Column_1",90, #PB_Flag_FullSelection|#PB_Flag_GridLines|#PB_Flag_CheckBoxes) : *g = GetGadgetData(g)                                          
    
    ;HideGadget(g,1)
    For i=1 To 2
      AddColumn(*g, i,"Column_"+Str(i+1),90)
    Next
    ; 1_example
    For i=0 To 15
      AddItem(*g, i, Str(i)+"_Column_1"+#LF$+Str(i)+"_Column_2"+#LF$+Str(i)+"_Column_3"+#LF$+Str(i)+"_Column_4", 0)                                         
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
; Folding = --v4+-----------Owv------------------------------f----f----
; EnableXP