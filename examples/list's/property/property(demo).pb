XIncludeFile "../../../widgets.pbi"
Uselib(widget)

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  ;- 
  Enumeration 
    #_pi_group_0 
    #_pi_id
    #_pi_class
    #_pi_text
    
    #_pi_group_1 
    #_pi_x
    #_pi_y
    #_pi_width
    #_pi_height
    
    #_pi_group_2 
    #_pi_disable
    #_pi_hide
  EndEnumeration
  
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *w, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  
  
  
  If Open(OpenWindow(#PB_Any, 0, 0, 605+30, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    Define *Tree = widget::Tree_Properties(10, 10, 250, 200);, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
    Define Value = *Tree
    widget::AddItem(*Tree, #_pi_group_0, "common")
    widget::AddItem(*Tree, #_pi_id, "id:"+Chr(10)+Str(Value), #PB_GadgetType_String, 1)
    widget::AddItem(*Tree, #_pi_class, "class:"+Chr(10)+GetClass(Value)+"_"+GetTypeCount(Value), #PB_GadgetType_String, 1)
    widget::AddItem(*Tree, #_pi_text, "text:"+Chr(10)+GetText(Value), #PB_GadgetType_String, 1)
    
    widget::AddItem(*Tree, #_pi_group_1, "layout")
    widget::AddItem(*Tree, #_pi_x, "x:"+Chr(10)+Str(X(Value)), #PB_GadgetType_Spin, 1)
    widget::AddItem(*Tree, #_pi_y, "y:"+Chr(10)+Str(Y(Value)), #PB_GadgetType_Spin, 1)
    widget::AddItem(*Tree, #_pi_width, "width:"+Chr(10)+Str(Width(Value)), #PB_GadgetType_Spin, 1)
    widget::AddItem(*Tree, #_pi_height, "height:"+Chr(10)+Str(Height(Value)), #PB_GadgetType_Spin, 1)
    
    widget::AddItem(*Tree, #_pi_group_2, "state")
    widget::AddItem(*Tree, #_pi_disable, "disable:"+Chr(10)+"", #PB_GadgetType_ComboBox, 1);Str(Disable(Value)))
    widget::AddItem(*Tree, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)), #PB_GadgetType_ComboBox, 1)
    
    Define *Tree1 = widget::Tree_Properties(10, 10, 250, 200, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
    Define Value = *Tree1
    widget::AddItem(*Tree1, #_pi_group_0, "common")
    widget::AddItem(*Tree1, #_pi_id, "id:"+Chr(10)+Str(Value), #PB_GadgetType_String, 1)
    widget::AddItem(*Tree1, #_pi_class, "class:"+Chr(10)+GetClass(Value)+"_"+GetTypeCount(Value), #PB_GadgetType_String, 1)
    widget::AddItem(*Tree1, #_pi_text, "text:"+Chr(10)+GetText(Value), #PB_GadgetType_String, 1)
    
    widget::AddItem(*Tree1, #_pi_group_1, "layout")
    widget::AddItem(*Tree1, #_pi_x, "x:"+Chr(10)+Str(X(Value)), #PB_GadgetType_Spin, 1)
    widget::AddItem(*Tree1, #_pi_y, "y:"+Chr(10)+Str(Y(Value)), #PB_GadgetType_Spin, 1)
    widget::AddItem(*Tree1, #_pi_width, "width:"+Chr(10)+Str(Width(Value)), #PB_GadgetType_Spin, 1)
    widget::AddItem(*Tree1, #_pi_height, "height:"+Chr(10)+Str(Height(Value)), #PB_GadgetType_Spin, 1)
    
    widget::AddItem(*Tree1, #_pi_group_2, "state")
    widget::AddItem(*Tree1, #_pi_disable, "disable:"+Chr(10)+"", #PB_GadgetType_ComboBox, 1);Str(Disable(Value)))
    widget::AddItem(*Tree1, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)), #PB_GadgetType_ComboBox, 1)
    
    Splitter_0 = widget::Splitter(0, 0, 300, 300, Button_1, *Tree)
    Splitter_1 = widget::Splitter(30, 30, 300, 300, Splitter_0, *Tree1, #PB_Splitter_Vertical)
    
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 53
; FirstLine = 34
; Folding = -
; EnableXP