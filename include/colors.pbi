DeclareModule colors
  Structure _s_color
    grey.structures::_s_color
    grey1.structures::_s_color
    grey2.structures::_s_color
    green.structures::_s_color
    red.structures::_s_color
    blue.structures::_s_color
  EndStructure
  
  Define *this._s_color = AllocateStructure(_s_color)
  
  ;- blue - (синие цвета)
  With *this\blue                        
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    ;\state[1] = constants::#__s_front|constants::#__s_back|constants::#__s_frame
     
    ; Цвета по умолчанию
    \front[0] = $80000000
    \fore[0] = $FFF8F8F8 
    \back[0] = $80E2E2E2
    \line[0] = $80000000
    \frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[1] = $80000000
    \fore[1] = $FFFAF8F8
    \back[1] = $80FCEADA
    \frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFE9BA81;$C8FFFCFA
    \back[2] = $FFE89C3D; $80E89C3D
    \frame[2] = $FFDC9338; $80DC9338
    
    ;     ; Цвета если нажали на виджет
    ;     \front[2] = $80000000
    ;     \fore[2] = $FFFDF7EF
    ;     \back[2] = $FFFBD9B7
    ;     \frame[2] = $FFE59B55
    
    
    ; Цвета если отключили виджет
    \front[3] = $FFBABABA
    \fore[3] = $FFF6F6F6 
    \back[3] = $FFE2E2E2 
    \frame[3] = $FFCECECE
  EndWith
  
  ;- green - (зеленые цвета)
  With *this\green                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
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
    \alpha[0] = 255
    \alpha[1] = 255
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
    \alpha[0] = 255
    \alpha[1] = 255
    ;\state[1] = constants::#__s_front|constants::#__s_back|constants::#__s_frame
    
    ; Цвета по умолчанию
    \front[0] = $80000000
    \Line[0] = $80000000
    \fore[0] = $FFF6F6F6
    \back[0] = $FFE8E8E8
    \frame[0] = $FFBABABA
    
    ; Цвета если курсор на виджете
    \front[1] = $80000000
    \Line[1] = $80000000
    \fore[1] = $FFF2F2F2 
    \back[1] = $FFDCDCDC 
    \frame[1] = $FFB0B0B0 
    
    ; Цвета если нажали на виджет
    \front[2] = $80000000
    \Line[2] = $FFFEFEFE
    \fore[2] = $FFE2E2E2
    \back[2] = $FFB4B4B4
    \frame[2] = $FF6F6F6F
    
    ; Цвета если отключили виджет
    \front[3] = $FFBABABA
    \Line[3] = $FFBABABA
    \fore[3] = $FFF6F6F6 
    \back[3] = $FFE2E2E2 
    \frame[3] = $FFCECECE
  EndWith
  
  
  ;- grey1 - (серые цвета)
  With *this\grey1                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    ;\state[1] = constants::#__s_front|constants::#__s_back|constants::#__s_frame
    
    ; Цвета по умолчанию
    \front[0] = $FF5B5B5B
    \Fore[0] = $FFF6F6F6 
    \Frame[0] = $FFBABABA
    \Back[0] = $FFE2E2E2;$F0F0F0 
    
    ; Цвета если курсор на виджете
    \front[1] = $FF5B5B5B
    \Fore[1] = $FFEAEAEA
    \Back[1] = $FFCECECE
    \Frame[1] = $FF8F8F8F
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFFFFFF
    \Fore[2] = $FFE2E2E2
    \Back[2] = $FFB4B4B4
    \Frame[2] = $FF6F6F6F
    
    ; Цвета если отключили виджет
    \front[3] = $FFBABABA
    \fore[3] = $FFF6F6F6 
    \back[3] = $FFE2E2E2 
    \frame[3] = $FFCECECE
 EndWith
 
 ;
  ;- grey2 - (серые цвета)
  With *this\grey2                         
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    ;\state[1] = constants::#__s_front|constants::#__s_back|constants::#__s_frame
    
    ; - Серые цвета
    ; Цвета по умолчанию
    \front[0] = $80000000
    \fore[0] = $FFF6F6F6
    \back[0] = $FFE8E8E8
    \frame[0] = $FFBABABA
    
    ; Цвета если курсор на виджете
    \front[1] = $80000000
    \fore[1] = $FFF2F2F2 
    \back[1] = $FFDCDCDC 
    \frame[1] = $FFB0B0B0 
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFE2E2E2
    \back[2] = $FFB4B4B4
    \frame[2] = $FF6F6F6F
    
    ;     ;- Серые цвета 
    ;         ; Цвета по умолчанию
    ;         \front[0] = $FF000000
    ;         \fore[0] = $FFFCFCFC ; $FFF6F6F6 
    ;         \back[0] = $FFE2E2E2 ; $FFE8E8E8 ; 
    ;         \line[0] = $FFA3A3A3
    ;         \frame[0] = $FFA5A5A5 ; $FFBABABA
    ;         
    ;         ; Цвета если мышь на виджете
    ;         \front[1] = $FF000000
    ;         \fore[1] = $FFF5F5F5 ; $FFF5F5F5 ; $FFEAEAEA
    ;         \back[1] = $FFEAEAEA ; $FFCECECE ; 
    ;         \line[1] = $FF5B5B5B
    ;         \frame[1] = $FFCECECE ; $FF8F8F8F
    ;         
    ;         ; Цвета если нажали на виджет
    ;         \front[2] = $FFFFFFFF
    ;         \fore[2] = $FFE2E2E2
    ;         \back[2] = $FFB4B4B4
    ;         \line[2] = $FFFFFFFF
    ;         \frame[2] = $FF6F6F6F
    
    ;     ;- Зеленые цвета
    ;                 ; Цвета по умолчанию
    ;                 \front[0] = $FF000000
    ;                 \fore[0] = $FFFFFFFF
    ;                 \back[0] = $FFDAFCE1  
    ;                 \frame[0] = $FF6AFF70 
    ;                 
    ;                 ; Цвета если мышь на виджете
    ;                 \front[1] = $FF000000
    ;                 \fore[1] = $FFE7FFEC
    ;                 \back[1] = $FFBCFFC5
    ;                 \frame[1] = $FF46E064 ; $FF51AB50
    ;                 
    ;                 ; Цвета если нажали на виджет
    ;                 \front[2] = $FFFEFEFE
    ;                 \fore[2] = $FFC3FDB7
    ;                 \back[2] = $FF00B002
    ;                 \frame[2] = $FF23BE03
    
    ; Цвета если отключили виджет
    \front[3] = $FFBABABA
    \fore[3] = $FFF6F6F6 
    \back[3] = $FFE2E2E2 
    \frame[3] = $FFCECECE
  EndWith
  
  
  
EndDeclareModule

Module colors
EndModule
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP