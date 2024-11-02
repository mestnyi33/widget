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
  
  CocoaMessage(0, app, "terminate:", win) ;?
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
Structure NSEdgeInsets
  left.i
  top.i
  right.i
  bottom.i
EndStructure

Procedure OpenWindow_(window, x, y, width, height, title.s, flags = 0, parentID = 0 )
  Protected.i win, view, myWindowDelegateClass, myWindowDelegate, NSObjectClass
  
  Protected.NSRect rect, frame, visibleFrame
  Protected mainScreen = CocoaMessage(0,0,"NSScreen mainScreen")
  CocoaMessage(@visibleFrame, mainScreen,"visibleFrame")
  CocoaMessage(@frame, mainScreen,"frame")
  
  ;\\
  ;   rect\origin\x = x
  ;   rect\origin\y = (Frame\size\height - visibleFrame\origin\y)-height-y
  ;   rect\size\width = width
  ;   rect\size\height = height
  InitRect(@rect,x,(frame\size\height-visibleFrame\origin\y)-height-y,width,height)
  
  ;\\
  If flags & #PB_Window_BorderLess = #PB_Window_BorderLess
    #MASK = #NSBorderlessWindowMask;|#NSTitledWindowMask | #NSClosableWindowMask | #NSMiniaturizableWindowMask | #NSResizableWindowMask
  Else
    ;#MASK = #NSTitledWindowMask | #NSClosableWindowMask | #NSMiniaturizableWindowMask | #NSResizableWindowMask
  EndIf
  
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
  
  ;   CocoaMessage(0, win, "center")
  CocoaMessage(0, win, "update")
  CocoaMessage(0, win, "display")
  
  CocoaMessage(0, win, "setDelegate:", myWindowDelegate)
  
  ;             ;CocoaMessage(0, Win, "borderless:", 1)
  ;             ; CocoaMessage(0, Win, "styleMask") ; get
  ;CocoaMessage(0, Win, "setStyleMask:", #NSMiniaturizableWindowMask )
  
  ;\\ var windowLevel: UIWindow.Level { get set }
  If CocoaMessage(0, win, "level") <> 5
    CocoaMessage(0, win, "setLevel:", 5 ) ; stay on top
  EndIf
  
  ;\\ @property BOOL hasShadow;
  If Not CocoaMessage(0, win, "hasShadow") 
    CocoaMessage(0, win, "setHasShadow:", 1 )
  EndIf
  
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
EndProcedure

Procedure EventsMessage( )
  Debug "message " + EventType( ) +" "+ EventGadget() +" " + EventWindow()
  
  Select EventType()
    Case #PB_EventType_LeftButtonDown
      SetActiveWindow(0)
  EndSelect
EndProcedure

Procedure OpenMessage( )
  Define win = OpenWindow_(10, 260, 50, 200, 200, "mac-win", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
  Protected UseGadgetList = UseGadgetList(win)
  Protected gadget = CanvasGadget(-1, 10, 20-10, 180, 180)
  
  StartDrawing(CanvasOutput(gadget))
  Box(10,10,30,30,$ff0000)
  StopDrawing()
  
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseEnter )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseLeave )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonDown )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonUp )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftClick )
  
  
  UseGadgetList(UseGadgetList)
  WaitClose_( )
  
  ;FreeGadget( gadget )
  Debug "Quit MESSAGE"
EndProcedure

Procedure OpenPopup( ParentID )
  Define win = OpenWindow(10, 260, 50, 200, 200, "mac-win", #PB_Window_BorderLess|#PB_Window_NoActivate, ParentID)
  Protected UseGadgetList = UseGadgetList(win)
  Protected gadget = CanvasGadget(-1, 10, 20-10, 180, 180)
  
  StartDrawing(CanvasOutput(gadget))
  Box(10,10,30,30,$ff0000)
  StopDrawing()
  
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseEnter )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseLeave )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonDown )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonUp )
  BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftClick )
  
  #NSWindowStyleMaskBorderless = 0
  #NSWindowStyleMaskResizable = 1 << 3
  #NSWindowStyleMaskDocModalWindow = 1 << 6
  #NSWindowStyleMaskNonactivatingPanel = 1 << 7
  #NSWindowStyleMaskHUDWindow = 1 << 13
  
  CocoaMessage(0, Win, "setStyleMask:", #NSWindowStyleMaskBorderless )
  
  ;\\ var windowLevel: UIWindow.Level { get set }
  If CocoaMessage(0, win, "level") <> 5
    CocoaMessage(0, win, "setLevel:", 5 ) ; stay on top
  EndIf
  
  ;\\ @property BOOL hasShadow;
  If Not CocoaMessage(0, win, "hasShadow") 
    CocoaMessage(0, win, "setHasShadow:", 1 )
  EndIf
  
     ; SetActiveWindow(0)
  UseGadgetList(UseGadgetList)
EndProcedure

;\\
Procedure gadget_event( )
  Select EventType()
    Case #PB_EventType_LeftButtonDown
      Select EventGadget()
        Case 0
          Debug "messageCreate"
          OpenPopup( WindowID(EventWindow()))
          ;OpenMessage( )
          
      EndSelect
      
    Case #PB_EventType_MouseEnter
      Debug "enter " + EventType( ) +" "+ EventGadget() +" " + EventWindow()
    Case #PB_EventType_MouseLeave
      Debug "leave " + EventType( ) +" "+ EventGadget() +" " + EventWindow()
  EndSelect
EndProcedure

OpenWindow(0, 50, 50, 200, 200, "pb-win", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
CanvasGadget(0, 10, 10, 180, 180)
StartDrawing(CanvasOutput(0))
DrawText( 30,45, "button_0")
StopDrawing()

BindEvent(#PB_Event_Gadget, @gadget_event())

Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_LeftClick
    Debug " pb_window_leftclick"
  EndIf
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = 8-+-
; EnableXP