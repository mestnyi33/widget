
XIncludeFile "../../../widgets.pbi"

;-
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  
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
  
  
  
  
  If Open(0, 0, 0, 605+30, 560, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Define Value 
    Value = Button(30,30, 100, 30, "button_0")
    String(30,30*2, 100, 30, "string_0")
    CheckBox(30,30*3, 100, 30, "checkbox_0")
    
    Define *Tree = widget::Tree_Properties(10, 10, 250, 200, #__flag_gridlines);|#__tree_nolines);, #__flag_autosize) 
    widget::AddItem(*Tree, #_pi_group_0, "common")
    widget::AddItem(*Tree, #_pi_id, "id:"+Chr(10)+Str(Value), #__type_String, 1)
    widget::AddItem(*Tree, #_pi_class, "class:"+Chr(10)+GetClass(Value)+"_"+GetTypeCount(Value), #__type_String, 1)
    widget::AddItem(*Tree, #_pi_text, "text:"+Chr(10)+GetText(Value), #__type_String, 1)
    
    widget::AddItem(*Tree, #_pi_group_1, "layout")
    widget::AddItem(*Tree, #_pi_x, "x:"+Chr(10)+Str(WidgetX(Value)), #__type_Spin, 1)
    widget::AddItem(*Tree, #_pi_y, "y:"+Chr(10)+Str(WidgetY(Value)), #__type_Spin, 1)
    widget::AddItem(*Tree, #_pi_width, "width:"+Chr(10)+Str(WidgetWidth(Value)), #__type_Spin, 1)
    widget::AddItem(*Tree, #_pi_height, "height:"+Chr(10)+Str(WidgetHeight(Value)), #__type_Spin, 1)
    
    widget::AddItem(*Tree, #_pi_group_2, "state")
    widget::AddItem(*Tree, #_pi_disable, "disable:"+Chr(10)+"", #__type_ComboBox, 1);Str(Disable(Value)))
    widget::AddItem(*Tree, #_pi_hide, "hide:"+Chr(10)+Str(Hide(Value)), #__type_ComboBox, 1)
    
    ;;;SetAttribute(*Tree, #__Transformation, #PB_All)
    Define vert=20, horiz=60, width=400, height=500
    Splitter_0 = widget::Splitter(0, 0, 0, 0, Button_1, *Tree, #PB_Splitter_FirstFixed)
    Splitter_1 = widget::Splitter(0, 0, 0, 0, Button_2, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
    Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, Button_3, #PB_Splitter_SecondFixed)
    Splitter_3 = widget::Splitter(200, 30, width, height, Splitter_2, Button_4, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    SetState(Splitter_3, width-40-horiz)
    SetState(Splitter_2, height-40-vert)
    SetState(Splitter_0, vert)
    SetState(Splitter_1, horiz)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 49
; FirstLine = 45
; Folding = -
; Optimizer
; EnableXP
; DPIAware