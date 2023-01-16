EnableExplicit
#MAINWIN = 1
#MAINTIMER = 2
#MAXWINDOWS = 100

;AXUIELEMENT: https://developer.apple.com/reference/applicationservices/axuielement.h?language=objc
;Getting unique windows: http://stackoverflow.com/questions/311956/getting-a-unique-id-for-a-window-of-another-application
;---------------------EXTERNAL------------------------
ImportC "-framework ApplicationServices"
	AXUIElementCreateApplication(pid.i)	
	AXUIElementCopyAttributeValues(element, attribute, index, maxValues, *value)
	AXUIElementCopyAttributeValue(element, attribute, *value)
	AXIsProcessTrustedWithOptions(options)
	AXValueCreate(theType, *valuePtr)
	AXUIElementSetAttributeValue(element, attribute, value)
	AXUIElementPerformAction(element, action)
	AXValueGetValue(value, theType, *valuePtr)
	CFDictionaryGetValue(_1,_2)
	CFStringCreateWithCharacters.i (*alloc, *bytes, numChars.i)
	CFStringCompare(theString1, theString2, compareOptions);
	CFArrayCreate(allocator, *values, numValues, *callBacks)
	CFArrayGetCount(theArray) 
	CFArrayGetValueAtIndex(theArray, idx)
	CFStringGetSystemEncoding()
	CFUserNotificationDisplayNotice(Timeout.d, AlertLevel.i, IconUrl.l, SoundUrl.l, LocalizationUrl.l, Title.l, Message.l, DefBtnTitle.l)
	CFStringGetCStringPtr(l1,l2)
	CFStringGetCString(CFStringRef, *StringBuffer, BufferSize.i, CFStringEncoding.i)
	CFBooleanGetValue(boolean)
	CFRelease(cf)
	
	CGWindowListCopyWindowInfo(option, relativeToWindow = 0)
	
	AXObserverCreate(apppid, callback, *outObserver);
	AXObserverAddNotification(observer, element, notification, *refcon)
	AXObserverRemoveNotification(observer, element, notification)
	
	CFRunLoopAddSource(rl, source, mode);
	CFRunLoopRun()
	CFRunLoopStop(rl)
	AXObserverGetRunLoopSource(observer);
EndImport

Global.i kCFBooleanTrue
Global.i kCFBooleanFalse
!mov rax, qword [kCFBooleanTruePtr]
!mov rdx, qword [kCFBooleanFalsePtr]
!mov rax, [rax]
!mov rdx, [rdx]
!mov [v_kCFBooleanTrue], rax
!mov [v_kCFBooleanFalse], rdx


DataSection
	!extern _kCFBooleanTrue
	!extern _kCFBooleanFalse
	!kCFBooleanTruePtr: dq _kCFBooleanTrue
	!kCFBooleanFalsePtr: dq _kCFBooleanFalse
EndDataSection

#NSImageLeft = 2
#NSApplicationActivationPolicyRegular = 0
#NSApplicationActivationPolicyAccessory = 1
#NSApplicationActivationPolicyProhibited = 2
#kAXValueCGPointType = 1
#kAXValueCGSizeType = 2
#kSetFrontProcessFrontWindowOnly = 1
#NSApplicationActivateAllWindows = 1 << 0
#NSApplicationActivateIgnoringOtherApps = 1 << 1

;Window List Option Constants
#kCGWindowListOptionAll                 = 0
#kCGWindowListOptionOnScreenOnly        = (1 << 0)
#kCGWindowListOptionOnScreenAboveWindow = (1 << 1)
#kCGWindowListOptionOnScreenBelowWindow = (1 << 2)
#kCGWindowListOptionIncludingWindow     = (1 << 3)
#kCGWindowListExcludeDesktopElements    = (1 << 4)
;-------------------------------------------------------


;-----------------------MACROS---------------------------
Macro DoubleQuote
	"
EndMacro

Macro defKValue(name)
	Global name#_STR.s = DoubleQuote#name#DoubleQuote
	Global name = CFStringCreateWithCharacters(#Null, @name#_STR, Len(name#_STR))
EndMacro
;---------------------------------------------------------

;----------------------GLOBAL/STRUCT----------------------
Structure Window
	index.i
	localindex.i
	pid.i
	app_title.s
	win_title.s
	icon.i
	x.i
	y.i
	w.i
	h.i
	observerRef.i
	observerRef2.i
	appref.i
	nowin.b
	timecreated.i
EndStructure

Global G_EntryHeight.i = 32
Global G_EntryWidth.i = 128
Global G_sharedapp.i = CocoaMessage(0,0,"NSApplication sharedApplication")
Global G_workspace.i = CocoaMessage(0,0, "NSWorkspace sharedWorkspace")
Global G_thispid.i = 0

Global G_LastWinCount = 0

;for app notify
Global G_dncenter = CocoaMessage(0, 0, "NSDistributedNotificationCenter defaultCenter")
Global G_ncenter = CocoaMessage(0, G_workspace, "notificationCenter")
Global G_appdelegate = CocoaMessage(0, G_sharedapp, "delegate")
Global G_delegateclass = CocoaMessage(0, G_appdelegate, "class")

;Global G_dncenter = CocoaMessage(0, 0, "NSDistributedNotificationCenter defaultCenter")
Global G_observerRef
Global G_currentRunloop


Global NewList G_taskbar_items.window()
;Global NewList G_taskbar_currentpids.i()

Declare AddObserver(pid, element, notificationtype)
Declare RemoveObserver(observerRef, element, notificationtype)

defKValue(AXMain)
defKValue(AXWindows)
defKValue(AXFocused)
defKValue(AXFocusedWindow)
defKValue(AXHidden)
defKValue(AXFrontmost)
defKValue(AXRaise)
defKValue(AXMinimized)
defKValue(AXTitle)
defKValue(AXPosition)
defKValue(AXCloseButton)
defKValue(AXPress)
defKValue(AXSize)
defKValue(AXWindowCreated)
defKValue(AXMainWindowChanged)
defKValue(AXUIElementDestroyed)
defKValue(AXResized)
defKValue(kCFRunLoopDefaultMode)

;--------------------------------------------------------

;----------------------PROCEDURES------------------------

Procedure GetCurrentDesktopWidth()
	ExamineDesktops()
	ProcedureReturn DesktopWidth(0)
EndProcedure

Procedure GetCurrentDesktopHeight()
	ExamineDesktops()
	ProcedureReturn DesktopHeight(0)
EndProcedure

Procedure GetDesktopLowerYPosition(yoffset)
	ProcedureReturn GetCurrentDesktopHeight() - yoffset
EndProcedure

Procedure.s GetNSRunningAppName(appobj)
	Define lname = CocoaMessage(0,appobj,"localizedName")
	If lname
		Define lname_str.s = PeekS(CocoaMessage(0, lname, "UTF8String"), -1, #PB_UTF8)
		ProcedureReturn lname_str
	Else
		ProcedureReturn ""
	EndIf
EndProcedure


Procedure.s CFStringToStr(cfstringref.i)
	If cfstringref = 0 : ProcedureReturn "" : EndIf
	;CFUserNotificationDisplayNotice(0,1, #Null,#Null, #Null, cfstringref, cfstringref, #Null)
	
	;Define String.s = Space(256)
	
	ProcedureReturn PeekS(CocoaMessage(0, cfstringref, "UTF8String"), -1, #PB_UTF8)
	
	;CFStringGetCString(cfstringref, @String, Len(String), 0)
	;Define tmp.s = Trim(PeekS(@String, -1, #PB_UTF8))
	;MessageRequester(tmp, tmp)
	;ProcedureReturn tmp
EndProcedure


Procedure GetCurrentWinCount()
	Define w = CGWindowListCopyWindowInfo(#kCGWindowListOptionAll)
	Define wincount = CFArrayGetCount(w)
	CFRelease(w)
	ProcedureReturn wincount
EndProcedure


Procedure RefreshTaskbar()
	ResizeWindow(#MAINWIN, 0,GetDesktopLowerYPosition(G_EntryHeight), GetCurrentDesktopWidth(), G_EntryHeight)

	;clear gadgets
	ForEach G_taskbar_items()
		If G_taskbar_items()\observerRef <> 0
			RemoveObserver(G_taskbar_items()\observerRef, G_taskbar_items()\appref, AXWindowCreated)
			CFRelease(G_taskbar_items()\observerRef)		
		EndIf
		
		If G_taskbar_items()\observerRef2 <> 0
			RemoveObserver(G_taskbar_items()\observerRef2, G_taskbar_items()\appref, AXUIElementDestroyed)
			CFRelease(G_taskbar_items()\observerRef2)		
		EndIf
		
		If G_taskbar_items()\appref <> 0
			CFRelease(G_taskbar_items()\appref)
		EndIf
		
		If G_taskbar_items()\index <> -1
		FreeGadget(G_taskbar_items()\index)
		EndIf
	Next
	;Debug "REFRESH"
	ClearList(G_taskbar_items())
	;ClearList(G_taskbar_currentpids())
	
	;GET CURRENT WINDOWS AND PUT IN LIST
	Define runningapps = CocoaMessage(0,G_workspace,"runningApplications")
	Define count = CocoaMessage(0,runningapps,"count")
	Define i = 0
	For i = 0 To count - 1
		Define current_app = CocoaMessage(0,runningapps,"objectAtIndex:",i)
		If current_app
			If CocoaMessage(0,current_app,"activationPolicy") = #NSApplicationActivationPolicyRegular
				Define appname.s = GetNSRunningAppName(current_app)
				
				;get windows object for current app
				Define pid = CocoaMessage(0, current_app, "processIdentifier")
				If G_thispid = pid  
					Continue
				EndIf
				
				;AddElement(G_taskbar_currentpids())
				;G_taskbar_currentpids() = pid
				
				Define appref = AXUIElementCreateApplication(pid)
				Define appwindows
				AXUIElementCopyAttributeValues(appref, AXWindows, 0, #MAXWINDOWS, @appwindows);
				If appwindows = 0: CFRelease(appref) : Continue : EndIf
				
				;get icon and resize
				Define icon = CocoaMessage(0, current_app, "icon")
				Define icon_size.NSSize
				icon_size\height = G_EntryHeight * 0.8
				icon_size\width = G_EntryHeight * 0.8
				CocoaMessage(0, icon, "setSize:@", @icon_size)
				
				;iterate through windows
				Define j = 0
				Define win = 0
				Define cli = -1
				Define wincount = 0
				For j = 0 To CFArrayGetCount(appwindows) -1
					Define title
					win = CFArrayGetValueAtIndex(appwindows, j)
					AXUIElementCopyAttributeValue(win, AXTitle, @title)
					If CFStringToStr(title) = "" And appname = "Finder"
						Continue
					EndIf
					
					;get window position
					Define posref = 0
					Define pos_val.CGPoint
					AXUIElementCopyAttributeValue(win, AXPosition, @posref)
					If posref
						AXValueGetValue(posref, #kAXValueCGPointType,@pos_val)
					EndIf
					
					;get window width height
					Define sizeref = 0
					Define size_val.CGSize
					AXUIElementCopyAttributeValue(win, AXSize, @sizeref)
					If sizeref
						AXValueGetValue(sizeref, #kAXValueCGSizeType, @size_val)
					EndIf
					
					;adjust window when required
					Define lowerypos = GetDesktopLowerYPosition(G_EntryHeight)
					If pos_val\y + size_val\height > lowerypos
						Define newsize.CGSize
						newsize\width = size_val\width
						newsize\height = size_val\height - (pos_val\y + size_val\height - lowerypos)
						Define newsizeaxval = AXValueCreate(#kAXValueCGSizeType, newsize)
						AXUIElementSetAttributeValue(win, AXSize, newsizeaxval)
						size_val\height = newsize\height
					EndIf
					
					;add notify
					;Define observerref = AddObserver(pid, win, AXResized)			
					
					AddElement(G_taskbar_items())
					G_taskbar_items()\app_title = appname
					G_taskbar_items()\win_title = CFStringToStr(title)
					G_taskbar_items()\pid = pid
					G_taskbar_items()\localindex = j
					G_taskbar_items()\icon = CocoaMessage(0, current_app, "icon")
					G_taskbar_items()\x = pos_val\x
					G_taskbar_items()\y = pos_val\y
					G_taskbar_items()\w = size_val\width
					G_taskbar_items()\h = size_val\height
					G_taskbar_items()\icon = icon
					G_taskbar_items()\timecreated = ElapsedMilliseconds()
					If j = 0 
						G_taskbar_items()\observerRef = AddObserver(pid,appref, AXWindowCreated)
						G_taskbar_items()\observerRef2 = AddObserver(pid, appref, AXUIElementDestroyed)
						G_taskbar_items()\appref = appref
					EndIf
					If cli = -1
						cli = ListIndex(G_taskbar_items())
					EndIf
					wincount + 1
				Next
				;sort windows for app so they stay in place
				If wincount <> 1 And cli >= 0
					SortStructuredList(G_taskbar_items(),#PB_Sort_Ascending, OffsetOf(Window\win_title), TypeOf(Window\win_title), cli,cli + wincount - 1)
				EndIf
				
				
				If ListSize(G_taskbar_items()) = 0
					AddElement(G_taskbar_items())
					G_taskbar_items()\observerRef = AddObserver(pid,appref, AXWindowCreated)
					G_taskbar_items()\observerRef2 = AddObserver(pid, appref, AXUIElementDestroyed)
					G_taskbar_items()\appref = appref
					G_taskbar_items()\nowin = #True
					G_taskbar_items()\index =  -1
				EndIf
				
				CFRelease(win)
				
			EndIf
		EndIf
		
		;FILL THE TASKBAR
		Define taskentry_h = G_EntryHeight
		Define taskentry_w = G_EntryWidth
		Define nowx = 0
		Define nowy = 0
		Define gadgetnow = 0
		
		;START BUTTON
		gadgetnow + 1
		ButtonGadget(gadgetnow, 0, 0, taskentry_h, taskentry_h, "S")
		CocoaMessage(0, GadgetID(gadgetnow), "setBezelStyle:", @"NSShadowlessSquareBezelStyle")
		
		nowx = nowx + taskentry_h 
		ForEach G_taskbar_items()
			If G_taskbar_items()\nowin = #True : Continue : EndIf
			gadgetnow+1
			;			ButtonImageGadget(gadgetnow, nowx, 0, taskentry_w, taskentry_h, G_taskbar_items()\icon, G_taskbar_items()\win_title,#PB_Button_Default|#PB_Button_Toggle)
			;			CocoaMessage(0, GadgetID(cmd_1), "setBezelStyle:", GetGadgetState(spn_1))
			ButtonGadget(gadgetnow, nowx, 0, taskentry_w, taskentry_h, G_taskbar_items()\win_title,#PB_Button_Default)
			CocoaMessage(0, GadgetID(gadgetnow), "setBezelStyle:", @"NSShadowlessSquareBezelStyle")
			;CocoaMessage(0, GadgetID(gadgetnow), "setTitle:$", @"TEST")
			CocoaMessage(0, GadgetID(gadgetnow), "setImage:", G_taskbar_items()\icon)
			CocoaMessage(0, GadgetID(gadgetnow), "setImagePosition:", #NSImageLeft)
			;CocoaMessage(0, GadgetID(gadgetnow), "highlight:", #YES)
			nowx+taskentry_w 
			G_taskbar_items()\index = gadgetnow
		Next
		
	Next
	G_LastWinCount = GetCurrentWinCount()
EndProcedure

Procedure WindowToFront(pid	.i, localindex.i, act_deact.b = #True)
	Define appref = AXUIElementCreateApplication(pid)
	Define appwindows
	AXUIElementCopyAttributeValues(appref, AXWindows, 0, 100, @appwindows);
	If appwindows = 0: ProcedureReturn #False : EndIf
	Define runapp = CocoaMessage(0, 0, "NSRunningApplication runningApplicationWithProcessIdentifier:", pid)
	
	;AXUIElementSetAttributeValue(appref, AXHidden, kCFBooleanTrue)
	;iterate through windows
	Define j = 0
	Define win = 0
	For j = 0 To CFArrayGetCount(appwindows) -1
		If localindex = j
			win = CFArrayGetValueAtIndex(appwindows, j)
			AXUIElementSetAttributeValue(win, AXMain, kCFBooleanTrue)
			AXUIElementPerformAction(win, AXRaise)
			CocoaMessage(0,runapp, "activateWithOptions:",  #NSApplicationActivateIgnoringOtherApps )
		EndIf
	Next
	CFRelease(appref)
	;CocoaMessage(0, runapp, "release")
	RefreshTaskbar()
EndProcedure

Procedure ActivateTaskbarItem(eventnum)
	;toggle button
	Define state = GetGadgetData(eventnum)
	
	If state = #True
		SetGadgetData(eventnum, #False)
		
	Else
		SetGadgetData(eventnum, #True)
	EndIf
	
	ForEach G_taskbar_items()
		If G_taskbar_items()\index = eventnum
			WindowToFront(G_taskbar_items()\pid, G_taskbar_items()\localindex, GetGadgetData(eventnum))
		EndIf
	Next
EndProcedure

Procedure CheckWindowCount()
	Define wincount = GetCurrentWinCount()
	If G_LastWinCount <> wincount
		RefreshTaskbar()
	EndIf
EndProcedure

ProcedureC ObserverCallback()
	RefreshTaskbar()
EndProcedure

Procedure AddObserver(pid, element, notificationtype)
	;http://stackoverflow.com/questions/853833/how-can-my-app-detect-a-change-To-another-apps-window
	Define observerRef = 0
	AXObserverCreate( pid, @ObserverCallback(), @observerRef )
	If observerRef
		Define currentloop = CocoaMessage(0, 0,"NSRunLoop currentRunLoop")
		Define rl= CocoaMessage(0, currentloop, "getCFRunLoop")
		Define source=AXObserverGetRunLoopSource(observerRef)
		CFRunLoopAddSource(rl,source,kCFRunLoopDefaultMode)
		AXObserverAddNotification( observerRef, element, notificationtype, #nil );

	EndIf
	ProcedureReturn observerRef
EndProcedure


Procedure RemoveObserver(observerRef, element, notificationtype)
	AXObserverRemoveNotification(observerRef, element,notificationtype)
EndProcedure

; Procedure CheckWindowCountOld(obj,sel,notification)
; 	Define nameobj.i= CocoaMessage(0,notification, "name")
; 	Debug 1
; 	If CFStringToStr(nameobj) = "com.apple.Carbon.TISNotifySelectedKeyboardInputSourceChanged"
; 		Define newtotal
; 		Define wintotal = ListSize(G_taskbar_items()) + 1
; 		ForEach G_taskbar_currentpids()
; 			If G_taskbar_currentpids() = 0 : Continue : EndIf
; 			Define appref = AXUIElementCreateApplication(G_taskbar_currentpids())
; 			Define appwindows
; 			AXUIElementCopyAttributeValues(appref, AXWindows, 0, #MAXWINDOWS, @appwindows);
; 			If appwindows = 0: CFRelease(appref) : Continue : EndIf
; 			newtotal + (CFArrayGetCount(appwindows))		
; 			CFRelease(appref)		
; 		Next
; 		Debug wintotal
; 		Debug newtotal
; 		Debug "--------"
; 		If wintotal <> newtotal
; 			RefreshTaskbar()
; 		EndIf
; 	EndIf
; EndProcedure
;----------------------------------------------------------

;-----------------------MAINPROGRAM------------------------



;get pid of this app
Define tmpapp = CocoaMessage(0, 0, "NSRunningApplication currentApplication")
G_thispid = CocoaMessage(0, tmpapp, "processIdentifier")
OpenWindow(#MAINWIN, 0,GetDesktopLowerYPosition(G_EntryHeight), GetCurrentDesktopWidth(), G_EntryHeight, "TaskBar", #PB_Window_Tool| #PB_Window_BorderLess)

StickyWindow(#MAINWIN, #True)
RefreshTaskbar()

;code for when new app is launched or closed
Define selector = sel_registerName_("RefreshTaskbar")
class_addMethod_(G_delegateclass, selector, @RefreshTaskbar(), "v@:@")
CocoaMessage(0, G_ncenter, "addObserver:", G_appdelegate, "selector:", selector, "name:$", @"NSWorkspaceDidTerminateApplicationNotification", "object:", #nil) 
CocoaMessage(0, G_ncenter, "addObserver:", G_appdelegate, "selector:", selector, "name:$", @"NSWorkspaceDidLaunchApplicationNotification", "object:", #nil)
CocoaMessage(0, G_ncenter, "addObserver:", G_appdelegate, "selector:", selector, "name:$", @"NSWorkspaceDidHideApplicationNotification", "object:", #nil) ;NSWorkspaceDidHideApplication
CocoaMessage(0, G_ncenter, "addObserver:", G_appdelegate, "selector:", selector, "name:$", @"NSWorkspaceDidUnhideApplicationNotification", "object:", #nil)

;Define selector_chkwinc = sel_registerName_("CheckWindowCount:")
;class_addMethod_(G_delegateclass, selector_chkwinc, @CheckWindowCount(), "v@:@")
;CocoaMessage(0, G_dncenter, "addObserver:", G_appdelegate, "selector:", selector_chkwinc, "name:", #nil, "object:", #nil)

;CocoaMessage(0, G_sharedapp, "setActivationPolicy:", #NSApplicationActivationPolicyAccessory)

Define eventnum = 0
Repeat
	Select WaitWindowEvent()
		Case #PB_Event_Gadget
			eventnum = EventGadget()
			Select eventnum
				Case 1
					Break
				Default
					ActivateTaskbarItem(eventnum)	
			EndSelect
		Case #PB_Event_Menu
			eventnum = EventMenu()
			Select eventnum
				Case 1
				Default
					
			EndSelect
		Case #PB_Event_CloseWindow : Break
	EndSelect
ForEver


CocoaMessage(0, G_ncenter, "removeObserver:", G_appdelegate, "name:$", @"NSWorkspaceDidTerminateApplicationNotification", "object:", #nil)
CocoaMessage(0, G_ncenter, "removeObserver:", G_appdelegate, "name:$", @"NSWorkspaceDidLaunchApplicationNotification", "object:", #nil)
CocoaMessage(0, G_ncenter, "removeObserver:", G_appdelegate, "name:$", @"NSWorkspaceDidHideApplicationNotification", "object:", #nil)
CocoaMessage(0, G_ncenter, "removeObserver:", G_appdelegate, "name:$", @"NSWorkspaceDidUnhideApplicationNotification", "object:", #nil)
;-----------------------------------------------------------

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --------
; EnableXP