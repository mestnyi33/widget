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
  widget::Open(0, 100,100,800,600, "ide", flag)
  window_ide = widget::GetCanvasWindow(root())
  canvas_ide = widget::GetCanvasGadget(root())
  
  s_tbar = Text(0,0,0,0,"", #__flag_TextBorder)
  s_desi = Text(0,0,0,0,"", #__flag_TextBorder)
  s_view = Text(0,0,0,0,"", #__flag_TextBorder)
  s_list = Text(0,0,0,0,"", #__flag_TextBorder)
  s_insp = Text(0,0,0,0,"", #__flag_TextBorder)
  s_help = Text(0,0,0,0,"", #__flag_TextBorder)
  
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
    widget::SetState(Splitter_ide, widget::Width(Splitter_ide)-220)
    widget::SetState(splitter_help, widget::Height(splitter_help)-80)
    widget::SetState(splitter_debug, widget::Height(splitter_debug)-150)
    widget::SetState(Splitter_inspector, 200)
    widget::SetState(Splitter_design, 30)
    widget::SetState(Splitter_5, 120)
    
    widget::SetState(Splitter_1, 20)
  EndIf
  
  ;widget::Resize(Splitter_ide, 0,0,820,620)
  
  SetText(s_tbar, "size: ("+Str(Width(s_tbar))+"x"+Str(Height(s_tbar))+")")
  SetText(s_desi, "size: ("+Str(Width(s_desi))+"x"+Str(Height(s_desi))+")")
  SetText(s_view, "size: ("+Str(Width(s_view))+"x"+Str(Height(s_view))+")")
  SetText(s_list, "size: ("+Str(Width(s_list))+"x"+Str(Height(s_list))+")")
  SetText(s_insp, "size: ("+Str(Width(s_insp))+"x"+Str(Height(s_insp))+")")
  SetText(s_help, "size: ("+Str(Width(s_help))+"x"+Str(Height(s_help))+")")
  
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
;   window_ide = GetCanvasWindow(Open(OpenWindow(#PB_Any, 100,100,800,600, "ide", flag)))
;   
;   toolbar_design = Text(0,0,0,0,"", #__flag_TextBorder)
;   mdi_design = Text(0,0,0,0,"", #__flag_TextBorder)
;   listview_debug = Text(0,0,0,0,"", #__flag_TextBorder)
;   tree_inspector = Text(0,0,0,0,"", #__flag_TextBorder)
;   panel_inspector = Text(0,0,0,0,"", #__flag_TextBorder)
;   text_help  = Text(0,0,0,0,"", #__flag_TextBorder)
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
;     SetState(Splitter_ide, Width(Splitter_ide)-220)
;     SetState(splitter_help, Height(splitter_help)-80)
;     SetState(splitter_debug, Height(splitter_debug)-150)
;     SetState(Splitter_inspector, 200)
;     SetState(Splitter_design, 30)
;   EndIf
;   
;   ;Resize(Splitter_ide, 0,0,800,600)
;   
;   SetText(toolbar_design, "size: ("+Str(Width(toolbar_design))+"x"+Str(Height(toolbar_design))+") - " + Str(Index( GetParent( toolbar_design ))) )
;   SetText(mdi_design, "size: ("+Str(Width(mdi_design))+"x"+Str(Height(mdi_design))+") - " + Str(Index( GetParent( mdi_design ))))
;   SetText(listview_debug, "size: ("+Str(Width(listview_debug))+"x"+Str(Height(listview_debug))+") - " + Str(Index( GetParent( listview_debug ))))
;   SetText(tree_inspector, "size: ("+Str(Width(tree_inspector))+"x"+Str(Height(tree_inspector))+") - " + Str(Index( GetParent( tree_inspector ))))
;   SetText(panel_inspector, "size: ("+Str(Width(panel_inspector))+"x"+Str(Height(panel_inspector))+") - " + Str(Index( GetParent( panel_inspector ))))
;   SetText(text_help, "size: ("+Str(Width(text_help))+"x"+Str(Height(text_help))+") - " + Str(Index( GetParent( text_help ))))
;   
;   Bind(-1,-1)
;   Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 162
; FirstLine = 132
; Folding = -
; Optimizer
; EnableXP
; DPIAware
; Executable = splitter(ide).exe