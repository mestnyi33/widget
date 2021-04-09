XIncludeFile "../../../widgets.pbi"
;XIncludeFile "../../../widgets-bar.pbi"
;XIncludeFile "../../../widgets-splitter.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  Uselib(widget)
  EnableExplicit
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global mdi_design, toolbar_design, listview_debug, text_help, tree_inspector,panel_inspector
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget
  window_ide = GetWindow(Open(OpenWindow(#PB_Any, 100,100,800,600, "ide", flag)))
  
  toolbar_design = Text(0,0,0,0,"", #__Text_Border)
  mdi_design = Text(0,0,0,0,"", #__Text_Border)
  listview_debug = Text(0,0,0,0,"", #__Text_Border)
  tree_inspector = Text(0,0,0,0,"", #__Text_Border)
  panel_inspector = Text(0,0,0,0,"", #__Text_Border)
  text_help  = Text(0,0,0,0,"", #__Text_Border)
  
  Splitter_design = Splitter(0,0,0,0, toolbar_design,mdi_design, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  Splitter_inspector = Splitter(0,0,0,0, tree_inspector,panel_inspector, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  splitter_debug = Splitter(0,0,0,0, Splitter_design,listview_debug, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  splitter_help = Splitter(0,0,0,0, Splitter_inspector,text_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  Splitter_ide = Splitter(0,0,0,0, splitter_debug,splitter_help, #__flag_autosize|#PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
;   Splitter_design = Splitter(0,0,800,600, toolbar_design,mdi_design, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
;   Splitter_inspector = Splitter(0,0,800,600, tree_inspector,panel_inspector, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
;   splitter_debug = Splitter(0,0,800,600, Splitter_design,listview_debug, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
;   splitter_help = Splitter(0,0,800,600, Splitter_inspector,text_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
;   Splitter_ide = Splitter(0,0,800,600, splitter_debug,splitter_help, #__flag_autosize|#PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
  
  If minsize
;         ; set splitter default minimum size
;     SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 10)
;     SetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 10)
;     SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 10)
;     SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 10)
;     SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
;     SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 10)
    
        ; set splitter default minimum size
    SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
    SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
    SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
   ; SetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
    SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
    SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
    SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
    ;SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  EndIf

  If state
    ; set splitters dafault positions
    ;SetState(Splitter_ide, -130)
    SetState(Splitter_ide, width(Splitter_ide)-220)
    SetState(splitter_help, height(splitter_help)-80)
    SetState(splitter_debug, height(splitter_debug)-150)
    SetState(Splitter_inspector, 200)
    SetState(Splitter_design, 30)
  EndIf
  
  ;Resize(Splitter_ide, 0,0,800,600)
  
  SetText(toolbar_design, "size: ("+Str(Width(toolbar_design))+"x"+Str(Height(toolbar_design))+") - " + Str(GetIndex( GetParent( toolbar_design ))) )
  SetText(mdi_design, "size: ("+Str(Width(mdi_design))+"x"+Str(Height(mdi_design))+") - " + Str(GetIndex( GetParent( mdi_design ))))
  SetText(listview_debug, "size: ("+Str(Width(listview_debug))+"x"+Str(Height(listview_debug))+") - " + Str(GetIndex( GetParent( listview_debug ))))
  SetText(tree_inspector, "size: ("+Str(Width(tree_inspector))+"x"+Str(Height(tree_inspector))+") - " + Str(GetIndex( GetParent( tree_inspector ))))
  SetText(panel_inspector, "size: ("+Str(Width(panel_inspector))+"x"+Str(Height(panel_inspector))+") - " + Str(GetIndex( GetParent( panel_inspector ))))
  SetText(text_help, "size: ("+Str(Width(text_help))+"x"+Str(Height(text_help))+") - " + Str(GetIndex( GetParent( text_help ))))
  
  Bind(-1,-1)
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (Windows - x64)
; Folding = -
; EnableXP
; Executable = splitter(ide).exe