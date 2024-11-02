Procedure ClickCount( )
  Static ClickTime.q, ClickCount
  Protected DoubleClickTime = 500
  
  Debug " time "+  Str(ElapsedMilliseconds( )-ClickTime)
  
  If DoubleClickTime > ( ElapsedMilliseconds( ) - ClickTime )
    ClickCount + 1
  Else
    ClickCount = 1
  EndIf
  ClickTime = ElapsedMilliseconds( )
  Debug " ClickTime "+ClickTime
  
  ProcedureReturn ClickCount
EndProcedure

Debug ClickCount( )
Delay(5010)
Debug ClickCount( )
Delay(98)
Debug ClickCount( )
Delay(498)
Debug ClickCount( )
; 
; For i=0 To 500
;   Debug ClickCount( )
; Next
; 
; ; windows
; ; time 0
; ; 1
; ;  time 9
; ; 2
; ;  time 9
; ; 3
; ;  time 15
; ; 4
; 
; ; mac os
; ;  time 695
; ; 1
; ;  time 498
; ; 2
; ;  time 498
; ; 3
; ;  time 499
; ; 4
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 11
; Folding = -
; EnableXP