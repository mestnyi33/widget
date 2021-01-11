Runtime Enumeration
  ;define our runtime equivalent constants for the PB ones by just adding 'my_' to the constant name.
  #my_PB_EventType_LeftButtonDown = #PB_EventType_LeftButtonDown
EndEnumeration

Global s.s="#PB_EventType_LeftButtonDown"
Debug #PB_EventType_LeftButtonDown
Debug Val(Str(#PB_EventType_LeftButtonDown))   ;still works
Debug Str(#PB_EventType_LeftButtonDown)          ;it is no wonder why the above works, it is dealing with a numeric string that comes from the constant value
Debug GetRuntimeInteger("#my_" + Mid(s,2)) ;retrieve runtime constant value from the PB name only
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; EnableXP