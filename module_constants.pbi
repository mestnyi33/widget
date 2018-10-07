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
  
  EnumerationBinary 8
;     CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
;       #PB_Text_Right
;       #PB_Text_Center
;       #PB_Text_Border
;     CompilerElse
;       CompilerIf #PB_Compiler_Version = 560
;         #PB_Text_Center
;         #PB_Text_Right
;       CompilerElse
;         #PB_Text_Right
;         #PB_Text_Center
;       CompilerEndIf
;     CompilerEndIf
    
    #PB_Text_Bottom
    
    #PB_Text_UpperCase
    #PB_Text_LowerCase
    #PB_Text_Password
    
    #PB_Text_Middle 
    #PB_Text_MultiLine 
    
    #PB_Text_Vertical
  
  #PB_Text_ReadOnly; = 256 ; #PB_String_ReadOnly
  #PB_Text_Numeric ;= 512  ; #PB_String_Numeric
  #PB_Text_WordWrap ;= 1024; #PB_Editor_WordWrap
  EndEnumeration
  
  ;     Debug #PB_Text_Center
  ;     Debug #PB_Text_Right
  ;     Debug #PB_Text_Bottom
  ;     
  ;     Debug #PB_Text_UpperCase
  ;     Debug #PB_Text_LowerCase
  ;     Debug #PB_Text_Password
  ;     
  ;     Debug #PB_Text_Middle 
  ;     Debug #PB_Text_MultiLine 
  ;     
  ;     Debug #PB_Text_ReadOnly
  ;     Debug #PB_Text_Numeric 
  ;     Debug #PB_Text_WordWrap
  ;     Debug #PB_Text_Border
  
  #PB_Gadget_FrameColor = 10
  ;   Debug #PB_Gadget_FrontColor      ; 1
  ;   Debug #PB_Gadget_BackColor       ; 2
  ;   Debug #PB_Gadget_LineColor       ; 3
  ;   Debug #PB_Gadget_TitleFrontColor ; 4
  ;   Debug #PB_Gadget_TitleBackColor  ; 5
  ;   Debug #PB_Gadget_GrayTextColor   ; 6
  
  Enumeration
    #PB_Align_None
    #PB_Align_Right
    #PB_Align_Bottom
    #PB_Align_Center
    #PB_Align_Middle
  EndEnumeration
  
EndDeclareModule 

Module Constants
  
EndModule 

UseModule Constants
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; CursorPosition = 14
; FirstLine = 9
; Folding = -
; EnableXP