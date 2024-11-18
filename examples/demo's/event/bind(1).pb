IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
	EnableExplicit
	UseWidgets( )
	
	Global.i gEvent, gQuit
	Global *but, *win
	
	Procedure events_widgets( )
		If WidgetEvent() <> #__event_MouseMove And 
		   WidgetEvent() <> #__event_Draw And 
		   WidgetEvent() <> #__event_StatusChange
			
			If Type( EventWidget( ) ) = #PB_GadgetType_Button
				; ClearDebugOutput()
				Debug ""+GetIndex(EventWidget())+ " - widget  event - " +WidgetEvent() +" ("+ ClassFromEvent( WidgetEvent())+ ")  item - " +WidgetEventItem() +" (gadget)"
			EndIf
			
			If GetIndex(EventWidget()) = 1
				If WidgetEvent() = #__event_MouseEnter
					ResizeWidget( EventWidget(), #PB_Ignore, #PB_Ignore, 280, #PB_Ignore)
				EndIf
				If WidgetEvent() = #__event_MouseLeave
					ResizeWidget( EventWidget(), #PB_Ignore, #PB_Ignore, 240, #PB_Ignore)
				EndIf
				ProcedureReturn #PB_Ignore ; no send to (window & root) - event
			EndIf
		EndIf
	EndProcedure
	
	Procedure events_windows( )
		If WidgetEvent() <> #__event_MouseMove And 
		   WidgetEvent() <> #__event_Draw And
		   WidgetEvent() <> #__event_StatusChange
			
			If Type( EventWidget( ) ) = #PB_GadgetType_Button
				Debug "  "+GetIndex(EventWidget())+ " - widget  event - " +WidgetEvent()+ "  item - " +WidgetEventItem() +" (window)"
			EndIf
			
			If GetIndex(EventWidget()) = 2
				ProcedureReturn #PB_Ignore ; no send to (root) - event
			EndIf
		EndIf
	EndProcedure
	
	Procedure events_roots( )
		If WidgetEvent() <> #__event_MouseMove And 
		   WidgetEvent() <> #__event_Draw And
		   WidgetEvent() <> #__event_StatusChange
			
			If Type( EventWidget( ) ) = #PB_GadgetType_Button
				Debug "    "+GetIndex(EventWidget())+ " - widget  event - " +WidgetEvent()+ "  item - " +WidgetEventItem() +" (root)"
			EndIf
		EndIf
	EndProcedure
	
	
	Procedure Window_0()
		If OpenWindow(0, 0, 0, 500, 500, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
			Define Editable ; = 
			
			If OpenRoot(0, 10,10, 480, 480)
				BindWidgetEvent(#PB_All, @events_roots())
				BindWidgetEvent(Window(80, 100, 300, 280, "Window_2", Editable|#__Window_SystemMenu), @events_windows())
				;SetWidgetColor(widget(), #PB_Gadget_BackColor, $ff00ff)
				
				BindWidgetEvent(ButtonWidget(10,  10, 240, 80, "post event for one procedure", Editable), @events_widgets())
				BindWidgetEvent(ButtonWidget(10, 100, 260, 80, "post event for to two procedure", Editable), @events_widgets())
				BindWidgetEvent(ButtonWidget(10, 190, 280, 80, "post event for all procedures", Editable), @events_widgets())
				
			EndIf
		EndIf
	EndProcedure
	
	Window_0()
	
	Repeat
		gEvent= WaitWindowEvent()
		
		Select gEvent
			Case #PB_Event_CloseWindow
				gQuit= #True
		EndSelect
		
	Until gQuit
CompilerEndIf



; IncludePath "../../../"
; XIncludeFile "widgets.pbi"
; 
; ;- EXAMPLE
; CompilerIf #PB_Compiler_IsMainFile
;   ;EnableExplicit
;   UseWidgets( )
;   
;   Procedure active()
;     Protected *ew._s_widget = EventWidget( )
;     Debug ""+#PB_Compiler_Procedure+" "+WidgetEvent()+" "+*ew\index
;   EndProcedure
;   
;   Procedure deactive()
;     Protected *ew._s_widget = EventWidget( )
;     Debug ""+#PB_Compiler_Procedure+" "+WidgetEvent()+" "+*ew\index
;   EndProcedure
;   
;   Procedure click()
;     Protected *ew._s_widget = EventWidget( )
;     Debug ""+#PB_Compiler_Procedure+" "+WidgetEvent()+" "+*ew\index
;   EndProcedure
;   
;   Procedure events()
;     Protected *ew._s_widget = EventWidget( )
;     Debug ""+#PB_Compiler_Procedure+" "+WidgetEvent()+" "+*ew\index
;   EndProcedure
;   
;   If OpenRoot(OpenWindow(#PB_Any, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
;     ; If OpenRoot(Window(100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
;     ; If WindowWidget(100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
;     
;     ;a_add(root())
;     
;     StringWidget(10,10,180,30,"string_0")
;     SetActiveWidget(widget())
;     
;     StringWidget(10,50,180,30,"string_1")
;     SetActiveWidget(widget())
;     
;     Debug ""
;     BindWidgetEvent( #PB_All, @click(), #__event_LeftClick)
;     BindWidgetEvent( #PB_All, @deactive(), #__event_LostFocus)
;     BindWidgetEvent( #PB_All, @active(), #__event_Focus)
;     
;     Debug ""
; ;     BindWidgetEvent( #PB_All, @events(), #__event_LeftClick)
; ;     BindWidgetEvent( #PB_All, @events(), #__event_LostFocus)
; ;     BindWidgetEvent( #PB_All, @events(), #__event_Focus)
;     BindWidgetEvent( #PB_All, @events())
;     
;     Repeat
;       Event = WaitWindowEvent()
;       
;       If Event = #PB_Event_CloseWindow 
;         Quit = 1
;       EndIf
;       
;     Until Quit = 1
;     
;   EndIf
; CompilerEndIf
; End  
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 53
; FirstLine = 32
; Folding = ----
; EnableXP
; DPIAware