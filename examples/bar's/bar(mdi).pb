IncludePath "../../"
XIncludeFile "widgets.pbi"

;-
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
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
  
  Global *this._s_widget = AllocateStructure(_s_widget) 
  Global x=151,y=151, Width=790, Height=600 , focus
  
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, drag.i, hole.i
  Global NewList Images.canvasitem()
  
  Macro GetScrollCoordinate()
    ;  *this\y[#__c_required] =- *this\scroll\v\bar\page\Pos 
    If focus
      ;       Scroll_x = *this\x[#__c_required]
      ;       Scroll_y = *this\y[#__c_required]
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
      ;       Scroll_x = *this\x[#__c_required]
      ;       Scroll_y = *this\y[#__c_required]
    EndIf
    
    *this\width[#__c_required] = *this\x[#__c_required]+Images()\width
    *this\scroll\height = *this\y[#__c_required]+Images()\height 
    
    PushListPosition(Images())
    ForEach Images()
      If *this\y[#__c_required] > Images()\y 
        *this\y[#__c_required] = Images()\y
      EndIf
      
      If *this\x[#__c_required] > Images()\x 
        *this\x[#__c_required] = Images()\x
      EndIf
      
      If *this\width[#__c_required] < Images()\x+Images()\width
        *this\width[#__c_required] = Images()\width+Images()\x
      EndIf
      
      If *this\scroll\height < Images()\Y+Images()\height 
        *this\scroll\height = Images()\height+Images()\Y
      EndIf 
    Next
    PopListPosition(Images())
    
    ;     If *this\y[#__c_required] < Images()\y 
    ;         *this\y[#__c_required] = Images()\y
    ;       EndIf
    ;       
    ;       If *this\x[#__c_required] > Images()\x 
    ;         *this\x[#__c_required] = Images()\x
    ;       EndIf
    
    ;     If *this\x[#__c_required] > 0
    ;       *this\x[#__c_required] = 0
    ;     EndIf
    ; ;     If *this\y[#__c_required] > 0
    ; ;       *this\y[#__c_required] =- *this\scroll\v\bar\page\Pos
    ; ;     EndIf
    ; ;     
    ;     ;                                 If *this\scroll\height<Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
    ;     ;                                   *this\scroll\height =Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
    ;     ;                                 EndIf
    ;     
    ;     If *this\width[#__c_required]<Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
    ;       *this\width[#__c_required] =Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
    ;     EndIf
    ;     
    ;     *this\width[#__c_required]-*this\x[#__c_required]
    ;     *this\scroll\height-*this\y[#__c_required]
    
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
    With *this
      SetGadgetState(v, GetState(\scroll\v))
      SetGadgetAttribute(v, #PB_ScrollBar_Minimum, GetAttribute(\scroll\v, #__bar_Minimum))
      SetGadgetAttribute(v, #PB_ScrollBar_Maximum, GetAttribute(\scroll\v, #__bar_Maximum))
      SetGadgetAttribute(v, #PB_ScrollBar_PageLength, GetAttribute(\scroll\v, #__bar_PageLength))
      ResizeGadget(v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \scroll\v\height)
      
      SetGadgetState(h, GetState(\scroll\h))
      SetGadgetAttribute(h, #PB_ScrollBar_Minimum, GetAttribute(\scroll\h, #__bar_Minimum))
      SetGadgetAttribute(h, #PB_ScrollBar_Maximum, GetAttribute(\scroll\h, #__bar_Maximum))
      SetGadgetAttribute(h, #PB_ScrollBar_PageLength, GetAttribute(\scroll\h, #__bar_PageLength))
      ResizeGadget(h, #PB_Ignore, #PB_Ignore, \scroll\h\width, #PB_Ignore)
    EndWith
  EndProcedure
  
  Procedure Canvas_ReDraw (canvas.i, List Images.canvasitem())
    With *this
      pb_scroll_update()
      
      If StartDrawing(CanvasOutput(canvas))
        
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
        
        ; ClipOutput(\scroll\h\x, \scroll\v\y, \scroll\h\bar\page\len, \scroll\v\bar\page\len)
        DrawingMode(#PB_2DDrawing_AlphaBlend)
        ;       If focus And ChangeCurrentElement(Images(), focus)
        ;         DrawImage(ImageID(Images()\img),x+(Images()\x - \scroll\h\bar\page\Pos), y+(Images()\y)) ; draw all images with z-order
        ;       Else
        ForEach Images()
          ;  DrawImage(ImageID(Images()\img),x+(Images()\x - \scroll\h\bar\page\Pos), y+(Images()\y - \scroll\v\bar\page\Pos)) ; draw all images with z-order
          DrawImage(ImageID(Images()\img),x+(Images()\x - Bool(Not focus) * \scroll\h\bar\page\Pos), y+(Images()\y - Bool(Not focus) * \scroll\v\bar\page\Pos)) ; draw all images with z-order
        Next
        ;       EndIf
        ;UnclipOutput()
        
        Draw(\scroll\v)
        Draw(\scroll\h)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        
        ; widget area coordinate
        Box(x-1, y-1, Width-x*2+2, Height-y*2+2, $0000FF)
        
        ; Scroll area coordinate
        Box(\scroll\h\x-\scroll\h\bar\page\Pos, \scroll\v\y-\scroll\v\bar\page\Pos, \scroll\h\bar\max, \scroll\v\bar\max, $FF0000)
        
        ; page coordinate
        Box(\scroll\h\x, \scroll\v\y, \scroll\h\bar\page\Len, \scroll\v\bar\page\Len, $00FF00)
        
        ; area coordinate
        Box(\scroll\h\x, \scroll\v\y, \scroll\h\bar\area\Len, \scroll\v\bar\area\Len, $00FFFF)
        
        ; scroll coordinate
        Box(\scroll\h\x, \scroll\v\y, \scroll\h\width, \scroll\v\height, $FF00FF)
        
        ; frame coordinate
        Box(\scroll\h\x, \scroll\v\y, 
            \scroll\h\bar\page\len + (Bool(Not \scroll\v\hide) * \scroll\v\width),
            \scroll\v\bar\page\len + (Bool(Not \scroll\h\hide) * \scroll\h\height), $FFFF00)
        
        StopDrawing()
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i HitTest (List Images.canvasitem(), mouse_x, mouse_y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, isCurrentItem.i = #False
    
    With *this
      If LastElement(Images()) ; search for hit, starting from end (z-order)
        Repeat
          If mouse_x >= x+Images()\x - \scroll\h\bar\page\Pos And mouse_x < x+Images()\x - \scroll\h\bar\page\Pos + Images()\width
            If mouse_y >= y+Images()\y - \scroll\v\bar\page\Pos And mouse_y < y+Images()\y - \scroll\v\bar\page\Pos + Images()\height
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
  
  
  Procedure BarUpdates(*v._S_widget, *h._S_widget, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height) ; Ok
    Protected iWidth = (*v\X-*h\X)+ Bool(*v\Hide) * *v\Width                                                ; X(*v)
    Protected iHeight = (*h\Y-*v\Y)+ Bool(*h\Hide) * *h\height                                              ; Y(*h)
    Static hPos, vPos : vPos = *v\bar\page\Pos : hPos = *h\bar\page\Pos
    
    ; Вправо работает как надо
    If ScrollArea_Width<*h\bar\page\Pos+iWidth 
      ScrollArea_Width=*h\bar\page\Pos+iWidth
      ; Влево работает как надо
    ElseIf ScrollArea_X>*h\bar\page\Pos And
           ScrollArea_Width=*h\bar\page\Pos+iWidth 
      ScrollArea_Width = iWidth
    EndIf
    
    ; Вниз работает как надо
    If ScrollArea_Height<*v\bar\page\Pos+iHeight
      ScrollArea_Height=*v\bar\page\Pos+iHeight 
      ; Верх работает как надо
    ElseIf ScrollArea_Y>*v\bar\page\Pos And
           ScrollArea_Height=*v\bar\page\Pos+iHeight 
      ScrollArea_Height = iHeight 
    EndIf
    
    If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
    If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
    
    If ScrollArea_Y<*v\bar\page\Pos : ScrollArea_Height-ScrollArea_Y-*v\bar\page\Pos : EndIf
    If ScrollArea_X<*h\bar\page\Pos : ScrollArea_Width-ScrollArea_X-*h\bar\page\Pos : EndIf
    
    SetAttribute(*v, #__bar_Maximum, ScrollArea_Height)
    SetAttribute(*h, #__bar_Maximum, ScrollArea_Width)
    
    If *v\bar\page\Len<>iHeight : SetAttribute(*v, #__bar_PageLength, iHeight) : EndIf
    If *h\bar\page\Len<>iWidth : SetAttribute(*h, #__bar_PageLength, iWidth) : EndIf
    
    If ScrollArea_Y<>*v\bar\page\Pos 
      SetState(*v, -ScrollArea_Y);(ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) 
    EndIf
    
    ;If ScrollArea_X<0 : SetState(*h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    If ScrollArea_X<>*h\bar\page\Pos 
      SetState(*h, -ScrollArea_X) 
    EndIf
    
    *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*h\Y + Bool(*h\Hide) * *h\Height) - *v\Y) ; #PB_Ignore, *h) 
    *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, (*v\X + Bool(*v\Hide) * *v\Width) - *h\X, #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, *v)
    
    *this\y[#__c_required] =- *v\bar\page\Pos
    *this\x[#__c_required] =- *h\bar\page\Pos
    *this\width[#__c_required] = *v\bar\max
    *this\scroll\height = *h\bar\max
    
    ;   If *v\Hide : *v\bar\page\Pos = 0 : Else : *v\bar\page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
    ;   If *h\Hide : *h\bar\page\Pos = 0 : Else : *h\bar\page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
    
    ;   If *v\Hide : *v\bar\page\Pos = 0 : If vPos : *v\Hide = vPos : EndIf : Else : *v\bar\page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
    ;   If *h\Hide : *h\bar\page\Pos = 0 : If hPos : *h\Hide = hPos : EndIf : Else : *h\bar\page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  Procedure BarResize(*v._S_widget, X,Y,Width,Height, *h._S_widget )
    
    ; ; ;     
    ; ; ;       If y=#PB_Ignore : y = *v\Y : EndIf
    ; ; ;       If x=#PB_Ignore : x = *h\X : EndIf
    ; ; ;       If Width=#PB_Ignore : Width = *v\X-*h\X+*v\width : EndIf
    ; ; ;       If Height=#PB_Ignore : Height = *h\Y-*v\Y+*h\height : EndIf
    ; ; ;       
    ; ; ;       ; Debug ""+Width +" "+ Str(*v\X-*h\X+*v\width)
    ; ; ;       
    ; ; ;       SetAttribute(*v, #__bar_PageLength, Height - Bool(*h\hide) * *h\height) 
    ; ; ;       SetAttribute(*h, #__bar_PageLength, Width - Bool(*v\hide) * *v\width)  
    ; ; ;       
    ; ; ;       *v\Hide = Resize(*v, x+*h\bar\page\Len, y, #PB_Ignore, Height)
    ; ; ;       *h\Hide = Resize(*h, x, y+*v\bar\page\len, Width, #PB_Ignore)
    ; ; ;       
    ; ; ; ; ;       SetAttribute(*v, #__bar_PageLength, Height - Bool(Not *h\hide) * *h\height)
    ; ; ; ; ;       SetAttribute(*h, #__bar_PageLength, Width - Bool(Not *v\hide) * *v\width)
    ; ; ; ;        SetAttribute(*v, #__bar_PageLength, Height - Bool(Not *h\hide) * *h\height) 
    ; ; ; ;       SetAttribute(*h, #__bar_PageLength, Width -  Bool(Not *v\hide) * *v\width)  
    ; ; ; ;      
    ; ; ; ;       *v\Hide = Resize(*v, x+*h\bar\page\len, #PB_Ignore, #PB_Ignore, Height + Bool(*v\round And Not *h\Hide)*4)
    ; ; ; ;       *h\Hide = Resize(*h, #PB_Ignore, y+*v\bar\page\len, Width + Bool(*h\round And Not *v\Hide)*4, #PB_Ignore)
    
    If Width=#PB_Ignore 
      Width = *v\X+*v\Width
    EndIf
    If Height=#PB_Ignore 
      Height = *h\Y+*h\Height
    EndIf
    
    SetAttribute(*v, #__bar_PageLength, Height-Bool(Not *h\Hide) * *h\height)
    SetAttribute(*h, #__bar_PageLength, Width-Bool(Not *v\Hide) * *v\width)
    
    *v\Hide = Resize(*v, (x+Width)-*v\Width, Y, #PB_Ignore, (*h\Y+Bool(*h\Hide) * *h\Height) - *v\Y)
    *h\Hide = Resize(*h, X, (y+Height)-*h\Height, (*v\X+Bool(*v\Hide) * *v\width) - *h\X, #PB_Ignore)
    
    SetAttribute(*v, #__bar_PageLength, Height-Bool(Not *h\Hide) * *h\height)
    SetAttribute(*h, #__bar_PageLength, Width-Bool(Not *v\Hide) * *v\width)
    
    *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, ((*h\Y+Bool(*h\Hide) * *h\Height) - *v\Y) + Bool(*v\round And Not *h\Hide)*4)
    *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, ((*v\X+Bool(*v\Hide) * *v\width) - *h\X) + Bool(*h\round And Not *v\Hide)*4, #PB_Ignore)
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
    ; ;     If *v\width And *v\bar\page\Len<>iHeight : SetAttribute(*v, #__bar_PageLength, iHeight) : EndIf
    ; ;     If *h\height And *h\bar\page\Len<>iWidth : SetAttribute(*h, #__bar_PageLength, iWidth) : EndIf
    ; ;     
    ; ;     *v\Hide = Resize(*v, Width+x-*v\Width, Y, #PB_Ignore, #PB_Ignore, *h) : iWidth = Width-Width(*v)
    ; ;     *h\Hide = Resize(*h, X, Height+y-*h\Height, #PB_Ignore, #PB_Ignore, *v) : iHeight = Height-Height(*h)
    ; ;     
    ; ;     If *v\width And *v\bar\page\Len<>iHeight : SetAttribute(*v, #__bar_PageLength, iHeight) : EndIf
    ; ;     If *h\height And *h\bar\page\Len<>iWidth : SetAttribute(*h, #__bar_PageLength, iWidth) : EndIf
    ; ;     
    ; ;     If *v\width
    ; ;       *v\Hide = Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*h\Y + Bool(*h\Hide) * *h\Height) - *v\Y) ; #PB_Ignore, *h) ;
    ; ;     EndIf
    ; ;     If *h\height
    ; ;       *h\Hide = Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*v\X + Bool(*v\Hide) * *v\Width) - *h\X, #PB_Ignore) ; #PB_Ignore, #PB_Ignore, *v) ;
    ; ;     EndIf
    ; ;     
    ; ; ;     If *v\Hide 
    ; ; ;       *v\bar\page\Pos = 0 
    ; ; ;     Else
    ; ; ;       ; Если есть вертикальная и горизонтальная полоса,
    ; ; ;       ; то окрашиваем прамоугольник между ними
    ; ; ;      ; *h\Width = Width
    ; ; ;     EndIf
    ; ; ;     If *h\Hide 
    ; ; ;       *h\bar\page\Pos = 0 
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
  
  Procedure Canvas_CallBack();Canvas.i, Event.i)
    Protected Repaint
    Protected Event = EventType()
    Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Width = GadgetWidth(Canvas)
    Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
    
;     Repaint | CallBack(*this\scroll\v, Event, MouseX, MouseY) 
;     Repaint | CallBack(*this\scroll\h, Event, MouseX, MouseY) 
    
    
    If *this\scroll\v\Change Or *this\scroll\h\Change 
      *this\x[#__c_required] =- *this\scroll\h\bar\page\Pos
      *this\y[#__c_required] =- *this\scroll\v\bar\page\Pos
      GetScrollCoordinate()
      
      ;                 If *this\x[#__c_required] > 0
      ;                   *this\x[#__c_required] = 0
      ;                 EndIf
      ;                 If *this\y[#__c_required] > 0
      ;                   *this\y[#__c_required] =- *this\scroll\v\bar\page\Pos
      ;                 EndIf
      ;                 
      ;                 If *this\scroll\height<Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
      ;                   *this\scroll\height =Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
      ;                 EndIf
      ;                 
      ;                 If *this\width[#__c_required]<Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
      ;                   *this\width[#__c_required] =Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
      ;                 EndIf
      ;                 
      ;                 *this\width[#__c_required]-*this\x[#__c_required]
      ;                 *this\scroll\height-*this\y[#__c_required]
      
      
      BarUpdates(*this\scroll\v, *this\scroll\h, *this\x[#__c_required], *this\y[#__c_required], *this\width[#__c_required], *this\scroll\height)
    EndIf
    
    ;     
    Select Event
      Case #PB_EventType_LeftButtonUp
        If focus
          ;   GetScrollCoordinate()
          ;           
          ;           
          ;                 If *this\x[#__c_required] > 0
          ;                   *this\x[#__c_required] =- *this\scroll\h\bar\page\Pos
          ;                 EndIf
          ;                 If *this\y[#__c_required] > 0
          ;                   *this\y[#__c_required] =- *this\scroll\v\bar\page\Pos
          ;                 EndIf
          ;                 
          ;                 If *this\scroll\height<Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
          ;                   *this\scroll\height =Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
          ;                 EndIf
          ;                 
          ;                 If *this\width[#__c_required]<Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
          ;                   *this\width[#__c_required] =Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
          ;                 EndIf
          ;                 
          ;                 *this\width[#__c_required]-*this\x[#__c_required]
          ;                 *this\scroll\height-*this\y[#__c_required]
          ;                 
          ;                 
          ; ;         *this\scroll\v\bar\page\Pos =- *this\y[#__c_required]
          ; ;         *this\scroll\h\bar\page\Pos =- *this\x[#__c_required]
          ;         
          ;         
          ;         Debug "up "+Images()\X
          ;         
          ;         ;If (*this\x[#__c_required]<0 Or *this\y[#__c_required]<0)
          ;           PushListPosition(Images())
          ;           ForEach Images()
          ;             If *this\x[#__c_required]<0
          ;               ;*this\scroll\h\bar\page\Pos =- *this\x[#__c_required]
          ;               Images()\X-*this\x[#__c_required]
          ;             EndIf
          ;             If *this\y[#__c_required]<0
          ;               ;*this\scroll\v\bar\page\Pos =- *this\y[#__c_required]
          ;               Images()\Y-*this\y[#__c_required]
          ;             EndIf
          ;           Next
          ;           PopListPosition(Images())
          ;         ;EndIf
          
          Debug "up "+Images()\X
        EndIf
        
        focus = 0
        Repaint = #True
    EndSelect     
    
    ;If Not Bool(*this\scroll\h\bar\index=-1 And *this\scroll\v\bar\index=-1)
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
                
                If Images()\x < *this\x[#__c_required]
                  focus = @Images()
                EndIf
                If Images()\y < *this\y[#__c_required]
                  focus = @Images()
                EndIf
                
                GetScrollCoordinate()
                
                ;                 If *this\x[#__c_required] > 0
                ;                   *this\x[#__c_required] = 0
                ;                 EndIf
                ;                 If *this\y[#__c_required] > 0
                ;                   *this\y[#__c_required] =- *this\scroll\v\bar\page\Pos
                ;                 EndIf
                ;                 
                ;                 If *this\scroll\height<Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
                ;                   *this\scroll\height =Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
                ;                 EndIf
                ;                 
                ;                 If *this\width[#__c_required]<Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
                ;                   *this\width[#__c_required] =Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
                ;                 EndIf
                ;                 
                ;                 *this\width[#__c_required]-*this\x[#__c_required]
                ;                 *this\scroll\height-*this\y[#__c_required]
                
                
                BarUpdates(*this\scroll\v, *this\scroll\h, *this\x[#__c_required], *this\y[#__c_required], *this\width[#__c_required], *this\scroll\height)
                ;                 
                ;                 Debug *this\scroll\v\bar\max
                ;                 Debug *this\scroll\v\bar\page\len
                
                Repaint = #True
              EndIf
            EndIf
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          GetScrollCoordinate()
          
          ;           If *this\x[#__c_required] > 0
          ;             *this\x[#__c_required] = 0
          ;           EndIf
          ;           If *this\y[#__c_required] > 0
          ;             *this\y[#__c_required] = 0
          ;           EndIf
          ;           
          ;           If *this\scroll\height<Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
          ;             *this\scroll\height =Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
          ;           EndIf
          ;           
          ;           If *this\width[#__c_required]<Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
          ;             *this\width[#__c_required] =Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
          ;           EndIf
          ;           
          ;           *this\width[#__c_required]-*this\x[#__c_required]
          ;           *this\scroll\height-*this\y[#__c_required]
          
          
          
          Protected vMax, hMax
          Protected iWidth = Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
          Protected iHeight = Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
          
          If *this\scroll\height>Height-y*2
            vMax = *this\scroll\height
          Else
            vMax = Height-y*2
          EndIf
          
          If *this\width[#__c_required]>Width-x*2
            hmax = *this\width[#__c_required]
          Else
            hmax = Width-x*2
          EndIf
          
          SetAttribute(*this\scroll\v, #__bar_Maximum, vMax)
          SetAttribute(*this\scroll\h, #__bar_Maximum, hMax)
          
          
          ;            BarResize(*this\scroll\v, x, y, Width-x*2, Height-y*2, *this\scroll\h)
          
          SetAttribute(*this\scroll\v, #__bar_PageLength, vMax)
          SetAttribute(*this\scroll\h, #__bar_PageLength, hMax)
          
          
          
          *this\scroll\v\Hide = Resize(*this\scroll\v, Width-x-*this\scroll\v\Width, Y, #PB_Ignore, iHeight)
          *this\scroll\h\Hide = Resize(*this\scroll\h, X, Height-y-*this\scroll\h\Height, iWidth, #PB_Ignore)
          
          iWidth = Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
          iHeight = Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
          
          SetAttribute(*this\scroll\v, #__bar_PageLength, iHeight)
          SetAttribute(*this\scroll\h, #__bar_PageLength, iWidth)
          
          *this\scroll\v\Hide = Resize(*this\scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, iHeight)
          *this\scroll\h\Hide = Resize(*this\scroll\h, #PB_Ignore, #PB_Ignore, iWidth, #PB_Ignore)
          
          iWidth = Width-x*2 - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width
          iHeight = Height-y*2 - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height
          
          SetAttribute(*this\scroll\v, #__bar_PageLength, iHeight)
          SetAttribute(*this\scroll\h, #__bar_PageLength, iWidth)
          
          Resize(*this\scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *this\scroll\v\bar\page\len)
          Resize(*this\scroll\h, #PB_Ignore, #PB_Ignore, *this\scroll\h\bar\page\len, #PB_Ignore)
          
          Repaint = #True
          
      EndSelect
    ;EndIf 
    
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
        *this\width[#__c_required] = OutputWidth()
        *this\scroll\height = OutputHeight()
        StopDrawing()
      EndIf
    EndIf
   
    Procedure Widget_Events()
      Select EventType()
        Case #PB_EventType_ScrollChange
          Debug EventData()
      EndSelect
    EndProcedure
    
    Procedure ResizeCallBack()
      ResizeGadget(g_Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-210, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
    EndProcedure
    
    Procedure.i Bars(*this._S_widget, Size.i, round.i, Both.b)
      With *this     
        \scroll\v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,0, #__bar_Vertical, round)
        \scroll\v\hide = \scroll\v\hide[1]
        ;\scroll\v\s = *this
        
        If Both
          \scroll\h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,0, 0, round)
          \scroll\h\hide = \scroll\h\hide[1]
        Else
          \scroll\h._S_widget = AllocateStructure(_S_Bar)
          \scroll\h\hide = 1
        EndIf
        ;\scroll\h\s = *this
      EndWith
      
      ProcedureReturn *this
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
      
;       Canvas = CanvasGadget(#PB_Any, 200, 10, 380, 380, #PB_Canvas_Keyboard)
      Open(0, 200,10, 600, Height,"", #PB_Canvas_Keyboard|#PB_Canvas_Container, @Canvas_CallBack())
      g_Canvas = GetGadget(Root())
      ;OpenGadgetList(g_Canvas)
      
;       g_Canvas = CanvasGadget(#PB_Any, 200,10, 600, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container)
;       SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
;       
;       AddElement(Root())
;       Root() = AllocateStructure(_S_root)
;       Root()\root = Root()
;       Root()\adress = Root()
;       
;       Root()\parent = Root()
;       opened() = Root()
;       Root()\canvas\window = 0
;       Root()\canvas\gadget = g_Canvas
;       Root()\width = 600
;       Root()\height = Height
      
      v = ScrollBarGadget(-1, x-18, y,  16, 300 ,0,ImageHeight(0), 240-16, #PB_ScrollBar_Vertical)
      h = ScrollBarGadget(-1, x, y-18, 300,  16 ,0,ImageWidth(0), 405-16)
      ;     SetGadgetAttribute(v, #PB_ScrollBar_Maximum, ImageHeight(0))
      ;     SetGadgetAttribute(h, #PB_ScrollBar_Maximum, ImageWidth(0))
      
      ; Set scroll page position
      SetGadgetState(v, 70)
      SetGadgetState(h, 55)
      CloseGadgetList()
      
;       OpenList(0, g_Canvas)
      ; Create both scroll bars
;       *this\scroll\v = Scroll(#PB_Ignore, #PB_Ignore,  16, #PB_Ignore ,0, ImageHeight(0), 240-16, #__bar_Vertical,7)
;       *this\scroll\h = Scroll(#PB_Ignore, #PB_Ignore,  #PB_Ignore, 16 ,0, ImageWidth(0), 405-16, 0, 7)
      *this\scroll\v = Scroll(x, y+Height-16,  16, #PB_Ignore ,0, ImageHeight(0), 240-16, #__bar_Vertical,7)
      *this\scroll\h = Scroll(x+Width-16, y,  #PB_Ignore, 16 ,0, ImageWidth(0), 405-16, 0, 7)
      
      ;     SetAttribute(*this\scroll\v, #__bar_Maximum, ImageHeight(0))
      ;     SetAttribute(*this\scroll\h, #__bar_Maximum, ImageWidth(0))
      
      ; Set scroll page position
      SetState(*this\scroll\v, 70)
      SetState(*this\scroll\h, 55)
      
;       PostEvent(#PB_Event_Gadget, 0,g_Canvas,#PB_EventType_Resize)
;       BindGadgetEvent(g_Canvas, @Canvas_CallBack())
      
;       BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
      
      Define value
      
      Repeat 
        Event = WaitWindowEvent()
        
        Select Event
          Case #PB_Event_Gadget
            
            Select EventGadget()
              Case g_min
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(GetAttribute(*this\scroll\v, #__bar_Minimum)))
                  Case 0
                    SetGadgetText(g_value, Str(GetAttribute(*this\scroll\h, #__bar_Minimum)))
                EndSelect
                
              Case g_max 
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(GetAttribute(*this\scroll\v, #__bar_Maximum)))
                  Case 0
                    SetGadgetText(g_value, Str(GetAttribute(*this\scroll\h, #__bar_Maximum)))
                EndSelect
                
              Case g_page_len
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(GetAttribute(*this\scroll\v, #__bar_PageLength)))
                  Case 0
                    SetGadgetText(g_value, Str(GetAttribute(*this\scroll\h, #__bar_PageLength)))
                EndSelect
                
              Case g_page_pos
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(GetState(*this\scroll\v)))
                  Case 0
                    SetGadgetText(g_value, Str(GetState(*this\scroll\h)))
                EndSelect
                
              Case g_pos
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*this\scroll\v\y))
                  Case 0
                    SetGadgetText(g_value, Str(*this\scroll\h\x))
                EndSelect
                
              Case g_len
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*this\scroll\v\height))
                  Case 0
                    SetGadgetText(g_value, Str(*this\scroll\h\width))
                EndSelect
                
              Case g_area_len 
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*this\scroll\v\bar\area\len))
                  Case 0
                    SetGadgetText(g_value, Str(*this\scroll\h\bar\area\len))
                EndSelect
                
              Case g_area_pos 
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*this\scroll\v\bar\area\Pos))
                  Case 0
                    SetGadgetText(g_value, Str(*this\scroll\h\bar\area\Pos))
                EndSelect
                
              Case g_set
                value = Val(GetGadgetText(g_value))
                
                Select 1
                  Case GetGadgetState(g_min) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        SetAttribute(*this\scroll\v, #__bar_Minimum, value)
                      Case 0
                        SetAttribute(*this\scroll\h, #__bar_Minimum, value)
                    EndSelect
                    
                  Case GetGadgetState(g_max) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        SetAttribute(*this\scroll\v, #__bar_Maximum, value)
                      Case 0
                        SetAttribute(*this\scroll\h, #__bar_Maximum, value)
                    EndSelect
                    
                  Case GetGadgetState(g_pos) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        Resize(*this\scroll\v, #PB_Ignore, value, #PB_Ignore, #PB_Ignore)
                      Case 0
                        Resize(*this\scroll\h, value, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                    EndSelect
                    
                  Case GetGadgetState(g_len) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        Resize(*this\scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, value)
                      Case 0
                        Resize(*this\scroll\h, #PB_Ignore, #PB_Ignore, value, #PB_Ignore)
                    EndSelect
                    
                  Case GetGadgetState(g_page_pos) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        SetState(*this\scroll\v, value)
                      Case 0
                        SetState(*this\scroll\h, value)
                    EndSelect
                    
                  Case GetGadgetState(g_page_len) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        SetAttribute(*this\scroll\v, #__bar_PageLength, value)
                      Case 0
                        SetAttribute(*this\scroll\h, #__bar_PageLength, value)
                    EndSelect
                    
                  Case GetGadgetState(g_area_len) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        *this\scroll\v\bar\area\len = value
                      Case 0
                        *this\scroll\h\bar\area\len = value
                    EndSelect
                    
                  Case GetGadgetState(g_area_len) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        *this\scroll\v\bar\area\Pos = value
                      Case 0
                        *this\scroll\h\bar\area\Pos = value
                    EndSelect
                    
                    
                EndSelect
                
                Debug "vmi "+ GetAttribute(*this\scroll\v, #__bar_Minimum) +" vma "+ GetAttribute(*this\scroll\v, #__bar_Maximum) +" vpl "+ GetAttribute(*this\scroll\v, #__bar_PageLength)
                
                Canvas_ReDraw(g_Canvas, Images())
            EndSelect
            
        EndSelect
      Until Event = #PB_Event_CloseWindow
    EndIf
  CompilerEndIf
  
  
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --------v---
; EnableXP