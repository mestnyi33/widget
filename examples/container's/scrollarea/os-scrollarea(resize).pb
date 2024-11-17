EnableExplicit
Define h = 185, bh = 20+9
Define g1, g2, g3, g4, g5, g6

If OpenWindow(0, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	
	g1 = ScrollAreaGadget(#PB_Any, 30, 30, 200, h, 301,h-bh )
	ButtonGadget(#PB_Any, 0,30,80,30, "button_1")
	CloseGadgetList( )
	
	g2 = ScrollAreaGadget(#PB_Any, 30+210, 30, 200, h, 301,h-bh )
	ButtonGadget(#PB_Any, (301-80)/2,30,80,30, "button_2")
	CloseGadgetList( )
	
	g3 = ScrollAreaGadget(#PB_Any, 30+420, 30, 200, h, 301,h-bh )
	ButtonGadget(#PB_Any, (301-80),30,80,30, "button_3")
	CloseGadgetList( )
	
	g4 = SplitterGadget(#PB_Any, 0,0,0,0, g1,g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
	g5 = SplitterGadget(#PB_Any, 30,30,620,h, g4,g3, #PB_Splitter_Vertical)
	g6 = SplitterGadget(#PB_Any, 30,30,620,h, g5,TextGadget(-1,0,0,0,0,""))
	
	SetGadgetState(g4, 200)
	SetGadgetState(g5, 200*2+8)
	SetGadgetState(g6, h)
	;;SetGadgetState(g4, 200) ; bug splitter
	Debug GetGadgetAttribute(g2, #PB_ScrollArea_InnerWidth)
	SetGadgetAttribute(g2, #PB_ScrollArea_X, 100/2 )
	SetGadgetAttribute(g3, #PB_ScrollArea_X, 100 )
	
	Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow ; WaitCloseRootWidget( )
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 27
; Folding = -
; EnableXP