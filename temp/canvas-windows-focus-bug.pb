; purebasic 610 lts
; windows 
; click gadget-1 then click window-2 then click gadget-1
;
; return events
; 1 #PB_EventType_Focus 
; 1 #PB_EventType_LostFocus 
; 1 #PB_EventType_Focus 
; 1 #PB_EventType_LostFocus 
; 1 #PB_EventType_Focus 

CompilerIf #PB_Compiler_IsMainFile
   Define event
   
   OpenWindow(1, 200, 100, 320, 320, "window_1", #PB_Window_SystemMenu)
   CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard)
   
   OpenWindow(2, 450, 200, 220, 220, "window_2", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
   ;
   Repeat 
      event = WaitWindowEvent()
      
      If event = #PB_Event_Gadget
         Select EventType()
            Case #PB_EventType_Focus
               Debug ""+EventGadget() + " #PB_EventType_Focus " 
               
            Case #PB_EventType_LostFocus
               Debug ""+EventGadget() + " #PB_EventType_LostFocus " 
               
         EndSelect
      EndIf
      
   Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; Folding = -
; EnableXP
; DPIAware