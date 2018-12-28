#PB_ScrollBar_NoButtons = 1<<2
#PB_ScrollBar_Inverted = 1<<3
  
Debug #PB_ScrollBar_Vertical
Debug #PB_ScrollBar_Minimum
Debug #PB_ScrollBar_Maximum
Debug #PB_ScrollBar_PageLength
Debug #PB_ScrollBar_NoButtons
Debug #PB_ScrollBar_Inverted

Flag = #PB_ScrollBar_Maximum
Debug Str(Bool(Flag&#PB_ScrollBar_NoButtons=#PB_ScrollBar_NoButtons))

; IDE Options = PureBasic 5.62 (MacOS X - x64)
; EnableXP