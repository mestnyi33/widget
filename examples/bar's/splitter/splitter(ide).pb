XIncludeFile "../../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  UseWidgets( )
  EnableExplicit
  #__flag_TextBorder = #PB_Text_Border
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global s_desi, s_tbar, s_view, s_help, s_list,s_insp
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget  
  widget::OpenRoot(0, 100,100,800,600, "ide", flag)
  window_ide = widget::GetCanvasWindow(root())
  canvas_ide = widget::GetCanvasGadget(root())
  
  s_tbar = TextWidget(0,0,0,0,"", #__flag_TextBorder)
  s_desi = TextWidget(0,0,0,0,"", #__flag_TextBorder)
  s_view = TextWidget(0,0,0,0,"", #__flag_TextBorder)
  s_list = TextWidget(0,0,0,0,"", #__flag_TextBorder)
  s_insp = TextWidget(0,0,0,0,"", #__flag_TextBorder)
  s_help = TextWidget(0,0,0,0,"", #__flag_TextBorder)
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5
  Button_0 = ButtonWidget(0, 0, 0, 0, "Button 0") ; as they will be sized automatically
  Button_1 = ButtonWidget(0, 0, 0, 0, "Button 1") ; as they will be sized automatically
  
  Button_2 = ButtonWidget(0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
  Button_3 = ButtonWidget(0, 0, 0, 0, "Button 3") ; as they will be sized automatically
  Button_4 = ButtonWidget(0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
  Button_5 = ButtonWidget(0, 0, 0, 0, "Button 5") ; as they will be sized automatically
  
  Splitter_0 = widget::SplitterWidget(0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
  Splitter_1 = widget::SplitterWidget(0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
  widget::SetWidgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
  widget::SetWidgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
  Splitter_2 = widget::SplitterWidget(0, 0, 0, 0, Splitter_1, Button_5)
  Splitter_3 = widget::SplitterWidget(0, 0, 0, 0, Button_2, Splitter_2)
  Splitter_4 = widget::SplitterWidget(0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical)
  Splitter_5 = widget::SplitterWidget(0, 0, 0, 0, s_desi, Splitter_4, #PB_Splitter_Vertical)
  
  Splitter_design = widget::SplitterWidget(0,0,0,0, s_tbar,Splitter_5, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  Splitter_inspector = widget::SplitterWidget(0,0,0,0, s_list,s_insp, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  splitter_debug = widget::SplitterWidget(0,0,0,0, Splitter_design,s_view, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  splitter_help = widget::SplitterWidget(0,0,0,0, Splitter_inspector,s_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  Splitter_ide = widget::SplitterWidget(0,0,800,600, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
  
  If minsize
    ;\\ set splitter default minimum size
    widget::SetWidgetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
    widget::SetWidgetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
    widget::SetWidgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
    widget::SetWidgetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 100)
    widget::SetWidgetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 200)
    widget::SetWidgetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
    widget::SetWidgetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
    widget::SetWidgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
    widget::SetWidgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    widget::SetWidgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
    ;widget::SetWidgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  EndIf

  If state
    ; set splitters dafault positions
    ;widget::SetWidgetState(Splitter_ide, -130)
    widget::SetWidgetState(Splitter_ide, widget::WidgetWidth(Splitter_ide)-220)
    widget::SetWidgetState(splitter_help, widget::WidgetHeight(splitter_help)-80)
    widget::SetWidgetState(splitter_debug, widget::WidgetHeight(splitter_debug)-150)
    widget::SetWidgetState(Splitter_inspector, 200)
    widget::SetWidgetState(Splitter_design, 30)
    widget::SetWidgetState(Splitter_5, 120)
    
    widget::SetWidgetState(Splitter_1, 20)
  EndIf
  
  ;widget::ResizeWidget(Splitter_ide, 0,0,820,620)
  
  SetWidgetText(s_tbar, "size: ("+Str(WidgetWidth(s_tbar))+"x"+Str(WidgetHeight(s_tbar))+") - " );+ Str(GetIndex( widget::GetParent( s_tbar ))) )
  SetWidgetText(s_desi, "size: ("+Str(WidgetWidth(s_desi))+"x"+Str(WidgetHeight(s_desi))+") - " );+ Str(GetIndex( widget::GetParent( s_desi ))))
  SetWidgetText(s_view, "size: ("+Str(WidgetWidth(s_view))+"x"+Str(WidgetHeight(s_view))+") - " );+ Str(GetIndex( widget::GetParent( s_view ))))
  SetWidgetText(s_list, "size: ("+Str(WidgetWidth(s_list))+"x"+Str(WidgetHeight(s_list))+") - " );+ Str(GetIndex( widget::GetParent( s_list ))))
  SetWidgetText(s_insp, "size: ("+Str(WidgetWidth(s_insp))+"x"+Str(WidgetHeight(s_insp))+") - " );+ Str(GetIndex( widget::GetParent( s_insp ))))
  SetWidgetText(s_help, "size: ("+Str(WidgetWidth(s_help))+"x"+Str(WidgetHeight(s_help))+") - " );+ Str(GetIndex( widget::GetParent( s_help ))))
  
  ;WaitClose( )
  Define event
  Repeat 
    event = WaitWindowEvent( )
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; CompilerIf #PB_Compiler_IsMainFile ;= 100
;   UseWidgets( )
;   EnableExplicit
;   
;   Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
;   Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
;   Global mdi_design, toolbar_design, listview_debug, text_help, tree_inspector,panel_inspector
;   
;   Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget
;   window_ide = GetCanvasWindow(OpenRoot(OpenWindow(#PB_Any, 100,100,800,600, "ide", flag)))
;   
;   toolbar_design = TextWidget(0,0,0,0,"", #__flag_TextBorder)
;   mdi_design = TextWidget(0,0,0,0,"", #__flag_TextBorder)
;   listview_debug = TextWidget(0,0,0,0,"", #__flag_TextBorder)
;   tree_inspector = TextWidget(0,0,0,0,"", #__flag_TextBorder)
;   panel_inspector = TextWidget(0,0,0,0,"", #__flag_TextBorder)
;   text_help  = TextWidget(0,0,0,0,"", #__flag_TextBorder)
;   
;   Splitter_design = SplitterWidget(0,0,0,0, toolbar_design,mdi_design, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
;   Splitter_inspector = SplitterWidget(0,0,0,0, tree_inspector,panel_inspector, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
;   splitter_debug = SplitterWidget(0,0,0,0, Splitter_design,listview_debug, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
;   splitter_help = SplitterWidget(0,0,0,0, Splitter_inspector,text_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
;   Splitter_ide = SplitterWidget(0,0,0,0, splitter_debug,splitter_help, #__flag_autosize|#PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
; ;   Splitter_design = SplitterWidget(0,0,800,600, toolbar_design,mdi_design, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
; ;   Splitter_inspector = SplitterWidget(0,0,800,600, tree_inspector,panel_inspector, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
; ;   splitter_debug = SplitterWidget(0,0,800,600, Splitter_design,listview_debug, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
; ;   splitter_help = SplitterWidget(0,0,800,600, Splitter_inspector,text_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
; ;   Splitter_ide = SplitterWidget(0,0,800,600, splitter_debug,splitter_help, #__flag_autosize|#PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
;   
;   If minsize
; ;         ; set splitter default minimum size
; ;     SetWidgetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 20)
; ;     SetWidgetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 10)
; ;     SetWidgetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 20)
; ;     SetWidgetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 10)
; ;     SetWidgetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 20)
; ;     SetWidgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 10)
; ;     SetWidgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 20)
; ;     SetWidgetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 10)
; ;     SetWidgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
; ;     SetWidgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 10)
;     
;         ; set splitter default minimum size
;     SetWidgetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
;     SetWidgetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
;     SetWidgetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
;    ; SetWidgetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
;     SetWidgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
;     SetWidgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
;     SetWidgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
;     SetWidgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
;     ;SetWidgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
;   EndIf
; 
;   If state
;     ; set splitters dafault positions
;     ;SetWidgetState(Splitter_ide, -130)
;     SetWidgetState(Splitter_ide, WidgetWidth(Splitter_ide)-220)
;     SetWidgetState(splitter_help, WidgetHeight(splitter_help)-80)
;     SetWidgetState(splitter_debug, WidgetHeight(splitter_debug)-150)
;     SetWidgetState(Splitter_inspector, 200)
;     SetWidgetState(Splitter_design, 30)
;   EndIf
;   
;   ;ResizeWidget(Splitter_ide, 0,0,800,600)
;   
;   SetWidgetText(toolbar_design, "size: ("+Str(WidgetWidth(toolbar_design))+"x"+Str(WidgetHeight(toolbar_design))+") - " + Str(GetIndex( GetParent( toolbar_design ))) )
;   SetWidgetText(mdi_design, "size: ("+Str(WidgetWidth(mdi_design))+"x"+Str(WidgetHeight(mdi_design))+") - " + Str(GetIndex( GetParent( mdi_design ))))
;   SetWidgetText(listview_debug, "size: ("+Str(WidgetWidth(listview_debug))+"x"+Str(WidgetHeight(listview_debug))+") - " + Str(GetIndex( GetParent( listview_debug ))))
;   SetWidgetText(tree_inspector, "size: ("+Str(WidgetWidth(tree_inspector))+"x"+Str(WidgetHeight(tree_inspector))+") - " + Str(GetIndex( GetParent( tree_inspector ))))
;   SetWidgetText(panel_inspector, "size: ("+Str(WidgetWidth(panel_inspector))+"x"+Str(WidgetHeight(panel_inspector))+") - " + Str(GetIndex( GetParent( panel_inspector ))))
;   SetWidgetText(text_help, "size: ("+Str(WidgetWidth(text_help))+"x"+Str(WidgetHeight(text_help))+") - " + Str(GetIndex( GetParent( text_help ))))
;   
;   BindWidgetEvent(-1,-1)
;   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 162
; FirstLine = 135
; Folding = -
; Optimizer
; EnableXP
; DPIAware
; Executable = SplitterWidget(ide).exe