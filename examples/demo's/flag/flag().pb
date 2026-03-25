Structure Widget
  ; Выделяем массив байт. 32 байта = 256 флагов (0-255)
  flags.a[32] 
EndStructure

; --- Набор макросов для работы с битовым массивом ---

; 1. Включить бит (номер n)
Macro SetFlag_(obj, n)
  obj\flags[n >> 3] | (1 << (n & 7))
EndMacro

; 2. Выключить бит (номер n)
Macro ClearFlag_(obj, n)
  obj\flags[n >> 3] & ~(1 << (n & 7))
EndMacro

; 3. Переключить бит (был 0 станет 1, и наоборот)
Macro ToggleFlag_(obj, n)
  obj\flags[n >> 3] ! (1 << (n & 7))
EndMacro

; 4. Проверить бит (вернет > 0 если включен, 0 если выключен)
Macro GetFlag_(obj, n)
  (obj\flags[n >> 3] & (1 << (n & 7)))
EndMacro

; --- ПРОВЕРКА ---

Define Widget.Widget

; Включаем 150-й флаг (который далеко за пределами .q)
SetFlag_(Widget, 150)

If GetFlag_(Widget, 150)
  Debug "150-й флаг включен!"
EndIf

; Выключаем его
ClearFlag_(Widget, 150)

If GetFlag_(Widget, 150) = 0
  Debug "150-й флаг теперь выключен."
EndIf
; 
; IncludePath "../../../"
; XIncludeFile "widgets.pbi"
; EnableExplicit
; UseWidgets( )
; 
; 
; 
; 
; Macro IsFlag( _flags_, _flag_ )
;   Bool(((_flags_) & _flag_) = _flag_)
; EndMacro
; 
; Macro RemoveFlag( _flags_, _flag_ )
;   Define i
;   For i = 0 To 63
;     If IsFlag(_flag_, (1<<i))
;       _flags_ &~ (1<<i)
;     EndIf
;   Next i
; EndMacro
; 
; Macro AddFlag( _flags_, _flag_ )
;   Define i
;   If Not _flags_ & _flag_
;     For i = 0 To 63
;       If IsFlag(_flag_, (1<<i))
;         _flags_ | (1<<i)
;       EndIf
;     Next i
;   EndIf
; EndMacro
; 
; Procedure SetFlag( *this._s_WIDGET, Flag.q )
;   If Not *this\flag & Flag
;     *this\flag | Flag
;     ProcedureReturn #True
;   EndIf
; EndProcedure
; 
; Procedure GetFlag( *this._s_WIDGET )
;   ProcedureReturn *this\flag
; EndProcedure
; 
; 
; Define Flag.q = #__flag_Textleft|#__flag_TextTop|#__flag_TextRight;|#__flag_TextBottom
; 
; Define flags.q = #__flag_TextBottom | Flag
; 
; ;RemoveFlag( )
; RemoveFlag( flags, #__flag_TextTop|#__flag_TextRight )
; 
; Debug constants::BinaryFlag( Flag, #__flag_Textleft )
; Debug constants::BinaryFlag( Flag, #__flag_TextTop )
; Debug constants::BinaryFlag( Flag, #__flag_TextRight )
; Debug constants::BinaryFlag( Flag, #__flag_TextBottom )
; Debug ""
; Debug constants::BinaryFlag( flags, #__flag_Textleft )
; Debug constants::BinaryFlag( flags, #__flag_TextTop )
; Debug constants::BinaryFlag( flags, #__flag_TextRight )
; Debug constants::BinaryFlag( flags, #__flag_TextBottom )
; 
; 
; 
; 
; Procedure Flag_Text( *this._s_WIDGET, Flag.q )
;   ;                           windows ; macos ; linux
;   ;   Debug  #PB_Text_Center ; 1      ;               ; The text is centered in the gadget.
;   ;   Debug  #PB_Text_Right  ; 2      ;               ; The text is right aligned.
;   ;   Debug  #PB_Text_Border ; 131072 ;               ; A sunken border is drawn around the gadget.
;   ;   
;   
;   If *this\type = #__type_Text
;     If constants::BinaryFlag( Flag, #__flag_TextInvert )
;       *this\text\invert = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #__flag_TextVertical )
;       *this\text\vertical = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #__flag_Textwordwrap )
;       *this\text\multiline = - 1
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #__flag_Textmultiline )
;       *this\mode\multiSelect = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #__flag_TextCenter )
;       *this\text\align\left = #False
;       *this\text\align\top = #False
;       *this\text\align\right = #False
;       *this\text\align\bottom = #False
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #__flag_Textleft )
;       *this\text\align\left = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #__flag_TextTop )
;       *this\text\align\top = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #__flag_TextRight )
;       *this\text\align\right = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #__flag_TextBottom )
;       *this\text\align\bottom = #True
;     EndIf
;   EndIf
; EndProcedure
; 
; Procedure Flag_Button( *this._s_WIDGET, Flag.q )
;   ;                                  windows ; macos ; linux
;   ;   Debug  #PB_Button_Default      ; 1                      ; Makes the button look As If it is the Default button in the window
;   ;   Debug  #PB_Button_Left         ; 256                    ; Aligns the button text at the left.
;   ;   Debug  #PB_Button_Right        ; 521                    ; Aligns the button text at the right.
;   ;   Debug  #PB_Button_Toggle       ; 4099                   ; Creates a toggle button: one click pushes it, another will release it.
;   ;   Debug  #PB_Button_MultiLine    ; 8192                   ; If the text is too long, it will be displayed on several lines. 
;   ;   
;   
;   If *this\type = #__type_Button 
;     If constants::BinaryFlag( Flag, #PB_Button_Toggle )
;       Flag &~ #PB_Button_Toggle
;       If Not *this\togglebox
;         *this\togglebox.allocate( BOX )
;       EndIf
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #PB_Button_MultiLine )
;       Flag &~ #PB_Button_MultiLine
;       *this\mode\multiSelect = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #PB_Button_Default )
;       Flag &~ #PB_Button_Default
;       *this\deffocus = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #PB_Button_Left )
;       Flag &~ #PB_Button_Left
;       *this\text\align\left = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #PB_Button_Right )
;       Flag &~ #PB_Button_Right
;       *this\text\align\right = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #__flag_TextTop )
;       *this\text\align\top = #True
;     EndIf
;     
;     If constants::BinaryFlag( Flag, #__flag_TextBottom )
;       *this\text\align\bottom = #True
;     EndIf
;   EndIf
; EndProcedure
; IDE Options = PureBasic 6.30 (Windows - x64)
; CursorPosition = 3
; Folding = --
; EnableXP
; DPIAware