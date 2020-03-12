; IncludePath "/Users/as/Documents/GitHub/Widget/"
;XIncludeFile "../bar().pbi"
;XIncludeFile "../bar().pb"
XIncludeFile "../../elements.pbi"
;XIncludeFile "../../splitter().pbi"

; Module name   : Splitter
; Author        : mestnyi
; Last updated  : Sep 20, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70662
; 

CompilerIf Not Defined(Splitter, #PB_Module)
  DeclareModule Splitter
    EnableExplicit
    UseModule constants
    UseModule structures
    
    
    ;- DECLARE
    Declare GetState(Gadget.i)
    Declare SetState(Gadget.i, State.i)
    Declare GetAttribute(Gadget.i, Attribute.i)
    Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
    Declare Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, First.i, Second.i, Flag.i=0)
    
  EndDeclareModule
  
  Module Splitter
    
    ;- PROCEDURE
    
    Procedure ReDraw(*This._s_widget)
      ProcedureReturn Bar::ReDraw(*This)
      
      With *This
        If StartDrawing(CanvasOutput(\root\canvas\gadget))
          FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F0)
          
          Bar::Draw(*This)
          StopDrawing()
        EndIf
      EndWith  
    EndProcedure
    
    Procedure CallBack()
      Protected WheelDelta.i, Mouse_X.i, Mouse_Y.i, *This._s_widget = GetGadgetData(EventGadget())
      
      With *This
        \root\canvas\window = EventWindow()
        Mouse_X = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseX)
        Mouse_Y = GetGadgetAttribute(\root\canvas\gadget, #PB_Canvas_MouseY)
        
        Select EventType()
          Case #PB_EventType_Resize : ResizeGadget(\root\canvas\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
            Bar::Resize(*This, 0, 0, GadgetWidth(\root\canvas\gadget), GadgetHeight(\root\canvas\gadget)) 
            ReDraw(*This)
        EndSelect
        
        If Bar::Events(*This, EventType(), Mouse_X, Mouse_Y)
          ReDraw(*This)
        EndIf
      EndWith
      
    EndProcedure
    
    ;- PUBLIC
    Procedure SetAttribute(Gadget.i, Attribute.i, Value.i)
      Protected *This._s_widget = GetGadgetData(Gadget)
      
      With *This
        If Bar::SetAttribute(*This, Attribute, Value)
          ReDraw(*This)
        EndIf
      EndWith
    EndProcedure
    
    Procedure GetAttribute(Gadget.i, Attribute.i)
      Protected Result, *This._s_widget = GetGadgetData(Gadget)
      
      With *This
        Select Attribute
          Case #PB_Splitter_FirstGadget         : Result = \splitter\first
          Case #PB_Splitter_SecondGadget        : Result = \splitter\second
          Case #PB_Splitter_FirstMinimumSize    : Result = \bar\button[#__b_1]\len
          Case #PB_Splitter_SecondMinimumSize   : Result = \bar\button[#__b_2]\len
        EndSelect
      EndWith
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure SetState(Gadget.i, State.i)
      Protected *This._s_widget = GetGadgetData(Gadget)
      
      With *This
        If Bar::SetState(*This, State) 
          ReDraw(*This)
          PostEvent(#PB_Event_Gadget, \root\canvas\window, \root\canvas\gadget, #PB_EventType_Change)
        EndIf
      EndWith
    EndProcedure
    
    Procedure GetState(Gadget.i)
      Protected *This._s_widget = GetGadgetData(Gadget)
      ProcedureReturn *This\bar\Page\Pos
    EndProcedure
    
    Procedure Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, First.i, Second.i, Flag.i=0)
      ;Protected g = Bar::Canvas(GetActiveWindow(), X, Y, Width, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container) : CloseGadgetList() : If Gadget=-1 : Gadget=g : EndIf
      Protected window = GetActiveWindow()
      Protected g = CanvasGadget(Gadget, x,y,width,height, Flag) : If Gadget=-1 : Gadget=g : EndIf
      
      If Not Bar::Root()
        Bar::Root() = AllocateStructure(_s_root)
      Bar::Root()\class = "Root"
      ; Root()\adress = Bar::Root()
      Bar::Root()\opened = Bar::Root()
      Bar::Root()\parent = Bar::Root()
      Bar::Root()\window = Bar::Root()
      EndIf
      
      Bar::Root()\canvas\window = window
      Bar::Root()\canvas\gadget = Gadget
      
      Bar::GetActive() = Bar::Root()
      Bar::GetActive()\root = Bar::Root()
      
      SetGadgetData(Gadget, Bar::Root())
      SetWindowData(window, Gadget)
      
;       If Not *CallBack
;         *CallBack = @CallBack()
        Bar::Root()\repaint = #True
;       EndIf
      
      ; z-order
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        SetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE, GetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE ) | #WS_CLIPSIBLINGS )
        SetWindowPos_( GadgetID(Gadget), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      CompilerEndIf
      
      ;BindGadgetEvent(Gadget, @CallBack())
      BindGadgetEvent(Gadget, Bar::@CallBack())
      PostEvent(#PB_Event_Gadget, Window, Gadget, #__Event_Resize)
      
      ;BindEvent(#PB_Event_SizeWindow, @Resize_CanvasWindow(), Window);, Gadget)
      ;ProcedureReturn Gadget
      
      
      CompilerIf #PB_Compiler_OS = #PB_OS_Linux
        gtk_widget_reparent_( GadgetID(First), GadgetID(Gadget) )
        gtk_widget_reparent_( GadgetID(Second), GadgetID(Gadget) )
        
      CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
        SetParent_( GadgetID(First), GadgetID(Gadget) )
        SetParent_( GadgetID(Second), GadgetID(Gadget) )
        
        ; z-order
        ;CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        SetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE, GetWindowLongPtr_( GadgetID(Gadget), #GWL_STYLE ) | #WS_CLIPSIBLINGS )
        SetWindowPos_( GadgetID(Gadget), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        ;CompilerEndIf
        
      CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
        ;CocoaMessage(0,GadgetID(Gadget), "setParent", GadgetID(Gadget_1)); NSWindowAbove = 1
        CocoaMessage (0, GadgetID (Gadget), "addSubview:", GadgetID (First)) 
        
        CocoaMessage (0, GadgetID (Gadget), "addSubview:", GadgetID (Second)) 
        
        ;       Protected Point.NSPoint
        ;       Point\x = 100
        ;       Point\y = 100
        ;       CocoaMessage (0, WindowID (0), "center")
        ;       CocoaMessage (0, WindowID (0), "setFrameTopLeftPoint:@", @Point) ; Установить верхнюю левую координату окна
        ;       CocoaMessage (0, WindowID (0), "setFrameOrigin:@", @Point) ; Установить нижнюю левую координату окна
      CompilerEndIf
      
      Bar::Splitter(0, 0, Width, Height, First, Second, Flag)
      
      
      ProcedureReturn Gadget
    EndProcedure
  EndModule
CompilerEndIf


CompilerIf #PB_Compiler_IsMainFile
  UseModule Bar
  UseModule constants
  UseModule structures
  
  Global g_Canvas, NewList *List._S_bar()
  
  
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
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      Repaint | Events(*List(), EventType, MouseX, MouseY)
    Next
    
    If Repaint 
      _ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  If OpenWindow(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
    
    Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    ;         SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    ;         SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    ;   SetGadgetState(Splitter_1, 20)
    
    SetGadgetState(Splitter_0, GadgetWidth(Splitter_0)/2-5)
    SetGadgetState(Splitter_1, GadgetWidth(Splitter_1)/2-5)
    
    TextGadget(#PB_Any, 110, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
    
    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
    
    Splitter_0 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    ;         Splitter::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    ;         Splitter::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    Splitter_2 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = Splitter::Gadget(#PB_Any, 430, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    ;  Splitter::SetState(Splitter_1, 20)
    
    TextGadget(#PB_Any, 530, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf

; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -----
; EnableXP