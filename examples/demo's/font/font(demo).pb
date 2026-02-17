;       CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
;         ;                     Protected TextGadget = TextGadget(#PB_Any, 0,0,0,0,"")
;         ;                     Root()\text\fontID = PB_(GetGadgetFont)(TextGadget) 
;         ;                     FreeGadget(TextGadget)
;         ;Protected FontSize.CGFloat = 12.0 ; boldSystemFontOfSize  fontWithSize
;         ;\text\fontID = CocoaMessage(0, 0, "NSFont systemFontOfSize:@", @FontSize) 
;         ; CocoaMessage(@FontSize,0,"NSFont systemFontSize")
;         
;         ;Root()\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica Neue", 12))
;         ;Root()\text\fontID = FontID(LoadFont(#PB_Any, "Tahoma", 12))
;         ;Root()\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 12))
;         ;
;         ;           Root()\text\fontID = CocoaMessage(0, 0, "NSFont controlContentFontOfSize:@", @FontSize)
;         ;           CocoaMessage(@FontSize, Root()\text\fontID, "pointSize")
;         ;           
;         ;           ;FontManager = CocoaMessage(0, 0, "NSFontManager sharedFontManager")
;         
;         ;  Debug PeekS(CocoaMessage(0,  CocoaMessage(0, Root()\text\fontID, "displayName"), "UTF8String"), -1, #PB_UTF8)
;       CompilerEndIf

XIncludeFile "../../../widgets.pbi" : UseWidgets( )

#WinTemp=0
#Font18R=0

If OpenWindow(#WinTemp, 0, 0, 100, 100, "", #PB_Window_Tool | #PB_Window_Invisible)
	
	If StartVectorDrawing(WindowVectorOutput(#WinTemp, #PB_Unit_Pixel))
		
		Global dgDpiX.d = VectorResolutionX()
		Global dgDpiY.d = VectorResolutionY()
		
		StopVectorDrawing()
	EndIf
	
	CloseWindow(#WinTemp)
EndIf

Global fs = 15
Global igFS18.i = (((fs * 100) / dgDpiY) + Bool(#PB_Compiler_OS=#PB_OS_MacOS)*(fs-5) - Bool(#PB_Compiler_OS=#PB_OS_Linux))

LoadFont(#Font18R, "Arial Unicode MS Regular", igFS18, #PB_Font_HighQuality)

Global *b._s_widget

Procedure events_gadgets()
	Debug ""+EventGadget() + " - gadget  event - " +EventType()+ "  item - " +GetGadgetState(EventGadget())
EndProcedure

Procedure events_widgets()
	Debug ""+Str(Index(EventWidget( )))+ " - widget  event - " +WidgetEvent( )+ "  item - " +WidgetEventItem( ) ; GetState(EventWidget( )) ; 
EndProcedure

Procedure events_gbuttons()
	Select EventType()
		Case #PB_EventType_LeftClick
			Select EventGadget()
				Case 2 
					If CountGadgetItems(1) > 1
						RemoveGadgetItem(1, 1)
						Debug ""+CountGadgetItems(1) +" - count gadget items"
					EndIf
					
				Case 5 : ClearGadgetItems(1)
					Debug ""+CountGadgetItems(1) +" - count gadget items"
					
				Case 3, 4
					OpenGadgetList(1)
					AddGadgetItem(1, 1, "Sub 2 (add)")
					Protected sub = Bool(CountGadgetItems(1) > 1)
					
					SetGadgetItemText(1, sub, "Sub "+Str(sub+1)+" (add&set)")
					Debug GetGadgetItemText(1, sub) + " - get item text"
					CloseGadgetList()
					
					; SetGadgetItemFont(1, sub, 5 + Bool(Index(EventWidget( )) = 4))
					SetGadgetItemState(1, sub, 1)
					; SetState(1, 1)
					
			EndSelect
	EndSelect
EndProcedure

Procedure events_wbuttons()
	Select WidgetEvent( )
		Case #PB_EventType_LeftClick
			Select Index(EventWidget( ))
				Case 2 
					If CountItems(ID(1)) > 1
						RemoveItem(ID(1), 1)
						Debug ""+CountItems(ID(1)) +" - count widget items"
					EndIf
					
				Case 5 : ClearItems(ID(1))
					Debug ""+CountItems(ID(1)) +" - count widget items"
					
				Case 3, 4
					;OpenList(ID(1))
					AddItem(ID(1), 1, "Sub 2 (add)")
					Protected sub = Bool(CountItems(ID(1)) > 1)
					
					SetItemText(ID(1), sub, "Sub "+Str(sub+1)+" (add&set)")
					Debug GetItemText(ID(1), sub) + " - get item text"
					;CloseList()
					
					SetItemFont(ID(1), sub, 5 + Bool(Index(EventWidget( )) = 4))
					SetItemState(ID(1), sub, 1)
					; SetState(ID(1), 1)
			EndSelect
	EndSelect
	
	Debug ""+*b\text\width +" "+ *b\text\height +" "+ *b\Width[#__c_required] +" "+ *b\Height[#__c_required] ; mac = 121 29 ; win 70 16
	
EndProcedure

; Shows using of several panels...
OpenWindow(0, 0, 0, 322 + 322 + 100, 220, "PanelGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
If Open(0, 322+50, 0, 322+50, 220)
	Define Text.s, *g
	CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
		LoadFont(5, "Arial", 18)
		LoadFont(6, "Arial", 25)
		
	CompilerElse
		LoadFont(5, "Arial", 14)
		LoadFont(6, "Arial", 21)
		
	CompilerEndIf
	
	PanelGadget     (0, 8, 8, 356, 203)
	AddGadgetItem (0, -1, "Panel 1")
	
	;PanelGadget (1, 10, 10, 334, 130)
	TreeGadget (1, 10, 10, 334, 130)
	
	If GadgetType(1) = #PB_GadgetType_Panel
		Text = "Sub"
	ElseIf GadgetType(1) = #PB_GadgetType_Tree
		Text = "Tree"
	EndIf
	
	AddGadgetItem (1, 0, Text+"_0", 0)                                    
	For i=1 To 12
		If i=5 
			AddGadgetItem(1, -1, Text+"_"+Str(i), 0, 0) 
		Else
			AddGadgetItem(1, -1, Text+"_"+Str(i), 0, 0) 
		EndIf
	Next 
	
	SetGadgetState(1, 2)
	If GadgetType(1) = #PB_GadgetType_Panel
		CloseGadgetList()
	EndIf
	
	;SetGadgetItemFont(1, 2, 5)
	SetGadgetItemText(1, 2, Text+"_2 (18)")
	
	;SetGadgetItemFont(1, 4, 6)
	SetGadgetItemText(1, 4, Text+"_4 (25)")
	
	
	ButtonGadget(2, 10, 145, 60, 24,"remove")
	ButtonGadget(3, 75, 145, 100, 24,"add (18)")
	ButtonGadget(4, 180, 145, 100, 24,"add (25)")
	ButtonGadget(5, 285, 145, 60, 24,"clear")
	
	AddGadgetItem (0, -1,"Panel 2")
	ButtonGadget(6, 10, 15, 80, 24,"Button 6")
	ButtonGadget(7, 95, 15, 80, 24,"Button 7")
	CloseGadgetList()
	
	For i = 0 To 1
		BindGadgetEvent(i, @events_gadgets())
	Next
	For i = 2 To 5
		BindGadgetEvent(i, @events_gbuttons())
	Next
	
	Debug ""+CountGadgetItems(1) +" - count gadget items"
	
	Define *p = Panel(8, 8, 356, 203)
	AddItem (*p, -1, "Panel 1")
	
	;*g = Panel(10, 10, 334, 130)
	*g = Tree(10, 10, 334, 130, #__flag_CheckBoxes|#__flag_NoLines|#__flag_NoButtons|#__flag_GridLines | #__flag_ThreeState | #__flag_OptionBoxes)                            
	
	If Type(*g) = #PB_GadgetType_Panel
		Text = "Sub"
	ElseIf Type(*g) = #PB_GadgetType_Tree
		Text = "Tree"
	EndIf
	
	AddItem (*g, 0, Text+"_0", 0)                                    
	For i=1 To 12
		If i=5 
			AddItem(*g, -1, Text+"_"+Str(i), -1, 0) 
		Else
			AddItem(*g, -1, Text+"_"+Str(i), 0, -1) 
		EndIf
	Next 
	
	SetState(*g, 2)
	If Type(*g) = #PB_GadgetType_Panel
		CloseList()
	EndIf
	
	SetItemFont(*g, 2, 5)
	SetItemText(*g, 2, Text+"_2 (18)")
	
	SetItemFont(*g, 4, 6)
	SetItemText(*g, 4, Text+"_4 (25)")
	
	Button(10, 145, 60, 24,"remove")
	SetFont(Button(75, 145, 100, 24,"add (18)"), 5)
	SetFont(Button(180, 145, 100, 24,"add (25)"), 6)
	SetFont(Button(285, 145, 60, 24,"clear"), #Font18R)
	
	AddItem (*p, -1,"Panel 2")
	SetFont(Button(10, 15, 100, 24,"Button 2_1"), 5)
	Button(115, 15, 100, 24,"Button 2_2")
	
	AddItem (*p, -1,"Panel 3")
	Button(10, 15, 100, 24,"Button 3_1")
	*b = Button(10, 15+24+10, 100, 24,"auto resize button when changing font");, #PB_Button_MultiLine)
	If SetFont(*b, 5)
	  ; Repaint( *b )
	EndIf
	;SetState(ID(0), 2)
	
	;   ; bug set font - FIXED SetFont() ; *this\root\text\fontID[1] =- 1 
	; set auto font size
	Define iw = 2 + (*b\bs+*b\text\x)*4 
	
; 	Macro Repaint( )
; 		Drawing( Root( ) )
; 	EndMacro
	
	
	;Debug Width(*b, #__c_required)
	
	Debug ""+*b\text\width +" "+ *b\text\height +" "+ *b\Width[#__c_required] +" "+ *b\Height[#__c_required] ; mac = 121 29 ; win 70 16
	Resize(*b, #PB_Ignore, #PB_Ignore, Width(*b, #__c_required), Height(*b, #__c_required))

	CloseList()
	
	SetItemFont(*p, 1, 6)
	SetItemFont(*p, 2, #Font18R)
	
	For i = 0 To 1
		Bind(ID(i), @events_widgets())
	Next
	For i = 2 To 5
		Bind(ID(i), @events_wbuttons())
	Next
	
	Debug ""+CountItems(ID(1)) +" - count widget items"
	
	;   ; bug set font - FIXED Repaint() ; Root(()\text\fontID[1] =- 1 >> *this\root\text\fontID[1] =- 1 
	;   Open(OpenWindow(-1, 0, 0, 300, 346, "demo set  new parent", #PB_Window_SystemMenu))
	;   Global *panel._S_widget = Panel(10,150,200,160) 
	;   AddItem(*panel,-1,"Panel") 
	;   AddItem(*panel,-1,"Second") 
	;   AddItem(*panel,-1,"Third") 
	;   CloseList()
	;   Open(OpenWindow(#PB_Any, 0, 0, 100, 100, "", 0, UseGadgetList(0)))
	
	Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 203
; FirstLine = 159
; Folding = v---
; EnableXP
; DPIAware