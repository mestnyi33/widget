CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"


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

Global *v.Scroll_S=AllocateStructure(Scroll_S)
Global *h.Scroll_S=AllocateStructure(Scroll_S)

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
  Protected iWidth = Scroll::X(*v), iHeight = Scroll::Y(*h)
  
  If StartDrawing(CanvasOutput(canvas))
    
    ClipOutput(0,0, iWidth, iHeight)
    
    DrawingMode(#PB_2DDrawing_Default)
    Box(0, 0, iWidth, iHeight, RGB(255,255,255))
    
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    ForEach Images()
      DrawImage(ImageID(Images()\img),Images()\x - *h\Page\Pos,Images()\y - *v\Page\Pos) ; draw all images with z-order
    Next
    
    UnclipOutput()
    
    Scroll::Draw(*v)
    Scroll::Draw(*h)
    
    StopDrawing()
  EndIf
EndProcedure

Procedure.i HitTest (List Images.canvasitem(), x, y)
  Shared currentItemXOffset.i, currentItemYOffset.i
  Protected alpha.i, isCurrentItem.i = #False
  
  If LastElement(Images()) ; search for hit, starting from end (z-order)
    Repeat
      If x >= Images()\x - *h\Page\Pos And x < Images()\x - *h\Page\Pos + Images()\width
        If y >= Images()\y - *v\Page\Pos And y < Images()\y - *v\Page\Pos + Images()\height
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
  Protected iWidth = Width-Scroll::Width(*v), iHeight = Height-Scroll::Height(*h)
  
  ; Вправо работает как надо
  If ScrollWidth<*h\Page\Pos+iWidth 
    ScrollWidth=*h\Page\Pos+iWidth
    ; Влево работает как надо
  ElseIf ScrollX>*h\Page\Pos And
         ScrollWidth=*h\Page\Pos+iWidth 
    ScrollWidth = iWidth 
  EndIf
  
  If ScrollHeight<*v\Page\Pos+iHeight
    ScrollHeight=*v\Page\Pos+iHeight 
  ElseIf ScrollY>*v\Page\Pos And
         ScrollHeight=*v\Page\Pos+iHeight 
    ScrollHeight = iHeight 
  EndIf
  
  If ScrollX>0 : ScrollX=0 : EndIf
  If ScrollY>0 : ScrollY=0 : EndIf
  
  If ScrollX<*h\Page\Pos : ScrollWidth-ScrollX : EndIf
  If ScrollY<*v\Page\Pos : ScrollHeight-ScrollY : EndIf
  
  
  ;   Debug "Width "+Width
  ;   Debug " *h\Page\Pos "+*h\Page\Pos
  ;   Debug " *h\Max "+*h\Max
  ;   Debug "  ScrollX "+ScrollX
  ;   Debug "  ScrollWidth "+ScrollWidth
  
  
  vPos = *v\Page\Pos : hPos = *h\Page\Pos
  
  If *v\Max<>ScrollHeight : Scroll::SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollHeight) : EndIf
  If *h\Max<>ScrollWidth : Scroll::SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollWidth) : EndIf
  
  If *v\Page\Length<>iHeight : Scroll::SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
  If *h\Page\Length<>iWidth : Scroll::SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
  
  If ScrollY<0 : Scroll::SetState(*v, (ScrollHeight-ScrollY)-ScrollHeight) : EndIf
  If ScrollX<0 : Scroll::SetState(*h, (ScrollWidth-ScrollX)-ScrollWidth) : EndIf
  
  *v\Hide = Scroll::Resize(*v, Width-*v\Width, Y, #PB_Ignore, #PB_Ignore, *h) 
  *h\Hide = Scroll::Resize(*h, X, Height-*h\Height, #PB_Ignore, #PB_Ignore, *v)
  
;   If *v\Hide : *v\Page\Pos = 0 : Else : *v\Page\Pos = vPos : *h\Width = Width : EndIf
;   If *h\Hide : *h\Page\Pos = 0 : Else : *h\Page\Pos = hPos : *v\Height = Height : EndIf
  
  If *v\Hide : *v\Page\Pos = 0 : If vPos : *v\Hide = vPos : EndIf : Else : *v\Page\Pos = vPos : *h\Width = Width : EndIf
  If *h\Hide : *h\Page\Pos = 0 : If hPos : *h\Hide = hPos : EndIf : Else : *h\Page\Pos = hPos : *v\Height = Height : EndIf
  
  ProcedureReturn Bool(ScrollHeight>=Height Or ScrollWidth>=Width)
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
  
  If Scroll::CallBack(*v, Event, MouseX, MouseY, WheelDelta) 
    Repaint = #True 
  EndIf
  If Scroll::CallBack(*h, Event, MouseX, MouseY, WheelDelta) 
    Repaint = #True 
  EndIf
  
  Select Event
    Case #PB_EventType_LeftButtonUp
      GetScrollCoordinate()
      
      If (ScrollX<0 Or ScrollY<0)
        PushListPosition(Images())
        ForEach Images()
          If ScrollX<0
            *h\Page\Pos =- ScrollX
            Images()\X-ScrollX
          EndIf
          If ScrollY<0
            *v\Page\Pos =- ScrollY
            Images()\Y-ScrollY
          EndIf
        Next
        PopListPosition(Images())
      EndIf
      
  EndSelect     
  
  If (*h\Buttons Or *v\Buttons)
    Select Event
      Case #PB_EventType_LeftButtonUp
        Debug "----------Up---------"
        GetScrollCoordinate()
        ScrollUpdates(ScrollX, ScrollY, ScrollWidth, ScrollHeight, Width, Height)
;         Protected iWidth = Width-Scroll::Width(*v), iHeight = Height-Scroll::Height(*h)
;   
;         Debug ""+*h\Hide+" "+ScrollX+" "+Str(ScrollWidth-iWidth)
;         Debug ""+*v\Hide+" "+ScrollY+" "+Str(ScrollHeight-iHeight)
        
        PushListPosition(Images())
        ForEach Images()
;           If *h\Hide And (ScrollWidth-Width)>0 : Images()\X-(ScrollWidth-Width) : EndIf
;           If *v\Hide And (ScrollHeight-Height)>0 : Images()\Y-(ScrollHeight-Height) : EndIf
          If *h\Hide>1 : Images()\X-*h\Hide : EndIf
          If *v\Hide>1 : Images()\Y-*v\Hide : EndIf
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
              
              Repaint = #True
            EndIf
          EndIf
        EndIf
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        GetScrollCoordinate()
        
        If *h\Max<>ScrollWidth : Scroll::SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollWidth) : EndIf
        If *v\Max<>ScrollHeight : Scroll::SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollHeight) : EndIf
        
        Scroll::Resizes(*v, *h, 0, 0, Width, Height)
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

*v = Scroll::Create(#MyCanvas,-1, 380, 0,  20, 380, 0, 0, 0, #PB_ScrollBar_Vertical, 10)
*h = Scroll::Create(#MyCanvas,-1, 0, 380, 380,  20, 0, 0, 0, 0, 10)

PostEvent(#PB_Event_Gadget, 0,#MyCanvas,#PB_EventType_Resize)
BindGadgetEvent(#MyCanvas, @CallBack())
BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ---------
; EnableXP