XIncludeFile "../../widgets.pbi"

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
  
  Global MyCanvas, *scroll._s_scroll = AllocateStructure(_s_scroll)
  
  Global *current=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, drag.i, hole.i
  Global x=100,y=100, Width=420, Height=420 , focus
  
  Global NewList Images.canvasitem()
  
  
  Procedure.i HitTest (List Images.canvasitem(), x, y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, *current = #False
    Protected scroll_x ; = *scroll\h\bar\Page\Pos
    Protected scroll_y ;= *scroll\v\bar\Page\Pos
    
    If LastElement(Images()) ; search for hit, starting from end (z-order)
      Repeat
        If x >= Images()\x - scroll_x And x < Images()\x+ Images()\width - scroll_x 
          If y >= Images()\y - scroll_y And y < Images()\y + Images()\height - scroll_y
            alpha = 255
            
            If Images()\alphatest And ImageDepth(Images()\img)>31
              If StartDrawing(ImageOutput(Images()\img))
                DrawingMode(#PB_2DDrawing_AlphaChannel)
                alpha = Alpha(Point(x-Images()\x - scroll_x, y-Images()\y - scroll_y)) ; get alpha
                StopDrawing()
              EndIf
            EndIf
            
            If alpha
              MoveElement(Images(), #PB_List_Last)
              *current = @Images()
              currentItemXOffset = x - Images()\x - scroll_x
              currentItemYOffset = y - Images()\y - scroll_y
              Break
            EndIf
          EndIf
        EndIf
      Until PreviousElement(Images()) = 0
    EndIf
    
    ProcedureReturn *current
  EndProcedure
  
  Procedure AddImage (List Images.canvasitem(), x, y, img, alphatest=0)
    If AddElement(Images())
      Images()\img    = img
      Images()\x          = x
      Images()\y          = y
      Images()\width  = ImageWidth(img)
      Images()\height = ImageHeight(img)
      Images()\alphatest = alphatest
    EndIf
  EndProcedure
  
  AddImage(Images(),  x-80, y-20, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp"))
  AddImage(Images(), x+100,y+100, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp"))
  ;AddImage(Images(),  x+221,y+200, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
  ;AddImage(Images(),  x+210,y+321, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
  ;AddImage(Images(),  x,y-1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
  AddImage(Images(),  x+310,y+350, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
  
  hole = CreateImage(#PB_Any,100,100,32)
  If StartDrawing(ImageOutput(hole))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,100,100,RGBA($00,$00,$00,$00))
    Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
    Circle(50,50,30,RGBA($00,$00,$00,$00))
    StopDrawing()
  EndIf
  AddImage(Images(),x+170,y+70,hole,1)
  
  
  Macro GetScrollCoordinate(x, y, width, height)
    *scroll\x = Images()\x 
    *scroll\y = Images()\Y
    *scroll\width = Images()\x+Images()\width - *scroll\x
    *scroll\height = Images()\Y+Images()\height - *scroll\y
    
    PushListPosition(Images())
    ForEach Images()
      If *scroll\x > Images()\x : *scroll\x = Images()\x : EndIf
      If *scroll\y > Images()\y : *scroll\y = Images()\y : EndIf
    Next
    ForEach Images()
      If *scroll\width < Images()\x+Images()\width - *scroll\x : *scroll\width = Images()\x+Images()\width - *scroll\x : EndIf
      If *scroll\height < Images()\Y+Images()\height - *scroll\y : *scroll\height = Images()\Y+Images()\height - *scroll\y : EndIf
    Next
    PopListPosition(Images())
    
    widget::Updates(*scroll, x, y, width, height)
    
    ; SetWindowTitle(EventWindow(), Str(Images()\x)+" "+Str(Images()\width)+" "+Str(Images()\x+Images()\width))
  EndMacro
  
  Procedure Canvas_Draw(canvas.i, List Images.canvasitem())
    If StartDrawing(CanvasOutput(canvas))
      DrawingMode(#PB_2DDrawing_Default)
      Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
      
      ;ClipOutput(*scroll\h\x, *scroll\v\y, *scroll\h\bar\page\len, *scroll\v\bar\page\len)
      
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      ForEach Images()
        DrawImage(ImageID(Images()\img), Images()\x, Images()\y) ; draw all images with z-order
      Next
      
      widget::Draw(*scroll\v)
      widget::Draw(*scroll\h)
      
      UnclipOutput()
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(x, y, Width, Height, RGB(0,255,255))
      Box(*scroll\x, *scroll\y, *scroll\width, *scroll\height, RGB(255,0,255))
      Box(*scroll\x, *scroll\y, *scroll\h\bar\max, *scroll\v\bar\max, RGB(255,0,0))
      Box(*scroll\h\x, *scroll\v\y, *scroll\h\bar\page\len, *scroll\v\bar\page\len, RGB(255,255,0))
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure Canvas_CallBack()
    Static set_cursor 
    Protected cursor
    Protected Repaint
    Protected Event = EventType()
    Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;   Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    ;   Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Width = GadgetWidth(Canvas) - x*2
    Height = GadgetHeight(Canvas) - y*2
    
    If *scroll\v\bar\state =- 1 And 
       *scroll\h\bar\state =- 1
      Select Event
        Case #PB_EventType_LeftButtonUp : Drag = #False
          SetGadgetAttribute(MyCanvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
          
        Case #PB_EventType_LeftButtonDown
          Drag = Bool(HitTest(Images(), Mousex, Mousey))
          If Drag 
            SetGadgetAttribute(MyCanvas, #PB_Canvas_Cursor, #PB_Cursor_Arrows)
            Repaint = #True 
          EndIf
          
        Case #PB_EventType_MouseMove
          If Drag = #True
            If LastElement(Images())
              Images()\x = Mousex - currentItemXOffset
              Images()\y = Mousey - currentItemYOffset
              
              GetScrollCoordinate(x, y, width, height)
              
              Repaint = #True
            EndIf
          Else
            If Bool(HitTest(Images(), Mousex, Mousey)) 
              ;If widget::_from_point_(Mousex, Mousey, Images(), [3])
              cursor = #PB_Cursor_Hand
              ;EndIf
            Else 
              cursor = #PB_Cursor_Default
            EndIf
            
            If set_cursor <> cursor
              set_cursor = cursor
              SetGadgetAttribute(MyCanvas, #PB_Canvas_Cursor, cursor)
            EndIf
            
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          
          GetScrollCoordinate(x, y, width, height)
          Repaint = #True
          
      EndSelect
    EndIf
    
    If Not Repaint And widget::Callback()
      
      If Widget()\bar\change
        If Widget()\bar\vertical
          PushListPosition(Images())
          ForEach Images()
            Images()\Y + Widget()\bar\page\change 
          Next
          PopListPosition(Images())
          
          *scroll\y =- Widget()\bar\page\pos+Widget()\y
        Else
          
          PushListPosition(Images())
          ForEach Images()
            Images()\X + Widget()\bar\page\change
          Next
          PopListPosition(Images())
          
          *scroll\x =- Widget()\bar\page\pos+Widget()\x
        EndIf
        
        Widget()\bar\change = 0
      EndIf
      
      Repaint = #True 
    EndIf
    
    If Repaint 
      Canvas_Draw(MyCanvas, Images()) 
    EndIf
  EndProcedure
  
  If Not OpenWindow(0, 0, 0, Width+x*2+20, Height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
    MessageRequester("Fatal error", "Program terminated.")
    End
  EndIf
  
  MyCanvas = GetGadget(Open(0, 10, 10, Width+x*2, Width+y*2, #PB_Canvas_Keyboard, @Canvas_CallBack()))
  
  ; *scroll\v = widget::scroll(0, y, 20, 0, 0, 0, Width-20, #__bar_Vertical|#__bar_inverted, 11)
  ; *scroll\h = widget::scroll(x, 0, 0,  20, 0, 0, Height-20, #__bar_inverted, 11)
  *scroll\v = widget::scroll(0, y, 20, 0, 0, 0, Width-20, #__bar_Vertical, 11)
  *scroll\h = widget::scroll(x, 0, 0,  20, 0, 0, Height-20, 0, 11)
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -----
; EnableXP