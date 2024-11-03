Global mainwin = 0
Global testwin 

If OpenWindow(mainwin, 0, 0, 600, 400, "Modal Window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   TextGadget(-1,5,50,40,24, "show")
   CanvasGadget(0,5,70,40,24)
   TextGadget(-1,50,50,40,24, "hide")
   CanvasGadget(1,50,70,40,24)
   
   OpenWindow(11,0,0,400,200,"11", #PB_Window_NoActivate|#PB_Window_WindowCentered | #PB_Window_Tool,WindowID(mainwin))
   mainwin = 11 ; comment/uncoment to see
   OpenWindow(12,0,0,200,100,"12", #PB_Window_NoActivate|#PB_Window_WindowCentered | #PB_Window_Tool,WindowID(mainwin))
   
   testwin = 12
   
   Repeat
      Select WaitWindowEvent()
         Case #PB_Event_CloseWindow
            Quit = 1
            
         Case #PB_Event_ActivateWindow
            Debug "active - "+EventWindow()
            
         Case #PB_Event_DeactivateWindow
            Debug "deactive - "+EventWindow()
            
         Case #PB_Event_Gadget
            Select EventGadget()          
               Case 0
                  HideWindow(testwin, 0, #PB_Window_NoActivate )
                  
               Case 1
                  HideWindow(testwin, 1, #PB_Window_NoActivate )
                  
                  
            EndSelect
      EndSelect
      
   Until Quit = 1
   
EndIf

; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 34
; FirstLine = 4
; Folding = -
; EnableXP