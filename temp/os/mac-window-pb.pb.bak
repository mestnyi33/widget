#NSBorderlessWindowMask = 0
#NSTitledWindowMask = 1 << 0
#NSClosableWindowMask = 1 << 1
#NSMiniaturizableWindowMask = 1 << 2
#NSResizableWindowMask = 1 << 3
#NSTexturedBackgroundWindowMask = 1 << 8

Procedure CloseWindow_( windowID )
  CocoaMessage(0, windowID, "release")
EndProcedure

ProcedureC winShouldClose(obj.i, sel.i, win.i) ; call 1
  Debug "winShouldClose - " + obj +" "+sel +" - "+win
  
  ;CloseWindow_(win)
  ProcedureReturn #YES
EndProcedure

Procedure OpenWindow_(window, x, y, width, height, title.s, flags = 0, parentID = 0 )
  Protected.i win, myWindowDelegateClass, myWindowDelegate
  
  CocoaMessage(@win, 0, "NSWindow alloc")
  myWindowDelegateClass = objc_allocateClassPair_(objc_getClass_("NSObject"), "myWindowDelegate", 0)
  class_addProtocol_(myWindowDelegateClass, objc_getProtocol_("NSWindowDelegate"))
  class_addMethod_(myWindowDelegateClass, sel_registerName_("windowShouldClose:"), @winShouldClose(), "c@:@")
  myWindowDelegate = class_createInstance_(myWindowDelegateClass, 0)
  
  ;\\
  Protected.NSRect rect
  ;   Protected.NSSize size
  ;   size\width = 100
  ;   size\height = 100
  
  ;\\
  Protected frame.NSRect
  Protected visibleFrame.NSRect
  Protected mainScreen = CocoaMessage(0,0,"NSScreen mainScreen")
  CocoaMessage(@visibleFrame.NSRect, mainScreen,"visibleFrame")
  CocoaMessage(@frame.NSRect, mainScreen,"frame")
  
  ;\\
  rect\origin\x = x
  rect\origin\y = (Frame\size\height - visibleFrame\origin\y)-height-y
  rect\size\width = width
  rect\size\height = height
  
  #MASK = #NSTitledWindowMask | #NSClosableWindowMask | #NSMiniaturizableWindowMask | #NSResizableWindowMask
  
  CocoaMessage(0, win, "initWithContentRect:@", @rect, "styleMask:", #MASK, "backing:", 2, "defer:", #NO)
  CocoaMessage(0, win, "makeKeyAndOrderFront:")
  CocoaMessage(0, win, "setTitle:$", @title)
  ;   CocoaMessage(0, win, "setMinSize:@", @size)
  ;   CocoaMessage(0, win, "center")
  CocoaMessage(0, win, "update")
  CocoaMessage(0, win, "display")
  
  CocoaMessage(0, win, "setPreventsApplicationTerminationWhenModal:", #NO)
  CocoaMessage(0, win, "setReleasedWhenClosed:", #YES)
  
  CocoaMessage(0, win, "setDelegate:", myWindowDelegate)
  ProcedureReturn win
EndProcedure

;\\
OpenWindow(0, 50, 50, 200, 200, "pb-win", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
ButtonGadget(0, 10, 10, 180, 180, "")

OpenWindow_(10, 50, 50, 200, 200, "mac-win", #PB_Window_SizeGadget | #PB_Window_SystemMenu)


Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP