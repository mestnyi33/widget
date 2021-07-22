EnableExplicit

Define.i app, win, appDelegate, appDelegateClass
Define.NSSize size
Define.NSRect rect
Define.i myAppDelegateClass, myAppDelegate
Define.i myWindowDelegateClass, myWindowDelegate
Global.i pool

ProcedureC winShouldClose(obj.i, sel.i, win.i) ; call 1
	Define.i app
	
	Debug "winShouldClose - " + obj +" "+sel +" - "+win
	
	CocoaMessage(0, win, "release")
	;CocoaMessage(@app, 0, "NSApplication sharedApplication")
	;CocoaMessage(0, app, "terminate:", app)
	;CocoaMessage(0, win, "close")
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
	
	End
	ProcedureReturn #YES
EndProcedure


CocoaMessage(@pool, 0, "NSAutoreleasePool alloc")
CocoaMessage(0, pool, "init")

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

CocoaMessage(@win, 0, "NSWindow alloc")
myWindowDelegateClass = objc_allocateClassPair_(objc_getClass_("NSObject"), "myWindowDelegate", 0)
class_addProtocol_(myWindowDelegateClass, objc_getProtocol_("NSWindowDelegate"))
class_addMethod_(myWindowDelegateClass, sel_registerName_("windowShouldClose:"), @winShouldClose(), "c@:@")
;class_addMethod_(myWindowDelegateClass, sel_registerName_("applicationShouldTerminate:"), @appShouldTerminate(), "c@:@")
myWindowDelegate = class_createInstance_(myWindowDelegateClass, 0)

#NSBorderlessWindowMask = 0
#NSTitledWindowMask = 1 << 0
#NSClosableWindowMask = 1 << 1
#NSMiniaturizableWindowMask = 1 << 2
#NSResizableWindowMask = 1 << 3
#NSTexturedBackgroundWindowMask = 1 << 8

size\width = 100
size\height = 100

rect\origin\x = 100
rect\origin\y = 100
rect\size\width = 800
rect\size\height = 600

#MASK = #NSTitledWindowMask | #NSClosableWindowMask | #NSMiniaturizableWindowMask | #NSResizableWindowMask

CocoaMessage(0, win, "initWithContentRect:@", @rect, "styleMask:", #MASK, "backing:", 2, "defer:", #NO)
CocoaMessage(0, win, "makeKeyWindow")
CocoaMessage(0, win, "makeKeyAndOrderFront:", app)
CocoaMessage(0, win, "setTitle:$", @"My Window")
CocoaMessage(0, win, "setMinSize:@", @size)
CocoaMessage(0, win, "center")
CocoaMessage(0, win, "update")
CocoaMessage(0, win, "display")

CocoaMessage(0, win, "setPreventsApplicationTerminationWhenModal:", #NO)
CocoaMessage(0, win, "setReleasedWhenClosed:", #YES)

CocoaMessage(0, win, "setDelegate:", myWindowDelegate)

CocoaMessage(0, app, "run")
CocoaMessage(0, pool, "drain")

; Debug "END"
; CocoaMessage(0, app, "runModalForWindow:",win)
; CocoaMessage(0, app, "terminate:", app)
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP