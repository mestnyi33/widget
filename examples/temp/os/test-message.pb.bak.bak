Procedure clik()
   MessageRequester("Information", "Click to move the Window", #PB_MessageRequester_YesNoCancel)
EndProcedure

If OpenWindow(0, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
   HyperLinkGadget(0, 10, 10, 250,20,"Red HyperLink", RGB(255,0,0))
   HyperLinkGadget(1, 10, 30, 250,40,"Arial Underlined Green HyperLink", RGB(0,255,0), #PB_HyperLink_Underline)
   SetGadgetFont(1, LoadFont(0, "Arial", 12))
   
   BindGadgetEvent(1, @clik( ), #PB_EventType_LeftClick )
   
   Repeat
      Event = WaitWindowEvent()
      
      If Event = #PB_Event_CloseWindow  ; If the user has pressed on the close button
         Quit = 1
      EndIf
      
   Until Quit = 1
   
EndIf

End   ; All the opened windows are closed automatically by PureBasic
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 10
; Folding = -
; EnableXP