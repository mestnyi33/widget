; https://www.purebasic.fr/english/viewtopic.php?t=79678
Structure GdkEventScroll_ Align #PB_Structure_AlignC
	type.l
	window.i
	sendEvent.b
	time.l
	x.d
	y.d
	state.l
	direction.l
	device.i
	xRoot.d
	yRoot.d
	deltaX.d
	deltaY.d
EndStructure

Structure GdkEvent_ Align #PB_Structure_AlignC
	StructureUnion
		type.l
		any.GdkEventAny
		expose.GdkEventExpose
		visibility.GdkEventVisibility
		motion.GdkEventMotion
		button.GdkEventButton
		; 		touch.GdkEventTouch
		scroll.GdkEventScroll_
		key.GdkEventKey
		crossing.GdkEventCrossing
		focus_change.GdkEventFocus
		configure.GdkEventConfigure
		property.GdkEventProperty
		selection.GdkEventSelection
		; 		owner_change.GdkEventOwnerChange
		proximity.GdkEventProximity
		dnd.GdkEventDND
		window_state.GdkEventWindowState
		setting.GdkEventSetting
		; 		grab_broken.GdkEventGrabBroken
		; 		touchpad_swipe.GdkEventTouchpadSwipe
		; 		touchpad_pinch.GdkEventTouchpadPinch
		; 		pad_button.GdkEventPadButton
		; 		pad_axis.GdkEventPadAxis
		; 		pad_group_mode.GdkEventPadGroupMode
	EndStructureUnion
EndStructure

  
  ProcedureC on_scroll(wd.i, *ev.GdkEvent_, id_canvas.i)
  	Debug "scr "
  	Debug (*ev\scroll\deltaY) * -1
  EndProcedure
  
  #ID_CANVAS = 0
  
  If OpenWindow(0, 0, 0, 220, 220, "CanvasGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    ; This works:
;     CanvasGadget(0, 10, 10, 200, 200)
    
;     This doesn't work:
    CanvasGadget(#ID_CANVAS, 10, 10, 200, 200, #PB_Canvas_Container)
    g_signal_connect_(GadgetID(0), "scroll-event", @on_scroll(), #ID_CANVAS) ;fix
    CloseGadgetList()
    
    Color=RGB(Random(255), Random(255), Random(255))

    Repeat
      Event = WaitWindowEvent()
          
      If Event = #PB_Event_Gadget And EventGadget() = 0 
        If EventType() = #PB_EventType_LeftButtonDown Or (EventType() = #PB_EventType_MouseMove And GetGadgetAttribute(0, #PB_Canvas_Buttons) & #PB_Canvas_LeftButton)
          If StartDrawing(CanvasOutput(0))
            x = GetGadgetAttribute(0, #PB_Canvas_MouseX)
            y = GetGadgetAttribute(0, #PB_Canvas_MouseY)
            
            Circle(x, y, 10, Color)
            StopDrawing()
          EndIf
          
        ElseIf EventType() = #PB_EventType_MouseWheel
          z = GetGadgetAttribute(0, #PB_Canvas_WheelDelta)
          
          If z<>0
            Color=RGB(Random(255), Random(255), Random(255))
          EndIf
          
          Debug "Wheel!"
          Debug z
        EndIf
      EndIf    
      
    Until Event = #PB_Event_CloseWindow
  EndIf


; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP