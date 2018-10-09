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
  
  EnumerationBinary
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
      ;       #PB_Text_Right = 1
      ;       #PB_Text_Center = 2
      ;       #PB_Text_Border = 4
      
      ;       #PB_String_Password = 1
      ;       #PB_String_ReadOnly = 2
      ;       #PB_String_UpperCase = 4
      
      ;       #PB_Editor_ReadOnly = 1
      ;       #PB_Editor_WordWrap = 2
      
      ;       #PB_Button_Default = 8
      
      #PB_Text_Numeric = 16      ; #PB_String_Numeric = 16
      #PB_String_BorderLess = 32
      
      #PB_Text_LowerCase ; = 8     ; #PB_String_LowerCase = 8
      #PB_Text_Password
      #PB_Text_ReadOnly
      #PB_Text_UpperCase
      #PB_Text_WordWrap
      
      #PB_Text_Vertical
      #PB_Text_Bottom
      #PB_Text_Middle 
      #PB_Text_MultiLine 
    CompilerElse
      ;       CompilerIf #PB_Compiler_Version >= 562
      ;         #PB_Text_Center = 1
      ;         #PB_Text_Right = 2
      ;       CompilerElse
      ;         #PB_Text_Right = 1
      ;         #PB_Text_Center = 2
      ;       CompilerEndIf
      
      #PB_Text_Vertical = 4
      
      #PB_Text_UpperCase = 8        ; #PB_String_UpperCase = 8
      #PB_Text_LowerCase = 16       ; #PB_String_LowerCase = 16
      #PB_Text_Password = 32        ; #PB_String_Password = 32
      
      #PB_Text_Bottom
      #PB_Text_Middle 
      #PB_Text_MultiLine 
      
      #PB_Text_ReadOnly = 2048      ; #PB_String_ReadOnly = 2048       ; #PB_Editor_ReadOnly = 2048
      #PB_Text_Numeric = 8192       ; #PB_String_Numeric = 8192
      #PB_Text_Border = 131072      ; #PB_String_BorderLess = 131072
      #PB_Text_WordWrap = 268435456 ;  #PB_Editor_WordWrap = 268435456
    CompilerEndIf
  EndEnumeration
;   Debug #PB_Button_Default
  ;   Debug #PB_Gadget_FrontColor      ; 1
  ;   Debug #PB_Gadget_BackColor       ; 2
  ;   Debug #PB_Gadget_LineColor       ; 3
  ;   Debug #PB_Gadget_TitleFrontColor ; 4
  ;   Debug #PB_Gadget_TitleBackColor  ; 5
  ;   Debug #PB_Gadget_GrayTextColor   ; 6
  #PB_Gadget_FrameColor = 10
  
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
; CursorPosition = 32
; FirstLine = 15
; Folding = -
; EnableXP