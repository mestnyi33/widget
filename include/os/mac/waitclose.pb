#NSBorderlessWindowMask = 0
#NSTitledWindowMask = 1 << 0
#NSClosableWindowMask = 1 << 1
#NSMiniaturizableWindowMask = 1 << 2
#NSResizableWindowMask = 1 << 3
#NSTexturedBackgroundWindowMask = 1 << 8

#PB_Event_CloseMessage = #PB_Event_FirstCustomValue

ProcedureC winShouldClose(obj.i, sel.i, win.i) 
  CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "stop:", win)
  ProcedureReturn #YES
EndProcedure

Procedure WaitCloseMessage( *callback )
  Protected app
  CocoaMessage(@app, 0, "NSApplication sharedApplication")
  
  Protected mask, EventTap
  mask = #NSMouseMovedMask | #NSScrollWheelMask
  mask | #NSMouseEnteredMask | #NSMouseExitedMask 
  mask | #NSLeftMouseDownMask | #NSLeftMouseUpMask 
  mask | #NSRightMouseDownMask | #NSRightMouseDownMask 
  mask | #NSLeftMouseDraggedMask | #NSRightMouseDraggedMask   ;| #NSCursorUpdateMask
  
  #cghidEventTap = 0              ; Указывает, что отвод события размещается в точке, где системные события HID поступают на оконный сервер.
  #cgSessionEventTap = 1          ; Указывает, что отвод события размещается в точке, где события системы HID и удаленного управления входят в сеанс входа в систему.
  #cgAnnotatedSessionEventTap = 2 ; Указывает, что отвод события размещается в точке, где события сеанса были аннотированы для передачи в приложение.
  
  #headInsertEventTap = 0         ; Указывает, что новое касание события должно быть вставлено перед любым ранее существовавшим касанием события в том же месте.
  #tailAppendEventTap = 1         ; Указывает, что новое касание события должно быть вставлено после любого ранее существовавшего касания события в том же месте
  
  
  GetCurrentProcess(@psn): eventTap = CGEventTapCreateForPSN(@psn, #headInsertEventTap, 1, mask, @eventTapFunction( ), *callback)
  
  ; с ним mousemove не происходит если приложение не активно
  ;eventTap = CGEventTapCreate(2, 0, 1, mask, @eventTapFunction(), *callback)
  
  If eventTap
    CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopDefaultMode")
  EndIf
  ; CFRelease_(eventTap)
  
  CocoaMessage(0, app, "run")
  ; Debug "Quit MESSAGE"
EndProcedure

Procedure OpenWindow_(window, x, y, width, height, title.s, flags = 0, parentID = 0 )
  Protected.i win, view, myWindowDelegateClass, myWindowDelegate, NSObjectClass
  
  Protected.NSRect rect, frame, visibleFrame
  Protected mainScreen = CocoaMessage(0,0,"NSScreen mainScreen")
  CocoaMessage(@visibleFrame.NSRect, mainScreen,"visibleFrame")
  CocoaMessage(@frame.NSRect, mainScreen,"frame")
  
  
  ;\\
  rect\origin\x = x
  rect\origin\y = (Frame\size\height - visibleFrame\origin\y)-height-y
  rect\size\width = width
  rect\size\height = height
  
  #NSWindowStyleMaskBorderless = 0
  #NSWindowStyleMaskResizable = 1 << 3
  #NSWindowStyleMaskDocModalWindow = 1 << 6
  #NSWindowStyleMaskNonactivatingPanel = 1 << 7
  #NSWindowStyleMaskHUDWindow = 1 << 13
  
  ;\\
  If flags & #PB_Window_BorderLess = #PB_Window_BorderLess
    #MASK = #NSWindowStyleMaskBorderless;#NSWindowStyleMaskNonactivatingPanel|#NSTitledWindowMask | #NSClosableWindowMask | #NSMiniaturizableWindowMask | #NSResizableWindowMask
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
  
  If ParentID
    objc_setAssociatedObject_(win, "ParentID", ParentID, 0) 
    objc_setAssociatedObject_(ParentID, "ChildID", win, 0) 
    ;CocoaMessage(0, win, "setParentWindow:", ParentID)
    
  EndIf
  ProcedureReturn win
EndProcedure

Procedure MessageEvents( )
  Protected WindowID = objc_getAssociatedObject_(GadgetID(EventGadget()), "ParentID")
  
  Debug "messageevents() " + EventType( ) +" "+ EventGadget() +" "+ WindowID +" " + EventWindow()
EndProcedure

Procedure OpenMessage( ParentID )
  Define win = OpenWindow_(10, 260, 50, 200, 200, "mac-win", #PB_Window_BorderLess, ParentID )
  Protected UseGadgetList = UseGadgetList(win)
  Protected gadget = CanvasGadget(-1, 10, 20-10, 180, 180)
  
  StartDrawing(CanvasOutput(gadget))
  Box(10,10,30,30,$ff0000)
  StopDrawing()
  
  objc_setAssociatedObject_(GadgetID(gadget), "ParentID", ParentID, 0) 
  
  ;\\
  BindGadgetEvent( gadget, @MessageEvents(), #PB_EventType_MouseEnter )
  BindGadgetEvent( gadget, @MessageEvents(), #PB_EventType_MouseLeave )
  BindGadgetEvent( gadget, @MessageEvents(), #PB_EventType_LeftButtonDown )
  BindGadgetEvent( gadget, @MessageEvents(), #PB_EventType_LeftButtonUp )
  BindGadgetEvent( gadget, @MessageEvents(), #PB_EventType_LeftClick )
  
  ;\\
  UseGadgetList(UseGadgetList)
  
  PostEvent(#PB_Event_CloseMessage);, EventWindow(), EventGadget(), #PB_EventType_StatusChange ) ; 
  BindEvent(#PB_Event_CloseMessage, @WaitCloseMessage( ) )
  ;FreeGadget( gadget )
EndProcedure

;\\
Procedure gadget_event( )
  If IsWindow(EventWindow())
    Static one
    Select EventType()
      Case #PB_EventType_LeftClick
        Debug "click"
        Select EventGadget()
          Case 0
            If one = 0
              one = 1
              Debug "messageCreate"
              OpenMessage( WindowID(EventWindow()))
              ;
            EndIf
        EndSelect
        
      Case #PB_EventType_MouseEnter
        Debug "enter " + EventType( ) +" "+ EventGadget() +" " + EventWindow()
      Case #PB_EventType_MouseLeave
        Debug "leave " + EventType( ) +" "+ EventGadget() +" " + EventWindow()
    EndSelect
  EndIf
EndProcedure

OpenWindow(0, 50, 50, 200, 200, "pb-win", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
ButtonGadget(0, 10, 10, 180, 180, "button")

BindEvent(#PB_Event_Gadget, @gadget_event())

Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_CloseMessage
    Debug " #PB_Event_CloseMessage"
    While WaitWindowEvent( ) : Wend
  EndIf
  If Event = #PB_Event_LeftClick
    Debug " pb_window_leftclick"
  EndIf
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP