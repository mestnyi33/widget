CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/widgets()"
  XIncludeFile "../fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/Widget/widgets()"
CompilerElse
 IncludePath "Z:/Documents/GitHub/Widget/widgets()"
CompilerEndIf


CompilerIf Not Defined(bar, #PB_Module)
  XIncludeFile "Open().pbi"
CompilerEndIf


UseModule Bar
  UseModule Constants
  UseModule Structures
;   Macro OpenWindow(Window, X, Y, Width, Height, Title, Flag=0, ParentID=0)
;     bar::Open_CanvasWindow(Window, X, Y, Width, Height, Title, Flag, ParentID)
;   EndMacro
;   
EnableExplicit

Structure canvasitem
  img.i
  x.i
  y.i
  width.i
  height.i
  alphatest.i
EndStructure

Global MyCanvas, *scroll._s_scroll = AllocateStructure(_s_scroll)

Global *current=#False
Global currentItemXOffset.i, currentItemYOffset.i
Global Event.i, drag.i, hole.i
Global x=150,y=50, Width=420, Height=420 , focus
Global ScrollX, ScrollY, ScrollWidth, ScrollHeight
  
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

Procedure Draw_Canvas(canvas.i, List Images.canvasitem())
  If StartDrawing(CanvasOutput(canvas))
    
    ;ClipOutput(0,0, iWidth, iHeight)
    
    DrawingMode(#PB_2DDrawing_Default)
    Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
    
    DrawingMode(#PB_2DDrawing_AlphaBlend)
    ForEach Images()
     ; DrawImage(ImageID(Images()\img), Images()\x, Images()\y) ; draw all images with z-order
       DrawImage(ImageID(Images()\img), Images()\x - Bool(*current <> images())**scroll\h\bar\Page\Pos, Images()\y - *scroll\v\bar\Page\Pos) ; draw all images with z-order
   Next
    
    ;UnclipOutput()
    
    Bar::Draw(*scroll\v)
    Bar::Draw(*scroll\h)
    
    UnclipOutput()
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(x, y, Width, Height, RGB(0,255,255))
    Box(*scroll\x, *scroll\y, scrollWidth, scrollHeight, RGB(255,0,255))
    ;Box(*scroll\h\x, *scroll\v\y, *scroll\h\bar\Page\len, *scroll\v\bar\Page\len, RGB(255,0,255))
    StopDrawing()
  EndIf
EndProcedure

Procedure.i HitTest (List Images.canvasitem(), x, y)
  Shared currentItemXOffset.i, currentItemYOffset.i
  Protected alpha.i, *current = #False
  
  If LastElement(Images()) ; search for hit, starting from end (z-order)
    Repeat
      If x >= Images()\x - *scroll\h\bar\Page\Pos And x < Images()\x - *scroll\h\bar\Page\Pos + Images()\width
        If y >= Images()\y - *scroll\v\bar\Page\Pos And y < Images()\y - *scroll\v\bar\Page\Pos + Images()\height
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
            *current = @Images()
            currentItemXOffset = x - Images()\x
            currentItemYOffset = y - Images()\y
            Break
          EndIf
        EndIf
      EndIf
    Until PreviousElement(Images()) = 0
  EndIf
  
  ProcedureReturn *current
EndProcedure

AddImage(Images(),  x+10, y+10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
AddImage(Images(), x+100,y+100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
AddImage(Images(),  x+50,y+200, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))

hole = CreateImage(#PB_Any,100,100,32)
If StartDrawing(ImageOutput(hole))
  DrawingMode(#PB_2DDrawing_AllChannels)
  Box(0,0,100,100,RGBA($00,$00,$00,$00))
  Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
  Circle(50,50,30,RGBA($00,$00,$00,$00))
  StopDrawing()
EndIf
AddImage(Images(),x+170,y+70,hole,1)


Macro GetScrollCoordinate()
  *scroll\x = Images()\x
  *scroll\y = Images()\Y
  ScrollWidth = Images()\x+Images()\width - x
  ScrollHeight = Images()\Y+Images()\height - y
  
  PushListPosition(Images())
  ForEach Images()
    If *scroll\x > Images()\x : *scroll\x = Images()\x : EndIf
    If *scroll\y > Images()\Y : *scroll\y = Images()\Y : EndIf
    If ScrollWidth < Images()\x+Images()\width - x : ScrollWidth = Images()\x+Images()\width - x : EndIf
    If ScrollHeight < Images()\Y+Images()\height - y : ScrollHeight = Images()\Y+Images()\height - y : EndIf
  Next
  PopListPosition(Images())
EndMacro

Procedure ScrollUpdates(Width, Height)
  ;ProcedureReturn
  Static hPos, vPos
  Protected Posx, Posy
  ;Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
  Protected *item = images()
  Protected iWidth, iHeight
  
   iWidth = Width -Bar::Width(*scroll\v)
  iHeight = Height -Bar::Height(*scroll\h)
  
  GetScrollCoordinate()
  
  Protected hMax = ScrollWidth
  Protected vMax = ScrollHeight
  
  If *scroll\x>x
    ;ScrollWidth + (*scroll\x-x) 
    *scroll\x= x
  EndIf
  
  If *scroll\y>y
    ;ScrollHeight + (*scroll\y-y)
    *scroll\y= y
  EndIf
  
  If ScrollWidth<iWidth - (*scroll\x-x)
    ScrollWidth=iWidth - (*scroll\x-x)
  EndIf
;   
  If ScrollHeight<iHeight - (*scroll\y-y)
    ScrollHeight=iHeight - (*scroll\y-y)
  EndIf
  
  If *scroll\h\bar\Max<>ScrollWidth
    Bar::SetAttribute(*scroll\h, #__bar_Maximum, ScrollWidth)
    
    If *scroll\x< x 
      
;       Debug ""+*scroll\h\bar\change +" "+ Str(*scroll\x- x)
;       PushListPosition(Images())
;       ForEach Images()
;         If *current <> images() And *scroll\h\bar\change > 0
;           Images()\X - *scroll\h\bar\ change
;         EndIf
;       Next
;       PopListPosition(Images())
      
      *scroll\h\bar\change = *scroll\h\bar\page\pos + (*scroll\x- x)
      
      PushListPosition(Images())
      ForEach Images()
        If *current <> images() And *scroll\h\bar\change < 0
          Images()\X - *scroll\h\bar\ change
        EndIf
      Next
      PopListPosition(Images())
      
      *scroll\h\bar\page\pos =- (*scroll\x- x)
     ; Bar::SetState(*scroll\h, *scroll\h\bar\max)
     *scroll\h\bar\change = 0
    EndIf
  EndIf
  
  If *scroll\v\bar\Max<>ScrollHeight
    Bar::SetAttribute(*scroll\v, #__bar_Maximum, ScrollHeight)
    
    If *scroll\y < y 
       *scroll\v\bar\page\pos =- (*scroll\y-y)
       *scroll\v\bar\change = 0
    EndIf
  EndIf
  
  Bar::Resizes(*scroll, X, Y, Width, Height) 
 
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
   Width = GadgetWidth(Canvas) - x*2
   Height = GadgetHeight(Canvas) - y*2
  ;Protected *scroll\x, *scroll\y, ScrollWidth, ScrollHeight
  
  If Bar::Events(*scroll\v, Event, MouseX, MouseY, WheelDelta) 
    Repaint = #True 
  EndIf
  If Bar::Events(*scroll\h, Event, MouseX, MouseY, WheelDelta) 
    If *scroll\h\change <> *scroll\h\bar\change
      Debug (*scroll\h\bar\change)
      
      PushListPosition(Images())
      ForEach Images()
       ; If *scroll\h\bar\change
          ;*scroll\x =x-(x -*scroll\h\bar\Page\Pos)
          Images()\X + *scroll\h\bar\change ; -(*scroll\x))) 
                                            ;Debug Images()\X;Images()\Y-*scroll\v\bar\Page\Pos
      ;  EndIf
      Next
      PopListPosition(Images())
      
      *scroll\h\change = *scroll\h\bar\change
      ; *scroll\x = x-*scroll\h\bar\Page\Pos
    EndIf
    Repaint = #True 
  EndIf
  
;   Select Event
;     Case #PB_EventType_LeftButtonUp
;       GetScrollCoordinate()
;       
;       If (*scroll\x<0 Or *scroll\y<0)
;         PushListPosition(Images())
;         ForEach Images()
;           If *scroll\x<0
;             *scroll\h\bar\Page\Pos =- *scroll\x
;             Images()\X-*scroll\x
;           EndIf
;           If *scroll\y<0
;             *scroll\v\bar\Page\Pos =- *scroll\y
;             Images()\Y-*scroll\y
;           EndIf
;         Next
;         PopListPosition(Images())
;       EndIf
;       
;   EndSelect     
  
  If Not (*scroll\h\from=-1 And *scroll\v\from=-1)
    Select Event
      Case #PB_EventType_LeftButtonUp
        Debug "----------Up---------"
        ScrollUpdates(Width, Height)
    EndSelect
  Else
    Select Event
      Case #PB_EventType_LeftButtonUp : Drag = #False
      Case #PB_EventType_LeftButtonDown
        *current = HitTest(Images(), Mousex, Mousey)
        If *current 
          Repaint = #True 
          Drag = #True
        EndIf
        
      Case #PB_EventType_MouseMove
        If Drag = #True
          If *current
            If LastElement(Images())
              Images()\x = Mousex - currentItemXOffset
              Images()\y = Mousey - currentItemYOffset
              
              ScrollUpdates(Width, Height)
              
              Repaint = #True
            EndIf
          EndIf
        EndIf
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        GetScrollCoordinate()
        
        If *scroll\h\bar\Max<>ScrollWidth : Bar::SetAttribute(*scroll\h, #__bar_Maximum, ScrollWidth) : EndIf
        If *scroll\v\bar\Max<>ScrollHeight : Bar::SetAttribute(*scroll\v, #__bar_Maximum, ScrollHeight) : EndIf
        
        
       ;Bar::Resizes(*scroll, x, y, Width, Height)
        ScrollUpdates(Width, Height)
         Repaint = #True
        
    EndSelect
  EndIf 
  
  If Repaint : Draw_Canvas(MyCanvas, Images()) : EndIf
EndProcedure

Procedure ResizeCallBack()
  ResizeGadget(MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
EndProcedure


If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
  MessageRequester("Fatal error", "Program terminated.")
  End
EndIf

;
MyCanvas = Open_Canvas(0, 10, 10, Width+x*2, Width+y*2, #PB_Canvas_Keyboard)

*scroll\v = Bar::scroll(0, 0,  20, 0, 0, 0, 0, #__bar_Vertical)
*scroll\h = Bar::scroll(0, 0, 0,  20, 0, 0, 0, 0)

PostEvent(#PB_Event_Gadget, 0,MyCanvas,#PB_EventType_Resize)
BindGadgetEvent(MyCanvas, @CallBack())
BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 192
; FirstLine = 181
; Folding = --------
; EnableXP