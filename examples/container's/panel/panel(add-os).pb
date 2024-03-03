; example 1
CompilerIf #PB_Compiler_IsMainFile
   EnableExplicit
   
   Global i = 0
   Global *PANEL_1, *PANEL_2
   
   If OpenWindow(3, 0, 0, 400, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
      *PANEL_1 = PanelGadget(-1,30, 30, 340, 240)
      ;\\
      AddGadgetItem(*PANEL_1, 1, "*PANEL_1 - 1")
      ButtonGadget(-1, 10,10,80,30,"Button1")
      ButtonGadget(-1, 10,45,80,30,"Button2")
      ButtonGadget(-1, 10,80,80,30,"Button3")
      
      ;\\
      AddGadgetItem(*PANEL_1, i, "*PANEL_1 - 2")
      
      ;\\
      CloseGadgetList() ; close *PANEL_1 list
      
      ;\\
      SetGadgetState( *PANEL_1,1 )
      
      ;\\
      AddGadgetItem(*PANEL_1, i, "*PANEL_1 - 3")
      ButtonGadget(-1, 200,10,80,30,"Button4")
      ButtonGadget(-1, 200,45,80,30,"Button5")
      ButtonGadget(-1, 200,80,80,30,"Button6")
      
      Debug "items count "+CountGadgetItems(*PANEL_1)
      
      SetGadgetState(*PANEL_1, - 1 )
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event= #PB_Event_CloseWindow
   EndIf   
CompilerEndIf

; example 2
CompilerIf #PB_Compiler_IsMainFile = 99
   EnableExplicit
   
   Global i = 0
   Global *PANEL_1, *PANEL_2
   
   If OpenWindow( 3, 0, 0, 400, 300, "Panel add childrens hide state", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
      
      *PANEL_1 = PanelGadget( - 1, 30, 30, 340, 240 )
      
      For i=0 To 100
         AddGadgetItem( *PANEL_1, i, "item_"+Str(i) )
      Next
      
      Debug "items count "+CountGadgetItems( *PANEL_1 )
      
      Repeat
         Define Event = WaitWindowEvent()
      Until Event= #PB_Event_CloseWindow
      
   EndIf   
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 23
; FirstLine = 3
; Folding = -
; EnableXP