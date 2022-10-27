﻿Procedure WindowCallback(Window, Message, wParam, lParam)
  Select Message
    Case #WM_CLOSE
      ;If MessageBox_(Window, "You sure?", "EXIT", #MB_YESNO) = #IDYES
        DestroyWindow_(Window)
;       Else
;         Result  = 0
;       EndIf
      
    Case #WM_DESTROY
      Debug 889999
      PostQuitMessage_(0)
      Result  = 0
      
    Default
      Result  = DefWindowProc_(Window, Message, wParam, lParam)
  EndSelect
  ProcedureReturn Result
EndProcedure

; 1 example
#Style  = #WS_VISIBLE | #WS_BORDER | #WS_SYSMENU

WindowClass.s  = "MeinFenster"
wc.WNDCLASSEX
wc\cbSize  = SizeOf(WNDCLASSEX)
wc\lpfnWndProc  = @WindowCallback()
wc\hCursor  = LoadCursor_(0, #IDC_ARROW)
wc\hbrBackground  = #COLOR_WINDOW+1
wc\lpszClassName  = @WindowClass
RegisterClassEx_(@wc)

hWndMain  = CreateWindowEx_(0, WindowClass, "Test-Window", #Style, 10, 10, 200, 200, 0, 0, 0, 0)

; ; 2 example
; win = OpenWindow(#PB_Any, 150, 150, 500, 400, "window_0")
; SetWindowCallback( @WindowCallback(), win )
  
While GetMessage_(msg.MSG, #Null, 0, 0 )
  TranslateMessage_(msg) ; - генерирует дополнительное сообщение если произошёл ввод с клавиатуры (клавиша с символом была нажата или отпущена)
  DispatchMessage_(msg) ;  посылает сообщение в функцию WindowProc.
  
  Debug ""+msg\message +" "+ msg\hwnd +" "+ msg\lParam +" "+ msg\wParam
;   If msg\wParam = #WM_QUIT
;     Debug "#WM_QUIT "
;   EndIf
Wend
; IDE Options = PureBasic 5.72 (Windows - x64)
; CursorPosition = 21
; Folding = -
; EnableXP