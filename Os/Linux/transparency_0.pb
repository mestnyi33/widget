; Module/File:     Window_SetTransparency2.pb
; Function:        Set widget transparency - Linux >=gtk3.8
; Author:          Omi/shardik
; Date:            Sep. 05, 2015
; Version:         0.1
; Target Compiler: PureBasic 5.22/5.31/5.40/5.5/5.6
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
; Link to topic:   http://www.purebasic.fr/english/viewtopic.php?f=15&t=63137
;--------------------------------------------------------------
;depends on distribution (Lubuntu without function)
;works from gtk3.8 and higher

EnableExplicit

ImportC ""
	gtk_widget_is_composited(*widget.GtkWidget)
	gtk_widget_set_opacity(*window.GtkWindow, opacity.d)
	gtk_scale_clear_marks(*scale.GtkScale)
	gtk_scale_add_mark(*scale.GtkScale, value.d, position.i, *markup)
	gtk_range_get_value.d(*range.GtkRange)
	gtk_adjustment_set_lower(*adjustment.GtkAdjustment, lower.d)
	gtk_adjustment_set_value(*adjustment.GtkAdjustment, value.d)
	g_signal_connect(*instance, detailed_signal.p-utf8, *c_handler, *data, destroy= 0, flags= 0) As "g_signal_connect_data"
EndImport

; Object constants
#MainWin= 0

#TBar1  = 0
#But1   = 1

Global.i I, gEvent, gQuit
Global *gWidget.GtkWidget, *gAdjustment.GtkAdjustment

ProcedureC Trackbar_changed(*trackbar, user_data)
	; ----- set opacity with trackbar-position ...
	gtk_widget_set_opacity(GadgetID(#But1), gtk_range_get_value(*trackbar)/10); widget transparency set here
EndProcedure

If OpenWindow(#MainWin, 300, 200, 250, 200, "widget-transparency", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	TextGadget(#PB_Any,     5, 20,  90, 20, "transparency")
	TrackBarGadget(#TBar1, 90,  5, 150, 40, 0, 10);                    no lower-limit 0.5 possible (= 0) => need double instead PB-integer)
	CanvasGadget(#But1,     5, 50, 240, 32)
	
	If StartDrawing(CanvasOutput(#But1))
              Box(0, 0, 20, 20, 0)
              StopDrawing()
            EndIf
	
	; ----- set trackbar to adjust transparency ...
	*gWidget= GadgetID(#TBar1)
	gtk_scale_set_value_pos_(*gWidget, #GTK_POS_RIGHT);                additional display value at right side
	gtk_scale_set_draw_value_(*gWidget, #True);                        display ON
	gtk_scale_clear_marks(*gWidget);                                   no marks => wrong cause pb-int-parameter
	*gAdjustment= gtk_range_get_adjustment_(*gWidget);                 get adjustment
	gtk_adjustment_set_lower(*gAdjustment, 0.1);                       set real lower-limit to 0.5
	gtk_adjustment_set_value(*gAdjustment, 1.0);                       preset value
	For I= 1 To 10
		gtk_scale_add_mark(*gWidget, I/10, #GTK_POS_TOP, #Null);         set marks to trackbar
	Next I
	If Not gtk_widget_is_composited(GadgetID(#But1))
		Debug "Widget transparency is not supported on this system!"
	EndIf
	
	; ----- set event for trackbar-change
 	g_signal_connect(*gWidget, "value-changed", @Trackbar_changed(), *gWidget)
 	
 	; ----- preset transparency ...
	gtk_widget_set_opacity(GadgetID(#But1), 1.0)
	
	Repeat
		gEvent= WaitWindowEvent()
		
		Select gEvent
			Case #PB_Event_CloseWindow
				gQuit= #True
			Case #PB_Event_Gadget
				;  see Trackbar_changed(*trackbar, user_data) for event
		EndSelect
		
	Until gQuit
EndIf
; IDE Options = PureBasic 5.45 LTS (Linux - x86)
; CursorPosition = 38
; Folding = -
; EnableUnicode
; EnableXP
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 44
; FirstLine = 26
; Folding = -
; EnableXP