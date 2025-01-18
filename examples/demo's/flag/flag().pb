IncludePath "../../../"
XIncludeFile "widgets.pbi"
EnableExplicit
UseWidgets( )

Macro IsFlag( _flags_, _flag_ )
  Bool(((_flags_) & _flag_) = _flag_)
EndMacro

Macro RemoveFlag( _flags_, _flag_ )
  Define i
  For i = 0 To 63
    If IsFlag(_flag_, (1<<i))
      _flags_ &~ (1<<i)
    EndIf
  Next i
EndMacro

Macro AddFlag( _flags_, _flag_ )
  Define i
  If Not _flags_ & _flag_
    For i = 0 To 63
      If IsFlag(_flag_, (1<<i))
        _flags_ | (1<<i)
      EndIf
    Next i
  EndIf
EndMacro

Procedure SetFlag( *this._s_WIDGET, flag.q )
  If Not *this\flag & flag
    *this\flag | flag
    ProcedureReturn #True
  EndIf
EndProcedure

Procedure GetFlag( *this._s_WIDGET )
  ProcedureReturn *this\flag
EndProcedure


Define flag.q = #__text_left|#__text_Top|#__text_Right;|#__text_Bottom

Define flags.q = #__text_Bottom | flag

;RemoveFlag( )
RemoveFlag( flags, #__text_Top|#__text_Right )

Debug constants::BinaryFlag( flag, #__text_left )
Debug constants::BinaryFlag( flag, #__text_Top )
Debug constants::BinaryFlag( flag, #__text_Right )
Debug constants::BinaryFlag( flag, #__text_Bottom )
Debug ""
Debug constants::BinaryFlag( flags, #__text_left )
Debug constants::BinaryFlag( flags, #__text_Top )
Debug constants::BinaryFlag( flags, #__text_Right )
Debug constants::BinaryFlag( flags, #__text_Bottom )



; FromPBFlag( Type, Flag.q )

Procedure Flag_Text( *this._s_WIDGET, flag.q )
  ;                           windows ; macos ; linux
  ;   Debug  #PB_Text_Center ; 1      ;               ; The text is centered in the gadget.
  ;   Debug  #PB_Text_Right  ; 2      ;               ; The text is right aligned.
  ;   Debug  #PB_Text_Border ; 131072 ;               ; A sunken border is drawn around the gadget.
  ;   
  
  If *this\type = #__type_Text
    If constants::BinaryFlag( Flag, #__text_Invert )
      *this\text\invert = #True
    EndIf
    
    If constants::BinaryFlag( Flag, #__text_Vertical )
      *this\text\vertical = #True
    EndIf
    
    If constants::BinaryFlag( Flag, #__flag_Textwordwrap )
      *this\text\multiline = - 1
    EndIf
    
    If constants::BinaryFlag( Flag, #__flag_Textmultiline )
      *this\mode\multiSelect = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__text_Center )
      *this\text\align\left = #False
      *this\text\align\top = #False
      *this\text\align\right = #False
      *this\text\align\bottom = #False
    EndIf
    
    If constants::BinaryFlag( flag, #__text_left )
      *this\text\align\left = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__text_Top )
      *this\text\align\top = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__text_Right )
      *this\text\align\right = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__text_Bottom )
      *this\text\align\bottom = #True
    EndIf
  EndIf
EndProcedure

Procedure Flag_Button( *this._s_WIDGET, flag.q )
  ;                                  windows ; macos ; linux
  ;   Debug  #PB_Button_Default      ; 1                      ; Makes the button look As If it is the Default button in the window
  ;   Debug  #PB_Button_Left         ; 256                    ; Aligns the button text at the left.
  ;   Debug  #PB_Button_Right        ; 521                    ; Aligns the button text at the right.
  ;   Debug  #__flag_ButtonToggle       ; 4099                   ; Creates a toggle button: one click pushes it, another will release it.
  ;   Debug  #PB_Button_MultiLine    ; 8192                   ; If the text is too long, it will be displayed on several lines. 
  ;   
  
  If *this\type = #__type_Button 
    If constants::BinaryFlag( flag, #__flag_ButtonToggle )
      flag &~ #__flag_ButtonToggle
      If Not *this\togglebox
        *this\togglebox.allocate( BOX )
      EndIf
    EndIf
    
    If constants::BinaryFlag( Flag, #PB_Button_MultiLine )
      flag &~ #PB_Button_MultiLine
      *this\mode\multiSelect = #True
    EndIf
    
    If constants::BinaryFlag( flag, #PB_Button_Default )
      flag &~ #PB_Button_Default
      *this\deffocus = #True
    EndIf
    
    If constants::BinaryFlag( flag, #PB_Button_Left )
      flag &~ #PB_Button_Left
      *this\text\align\left = #True
    EndIf
    
    If constants::BinaryFlag( flag, #PB_Button_Right )
      flag &~ #PB_Button_Right
      *this\text\align\right = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__text_Top )
      *this\text\align\top = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__text_Bottom )
      *this\text\align\bottom = #True
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 86
; FirstLine = 82
; Folding = -----
; EnableXP
; DPIAware