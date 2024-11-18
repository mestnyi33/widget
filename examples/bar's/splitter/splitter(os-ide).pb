EnableExplicit
#__flag_TextBorder = #PB_Text_Border
Macro GetIndex( this )
  MacroExpandedCount
EndMacro
Procedure.l GetParent( *this )
  ;  ProcedureReturn *this\index - 1
EndProcedure

Global window_ide, canvas_ide, fixed=1, state=1, minsize=1
Global Splitter_ide, Splitter_design, splitter_debug, Splitter_inspector, splitter_help
Global mdi_design, toolbar_design, listview_debug, text_help, tree_inspector,panel_inspector
Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4, Splitter_5

Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget
window_ide = OpenWindow(#PB_Any, 100,100,800,600, "ide", flag)

toolbar_design = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
mdi_design = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
listview_debug = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
tree_inspector = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
panel_inspector = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)
text_help  = TextGadget(#PB_Any,0,0,0,0,"", #__flag_TextBorder)

Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically

Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically

Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
SetGadGetWidgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
SetGadGetWidgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
Splitter_4 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
Splitter_5 = SplitterGadget(#PB_Any, 0, 0, 0, 0, mdi_design, Splitter_4, #PB_Splitter_Vertical|#PB_Splitter_Separator)


Splitter_design = SplitterGadget(#PB_Any,0,0,0,0, toolbar_design,Splitter_5, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
Splitter_inspector = SplitterGadget(#PB_Any,0,0,0,0, tree_inspector,panel_inspector, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_FirstFixed))
splitter_debug = SplitterGadget(#PB_Any,0,0,0,0, Splitter_design,listview_debug, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
splitter_help = SplitterGadget(#PB_Any,0,0,0,0, Splitter_inspector,text_help, #PB_Splitter_Separator|(Bool(fixed)*#PB_Splitter_SecondFixed))
Splitter_ide = SplitterGadget(#PB_Any,0,0,800,600, splitter_debug,splitter_help, #PB_Splitter_Separator|#PB_Splitter_Vertical|(Bool(fixed)*#PB_Splitter_SecondFixed))

If minsize
  ;         ; set splitter default minimum size
  ;     SetGadGetWidgetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 20)
  ;     SetGadGetWidgetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 10)
  ;     SetGadGetWidgetAttribute(splitter_help, #PB_Splitter_FirstMinimumSize, 20)
  ;     SetGadGetWidgetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 10)
  ;     SetGadGetWidgetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 20)
  ;     SetGadGetWidgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 10)
  ;     SetGadGetWidgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 20)
  ;     SetGadGetWidgetAttribute(Splitter_inspector, #PB_Splitter_SecondMinimumSize, 10)
  ;     SetGadGetWidgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
  ;     SetGadGetWidgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 10)
  
  ; set splitter default minimum size
  SetGadGetWidgetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
  SetGadGetWidgetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
  SetGadGetWidgetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
  ; SetGadGetWidgetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
  SetGadGetWidgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
  SetGadGetWidgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
  SetGadGetWidgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
  SetGadGetWidgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
  ;SetGadGetWidgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
EndIf

If state
  ; set splitters dafault positions
  ;SetGadGetWidgetState(Splitter_ide, -130)
  SetGadGetWidgetState(Splitter_ide, GadgetWidth(Splitter_ide)-220)
  SetGadGetWidgetState(splitter_help, GadgetHeight(splitter_help)-80)
  SetGadGetWidgetState(splitter_debug, GadgetHeight(splitter_debug)-150)
  SetGadGetWidgetState(Splitter_inspector, 200)
  SetGadGetWidgetState(Splitter_design, 30)
  SetGadGetWidgetState(Splitter_5, 120)
  
  ;       ; bug fixed
  ;       SetGadGetWidgetState(Splitter_0, GadgetWidth(Splitter_0)/2-5)
  ;       SetGadGetWidgetState(Splitter_1, GadgetWidth(Splitter_1)/2-5)
  
  SetGadGetWidgetState(Splitter_1, 20)
  
EndIf

;ResizeWidget(Splitter_ide, 0,0,800,600)

SetGadGetWidgetText(toolbar_design, "size: ("+Str(GadgetWidth(toolbar_design))+"x"+Str(GadgetHeight(toolbar_design))+") - " + Str(GetIndex( GetParent( toolbar_design ))) )
SetGadGetWidgetText(mdi_design, "size: ("+Str(GadgetWidth(mdi_design))+"x"+Str(GadgetHeight(mdi_design))+") - " + Str(GetIndex( GetParent( mdi_design ))))
SetGadGetWidgetText(listview_debug, "size: ("+Str(GadgetWidth(listview_debug))+"x"+Str(GadgetHeight(listview_debug))+") - " + Str(GetIndex( GetParent( listview_debug ))))
SetGadGetWidgetText(tree_inspector, "size: ("+Str(GadgetWidth(tree_inspector))+"x"+Str(GadgetHeight(tree_inspector))+") - " + Str(GetIndex( GetParent( tree_inspector ))))
SetGadGetWidgetText(panel_inspector, "size: ("+Str(GadgetWidth(panel_inspector))+"x"+Str(GadgetHeight(panel_inspector))+") - " + Str(GetIndex( GetParent( panel_inspector ))))
SetGadGetWidgetText(text_help, "size: ("+Str(GadgetWidth(text_help))+"x"+Str(GadgetHeight(text_help))+") - " + Str(GetIndex( GetParent( text_help ))))

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.12 LTS (Linux - x64)
; CursorPosition = 22
; Folding = -
; Optimizer
; EnableXP
; DPIAware