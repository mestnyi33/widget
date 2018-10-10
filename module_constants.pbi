DeclareModule Constants
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf #PB_Compiler_Version =< 546
      #PB_EventType_Resize
    CompilerEndIf
    #PB_EventType_Free
    #PB_EventType_Create
    #PB_EventType_ScrollChange
  EndEnumeration
  
  EnumerationBinary WidgetFlags
;     #PB_Text_Center
;     #PB_Text_Right
    #PB_Text_Bottom = 4
    #PB_Text_Middle 
    
    #PB_Text_Vertical
    #PB_Text_Numeric
    
    #PB_Text_LowerCase 
    #PB_Text_UpperCase
    #PB_Text_Password
    
    #PB_Text_ReadOnly
    #PB_Text_WordWrap
    #PB_Text_MultiLine 
    
    #PB_Text_Left
    #PB_Text_Top
    
    #PB_Widget_Default
    #PB_Widget_Toggle
    
    #PB_Widget_BorderLess
    #PB_Widget_Double
    #PB_Widget_Flat
    #PB_Widget_Raised
    #PB_Widget_Single
    
    #PB_Widget_Invisible
  EndEnumeration
  
;   #PB_Text_Left = ~#PB_Text_Center
;   #PB_Text_Top = ~#PB_Text_Middle
;   
  If WidgetFlags > 2147483647
    Debug "Исчерпан лимит в x32"+WidgetFlags
  EndIf
  
  #PB_Gadget_FrameColor = 10
  
EndDeclareModule 

Module Constants
  
EndModule 

UseModule Constants
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP