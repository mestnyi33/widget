IncludePath "/Users/as/Documents/GitHub/Widget/exemples/"
XIncludeFile "scroll_new000_____.pb"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Scroll
  EnableExplicit
  
  Global *Scroll._S_scroll=AllocateStructure(_S_scroll)
  Global Window_demo, v, h, x=151,y=151, Width=790, Height=600 , focus
  Global g_container, g_value, g_value_, g_is_vertical, g_min, g_max, g_draw_pos, g_draw_len, g_set, g_page_pos, g_page_len, g_area_pos, g_area_len, g_Canvas
  
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
 
  Structure canvasitem
    img.i
    x.i
    y.i
    width.i
    height.i
    alphatest.i
  EndStructure
  
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, drag.i, hole.i
  Global NewList Images.canvasitem()
  
  Macro _scroll_pos_(_this_)
    (_this_\min + Round((_this_\thumb\pos - _this_\area\pos) / (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Down)) 
  EndMacro
  
  Procedure ReDraw(canvas.i)
    With *Scroll
      
      If StartDrawing(CanvasOutput(canvas))
      ; ClipOutput(0,0, X(\v), Y(\h))
      ClipOutput(\h\x, \v\y, \h\page\len, \v\page\len)
      
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
      
     ; Debug " "+Str(_scroll_pos_(\h)) +" "+ \h\page\pos
      
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      ForEach Images()
        DrawImage(ImageID(Images()\img), Images()\x - \h\page\pos + \h\x, Images()\y - \v\page\pos + \v\y) ; draw all images with z-order
      Next
      
      UnclipOutput()
      
;       If Not Hide(*scroll\v) : Draw(*scroll\v) : EndIf
;       If Not Hide(*scroll\v) : Draw(*scroll\h) : EndIf
      If Not *scroll\v\hide : Draw(*scroll\v) : EndIf
      If Not *scroll\h\hide : Draw(*scroll\h) : EndIf
      
      DrawingMode(#PB_2DDrawing_Outlined)
        
        ; widget area coordinate
        Box(x-1, y-1, Width-x*2-190+2, Height-y*2+2, $0000FF)
        
        ; Scroll area coordinate
        ; Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
         Box(\h\x-\h\Page\end, \v\y-\v\Page\end, \h\Max, \v\Max, $FF0000)
        ;Box(\h\x-_scroll_pos_(\h), \v\y-_scroll_pos_(\v), \h\Max, \v\Max, $FF0000)
        
        ; page coordinate
        Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
        
        ; area coordinate
        Box(\h\area\pos, \v\area\pos, \h\area\Len, \v\area\Len, $00FFFF)
        
        ; scroll coordinate
        Box(\h\x, \v\y, \h\width, \v\height, $FF00FF)
        
;         ; frame coordinate
;         Box(\h\x, \v\y, 
;             \h\Page\len + (Bool(Not \v\hide) * \v\width),
;             \v\Page\len + (Bool(Not \h\hide) * \h\height), $FFFF00)
        
      StopDrawing()
    EndIf
    
    EndWith
  EndProcedure
  
  Procedure.i HitTest (List Images.canvasitem(), mouse_x, mouse_y)
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, image_x, image_y, isCurrentItem.i = #False
    
    If LastElement(Images()) ; search for hit, starting from end (z-order)
      Repeat
        image_x = *scroll\h\x + Images()\x - *scroll\h\page\pos
        image_y = *scroll\v\y + Images()\y - *scroll\v\page\pos
        
        If mouse_x > image_x And mouse_x =< image_x+Images()\width And ; Images()\x + Images()\width - *scroll\h\page\pos  ;  
           mouse_y > image_y And mouse_y =< image_y+Images()\height    ; Images()\y + Images()\height - *scroll\v\page\pos  ;   
          
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
    EndIf
    
    ProcedureReturn isCurrentItem
  EndProcedure
  
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
  
  AddImage(Images(),  10, 10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/PureBasic.bmp"))
  AddImage(Images(), 100,100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/GeeBee2.bmp"))
  AddImage(Images(), 50,150, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/AlphaChannel.bmp"))
  
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
  
  Procedure ScrollUpdates(*scroll._S_scroll, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *scroll
      ;ProcedureReturn 
      
      ;Protected iWidth = X(\v), iHeight = Y(\h)
      Protected iWidth = \h\page\len, iHeight = \v\page\len
      Static hPos, vPos : vPos = \v\page\pos : hPos = \h\page\pos
      
      ; Вправо работает как надо
      If ScrollArea_Width<\h\page\pos+iWidth 
        ScrollArea_Width=\h\page\pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\page\pos And
             ScrollArea_Width=\h\page\pos+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<\v\page\pos+iHeight
        ScrollArea_Height=\v\page\pos+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\page\pos And
             ScrollArea_Height=\v\page\pos+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X > 0 : ScrollArea_X = 0 : EndIf
      If ScrollArea_Y > 0 : ScrollArea_Y = 0 : EndIf
      
      If ScrollArea_X < 0 : ScrollArea_Width-ScrollArea_X : EndIf
      ;If ScrollArea_X<\h\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \h\max <> ScrollArea_Width 
        SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollArea_Width) 
      EndIf
      If \v\max <> ScrollArea_Height 
        SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollArea_Height) 
      EndIf
      
;       If \v\page\len <> iHeight 
;         SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) 
;       EndIf
;       If \h\page\len <> iWidth 
;         SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) 
;       EndIf
      
      If -\h\page\pos > ScrollArea_X
        SetState(\h, _scroll_invert_(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width, \h\inverted)) 
      EndIf
      If -\v\page\pos > ScrollArea_Y
        SetState(\v, _scroll_invert_(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height, \v\inverted)) 
      EndIf
      
      \h\thumb\len = _thumb_len_(\h)
      \h\thumb\pos = _thumb_pos_(\h, _scroll_invert_(\h, \h\page\pos, \h\inverted))
      
      \v\thumb\len = _thumb_len_(\v)
      \v\thumb\pos = _thumb_pos_(\v, _scroll_invert_(\v, \v\page\pos, \v\inverted))
      
      \h\hide[1] = Bool(Not ((\h\max-\h\min) > \h\page\len))
      \v\hide[1] = Bool(Not ((\v\max-\v\min) > \v\page\len))
      \h\hide = \h\hide[1]
      \v\hide = \v\hide[1]
      
      ;       \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y+Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\width/4))
      ;       \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x+Bool(Not \v\hide And \v\Radius And \h\Radius)*(\h\height/4), #PB_Ignore)
      
      If \v\hide 
        \v\page\pos = 0 
        
        If vPos 
          \v\hide = Bool(vPos) 
        EndIf 
      Else 
        \v\page\pos = vPos
      EndIf
      
      If \h\hide 
        \h\page\pos = 0 
        
        If hPos 
          \h\hide = Bool(hPos)
        EndIf
      Else 
        \h\page\pos = hPos 
      EndIf
      
      Debug " pp-"+\h\page\pos +" pl-"+ \h\page\len +" tp-"+ \h\thumb\pos +" tl-"+ \h\thumb\len +" ap-"+ \h\area\pos +" al-"+ \h\area\len +" m-"+ \h\max
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
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
    
    If CallBack(*scroll\v, EventType, MouseX, MouseY, WheelDelta) 
      Repaint = #True 
    EndIf
    If CallBack(*scroll\h, EventType, MouseX, MouseY, WheelDelta) 
      Repaint = #True 
    EndIf
    
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
    
    
    If (*scroll\h\from Or *scroll\v\from)
      Select EventType
        Case #PB_EventType_LeftButtonUp
          Debug "----------Up---------"
          GetScrollCoordinate()
          Updates(*scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
          ;           Protected iWidth = Width-Width(*scroll\v), iHeight = Height-Height(*scroll\h)
          ;   
          ;         Debug ""+*scroll\h\hide+" "+ScrollX+" "+Str(ScrollWidth-iWidth)
          ;         Debug ""+*scroll\v\hide+" "+ScrollY+" "+Str(ScrollHeight-iHeight)
          
          PushListPosition(Images())
          ForEach Images()
            ;           If *scroll\h\hide And (ScrollWidth-Width)>0 : Images()\X-(ScrollWidth-Width) : EndIf
            ;           If *scroll\v\hide And (ScrollHeight-Height)>0 : Images()\Y-(ScrollHeight-Height) : EndIf
            If *scroll\h\hide>1 : Images()\X-*scroll\h\hide : EndIf
            If *scroll\v\hide>1 : Images()\Y-*scroll\v\hide : EndIf
          Next
          PopListPosition(Images())
          
          
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
                
                GetScrollCoordinate()
                Repaint = Updates(*scroll, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
              EndIf
            EndIf
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          GetScrollCoordinate()
          
          If *scroll\h\max<>ScrollWidth : SetAttribute(*scroll\h, #PB_ScrollBar_Maximum, ScrollWidth) : EndIf
          If *scroll\v\max<>ScrollHeight : SetAttribute(*scroll\v, #PB_ScrollBar_Maximum, ScrollHeight) : EndIf
          
          Resizes(*scroll, x, y, Width-x*2, Height-y*2)
          Repaint = #True
          
      EndSelect
    EndIf 
    
    If Repaint 
      
      ReDraw(Canvas) 
    EndIf
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
    
    ;-
    Procedure Widget_Events()
      Select EventType()
        Case #PB_EventType_ScrollChange
          Debug EventData()
      EndSelect
    EndProcedure
    
    Procedure ResizeCallBack()
      ResizeGadget(g_Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-210, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
    EndProcedure
    
    If OpenWindow(0, 0, 0, Width+20, Height+20, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
      g_container = ContainerGadget(#PB_Any, 10, 10, 180, 250, #PB_Container_Flat)
      
      g_is_vertical = CheckBoxGadget(#PB_Any, 10, 10, 160, 20, "Vertical") : SetGadgetState(g_is_vertical, 1)
      g_value = StringGadget(#PB_Any, 10, 32, 120, 20, "100", #PB_String_Numeric) : g_set = ButtonGadget(#PB_Any, 140, 32, 30, 20, "set")
      g_value_ = TrackBarGadget(#PB_Any, 5, 55, 170, 20, -150, 500);, #PB_TrackBar_Ticks)
      SetGadgetState(g_value_, 100)
      
      g_min = OptionGadget(#PB_Any, 10, 70+10, 160, 20, "")
      g_max = OptionGadget(#PB_Any, 10, 90+10, 160, 20, "") : SetGadgetState(g_max, 1)
      g_draw_pos = OptionGadget(#PB_Any, 10, 110+10, 160, 20, "")
      g_draw_len = OptionGadget(#PB_Any, 10, 130+10, 160, 20, "")
      g_page_pos = OptionGadget(#PB_Any, 10, 150+10, 160, 20, "")
      g_page_len = OptionGadget(#PB_Any, 10, 170+10, 160, 20, "")
      g_area_pos = OptionGadget(#PB_Any, 10, 190+10, 160, 20, "")
      g_area_len = OptionGadget(#PB_Any, 10, 210+10, 160, 20, "")
      
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+70+10, 160, 20, "Min"), #PB_Gadget_FrontColor, $FF0000)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+90+10, 160, 20, "Max"), #PB_Gadget_FrontColor, $FF0000)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+110+10, 160, 20, "Draw pos"), #PB_Gadget_FrontColor, $FFFF00)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+130+10, 160, 20, "Draw len"), #PB_Gadget_FrontColor, $FFFF00)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+150+10, 160, 20, "Page pos"), #PB_Gadget_FrontColor, $00FF00)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+170+10, 160, 20, "Page len"), #PB_Gadget_FrontColor, $00FF00)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+190+10, 160, 20, "Area pos"), #PB_Gadget_FrontColor, $00FFFF)
      SetGadgetColor(TextGadget(#PB_Any, 18+10, 2+210+10, 160, 20, "Area len"), #PB_Gadget_FrontColor, $00FFFF)
      CloseGadgetList()
      
      g_Canvas = CanvasGadget(#PB_Any, 200,10, 600, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    
      v = ScrollBarGadget(-1, x-18, y,  16, 300 ,0,ImageHeight(0), 240-16, #PB_ScrollBar_Vertical)
      h = ScrollBarGadget(-1, x, y-18, 300,  16 ,0,ImageWidth(0), 405-16)
      ;     SetGadgetAttribute(v, #PB_ScrollBar_Maximum, ImageHeight(0))
      ;     SetGadgetAttribute(h, #PB_ScrollBar_Maximum, ImageWidth(0))
      
;       ; Set scroll page position
;       SetGadgetState(v, 70)
;       SetGadgetState(h, 55)
      CloseGadgetList()
      
      ; Create both scroll bars
      *Scroll\v = Gadget(0, 0,  16, 0 ,0, 0, 0, #PB_ScrollBar_Vertical,7)
      *Scroll\h = Gadget(0, 0,  0, 16 ,0, 0, 0, 0, 7)
      
      ;     SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
      ;     SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))
      
;       ; Set scroll page position
;       SetState(*Scroll\v, 70)
;       SetState(*Scroll\h, 55)
      
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
                
              Case g_draw_pos
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*Scroll\v\y))
                  Case 0
                    SetGadgetText(g_value, Str(*Scroll\h\x))
                EndSelect
                
              Case g_draw_len
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
                
              Case g_set, g_value_, g_value
                
                If g_value_ = EventGadget()
                  SetGadgetText(g_value, Str(GetGadgetState(g_value_)))
                EndIf
                If g_value = EventGadget()
                  SetGadgetState(g_value_, Val(GetGadgetText(g_value)))
                EndIf
                value = Val(GetGadgetText(g_value))
                
                Select #True
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
                    
                  Case GetGadgetState(g_draw_pos) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        Resize(*Scroll\v, #PB_Ignore, value, #PB_Ignore, #PB_Ignore)
                      Case 0
                        Resize(*Scroll\h, value, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                    EndSelect
                    
                  Case GetGadgetState(g_draw_len) 
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
                
                ReDraw(g_Canvas)
            EndSelect
            
        EndSelect
      Until Event = #PB_Event_CloseWindow
    EndIf
  CompilerEndIf
  
  
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = 0-t-----f+DAA5
; EnableXP