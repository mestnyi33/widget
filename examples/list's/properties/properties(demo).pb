XIncludeFile "../../../widgets.pbi"
UseWidgets( )

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
  
  
  Define cr.s = #LF$, Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *w, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  
  
  
  If Open(0, 0, 0, 605+30, 140+200+140+140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define *prop = widget::Properties(10, 10, 250, 200);, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
    Define Value = *prop
    widget::AddItem(*prop, #_pi_group_0, "common")
    widget::AddItem(*prop, #_pi_id, "id:"+Chr(10)+Str(Value), #__type_String, 1)
    widget::AddItem(*prop, #_pi_class, "class:"+Chr(10)+GetClass(Value), #__type_String, 1)
    widget::AddItem(*prop, #_pi_text, "text:"+Chr(10)+GetText(Value), #__type_String, 1)
    
    widget::AddItem(*prop, #_pi_group_1, "layout")
    widget::AddItem(*prop, #_pi_x, "x:"+Chr(10)+Str(X(Value)), #__type_Spin, 1)
    widget::AddItem(*prop, #_pi_y, "y:"+Chr(10)+Str(Y(Value)), #__type_Spin, 1)
    widget::AddItem(*prop, #_pi_width, "width:"+Chr(10)+Str(Width(Value)), #__type_Spin, 1)
    widget::AddItem(*prop, #_pi_height, "height:"+Chr(10)+Str(Height(Value)), #__type_Spin, 1)
    
    widget::AddItem(*prop, #_pi_group_2, "state")
    widget::AddItem(*prop, #_pi_disable, "disable:"+Chr(10)+"", #__type_ComboBox, 1);Str(Disable(Value)))
    widget::AddItem(*prop, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)), #__type_ComboBox, 1)
    
    Define *prop1 = widget::Properties(10, 10, 250, 200, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
    Define Value = *prop1
    widget::AddItem(*prop1, #_pi_group_0, "common")
    widget::AddItem(*prop1, #_pi_id, "id:"+Chr(10)+Str(Value), #__type_String, 1)
    widget::AddItem(*prop1, #_pi_class, "class:"+Chr(10)+GetClass(Value), #__type_String, 1)
    widget::AddItem(*prop1, #_pi_text, "text:"+Chr(10)+GetText(Value), #__type_String, 1)
    
    widget::AddItem(*prop1, #_pi_group_1, "layout")
    widget::AddItem(*prop1, #_pi_x, "x:"+Chr(10)+Str(X(Value)), #__type_Spin, 1)
    widget::AddItem(*prop1, #_pi_y, "y:"+Chr(10)+Str(Y(Value)), #__type_Spin, 1)
    widget::AddItem(*prop1, #_pi_width, "width:"+Chr(10)+Str(Width(Value)), #__type_Spin, 1)
    widget::AddItem(*prop1, #_pi_height, "height:"+Chr(10)+Str(Height(Value)), #__type_Spin, 1)
    
    widget::AddItem(*prop1, #_pi_group_2, "state")
    widget::AddItem(*prop1, #_pi_disable, "disable:"+Chr(10)+"", #__type_ComboBox, 1);Str(Disable(Value)))
    widget::AddItem(*prop1, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)), #__type_ComboBox, 1)
    
    Splitter_0 = widget::Splitter(0, 0, 300, 300, Button_1, *prop)
    Splitter_1 = widget::Splitter(30, 30, 300, 300, Splitter_0, *prop1, #PB_Splitter_Vertical)
    
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 53
; FirstLine = 33
; Folding = -
; Optimizer
; EnableXP
; DPIAware