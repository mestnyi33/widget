#__align_none         = 0
#__align_left         = 1 << 1 
#__align_top          = 1 << 2 
#__align_right        = 1 << 3 
#__align_bottom       = 1 << 4 
;
#__align_auto         = 1 << 8
#__align_center       = 1 << 5 
#__align_full         = 1 << 7
#__align_proportional = 1 << 6

#__flag_count = 8

Macro IsFlag( _flags_, _flag_ )
  Bool(((_flags_) & _flag_) = _flag_)
EndMacro

Define i
Macro RemoveFlag( _flags_, _flag_ )
  For i = 1 To #__flag_count
    If IsFlag(_flag_, (1<<i))
      _flags_ &~ (1<<i)
    EndIf
  Next i
EndMacro


Define flag.q = #__align_left|#__align_top|#__align_right

Define flags.q = #__align_bottom | flag

RemoveFlag( flags, #__align_top|#__align_right )

Debug IsFlag( flag, #__align_left )
Debug IsFlag( flag, #__align_top )
Debug IsFlag( flag, #__align_right )
Debug IsFlag( flag, #__align_bottom )
Debug ""
Debug IsFlag( flags, #__align_left )
Debug IsFlag( flags, #__align_top )
Debug IsFlag( flags, #__align_right )
Debug IsFlag( flags, #__align_bottom )


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 12
; FirstLine = 4
; Folding = -
; EnableXP
; DPIAware