DeclareModule colors
  Structure _s_color
    grey.structures::_s_color
    green.structures::_s_color
    red.structures::_s_color
    blue.structures::_s_color
    black.structures::_s_color
  EndStructure
  
  Define *this._s_color = AllocateStructure(_s_color)
  
  ;- blue - (синие цвета)
  With *this\blue                        
    \state = 0
    \_alpha = 255
     
    ; Цвета по умолчанию
    \front[0] = $ff000001
    \fore[0] = $ffF8F8F8 
    \back[0] = $ffE2E2E2
    \frame[0] = $DE777D7E ; $ffC8C8C8 ; 
    
    ; Цвета если мышь на виджете
    \front[1] = $ff000000
    \fore[1] = $FFFAF8F8
    \back[1] = $ffFCEADA ; RGBA(218, 234, 252, 255)
    \frame[1] = $ffFFC288 ; RGBA(135, 194, 255, 255)
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFE9BA81;$C8FFFCFA
    \back[2] = $FFE89C3D; $80E89C3D ; RGBA(60, 155, 232, 128)
    \frame[2] = $FFDC9338; $80DC9338
    
    ;     ; Цвета если нажали на виджет
    ;     \front[2] = $80000000
    ;     \fore[2] = $FFFDF7EF
    ;     \back[2] = $FFFBD9B7
    ;     \frame[2] = $FFE59B55
    
    
    ; Цвета если отключили виджет
    \front[3] = $FFBABABA
    \fore[3] = $FFF6F6F6 
    \back[3] = $FFE2E2E2 ; RGBA(226, 226, 226, 255)
    \frame[3] = $FFCECECE ; RGBA(206, 206, 206, 255)
  EndWith
  
  ;- green - (зеленые цвета)
  With *this\green                          
    \state = 0
    \_alpha = 255
    
    ;\state[1] = constants::#__s_front|constants::#__s_back|constants::#__s_frame
    
    ; Цвета по умолчанию
    \front[0] = $FF000000
    \fore[0] = $FFFFFFFF
    \back[0] = $FFDAFCE1  
    \frame[0] = $FF6AFF70 
    
    ; Цвета если мышь на виджете
    \front[1] = $FF000000
    \fore[1] = $FFE7FFEC
    \back[1] = $FFBCFFC5
    \frame[1] = $FF46E064 ; $FF51AB50
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFC3FDB7
    \back[2] = $FF00B002
    \frame[2] = $FF23BE03
    
    ; Цвета если отключили виджет
    \front[3] = $FFBABABA
    \fore[3] = $FFFFFFFF
    \back[3] = $FFDAFCE1  
    \frame[3] = $CA6AFF70 
  EndWith
  
  ;- red - (красные цвета)
  With *this\red                          
    \state = 0
    \_alpha = 255
    
    ;\state[1] = constants::#__s_front|constants::#__s_back|constants::#__s_frame
    
    ; Цвета по умолчанию
    \front[0] = $FF000000
    \fore[0] = $FFFFFFFF
    \back[0] = $FFB4B4E1  
    \frame[0] = $FF7878E1 
    
    ; Цвета если мышь на виджете
    \front[1] = $FF000000
    \fore[1] = $FFE7FFEC
    \back[1] = $FF9696E1
    \frame[1] = $FF4646E1 ; $FF51AB50
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFC3FDB7
    \back[2] = $FF5F5EEE
    \frame[2] = $FF3333F0
    
    ; Цвета если отключили виджет
    \front[3] = $FFBABABA
    \fore[3] = $FFFFFFFF
    \back[3] = $FFDAFCE1  
    \frame[3] = $CA6AFF70 
  EndWith
  
  ;-
  ;- grey - (серые цвета)
  With *this\grey                          
    \state = 0
    \_alpha = 255
    
    ;\state[1] = constants::#__s_front|constants::#__s_back|constants::#__s_frame
    
    ; Цвета по умолчанию
    \front[0] = $ff000000
    \fore[0] = $FFF6F6F6
    \back[0] = $FFE8E8E8
    \frame[0] = $FFBABABA
    
    ; Цвета если курсор на виджете
    \front[1] = $ff000000
    \fore[1] = $FFF2F2F2 
    \back[1] = $FFDCDCDC 
    \frame[1] = $FFB0B0B0 
    
    ; Цвета если нажали на виджет
    \front[2] = $ff000000
    \fore[2] = $FFE2E2E2
    \back[2] = $FFB4B4B4
    \frame[2] = $FF6F6F6F
    
    ; Цвета если отключили виджет
    \front[3] = $FFBABABA
    \fore[3] = $FFF6F6F6 
    \back[3] = $FFE2E2E2 
    \frame[3] = $FFCECECE
  EndWith
  ;-
  ;- Black - (черные цвета)
  With *this\black                          
    \state = 0
    \_alpha = 255
    
    ;\state[1] = constants::#__s_front|constants::#__s_back|constants::#__s_frame
    
    ; Цвета по умолчанию
    \front[0] = $ff000000
    \fore[0] = $FFF6F6F6
    \back[0] = $FFE8E8E8
    \frame[0] = $FFBABABA
    
    ; Цвета если курсор на виджете
    \front[1] = $ff000000
    \fore[1] = $FFF2F2F2 
    \back[1] = $FFDCDCDC 
    \frame[1] = $FFB0B0B0 
    
    ; Цвета если нажали на виджет
    \front[2] = $ff000000
    \fore[2] = $FFE2E2E2
    \back[2] = $FFB4B4B4
    \frame[2] = $FF6F6F6F
    
    ; Цвета если отключили виджет
    \front[3] = $FFBABABA
    \fore[3] = $FFF6F6F6 
    \back[3] = $FFE2E2E2 
    \frame[3] = $FFCECECE
  EndWith
  
EndDeclareModule

Module colors
EndModule
; CompilerSelect #PB_Compiler_OS
;   CompilerCase #PB_OS_Windows
;     CanvasEx()\Scrollbar\Color\Front  = GetSysColor_(#COLOR_SCROLLBAR)
;     CanvasEx()\Scrollbar\Color\Button = GetSysColor_(#COLOR_BTNFACE)
;     CanvasEx()\Scrollbar\Color\Focus  = GetSysColor_(#COLOR_MENUHILIGHT)
;     CanvasEx()\Scrollbar\Color\Hover  = GetSysColor_(#COLOR_ACTIVEBORDER)
;     CanvasEx()\Scrollbar\Color\Arrow  = GetSysColor_(#COLOR_GRAYTEXT)
;     CanvasEx()\Scrollbar\Color\Back   = GetSysColor_(#COLOR_MENU)
;     CanvasEx()\Color\Gadget           = GetSysColor_(#COLOR_MENU)
;   CompilerCase #PB_OS_MacOS
;     CanvasEx()\Scrollbar\Color\Front  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
;     CanvasEx()\Scrollbar\Color\Button = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor windowBackgroundColor"))
;     CanvasEx()\Scrollbar\Color\Focus  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor selectedControlColor"))
;     CanvasEx()\Scrollbar\Color\Hover  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
;     CanvasEx()\Scrollbar\Color\Arrow  = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor grayColor"))
;     CanvasEx()\Scrollbar\Color\Back   = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor windowBackgroundColor"))
;     CanvasEx()\Color\Gadget           = OSX_NSColorToRGB(CocoaMessage(0, 0, "NSColor windowBackgroundColor"))
;   CompilerCase #PB_OS_Linux
;     
; CompilerEndSelect

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 20
; FirstLine = 9
; Folding = -
; EnableXP