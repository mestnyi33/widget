#__FLAG_none         = 0
#__FLAG_left         = 1 << 1 
#__FLAG_top          = 1 << 2 
#__FLAG_right        = 1 << 3 
#__FLAG_bottom       = 1 << 4 
;
#__FLAG_auto         = 1 << 8
#__FLAG_center       = 1 << 5 
#__FLAG_full         = 1 << 7
#__FLAG_proportional = 1 << 6

#__FLAG_count = 8

Macro IsFlag( _flags_, _flag_ )
  Bool(((_flags_) & _flag_) = _flag_)
EndMacro

Define i
Macro RemoveFlag( _flags_, _flag_ )
  For i = 1 To #__FLAG_count
    If IsFlag(_flag_, (1<<i))
      _flags_ &~ (1<<i)
    EndIf
  Next i
EndMacro


Define flag.q = #__FLAG_left|#__FLAG_top|#__FLAG_right

Define flags.q = #__FLAG_bottom | flag

RemoveFlag( flags, #__FLAG_top|#__FLAG_right )

Debug IsFlag( flag, #__FLAG_left )
Debug IsFlag( flag, #__FLAG_top )
Debug IsFlag( flag, #__FLAG_right )
Debug IsFlag( flag, #__FLAG_bottom )
Debug ""
Debug IsFlag( flags, #__FLAG_left )
Debug IsFlag( flags, #__FLAG_top )
Debug IsFlag( flags, #__FLAG_right )
Debug IsFlag( flags, #__FLAG_bottom )


; IDE Options = PureBasic 6.40 (Windows - x64)
; CursorPosition = 41
; FirstLine = 18
; Folding = -
; EnableXP
; DPIAware