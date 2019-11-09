IncludePath "../"
XIncludeFile "widgets().pbi"

;- 
;- example
;-
CompilerIf #PB_Compiler_IsMainFile
    UseModule Widget
  Global *Text._s_widget = AllocateStructure(_s_widget)
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  
  Global g_Canvas, NewList *List._S_widget()
  
  Procedure _ReDraw(Canvas)
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
        ForEach *List()
          Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
        Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      Repaint | CallBack(*List(), EventType, MouseX, MouseY)
    Next
    
    If Repaint 
      _ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-125, #PB_Ignore)
    ResizeGadget(g_Canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-125, #PB_Ignore)
    SetWindowTitle(0, Str(WindowWidth(EventWindow(), #PB_Window_FrameCoordinate)-20)+" - Text on the canvas")
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 18)
  CompilerElse
    LoadFont(0, "Arial", 16)
  CompilerEndIf 
  
  Text.s = "строка_1"+Chr(10)+
  "строка__2"+Chr(10)+
  "строка___3 эта длиняя строка оказалась ну, очень длиной, поэтому будем его переносить"+Chr(10)+
  "строка_4"+#CRLF$+
  "строка__5";+#CRLF$
             ; Text.s = "Vertical & Horizontal" + #LF$ + "   Centered   Text in   " + #LF$ + "Multiline StringGadget"
             ; Debug "len - "+Len(Text)
  
  If OpenWindow(0, 0, 0, 280, 760, "CanvasGadget", #PB_Window_SizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    WindowBounds(0, 128,-1,-1,-1)
    
    g_Canvas = CanvasGadget(#PB_Any, 10, 10, 200, 140*4+30, #PB_Canvas_Keyboard|#PB_Canvas_Container)
    SetGadgetAttribute(g_Canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    
    Root() = AllocateStructure(_S_root)
    Root()\root = Root()
    Root()\parent = Root()
    Root()\opened = Root()
    Root()\window = 0
    Root()\canvas = g_Canvas
    ;Form(0,0, 140, 70,"")
    
    AddElement(*List()) : *List() = Text(0, 0, 200, 140, Text, #__flag_Horizontal)
    AddElement(*List()) : *List() = Text(0, 150, 200, 140, Text, #__flag_Vertical)
    AddElement(*List()) : *List() = Text(0, 300, 200, 140, Text, #__flag_Vertical|#__Flag_Right)
    AddElement(*List()) : *List() = Text(0, 450, 200, 140, Text, #__flag_Horizontal|#__Flag_Bottom)
    
    ;Debug "font name: "+Procedures::Font_GetNameFromGadgetID(GadgetID(16))
    
    CloseGadgetList()
    TextGadget(0, 10, 610, 200, 140, Text, #PB_Text_Border|#PB_Text_Center)
    ;   EditorGadget(4, 10, 220, 200, 200) : AddGadgetItem(10, -1, Text)
    ;SetGadgetFont(0,FontID)
    
    ResizeCallBack()
    ; ResizeWindow(0,WindowX(0)-180,#PB_Ignore,#PB_Ignore,#PB_Ignore)
    BindEvent(#PB_Event_SizeWindow,@ResizeCallBack(),0)
    
    ReDraw(Root())
  EndIf
  
;   If OpenWindow(0, 0, 0, 104, 690, "Text on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
;     ClearList(List())
;     
;     ;EditorGadget(0, 10, 10, 380, 330, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s)
;     TextGadget(0, 10, 10, 380, 330, Text.s) 
;     ;ButtonGadget(0, 10, 10, 380, 330, Text.s) 
;     
;     g=16
;     CanvasGadget(g, 10, 350, 380, 330) 
;     
;     *Text = Create(g, -1, 0, 0, 380, 330, Text.s);, #PB_Text_Center|#PB_Text_Middle);
;     SetColor(*Text, #PB_Gadget_BackColor, $FFCCBFB4)
;     SetColor(*Text, #PB_Gadget_FrontColor, $FFD56F1A)
;     SetFont(*Text, FontID(0))
;     
;     ; Get example
;     SetGadgetFont(0, GetFont(*Text))
;     SetGadgetColor(0, #PB_Gadget_BackColor, GetColor(*Text, #PB_Gadget_BackColor))
;     SetGadgetColor(0, #PB_Gadget_FrontColor, GetColor(*Text, #PB_Gadget_FrontColor))
;     
;     PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore)
;     BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
;     
;     BindGadgetEvent(g, @Canvas_CallBack())
;     PostEvent(#PB_Event_Gadget, 0,g, #PB_EventType_Resize) ; 
;     
;      ReDraw(Root())
;   EndIf
;   
  Repeat
    Define Event = WaitWindowEvent()
  Until Event= #PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = Aw
; EnableXP