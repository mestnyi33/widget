IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
	EnableExplicit
	UseLib(Widget)
	
	Global.i gEvent, gQuit, *but, *win
	
	Procedure events_widgets( )
		If WidgetEventType() <> #__event_MouseMove And 
		   WidgetEventType() <> #__event_Draw And 
		   WidgetEventType() <> #__event_StatusChange
			
			If WidgetType( EventWidget( ) ) = #PB_GadgetType_Button
				; ClearDebugOutput()
				Debug ""+IDWidget(EventWidget())+ " - widget  event - " +WidgetEventType() +" ("+ ClassFromEvent( WidgetEventType())+ ")  item - " +WidgetEventItem() +" (gadget)"
			EndIf
			
			If IDWidget(EventWidget()) = 1
				If WidgetEventType() = #__event_MouseEnter
					Resize( EventWidget(), #PB_Ignore, #PB_Ignore, 280, #PB_Ignore)
				EndIf
				If WidgetEventType() = #__event_MouseLeave
					Resize( EventWidget(), #PB_Ignore, #PB_Ignore, 240, #PB_Ignore)
				EndIf
				ProcedureReturn #PB_Ignore ; no send to (window & root) - event
			EndIf
		EndIf
	EndProcedure
	
	Procedure events_windows( )
		If WidgetEventType() <> #__event_MouseMove And 
		   WidgetEventType() <> #__event_Draw And
		   WidgetEventType() <> #__event_StatusChange
			
			If WidgetType( EventWidget( ) ) = #PB_GadgetType_Button
				Debug "  "+IDWidget(EventWidget())+ " - widget  event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (window)"
			EndIf
			
			If IDWidget(EventWidget()) = 2
				ProcedureReturn #PB_Ignore ; no send to (root) - event
			EndIf
		EndIf
	EndProcedure
	
	Procedure events_roots( )
		If WidgetEventType() <> #__event_MouseMove And 
		   WidgetEventType() <> #__event_Draw And
		   WidgetEventType() <> #__event_StatusChange
			
			If WidgetType( EventWidget( ) ) = #PB_GadgetType_Button
				Debug "    "+IDWidget(EventWidget())+ " - widget  event - " +WidgetEventType()+ "  item - " +WidgetEventItem() +" (root)"
			EndIf
		EndIf
	EndProcedure
	
	
	Procedure Window_0()
		If OpenWindow(0, 0, 0, 500, 500, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
			Define Editable ; = #__flag_AnchorsGadget
			
			If Open(0, 10,10, 480, 480)
				Bind(#PB_All, @events_roots())
				Bind(Window(80, 100, 300, 280, "Window_2", Editable|#__Window_SystemMenu), @events_windows())
				;SetColor(widget(), #PB_Gadget_BackColor, $ff00ff)
				
				Bind(Button(10,  10, 240, 80, "post event for one procedure", Editable), @events_widgets())
				Bind(Button(10, 100, 260, 80, "post event for to two procedure", Editable), @events_widgets())
				Bind(Button(10, 190, 280, 80, "post event for all procedures", Editable), @events_widgets())
				
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
;   Uselib(widget)
;   
;   Procedure active()
;     Protected *ew._s_widget = EventWidget( )
;     Debug ""+#PB_Compiler_Procedure+" "+WidgetEventType()+" "+*ew\index
;   EndProcedure
;   
;   Procedure deactive()
;     Protected *ew._s_widget = EventWidget( )
;     Debug ""+#PB_Compiler_Procedure+" "+WidgetEventType()+" "+*ew\index
;   EndProcedure
;   
;   Procedure click()
;     Protected *ew._s_widget = EventWidget( )
;     Debug ""+#PB_Compiler_Procedure+" "+WidgetEventType()+" "+*ew\index
;   EndProcedure
;   
;   Procedure events()
;     Protected *ew._s_widget = EventWidget( )
;     Debug ""+#PB_Compiler_Procedure+" "+WidgetEventType()+" "+*ew\index
;   EndProcedure
;   
;   If Open(OpenWindow(#PB_Any, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
;     ; If Open(Window(100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget))
;     ; If Window(100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
;     
;     ;a_add(root())
;     
;     String(10,10,180,30,"string_0")
;     SetActive(widget())
;     
;     String(10,50,180,30,"string_1")
;     SetActive(widget())
;     
;     Debug ""
;     Bind( #PB_All, @click(), #__event_LeftClick)
;     Bind( #PB_All, @deactive(), #__event_LostFocus)
;     Bind( #PB_All, @active(), #__event_Focus)
;     
;     Debug ""
; ;     Bind( #PB_All, @events(), #__event_LeftClick)
; ;     Bind( #PB_All, @events(), #__event_LostFocus)
; ;     Bind( #PB_All, @events(), #__event_Focus)
;     Bind( #PB_All, @events())
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
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 52
; FirstLine = 22
; Folding = ----
; EnableXP
; DPIAware