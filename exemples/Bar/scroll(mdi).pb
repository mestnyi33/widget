IncludePath "../../"
XIncludeFile "widgets.pbi"

;-
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule widget
  EnableExplicit
  
  Structure canvasitem
    img.i
    x.i
    y.i
    width.i
    height.i
    alphatest.i
  EndStructure
  
  Enumeration
    #MyCanvas = 1   ; just to test whether a number different from 0 works now
  EndEnumeration
  
  Global Window_demo, v, h
  
  Global g_container, g_value, g_is_vertical, g_min, g_max, g_pos, g_len, g_set, g_page_pos, g_page_len, g_area_pos, g_area_len, g_Canvas
  
  Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
  Global x=151,y=151, Width=790, Height=600 , focus
  
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, drag.i, hole.i
  Global NewList Images.canvasitem()
  
  Macro GetScrollCoordinate()
    ;  *Scroll\y =- *Scroll\v\Page\Pos 
    If focus
      ;       Scroll_x = *Scroll\x
      ;       Scroll_y = *Scroll\y
      PushListPosition(Images())
      ForEach Images()
        Debug Images()\y 
        ;         If Scroll_y > Images()\y 
        ;           Scroll_y = Images()\y
        ;         EndIf
        ;         
        ;         If Scroll_x > Images()\x 
        ;           Scroll_x = Images()\x
        ;         EndIf
      Next
      PopListPosition(Images())
      ;       Scroll_x = *Scroll\x
      ;       Scroll_y = *Scroll\y
    EndIf
    
    *Scroll\Width = *Scroll\x+Images()\width
    *Scroll\Height = *Scroll\y+Images()\height 
    
    PushListPosition(Images())
    ForEach Images()
      If *Scroll\y > Images()\y 
        *Scroll\y = Images()\y
      EndIf
      
      If *Scroll\x > Images()\x 
        *Scroll\x = Images()\x
      EndIf
      
      If *Scroll\Width < Images()\x+Images()\width
        *Scroll\Width = Images()\width+Images()\x
      EndIf
      
      If *Scroll\height < Images()\Y+Images()\height 
        *Scroll\height = Images()\height+Images()\Y
      EndIf 
    Next
    PopListPosition(Images())
    
    ;     If *Scroll\y < Images()\y 
    ;         *Scroll\y = Images()\y
    ;       EndIf
    ;       
    ;       If *Scroll\x > Images()\x 
    ;         *Scroll\x = Images()\x
    ;       EndIf
    
    ;     If *Scroll\x > 0
    ;       *Scroll\x = 0
    ;     EndIf
    ; ;     If *Scroll\y > 0
    ; ;       *Scroll\y =- *Scroll\v\Page\Pos
    ; ;     EndIf
    ; ;     
    ;     ;                                 If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
    ;     ;                                   *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
    ;     ;                                 EndIf
    ;     
    ;     If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
    ;       *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
    ;     EndIf
    ;     
    ;     *Scroll\Width-*Scroll\x
    ;     *Scroll\height-*Scroll\y
    
  EndMacro
  
  Procedure AddImage (List Images.canvasitem(), x, y, img, alphatest=0)
    If AddElement(Images())
      Images()\img    = img
      Images()\x      = x
      Images()\y      = y
      Images()\width  = ImageWidth(img)
      Images()\height = ImageHeight(img)
      Images()\alphatest = alphatest
    EndIf
  EndProcedure
  
  Procedure pb_scroll_update()
    With *Scroll
      SetGadgetState(v, GetState(\v))
      SetGadgetAttribute(v, #PB_ScrollBar_Minimum, GetAttribute(\v, #PB_ScrollBar_Minimum))
      SetGadgetAttribute(v, #PB_ScrollBar_Maximum, GetAttribute(\v, #PB_ScrollBar_Maximum))
      SetGadgetAttribute(v, #PB_ScrollBar_PageLength, GetAttribute(\v, #PB_ScrollBar_PageLength))
      ResizeGadget(v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\height)
      
      SetGadgetState(h, GetState(\h))
      SetGadgetAttribute(h, #PB_ScrollBar_Minimum, GetAttribute(\h, #PB_ScrollBar_Minimum))
      SetGadgetAttribute(h, #PB_ScrollBar_Maximum, GetAttribute(\h, #PB_ScrollBar_Maximum))
      SetGadgetAttribute(h, #PB_ScrollBar_PageLength, GetAttribute(\h, #PB_ScrollBar_PageLength))
      ResizeGadget(h, #PB_Ignore, #PB_Ignore, \h\width, #PB_Ignore)
      
      
    EndWith
  EndProcedure
  
  Procedure Canvas_ReDraw (canvas.i, List Images.canvasitem())
    With *Scroll
      pb_scroll_update()
      
      If StartDrawing(CanvasOutput(canvas))
        
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
        
        ; ClipOutput(\h\x, \v\y, \h\Page\len, \v\Page\len)
        DrawingMode(#PB_2DDrawing_AlphaBlend)
        ;       If focus And ChangeCurrentElement(Images(), focus)
        ;         DrawImage(ImageID(Images()\img),x+(Images()\x - \h\Page\Pos), y+(Images()\y)) ; draw all images with z-order
        ;       Else
        ForEach Images()
          ;  DrawImage(ImageID(Images()\img),x+(Images()\x - \h\Page\Pos), y+(Images()\y - \v\Page\Pos)) ; draw all images with z-order
          DrawImage(ImageID(Images()\img),x+(Images()\x - Bool(Not focus) * \h\Page\Pos), y+(Images()\y - Bool(Not focus) * \v\Page\Pos)) ; draw all images with z-order
        Next
        ;       EndIf
        ;UnclipOutput()
        
        Draw(\v)
        Draw(\h)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        
        ; widget area coordinate
        Box(x-1, y-1, Width-x*2+2, Height-y*2+2, $0000FF)
        
        ; Scroll area coordinate
        Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
        
        ; page coordinate
        Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
        
        ; area coordinate
        Box(\h\x, \v\y, \h\Area\Len, \v\Area\Len, $00FFFF)
        
        ; scroll coordinate
        Box(\h\x, \v\y, \h\width, \v\height, $FF00FF)
        
        ; frame coordinate
        Box(\h\x, \v\y, 
            \h\Page\len + (Bool(Not \v\hide) * \v\width),
            \v\Page\len + (Bool(Not \h\hide) * \h\height), $FFFF00)
        
        StopDrawing()
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i HitTest (List Images.canvasitem(), mouse_x, mouse_y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, isCurrentItem.i = #False
    
    With *Scroll
      If LastElement(Images()) ; search for hit, starting from end (z-order)
        Repeat
          If mouse_x >= x+Images()\x - \h\Page\Pos And mouse_x < x+Images()\x - \h\Page\Pos + Images()\width
            If mouse_y >= y+Images()\y - \v\Page\Pos And mouse_y < y+Images()\y - \v\Page\Pos + Images()\height
              alpha = 255
              
              If Images()\alphatest And ImageDepth(Images()\img)>31
                If StartDrawing(ImageOutput(Images()\img))
                  DrawingMode(#PB_2DDrawing_AlphaChannel)
                  
                  alpha = Alpha(Point(mouse_x-Images()\x, mouse_y-Images()\y)) ; get alpha
                  StopDrawing()
                EndIf
              EndIf
              
              If alpha
                MoveElement(Images(), #PB_List_Last)
                isCurrentItem = #True
                currentItemXOffset = mouse_x - Images()\x
                currentItemYOffset = mouse_y - Images()\y
                Break
              EndIf
            EndIf
          EndIf
        Until PreviousElement(Images()) = 0
      EndIf
    EndWith
    
    ProcedureReturn isCurrentItem
  EndProcedure
  
  AddImage(Images(),  10,  10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
  AddImage(Images(), 100, 60, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
  AddImage(Images(),  50, 160, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))
  
  ;   hole = CreateImage(#PB_Any,100,100,32)
  ;   If StartDrawing(ImageOutput(hole))
  ;     DrawingMode(#PB_2DDrawing_AllChannels)
  ;     Box(0,0,100,100,RGBA($00,$00,$00,$00))
  ;     Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
  ;     Circle(50,50,30,RGBA($00,$00,$00,$00))
  ;     StopDrawing()
  ;   EndIf
  ;   AddImage(Images(),170,70,hole,1)
  
  
  Procedure BarUpdates(*v.Bar_S, *h.Bar_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height) ; Ok
    Protected iWidth = (*v\X-*h\X)+ Bool(*v\Hide) * *v\Width                                                ; X(*v)
    Protected iHeight = (*h\Y-*v\Y)+ Bool(*h\Hide) * *h\height                                              ; Y(*h)
    Static hPos, vPos : vPos = *v\Page\Pos : hPos = *h\Page\Pos
    
    ; Вправо работает как надо
    If ScrollArea_Width<*h\Page\Pos+iWidth 
      ScrollArea_Width=*h\Page\Pos+iWidth
      ; Влево работает как надо
    ElseIf ScrollArea_X>*h\Page\Pos And
           ScrollArea_Width=*h\Page\Pos+iWidth 
      ScrollArea_Width = iWidth
    EndIf
    
    ; Вниз работает как надо
    If ScrollArea_Height<*v\Page\Pos+iHeight
      ScrollArea_Height=*v\Page\Pos+iHeight 
      ; Верх работает как надо
    ElseIf ScrollArea_Y>*v\Page\Pos And
           ScrollArea_Height=*v\Page\Pos+iHeight 
      ScrollArea_Height = iHeight 
    EndIf
    
    If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
    If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
    
    If ScrollArea_Y<*v\Page\Pos : ScrollArea_Height-ScrollArea_Y-*v\Page\Pos : EndIf
    If ScrollArea_X<*h\Page\Pos : ScrollArea_Width-ScrollArea_X-*h\Page\Pos : EndIf
    
    SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollArea_Height)
    SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollArea_Width)
    
    If *v\Page\Len<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\Page\Len<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If ScrollArea_Y<>*v\Page\Pos 
      SetState(*v, -ScrollArea_Y);(ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) 
    EndIf
    
    ;If ScrollArea_X<0 : SetState(*h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    If ScrollArea_X<>*h\Page\Pos 
      SetState(*h, -ScrollArea_X) 
    EndIf
    
    *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*h\Y + Bool(*h\Hide) * *h\Height) - *v\Y) ; #PB_Ignore, *h) 
    *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, (*v\X + Bool(*v\Hide) * *v\Width) - *h\X, #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, *v)
    
    *Scroll\Y =- *v\Page\Pos
    *Scroll\X =- *h\Page\Pos
    *Scroll\width = *v\Max
    *Scroll\height = *h\Max
    
    ;   If *v\Hide : *v\Page\Pos = 0 : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
    ;   If *h\Hide : *h\Page\Pos = 0 : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
    
    ;   If *v\Hide : *v\Page\Pos = 0 : If vPos : *v\Hide = vPos : EndIf : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
    ;   If *h\Hide : *h\Page\Pos = 0 : If hPos : *h\Hide = hPos : EndIf : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure BarResize(*v.Bar_s, X,Y,Width,Height, *h.Bar_s )
    
    ; ; ;     
    ; ; ;       If y=#PB_Ignore : y = *v\Y : EndIf
    ; ; ;       If x=#PB_Ignore : x = *h\X : EndIf
    ; ; ;       If Width=#PB_Ignore : Width = *v\X-*h\X+*v\width : EndIf
    ; ; ;       If Height=#PB_Ignore : Height = *h\Y-*v\Y+*h\height : EndIf
    ; ; ;       
    ; ; ;       ; Debug ""+Width +" "+ Str(*v\X-*h\X+*v\width)
    ; ; ;       
    ; ; ;       SetAttribute(*v, #PB_ScrollBar_PageLength, Height - Bool(*h\hide) * *h\height) 
    ; ; ;       SetAttribute(*h, #PB_ScrollBar_PageLength, Width - Bool(*v\hide) * *v\width)  
    ; ; ;       
    ; ; ;       *v\Hide = Resize(*v, x+*h\Page\Len, y, #PB_Ignore, Height)
    ; ; ;       *h\Hide = Resize(*h, x, y+*v\Page\len, Width, #PB_Ignore)
    ; ; ;       
    ; ; ; ; ;       SetAttribute(*v, #PB_ScrollBar_PageLength, Height - Bool(Not *h\hide) * *h\height)
    ; ; ; ; ;       SetAttribute(*h, #PB_ScrollBar_PageLength, Width - Bool(Not *v\hide) * *v\width)
    ; ; ; ;        SetAttribute(*v, #PB_ScrollBar_PageLength, Height - Bool(Not *h\hide) * *h\height) 
    ; ; ; ;       SetAttribute(*h, #PB_ScrollBar_PageLength, Width -  Bool(Not *v\hide) * *v\width)  
    ; ; ; ;      
    ; ; ; ;       *v\Hide = Resize(*v, x+*h\Page\len, #PB_Ignore, #PB_Ignore, Height + Bool(*v\Radius And Not *h\Hide)*4)
    ; ; ; ;       *h\Hide = Resize(*h, #PB_Ignore, y+*v\Page\len, Width + Bool(*h\Radius And Not *v\Hide)*4, #PB_Ignore)
    
    If Width=#PB_Ignore 
      Width = *v\X+*v\Width
    EndIf
    If Height=#PB_Ignore 
      Height = *h\Y+*h\Height
    EndIf
    
    SetAttribute(*v, #PB_ScrollBar_PageLength, Height-Bool(Not *h\Hide) * *h\height)
    SetAttribute(*h, #PB_ScrollBar_PageLength, Width-Bool(Not *v\Hide) * *v\width)
    
    *v\Hide = Resize(*v, (x+Width)-*v\Width, Y, #PB_Ignore, (*h\Y+Bool(*h\Hide) * *h\Height) - *v\Y)
    *h\Hide = Resize(*h, X, (y+Height)-*h\Height, (*v\X+Bool(*v\Hide) * *v\width) - *h\X, #PB_Ignore)
    
    SetAttribute(*v, #PB_ScrollBar_PageLength, Height-Bool(Not *h\Hide) * *h\height)
    SetAttribute(*h, #PB_ScrollBar_PageLength, Width-Bool(Not *v\Hide) * *v\width)
    
    *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((*h\Y+Bool(*h\Hide) * *h\Height) - *v\Y) + Bool(*v\Radius And Not *h\Hide)*4)
    *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, ((*v\X+Bool(*v\Hide) * *v\width) - *h\X) + Bool(*h\Radius And Not *v\Hide)*4, #PB_Ignore)
    ProcedureReturn 1
    
    
    ; ;     ; ;     Static.l w,h
    ; ;     ;     
    ; ;     ; ;     If Width=#PB_Ignore 
    ; ;     ; ;       Width = *v\X+*v\Width
    ; ;     ; ;       If Not *v\Hide And w 
    ; ;     ; ;         Width+w : w=0 
    ; ;     ; ;       EndIf
    ; ;     ; ;     Else
    ; ;     ; ;       Width+*h\x 
    ; ;     ; ;       w=X
    ; ;     ; ;     EndIf
    ; ;     ; ;     If Height=#PB_Ignore 
    ; ;     ; ;       Height = *h\Y+*h\Height
    ; ;     ; ;       If Not *h\Hide And h
    ; ;     ; ;         Height+h : h=0
    ; ;     ; ;       EndIf
    ; ;     ; ;     Else
    ; ;     ; ;       Height+*v\y 
    ; ;     ; ;       h=Y
    ; ;     ; ;     EndIf
    ; ;     
    ; ;     If Width=#PB_Ignore 
    ; ;       Width = *v\X+*v\Width
    ; ;     EndIf
    ; ;     If Height=#PB_Ignore 
    ; ;       Height = *h\Y+*h\Height
    ; ;     EndIf
    ; ;     
    ; ;     Protected iWidth = Width-Width(*v), iHeight = Height-Height(*h)
    ; ;     
    ; ;     If *v\width And *v\Page\Len<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    ; ;     If *h\height And *h\Page\Len<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    ; ;     
    ; ;     *v\Hide = Resize(*v, Width+x-*v\Width, Y, #PB_Ignore, #PB_Ignore, *h) : iWidth = Width-Width(*v)
    ; ;     *h\Hide = Resize(*h, X, Height+y-*h\Height, #PB_Ignore, #PB_Ignore, *v) : iHeight = Height-Height(*h)
    ; ;     
    ; ;     If *v\width And *v\Page\Len<>iHeight : SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    ; ;     If *h\height And *h\Page\Len<>iWidth : SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    ; ;     
    ; ;     If *v\width
    ; ;       *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*h\Y + Bool(*h\Hide) * *h\Height) - *v\Y) ; #PB_Ignore, *h) ;
    ; ;     EndIf
    ; ;     If *h\height
    ; ;       *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*v\X + Bool(*v\Hide) * *v\Width) - *h\X, #PB_Ignore) ; #PB_Ignore, #PB_Ignore, *v) ;
    ; ;     EndIf
    ; ;     
    ; ; ;     If *v\Hide 
    ; ; ;       *v\Page\Pos = 0 
    ; ; ;     Else
    ; ; ;       ; Если есть вертикальная и горизонтальная полоса,
    ; ; ;       ; то окрашиваем прамоугольник между ними
    ; ; ;      ; *h\Width = Width
    ; ; ;     EndIf
    ; ; ;     If *h\Hide 
    ; ; ;       *h\Page\Pos = 0 
    ; ; ;     Else
    ; ; ;       ; Если есть вертикальная и горизонтальная полоса,
    ; ; ;       ; то окрашиваем прамоугольник между ними
    ; ; ;       ;*v\Height = Height
    ; ; ;     EndIf
    ; ;     
    ; ;     ProcedureReturn Bool(*v\Hide|*h\Hide)
    ; ;     
    ProcedureReturn 1
  EndProcedure
  
  Procedure Canvas_Events(Canvas.i, Event.i)
    Protected Repaint
    ;Protected Event = EventType()
    ;Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Width = GadgetWidth(Canvas)
    Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
    
    Repaint | CallBack(*Scroll\v, Event, MouseX, MouseY) 
    Repaint | CallBack(*Scroll\h, Event, MouseX, MouseY) 
    
    
    If *Scroll\v\Change Or *Scroll\h\Change 
      *Scroll\X =- *Scroll\h\Page\Pos
      *Scroll\Y =- *Scroll\v\Page\Pos
      GetScrollCoordinate()
      
      ;                 If *Scroll\x > 0
      ;                   *Scroll\x = 0
      ;                 EndIf
      ;                 If *Scroll\y > 0
      ;                   *Scroll\y =- *Scroll\v\Page\Pos
      ;                 EndIf
      ;                 
      ;                 If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
      ;                   *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
      ;                 EndIf
      ;                 
      ;                 If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
      ;                   *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
      ;                 EndIf
      ;                 
      ;                 *Scroll\Width-*Scroll\x
      ;                 *Scroll\height-*Scroll\y
      
      
      BarUpdates(*Scroll\v, *Scroll\h, *Scroll\X, *Scroll\Y, *Scroll\Width, *Scroll\Height)
    EndIf
    
    ;     
    Select Event
      Case #PB_EventType_LeftButtonUp
        If focus
          ;   GetScrollCoordinate()
          ;           
          ;           
          ;                 If *Scroll\x > 0
          ;                   *Scroll\x =- *Scroll\h\Page\Pos
          ;                 EndIf
          ;                 If *Scroll\y > 0
          ;                   *Scroll\y =- *Scroll\v\Page\Pos
          ;                 EndIf
          ;                 
          ;                 If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          ;                   *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          ;                 EndIf
          ;                 
          ;                 If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          ;                   *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          ;                 EndIf
          ;                 
          ;                 *Scroll\Width-*Scroll\x
          ;                 *Scroll\height-*Scroll\y
          ;                 
          ;                 
          ; ;         *Scroll\v\Page\Pos =- *Scroll\Y
          ; ;         *Scroll\h\Page\Pos =- *Scroll\X
          ;         
          ;         
          ;         Debug "up "+Images()\X
          ;         
          ;         ;If (*Scroll\X<0 Or *Scroll\Y<0)
          ;           PushListPosition(Images())
          ;           ForEach Images()
          ;             If *Scroll\X<0
          ;               ;*Scroll\h\Page\Pos =- *Scroll\X
          ;               Images()\X-*Scroll\X
          ;             EndIf
          ;             If *Scroll\Y<0
          ;               ;*Scroll\v\Page\Pos =- *Scroll\Y
          ;               Images()\Y-*Scroll\Y
          ;             EndIf
          ;           Next
          ;           PopListPosition(Images())
          ;         ;EndIf
          
          Debug "up "+Images()\X
        EndIf
        
        focus = 0
        Repaint = #True
    EndSelect     
    
    If Not Bool(*Scroll\h\at Or *Scroll\v\at)
      Select Event
        Case #PB_EventType_LeftButtonUp : Drag = #False
          
        Case #PB_EventType_LeftButtonDown
          isCurrentItem = HitTest(Images(), Mousex, Mousey)
          If isCurrentItem 
            Repaint = #True 
            Drag = #True
          EndIf
          
        Case #PB_EventType_MouseMove
          If Drag = #True
            If isCurrentItem
              If LastElement(Images())
                Images()\x = Mousex - currentItemXOffset
                Images()\y = Mousey - currentItemYOffset
                SetWindowTitle(EventWindow(), Str(Images()\x))
                
                If Images()\x < *Scroll\x
                  focus = @Images()
                EndIf
                If Images()\y < *Scroll\y
                  focus = @Images()
                EndIf
                
                GetScrollCoordinate()
                
                ;                 If *Scroll\x > 0
                ;                   *Scroll\x = 0
                ;                 EndIf
                ;                 If *Scroll\y > 0
                ;                   *Scroll\y =- *Scroll\v\Page\Pos
                ;                 EndIf
                ;                 
                ;                 If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
                ;                   *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
                ;                 EndIf
                ;                 
                ;                 If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
                ;                   *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
                ;                 EndIf
                ;                 
                ;                 *Scroll\Width-*Scroll\x
                ;                 *Scroll\height-*Scroll\y
                
                
                BarUpdates(*Scroll\v, *Scroll\h, *Scroll\X, *Scroll\Y, *Scroll\Width, *Scroll\Height)
                ;                 
                ;                 Debug *Scroll\v\Max
                ;                 Debug *Scroll\v\Page\len
                
                Repaint = #True
              EndIf
            EndIf
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          GetScrollCoordinate()
          
          ;           If *Scroll\x > 0
          ;             *Scroll\x = 0
          ;           EndIf
          ;           If *Scroll\y > 0
          ;             *Scroll\y = 0
          ;           EndIf
          ;           
          ;           If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          ;             *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          ;           EndIf
          ;           
          ;           If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          ;             *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          ;           EndIf
          ;           
          ;           *Scroll\Width-*Scroll\x
          ;           *Scroll\height-*Scroll\y
          
          
          
          Protected vMax, hMax
          Protected iWidth = Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          Protected iHeight = Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          
          If *Scroll\Height>Height-y*2
            vMax = *Scroll\Height
          Else
            vMax = Height-y*2
          EndIf
          
          If *Scroll\width>Width-x*2
            hmax = *Scroll\width
          Else
            hmax = Width-x*2
          EndIf
          
          SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, vMax)
          SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, hMax)
          
          
          ;            BarResize(*Scroll\v, x, y, Width-x*2, Height-y*2, *Scroll\h)
          
          SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, vMax)
          SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, hMax)
          
          
          
          *Scroll\v\Hide = Resize(*Scroll\v, Width-x-*Scroll\v\Width, Y, #PB_Ignore, iHeight)
          *Scroll\h\Hide = Resize(*Scroll\h, X, Height-y-*Scroll\h\Height, iWidth, #PB_Ignore)
          
          iWidth = Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          iHeight = Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          
          SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight)
          SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth)
          
          *Scroll\v\Hide = Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, iHeight)
          *Scroll\h\Hide = Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, iWidth, #PB_Ignore)
          
          iWidth = Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          iHeight = Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          
          SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight)
          SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth)
          
          Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\v\Page\len)
          Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, *Scroll\h\Page\len, #PB_Ignore)
          
          Repaint = #True
          
      EndSelect
    EndIf 
    
    If Repaint : Canvas_ReDraw(g_Canvas, Images()) : EndIf
  EndProcedure
  
  
  ;-
  ;- EXAMPLE
  ;-
  CompilerIf #PB_Compiler_IsMainFile
    
    If LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/Background.bmp")
      ResizeImage(0,ImageWidth(0)*2,ImageHeight(0)*2)
      
      ; draw frame on the image
      If StartDrawing(ImageOutput(0))
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(0,0,OutputWidth(),OutputWidth(), $FF0000)
        *Scroll\width = OutputWidth()
        *Scroll\height = OutputHeight()
        StopDrawing()
      EndIf
    EndIf
    
    Procedure Canvas_CallBack()
      ; Canvas events bug fix
      Protected Result.b
      Static MouseLeave.b
      Protected EventGadget.i = EventGadget()
      Protected EventType.i = EventType()
      Protected Width = GadgetWidth(EventGadget)
      Protected Height = GadgetHeight(EventGadget)
      Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
      Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
      
      ; Это из за ошибки в мак ос и линукс
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
        Select EventType 
          Case #PB_EventType_MouseEnter 
            If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
              EventType = #PB_EventType_MouseMove
              MouseLeave = 0
            EndIf
            
          Case #PB_EventType_MouseLeave 
            If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
              EventType = #PB_EventType_MouseMove
              MouseLeave = 1
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            If GetActiveGadget()<>EventGadget
              SetActiveGadget(EventGadget)
            EndIf
            
          Case #PB_EventType_LeftButtonUp
            If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
              MouseLeave = 0
              CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
                EventType = #PB_EventType_MouseLeave
              CompilerEndIf
            Else
              MouseLeave =- 1
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_LeftClick
            EndIf
            
          Case #PB_EventType_LeftClick : ProcedureReturn 0
        EndSelect
      CompilerEndIf
      
      Result | Canvas_Events(EventGadget, EventType)
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure Widget_Events()
      Select EventType()
        Case #PB_EventType_ScrollChange
          Debug EventData()
      EndSelect
    EndProcedure
    
    Procedure ResizeCallBack()
      ResizeGadget(g_Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-210, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
    EndProcedure
    
    Procedure.i Bars(*Scroll.Scroll_S, Size.i, Radius.i, Both.b)
      With *Scroll     
        \v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,0, #PB_Vertical, Radius)
        \v\hide = \v\hide[1]
        ;\v\s = *Scroll
        
        If Both
          \h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,0, 0, Radius)
          \h\hide = \h\hide[1]
        Else
          \h.Widget_S = AllocateStructure(Bar_S)
          \h\hide = 1
        EndIf
        ;\h\s = *Scroll
      EndWith
      
      ProcedureReturn *Scroll
    EndProcedure
    
    
    ; open window
    If OpenWindow(0, 0, 0, Width+20, Height+20, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      g_container = ContainerGadget(#PB_Any, 10, 10, 180, 240, #PB_Container_Flat)
      
      g_is_vertical = CheckBoxGadget(#PB_Any, 10, 10, 160, 20, "Vertical") : SetGadgetState(g_is_vertical, 1)
      g_value = StringGadget(#PB_Any, 10, 40, 120, 20, "100", #PB_String_Numeric)
      g_set = ButtonGadget(#PB_Any, 140, 40, 30, 20, "set")
      
      g_min = OptionGadget(#PB_Any, 10, 70, 160, 20, "") : SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+70, 160, 20, "Min"), #PB_Gadget_FrontColor, $FF0000)
      g_max = OptionGadget(#PB_Any, 10, 90, 160, 20, "") : SetGadgetState(g_max, 1) : SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+90, 160, 20, "Max"), #PB_Gadget_FrontColor, $FF0000)
      g_pos = OptionGadget(#PB_Any, 10, 110, 160, 20, "") : SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+110, 160, 20, "pos"), #PB_Gadget_FrontColor, $FFFF00)
      g_len = OptionGadget(#PB_Any, 10, 130, 160, 20, "") : SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+130, 160, 20, "len"), #PB_Gadget_FrontColor, $FFFF00)
      g_page_pos = OptionGadget(#PB_Any, 10, 150, 160, 20, "") : SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+150, 160, 20, "Page pos"), #PB_Gadget_FrontColor, $00FF00)
      g_page_len = OptionGadget(#PB_Any, 10, 170, 160, 20, "") : SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+170, 160, 20, "Page len"), #PB_Gadget_FrontColor, $00FF00)
      g_area_pos = OptionGadget(#PB_Any, 10, 190, 160, 20, "") : SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+190, 160, 20, "Area pos"), #PB_Gadget_FrontColor, $00FFFF)
      g_area_len = OptionGadget(#PB_Any, 10, 210, 160, 20, "") : SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+210, 160, 20, "Area len"), #PB_Gadget_FrontColor, $00FFFF)
      
      CloseGadgetList()
      
      ;Canvas = CanvasGadget(#PB_Any, 200, 10, 380, 380, #PB_Canvas_Keyboard)
      g_Canvas = CanvasGadget(#PB_Any, 200,10, 600, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
      v = ScrollBarGadget(-1, x-18, y,  16, 300 ,0,ImageHeight(0), 240-16, #PB_ScrollBar_Vertical)
      h = ScrollBarGadget(-1, x, y-18, 300,  16 ,0,ImageWidth(0), 405-16)
      ;     SetGadgetAttribute(v, #PB_ScrollBar_Maximum, ImageHeight(0))
      ;     SetGadgetAttribute(h, #PB_ScrollBar_Maximum, ImageWidth(0))
      
      ; Set scroll page position
      SetGadgetState(v, 70)
      SetGadgetState(h, 55)
      CloseGadgetList()
      
      OpenList(0, g_Canvas)
      ; Create both scroll bars
      *Scroll\v = Scroll(#PB_Ignore, #PB_Ignore,  16, #PB_Ignore ,0, ImageHeight(0), 240-16, #PB_ScrollBar_Vertical,7)
      *Scroll\h = Scroll(#PB_Ignore, #PB_Ignore,  #PB_Ignore, 16 ,0, ImageWidth(0), 405-16, 0, 7)
      
      ;     SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
      ;     SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))
      
      ; Set scroll page position
      SetState(*Scroll\v, 70)
      SetState(*Scroll\h, 55)
      
      PostEvent(#PB_Event_Gadget, 0,g_Canvas,#PB_EventType_Resize)
      BindGadgetEvent(g_Canvas, @Canvas_CallBack())
      
      BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
      
      Define value
      
      Repeat 
        Event = WaitWindowEvent()
        Select Event
          Case #PB_Event_Gadget
            
            Select EventGadget()
              Case g_min
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\v, #PB_ScrollBar_Minimum)))
                  Case 0
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\h, #PB_ScrollBar_Minimum)))
                EndSelect
                
              Case g_max 
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\v, #PB_ScrollBar_Maximum)))
                  Case 0
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\h, #PB_ScrollBar_Maximum)))
                EndSelect
                
              Case g_page_len
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\v, #PB_ScrollBar_PageLength)))
                  Case 0
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\h, #PB_ScrollBar_PageLength)))
                EndSelect
                
              Case g_page_pos
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(GetState(*Scroll\v)))
                  Case 0
                    SetGadgetText(g_value, Str(GetState(*Scroll\h)))
                EndSelect
                
              Case g_pos
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*Scroll\v\y))
                  Case 0
                    SetGadgetText(g_value, Str(*Scroll\h\x))
                EndSelect
                
              Case g_len
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*Scroll\v\height))
                  Case 0
                    SetGadgetText(g_value, Str(*Scroll\h\width))
                EndSelect
                
              Case g_area_len 
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*Scroll\v\Area\len))
                  Case 0
                    SetGadgetText(g_value, Str(*Scroll\h\Area\len))
                EndSelect
                
              Case g_area_pos 
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*Scroll\v\Area\Pos))
                  Case 0
                    SetGadgetText(g_value, Str(*Scroll\h\Area\Pos))
                EndSelect
                
              Case g_set
                value = Val(GetGadgetText(g_value))
                
                Select 1
                  Case GetGadgetState(g_min) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        SetAttribute(*Scroll\v, #PB_ScrollBar_Minimum, value)
                      Case 0
                        SetAttribute(*Scroll\h, #PB_ScrollBar_Minimum, value)
                    EndSelect
                    
                  Case GetGadgetState(g_max) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, value)
                      Case 0
                        SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, value)
                    EndSelect
                    
                  Case GetGadgetState(g_pos) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        Resize(*Scroll\v, #PB_Ignore, value, #PB_Ignore, #PB_Ignore)
                      Case 0
                        Resize(*Scroll\h, value, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                    EndSelect
                    
                  Case GetGadgetState(g_len) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, value)
                      Case 0
                        Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, value, #PB_Ignore)
                    EndSelect
                    
                  Case GetGadgetState(g_page_pos) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        SetState(*Scroll\v, value)
                      Case 0
                        SetState(*Scroll\h, value)
                    EndSelect
                    
                  Case GetGadgetState(g_page_len) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, value)
                      Case 0
                        SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, value)
                    EndSelect
                    
                  Case GetGadgetState(g_area_len) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        *Scroll\v\Area\len = value
                      Case 0
                        *Scroll\h\Area\len = value
                    EndSelect
                    
                  Case GetGadgetState(g_area_len) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        *Scroll\v\Area\Pos = value
                      Case 0
                        *Scroll\h\Area\Pos = value
                    EndSelect
                    
                    
                EndSelect
                
                Debug "vmi "+ GetAttribute(*Scroll\v, #PB_ScrollBar_Minimum) +" vma "+ GetAttribute(*Scroll\v, #PB_ScrollBar_Maximum) +" vpl "+ GetAttribute(*Scroll\v, #PB_ScrollBar_PageLength)
                
                Canvas_ReDraw(g_Canvas, Images())
            EndSelect
            
        EndSelect
      Until Event = #PB_Event_CloseWindow
    EndIf
  CompilerEndIf
  
  
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --------------
; EnableXP