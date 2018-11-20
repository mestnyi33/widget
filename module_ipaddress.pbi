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
  Macro GetState(_this_) : _this_\address : EndMacro
  
  
  Declare.i SetState(*This.Widget_S, State.i)
  
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s="", Flag.i=0, Radius.i=0)
EndDeclareModule

Module IPAddress
  Procedure.i SetState(*This.Widget_S, State.i)
    Protected Text.s
    
    With *This
      Text.s = Str(IPAddressField(State,0))+"."+
               Str(IPAddressField(State,1))+"."+
               Str(IPAddressField(State,2))+"."+
               Str(IPAddressField(State,3))
      \address = State
      Text::SetText(*This, Text)
    EndWith
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(String::@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s="", Flag.i=0, Radius.i=0)
    String::Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag|#PB_Text_Numeric, Radius.i)
    With List()\Widget
      \Type = #PB_GadgetType_IPAddress
    EndWith
    ProcedureReturn List()\Widget
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
    Debug ""+EventGadget()+" "+EventType()
  EndProcedure
  
  If OpenWindow(0, 0, 0, 615, 235, "String on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    IPAddressGadget(0, 8,  10, 290, 20)
    IPAddressGadget(1, 8,  35, 290, 20)
    IPAddressGadget(2, 8,  60, 290, 20)
    
    SetGadgetState(0, MakeIPAddress(127, 0, 30, 1))   ; set a valid ip address
    SetGadgetState(1, MakeIPAddress(127, 190, 0, 1))   ; set a valid ip address
    SetGadgetState(2, MakeIPAddress(127, 0, 0, 1))   ; set a valid ip address
    Debug GetGadgetState(0)
    
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      CocoaMessage(0,GadgetID(0),"setAlignment:", 0)
      CocoaMessage(0,GadgetID(2),"setAlignment:", 1)
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      If OSVersion() > #PB_OS_Windows_XP
        SetWindowLongPtr_(GadgetID(0), #GWL_STYLE, GetWindowLong_(GadgetID(0), #GWL_STYLE) & $FFFFFFFC | #SS_LEFT)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLongPtr_(GadgetID(2), #GWL_STYLE) & $FFFFFFFC | #ES_RIGHT) 
      Else
        SetWindowLongPtr_(GadgetID(1), #GWL_STYLE, GetWindowLong_(GadgetID(1), #GWL_STYLE)|#SS_CENTER)
        SetWindowLongPtr_(GadgetID(2), #GWL_STYLE, GetWindowLong_(GadgetID(2), #GWL_STYLE)|#SS_RIGHT)
      EndIf
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ImportC ""
        gtk_entry_set_alignment(Entry.i, XAlign.f)
      EndImport
      gtk_entry_set_alignment(GadgetID(0), 0)
      gtk_entry_set_alignment(GadgetID(2), 1)
    CompilerEndIf
    
    ; Demo draw IPAddress on the canvas
    CanvasGadget(10,  305, 0, 310, 235, #PB_Canvas_Keyboard)
    SetGadgetAttribute(10, #PB_Canvas_Cursor, #PB_Cursor_Cross)
    BindGadgetEvent(10, @CallBacks())
    
    *S_0 = Create(10, -1, 8,  10, 290, 20)
    *S_1 = Create(10, -1, 8,  35, 290, 20, "127. 190. 0. 1", #PB_Text_Center)
    *S_2 = Create(10, -1, 8,  60, 290, 20, "127. 0. 0. 1", #PB_Text_Right)
    
    SetState(*S_0, MakeIPAddress(127, 0, 30, 1))
    Debug GetState(*S_0)
    
    BindEvent(#PB_Event_Widget, @Events())
    PostEvent(#PB_Event_Gadget, 0,10, #PB_EventType_Resize)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -4v-
; EnableXP