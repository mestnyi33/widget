EnableExplicit

#NSTitledWindowMask             = 1 << 0
#NSClosableWindowMask           = 1 << 1
#NSMiniaturizableWindowMask     = 1 << 2
#NSResizableWindowMask          = 1 << 3
#NSTexturedBackgroundWindowMask = 1 << 8

Define ButtonID.I
Define ButtonState.I
Define ButtonText.S
Define i.I
Define NumButtons.I
Define WindowAttributeName.S
Define WindowAttributes.I

Dim WindowAttributeID.I(0)
Dim WindowAttributeName.S(0)

OpenWindow(0, 270, 100, 300, 260, "Toggle Window attributes", #PB_Window_SystemMenu | #PB_Window_Invisible)
ButtonGadget(100, 10, 160, 280, 25, "window's shadow")

; ----- Read the constant descriptions and its values into 2 arrays and create buttons

Repeat
  Read.S WindowAttributeName

  If WindowAttributeName = ""
    NumButtons = i
    Break
  Else
    ReDim WindowAttributeID(i)
    ReDim WindowAttributeName(i)
    WindowAttributeName(i) = WindowAttributeName
    Read.I WindowAttributeID(i)

    WindowAttributes = CocoaMessage(0, WindowID(0), "styleMask")

    If WindowAttributes & WindowAttributeID(i)
      ButtonText = "Disable "
    Else
      ButtonText = "Enable "
    EndIf

    ButtonGadget(i, 10, i * 30 + 10, WindowWidth(0) - 20, 25, ButtonText + WindowAttributeName(i))
    i + 1
  EndIf
ForEver

; ----- Adapt vertical size of window to display all buttons

ResizeWindow(0, #PB_Ignore, #PB_Ignore, #PB_Ignore, NumButtons * 30 + 10+40)
HideWindow(0, #False)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      If EventType() = #PB_EventType_LeftClick
        If EventGadget() = 100
        Define ShadowState = CocoaMessage(0, WindowID(0), "hasShadow") ! 1
        CocoaMessage(0, WindowID(0), "setHasShadow:", ShadowState)
      Else
        ButtonID = EventGadget()

      ; ----- Read current attributes of window
      WindowAttributes = CocoaMessage(0, WindowID(0), "styleMask")

      ; ----- Toggle the window attribute connected to the pressed button
      WindowAttributes ! WindowAttributeID(ButtonID)
      CocoaMessage(0, WindowID(0), "setStyleMask:", WindowAttributes)

      ; ----- Change the text of the button
      If WindowAttributes & WindowAttributeID(ButtonID)
        ButtonText = "Disable "
        ButtonState = #False
      Else
        ButtonText = "Enable "
        ButtonState = #True
      EndIf

      SetGadgetText(ButtonID, ButtonText + WindowAttributeName(ButtonID))

      Select WindowAttributeName(ButtonID)
        Case "titlebar"
          For i = 1 To NumButtons - 1
            DisableGadget(i, ButtonState)
          Next i
        Case "resizing of window"
          DisableGadget(0, ButtonState ! 1)
      EndSelect

      SetWindowTitle(0, "Toggle Window attributes")
    EndIf
  EndIf
EndSelect
ForEver

End

DataSection
  Data.S "titlebar"
  Data.I #NSTitledWindowMask
  Data.S "closing of window"
  Data.I #NSClosableWindowMask
  Data.S "minimizing to dock"
  Data.I #NSMiniaturizableWindowMask
  Data.S "resizing of window"
  Data.I #NSResizableWindowMask
  Data.S "metal look"
  Data.I #NSTexturedBackgroundWindowMask
  Data.S ""
EndDataSection
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP