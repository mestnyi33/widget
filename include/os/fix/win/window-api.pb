; https://www.purebasic.fr/english/viewtopic.php?t=86604
Procedure WindowCallback(hWnd, uMsg, wParam, lParam) 
  Select uMsg 
    Case #WM_CLOSE 
      DestroyWindow_(hWnd) 
    Case #WM_DESTROY 
      PostQuitMessage_(0) 
      Result  = 0 
    Default 
      Result  = DefWindowProc_(hWnd, uMsg, wParam, lParam) 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

#Style  = #WS_VISIBLE | #WS_CAPTION | #WS_SYSMENU 
WindowClass.s  = "WindowClass_227B" 
wc.WNDCLASSEX 
wc\cbSize  = SizeOf(WNDCLASSEX) 
wc\hbrBackground = CreateSolidBrush_(GetSysColor_(#COLOR_BTNFACE))
wc\hCursor = LoadCursor_(0, #IDC_ARROW)
wc\lpfnWndProc  = @WindowCallback() 
wc\lpszClassName  = @WindowClass 
RegisterClassEx_(@wc) 

Define Width.i = 320
Define Height.i = 240

screenx = GetSystemMetrics_(#SM_CXSCREEN)/2-Width/2
screeny = GetSystemMetrics_(#SM_CYSCREEN)/2-Height/2

hWndMain  = CreateWindow_( WindowClass, "win api window", #Style, screenx, screeny, Width, Height, 0, 0, 0, 0) 


While GetMessage_(msg.MSG, #Null, 0, 0 ) 
  TranslateMessage_(msg) 
  DispatchMessage_(msg) 
Wend 
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 34
; Folding = -
; EnableXP