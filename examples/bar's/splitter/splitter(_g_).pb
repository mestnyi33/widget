XIncludeFile "../../../widget-events.pbi"

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
    
    ;- PUBLIC
    Procedure GetState(Gadget.i)
      If widget::ChangeCurrentRoot( GadgetID(gadget) )
        ProcedureReturn widget::GetState( widget::Root( ) )
      EndIf
    EndProcedure
    
    Procedure GetAttribute(Gadget.i, Attribute.i)
      If widget::ChangeCurrentRoot( GadgetID(gadget) )
        ProcedureReturn widget::GetAttribute( widget::Root( ), Attribute )
      EndIf
    EndProcedure
    
    Procedure SetState(Gadget.i, State.i)
      If widget::ChangeCurrentRoot( GadgetID(gadget) )
        If widget::SetState( widget::Root( ), State) 
          widget::PostCanvasRepaint( widget::Root( ) )
        EndIf
      EndIf
    EndProcedure
    
    Procedure SetAttribute(Gadget.i, Attribute.i, Value.i)
      If widget::ChangeCurrentRoot( GadgetID(gadget) )
        If widget::SetAttribute( widget::Root( ), Attribute, Value)
          widget::PostCanvasRepaint( widget::Root( ) )
        EndIf
      EndIf
    EndProcedure
    
    Procedure Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, First.i, Second.i, Flag.i=0)
      ProcedureReturn widget::Gadget(#PB_GadgetType_Splitter, Gadget, X, Y, Width, Height, "", First, Second, #Null, Flag)
    EndProcedure
  EndModule
CompilerEndIf


CompilerIf #PB_Compiler_IsMainFile
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  If OpenWindow(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
    
    Splitter_0 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
    
    ; bug purebasic
    SetGadgetState(Splitter_0, GadgetWidth(Splitter_0)/2-5)
    SetGadgetState(Splitter_1, GadgetWidth(Splitter_1)/2-5)
    
    SetGadgetState(Splitter_1, 20)
    
    TextGadget(#PB_Any, 110, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
    
    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
    
    Splitter_0 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    Splitter_1 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    Splitter::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
    Splitter::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    Splitter_2 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5)
    Splitter_3 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2)
    Splitter_4 = Splitter::Gadget(#PB_Any, 430, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
    Splitter::SetState(Splitter_1, 20)
    
    TextGadget(#PB_Any, 530, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
    
    Repeat : Until Widget::WaitWindowEvent() = #PB_Event_CloseWindow
    ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP