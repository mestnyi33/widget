;
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  ; IncludePath "C:\Users\as\Documents\GitHub\"
  ; XIncludeFile "module_scroll.pbi"
  
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
  
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global v,h,Event.i, x.i, y.i, drag.i, hole.i, Width, Height
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
  
  Procedure.b Updates(v,h, ScrollArea_X.l, ScrollArea_Y.l, ScrollArea_Width.l, ScrollArea_Height.l)
      Protected iWidth = GadgetX(v), iHeight = GadgetY(h)
      Static hPos, vPos : vPos = GetGadgetState(v) : hPos = GetGadgetState(h) 
      
      ; Вправо работает как надо
      If ScrollArea_Width<GetGadgetState(h)+iWidth 
        ScrollArea_Width=GetGadgetState(h)+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>GetGadgetState(h) And
             ScrollArea_Width=GetGadgetState(h)+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<GetGadgetState(v)+iHeight
        ScrollArea_Height=GetGadgetState(v)+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>GetGadgetState(v) And
             ScrollArea_Height=GetGadgetState(v)+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
      
      If ScrollArea_X<GetGadgetState(h) : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<GetGadgetState(v) : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If GetGadgetAttribute(v, #PB_ScrollBar_Maximum)<>ScrollArea_Height : SetGadgetAttribute(v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
      If GetGadgetAttribute(h, #PB_ScrollBar_Maximum)<>ScrollArea_Width : SetGadgetAttribute(h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
      
      If GetGadgetAttribute(v, #PB_ScrollBar_PageLength)<>iHeight : SetGadgetAttribute(v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If GetGadgetAttribute(h, #PB_ScrollBar_PageLength)<>iWidth : SetGadgetAttribute(h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If ScrollArea_Y<0 : SetGadgetState(v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetGadgetState(h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      ;       \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h) 
      ;       \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v)
;       ResizeGadget(v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y+Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1))
;       ResizeGadget(h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x+Bool(Not \v\hide And \v\Radius And \h\Radius)*(\v\button\len/4+1), #PB_Ignore)
      
;       If \v\hide : SetGadgetState(v, 0) : If vPos : \v\hide = vPos : EndIf : Else : SetGadgetState(v, vPos) : EndIf
;       If \h\hide : SetGadgetState(h, 0) : If hPos : \h\hide = hPos : EndIf : Else : SetGadgetState(h, hPos) : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)

  EndProcedure
  
  Procedure _Draw (canvas.i)
    If StartDrawing(CanvasOutput(canvas))
      ; ClipOutput(0,0, X(*scroll\v), Y(*scroll\h))
      ClipOutput(0, 0, GetGadgetAttribute(h, #PB_ScrollBar_PageLength), GetGadgetAttribute(v, #PB_ScrollBar_PageLength))
      ;ClipOutput(*scroll\h\area\pos, *scroll\v\area\pos, *scroll\h\area\len, *scroll\v\area\len)
      
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
      
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      ForEach Images()
;         DrawImage(ImageID(Images()\img), Images()\x - GetState(*scroll\h), Images()\y - GetState(*scroll\v)) ; draw all images with z-order
        DrawImage(ImageID(Images()\img), Images()\x - GetGadgetState(h), Images()\y - GetGadgetState(v)) ; draw all images with z-order
      Next
      
      UnclipOutput()
      
; ;       If Not Hide(*scroll\v) : Draw(*scroll\v) : EndIf
; ;       If Not Hide(*scroll\v) : Draw(*scroll\h) : EndIf
;       If Not *scroll\v\hide : Draw(*scroll\v) : EndIf
;       If Not *scroll\h\hide : Draw(*scroll\h) : EndIf
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i HitTest (List Images.canvasitem(), x, y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, isCurrentItem.i = #False
    
    If LastElement(Images()) ; search for hit, starting from end (z-order)
      Repeat
        If x >= Images()\x - GetGadgetState(h) And x < Images()\x + Images()\width - GetGadgetState(h)
          If y >= Images()\y - GetGadgetState(v) And y < Images()\y + Images()\height - GetGadgetState(v)
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
  AddImage(Images(),  250,350, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))
  
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
  
  Procedure.i Canvas_CallBack() ; Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint
    Protected Canvas = EventGadget()
    Protected EventType = EventType()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
    
    Select EventType
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
                Repaint = Updates(v,h, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
              EndIf
            EndIf
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          GetScrollCoordinate()
          SetGadgetAttribute(h, #PB_ScrollBar_Maximum, ScrollWidth)
          SetGadgetAttribute(v, #PB_ScrollBar_Maximum, ScrollHeight)
          
          SetGadgetAttribute(v, #PB_ScrollBar_PageLength, Height-16)
          SetGadgetAttribute(h, #PB_ScrollBar_PageLength, Width-16)
          
          ResizeGadget(v, Width-20+10, #PB_Ignore, #PB_Ignore, Height-16)
          ResizeGadget(h, #PB_Ignore, Height-20+110, Width-16, #PB_Ignore)
          Repaint = #True
          
      EndSelect
    
    If Repaint 
      _Draw(#MyCanvas) 
    EndIf
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(#MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20-100)
  EndProcedure
  
  Procedure BindHScrollDatas()
    SetWindowTitle(0, "ScrollBarGadget (" + GetGadgetState(h) + ")" )
    _Draw(#MyCanvas) 
    EndProcedure

  Procedure BindVScrollDatas()
    SetWindowTitle(0, "ScrollBarGadget (" + GetGadgetState(v) + ")" )
    _Draw(#MyCanvas) 
    EndProcedure

  If Not OpenWindow(0, 0, 0, 420, 420+100, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  ;
  CheckBoxGadget(2, 10, 10, 80,20, "vertical") : SetGadgetState(2, 1)
  CheckBoxGadget(3, 10, 30, 80,20, "invert")
  CheckBoxGadget(4, 10, 50, 80,20, "noButtons")
  
  CanvasGadget(#MyCanvas, 10, 110, 400, 400, #PB_Canvas_Container)
  CloseGadgetList()
  
  v = ScrollBarGadget(-1,380, 110,  20, 380, 0, 0, 0, #PB_ScrollBar_Vertical)
  h = ScrollBarGadget(-1,10, 380+110, 380,  20, 0, 0, 0, 0)
  BindGadgetEvent(v, @BindHScrollDatas())
  BindGadgetEvent(h, @BindVScrollDatas())
  
  SetGadgetState(h, 10)
  
  PostEvent(#PB_Event_Gadget, 0,#MyCanvas, #PB_EventType_Resize)
  BindGadgetEvent(#MyCanvas, @Canvas_CallBack())
  BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
  
  Repeat
    Event = WaitWindowEvent()
    
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -------
; EnableXP