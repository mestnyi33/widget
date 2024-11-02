EnableExplicit

Procedure CallbackHandler(hWnd, uMsg, wParam, lParam) 
   Static enter.b
   Protected stat.s, sysProc = GetProp_(hWnd, "sysProc")
   
   Select uMsg
      Case #WM_MOUSEFIRST 
         Protected TRACK.TRACKMOUSEEVENT
         TRACK\cbSize = SizeOf(TRACK)
         TRACK\dwFlags = #TME_HOVER|#TME_LEAVE
         TRACK\hwndTrack = hWnd
         TRACK\dwHoverTime = 1
         TrackMouseEvent_(@TRACK)
         
      Case #WM_MOUSEHOVER
         If enter = 0
            enter = 1
            stat = "enter gadget #" + Str(GetDlgCtrlID_(hWnd))
         EndIf
         
      Case #WM_MOUSELEAVE
         enter = 0
         stat = "leave gadget #" + Str(GetDlgCtrlID_(hWnd))
         
      Case #WM_LBUTTONDOWN
         stat = "Left button down on gadget #" + Str(GetDlgCtrlID_(hWnd))
      Case #WM_LBUTTONUP
         stat = "Left button up on gadget #" + Str(GetDlgCtrlID_(hWnd))
      Case #WM_LBUTTONDBLCLK
         stat = "Left button click on gadget #" + Str(GetDlgCtrlID_(hWnd))
      Case #WM_RBUTTONDOWN
         stat = "Right button down on gadget #" + Str(GetDlgCtrlID_(hWnd))
      Case #WM_RBUTTONUP
         stat = "Right button up on gadget #" + Str(GetDlgCtrlID_(hWnd))
      Case #WM_RBUTTONDBLCLK
         stat = "Right button click on gadget #" + Str(GetDlgCtrlID_(hWnd))
   EndSelect
   
   If IsGadget(0) And stat
      AddGadgetItem (0, -1, stat)
      SetGadgetState(0, CountGadgetItems(0) - 1)
   EndIf
   
   ProcedureReturn CallWindowProc_(sysProc, hWnd, uMsg, wParam, lParam)
EndProcedure 

Procedure BindCallBack(hWnd)
   Protected sysProc = SetWindowLongPtr_(hWnd, #GWL_WNDPROC, @CallbackHandler())
   SetProp_(hWnd, "sysProc", sysProc)
EndProcedure

Define i, wFlags.i = #PB_Window_SystemMenu | #PB_Window_ScreenCentered
OpenWindow(0, #PB_Any, #PB_Any, 300, 200, "Binding Gadget Events", wFlags)
ListViewGadget(0, 20, 60, 260, 120)
ButtonGadget(1, 20, 15, 60, 30, "Button")
CheckBoxGadget(2, 110, 15, 80, 30, "CheckBox")
StringGadget(3, 200, 15, 80, 30, "StringGadget")

BindCallBack(WindowID(0))
For i = 0 To 3
   BindCallBack(GadgetID(i))
Next

While WaitWindowEvent() <> #PB_Event_CloseWindow : Wend
; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 64
; FirstLine = 31
; Folding = -
; EnableXP