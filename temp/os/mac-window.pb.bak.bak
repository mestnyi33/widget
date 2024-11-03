EnableExplicit

Global.i app, appDelegate, appDelegateClass
Define.i myAppDelegateClass, myAppDelegate
Global.i pool

; TOP
; MacOS: Get menubar height

; #NSApplicationActivateAllWindows = 1 << 0
; #NSApplicationActivateIgnoringOtherApps = 1 << 1
; 
; currentApplication = CocoaMessage(0, 0, "NSRunningApplication currentApplication")
; CocoaMessage(0, currentApplication, "activateWithOptions:", #NSApplicationActivateAllWindows | #NSApplicationActivateIgnoringOtherApps)


ImportC "-framework ApplicationServices"
; 	AXUIElementCreateApplication(pid.i)	
; 	AXUIElementCopyAttributeValues(element, attribute, index, maxValues, *value)
; 	AXUIElementCopyAttributeValue(element, attribute, *value)
; 	AXIsProcessTrustedWithOptions(options)
; 	AXValueCreate(theType, *valuePtr)
; 	AXUIElementSetAttributeValue(element, attribute, value)
; 	AXUIElementPerformAction(element, action)
; 	AXValueGetValue(value, theType, *valuePtr)
; 	CFDictionaryGetValue(_1,_2)
; 	CFStringCreateWithCharacters.i (*alloc, *bytes, numChars.i)
; 	CFStringCompare(theString1, theString2, compareOptions);
; 	CFArrayCreate(allocator, *values, numValues, *callBacks)
; 	CFArrayGetValueAtIndex(theArray, idx)
; 	CFStringGetSystemEncoding()
; 	CFUserNotificationDisplayNotice(Timeout.d, AlertLevel.i, IconUrl.l, SoundUrl.l, LocalizationUrl.l, Title.l, Message.l, DefBtnTitle.l)
; 	CFStringGetCStringPtr(l1,l2)
; 	CFStringGetCString(CFStringRef, *StringBuffer, BufferSize.i, CFStringEncoding.i)
; 	CFBooleanGetValue(boolean)
; 	
	CGWindowListCopyWindowInfo(option, relativeToWindow = 0)
	CFArrayGetCount(theArray) 
	CFRelease(cf)
; 	
; 	AXObserverCreate(apppid, callback, *outObserver);
; 	AXObserverAddNotification(observer, element, notification, *refcon)
; 	AXObserverRemoveNotification(observer, element, notification)
; 	
; 	CFRunLoopAddSource(rl, source, mode);
; 	CFRunLoopRun()
; 	CFRunLoopStop(rl)
; 	AXObserverGetRunLoopSource(observer);
EndImport
;Window List Option Constants
#kCGWindowListOptionAll                 = 0
#kCGWindowListOptionOnScreenOnly        = (1 << 0)
#kCGWindowListOptionOnScreenAboveWindow = (1 << 1)
#kCGWindowListOptionOnScreenBelowWindow = (1 << 2)
#kCGWindowListOptionIncludingWindow     = (1 << 3)
#kCGWindowListExcludeDesktopElements    = (1 << 4)

Procedure GetCurrentWinCount()
	Define w = CGWindowListCopyWindowInfo(#kCGWindowListOptionAll)
	Define wincount = CFArrayGetCount(w)
	CFRelease(w)
	ProcedureReturn wincount
EndProcedure


Procedure CloseWindow_( win )
  CocoaMessage(0, win, "release")
  CocoaMessage(0, win, "close")
EndProcedure

ProcedureC winShouldClose(obj.i, sel.i, win.i) ; call 1
  Debug "winShouldClose - " + obj +" "+sel +" - "+win
  ; CloseWindow_( win )
  ProcedureReturn #YES
EndProcedure

ProcedureC appShouldTerminateALWC(obj.i, sel.i, app.i) ; call 2
  Debug "appShouldTerminateALWC - " + obj +" - "+sel +" - "+app
  
  ProcedureReturn #YES
EndProcedure

ProcedureC appShouldTerminate(obj.i, sel.i, app.i) ; call 3
  Debug "appShouldTerminate - " + obj +" - "+sel +" - "+app
  
  ProcedureReturn #YES
EndProcedure

ProcedureC appWillTerminate(obj.i, sel.i, ntn.i) ; call 4
  Debug "appWillTerminate - " + obj +" - "+sel +" - "+ntn
  
  CocoaMessage(0, app, "stop:", obj)
  ; CocoaMessage(0, app, "terminate:")
  End
  ProcedureReturn #YES
EndProcedure


; CocoaMessage(@pool, 0, "NSAutoreleasePool alloc")
; CocoaMessage(0, pool, "init")

CocoaMessage(@app, 0, "NSApplication sharedApplication")

; CocoaMessage(@appDelegate, app, "delegate")
; CocoaMessage(@appDelegateClass, appDelegate, "class")

myAppDelegateClass = objc_allocateClassPair_(objc_getClass_("NSObject"), "myAppDelegate", 0)
class_addProtocol_(myAppDelegateClass, objc_getProtocol_("NSApplicationDelegate"))

class_addMethod_(myAppDelegateClass, sel_registerName_("applicationShouldTerminate:"), @appShouldTerminate(), "L@:@")
class_addMethod_(myAppDelegateClass, sel_registerName_("applicationShouldTerminateAfterLastWindowClosed:"), @appShouldTerminateALWC(), "c@:@")
class_addMethod_(myAppDelegateClass, sel_registerName_("applicationWillTerminate:"), @appWillTerminate(), "v@:@")

objc_registerClassPair_(myAppDelegateClass)
myAppDelegate = class_createInstance_(myAppDelegateClass, 0)
CocoaMessage(0, app, "setDelegate:", myAppDelegate)

#NSBorderlessWindowMask = 0
#NSTitledWindowMask = 1 << 0
#NSClosableWindowMask = 1 << 1
#NSMiniaturizableWindowMask = 1 << 2
#NSResizableWindowMask = 1 << 3
#NSTexturedBackgroundWindowMask = 1 << 8

Procedure OpenWindow_(window, x, y, width, height, title.s, flags = 0, parentID = 0 )
  Protected.i win, myWindowDelegateClass, myWindowDelegate
  
  CocoaMessage(@win, 0, "NSWindow alloc")
  myWindowDelegateClass = objc_allocateClassPair_(objc_getClass_("NSObject"), "myWindowDelegate", 0)
  class_addProtocol_(myWindowDelegateClass, objc_getProtocol_("NSWindowDelegate"))
  class_addMethod_(myWindowDelegateClass, sel_registerName_("windowShouldClose:"), @winShouldClose(), "c@:@")
  ;class_addMethod_(myWindowDelegateClass, sel_registerName_("applicationShouldTerminate:"), @appShouldTerminate(), "c@:@")
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
  CocoaMessage(0, win, "makeKeyWindow")
  CocoaMessage(0, win, "makeKeyAndOrderFront:", app)
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

OpenWindow_(-1, 50,50, 300, 200, "Window_0")
OpenWindow_(-1, 200,60, 300, 200, "Window_1")
OpenWindow_(-1, 300,70, 300, 200, "Window_2")

Debug GetCurrentWinCount()
CocoaMessage(0, app, "run")
exit:
Debug "END"
;CocoaMessage(0, pool, "drain")

; CocoaMessage(0, app, "runModalForWindow:",win)
; CocoaMessage(0, app, "terminate:", app)
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 173
; FirstLine = 102
; Folding = -+
; EnableXP