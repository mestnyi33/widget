IncludePath "../../"
XIncludeFile "widgets.pbi"

;-
;- EXAMPLE
;-
CompilerIf #PB_Compiler_IsMainFile
  UseModule widget
  
  Global Window_demo, v, h
  
  Global g_container, g_min, g_max, g_page_pos, g_area_pos, g_len, g_value, g_is_vertical, g_set, g_page_len, g_area_len, g_Canvas
  
  
  Global *Scroll._S_scroll=AllocateStructure(_S_scroll)
  Global x=101,y=101, Width=790, Height=600 
  
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
  
  Procedure _ReDraw(Canvas)
    With *Scroll
      pb_scroll_update()
      
      If StartDrawing(CanvasOutput(Canvas))
        ; back ground
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,0,Width,Height, $FFFFFF)
        
        ;       ;       
        ;       If IsStop(\v)
        ;         \h\Color\Line = 0
        ;       Else
        ;         \h\Color\Line = $FFFFFF
        ;       EndIf
        ;       
        ;       If IsStop(\h)
        ;         \v\Color\Line = 0
        ;       Else
        ;         \v\Color\Line = $FFFFFF
        ;       EndIf
        
        ClipOutput(\h\x, \v\y, \h\Page\len, \v\Page\len)
        ;DrawImage(ImageID(0), \h\x-\h\Page\Pos, \v\y-\v\Page\Pos)
        DrawImage(ImageID(0), \h\x-GetState(\h), \v\y-GetState(\v))
        UnclipOutput()
        
        Draw(\v)
        Draw(\h)
        
        ; frame 
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\h\x-1,\v\y-1,
            2 + Bool(\v\hide) * \h\Page\len + Bool(Not \v\hide) * ((\v\X+\v\width)-\h\x),
            2 + Bool(\h\hide) * \v\Page\len + Bool(Not \h\hide) * ((\h\Y+\h\height)-\v\y), $0000FF)
        ;       ; 
        ;       Box(x, y, Width-x*2, Height-y*2, $0000FF)
        
        ; Scroll area coordinate ; (\v\x-\h\x)
        ;Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
        ;Debug Str(((\h\Max-\h\Page\len)-\h\Page\Pos))
        
        Box(\h\x-GetState(\h), \v\y-GetState(\v), \h\Max, \v\Max, $FF0000)
        
        ; page coordinate
        Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
        
        ; area coordinate
        Box(\h\x, \v\y, \h\Area\Len, \v\Area\Len, $00FFFF)
        
        ; scroll coordinate
        Box(\h\x, \v\y, \h\width, \v\height, $FF00FF)
        
        ; frame coordinate
        Box(\h\x, \v\y, 
            \h\Page\len + (Bool(Not \v\hide) * \v\width),
            \v\Page\len + (Bool(Not \h\hide) * \h\height), $FFFF00)
        
        StopDrawing()
        
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, iWidth, iHeight
    Width = GadgetWidth(Canvas)
    Height = GadgetHeight(Canvas)
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Repaint | Resizes(*Scroll, x, y, Width-x*2, Height-y*2)                                        ;, *Scroll\h)
                                                                                                       ;  Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *Scroll\h)
        ResizeGadget(v,  *Scroll\v\x+20, *Scroll\v\y, *Scroll\v\Width, *Scroll\v\Height)
        ResizeGadget(h,  *Scroll\h\x, *Scroll\h\y+20, *Scroll\h\Width, *Scroll\h\Height)
    EndSelect
    
    Repaint | CallBack(From(Root(), mouseX,mouseY), EventType, mouseX,mouseY)
    ;Repaint | CallBack(*Scroll\v, EventType, mouseX,mouseY)
    ;Repaint | CallBack(*Scroll\h, EventType, mouseX,mouseY)
    
    If Not (*Scroll\v\at Or *Scroll\h\at)
      Select EventType
        Case #PB_EventType_LeftButtonDown
         ; SetAttribute(*Scroll\h, #PB_Bar_Inverted, *Scroll\h\Inverted!1)
         ; Debug "#PB_EventType_LeftButtonDown *Scroll\h\Inverted " + *Scroll\h\Inverted
          
          Repaint = 1
      EndSelect
    EndIf
    
    If Repaint
      _ReDraw(g_Canvas)
    EndIf
  EndProcedure
  
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
  
  Procedure.i Bars(*Scroll._S_scroll, Size.i, Radius.i, Both.b)
    With *Scroll     
      \v = Scroll(#PB_Ignore,#PB_Ignore,Size,#PB_Ignore, 0,0,0, #PB_Vertical, Radius)
      \v\hide = \v\hide[1]
      ;\v\s = *Scroll
      
      If Both
        \h = Scroll(#PB_Ignore,#PB_Ignore,#PB_Ignore,Size, 0,0,0, 0, Radius)
        \h\hide = \h\hide[1]
      Else
        \h._S_widget = AllocateStructure(_S_bar)
        \h\hide = 1
      EndIf
      ;\h\s = *Scroll
    EndWith
    
    ProcedureReturn *Scroll
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, Width+20, Height+20, "Scroll on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    g_container = ContainerGadget(#PB_Any, 10, 10, 180, 220, #PB_Container_Flat)
    
    g_is_vertical = CheckBoxGadget(#PB_Any, 10, 10, 160, 20, "Vertical") : SetGadgetState(g_is_vertical, 1)
    g_value = StringGadget(#PB_Any, 10, 40, 120, 20, "100", #PB_String_Numeric)
    g_set = ButtonGadget(#PB_Any, 140, 40, 30, 20, "set")
    
    g_min = OptionGadget(#PB_Any, 10, 70, 160, 20, "Min")
    g_max = OptionGadget(#PB_Any, 10, 90, 160, 20, "Max") : SetGadgetState(g_max, 1)
    g_len = OptionGadget(#PB_Any, 10, 110, 160, 20, "len")
    g_page_len = OptionGadget(#PB_Any, 10, 130, 160, 20, "Page len")
    g_area_len = OptionGadget(#PB_Any, 10, 150, 160, 20, "Area len")
    g_page_pos = OptionGadget(#PB_Any, 10, 170, 160, 20, "Page pos")
    g_area_pos = OptionGadget(#PB_Any, 10, 190, 160, 20, "Area pos")
    
    CloseGadgetList()
    
    ;Canvas = CanvasGadget(#PB_Any, 200, 10, 380, 380, #PB_Canvas_Keyboard)
    g_Canvas = CanvasGadget(#PB_Any, 200,10, 600, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container)
    SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    v = ScrollBarGadget(-1, x-18, y,  16, 300 ,0,ImageHeight(0), 240-16, #PB_ScrollBar_Vertical)
      h = ScrollBarGadget(-1, x, y-18, 300,  16 ,0,ImageWidth(0), 405-16)
      ;     SetGadgetAttribute(v, #PB_ScrollBar_Maximum, ImageHeight(0))
      ;     SetGadgetAttribute(h, #PB_ScrollBar_Maximum, ImageWidth(0))
      
      ; Set scroll page position
      SetGadgetState(v, 70)
      SetGadgetState(h, 55)
      CloseGadgetList()
    OpenList(0, g_Canvas)
    
    ; Create both scroll bars
    *Scroll\v = Scroll(#PB_Ignore, #PB_Ignore,  16, #PB_Ignore ,0, ImageHeight(0), 240-16, #PB_ScrollBar_Vertical,7)
    *Scroll\h = Scroll(#PB_Ignore, #PB_Ignore,  #PB_Ignore, 16 ,0, ImageWidth(0), 405-16, 0, 7)
;       *Scroll\v = Scroll(0, 0,  16, 0 ,0, 0, 0, #PB_ScrollBar_Vertical,7)
;       *Scroll\h = Scroll(0, 0,  0, 16 ,0, 0, 0, 0, 7)
 ; Bars(*Scroll, 16, 7, 1)
      
;     SetAttribute(*Scroll\v, #PB_ScrollBar_Maximum, ImageHeight(0))
;     SetAttribute(*Scroll\h, #PB_ScrollBar_Maximum, ImageWidth(0))
    
    ; Set scroll page position
    SetState(*Scroll\v, 70)
    SetState(*Scroll\h, 55)
    
    PostEvent(#PB_Event_Gadget, 0,g_Canvas,#PB_EventType_Resize)
    BindGadgetEvent(g_Canvas, @Canvas_CallBack())
    
    
    ;_ReDraw(g_Canvas)
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack())
    
    Define Event, value
    Repeat 
      Event = WaitWindowEvent()
      Select Event
        Case #PB_Event_Gadget
          
          Select EventGadget()
            Case g_set
              value = Val(GetGadgetText(g_value))
              
              Select 1
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
                  
                Case GetGadgetState(g_len) 
                  Select GetGadgetState(g_is_vertical)
                    Case 1
                      Resize(*Scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, value)
                    Case 0
                      Resize(*Scroll\h, #PB_Ignore, #PB_Ignore, value, #PB_Ignore)
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
                  
                  
              EndSelect
              
              Debug "vmi "+ GetAttribute(*Scroll\v, #PB_ScrollBar_Minimum) +" vma "+ GetAttribute(*Scroll\v, #PB_ScrollBar_Maximum) +" vpl "+ GetAttribute(*Scroll\v, #PB_ScrollBar_PageLength)
              
              _ReDraw(g_Canvas)
          EndSelect
          
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = xfD24-
; EnableXP