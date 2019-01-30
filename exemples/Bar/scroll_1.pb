IncludePath "../../../"
XIncludeFile "widgets.pbi"

EnableExplicit
UseModule widget
  
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

Procedure ReDraw (canvas.i, List Images.canvasitem())
  Protected iWidth = X(*Scroll\v), iHeight = Y(*Scroll\h)
  
  If StartDrawing(CanvasOutput(canvas))
    
    
    DrawingMode(#PB_2DDrawing_Default)
    Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
    
    ClipOutput(0,0, iWidth, iHeight)
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    ForEach Images()
      DrawImage(ImageID(Images()\img),Images()\x - *Scroll\h\Page\Pos,Images()\y - *Scroll\v\Page\Pos) ; draw all images with z-order
    Next
    
    UnclipOutput()
    
    Draw(*Scroll\v)
    Draw(*Scroll\h)
    
    StopDrawing()
  EndIf
EndProcedure

Procedure.i HitTest (List Images.canvasitem(), x, y)
  Shared currentItemXOffset.i, currentItemYOffset.i
  Protected alpha.i, isCurrentItem.i = #False
  
  If LastElement(Images()) ; search for hit, starting from end (z-order)
    Repeat
      If x >= Images()\x - *Scroll\h\Page\Pos And x < Images()\x - *Scroll\h\Page\Pos + Images()\width
        If y >= Images()\y - *Scroll\v\Page\Pos And y < Images()\y - *Scroll\v\Page\Pos + Images()\height
          alpha = 255
          
          If Images()\alphatest And ImageDepth(Images()\img)>31
            If StartDrawing(ImageOutput(Images()\img))
              DrawingMode(#PB_2DDrawing_AlphaChannel)
              alpha = Alpha(Point(x-Images()\x, y-Images()\y)) ; get alpha
              StopDrawing()
            EndIf
          EndIf
          
          If alpha
            MoveElement(Images(), #PB_List_Last)
            isCurrentItem = #True
            currentItemXOffset = x - Images()\x
            currentItemYOffset = y - Images()\y
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
  ScrollWidth = Images()\x+Images()\width
  ScrollHeight = Images()\Y+Images()\height
  
  PushListPosition(Images())
  ForEach Images()
    If ScrollX > Images()\x : ScrollX = Images()\x : EndIf
    If ScrollY > Images()\Y : ScrollY = Images()\Y : EndIf
    If ScrollWidth < Images()\x+Images()\width : ScrollWidth = Images()\x+Images()\width : EndIf
    If ScrollHeight < Images()\Y+Images()\height : ScrollHeight = Images()\Y+Images()\height : EndIf
  Next
  PopListPosition(Images())
EndMacro

Procedure ScrollUpdates(ScrollX, ScrollY, ScrollWidth, ScrollHeight, Width, Height, X=0,Y=0)
  Static hPos, vPos
  Protected iWidth = Width-Width(*Scroll\v), iHeight = Height-Height(*Scroll\h)
  
  ; Вправо работает как надо
  If ScrollWidth<*Scroll\h\Page\Pos+iWidth 
    ScrollWidth=*Scroll\h\Page\Pos+iWidth
    ; Влево работает как надо
  ElseIf ScrollX>*Scroll\h\Page\Pos And
         ScrollWidth=*Scroll\h\Page\Pos+iWidth 
    ScrollWidth = iWidth 
  EndIf
  
  If ScrollHeight<*Scroll\v\Page\Pos+iHeight
    ScrollHeight=*Scroll\v\Page\Pos+iHeight 
  ElseIf ScrollY>*Scroll\v\Page\Pos And
         ScrollHeight=*Scroll\v\Page\Pos+iHeight 
    ScrollHeight = iHeight 
  EndIf
  
  If ScrollX>0 : ScrollX=0 : EndIf
  If ScrollY>0 : ScrollY=0 : EndIf
  
  If ScrollX<*Scroll\h\Page\Pos : ScrollWidth-ScrollX : EndIf
  If ScrollY<*Scroll\v\Page\Pos : ScrollHeight-ScrollY : EndIf
  
  
  ;   Debug "Width "+Width
  ;   Debug " *Scroll\h\Page\Pos "+*Scroll\h\Page\Pos
  ;   Debug " *Scroll\h\Max "+*Scroll\h\Max
  ;   Debug "  ScrollX "+ScrollX
  ;   Debug "  ScrollWidth "+ScrollWidth
  
  
  vPos = *Scroll\v\Page\Pos : hPos = *Scroll\h\Page\Pos
  
  If *Scroll\v\Max<>ScrollHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ScrollHeight) : EndIf
  If *Scroll\h\Max<>ScrollWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ScrollWidth) : EndIf
  
  If *Scroll\v\Page\Len<>iHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
  If *Scroll\h\Page\Len<>iWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
  
  If ScrollY<0 : SetState(*Scroll\v, (ScrollHeight-ScrollY)-ScrollHeight) : EndIf
  If ScrollX<0 : SetState(*Scroll\h, (ScrollWidth-ScrollX)-ScrollWidth) : EndIf
  
  *Scroll\v\Hide = Resize(*Scroll\v, Width-*Scroll\v\Width, Y, #PB_Ignore, #PB_Ignore);, *Scroll\h) 
  *Scroll\h\Hide = Resize(*Scroll\h, X, Height-*Scroll\h\Height, #PB_Ignore, #PB_Ignore);, *Scroll\v)
  
  ;   If *Scroll\v\Hide : *Scroll\v\Page\Pos = 0 : Else : *Scroll\v\Page\Pos = vPos : *Scroll\h\Width = Width : EndIf
  ;   If *Scroll\h\Hide : *Scroll\h\Page\Pos = 0 : Else : *Scroll\h\Page\Pos = hPos : *Scroll\v\Height = Height : EndIf
  
  If *Scroll\v\Hide : *Scroll\v\Page\Pos = 0 : If vPos : *Scroll\v\Hide = vPos : EndIf : Else : *Scroll\v\Page\Pos = vPos : *Scroll\h\Width = Width : EndIf
  If *Scroll\h\Hide : *Scroll\h\Page\Pos = 0 : If hPos : *Scroll\h\Hide = hPos : EndIf : Else : *Scroll\h\Page\Pos = hPos : *Scroll\v\Height = Height : EndIf
  
  ProcedureReturn Bool(ScrollHeight>=Height Or ScrollWidth>=Width)
EndProcedure

Procedure Canvas_CallBack()
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
  
  If CallBack(*Scroll\v, Event, MouseX, MouseY) 
    Repaint = #True 
  EndIf
  If CallBack(*Scroll\h, Event, MouseX, MouseY) 
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
        ScrollUpdates(ScrollX, ScrollY, ScrollWidth, ScrollHeight, Width, Height)
        ; Updates(*Scroll,ScrollX, ScrollY, ScrollWidth, ScrollHeight)
        ;         Protected iWidth = Width-Width(*Scroll\v), iHeight = Height-Height(*Scroll\h)
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
              ScrollUpdates(ScrollX, ScrollY, ScrollWidth, ScrollHeight, Width, Height)
              ;Updates(*Scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight);, Width, Height)
        
              Repaint = #True
            EndIf
          EndIf
        EndIf
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        GetScrollCoordinate()
        
        If *Scroll\h\Max<>ScrollWidth : SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ScrollWidth) : EndIf
        If *Scroll\v\Max<>ScrollHeight : SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ScrollHeight) : EndIf
        
        Resizes(*Scroll, 0, 0, Width, Height)
        Repaint = #True
        
    EndSelect
  EndIf 
  
  If Repaint : ReDraw(#MyCanvas, Images()) : EndIf
EndProcedure

Procedure ResizeCallBack()
  ResizeGadget(#MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
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
  
If Not OpenWindow(0, 0, 0, 420, 420, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
  MessageRequester("Fatal error", "Program terminated.")
  End
EndIf

;
CanvasGadget(#MyCanvas, 10, 10, 400, 400)

Bars(*Scroll, 16, 7, 1)
;     SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
;     SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))

PostEvent(#PB_Event_Gadget, 0,#MyCanvas,#PB_EventType_Resize)
BindGadgetEvent(#MyCanvas, @Canvas_CallBack())
BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = f---f----
; EnableXP