IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "bar(widgets).pb"
;XIncludeFile "bar().pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule bar
  
  Global.i gEvent, gQuit, g_Canvas
  Global *Bar_0._S_widget = AllocateStructure(_S_widget)
  
  Procedure ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
      
      Draw(*Bar_0)
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i Canvas_Events()
    Protected Canvas.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta ; = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    ;     Protected *this._s_widget = GetGadgetData(Canvas)
    
    Select EventType
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    Repaint | CallBack(*Bar_0, EventType, MouseX, MouseY)
    
    ;*Bar_0\scrollstep = 1
    If *Bar_0\change
      Debug "Change scroll direction "+ GetAttribute(*Bar_0, #__Bar_Direction)
      SetWindowTitle(0, Str(GetState(*Bar_0)))
      *Bar_0\change = 0
    EndIf
    ;             
    ;             Select EventWidget()
    ;                 
    ;               Case *Bar_0
    
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 400, 100, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ButtonGadget   (0,    5,   65, 390,  30, "set  inverted scrollbar", #PB_Button_Toggle)
      SetGadgetState(0, 1)
      
      g_Canvas = CanvasGadget(-1, 10, 10, 380, 50, #PB_Canvas_Container)
      BindGadgetEvent(g_Canvas, @Canvas_Events())
      PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
      
      *Bar_0 = Scroll(5, 10, 370, 30, 20, 50, 8, #__Bar_Inverted) ; Button ( 5, 65, 390, 30, "set  standart scrollbar"); 
      
      SetWindowTitle(0, Str(GetState(*Bar_0)))
      ReDraw(g_Canvas)
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
            SetAttribute(*Bar_0, #__Bar_Inverted, Bool(GetGadgetState(0)))
            SetWindowTitle(0, Str(GetState(*Bar_0)))
            
            If GetGadgetState(0)
              SetGadgetText(0, "set inverted scrollbar")
            Else
              SetGadgetText(0, "set standart scrollbar")
            EndIf
            
            ReDraw(g_Canvas)
        EndSelect
        
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---
; EnableXP