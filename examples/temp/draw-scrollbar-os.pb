
;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   Global Event, Progress, Scroll
   
   Procedure scrolled( )
      SetGadgetState( Progress, GetGadgetState( Scroll ))
   EndProcedure
   
   If OpenWindow(0, 0, 0, 995, 605, "demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      Progress = ProgressBarGadget(#PB_Any, 10, 105, 975,95,0,100, 0) 
      ; SetGadgetState(progress, 50)
      
      Scroll = ScrollBarGadget(#PB_Any, 10, 205, 975,95,0,120,20) 
      SetGadgetState(Scroll, 50)
         SetGadgetState( Progress, GetGadgetState( Scroll ))
   
      ;\\
      BindGadgetEvent(Scroll, @scrolled());, #PB_EventType_Change )
      Repeat
         Event = WaitWindowEvent()
      Until Event = #PB_Event_CloseWindow
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 17
; Folding = -
; EnableXP