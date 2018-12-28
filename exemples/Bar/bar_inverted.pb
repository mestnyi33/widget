; Module/File:     Scrollbar_Inverted.pb
; Function:        Inverted ScrollBar direction - Linux gtk2/gtk3
; Author:          Omi
; Date:            Apr. 7, 2018
; Version:         0.1
; Target Compiler: PureBasic 5.22/5.3/5.4/5.5/5.6/5.7
; Target OS:       Linux: (X/K/L)ubuntu, Mint, 32/64, Ascii/Uni
;--------------------------------------------------------------

;IncludePath "../../"
XIncludeFile "ScrollBar().pb"

EnableExplicit

; Object constants
#Win_Main  = 0


Global.i gEvent, gQuit

Procedure ScrollBar_SetInverted(Gadget, Inverted)
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    gtk_range_set_inverted_(GadgetID(Gadget), Inverted)
  CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
    
   ; NSString *scrollDirection = [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.apple.swipescrolldirection"] boolValue]? @"Natural" : @"Normal";
  CompilerEndIf
EndProcedure

Procedure Create_WinMain()
	If OpenWindow(#Win_Main, 0, 0, 400, 200, "Inverted ScrollBar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
		ButtonGadget   (0,    5,   5, 390,  30, "Invert ScrollBar 2", #PB_Button_Toggle)
		ScrollBarGadget(1,   5,  40, 350,  22,  0, 100, 25)
		ScrollBarGadget(2,   5, 70, 350,  20, 20,  50, 8)
		
		ScrollBar::Gadget(3,   5,  100, 350,  22,  0, 100+1, 25)
		ScrollBar::Gadget(4,   5, 140, 350,  20, 20,  50+1, 8);, Bar::#PB_ScrollBar_Inverted)
	EndIf
EndProcedure

Create_WinMain()

Repeat
	gEvent= WaitWindowEvent()
	
	Select gEvent
		Case #PB_Event_CloseWindow
			gQuit= #True
			
		Case #PB_Event_Gadget
			
			Select EventGadget()
					
				Case 0
					ScrollBar_SetInverted(2, GetGadgetState(0))
					ScrollBar::SetAttribute(4, Bar::#PB_ScrollBar_Inverted, GetGadgetState(0))
					Debug "canvas - "+ScrollBar::GetState(4)
					Debug "gadget - "+GetGadgetState(2)
					
				Case 1
					SetWindowTitle(0, Str(GetGadgetState(1)))
					ScrollBar::SetState(3, GetGadgetState(1))
					
				Case 2
					SetWindowTitle(0, Str(GetGadgetState(2)))
					
				Case 3
					SetWindowTitle(0, Str(ScrollBar::GetState(3)))
					
					SetGadgetState(1, ScrollBar::GetState(3))
				
				Case 4
					SetWindowTitle(0, Str(ScrollBar::GetState(4)))
					
			EndSelect
			
	EndSelect
	
Until gQuit
; IDE Options = PureBasic 5.70 LTS beta 2 (Linux - x64)
; CursorPosition = 5
; Folding = -
; EnableXP
; EnableUnicode
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP