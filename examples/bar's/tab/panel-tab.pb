
IncludePath "../../../"
XIncludeFile "widgets.pbi"


CompilerIf #PB_Compiler_IsMainFile
	EnableExplicit
	Uselib(widget)
	
	Global i, *w0, *w1, *w2, *w3, *w4, *w5, *w6, *w7
	Global *tab, *panel
	
	CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
		LoadFont(5, "Arial", 18)
		LoadFont(6, "Arial", 25)
		
	CompilerElse
		LoadFont(5, "Arial", 14)
		LoadFont(6, "Arial", 21)
		
	CompilerEndIf
	
	
	widget::Open(0, 10, 10, 850, 370, "SPLITTER", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_SystemMenu)
	
	;
	Procedure events_tab( )
		Debug "events_tab"
		SetState(*panel, GetState(*tab))
	EndProcedure
	*tab = widget::Tab(10, 30, 830, 30)
	For i=0 To 10
		widget::AddItem(*tab, -1, "Tab "+Str(i))
	Next
	widget::SetState(*tab, 6)
	widget::Bind(*tab, @events_tab( ), #PB_EventType_Change)
	
	;
	Procedure events_panel( )
		Debug "events_panel"
		SetState(*tab, GetState(*panel))
	EndProcedure
	*panel = widget::Panel(300, 70, 250, 110)
	For i=0 To 10
		If i = 6
	    	Continue
		EndIf
		
		widget::AddItem(*panel, -1, "Sub "+Str(i))
		If (i > 4 And i < 9) 
			Button((i-4)*30,(i-4)*10,50,30,Str(i))
		EndIf
		If i=0
			Button(30,10,50,30,Str(i))
		EndIf
	Next
	i = 6
	widget::AddItem(*panel, i, "+Sub "+Str(i))
	Button((i-4)*30+10,(i-4)*10+10,50,30,"+"+Str(i))
	
	widget::CloseList()
	widget::SetState(*panel, 6)
	widget::Bind(*panel, @events_panel( ), #PB_EventType_Change)
	
	
	; first splitter
	*w0 = widget::Tab(0, 0, 0, 0)
	For i=0 To 3
		widget::AddItem(*w0, -1, "tab_"+Str(i))
	Next
	
	*w1 = widget::Tab(0, 0, 0, 0)
	For i=0 To 10
		widget::AddItem(*w1, -1, "tab_"+Str(i))
	Next
	
	*w2 = widget::Splitter(30, 30, 250, 70, *w0, *w1, #PB_Splitter_Separator)
	
	; second splitter
	*w3 = widget::Tab(0, 0, 0, 0)
	For i=0 To 10
		widget::AddItem(*w3, -1, "tab_rrrrrrrr"+Str(i))
	Next
	
	*w4 = widget::Tab(0, 0, 0, 0)
	For i=0 To 10
		widget::AddItem(*w4, -1, "tab_"+Str(i))
	Next
	
	*w5 = widget::Splitter(30, 110, 250, 70, *w3, *w4, #PB_Splitter_Separator)
	
	
	*w6 = widget::Splitter(300, 180+30, 250, 70, *w2, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
	*w7 = widget::Splitter(300, 180+110, 250, 70, *w5, 0, #PB_Splitter_Separator|#PB_Splitter_Vertical)
	widget::SetState(*w6, 250)
	widget::SetState(*w7, 250)
	
	
	
	;
	;   widget::SetState(*w0, -10)
	;   widget::SetState(*w1, 250-10)
	;   widget::SetState(*w3, 250/2)
	;   widget::SetState(*w4, 10)
	
	;widget::SetState(*w0, -1)
	widget::SetState(*w1, 9)
	widget::SetState(*w3, 6)
	widget::SetState(*w4, 1)
	;   
	;   widget::SetItemFont(*w0, 1, 6)
	;   widget::SetItemFont(*w1, 7, 5)
	
	
	widget::WaitClose( )
	End
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 30
; FirstLine = 14
; Folding = --
; EnableXP