﻿; #PB_Event_ActivateWindow
; #PB_Event_DeactivateWindow
; #PB_Event_SizeWindow
; #PB_Event_MoveWindow
; #PB_Event_Repaint

Define doevent = #PB_Event_SizeWindow

Procedure event_repaint( )
  Debug " bind event - " + Event() +" window - "+ EventWindow( )
EndProcedure

BindEvent( doevent, @event_repaint( ) ) ; uncomment to see

OpenWindow( 1, 100, 100, 150, 100, "window 1", #PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SystemMenu )
OpenWindow( 2, 200, 200, 150, 100, "window 2", #PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SystemMenu )

For i=141 To 150
  ResizeWindow( 2, #PB_Ignore, #PB_Ignore, i, #PB_Ignore ) 
Next i 

; AddWindowTimer(1,1,1)
BindEvent( doevent, @event_repaint( ) )

Debug ""
Define resize
Repeat
  Event = WaitWindowEvent( )
  
  If event = doevent
    Debug " loop event - " + event +" window - "+ EventWindow( )
    ; End
  EndIf
  
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP