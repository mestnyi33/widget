IncludePath "../../../"
XIncludeFile "widgets.pbi"
EnableExplicit
UseWidgets( )

Macro IsFlag( _flags_, _flag_ )
  constants::BinaryFlag( _flags_, _flag_ )
EndMacro

Macro RemoveFlag( _flags_, _flag_ )
  _flags_ &~ _flag_
EndMacro
Define i
Macro RemoveFlag( _flags_, _flag_ )
  For i = 1 To #__flag_count
    If IsFlag(_flag_, (1<<i))
      _flags_ &~ (1<<i)
    EndIf
  Next i
EndMacro

Macro AddFlag( _flags_, _flag_ )
  If _flag_ & #__flag_Texttop
    _flags_ | #__flag_Texttop
  EndIf
  If _flag_ & #__flag_Textright
    _flags_ | #__flag_Textright
  EndIf
EndMacro

; Procedure DeleteFlag( flags.q, flag.q  )
;   Protected _flag_.q
;   
;   If flag & #__flag_Texttop
;     flag &~ #__flag_Texttop
;     flags &~ #__flag_Texttop
;   EndIf
;   If flag & #__flag_Textright
;     flag &~ #__flag_Textright
;     flags &~ #__flag_Textright
;   EndIf
;   
;   ProcedureReturn flags
; EndProcedure

; Procedure RemoveFlag( *this._s_WIDGET, flag.q )
;   If *this\flag & flag
;     *this\flag &~ flag
;     ProcedureReturn #True
;   EndIf
; EndProcedure

Procedure SetFlag( *this._s_WIDGET, flag.q )
  If Not *this\flag & flag
    *this\flag | flag
    ProcedureReturn #True
  EndIf
EndProcedure

Procedure GetFlag( *this._s_WIDGET )
  ProcedureReturn *this\flag
EndProcedure


Define flag.q = #__flag_TextLeft|#__flag_Texttop|#__flag_Textright;|#__flag_Textbottom

Define flags.q = #__flag_Textbottom | flag

;RemoveFlag( )
RemoveFlags( flags, #__flag_Texttop|#__flag_Textright )

Debug constants::BinaryFlag( flag, #__flag_TextLeft )
Debug constants::BinaryFlag( flag, #__flag_Texttop )
Debug constants::BinaryFlag( flag, #__flag_Textright )
Debug constants::BinaryFlag( flag, #__flag_Textbottom )
Debug ""
Debug constants::BinaryFlag( flags, #__flag_TextLeft )
Debug constants::BinaryFlag( flags, #__flag_Texttop )
Debug constants::BinaryFlag( flags, #__flag_Textright )
Debug constants::BinaryFlag( flags, #__flag_Textbottom )



; FromPBFlag( Type, Flag.q )

Procedure Flag_Text( *this._s_WIDGET, flag.q )
  ;                           windows ; macos ; linux
  ;   Debug  #PB_Text_Center ; 1      ;               ; The text is centered in the gadget.
  ;   Debug  #PB_Text_Right  ; 2      ;               ; The text is right aligned.
  ;   Debug  #PB_Text_Border ; 131072 ;               ; A sunken border is drawn around the gadget.
  ;   
  
  If *this\type = #__type_Text
    If constants::BinaryFlag( Flag, #__flag_Textinvert )
      *this\text\invert = #True
    EndIf
    
    If constants::BinaryFlag( Flag, #__flag_Textvertical )
      *this\text\vertical = #True
    EndIf
    
    If constants::BinaryFlag( Flag, #__flag_Textwordwrap )
      *this\text\multiline = - 1
    EndIf
    
    If constants::BinaryFlag( Flag, #__flag_Textmultiline )
      *this\mode\multiSelect = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__flag_Textcenter )
      *this\text\align\left = #False
      *this\text\align\top = #False
      *this\text\align\right = #False
      *this\text\align\bottom = #False
    EndIf
    
    If constants::BinaryFlag( flag, #__flag_TextLeft )
      *this\text\align\left = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__flag_Texttop )
      *this\text\align\top = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__flag_Textright )
      *this\text\align\right = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__flag_Textbottom )
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
    
    If constants::BinaryFlag( flag, #__flag_Texttop )
      *this\text\align\top = #True
    EndIf
    
    If constants::BinaryFlag( flag, #__flag_Textbottom )
      *this\text\align\bottom = #True
    EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 14
; Folding = -----
; EnableXP
; DPIAware