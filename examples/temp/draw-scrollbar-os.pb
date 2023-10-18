
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Global Event, progress, scroll
   
   Procedure scrolled( )
      SetGadgetState( progress, GetGadgetState( scroll ))
   EndProcedure
   
   If OpenWindow(0, 0, 0, 995, 605, "demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      progress = ProgressBarGadget(#PB_Any, 10, 105, 975,95,0,100, 0) 
      ; SetGadgetState(progress, 50)
      
      scroll = ScrollBarGadget(#PB_Any, 10, 205, 975,95,0,120,20) 
      SetGadgetState(scroll, 50)
      
      ;\\
      BindGadgetEvent(scroll, @scrolled());, #PB_EventType_Change )
      Repeat
         Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 12
; Folding = -
; EnableXP