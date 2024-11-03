
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  
  Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
  Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
  Global mdi_design, toolbar_design, listview_debug, text_help, tree_inspector,panel_inspector
  
  Procedure event_gadget()
    SetWindowTitle( EventWindow(), Str(GetGadgetState(EventGadget())))
  EndProcedure
  
  Procedure resize_window()
    ResizeGadget(Splitter_ide, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()), WindowHeight(EventWindow()))
  EndProcedure
  
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget
  window_ide=OpenWindow(#PB_Any, 100,100,800,600, "ide", flag)
  BindEvent(#PB_Event_SizeWindow, @resize_window())
  BindEvent( #PB_Event_Gadget, @event_gadget() )
  
  
  toolbar_design = TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border)
  mdi_design = TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border)
  listview_debug = TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border)
  tree_inspector = TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border)
  panel_inspector = TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border)
  text_help  = TextGadget(#PB_Any,0,0,0,0,"", #PB_Text_Border)
  
  Splitter_design = SplitterGadget(#PB_Any,0,0,0,0, toolbar_design,mdi_design, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  Splitter_inspector = SplitterGadget(#PB_Any,0,0,0,0, tree_inspector,panel_inspector, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
  splitter_debug = SplitterGadget(#PB_Any,0,0,0,0, Splitter_design,listview_debug, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  splitter_help = SplitterGadget(#PB_Any,0,0,0,0, Splitter_inspector,text_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
  Splitter_ide = SplitterGadget(#PB_Any,0,0,0,0, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))
   ResizeGadget(Splitter_ide, 0,0,800,600)
 
  If minsize
;     ; set splitter default minimum size
;     SetGadgetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 20)
;     SetGadgetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 10)
;     SetGadgetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 20)
;     SetGadgetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 10)
;     SetGadgetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 20)
;     SetGadgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 10)
;     SetGadgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 20)
;     SetGadgetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 10)
;     SetGadgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
;     SetGadgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 10)
    ; set splitter default minimum size
    SetGadgetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
    SetGadgetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
    SetGadgetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
    ;SetGadgetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
    SetGadgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
    SetGadgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
    SetGadgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
    SetGadgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
    ;SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  EndIf

  
  If state
    ; set splitters dafault positions
    SetGadgetState(Splitter_ide, GadgetWidth(Splitter_ide)-220)
    SetGadgetState(splitter_help, GadgetHeight(splitter_help)-80)
    SetGadgetState(splitter_debug, GadgetHeight(splitter_debug)-150)
    SetGadgetState(Splitter_inspector, 200)
    SetGadgetState(Splitter_design, 30)
  EndIf
  
  
  SetGadgetText(toolbar_design, "size: ("+Str(GadgetWidth(toolbar_design))+"x"+Str(GadgetHeight(toolbar_design))+")")
  SetGadgetText(mdi_design, "size: ("+Str(GadgetWidth(mdi_design))+"x"+Str(GadgetHeight(mdi_design))+")")
  SetGadgetText(listview_debug, "size: ("+Str(GadgetWidth(listview_debug))+"x"+Str(GadgetHeight(listview_debug))+")")
  SetGadgetText(tree_inspector, "size: ("+Str(GadgetWidth(tree_inspector))+"x"+Str(GadgetHeight(tree_inspector))+")")
  SetGadgetText(panel_inspector, "size: ("+Str(GadgetWidth(panel_inspector))+"x"+Str(GadgetHeight(panel_inspector))+")")
  SetGadgetText(text_help, "size: ("+Str(GadgetWidth(text_help))+"x"+Str(GadgetHeight(text_help))+")")
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (Windows - x64)
; CursorPosition = 24
; FirstLine = 6
; Folding = -
; EnableXP
; Executable = splitter(ide).exe