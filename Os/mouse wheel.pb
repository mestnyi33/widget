EnableExplicit

#ListIcon = 0
#Window = 0

Enumeration 
  #PB_EventType_MouseWheel_Down = #PB_EventType_FirstCustomValue
  #PB_EventType_MouseWheel_Up
EndEnumeration

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux ; --------------------------------------------------
    ProcedureC MouseWheelCallback(*Event.GdkEventScroll, *UserData)
      Protected *ListView.GtkWidget = GadgetID(#ListIcon)
     
      If *ListView\window = gdk_window_get_parent_(*Event\window)
        If *Event\type = #GDK_SCROLL
          Select *Event\direction
            Case #GDK_SCROLL_UP
              PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
                #PB_EventType_MouseWheel_Up)
            Case #GDK_SCROLL_DOWN
              PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
                #PB_EventType_MouseWheel_Down)
          EndSelect
        EndIf
      EndIf
     
      gtk_main_do_event_(*Event)
    EndProcedure
  CompilerCase #PB_OS_MacOS ; --------------------------------------------------
    #kCGEventTapOptionListenOnly = 1
    #kCGHeadInsertEventTap = 0
    #NX_SCROLLWHEELMOVED = 22
    #NX_SCROLLWHEELMOVEDMASK = 1 << #NX_SCROLLWHEELMOVED

    ImportC ""
      CGEventTapCreateForPSN(*ProcessSerialNumber, CGEventTapPlacement.I,
        CGEventTapOptions.I, CGEventMask.Q, CGEventTapCallback.I, *UserData)
      GetCurrentProcess(*ProcessSerialNumber)
    EndImport

    ProcedureC MouseWheelCallback(CGEventTapProxy.I, CGEventType.I, CGEvent.I,
      *UserData)
      Protected DeltaY.CGFloat
      Protected NSEvent.I
      Protected Point.NSPoint
      
      NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", CGEvent)
      CocoaMessage(@Point, NSEvent, "locationInWindow")
      
      If CocoaMessage(0, CocoaMessage(0, WindowID(#Window), "contentView"),
        "hitTest:@", @Point) = GadgetID(#ListIcon)
        CocoaMessage(@DeltaY, NSEvent, "deltaY")
        
        If DeltaY < 0.0
          PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
            #PB_EventType_MouseWheel_Down)
        Else
          Debug DeltaY
          PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
            #PB_EventType_MouseWheel_Up)
        EndIf
      EndIf
    EndProcedure
  CompilerCase #PB_OS_Windows ; ------------------------------------------------
    Define DefaultListIconCallback.I

    Procedure CustomListIconCallback(WindowHandle.I, Msg.I, WParam.I, LParam.I)
      Shared DefaultListIconCallback.I

      If Msg = #WM_MOUSEWHEEL
        If (WParam >> 16) & $8000
          PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
            #PB_EventType_MouseWheel_Down)
        Else         
          PostEvent(#PB_Event_Gadget, #Window, #ListIcon,
            #PB_EventType_MouseWheel_Up)
        EndIf
      EndIf

      ProcedureReturn CallWindowProc_(DefaultListIconCallback, WindowHandle,
        Msg, WParam, LParam)
   EndProcedure
CompilerEndSelect

Define i.I

OpenWindow(0, 200, 100, 300, 140, "Detect mouse wheel scrolling")
ListIconGadget(#ListIcon, 10, 10, 280, 120, "Column 1", 100)

For i = 1 To 20
  AddGadgetItem(0, -1, "Line " + Str(i))
Next i

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux
    gdk_event_handler_set_(@MouseWheelCallback(), 0, 0)
  CompilerCase #PB_OS_MacOS
    Define MachPort.I
    Define ProcessSerialNumber.Q

    GetCurrentProcess(@ProcessSerialNumber)
    MachPort = CGEventTapCreateForPSN(@ProcessSerialNumber,
      #kCGHeadInsertEventTap, #kCGEventTapOptionListenOnly,
      #NX_SCROLLWHEELMOVEDMASK, @MouseWheelCallback(), 0)

    If MachPort
      CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"),
      "addPort:", MachPort,
      "forMode:$", @"kCFRunLoopCommonModes")
    EndIf
  CompilerCase #PB_OS_Windows
    DefaultListIconCallback = GetWindowLongPtr_(GadgetID(#ListIcon),
      #GWL_WNDPROC)
    SetWindowLongPtr_(GadgetID(#ListIcon), #GWL_WNDPROC,
      @CustomListIconCallback())
CompilerEndSelect

SetActiveGadget(#ListIcon)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux
          gdk_event_handler_set_(0, 0, 0)
        CompilerCase #PB_OS_MacOS
          CFRelease_(MachPort)
      CompilerEndSelect
      Break
    Case #PB_Event_Gadget
      If EventGadget() = #ListIcon
        Select EventType()
          Case #PB_EventType_MouseWheel_Down
            Debug "Mouse wheel moved down"
          Case #PB_EventType_MouseWheel_Up
            Debug "Mouse wheel moved up"
        EndSelect
      EndIf
  EndSelect
ForEver
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -0-
; EnableXP