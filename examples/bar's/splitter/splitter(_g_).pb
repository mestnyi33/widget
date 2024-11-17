XIncludeFile "../../../widgets.pbi"

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
      If widget::ChangeCurrentCanvas( GadgetID(gadget) )
        ProcedureReturn widget::GetState( widget::Root( ) )
      EndIf
    EndProcedure
    
    Procedure GetAttribute(Gadget.i, Attribute.i)
      If widget::ChangeCurrentCanvas( GadgetID(gadget) )
        ProcedureReturn widget::GetAttribute( widget::Root( ), Attribute )
      EndIf
    EndProcedure
    
    Procedure SetState(Gadget.i, State.i)
      If widget::ChangeCurrentCanvas( GadgetID(gadget) )
        If widget::SetState( widget::Root( ), State) 
          widget::PostEventRepaint( widget::Root( ) )
        EndIf
      EndIf
    EndProcedure
    
    Procedure SetAttribute(Gadget.i, Attribute.i, Value.i)
      If widget::ChangeCurrentCanvas( GadgetID(gadget) )
        If widget::SetAttribute( widget::Root( ), Attribute, Value)
          widget::PostEventRepaint( widget::Root( ) )
        EndIf
      EndIf
    EndProcedure
    
    Procedure Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, First.i, Second.i, Flag.i=0)
      ProcedureReturn widget::Gadget(#PB_GadgetType_Splitter, Gadget, X, Y, Width, Height, "", First, Second, #Null, Flag)
    EndProcedure
  EndModule
CompilerEndIf

; good
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
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
    ; Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
  
CompilerEndIf

; no good
CompilerIf #PB_Compiler_IsMainFile = 99 
  UseWidgets( )
  EnableExplicit
  #__flag_TextBorder = #PB_Text_Border
  
  Macro IDWidget( this )
    MacroExpandedCount
  EndMacro
  Macro SetGadgetAttribute(_gadget_, _attribute_, _value_)
    Splitter::SetAttribute(_gadget_, _attribute_, _value_)
  EndMacro
  Macro SetGadgetState(_gadget_, _state_)
    Splitter::SetState(_gadget_, _state_)
  EndMacro
;   Macro GadgetWidth(_gadget_, _mode_ = #PB_Gadget_ActualSize)
;     Splitter::GadgetWidth_(_gadget_, _mode_)
;   EndMacro
;   Macro GadgetHeight(_gadget_, _mode_ = #PB_Gadget_ActualSize)
;     Splitter::GadgetHeight_(_gadget_, _mode_)
;   EndMacro
  Macro SplitterGadget(_gadget_, X,Y,Width,Height, gadget1, gadget2, Flags=0)
    Splitter::Gadget(_gadget_, X,Y,Width,Height, gadget1,gadget2, Flags)
  EndMacro



  ; Procedure.l IDWidget( *this._S_widget )
  ;     ; ProcedureReturn *this\index - 1
  ;   EndProcedure
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global s_desi, s_tbar, s_view, s_help, s_list,s_insp
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget  
  OpenWindow(#PB_Any, 100,100,800,600, "ide", flag)
  ;   widget::OpenRootWidget()
  ;   window_ide = widget::GetCanvasWindow(root())
  ;   canvas_ide = widget::GetCanvasGadget(root())
  
  s_tbar = TextGadget(#PB_Any, 0,0,0,0,"", #__flag_TextBorder)
  s_desi = TextGadget(#PB_Any, 0,0,0,0,"", #__flag_TextBorder)
  s_view = TextGadget(#PB_Any, 0,0,0,0,"", #__flag_TextBorder)
  s_list = TextGadget(#PB_Any, 0,0,0,0,"", #__flag_TextBorder)
  s_insp = TextGadget(#PB_Any, 0,0,0,0,"", #__flag_TextBorder)
  s_help  = TextGadget(#PB_Any, 0,0,0,0,"", #__flag_TextBorder)
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  
  Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  
  ;Splitter_0 = widget::SplitterWidget(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  Splitter_0 = SplitterGadget(-1, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  Splitter_1 = SplitterGadget(-1, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
  SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  Splitter_2 = SplitterGadget(-1, 0, 0, 0, 0, Splitter_1, Button_5)
  Splitter_3 = SplitterGadget(-1, 0, 0, 0, 0, Button_2, Splitter_2)
  Splitter_4 = SplitterGadget(-1, 0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
  Splitter_5 = SplitterGadget(-1, 0, 0, 0, 0, s_desi, Splitter_4, #PB_Splitter_Vertical)
  
  Splitter_design = SplitterGadget(-1, 0,0,0,0, s_tbar,Splitter_5, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  ;Splitter_inspector = widget::SplitterWidget(0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  Splitter_inspector = SplitterGadget(-1, 0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  splitter_debug = SplitterGadget(-1, 0,0,0,0, Splitter_design,s_view, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  splitter_help = SplitterGadget(-1, 0,0,0,0, Splitter_inspector,s_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  Splitter_ide = SplitterGadget(-1, 0,0,800,600, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
  
  If minsize
    ;         ; set splitter default minimum size
    ;     widget::SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 20)
    ;     widget::SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 10)
    ;     widget::SetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 20)
    ;     widget::SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 10)
    ;     widget::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 20)
    ;     widget::SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 10)
    ;     widget::SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 20)
    ;     widget::SetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 10)
    ;     widget::SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    ;     widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 10)
    
    ;   ; set splitter default minimum size
    SetGadgetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
    SetGadgetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
    SetGadgetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
    ; widget::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
    SetGadgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
    SetGadgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
    SetGadgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    SetGadgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
    ;widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  EndIf
  
  If state
    ; set splitters dafault positions
    ;widget::SetState(Splitter_ide, -130)
    SetGadgetState(Splitter_ide, GadgetWidth(Splitter_ide)-220)
    SetGadgetState(splitter_help, GadgetHeight(splitter_help)-80)
    SetGadgetState(splitter_debug, GadgetHeight(splitter_debug)-150)
    SetGadgetState(Splitter_inspector, 200)
    SetGadgetState(Splitter_design, 30)
    SetGadgetState(Splitter_5, 120)
    
    SetGadgetState(Splitter_1, 20)
  EndIf
  
  ;widget::ResizeWidget(Splitter_ide, 0,0,820,620)
  
  SetGadgetTextWidget(s_tbar, "size: ("+Str(GadgetWidth(s_tbar))+"x"+Str(GadgetHeight(s_tbar))+") - " + Str(IDWidget( widget::GetParent( s_tbar ))) )
  SetGadgetTextWidget(s_desi, "size: ("+Str(GadgetWidth(s_desi))+"x"+Str(GadgetHeight(s_desi))+") - " + Str(IDWidget( widget::GetParent( s_desi ))))
  SetGadgetTextWidget(s_view, "size: ("+Str(GadgetWidth(s_view))+"x"+Str(GadgetHeight(s_view))+") - " + Str(IDWidget( widget::GetParent( s_view ))))
  SetGadgetTextWidget(s_list, "size: ("+Str(GadgetWidth(s_list))+"x"+Str(GadgetHeight(s_list))+") - " + Str(IDWidget( widget::GetParent( s_list ))))
  SetGadgetTextWidget(s_insp, "size: ("+Str(GadgetWidth(s_insp))+"x"+Str(GadgetHeight(s_insp))+") - " + Str(IDWidget( widget::GetParent( s_insp ))))
  SetGadgetTextWidget(s_help, "size: ("+Str(GadgetWidth(s_help))+"x"+Str(GadgetHeight(s_help))+") - " + Str(IDWidget( widget::GetParent( s_help ))))
  
  Repeat 
    Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 111
; FirstLine = 107
; Folding = ----
; EnableXP
; DPIAware