XIncludeFile "../../widgets.pbi"

EnableExplicit
Uselib(widget)

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   Macro TreeGadget(_gadget_, X,Y,Width,Height, Flags=0)
      widget::Gadget(#PB_GadgetType_Tree, _gadget_, X,Y,Width,Height, Flags) ; : CloseGadgetList()
    EndMacro
    
    Macro AddGadgetItem(_gadget_, _position_, _text_, _image_id_=0, Flag=0)
      widget::AddItem(GetGadgetData(_gadget_), _position_, _text_, _image_id_, Flag)
    EndMacro
    
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  Procedure ev()
    Debug ""+Widget() ;+" "+ Type() +" "+ Item() +" "+ Data()     ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  Procedure ev2()
    ;Debug "  "+Widget() +" "+ Type() +" "+ Item() +" "+ Data()   ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 605+30, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    Open(0)
    
;     Define i,*g = Tree(50, 100, 210, 210, #__tree_CheckBoxes|#__tree_NoLines|#__tree_NoButtons|#__tree_GridLines | #__tree_ThreeState | #__tree_OptionBoxes)                            
;     
;     ;  2_example
;     AddItem (*g, 0, "Tree_0 (NoLines | NoButtons | NoSublavel)", 0)                                    
;     For i=1 To 20
;       If i=5 ;Or i%3=0
;         AddItem(*g, -1, "Tree_"+Str(i), -1, 0) 
;       Else
;         AddItem(*g, -1, "Tree_"+Str(i), 0, -1) 
;       EndIf
;     Next
;     ;For i=0 To CountItems(*g) : SetItemState(*g, i, #__tree_Expanded) : Next
;     SetItemState(*g, 0, #__tree_Selected|#__tree_Checked)
;     SetItemState(*g, 5, #__tree_Selected|#__tree_Inbetween)
;     
;     LoadFont(5, "Arial", 16)
;     SetItemFont(*g, 3, 5)
;     SetItemText(*g, 3, "16_font and text change")
;     SetItemColor(*g, 5, #__color_front, $FFFFFF00)
;     SetItemColor(*g, 5, #__color_back, $FFFF00FF)
;     SetItemText(*g, 5, "backcolor and text change")
;     
;     LoadFont(6, "Arial", 25)
;     SetItemFont(*g, 4, 6)
;     SetItemText(*g, 4, "25_font and text change")
;     SetItemFont(*g, 14, 6)
;     SetItemText(*g, 14, "25_font and text change")
;     ;;Bind(*g, @events_tree_widget())
    
    
    Define g = TreeGadget(#PB_Any, 30,30,180,180)
    
    AddGadgetItem(g, -1, "index_0_level_0")
    AddGadgetItem(g, -1, "index_1_sublevel_1", 0, 1)
    AddGadgetItem(g, -1, "index_2_sublevel_2", 0, 2)
    AddGadgetItem(g, -1, "index_3_level_0")
    AddGadgetItem(g, -1, "index_4_sublevel_1", 0, 1)
    AddGadgetItem(g, -1, "index_5_sublevel_2", 0, 2)
    AddGadgetItem(g, -1, "Form_0")
    AddGadgetItem(g, -1, "Form_0")
    AddGadgetItem(g, -1, "Form_0")
    AddGadgetItem(g, -1, "Form_0")
    AddGadgetItem(g, -1, "Form_0")
    ;SetItemColor(Button_1,  #PB_All, #__Color_Line,  $FF00f000)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (Windows - x86)
; FirstLine = 48
; Folding = --
; EnableXP