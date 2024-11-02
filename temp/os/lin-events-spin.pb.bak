;   https://www.opennet.ru/docs/RUS/gtk_plus/x2447.html
;   gtk_signal_connect_ (GTK_OBJECT (drawing_area), "expose_event", @expose_event( ), #Null);
;   gtk_signal_connect_ (GTK_OBJECT(drawing_area),"configure_event", @configure_event( ), #Null);
;   gtk_signal_connect_ (GTK_OBJECT (drawing_area), "motion_notify_event", @motion_notify_event( ), #Null);
;   gtk_signal_connect_ (GTK_OBJECT (drawing_area), "button_press_event", @button_press_event( ), #Null);
;   gtk_widget_set_events_ (drawing_area, #GDK_EXPOSURE_MASK | #GDK_LEAVE_NOTIFY_MASK | #GDK_BUTTON_PRESS_MASK | #GDK_POINTER_MOTION_MASK | #GDK_POINTER_MOTION_HINT_MASK);
;   https://www.opennet.ru/docs/RUS/gtk_plus/c1246.html#SEC-EVENTBOX


; http://forums.purebasic.com/english/viewtopic.php?f=15&t=69051
; http://forums.purebasic.com/english/viewtopic.php?t=17182
; https://www.purebasic.fr/english/viewtopic.php?t=78737
EnableExplicit

; Object constants
#Win_Main  = 0

Enumeration
	#But1
	#SpBG1
	#SpBG2
	#But2
EndEnumeration

Global.i gEvent, gEventType, gQuit

;- Part for tweaked SpinGadgets ...
CompilerIf #PB_Compiler_OS = #PB_OS_Linux
	
	ImportC ""
		g_signal_connect(*instance, detailed_signal.p-utf8, *c_handler, *data, destroy= 0, flags= 0) As "g_signal_connect_data"
	EndImport
	
	;see https://git.gnome.org/browse/gtk+/plain/gdk/gdkkeysyms.h
	#GDK_KEY_Up  = $FF52
	#GDK_KEY_Down= $FF54
	
	Structure CALLBACKDATA
		GadgetNo.i
		WindowNo.i
	EndStructure
	Global NewList GadgetData.CALLBACKDATA() 
	
	ProcedureC Callback_SpinGadgetScroll(*widget.GtkWidget, *Event.GdkEventAny, *user_data.CALLBACKDATA); match callback name with the call in SpinGadget_Tweak
		Protected *ev_scroll.GdkEventScroll
		Protected *ev_keypress.GdkEventKey
		Protected Ret= #False
		
		If *Event\type = #GDK_SCROLL
			*ev_scroll= *Event
		ElseIf *Event\type = #GDK_KEY_PRESS
			*ev_keypress= *Event
		EndIf
		If (*ev_scroll And *ev_scroll\direction = #GDK_SCROLL_UP) Or (*ev_keypress And *ev_keypress\keyval = #GDK_KEY_Up)
			SetGadgetText(*user_data\GadgetNo, Str(Val(GetGadgetText(*user_data\GadgetNo))+ 1))
			PostEvent(#PB_Event_Gadget, *user_data\WindowNo, *user_data\GadgetNo, #PB_EventType_Up)
			PostEvent(#PB_Event_Gadget, *user_data\WindowNo, *user_data\GadgetNo, #PB_EventType_Change)
			Ret= #True;                                                    avoids focus change on up/down key
		ElseIf (*ev_scroll And *ev_scroll\direction = #GDK_SCROLL_DOWN) Or (*ev_keypress And *ev_keypress\keyval = #GDK_KEY_Down)
			SetGadgetText(*user_data\GadgetNo, Str(Val(GetGadgetText(*user_data\GadgetNo))- 1))
			PostEvent(#PB_Event_Gadget, *user_data\WindowNo, *user_data\GadgetNo, #PB_EventType_Down)
			PostEvent(#PB_Event_Gadget, *user_data\WindowNo, *user_data\GadgetNo, #PB_EventType_Change)
			Ret= #True;                                                    avoids focus change on up/down key
		EndIf
		ProcedureReturn Ret
	EndProcedure
	
CompilerEndIf

Procedure SpinGadget_Tweak(Window, Gadget)
	CompilerIf #PB_Compiler_OS = #PB_OS_Linux
		If GadgetType(Gadget) = #PB_GadgetType_Spin
			Protected *entry.GtkEntry = g_list_nth_data_(gtk_container_get_children_(GadgetID(Gadget)), 0)
			
			AddElement(GadgetData())
			GadgetData()\GadgetNo= Gadget
			GadgetData()\WindowNo= Window
			
			gtk_widget_add_events_(*entry, #GDK_SCROLL_MASK | #GDK_KEY_PRESS_MASK)
			g_signal_connect_(*entry, "scroll-event", @Callback_SpinGadgetScroll(), @GadgetData());    event on wheelscrolling over entry
			g_signal_connect_(*entry, "key-press-event", @Callback_SpinGadgetScroll(), @GadgetData()); event on key up/down on focussed entry
		EndIf
	CompilerEndIf
EndProcedure
;- ... End of part

Procedure Create_WinMain()
	If OpenWindow(#Win_Main, 300, 200, 600, 200, "PB-SpinGadget w. scrollwheel + up/down-key support", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
		ButtonGadget  (#But1,     5,   5, 100,  26, "Gadget in front")
		TextGadget    (#PB_Any,   5,  45, 190,  22, "Tweaked PB-StringGadget")
		SpinGadget    (#SpBG1,  200,  40, 100,  26, 0, 10, #PB_Spin_Numeric)
		TextGadget    (#PB_Any,   5,  80, 190,  22, "Standard PB-StringGadget")
		SpinGadget    (#SpBG2,  200,  75, 100,  26, 0, 10, #PB_Spin_Numeric)
		ButtonGadget  (#But2,     5, 110, 100,  26, "Gadget rear")
		
		SetGadgetState(#SpBG1,    5)
		SetGadgetState(#SpBG2,    5)
		
		SpinGadget_Tweak(#Win_Main, #SpBG1);                             add this call for each SpinGadget you wanna tweak
		
		GadgetToolTip(#SpBG1, "Use mousewheel on hover or up/down-keys on focused SpinGadget")
	EndIf
EndProcedure

Create_WinMain()

Repeat
	gEvent= WaitWindowEvent()
	
	Select gEvent
		Case #PB_Event_CloseWindow
			gQuit= #True
			
		Case #PB_Event_Gadget
			If EventGadget() = #SpBG1
				gEventType= EventType()
				If gEventType = #PB_EventType_Up
					Debug "SpinGadget up"
				ElseIf gEventType = #PB_EventType_Down
					Debug "SpinGadget down"
				ElseIf gEventType = #PB_EventType_Change
					Debug "SpinGadget change"
					Debug " ---"
				EndIf
			EndIf
			
	EndSelect
	
Until gQuit
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP