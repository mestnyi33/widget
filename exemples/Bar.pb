IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "module_bar.pbi"
;-
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
  Structure Coordinate_S
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  Structure Scroll_S Extends Coordinate_S
    *v.Bar::Bar_S
    *h.Bar::Bar_S
  EndStructure
  
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
  
  Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
  Global x=151, y=151, focus
  
  
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, drag.i, hole.i, Width, Height
  Global NewList Images.canvasitem()
  
  Macro GetScrollCoordinate()
    *Scroll\x = Images()\x
    *Scroll\y = Images()\Y
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
        *Scroll\height = Images()\Y+Images()\height
      EndIf 
    Next
    PopListPosition(Images())
    
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
  
  Procedure Draw (canvas.i, List Images.canvasitem())
    If StartDrawing(CanvasOutput(canvas))
      
      
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
      
      ; frame 
      DrawingMode(#PB_2DDrawing_Outlined)
      ; Box(0, 0, OutputWidth(), OutputHeight(), $000000)
      ;             Box(x-1,y-1,
      ;                 2 + Bool(*Scroll\v\hide) * *Scroll\h\Page\len + Bool(Not *Scroll\v\hide) * ((*Scroll\v\X+*Scroll\v\width)-x),
      ;                 2 + Bool(*Scroll\h\hide) * *Scroll\v\Page\len + Bool(Not *Scroll\h\hide) * ((*Scroll\h\Y+*Scroll\h\height)-y), $000000)
      
      ;       If Bar::ScrollEnd(*Scroll\v)
      ;         *Scroll\h\Color\Line = 0
      ;       Else
      ;         *Scroll\h\Color\Line = $FFFFFF
      ;       EndIf
      ;       
      ;       If Bar::ScrollEnd(*Scroll\h)
      ;         *Scroll\v\Color\Line = 0
      ;       Else
      ;         *Scroll\v\Color\Line = $FFFFFF
      ;       EndIf
      
      
      
      ; ClipOutput(x,y, *Scroll\h\Page\len, *Scroll\v\Page\len)
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      ;       If focus And ChangeCurrentElement(Images(), focus)
      ;         DrawImage(ImageID(Images()\img),x+(Images()\x - *Scroll\h\Page\Pos), y+(Images()\y)) ; draw all images with z-order
      ;       Else
      ForEach Images()
        DrawImage(ImageID(Images()\img),x+(Images()\x - Bool(Not focus) * *Scroll\h\Page\Pos), y+(Images()\y - Bool(Not focus) * *Scroll\y)) ; draw all images with z-order
      Next
      ;       EndIf
      UnclipOutput()
      
      Bar::Draw(*Scroll\v)
      Bar::Draw(*Scroll\h)
      
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(x, y, *Scroll\h\Page\Len, *Scroll\v\Page\Len, $000000)
      Box(x+*Scroll\x, y+*Scroll\y, *Scroll\width, *Scroll\height, $00FF00)
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i HitTest (List Images.canvasitem(), mouse_x, mouse_y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, isCurrentItem.i = #False
    
    If LastElement(Images()) ; search for hit, starting from end (z-order)
      Repeat
        If mouse_x >= x+Images()\x - *Scroll\h\Page\Pos And mouse_x < x+Images()\x - *Scroll\h\Page\Pos + Images()\width
          If mouse_y >= y+Images()\y - *Scroll\v\Page\Pos And mouse_y < y+Images()\y - *Scroll\v\Page\Pos + Images()\height
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
    
    ProcedureReturn isCurrentItem
  EndProcedure
  
  AddImage(Images(),  10,  10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
  AddImage(Images(), 100, 100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
  AddImage(Images(),  50, 200, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))
  
  ;   hole = CreateImage(#PB_Any,100,100,32)
  ;   If StartDrawing(ImageOutput(hole))
  ;     DrawingMode(#PB_2DDrawing_AllChannels)
  ;     Box(0,0,100,100,RGBA($00,$00,$00,$00))
  ;     Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
  ;     Circle(50,50,30,RGBA($00,$00,$00,$00))
  ;     StopDrawing()
  ;   EndIf
  ;   AddImage(Images(),170,70,hole,1)
  
  
  Procedure.i Updates(*v.bar::Bar_S, *h.bar::Bar_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    Static hPos, vPos : vPos = *v\Page\Pos : hPos = *h\Page\Pos
    
    ;Debug ScrollArea_Height
    
    Protected iWidth, iHeight
    
    If *v\Hide
      iWidth = *v\X+*v\Width
    Else
      iWidth = *v\X
    EndIf
    
    If *h\Hide 
      iHeight = *h\Y+*h\Height
    Else
      iHeight = *h\Y
    EndIf
    
    ;     ; Вправо работает как надо
    ;     If ScrollArea_Width<*h\Page\Pos+iWidth 
    ;       ScrollArea_Width=*h\Page\Pos+iWidth
    ;       ; Влево работает как надо
    ;     ElseIf ScrollArea_X>*h\Page\Pos And
    ;            ScrollArea_Width=*h\Page\Pos+iWidth 
    ;       ScrollArea_Width = iWidth 
    ;     EndIf
    ;     
    ;     ; Вниз работает как надо
    ;     If ScrollArea_Height<*v\Page\Pos+iHeight
    ;       ScrollArea_Height=*v\Page\Pos+iHeight 
    ;       ; Верх работает как надо
    ;     ElseIf ScrollArea_Y>*v\Page\Pos And
    ;            ScrollArea_Height=*v\Page\Pos+iHeight 
    ;       ScrollArea_Height = iHeight 
    ;     EndIf
    ;     
    ;     If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
    ;     If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
    ;     
    ;     If ScrollArea_X<*h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
    ;     If ScrollArea_Y<*v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
    
    ;Debug "    "+ScrollArea_Height
    bar::SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollArea_Height)
    bar::SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollArea_Width)
    
    ;     bar::SetAttribute(*v, #PB_ScrollBar_PageLength, *v\Height)
    ;     bar::SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth)
    
    If ScrollArea_Y<0 : bar::SetState(*v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
    If ScrollArea_X<0 : bar::SetState(*h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
    
    ;     *v\Hide[1] = Bool((*v\Max-*v\Min) < *v\Page\len)
    ;     *v\Hide = *v\Hide[1]
    *v\Hide = bar::Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (*h\Y + Bool(*h\Hide) * *h\Height) - *v\Y) 
    *h\Hide = bar::Resize(*h, #PB_Ignore, #PB_Ignore, (*v\X + Bool(*v\Hide) * *v\Width) - *h\X, #PB_Ignore)
    
    ;     
    ;     If *v\Hide 
    ;       *v\Page\Pos = 0 
    ;       If vPos 
    ;         *v\Hide = vPos 
    ;       EndIf 
    ;     Else 
    ;       *v\Page\Pos = vPos 
    ;     EndIf
    ;     
    ;     If *h\Hide 
    ;       *h\Page\Pos = 0 
    ;       If hPos 
    ;         *h\Hide = hPos 
    ;       EndIf 
    ;     Else
    ;       *h\Page\Pos = hPos 
    ;     EndIf
    
    ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
  EndProcedure
  
  
  Procedure CallBack()
    Protected Repaint
    Protected Event = EventType()
    Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
    
    Repaint | Bar::CallBack(*Scroll\v, Event, MouseX, MouseY) 
    Repaint | Bar::CallBack(*Scroll\h, Event, MouseX, MouseY) 
    
    If *Scroll\v\Change
      *Scroll\Y =- *Scroll\v\Page\Pos
      ;       ; An example showing the sending of messages in a vertical scrollbar.
      ;       PostEvent(#PB_Event_Widget, EventWindow(), *Scroll\v, #PB_EventType_ScrollChange, *Scroll\v\Direction) 
      ;       
      ;       ; An example showing the sending of messages to the gadget of both scrollbars.
      ;       PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_ScrollChange, *Scroll\v\Direction) 
      *Scroll\v\Change = 0
    EndIf
    
    If *Scroll\h\Change
      *Scroll\X =- *Scroll\h\Page\Pos
      ;       ; An example showing the sending of messages in a horizontal scrollbar.
      ;       PostEvent(#PB_Event_Widget, EventWindow(), *Scroll\h, #PB_EventType_ScrollChange, *Scroll\h\Direction) 
      ;       
      ;       ; An example showing the sending of messages to the gadget of both scrollbars.
      ;       PostEvent(#PB_Event_Widget, EventWindow(), EventGadget(), #PB_EventType_ScrollChange, *Scroll\h\Direction) 
      *Scroll\h\Change = 0
    EndIf
    
    
    
    Select Event
      Case #PB_EventType_LeftButtonUp
        focus = 0
        ;         GetScrollCoordinate()
        ;         
        ;         
        ;         
        ;         If *Scroll\x > 0
        ;           *Scroll\x = 0
        ;         EndIf
        ;         If *Scroll\y > 0
        ;           *Scroll\y = 0
        ;         EndIf
        ;         
        ;         If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height+1
        ;           *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height+1
        ;         EndIf
        ;         
        ;         If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width+1
        ;           *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width+1
        ;         EndIf
        ;         
        ;         *Scroll\Width-*Scroll\x
        ;         *Scroll\height-*Scroll\y
        ;         
        ;         
        ;         
        ;         Debug *Scroll\Y
        ;         Debug *Scroll\v\Page\Pos
        ;         
        ;         If (*Scroll\X<0 Or *Scroll\Y<0)
        ;           Debug 555
        ;           PushListPosition(Images())
        ;           ForEach Images()
        ;             If *Scroll\X<0
        ;               *Scroll\h\Page\Pos =- *Scroll\X
        ;               Images()\X-*Scroll\X
        ;             EndIf
        ;             
        ;             If *Scroll\Y<0
        ;               *Scroll\v\Page\Pos =- *Scroll\Y
        ;               Images()\Y-*Scroll\Y
        ;             EndIf
        ;           Next
        ;           PopListPosition(Images())
        ;         EndIf
        ;         
        ;         Debug *Scroll\Y
        ;         Debug *Scroll\v\Page\Pos
        ;         If *Scroll\Y=0
        ;           *Scroll\Y=-*Scroll\v\Page\Pos
        ;         EndIf
        ;         
    EndSelect     
    
    If (*Scroll\h\at Or *Scroll\v\at)
      ;       Select Event
      ;         Case #PB_EventType_LeftButtonUp
      ;           Debug "----------Up---------"
      ;           GetScrollCoordinate()
      ;           Updates(*Scroll\v,*Scroll\h,*Scroll\X, *Scroll\Y, *Scroll\Width, *Scroll\Height)
      ;           
      ;           ;         Protected iWidth = Width-Bar::Width(*Scroll\v), iHeight = Height-Bar::Height(*Scroll\h)
      ;           ;   
      ;           ;         Debug ""+*Scroll\h\Hide+" "+ScrollX+" "+Str(ScrollWidth-iWidth)
      ;           ;         Debug ""+*Scroll\v\Hide+" "+ScrollY+" "+Str(ScrollHeight-iHeight)
      ;           
      ;           PushListPosition(Images())
      ;           ForEach Images()
      ;             ;           If *Scroll\h\Hide And (ScrollWidth-Width)>0 : Images()\X-(ScrollWidth-Width) : EndIf
      ;             ;           If *Scroll\v\Hide And (ScrollHeight-Height)>0 : Images()\Y-(ScrollHeight-Height) : EndIf
      ;             If *Scroll\h\Hide>1 : Images()\X-*Scroll\h\Hide : EndIf
      ;             If *Scroll\v\Hide>1 : Images()\Y-*Scroll\v\Hide : EndIf
      ;           Next
      ;           PopListPosition(Images())
      ;           
      ;           
      ;       EndSelect
    Else
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
                focus = @Images()
                Images()\x = Mousex - currentItemXOffset
                Images()\y = Mousey - currentItemYOffset
                SetWindowTitle(EventWindow(), Str(Images()\x))
                
                GetScrollCoordinate()
                
                If *Scroll\x > 0
                  *Scroll\x = 0
                EndIf
                If *Scroll\y > 0
                  *Scroll\y =- *Scroll\v\Page\Pos
                EndIf
                
                If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height+1
                  *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height+1
                EndIf
                
                If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width+1
                  *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width+1
                EndIf
                
                *Scroll\Width-*Scroll\x
                *Scroll\height-*Scroll\y
                
                
                Debug *Scroll\Y
                Updates(*Scroll\v, *Scroll\h, *Scroll\X, *Scroll\Y, *Scroll\Width, *Scroll\Height)
                ;                 
                ;                 Debug *Scroll\v\Max
                ;                 Debug *Scroll\v\Page\len
                
                Repaint = #True
              EndIf
            EndIf
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          GetScrollCoordinate()
          
          If *Scroll\x > 0
            *Scroll\x = 0
          EndIf
          If *Scroll\y > 0
            *Scroll\y = 0
          EndIf
          
          If *Scroll\Height<Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height+1
            *Scroll\Height =Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height+1
          EndIf
          
          If *Scroll\width<Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width+1
            *Scroll\width =Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width+1
          EndIf
          
          *Scroll\Width-*Scroll\x
          *Scroll\height-*Scroll\y
          
          
          
          Protected Max
          Protected iWidth = Width-x*2 ; - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          Protected iHeight = Height-y*2; - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          
          Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, *Scroll\Height)
          Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, *Scroll\width)
          
          ;           If *Scroll\h\Min<>*Scroll\X : Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_Minimum, *Scroll\X) : EndIf
          ;           If *Scroll\v\Min<>*Scroll\Y : Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_Minimum, *Scroll\Y) : EndIf
          ;           If *Scroll\h\Max<>*Scroll\Width : Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, *Scroll\Width) : EndIf
          ;           If *Scroll\v\Max<>*Scroll\Height : Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, *Scroll\Height) : EndIf
          ;           
          Bar::Resize(*Scroll\v, x, y, Width-x*2, Height-y*2, *Scroll\h)
          
          
          
          ;           iWidth = Width-x*2 - Bool(Not *Scroll\v\hide) * *Scroll\v\width
          ;           iHeight = Height-y*2 - Bool(Not *Scroll\h\hide) * *Scroll\h\height
          ;           
          ;           If *Scroll\Height>iHeight
          ;             Max = *Scroll\Height
          ;           Else
          ;             Max = iHeight
          ;           EndIf
          ;           Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, Max)
          ;           
          ;           If *Scroll\width>iWidth
          ;             max = *Scroll\width
          ;           Else
          ;             max = iWidth
          ;           EndIf
          ;           Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, Max)
          ;           Bar::Resize(*Scroll\v, x, y, Width-x*2, Height-y*2, *Scroll\h)
          ;           
          ;           Debug *Scroll\v\Max
          ;           Debug *Scroll\v\Page\len
          Repaint = #True
          
      EndSelect
    EndIf 
    
    If Repaint : Draw(#MyCanvas, Images()) : EndIf
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(#MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
  EndProcedure
  
  
  If Not OpenWindow(0, 0, 0, 620, 620, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  ;
  CanvasGadget(#MyCanvas, 10, 10, 600, 600)
  
  ; Create both scroll bars
  *Scroll\v = Bar::Bar(#PB_Ignore, y,  16, #PB_Ignore ,0, 0, 0, #PB_ScrollBar_Vertical, 7)
  *Scroll\h = Bar::Bar(x, #PB_Ignore,  #PB_Ignore, 16 ,0, 0, 0, 0, 7)
  
  PostEvent(#PB_Event_Gadget, 0,#MyCanvas,#PB_EventType_Resize)
  BindGadgetEvent(#MyCanvas, @CallBack())
  BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --------
; EnableXP