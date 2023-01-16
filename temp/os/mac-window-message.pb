#NSBorderlessWindowMask = 0
#NSTitledWindowMask = 1 << 0
#NSClosableWindowMask = 1 << 1
#NSMiniaturizableWindowMask = 1 << 2
#NSResizableWindowMask = 1 << 3
#NSTexturedBackgroundWindowMask = 1 << 8

Procedure CloseWindow_( windowID )
  
  CocoaMessage(0, windowID, "close")
  ; CocoaMessage(0, windowID, "release")
EndProcedure

ProcedureC winShouldClose(obj.i, sel.i, win.i) ; call 1
  Protected app
  CocoaMessage(@app, 0, "NSApplication sharedApplication")
  Debug "winShouldClose - " + app +" "+ obj +" "+sel +" - "+win
  
  ; CocoaMessage(@appDelegate, app, "delegate")
  ; CocoaMessage(@appDelegateClass, appDelegate, "class")
  CocoaMessage(0, app, "stop:", win)
  ; CloseWindow_(win)
  ;End
  ProcedureReturn #YES
EndProcedure

Procedure InitRect(*rect.NSRect,x,y,width,height)
  If *rect
    *rect\origin\x = x
    *rect\origin\y = y
    *rect\size\width = width
    *rect\size\height = height
  EndIf
EndProcedure

Procedure OpenWindow_(window, x, y, width, height, title.s, flags = 0, parentID = 0 )
  Protected.i win, view, myWindowDelegateClass, myWindowDelegate, NSObjectClass
  
  Protected.NSRect rect, frame, visibleFrame
  Protected mainScreen = CocoaMessage(0,0,"NSScreen mainScreen")
  CocoaMessage(@visibleFrame.NSRect, mainScreen,"visibleFrame")
  CocoaMessage(@frame.NSRect, mainScreen,"frame")
  
  
  ;\\
;   rect\origin\x = x
;   rect\origin\y = (Frame\size\height - visibleFrame\origin\y)-height-y
;   rect\size\width = width
;   rect\size\height = height
  InitRect(@rect,x,(frame\size\height-visibleFrame\origin\y)-height-y,width,height)
  
  #MASK = #NSTitledWindowMask | #NSClosableWindowMask | #NSMiniaturizableWindowMask | #NSResizableWindowMask
  
  CocoaMessage(@win, 0, "NSWindow alloc")
  NSObjectClass = objc_getClass_("NSObject")
  myWindowDelegateClass = objc_allocateClassPair_(NSObjectClass, "myWindowDelegate", 0)
  class_addProtocol_(myWindowDelegateClass, objc_getProtocol_("NSWindowDelegate"))
  class_addMethod_(myWindowDelegateClass, sel_registerName_("windowShouldClose:"), @winShouldClose(), "c@:@")
  myWindowDelegate = class_createInstance_(myWindowDelegateClass, 0)
  
  CocoaMessage(0, win, "initWithContentRect:@", @rect, "styleMask:", #MASK, "backing:", 2, "defer:", #NO)
  ;   CocoaMessage(0, win, "makeKeyWindow")
  CocoaMessage(0, win, "makeKeyAndOrderFront:", app)
  CocoaMessage(0, win, "setTitle:$", @title)
  CocoaMessage(0, win, "setPreventsApplicationTerminationWhenModal:", #NO)
  CocoaMessage(0, win, "setReleasedWhenClosed:", #YES)
  
;   CocoaMessage(@view,0,"NSView alloc")
;   If view
;     InitRect(@rect,0,0,width,height)
;     CocoaMessage(@view,view,"initWithFrame:@",@rect)
;     CocoaMessage(0,win,"setContentView:",view)
;   EndIf
        
  ;   CocoaMessage(0, win, "center")
  CocoaMessage(0, win, "update")
  CocoaMessage(0, win, "display")
  
  CocoaMessage(0, win, "setDelegate:", myWindowDelegate)
  ProcedureReturn win
EndProcedure

Procedure WaitClose_( )
  Protected app
  CocoaMessage(@app, 0, "NSApplication sharedApplication")
  
  ; #NSApplicationActivateAllWindows = 1 << 0
  ; #NSApplicationActivateIgnoringOtherApps = 1 << 1
  ; 
  ; Protected currentApplication = CocoaMessage(0, 0, "NSRunningApplication currentApplication")
  ; CocoaMessage(0, currentApplication, "activateWithOptions:", #NSApplicationActivateAllWindows | #NSApplicationActivateIgnoringOtherApps)
  
  ;	CocoaMessage(0,runapp, "activateWithOptions:",  #NSApplicationActivateIgnoringOtherApps )
		
  CocoaMessage(0, app, "run")
  ; CocoaMessage(0, app, "terminate:", app)
  
EndProcedure


Procedure OpenMessage( )
  Define win = OpenWindow_(10, 50, 50, 200, 200, "mac-win", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  Protected UseGadgetList = UseGadgetList(win)
  Protected gadget = CanvasGadget(-1, 10, 20-10, 180, 180)
  UseGadgetList(UseGadgetList)
  
  
  StartDrawing(CanvasOutput(gadget))
  Box(10,10,30,30,$ff0000)
  StopDrawing()
  
  ; var windowLevel: UIWindow.Level { get set }
  CocoaMessage(0, Win, "setLevel:",5) ; stay on top
                                      ; Debug CocoaMessage(0, Win, "level")
  WaitClose_( )
  
  ;FreeGadget( gadget )
EndProcedure

;\\
Procedure gadget_event( )
  Select EventGadget()
    Case 0
      Debug "click"
      OpenMessage( )
      
    Case 1
      Select EventType()
        Case #PB_EventType_LeftButtonDown
          Debug "down " + EventWindow()
        Case #PB_EventType_LeftButtonUp
          Debug "up "+EventWindow()
      EndSelect
  EndSelect
EndProcedure

OpenWindow(0, 50, 50, 200, 200, "pb-win", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
ButtonGadget(0, 10, 10, 180, 180, "button_0")

BindEvent(#PB_Event_Gadget, @gadget_event())

Repeat
  Event = WaitWindowEvent()
  
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP