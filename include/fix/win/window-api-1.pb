Procedure WindowCallback(hWnd, uMsg, wParam, lParam) 
  Select uMsg 
    Case #WM_CREATE
      Debug "create"
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

;///1
#Style1  = #WS_VISIBLE | #WS_CAPTION | #WS_SYSMENU 
WindowClass.s  = "WindowClass_1_" 
wc.WNDCLASSEX 
wc\cbSize  = SizeOf(WNDCLASSEX) 
wc\hbrBackground = CreateSolidBrush_(GetSysColor_(#COLOR_BTNFACE))
wc\hCursor = LoadCursor_(0, #IDC_ARROW)
wc\lpfnWndProc  = @WindowCallback() 
wc\lpszClassName  = @WindowClass 
RegisterClassEx_(@wc) 

hWnd1  = CreateWindow_( WindowClass, "Window_1", #Style1, 200, 100, 320+6, 320+32, 0, 0, 0, 0) 
UseGadgetList(hWnd1)
CanvasGadget(0, 240, 10, 60, 60, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
CanvasGadget(1, 10, 10, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
CanvasGadget(11, 110, 110, 200, 200, #PB_Canvas_Keyboard);|#PB_Canvas_DrawFocus)
ButtonGadget(100, 60,240,60,60,"")
g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
g2=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
SplitterGadget(111,10,240,60,60, g1,g2)

;///2
#Style2  = #WS_VISIBLE | #WS_CAPTION | #WS_SYSMENU | #WS_SIZEBOX 
WindowClass.s  = "WindowClass_2_" 
wc.WNDCLASSEX 
wc\cbSize  = SizeOf(WNDCLASSEX) 
wc\hbrBackground = CreateSolidBrush_(GetSysColor_(#COLOR_BTNFACE))
wc\hCursor = LoadCursor_(0, #IDC_ARROW)
wc\lpfnWndProc  = @WindowCallback() 
wc\lpszClassName  = @WindowClass 
RegisterClassEx_(@wc) 

hWnd2  = CreateWindow_( WindowClass, "Window_2", #Style2, 450, 200, 220+8, 220+34, 0, 0, 0, 0) 
UseGadgetList(hWnd2)
g1=StringGadget(-1,0,0,0,0,"StringGadget")
g2=HyperLinkGadget(-1,0,0,0,0,"HyperLinkGadget", 0)
SplitterGadget(2, 10, 10, 200, 200, g1,g2)

;///3
#Style3  = #WS_VISIBLE | #WS_CAPTION | #WS_SYSMENU | #WS_SIZEBOX 
WindowClass.s  = "WindowClass_3_" 
wc.WNDCLASSEX 
wc\cbSize  = SizeOf(WNDCLASSEX) 
wc\hbrBackground = CreateSolidBrush_(GetSysColor_(#COLOR_BTNFACE))
wc\hCursor = LoadCursor_(0, #IDC_ARROW)
wc\lpfnWndProc  = @WindowCallback() 
wc\lpszClassName  = @WindowClass 
RegisterClassEx_(@wc) 

hWnd3  = CreateWindow_( WindowClass, "Window_3", #Style3, 450+50, 200+50, 220+8, 220+34, 0, 0, 0, 0) 
UseGadgetList(hWnd3)
g1=CanvasGadget(-1,0,0,0,0,#PB_Canvas_Keyboard)
g2=StringGadget(-1,0,0,0,0,"StringGadget")
SplitterGadget(3,10, 10, 200, 200, g1,g2)

; Procedure EnumWindowsProc( hwnd,lParam )
;   Debug hwnd
; EndProcedure
; 
; EnumWindows_( @EnumWindowsProc(), 0)

Debug "----"

While GetMessage_(msg.MSG, #Null, 0, 0 ) 
  TranslateMessage_(msg) 
  DispatchMessage_(msg) 
Wend 
; IDE Options = PureBasic 5.72 (Windows - x86)
; CursorPosition = 5
; Folding = -
; EnableXP