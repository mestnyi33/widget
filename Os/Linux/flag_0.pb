; Module/File:     Window_GetDecoration.pb
; Function:        Get the window elements - Linux gtk2/gtk3
; Author:          Omi
; Date:            Nov. 03, 2014
; Version:         0.2 updt. gtk3
; Target Compiler: PureBasic 5.22/5.31/5.40
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
;--------------------------------------------------------------
;http://www.crategus.com/books/cl-cffi-gtk/pages/gdk_sym_gdk-wm-decoration.html
EnableExplicit

ImportC ""
	gtk_widget_get_window(*widget.GtkWidget)
EndImport

; #GDK_DECOR_ALL      =  1
; #GDK_DECOR_BORDER   =  2
; #GDK_DECOR_RESIZER  =  4
; #GDK_DECOR_TITLE    =  8
; #GDK_DECOR_MENU     = 16
; #GDK_DECOR_MINIMIZE = 32
; #GDK_DECOR_MAXIMIZE = 64

; Object constants
#MainWin  = 0
#But1 = 0

#WinX=300
#WinY=200
#WinW=250
#WinH=200

Global.i gEvent, gQuit
Global.i WElements


Procedure GetWindowDecoration(Window)
	Protected decorations
	gdk_window_get_decorations_(gtk_widget_get_window(WindowID(Window)), @decorations)
	ProcedureReturn decorations
EndProcedure

If OpenWindow(#MainWin, #WinX, #WinY, #WinW, #WinH, "Window decoration", #PB_Window_SystemMenu); | #PB_Window_ScreenCentered | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget)
	ButtonGadget(#But1, 5, 5, 240, 26, "Get decoration")
	
	gdk_window_set_decorations_(gtk_widget_get_window(WindowID(#MainWin)),  #GDK_DECOR_MAXIMIZE)
      Debug  gdk_wm_decoration_get_type_()
	Repeat
		gEvent= WaitWindowEvent()
		
		Select gEvent
			Case #PB_Event_CloseWindow
				gQuit= #True
			Case #PB_Event_Gadget
				If EventGadget()= #But1
					WElements= GetWindowDecoration(#MainWin)
					Debug "All     : " + Str(Bool(WElements & #GDK_DECOR_ALL))
					Debug "BORDER  : " + Str(Bool(WElements & #GDK_DECOR_BORDER))
					Debug "RESIZER : " + Str(Bool(WElements & #GDK_DECOR_RESIZEH))
					Debug "TITLE   : " + Str(Bool(WElements & #GDK_DECOR_TITLE))
					Debug "MENU    : " + Str(Bool(WElements & #GDK_DECOR_MENU))
					Debug "MINIMIZE: " + Str(Bool(WElements & #GDK_DECOR_MINIMIZE))
					Debug "MAXIMIZE: " + Str(Bool(WElements & #GDK_DECOR_MAXIMIZE))
				EndIf
		EndSelect
		
	Until gQuit
EndIf
; IDE Options = PureBasic 5.46 LTS Beta 1 (Linux - x86)
; CursorPosition = 26
; Folding = -
; EnableUnicode
; EnableXP
; IDE Options = PureBasic 5.62 (Linux - x64)
; CursorPosition = 45
; FirstLine = 40
; Folding = -
; EnableXP