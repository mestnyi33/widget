XIncludeFile "../../widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  Uselib(widget)
  
  Global window_ide, canvas_ide
  
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global mdi_design, toolbar_design, listview_debug, text_help, tree_inspector,panel_inspector
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget
  Define root = Open(OpenWindow(#PB_Any, 100,100,800,600, "ide", flag))
  window_ide = GetWindow(root)
  canvas_ide = GetGadget(root)
  
  toolbar_design = 0
  mdi_design = 0
  listview_debug = 0
  tree_inspector = 0
  listview_debug = 0
  panel_inspector = 0
  text_help  = 0
  
  
  Splitter_design = Splitter(0,0,0,0, toolbar_design,mdi_design, #PB_Splitter_FirstFixed|#PB_Splitter_Separator)
  Splitter_inspector = Splitter(0,0,0,0, tree_inspector,panel_inspector, #PB_Splitter_FirstFixed)
  splitter_debug = Splitter(0,0,0,0, Splitter_design,listview_debug, #PB_Splitter_SecondFixed)
  splitter_help = Splitter(0,0,0,0, Splitter_inspector,text_help, #PB_Splitter_SecondFixed)
  Splitter_ide = Splitter(0,0,0,0, splitter_debug,splitter_help, #__flag_autosize|#PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
  
  ; set splitter default minimum size
  SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
  SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
  SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
  SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
  SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
  SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
  ;SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  
  ; set splitters dafault positions
  SetState(Splitter_ide, width(Splitter_ide)-220)
  SetState(splitter_help, height(splitter_help)-80)
  SetState(splitter_debug, height(splitter_debug)-150)
  SetState(Splitter_inspector, 200)
  SetState(Splitter_design, 30)
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP