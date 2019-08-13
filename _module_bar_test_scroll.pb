IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "_module_bar.pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  ; IncludePath "C:\Users\as\Documents\GitHub\"
  ; XIncludeFile "module_scroll.pbi"
  
  EnableExplicit
  UseModule Bar
  Global *scroll._S_scroll=AllocateStructure(_S_scroll)
  
  
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
  
  Procedure ReDraw (canvas.i)
    With *scroll
      If StartDrawing(CanvasOutput(canvas))
        ; ClipOutput(\h\x, \v\y, \h\page\len, \v\page\len)
        
        FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
        
        DrawingMode(#PB_2DDrawing_AlphaBlend)
        ForEach Images()
          DrawImage(ImageID(Images()\img), Images()\x - \h\page\pos, Images()\y - \v\page\pos) ; draw all images with z-order
        Next
        
        UnclipOutput()
        
        If Not \v\hide : Draw(\v) : EndIf
        If Not \h\hide : Draw(\h) : EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\h\x, \v\y, \h\page\len, \v\page\len, $0000FF)
        
        
        StopDrawing()
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i HitTest (List Images.canvasitem(), mouse_x, mouse_y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, image_x, image_y, isCurrentItem.i = #False
    
    If LastElement(Images()) ; search for hit, starting from end (z-order)
      With *scroll
        
        Repeat
          image_x = \h\x + Images()\x - \h\page\pos
          image_y = \v\y + Images()\y - \v\page\pos
          
          If mouse_x > image_x And mouse_x =< image_x+Images()\width And ; Images()\x + Images()\width - \h\page\pos  ;  
             mouse_y > image_y And mouse_y =< image_y+Images()\height    ; Images()\y + Images()\height - \v\page\pos  ;   
            
            If Images()\alphatest And 
               ImageDepth(Images()\img)>31 And 
               StartDrawing(ImageOutput(Images()\img))
              DrawingMode(#PB_2DDrawing_AlphaChannel)
              alpha = Alpha( Point(mouse_x-image_x, mouse_y-image_y)) ; get alpha
              StopDrawing()
            Else
              alpha = 255
            EndIf
            
            If alpha
              MoveElement(Images(), #PB_List_Last)
              isCurrentItem = #True
              currentItemXOffset = mouse_x - Images()\x
              currentItemYOffset = mouse_y - Images()\y
              Break
            EndIf
          EndIf
        Until PreviousElement(Images()) = 0
      EndWith
      
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
  
  Procedure.b Resizes2(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    With *scroll
      Protected iHeight, iWidth
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
;       iWidth = (\v\x + Bool(\v\hide) * \v\width) - \h\x
;       iHeight = (\h\y + Bool(\h\hide) * \h\height) - \v\y
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
;       iWidth = (\v\x + Bool(\v\hide) * \v\width) - \h\x
;       iHeight = (\h\y + Bool(\h\hide) * \h\height) - \v\y
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\page\len) : EndIf
      If \h\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\page\len, #PB_Ignore) : EndIf
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\Radius And \h\Radius)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\Radius And \h\Radius)*(\h\height/4))
      EndIf
;       \v\page\pos =- 30
;       Debug \v\page\pos
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
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
    
    With *scroll
      
      If CallBack(\v, EventType, MouseX, MouseY, WheelDelta) 
        Repaint = #True 
      EndIf
      If CallBack(\h, EventType, MouseX, MouseY, WheelDelta) 
        Repaint = #True 
      EndIf
      
      
      
      ;If Not Bool(\h\from And \v\from)
      Select EventType
        Case #PB_EventType_LeftButtonUp
          GetScrollCoordinate()
          
          If (ScrollX<0 Or ScrollY<0)
            PushListPosition(Images())
            ForEach Images()
              If ScrollX<0
                Images()\X-ScrollX
              EndIf
              If ScrollY<0
                Images()\Y-ScrollY
              EndIf
            Next
            PopListPosition(Images())
            
            If ScrollX<0
              *scroll\h\page\pos =- ScrollX+*scroll\h\page\pos
            EndIf
            If ScrollY<0
              *scroll\v\page\pos =- ScrollY+*scroll\v\page\pos
            EndIf
          EndIf
          
      EndSelect     
      ;EndIf
      
      
      If (\h\from Or \v\from)
        If \v\from And \v\change
          SetWindowTitle(EventWindow(), Str(\v\page\pos))
        EndIf
        If \h\from And \h\change
          SetWindowTitle(EventWindow(), Str(\h\page\pos))
        EndIf
        
        Select EventType
          Case #PB_EventType_LeftButtonUp
            Debug "----------Up---------"
            GetScrollCoordinate()
            
            ;               Debug ""+Scrollx+" "+*scroll\h\page\pos
            ;               
            ;               If *scroll\h\page\pos<>Scrollx
            ;                 ScrollWidth - *scroll\h\page\pos
            ;                 *scroll\h\page\pos = Scrollx
            ;               EndIf 
            ;                Debug ""+Scrollx+" "+ScrollWidth
            
            Updates(*scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
            
            
        EndSelect
      Else
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
                  
                  ;                   ScrollX = Images()\x
                  ;                   ScrollY = Images()\y
                  
                  GetScrollCoordinate()
                  Repaint = Updates(*scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
                  
                EndIf
              EndIf
            EndIf
            
          Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
            GetScrollCoordinate()
            
            If \h\max<>ScrollWidth : SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollWidth) : EndIf
            If \v\max<>ScrollHeight : SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollHeight) : EndIf
            
            Resizes2(*scroll, 0, 30, Width, Height-30)
            Repaint = #True
            
        EndSelect
      EndIf 
      
      If Repaint 
        ReDraw(#MyCanvas) 
      EndIf
    EndWith
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(#MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20-100)
  EndProcedure
  
  
  If Not OpenWindow(0, 0, 0, 420, 420+100, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  ;
  CheckBoxGadget(2, 10, 10, 80,20, "vertical") : SetGadgetState(2, 1)
  CheckBoxGadget(3, 10, 30, 80,20, "invert")
  CheckBoxGadget(4, 10, 50, 80,20, "noButtons")
  CheckBoxGadget(5, 10, 70, 80,20, "Pos&len")
  TrackBarGadget(6, 10, 95, 400,20, 0, 400, #PB_TrackBar_Ticks)
  SetGadgetState(5,1)
  
  CanvasGadget(#MyCanvas, 10, 110, 400, 400)
  
  *Scroll\v = Scroll(380, 0,  20, 380, 0, 0, 0, #PB_ScrollBar_Vertical, 9)
  *Scroll\h = Scroll(0, 380, 380,  20, 0, 0, 0, 0, 9)
  
  SetState(*Scroll\h, 30)
  
  If GetGadgetState(2)
    SetGadgetState(3, GetAttribute(*Scroll\v, #PB_Bar_Inverted))
  Else
    SetGadgetState(3, GetAttribute(*Scroll\h, #PB_Bar_Inverted))
  EndIf
  
  Define vButton = GetAttribute(*Scroll\v, #PB_Bar_NoButtons)
  Define hButton = GetAttribute(*Scroll\h, #PB_Bar_NoButtons)
  
  PostEvent(#PB_Event_Gadget, 0,#MyCanvas, #PB_EventType_Resize)
  BindGadgetEvent(#MyCanvas, @Canvas_CallBack())
  BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
  
  ;Resize(*Scroll\v, #PB_Ignore, 30, #PB_Ignore, (*scroll\v\page\len + Bool(*scroll\v\Radius And *scroll\h\Radius)*(*scroll\h\height/4))-30)
              
  Repeat
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 6
            If GetGadgetState(5)
              If GetGadgetState(2)
                Resize(*Scroll\v, #PB_Ignore, GetGadgetState(6), #PB_Ignore, (*scroll\v\page\len + Bool(*scroll\v\Radius And *scroll\h\Radius)*(*scroll\h\height/4))-GetGadgetState(6))
              Else
                Resize(*Scroll\h, GetGadgetState(6), #PB_Ignore, (*scroll\h\page\len + Bool(*scroll\v\Radius And *scroll\h\Radius)*(*scroll\v\width/4))-GetGadgetState(6), #PB_Ignore)
              EndIf
            Else
              If GetGadgetState(2)
                Resizes(*Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, 400-GetGadgetState(6))
              Else
                Resizes(*Scroll, #PB_Ignore, #PB_Ignore, 400-GetGadgetState(6), #PB_Ignore)
              EndIf
            EndIf
            ReDraw(#MyCanvas) 
            
          Case 2 
            If GetGadgetState(2)
              SetGadgetState(3, GetAttribute(*Scroll\v, #PB_Bar_Inverted))
            Else
              SetGadgetState(3, GetAttribute(*Scroll\h, #PB_Bar_Inverted))
            EndIf
            
          Case 3
            If GetGadgetState(2)
              SetAttribute(*Scroll\v, #PB_Bar_Inverted, Bool(GetGadgetState(3)))
              SetWindowTitle(0, Str(GetState(*Scroll\v)))
            Else
              SetAttribute(*Scroll\h, #PB_Bar_Inverted, Bool(GetGadgetState(3)))
              SetWindowTitle(0, Str(GetState(*Scroll\h)))
            EndIf
            ReDraw(#MyCanvas) 
            
          Case 4
            If GetGadgetState(2)
              SetAttribute(*Scroll\v, #PB_Bar_NoButtons, Bool( Not GetGadgetState(4)) * vButton) 
              SetWindowTitle(0, Str(GetState(*Scroll\v)))
            Else
              SetAttribute(*Scroll\h, #PB_Bar_NoButtons, Bool( Not GetGadgetState(4)) * hButton)
              SetWindowTitle(0, Str(GetState(*Scroll\h)))
            EndIf
            ReDraw(#MyCanvas) 
            
        EndSelect
    EndSelect
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -8---------
; EnableXP