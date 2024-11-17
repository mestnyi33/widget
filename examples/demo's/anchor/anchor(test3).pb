 XIncludeFile "../../../widgets.pbi"
; fixed 778 commit
;-
CompilerIf #PB_Compiler_IsMainFile ;= 100
  UseWidgets( )
  EnableExplicit
  #__flag_TextBorder = #PB_Text_Border
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global s_desi, s_tbar, s_view, s_help, s_list,s_insp
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget  
  widget::Open(OpenWindow(#PB_Any, 100,100,800,600, "ide", flag))
  window_ide = widget::GetCanvasWindow(root())
  canvas_ide = widget::GetCanvasGadget(root())
  a_init(root())
  
  s_tbar = Text(0,0,0,0,"", #__flag_TextBorder)
  s_desi = Text(0,0,0,0,"", #__flag_TextBorder)
  s_view = Text(0,0,0,0,"", #__flag_TextBorder)
  s_list = Text(0,0,0,0,"", #__flag_TextBorder)
  s_insp = Text(0,0,0,0,"", #__flag_TextBorder)
  s_help  = Text(0,0,0,0,"", #__flag_TextBorder)
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  Button_0 = Button(0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  ;Button_1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  Button_1 = Container(0, 0, 0, 0) ; as they will be sized automatically
  Button(10, 10, 50, 50, "Button 1")
  CloseList( )
  
  Button_2 = Button(0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3 = Button(0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Button_4 = Button(0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Button_5 = Button(0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  
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
  Splitter_ide = widget::Splitter(50,50,700,500, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
  
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
    widget::SetState(Splitter_ide, widget::Width(Splitter_ide)-220)
    widget::SetState(splitter_help, widget::Height(splitter_help)-80)
    widget::SetState(splitter_debug, widget::Height(splitter_debug)-150)
    widget::SetState(Splitter_inspector, 200)
    widget::SetState(Splitter_design, 30)
    widget::SetState(Splitter_5, 120)
    
    widget::SetState(Splitter_1, 20)
  EndIf
  
  ;widget::Resize(Splitter_ide, 0,0,820,620)
  
  SetText(s_tbar, "size: ("+Str(Width(s_tbar))+"x"+Str(Height(s_tbar))+") - " );+ Str(GetIndex( widget::GetParent( s_tbar ))) )
  SetText(s_desi, "size: ("+Str(Width(s_desi))+"x"+Str(Height(s_desi))+") - " );+ Str(GetIndex( widget::GetParent( s_desi ))))
  SetText(s_view, "size: ("+Str(Width(s_view))+"x"+Str(Height(s_view))+") - " );+ Str(GetIndex( widget::GetParent( s_view ))))
  SetText(s_list, "size: ("+Str(Width(s_list))+"x"+Str(Height(s_list))+") - " );+ Str(GetIndex( widget::GetParent( s_list ))))
  SetText(s_insp, "size: ("+Str(Width(s_insp))+"x"+Str(Height(s_insp))+") - " );+ Str(GetIndex( widget::GetParent( s_insp ))))
  SetText(s_help, "size: ("+Str(Width(s_help))+"x"+Str(Height(s_help))+") - " );+ Str(GetIndex( widget::GetParent( s_help ))))
  
  ;WaitClose( )
  Define event
  Repeat 
    event = WaitWindowEvent( )
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 96
; FirstLine = 80
; Folding = -
; Optimizer
; EnableXP
; DPIAware