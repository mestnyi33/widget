Enumeration
  #AttachedWindow_PositionDifference = %000
  #AttachedWindow_FrameDifference    = %001
  #AttachedWindow_Magnetic           = %010
EndEnumeration


Structure AttachedWindow
  Window.i
  Attributes.i
  ParentWindow.i
  
  AlignX.i
  AlignY.i
  DeltaX.i
  DeltaY.i
  margin.i
EndStructure

Global NewList AttachedWindow.AttachedWindow()

Macro AttachedWindow_MagneticX(ShiftX)
  If Abs(AttachedWindow()\DeltaX-ShiftX) < AttachedWindow()\margin
    AttachedWindow()\DeltaX = ShiftX
    PushListPosition(AttachedWindow())
    ResizeWindow(AttachedWindow()\Window, WindowX(AttachedWindow()\ParentWindow, #PB_Window_FrameCoordinate)+AttachedWindow()\DeltaX, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    PopListPosition(AttachedWindow())
  EndIf
EndMacro

Macro AttachedWindow_MagneticY(ShiftY)
  If Abs(AttachedWindow()\DeltaY-(ShiftY)) < AttachedWindow()\margin
    AttachedWindow()\DeltaY = ShiftY
    PushListPosition(AttachedWindow())
    ResizeWindow(AttachedWindow()\Window, #PB_Ignore, WindowY(AttachedWindow()\ParentWindow, #PB_Window_FrameCoordinate)+AttachedWindow()\DeltaY, #PB_Ignore, #PB_Ignore)
    PopListPosition(AttachedWindow())
  EndIf
EndMacro

Macro _set_delta_pos_(_address_)
  _address_\DeltaX       = WindowX(_address_\Window) - WindowX(_address_\ParentWindow, #PB_Window_FrameCoordinate)
  _address_\DeltaY       = WindowY(_address_\Window) - WindowY(_address_\ParentWindow, #PB_Window_FrameCoordinate)
  
  If _address_\Attributes & #AttachedWindow_FrameDifference And _address_\DeltaX ;> (WindowWidth(_address_\ParentWindow, #PB_Window_FrameCoordinate)-WindowWidth(_address_\Window, #PB_Window_FrameCoordinate))/2
    _address_\AlignX = WindowWidth(_address_\ParentWindow, #PB_Window_FrameCoordinate)
  Else
    _address_\AlignX = 0
  EndIf
  If _address_\Attributes & #AttachedWindow_FrameDifference And _address_\DeltaY ; > (WindowHeight(_address_\ParentWindow, #PB_Window_FrameCoordinate)-WindowHeight(_address_\Window, #PB_Window_FrameCoordinate))/2
    _address_\AlignY = WindowHeight(_address_\ParentWindow, #PB_Window_FrameCoordinate)
  Else
    _address_\AlignY = 0
  EndIf
EndMacro


Procedure AttachedWindow_FollowCallback()
  Protected ParentWindow.i = EventWindow()
  Protected Window.i = EventWindow()
  
  ForEach AttachedWindow()
    With AttachedWindow()
      If \ParentWindow = ParentWindow
        PushListPosition(AttachedWindow())
        If \Attributes & #AttachedWindow_FrameDifference
          If \AlignX And \AlignY
            ResizeWindow(\Window, WindowX(ParentWindow)+WindowWidth(ParentWindow, #PB_Window_FrameCoordinate)+\DeltaX-\AlignX, WindowY(ParentWindow)+WindowHeight(ParentWindow, #PB_Window_FrameCoordinate)+\DeltaY-\AlignY, #PB_Ignore, #PB_Ignore)
          ElseIf \AlignX
            ResizeWindow(\Window, WindowX(ParentWindow)+WindowWidth(ParentWindow, #PB_Window_FrameCoordinate)+\DeltaX-\AlignX, WindowY(ParentWindow)+\DeltaY, #PB_Ignore, #PB_Ignore)
          ElseIf \AlignY
            ResizeWindow(\Window, WindowX(ParentWindow)+\DeltaX, WindowY(ParentWindow)+WindowHeight(ParentWindow, #PB_Window_FrameCoordinate)+\DeltaY-\AlignY, #PB_Ignore, #PB_Ignore)
          Else
            ResizeWindow(\Window, WindowX(ParentWindow)+\DeltaX, WindowY(ParentWindow)+\DeltaY, #PB_Ignore, #PB_Ignore)
          EndIf
        Else
          ResizeWindow(\Window, WindowX(ParentWindow)+\DeltaX, WindowY(ParentWindow)+\DeltaY, #PB_Ignore, #PB_Ignore)
        EndIf
        PopListPosition(AttachedWindow())
      ElseIf \Window = Window
        _set_delta_pos_(AttachedWindow())
        
        If \Attributes & #AttachedWindow_Magnetic
          AttachedWindow_MagneticX(-WindowWidth(\Window, #PB_Window_FrameCoordinate))
          AttachedWindow_MagneticX(0)
          AttachedWindow_MagneticX(WindowWidth(\ParentWindow, #PB_Window_FrameCoordinate))
          AttachedWindow_MagneticX((WindowWidth(\ParentWindow, #PB_Window_FrameCoordinate)-WindowWidth(\Window, #PB_Window_FrameCoordinate)))
          
          AttachedWindow_MagneticY(-WindowHeight(\Window, #PB_Window_FrameCoordinate))
          AttachedWindow_MagneticY(0)
          AttachedWindow_MagneticY(WindowHeight(\ParentWindow, #PB_Window_FrameCoordinate))
          AttachedWindow_MagneticY((WindowHeight(\ParentWindow, #PB_Window_FrameCoordinate)-WindowHeight(\Window, #PB_Window_FrameCoordinate)))
        EndIf
      EndIf
    EndWith
  Next
EndProcedure

Procedure AttachWindow(Window.i, ParentWindow.i, Attributes.i=#AttachedWindow_PositionDifference)
  AddElement(AttachedWindow())
  With AttachedWindow()
    \Attributes   = Attributes
    \Window       = Window
    \ParentWindow = ParentWindow
    
    If \Attributes & #AttachedWindow_Magnetic
      \margin = 25
    EndIf
    
    _set_delta_pos_(AttachedWindow())
    
  EndWith
  BindEvent(#PB_Event_MoveWindow, @AttachedWindow_FollowCallback(), ParentWindow)
  If Attributes & #AttachedWindow_FrameDifference
    BindEvent(#PB_Event_SizeWindow, @AttachedWindow_FollowCallback(), ParentWindow)
  EndIf
  BindEvent(#PB_Event_MoveWindow, @AttachedWindow_FollowCallback(), Window)
EndProcedure

Procedure DetachWindow(Window.i)
  ForEach AttachedWindow()
    If AttachedWindow()\Window = Window
      DeleteElement(AttachedWindow())
    EndIf
  Next
  UnbindEvent(#PB_Event_MoveWindow, @AttachedWindow_FollowCallback(), ParentWindow)
  UnbindEvent(#PB_Event_SizeWindow, @AttachedWindow_FollowCallback(), ParentWindow)
  UnbindEvent(#PB_Event_MoveWindow, @AttachedWindow_FollowCallback(), Window)
EndProcedure




;- Example

Enumeration
  #Window_Main
  #Window_Child1
  #Window_Child2
  #Window_SubChild
  #Gadget
EndEnumeration


OpenWindow(#Window_Main, 300, 200, 400, 400, "Main", #PB_Window_MinimizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered)

OpenWindow(#Window_Child1, WindowX(#Window_Main)+50, WindowY(#Window_Main, #PB_Window_FrameCoordinate)+50, 200, 300, "Child 1 (Position Attach)", #PB_Window_SizeGadget, WindowID(#Window_Main))
AttachWindow(#Window_Child1, #Window_Main)

OpenWindow(#Window_Child2, WindowX(#Window_Main)+WindowWidth(#Window_Main, #PB_Window_FrameCoordinate), WindowY(#Window_Main, #PB_Window_FrameCoordinate), 200, 300, "Child 2 (Frame Magnetic)", #PB_Window_SizeGadget, WindowID(#Window_Main))
AttachWindow(#Window_Child2, #Window_Main, #AttachedWindow_FrameDifference|#AttachedWindow_Magnetic)

OpenWindow(#Window_SubChild, WindowX(#Window_Child2), WindowY(#Window_Child2, #PB_Window_FrameCoordinate)+WindowHeight(#Window_Child2, #PB_Window_FrameCoordinate), 200, 100, "SubChild", #PB_Window_SizeGadget, WindowID(#Window_Child2))
AttachWindow(#Window_SubChild, #Window_Child2, #AttachedWindow_FrameDifference)
StringGadget(-1,0,0,200,100,"")

Repeat
  
  Event = WaitWindowEvent()
  
  Select Event
    Case #PB_Event_CloseWindow
      End
  EndSelect
  
ForEver
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---
; EnableXP