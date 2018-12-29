IncludePath "../../"
XIncludeFile "module_bar.pbi"

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
  
  Global *Scroll.Scroll_S=AllocateStructure(Scroll_S)
;   Global *Scroll\v.Bar::Bar_S=AllocateStructure(Bar::Bar_S)
; Global *Scroll\h.Bar::Bar_S=AllocateStructure(Bar::Bar_S)
Global x1=1,y1=1

Global isCurrentItem=#False
Global currentItemXOffset.i, currentItemYOffset.i
Global Event.i, x.i, y.i, drag.i, hole.i, Width, Height
Global NewList Images.canvasitem()

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
    ;       Box(x1-1,y1-1,
    ;           2 + Bool(*Scroll\v\hide) * *Scroll\h\Page\Len-x1 + Bool(Not *Scroll\v\hide) * ((*Scroll\v\X+*Scroll\v\width)),
    ;           2 + Bool(*Scroll\h\hide) * *Scroll\v\Page\Len-y1 + Bool(Not *Scroll\h\hide) * ((*Scroll\h\Y+*Scroll\h\height)), $000000)
    ;Box(0, 0, OutputWidth(), OutputHeight(), $000000)
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
    
    Box(x, y, *Scroll\h\Page\Len, *Scroll\v\Page\Len, $000000)
    Box(x-*Scroll\h\Page\Pos, y-*Scroll\v\Page\Pos, *Scroll\h\Max, *Scroll\v\Max, $00FF00)
    
    ClipOutput(x,y, *Scroll\h\Page\Len, *Scroll\v\Page\Len)
    
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    ForEach Images()
      DrawImage(ImageID(Images()\img),Images()\x - *Scroll\h\Page\Pos,Images()\y - *Scroll\v\Page\Pos) ; draw all images with z-order
    Next
    
    UnclipOutput()
    
    Bar::Draw(*Scroll\v)
    Bar::Draw(*Scroll\h)
    
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
  

AddImage(Images(),  10, 10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
AddImage(Images(), 100,100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
AddImage(Images(),  50,200, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))

hole = CreateImage(#PB_Any,100,100,32)
If StartDrawing(ImageOutput(hole))
  DrawingMode(#PB_2DDrawing_AllChannels)
  Box(0,0,100,100,RGBA($00,$00,$00,$00))
  Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
  Circle(50,50,30,RGBA($00,$00,$00,$00))
  StopDrawing()
EndIf
AddImage(Images(),170,70,hole,1)


Macro GetScrollCoordinate()
  ScrollX = Images()\x
  ScrollY = Images()\Y
  ScrollWidth = ScrollX+Images()\width
  ScrollHeight = ScrollY+Images()\height
  
  PushListPosition(Images())
  ForEach Images()
    If ScrollX > Images()\x : ScrollX = Images()\x : EndIf
    If ScrollY > Images()\Y : ScrollY = Images()\Y : EndIf
    If ScrollWidth < Images()\x+Images()\width : ScrollWidth = Images()\x+Images()\width : EndIf
    If ScrollHeight < Images()\Y+Images()\height : ScrollHeight = Images()\Y+Images()\height : EndIf
  Next
  PopListPosition(Images())
  
  ;   ScrollWidth-ScrollX
  ;   ScrollHeight-ScrollY
  
EndMacro

 Procedure.b Updates(*v.Bar::Bar_s, *h.Bar::Bar_s, BarArea_X, BarArea_Y, BarArea_Width, BarArea_Height)
    Protected iWidth = *v\X+Bool(*v\Hide) * *v\Width, iHeight = *h\Y+Bool(*h\Hide) * *h\height
    ;Protected iWidth = X(*v), iHeight = Y(*h)
    Static hPos, vPos : vPos = *v\Page\Pos : hPos = *h\Page\Pos
    
    ; Вправо работает как надо
    If BarArea_Width<*h\Page\Pos+iWidth 
      BarArea_Width=*h\Page\Pos+iWidth
      ; Влево работает как надо
    ElseIf BarArea_X>*h\Page\Pos And
           BarArea_Width=*h\Page\Pos+iWidth 
      BarArea_Width = iWidth 
    EndIf
    
    ; Вниз работает как надо
    If BarArea_Height<*v\Page\Pos+iHeight
      BarArea_Height=*v\Page\Pos+iHeight 
      ; Верх работает как надо
    ElseIf BarArea_Y>*v\Page\Pos And
           BarArea_Height=*v\Page\Pos+iHeight 
      BarArea_Height = iHeight 
    EndIf
    
    If BarArea_X>0 : BarArea_X=0 : EndIf
    If BarArea_Y>0 : BarArea_Y=0 : EndIf
    
    If BarArea_X<*h\Page\Pos : BarArea_Width-BarArea_X : EndIf
    If BarArea_Y<*v\Page\Pos : BarArea_Height-BarArea_Y : EndIf
    
    If *v\Max<>BarArea_Height : Bar::SetAttribute(*v, #PB_ScrollBar_Maximum, BarArea_Height) : EndIf
    If *h\Max<>BarArea_Width : Bar::SetAttribute(*h, #PB_ScrollBar_Maximum, BarArea_Width) : EndIf
    
    If *v\Page\Len<>iHeight : Bar::SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
    If *h\Page\Len<>iWidth : Bar::SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
    
    If BarArea_Y<0 : Bar::SetState(*v, (BarArea_Height-BarArea_Y)-BarArea_Height) : EndIf
    If BarArea_X<0 : Bar::SetState(*h, (BarArea_Width-BarArea_X)-BarArea_Width) : EndIf
    
    *v\Hide = Bar::Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h) 
    *h\Hide = Bar::Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *v)
    
    If *v\Hide : *v\Page\Pos = 0 : If vPos : *v\Hide = vPos : EndIf : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
    If *h\Hide : *h\Page\Pos = 0 : If hPos : *h\Hide = hPos : EndIf : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
    
    ProcedureReturn Bool(BarArea_Height>=iHeight Or BarArea_Width>=iWidth)
  EndProcedure
  
 Procedure ScrollUpdates(*v.Bar::Bar_S, *h.Bar::Bar_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Protected iWidth = *v\X+Bool(*v\Hide) * *v\Width, iHeight = *h\Y+Bool(*h\Hide) * *h\height
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
  
  If ScrollArea_X<*h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
  If ScrollArea_Y<*v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
  
  If *v\Max<>ScrollArea_Height : Bar::SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
  If *h\Max<>ScrollArea_Width : Bar::SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
  
  ;   If *v\Page\Len<>iHeight : Bar::SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
  ;   If *h\Page\Len<>iWidth : Bar::SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
  
  If ScrollArea_Y<0 : Bar::SetState(*v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
  If ScrollArea_X<0 : Bar::SetState(*h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
  
  *v\Hide = Bar::Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h) 
  *h\Hide = Bar::Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *v)
  
  ;   If *v\Hide : *v\Page\Pos = 0 : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
  ;   If *h\Hide : *h\Page\Pos = 0 : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
  
  If *v\Hide : *v\Page\Pos = 0 : If vPos : *v\Hide = vPos : EndIf : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
  If *h\Hide : *h\Page\Pos = 0 : If hPos : *h\Hide = hPos : EndIf : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
  
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
  
  If Bar::CallBack(*Scroll\v, Event, MouseX, MouseY) 
    Repaint = #True 
  EndIf
  If Bar::CallBack(*Scroll\h, Event, MouseX, MouseY) 
    Repaint = #True 
  EndIf
  
  Select Event
    Case #PB_EventType_LeftButtonUp
      GetScrollCoordinate()
      
      If (ScrollX<0 Or ScrollY<0)
        PushListPosition(Images())
        ForEach Images()
          If ScrollX<0
            *Scroll\h\Page\Pos =- ScrollX
            Images()\X-ScrollX
          EndIf
          If ScrollY<0
            *Scroll\v\Page\Pos =- ScrollY
            Images()\Y-ScrollY
          EndIf
        Next
        PopListPosition(Images())
      EndIf
      
  EndSelect     
  
  
  If (*Scroll\h\at Or *Scroll\v\at)
    Select Event
      Case #PB_EventType_LeftButtonUp
        Debug "----------Up---------"
        GetScrollCoordinate()
        ScrollUpdates(*Scroll\v,*Scroll\h, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
        ;           Protected iWidth = Width-Bar::Width(*Scroll\v), iHeight = Height-Bar::Height(*Scroll\h)
        ;   
        ;         Debug ""+*Scroll\h\Hide+" "+ScrollX+" "+Str(ScrollWidth-iWidth)
        ;         Debug ""+*Scroll\v\Hide+" "+ScrollY+" "+Str(ScrollHeight-iHeight)
        
        PushListPosition(Images())
        ForEach Images()
          ;           If *Scroll\h\Hide And (ScrollWidth-Width)>0 : Images()\X-(ScrollWidth-Width) : EndIf
          ;           If *Scroll\v\Hide And (ScrollHeight-Height)>0 : Images()\Y-(ScrollHeight-Height) : EndIf
          If *Scroll\h\Hide>1 : Images()\X-*Scroll\h\Hide : EndIf
          If *Scroll\v\Hide>1 : Images()\Y-*Scroll\v\Hide : EndIf
        Next
        PopListPosition(Images())
        
        
    EndSelect
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
              Images()\x = Mousex - currentItemXOffset
              Images()\y = Mousey - currentItemYOffset
              SetWindowTitle(EventWindow(), Str(Images()\x))
              
              GetScrollCoordinate()
              Repaint = Bar::Updates(*Scroll\v,*Scroll\h, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
              ; Repaint = Updates(*Scroll\v,*Scroll\h, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
            EndIf
          EndIf
        EndIf
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        GetScrollCoordinate()
        
        Bar::SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ScrollHeight)
        Bar::SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ScrollWidth)
        
        Bar::Resize(*Scroll\v, x1, y1, Width-x1*2, Height-y1*2, *Scroll\h)
        Repaint = #True
        
    EndSelect
  EndIf 
  
  If Repaint : Draw(#MyCanvas, Images()) : EndIf
EndProcedure

Procedure ResizeCallBack()
  ResizeGadget(#MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
EndProcedure


If Not OpenWindow(0, 0, 0, 420, 420, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
  MessageRequester("Fatal error", "Program terminated.")
  End
EndIf

;
CanvasGadget(#MyCanvas, 10, 10, 400, 400)

*Scroll\v = Bar::Bar(380, 0,  20, 380, 0, 0, 0, #PB_ScrollBar_Vertical)
*Scroll\h = Bar::Bar(0, 380, 380,  20, 0, 0, 0, 0)

PostEvent(#PB_Event_Gadget, 0,#MyCanvas,#PB_EventType_Resize)
BindGadgetEvent(#MyCanvas, @CallBack())
BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -----------
; EnableXP