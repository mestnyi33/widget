IncludePath "/Users/as/Documents/GitHub/Widget/exemples/"
XIncludeFile "scroll_new000_____.pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule scroll
  
  Global.i gEvent, gQuit
  Global *Bar_0._S_widget = AllocateStructure(_S_widget)
  
  Procedure.i ReDraw(canvas)
    If StartDrawing(CanvasOutput(canvas))
      ;DrawingMode(#PB_2DDrawing_Default)
      ;box(0,0,OutputWidth(),OutputHeight(), *this\color\back)
      FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
      
      Draw(*Bar_0)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure BindGScrollDatas()
    SetWindowTitle(0, "ScrollBarGadget (" + GetGadgetState(5) + ")" )
  EndProcedure
  
  Procedure BindWScrollDatas()
    SetWindowTitle(0, "ScrollBarWidget (" + GetState(*Bar_0) + ")" )
  EndProcedure


  Procedure Canvas_Events()
    Protected Canvas.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint, iWidth, iHeight
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected mouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected mouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    
    Select EventType
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        Repaint = 1
    EndSelect
    
    Repaint | CallBack(*Bar_0, EventType, mouseX,mouseY)
    
    If Repaint
      SetGadgetState(5, *Bar_0\page\pos)
      
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 100+30, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65+30, 390,  30, "set  inverted scrollbar", #PB_Button_Toggle)
      SetGadgetState(0, 1)
     
      ScrollBarGadget(5, 15, 0, 370, 30, 20, 50, 8)
      BindGadgetEvent(5, @ BindGScrollDatas())
      
      CanvasGadget(10, 10,40, 380, 50)
      
      *Bar_0 = Gadget(5, 10, 370, 30, 20, 50, 8, #PB_Bar_Inverted) 
      
      ReDraw(10)
      BindGadgetEvent(10, @Canvas_Events())
    EndIf
  EndProcedure
  
  Window_0()
        
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 0
            SetAttribute(*Bar_0, #PB_Bar_Inverted, Bool( GetGadgetState(0)))
            SetWindowTitle(0, Str(GetState(*Bar_0)))
            
            If GetGadgetState(0)
              SetGadgetText(0, "set inverted scrollbar")
            Else
              SetGadgetText(0, "set standart scrollbar")
            EndIf
            
            ReDraw(10)
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP