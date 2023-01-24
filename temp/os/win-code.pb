; http://hashvb.earlsoft.co.uk/Mouse_Hover_and_Out_Events
Procedure  SubclassWindow( hwnd )
  Protected pOldWndProc.l
  
  pOldWndProc = SetWindowLong_(hwnd, #GWL_WNDPROC, @fnWndProc())
  SetProp_( hwnd, "pOldWndProc", pOldWndProc )
EndProcedure

Procedure  UnSubclassWindow( hwnd )
  SetWindowLong_( hwnd, #GWL_WNDPROC, GetProp_(hwnd, "pOldWndProc")
  RemoveProp_( hwnd, "pOldWndProc" )
EndProcedure

Procedure.l  fnWndProc( hwnd, uMsg, wParam, lParam )
  Select uMsg
    Case #WM_MOUSELEAVE
      SetProp_( hwnd, "bOver", #False )
      ;'-- Mouse Left
      ;'-- Do Something
      
    Case #WM_MOUSEHOVER
      If GetProp_( hwnd, "bOver" ) <> 1
        SetProp_( hwnd, "bOver", 1 )
        ;'-- Mouse Hovering
        ;'-- Do something
      EndIf
      
    Case #WM_MOUSEMOVE
      RequestTracking_( hwnd )
      
  EndSelect
  fnWndProc = CallWindowProc_( GetProp_(hwnd, "pOldWndProc"), hwnd, uMsg, wParam, lParam)
  ProcedureReturn fnWndProc
EndProcedure


; If you want to use in GUI not only latin characters, compile it in Unicode!
; Warning: exe size - it's very, very small!

Declare.l WndProc(hWnd, Msg, wParam, lParam) ; declare Window events callback

; Global vars
WindowClass.s = "WndClass1"

; Initialize Window Class
wc.WNDCLASSEX
wc\cbSize = SizeOf(WNDCLASSEX)
wc\hbrBackground = #COLOR_WINDOW
wc\hCursor = LoadCursor_(0, #IDC_ARROW)
wc\lpfnWndProc = @WndProc()
wc\lpszClassName = @WindowClass

; register Window Class
If RegisterClassEx_(@wc) = 0
  MessageBox_(hWnd, "Can't register main window class.", "", #MB_ICONERROR)
  End
EndIf

; create window
hWnd = CreateWindowEx_(0, WindowClass, "Lorem ipsum", #WS_SYSMENU, 10, 50, 400, 200, 0, 0, 0, 0)
If hWnd = 0
  MessageBox_(hWnd, "Can't create main window.", "", #MB_ICONERROR)
  End
EndIf

; create button and set it's font
hButton1 = CreateWindowEx_(0, "Button", "Button 1", #WS_CHILD | #WS_VISIBLE, 10, 10, 100, 25, hWnd, 0, 0, 0) 
SendMessage_(hButton1, #WM_SETFONT, GetStockObject_(#DEFAULT_GUI_FONT), 1)

; show window
ShowWindow_(hWnd, #SW_SHOWDEFAULT) 
UpdateWindow_(hWndMain)

; messages handling loop
While GetMessage_(msg.MSG, #Null, 0, 0 ) 
  TranslateMessage_(msg) 
  DispatchMessage_(msg) 
Wend

; window events callback
Procedure.l WndProc(hWnd, Msg, wParam, lParam)
  Shared hButton1
  
  Select Msg
    Case #WM_COMMAND
      If hButton1 = lParam
        MessageBox_(hWnd, "Button 1 clicked!", "", #MB_OK)
      EndIf
    Case #WM_CLOSE 
      DestroyWindow_(hWnd) 
    Case #WM_DESTROY 
      PostQuitMessage_(0) : Result  = 0 
    Default 
      Result  = DefWindowProc_(hWnd, Msg, wParam, lParam) 
  EndSelect 
  
  ProcedureReturn Result 
EndProcedure
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = --
; EnableXP