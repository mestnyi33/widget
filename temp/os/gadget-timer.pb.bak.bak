Global EventType


Procedure Canvas_Event( ) 
  EventType = EventType( )
  
EndProcedure 

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Windows
    Procedure TimerCallback( hwnd, uMsg, idEvent, dwTime.w ) 
      Debug "Alert !" +dwTime
      
    EndProcedure 
  CompilerCase #PB_OS_Linux
    
CompilerEndSelect

Procedure SetGadgetTimer( gadget, timeid, timecount )
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      SetTimer_( GadgetID( gadget ), timeid,timecount, @TimerCallback( ) )
    CompilerCase #PB_OS_Linux
      
  CompilerEndSelect
EndProcedure

Procedure RemoveGadgetTimer( gadget, timeid )
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      KillTimer_( GadgetID( gadget ), timeid )
    CompilerCase #PB_OS_Linux
      
  CompilerEndSelect
EndProcedure

If OpenWindow( 0, 0, 0, 220, 220, "canvas-timer", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
  CanvasGadget( 0, 10, 10, 200, 200 )
  BindGadgetEvent( 0,@Canvas_Event( ) )
  
  SetGadgetTimer( 0, 1, 1000 )
  
  Repeat
    Event = WaitWindowEvent()
  Until Event = #PB_Event_CloseWindow
  
  RemoveGadgetTimer( 0, 1 )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP