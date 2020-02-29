
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


;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  UseModule Constants
  UseModule Structures
;   Macro OpenWindow(Window, X, Y, Width, Height, Title, Flag=0, ParentID=0)
;     bar::Open_CanvasWindow(Window, X, Y, Width, Height, Title, Flag, ParentID)
;   EndMacro
  
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
  
  Global g_container, g_value, g_value_, g_is_vertical, g_min, g_max, g_draw_pos, g_draw_len, g_set, g_page_pos, g_page_len, g_area_pos, g_area_len, g_Canvas
  
  Global *Scroll._S_Scroll=AllocateStructure(_s_scroll)
  Global x=110,y=110, Width=420, Height=420 , focus
  
  Global isCurrentItem=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, drag.i, hole.i
  Global NewList Images.canvasitem()
  
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
  
  Bar::Updates(*scroll, x, y, width, height)
  
  SetWindowTitle(EventWindow(), Str(Images()\x)+" "+Str(Images()\width)+" "+Str(Images()\x+Images()\width))
EndMacro


  Procedure AddImage (List Images.canvasitem(), x, y, img, alphatest=0)
    If AddElement(Images())
      Images()\x      = x
      Images()\y      = y
      Images()\img    = img
      Images()\width  = ImageWidth(img)
      Images()\height = ImageHeight(img)
      Images()\alphatest = alphatest
    EndIf
  EndProcedure
  
  Procedure pb_scroll_update()
    With *Scroll
      SetGadgetState(v, GetState(\v))
      SetGadgetAttribute(v, #PB_ScrollBar_Minimum, GetAttribute(\v, #__Bar_Minimum))
      SetGadgetAttribute(v, #PB_ScrollBar_Maximum, GetAttribute(\v, #__Bar_Maximum))
      SetGadgetAttribute(v, #PB_ScrollBar_PageLength, GetAttribute(\v, #__Bar_PageLength))
      ResizeGadget(v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\height)
      
      SetGadgetState(h, GetState(\h))
      SetGadgetAttribute(h, #PB_ScrollBar_Minimum, GetAttribute(\h, #__Bar_Minimum))
      SetGadgetAttribute(h, #PB_ScrollBar_Maximum, GetAttribute(\h, #__Bar_Maximum))
      SetGadgetAttribute(h, #PB_ScrollBar_PageLength, GetAttribute(\h, #__Bar_PageLength))
      ResizeGadget(h, #PB_Ignore, #PB_Ignore, \h\width, #PB_Ignore)
    EndWith
  EndProcedure
 
  Procedure Canvas_ReDraw (canvas.i, List Images.canvasitem())
    With *Scroll
      pb_scroll_update()
      
     ; ReDraw(Root())
      
      If StartDrawing(CanvasOutput(canvas))
        
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(0, 0, OutputWidth(), OutputHeight(), RGB(255,255,255))
        
        ; ClipOutput(\h\x, \v\y, \h\bar\Page\len, \v\bar\page\len)
        DrawingMode(#PB_2DDrawing_AlphaBlend)
        ;       If focus And ChangeCurrentElement(Images(), focus)
        ;         DrawImage(ImageID(Images()\img),x+(Images()\x - \h\bar\Page\Pos), y+(Images()\y)) ; draw all images with z-order
        ;       Else
        ForEach Images()
          DrawImage(ImageID(Images()\img),Images()\x, Images()\y) ; draw all images with z-order
          ;  DrawImage(ImageID(Images()\img),x+(Images()\x - Bool(Not focus) * \h\bar\Page\Pos), y+(Images()\y - Bool(Not focus) * \v\bar\page\Pos)) ; draw all images with z-order
        Next
        ;       EndIf
        ;UnclipOutput()
        
        Draw(*Scroll\v)
        Draw(*Scroll\h)
        
        UnclipOutput()
        DrawingMode(#PB_2DDrawing_Outlined)
;     Box(x, y, Width, Height, RGB(0,255,255))
;     Box(*scroll\x, *scroll\y, *scroll\width, *scroll\height, RGB(255,0,255))
;     Box(*scroll\x, *scroll\y, *scroll\h\bar\max, *scroll\v\bar\max, RGB(255,0,0))
;     Box(*scroll\h\x, *scroll\v\y, *scroll\h\bar\page\len, *scroll\v\bar\page\len, RGB(255,255,0))
;     DrawingMode(#PB_2DDrawing_Outlined)
        
        ; widget area coordinate
        Box(x-1, y-1, Width+2, Height+2, $0000FF)
        
        ; Scrollarea coordinate
        Box(*Scroll\x, *Scroll\y, *Scroll\width, *Scroll\height, $FF0000)
        ; Box(*Scroll\h\x-*Scroll\h\bar\Page\Pos, *Scroll\v\y-*Scroll\v\bar\page\Pos, *Scroll\h\bar\Max, *Scroll\v\bar\max, $FF0000)
        
        ; page coordinate
        Box(*Scroll\h\x, *Scroll\v\y, *Scroll\h\bar\Page\Len, *Scroll\v\bar\page\Len, $00FF00)
        
        ; area coordinate
        Box(*Scroll\h\x, *Scroll\v\y, *Scroll\h\bar\Area\Len, *Scroll\v\bar\area\Len, $00FFFF)
        
        ; scrollbar coordinate
        Box(*Scroll\h\x, *Scroll\v\y, *Scroll\h\width, *Scroll\v\height, $FF00FF)
        
        ; frame coordinate
        Box(*Scroll\h\x, *Scroll\v\y, 
            *Scroll\h\bar\Page\len + (Bool(Not *Scroll\v\hide) * *Scroll\v\width),
            *Scroll\v\bar\page\len + (Bool(Not *Scroll\h\hide) * *Scroll\h\height), $FFFF00)
        
        StopDrawing()
      EndIf
    EndWith
  EndProcedure
  
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

  AddImage(Images(),  x+10,  y+10, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp"))
  AddImage(Images(), x+100, y+60, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp"))
  AddImage(Images(),  x+50, y+160, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp"))
  
  ;   hole = CreateImage(#PB_Any,100,100,32)
  ;   If StartDrawing(ImageOutput(hole))
  ;     DrawingMode(#PB_2DDrawing_AllChannels)
  ;     Box(0,0,100,100,RGBA($00,$00,$00,$00))
  ;     Circle(50,50,48,RGBA($00,$FF,$FF,$FF))
  ;     Circle(50,50,30,RGBA($00,$00,$00,$00))
  ;     StopDrawing()
  ;   EndIf
  ;   AddImage(Images(),170,70,hole,1)
  
  
  Procedure Canvas_Events(Canvas.i, Event.i)
    Protected Repaint
    ;Protected Event = EventType()
    ;Protected Canvas = EventGadget()
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Width = GadgetWidth(Canvas) - x*2
    Height = GadgetHeight(Canvas) - y*2
    
    Repaint | Events(*Scroll\v, Event, MouseX, MouseY) 
    Repaint | Events(*Scroll\h, Event, MouseX, MouseY) 
  ;  Repaint | CallBack(From(Root(), MouseX, MouseY), Event, MouseX, MouseY) 
    
    
    ;If *Scroll\v\Change Or *Scroll\h\Change 
     If *scroll\v\bar\change
      PushListPosition(Images())
      ForEach Images()
        Images()\Y + *scroll\v\bar\page\change 
      Next
      PopListPosition(Images())
      
      *scroll\y =- *scroll\v\bar\page\pos+*scroll\v\y
      *scroll\v\bar\change = 0
    EndIf
    
    If *scroll\h\bar\change
      PushListPosition(Images())
      ForEach Images()
        Images()\X + *scroll\h\bar\page\change
      Next
      PopListPosition(Images())
      
      *scroll\x =- *scroll\h\bar\page\pos+*scroll\h\x
      *scroll\h\bar\change = 0
    EndIf
    ;EndIf
    
    If Bool(*Scroll\h\from=-1 And *Scroll\v\from=-1)
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
                
                GetScrollCoordinate(x, y, width, height)
                Repaint = #True
              EndIf
            EndIf
          EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          GetScrollCoordinate(x, y, width, height)
          Repaint = #True
          
      EndSelect
    EndIf 
    
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
        *Scroll\width = OutputWidth()
        *Scroll\height = OutputHeight()
        StopDrawing()
      EndIf
    EndIf
    
    Procedure Canvas_CallBack()
      ; Canvas events bug fix
      Protected Result.b
      Static MouseLeave.b
      Protected EventGadget.i = EventGadget()
      Protected EventType.i = EventType()
      Protected Width = GadgetWidth(EventGadget)
      Protected Height = GadgetHeight(EventGadget)
      Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
      Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
      
      ; Это из за ошибки в мак ос и линукс
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
        Select EventType 
          Case #PB_EventType_MouseEnter 
            If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
              EventType = #PB_EventType_MouseMove
              MouseLeave = 0
            EndIf
            
          Case #PB_EventType_MouseLeave 
            If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
              EventType = #PB_EventType_MouseMove
              MouseLeave = 1
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            If GetActiveGadget()<>EventGadget
              SetActiveGadget(EventGadget)
            EndIf
            
          Case #PB_EventType_LeftButtonUp
            If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
              MouseLeave = 0
              CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
                EventType = #PB_EventType_MouseLeave
              CompilerEndIf
            Else
              MouseLeave =- 1
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_LeftClick
            EndIf
            
          Case #PB_EventType_LeftClick : ProcedureReturn 0
        EndSelect
      CompilerEndIf
      
      Result | Canvas_Events(EventGadget, EventType)
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure Widget_Events()
      Select EventType()
        Case #PB_EventType_ScrollChange
          Debug EventData()
      EndSelect
    EndProcedure
    
    Procedure ResizeCallBack()
      ResizeGadget(g_Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-210, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
    EndProcedure
    
    
    ; open window
    If OpenWindow(0, 0, 0, Width+x*2+190+20, Height+y*2+20, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
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
      
;       ;Canvas = CanvasGadget(#PB_Any, 200, 10, 380, 380, #PB_Canvas_Keyboard)
      g_Canvas = Open_Canvas(0, 200,10, Width+x*2, Height+y*2, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      
  ;    OpenList(0, g_Canvas)
;        Open(0, 200,10, 600, Height, "test") 
;       g_Canvas = _Gadget()
      
      ;g_Canvas = GetWindowData(0)
     ; OpenGadgetList(g_Canvas)
      v = ScrollBarGadget(-1, x-18, y,  16, 300 ,0,ImageHeight(0), 240-16, #PB_ScrollBar_Vertical)
      h = ScrollBarGadget(-1, x, y-18, 300,  16 ,0,ImageWidth(0), 405-16)
      ;     SetGadgetAttribute(v, #__Bar_Maximum, ImageHeight(0))
      ;     SetGadgetAttribute(h, #__Bar_Maximum, ImageWidth(0))
      
      ; Set scroll page position
      SetGadgetState(v, 70)
      SetGadgetState(h, 55)
     ; CloseGadgetList()
      
      ; Create both scroll bars
;       *Scroll\v = Scroll(#PB_Ignore, #PB_Ignore,  16, #PB_Ignore ,0, ImageHeight(0), 240-16, #__Bar_Vertical,7)
;       *Scroll\h = Scroll(#PB_Ignore, #PB_Ignore,  #PB_Ignore, 16 ,0, ImageWidth(0), 405-16, 0, 7)
      *scroll\v = Bar::scroll(0, y, 20, 0, 0, 0, Width-20, #__bar_Vertical, 11)
      *scroll\h = Bar::scroll(x, 0, 0,  20, 0, 0, Height-20, 0, 11)

      ;     SetAttribute(*Scroll\v, #__Bar_Maximum, ImageHeight(0))
      ;     SetAttribute(*Scroll\h, #__Bar_Maximum, ImageWidth(0))
      
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
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\v, #__Bar_Minimum)))
                  Case 0
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\h, #__Bar_Minimum)))
                EndSelect
                
              Case g_max 
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\v, #__Bar_Maximum)))
                  Case 0
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\h, #__Bar_Maximum)))
                EndSelect
                
              Case g_page_len
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\v, #__Bar_PageLength)))
                  Case 0
                    SetGadgetText(g_value, Str(GetAttribute(*Scroll\h, #__Bar_PageLength)))
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
                    SetGadgetText(g_value, Str(*Scroll\v\bar\area\len))
                  Case 0
                    SetGadgetText(g_value, Str(*Scroll\h\bar\Area\len))
                EndSelect
                
              Case g_area_pos 
                Select GetGadgetState(g_is_vertical)
                  Case 1
                    SetGadgetText(g_value, Str(*Scroll\v\bar\area\Pos))
                  Case 0
                    SetGadgetText(g_value, Str(*Scroll\h\bar\Area\Pos))
                EndSelect
                
              Case g_set, g_value_, g_value
                
                If g_value_ = EventGadget()
                  SetGadgetText(g_value, Str(GetGadgetState(g_value_)))
                EndIf
                If g_value = EventGadget()
                  SetGadgetState(g_value_, Val(GetGadgetText(g_value)))
                EndIf
                value = Val(GetGadgetText(g_value))
                
                Select 1
                  Case GetGadgetState(g_min) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        SetAttribute(*Scroll\v, #__Bar_Minimum, value)
                      Case 0
                        SetAttribute(*Scroll\h, #__Bar_Minimum, value)
                    EndSelect
                    
                  Case GetGadgetState(g_max) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        SetAttribute(*Scroll\v, #__Bar_Maximum, value)
                      Case 0
                        SetAttribute(*Scroll\h, #__Bar_Maximum, value)
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
                        SetAttribute(*Scroll\v, #__Bar_PageLength, value)
                      Case 0
                        SetAttribute(*Scroll\h, #__Bar_PageLength, value)
                    EndSelect
                    
                  Case GetGadgetState(g_area_len) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        *Scroll\v\bar\area\len = value
                      Case 0
                        *Scroll\h\bar\Area\len = value
                    EndSelect
                    
                  Case GetGadgetState(g_area_len) 
                    Select GetGadgetState(g_is_vertical)
                      Case 1
                        *Scroll\v\bar\area\Pos = value
                      Case 0
                        *Scroll\h\bar\Area\Pos = value
                    EndSelect
                    
                    
                EndSelect
                
                Debug "vmi "+ GetAttribute(*Scroll\v, #__Bar_Minimum) +" vma "+ GetAttribute(*Scroll\v, #__Bar_Maximum) +" vpl "+ GetAttribute(*Scroll\v, #__Bar_PageLength)
                
                Canvas_ReDraw(g_Canvas, Images())
            EndSelect
            
        EndSelect
      Until Event = #PB_Event_CloseWindow
    EndIf
  CompilerEndIf
  
  
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = f--vv+8----
; EnableXP