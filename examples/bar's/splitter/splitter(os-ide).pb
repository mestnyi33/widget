EnableExplicit
#__Text_Border = #PB_Text_Border
Macro IDWidget( this )
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

toolbar_design = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
mdi_design = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
listview_debug = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
tree_inspector = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
panel_inspector = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)
text_help  = TextGadget(#PB_Any,0,0,0,0,"", #__Text_Border)

Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically

Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically

Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
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
  ; SetGadgetAttribute(splitter_debug, #PB_Splitter_FirstMinimumSize, 300)
  SetGadgetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
  SetGadgetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
  SetGadgetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
  SetGadgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, 200)
  ;SetGadgetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
EndIf

If state
  ; set splitters dafault positions
  ;SetGadgetState(Splitter_ide, -130)
  SetGadgetState(Splitter_ide, GadgetWidth(Splitter_ide)-220)
  SetGadgetState(splitter_help, GadgetHeight(splitter_help)-80)
  SetGadgetState(splitter_debug, GadgetHeight(splitter_debug)-150)
  SetGadgetState(Splitter_inspector, 200)
  SetGadgetState(Splitter_design, 30)
  SetGadgetState(Splitter_5, 120)
  
  ;       SetGadgetState(Splitter_0, GadgetWidth(Splitter_0)/2-5)
  ;       SetGadgetState(Splitter_1, GadgetWidth(Splitter_1)/2-5)
  
  SetGadgetState(Splitter_1, 20)
  
EndIf

;Resize(Splitter_ide, 0,0,800,600)

SetGadgetText(toolbar_design, "size: ("+Str(GadgetWidth(toolbar_design))+"x"+Str(GadgetHeight(toolbar_design))+") - " + Str(IDWidget( GetParent( toolbar_design ))) )
SetGadgetText(mdi_design, "size: ("+Str(GadgetWidth(mdi_design))+"x"+Str(GadgetHeight(mdi_design))+") - " + Str(IDWidget( GetParent( mdi_design ))))
SetGadgetText(listview_debug, "size: ("+Str(GadgetWidth(listview_debug))+"x"+Str(GadgetHeight(listview_debug))+") - " + Str(IDWidget( GetParent( listview_debug ))))
SetGadgetText(tree_inspector, "size: ("+Str(GadgetWidth(tree_inspector))+"x"+Str(GadgetHeight(tree_inspector))+") - " + Str(IDWidget( GetParent( tree_inspector ))))
SetGadgetText(panel_inspector, "size: ("+Str(GadgetWidth(panel_inspector))+"x"+Str(GadgetHeight(panel_inspector))+") - " + Str(IDWidget( GetParent( panel_inspector ))))
SetGadgetText(text_help, "size: ("+Str(GadgetWidth(text_help))+"x"+Str(GadgetHeight(text_help))+") - " + Str(IDWidget( GetParent( text_help ))))

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 97
; FirstLine = 69
; Folding = -
; EnableXP
; DPIAware