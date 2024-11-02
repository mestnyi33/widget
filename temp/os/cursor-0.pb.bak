;--- WINDOWS
; #IDC_ARROW=32512
; #IDC_APPSTARTING=32650
; #IDC_HAND=32649
; #IDC_HELP=32651
; #IDC_IBEAM=32513
; #IDC_CROSS=32515
; #IDC_NO=32648
; #IDC_SIZE=32640
; #IDC_SIZEALL=32646
; #IDC_SIZENESW=32643
; #IDC_SIZENS=32645
; #IDC_SIZENWSE=32642
; #IDC_SIZEWE=32644
; #IDC_UPARROW=32516
; #IDC_WAIT=32514


;--- OSX
#kThemeArrowCursor = 0
#kThemeCopyArrowCursor = 1
#kThemeAliasArrowCursor = 2
#kThemeContextualMenuArrowCursor = 3
#kThemeIBeamCursor = 4
#kThemeCrossCursor = 5
#kThemePlusCursor = 6
#kThemeWatchCursor = 7
#kThemeClosedHandCursor = 8
#kThemeOpenHandCursor = 9
#kThemePointingHandCursor = 10
#kThemeCountingUpHandCursor = 11
#kThemeCountingDownHandCursor = 12
#kThemeCountingUpAndDownHandCursor = 13
#kThemeSpinningCursor = 14
#kThemeResizeLeftCursor = 15
#kThemeResizeRightCursor = 16
#kThemeResizeLeftRightCursor = 17
#kThemeNotAllowedCursor = 18


;--- LINUX:
;   GDK_X_CURSOR 		  = 0,
;   GDK_ARROW 		  = 2,
;   GDK_BASED_ARROW_DOWN    = 4,
;   GDK_BASED_ARROW_UP 	  = 6,
;   GDK_BOAT 		  = 8,
;   GDK_BOGOSITY 		  = 10,
;   GDK_BOTTOM_LEFT_CORNER  = 12,
;   GDK_BOTTOM_RIGHT_CORNER = 14,
;   GDK_BOTTOM_SIDE 	  = 16,
;   GDK_BOTTOM_TEE 	  = 18,
;   GDK_BOX_SPIRAL 	  = 20,
;   GDK_CENTER_PTR 	  = 22,
;   GDK_CIRCLE 		  = 24,
;   GDK_CLOCK	 	  = 26,
;   GDK_COFFEE_MUG 	  = 28,
;   GDK_CROSS 		  = 30,
;   GDK_CROSS_REVERSE 	  = 32,
;   GDK_CROSSHAIR 	  = 34,
;   GDK_DIAMOND_CROSS 	  = 36,
;   GDK_DOT 		  = 38,
;   GDK_DOTBOX 		  = 40,
;   GDK_DOUBLE_ARROW 	  = 42,
;   GDK_DRAFT_LARGE 	  = 44,
;   GDK_DRAFT_SMALL 	  = 46,
;   GDK_DRAPED_BOX 	  = 48,
;   GDK_EXCHANGE 		  = 50,
;   GDK_FLEUR 		  = 52,
;   GDK_GOBBLER 		  = 54,
;   GDK_GUMBY 		  = 56,
;   GDK_HAND1 		  = 58,
;   GDK_HAND2 		  = 60,
;   GDK_HEART 		  = 62,
;   GDK_ICON 		  = 64,
;   GDK_IRON_CROSS 	  = 66,
;   GDK_LEFT_PTR 		  = 68,
;   GDK_LEFT_SIDE 	  = 70,
;   GDK_LEFT_TEE 		  = 72,
;   GDK_LEFTBUTTON 	  = 74,
;   GDK_LL_ANGLE 		  = 76,
;   GDK_LR_ANGLE 	 	  = 78,
;   GDK_MAN 		  = 80,
;   GDK_MIDDLEBUTTON 	  = 82,
;   GDK_MOUSE 		  = 84,
;   GDK_PENCIL 		  = 86,
;   GDK_PIRATE 		  = 88,
;   GDK_PLUS 		  = 90,
;   GDK_QUESTION_ARROW 	  = 92,
;   GDK_RIGHT_PTR 	  = 94,
;   GDK_RIGHT_SIDE 	  = 96,
;   GDK_RIGHT_TEE 	  = 98,
;   GDK_RIGHTBUTTON 	  = 100,
;   GDK_RTL_LOGO 		  = 102,
;   GDK_SAILBOAT 		  = 104,
;   GDK_SB_DOWN_ARROW 	  = 106,
;   GDK_SB_H_DOUBLE_ARROW   = 108,
;   GDK_SB_LEFT_ARROW 	  = 110,
;   GDK_SB_RIGHT_ARROW 	  = 112,
;   GDK_SB_UP_ARROW 	  = 114,
;   GDK_SB_V_DOUBLE_ARROW   = 116,
;   GDK_SHUTTLE 		  = 118,
;   GDK_SIZING 		  = 120,
;   GDK_SPIDER		  = 122,
;   GDK_SPRAYCAN 		  = 124,
;   GDK_STAR 		  = 126,
;   GDK_TARGET 		  = 128,
;   GDK_TCROSS 		  = 130,
;   GDK_TOP_LEFT_ARROW 	  = 132,
;   GDK_TOP_LEFT_CORNER 	  = 134,
;   GDK_TOP_RIGHT_CORNER 	  = 136,
;   GDK_TOP_SIDE 		  = 138,
;   GDK_TOP_TEE 		  = 140,
;   GDK_TREK 		  = 142,
;   GDK_UL_ANGLE 		  = 144,
;   GDK_UMBRELLA 		  = 146,
;   GDK_UR_ANGLE 		  = 148,
;   GDK_WATCH 		  = 150,
;   GDK_XTERM 		  = 152
;   GDK_BLANK_CURSOR = -2
;   GDK_CURSOR_IS_PIXMAP = -1

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Macro CURSOR_ARROW : #IDC_ARROW : EndMacro
  Macro CURSOR_BUSY : #IDC_WAIT : EndMacro
  
CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
  Macro CURSOR_ARROW : #kThemeClosedHandCursor : EndMacro
  Macro CURSOR_BUSY : #kThemeWatchCursor : EndMacro
  ImportC ""
    SetThemeCursor(CursorType.L)
  EndImport
  
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  Global *Cursor.GdkCursor
  Macro CURSOR_ARROW : #GDK_ARROW : EndMacro
  Macro CURSOR_BUSY : #GDK_WATCH : EndMacro
  ImportC ""
    gtk_widget_get_window(*widget.GtkWidget)
  EndImport
CompilerEndIf  


Procedure SetCursor(hWnd, CursorId)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    SetClassLong_(hWnd, #GCL_HCURSOR, LoadCursor_(0, CursorId))
  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
    SetThemeCursor(CursorId)
    Debug 888
  CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  	*Cursor= gdk_cursor_new_(CursorID)
	  If *Cursor
		  gdk_window_set_cursor_(gtk_widget_get_window(WindowID(Window)), *Cursor)
	  EndIf
  CompilerEndIf
EndProcedure

;IncludeFile("SetCursor.pbi")

hWnd=OpenWindow(0, 0,0, 400,200, "Change Mouse Cursor", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
ButtonGadget(0, 10, 10, 40, 24, "Arrow")
ButtonGadget(1, 10, 40, 40, 24, "Busy")
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 0
          SetCursor(hWnd, CURSOR_ARROW)
        Case 1
          SetCursor(hWnd, CURSOR_BUSY)
      EndSelect
  EndSelect
ForEver
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP