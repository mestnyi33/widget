;gadgetEx.pb
;Justin 07/24

EnableExplicit

#GADGETEX_PROP_CALLBACK = "_pb_cb_"
#GADGETEX_PROP_OLD_PROC = "_pb_oldProc_"

Enumeration
	#GADGETEX_EVENT_MOUSEMOVE
EndEnumeration

Structure GADGETEX_EVENT
	type.l
EndStructure

Structure GADGETEX_EVENT_MOUSEMOVE Extends GADGETEX_EVENT
	x.l
	y.l
EndStructure

Prototype gadgetEx_callbackProto(gdt.i, *evt.GADGETEX_EVENT)

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
	Macro HIWORD(Value)
		(((Value) >> 16) & $FFFF)
	EndMacro
	
	Macro LOWORD(Value)
		((Value) & $FFFF)
	EndMacro
	
	Procedure gadgetEx_onMouseMoveWin(hwnd.i, msg.l, wparam.i, lparam.i)
		Protected.gadgetEx_callbackProto cb
		Protected.GADGETEX_EVENT_MOUSEMOVE ev
		
		cb = GetProp_(hwnd, #GADGETEX_PROP_CALLBACK)
		If cb
			ev\type = #GADGETEX_EVENT_MOUSEMOVE
			ev\x = LOWORD(lparam)
			ev\y = HIWORD(lparam)
			
			cb(GetProp_(hwnd, "PB_ID"), @ev)
		EndIf
	EndProcedure
	
	Procedure gadgetEx_proc(hwnd.i, msg.l, wparam.i, lparam.i)
		Select msg
			Case #WM_MOUSEMOVE : gadgetEx_onMouseMoveWin(hwnd, msg, wparam, lparam)
		EndSelect
	
		ProcedureReturn CallWindowProc_(GetProp_(hwnd, #GADGETEX_PROP_OLD_PROC), hwnd, msg, wparam, lparam)
	EndProcedure

CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
	#OBJC_ASSOCIATION_ASSIGN = 0       
	
	;- Enum NSTrackingAreaOptions
	#NSTrackingMouseEnteredAndExited = $01
	#NSTrackingMouseMoved = $02
	#NSTrackingCursorUpdate = $04
	#NSTrackingActiveWhenFirstResponder = $10
	#NSTrackingActiveInKeyWindow = $20
	#NSTrackingActiveInActiveApp = $40
	#NSTrackingActiveAlways = $80
	#NSTrackingAssumeInside = $100
	#NSTrackingInVisibleRect = $200
	#NSTrackingEnabledDuringMouseDrag = $400
	  
	Procedure gadgetEx_onMouseMoveHandler(obj.i, sel.i, nsEv.i)
		Protected.NSPoint pt
		Protected.GADGETEX_EVENT_MOUSEMOVE ev
		Protected.gadgetEx_callbackProto cb
		Protected.i gdt
		
		gdt = CocoaMessage(0, obj, "tag")
		CocoaMessage(@pt, nsEv, "locationInWindow")
		CocoaMessage(@pt, obj, "convertPoint:@", @pt, "fromView:", #nil)

		ev\type = #GADGETEX_EVENT_MOUSEMOVE
		ev\x = pt\x
		ev\y = GadgetHeight(gdt) - pt\y
		
		cb = objc_getAssociatedObject_(obj, #GADGETEX_PROP_CALLBACK)

		If cb
			cb(gdt, @ev)
		EndIf
	EndProcedure
	
	Procedure gadgetEx_onMouseMovedMac(obj.i, sel.i, nsEv.i)
		gadgetEx_onMouseMoveHandler(obj, sel, nsEv)
	EndProcedure
	
	Procedure gadgetEx_onMouseDraggedMac(obj.i, sel.i, nsEv.i)
		gadgetEx_onMouseMoveHandler(obj, sel, nsEv)
	EndProcedure
	
ProcedureC gadgetEx_onUpdateTrackingAreas(obj.i, sel.i)
	Protected.NSRect rc
	Static.i trackingArea
	
	If trackingArea
		CocoaMessage(0, obj, "removeTrackingArea:", trackingArea)
		CocoaMessage(0, trackingArea, "release")
	EndIf
		
	trackingArea = CocoaMessage(0, 0, "NSTrackingArea alloc")
	CocoaMessage(0, trackingArea, "initWithRect:@", @rc, 
		"options:", #NSTrackingMouseEnteredAndExited | #NSTrackingActiveInActiveApp | #NSTrackingInVisibleRect | #NSTrackingMouseMoved, 
		"owner:", obj, "userInfo:", #nil)
			
	CocoaMessage(0, obj, "addTrackingArea:", trackingArea)
EndProcedure
CompilerEndIf

Procedure gadgetEx_setup(gdt.i, callback.i)
	Protected.i osHandle
	
	osHandle = GadgetID(gdt)

	CompilerIf #PB_Compiler_OS = #PB_OS_Windows		
		SetProp_(osHandle, #GADGETEX_PROP_CALLBACK, callback)
		SetProp_(osHandle, #GADGETEX_PROP_OLD_PROC, SetWindowLongPtr_(osHandle, #GWLP_WNDPROC, @gadgetEx_proc()))
		
	CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
		Protected.i viewClass
		
		objc_setAssociatedObject_(osHandle, #GADGETEX_PROP_CALLBACK, callback, #OBJC_ASSOCIATION_ASSIGN)
		viewClass = object_getClass_(osHandle)
		
		class_replaceMethod_(viewClass, sel_registerName_("mouseMoved:"), @gadgetEx_onMouseMovedMac(), "v@:@")
		class_replaceMethod_(viewClass, sel_registerName_("mouseDragged:"), @gadgetEx_onMouseDraggedMac(), "v@:@")

		class_replaceMethod_(viewClass, sel_registerName_("updateTrackingAreas"), @gadgetEx_onUpdateTrackingAreas(), "v@:")
	CompilerEndIf
EndProcedure

;- TEST
Procedure imgGdt1_Callback(gdt.i, *evt.GADGETEX_EVENT)
	Select *evt\type
		Case #GADGETEX_EVENT_MOUSEMOVE
			Protected.GADGETEX_EVENT_MOUSEMOVE *evtMouseMove = *evt
			
			Debug "img mouse move " + *evtMouseMove\x + " " + *evtMouseMove\y
	EndSelect
EndProcedure

Procedure canvasMouseMove()
	Debug "canvas mouse move" + GetGadgetAttribute(2, #PB_Canvas_MouseX) + " " + GetGadgetAttribute(2, #PB_Canvas_MouseY)
EndProcedure

Procedure main()
	OpenWindow(0, 0, 0, 245, 105, "ImageGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	If LoadImage(0, #PB_Compiler_Home + "examples\sources\Data\File.bmp")
	   Debug 444
	   ImageGadget(1,  10, 10, 100, 83, ImageID(0))
		CanvasGadget(2,  130, 10, 100, 83)
		BindGadgetEvent(2, @canvasMouseMove(), #PB_EventType_MouseMove) 
		gadgetEx_setup(1, @imgGdt1_Callback())
		
		Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
	EndIf
EndProcedure

main()

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 4
; FirstLine = 126
; Folding = ----
; EnableXP