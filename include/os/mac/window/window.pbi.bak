EnableExplicit
XIncludeFile "id.pbi"
XIncludeFile "mouse.pbi"

Global EventTap

Macro ClassName( windowID )
   ID::ClassName( windowID )
EndMacro

Macro __CloseWindow( win )
   ;CFRelease_(eventTap)
   CocoaMessage(0, win, "close")
EndMacro

Procedure __SetActiveWindow( win )
   ProcedureReturn CocoaMessage(0, win, "makeKeyWindow")
   ;  ProcedureReturn CocoaMessage(0, win, "makeKeyAndOrderFront:", app)
EndProcedure


Procedure __HideWindow( win, state )
   If ClassName( win ) = "PBWindow"
      ProcedureReturn CocoaMessage(0, win, "setIsVisible:", state)
   Else
      ProcedureReturn CocoaMessage(0, win, "stIsHidden", state)
   EndIf
EndProcedure

Procedure __IsHideWindow( win )
   If ClassName( win ) = "PBWindow"
      ProcedureReturn Bool(CocoaMessage(0, win, "isVisible") = 0)
   Else
      ProcedureReturn Bool(CocoaMessage(0, win, "isHidden"))
   EndIf
EndProcedure

Procedure __IsActiveWindow( win )
   ProcedureReturn CocoaMessage(0, win, "keyWindow")
EndProcedure

Procedure __IsMainWindow( win )
   ProcedureReturn CocoaMessage(0, win, "mainWindow")
EndProcedure

ImportC ""
   CFRunLoopGetCurrent()
   CFRunLoopAddCommonMode(rl, mode)
   
   CGEventTapCreate(tap.i, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
   
   ;     GetCurrentProcess(*psn)
   ;     CGEventTapCreateForPSN(*psn, place.i, options.i, eventsOfInterest.q, callback.i, refcon)
   CGEventTapCreateForPSN(*ProcessSerialNumber, CGEventTapPlacement.i, CGEventTapOptions.i, CGEventMask.Q, CGEventTapCallback.i, *UserData)
   GetCurrentProcess(*ProcessSerialNumber)
EndImport

Global psn.q

ProcedureC  eventTapFunction(proxy, eType, event, refcon) ; CGEventTapProxy.i, CGEventType.i, CGEvent.i,  *UserData
   Protected NSEvent = CocoaMessage(0, 0, "NSEvent eventWithCGEvent:", event)
   Protected hWnd = Mouse::Gadget( Mouse::Window( ) )
   
   If eType = #NSLeftMouseDown
      Debug "#NSLeftMouseDown "+id::gadget(hWnd)
   ElseIf eType = #NSLeftMouseUp 
      Debug "#NSLeftMouseUp "+id::gadget(hWnd)
   ElseIf eType = #NSRightMouseDown
      Debug "#NSRightMouseDown "+id::gadget(hWnd)
   ElseIf eType = #NSRightMouseUp
      Debug "#NSRightMouseUp "+id::gadget(hWnd)
   ElseIf eType = #NSOtherMouseDown
      Debug "#NSOtherMouseDown "+id::gadget(hWnd)
   ElseIf eType = #NSOtherMouseUp
      Debug "#NSOtherMouseUp "+id::gadget(hWnd)
   ElseIf eType = #NSMouseEntered
      Debug "#NSMouseEntered "+id::gadget(hWnd)
   ElseIf eType = #NSMouseMoved
      ;  Debug "#NSMouseMoved "+id::gadget(hWnd)
   ElseIf eType = #NSMouseExited
      Debug "#NSMouseExited "+id::gadget(hWnd)
   ElseIf eType = #NSWindowCloseButton
      Debug "#WM_CREATE "+id::gadget(hWnd)
   Else
      Debug ""+eType +" "+ NSEvent
   EndIf
   
   ; ProcedureReturn 1
EndProcedure

ProcedureC winShouldClose(obj.i, sel.i, win.i) 
   CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "stop:", win)
   ProcedureReturn #YES
EndProcedure

Procedure OpenWindow_(window, x, y, width, height, title.s, flags = 0, parentID = 0 )
   Protected app
   CocoaMessage(@app, 0, "NSApplication sharedApplication")
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
   
   UseGadgetList(win)
   ProcedureReturn win
EndProcedure

Procedure WaitCloseWindow_( *callback = #Null )
   Protected app
   CocoaMessage(@app, 0, "NSApplication sharedApplication")
   
   Protected mask
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
   
   
   ; с ним mousemove не происходит если приложение не активно
   ;eventTap = CGEventTapCreate(2, 0, 1, mask, @eventTapFunction(), *callback)
   
   ;\\
   GetCurrentProcess(@psn)
   eventTap = CGEventTapCreateForPSN(@psn, #headInsertEventTap, #cgSessionEventTap, mask, @eventTapFunction( ), *callback)
   
   ;\\
   If eventTap
      CocoaMessage(0, CocoaMessage(0, 0, "NSRunLoop currentRunLoop"), "addPort:", eventTap, "forMode:$", @"kCFRunLoopDefaultMode")
   EndIf
   
   ;\\
   CocoaMessage(0, app, "run")
   ; CFRelease_(eventTap)
EndProcedure


;-\\
Declare EventsMessage( )

Procedure OpenPopup(ParentID=0)
   Static x,y
   x + 50
   y + 50
   Define win = OpenWindow_(10, 200+x, 100+y, 200, 200, "mac-win", #PB_Window_BorderLess|#PB_Window_NoActivate, ParentID)
   Protected UseGadgetList = UseGadgetList(win)
   Protected gadget = CanvasGadget(-1, 10, 20-10, 180, 180)
   
   ;\\
   StartDrawing(CanvasOutput(gadget))
   Box(10,10,30,30,$ff0000)
   StopDrawing()
   
   ;\\
   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseEnter )
   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseLeave )
   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonDown )
   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonUp )
   ;BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftClick )
   ;ETCallback = SetWindowLongPtr_(GadgetID(gadget), #GWL_WNDPROC, @EventTypeCallback())
   
   ;\\
   objc_setAssociatedObject_(GadgetID(Gadget), "ParentID", win, 0) 
   ;   SetWindowPos_( win, #HWND_TOPMOST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOACTIVATE )
   
   ;\\
   Protected closeButton = ButtonGadget(-1, 100,100,80,80,"close" )
   BindGadgetEvent( closeButton, @EventsMessage(), #PB_EventType_LeftClick )
   ;ETCallback = SetWindowLongPtr_(GadgetID(closeButton), #GWL_WNDPROC, @EventTypeCallback())
   ;objc_setAssociatedObject_(GadgetID(closeButton), "oldproc", ETCallback, 0)
   objc_setAssociatedObject_(GadgetID(closeButton), "ParentID", win, 0) 
   
   ;\\
   If ParentID
      objc_setAssociatedObject_(win, "ParentID", ParentID, 0) 
      ;objc_setAssociatedObject_(ParentID, "ChildID", win, 0) 
      ;\\ Всплывающее окно чтобы не забирала фокус у Вызваного окна
      ;SetWindowPos_( ParentID, 0,0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER )
      ;;;SendMessage_(#HWND_BROADCAST, #WM_SYSCOMMAND, #SC_HOTKEY, ParentID)
   EndIf
   
   UseGadgetList(UseGadgetList)
EndProcedure

Procedure OpenMessage(ParentID=0)
   Define win = OpenWindow_(10, 160, 100, 200, 200, "mac-win", #PB_Window_BorderLess, ParentID)
   Protected gadget = CanvasGadget(-1, 10, 20-10, 180, 180)
   
   
   StartDrawing(CanvasOutput(gadget))
   Box(10,10,30,30,$ff0000)
   StopDrawing()
   
   ;   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseEnter )
   ;   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_MouseLeave )
   ;   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonDown )
   ;   BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftButtonUp )
   ;   ;BindGadgetEvent( gadget, @EventsMessage(), #PB_EventType_LeftClick )
   ;   ETCallback = SetWindowLongPtr_(GadgetID(gadget), #GWL_WNDPROC, @EventTypeCallback())
   
   objc_setAssociatedObject_(GadgetID(Gadget), "ParentID", win, 0) 
   
   ;\\
   Protected closeButton = ButtonGadget(-1, 100,100,80,80,"close" )
   objc_setAssociatedObject_(GadgetID(closeButton), "ParentID", win, 0) 
   ;   ETCallback = SetWindowLongPtr_(GadgetID(closeButton), #GWL_WNDPROC, @EventTypeCallback())
   BindGadgetEvent( closeButton, @EventsMessage(), #PB_EventType_LeftClick )
   
   If ParentID
      UseGadgetList(ParentID)
   EndIf
   
   WaitCloseWindow_( )
   
   ;FreeGadget( gadget )
   Debug "Quit MESSAGE"
EndProcedure

Procedure EventsMessage( )
   Static click, enter
   Protected WindowID = objc_getAssociatedObject_(GadgetID(EventGadget()), "ParentID")
   Protected ParentID = objc_getAssociatedObject_(WindowID, "ParentID")
   
   ;\\
   Select EventType()
      Case #PB_EventType_LeftClick
         Debug "close"
         __CloseWindow(WindowID)
         
      Case #PB_EventType_MouseEnter
         If enter = 0
            Debug "message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
            enter = 1
         Else
            ;Debug " bug message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
         EndIf
         
      Case #PB_EventType_MouseLeave
         If enter = 1
            Debug "message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
            enter = 0
         EndIf
         
      Case #PB_EventType_LeftButtonUp
         If click = 1
            Debug "message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
            click = 0
         EndIf
         
      Case #PB_EventType_LeftButtonDown
         If click = 0
            click = 1
            Debug "message " + EventType( ) +" "+ EventGadget() +" "+ WindowID
            OpenPopup( ParentID )
            ; OpenMessage( WindowID )
            
            ;         ;\\ Всплывающее окно чтобы не забирала фокус у Вызваного окна
            ;         SetWindowPos_( ParentID, 0,0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER )
         EndIf
   EndSelect
EndProcedure

;\\
Procedure gadget_event( )
   If IsWindow(EventWindow())
      Select EventType()
         Case #PB_EventType_LeftClick
            Debug "click"
            
         Case #PB_EventType_LeftButtonDown
            Select EventGadget()
               Case 0
                  ;Debug "messageCreate"
                  ;OpenPopup( WindowID( EventWindow( )))
                  OpenMessage( WindowID( EventWindow( )))
            EndSelect
            
         Case #PB_EventType_MouseEnter
            Debug "enter " + EventType( ) +" "+ EventGadget() +" " + EventWindow()
         Case #PB_EventType_MouseLeave
            Debug "leave " + EventType( ) +" "+ EventGadget() +" " + EventWindow()
      EndSelect
   EndIf
EndProcedure

OpenWindow(0, 50, 50, 200, 200, "pb-win", #PB_Window_SizeGadget | #PB_Window_SystemMenu)
CanvasGadget(0, 10, 10, 180, 180)
StartDrawing(CanvasOutput(0))
DrawText( 30,45, "button_0")
StopDrawing()

BindEvent(#PB_Event_Gadget, @gadget_event())

Define Event
Repeat
   Event = WaitWindowEvent()
   If Event = #PB_Event_LeftClick
      Debug " pb_window_leftclick"
   EndIf
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 84
; FirstLine = 58
; Folding = ------
; EnableXP