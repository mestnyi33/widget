Procedure IsAltPressed()
	ProcedureReturn GetAsyncKeyState_(#VK_MENU)&$8000
EndProcedure

Procedure IsShiftPressed()
	ProcedureReturn GetAsyncKeyState_(#VK_SHIFT)&$8000
EndProcedure

Procedure IsCtrlPressed()
	ProcedureReturn GetAsyncKeyState_(#VK_CONTROL)&$8000
EndProcedure

Procedure IsMiddlePressed()
	ProcedureReturn GetAsyncKeyState_(#VK_MBUTTON)&$8000
EndProcedure

; Procedure IsLeftPressed()
; 	result=GetAsyncKeyState_(#VK_LBUTTON)&$8000
; 	If GetSystemMetrics_(#SM_SWAPBUTTON)
; 		If result
; 			result=#False
; 		Else
; 			result=$8000
; 		EndIf
; 	EndIf
; 	ProcedureReturn result
; EndProcedure
; 
; Procedure IsRightPressed()
; 	result=GetAsyncKeyState_(#VK_RBUTTON)&$8000
; 	If GetSystemMetrics_(#SM_SWAPBUTTON)
; 		If result
; 			result=#False
; 		Else
; 			result=$8000
; 		EndIf
; 	EndIf
; 	ProcedureReturn result
; EndProcedure

Procedure IsLeftPressed()
	If GetSystemMetrics_(#SM_SWAPBUTTON)
		key=#VK_RBUTTON
	Else
		key=#VK_LBUTTON
	EndIf
	ProcedureReturn GetAsyncKeyState_(key)&$8000
EndProcedure

Procedure IsRightPressed()
	If GetSystemMetrics_(#SM_SWAPBUTTON)
		key=#VK_LBUTTON
	Else
		key=#VK_RBUTTON
	EndIf
	ProcedureReturn GetAsyncKeyState_(key)&$8000
EndProcedure



Procedure WindowMouseButton(Wnd, ButtonNr)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ;Linux Version
    
    Protected gdkWnd.l, x.l, y.l, mask.l
    
    If Wnd
      *Window.GTKWindow = Wnd
      gdkWnd = *Window\bin\child\window
      gdk_window_get_pointer_(gdkWnd, @x, @y, @mask)
      
      Select ButtonNr
        Case 0
          If (mask & #GDK_BUTTON1_MASK)
            ProcedureReturn 1
          EndIf
        Case 1
          If (mask & #GDK_BUTTON3_MASK)
            ProcedureReturn 1
          EndIf
        Case 2
          If (mask & #GDK_BUTTON2_MASK)
            ProcedureReturn 1
          EndIf
      EndSelect
    EndIf
    
  CompilerElse
    ;Windows Version
    
    If Wnd And GetForegroundWindow_() = Wnd
      Select ButtonNr
        Case 0
          If GetAsyncKeyState_(#VK_LBUTTON) > 0
            ProcedureReturn 1
          EndIf
        Case 1
          If GetAsyncKeyState_(#VK_RBUTTON) > 0
            ProcedureReturn 1
          EndIf
        Case 2
          If GetAsyncKeyState_(#VK_MBUTTON) > 0
            ProcedureReturn 1
          EndIf
      EndSelect
    EndIf
    
  CompilerEndIf
  
  ProcedureReturn 0
EndProcedure

;-ExampleCode:

OpenWindow(0, 0, 0, 300, 200, "Test", #PB_Window_SystemMenu)

hWnd = WindowID(0)
If hWnd <> 0
  
  
  TextGadget(0, 10, 10, 280, 20, "Status")
  
  Repeat
    Event = WindowEvent()
    
    If WindowMouseButton(hWnd, 0)
      SetGadgetText(0, "Left MouseButton pressed"  )
    ElseIf WindowMouseButton(hWnd, 1)
      SetGadgetText(0, "Right MouseButton pressed" )
    ElseIf WindowMouseButton(hWnd, 2)
      SetGadgetText(0, "Middle MouseButton pressed")
    EndIf
    
    Delay(15)
  Until Event = #PB_Event_CloseWindow
EndIf
End
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 60
; FirstLine = 35
; Folding = ----
; EnableXP