#NSTopTabsBezelBorder    = 0
#NSLeftTabsBezelBorder   = 1
#NSBottomTabsBezelBorder = 2
#NSRightTabsBezelBorder  = 3

OpenWindow(0, 270, 100, 300, 310, "Change tab location")
PanelGadget(0, 10, 10, WindowWidth(0) - 20, 180)
AddGadgetItem (0, -1, "Tab 1")
AddGadgetItem (0, -1, "Tab 2")
CloseGadgetList()
FrameGadget(1, 30, 210, WindowWidth(0) - 60, 80, "Tab location")
OptionGadget(2, 130, GadgetY(1) + 20, 80, 20, "Top")
OptionGadget(3, 50, GadgetY(1) + 35, 80, 20, "Left")
OptionGadget(4, 130, GadgetY(1) + 50, 80, 20, "Bottom")
OptionGadget(5, 210, GadgetY(1) + 35, 80, 20, "Right")
SetGadgetState(2, #True)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      SelectedGadget = EventGadget()

      If SelectedGadget >= 2 And SelectedGadget <= 5
        CocoaMessage(0, GadgetID(0), "setTabViewType:", SelectedGadget - 2)
      EndIf
  EndSelect
ForEver
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP