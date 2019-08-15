XIncludeFile "_module_bar.pb"

CompilerIf #PB_Compiler_IsMainFile
UseModule Bar
  Global g_Canvas, NewList *List._S_bar()
  
  
  Procedure ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F0)
      
      ForEach *List()
        If Not *List()\hide
          Draw(*List())
        EndIf
      Next
      
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
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    ;     Protected *this._S_bar = GetGadgetData(Canvas)
    
    Select EventType
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      Repaint | CallBack(*List(), EventType, MouseX, MouseY)
    Next
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Global Button_1, Button_2, Button_3, Button_4, Splitter_1, Splitter_2, Splitter_3

If OpenWindow(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Separator)
    Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_1, #PB_Splitter_Separator)
    Splitter_3 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Button_1, Splitter_2, #PB_Splitter_Vertical)

    TextGadget(#PB_Any, 110, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )

    g_Canvas = CanvasGadget(-1, 420, 0, 430, 280);, #PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    
    Button_1 = Bar::Progress(0, 0, 0, 0, 30,100) ; No need to specify size or coordinates
    Button_2 = Bar::Progress(0, 0, 0, 0, 30,100) ; as they will be sized automatically
    Button_3 = Bar::Progress(0, 0, 0, 0, 30,100) ; as they will be sized automatically
    Button_4 = Bar::Progress(0, 0, 0, 0, 30,100) ; as they will be sized automatically
    
    Splitter_1 = Bar::Splitter(0, 0, 410, 210, Button_3, Button_4, #PB_Splitter_Separator)
    Splitter_2 = Bar::Splitter(0, 0, 410, 210, Button_2, Splitter_1, #PB_Splitter_Separator)
    Splitter_3 = Bar::Splitter(10, 10, 410, 210, Button_1, Splitter_2, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    AddElement(*List()) : *List() = Button_1
    AddElement(*List()) : *List() = Button_2
    AddElement(*List()) : *List() = Button_3
    AddElement(*List()) : *List() = Button_4
    
    AddElement(*List()) : *List() = Splitter_1
    AddElement(*List()) : *List() = Splitter_2
    AddElement(*List()) : *List() = Splitter_3
    
    TextGadget(#PB_Any, 530, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf

CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP