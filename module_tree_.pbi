CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
  ;  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  ;  IncludePath "/Users/a/Documents/GitHub/Widget/"
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_draw.pbi"
  
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_scroll.pbi"
  XIncludeFile "module_text.pbi"
  XIncludeFile "module_editor.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf

DeclareModule tree
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  
  ;- - DECLAREs MACROs
  Macro ClearItems(_this_)
    Editor::ClearItems(_this_)
  EndMacro
  
  Macro CountItems(_this_)
    Editor::CountItems(_this_)
  EndMacro
  
  Macro RemoveItem(_this_, _item_)
    Editor::RemoveItem(_this_, _item_)
  EndMacro
  
  Macro AddItem(_this_, _item_,_text_,_image_=-1,_flag_=0)
    Editor::AddItem(_this_,_item_,_text_,_image_,_flag_)
  EndMacro
  
  Macro SetText(_this_, _text_)
    Editor::SetText(_this_,_text_,0)
  EndMacro
  
  Macro SetFont(_this_, _font_id_)
    Editor::SetFont(_this_, _font_id_)
  EndMacro
  
  Macro GetText(_this_)
    Text::GetText(_this_)
  EndMacro
  
  ;- DECLAREs PROCEDUREs
  Declare.i GetState(*This.Widget_S)
  Declare.i SetState(*This.Widget_S, State.i)
  ; Declare.i GetItemState(*This.Widget_S, Item.i)
  Declare.i SetItemState(*This.Widget_S, Item.i, State.i)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
EndDeclareModule

Module tree
  ;-
  ;- PROCEDUREs
  ;-
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
  
  Procedure DrawPlotXCallback(X, Y, SourceColor, TargetColor)
    Protected Color
    
;     If x%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Default
          Color = SourceColor
      EndSelect
;     Else
;       Color = TargetColor
;     EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure DrawPlotYCallback(X, Y, SourceColor, TargetColor)
    Protected Color
    
;     If y%2
      Select TargetColor
        Case $FFECAE62, $FFECB166, $FFFEFEFE, $FFE89C3D, $FFF3CD9D
          Color = $FFFEFEFE
        Case $FFF1F1F1, $FFF3F3F3, $FFF5F5F5, $FFF7F7F7, $FFF9F9F9, $FFFBFBFB, $FFFDFDFD, $FFFCFCFC, $FFFEFEFE, $FF7E7E7E
          Color = TargetColor
        Default
          Color = SourceColor
      EndSelect
;     Else
;       Color = TargetColor
;     EndIf
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure _Draw(*This.Widget_S)
    Protected x_content,y_point,x_point, iwidth, iheight, w=18, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 128, height =20
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b =- 1
    Protected Drawing.b, text_color
    
    ;box_type.b = 0
    
    If *This 
      If *This\Text\FontID : DrawingFont(*This\Text\FontID) : EndIf
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\x[2], *This\y[2], *This\width[2], *This\height[2], back_color)
      
      If Not *This\Text\Height
        *This\Text\Height = height;TextHeight("A") + 1
      EndIf
      
      With *This\Items()
        If ListSize(*This\Items())
          *This\Scroll\Width=*This\x[2]
          *This\Scroll\height=*This\y[2]
          iwidth = *This\width[2]-Scroll::Width(*This\vScroll)
          iheight = *This\height[2]-Scroll::Height(*This\hScroll)
          
          ForEach *This\Items()
            If Not \hide
              If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
              _clip_output_(*This, *This\x[2], *This\y[2], iwidth, iheight) ; Bug
              
              \x=*This\x[2]
              \width=iwidth
              \height=height
              \y=*This\Scroll\height-*This\vScroll\Page\Pos
              
              If \text\change = 1
                \text\height = TextHeight("A")
                \text\width = TextWidth(\text\string.s)
                \text\change = 0
              EndIf
              
              x_content=\x+(Bool(*This\Flag\NoButtons=0)*w+\sublevel*w)-*This\hScroll\Page\Pos-1
              
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
              
              If *This\Flag\CheckBoxes
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
                   (*This\focus And *This\Flag\FullSelection And *This\Item = \Item )
                  
                  If *This\Flag\FullSelection And box_type=-1
                    box_color = $FEFEFE
                  EndIf
                  text_color=$FEFEFE
                Else
                  box_color = $7E7E7E
                  text_color=$000000
                EndIf
                
                ; Draw selections
                If \Item=\Line Or \Item=\focus ; \Item=*This\Line ; с этим остается последное виделеное слово
                  Protected SelectionPos, SelectionLen 
                  If *This\Flag\FullSelection
                    SelectionPos = *This\X[2]
                    SelectionLen = iwidth
                  Else
                    SelectionPos = \Text\X - 2
                    SelectionLen = \Text\width + 4
                  EndIf
                  
                  ; Draw items back color
                  If \Color\Fore
                    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                    BoxGradient(\Vertical,SelectionPos,\Y,SelectionLen,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
                  Else
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    RoundBox(SelectionPos,\Y,SelectionLen,\Height,\Radius,\Radius,\Color\Back[\Color\State])
                  EndIf
                  ;Debug Point(\x+2,\y+2)
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(SelectionPos,\y,SelectionLen,\height, \Color\Frame[\Color\State])
                EndIf
              EndIf  
              
              ; Draw plot
              If Not *This\Flag\NoLines 
                x_point=\box\x+\box\width/2
                
                If x_point>*This\x[2] 
                  y_point=\box\y+\box\height/2
                  
                  If Drawing
                    ; Horizontal plot
                    DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotXCallback())
                    Line(x_point+i,y_point,line_size,1, point_color&$FFFFFF|alpha<<24)
                  EndIf
                  
                  ; Vertical plot
                  If \adress
                    start = \sublevel
                    
                    PushListPosition(*This\Items())
                    ChangeCurrentElement(*This\Items(), \adress) 
                    If Drawing Or (start = \sublevel And Bool(\y+\height>*This\y[2] And \y<*This\height[2]))
                      
                      If start
                        start = \y+\height+\height/2-line_size 
                      Else 
                        start = (*This\y[2]+\height/2)-*This\vScroll\Page\Pos 
                      EndIf
                      
                      DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotYCallback())
                      Line(x_point,start,1, (y_point-start), point_color&$FFFFFF|alpha<<24)
                    EndIf
                    PopListPosition(*This\Items())
                  EndIf
                EndIf
              EndIf
              
              If Drawing
                ; Draw boxes
                If Not *This\Flag\NoButtons And \childrens
                  ;                   DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  ;                   Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, box_color&$FFFFFF|alpha<<24, 0,0) 
                  If box_type=-1
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, box_color&$FFFFFF|alpha<<24, 0,0) 
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
                
                ; Draw checkbox
                If *This\Flag\CheckBoxes
                  DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, checkbox_color, box_color, 2, alpha);, box_type)
                EndIf
                
                ; Draw image
                If \Image\handle
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawAlphaImage(\Image\handle, \Image\x, \Image\y, alpha)
                EndIf
                
                ; Draw string
                If \text\string.s
                  _clip_output_(*This, *This\x[2], *This\y[2], \width, *This\height[2]) 
                  DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                  DrawText(\text\x, \text\y, \text\string.s, text_color&$FFFFFF|alpha<<24)
                EndIf
              EndIf
            EndIf
          Next
        EndIf
        
        UnclipOutput()
        
        ; Задаем размеры скролл баров
        If *This\vScroll\Page\Length And *This\vScroll\Max<>*This\Scroll\Height And 
           Scroll::SetAttribute(*This\vScroll, #PB_ScrollBar_Maximum, *This\Scroll\Height)
          Scroll::Resizes(*This\vScroll, *This\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          *This\vScroll\Page\ScrollStep = height
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
        
      EndWith
    EndIf
  EndProcedure
  
  
  
  
  
  Procedure.i Draw(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    
    Protected box_size = 9,box_1_size = 12
    
    If Not *This\Hide
      
      With *This
        iX=\X[2]
        iY=\Y[2]
        CompilerIf Defined(Scroll, #PB_Module)
          iwidth = *This\width[2]-Scroll::Width(*This\vScroll)
          iheight = *This\height[2]-Scroll::Height(*This\hScroll)
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
          
          Text::MultiLine(*This)
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
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
            \Hide = Bool(Not Drawing)
            
            If Drawing
               ; Debug  \Item                                                             ; Draw items back color
              
            If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
            _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
            
            If \Text\Change : \Text\Change = #False
              \Text\Width = TextWidth(\Text\String.s) 
              
              If \Text\FontID 
                \Text\Height = TextHeight("A") 
              Else
                \Text\Height = *This\Text\Height
              EndIf
            EndIf 
            
            If \Text[1]\Change : \Text[1]\Change = #False
              \Text[1]\Width = TextWidth(\Text[1]\String.s) 
            EndIf 
            
            If \Text[3]\Change : \Text[3]\Change = #False 
              \Text[3]\Width = TextWidth(\Text[3]\String.s)
            EndIf 
            
            If \Text[2]\Change : \Text[2]\Change = #False 
              \Text[2]\X = Text_X+\Text[1]\Width
              \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
              \Text[3]\X = \Text[2]\X+\Text[2]\Width
            EndIf 
            
            ;               
            If *This\Focus = *This 
              Protected Left,Right
              Left =- TextWidth(Mid(*This\Text\String.s, \Text\Position, *This\Caret))
              ; Left =- (\Text[1]\Width+(Bool(*This\Caret>*This\Caret[1])*\Text[2]\Width))
              Right = (\Width + Left)
              
              If *This\Scroll\X < Left
                *This\Scroll\X = Left
              ElseIf *This\Scroll\X > Right
                *This\Scroll\X = Right
              ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
                *This\Scroll\X = (\Width-\Text[3]\Width) + Left
                If *This\Scroll\X>0
                  *This\Scroll\X=0
                EndIf
              EndIf
            EndIf
            
          EndIf
          
          *This\sublevellen = 18
            Protected indent = 8 + Bool(*This\Image\width)*5
            ; Draw coordinates 
            \sublevellen = (12 - *This\sublevellen) + ((\sublevel+Bool(Not *This\Flag\NoButtons))**This\sublevellen) + Bool(*This\Flag\CheckBoxes)*12
            
;             If *This\Image\width And Not *This\Flag\CheckBoxes
;               indent = 16
;             EndIf
            
            Height = \Height
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X + \sublevellen + *This\Image\width + indent
            Text_Y = \Text\Y+*This\Scroll\Y
            
            ; expanded & collapsed box
            If Not *This\Flag\NoButtons Or
               Not *This\Flag\NoLines 
              \box\width = box_size
              \box\height = box_size
              \box\x = \sublevellen-(\box\width)/2 
              \box\y = (Y+height)-(height+\box\height)/2
            EndIf
            
            If *This\Flag\CheckBoxes
              \box\width[1] = box_1_size
              \box\height[1] = box_1_size
              
              \box\x[1] = (\box\width[1])/2
              \box\y[1] = (Y+height)-(height+\box\height[1])/2
            EndIf
            
            ; Draw selections
            If Drawing And (\Item=*This\Line Or \Item=\focus Or \Item=\line) ; \Color\State;
              If \Color\Fore[\Color\State]
                DrawingMode(#PB_2DDrawing_Gradient)
                BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
              Else
                DrawingMode(#PB_2DDrawing_Default)
                RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,\Color\Back[\Color\State])
              EndIf
              
              DrawingMode(#PB_2DDrawing_Outlined)
              RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, \Color\Frame[\Color\State])
            EndIf
            
            ; Draw plot
            If Not *This\Flag\NoLines 
              Protected line_size=8, x_point=\sublevellen
              
              If x_point>*This\x[2] 
                Protected y_point=\box\y+\box\height/2
                
                If Drawing
                  ; Horizontal plot
                  DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotXCallback())
                  Line(x_point,y_point,line_size,1, $FF000000)
                EndIf
                
                ; Vertical plot
                If \adress
                  Protected start = \sublevel
                  
                  If \adress[1]
                    PushListPosition(*This\Items())
                    ChangeCurrentElement(*This\Items(), \adress[1]) 
                    If \Hide 
                      DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotYCallback())
                      Drawing = 1 
                    EndIf
                    PopListPosition(*This\Items())
                  EndIf
                  
                  PushListPosition(*This\Items())
                  ChangeCurrentElement(*This\Items(), \adress) 
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
                    
                    Line(x_point,start,1, (y_point-start), $FF000000)
                  EndIf
                  PopListPosition(*This\Items())
                EndIf
              EndIf
            EndIf
            
            If Drawing
              ; Draw boxes
              If Not *This\Flag\NoButtons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, \Color\Front[\Color\State], 0,0) 
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, indent + \Image\x+\sublevellen, \Image\y+*This\Scroll\Y, \alpha)
              EndIf
              
              ; Draw text
              ;_clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
              
              ; Draw string
              If \Text[2]\Len > 0 And *This\Color\Front <> *This\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Caret[1] > *This\Caret And *This\Line[1] = *This\Line) Or (*This\Line[1] > *This\Line And *This\Line = \Item)
                    \Text[3]\X = Text_X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                    
                    If *This\Line[1] = *This\Line
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[3]\X, Text_Y, \Text[3]\String.s, *This\Color\Front)
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s, *This\Color\Front)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText(Text_X, Text_Y, \Text\String.s, *This\Color\Front)
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[2]\X, Text_Y, \Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[2])
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len > 0
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                EndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, \Color\Front[\Color\State])
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
                EndIf
              EndIf
              
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ;And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              If Bool(Not \Text[1]\Width Or *This\Caret > *This\Caret[1])
                Line((\X+*This\Scroll\X + \Text[1]\Width + \Text[2]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              Else
                Line((\X+*This\Scroll\X + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              EndIf
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(*This\Items())
          ; Draw scroll bars
          CompilerIf Defined(Scroll, #PB_Module)
            UnclipOutput()
            If \vScroll\Page\Length And \vScroll\Max<>\Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines) And
               Scroll::SetAttribute(\vScroll, #PB_ScrollBar_Maximum, \Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines))
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            If \hScroll\Page\Length And \hScroll\Max<>\Scroll\Width And
               Scroll::SetAttribute(\hScroll, #PB_ScrollBar_Maximum, \Scroll\Width)
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            
            Scroll::Draw(\vScroll)
            Scroll::Draw(\hScroll)
            
            ;           ; >>>|||
            ;           If \Scroll\Widget\Vertical\Page\Length And \Scroll\Widget\Vertical\Max<>\Scroll\Height And
            ;              Scroll::SetAttribute(\Scroll\Widget\Vertical, #PB_ScrollBar_Maximum, \Scroll\Height)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           If \Scroll\Widget\Horizontal\Page\Length And \Scroll\Widget\Horizontal\Max<>\Scroll\Width And
            ;              Scroll::SetAttribute(\Scroll\Widget\Horizontal, #PB_ScrollBar_Maximum, \Scroll\Width)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           Scroll::Draw(\Scroll\Widget\Vertical)
            ;           Scroll::Draw(\Scroll\Widget\Horizontal)
          CompilerEndIf
          
          _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
          
          ; Draw image
          If \Image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
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
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius, $FFF1F1FF)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius 
              RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF)
            EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText((\Width[1]-TextWidth("!!! Недопустимый символ"))/2, \Items()\Text[0]\Y, "!!! Недопустимый символ", $FF0000FF)
          Else
            ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            ;           If \Radius : RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[2]) : EndIf ; Сглаживание краев )))
            ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[2])
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i __Draw(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    
    Protected box_size = 9,box_1_size = 12
    
    If Not *This\Hide
      
      With *This
        iX=\X[2]
        iY=\Y[2]
        CompilerIf Defined(Scroll, #PB_Module)
          iwidth = *This\width[2]-Scroll::Width(*This\vScroll)
          iheight = *This\height[2]-Scroll::Height(*This\hScroll)
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
          
          Text::MultiLine(*This)
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
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
            \Hide = Bool(Not Drawing)
            
            If Drawing
               ; Debug  \Item                                                             ; Draw items back color
              
            If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
            _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
            
            If \Text\Change : \Text\Change = #False
              \Text\Width = TextWidth(\Text\String.s) 
              
              If \Text\FontID 
                \Text\Height = TextHeight("A") 
              Else
                \Text\Height = *This\Text\Height
              EndIf
            EndIf 
            
            If \Text[1]\Change : \Text[1]\Change = #False
              \Text[1]\Width = TextWidth(\Text[1]\String.s) 
            EndIf 
            
            If \Text[3]\Change : \Text[3]\Change = #False 
              \Text[3]\Width = TextWidth(\Text[3]\String.s)
            EndIf 
            
            If \Text[2]\Change : \Text[2]\Change = #False 
              \Text[2]\X = Text_X+\Text[1]\Width
              \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
              \Text[3]\X = \Text[2]\X+\Text[2]\Width
            EndIf 
            
            ;               
            If *This\Focus = *This 
              Protected Left,Right
              Left =- TextWidth(Mid(*This\Text\String.s, \Text\Position, *This\Caret))
              ; Left =- (\Text[1]\Width+(Bool(*This\Caret>*This\Caret[1])*\Text[2]\Width))
              Right = (\Width + Left)
              
              If *This\Scroll\X < Left
                *This\Scroll\X = Left
              ElseIf *This\Scroll\X > Right
                *This\Scroll\X = Right
              ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
                *This\Scroll\X = (\Width-\Text[3]\Width) + Left
                If *This\Scroll\X>0
                  *This\Scroll\X=0
                EndIf
              EndIf
            EndIf
            
          EndIf
          
            ; Draw coordinates 
            \sublevellen = ((\sublevel+Bool(Not *This\Flag\NoButtons))**This\sublevellen) + Bool(*This\Flag\CheckBoxes)*15
            
            Height = \Height
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X + \sublevellen + *This\Image\width
            Text_Y = \Text\Y+*This\Scroll\Y
            
            ; Draw selections
            If Drawing And (\Item=*This\Line Or \Item=\focus Or \Item=\line) ; \Color\State;
              If \Color\Fore[\Color\State]
                DrawingMode(#PB_2DDrawing_Gradient)
                BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
              Else
                DrawingMode(#PB_2DDrawing_Default)
                RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,\Color\Back[\Color\State])
              EndIf
              
              DrawingMode(#PB_2DDrawing_Outlined)
              RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, \Color\Frame[\Color\State])
            EndIf
            
            ; expanded & collapsed box
            If Not *This\Flag\NoButtons Or
               Not *This\Flag\NoLines 
              \box\width = box_size
              \box\height = box_size
              \box\x = \sublevellen-(*This\sublevellen+\box\width)/2 - 1
              \box\y = (Y+height)-(height+\box\height)/2
            EndIf
            
            If *This\Flag\CheckBoxes
              \box\width[1] = box_1_size
              \box\height[1] = box_1_size
              
              \box\x[1] = (*This\sublevellen+\box\width[1])/2 - box_size
              \box\y[1] = (Y+height)-(height+\box\height[1])/2
            EndIf
            
            ; Draw plot
            If Not *This\Flag\NoLines 
              Protected line_size=8, x_point=\box\x+\box\width/2
              
              If x_point>*This\x[2] 
                Protected y_point=\box\y+\box\height/2
                
                If Drawing
                  ; Horizontal plot
                  ; DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotXCallback())
                  Line(x_point,y_point,line_size,1, $FF000000)
                EndIf
                
                ; Vertical plot
                If \adress
                  Protected start = \sublevel
                  
                  PushListPosition(*This\Items())
                  ChangeCurrentElement(*This\Items(), \adress) 
                  ;If Drawing Or (start = \sublevel And Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
                  If Drawing ;Or (start = \sublevel And Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
                    ;If Drawing Or (start = \sublevel And Bool(\y+\height>*This\y[2] And \y<*This\height[2]))
                    
                    If start
                      start = (\y+\height) + *This\Scroll\Y
                    Else 
                      start = (*This\y[2]+\height/2)+*This\Scroll\Y
                    EndIf
                    
                    ; DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotYCallback())
                    Line(x_point,start,1, (y_point-start), $FF000000)
                  EndIf
                  PopListPosition(*This\Items())
                EndIf
              EndIf
            EndIf
            
            If Drawing
              ; Draw boxes
              If Not *This\Flag\NoButtons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, \Color\Front[\Color\State], 0,0) 
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, \Image\x+\sublevellen, \Image\y+*This\Scroll\Y, \alpha)
              EndIf
              
              ; Draw text
              ;_clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
              
              ; Draw string
              If \Text[2]\Len > 0 And *This\Color\Front <> *This\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Caret[1] > *This\Caret And *This\Line[1] = *This\Line) Or (*This\Line[1] > *This\Line And *This\Line = \Item)
                    \Text[3]\X = Text_X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                    
                    If *This\Line[1] = *This\Line
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[3]\X, Text_Y, \Text[3]\String.s, *This\Color\Front)
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s, *This\Color\Front)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText(Text_X, Text_Y, \Text\String.s, *This\Color\Front)
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[2]\X, Text_Y, \Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[2])
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len > 0
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                EndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, \Color\Front[\Color\State])
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
                EndIf
              EndIf
              
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ;And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              If Bool(Not \Text[1]\Width Or *This\Caret > *This\Caret[1])
                Line((\X+*This\Scroll\X + \Text[1]\Width + \Text[2]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              Else
                Line((\X+*This\Scroll\X + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              EndIf
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(*This\Items())
          ; Draw scroll bars
          CompilerIf Defined(Scroll, #PB_Module)
            UnclipOutput()
            If \vScroll\Page\Length And \vScroll\Max<>\Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines) And
               Scroll::SetAttribute(\vScroll, #PB_ScrollBar_Maximum, \Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines))
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            If \hScroll\Page\Length And \hScroll\Max<>\Scroll\Width And
               Scroll::SetAttribute(\hScroll, #PB_ScrollBar_Maximum, \Scroll\Width)
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            
            Scroll::Draw(\vScroll)
            Scroll::Draw(\hScroll)
            
            ;           ; >>>|||
            ;           If \Scroll\Widget\Vertical\Page\Length And \Scroll\Widget\Vertical\Max<>\Scroll\Height And
            ;              Scroll::SetAttribute(\Scroll\Widget\Vertical, #PB_ScrollBar_Maximum, \Scroll\Height)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           If \Scroll\Widget\Horizontal\Page\Length And \Scroll\Widget\Horizontal\Max<>\Scroll\Width And
            ;              Scroll::SetAttribute(\Scroll\Widget\Horizontal, #PB_ScrollBar_Maximum, \Scroll\Width)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           Scroll::Draw(\Scroll\Widget\Vertical)
            ;           Scroll::Draw(\Scroll\Widget\Horizontal)
          CompilerEndIf
          
          _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
          
          ; Draw image
          If \Image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
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
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius, $FFF1F1FF)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius 
              RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF)
            EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText((\Width[1]-TextWidth("!!! Недопустимый символ"))/2, \Items()\Text[0]\Y, "!!! Недопустимый символ", $FF0000FF)
          Else
            ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            ;           If \Radius : RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[2]) : EndIf ; Сглаживание краев )))
            ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[2])
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i ___Draw(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    
    Protected box_size = 9,box_1_size = 12
    
    If Not *This\Hide
      
      With *This
        iX=\X[2]
        iY=\Y[2]
        CompilerIf Defined(Scroll, #PB_Module)
          iwidth = *This\width[2]-Scroll::Width(*This\vScroll)
          iheight = *This\height[2]-Scroll::Height(*This\hScroll)
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
          
          Text::MultiLine(*This)
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
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
            \Hide = Bool(Not Drawing)
            
            If Drawing
               ; Debug  \Item                                                             ; Draw items back color
              
            If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
            _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
            
            If \Text\Change : \Text\Change = #False
              \Text\Width = TextWidth(\Text\String.s) 
              
              If \Text\FontID 
                \Text\Height = TextHeight("A") 
              Else
                \Text\Height = *This\Text\Height
              EndIf
            EndIf 
            
            If \Text[1]\Change : \Text[1]\Change = #False
              \Text[1]\Width = TextWidth(\Text[1]\String.s) 
            EndIf 
            
            If \Text[3]\Change : \Text[3]\Change = #False 
              \Text[3]\Width = TextWidth(\Text[3]\String.s)
            EndIf 
            
            If \Text[2]\Change : \Text[2]\Change = #False 
              \Text[2]\X = Text_X+\Text[1]\Width
              \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
              \Text[3]\X = \Text[2]\X+\Text[2]\Width
            EndIf 
            
            ;               
            If *This\Focus = *This 
              Protected Left,Right
              Left =- TextWidth(Mid(*This\Text\String.s, \Text\Position, *This\Caret))
              ; Left =- (\Text[1]\Width+(Bool(*This\Caret>*This\Caret[1])*\Text[2]\Width))
              Right = (\Width + Left)
              
              If *This\Scroll\X < Left
                *This\Scroll\X = Left
              ElseIf *This\Scroll\X > Right
                *This\Scroll\X = Right
              ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
                *This\Scroll\X = (\Width-\Text[3]\Width) + Left
                If *This\Scroll\X>0
                  *This\Scroll\X=0
                EndIf
              EndIf
            EndIf
            
          EndIf
          
          *This\sublevellen = 18
            ; Draw coordinates 
            \sublevellen = ((\sublevel+Bool(Not *This\Flag\NoButtons))**This\sublevellen) - *This\sublevellen/2 + Bool(*This\Flag\CheckBoxes)*13 ; (\sublevel**This\sublevellen) + (Bool(\childrens)**This\sublevellen);((\sublevel+Bool(Not *This\Flag\NoButtons))**This\sublevellen) + Bool(*This\Flag\CheckBoxes)*15
            
            Height = \Height
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X + \sublevellen + *This\sublevellen/2 + (Bool(\childrens)**This\sublevellen) + *This\Image\width ; - Bool(Not *This\Image\width) * box_size/2 - *This\sublevellen
            Text_Y = \Text\Y+*This\Scroll\Y
            
            ; Draw selections
            If Drawing And (\Item=*This\Line Or \Item=\focus Or \Item=\line) ; \Color\State;
              If \Color\Fore[\Color\State]
                DrawingMode(#PB_2DDrawing_Gradient)
                BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
              Else
                DrawingMode(#PB_2DDrawing_Default)
                RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,\Color\Back[\Color\State])
              EndIf
              
              DrawingMode(#PB_2DDrawing_Outlined)
              RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, \Color\Frame[\Color\State])
            EndIf
            
            ; expanded & collapsed box
            If Not *This\Flag\NoButtons Or
               Not *This\Flag\NoLines 
              \box\width = box_size
              \box\height = box_size
              \box\x = \sublevellen - (\box\width)/2 + *This\sublevellen
              \box\y = (Y+height)-(height+\box\height)/2
            EndIf
            
            If *This\Flag\CheckBoxes
              \box\width[1] = box_1_size
              \box\height[1] = box_1_size
              
              \box\x[1] = (*This\sublevellen+\box\width[1])/2 - box_size
              \box\y[1] = (Y+height)-(height+\box\height[1])/2
            EndIf
            
            ; Draw plot
            If Not *This\Flag\NoLines 
              Protected line_size=9, x_point=\sublevellen
              
              If x_point>*This\x[2] 
                Protected y_point=\box\y+\box\height/2
                
                If Drawing
                  ; Horizontal plot
                  ; DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotXCallback())
                  Line(x_point,y_point,line_size+Bool(\childrens)**This\sublevellen,1, $FF000000)
                EndIf
                
                ; Vertical plot
                If \adress
                  Protected start = \sublevel
                  
                  PushListPosition(*This\Items())
                  ChangeCurrentElement(*This\Items(), \adress) 
                  ;If Drawing Or (start = \sublevel And Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
                  If Drawing ;Or (start = \sublevel And Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
                    ;If Drawing Or (start = \sublevel And Bool(\y+\height>*This\y[2] And \y<*This\height[2]))
                    
                    If start
                      start = (\y+\height/2) + *This\Scroll\Y
                    Else 
                      start = (*This\y[2]+\height/2)+*This\Scroll\Y
                    EndIf
                    
                    ; DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotYCallback())
                    Line(x_point,start,1, (y_point-start), $FF000000)
                  EndIf
                  PopListPosition(*This\Items())
                EndIf
              EndIf
            EndIf
            
            If Drawing
              ; Draw boxes
              If Not *This\Flag\NoButtons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, \Color\Front[\Color\State], 0,0) 
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, text_X-\Image\Width-2, \Image\y+*This\Scroll\Y, \alpha)
              EndIf
              
              ; Draw text
              _clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
              
              ; Draw string
              If \Text[2]\Len > 0 And *This\Color\Front <> *This\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Caret[1] > *This\Caret And *This\Line[1] = *This\Line) Or (*This\Line[1] > *This\Line And *This\Line = \Item)
                    \Text[3]\X = Text_X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                    
                    If *This\Line[1] = *This\Line
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[3]\X, Text_Y, \Text[3]\String.s, *This\Color\Front)
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s, *This\Color\Front)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText(Text_X, Text_Y, \Text\String.s, *This\Color\Front)
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[2]\X, Text_Y, \Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[2])
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len > 0
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                EndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, \Color\Front[\Color\State])
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
                EndIf
              EndIf
              
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ;And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              If Bool(Not \Text[1]\Width Or *This\Caret > *This\Caret[1])
                Line((\X+*This\Scroll\X + \Text[1]\Width + \Text[2]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              Else
                Line((\X+*This\Scroll\X + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              EndIf
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(*This\Items())
          ; Draw scroll bars
          CompilerIf Defined(Scroll, #PB_Module)
            UnclipOutput()
            If \vScroll\Page\Length And \vScroll\Max<>\Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines) And
               Scroll::SetAttribute(\vScroll, #PB_ScrollBar_Maximum, \Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines))
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            If \hScroll\Page\Length And \hScroll\Max<>\Scroll\Width And
               Scroll::SetAttribute(\hScroll, #PB_ScrollBar_Maximum, \Scroll\Width)
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            
            Scroll::Draw(\vScroll)
            Scroll::Draw(\hScroll)
            
            ;           ; >>>|||
            ;           If \Scroll\Widget\Vertical\Page\Length And \Scroll\Widget\Vertical\Max<>\Scroll\Height And
            ;              Scroll::SetAttribute(\Scroll\Widget\Vertical, #PB_ScrollBar_Maximum, \Scroll\Height)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           If \Scroll\Widget\Horizontal\Page\Length And \Scroll\Widget\Horizontal\Max<>\Scroll\Width And
            ;              Scroll::SetAttribute(\Scroll\Widget\Horizontal, #PB_ScrollBar_Maximum, \Scroll\Width)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           Scroll::Draw(\Scroll\Widget\Vertical)
            ;           Scroll::Draw(\Scroll\Widget\Horizontal)
          CompilerEndIf
          
          _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
          
          ; Draw image
          If \Image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
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
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius, $FFF1F1FF)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius 
              RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF)
            EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText((\Width[1]-TextWidth("!!! Недопустимый символ"))/2, \Items()\Text[0]\Y, "!!! Недопустимый символ", $FF0000FF)
          Else
            ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            ;           If \Radius : RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[2]) : EndIf ; Сглаживание краев )))
            ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[2])
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i ____Draw(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    
    Protected box_size = 9,box_1_size = 12
    
    If Not *This\Hide
      
      With *This
        iX=\X[2]
        iY=\Y[2]
        CompilerIf Defined(Scroll, #PB_Module)
          iwidth = *This\width[2]-Scroll::Width(*This\vScroll)
          iheight = *This\height[2]-Scroll::Height(*This\hScroll)
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
          
          Text::MultiLine(*This)
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
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
            \Hide = Bool(Not Drawing)
            
            If Drawing
               ; Debug  \Item                                                             ; Draw items back color
              
            If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
            _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
            
            If \Text\Change : \Text\Change = #False
              \Text\Width = TextWidth(\Text\String.s) 
              
              If \Text\FontID 
                \Text\Height = TextHeight("A") 
              Else
                \Text\Height = *This\Text\Height
              EndIf
            EndIf 
            
            If \Text[1]\Change : \Text[1]\Change = #False
              \Text[1]\Width = TextWidth(\Text[1]\String.s) 
            EndIf 
            
            If \Text[3]\Change : \Text[3]\Change = #False 
              \Text[3]\Width = TextWidth(\Text[3]\String.s)
            EndIf 
            
            If \Text[2]\Change : \Text[2]\Change = #False 
              \Text[2]\X = Text_X+\Text[1]\Width
              \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
              \Text[3]\X = \Text[2]\X+\Text[2]\Width
            EndIf 
            
            ;               
            If *This\Focus = *This 
              Protected Left,Right
              Left =- TextWidth(Mid(*This\Text\String.s, \Text\Position, *This\Caret))
              ; Left =- (\Text[1]\Width+(Bool(*This\Caret>*This\Caret[1])*\Text[2]\Width))
              Right = (\Width + Left)
              
              If *This\Scroll\X < Left
                *This\Scroll\X = Left
              ElseIf *This\Scroll\X > Right
                *This\Scroll\X = Right
              ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
                *This\Scroll\X = (\Width-\Text[3]\Width) + Left
                If *This\Scroll\X>0
                  *This\Scroll\X=0
                EndIf
              EndIf
            EndIf
            
          EndIf
          
          *This\sublevellen = 14
            ; Draw coordinates 
            \sublevellen = *This\sublevellen/2+((\sublevel+Bool(Not *This\Flag\NoButtons))**This\sublevellen/2) - *This\sublevellen/2 + Bool(*This\Flag\CheckBoxes)*13 ; (\sublevel**This\sublevellen) + (Bool(\childrens)**This\sublevellen);((\sublevel+Bool(Not *This\Flag\NoButtons))**This\sublevellen) + Bool(*This\Flag\CheckBoxes)*15
            
            Height = \Height
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X + \sublevellen + *This\sublevellen/2 + 4 +*This\Image\width ; - Bool(Not *This\Image\width) * box_size/2 - *This\sublevellen
            Text_Y = \Text\Y+*This\Scroll\Y
            
            ; Draw selections
            If Drawing And (\Item=*This\Line Or \Item=\focus Or \Item=\line) ; \Color\State;
              If \Color\Fore[\Color\State]
                DrawingMode(#PB_2DDrawing_Gradient)
                BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
              Else
                DrawingMode(#PB_2DDrawing_Default)
                RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,\Color\Back[\Color\State])
              EndIf
              
              DrawingMode(#PB_2DDrawing_Outlined)
              RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, \Color\Frame[\Color\State])
            EndIf
            
            ; expanded & collapsed box
            If Not *This\Flag\NoButtons Or
               Not *This\Flag\NoLines 
              \box\width = box_size
              \box\height = box_size
              \box\x = \sublevellen - (\box\width)/2 + *This\sublevellen/2
              \box\y = (Y+height)-(height+\box\height)/2
            EndIf
            
            If *This\Flag\CheckBoxes
              \box\width[1] = box_1_size
              \box\height[1] = box_1_size
              
              \box\x[1] = (*This\sublevellen+\box\width[1])/2 - box_size
              \box\y[1] = (Y+height)-(height+\box\height[1])/2
            EndIf
            
            ; Draw plot
            If Not *This\Flag\NoLines 
              Protected line_size=9, x_point=\sublevellen
              
              If x_point>*This\x[2] 
                Protected y_point=\box\y+\box\height/2
                
                If Drawing
                  ; Horizontal plot
                  ; DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotXCallback())
                  Line(x_point,y_point,*This\sublevellen,1, $FF000000)
                EndIf
                
                ; Vertical plot
                If \adress
                  Protected start = \sublevel
                  
                  PushListPosition(*This\Items())
                  ChangeCurrentElement(*This\Items(), \adress) 
                  ;If Drawing Or (start = \sublevel And Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
                  If Drawing ;Or (start = \sublevel And Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
                    ;If Drawing Or (start = \sublevel And Bool(\y+\height>*This\y[2] And \y<*This\height[2]))
                    
                    If start
                      start = (\y+\height/2) + *This\Scroll\Y
                    Else 
                      start = (*This\y[2]+\height/2)+*This\Scroll\Y
                    EndIf
                    
                    ; DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotYCallback())
                    Line(x_point,start,1, (y_point-start), $FF000000)
                  EndIf
                  PopListPosition(*This\Items())
                EndIf
              EndIf
            EndIf
            
            If Drawing
              ; Draw boxes
              If Not *This\Flag\NoButtons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, \Color\Front[\Color\State], 0,0) 
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, text_X-\Image\Width-2, \Image\y+*This\Scroll\Y, \alpha)
              EndIf
              
              ; Draw text
              _clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
              
              ; Draw string
              If \Text[2]\Len > 0 And *This\Color\Front <> *This\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Caret[1] > *This\Caret And *This\Line[1] = *This\Line) Or (*This\Line[1] > *This\Line And *This\Line = \Item)
                    \Text[3]\X = Text_X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                    
                    If *This\Line[1] = *This\Line
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[3]\X, Text_Y, \Text[3]\String.s, *This\Color\Front)
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s, *This\Color\Front)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText(Text_X, Text_Y, \Text\String.s, *This\Color\Front)
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[2]\X, Text_Y, \Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[2])
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len > 0
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                EndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, \Color\Front[\Color\State])
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
                EndIf
              EndIf
              
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ;And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              If Bool(Not \Text[1]\Width Or *This\Caret > *This\Caret[1])
                Line((\X+*This\Scroll\X + \Text[1]\Width + \Text[2]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              Else
                Line((\X+*This\Scroll\X + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              EndIf
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(*This\Items())
          ; Draw scroll bars
          CompilerIf Defined(Scroll, #PB_Module)
            UnclipOutput()
            If \vScroll\Page\Length And \vScroll\Max<>\Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines) And
               Scroll::SetAttribute(\vScroll, #PB_ScrollBar_Maximum, \Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines))
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            If \hScroll\Page\Length And \hScroll\Max<>\Scroll\Width And
               Scroll::SetAttribute(\hScroll, #PB_ScrollBar_Maximum, \Scroll\Width)
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            
            Scroll::Draw(\vScroll)
            Scroll::Draw(\hScroll)
            
            ;           ; >>>|||
            ;           If \Scroll\Widget\Vertical\Page\Length And \Scroll\Widget\Vertical\Max<>\Scroll\Height And
            ;              Scroll::SetAttribute(\Scroll\Widget\Vertical, #PB_ScrollBar_Maximum, \Scroll\Height)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           If \Scroll\Widget\Horizontal\Page\Length And \Scroll\Widget\Horizontal\Max<>\Scroll\Width And
            ;              Scroll::SetAttribute(\Scroll\Widget\Horizontal, #PB_ScrollBar_Maximum, \Scroll\Width)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           Scroll::Draw(\Scroll\Widget\Vertical)
            ;           Scroll::Draw(\Scroll\Widget\Horizontal)
          CompilerEndIf
          
          _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
          
          ; Draw image
          If \Image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
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
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius, $FFF1F1FF)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius 
              RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF)
            EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText((\Width[1]-TextWidth("!!! Недопустимый символ"))/2, \Items()\Text[0]\Y, "!!! Недопустимый символ", $FF0000FF)
          Else
            ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            ;           If \Radius : RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[2]) : EndIf ; Сглаживание краев )))
            ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[2])
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i _____Draw(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    
    Protected line_size=9, box_size = 9,box_1_size = 12
    
    If Not *This\Hide
      
      With *This
        iX=\X[2]
        iY=\Y[2]
        CompilerIf Defined(Scroll, #PB_Module)
          iwidth = *This\width[2]-Scroll::Width(*This\vScroll)
          iheight = *This\height[2]-Scroll::Height(*This\hScroll)
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
          
          Text::MultiLine(*This)
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
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
            \Hide = Bool(Not Drawing)
            
            If Drawing
               ; Debug  \Item                                                             ; Draw items back color
              
            If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
            _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
            
            If \Text\Change : \Text\Change = #False
              \Text\Width = TextWidth(\Text\String.s) 
              
              If \Text\FontID 
                \Text\Height = TextHeight("A") 
              Else
                \Text\Height = *This\Text\Height
              EndIf
            EndIf 
            
            If \Text[1]\Change : \Text[1]\Change = #False
              \Text[1]\Width = TextWidth(\Text[1]\String.s) 
            EndIf 
            
            If \Text[3]\Change : \Text[3]\Change = #False 
              \Text[3]\Width = TextWidth(\Text[3]\String.s)
            EndIf 
            
            If \Text[2]\Change : \Text[2]\Change = #False 
              \Text[2]\X = Text_X+\Text[1]\Width
              \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
              \Text[3]\X = \Text[2]\X+\Text[2]\Width
            EndIf 
            
            ;               
            If *This\Focus = *This 
              Protected Left,Right
              Left =- TextWidth(Mid(*This\Text\String.s, \Text\Position, *This\Caret))
              ; Left =- (\Text[1]\Width+(Bool(*This\Caret>*This\Caret[1])*\Text[2]\Width))
              Right = (\Width + Left)
              
              If *This\Scroll\X < Left
                *This\Scroll\X = Left
              ElseIf *This\Scroll\X > Right
                *This\Scroll\X = Right
              ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
                *This\Scroll\X = (\Width-\Text[3]\Width) + Left
                If *This\Scroll\X>0
                  *This\Scroll\X=0
                EndIf
              EndIf
            EndIf
            
          EndIf
          
          *This\sublevellen = 18
            ; Draw coordinates 
            \sublevellen = *This\sublevellen/2+((\sublevel+Bool(Not *This\Flag\NoButtons))**This\sublevellen/2) - *This\sublevellen/2 + Bool(*This\Flag\CheckBoxes)*13 ; (\sublevel**This\sublevellen) + (Bool(\childrens)**This\sublevellen);((\sublevel+Bool(Not *This\Flag\NoButtons))**This\sublevellen) + Bool(*This\Flag\CheckBoxes)*15
            
            Height = \Height
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X + \sublevellen + *This\sublevellen/2 + (Bool(\childrens)*line_size) + (Bool(Not \childrens)**This\sublevellen) + *This\Image\width ;b- Bool(Not *This\Image\width) * box_size/2 - *This\sublevellen
            Text_Y = \Text\Y+*This\Scroll\Y
            
            ; Draw selections
            If Drawing And (\Item=*This\Line Or \Item=\focus Or \Item=\line) ; \Color\State;
              If \Color\Fore[\Color\State]
                DrawingMode(#PB_2DDrawing_Gradient)
                BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
              Else
                DrawingMode(#PB_2DDrawing_Default)
                RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,\Color\Back[\Color\State])
              EndIf
              
              DrawingMode(#PB_2DDrawing_Outlined)
              RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, \Color\Frame[\Color\State])
            EndIf
            
            ; expanded & collapsed box
            If Not *This\Flag\NoButtons Or
               Not *This\Flag\NoLines 
              \box\width = box_size
              \box\height = box_size
              \box\x = \sublevellen - (\box\width)/2 + *This\sublevellen/2
              \box\y = (Y+height)-(height+\box\height)/2
            EndIf
            
            If *This\Flag\CheckBoxes
              \box\width[1] = box_1_size
              \box\height[1] = box_1_size
              
              \box\x[1] = (*This\sublevellen+\box\width[1])/2 - box_size
              \box\y[1] = (Y+height)-(height+\box\height[1])/2
            EndIf
            
            ; Draw plot
            If Not *This\Flag\NoLines 
              Protected x_point=\sublevellen
              
              If x_point>*This\x[2] 
                Protected y_point=\box\y+\box\height/2
                
                If Drawing
                  ; Horizontal plot
                  ; DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotXCallback())
                  Line(x_point,y_point,*This\sublevellen+Bool(Not \childrens)*line_size,1, $FF000000)
                EndIf
                
                ; Vertical plot
                If \adress
                  Protected start = \sublevel
                  
                  PushListPosition(*This\Items())
                  ChangeCurrentElement(*This\Items(), \adress) 
                  ;If Drawing Or (start = \sublevel And Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
                  If Drawing ;Or (start = \sublevel And Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
                    ;If Drawing Or (start = \sublevel And Bool(\y+\height>*This\y[2] And \y<*This\height[2]))
                    
                    If start
                      start = (\y+\height/2) + *This\Scroll\Y
                    Else 
                      start = (*This\y[2]+\height/2)+*This\Scroll\Y
                    EndIf
                    
                    ; DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotYCallback())
                    Line(x_point,start,1, (y_point-start), $FF000000)
                  EndIf
                  PopListPosition(*This\Items())
                EndIf
              EndIf
            EndIf
            
            If Drawing
              ; Draw boxes
              If Not *This\Flag\NoButtons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, \Color\Front[\Color\State], 0,0) 
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, text_X-\Image\Width-2, \Image\y+*This\Scroll\Y, \alpha)
              EndIf
              
              ; Draw text
              _clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
              
              ; Draw string
              If \Text[2]\Len > 0 And *This\Color\Front <> *This\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Caret[1] > *This\Caret And *This\Line[1] = *This\Line) Or (*This\Line[1] > *This\Line And *This\Line = \Item)
                    \Text[3]\X = Text_X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                    
                    If *This\Line[1] = *This\Line
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[3]\X, Text_Y, \Text[3]\String.s, *This\Color\Front)
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s, *This\Color\Front)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText(Text_X, Text_Y, \Text\String.s, *This\Color\Front)
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[2]\X, Text_Y, \Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[2])
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len > 0
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                EndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, \Color\Front[\Color\State])
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
                EndIf
              EndIf
              
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ;And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              If Bool(Not \Text[1]\Width Or *This\Caret > *This\Caret[1])
                Line((\X+*This\Scroll\X + \Text[1]\Width + \Text[2]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              Else
                Line((\X+*This\Scroll\X + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              EndIf
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(*This\Items())
          ; Draw scroll bars
          CompilerIf Defined(Scroll, #PB_Module)
            UnclipOutput()
            If \vScroll\Page\Length And \vScroll\Max<>\Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines) And
               Scroll::SetAttribute(\vScroll, #PB_ScrollBar_Maximum, \Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines))
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            If \hScroll\Page\Length And \hScroll\Max<>\Scroll\Width And
               Scroll::SetAttribute(\hScroll, #PB_ScrollBar_Maximum, \Scroll\Width)
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            
            Scroll::Draw(\vScroll)
            Scroll::Draw(\hScroll)
            
            ;           ; >>>|||
            ;           If \Scroll\Widget\Vertical\Page\Length And \Scroll\Widget\Vertical\Max<>\Scroll\Height And
            ;              Scroll::SetAttribute(\Scroll\Widget\Vertical, #PB_ScrollBar_Maximum, \Scroll\Height)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           If \Scroll\Widget\Horizontal\Page\Length And \Scroll\Widget\Horizontal\Max<>\Scroll\Width And
            ;              Scroll::SetAttribute(\Scroll\Widget\Horizontal, #PB_ScrollBar_Maximum, \Scroll\Width)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           Scroll::Draw(\Scroll\Widget\Vertical)
            ;           Scroll::Draw(\Scroll\Widget\Horizontal)
          CompilerEndIf
          
          _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
          
          ; Draw image
          If \Image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
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
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius, $FFF1F1FF)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius 
              RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF)
            EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText((\Width[1]-TextWidth("!!! Недопустимый символ"))/2, \Items()\Text[0]\Y, "!!! Недопустимый символ", $FF0000FF)
          Else
            ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            ;           If \Radius : RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[2]) : EndIf ; Сглаживание краев )))
            ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[2])
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i ______Draw(*This.Widget_S)
    Protected String.s, StringWidth, ix, iy, iwidth, iheight
    Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
    
    Protected box_size = 9,box_1_size = 12
    
    If Not *This\Hide
      
      With *This
        iX=\X[2]
        iY=\Y[2]
        CompilerIf Defined(Scroll, #PB_Module)
          iwidth = *This\width[2]-Scroll::Width(*This\vScroll)
          iheight = *This\height[2]-Scroll::Height(*This\hScroll)
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
          
          Text::MultiLine(*This)
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
      With *This\Items()
        If ListSize(*This\Items())
          PushListPosition(*This\Items())
          ForEach *This\Items()
            ; Is visible lines ---
            Drawing = Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight)
            \Hide = Bool(Not Drawing)
            
            If Drawing
               ; Debug  \Item                                                             ; Draw items back color
              
            If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
            _clip_output_(*This, *This\X[2], #PB_Ignore, *This\Width[2], #PB_Ignore) 
            
            If \Text\Change : \Text\Change = #False
              \Text\Width = TextWidth(\Text\String.s) 
              
              If \Text\FontID 
                \Text\Height = TextHeight("A") 
              Else
                \Text\Height = *This\Text\Height
              EndIf
            EndIf 
            
            If \Text[1]\Change : \Text[1]\Change = #False
              \Text[1]\Width = TextWidth(\Text[1]\String.s) 
            EndIf 
            
            If \Text[3]\Change : \Text[3]\Change = #False 
              \Text[3]\Width = TextWidth(\Text[3]\String.s)
            EndIf 
            
            If \Text[2]\Change : \Text[2]\Change = #False 
              \Text[2]\X = Text_X+\Text[1]\Width
              \Text[2]\Width = TextWidth(\Text[2]\String.s) ; bug in mac os
              \Text[3]\X = \Text[2]\X+\Text[2]\Width
            EndIf 
            
            ;               
            If *This\Focus = *This 
              Protected Left,Right
              Left =- TextWidth(Mid(*This\Text\String.s, \Text\Position, *This\Caret))
              ; Left =- (\Text[1]\Width+(Bool(*This\Caret>*This\Caret[1])*\Text[2]\Width))
              Right = (\Width + Left)
              
              If *This\Scroll\X < Left
                *This\Scroll\X = Left
              ElseIf *This\Scroll\X > Right
                *This\Scroll\X = Right
              ElseIf (*This\Scroll\X < 0 And *This\Caret = *This\Caret[1] And Not *This\Canvas\Input) ; Back string
                *This\Scroll\X = (\Width-\Text[3]\Width) + Left
                If *This\Scroll\X>0
                  *This\Scroll\X=0
                EndIf
              EndIf
            EndIf
            
          EndIf
          
          *This\sublevellen = 8
            ; Draw coordinates 
            \sublevellen = 6+((\sublevel+Bool(Not *This\Flag\NoButtons))**This\sublevellen) - *This\sublevellen/2 + Bool(*This\Flag\CheckBoxes)*13 ; (\sublevel**This\sublevellen) + (Bool(\childrens)**This\sublevellen);((\sublevel+Bool(Not *This\Flag\NoButtons))**This\sublevellen) + Bool(*This\Flag\CheckBoxes)*15
            
            Height = \Height
            Y = \Y+*This\Scroll\Y
            Text_X = \Text\X+*This\Scroll\X + \sublevellen + *This\sublevellen/2 + *This\Image\width + 14; - Bool(Not *This\Image\width) * box_size/2 - *This\sublevellen
            Text_Y = \Text\Y+*This\Scroll\Y
            
            ; Draw selections
            If Drawing And (\Item=*This\Line Or \Item=\focus Or \Item=\line) ; \Color\State;
              If \Color\Fore[\Color\State]
                DrawingMode(#PB_2DDrawing_Gradient)
                BoxGradient(\Vertical,*This\X[2],Y,iwidth,\Height,\Color\Fore[\Color\State],\Color\Back[\Color\State],\Radius)
              Else
                DrawingMode(#PB_2DDrawing_Default)
                RoundBox(*This\X[2],Y,iwidth,\Height,\Radius,\Radius,\Color\Back[\Color\State])
              EndIf
              
              DrawingMode(#PB_2DDrawing_Outlined)
              RoundBox(*This\x[2],Y,iwidth,\height,\Radius,\Radius, \Color\Frame[\Color\State])
            EndIf
            
            ; expanded & collapsed box
            If Not *This\Flag\NoButtons Or
               Not *This\Flag\NoLines 
              \box\width = box_size
              \box\height = box_size
              \box\x = \sublevellen - (\box\width)/2 + *This\sublevellen
              \box\y = (Y+height)-(height+\box\height)/2
            EndIf
            
            If *This\Flag\CheckBoxes
              \box\width[1] = box_1_size
              \box\height[1] = box_1_size
              
              \box\x[1] = (\box\width[1])/2 ;(*This\sublevellen+\box\width[1])/2 - box_size
              \box\y[1] = (Y+height)-(height+\box\height[1])/2
            EndIf
            
            ; Draw plot
            If Not *This\Flag\NoLines 
              Protected line_size=9, x_point=\sublevellen
              
              If x_point>*This\x[2] 
                Protected y_point=\box\y+\box\height/2
                
                If Drawing
                  ; Horizontal plot
                  ; DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotXCallback())
                  Line(x_point,y_point,line_size*2-2,1, $FF000000)
                EndIf
                
                ; Vertical plot
                If \adress
                  Protected start = \sublevel
                  
                  PushListPosition(*This\Items())
                  ChangeCurrentElement(*This\Items(), \adress) 
                  ;If Drawing Or (start = \sublevel And Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
                  If Drawing ;Or (start = \sublevel And Bool(\y+\height+*This\Scroll\Y>*This\y[2] And (\y-*This\y[2])+*This\Scroll\Y<iheight))
                    ;If Drawing Or (start = \sublevel And Bool(\y+\height>*This\y[2] And \y<*This\height[2]))
                    
                    If start
                      start = (\y+\height/2) + *This\Scroll\Y
                    Else 
                      start = (*This\y[2]+\height/2)+*This\Scroll\Y
                    EndIf
                    
                    ; DrawingMode(#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawPlotYCallback())
                    Line(x_point,start,1, (y_point-start), $FF000000)
                  EndIf
                  PopListPosition(*This\Items())
                EndIf
              EndIf
            EndIf
            
            If Drawing
              ; Draw boxes
              If Not *This\Flag\NoButtons And \childrens
                DrawingMode(#PB_2DDrawing_Default)
                Scroll::Arrow(\box\X[0]+(\box\Width[0]-6)/2,\box\Y[0]+(\box\Height[0]-6)/2, 6, Bool(Not \collapsed)+2, \Color\Front[\Color\State], 0,0) 
              EndIf
              
              ; Draw checkbox
              If *This\Flag\CheckBoxes
                DrawingMode(#PB_2DDrawing_Default)
                DrawBox(\box\x[1],\box\y[1],\box\width[1],\box\height[1], 3, \checked, $FFFFFFFF, $FF7E7E7E, 2, 255)
              EndIf
              
              ; Draw image
              If \Image\handle
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Image\handle, text_X-\Image\Width-2, \Image\y+*This\Scroll\Y, \alpha)
              EndIf
              
              ; Draw text
              _clip_output_(*This, \X, #PB_Ignore, \Width, #PB_Ignore) 
              
              ; Draw string
              If \Text[2]\Len > 0 And *This\Color\Front <> *This\Color\Front[2]
                
                CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                  If (*This\Caret[1] > *This\Caret And *This\Line[1] = *This\Line) Or (*This\Line[1] > *This\Line And *This\Line = \Item)
                    \Text[3]\X = Text_X+TextWidth(Left(\Text\String.s, *This\Caret[1])) 
                    
                    If *This\Line[1] = *This\Line
                      \Text[2]\X = \Text[3]\X-\Text[2]\Width
                    EndIf
                    
                    If \Text[3]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[3]\X, Text_Y, \Text[3]\String.s, *This\Color\Front)
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                    
                    If \Text[1]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(Text_X, Text_Y, \Text[1]\String.s, *This\Color\Front)
                    EndIf
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawText(Text_X, Text_Y, \Text\String.s, *This\Color\Front)
                    
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                    
                    If \Text[2]\String.s
                      DrawingMode(#PB_2DDrawing_Transparent)
                      DrawText(\Text[2]\X, Text_Y, \Text[2]\String.s, *This\Color\Front[2])
                    EndIf
                  EndIf
                CompilerElse
                  If \Text[1]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                  
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                  
                  If \Text[2]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[2])
                  EndIf
                  
                  If \Text[3]\String.s
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front)
                  EndIf
                CompilerEndIf
                
              Else
                If \Text[2]\Len > 0
                  DrawingMode(#PB_2DDrawing_Default)
                  Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, *This\Color\Frame[2])
                EndIf
                
                If \Color\State = 2
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, \Color\Front[\Color\State])
                Else
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, Bool(\Text\Vertical)**This\Text\Rotate, *This\Color\Front[*This\Color\State])
                EndIf
              EndIf
              
            EndIf
          Next
          PopListPosition(*This\Items()) ; 
          
          If *This\Focus = *This 
            Debug ""+ \Caret +" "+ \Caret[1] +" "+ \Text[1]\Width +" "+ \Text[1]\String.s
            If (*This\Text\Editable Or \Text\Editable) ;And *This\Caret = *This\Caret[1] And *This\Line = *This\Line[1] And Not \Text[2]\Width[2] 
              DrawingMode(#PB_2DDrawing_XOr)             
              If Bool(Not \Text[1]\Width Or *This\Caret > *This\Caret[1])
                Line((\X+*This\Scroll\X + \Text[1]\Width + \Text[2]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              Else
                Line((\X+*This\Scroll\X + \Text[1]\Width) - Bool(*This\Scroll\X = Right), \Y+*This\Scroll\Y, 1, Height, $FFFFFFFF)
              EndIf
            EndIf
          EndIf
        EndIf
      EndWith  
      
      ; Draw frames
      With *This
        If ListSize(*This\Items())
          ; Draw scroll bars
          CompilerIf Defined(Scroll, #PB_Module)
            UnclipOutput()
            If \vScroll\Page\Length And \vScroll\Max<>\Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines) And
               Scroll::SetAttribute(\vScroll, #PB_ScrollBar_Maximum, \Scroll\Height+Bool(\Text\Count<>1 And \Flag\GridLines))
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            If \hScroll\Page\Length And \hScroll\Max<>\Scroll\Width And
               Scroll::SetAttribute(\hScroll, #PB_ScrollBar_Maximum, \Scroll\Width)
              Scroll::Resizes(\vScroll, \hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
            
            Scroll::Draw(\vScroll)
            Scroll::Draw(\hScroll)
            
            ;           ; >>>|||
            ;           If \Scroll\Widget\Vertical\Page\Length And \Scroll\Widget\Vertical\Max<>\Scroll\Height And
            ;              Scroll::SetAttribute(\Scroll\Widget\Vertical, #PB_ScrollBar_Maximum, \Scroll\Height)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           If \Scroll\Widget\Horizontal\Page\Length And \Scroll\Widget\Horizontal\Max<>\Scroll\Width And
            ;              Scroll::SetAttribute(\Scroll\Widget\Horizontal, #PB_ScrollBar_Maximum, \Scroll\Width)
            ;             Scroll::Resizes(\Scroll\Widget\Vertical, \Scroll\Widget\Horizontal, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            ;           EndIf
            ;           
            ;           Scroll::Draw(\Scroll\Widget\Vertical)
            ;           Scroll::Draw(\Scroll\Widget\Horizontal)
          CompilerEndIf
          
          _clip_output_(*This, \X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2)
          
          ; Draw image
          If \Image\handle
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Image\handle, \Image\x, \Image\y, \alpha)
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
          If \Default = *This : \Default = 0
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius, $FFF1F1FF)
            
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\X[1]-1,\Y[1]-1,\Width[1]+2,\Height[1]+2,\Radius,\Radius,$FF004DFF)
            If \Radius 
              RoundBox(\X[1],\Y[1]-1,\Width[1],\Height[1]+2,\Radius,\Radius,$FF004DFF)
            EndIf
            RoundBox(\X[1],\Y[1],\Width[1],\Height[1],\Radius,\Radius,$FF004DFF)
            
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawText((\Width[1]-TextWidth("!!! Недопустимый символ"))/2, \Items()\Text[0]\Y, "!!! Недопустимый символ", $FF0000FF)
          Else
            ; DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter) : CustomFilterCallback(@DrawFilterCallback())
            RoundBox(\X[1]+2,\Y[1]+2,\Width[1]-4,\Height[1]-4,\Radius,\Radius,\Color\Frame[2])
            ;           If \Radius : RoundBox(\X[1]+2,\Y[1]+3,\Width[1]-4,\Height[1]-6,\Radius,\Radius,\Color\Frame[2]) : EndIf ; Сглаживание краев )))
            ;           RoundBox(\X[1]+3,\Y[1]+3,\Width[1]-6,\Height[1]-6,\Radius,\Radius,\Color\Frame[2])
          EndIf
        EndIf
        
        If \Text\Change : \Text\Change = 0 : EndIf
        If \Resize : \Resize = 0 : EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure ReDraw(*This.Widget_S)
    If StartDrawing(CanvasOutput(*This\Canvas\Gadget))
      Draw(*This)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i SetItemState(*This.Widget_S, Item.i, State.i)
    Protected Result, sublevel
    
    With *This
      ; If (\Flag\MultiSelect Or \Flag\ClickSelect)
      PushListPosition(\Items())
      Result = SelectElement(\Items(), Item) 
      If Result 
        If State&#PB_Attribute_Selected
          \Items()\Line = \Items()\Item
          \Items()\Color\State = Bool(State)+1
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
        
      EndIf
      PopListPosition(\Items())
      ; EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, State.i)
    With *This
      Text::Redraw(*This, \Canvas\Gadget)
      
      PushListPosition(\Items())
      SelectElement(\Items(), State) : \Items()\Focus = State : \Items()\Line = \Items()\Item : \Items()\Color\State = 2
      Scroll::SetState(\vScroll, ((State*\Text\Height)-\vScroll\Height) + \Text\Height) : \Scroll\Y =- \vScroll\Page\Pos ; в конце
                                                                                                                         ; Scroll::SetState(\vScroll, (State*\Text\Height)) : \Scroll\Y =- \vScroll\Page\Pos ; в начале 
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  Procedure.i GetState(*This.Widget_S)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Focus = \Items()\Item
          Result = \Items()\Item
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i, Canvas.i=-1)
    With *This
      If Text::Resize(*This, X,Y,Width,Height)
        Scroll::Resizes(\vScroll, \hScroll, \x[2],\Y[2],\Width[2],\Height[2])
      EndIf
      ProcedureReturn \Resize
    EndWith
  EndProcedure
  
  Procedure.i Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\vScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0, \hScroll, \Canvas\Window, \Canvas\Gadget)
      If Repaint
        \Scroll\Y =- \vScroll\Page\Pos
      EndIf
      Repaint | Scroll::CallBack(\hScroll, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y,0, 0, \vScroll, \Canvas\Window, \Canvas\Gadget)
      If Repaint
        \Scroll\X =- \hScroll\Page\Pos
      EndIf
    EndWith
    
    If *This And (Not *This\vScroll\Buttons And Not *This\hScroll\Buttons)
      If ListSize(*This\items())
        With *This
          If Not \Hide And Not \Disable And \Interact
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType 
              Case #PB_EventType_LostFocus 
                \Focus =- 1
                \Line =- 1
                \Items()\Focus =- 1
                \Items()\Line = \Items()\Item
                \Items()\Color\State = 1
                Repaint = #True
                Debug 555
                PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
                
              Case #PB_EventType_Focus 
                Repaint = #True 
                
              Case #PB_EventType_LeftClick : PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_LeftClick)
              Case #PB_EventType_RightClick : PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_RightClick)
              Case #PB_EventType_LeftDoubleClick : PostEvent(#PB_Event_Widget, \Canvas\Window, *This, #PB_EventType_LeftDoubleClick)
                
              Case #PB_EventType_MouseLeave
                \Line =- 1
                
              Case #PB_EventType_LeftButtonDown
                PushListPosition(\Items()) 
                ForEach \Items()
                  If \Line = \Items()\Item 
                    \Line[1] = \Line
                    
                    If \Flag\ClickSelect
                      \Items()\Color\State ! 2
                    Else
                      ; \Items()\Line = \Items()\Item
                      \Items()\Color\State = 2
                    EndIf
                    
                    ; \Items()\Focus = \Items()\Item 
                  ElseIf ((Not \Flag\ClickSelect And \Items()\Focus = \Items()\Item) Or \Flag\MultiSelect) And Not Control
                    \Items()\Line =- 1
                    \Items()\Color\State = 1
                    \Items()\Focus =- 1
                  EndIf
                Next
                PopListPosition(\Items()) 
                Repaint = 1
                
              Case #PB_EventType_LeftButtonUp
                PushListPosition(\Items()) 
                ForEach \Items()
                  If \Line = \Items()\Item 
                    \Items()\Focus = \Items()\Item 
                  Else
                    If (Not \Flag\MultiSelect And Not \Flag\ClickSelect)
                      \items()\Color\State = 1
                    EndIf
                  EndIf
                Next
                PopListPosition(\Items()) 
                Repaint = 1
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\Y < \Y Or \Canvas\Mouse\X > Scroll::X(\vScroll)
                  Item.i =- 1
                ElseIf \Text\Height
                  Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
                EndIf
                
                If \Line <> Item And Item =< ListSize(\Items())
                  If isItem(\Line, \Items()) 
                    If \Line <> ListIndex(\Items())
                      SelectElement(\Items(), \Line) 
                    EndIf
                    
                    If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton 
                      If (\Flag\MultiSelect And Not Control)
                        \items()\Color\State = 2
                      ElseIf Not \Flag\ClickSelect
                        \items()\Color\State = 1
                      EndIf
                    EndIf
                  EndIf
                  
                  If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton And itemSelect(Item, \Items())
                    If (Not \Flag\MultiSelect And Not \Flag\ClickSelect)
                      \items()\Color\State = 2
                    ElseIf Not \Flag\ClickSelect And (\Flag\MultiSelect And Not Control)
                      \Items()\Line = \Items()\Item
                      \items()\Color\State = 2
                    EndIf
                  EndIf
                  
                  \Line = Item
                  Repaint = #True
                  
                  If \Canvas\Mouse\Buttons & #PB_Canvas_LeftButton
                    If (\Flag\MultiSelect And Not Control)
                      PushListPosition(\Items()) 
                      ForEach \Items()
                        If  Not \Items()\Hide
                          If ((\Line[1] =< \Line And \Line[1] =< \Items()\Item And \Line >= \Items()\Item) Or
                              (\Line[1] >= \Line And \Line[1] >= \Items()\Item And \Line =< \Items()\Item)) 
                            If \Items()\Line <> \Items()\Item
                              \Items()\Line = \Items()\Item
                              \items()\Color\State = 2
                            EndIf
                          Else
                            \Items()\Line =- 1
                            \Items()\Color\State = 1
                            \Items()\Focus =- 1
                          EndIf
                        EndIf
                      Next
                      PopListPosition(\Items()) 
                    EndIf
                    
                    ; ; ;                   If \Line[1] =< \Line
                    ; ; ;                     PushListPosition(\Items()) 
                    ; ; ;                     While PreviousElement(\Items()) And \Line[1] < \Items()\Item And Not \Items()\Hide
                    ; ; ;                       If \Items()\Line <> \Items()\Item
                    ; ; ;                         \Items()\Line = \Items()\Item
                    ; ; ;                         \items()\Color\State = 2
                    ; ; ;                       EndIf
                    ; ; ;                     Wend
                    ; ; ;                     PopListPosition(\Items()) 
                    ; ; ;                     PushListPosition(\Items()) 
                    ; ; ;                     While NextElement(\Items()) And \Items()\Line = \Items()\Item And Not \Items()\Hide
                    ; ; ;                       \Items()\Line =- 1
                    ; ; ;                       \Items()\Color\State = 1
                    ; ; ;                       \Items()\Focus =- 1
                    ; ; ;                     Wend
                    ; ; ;                     PopListPosition(\Items()) 
                    ; ; ;                     PushListPosition(\Items()) 
                    ; ; ;                     If \Line[1] = \Line And PreviousElement(\Items()) And \Items()\Line = \Items()\Item And Not \Items()\Hide
                    ; ; ;                       \Items()\Line =- 1
                    ; ; ;                       \Items()\Color\State = 1
                    ; ; ;                       \Items()\Focus =- 1
                    ; ; ;                     EndIf
                    ; ; ;                     PopListPosition(\Items()) 
                    ; ; ;                   ElseIf \Line[1] > \Line
                    ; ; ;                     PushListPosition(\Items()) 
                    ; ; ;                     While NextElement(\Items()) And \Line[1] > \Items()\Item And Not \Items()\Hide
                    ; ; ;                       If \Items()\Line <> \Items()\Item
                    ; ; ;                         \Items()\Line = \Items()\Item
                    ; ; ;                         \items()\Color\State = 2
                    ; ; ;                       EndIf
                    ; ; ;                     Wend
                    ; ; ;                     PopListPosition(\Items()) 
                    ; ; ;                     PushListPosition(\Items()) 
                    ; ; ;                     While PreviousElement(\Items()) And \Items()\Line = \Items()\Item And Not \Items()\Hide
                    ; ; ;                       \Items()\Line =- 1
                    ; ; ;                       \Items()\Color\State = 1
                    ; ; ;                       \Items()\Focus =- 1
                    ; ; ;                     Wend
                    ; ; ;                     PopListPosition(\Items()) 
                    ; ; ;                   EndIf
                  EndIf
                EndIf
                
              Default
                itemSelect(\Line[1], \Items())
            EndSelect
          EndIf
        EndWith    
        
        With *This\items()
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
      *This\Line =- 1
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Tree
        \Cursor = #PB_Cursor_Default
        \DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \sublevellen = 18
        \Alpha = 255
        \Interact = 1
        \Caret[1] =- 1
        \Line =- 1
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
        
        If Text::Resize(*This, X,Y,Width,Height, Canvas)
          \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
          \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
          \Flag\NoButtons = Bool(flag&#PB_Flag_NoButtons)
          \Flag\NoLines = Bool(flag&#PB_Flag_NoLines)
          \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)
          \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
          \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)
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
          
          If \Text\Editable
            \Text\Editable = 0
            \Color[0]\Back[0] = $FFFFFFFF 
          Else
            \Color[0]\Back[0] = $FFF0F0F0  
          EndIf
          
        EndIf
        
        Scroll::Widget(\vScroll, #PB_Ignore, #PB_Ignore, 16, #PB_Ignore, 0,0,0, #PB_ScrollBar_Vertical, 7)
        If Bool(Not \flag\NoButtons Or Not \flag\NoLines)
          Scroll::Widget(\hScroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 16, 0,0,0, 0, 7)
        EndIf
        Scroll::Resizes(\vScroll, \hScroll, \x[2],\Y[2],\Width[2],\Height[2])
        \Resize = 0
      EndWith
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
      PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure Canvas_CallBack()
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
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
EndModule

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Tree
  
  Procedure Events()
    If EventType() = #PB_EventType_LeftClick
      ;       If GadgetType(EventGadget()) = #PB_GadgetType_Tree
      ;         Debug GetGadgetText(EventGadget())
      ;         Debug GetGadgetState(EventGadget())
      ;         Debug GetGadgetItemState(EventGadget(), GetGadgetState(EventGadget()))
      ;       Else
      ;         Debug GetText(EventGadget())
      ;         Debug GetState(EventGadget())
      ;         Debug GetItemState(EventGadget(), GetState(EventGadget()))
      ;       EndIf
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
    TreeGadget(g, 450, 10, 210, 210, #PB_Tree_AlwaysShowSelection|#PB_Tree_CheckBoxes)  ; |#PB_Tree_NoLines|#PB_Tree_NoButtons                                       
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
    Gadget(g, 10, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Tree_CheckBoxes|#PB_Flag_FullSelection)                                         
    *g = GetGadgetData(g)
    
  Define time = ElapsedMilliseconds()
   AddItem (*g, -1, "Item "+Str(a), -1);,Random(5)+1)
   For a = 1 To 1500
    AddItem (*g, -1, "Item "+Str(a), -1, 1);,Random(5)+1)
    If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
    EndIf
    If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
      Debug a
    EndIf
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + CountItems(*g)
  
  Text::Redraw(*g)
  
; ; ;     ; 1_example
; ; ;     AddItem (*g, 0, "Normal Item "+Str(a), -1, 0)                                   
; ; ;     AddItem (*g, -1, "Node "+Str(a), 0, 0)                                         
; ; ;     AddItem (*g, -1, "Sub-Item 1", -1, 1)                                           
; ; ;     AddItem (*g, -1, "Sub-Item 2", -1, 11)
; ; ;     AddItem (*g, -1, "Sub-Item 3", -1, 1)
; ; ;     AddItem (*g, -1, "Sub-Item 4", -1, 1)                                           
; ; ;     AddItem (*g, -1, "Sub-Item 5", -1, 11)
; ; ;     AddItem (*g, -1, "Sub-Item 6", -1, 1)
; ; ;     AddItem (*g, -1, "File "+Str(a), -1, 0)  
; ; ;     For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
; ; ;     
; ; ;     ; RemoveItem(*g,1)
; ; ;     Tree::SetItemState(*g, 1, #PB_Tree_Selected|#PB_Tree_Collapsed|#PB_Tree_Checked)
; ; ;     BindGadgetEvent(g, @Events())
; ; ;     ;Tree::SetState(*g, 1)
; ; ;     ;Tree::SetState(*g, -1)
    ;     Debug "c "+Tree::GetText(*g)
    
    g = 11
    Gadget(g, 230, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection)                                         
    *g = GetGadgetData(g)
    ;  3_example
    AddItem(*g, 0, "Tree_0", -1 )
    AddItem(*g, 1, "Tree_1_1", 0, 1) 
    AddItem(*g, 4, "Tree_1_1_1", -1, 2) 
    AddItem(*g, 5, "Tree_1_1_2", -1, 2) 
    AddItem(*g, 6, "Tree_1_1_2_1", -1, 3) 
    AddItem(*g, 8, "Tree_1_1_2_1_1_4 and scroll end", -1, 4) 
    AddItem(*g, 7, "Tree_1_1_2_2", -1, 3) 
    AddItem(*g, 2, "Tree_1_2", -1, 1) 
    AddItem(*g, 3, "Tree_1_3", -1, 1) 
    AddItem(*g, 9, "Tree_2",-1 )
    AddItem(*g, 10, "Tree_3", -1 )
    
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
    Gadget(g, 450, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Flag_FullSelection|#PB_Flag_CheckBoxes)    ; |#PB_Flag_NoLines|#PB_Flag_NoButtons                                    
    *g = GetGadgetData(g)
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
    Gadget(g, 670, 230, 210, 210, #PB_Flag_AlwaysSelection|#PB_Tree_NoLines)                                         
    *g = GetGadgetData(g)
    ;  4_example
    AddItem(*g, 0, "Tree_0 (NoLines|AlwaysShowSelection)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 3, "Tree_3_1", -1, 1) 
    AddItem(*g, 3, "Tree_3_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    
    g = 14
    Gadget(g, 890, 230, 103, 210, #PB_Flag_AlwaysSelection|#PB_Tree_NoButtons)                                         
    *g = GetGadgetData(g)
    ;  5_example
    AddItem(*g, 0, "Tree_0 (NoButtons)", -1 )
    AddItem(*g, 1, "Tree_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_1", -1, 1) 
    AddItem(*g, 2, "Tree_2_2", -1, 2) 
    For i=0 To CountItems(*g) : SetItemState(*g, i, #PB_Tree_Expanded) : Next
    
    g = 15
    Gadget(g, 890+106, 230, 103, 210, #PB_Flag_AlwaysSelection|#PB_Flag_BorderLess)                                         
    *g = GetGadgetData(g)
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
; Folding = ---4-------F+--8------------------C8-p-f--------------8-----------------------------------
; EnableXP