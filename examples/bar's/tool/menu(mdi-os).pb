Procedure MenuEvents()
   Select EventMenu()
      Case 0
         SetGadgetState(0, #PB_MDI_Next)
      Case 1
         SetGadgetState(0, #PB_MDI_Previous)
   EndSelect
   
   Debug EventMenu()
EndProcedure

If OpenWindow(0, 0, 0, 800, 600, "MDIGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget)
   If CreateMenu(0, WindowID(0))
      MenuTitle("MDI windows menu")
      
      
      AddKeyboardShortcut(0, #PB_Shortcut_Control | #PB_Shortcut_Tab, 1)
      AddKeyboardShortcut(0, #PB_Shortcut_Control | #PB_Shortcut_Shift | #PB_Shortcut_Tab, 0)
      BindEvent(#PB_Event_Menu, @MenuEvents())
   EndIf
   
   MDIGadget(0, 0, 0, 0, 0, 0, 2, #PB_MDI_AutoSize)
   AddGadgetItem(0, 1, "child1")
   AddGadgetItem(0, 2, "child2")
   AddGadgetItem(0, 3, "child3")
   AddGadgetItem(0, 4, "child4")
   
   UseGadgetList(WindowID(0))
   
   Repeat : Until WaitWindowEvent(1) = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 27
; Folding = -
; EnableXP
; DPIAware