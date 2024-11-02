XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  Uselib(widget)
  EnableExplicit
  #__flag_textBorder = #PB_Text_Border
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global s_desi, s_tbar, s_view, s_help, s_list,s_insp
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget  
  widget::Open(0, 100,100,800,600, "ide", flag)
  window_ide = widget::GetWindow(root())
  canvas_ide = widget::GetGadget(root())
  
  s_tbar = Text(0,0,0,0,"", #__flag_textBorder)
  s_desi = Text(0,0,0,0,"", #__flag_textBorder)
  s_view = Text(0,0,0,0,"", #__flag_textBorder)
  s_list = Text(0,0,0,0,"", #__flag_textBorder)
  s_insp = Text(0,0,0,0,"", #__flag_textBorder)
  s_help = Text(0,0,0,0,"", #__flag_textBorder)
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  Button_0 = Button(0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  Button_1 = Button(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  
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
  Splitter_ide = widget::Splitter(0,0,800,600, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
  
  If minsize
    ;\\ set splitter default minimum size
    widget::SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
    widget::SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
    widget::SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
    widget::SetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 100)
    widget::SetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 200)
    widget::SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
    widget::SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
    widget::SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
    widget::SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
    ;widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  EndIf

  If state
    ; set splitters dafault positions
    ;widget::SetState(Splitter_ide, -130)
    widget::SetState(Splitter_ide, widget::WidgetWidth(Splitter_ide)-220)
    widget::SetState(splitter_help, widget::WidgetHeight(splitter_help)-80)
    widget::SetState(splitter_debug, widget::WidgetHeight(splitter_debug)-150)
    widget::SetState(Splitter_inspector, 200)
    widget::SetState(Splitter_design, 30)
    widget::SetState(Splitter_5, 120)
    
    widget::SetState(Splitter_1, 20)
  EndIf
  
  ;widget::Resize(Splitter_ide, 0,0,820,620)
  
  SetText(s_tbar, "size: ("+Str(WidgetWidth(s_tbar))+"x"+Str(WidgetHeight(s_tbar))+") - " );+ Str(IDWidget( widget::GetParent( s_tbar ))) )
  SetText(s_desi, "size: ("+Str(WidgetWidth(s_desi))+"x"+Str(WidgetHeight(s_desi))+") - " );+ Str(IDWidget( widget::GetParent( s_desi ))))
  SetText(s_view, "size: ("+Str(WidgetWidth(s_view))+"x"+Str(WidgetHeight(s_view))+") - " );+ Str(IDWidget( widget::GetParent( s_view ))))
  SetText(s_list, "size: ("+Str(WidgetWidth(s_list))+"x"+Str(WidgetHeight(s_list))+") - " );+ Str(IDWidget( widget::GetParent( s_list ))))
  SetText(s_insp, "size: ("+Str(WidgetWidth(s_insp))+"x"+Str(WidgetHeight(s_insp))+") - " );+ Str(IDWidget( widget::GetParent( s_insp ))))
  SetText(s_help, "size: ("+Str(WidgetWidth(s_help))+"x"+Str(WidgetHeight(s_help))+") - " );+ Str(IDWidget( widget::GetParent( s_help ))))
  
  ;WaitClose( )
  Define event
  Repeat 
    event = WaitWindowEvent( )
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; CompilerIf #PB_Compiler_IsMainFile ;= 100
;   Uselib(widget)
;   EnableExplicit
;   
;   Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
;   Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
;   Global mdi_design, toolbar_design, listview_debug, text_help, tree_inspector,panel_inspector
;   
;   Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget
;   window_ide = GetWindow(Open(OpenWindow(#PB_Any, 100,100,800,600, "ide", flag)))
;   
;   toolbar_design = Text(0,0,0,0,"", #__flag_textBorder)
;   mdi_design = Text(0,0,0,0,"", #__flag_textBorder)
;   listview_debug = Text(0,0,0,0,"", #__flag_textBorder)
;   tree_inspector = Text(0,0,0,0,"", #__flag_textBorder)
;   panel_inspector = Text(0,0,0,0,"", #__flag_textBorder)
;   text_help  = Text(0,0,0,0,"", #__flag_textBorder)
;   
;   Splitter_design = Splitter(0,0,0,0, toolbar_design,mdi_design, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
;   Splitter_inspector = Splitter(0,0,0,0, tree_inspector,panel_inspector, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
;   splitter_debug = Splitter(0,0,0,0, Splitter_design,listview_debug, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
;   splitter_help = Splitter(0,0,0,0, Splitter_inspector,text_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
;   Splitter_ide = Splitter(0,0,0,0, splitter_debug,splitter_help, #__flag_autosize|#PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
; ;   Splitter_design = Splitter(0,0,800,600, toolbar_design,mdi_design, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
; ;   Splitter_inspector = Splitter(0,0,800,600, tree_inspector,panel_inspector, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
; ;   splitter_debug = Splitter(0,0,800,600, Splitter_design,listview_debug, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
; ;   splitter_help = Splitter(0,0,800,600, Splitter_inspector,text_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
; ;   Splitter_ide = Splitter(0,0,800,600, splitter_debug,splitter_help, #__flag_autosize|#PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
;   
;   If minsize
; ;         ; set splitter default minimum size
; ;     SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 20)
; ;     SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 10)
; ;     SetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 20)
; ;     SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 10)
; ;     SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 20)
; ;     SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 10)
; ;     SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 20)
; ;     SetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 10)
; ;     SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
; ;     SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 10)
;     
;         ; set splitter default minimum size
;     SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
;     SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
;     SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
;    ; SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
;     SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
;     SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
;     SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
;     ;SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
;   EndIf
; 
;   If state
;     ; set splitters dafault positions
;     ;SetState(Splitter_ide, -130)
;     SetState(Splitter_ide, WidgetWidth(Splitter_ide)-220)
;     SetState(splitter_help, WidgetHeight(splitter_help)-80)
;     SetState(splitter_debug, WidgetHeight(splitter_debug)-150)
;     SetState(Splitter_inspector, 200)
;     SetState(Splitter_design, 30)
;   EndIf
;   
;   ;Resize(Splitter_ide, 0,0,800,600)
;   
;   SetText(toolbar_design, "size: ("+Str(WidgetWidth(toolbar_design))+"x"+Str(WidgetHeight(toolbar_design))+") - " + Str(IDWidget( GetParent( toolbar_design ))) )
;   SetText(mdi_design, "size: ("+Str(WidgetWidth(mdi_design))+"x"+Str(WidgetHeight(mdi_design))+") - " + Str(IDWidget( GetParent( mdi_design ))))
;   SetText(listview_debug, "size: ("+Str(WidgetWidth(listview_debug))+"x"+Str(WidgetHeight(listview_debug))+") - " + Str(IDWidget( GetParent( listview_debug ))))
;   SetText(tree_inspector, "size: ("+Str(WidgetWidth(tree_inspector))+"x"+Str(WidgetHeight(tree_inspector))+") - " + Str(IDWidget( GetParent( tree_inspector ))))
;   SetText(panel_inspector, "size: ("+Str(WidgetWidth(panel_inspector))+"x"+Str(WidgetHeight(panel_inspector))+") - " + Str(IDWidget( GetParent( panel_inspector ))))
;   SetText(text_help, "size: ("+Str(WidgetWidth(text_help))+"x"+Str(WidgetHeight(text_help))+") - " + Str(IDWidget( GetParent( text_help ))))
;   
;   Bind(-1,-1)
;   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 107
; FirstLine = 83
; Folding = -
; Optimizer
; EnableXP
; DPIAware
; Executable = splitter(ide).exe