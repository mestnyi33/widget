; If OSVersion() > #PB_OS_MacOSX_10_6
;   MessageRequester("Info", "Sorry, but 'setColorTint:' seems to be broken beginning with Lion...")
;   End
; EndIf

#NSBlueControlTint = 1
#NSClearControlTint = 7

OpenWindow(0, 270, 100, 300, 250, "Change tab selection color")
PanelGadget(0, 10, 10, WindowWidth(0) - 20, 160)
AddGadgetItem (0, -1, "Tab 1")
AddGadgetItem (0, -1, "Tab 2")
CloseGadgetList()
FrameGadget(1, 50, 180, WindowWidth(0) - 100, 50, "Tab selection color")
OptionGadget(2, 70, GadgetY(1) + 20, 80, 20, "Blue")
OptionGadget(3, 150, GadgetY(1) + 20, 80, 20, "Graphite")
SetGadgetState(2, #True)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 2
          CocoaMessage(0, GadgetID(0), "setControlTint:", #NSBlueControlTint)
        Case 3
          CocoaMessage(0, GadgetID(0), "setControlTint:", #NSClearControlTint)
      EndSelect
  EndSelect
ForEver
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP