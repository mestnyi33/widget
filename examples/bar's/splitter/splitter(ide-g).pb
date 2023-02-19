XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  Macro GetIndex( this )
    MacroExpandedCount
  EndMacro
  Uselib(widget)
  EnableExplicit
  #__Text_Border = #PB_Text_Border
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global s_desi, s_tbar, s_view, s_help, s_list,s_insp
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget  
  widget::Open(OpenWindow(#PB_Any, 100,100,800,600, "ide", flag))
  window_ide = widget::GetWindow(root())
  canvas_ide = widget::GetGadget(root())
  
  s_tbar = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
  s_desi = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
  s_view = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
  s_list = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
  s_insp = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
  s_help  = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  
  Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  
  Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
  widget::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  widget::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_5)
  Splitter_3 = widget::Splitter(0, 0, 0, 0, Button_2, Splitter_2)
  Splitter_4 = widget::Splitter(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
  Splitter_5 = widget::Splitter(0, 0, 0, 0, s_desi, Splitter_4, #PB_Splitter_Vertical)
  
  Splitter_design = widget::Splitter(0,0,0,0, s_tbar,Splitter_5, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  Splitter_inspector = widget::Splitter(0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  splitter_debug = widget::Splitter(0,0,0,0, Splitter_design,s_view, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  splitter_help = widget::Splitter(0,0,0,0, Splitter_inspector,s_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  Splitter_ide = widget::Splitter(0,0,800,600, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
  
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
    widget::SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
    widget::SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
    widget::SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
   ; widget::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
    widget::SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
    widget::SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
    widget::SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
    ;widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  EndIf

  If state
    ; set splitters dafault positions
    ;widget::SetState(Splitter_ide, -130)
    widget::SetState(Splitter_ide, widget::width(Splitter_ide)-220)
    widget::SetState(splitter_help, widget::height(splitter_help)-80)
    widget::SetState(splitter_debug, widget::height(splitter_debug)-150)
    widget::SetState(Splitter_inspector, 200)
    widget::SetState(Splitter_design, 30)
    widget::SetState(Splitter_5, 120)
    
    widget::SetState(Splitter_1, 20)
  EndIf
  
  ;widget::Resize(Splitter_ide, 0,0,820,620)
  
  SetGadgetText(s_tbar, "size: ("+Str(GadgetWidth(s_tbar))+"x"+Str(GadgetHeight(s_tbar))+") - " + Str(GetIndex( widget::GetParent( s_tbar ))))
  SetGadgetText(s_desi, "size: ("+Str(GadgetWidth(s_desi))+"x"+Str(GadgetHeight(s_desi))+") - " + Str(GetIndex( widget::GetParent( s_desi ))))
  SetGadgetText(s_view, "size: ("+Str(GadgetWidth(s_view))+"x"+Str(GadgetHeight(s_view))+") - " + Str(GetIndex( widget::GetParent( s_view ))))
  SetGadgetText(s_list, "size: ("+Str(GadgetWidth(s_list))+"x"+Str(GadgetHeight(s_list))+") - " + Str(GetIndex( widget::GetParent( s_list ))))
  SetGadgetText(s_insp, "size: ("+Str(GadgetWidth(s_insp))+"x"+Str(GadgetHeight(s_insp))+") - " + Str(GetIndex( widget::GetParent( s_insp ))))
  SetGadgetText(s_help, "size: ("+Str(GadgetWidth(s_help))+"x"+Str(GadgetHeight(s_help))+") - " + Str(GetIndex( widget::GetParent( s_help ))))
  
  ;WaitClose( )
  Define event
  Repeat 
    event = WaitWindowEvent( )
  Until event = #PB_Event_CloseWindow
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP