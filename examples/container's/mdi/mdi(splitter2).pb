XIncludeFile "../../../widgets3.pbi"

;
; Module name   : elements
; Author        : mestnyi
; Last updated  : mar 12, 2020
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70662
;

CompilerIf #PB_Compiler_IsMainFile
	Uselib(widget)
	
	Global MDI, MDI_splitter, Splitter
	
	Procedure MDI_ChildrensResizeEvents( )
	   Debug "    ---  resize "+GetClass(EventWidget( )) +" "+x(EventWidget( )) +" "+y(EventWidget( )) +" "+width(EventWidget( )) +" "+height(EventWidget( ))
	EndProcedure
	
	If Open(0, 0, 0, 700, 280, "MDI", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
	   ;a_init( Root( ))
	   Bind( Root( ), @MDI_ChildrensResizeEvents( ), #__event_resize)
		
		MDI = MDI(0, 0, 680, 260);, #PB_MDI_AutoSize) ; as they will be sized automatically
		Define *g0 = AddItem(MDI, -1, "form_0")
; 		Button(10,10,80,80,"button_0")
; 		
 		Define *g1 = AddItem(MDI, -1, "form_1")
; 		Button(10,10,80,80,"button_1")
; 		
 		Define *g2 = AddItem(MDI, -1, "form_2")
; 		Button(10,10,80,80,"button_2")
 		
 		Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
	EndIf
	
CompilerEndIf

; CompilerIf #PB_Compiler_IsMainFile
;   Uselib(widget)
;   
;   EnableExplicit
;   Global Event.i, MyCanvas
;   Global x=100,y=100, width=420, height=420 , focus
;   
;   If Not OpenWindow(0, 0, 0, width+x*2+20, height+y*2+20, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
;     MessageRequester("Fatal error", "Program terminated.")
;     End
;   EndIf
;   
;   MyCanvas = GetGadget(Open(0, 10, 10));, #PB_Ignore, #PB_Ignore, #PB_Canvas_Keyboard, @Canvas_CallBack()))
;   
;   Define *mdi = MDI(x,y,width, height);, #__flag_autosize)
;   a_init( *mdi )
;   
;   Define *g0 = AddItem(*mdi, -1, "form_0")
;   Button(10,10,80,80,"button_0")
;   
;   Define *g1 = AddItem(*mdi, -1, "form_1")
;   Button(10,10,80,80,"button_1")
;   
;   Define *g2 = AddItem(*mdi, -1, "form_2")
;   Button(10,10,80,80,"button_2")
;   
;   ; use root list
;   OpenList(Root())
;   ;;CloseList()
;   
;   Define *spl1 = Splitter(x,y,width,height, #Null, *mdi, #PB_Splitter_Vertical)
;   Define *spl2 = Splitter(x,y,width,height, #Null, *spl1);, #__flag_autosize)
;   
;   SetState(*spl1, 150)
;   SetState(*spl2, 150)
;   
;   Repeat
;     Event = WaitWindowEvent()
;   Until Event = #PB_Event_CloseWindow
; CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 15
; Folding = -
; EnableXP