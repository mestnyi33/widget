IncludePath "/Users/as/Documents/GitHub/Widget/"

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_text.pbi"
  XIncludeFile "module_string.pbi"
CompilerEndIf

;-
DeclareModule IPAddress
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  Macro Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_=-1) : Text::Resize(_adress_, _x_,_y_,_width_,_height_, _canvas_) : EndMacro
  
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Radius.i=0)
EndDeclareModule

Module IPAddress
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(String::@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Radius.i=0)
   String::Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, "1", #PB_Text_Numeric, Radius.i)
  EndProcedure
EndModule

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule IPAddress
  
  Global *S_0.Widget_S = AllocateStructure(Widget_S)
  Global *S_1.Widget_S = AllocateStructure(Widget_S)
  Global *S_2.Widget_S = AllocateStructure(Widget_S)
  
  Procedure CallBacks()
    Protected Result
    Protected Canvas = EventGadget()
    Protected Window = EventWindow()
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    
    Select EventType()
      Case #PB_EventType_Repaint : Result = 1
      Case #PB_EventType_Resize : Result = 1
      Default
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(EventGadget())
        EndIf
        
        ForEach List()
          ; If List()\Widget\Canvas\Gadget = GetActiveGadget()
          If Canvas = List()\Widget\Canvas\Gadget
            Result | CallBack(List()\Widget, EventType()) 
          EndIf
        Next
        
    EndSelect
    
    If Result
      Text::ReDraw(0, Canvas)
    EndIf
    
  EndProcedure
  
  
  Procedure Events()
    Debug "Left click "+EventGadget()+" "+EventType()
  EndProcedure
  
  If OpenWindow(0, 0, 0, 615, 235, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    IPAddressGadget(0, 8,  10, 290, 20)
    SetGadgetState(0, MakeIPAddress(127, 0, 0, 1))   ; set a valid ip address
    Debug MakeIPAddress(127, 0, 0, 1) ; 16777343
    Debug MakeIPAddress(17, 0, 0, 1) ; 16777233
    Debug MakeIPAddress(127, 0, 0, 0); 16777233
    ;Debug 255*10000000/127
    ; Demo draw IPAddress on the canvas
    CanvasGadget(10,  305, 0, 310, 235, #PB_Canvas_Keyboard)
    SetGadgetAttribute(10, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    BindGadgetEvent(10, @CallBacks())
    
    *S_0 = Create(10, -1, 8,  10, 290, 20)
    *S_1 = Create(10, -1, 8,  35, 290, 20)
    *S_2 = Create(10, -1, 8,  60, 290, 20)
    ; SetState(*S_0, MakeIPAddress(127, 0, 0, 1))
    
    BindEvent(#PB_Event_Widget, @Events())
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -0-
; EnableXP